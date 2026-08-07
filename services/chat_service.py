from __future__ import annotations

import json
import logging
import re
from typing import Any

from .document_version_service import document_version_service
from .knowledge_engine import knowledge_engine_service
from .retrieval_service import RetrievalPlan, analyze_question, retrieval_decision_service
from .search_service import search_service

logger = logging.getLogger(__name__)
FAILED_DOCUMENT_MESSAGE = (
    "This document has not been processed successfully and is not available in the Knowledge Base. "
    "Please resolve the processing issue or upload the document again before asking questions."
)
MISSING_INFORMATION_MESSAGE = "The requested information was not found in the selected document."
DGFT_DOCUMENT_HINTS = (
    "dgft",
    "ftp",
    "foreign trade policy",
    "hbp",
    "handbook of procedures",
    "hand book of procedures",
    "chapter",
    "appendix",
    "notification",
    "public notice",
    "trade notice",
)
FAILED_DOCUMENT_STOPWORDS = {
    "pdf",
    "document",
    "documents",
    "file",
    "files",
    "version",
    "final",
    "copy",
    "chapter",
    "dgft",
    "knowledge",
    "source",
    "shared",
}
GROUNDING_STOPWORDS = {
    "about",
    "answer",
    "chapter",
    "document",
    "documents",
    "file",
    "files",
    "information",
    "question",
    "requested",
    "say",
    "section",
    "selected",
    "tell",
    "this",
    "what",
    "which",
}
SHORT_EVIDENCE_TOKENS = {"dgft", "ftp", "hbp", "hsn", "iec", "json", "xml"}

WORKFLOW_PATTERNS = ("workflow", "process", "procedure", "steps", "flow")
DOCUMENT_PATTERNS = ("document", "documents", "paperwork", "attachment", "attachments")
CONDITION_PATTERNS = ("condition", "conditions", "eligibility", "criteria", "requirement", "requirements")
EXCEPTION_PATTERNS = ("exception", "exceptions", "exemption", "exemptions")
RULE_PATTERNS = ("business logic", "business rule", "business rules", "logic", "rule", "rules")
EXAMPLE_PATTERNS = ("example", "examples", "sample", "samples")
REFERENCE_PATTERNS = ("reference", "references", "source", "sources", "cite", "citation", "page", "pages")
SUMMARY_PATTERNS = ("summary", "summarize", "summarise", "brief", "short")
FULL_CONTENT_PATTERNS = (
    "all the information under",
    "complete information under",
    "complete details under",
    "show the entire paragraph",
    "entire paragraph",
    "full paragraph",
    "under the heading",
    "under heading",
    "under the title",
    "show chapter",
    "show section",
    "explain section",
    "show paragraph",
    "show the section",
    "show the chapter",
)
SEMANTIC_QUERY_EXPANSIONS: dict[str, tuple[str, ...]] = {
    "Import Procedure": (
        "import procedure",
        "import workflow",
        "import steps",
        "import documentation",
        "import licensing requirements",
        "import policy customs clearance bill of entry iec",
    ),
    "Export Procedure": (
        "export procedure",
        "export workflow",
        "export steps",
        "export documentation",
        "export licensing requirements",
        "export policy shipping bill customs iec",
    ),
    "Customs": (
        "customs clearance",
        "bill of entry assessment duty import documentation",
        "customs procedure import export",
    ),
    "IEC": (
        "importer exporter code",
        "iec application requirements",
        "iec registration import export",
    ),
    "DGFT Policy": (
        "dgft policy procedure requirements",
        "foreign trade policy handbook of procedures",
        "licensing restrictions compliance documentation",
    ),
}
GENERIC_QUERY_EXPANSIONS: dict[str, tuple[str, ...]] = {
    "import": (
        "import procedure",
        "import workflow",
        "import documentation",
        "iec import customs clearance bill of entry",
    ),
    "export": (
        "export procedure",
        "export workflow",
        "export documentation",
        "iec export shipping bill customs",
    ),
    "process": (
        "workflow steps procedure",
        "documentation requirements compliance steps",
    ),
    "procedure": (
        "workflow steps procedure",
        "documentation requirements compliance steps",
    ),
    "workflow": (
        "workflow steps process",
        "documentation requirements compliance steps",
    ),
    "customs": (
        "customs clearance bill of entry assessment duty",
    ),
    "documentation": (
        "required documents compliance paperwork",
    ),
}


def _clean(value: str, limit: int = 240) -> str:
    normalized = " ".join((value or "").split()).strip()
    return normalized[: limit - 3].rstrip() + "..." if len(normalized) > limit else normalized


def _unique(items: list[str]) -> list[str]:
    return list(dict.fromkeys(item for item in items if item))


def _section_label(section: dict[str, Any]) -> str:
    return f'{section.get("id", "")} {section.get("title", "")}'.strip()


def _chapter_label(section: dict[str, Any]) -> str:
    chapter_number = str(section.get("chapterNumber", "")).strip()
    chapter_title = str(section.get("chapterTitle", "")).strip()
    document_name = str(section.get("documentName", "")).lower()

    if "ftp" in document_name:
        return f"FTP Chapter {chapter_number}" if chapter_number else "FTP"
    if "hbp" in document_name or "hand book" in document_name or "handbook" in document_name:
        return f"HBP Chapter {chapter_number}" if chapter_number else "HBP"
    return f"Chapter {chapter_number} - {chapter_title}" if chapter_number else chapter_title


def _section_reference(section: dict[str, Any]) -> str:
    pages = ", ".join(str(page) for page in section.get("sourcePages", [])[:6]) or "Not available"
    return " | ".join(
        [
            str(section.get("documentName", "")),
            _chapter_label(section),
            _section_label(section),
            f"Pages {pages}",
        ]
    )


def _normalize(value: str) -> str:
    return " ".join((value or "").lower().split())


def _normalize_alnum_words(value: str) -> str:
    return _normalize(re.sub(r"[^A-Za-z0-9]+", " ", str(value or "")))


def _heading_lookup_tokens(value: str) -> list[str]:
    return [
        token
        for token in re.findall(r"\b[a-z0-9][a-z0-9/&._:-]*\b", _normalize(value))
        if token not in {"a", "an", "and", "details", "for", "in", "is", "of", "show", "the", "this", "under", "what"}
    ]


def _looks_like_heading_lookup(question: str) -> bool:
    normalized = _normalize(question)
    if not normalized:
        return False
    if re.search(
        r"\b(?:document|documents|exception|exceptions|process|procedure|rule|rules|step|steps|table|validation|validations|workflow)\b",
        normalized,
    ):
        return False
    return 2 <= len(_heading_lookup_tokens(question)) <= 7


def _split_camel_case(value: str) -> str:
    raw = str(value or "")
    raw = re.sub(r"([A-Z]+)([A-Z][a-z])", r"\1 \2", raw)
    raw = re.sub(r"([a-z0-9])([A-Z])", r"\1 \2", raw)
    return raw


def _document_aliases(value: str) -> list[str]:
    cleaned = str(value or "").strip()
    if not cleaned:
        return []
    stem = re.sub(r"\.[a-z0-9]{1,6}$", "", cleaned, flags=re.IGNORECASE)
    camel_cleaned = _split_camel_case(cleaned)
    camel_stem = _split_camel_case(stem)
    normalized_cleaned = _normalize_alnum_words(cleaned)
    normalized_stem = _normalize_alnum_words(stem)
    normalized_camel_cleaned = _normalize_alnum_words(camel_cleaned)
    normalized_camel_stem = _normalize_alnum_words(camel_stem)
    aliases = [
        _normalize(cleaned.replace("_", " ").replace("-", " ")),
        _normalize(stem.replace("_", " ").replace("-", " ")),
        _normalize(camel_cleaned.replace("_", " ").replace("-", " ")),
        _normalize(camel_stem.replace("_", " ").replace("-", " ")),
        normalized_cleaned,
        normalized_stem,
        normalized_camel_cleaned,
        normalized_camel_stem,
    ]
    aliases.extend(token for token in _document_tokens(normalized_stem) if len(token) >= 3)
    aliases.extend(token for token in _document_tokens(normalized_camel_stem) if len(token) >= 3)

    chapter_match = re.search(r"\bchapter\s*(\d{1,2})\b", normalized_camel_stem or normalized_stem)
    if chapter_match:
        chapter_number = chapter_match.group(1)
        aliases.extend(
            [
                f"chapter {chapter_number}",
                f"hbp chapter {chapter_number}" if "hbp" in normalized_camel_stem or "hbp" in normalized_stem else "",
                f"ftp chapter {chapter_number}" if "ftp" in normalized_camel_stem or "ftp" in normalized_stem else "",
                f"hbp {chapter_number}" if "hbp" in normalized_camel_stem or "hbp" in normalized_stem else "",
                f"ftp {chapter_number}" if "ftp" in normalized_camel_stem or "ftp" in normalized_stem else "",
            ]
        )
    return _unique([alias for alias in aliases if alias])


def _document_tokens(value: str) -> list[str]:
    tokens = [
        token
        for token in re.findall(r"\b[a-z0-9][a-z0-9]{2,}\b", _normalize(value))
        if token not in FAILED_DOCUMENT_STOPWORDS and not token.isdigit()
    ]
    return _unique(tokens)


def _friendly_failure_reason(value: str) -> str:
    message = _normalize(value)
    if not message:
        return "Unexpected Server Error"
    if any(token in message for token in ("document_versions.json", "jobs.json", "settings.json", "users.json", "replace(", "access is denied", "permission denied", "winerror 5")):
        return "Database Save Failed"
    if any(token in message for token in ("password", "encrypted", "decrypt")):
        return "Password Protected PDF"
    if any(token in message for token in ("ocr", "tesseract", "image-only", "image only")):
        return "OCR Failed"
    if any(token in message for token in ("markdown", "html conversion", "conversion failed")):
        return "Markdown Conversion Failed"
    if any(token in message for token in ("embedding", "vector", "similarity")):
        return "Embedding Generation Failed"
    if any(token in message for token in ("index", "knowledge base", "search record", "search index")):
        return "Knowledge Base Indexing Failed"
    if any(token in message for token in ("invalid pdf", "malformed pdf", "corrupt", "cannot open", "failed to read", "pdf syntax", "eof")):
        return "Invalid PDF"
    if "interrupted" in message:
        return "Processing Interrupted"
    return "Unexpected Server Error"


def _contains_any(value: str, patterns: tuple[str, ...]) -> bool:
    return any(pattern in value for pattern in patterns)


def _extract_xml_tag(value: str) -> str:
    match = re.search(r"\b((?:ipt|cac|cbc):[A-Za-z][A-Za-z0-9._-]*)\b", str(value or ""), flags=re.IGNORECASE)
    return match.group(1).strip() if match else ""


def _numbered_lines(items: list[str], limit: int = 5) -> str:
    lines = [f"{index}. {_clean(item, 180)}" for index, item in enumerate(items[:limit], start=1) if item]
    return "\n".join(lines)


def _bullet_lines(items: list[str], limit: int = 8) -> str:
    lines = [f"- {_clean(item, 220)}" for item in items[:limit] if item]
    return "\n".join(lines)


def _preserve_text(value: Any) -> str:
    lines = [str(line).rstrip() for line in str(value or "").replace("\r\n", "\n").split("\n")]
    compact: list[str] = []
    previous_blank = False
    for line in lines:
        if line.strip():
            compact.append(line)
            previous_blank = False
            continue
        if not previous_blank:
            compact.append("")
        previous_blank = True
    return "\n".join(compact).strip()


def _markdown_table(headers: list[str], rows: list[list[str]]) -> str:
    if not rows:
        return ""
    header_row = "| " + " | ".join(headers) + " |"
    divider = "| " + " | ".join("---" for _ in headers) + " |"
    body = "\n".join("| " + " | ".join(_clean(cell, 120) for cell in row) + " |" for row in rows)
    return "\n".join([header_row, divider, body])


def _ensure_sentence(value: str) -> str:
    text = " ".join((value or "").split()).strip()
    if not text:
        return ""
    if text[-1] not in ".!?":
        text += "."
    return text


def _first_sentence(value: Any, limit: int = 240) -> str:
    text = _clean(str(value or ""), limit)
    if not text:
        return ""
    match = re.search(r"(.+?[.?!])(?:\s|$)", text)
    return match.group(1).strip() if match else _ensure_sentence(text)


def _nonempty_lines(value: Any) -> list[str]:
    lines = [str(line).strip() for line in _preserve_text(value).split("\n")]
    return [line for line in lines if line]


def _natural_list(items: list[str], limit: int = 5) -> str:
    cleaned = [str(item).strip().rstrip(".") for item in items[:limit] if str(item).strip()]
    if not cleaned:
        return ""
    if len(cleaned) == 1:
        return cleaned[0]
    if len(cleaned) == 2:
        return f"{cleaned[0]} and {cleaned[1]}"
    return f"{', '.join(cleaned[:-1])}, and {cleaned[-1]}"


