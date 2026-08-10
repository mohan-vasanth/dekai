from __future__ import annotations

import json
import logging
import re
from collections import Counter
from time import perf_counter
from typing import Any

from parser.utils import normalise_whitespace
from parser.xml_utils import (
    extract_query_namespace,
    extract_section_request_target,
    field_search_aliases,
    hierarchy_search_aliases,
    is_xml_field_query,
    normalize_query_field_reference,
    normalized_tag_key,
    normalized_tag_root,
)

from .document_version_service import document_version_service
from .conversation_service import conversation_service
from .knowledge_engine import knowledge_engine_service
from .llm_service import LLMConfigurationError, llm_service
from .retrieval_service import TRADE_NET_XML_FIELD_INTENT, RetrievalPlan, analyze_question, retrieval_decision_service
from .search_service import search_service
from .settings_service import SUPPORTED_LANGUAGES

logger = logging.getLogger(__name__)
FAILED_DOCUMENT_MESSAGE = (
    "This document has not been processed successfully and is not available in the Knowledge Base. "
    "Please resolve the processing issue or upload the document again before asking questions."
)
MISSING_INFORMATION_MESSAGE = "The requested information is not available in the uploaded documents."
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
TRADE_NET_DOCUMENT_HINTS = (
    "tradenet",
    "iptdec",
    "trade net declaration",
    "message definition",
    "message details",
    "message function",
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


def _remove_extraction_noise(value: Any) -> str:
    text = str(value or "").replace("\r\n", "\n")
    cleaned_lines: list[str] = []
    seen_lines: set[str] = set()
    noise_patterns = (
        r"^\s*pg\.?\s*\d+\s*$",
        r"^\s*page\s+\d+\s*$",
        r"^\s*\d{1,2}/\d{1,2}/\d{2,4}\s+\d{1,2}:\d{2}(?::\d{2})?\s*$",
        r"^\s*(?:for:)?\s*\d{1,2}/\d{1,2}/\d{2,4}\s+\d{1,2}:\d{2}(?::\d{2})?\s*$",
        r"^\s*ver(?:sion)?\s*[\d.]+\s*$",
        r"^\s*trade\s*net\b.*$",
        r"^\s*.+\.(?:pdf|docx?|xlsx?|pptx?)\s*$",
        r"^\s*cargo\s+\d{1,2}/\d{1,2}/\d{2,4}.*$",
    )

    for raw_line in text.split("\n"):
        line = " ".join(raw_line.split()).strip(" |")
        if not line:
            continue
        lowered = line.casefold()
        if lowered in seen_lines:
            continue
        if any(re.match(pattern, line, flags=re.IGNORECASE) for pattern in noise_patterns):
            continue
        if re.fullmatch(r"[\d\s./:-]+", line):
            continue
        if len(line) < 4:
            continue
        seen_lines.add(lowered)
        cleaned_lines.append(line)

    cleaned = " ".join(cleaned_lines)
    cleaned = re.sub(r"\b(?:copy of the message|receiving a copy of the message)\b", "", cleaned, flags=re.IGNORECASE)
    cleaned = re.sub(r"\b(?:timestamp|version number|page header|page footer)\b", "", cleaned, flags=re.IGNORECASE)
    return " ".join(cleaned.split()).strip()


def _split_sentences(value: Any) -> list[str]:
    text = _remove_extraction_noise(value)
    if not text:
        return []
    parts = re.split(r"(?<=[.!?])\s+|\s*[•\-]\s+", text)
    sentences: list[str] = []
    for part in parts:
        sentence = " ".join(part.split()).strip(" .;:-")
        if len(sentence) < 12:
            continue
        sentences.append(sentence)
    return sentences


def _is_extractive_sentence(value: str) -> bool:
    sentence = " ".join(str(value or "").split()).strip()
    if not sentence:
        return True
    if re.search(r"\b(?:trade net|cargo|copy of the message|ver\s*\d|page \d|pg\.)\b", sentence, flags=re.IGNORECASE):
        return True
    if re.search(r"\b\d{1,2}/\d{1,2}/\d{2,4}\b", sentence):
        return True
    if sentence.count(":") >= 4 and len(sentence.split()) < 20:
        return True
    return False


def _clean_evidence_item(value: Any, limit: int = 240) -> str:
    cleaned = _remove_extraction_noise(value)
    if not cleaned or _is_extractive_sentence(cleaned):
        return ""
    return _clean(cleaned, limit)


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
    if is_xml_field_query(question):
        return True
    if re.search(
        r"\b(?:document|documents|exception|exceptions|process|procedure|rule|rules|step|steps|table|validation|validations|workflow)\b",
        normalized,
    ):
        return False
    return 1 <= len(_heading_lookup_tokens(question)) <= 7


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
    if match:
        return match.group(1).strip()
    cleaned = normalise_whitespace(str(value or "").strip().strip("'\""))
    return cleaned if is_xml_field_query(cleaned) else ""


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

    def _is_trade_net_document(self, document_name: str) -> bool:
        normalized = _normalize_alnum_words(document_name)
        return any(hint in normalized for hint in TRADE_NET_DOCUMENT_HINTS)

    def _trade_net_ready_documents(self, ready_documents: list[dict[str, Any]]) -> list[dict[str, Any]]:
        return [
            document
            for document in ready_documents
            if self._is_trade_net_document(str(document.get("name", "")))
        ]

    def _trade_net_exact_field_match(self, retrieval: list[dict[str, Any]]) -> dict[str, Any] | None:
        for item in retrieval:
            if any(
                bool(item.get(flag))
                for flag in ("fieldExactMatch", "normalizedFieldExactMatch", "headingExactMatch")
            ):
                return item
        return None

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

        if current_document and (
            is_xml_field_query(question)
            or plan.intent == "Section Request"
            or bool(plan.section_request_name)
            or (_looks_like_heading_lookup(question) and self._is_trade_net_document(str(current_document.get("name", ""))))
        ):
            normalized_name = _normalize(str(current_document.get("name", "")))
            selected = document_map.get(normalized_name)
            if selected:
                selected["score"] = 25000.0
                selected["reasons"].append("current_structured_document")
                return selected, {
                    "selectionMethod": "current_structured_document",
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
            query_compact_keys = {
                normalized_tag_key(alias)
                for alias in field_search_aliases(question)
                if normalized_tag_key(alias)
            }
            query_root_keys = {
                normalized_tag_root(alias)
                for alias in field_search_aliases(question)
                if normalized_tag_root(alias)
            }
            exact_title_hits: list[tuple[int, dict[str, Any], bool]] = []
            for rank, hit in enumerate(grounding_hits):
                heading_value = _normalize_alnum_words(str(hit.get("heading", "") or hit.get("title", "")))
                field_values = [_normalize_alnum_words(str(field)) for field in hit.get("fieldNames", []) if _normalize_alnum_words(str(field))]
                field_compact_keys = {
                    normalized_tag_key(str(field))
                    for field in [hit.get("tagName", ""), hit.get("normalizedTagName", ""), *hit.get("fieldNames", [])]
                    if normalized_tag_key(str(field))
                }
                field_root_keys = {
                    normalized_tag_root(str(field))
                    for field in [hit.get("tagName", ""), hit.get("normalizedTagName", ""), *hit.get("fieldNames", [])]
                    if normalized_tag_root(str(field))
                }
                heading_exact = bool(normalized_lookup and heading_value == normalized_lookup)
                field_exact = bool(normalized_lookup and normalized_lookup in field_values)
                if not field_exact and query_compact_keys and field_compact_keys.intersection(query_compact_keys):
                    field_exact = True
                if not field_exact and query_root_keys and field_root_keys.intersection(query_root_keys):
                    field_exact = True
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
                current_document_bonus = 60.0
                if _looks_like_heading_lookup(question) or is_xml_field_query(question):
                    current_document_bonus = 900.0
                candidate["score"] += current_document_bonus
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
        if plan.disable_semantic_expansion:
            return _unique([plan.topic, question])[:2]
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
            "detected_namespace": plan.detected_namespace,
            "selected_retrieval_engine": plan.retrieval_engine or "semantic_grounding",
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
                    if str(item.get("type", "")).lower() in {"section", "chunk", "hierarchy", "rule", "condition", "workflow", "definition"}
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

    def _retrieve_trade_net_field_grounding(
        self,
        question: str,
        plan: RetrievalPlan,
        *,
        trade_net_document_names: list[str],
        scope_label: str,
    ) -> tuple[list[dict[str, Any]], dict[str, Any], str]:
        normalized_document_names = frozenset(_normalize(name) for name in trade_net_document_names if _normalize(name))
        queries = _unique([plan.topic, question])
        batches: list[tuple[str, list[dict[str, Any]]]] = []
        debugs: list[dict[str, Any]] = []

        def run_queries(document_names: frozenset[str]) -> list[dict[str, Any]]:
            local_batches: list[tuple[str, list[dict[str, Any]]]] = []
            local_debugs: list[dict[str, Any]] = []
            for lookup_query in queries:
                results = search_service.retrieve(
                    lookup_query,
                    mode="keyword",
                    limit=20,
                    document_filters=document_names,
                )
                local_batches.append((lookup_query, results))
                local_debugs.append(search_service.get_last_debug())
            batches[:] = local_batches
            debugs[:] = local_debugs
            return self._merge_retrieval_sets(question, plan, local_batches)

        retrieval = run_queries(normalized_document_names)
        exact_match = self._trade_net_exact_field_match(retrieval)
        locked_document_name = ""
        if exact_match:
            locked_document_name = str(exact_match.get("documentName", "")).strip()
        elif trade_net_document_names:
            locked_document_name = str(trade_net_document_names[0]).strip()
        elif retrieval:
            locked_document_name = str(retrieval[0].get("documentName", "")).strip()

        if exact_match and locked_document_name:
            retrieval = run_queries(frozenset({_normalize(locked_document_name)}))

        search_debug = self._aggregate_search_debug(
            question,
            plan,
            queries,
            debugs,
            retrieval,
            locked_document_name,
            scope_label,
        )
        final_exact_match = self._trade_net_exact_field_match(retrieval)
        selected_result = final_exact_match or (retrieval[0] if retrieval else {})
        search_debug.update(
            {
                "selected_retrieval_engine": plan.retrieval_engine or "trade_net_xml_field",
                "selected_document": locked_document_name,
                "exact_field_match": {
                    "found": bool(final_exact_match),
                    "matchedField": str((final_exact_match or {}).get("matchedField", "")).strip(),
                    "matchedHeading": str((final_exact_match or {}).get("matchedHeading", "")).strip(),
                    "documentName": str((final_exact_match or {}).get("documentName", "")).strip(),
                    "sectionId": str((final_exact_match or {}).get("sectionId", "")).strip(),
                    "title": str((final_exact_match or {}).get("title", "")).strip(),
                },
                "selected_section": str(selected_result.get("sectionId", "")).strip(),
            }
        )
        return retrieval, search_debug, locked_document_name

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
            and str(item.get("type", "")).lower() in {"section", "chunk", "hierarchy", "rule", "condition", "workflow", "definition"}
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
            "detectedIntent": plan.intent,
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
            "sources": [],
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
        document_sync: dict[str, Any] | None = None,
    ) -> None:
        payload = {
            "question": question,
            "original_question": question,
            "detected_namespace": plan.detected_namespace,
            "detected_intent": plan.intent,
            "detected_user_intent": plan.user_intent,
            "detected_topic": plan.topic,
            "selected_retrieval_engine": debug.get("selected_retrieval_engine", plan.retrieval_engine or "") if debug else (plan.retrieval_engine or ""),
            "knowledge_source": list(plan.knowledge_sources),
            "requested_document": document_sync.get("requestedDocumentName", "") if document_sync else "",
            "retrieved_document": document_sync.get("retrievedDocumentName", "") if document_sync else "",
            "response_source_document": document_sync.get("responseDocumentName", "") if document_sync else "",
            "detected_document": debug.get("detected_document", "") if debug else "",
            "selected_document": debug.get("selected_document", "") if debug else "",
            "selected_section": debug.get("selected_section", "") if debug else "",
            "exact_field_match": debug.get("exact_field_match", {}) if debug else {},
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

    def _attach_document_sync(
        self,
        answer: dict[str, Any],
        bundle: dict[str, Any],
        *,
        requested_document_name: str = "",
    ) -> dict[str, str]:
        search_debug = bundle.get("searchDebug", {}) or {}
        final_context_documents = bundle.get("finalContextDocuments", []) or []
        requested_document = str(requested_document_name or getattr(self, "_current_document_name", "")).strip()
        retrieved_document = str(
            search_debug.get("selected_document", "")
            or search_debug.get("target_document", "")
            or search_debug.get("detected_document", "")
            or next((str(name).strip() for name in final_context_documents if str(name).strip()), "")
            or answer.get("referencedPdf", "")
            or next((str(name).strip() for name in answer.get("sourcePdfs", []) if str(name).strip()), "")
        ).strip()
        response_document = str(
            answer.get("referencedPdf", "")
            or next((str(name).strip() for name in answer.get("sourcePdfs", []) if str(name).strip()), "")
            or retrieved_document
        ).strip()
        document_sync = {
            "requestedDocumentName": requested_document,
            "retrievedDocumentName": retrieved_document or response_document,
            "responseDocumentName": response_document or retrieved_document,
        }
        answer["documentSync"] = document_sync
        bundle["documentSync"] = document_sync
        return document_sync

    def _pick_sections(self, retrieval: list[dict[str, Any]], sections: list[dict[str, Any]], plan: RetrievalPlan) -> tuple[list[dict[str, Any]], float]:
        ranked_section_hits = [
            item
            for item in retrieval
            if item.get("sectionId")
            and str(item.get("type", "")).lower() in {"section", "chunk", "hierarchy", "rule", "condition", "workflow", "definition"}
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
            "normalized_field_exact_match",
            "normalized_field_root_match",
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

        if is_xml_field_query(question):
            query_compact_keys = {
                normalized_tag_key(alias)
                for alias in field_search_aliases(question)
                if normalized_tag_key(alias)
            }
            query_root_keys = {
                normalized_tag_root(alias)
                for alias in field_search_aliases(question)
                if normalized_tag_root(alias)
            }
            for item in retrieval[:12]:
                candidate_keys = {
                    normalized_tag_key(str(field))
                    for field in [item.get("tagName", ""), item.get("normalizedTagName", ""), *item.get("fieldNames", [])]
                    if normalized_tag_key(str(field))
                }
                candidate_root_keys = {
                    normalized_tag_root(str(field))
                    for field in [item.get("tagName", ""), item.get("normalizedTagName", ""), *item.get("fieldNames", [])]
                    if normalized_tag_root(str(field))
                }
                if query_compact_keys.intersection(candidate_keys) or query_root_keys.intersection(candidate_root_keys):
                    return True

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
        seen_hashes: set[str] = set()
        for item in retrieval:
            if item.get("type") != "chunk" or self._record_section_key(item) not in section_keys:
                continue
            item_id = str(item.get("id", ""))
            if item_id in seen_ids:
                continue
            chunk_hash = str(item.get("chunkHash", "")).strip() or _normalize(_remove_extraction_noise(item.get("text", "")))
            if chunk_hash and chunk_hash in seen_hashes:
                continue
            seen_ids.add(item_id)
            if chunk_hash:
                seen_hashes.add(chunk_hash)
            selected.append(item)
            if len(selected) >= 6:
                break
        if selected:
            return selected
        fallback_selected: list[dict[str, Any]] = []
        for chunk in chunks:
            if self._record_section_key(chunk) not in section_keys:
                continue
            chunk_hash = str(chunk.get("chunkHash", "")).strip() or _normalize(_remove_extraction_noise(chunk.get("text", "")))
            if chunk_hash and chunk_hash in seen_hashes:
                continue
            if chunk_hash:
                seen_hashes.add(chunk_hash)
            fallback_selected.append(chunk)
            if len(fallback_selected) >= 6:
                break
        return fallback_selected

    def _section_hierarchy_nodes(self, section: dict[str, Any]) -> list[dict[str, Any]]:
        nodes = [node for node in section.get("hierarchyNodes", []) if isinstance(node, dict)]
        return sorted(
            nodes,
            key=lambda node: (
                int(node.get("startLine", 0) or 0),
                int(node.get("endLine", 0) or 0),
                int(node.get("depth", 0) or 0),
                str(node.get("id", "")),
            ),
        )

    def _hierarchy_aliases(self, node: dict[str, Any]) -> list[str]:
        aliases = [
            *node.get("searchAliases", []),
            str(node.get("title", "")),
            str(node.get("tagName", "")),
            str(node.get("normalizedTagName", "")),
        ]
        return _unique([normalise_whitespace(str(alias)) for alias in aliases if normalise_whitespace(str(alias))])

    def _hierarchy_match_score(self, target: str, node: dict[str, Any], *, prefer_field: bool) -> float:
        node_type = str(node.get("type", "")).strip().lower()
        if node_type in {"note", "exception", "validation", "definition", "business_rule"}:
            return 0.0

        target_aliases = _unique([*hierarchy_search_aliases(target), *field_search_aliases(target), target])
        target_words = {_normalize_alnum_words(alias) for alias in target_aliases if _normalize_alnum_words(alias)}
        target_compact_keys = {normalized_tag_key(alias) for alias in target_aliases if normalized_tag_key(alias)}
        target_root_keys = {normalized_tag_root(alias) for alias in target_aliases if normalized_tag_root(alias)}
        node_aliases = self._hierarchy_aliases(node)
        node_words = {_normalize_alnum_words(alias) for alias in node_aliases if _normalize_alnum_words(alias)}
        node_compact_keys = {normalized_tag_key(alias) for alias in node_aliases if normalized_tag_key(alias)}
        node_root_keys = {normalized_tag_root(alias) for alias in node_aliases if normalized_tag_root(alias)}

        score = 0.0
        if target_words.intersection(node_words):
            score += 280.0
        elif target_compact_keys.intersection(node_compact_keys):
            score += 255.0
        elif target_root_keys.intersection(node_root_keys):
            score += 225.0
        elif any(target_word and node_word and (target_word in node_word or node_word in target_word) for target_word in target_words for node_word in node_words):
            score += 170.0

        target_tokens = {
            token
            for token in re.findall(r"\b[a-z0-9][a-z0-9/&._:-]{2,}\b", _normalize(target))
            if token not in GROUNDING_STOPWORDS
        }
        node_tokens = {
            token
            for alias in node_aliases
            for token in re.findall(r"\b[a-z0-9][a-z0-9/&._:-]{2,}\b", _normalize(alias))
            if token not in GROUNDING_STOPWORDS
        }
        score += float(len(target_tokens.intersection(node_tokens)) * 18)

        if prefer_field:
            score += {
                "field": 95.0,
                "xml_container": 70.0,
                "subsection": 25.0,
                "section": 10.0,
            }.get(node_type, 0.0)
        else:
            score += {
                "subsection": 95.0,
                "xml_container": 80.0,
                "section": 40.0,
                "field": 20.0,
            }.get(node_type, 0.0)

        if str(node.get("tagName", "")).strip() and str(node.get("namespace", "")).strip():
            score += 8.0
        return score

    def _best_hierarchy_match(
        self,
        target: str,
        sections: list[dict[str, Any]],
        *,
        prefer_field: bool,
    ) -> dict[str, Any] | None:
        best_match: dict[str, Any] | None = None
        best_score = 0.0
        for section in sections:
            for node in self._section_hierarchy_nodes(section):
                score = self._hierarchy_match_score(target, node, prefer_field=prefer_field)
                if score > best_score:
                    best_match = {"section": section, "node": node, "score": score}
                    best_score = score
        threshold = 145.0 if prefer_field else 155.0
        return best_match if best_match and best_score >= threshold else None

    def _hierarchy_context(self, section: dict[str, Any], matched_node: dict[str, Any], *, mode: str) -> dict[str, Any]:
        nodes = self._section_hierarchy_nodes(section)
        lookup = {str(node.get("id", "")): node for node in nodes}
        children_by_parent: dict[str, list[dict[str, Any]]] = {}
        for node in nodes:
            children_by_parent.setdefault(str(node.get("parentId", "")), []).append(node)

        def descendants(node_id: str) -> list[dict[str, Any]]:
            result: list[dict[str, Any]] = []
            for child in children_by_parent.get(node_id, []):
                result.append(child)
                result.extend(descendants(str(child.get("id", ""))))
            return result

        ancestry: list[dict[str, Any]] = []
        cursor = matched_node
        while cursor:
            ancestry.append(cursor)
            parent_id = str(cursor.get("parentId", ""))
            cursor = lookup.get(parent_id) if parent_id else None
        ancestry.reverse()

        related_nodes = [matched_node]
        if mode == "field":
            related_nodes.extend(ancestry)
            if str(matched_node.get("type", "")) in {"xml_container", "subsection", "section"}:
                related_nodes.extend(descendants(str(matched_node.get("id", ""))))
            else:
                parent_node = lookup.get(str(matched_node.get("parentId", "")))
                if parent_node:
                    related_nodes.extend(children_by_parent.get(str(parent_node.get("id", "")), [])[:10])
        else:
            related_nodes.extend(ancestry[:-1])
            related_nodes.extend(descendants(str(matched_node.get("id", ""))))

        deduped_nodes: list[dict[str, Any]] = []
        seen_node_ids: set[str] = set()
        for node in sorted(
            related_nodes,
            key=lambda item: (
                int(item.get("startLine", 0) or 0),
                int(item.get("endLine", 0) or 0),
                int(item.get("depth", 0) or 0),
                str(item.get("id", "")),
            ),
        ):
            node_id = str(node.get("id", ""))
            if not node_id or node_id in seen_node_ids:
                continue
            seen_node_ids.add(node_id)
            deduped_nodes.append(node)

        node_type_groups: dict[str, list[dict[str, Any]]] = {}
        for node in deduped_nodes:
            node_type_groups.setdefault(str(node.get("type", "")), []).append(node)

        pages = _unique(
            [
                *[str(node.get("pageNumber", "")) for node in deduped_nodes if str(node.get("pageNumber", "")).strip() and str(node.get("pageNumber", "")) != "0"],
                *[str(page) for page in section.get("sourcePages", []) if str(page).strip()],
            ]
        )
        parent_xml = next((node for node in reversed(ancestry) if str(node.get("type", "")) == "xml_container"), None)
        parent_section = next(
            (
                node
                for node in reversed(ancestry)
                if str(node.get("type", "")) in {"subsection", "section"}
            ),
            None,
        )
        return {
            "nodes": deduped_nodes,
            "fields": node_type_groups.get("field", []),
            "xmlContainers": node_type_groups.get("xml_container", []),
            "definitions": node_type_groups.get("definition", []),
            "notes": node_type_groups.get("note", []),
            "validations": node_type_groups.get("validation", []),
            "exceptions": node_type_groups.get("exception", []),
            "businessRules": node_type_groups.get("business_rule", []),
            "pages": pages,
            "parentXml": parent_xml or matched_node,
            "parentSection": parent_section or matched_node,
        }

    def _hierarchical_answer_text(
        self,
        *,
        section: dict[str, Any],
        matched_node: dict[str, Any],
        context: dict[str, Any],
        mode: str,
    ) -> str:
        matched_label = str(matched_node.get("title", "") or matched_node.get("tagName", "") or section.get("title", "")).strip()
        section_label = _section_label(section)
        parent_xml = context.get("parentXml") or {}
        overview = ""
        if mode == "field":
            overview = (
                _clean_evidence_item(matched_node.get("description", ""), 260)
                or _clean_evidence_item(matched_node.get("content", ""), 260)
                or _first_sentence(section.get("summary", ""), 260)
            )
        else:
            overview = (
                _clean_evidence_item(matched_node.get("content", ""), 320)
                or _first_sentence(section.get("summary", ""), 260)
                or _first_sentence(section.get("businessExplanation", ""), 260)
            )
        if str(matched_node.get("type", "")) == "section":
            purpose = (
                _first_sentence(section.get("purpose", ""), 240)
                or _first_sentence(section.get("businessMeaning", ""), 220)
                or _first_sentence(section.get("summary", ""), 240)
            )
        else:
            purpose = (
                _first_sentence(section.get("businessExplanation", ""), 220)
                or _first_sentence(section.get("businessMeaning", ""), 220)
                or _first_sentence(section.get("summary", ""), 240)
            )

        field_lines = []
        for field in context.get("fields", [])[:20]:
            label_parts = [str(field.get("fieldCode", "")).strip(), str(field.get("tagName", "") or field.get("title", "")).strip()]
            label = " ".join(part for part in label_parts if part).strip()
            description = (
                _clean_evidence_item(field.get("description", ""), 200)
                or _clean_evidence_item(field.get("content", ""), 200)
                or "Captured in the selected document."
            )
            field_lines.append(f"{label}: {description}".strip(": "))

        xml_lines = _unique(
            [
                str(node.get("title", "")).strip()
                for node in context.get("xmlContainers", [])[:10]
                if str(node.get("title", "")).strip()
            ]
        )
        business_rule_lines = _unique(
            [
                *[
                    _clean_evidence_item(node.get("content", ""), 220)
                    for node in context.get("businessRules", [])[:8]
                ],
                *(
                    [
                        _clean(rule.get("description", ""), 220)
                        for rule in section.get("businessRules", [])[:8]
                        if rule.get("description")
                    ]
                    if mode == "section"
                    else []
                ),
            ]
        )
        validation_lines = _unique(
            [
                *[
                    _clean_evidence_item(node.get("content", ""), 220)
                    for node in context.get("validations", [])[:8]
                ],
                *[_clean(item, 220) for item in section.get("validations", [])[:8]],
            ]
        )
        note_lines = _unique(
            [
                *[
                    _clean_evidence_item(node.get("content", ""), 220)
                    for node in context.get("notes", [])[:8]
                ],
                *[_clean(item, 220) for item in section.get("notes", [])[:8]],
            ]
        )
        exception_lines = _unique(
            [
                *[
                    _clean_evidence_item(node.get("content", ""), 220)
                    for node in context.get("exceptions", [])[:8]
                ],
                *[_clean(item, 220) for item in section.get("exceptions", [])[:8]],
            ]
        )
        definition_lines = _unique(
            [
                *[
                    _clean_evidence_item(node.get("content", ""), 220)
                    for node in context.get("definitions", [])[:8]
                ],
            ]
        )
        example_text = (
            next((str(example).strip() for example in section.get("examples", []) if str(example).strip()), "")
            or str(section.get("realWorldExample", "")).strip()
        )

        opening = (
            f"{matched_label} is covered in {section_label} of the selected document."
            if mode == "section"
            else f"{matched_label} is covered in {section_label} of the selected document."
        )
        if mode == "field" and parent_xml and str(parent_xml.get("title", "")).strip() and str(parent_xml.get("id", "")) != str(matched_node.get("id", "")):
            opening = f"{opening.rstrip('.')} It sits under XML element {str(parent_xml.get('title', '')).strip()}."

        parts = [_ensure_sentence(opening)]
        if overview:
            parts.append("\n".join(["Overview", _ensure_sentence(overview)]))
        if purpose:
            parts.append("\n".join(["Purpose", _ensure_sentence(purpose)]))
        if xml_lines:
            parts.append("\n".join(["XML Elements", _bullet_lines(xml_lines, limit=10)]))
        if field_lines:
            parts.append("\n".join(["Fields", _bullet_lines(field_lines, limit=20)]))
        if definition_lines:
            parts.append("\n".join(["Definitions", _bullet_lines(definition_lines, limit=8)]))
        if business_rule_lines:
            parts.append("\n".join(["Business Rules", _bullet_lines(business_rule_lines, limit=8)]))
        if validation_lines:
            parts.append("\n".join(["Validation Rules", _bullet_lines(validation_lines, limit=8)]))
        if note_lines:
            parts.append("\n".join(["Notes", _bullet_lines(note_lines, limit=8)]))
        if exception_lines:
            parts.append("\n".join(["Exceptions", _bullet_lines(exception_lines, limit=8)]))
        if example_text:
            parts.append("\n".join(["Example", _ensure_sentence(_clean(example_text, 240))]))
        parts.append(
            self._source_block(
                document_name=str(section.get("documentName", "")).strip(),
                chapter=_chapter_label(section),
                section=section_label,
                source_pages=context.get("pages", []),
            )
        )
        return "\n\n".join(part for part in parts if part).strip()

    def _hierarchical_answer_payload(
        self,
        question: str,
        plan: RetrievalPlan,
        sections: list[dict[str, Any]],
        *,
        allowed_document_names: list[str] | None = None,
    ) -> dict[str, Any] | None:
        target = plan.section_request_name or extract_section_request_target(question) or question
        prefer_field = is_xml_field_query(question)
        allowed_documents = {_normalize(name) for name in (allowed_document_names or []) if _normalize(name)}
        eligible_sections = [
            section
            for section in sections
            if not allowed_documents or _normalize(str(section.get("documentName", ""))) in allowed_documents
        ]
        if not eligible_sections:
            return None

        match = self._best_hierarchy_match(target, eligible_sections, prefer_field=prefer_field)
        if not match:
            return None

        section = match["section"]
        matched_node = match["node"]
        mode = "field" if prefer_field else "section"
        context = self._hierarchy_context(section, matched_node, mode=mode)
        answer_text = self._hierarchical_answer_text(
            section=section,
            matched_node=matched_node,
            context=context,
            mode=mode,
        )
        business_rules = _unique(
            [
                *[
                    _clean_evidence_item(node.get("content", ""), 220)
                    for node in context.get("businessRules", [])[:8]
                ],
                *(
                    [
                        _clean(rule.get("description", ""), 220)
                        for rule in section.get("businessRules", [])[:8]
                        if rule.get("description")
                    ]
                    if mode == "section"
                    else []
                ),
            ]
        )[:8]
        conditions = _unique([_clean(item, 220) for item in section.get("conditions", [])[:8]])[:8]
        validations = _unique(
            [
                *[
                    _clean_evidence_item(node.get("content", ""), 220)
                    for node in context.get("validations", [])[:8]
                ],
                *[_clean(item, 220) for item in section.get("validations", [])[:8]],
            ]
        )[:8]
        notes = _unique(
            [
                *[
                    _clean_evidence_item(node.get("content", ""), 220)
                    for node in context.get("notes", [])[:8]
                ],
                *[_clean(item, 220) for item in section.get("notes", [])[:8]],
            ]
        )[:8]
        exceptions = _unique(
            [
                *[
                    _clean_evidence_item(node.get("content", ""), 220)
                    for node in context.get("exceptions", [])[:8]
                ],
                *[_clean(item, 220) for item in section.get("exceptions", [])[:8]],
            ]
        )[:8]
        required_documents = _unique(
            [
                *[str(document) for document in section.get("requiredDocuments", []) if str(document).strip()],
                *[str(document) for document in section.get("documents", []) if str(document).strip()],
            ]
        )[:8]
        workflow_steps = _unique([str(step) for step in section.get("workflow", []) if str(step).strip()])[:8]
        confidence = 0.98 if float(match["score"]) >= 260.0 else 0.95 if float(match["score"]) >= 220.0 else 0.91
        return {
            "title": str(matched_node.get("title", "") or section.get("title", "")).strip(),
            "section": section,
            "matchedNode": matched_node,
            "context": context,
            "directAnswer": answer_text,
            "confidenceScore": confidence,
            "businessRules": business_rules,
            "conditions": conditions,
            "validations": validations,
            "exceptions": exceptions,
            "importantNotes": notes,
            "requiredDocuments": required_documents,
            "workflow": workflow_steps,
            "realExample": next((str(example).strip() for example in section.get("examples", []) if str(example).strip()), str(section.get("realWorldExample", "")).strip()),
            "sourcePages": context.get("pages", []),
            "sourcePdfs": [str(section.get("documentName", "")).strip()],
            "relevantChapters": [_chapter_label(section)],
            "relevantSections": [_section_label(section)],
            "mode": mode,
            "decision": (
                f"Answered from the hierarchical section tree using matched node {matched_node.get('title', '')}."
            ),
        }

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
        block_text = _clean_evidence_item(heading_chunk.get("text", ""), 260)
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
        query_compact_keys = {
            normalized_tag_key(alias)
            for alias in field_search_aliases(xml_tag)
            if normalized_tag_key(alias)
        }
        query_root_keys = {
            normalized_tag_root(alias)
            for alias in field_search_aliases(xml_tag)
            if normalized_tag_root(alias)
        }
        best_chunk: dict[str, Any] | None = None
        best_score = -1

        for chunk in selected_chunks:
            heading = _normalize(str(chunk.get("heading", "")).strip())
            field_names = [_normalize(str(field).strip()) for field in chunk.get("fieldNames", []) if str(field).strip()]
            text = _normalize(str(chunk.get("text", "")).strip())
            chunk_keys = {
                normalized_tag_key(str(field))
                for field in [chunk.get("tagName", ""), chunk.get("normalizedTagName", ""), *chunk.get("fieldNames", [])]
                if normalized_tag_key(str(field))
            }
            chunk_root_keys = {
                normalized_tag_root(str(field))
                for field in [chunk.get("tagName", ""), chunk.get("normalizedTagName", ""), *chunk.get("fieldNames", [])]
                if normalized_tag_root(str(field))
            }

            score = 0
            if heading == normalized_tag:
                score += 100
            elif normalized_tag and normalized_tag in heading:
                score += 70
            if query_compact_keys and chunk_keys.intersection(query_compact_keys):
                score += 95
            if query_root_keys and chunk_root_keys.intersection(query_root_keys):
                score += 80
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

        heading = str(best_chunk.get("heading", "")).strip() or xml_tag
        heading_label = heading.title() if heading.isupper() else heading
        field_names = [str(field).strip() for field in best_chunk.get("fieldNames", []) if str(field).strip()]
        description = _clean_evidence_item(best_chunk.get("description", ""), 180)
        best_text = _clean_evidence_item(best_chunk.get("text", ""), 220)

        if best_text and _normalize(best_text) != _normalize(heading):
            return _ensure_sentence(best_text)

        blocks = [f"{heading_label} is an XML tag in the uploaded declaration message."]
        if field_names:
            blocks.append(f"It includes fields such as {_natural_list(field_names, limit=8)}.")
        elif description and _normalize(description) != _normalize(heading):
            blocks.append(f"It is associated with {description}.")
        else:
            blocks.append("It identifies a structured declaration block used by the message specification.")
        return " ".join(blocks)

    def _best_field_chunk(self, question: str, selected_chunks: list[dict[str, Any]]) -> tuple[dict[str, Any] | None, str]:
        normalized_question = _normalize(question)
        query_compact_keys = {
            normalized_tag_key(alias)
            for alias in field_search_aliases(question)
            if normalized_tag_key(alias)
        }
        query_root_keys = {
            normalized_tag_root(alias)
            for alias in field_search_aliases(question)
            if normalized_tag_root(alias)
        }
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
                field_compact_key = normalized_tag_key(field_name)
                field_root_key = normalized_tag_root(field_name)
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
                if field_compact_key and field_compact_key in query_compact_keys:
                    score += 95
                if field_root_key and field_root_key in query_root_keys:
                    score += 75
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
            cleaned_line = _clean_evidence_item(matched_line, 220)
            if cleaned_line:
                blocks.append(f"The selected document describes it as: {cleaned_line}.")
            else:
                blocks.append("It is part of the structured fields captured from the selected PDF.")
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
        matched_document_tokens: set[str] = set()

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
                matched_document_tokens = {
                    token
                    for token in _document_tokens(document_name)
                    if len(token) >= 4
                }
                break

        if not matched_document_name:
            return None

        generic_identity_tokens = {
            "about",
            "document",
            "file",
            "meaning",
            "pdf",
            "tell",
            "what",
        }
        content_tokens = {
            token
            for token in question_tokens
            if len(token) >= 4 and token not in matched_document_tokens and token not in generic_identity_tokens
        }
        if content_tokens:
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

    def _iec_definition_payload(self, question: str, sections: list[dict[str, Any]], allowed_document_names: list[str] | None = None) -> dict[str, Any] | None:
        normalized_question = _normalize(question)
        if "iec" not in normalized_question:
            return None
        if not _contains_any(normalized_question, ("full form", "stands for", "meaning of iec", "what is iec")):
            return None

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
        one_pan_summary = _clean_evidence_item(_first_sentence((one_pan_section or {}).get("summary", ""), 220), 220)
        if one_pan_summary:
            answer_parts.append(f"According to the selected document, {one_pan_summary.rstrip('.')}.")

        if not one_pan_section:
            return None

        return {
            "answer": " ".join(part for part in answer_parts if part).strip(),
            "documentName": str(one_pan_section.get("documentName", "")).strip(),
            "section": one_pan_section,
            "sourcePages": [int(page) for page in one_pan_section.get("sourcePages", []) if str(page).isdigit()],
        }

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

    def _source_entries(self, answer_sections: list[dict[str, Any]], selected_chunks: list[dict[str, Any]] | None = None) -> list[dict[str, Any]]:
        selected_chunks = selected_chunks or []
        pages_by_section: dict[str, list[int]] = {}
        for chunk in selected_chunks:
            section_key = self._record_section_key(chunk)
            chunk_pages = [int(page) for page in chunk.get("sourcePages", []) if str(page).isdigit()]
            if not section_key or not chunk_pages:
                continue
            pages_by_section.setdefault(section_key, [])
            for page in chunk_pages:
                if page not in pages_by_section[section_key]:
                    pages_by_section[section_key].append(page)

        sources: list[dict[str, Any]] = []
        seen: set[tuple[str, str, str]] = set()
        for section in answer_sections:
            document_name = str(section.get("documentName", "")).strip()
            chapter = _chapter_label(section)
            section_label = _section_label(section)
            key = (document_name, chapter, section_label)
            if key in seen:
                continue
            seen.add(key)
            pages = [int(page) for page in section.get("sourcePages", []) if str(page).isdigit()]
            extra_pages = pages_by_section.get(self._section_record_key(section), [])
            merged_pages = []
            for page in [*pages, *extra_pages]:
                if page not in merged_pages:
                    merged_pages.append(page)
            merged_pages.sort()
            sources.append(
                {
                    "documentName": document_name,
                    "chapter": chapter,
                    "section": section_label,
                    "pageNumbers": merged_pages,
                }
            )
        return sources

    def _is_list_request(self, question: str) -> bool:
        normalized_question = _normalize(question)
        return any(
            phrase in normalized_question
            for phrase in (
                "what are the",
                "which are the",
                "what are all",
                "list all",
                "list the",
                "give all",
                "enumerate",
                "different",
                "valid",
            )
        )

    def _requested_code(self, question: str) -> str:
        normalized_question = _normalize(question)
        for pattern in (
            r"\bcode\s*(\d{1,3})\b",
            r"\bcorresponds to code\s*(\d{1,3})\b",
        ):
            match = re.search(pattern, normalized_question, flags=re.IGNORECASE)
            if match:
                return match.group(1).strip()
        return ""

    def _extract_enumerated_items(self, text: str) -> list[dict[str, str]]:
        items: list[dict[str, str]] = []
        seen: set[tuple[str, str]] = set()
        for line in _nonempty_lines(text):
            match = re.match(r"^\s*(\d{1,3})\s*[:.)-]\s*(.+?)\s*$", line)
            if not match:
                continue
            code = match.group(1).strip()
            label = normalise_whitespace(match.group(2))
            if not label or len(label) > 120:
                continue
            key = (code, label.casefold())
            if key in seen:
                continue
            seen.add(key)
            items.append({"code": code, "label": label})
        return items

    def _extract_inline_enumerated_items(self, text: str) -> list[dict[str, str]]:
        items: list[dict[str, str]] = []
        seen: set[tuple[str, str]] = set()
        inline_text = normalise_whitespace(text)
        for code, label in re.findall(
            r"(?<![A-Za-z0-9])(\d{1,3})\s*[:.)-]\s*([A-Za-z][A-Za-z0-9/&(), \-]{1,90}?)(?=(?:\s+[A-Z]\d{3}\b)|(?:\s+[a-z]{2,5}:[A-Za-z])|(?:\s+\d{1,3}\s*[:.)-])|$)",
            inline_text,
        ):
            cleaned_label = normalise_whitespace(label).strip(" -:;,.")
            if not cleaned_label or len(cleaned_label) > 90:
                continue
            key = (code.strip(), cleaned_label.casefold())
            if key in seen:
                continue
            seen.add(key)
            items.append({"code": code.strip(), "label": cleaned_label})
        return items

    def _enumeration_topic_terms(self, question: str) -> set[str]:
        normalized_question = _normalize(question)
        ignored_terms = {
            "all",
            "are",
            "code",
            "codes",
            "corresponds",
            "different",
            "document",
            "give",
            "inpdec",
            "in",
            "is",
            "listed",
            "list",
            "pdf",
            "the",
            "to",
            "valid",
            "what",
            "which",
        }
        return {
            token
            for token in re.findall(r"\b[a-z0-9][a-z0-9/&._:-]{2,}\b", normalized_question)
            if token not in ignored_terms and token not in GROUNDING_STOPWORDS
        }

    def _looks_like_structural_label(self, label: str) -> bool:
        normalized_label = _normalize(label)
        if not normalized_label:
            return True
        if any(token in normalized_label for token in ("official", "closed", " doc ", " document ", "prepared by")):
            return True
        if normalized_label in {
            "message definition",
            "message details",
            "header section",
            "introduction",
            "scope",
            "references",
            "definitions and abbreviations",
        }:
            return True
        tokens = [token for token in re.findall(r"\b[a-z][a-z]+\b", normalized_label)]
        if not tokens:
            return False
        if len(tokens) > 4:
            return False
        return label.strip() == label.strip().upper()

    def _structured_enumeration_evidence(
        self,
        question: str,
        retrieval: list[dict[str, Any]],
        sections: list[dict[str, Any]],
        chunks: list[dict[str, Any]],
        answer_sections: list[dict[str, Any]],
        selected_chunks: list[dict[str, Any]],
    ) -> dict[str, Any] | None:
        wants_list = self._is_list_request(question)
        requested_code = self._requested_code(question)
        if not wants_list and not requested_code:
            return None

        topic_terms = self._enumeration_topic_terms(question)
        if not topic_terms and not requested_code:
            return None

        target_document_name = next(
            (
                str(item.get("documentName", "")).strip()
                for item in [*selected_chunks, *answer_sections, *retrieval]
                if str(item.get("documentName", "")).strip()
            ),
            "",
        )
        if not target_document_name:
            return None

        target_document_normalized = _normalize(target_document_name)
        scored_anchor_records: list[tuple[int, float, dict[str, Any]]] = []
        for item in retrieval[:20]:
            if _normalize(str(item.get("documentName", "")).strip()) != target_document_normalized:
                continue
            structure_text = _normalize(
                " ".join(
                    [
                        str(item.get("title", "")),
                        str(item.get("heading", "")),
                        str(item.get("matchedField", "")),
                        str(item.get("matchedHeading", "")),
                        " ".join(str(field) for field in item.get("fieldNames", [])),
                    ]
                )
            )
            topic_score = sum(1 for term in topic_terms if term in structure_text)
            if topic_terms and topic_score <= 0:
                continue
            item_text = _normalize(
                " ".join(
                    [
                        structure_text,
                        str(item.get("text", "")),
                        " ".join(str(field) for field in item.get("fieldNames", [])),
                    ]
                )
            )
            if str(item.get("type", "")).lower() == "chunk" and (
                len([page for page in item.get("sourcePages", []) if str(page).isdigit()]) > 2
                or len(str(item.get("text", ""))) > 500
            ):
                continue
            scored_anchor_records.append((topic_score, float(item.get("score", 0.0)), item))

        scored_anchor_records.sort(key=lambda value: (value[0], value[1]), reverse=True)
        if not scored_anchor_records:
            return None
        top_topic_score = scored_anchor_records[0][0]
        anchor_records = [
            item
            for topic_score, _score, item in scored_anchor_records
            if topic_score >= max(1, top_topic_score)
        ][:8]

        anchor_text = _normalize(
            " ".join(
                " ".join(
                    [
                        str(item.get("title", "")),
                        str(item.get("heading", "")),
                        str(item.get("matchedField", "")),
                        str(item.get("matchedHeading", "")),
                        str(item.get("text", "")),
                    ]
                )
                for item in anchor_records
            )
        )
        if not anchor_records or not any(
            phrase in anchor_text
            for phrase in ("valid code", "valid codes", "mode code", "codes are", "transport mode")
        ):
            return None

        page_counts: Counter[int] = Counter()
        for item in anchor_records:
            for page in item.get("sourcePages", []):
                if str(page).isdigit():
                    page_counts[int(page)] += 1
        if not page_counts:
            return None

        top_page_count = max(page_counts.values())
        focus_pages = {
            page
            for page, count in page_counts.items()
            if count >= max(1, top_page_count - 1)
        } or {page for page, _count in page_counts.most_common(2)}

        candidate_sections = [
            section
            for section in sections
            if _normalize(str(section.get("documentName", "")).strip()) == target_document_normalized
            and focus_pages.intersection(
                {
                    int(page)
                    for page in section.get("sourcePages", [])
                    if str(page).isdigit()
                }
            )
        ]
        if not candidate_sections:
            return None

        enumerated_items: list[dict[str, Any]] = []
        for section in candidate_sections:
            raw_text = str(section.get("rawText", ""))
            lines = _nonempty_lines(raw_text)
            is_compact_section = bool(lines) and len(lines) <= 3 and max((len(line) for line in lines), default=0) <= 80
            if not is_compact_section:
                continue
            for item in self._extract_enumerated_items(raw_text):
                if self._looks_like_structural_label(str(item.get("label", ""))):
                    continue
                enumerated_items.append(
                    {
                        **item,
                        "section": section,
                        "pages": [int(page) for page in section.get("sourcePages", []) if str(page).isdigit()],
                    }
                )

        for anchor_record in anchor_records:
            anchor_text_value = " ".join(
                [
                    str(anchor_record.get("title", "")),
                    str(anchor_record.get("heading", "")),
                    str(anchor_record.get("matchedField", "")),
                    str(anchor_record.get("matchedHeading", "")),
                    str(anchor_record.get("text", "")),
                    " ".join(str(field) for field in anchor_record.get("fieldNames", [])),
                ]
            )
            normalized_anchor_text = _normalize(anchor_text_value)
            if topic_terms and not any(term in normalized_anchor_text for term in topic_terms):
                continue
            anchor_items: list[dict[str, str]] = []
            for snippet in re.findall(
                r"(?:valid\s+codes?(?:\s*\([^)]*\))?\s+are\s*:?\s*)(.{0,220})",
                str(anchor_record.get("text", "")),
                flags=re.IGNORECASE | re.DOTALL,
            ):
                anchor_items.extend(self._extract_inline_enumerated_items(snippet))
            if not anchor_items:
                anchor_items = self._extract_inline_enumerated_items(str(anchor_record.get("text", "")))
            if not anchor_items:
                continue
            for anchor_item in anchor_items:
                if self._looks_like_structural_label(str(anchor_item.get("label", ""))):
                    continue
                enumerated_items.append(
                    {
                        **anchor_item,
                        "section": {
                            "id": anchor_item["code"],
                            "title": anchor_item["label"],
                            "chapterNumber": next((section.get("chapterNumber", "") for section in answer_sections if str(section.get("documentName", "")).strip() == target_document_name), ""),
                            "chapterTitle": next((section.get("chapterTitle", "") for section in answer_sections if str(section.get("documentName", "")).strip() == target_document_name), ""),
                            "documentName": target_document_name,
                            "summary": anchor_item["label"],
                            "businessMeaning": "",
                            "businessExplanation": "",
                            "requiredDocuments": [],
                            "documents": [],
                            "notes": [],
                            "validations": [],
                            "exceptions": [],
                            "definitions": [],
                            "timelines": [],
                            "authorities": [],
                            "workflow": [],
                            "sourcePages": [int(page) for page in anchor_record.get("sourcePages", []) if str(page).isdigit()],
                            "rawText": str(anchor_record.get("text", "")),
                        },
                        "pages": [int(page) for page in anchor_record.get("sourcePages", []) if str(page).isdigit()],
                    }
                )

        if not enumerated_items:
            return None

        deduped_items: list[dict[str, Any]] = []
        seen_item_keys: set[tuple[str, str]] = set()
        for item in sorted(
            enumerated_items,
            key=lambda value: (
                int(value["code"]) if str(value.get("code", "")).isdigit() else 9999,
                str(value.get("label", "")).casefold(),
            ),
        ):
            key = (str(item.get("code", "")).strip(), str(item.get("label", "")).casefold())
            if key in seen_item_keys:
                continue
            seen_item_keys.add(key)
            deduped_items.append(item)

        if wants_list and len(deduped_items) < 2:
            return None

        matched_items = deduped_items
        if requested_code:
            matched_items = [item for item in deduped_items if str(item.get("code", "")).strip() == requested_code]
            if not matched_items:
                return None

        matched_sections: list[dict[str, Any]] = []
        matched_chunks: list[dict[str, Any]] = []
        seen_sections: set[tuple[str, str]] = set()
        for item in matched_items:
            section_payload = dict(item["section"])
            section_key = (str(item["code"]).strip(), str(item["label"]).casefold())
            if section_key not in seen_sections:
                seen_sections.add(section_key)
                section_payload["id"] = str(item["code"]).strip()
                section_payload["title"] = str(item["label"]).strip()
                section_payload["summary"] = str(item["label"]).strip()
                section_payload["businessMeaning"] = ""
                section_payload["businessExplanation"] = ""
                section_payload["sourcePages"] = list(item["pages"])
                section_payload["rawText"] = f'{item["code"]}: {item["label"]}'
                matched_sections.append(section_payload)
            matched_chunks.append(
                {
                    "id": f'enum-{item["code"]}-{re.sub(r"[^a-z0-9]+", "-", str(item["label"]).casefold()).strip("-")}',
                    "type": "chunk",
                    "entityType": "chunk",
                    "documentName": target_document_name,
                    "sectionId": str(item["code"]).strip(),
                    "title": str(item["label"]).strip(),
                    "heading": str(item["label"]).strip(),
                    "fieldNames": [str(item["label"]).strip()],
                    "sourcePages": list(item["pages"]),
                    "text": f'{item["code"]}: {item["label"]}',
                }
            )
        evidence_lines = [f'{item["code"]}: {item["label"]}' for item in matched_items]

        if requested_code:
            answer_text = f'According to the selected document, code {requested_code} corresponds to {matched_items[0]["label"]}.'
        else:
            formatted_items = [f'{item["code"]}. {item["label"]}' for item in matched_items]
            answer_text = f'According to the selected document, the listed values are {_natural_list(formatted_items, limit=len(formatted_items))}.'

        return {
            "answerText": answer_text,
            "evidenceLines": evidence_lines,
            "sections": matched_sections,
            "chunks": matched_chunks,
            "items": matched_items,
        }

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
            text = _remove_extraction_noise(chunk.get("text", ""))
            if not text:
                continue
            for bullet in self._bulletize_text(text, limit=limit):
                if _is_extractive_sentence(bullet):
                    continue
                lowered = bullet.casefold()
                if lowered in seen:
                    continue
                seen.add(lowered)
                bullets.append(bullet)
                if len(bullets) >= limit:
                    return bullets
        return bullets

    def _evidence_sentences(self, question: str, selected_chunks: list[dict[str, Any]], limit: int = 3) -> list[str]:
        question_terms = {
            token
            for token in re.findall(r"\b[a-z0-9][a-z0-9/&._:-]{2,}\b", _normalize(question))
            if token not in GROUNDING_STOPWORDS
        }
        scored: list[tuple[int, str]] = []
        seen: set[str] = set()
        for chunk in selected_chunks:
            candidates = [
                _clean_evidence_item(chunk.get("description", ""), 220),
                *[_clean_evidence_item(sentence, 220) for sentence in _split_sentences(chunk.get("text", ""))[:5]],
            ]
            for candidate in candidates:
                if not candidate:
                    continue
                lowered = candidate.casefold()
                if lowered in seen:
                    continue
                seen.add(lowered)
                overlap = len([term for term in question_terms if term in lowered])
                scored.append((overlap, candidate))
        scored.sort(key=lambda item: (item[0], len(item[1])), reverse=True)
        return [sentence for _score, sentence in scored[:limit]]

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

        cleaned = _clean_evidence_item(best_text, 260)
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
        question_targets_condition_list = question_targets_list and any(
            token in normalized_question
            for token in ("condition", "conditions", "criteria", "eligibility", "requirement", "requirements", "rule", "rules")
        )

        clean_conditions = _unique([_clean_evidence_item(item, 220) for item in condition_items if _clean_evidence_item(item, 220)])
        clean_exceptions = _unique([_clean_evidence_item(item, 220) for item in exception_items if _clean_evidence_item(item, 220)])
        clean_rules = _unique([_clean_evidence_item(item, 220) for item in business_logic if _clean_evidence_item(item, 220)])
        clean_documents = _unique([_clean_evidence_item(item, 180) for item in required_documents if _clean_evidence_item(item, 180)])
        clean_workflow = _unique([_clean_evidence_item(item, 220) for item in workflow_steps if _clean_evidence_item(item, 220)])

        if question_targets_condition_list and clean_conditions:
            return f"The key conditions mentioned are {_natural_list(clean_conditions, limit=6)}."
        if question_targets_documents and clean_documents:
            return f"The required documents mentioned are {_natural_list(clean_documents, limit=6)}."
        if question_targets_workflow and clean_workflow:
            return f"The process described is {_natural_list(clean_workflow, limit=6)}."
        if question_targets_conditions and clean_conditions:
            return f"The main conditions mentioned are {_natural_list(clean_conditions, limit=6)}."
        if question_targets_exceptions and clean_exceptions:
            return f"The exceptions or exemptions mentioned are {_natural_list(clean_exceptions, limit=6)}."
        if question_targets_rules and clean_rules:
            return f"The main rules described are {_natural_list(clean_rules, limit=6)}."

        focused_chunk_answer = self._focused_chunk_answer(question, selected_chunks)
        if focused_chunk_answer:
            return focused_chunk_answer

        section_summaries = _unique(
            [
                *[_clean_evidence_item(section.get("summary", ""), 240) for section in answer_sections if _clean_evidence_item(section.get("summary", ""), 240)],
                *[_clean_evidence_item(section.get("businessMeaning", ""), 220) for section in answer_sections if _clean_evidence_item(section.get("businessMeaning", ""), 220)],
                *[_clean_evidence_item(section.get("businessExplanation", ""), 240) for section in answer_sections if _clean_evidence_item(section.get("businessExplanation", ""), 240)],
            ]
        )
        evidence_sentences = self._evidence_sentences(question, selected_chunks, limit=3)
        if section_summaries or evidence_sentences:
            answer_parts = [*section_summaries[:2], *evidence_sentences[:1]]
            return " ".join(_ensure_sentence(part) for part in answer_parts if part).strip()

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
        return body

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
                *[_clean_evidence_item(_first_sentence(section.get("summary", ""), 260), 260) for section in answer_sections if section.get("summary")],
                *[_clean_evidence_item(_first_sentence(section.get("businessMeaning", ""), 220), 220) for section in answer_sections if section.get("businessMeaning")],
                *[_clean_evidence_item(_first_sentence(section.get("businessExplanation", ""), 240), 240) for section in answer_sections if section.get("businessExplanation")],
                *self._evidence_sentences(question, selected_chunks, limit=2),
            ]
        )
        if not any(summary_points):
            return "I found related content in the selected document, but there is not enough extracted text to produce a grounded answer."

        blocks: list[str] = []
        if _contains_any(normalized_question, WORKFLOW_PATTERNS) or plan.intent in {"Import Procedure", "Export Procedure"}:
            blocks.append("This topic is explained across the selected document as a combined process.")
            blocks.append(" ".join(_ensure_sentence(point) for point in summary_points[:3] if point))
            if workflow_steps:
                clean_workflow = [_clean_evidence_item(step, 180) for step in workflow_steps if _clean_evidence_item(step, 180)]
                if clean_workflow:
                    blocks.append(f"The process steps are {_natural_list(clean_workflow, limit=6)}.")
            if condition_items:
                clean_conditions = [_clean_evidence_item(item, 180) for item in condition_items if _clean_evidence_item(item, 180)]
                if clean_conditions:
                    blocks.append(f"The key requirements are {_natural_list(clean_conditions, limit=6)}.")
            if required_documents:
                clean_documents = [_clean_evidence_item(item, 160) for item in required_documents if _clean_evidence_item(item, 160)]
                if clean_documents:
                    blocks.append(f"The related documents mentioned are {_natural_list(clean_documents, limit=6)}.")
        else:
            blocks.append(" ".join(_ensure_sentence(point) for point in summary_points[:3] if point))
            if condition_items:
                clean_conditions = [_clean_evidence_item(item, 180) for item in condition_items if _clean_evidence_item(item, 180)]
                if clean_conditions:
                    blocks.append(f"The key requirements are {_natural_list(clean_conditions, limit=6)}.")
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
        normalized_source_pages = sorted(
            {
                int(page)
                for page in source_pages
                if str(page).isdigit()
            }
        )
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
            "sourcePages": normalized_source_pages,
            "sourceChapter": relevant_chapters[0] if relevant_chapters else "",
            "sourceSection": relevant_sections[0] if relevant_sections else "",
            "sourceHeading": source_heading,
            "sources": self._source_entries(answer_sections, selected_chunks),
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
                    snippet = _clean_evidence_item(text[max(0, match.start() - 60) : min(len(text), match.end() + 80)], 180)
                    if not snippet:
                        continue
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
                response_blocks.append("The relevant information is grounded in the source section listed below.")
            elif relevant_sections:
                response_blocks.append("The relevant information is grounded in the source section listed below.")
            elif source_pdfs:
                response_blocks.append("The relevant information is grounded in the selected uploaded document.")

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
                return structured, source_payload
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

    def _is_follow_up_question(self, question: str) -> bool:
        normalized_question = _normalize(question)
        if not normalized_question:
            return False
        follow_up_markers = (
            "and what about",
            "based on that",
            "continue",
            "does it",
            "for this",
            "from that",
            "how about",
            "in that case",
            "same for",
            "that field",
            "that section",
            "that one",
            "this field",
            "this section",
            "what about",
            "what does that",
            "what does this",
            "what is the validation",
            "which page",
        )
        if any(marker in normalized_question for marker in follow_up_markers):
            return True
        tokens = re.findall(r"\b[a-z0-9][a-z0-9/&._:-]*\b", normalized_question)
        referential_tokens = {"it", "its", "that", "this", "they", "them", "those", "these", "same"}
        return len(tokens) <= 8 and any(token in referential_tokens for token in tokens)

    def _resolve_question(self, question: str, conversation_turns: list[dict[str, Any]]) -> str:
        cleaned_question = " ".join((question or "").split()).strip()
        if not cleaned_question or not conversation_turns or not self._is_follow_up_question(cleaned_question):
            return cleaned_question

        previous_turn = conversation_turns[-1]
        previous_question = " ".join(str(previous_turn.get("question", "")).split()).strip()
        metadata = previous_turn.get("metadata", {}) if isinstance(previous_turn.get("metadata"), dict) else {}
        source_hints = _unique(
            [
                str(metadata.get("documentName", "")).strip(),
                str(metadata.get("sourceChapter", "")).strip(),
                str(metadata.get("sourceSection", "")).strip(),
                str(metadata.get("title", "")).strip(),
            ]
        )
        hint_text = " | ".join(hint for hint in source_hints if hint)
        if not previous_question:
            return cleaned_question
        if hint_text:
            return f"{cleaned_question}\n\nFollow-up context from the previous turn:\nQuestion: {previous_question}\nSource: {hint_text}"
        return f"{cleaned_question}\n\nFollow-up context from the previous turn:\nQuestion: {previous_question}"

    def _format_conversation_turns(self, conversation_turns: list[dict[str, Any]]) -> str:
        if not conversation_turns:
            return "None"
        lines: list[str] = []
        for turn in conversation_turns[-3:]:
            question = " ".join(str(turn.get("question", "")).split()).strip()
            answer = _clean(str(turn.get("answer", "")).strip(), 220)
            metadata = turn.get("metadata", {}) if isinstance(turn.get("metadata"), dict) else {}
            source = " | ".join(
                value
                for value in [
                    str(metadata.get("documentName", "")).strip(),
                    str(metadata.get("sourceSection", "")).strip(),
                ]
                if value
            )
            lines.append(f"- User: {question or 'Not available'}")
            if answer:
                lines.append(f"  Assistant: {answer}")
            if source:
                lines.append(f"  Source: {source}")
        return "\n".join(lines) if lines else "None"

    def _chunks_for_sections_from_index(self, chunks: list[dict[str, Any]], section_keys: set[str], limit: int = 10) -> list[dict[str, Any]]:
        matches = [chunk for chunk in chunks if self._record_section_key(chunk) in section_keys]
        matches.sort(
            key=lambda item: (
                0 if item.get("fieldNames") else 1,
                int(bool(item.get("heading"))),
                len(str(item.get("text", ""))),
            ),
            reverse=True,
        )
        return matches[:limit]

    def _llm_context(
        self,
        *,
        question: str,
        resolved_question: str,
        plan: RetrievalPlan,
        answer_sections: list[dict[str, Any]],
        selected_chunks: list[dict[str, Any]],
        section_rules: list[dict[str, Any]],
        section_conditions: list[dict[str, Any]],
        section_workflows: list[dict[str, Any]],
        section_examples: list[dict[str, Any]],
        required_documents: list[str],
        important_notes: list[str],
        business_logic: list[str],
        workflow_steps: list[str],
        condition_items: list[str],
        exception_items: list[str],
        seed_answer: str,
        structured_evidence_lines: list[str],
        source_payload: dict[str, Any],
        conversation_turns: list[dict[str, Any]],
        include_full_section_text: bool,
    ) -> str:
        source_lines: list[str] = []
        for source in source_payload.get("sources", []):
            pages = ", ".join(str(page) for page in source.get("pageNumbers", [])) or "Not available"
            source_lines.append(
                f'- Document: {source.get("documentName", "") or "Not available"} | Chapter: {source.get("chapter", "") or "Not available"} | '
                f'Section: {source.get("section", "") or "Not available"} | Pages: {pages}'
            )

        section_blocks: list[str] = []
        for section in answer_sections[:3]:
            definition_lines = [
                f'- {definition.get("term", "")}: {_clean(definition.get("definition", ""), 200)}'
                for definition in section.get("definitions", [])[:4]
                if definition.get("term") and definition.get("definition")
            ]
            rule_lines = [
                f'- {_clean(rule.get("description", ""), 220)}'
                for rule in section_rules
                if self._record_section_key(rule) == self._section_record_key(section) and rule.get("description")
            ][:5]
            condition_lines = [
                f'- {_clean(condition.get("text", ""), 220)}'
                for condition in section_conditions
                if self._record_section_key(condition) == self._section_record_key(section) and condition.get("text")
            ][:5]
            workflow_lines = [
                f"- {step}"
                for workflow in section_workflows
                if self._section_key(workflow.get("section", ""), workflow.get("documentName", "")) == self._section_record_key(section)
                for step in workflow.get("steps", [])[:6]
            ][:6]
            example_lines = [
                f'- {_clean(example.get("text", ""), 220)}'
                for example in section_examples
                if self._record_section_key(example) == self._section_record_key(section) and example.get("text")
            ][:3]
            raw_text = _preserve_text(section.get("rawText", ""))
            if not include_full_section_text:
                raw_text = _clean(raw_text, 2200)
            section_blocks.append(
                "\n".join(
                    [
                        f'Document: {section.get("documentName", "")}',
                        f'Chapter: {_chapter_label(section)}',
                        f'Section: {_section_label(section)}',
                        f'Pages: {", ".join(str(page) for page in section.get("sourcePages", [])) or "Not available"}',
                        f'Summary: {_clean(section.get("summary", ""), 360)}',
                        f'Business Meaning: {_clean(section.get("businessMeaning", ""), 320)}',
                        f'Business Explanation: {_clean(section.get("businessExplanation", ""), 360)}',
                        "Definitions:\n" + ("\n".join(definition_lines) if definition_lines else "- None"),
                        "Notes:\n" + (_bullet_lines(section.get("notes", []), limit=5) or "- None"),
                        "Validations:\n" + (_bullet_lines(section.get("validations", []), limit=6) or "- None"),
                        "Required Documents:\n" + (_bullet_lines(section.get("requiredDocuments", []), limit=6) or "- None"),
                        "Business Rules:\n" + ("\n".join(rule_lines) if rule_lines else "- None"),
                        "Conditions:\n" + ("\n".join(condition_lines) if condition_lines else "- None"),
                        "Workflow:\n" + ("\n".join(workflow_lines) if workflow_lines else "- None"),
                        "Examples:\n" + ("\n".join(example_lines) if example_lines else "- None"),
                        "Section Text:\n" + (raw_text or "Not available"),
                    ]
                )
            )

        chunk_blocks: list[str] = []
        for chunk in selected_chunks[:8]:
            field_names = ", ".join(str(field) for field in chunk.get("fieldNames", [])[:8]) or "Not available"
            chunk_blocks.append(
                "\n".join(
                    [
                        f'Chunk Id: {chunk.get("id", "")}',
                        f'Document: {chunk.get("documentName", "")}',
                        f'Section: {chunk.get("sectionId", "")}',
                        f'Heading: {chunk.get("heading", "") or "Not available"}',
                        f'Fields: {field_names}',
                        f'Text: {_clean(_preserve_text(chunk.get("text", "")), 1200)}',
                    ]
                )
            )

        return "\n\n".join(
            [
                f"Original user question:\n{question}",
                f"Resolved retrieval question:\n{resolved_question}",
                f"Detected intent:\n{plan.intent} | Topic: {plan.topic}",
                "Conversation memory:\n" + self._format_conversation_turns(conversation_turns),
                "Retrieved sources:\n" + ("\n".join(source_lines) if source_lines else "None"),
                "Helpful retrieval draft answer:\n" + (seed_answer or "None"),
                "Structured list/code evidence:\n" + (_bullet_lines(structured_evidence_lines, limit=12) or "- None"),
                "Workflow steps:\n" + (_bullet_lines(workflow_steps, limit=6) or "- None"),
                "Conditions:\n" + (_bullet_lines(condition_items, limit=6) or "- None"),
                "Exceptions:\n" + (_bullet_lines(exception_items, limit=6) or "- None"),
                "Business logic:\n" + (_bullet_lines(business_logic, limit=6) or "- None"),
                "Important notes:\n" + (_bullet_lines(important_notes, limit=8) or "- None"),
                "Required documents:\n" + (_bullet_lines(required_documents, limit=6) or "- None"),
                "Retrieved sections:\n\n" + ("\n\n---\n\n".join(section_blocks) if section_blocks else "None"),
                "Retrieved chunks:\n\n" + ("\n\n---\n\n".join(chunk_blocks) if chunk_blocks else "None"),
            ]
        )

    def _llm_system_prompt(self, language: str) -> str:
        target_language = language if language in SUPPORTED_LANGUAGES else "English"
        return "\n".join(
            [
                "You are DEKAI's answer generation layer in a retrieval-augmented system.",
                "Use only the retrieved context you are given. Never use outside knowledge.",
                f'If the answer is not supported by the retrieved context, reply exactly: "{MISSING_INFORMATION_MESSAGE}"',
                "Do not guess. Do not hallucinate. Do not invent examples, rules, pages, section numbers, or business meaning.",
                "If a requested detail is missing from the context, omit it instead of inventing it.",
                "For list or enumeration questions, include all matching items supported by the retrieved context, not just the first matching item.",
                "For code lookup questions, return only the code-to-value mapping explicitly supported by the retrieved context.",
                "Keep the answer grounded in the retrieved documents and cite the source information only when present in the context.",
                f"Answer in {target_language}. If the target language is English, use simple English.",
                "When the context supports it, structure the answer with these headings in this order:",
                "1. Simple Explanation",
                "2. Business Meaning",
                "3. Step-by-Step Explanation",
                "4. Practical Example",
                "5. Validation Notes",
                "6. Source",
            ]
        )

    def _provider_error_answer(
        self,
        *,
        question: str,
        plan: RetrievalPlan,
        ai_model: str,
        language: str,
        message: str,
        answer: dict[str, Any] | None = None,
    ) -> dict[str, Any]:
        payload = dict(answer or self._empty_answer(question, plan, ai_model=ai_model, language=language))
        payload["directAnswer"] = message
        payload["modelUsed"] = ai_model
        payload["languageUsed"] = language
        return payload

    def _prepare_answer_bundle(
        self,
        question: str,
        *,
        ai_model: str = "",
        language: str = "English",
        user_email: str = "",
        conversation_id: str = "",
    ) -> dict[str, Any]:
        retrieval_started = perf_counter()
        index = knowledge_engine_service.load_index()
        ready_documents = self._ready_documents(index)
        failed_documents = self._failed_documents()
        conversation_turns = conversation_service.recent_turns(user_email, conversation_id)
        resolved_question = self._resolve_question(question, conversation_turns)
        failed_document_match = self._match_failed_document(resolved_question, failed_documents)
        plan = retrieval_decision_service.detect_intent(resolved_question)
        target_ready_document = self._match_ready_document(resolved_question, ready_documents)
        ready_document_count = len([document for document in index.get("documents", []) if str(document.get("status", "ready")) == "ready"])

        def _skip(answer: dict[str, Any], decision: str, search_debug: dict[str, Any] | None = None, final_context_documents: list[str] | None = None) -> dict[str, Any]:
            return {
                "skipLlm": True,
                "answer": answer,
                "plan": plan,
                "retrieval": [],
                "selectedChunks": [],
                "decision": decision,
                "searchDebug": search_debug or {},
                "finalContextDocuments": final_context_documents or answer.get("sourcePdfs", []),
                "resolvedQuestion": resolved_question,
                "conversationTurns": conversation_turns,
                "retrievalTimeMs": round((perf_counter() - retrieval_started) * 1000, 2),
            }

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
            return _skip(
                answer,
                "Blocked answer because the question targeted a failed document or no document is currently Knowledge Ready.",
                final_context_documents=[str(blocked_document.get("name", "")).strip()],
            )

        if plan.needs_clarification:
            answer = self._empty_answer(
                question,
                plan,
                direct_answer=plan.clarification_message,
                business_explanation="If the relevant HS Master is available, DEKAI will search only the selected document after you provide product-specific details.",
                ai_model=ai_model,
                language=language,
            )
            return _skip(
                answer,
                "HS code intent detected without product description or existing code. Asked for clarification instead of searching unrelated sources.",
            )

        current_ready_document = None
        allowed_document_names: list[str] = []
        retrieval: list[dict[str, Any]] = []
        search_debug: dict[str, Any] = {}
        selected_scope_label = "selected_document"
        selected_document = None
        document_selection_debug: dict[str, Any] = {"selectionMethod": "none", "rankedDocuments": []}
        structured_evidence_lines: list[str] = []

        current_document_name = getattr(self, "_current_document_name", "")
        if current_document_name:
            current_ready_document = self._find_ready_document_by_name(current_document_name, ready_documents)

        if plan.intent == TRADE_NET_XML_FIELD_INTENT:
            selected_scope_label = "trade_net_xml_field"
            trade_net_documents = self._trade_net_ready_documents(ready_documents)
            if current_ready_document and self._is_trade_net_document(str(current_ready_document.get("name", ""))):
                selected_document = current_ready_document
            elif trade_net_documents:
                selected_document = trade_net_documents[0]
            if selected_document:
                selected_document_name = str(selected_document.get("name", "")).strip()
                retrieval, search_debug, locked_document_name = self._retrieve_trade_net_field_grounding(
                    resolved_question,
                    plan,
                    trade_net_document_names=[selected_document_name],
                    scope_label=selected_scope_label,
                )
                effective_document_name = locked_document_name or selected_document_name
                allowed_document_names = [effective_document_name] if effective_document_name else []
                search_debug["selected_document"] = effective_document_name
                document_selection_debug = {
                    "selectionMethod": "trade_net_xml_lock",
                    "rankedDocuments": [
                        {
                            "name": effective_document_name,
                            "score": 99999.0,
                            "reasons": ["trade_net_xml_field"],
                        }
                    ],
                }
            else:
                document_selection_debug = {
                    "selectionMethod": "trade_net_unavailable",
                    "rankedDocuments": [],
                }
        else:
            selected_document, document_selection_debug = self._select_best_document(
                question=resolved_question,
                plan=plan,
                ready_documents=ready_documents,
                explicit_document=target_ready_document,
                current_document=current_ready_document,
            )
            if selected_document:
                selected_document_name = str(selected_document.get("name", "")).strip()
                allowed_document_names = [selected_document_name] if selected_document_name else []
                retrieval, search_debug = self._retrieve_grounding(
                    resolved_question,
                    plan,
                    scope_label=selected_scope_label,
                    target_document_name=selected_document_name,
                    document_names=allowed_document_names,
                    collection_filters=None,
                )

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

        hierarchy_answer_payload = None
        if plan.intent == "Section Request" or is_xml_field_query(resolved_question):
            hierarchy_answer_payload = self._hierarchical_answer_payload(
                resolved_question,
                plan,
                sections,
                allowed_document_names=allowed_document_names,
            )

        iec_definition_payload = self._iec_definition_payload(resolved_question, sections, allowed_document_names)
        definition_answer_payload = self._definition_answer_payload(
            resolved_question,
            sections,
            definitions,
            retrieval,
            target_document_name=allowed_document_names[0] if allowed_document_names else "",
        )
        document_identity_payload = self._document_identity_answer_payload(resolved_question, sections, allowed_document_names)

        confidence_score = 0.0
        answer_sections: list[dict[str, Any]] = []
        selected_chunks: list[dict[str, Any]] = []
        answer_title = ""
        seed_answer = ""

        if hierarchy_answer_payload:
            section = hierarchy_answer_payload.get("section", {}) or {}
            if section:
                answer_sections = [section]
                answer_title = str(hierarchy_answer_payload.get("title", "") or section.get("title", "")).strip()
                seed_answer = str(hierarchy_answer_payload.get("directAnswer", "")).strip()
                confidence_score = float(hierarchy_answer_payload.get("confidenceScore", 0.0))
                selected_chunks = self._chunks_for_sections_from_index(chunks, {self._section_record_key(section)})
        elif iec_definition_payload:
            section = iec_definition_payload.get("section", {}) or {}
            if section:
                answer_sections = [section]
                answer_title = str(section.get("title", "") or "IEC").strip()
                seed_answer = str(iec_definition_payload.get("answer", "")).strip()
                confidence_score = 0.96
                selected_chunks = self._chunks_for_sections_from_index(chunks, {self._section_record_key(section)})
        elif definition_answer_payload:
            section = definition_answer_payload.get("section", {}) or {}
            if section:
                answer_sections = [section]
                answer_title = str(section.get("title", "") or definition_answer_payload.get("term", "")).strip()
                seed_answer = f'{definition_answer_payload.get("term", "")}: {definition_answer_payload.get("definition", "")}'.strip()
                confidence_score = 0.96
                selected_chunks = self._chunks_for_sections_from_index(chunks, {self._section_record_key(section)})
        elif document_identity_payload:
            section = document_identity_payload.get("section", {}) or {}
            if section:
                answer_sections = [section]
                answer_title = str(section.get("title", "") or document_identity_payload.get("documentName", "")).strip()
                seed_answer = str(document_identity_payload.get("answer", "")).strip()
                confidence_score = 0.92
                selected_chunks = self._chunks_for_sections_from_index(chunks, {self._section_record_key(section)})

        full_content_request = self._is_full_content_request(resolved_question, plan)
        if not answer_sections:
            answer_sections, confidence_score = self._pick_sections(retrieval, sections, plan)
            if full_content_request:
                full_content_sections = self._full_content_sections(resolved_question, plan, retrieval, sections, allowed_document_names)
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
            if answer_sections and not self._has_grounded_evidence(resolved_question, retrieval, answer_sections):
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
            answer["questionUnderstood"] = plan.question_understood
            return _skip(
                answer,
                "Rejected answer because the selected document did not contain a sufficiently grounded matching section.",
                search_debug=search_debug,
                final_context_documents=allowed_document_names,
            )

        primary_section = answer_sections[0]
        section_keys = {self._section_record_key(section) for section in answer_sections if self._section_record_key(section)}
        if not selected_chunks:
            selected_chunks = self._section_chunks(retrieval, chunks, section_keys)
        if not selected_chunks:
            selected_chunks = self._chunks_for_sections_from_index(chunks, section_keys)

        heading_target_chunk = self._best_heading_chunk(resolved_question, selected_chunks)
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
                if plan.intent == TRADE_NET_XML_FIELD_INTENT:
                    selected_chunks = [heading_target_chunk]

        structured_enumeration = self._structured_enumeration_evidence(
            resolved_question,
            retrieval,
            sections,
            chunks,
            answer_sections,
            selected_chunks,
        )
        if structured_enumeration:
            answer_sections = structured_enumeration["sections"] or answer_sections
            if answer_sections:
                primary_section = answer_sections[0]
                section_keys = {
                    self._section_record_key(section)
                    for section in answer_sections
                    if self._section_record_key(section)
                }
            selected_chunks = structured_enumeration["chunks"] or selected_chunks
            seed_answer = structured_enumeration["answerText"]
            structured_evidence_lines = structured_enumeration["evidenceLines"]

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
        if hierarchy_answer_payload and plan.intent == TRADE_NET_XML_FIELD_INTENT and hierarchy_answer_payload.get("sourcePages"):
            source_pages = _unique([str(page) for page in hierarchy_answer_payload.get("sourcePages", []) if str(page).strip()])

        definitions_text = []
        for section in answer_sections:
            for definition in section.get("definitions", [])[:4]:
                term = str(definition.get("term", "")).strip()
                meaning = str(definition.get("definition", "")).strip()
                if term and meaning:
                    definitions_text.append(f"{term}: {_clean(meaning, 180)}")

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
                *definitions_text[:3],
                *[
                    _clean(" | ".join(str(cell) for cell in row), 220)
                    for section in answer_sections
                    for row in section.get("tables", [])[:2]
                ],
                *[_clean(timeline, 200) for section in answer_sections for timeline in section.get("timelines", [])[:3]],
                *[_clean(authority, 180) for section in answer_sections for authority in section.get("authorities", [])[:3]],
            ]
        )[:8]
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

        source_payload = self._source_payload(
            answer_sections=answer_sections,
            relevant_chapters=relevant_chapters,
            relevant_sections=relevant_sections,
            source_pdfs=source_pdfs,
            source_pages=source_pages,
            selected_chunks=selected_chunks,
        )
        if not seed_answer:
            seed_answer, source_payload = self._intent_response(
                question=resolved_question,
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

        if not answer_title:
            answer_title = primary_section["title"]
        if plan.intent in {"Import Procedure", "Export Procedure"}:
            answer_title = plan.topic
        if full_content_request and plan.chapter_filters and not plan.section_filters:
            chapter_number = next(iter(plan.chapter_filters), "")
            chapter = next((item for item in chapters if str(item.get("chapter_number", "")) == chapter_number), None)
            answer_title = f'Chapter {chapter_number}'
            if chapter and chapter.get("chapter_title"):
                answer_title = f'{answer_title} - {chapter.get("chapter_title", "")}'
        search_debug["selected_section"] = _section_label(primary_section)

        answer = {
            "question": question,
            "questionUnderstood": resolved_question,
            "title": answer_title,
            "sectionId": primary_section["id"],
            "chapterNumber": primary_section["chapterNumber"],
            "detectedIntent": plan.intent,
            "detectedTopic": plan.topic,
            "knowledgeSourcesUsed": list(plan.knowledge_sources),
            "confidenceScore": round(confidence_score, 2),
            "relevantChapters": relevant_chapters,
            "relevantSections": relevant_sections,
            "directAnswer": seed_answer,
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

        llm_context = self._llm_context(
            question=question,
            resolved_question=resolved_question,
            plan=plan,
            answer_sections=answer_sections,
            selected_chunks=selected_chunks,
            section_rules=section_rules,
            section_conditions=section_conditions,
            section_workflows=section_workflows,
            section_examples=section_examples,
            required_documents=required_documents,
            important_notes=important_notes,
            business_logic=business_logic,
            workflow_steps=workflow_steps,
            condition_items=condition_items,
            exception_items=exception_items,
            seed_answer=seed_answer,
            structured_evidence_lines=structured_evidence_lines,
            source_payload=source_payload,
            conversation_turns=conversation_turns,
            include_full_section_text=full_content_request or plan.intent == "Section Request" or is_xml_field_query(resolved_question),
        )

        return {
            "skipLlm": False,
            "answer": answer,
            "plan": plan,
            "retrieval": retrieval,
            "selectedChunks": selected_chunks,
            "decision": "Accepted the relevant section(s) after dynamic document selection, in-document retrieval, source validation, and LLM-ready context construction.",
            "searchDebug": search_debug,
            "finalContextDocuments": source_pdfs,
            "resolvedQuestion": resolved_question,
            "conversationTurns": conversation_turns,
            "llmContext": llm_context,
            "retrievalTimeMs": round((perf_counter() - retrieval_started) * 1000, 2),
        }

    def build_answer(
        self,
        question: str,
        ai_model: str = "",
        language: str = "English",
        user_email: str = "",
        conversation_id: str = "",
    ) -> dict[str, Any]:
        bundle = self._prepare_answer_bundle(
            question,
            ai_model=ai_model,
            language=language,
            user_email=user_email,
            conversation_id=conversation_id,
        )
        answer = bundle["answer"]
        plan = bundle["plan"]
        document_sync = self._attach_document_sync(
            answer,
            bundle,
            requested_document_name=getattr(self, "_current_document_name", ""),
        )

        if bundle["skipLlm"]:
            answer["telemetry"] = {
                "provider": "none",
                "displayModel": ai_model,
                "apiModel": "",
                "retrievalTimeMs": bundle["retrievalTimeMs"],
                "llmResponseTimeMs": 0.0,
                "promptTokens": None,
                "completionTokens": None,
                "totalTokens": None,
                "totalCostUsd": None,
            }
            self._log_retrieval(
                question=question,
                plan=plan,
                retrieval=bundle["retrieval"],
                confidence_score=float(answer.get("confidenceScore", 0.0)),
                selected_chunks=bundle["selectedChunks"],
                decision=bundle["decision"],
                debug=bundle["searchDebug"],
                final_prompt="",
                llm_response=answer["directAnswer"],
                final_context_documents=bundle["finalContextDocuments"],
                document_sync=document_sync,
            )
            self._last_trace["telemetry"] = answer["telemetry"]
            return answer

        llm_started = perf_counter()
        try:
            result = llm_service.generate(
                display_model=ai_model,
                system_prompt=self._llm_system_prompt(language),
                user_prompt=bundle["llmContext"],
            )
        except LLMConfigurationError as exc:
            logger.warning("dekai_llm_configuration_error %s", str(exc))
            answer = self._provider_error_answer(
                question=question,
                plan=plan,
                ai_model=ai_model,
                language=language,
                message=str(exc),
                answer=answer,
            )
            answer["telemetry"] = {
                "provider": "configuration_error",
                "displayModel": ai_model,
                "apiModel": "",
                "retrievalTimeMs": bundle["retrievalTimeMs"],
                "llmResponseTimeMs": round((perf_counter() - llm_started) * 1000, 2),
                "promptTokens": None,
                "completionTokens": None,
                "totalTokens": None,
                "totalCostUsd": None,
            }
        else:
            answer["directAnswer"] = result.text or MISSING_INFORMATION_MESSAGE
            answer["modelUsed"] = result.display_model
            answer["telemetry"] = {
                **result.telemetry(),
                "retrievalTimeMs": bundle["retrievalTimeMs"],
                "llmResponseTimeMs": round((perf_counter() - llm_started) * 1000, 2),
            }
            conversation_service.append_turn(
                user_email=user_email,
                conversation_id=conversation_id,
                question=question,
                answer=answer["directAnswer"],
                metadata={
                    "documentName": answer.get("referencedPdf", ""),
                    "sourceChapter": answer.get("sourceChapter", ""),
                    "sourceSection": answer.get("sourceSection", ""),
                    "title": answer.get("title", ""),
                },
            )

        self._log_retrieval(
            question=question,
            plan=plan,
            retrieval=bundle["retrieval"],
            confidence_score=float(answer.get("confidenceScore", 0.0)),
            selected_chunks=bundle["selectedChunks"],
            decision=bundle["decision"],
            debug=bundle["searchDebug"],
            final_prompt=bundle.get("llmContext", ""),
            llm_response=answer["directAnswer"],
            final_context_documents=bundle["finalContextDocuments"],
            document_sync=document_sync,
        )
        self._last_trace["telemetry"] = answer.get("telemetry", {})
        return answer

    def stream_events(
        self,
        question: str,
        ai_model: str = "",
        language: str = "English",
        current_document_name: str = "",
        user_email: str = "",
        conversation_id: str = "",
    ):
        self._current_document_name = current_document_name
        try:
            bundle = self._prepare_answer_bundle(
                question,
                ai_model=ai_model,
                language=language,
                user_email=user_email,
                conversation_id=conversation_id,
            )
        finally:
            if hasattr(self, "_current_document_name"):
                delattr(self, "_current_document_name")

        answer = bundle["answer"]
        plan = bundle["plan"]
        document_sync = self._attach_document_sync(
            answer,
            bundle,
            requested_document_name=current_document_name,
        )
        yield json.dumps({"type": "start", "documentSync": document_sync})

        if bundle["skipLlm"]:
            answer["telemetry"] = {
                "provider": "none",
                "displayModel": ai_model,
                "apiModel": "",
                "retrievalTimeMs": bundle["retrievalTimeMs"],
                "llmResponseTimeMs": 0.0,
                "promptTokens": None,
                "completionTokens": None,
                "totalTokens": None,
                "totalCostUsd": None,
            }
            direct_answer = answer["directAnswer"]
            for index in range(0, len(direct_answer), 24):
                yield json.dumps({"type": "delta", "text": direct_answer[index : index + 24]})
            self._log_retrieval(
                question=question,
                plan=plan,
                retrieval=bundle["retrieval"],
                confidence_score=float(answer.get("confidenceScore", 0.0)),
                selected_chunks=bundle["selectedChunks"],
                decision=bundle["decision"],
                debug=bundle["searchDebug"],
                final_prompt="",
                llm_response=answer["directAnswer"],
                final_context_documents=bundle["finalContextDocuments"],
                document_sync=document_sync,
            )
            self._last_trace["telemetry"] = answer["telemetry"]
            yield json.dumps({"type": "complete", "answer": answer})
            return

        llm_started = perf_counter()
        try:
            final_result = None
            for event in llm_service.stream(
                display_model=ai_model,
                system_prompt=self._llm_system_prompt(language),
                user_prompt=bundle["llmContext"],
            ):
                if event["type"] == "delta":
                    yield json.dumps({"type": "delta", "text": event["text"]})
                    continue
                final_result = event["result"]
        except LLMConfigurationError as exc:
            logger.warning("dekai_llm_configuration_error %s", str(exc))
            answer = self._provider_error_answer(
                question=question,
                plan=plan,
                ai_model=ai_model,
                language=language,
                message=str(exc),
                answer=answer,
            )
            answer["telemetry"] = {
                "provider": "configuration_error",
                "displayModel": ai_model,
                "apiModel": "",
                "retrievalTimeMs": bundle["retrievalTimeMs"],
                "llmResponseTimeMs": round((perf_counter() - llm_started) * 1000, 2),
                "promptTokens": None,
                "completionTokens": None,
                "totalTokens": None,
                "totalCostUsd": None,
            }
        else:
            if final_result is None:
                answer["directAnswer"] = MISSING_INFORMATION_MESSAGE
                answer["telemetry"] = {
                    "provider": "unknown",
                    "displayModel": ai_model,
                    "apiModel": "",
                    "retrievalTimeMs": bundle["retrievalTimeMs"],
                    "llmResponseTimeMs": round((perf_counter() - llm_started) * 1000, 2),
                    "promptTokens": None,
                    "completionTokens": None,
                    "totalTokens": None,
                    "totalCostUsd": None,
                }
            else:
                answer["directAnswer"] = final_result.text or MISSING_INFORMATION_MESSAGE
                answer["modelUsed"] = final_result.display_model
                answer["telemetry"] = {
                    **final_result.telemetry(),
                    "retrievalTimeMs": bundle["retrievalTimeMs"],
                    "llmResponseTimeMs": round((perf_counter() - llm_started) * 1000, 2),
                }
                conversation_service.append_turn(
                    user_email=user_email,
                    conversation_id=conversation_id,
                    question=question,
                    answer=answer["directAnswer"],
                    metadata={
                        "documentName": answer.get("referencedPdf", ""),
                        "sourceChapter": answer.get("sourceChapter", ""),
                        "sourceSection": answer.get("sourceSection", ""),
                        "title": answer.get("title", ""),
                    },
                )

        self._log_retrieval(
            question=question,
            plan=plan,
            retrieval=bundle["retrieval"],
            confidence_score=float(answer.get("confidenceScore", 0.0)),
            selected_chunks=bundle["selectedChunks"],
            decision=bundle["decision"],
            debug=bundle["searchDebug"],
            final_prompt=bundle.get("llmContext", ""),
            llm_response=answer["directAnswer"],
            final_context_documents=bundle["finalContextDocuments"],
            document_sync=document_sync,
        )
        self._last_trace["telemetry"] = answer.get("telemetry", {})
        yield json.dumps({"type": "complete", "answer": answer})


chat_service = ChatService()