class ChatService:
    minimum_confidence = 0.75
    semantic_minimum_confidence = 0.56

    def _ready_documents(self, index: dict[str, Any]) -> list[dict[str, Any]]:
        ready_documents: list[dict[str, Any]] = []
        for document in index.get("documents", []):
            if str(document.get("status", "ready")).strip() != "ready":
                continue
            current_name = str(document.get("name", "")).strip()
            aliases = _document_aliases(current_name)
            tokens = _unique(token for alias in aliases for token in _document_tokens(alias))
            ready_documents.append(
                {
                    "name": current_name,
                    "aliases": aliases,
                    "tokens": tokens,
                    "isDgft": self._is_dgft_document(current_name),
                }
            )
        return ready_documents

    def _is_dgft_document(self, document_name: str) -> bool:
        normalized = _normalize_alnum_words(document_name)
        return any(hint in normalized for hint in DGFT_DOCUMENT_HINTS)

    def get_last_trace(self) -> dict[str, Any]:
        return dict(getattr(self, "_last_trace", {}))

    def _failed_documents(self) -> list[dict[str, Any]]:
        failed_documents: list[dict[str, Any]] = []
        for entry in document_version_service.list_documents():
            if entry.get("archived"):
                continue
            versions = entry.get("versions", [])
            latest_version = versions[-1] if versions else {}
            if str(latest_version.get("status", "")).strip() != "failed":
                continue
            current_name = str(entry.get("currentName", "")).strip()
            aliases = [current_name, *(entry.get("aliases") or [])]
            failure_detail = str(latest_version.get("error", "") or latest_version.get("metadata", {}).get("error", "")).strip()
            normalized_aliases = _unique(
                alias_variant
                for name in aliases
                for alias_variant in _document_aliases(name)
            )
            tokens = _unique(token for alias in normalized_aliases for token in _document_tokens(alias))
            failed_documents.append(
                {
                    "name": current_name,
                    "aliases": normalized_aliases,
                    "tokens": tokens,
                    "failureDetail": failure_detail,
                    "failureReason": _friendly_failure_reason(failure_detail),
                }
            )
        return failed_documents

    def _match_failed_document(self, question: str, failed_documents: list[dict[str, Any]]) -> dict[str, Any] | None:
        normalized_question = _normalize(question)
        question_tokens = set(_document_tokens(normalized_question))
        mentions_document = any(term in normalized_question for term in ("document", "pdf", "file", "upload"))

        for failed_document in failed_documents:
            if any(alias and alias in normalized_question for alias in failed_document.get("aliases", [])):
                return failed_document

            document_tokens = set(failed_document.get("tokens", []))
            if not document_tokens:
                continue

            matched_tokens = document_tokens.intersection(question_tokens)
            minimum_hits = 1 if len(document_tokens) == 1 else 2
            if len(matched_tokens) >= minimum_hits and (mentions_document or len(document_tokens) <= 2):
                return failed_document

        return None

    def _match_ready_document(self, question: str, ready_documents: list[dict[str, Any]]) -> dict[str, Any] | None:
        normalized_question = _normalize(question)
        question_tokens = set(_document_tokens(normalized_question))
        mentions_document = any(term in normalized_question for term in ("document", "pdf", "file", "upload"))
        best_match: dict[str, Any] | None = None
        best_score = 0

        for ready_document in ready_documents:
            aliases = [alias for alias in ready_document.get("aliases", []) if alias]
            alias_hits = [alias for alias in aliases if alias in normalized_question]
            if alias_hits:
                score = 100 + max(len(alias) for alias in alias_hits)
                if score > best_score:
                    best_match = ready_document
                    best_score = score
                continue

            document_tokens = set(ready_document.get("tokens", []))
            if not document_tokens:
                continue

            matched_tokens = document_tokens.intersection(question_tokens)
            if not matched_tokens:
                continue

            longest_token = max((len(token) for token in matched_tokens), default=0)
            minimum_hits = 1 if longest_token >= 6 or len(document_tokens) <= 3 else 2
            if len(matched_tokens) < minimum_hits:
                continue
            if not mentions_document and longest_token < 6:
                continue

            score = (len(matched_tokens) * 10) + longest_token
            if score > best_score:
                best_match = ready_document
                best_score = score

        return best_match

    def _select_best_document(
        self,
        *,
        question: str,
        plan: RetrievalPlan,
        ready_documents: list[dict[str, Any]],
        explicit_document: dict[str, Any] | None,
        current_document: dict[str, Any] | None,
    ) -> tuple[dict[str, Any] | None, dict[str, Any]]:
        normalized_question = _normalize(question)
        document_map = {
            _normalize(str(document.get("name", ""))): {
                **document,
                "score": 0.0,
                "reasons": [],
            }
            for document in ready_documents
            if str(document.get("name", "")).strip()
        }
        if not document_map:
            return None, {"selectionMethod": "none", "rankedDocuments": []}

        if explicit_document:
            normalized_name = _normalize(str(explicit_document.get("name", "")))
            selected = document_map.get(normalized_name)
            if selected:
                selected["score"] = 10000.0
                selected["reasons"].append("explicit_document_mention")
                return selected, {
                    "selectionMethod": "explicit_document",
                    "rankedDocuments": [
                        {
                            "name": str(selected.get("name", "")),
                            "score": round(float(selected.get("score", 0.0)), 4),
                            "reasons": list(selected.get("reasons", [])),
                        }
                    ],
                }

        document_hits = search_service.retrieve(
            question,
            mode="document",
            limit=max(12, min(50, len(document_map))),
        )
        document_debug = search_service.get_last_debug()
        grounding_hits = search_service.retrieve(
            question,
            mode="keyword",
            limit=max(24, min(80, len(document_map) * 6)),
            collection_filters=plan.collection_filters or None,
            chapter_filters=plan.chapter_filters or None,
            section_filters=plan.section_filters or None,
        )
        grounding_debug = search_service.get_last_debug()

        if _looks_like_heading_lookup(question):
            normalized_lookup = _normalize_alnum_words(question)
            exact_title_hits: list[tuple[int, dict[str, Any], bool]] = []
            for rank, hit in enumerate(grounding_hits):
                heading_value = _normalize_alnum_words(str(hit.get("heading", "") or hit.get("title", "")))
                field_values = [
                    _normalize_alnum_words(str(field))
                    for field in hit.get("fieldNames", [])
                    if _normalize_alnum_words(str(field))
                ]
                heading_exact = bool(normalized_lookup and heading_value == normalized_lookup)
                field_exact = bool(normalized_lookup and normalized_lookup in field_values)
                if heading_exact or field_exact:
                    exact_title_hits.append((rank, hit, heading_exact))

            if exact_title_hits:
                exact_title_hits.sort(
                    key=lambda item: (
                        1 if item[2] else 0,
                        float(item[1].get("score", 0.0)),
                        float(item[1].get("confidence", 0.0)),
                        -item[0],
                    ),
                    reverse=True,
                )
                best_rank, best_hit, heading_exact = exact_title_hits[0]
                document_name = str(best_hit.get("documentName", "")).strip()
                normalized_name = _normalize(document_name)
                selected = document_map.get(normalized_name)
                if selected:
                    selected["score"] = 50000.0 + float(best_hit.get("score", 0.0))
                    selected["reasons"] = ["full_title_exact_match" if heading_exact else "full_field_exact_match"]
                    return selected, {
                        "selectionMethod": "full_title_exact_match" if heading_exact else "full_field_exact_match",
                        "groundingResultsCount": len(grounding_hits),
                        "documentSearchDebug": document_debug,
                        "groundingSearchDebug": grounding_debug,
                        "matchedHit": {
                            "documentName": document_name,
                            "sectionId": str(best_hit.get("sectionId", "")),
                            "type": str(best_hit.get("type", "")),
                            "heading": str(best_hit.get("heading", "") or best_hit.get("title", "")),
                            "score": round(float(best_hit.get("score", 0.0)), 4),
                            "confidence": round(float(best_hit.get("confidence", 0.0)), 4),
                            "rank": best_rank + 1,
                        },
                        "rankedDocuments": [
                            {
                                "name": document_name,
                                "score": round(float(selected.get("score", 0.0)), 4),
                                "reasons": list(selected.get("reasons", [])),
                            }
                        ],
                    }

        if _looks_like_heading_lookup(question):
            for rank, hit in enumerate(grounding_hits):
                if not (
                    hit.get("headingExactMatch")
                    or hit.get("fieldExactMatch")
                    or hit.get("exactSectionMatch")
                ):
                    continue
                document_name = str(hit.get("documentName", "")).strip()
                normalized_name = _normalize(document_name)
                if normalized_name not in document_map:
                    continue
                bonus = 1400.0 - min(rank, 20) * 40.0
                if hit.get("headingExactMatch"):
                    bonus += 260.0
                if hit.get("fieldExactMatch"):
                    bonus += 220.0
                if hit.get("exactSectionMatch"):
                    bonus += 180.0
                candidate = document_map[normalized_name]
                candidate["score"] += bonus
                candidate["reasons"].append("exact_heading_lookup")

        for rank, hit in enumerate(document_hits):
            document_name = str(hit.get("documentName", "") or hit.get("title", "")).strip()
            normalized_name = _normalize(document_name)
            if normalized_name not in document_map:
                continue
            weighted_score = (
                float(hit.get("score", 0.0)) * 2.0
                + float(hit.get("confidence", 0.0)) * 180.0
                + max(0, 25 - rank)
            )
            candidate = document_map[normalized_name]
            candidate["score"] += weighted_score
            candidate["reasons"].append(f"document_rank:{rank + 1}")

        for rank, hit in enumerate(grounding_hits):
            document_name = str(hit.get("documentName", "")).strip()
            normalized_name = _normalize(document_name)
            if normalized_name not in document_map:
                continue
            structure_bonus = 0.0
            if hit.get("headingExactMatch"):
                structure_bonus += 180.0
            elif hit.get("headingContainsMatch"):
                structure_bonus += 90.0
            elif float(hit.get("fuzzyHeadingScore", 0.0)) >= 0.84:
                structure_bonus += float(hit.get("fuzzyHeadingScore", 0.0)) * 60.0
            if hit.get("fieldExactMatch"):
                structure_bonus += 160.0
            elif hit.get("fieldContainsMatch"):
                structure_bonus += 80.0
            elif float(hit.get("fuzzyFieldScore", 0.0)) >= 0.86:
                structure_bonus += float(hit.get("fuzzyFieldScore", 0.0)) * 55.0
            if str(hit.get("type", "")).lower() in {"section", "chunk", "rule", "condition", "workflow", "definition"}:
                structure_bonus += 25.0
            weighted_score = (
                float(hit.get("score", 0.0))
                + float(hit.get("confidence", 0.0)) * 120.0
                + structure_bonus
                + max(0, 30 - rank)
            )
            candidate = document_map[normalized_name]
            candidate["score"] += weighted_score
            candidate["reasons"].append(f"grounding_rank:{rank + 1}")

        for candidate in document_map.values():
            aliases = [alias for alias in candidate.get("aliases", []) if alias]
            alias_hits = [alias for alias in aliases if alias in normalized_question]
            if alias_hits:
                candidate["score"] += 500.0 + max(len(alias) for alias in alias_hits)
                candidate["reasons"].append("alias_match")

            if current_document and _normalize(str(current_document.get("name", ""))) == _normalize(str(candidate.get("name", ""))):
                candidate["score"] += 60.0
                candidate["reasons"].append("current_document_bias")

        ranked_documents = sorted(
            document_map.values(),
            key=lambda item: (float(item.get("score", 0.0)), str(item.get("name", ""))),
            reverse=True,
        )
        selected_document = ranked_documents[0] if ranked_documents else None
        return selected_document, {
            "selectionMethod": "dynamic_document_ranking",
            "documentResultsCount": len(document_hits),
            "groundingResultsCount": len(grounding_hits),
            "documentSearchDebug": document_debug,
            "groundingSearchDebug": grounding_debug,
            "rankedDocuments": [
                {
                    "name": str(item.get("name", "")),
                    "score": round(float(item.get("score", 0.0)), 4),
                    "reasons": _unique(list(item.get("reasons", [])))[:8],
                }
                for item in ranked_documents[:8]
            ],
        }

    def _find_ready_document_by_name(self, document_name: str, ready_documents: list[dict[str, Any]]) -> dict[str, Any] | None:
        normalized_target = _normalize(document_name)
        if not normalized_target:
            return None
        return next(
            (
                document
                for document in ready_documents
                if normalized_target == _normalize(str(document.get("name", "")))
                or normalized_target in set(document.get("aliases", []))
            ),
            None,
        )

    def _section_key(self, section_id: Any, document_name: Any) -> str:
        normalized_document_name = _normalize(str(document_name or ""))
        normalized_section_id = str(section_id or "").strip()
        if not normalized_document_name or not normalized_section_id:
            return ""
        return f"{normalized_document_name}::{normalized_section_id}"

    def _record_section_key(self, record: dict[str, Any]) -> str:
        return self._section_key(record.get("sectionId", ""), record.get("documentName", ""))

    def _section_record_key(self, section: dict[str, Any]) -> str:
        return self._section_key(section.get("id", ""), section.get("documentName", ""))

    def _section_lookup(self, sections: list[dict[str, Any]]) -> dict[str, dict[str, Any]]:
        lookup: dict[str, dict[str, Any]] = {}
        for section in sections:
            key = self._section_record_key(section)
            if key:
                lookup[key] = section
        return lookup

    def _retrieval_key(self, item: dict[str, Any]) -> str:
        return "|".join(
            [
                str(item.get("type", "")),
                str(item.get("id", "")),
                str(item.get("sectionId", "")),
                str(item.get("documentName", "")),
            ]
        )

    def _semantic_queries(self, question: str, plan: RetrievalPlan, target_document_name: str = "") -> list[str]:
        normalized = _normalize(question)
        if plan.intent == "Import Procedure":
            queries = [
                question,
                "application for iec",
                "filing of application import export restricted goods",
                "import export authorisation restricted items",
                "procedure for import",
                "warehousing customs bonded warehouse import",
                "date of reckoning of import export",
                "profile of importer exporter",
            ]
            return _unique([query.strip() for query in queries if query and query.strip()])[:8]

        if plan.intent == "Export Procedure":
            queries = [
                question,
                "application for iec",
                "filing of application import export restricted goods",
                "application for grant of export authorisation",
                "export by post documents",
                "date of reckoning of import export",
                "export procedure customs shipping bill",
                "profile of importer exporter",
            ]
            return _unique([query.strip() for query in queries if query and query.strip()])[:8]

        queries = [question]
        queries.extend(SEMANTIC_QUERY_EXPANSIONS.get(plan.intent, ()))
        queries.extend(SEMANTIC_QUERY_EXPANSIONS.get(plan.topic, ()))

        for token, expansions in GENERIC_QUERY_EXPANSIONS.items():
            if token in normalized:
                queries.extend(expansions)
        if plan.likely_chapters:
            queries.extend(str(chapter) for chapter in plan.likely_chapters[:3] if str(chapter).strip())
        if plan.likely_sections:
            queries.extend(str(section) for section in plan.likely_sections[:3] if str(section).strip())

        return _unique([query.strip() for query in queries if query and query.strip()])[:8]

    def _intent_rerank_bonus(self, question: str, plan: RetrievalPlan, item: dict[str, Any]) -> float:
        normalized_question = _normalize(question)
        haystack = _normalize(
            " ".join(
                [
                    str(item.get("title", "")),
                    str(item.get("text", "")),
                    str(item.get("preview", "")),
                    str(item.get("chapterTitle", "")),
                    str(item.get("documentName", "")),
                ]
            )
        )
        item_type = str(item.get("type", "")).lower()
        bonus = 0.0

        if plan.intent in {"Import Procedure", "Export Procedure"} or _contains_any(normalized_question, WORKFLOW_PATTERNS):
            procedural_terms = (
                "procedure",
                "process",
                "workflow",
                "steps",
                "application",
                "filing",
                "documentation",
                "documents",
                "iec",
                "customs",
                "bill of entry",
                "shipping bill",
                "restricted",
                "authorisation",
                "authorization",
                "licence",
                "license",
                "certificate",
                "compliance",
            )
            niche_terms = (
                "metallic waste",
                "scrap",
                "ammunition",
                "gifts",
                "government-to-government",
                "government to government",
                "samples",
                "exhibits",
                "diamonds",
                "jewellery",
                "tariff rate quota",
            )
            bonus += sum(3.0 for term in procedural_terms if term in haystack)
            bonus -= sum(2.5 for term in niche_terms if term in haystack)
            if item_type in {"section", "chunk", "rule", "condition"}:
                bonus += 3.0
            elif item_type in {"definition", "concept", "document"}:
                bonus -= 4.0

        return bonus

    def _merge_retrieval_sets(self, question: str, plan: RetrievalPlan, batches: list[tuple[str, list[dict[str, Any]]]]) -> list[dict[str, Any]]:
        merged: dict[str, dict[str, Any]] = {}
        for query, items in batches:
            for rank, item in enumerate(items):
                key = self._retrieval_key(item)
                existing = merged.get(key, {})
                matched_queries = _unique([*existing.get("matchedQueries", []), query])
                retrieval_channels = _unique([*existing.get("retrievalChannels", []), *item.get("retrievalChannels", [])])
                combined_confidence = max(float(existing.get("confidence", 0.0)), float(item.get("confidence", 0.0)))
                score = max(float(existing.get("score", 0.0)), float(item.get("score", 0.0))) + self._intent_rerank_bonus(question, plan, item)
                combined = {
                    **existing,
                    **item,
                    "matchedQueries": matched_queries,
                    "queryMatches": len(matched_queries),
                    "retrievalChannels": retrieval_channels,
                    "bestRank": min(int(existing.get("bestRank", 999)), rank),
                    "score": round(score + max(0, len(matched_queries) - 1) * 5.0, 4),
                    "confidence": round(min(0.99, combined_confidence + min(0.08, max(0, len(matched_queries) - 1) * 0.02)), 4),
                }
                merged[key] = combined

        results = list(merged.values())
        results.sort(
            key=lambda item: (
                float(item.get("confidence", 0.0)),
                int(item.get("queryMatches", 0)),
                float(item.get("score", 0.0)),
                -int(item.get("bestRank", 999)),
            ),
            reverse=True,
        )
        return results[:30]

    def _aggregate_search_debug(
        self,
        query: str,
        plan: RetrievalPlan,
        queries: list[str],
        debugs: list[dict[str, Any]],
        retrieval: list[dict[str, Any]],
        target_document_name: str = "",
        scope_label: str = "",
    ) -> dict[str, Any]:
        retrieved_document_ids = _unique([str(item.get("documentId", "")).strip() for item in retrieval if str(item.get("documentId", "")).strip()])
        retrieved_document_names = _unique([str(item.get("documentName", "")).strip() for item in retrieval if str(item.get("documentName", "")).strip()])
        return {
            "user_question": query,
            "detected_intent": plan.intent,
            "detected_document": target_document_name or (retrieved_document_names[0] if retrieved_document_names else ""),
            "target_document": target_document_name,
            "scope_label": scope_label,
            "applied_document_filter": _unique(
                [value for debug in debugs for value in debug.get("applied_document_filter", [])]
            ) or ([target_document_name] if target_document_name else []),
            "detected_entities": _unique([entity for debug in debugs for entity in debug.get("detected_entities", [])]),
            "detected_hs_code": _unique([code for debug in debugs for code in debug.get("detected_hs_code", [])]),
            "metadata_results_count": sum(int(debug.get("metadata_results_count", 0)) for debug in debugs),
            "bm25_results_count": sum(int(debug.get("bm25_results_count", 0)) for debug in debugs),
            "vector_results_count": sum(int(debug.get("vector_results_count", 0)) for debug in debugs),
            "merged_results_count": len(retrieval),
            "retrieved_document_ids": retrieved_document_ids,
            "retrieved_document_names": retrieved_document_names,
            "retrieved_chunk_count": len(
                [
                    item
                    for item in retrieval
                    if str(item.get("type", "")).lower() in {"section", "chunk", "rule", "condition", "workflow", "definition"}
                ]
            ),
            "expanded_queries": queries,
            "top_ranked_chunks": [
                {
                    "id": item.get("id", ""),
                    "type": item.get("type", ""),
                    "title": item.get("title", ""),
                    "sectionId": item.get("sectionId", ""),
                    "documentName": item.get("documentName", ""),
                    "heading": item.get("heading", ""),
                    "fieldNames": item.get("fieldNames", []),
                    "sourcePages": item.get("sourcePages", []),
                    "score": item.get("score", 0),
                    "confidence": item.get("confidence", 0),
                    "rankingReasons": item.get("rankingReasons", []),
                    "matchedQueries": item.get("matchedQueries", []),
                }
                for item in retrieval[:10]
            ],
        }

    def _retrieve_grounding(
        self,
        question: str,
        plan: RetrievalPlan,
        *,
        scope_label: str = "",
        target_document_name: str = "",
        document_names: list[str] | None = None,
        collection_filters: frozenset[str] | None = None,
    ) -> tuple[list[dict[str, Any]], dict[str, Any]]:
        queries = self._semantic_queries(question, plan, target_document_name)
        normalized_document_names = frozenset(
            _normalize(name) for name in (document_names or ([target_document_name] if target_document_name else [])) if _normalize(name)
        ) or None
        effective_collection_filters = None if normalized_document_names else collection_filters
        batches: list[tuple[str, list[dict[str, Any]]]] = []
        debugs: list[dict[str, Any]] = []

        for semantic_query in queries[:4]:
            results = search_service.retrieve(
                semantic_query,
                mode="keyword",
                limit=12,
                collection_filters=effective_collection_filters,
                chapter_filters=plan.chapter_filters or None,
                section_filters=plan.section_filters or None,
                document_filters=normalized_document_names,
            )
            batches.append((semantic_query, results))
            debugs.append(search_service.get_last_debug())

        merged = self._merge_retrieval_sets(question, plan, batches)
        section_hits = {str(item.get("sectionId", "")).strip() for item in merged if str(item.get("sectionId", "")).strip()}
        top_confidence = max((float(item.get("confidence", 0.0)) for item in merged), default=0.0)

        if len(section_hits) < 3 or top_confidence < 0.68:
            for semantic_query in queries[1:6]:
                results = search_service.retrieve(
                    semantic_query,
                    mode="keyword",
                    limit=10,
                    collection_filters=effective_collection_filters,
                    chapter_filters=plan.chapter_filters or None,
                    section_filters=plan.section_filters or None,
                    document_filters=normalized_document_names,
                )
                batches.append((semantic_query, results))
                debugs.append(search_service.get_last_debug())
            merged = self._merge_retrieval_sets(question, plan, batches)

        return merged, self._aggregate_search_debug(
            question,
            plan,
            queries,
            debugs,
            merged,
            target_document_name,
            scope_label,
        )

    def _primary_document_name(self, retrieval: list[dict[str, Any]]) -> str:
        for item in retrieval:
            document_name = str(item.get("documentName", "")).strip()
            if document_name:
                return document_name
        return ""

    def _filter_retrieval_by_documents(self, retrieval: list[dict[str, Any]], document_names: list[str]) -> list[dict[str, Any]]:
        normalized_names = {_normalize(name) for name in document_names if _normalize(name)}
        if not normalized_names:
            return retrieval
        return [
            item
            for item in retrieval
            if _normalize(str(item.get("documentName", "")).strip()) in normalized_names
        ]

    def _scope_has_grounding(self, retrieval: list[dict[str, Any]]) -> bool:
        if not retrieval:
            return False
        section_hits = [
            item
            for item in retrieval
            if str(item.get("sectionId", "")).strip()
            and str(item.get("documentName", "")).strip()
            and str(item.get("type", "")).lower() in {"section", "chunk", "rule", "condition", "workflow", "definition"}
        ]
        if not section_hits:
            return False
        top_confidence = max(float(item.get("confidence", 0.0)) for item in section_hits)
        return top_confidence >= self.semantic_minimum_confidence

    def _section_sort_key(self, section: dict[str, Any]) -> tuple[Any, ...]:
        raw_id = str(section.get("id", "")).strip()
        parts = []
        for part in raw_id.split("."):
            parts.append(int(part) if part.isdigit() else part)
        return (*parts, raw_id)

    def _quoted_phrases(self, question: str) -> list[str]:
        phrases = [
            *re.findall(r'"([^"]+)"', question),
            *re.findall(r"'([^']+)'", question),
        ]
        return _unique([phrase.strip() for phrase in phrases if phrase.strip()])

    def _is_full_content_request(self, question: str, plan: RetrievalPlan) -> bool:
        normalized = _normalize(question)
        if _contains_any(normalized, SUMMARY_PATTERNS):
            return False
        if _contains_any(normalized, FULL_CONTENT_PATTERNS):
            return True
        if ("heading" in normalized or "title" in normalized) and _contains_any(normalized, ("show", "all", "complete", "full", "entire", "give")):
            return True
        if ("section" in normalized or "paragraph" in normalized) and (bool(plan.section_filters) or re.search(r"\b\d{1,2}\.\d{1,2}\b", question)):
            return True
        if "chapter" in normalized and bool(plan.chapter_filters) and _contains_any(normalized, ("show", "all", "complete", "full", "entire", "give", "explain")):
            return True
        return False

    def _full_content_sections(
        self,
        question: str,
        plan: RetrievalPlan,
        retrieval: list[dict[str, Any]],
        sections: list[dict[str, Any]],
        allowed_document_names: list[str] | None = None,
    ) -> list[dict[str, Any]]:
        allowed_documents = {_normalize(name) for name in (allowed_document_names or []) if _normalize(name)}
        eligible_sections = [
            section
            for section in sections
            if not allowed_documents or _normalize(str(section.get("documentName", ""))) in allowed_documents
        ]
        section_by_key = self._section_lookup(eligible_sections)
        normalized_question = _normalize(question)

        if plan.chapter_filters and not plan.section_filters and "chapter" in normalized_question:
            return sorted(
                [section for section in eligible_sections if str(section.get("chapterNumber", "")) in plan.chapter_filters],
                key=self._section_sort_key,
            )

        if plan.section_filters:
            matched = [section for section in eligible_sections if str(section.get("id", "")) in plan.section_filters]
            if matched:
                return sorted(matched, key=self._section_sort_key)

        quoted_phrases = self._quoted_phrases(question)
        if quoted_phrases:
            matched_sections = [
                section
                for section in eligible_sections
                if any(
                    _normalize(phrase) in _normalize(
                        " ".join(
                            [
                                str(section.get("title", "")),
                                str(section.get("id", "")),
                                str(section.get("chapterTitle", "")),
                            ]
                        )
                    )
                    for phrase in quoted_phrases
                )
            ]
            if matched_sections:
                return sorted(matched_sections, key=self._section_sort_key)

        matched_keys: list[str] = []
        title_matched_keys: list[str] = []
        top_confidence = max((float(item.get("confidence", 0.0)) for item in retrieval), default=0.0)
        for item in retrieval:
            section_key = self._record_section_key(item)
            if not section_key or section_key not in section_by_key:
                continue
            if section_key in matched_keys:
                continue
            section = section_by_key[section_key]
            title_haystack = _normalize(
                " ".join(
                    [
                        str(section.get("id", "")),
                        str(section.get("title", "")),
                        str(section.get("chapterTitle", "")),
                    ]
                )
            )
            if any(phrase and phrase in title_haystack for phrase in quoted_phrases):
                title_matched_keys.append(section_key)
            confidence = float(item.get("confidence", 0.0))
            if confidence >= max(0.45, top_confidence - 0.18):
                matched_keys.append(section_key)

        selected_keys = _unique([*title_matched_keys, *matched_keys])[:8]
        return [section_by_key[section_key] for section_key in selected_keys if section_key in section_by_key]

    def _render_section_tables(self, section: dict[str, Any]) -> str:
        table_rows = [row for row in section.get("tables", []) if isinstance(row, list) and row]
        if not table_rows:
            return ""

        rendered_rows = []
        for row in table_rows[:16]:
            cells = [str(cell).strip() for cell in row if str(cell).strip()]
            if cells:
                rendered_rows.append("| " + " | ".join(cells) + " |")
        return "\n".join(rendered_rows)

    def _render_full_section(self, section: dict[str, Any]) -> str:
        blocks = [
            f'{section.get("id", "")} {section.get("title", "")}'.strip(),
            "",
            "Complete Content",
            _preserve_text(section.get("rawText", "")) or MISSING_INFORMATION_MESSAGE,
        ]

        rendered_tables = self._render_section_tables(section)
        if rendered_tables:
            blocks.extend(["", "Tables", rendered_tables])

        conditions = [str(item).strip() for item in section.get("conditions", []) if str(item).strip()]
        if conditions:
            blocks.extend(["", "Conditions", _numbered_lines(conditions, limit=20)])

        notes = [str(item).strip() for item in section.get("notes", []) if str(item).strip()]
        if notes:
            blocks.extend(["", "Notes", _bullet_lines(notes, limit=20)])

        blocks.extend(
            [
                "",
                "Source",
                f'- Document Name: {section.get("documentName", "")}',
                f'- Section: {_section_label(section)}',
                f'- Page Numbers: {", ".join(str(page) for page in section.get("sourcePages", [])) or "Not available"}',
            ]
        )
        return "\n".join(block for block in blocks if block is not None).strip()

    def _section_narrative(self, section: dict[str, Any]) -> str:
        summary = (
            _first_sentence(section.get("summary", ""), 240)
            or _first_sentence(section.get("businessMeaning", ""), 220)
            or _first_sentence(section.get("businessExplanation", ""), 240)
            or _first_sentence(section.get("rawText", ""), 260)
        )
        label = _section_label(section)
        if summary and label:
            return f"In section {label}, {summary.rstrip('.')}."
        if summary:
            return _ensure_sentence(summary)
        if label:
            return f"I found relevant content in section {label}, but the selected document does not contain a concise summary for it."
        return "I found relevant content in the selected document, but it does not include a concise extract for this topic."

    def _full_content_response(self, question: str, plan: RetrievalPlan, answer_sections: list[dict[str, Any]], chapters: list[dict[str, Any]]) -> str:
        normalized_question = _normalize(question)
        if plan.chapter_filters and "chapter" in normalized_question and not plan.section_filters:
            chapter_number = next(iter(plan.chapter_filters), "")
            chapter = next((item for item in chapters if str(item.get("chapter_number", "")) == chapter_number), None)
            chapter_summary = ""
            if chapter:
                chapter_summary = _ensure_sentence(_clean(str(chapter.get("summary_en", "")), 320))
            section_summaries = [self._section_narrative(section) for section in sorted(answer_sections, key=self._section_sort_key)[:4]]
            return "\n\n".join(part for part in [chapter_summary, *section_summaries] if part).strip()

        return "\n\n".join(
            self._section_narrative(section) for section in sorted(answer_sections, key=self._section_sort_key)[:4]
        ).strip()

    def _empty_answer(
        self,
        question: str,
        plan: RetrievalPlan,
        confidence_score: float = 0.0,
        direct_answer: str = MISSING_INFORMATION_MESSAGE,
        business_explanation: str = "",
        ai_model: str = "",
        language: str = "English",
    ) -> dict[str, Any]:
        return {
            "question": question,
            "questionUnderstood": plan.question_understood,
            "title": "No matching knowledge found",
            "sectionId": "",
            "chapterNumber": "",
            "detectedIntent": plan.user_intent,
            "detectedTopic": plan.topic,
            "knowledgeSourcesUsed": list(plan.knowledge_sources),
            "confidenceScore": round(confidence_score, 2),
            "relevantChapters": list(plan.likely_chapters),
            "relevantSections": list(plan.likely_sections),
            "directAnswer": direct_answer,
            "businessExplanation": business_explanation,
            "businessLogic": [],
            "workflow": [],
            "conditions": [],
            "exceptions": [],
            "requiredDocuments": [],
            "importantNotes": [],
            "businessRules": [],
            "realExample": "",
            "relatedChapters": [],
            "relatedSections": [],
            "sourcePdfs": [],
            "referencedPdf": "",
            "sourcePages": [],
            "sourceChapter": "",
            "sourceSection": "",
            "modelUsed": ai_model,
            "languageUsed": language,
        }

    def _log_retrieval(
        self,
        *,
        question: str,
        plan: RetrievalPlan,
        retrieval: list[dict[str, Any]],
        confidence_score: float,
        selected_chunks: list[dict[str, Any]],
        decision: str,
        debug: dict[str, Any] | None = None,
        final_prompt: str = "",
        llm_response: str = "",
        final_context_documents: list[str] | None = None,
    ) -> None:
        payload = {
            "question": question,
            "detected_intent": plan.user_intent,
            "detected_topic": plan.topic,
            "knowledge_source": list(plan.knowledge_sources),
            "detected_document": debug.get("detected_document", "") if debug else "",
            "selected_scope": debug.get("scope_label", "") if debug else "",
            "selected_document_id": next((document_id for document_id in (debug.get("retrieved_document_ids", []) if debug else []) if document_id), ""),
            "metadata_filter": {
                "document": debug.get("applied_document_filter", []) if debug else [],
                "collection": sorted(plan.collection_filters),
                "chapter": sorted(plan.chapter_filters),
                "section": sorted(plan.section_filters),
            },
            "applied_document_filter": debug.get("applied_document_filter", []) if debug else [],
            "retrieved_documents": _unique([str(item.get("documentName", "")) for item in retrieval]),
            "retrieved_document_ids": debug.get("retrieved_document_ids", []) if debug else [],
            "retrieved_chunk_count": debug.get("retrieved_chunk_count", 0) if debug else 0,
            "similarity_score": round(confidence_score, 4),
            "selected_chunks": [str(chunk.get("id", "")) for chunk in selected_chunks],
            "reason_for_selection": decision,
            "user_question": debug.get("user_question", question) if debug else question,
            "detected_entities": debug.get("detected_entities", []) if debug else [],
            "detected_hs_code": debug.get("detected_hs_code", []) if debug else [],
            "metadata_results_count": debug.get("metadata_results_count", 0) if debug else 0,
            "bm25_results_count": debug.get("bm25_results_count", 0) if debug else 0,
            "vector_results_count": debug.get("vector_results_count", 0) if debug else 0,
            "merged_results_count": debug.get("merged_results_count", len(retrieval)) if debug else len(retrieval),
            "top_ranked_chunks": debug.get("top_ranked_chunks", []) if debug else [],
            "selected_chunk": [str(chunk.get("id", "")) for chunk in selected_chunks[:1]],
            "final_context_documents": _unique(final_context_documents or []),
            "final_source_document": (
                next((str(chunk.get("documentName", "")).strip() for chunk in selected_chunks if str(chunk.get("documentName", "")).strip()), "")
                or next((str(item.get("documentName", "")).strip() for item in retrieval if str(item.get("documentName", "")).strip()), "")
            ),
            "generated_answer_source": {
                "documents": _unique(final_context_documents or []),
                "chunkIds": [str(chunk.get("id", "")) for chunk in selected_chunks[:10]],
            },
            "final_prompt": final_prompt,
            "llm_response": llm_response,
        }
        self._last_trace = payload
        logger.info("dekai_retrieval %s", json.dumps(payload, ensure_ascii=False))

    def _pick_sections(self, retrieval: list[dict[str, Any]], sections: list[dict[str, Any]], plan: RetrievalPlan) -> tuple[list[dict[str, Any]], float]:
        ranked_section_hits = [
            item
            for item in retrieval
            if item.get("sectionId") and str(item.get("type", "")).lower() in {"section", "chunk", "rule", "condition", "workflow"}
        ]
        if not ranked_section_hits:
            return [], 0.0

        section_by_key = self._section_lookup(sections)
        top_confidence = max(float(item.get("confidence", 0.0)) for item in ranked_section_hits)
        scored_sections: dict[str, dict[str, Any]] = {}

        for item in ranked_section_hits:
            section_key = self._record_section_key(item)
            if not section_key or section_key not in section_by_key:
                continue
            section = section_by_key[section_key]
            current = scored_sections.setdefault(
                section_key,
                {
                    "section": section,
                    "confidence": 0.0,
                    "score": 0.0,
                    "queryMatches": 0,
                    "documentName": str(section.get("documentName", "")),
                },
            )
            current["confidence"] = max(float(current["confidence"]), float(item.get("confidence", 0.0)))
            current["score"] += float(item.get("score", 0.0))
            current["queryMatches"] = max(int(current["queryMatches"]), int(item.get("queryMatches", 0)))

        if top_confidence < self.semantic_minimum_confidence:
            return [], top_confidence

        ranked_sections = sorted(
            scored_sections.values(),
            key=lambda item: (float(item["confidence"]), int(item["queryMatches"]), float(item["score"])),
            reverse=True,
        )

        threshold = max(self.semantic_minimum_confidence, top_confidence - 0.18)
        max_sections = 6 if plan.intent in {"Import Procedure", "Export Procedure", "Customs", "DGFT Policy", "General Question"} else 4
        chosen_sections: list[dict[str, Any]] = []
        chosen_documents: dict[str, int] = {}

        for item in ranked_sections:
            section = item["section"]
            section_id = str(section.get("id", ""))
            confidence = float(item["confidence"])
            document_name = str(item["documentName"])
            section_haystack = _normalize(
                " ".join(
                    [
                        str(section.get("title", "")),
                        str(section.get("summary", "")),
                        str(section.get("businessMeaning", "")),
                        str(section.get("businessExplanation", "")),
                    ]
                )
            )
            if plan.intent == "Import Procedure" and not any(
                term in section_haystack
                for term in ("import", "iec", "importer", "customs", "bill of entry", "restricted", "warehouse")
            ):
                continue
            if plan.intent == "Export Procedure" and not any(
                term in section_haystack
                for term in ("export", "iec", "exporter", "customs", "shipping bill", "restricted")
            ):
                continue
            if confidence < threshold and section_id not in plan.section_filters:
                continue
            if chosen_documents.get(document_name, 0) >= 2 and len(chosen_sections) < max_sections - 1:
                continue
            chosen_sections.append(section)
            chosen_documents[document_name] = chosen_documents.get(document_name, 0) + 1
            if len(chosen_sections) >= max_sections:
                break

        if not chosen_sections and ranked_sections:
            chosen_sections = [item["section"] for item in ranked_sections[: min(3, len(ranked_sections))]]

        return chosen_sections, top_confidence

    def _has_grounded_evidence(
        self,
        question: str,
        retrieval: list[dict[str, Any]],
        answer_sections: list[dict[str, Any]],
    ) -> bool:
        normalized_question = _normalize(question)
        if not retrieval or not answer_sections:
            return False

        strong_ranking_reasons = {
            "exact_hs_code_match",
            "exact_section_match",
            "exact_chapter_match",
            "exact_heading_match",
            "exact_field_match",
            "heading_contains_match",
            "field_contains_match",
        }
        if any(
            strong_ranking_reasons.intersection(set(item.get("rankingReasons", [])))
            for item in retrieval[:8]
        ):
            return True

        analysis = analyze_question(question)
        evidence_terms = _unique(
            [
                *[code.lower() for code in analysis.hs_codes if str(code).strip()],
                *[section.lower() for section in analysis.section_numbers if str(section).strip()],
                *[chapter.lower() for chapter in analysis.chapter_numbers if str(chapter).strip()],
                *[
                    keyword.lower()
                    for keyword in analysis.keywords
                    if (
                        keyword.lower() not in GROUNDING_STOPWORDS
                        and (len(keyword) >= 4 or keyword.lower() in SHORT_EVIDENCE_TOKENS)
                    )
                ],
            ]
        )

        haystacks = [
            _normalize(
                " ".join(
                    [
                        str(item.get("title", "")),
                        str(item.get("heading", "")),
                        str(item.get("text", "")),
                        str(item.get("preview", "")),
                        " ".join(str(field) for field in item.get("fieldNames", [])),
                    ]
                )
            )
            for item in retrieval[:10]
        ]
        haystacks.extend(
            _normalize(
                " ".join(
                    [
                        str(section.get("id", "")),
                        str(section.get("title", "")),
                        str(section.get("summary", "")),
                        str(section.get("businessMeaning", "")),
                        str(section.get("businessExplanation", "")),
                        str(section.get("rawText", "")),
                    ]
                )
            )
            for section in answer_sections[:4]
        )

        if "xml" in normalized_question:
            return any(
                re.search(r"<\s*/?\s*([A-Za-z_][\w:.-]*)", str(section.get("rawText", "")))
                for section in answer_sections
            )
        if "json" in normalized_question:
            return any(
                re.search(r'"([^"]+)"\s*:', str(section.get("rawText", "")))
                for section in answer_sections
            )
        if "table" in normalized_question:
            return any(section.get("tables", []) for section in answer_sections)

        if not evidence_terms:
            top_confidence = max((float(item.get("confidence", 0.0)) for item in retrieval), default=0.0)
            return top_confidence >= 0.82

        return any(
            term and any(term in haystack for haystack in haystacks)
            for term in evidence_terms
        )

    def _section_chunks(self, retrieval: list[dict[str, Any]], chunks: list[dict[str, Any]], section_keys: set[str]) -> list[dict[str, Any]]:
        selected: list[dict[str, Any]] = []
        seen_ids: set[str] = set()
        for item in retrieval:
            if item.get("type") != "chunk" or self._record_section_key(item) not in section_keys:
                continue
            item_id = str(item.get("id", ""))
            if item_id in seen_ids:
                continue
            seen_ids.add(item_id)
            selected.append(item)
            if len(selected) >= 6:
                break
        if selected:
            return selected
        return [chunk for chunk in chunks if self._record_section_key(chunk) in section_keys][:6]

    def _fallback_sections(
        self,
        retrieval: list[dict[str, Any]],
        sections: list[dict[str, Any]],
        plan: RetrievalPlan,
        allowed_document_names: list[str] | None = None,
    ) -> list[dict[str, Any]]:
        allowed_documents = {_normalize(name) for name in (allowed_document_names or []) if _normalize(name)}
        eligible_sections = [
            section
            for section in sections
            if not allowed_documents or _normalize(str(section.get("documentName", ""))) in allowed_documents
        ]
        section_by_key = self._section_lookup(eligible_sections)
        selected_keys: list[str] = []

        if plan.chapter_filters:
            for section in eligible_sections:
                section_key = self._section_record_key(section)
                if str(section.get("chapterNumber", "")) in plan.chapter_filters and section_key not in selected_keys:
                    selected_keys.append(section_key)
                if len(selected_keys) >= 3:
                    break

        for item in retrieval:
            section_key = self._record_section_key(item)
            if not section_key or section_key in selected_keys or section_key not in section_by_key:
                continue
            selected_keys.append(section_key)
            if len(selected_keys) >= 3:
                break

        return [section_by_key[section_key] for section_key in selected_keys if section_key in section_by_key][:5]

    def _chapter_overview(self, question: str, plan: RetrievalPlan, chapters: list[dict[str, Any]], primary_section: dict[str, Any] | None = None) -> str:
        if "chapter" in _normalize(question) and plan.chapter_filters and not plan.section_filters:
            target = next((chapter for chapter in chapters if str(chapter.get("chapter_number", "")) in plan.chapter_filters), None)
            if target:
                summary = _clean(str(target.get("summary_en", "")), 320)
                chapter_number = str(target.get("chapter_number", "")).strip()
                title = str(target.get("chapter_title", "")).strip()
                section_count = int(target.get("section_count", 0))
                parts = [summary] if summary else []
                if section_count:
                    parts.append(f"{'HBP' if 'hbp' in ' '.join(plan.knowledge_sources).lower() else 'Chapter'} {chapter_number} covers {title} and includes {section_count} sections in the uploaded knowledge base.")
                return " ".join(part for part in parts[:2] if part)
        return ""

    def _exact_hs_answer(self, question: str, selected_chunks: list[dict[str, Any]]) -> str:
        codes = re.findall(r"\b\d{6,10}\b", re.sub(r"\D", " ", question))
        if not codes:
            return ""
        normalized_codes = {code.strip() for code in codes if code.strip()}
        for chunk in selected_chunks:
            chunk_codes = {str(code).strip() for code in chunk.get("hsCodes", []) if str(code).strip()}
            if not chunk_codes.intersection(normalized_codes):
                continue
            description = str(chunk.get("description", "")).strip()
            matched_code = next(iter(chunk_codes.intersection(normalized_codes)), next(iter(chunk_codes), ""))
            if matched_code and description:
                return f"HS Code {matched_code} refers to {description}."
        return ""

    def _best_heading_chunk(self, question: str, selected_chunks: list[dict[str, Any]]) -> dict[str, Any] | None:
        normalized_question = _normalize(question)
        question_terms = {
            token
            for token in re.findall(r"\b[a-z0-9][a-z0-9/&._-]{1,}\b", normalized_question)
            if token not in {"what", "is", "the", "a", "an", "of", "in", "for", "this", "that", "section", "details"}
        }
        best_chunk: dict[str, Any] | None = None
        best_score = 0

        for chunk in selected_chunks:
            heading = str(chunk.get("heading", "") or chunk.get("title", "")).strip()
            if not heading:
                continue
            normalized_heading = _normalize(heading)
            heading_terms = {
                token
                for token in re.findall(r"\b[a-z0-9][a-z0-9/&._-]{1,}\b", normalized_heading)
                if token not in {"the", "a", "an", "of", "in", "for", "this", "that"}
            }
            if not heading_terms:
                continue

            score = 0
            if normalized_heading and normalized_heading in normalized_question:
                score += 100
            if heading_terms and heading_terms.issubset(question_terms.union({"section", "details"})):
                score += 60
            score += len(heading_terms.intersection(question_terms)) * 12
            if str(chunk.get("fieldNames", "")):
                score += 5

            if score > best_score:
                best_score = score
                best_chunk = chunk

        return best_chunk if best_score >= 12 else None

    def _heading_answer(self, question: str, selected_chunks: list[dict[str, Any]]) -> str:
        heading_chunk = self._best_heading_chunk(question, selected_chunks)
        if not heading_chunk:
            return ""

        normalized_question = _normalize(question)
        heading = str(heading_chunk.get("heading", "") or heading_chunk.get("title", "")).strip()
        block_text = " ".join(str(heading_chunk.get("text", "")).split()).strip()
        if block_text and len(block_text) > max(24, len(heading) + 12):
            if any(phrase in normalized_question for phrase in ("details", "under", "what is", "show", "explain", "meaning")):
                return _ensure_sentence(block_text)
        field_names = [str(field).strip() for field in heading_chunk.get("fieldNames", []) if str(field).strip()]
        heading_label = heading.title() if heading.isupper() else heading
        blocks = [f"{heading_label} is a block in the uploaded declaration message."]
        if field_names:
            blocks.append(
                f"It contains fields such as {_natural_list(field_names, limit=8)}."
            )
        blocks.append(
            "The extracted content shows that this block carries message-level information used to identify and process the declaration."
        )
        return " ".join(blocks)

    def _xml_tag_answer(self, question: str, selected_chunks: list[dict[str, Any]]) -> str:
        xml_tag = _extract_xml_tag(question)
        if not xml_tag:
            return ""

        normalized_tag = _normalize(xml_tag)
        best_chunk: dict[str, Any] | None = None
        best_score = -1

        for chunk in selected_chunks:
            heading = _normalize(str(chunk.get("heading", "")).strip())
            field_names = [_normalize(str(field).strip()) for field in chunk.get("fieldNames", []) if str(field).strip()]
            text = _normalize(str(chunk.get("text", "")).strip())

            score = 0
            if heading == normalized_tag:
                score += 100
            elif normalized_tag and normalized_tag in heading:
                score += 70
            if normalized_tag in field_names:
                score += 50
            elif any(normalized_tag in field for field in field_names):
                score += 30
            if normalized_tag and normalized_tag in text:
                score += 20
            if score > best_score:
                best_chunk = chunk
                best_score = score

        if not best_chunk or best_score <= 0:
            return ""

        best_text = " ".join(str(best_chunk.get("text", "")).split()).strip()
        if best_text:
            return _ensure_sentence(best_text)
        heading = str(best_chunk.get("heading", "")).strip()
        return _ensure_sentence(heading)

    def _best_field_chunk(self, question: str, selected_chunks: list[dict[str, Any]]) -> tuple[dict[str, Any] | None, str]:
        normalized_question = _normalize(question)
        question_terms = {
            token
            for token in re.findall(r"\b[a-z0-9][a-z0-9/&._:-]{1,}\b", normalized_question)
            if token not in {"what", "is", "the", "a", "an", "of", "in", "for", "this", "that", "field", "value", "show", "give", "explain"}
        }
        best_chunk: dict[str, Any] | None = None
        best_field = ""
        best_score = 0

        for chunk in selected_chunks:
            field_names = [str(field).strip() for field in chunk.get("fieldNames", []) if str(field).strip()]
            if not field_names:
                continue
            for field_name in field_names:
                normalized_field = _normalize(field_name)
                field_terms = {
                    token
                    for token in re.findall(r"\b[a-z0-9][a-z0-9/&._:-]{1,}\b", normalized_field)
                    if token not in {"cbc", "cac", "ipt", "field"}
                }
                if not field_terms:
                    continue

                score = 0
                if normalized_field and normalized_field in normalized_question:
                    score += 100
                score += len(field_terms.intersection(question_terms)) * 14
                if field_terms and field_terms.issubset(question_terms.union({"type", "details", "section"})):
                    score += 35
                if str(chunk.get("heading", "")).strip():
                    score += 5
                if score > best_score:
                    best_score = score
                    best_chunk = chunk
                    best_field = field_name

        return (best_chunk, best_field) if best_score >= 16 else (None, "")

    def _field_answer(self, question: str, selected_chunks: list[dict[str, Any]]) -> str:
        field_chunk, field_name = self._best_field_chunk(question, selected_chunks)
        if not field_chunk or not field_name:
            return ""

        heading = str(field_chunk.get("heading", "") or field_chunk.get("title", "")).strip()
        heading_label = heading.title() if heading.isupper() else heading
        matched_line = next(
            (
                " ".join(line.split())
                for line in str(field_chunk.get("text", "")).replace("\r\n", "\n").split("\n")
                if _normalize(field_name) in _normalize(line)
            ),
            "",
        )
        blocks = [f"{field_name} appears in the selected document"]
        if heading_label:
            blocks[0] += f" under {heading_label}."
        else:
            blocks[0] += "."
        if matched_line:
            blocks.append(f"The extracted content lists it as: {_clean(matched_line, 220)}.")
        else:
            blocks.append("It is part of the structured fields captured from the selected PDF.")
        return " ".join(blocks)

    def _document_identity_answer_payload(
        self,
        question: str,
        sections: list[dict[str, Any]],
        allowed_document_names: list[str] | None = None,
    ) -> dict[str, Any] | None:
        normalized_question = _normalize(question)
        if not _contains_any(normalized_question, ("what is", "what are", "define", "meaning of", "about")):
            return None

        allowed_documents = [_normalize(name) for name in (allowed_document_names or []) if _normalize(name)]
        if not allowed_documents:
            return None

        question_tokens = set(_document_tokens(normalized_question))
        matched_document_name = ""
        matched_label = ""

        for document_name in allowed_document_names or []:
            aliases = _document_aliases(document_name)
            alias_hit = next(
                (
                    alias
                    for alias in aliases
                    if len(alias) >= 4 and alias in normalized_question and not any(token in alias for token in ("chapter", "pdf"))
                ),
                "",
            )
            token_hit = next(
                (
                    token
                    for token in _document_tokens(document_name)
                    if len(token) >= 4 and token in question_tokens
                ),
                "",
            )
            if alias_hit or token_hit:
                matched_document_name = document_name
                matched_label = token_hit.upper() if token_hit else alias_hit.upper()
                break

        if not matched_document_name:
            return None

        candidate_sections = [
            section
            for section in sections
            if _normalize(str(section.get("documentName", ""))) == _normalize(matched_document_name)
        ]
        if not candidate_sections:
            return None

        def rank(section: dict[str, Any]) -> tuple[int, int]:
            title = _normalize(str(section.get("title", "")))
            priority = 99
            if "introduction" in title:
                priority = 1
            elif "message function" in title:
                priority = 2
            elif "message definition" in title:
                priority = 3
            elif "definition" in title:
                priority = 4
            elif "scope" in title:
                priority = 5
            return priority, len(str(section.get("summary", "")))

        candidate_sections.sort(key=rank)
        section = candidate_sections[0]
        summary = ""
        for section_candidate in candidate_sections[:6]:
            candidate_summary = _clean(
                section_candidate.get("summary", "")
                or section_candidate.get("businessMeaning", "")
                or section_candidate.get("businessExplanation", "")
                or section_candidate.get("rawText", ""),
                320,
            )
            title = str(section_candidate.get("title", "")).strip()
            if title and candidate_summary.startswith(title):
                candidate_summary = candidate_summary[len(title) :].strip(" .:-")
            candidate_summary = re.sub(r"^\d+(?:\.\d+)*\s+", "", candidate_summary).strip()
            normalized_summary = _normalize(candidate_summary)
            if not candidate_summary or re.fullmatch(r"[\d.\s]+", normalized_summary or "") or len(normalized_summary) < 12:
                continue
            section = section_candidate
            summary = candidate_summary
            break
        if not summary:
            return None

        answer = f"{matched_label or str(section.get('title', '')).strip()} is described in the selected document as {summary}"
        return {
            "documentName": matched_document_name,
            "section": section,
            "answer": _ensure_sentence(answer),
            "sourcePages": [int(page) for page in section.get("sourcePages", []) if str(page).isdigit()],
        }

    def _iec_definition_answer(self, question: str, sections: list[dict[str, Any]], allowed_document_names: list[str] | None = None) -> str:
        normalized_question = _normalize(question)
        if "iec" not in normalized_question:
            return ""
        if not _contains_any(normalized_question, ("full form", "stands for", "meaning of iec", "what is iec")):
            return ""

        allowed_documents = {_normalize(name) for name in (allowed_document_names or []) if _normalize(name)}

        answer_parts = ["IEC stands for Importer Exporter Code."]

        one_pan_section = next(
            (
                section
                for section in sections
                if str(section.get("id", "")).strip() == "2.12"
                and (not allowed_documents or _normalize(str(section.get("documentName", ""))) in allowed_documents)
            ),
            None,
        )
        one_pan_summary = _first_sentence((one_pan_section or {}).get("summary", ""), 220)
        if one_pan_summary:
            answer_parts.append(f"According to the selected document, {one_pan_summary.rstrip('.')}.")

        return " ".join(part for part in answer_parts if part).strip()

    def _definition_query_term(self, question: str) -> str:
        patterns = (
            r"\bwhat does\s+([a-z0-9/&._-]{2,})\s+stand for\b",
            r"\bfull form of\s+([a-z0-9/&._-]{2,})\b",
            r"\bmeaning of\s+([a-z0-9/&._-]{2,})\b",
        )
        normalized_question = _normalize(question)
        for pattern in patterns:
            match = re.search(pattern, normalized_question, flags=re.IGNORECASE)
            if match:
                return match.group(1).strip().upper()
        return ""

    def _extract_definition_phrase(self, term: str, *texts: Any) -> str:
        if not term:
            return ""
        for text in texts:
            raw_text = " ".join(str(text or "").replace("\r\n", "\n").split())
            if not raw_text.strip():
                continue
            match = re.search(rf"\b{re.escape(term)}\b", raw_text, flags=re.IGNORECASE)
            if not match:
                continue
            suffix = raw_text[match.end() :].strip(" :.-")
            tokens = suffix.split()
            collected: list[str] = []
            for token in tokens:
                cleaned = token.strip(".,;:()[]{}")
                if not cleaned:
                    continue
                if collected and re.fullmatch(r"[A-Z0-9/&.-]{2,}", cleaned):
                    break
                if collected and re.fullmatch(r"\d+(?:\.\d+)?", cleaned):
                    break
                collected.append(cleaned)
                if len(collected) >= 8:
                    break

            definition = " ".join(collected).strip(" .,:;-")
            if definition:
                return definition
        return ""

    def _definition_answer_payload(
        self,
        question: str,
        sections: list[dict[str, Any]],
        definitions: list[dict[str, Any]],
        retrieval: list[dict[str, Any]],
        *,
        target_document_name: str = "",
    ) -> dict[str, Any] | None:
        term = self._definition_query_term(question)
        if not term:
            return None

        target_document_normalized = _normalize(target_document_name)
        section_by_key = self._section_lookup(sections)
        matching_definitions = [
            definition
            for definition in definitions
            if _normalize(str(definition.get("term", ""))) == _normalize(term)
            and (
                not target_document_normalized
                or _normalize(str(definition.get("documentName", ""))) == target_document_normalized
            )
        ]
        if not matching_definitions:
            return None

        for definition in matching_definitions:
            definition_section_key = self._section_key(definition.get("sectionId", ""), definition.get("documentName", ""))
            section = section_by_key.get(definition_section_key, {})
            retrieval_texts = [
                item.get("text", "")
                for item in retrieval
                if self._record_section_key(item) == definition_section_key
            ]
            expanded = self._extract_definition_phrase(
                term,
                definition.get("definition", ""),
                section.get("summary", ""),
                section.get("purpose", ""),
                *retrieval_texts,
            )
            if not expanded:
                continue

            return {
                "term": term,
                "definition": expanded,
                "section": section,
                "documentName": str(definition.get("documentName", "") or section.get("documentName", "")).strip(),
                "sourcePages": definition.get("sourcePages", []) or section.get("sourcePages", []),
            }

        return None

    def _source_reference_lines(self, answer_sections: list[dict[str, Any]], limit: int = 5) -> list[str]:
        references: list[str] = []
        seen: set[str] = set()
        for section in answer_sections:
            reference = _section_reference(section)
            if not reference or reference in seen:
                continue
            seen.add(reference)
            references.append(f"- {reference}")
            if len(references) >= limit:
                break
        return references

    def _source_block(
        self,
        *,
        document_name: str,
        chapter: str,
        section: str,
        source_pages: list[str] | list[int],
    ) -> str:
        page_number = ", ".join(str(page) for page in source_pages if str(page).strip()) or "Not available"
        return "\n".join(
            [
                "Source:",
                f"- Document Name: {document_name or 'Not available'}",
                f"- Chapter: {chapter or 'Not available'}",
                f"- Section: {section or 'Not available'}",
                f"- Page Number: {page_number}",
            ]
        )

    def _bulletize_text(self, value: Any, limit: int = 8) -> list[str]:
        bullets: list[str] = []
        seen: set[str] = set()
        for line in _nonempty_lines(value):
            cleaned = line.lstrip("-*• \t").strip()
            if len(cleaned) < 3:
                continue
            lowered = cleaned.casefold()
            if lowered in seen:
                continue
            seen.add(lowered)
            bullets.append(cleaned)
            if len(bullets) >= limit:
                break
        return bullets

    def _chunk_bullets(self, selected_chunks: list[dict[str, Any]], limit: int = 8) -> list[str]:
        bullets: list[str] = []
        seen: set[str] = set()
        for chunk in selected_chunks:
            text = str(chunk.get("text", "")).strip()
            if not text:
                continue
            for bullet in self._bulletize_text(text, limit=limit):
                lowered = bullet.casefold()
                if lowered in seen:
                    continue
                seen.add(lowered)
                bullets.append(bullet)
                if len(bullets) >= limit:
                    return bullets
        return bullets

    def _focused_chunk_answer(self, question: str, selected_chunks: list[dict[str, Any]]) -> str:
        normalized_question = _normalize(question)
        question_terms = {
            token
            for token in re.findall(r"\b[a-z0-9][a-z0-9/&._:-]{1,}\b", normalized_question)
            if token not in {
                "a",
                "an",
                "and",
                "authorisation",
                "authorizations",
                "authorisation?",
                "authorization",
                "details",
                "does",
                "for",
                "give",
                "how",
                "is",
                "of",
                "policy",
                "show",
                "tell",
                "the",
                "this",
                "what",
            }
        }
        if not selected_chunks or not question_terms:
            return ""

        prefers_tabular_answer = any(token in normalized_question for token in ("table", "list", "rows", "columns", "xml", "json", "hs code", "hscode", "hsn"))
        best_text = ""
        best_score = 0.0

        for chunk in selected_chunks:
            candidate_texts = [
                str(field).strip()
                for field in chunk.get("fieldNames", [])
                if str(field).strip() and len(_normalize(str(field))) >= 12
            ]
            candidate_texts.extend(
                [
                    str(chunk.get("description", "")).strip(),
                    str(chunk.get("text", "")).strip(),
                ]
            )

            for candidate_text in candidate_texts:
                if not candidate_text:
                    continue
                normalized_candidate = _normalize(candidate_text)
                overlap = len([term for term in question_terms if term in normalized_candidate])
                if overlap <= 0:
                    continue

                score = float(overlap * 20)
                if "valid" in normalized_question and "valid" in normalized_candidate:
                    score += 14.0
                if "gaict" in normalized_question and "gaict" in normalized_candidate:
                    score += 18.0
                if "period" in normalized_question and "period" in normalized_candidate:
                    score += 6.0
                if any(phrase in normalized_candidate for phrase in ("shall be valid", "valid for a period", "whichever is earlier")):
                    score += 8.0
                if candidate_text == str(chunk.get("text", "")).strip():
                    score += 3.0
                if not bool(chunk.get("isTableRow")):
                    score += 10.0
                elif not prefers_tabular_answer:
                    score -= 6.0
                if re.match(r"^\d+\s*:\s*\d+", candidate_text):
                    score -= 5.0
                if candidate_text.count(";") >= 4:
                    score -= 4.0

                if score > best_score:
                    best_score = score
                    best_text = candidate_text

        if best_score <= 0 or not best_text:
            return ""

        cleaned = " ".join(best_text.split()).strip(" .;:-")
        if not cleaned:
            return ""
        return _ensure_sentence(cleaned)

    def _render_bullets(self, items: list[str], *, limit: int = 8, clean_limit: int = 420) -> str:
        return "\n".join(f"- {_clean(item, clean_limit)}" for item in items[:limit] if str(item).strip())

    def _answer_body(
        self,
        *,
        question: str,
        selected_chunks: list[dict[str, Any]],
        answer_sections: list[dict[str, Any]],
        workflow_steps: list[str],
        condition_items: list[str],
        exception_items: list[str],
        business_logic: list[str],
        required_documents: list[str],
    ) -> str:
        normalized_question = _normalize(question)
        xml_tag_answer = self._xml_tag_answer(question, selected_chunks)
        if xml_tag_answer:
            return xml_tag_answer
        question_targets_documents = _contains_any(normalized_question, DOCUMENT_PATTERNS)
        question_targets_workflow = _contains_any(normalized_question, WORKFLOW_PATTERNS)
        question_targets_conditions = _contains_any(normalized_question, CONDITION_PATTERNS)
        question_targets_exceptions = _contains_any(normalized_question, EXCEPTION_PATTERNS)
        question_targets_rules = _contains_any(normalized_question, RULE_PATTERNS)
        question_targets_list = any(
            phrase in normalized_question for phrase in ("category", "categories", "list", "include", "which are", "what are")
        )

        if question_targets_list and condition_items:
            return self._render_bullets(condition_items, limit=8, clean_limit=420)
        if question_targets_documents and required_documents:
            return self._render_bullets(required_documents, limit=8, clean_limit=420)
        if question_targets_workflow and workflow_steps:
            return _numbered_lines(workflow_steps, limit=8)
        if question_targets_conditions and condition_items:
            return self._render_bullets(condition_items, limit=8, clean_limit=420)
        if question_targets_exceptions and exception_items:
            return self._render_bullets(exception_items, limit=8, clean_limit=420)
        if question_targets_rules and business_logic:
            return self._render_bullets(business_logic, limit=8, clean_limit=420)

        focused_chunk_answer = self._focused_chunk_answer(question, selected_chunks)
        if focused_chunk_answer:
            return focused_chunk_answer

        table_chunks = [chunk for chunk in selected_chunks if bool(chunk.get("isTableRow"))]
        table_bullets = self._chunk_bullets(table_chunks, limit=10)
        if table_bullets:
            return self._render_bullets(table_bullets, limit=10, clean_limit=420)

        chunk_bullets = self._chunk_bullets(selected_chunks, limit=8)
        if chunk_bullets:
            return self._render_bullets(chunk_bullets, limit=8, clean_limit=420)

        for section in answer_sections:
            raw_bullets = self._bulletize_text(section.get("rawText", ""), limit=8)
            if raw_bullets:
                return self._render_bullets(raw_bullets, limit=8, clean_limit=420)

        return MISSING_INFORMATION_MESSAGE

    def _grounded_answer_text(
        self,
        *,
        question: str,
        answer_sections: list[dict[str, Any]],
        selected_chunks: list[dict[str, Any]],
        workflow_steps: list[str],
        condition_items: list[str],
        exception_items: list[str],
        business_logic: list[str],
        required_documents: list[str],
        source_payload: dict[str, Any],
    ) -> str:
        body = self._answer_body(
            question=question,
            selected_chunks=selected_chunks,
            answer_sections=answer_sections,
            workflow_steps=workflow_steps,
            condition_items=condition_items,
            exception_items=exception_items,
            business_logic=business_logic,
            required_documents=required_documents,
        )
        if body == MISSING_INFORMATION_MESSAGE:
            return body
        return "\n\n".join(
            [
                body,
                self._source_block(
                    document_name=str(source_payload.get("referencedPdf", "")),
                    chapter=str(source_payload.get("sourceChapter", "")),
                    section=str(source_payload.get("sourceSection", "")),
                    source_pages=source_payload.get("sourcePages", []),
                ),
            ]
        )

    def _general_answer(
        self,
        question: str,
        plan: RetrievalPlan,
        primary_section: dict[str, Any],
        selected_chunks: list[dict[str, Any]],
        chapters: list[dict[str, Any]],
        answer_sections: list[dict[str, Any]] | None = None,
        workflow_steps: list[str] | None = None,
        condition_items: list[str] | None = None,
        required_documents: list[str] | None = None,
    ) -> str:
        answer_sections = answer_sections or [primary_section]
        workflow_steps = workflow_steps or []
        condition_items = condition_items or []
        required_documents = required_documents or []
        chapter_overview = self._chapter_overview(question, plan, chapters, primary_section)
        if chapter_overview:
            return _ensure_sentence(chapter_overview)

        exact_hs_answer = self._exact_hs_answer(question, selected_chunks)
        if exact_hs_answer:
            return exact_hs_answer

        heading_answer = self._heading_answer(question, selected_chunks)
        if heading_answer:
            return heading_answer

        field_answer = self._field_answer(question, selected_chunks)
        if field_answer:
            return field_answer

        normalized_question = _normalize(question)
        summary_points = _unique(
            [
                *[_first_sentence(section.get("summary", ""), 260) for section in answer_sections if section.get("summary")],
                *[_first_sentence(section.get("businessMeaning", ""), 220) for section in answer_sections if section.get("businessMeaning")],
                *[_first_sentence(section.get("businessExplanation", ""), 240) for section in answer_sections if section.get("businessExplanation")],
                *[_first_sentence(chunk.get("text", ""), 240) for chunk in selected_chunks if chunk.get("text")],
            ]
        )
        if not any(summary_points):
            return "I found related content in the selected document, but there is not enough extracted text to produce a grounded answer."

        references = self._source_reference_lines(answer_sections)
        blocks: list[str] = []
        if _contains_any(normalized_question, WORKFLOW_PATTERNS) or plan.intent in {"Import Procedure", "Export Procedure"}:
            blocks.append(
                "Based on the selected document, this topic is explained across multiple sections rather than one exact heading."
            )
            blocks.append("Relevant guidance from the selected document:\n" + _bullet_lines(summary_points, limit=4))
            if workflow_steps:
                blocks.append("Combined workflow:\n" + _numbered_lines(workflow_steps, limit=8))
            if condition_items:
                blocks.append("Key requirements and checks:\n" + _bullet_lines(condition_items, limit=6))
            if required_documents:
                blocks.append("Related documents mentioned in the selected document:\n" + _bullet_lines(required_documents, limit=6))
        else:
            blocks.append("Based on the selected document:\n" + _bullet_lines(summary_points, limit=4))
            if condition_items:
                blocks.append("Key requirements:\n" + _bullet_lines(condition_items, limit=6))

        if references:
            blocks.append("Sources:\n" + "\n".join(references))
        return "\n\n".join(block for block in blocks if block)

    def _source_payload(
        self,
        answer_sections: list[dict[str, Any]],
        relevant_chapters: list[str],
        relevant_sections: list[str],
        source_pdfs: list[str],
        source_pages: list[str],
        selected_chunks: list[dict[str, Any]] | None = None,
    ) -> dict[str, Any]:
        primary_section = answer_sections[0] if answer_sections else {}
        selected_chunks = selected_chunks or []
        source_heading = next(
            (
                str(chunk.get("heading", "")).strip()
                for chunk in selected_chunks
                if str(chunk.get("heading", "")).strip()
            ),
            "",
        )
        return {
            "sourcePdfs": source_pdfs,
            "referencedPdf": source_pdfs[0] if source_pdfs else str(primary_section.get("documentName", "")),
            "sourcePages": [int(page) for page in source_pages if str(page).isdigit()],
            "sourceChapter": relevant_chapters[0] if relevant_chapters else "",
            "sourceSection": relevant_sections[0] if relevant_sections else "",
            "sourceHeading": source_heading,
        }

    def _extract_structured_response(
        self,
        question: str,
        answer_sections: list[dict[str, Any]],
        selected_chunks: list[dict[str, Any]],
        workflow_steps: list[str],
        condition_items: list[str],
        exception_items: list[str],
        business_logic: list[str],
        required_documents: list[str],
    ) -> str:
        normalized_question = _normalize(question)
        if "table" in normalized_question:
            rendered_tables: list[str] = []
            for section in answer_sections:
                tables = [table for table in section.get("tables", []) if isinstance(table, list) and table]
                for index, table in enumerate(tables[:5], start=1):
                    row_summaries = []
                    for row in table[:3]:
                        cells = [str(cell).strip() for cell in row if str(cell).strip()]
                        if cells:
                            row_summaries.append(", ".join(cells))
                    if not row_summaries:
                        continue
                    rendered_tables.append(
                        f"In section {_section_label(section)}, table {index} includes { '; '.join(row_summaries[:3]) }."
                    )
            return "\n\n".join(rendered_tables) if rendered_tables else MISSING_INFORMATION_MESSAGE

        if "xml" in normalized_question:
            xml_tags = sorted(
                {
                    match
                    for section in answer_sections
                    for match in re.findall(r"<\s*/?\s*([A-Za-z_][\w:.-]*)", str(section.get("rawText", "")))
                }
            )
            return (
                f"I found these XML tags in the selected document: {_natural_list(xml_tags, limit=8)}."
                if xml_tags
                else MISSING_INFORMATION_MESSAGE
            )

        if "json" in normalized_question:
            json_keys = sorted(
                {
                    match
                    for section in answer_sections
                    for match in re.findall(r'"([^"]+)"\s*:', str(section.get("rawText", "")))
                }
            )
            return (
                f"I found these JSON keys in the selected document: {_natural_list(json_keys, limit=8)}."
                if json_keys
                else MISSING_INFORMATION_MESSAGE
            )

        if "validation" in normalized_question:
            validations = _unique(
                [
                    *[_clean(validation, 220) for section in answer_sections for validation in section.get("validations", [])],
                    *condition_items,
                ]
            )
            return (
                f"The selected document mainly requires the following validations: {_natural_list(validations, limit=6)}."
                if validations
                else MISSING_INFORMATION_MESSAGE
            )

        if "error code" in normalized_question or "error codes" in normalized_question:
            error_lines = _unique(
                [
                    sentence
                    for section in answer_sections
                    for sentence in re.findall(r"[^.!\n]*(?:error|code)[^.!\n]*", str(section.get("rawText", "")), flags=re.IGNORECASE)
                ]
            )
            return (
                f"I found these error-related references in the selected document: {_natural_list(error_lines, limit=5)}."
                if error_lines
                else MISSING_INFORMATION_MESSAGE
            )

        if "hs code" in normalized_question or "hscode" in normalized_question or "hsn" in normalized_question:
            matches: list[str] = []
            for section in answer_sections:
                text = str(section.get("rawText", ""))
                for match in re.finditer(r"\b\d{4,10}\b", text):
                    snippet = _clean(text[max(0, match.start() - 60) : min(len(text), match.end() + 80)], 180)
                    matches.append(f"{match.group(0)}: {snippet}")
            unique_matches: list[str] = []
            seen_matches: set[str] = set()
            for item in matches:
                if item in seen_matches:
                    continue
                seen_matches.add(item)
                unique_matches.append(item)
            return (
                f"I found these HS code references in the selected document: {_natural_list(unique_matches, limit=5)}."
                if unique_matches
                else MISSING_INFORMATION_MESSAGE
            )

        if any(term in normalized_question for term in ("document", "documents")):
            return (
                f"According to the selected document, the required documents include {_natural_list(required_documents, limit=6)}."
                if required_documents
                else "The selected document does not clearly list the required documents for this topic."
            )

        if "workflow" in normalized_question:
            return (
                f"The process described in the selected document is: {_natural_list(workflow_steps, limit=6)}."
                if workflow_steps
                else MISSING_INFORMATION_MESSAGE
            )

        if "condition" in normalized_question or "criteria" in normalized_question or "eligibility" in normalized_question:
            return (
                f"The main conditions mentioned in the selected document are {_natural_list(condition_items, limit=6)}."
                if condition_items
                else MISSING_INFORMATION_MESSAGE
            )

        if "exception" in normalized_question or "exemption" in normalized_question:
            return (
                f"The selected document mentions these exceptions or exemptions: {_natural_list(exception_items, limit=6)}."
                if exception_items
                else MISSING_INFORMATION_MESSAGE
            )

        if "rule" in normalized_question or "logic" in normalized_question:
            return (
                f"The main rules described in the selected document are {_natural_list(business_logic, limit=6)}."
                if business_logic
                else MISSING_INFORMATION_MESSAGE
            )

        section_summaries = [self._section_narrative(section) for section in answer_sections[:3]]
        return "\n\n".join(section_summaries) if section_summaries else MISSING_INFORMATION_MESSAGE

    def _search_response(self, retrieval: list[dict[str, Any]]) -> str:
        matches = []
        for item in retrieval[:3]:
            title = str(item.get("title", "")).strip()
            preview = _clean(str(item.get("preview", "") or item.get("text", "")), 180)
            if title and preview:
                matches.append(f"{title}: {preview}")
            elif preview:
                matches.append(preview)
            elif title:
                matches.append(title)
        return (
            f"The most relevant matches in the selected document are {_natural_list(matches, limit=3)}."
            if matches
            else MISSING_INFORMATION_MESSAGE
        )

    def _comparison_response(self, answer_sections: list[dict[str, Any]]) -> str:
        if len(answer_sections) < 2:
            return MISSING_INFORMATION_MESSAGE
        comparisons = []
        for section in answer_sections[:3]:
            comparisons.append(self._section_narrative(section))
        return "\n\n".join(comparisons)

    def _summary_response(self, question: str, plan: RetrievalPlan, answer_sections: list[dict[str, Any]], selected_chunks: list[dict[str, Any]], chapters: list[dict[str, Any]]) -> str:
        primary_section = answer_sections[0]
        chapter_overview = self._chapter_overview(question, plan, chapters, primary_section)
        if chapter_overview:
            return _ensure_sentence(chapter_overview)
        summaries = _unique(
            [
                *[_clean(str(section.get("summary", "")), 220) for section in answer_sections],
                *[_clean(str(section.get("businessMeaning", "")), 180) for section in answer_sections],
            ]
        )
        if not any(summaries) and selected_chunks:
            summaries = [_clean(str(selected_chunks[0].get("text", "")), 220)]
        return " ".join(_ensure_sentence(summary) for summary in summaries[:3] if summary) if any(summaries) else MISSING_INFORMATION_MESSAGE

    def _detail_answer(
        self,
        question: str,
        plan: RetrievalPlan,
        primary_section: dict[str, Any],
        answer_sections: list[dict[str, Any]],
        selected_chunks: list[dict[str, Any]],
        chapters: list[dict[str, Any]],
        business_logic: list[str],
        workflow_steps: list[str],
        condition_items: list[str],
        exception_items: list[str],
        required_documents: list[str],
        section_examples: list[dict[str, Any]],
        source_pdfs: list[str],
        source_pages: list[str],
        relevant_chapters: list[str],
        relevant_sections: list[str],
    ) -> tuple[str, bool]:
        normalized_question = _normalize(question)
        response_blocks: list[str] = []
        explicit_detail_request = False
        broad_process_question = plan.intent in {"Import Procedure", "Export Procedure"} and not _contains_any(
            normalized_question,
            DOCUMENT_PATTERNS + CONDITION_PATTERNS + EXCEPTION_PATTERNS + RULE_PATTERNS + EXAMPLE_PATTERNS + REFERENCE_PATTERNS,
        )

        if _contains_any(normalized_question, DOCUMENT_PATTERNS):
            explicit_detail_request = True
            response_blocks.append(
                f"According to the selected document, the required documents include {_natural_list(required_documents, limit=6)}."
                if required_documents
                else "The selected document does not explicitly list the required documents for this topic."
            )

        if _contains_any(normalized_question, WORKFLOW_PATTERNS) and not broad_process_question:
            explicit_detail_request = True
            response_blocks.append(
                f"The process described in the selected document is {_natural_list(workflow_steps, limit=6)}."
                if workflow_steps
                else "No explicit workflow was extracted for this topic in the selected document."
            )

        if _contains_any(normalized_question, CONDITION_PATTERNS):
            explicit_detail_request = True
            response_blocks.append(
                f"The main conditions mentioned are {_natural_list(condition_items, limit=6)}."
                if condition_items
                else "The selected document does not explicitly list conditions for this topic."
            )

        if _contains_any(normalized_question, EXCEPTION_PATTERNS):
            explicit_detail_request = True
            response_blocks.append(
                f"The selected document mentions these exceptions or exemptions: {_natural_list(exception_items, limit=6)}."
                if exception_items
                else "The selected document does not explicitly list exceptions for this topic."
            )

        if _contains_any(normalized_question, RULE_PATTERNS):
            explicit_detail_request = True
            response_blocks.append(
                f"The main rule logic described is {_natural_list(business_logic, limit=6)}."
                if business_logic
                else "No explicit business logic was extracted for this topic."
            )

        if _contains_any(normalized_question, EXAMPLE_PATTERNS):
            explicit_detail_request = True
            example_text = next((str(example.get("text", "")).strip() for example in section_examples if example.get("text")), "")
            response_blocks.append(
                _ensure_sentence(example_text) if example_text else "No explicit example was extracted for this topic in the selected document."
            )

        if _contains_any(normalized_question, REFERENCE_PATTERNS):
            explicit_detail_request = True
            reference_lines = self._source_reference_lines(answer_sections)
            if reference_lines:
                response_blocks.append("Sources:\n" + "\n".join(reference_lines))
            elif relevant_sections:
                source_summary = f"This answer is based on section {relevant_sections[0]}"
                if source_pdfs:
                    source_summary += f" in {source_pdfs[0]}"
                response_blocks.append(_ensure_sentence(source_summary))
            elif source_pdfs:
                response_blocks.append(f"This answer is based on the selected PDF {source_pdfs[0]}.")

        if response_blocks:
            return "\n\n".join(block for block in response_blocks if block), explicit_detail_request

        return self._general_answer(
            question,
            plan,
            primary_section,
            selected_chunks,
            chapters,
            answer_sections=answer_sections,
            workflow_steps=workflow_steps,
            condition_items=condition_items,
            required_documents=required_documents,
        ), explicit_detail_request

    def _intent_response(
        self,
        *,
        question: str,
        plan: RetrievalPlan,
        retrieval: list[dict[str, Any]],
        answer_sections: list[dict[str, Any]],
        selected_chunks: list[dict[str, Any]],
        chapters: list[dict[str, Any]],
        workflow_steps: list[str],
        condition_items: list[str],
        exception_items: list[str],
        business_logic: list[str],
        required_documents: list[str],
        section_examples: list[dict[str, Any]],
        source_pdfs: list[str],
        source_pages: list[str],
        relevant_chapters: list[str],
        relevant_sections: list[str],
    ) -> tuple[str, dict[str, Any]]:
        source_payload = self._source_payload(
            answer_sections=answer_sections,
            relevant_chapters=relevant_chapters,
            relevant_sections=relevant_sections,
            source_pdfs=source_pdfs,
            source_pages=source_pages,
            selected_chunks=selected_chunks,
        )
        normalized_question = _normalize(question)
        if plan.user_intent in {"Table Extraction", "XML Extraction", "JSON Extraction"} or any(
            token in normalized_question for token in ("table", "xml", "json", "validation", "error code", "error codes", "hs code", "hscode", "hsn")
        ):
            structured = self._extract_structured_response(
                question,
                answer_sections,
                selected_chunks,
                workflow_steps,
                condition_items,
                exception_items,
                business_logic,
                required_documents,
            )
            if structured != MISSING_INFORMATION_MESSAGE:
                return (
                    "\n\n".join(
                        [
                            structured,
                            self._source_block(
                                document_name=str(source_payload.get("referencedPdf", "")),
                                chapter=str(source_payload.get("sourceChapter", "")),
                                section=str(source_payload.get("sourceSection", "")),
                                source_pages=source_payload.get("sourcePages", []),
                            ),
                        ]
                    ),
                    source_payload,
                )
            return structured, source_payload
        return (
            self._grounded_answer_text(
                question=question,
                answer_sections=answer_sections,
                selected_chunks=selected_chunks,
                workflow_steps=workflow_steps,
                condition_items=condition_items,
                exception_items=exception_items,
                business_logic=business_logic,
                required_documents=required_documents,
                source_payload=source_payload,
            ),
            source_payload,
        )

    def build_answer(self, question: str, ai_model: str = "", language: str = "English") -> dict[str, Any]:
        index = knowledge_engine_service.load_index()
        ready_documents = self._ready_documents(index)
        failed_documents = self._failed_documents()
        failed_document_match = self._match_failed_document(question, failed_documents)
        plan = retrieval_decision_service.detect_intent(question)
        target_ready_document = self._match_ready_document(question, ready_documents)
        ready_document_count = len([document for document in index.get("documents", []) if str(document.get("status", "ready")) == "ready"])

        if failed_document_match or (failed_documents and ready_document_count == 0):
            blocked_document = failed_document_match or failed_documents[0]
            direct_answer = FAILED_DOCUMENT_MESSAGE
            business_explanation = f'{blocked_document.get("name", "This document")} failed during processing: {blocked_document.get("failureReason", "Unexpected Server Error")}.'
            if blocked_document.get("failureDetail"):
                business_explanation = f'{business_explanation} Details: {blocked_document["failureDetail"]}'
            answer = self._empty_answer(
                question,
                plan,
                direct_answer=direct_answer,
                business_explanation=business_explanation,
                ai_model=ai_model,
                language=language,
            )
            answer["title"] = blocked_document.get("name", "Processing failed")
            answer["sourcePdfs"] = [blocked_document.get("name", "")]
            answer["referencedPdf"] = blocked_document.get("name", "")
            self._log_retrieval(
                question=question,
                plan=plan,
                retrieval=[],
                confidence_score=0.0,
                selected_chunks=[],
                decision="Blocked answer because the question targeted a failed document or no document is currently Knowledge Ready.",
                final_prompt=f"Question: {question}\nBlocked document: {blocked_document.get('name', '')}",
                llm_response=direct_answer,
                final_context_documents=[str(blocked_document.get("name", "")).strip()],
            )
            return answer

        if plan.needs_clarification:
            answer = self._empty_answer(
                question,
                plan,
                direct_answer=plan.clarification_message,
                business_explanation="If the relevant HS Master is available, DEKAI will search only the selected document after you provide product-specific details.",
                ai_model=ai_model,
                language=language,
            )
            self._log_retrieval(
                question=question,
                plan=plan,
                retrieval=[],
                confidence_score=0.0,
                selected_chunks=[],
                decision="HS code intent detected without product description or existing code. Asked for clarification instead of searching unrelated sources.",
                final_context_documents=[],
            )
            return answer

        current_ready_document = None
        allowed_document_names: list[str] = []
        retrieval: list[dict[str, Any]] = []
        search_debug: dict[str, Any] = {}
        selected_scope_label = "selected_document"

        current_document_name = getattr(self, "_current_document_name", "")
        if current_document_name:
            current_ready_document = self._find_ready_document_by_name(current_document_name, ready_documents)

        selected_document, document_selection_debug = self._select_best_document(
            question=question,
            plan=plan,
            ready_documents=ready_documents,
            explicit_document=target_ready_document,
            current_document=current_ready_document,
        )
        if selected_document:
            selected_document_name = str(selected_document.get("name", "")).strip()
            allowed_document_names = [selected_document_name] if selected_document_name else []
            retrieval, search_debug = self._retrieve_grounding(
                question,
                plan,
                scope_label=selected_scope_label,
                target_document_name=selected_document_name,
                document_names=allowed_document_names,
                collection_filters=None,
            )
        else:
            search_debug = {}

        if search_debug is not None:
            search_debug["scope_label"] = selected_scope_label
            search_debug["document_selection"] = document_selection_debug
            if selected_document and str(selected_document.get("name", "")).strip():
                search_debug["selected_document"] = str(selected_document.get("name", "")).strip()

        chapters = index.get("chapters", [])
        sections = index.get("sections", [])
        definitions = index.get("definitions", [])
        rules = index.get("rules", [])
        conditions = index.get("conditions", [])
        workflows = index.get("workflows", [])
        chunks = index.get("chunks", [])
        examples = index.get("examples", [])
        iec_definition_answer = self._iec_definition_answer(question, sections, allowed_document_names)
        definition_answer_payload = self._definition_answer_payload(
            question,
            sections,
            definitions,
            retrieval,
            target_document_name=allowed_document_names[0] if allowed_document_names else "",
        )
        document_identity_payload = self._document_identity_answer_payload(question, sections, allowed_document_names)

        if definition_answer_payload:
            section = definition_answer_payload.get("section", {}) or {}
            answer = self._empty_answer(
                question,
                plan,
                confidence_score=0.96,
                direct_answer="",
                business_explanation=f'Answered from the selected document {definition_answer_payload["documentName"]}.',
                ai_model=ai_model,
                language=language,
            )
            answer["title"] = str(section.get("title", "") or definition_answer_payload["term"])
            answer["sectionId"] = str(section.get("id", ""))
            answer["chapterNumber"] = str(section.get("chapterNumber", ""))
            answer["sourcePdfs"] = [definition_answer_payload["documentName"]] if definition_answer_payload.get("documentName") else []
            answer["referencedPdf"] = str(definition_answer_payload.get("documentName", ""))
            answer["sourcePages"] = definition_answer_payload.get("sourcePages", [])
            answer["sourceChapter"] = _chapter_label(section) if section else ""
            answer["sourceSection"] = _section_label(section) if section else ""
            answer["relevantSections"] = [_section_label(section)] if section else []
            answer["relevantChapters"] = [_chapter_label(section)] if section else []
            answer["directAnswer"] = "\n\n".join(
                [
                    f'{definition_answer_payload["term"]}: {definition_answer_payload["definition"]}',
                    self._source_block(
                        document_name=str(answer.get("referencedPdf", "")),
                        chapter=str(answer.get("sourceChapter", "")),
                        section=str(answer.get("sourceSection", "")),
                        source_pages=answer.get("sourcePages", []),
                    ),
                ]
            )
            self._log_retrieval(
                question=question,
                plan=plan,
                retrieval=retrieval,
                confidence_score=0.96,
                selected_chunks=[],
                decision=f'Returned exact definition for term {definition_answer_payload["term"]} from the selected document.',
                debug=search_debug,
                llm_response=answer["directAnswer"],
                final_context_documents=[str(definition_answer_payload.get("documentName", "")).strip()],
            )
            return answer

        if document_identity_payload:
            section = document_identity_payload.get("section", {}) or {}
            answer = self._empty_answer(
                question,
                plan,
                confidence_score=0.92,
                direct_answer="",
                business_explanation=f'Answered from the selected document {document_identity_payload.get("documentName", "")}.',
                ai_model=ai_model,
                language=language,
            )
            answer["title"] = str(section.get("title", "") or document_identity_payload.get("documentName", ""))
            answer["sectionId"] = str(section.get("id", ""))
            answer["chapterNumber"] = str(section.get("chapterNumber", ""))
            answer["sourcePdfs"] = [str(document_identity_payload.get("documentName", ""))] if document_identity_payload.get("documentName") else []
            answer["referencedPdf"] = str(document_identity_payload.get("documentName", ""))
            answer["sourcePages"] = document_identity_payload.get("sourcePages", [])
            answer["sourceChapter"] = _chapter_label(section) if section else ""
            answer["sourceSection"] = _section_label(section) if section else ""
            answer["sourceHeading"] = ""
            answer["relevantSections"] = [_section_label(section)] if section else []
            answer["relevantChapters"] = [_chapter_label(section)] if section else []
            answer["directAnswer"] = "\n\n".join(
                [
                    str(document_identity_payload.get("answer", "")).strip(),
                    self._source_block(
                        document_name=str(answer.get("referencedPdf", "")),
                        chapter=str(answer.get("sourceChapter", "")),
                        section=str(answer.get("sourceSection", "")),
                        source_pages=answer.get("sourcePages", []),
                    ),
                ]
            )
            self._log_retrieval(
                question=question,
                plan=plan,
                retrieval=retrieval,
                confidence_score=0.92,
                selected_chunks=[],
                decision=f'Returned document identity answer for {document_identity_payload.get("documentName", "")} from the selected document introduction/definition path.',
                debug=search_debug,
                llm_response=answer["directAnswer"],
                final_context_documents=[str(document_identity_payload.get("documentName", "")).strip()],
            )
            return answer

        full_content_request = self._is_full_content_request(question, plan)
        answer_sections, confidence_score = self._pick_sections(retrieval, sections, plan)
        if full_content_request:
            full_content_sections = self._full_content_sections(question, plan, retrieval, sections, allowed_document_names)
            if full_content_sections:
                answer_sections = full_content_sections
        if not answer_sections and plan.user_intent in {
            "Data Extraction",
            "Table Extraction",
            "XML Extraction",
            "JSON Extraction",
            "PDF Parsing",
            "Comparison",
            "Summarization",
            "Search",
            "Information Retrieval",
            "Document Analysis",
            "Report Generation",
        }:
            answer_sections = self._fallback_sections(retrieval, sections, plan, allowed_document_names)
        if answer_sections and not self._has_grounded_evidence(question, retrieval, answer_sections):
            answer_sections = []
        if not answer_sections:
            answer = self._empty_answer(
                question,
                plan,
                confidence_score=confidence_score,
                ai_model=ai_model,
                language=language,
                direct_answer=MISSING_INFORMATION_MESSAGE,
            )
            self._log_retrieval(
                question=question,
                plan=plan,
                retrieval=retrieval,
                confidence_score=confidence_score,
                selected_chunks=[],
                decision="Rejected answer because the selected document did not contain a sufficiently grounded matching section.",
                debug=search_debug,
                final_prompt=f"Question: {question}\nSelected document: {', '.join(allowed_document_names) or 'none'}\nSelected scope: {selected_scope_label}",
                llm_response=answer["directAnswer"],
                final_context_documents=allowed_document_names,
            )
            return answer

        primary_section = answer_sections[0]
        section_keys = {self._section_record_key(section) for section in answer_sections if self._section_record_key(section)}
        selected_chunks = self._section_chunks(retrieval, chunks, section_keys)
        heading_target_chunk = self._best_heading_chunk(question, selected_chunks)
        if heading_target_chunk:
            heading_section_key = self._record_section_key(heading_target_chunk)
            matching_heading_section = next(
                (section for section in answer_sections if self._section_record_key(section) == heading_section_key),
                None,
            )
            if matching_heading_section:
                answer_sections = [matching_heading_section]
                primary_section = matching_heading_section
                section_keys = {heading_section_key}
                selected_chunks = [
                    chunk
                    for chunk in selected_chunks
                    if self._record_section_key(chunk) == heading_section_key
                ]

        section_rules = [rule for rule in rules if self._record_section_key(rule) in section_keys][:8]
        section_conditions = [condition for condition in conditions if self._record_section_key(condition) in section_keys][:8]
        section_workflows = [
            workflow
            for workflow in workflows
            if self._section_key(workflow.get("section", ""), workflow.get("documentName", "")) in section_keys
        ][:2]
        section_examples = [example for example in examples if self._record_section_key(example) in section_keys][:3]

        relevant_chapters = _unique([*plan.likely_chapters, *[_chapter_label(section) for section in answer_sections]])
        relevant_sections = _unique([_section_label(section) for section in answer_sections]) or list(plan.likely_sections)
        source_pdfs = _unique([str(section.get("documentName", "")) for section in answer_sections] + [str(chunk.get("documentName", "")) for chunk in selected_chunks])
        source_pages = _unique([str(page) for section in answer_sections for page in section.get("sourcePages", [])] + [str(page) for chunk in selected_chunks for page in chunk.get("sourcePages", [])])

        definitions = []
        for section in answer_sections:
            for definition in section.get("definitions", [])[:4]:
                term = str(definition.get("term", "")).strip()
                meaning = str(definition.get("definition", "")).strip()
                if term and meaning:
                    definitions.append(f"{term}: {_clean(meaning, 180)}")

        business_logic = _unique(
            [
                *[_clean(rule.get("description", ""), 420) for rule in section_rules if rule.get("description")],
                *[_clean(validation, 420) for section in answer_sections for validation in section.get("validations", [])[:3]],
            ]
        )[:6]

        workflow_steps = _unique(
            [
                *[step for workflow in section_workflows for step in workflow.get("steps", [])[:6]],
                *[step for section in answer_sections for step in section.get("workflow", [])[:6]],
            ]
        )[:6]

        condition_items = _unique(
            [
                *[_clean(condition.get("text", ""), 420) for condition in section_conditions if condition.get("text")],
                *[_clean(rule.get("condition", ""), 420) for rule in section_rules if rule.get("condition")],
            ]
        )[:6]

        exception_items = _unique(
            [
                *[_clean(rule.get("exception", ""), 420) for rule in section_rules if rule.get("exception")],
                *[_clean(exception, 420) for section in answer_sections for exception in section.get("exceptions", [])[:4]],
            ]
        )[:6]

        required_documents = _unique(
            [
                *[str(document) for section in answer_sections for document in section.get("requiredDocuments", [])],
                *[str(document) for section in answer_sections for document in section.get("documents", [])],
            ]
        )[:6]

        important_notes = _unique(
            [
                *[_clean(note, 220) for section in answer_sections for note in section.get("notes", [])[:5]],
                *definitions[:3],
                *[
                    _clean(" | ".join(str(cell) for cell in row), 220)
                    for section in answer_sections
                    for row in section.get("tables", [])[:2]
                ],
                *[_clean(timeline, 200) for section in answer_sections for timeline in section.get("timelines", [])[:3]],
                *[_clean(authority, 180) for section in answer_sections for authority in section.get("authorities", [])[:3]],
            ]
        )[:8]
        supporting_text = _unique(
            [
                *[
                    f'{_section_reference(next((section for section in answer_sections if self._section_record_key(section) == self._record_section_key(chunk)), primary_section))}\n{_clean(str(chunk.get("text", "")), 260)}'
                    for chunk in selected_chunks
                    if chunk.get("text")
                ],
                *[
                    f"{_section_reference(section)}\n{_clean(str(section.get('summary', '')), 220)}"
                    for section in answer_sections
                    if section.get("summary")
                ],
                *[
                    f"{_section_reference(section)}\n{_clean(str(section.get('businessExplanation', '')), 220)}"
                    for section in answer_sections
                    if section.get("businessExplanation")
                ],
            ]
        )[:3]

        direct_answer_parts = [
            _clean(primary_section.get("summary", ""), 220),
            _clean(primary_section.get("businessMeaning", ""), 220),
        ]
        if selected_chunks:
            direct_answer_parts.append(_clean(" ".join(str(chunk.get("text", "")) for chunk in selected_chunks), 260))

        business_explanation_parts = _unique(
            [
                *[_clean(section.get("businessExplanation", ""), 220) for section in answer_sections if section.get("businessExplanation")],
                *definitions[:2],
            ]
        )[:4]

        related_sections = _unique(
            [
                *[
                    f'{section["id"]} {section["title"]}'
                    for section in sections
                    if section["id"] in {related_id for item in answer_sections for related_id in item.get("relatedSections", [])}
                ],
                *relevant_sections[1:],
            ]
        )[:5]

        answer_text, source_payload = self._intent_response(
            question=question,
            plan=plan,
            retrieval=retrieval,
            answer_sections=answer_sections,
            selected_chunks=selected_chunks,
            chapters=chapters,
            workflow_steps=workflow_steps,
            condition_items=condition_items,
            exception_items=exception_items,
            business_logic=business_logic,
            required_documents=required_documents,
            section_examples=section_examples,
            source_pdfs=source_pdfs,
            source_pages=source_pages,
            relevant_chapters=relevant_chapters,
            relevant_sections=relevant_sections,
        )
        if iec_definition_answer:
            answer_text = iec_definition_answer

        answer_title = primary_section["title"]
        if plan.intent in {"Import Procedure", "Export Procedure"}:
            answer_title = plan.topic
        if full_content_request and plan.chapter_filters and not plan.section_filters:
            chapter_number = next(iter(plan.chapter_filters), "")
            chapter = next((item for item in chapters if str(item.get("chapter_number", "")) == chapter_number), None)
            answer_title = f'Chapter {chapter_number}'
            if chapter and chapter.get("chapter_title"):
                answer_title = f'{answer_title} - {chapter.get("chapter_title", "")}'

        answer = {
            "question": question,
            "questionUnderstood": plan.question_understood,
            "title": answer_title,
            "sectionId": primary_section["id"],
            "chapterNumber": primary_section["chapterNumber"],
            "detectedIntent": plan.user_intent,
            "detectedTopic": plan.topic,
            "knowledgeSourcesUsed": list(plan.knowledge_sources),
            "confidenceScore": round(confidence_score, 2),
            "relevantChapters": relevant_chapters,
            "relevantSections": relevant_sections,
            "directAnswer": answer_text,
            "businessExplanation": "",
            "businessLogic": business_logic,
            "workflow": workflow_steps,
            "conditions": condition_items,
            "exceptions": exception_items,
            "requiredDocuments": required_documents,
            "importantNotes": important_notes,
            "businessRules": [_clean(rule.get("description", ""), 220) for rule in section_rules if rule.get("description")][:6],
            "realExample": next((str(example.get("text", "")).strip() for example in section_examples if example.get("text")), str(primary_section.get("realWorldExample", ""))),
            "relatedChapters": _unique([str(chapter) for chapter in primary_section.get("relatedChapters", [])])[:5],
            "relatedSections": related_sections,
            "modelUsed": ai_model,
            "languageUsed": language,
            **source_payload,
        }

        final_prompt = "\n".join(
            [
                f"Question: {question}",
                f"Detected intent: {search_debug.get('detected_intent', plan.intent)}",
                f"Detected entities: {', '.join(search_debug.get('detected_entities', []))}",
                f"Selected scope: {selected_scope_label}",
                f"Selected sections: {', '.join(relevant_sections)}",
                f"Selected chunks: {', '.join(str(chunk.get('id', '')) for chunk in selected_chunks[:3])}",
            ]
        )
        self._log_retrieval(
            question=question,
            plan=plan,
            retrieval=retrieval,
            confidence_score=confidence_score,
            selected_chunks=selected_chunks,
            decision="Accepted the relevant section(s) after dynamic document selection, in-document retrieval, source validation, and grounded answer generation.",
            debug=search_debug,
            final_prompt=final_prompt,
            llm_response=answer["directAnswer"],
            final_context_documents=source_pdfs,
        )
        return answer

    def stream_events(self, question: str, ai_model: str = "", language: str = "English", current_document_name: str = "") -> list[str]:
        self._current_document_name = current_document_name
        answer = self.build_answer(question, ai_model=ai_model, language=language)
        if hasattr(self, "_current_document_name"):
            delattr(self, "_current_document_name")
        direct_answer = answer["directAnswer"]
        chunks = [direct_answer[index : index + 18] for index in range(0, len(direct_answer), 18)]
        events = [json.dumps({"type": "start"})]
        events.extend(json.dumps({"type": "delta", "text": chunk}) for chunk in chunks)
        events.append(json.dumps({"type": "complete", "answer": answer}))
        return events


chat_service = ChatService()
