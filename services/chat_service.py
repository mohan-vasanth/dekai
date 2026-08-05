from __future__ import annotations

import json
import logging
import re
from typing import Any

from .document_version_service import document_version_service
from .knowledge_engine import knowledge_engine_service
from .retrieval_service import RetrievalPlan, retrieval_decision_service
from .search_service import search_service

logger = logging.getLogger(__name__)
FAILED_DOCUMENT_MESSAGE = (
    "This document has not been processed successfully and is not available in the Knowledge Base. "
    "Please resolve the processing issue or upload the document again before asking questions."
)
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


def _document_aliases(value: str) -> list[str]:
    cleaned = str(value or "").strip()
    if not cleaned:
        return []
    stem = re.sub(r"\.[a-z0-9]{1,6}$", "", cleaned, flags=re.IGNORECASE)
    normalized_cleaned = _normalize_alnum_words(cleaned)
    normalized_stem = _normalize_alnum_words(stem)
    aliases = [
        _normalize(cleaned.replace("_", " ").replace("-", " ")),
        _normalize(stem.replace("_", " ").replace("-", " ")),
        normalized_cleaned,
        normalized_stem,
    ]
    aliases.extend(token for token in _document_tokens(normalized_stem) if len(token) >= 3)

    chapter_match = re.search(r"\bchapter\s*(\d{1,2})\b", normalized_stem)
    if chapter_match:
        chapter_number = chapter_match.group(1)
        aliases.extend(
            [
                f"chapter {chapter_number}",
                f"hbp chapter {chapter_number}" if "hbp" in normalized_stem else "",
                f"ftp chapter {chapter_number}" if "ftp" in normalized_stem else "",
                f"hbp {chapter_number}" if "hbp" in normalized_stem else "",
                f"ftp {chapter_number}" if "ftp" in normalized_stem else "",
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
            if target_document_name:
                queries.insert(1, f"{target_document_name} {question}".strip())
                queries.append(target_document_name)
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
            if target_document_name:
                queries.insert(1, f"{target_document_name} {question}".strip())
                queries.append(target_document_name)
            return _unique([query.strip() for query in queries if query and query.strip()])[:8]

        queries = [question]
        if target_document_name:
            queries.extend(
                [
                    f"{target_document_name} {question}".strip(),
                    target_document_name,
                ]
            )
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

    def _document_scope_candidates(
        self,
        *,
        explicit_document: dict[str, Any] | None,
        current_document: dict[str, Any] | None,
        ready_documents: list[dict[str, Any]],
        plan: RetrievalPlan,
    ) -> list[dict[str, Any]]:
        custom_documents = [document for document in ready_documents if not bool(document.get("isDgft"))]
        dgft_documents = [document for document in ready_documents if bool(document.get("isDgft"))]

        if explicit_document:
            return [
                {
                    "label": "explicit_document",
                    "document_names": [str(explicit_document.get("name", ""))],
                    "target_document_name": str(explicit_document.get("name", "")),
                    "collection_filters": None,
                    "strict": True,
                }
            ]

        scopes: list[dict[str, Any]] = []
        if current_document:
            scopes.append(
                {
                    "label": "current_document",
                    "document_names": [str(current_document.get("name", ""))],
                    "target_document_name": str(current_document.get("name", "")),
                    "collection_filters": None,
                    "strict": False,
                }
            )

        remaining_custom_names = [
            str(document.get("name", ""))
            for document in custom_documents
            if str(document.get("name", "")) and _normalize(str(document.get("name", ""))) != _normalize(str((current_document or {}).get("name", "")))
        ]
        if remaining_custom_names:
            scopes.append(
                {
                    "label": "uploaded_documents",
                    "document_names": remaining_custom_names,
                    "target_document_name": "",
                    "collection_filters": None,
                    "strict": False,
                }
            )

        dgft_names = [str(document.get("name", "")) for document in dgft_documents if str(document.get("name", ""))]
        if dgft_names:
            scopes.append(
                {
                    "label": "dgft_fallback",
                    "document_names": dgft_names,
                    "target_document_name": "",
                    "collection_filters": plan.collection_filters,
                    "strict": False,
                }
            )

        if not scopes and ready_documents:
            scopes.append(
                {
                    "label": "all_ready_documents",
                    "document_names": [str(document.get("name", "")) for document in ready_documents if str(document.get("name", ""))],
                    "target_document_name": "",
                    "collection_filters": None,
                    "strict": False,
                }
            )

        return scopes

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
            _preserve_text(section.get("rawText", "")) or "I couldn't find this information in the uploaded document.",
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
            return f"I found relevant content in section {label}, but the uploaded document does not contain a concise summary for it."
        return "I found relevant content in the uploaded document, but it does not include a concise extract for this topic."

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
        direct_answer: str = "I couldn't find this information in the uploaded document.",
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

        heading = str(heading_chunk.get("heading", "") or heading_chunk.get("title", "")).strip()
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
        blocks = [f"{field_name} appears in the uploaded document"]
        if heading_label:
            blocks[0] += f" under {heading_label}."
        else:
            blocks[0] += "."
        if matched_line:
            blocks.append(f"The extracted content lists it as: {_clean(matched_line, 220)}.")
        else:
            blocks.append("It is part of the structured fields captured from the uploaded PDF.")
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

        answer = f"{matched_label or str(section.get('title', '')).strip()} is described in the uploaded document as {summary}"
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
            answer_parts.append(f"According to the uploaded document, {one_pan_summary.rstrip('.')}.")

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
            return "I found related content in the uploaded documents, but there is not enough extracted text to produce a grounded answer."

        references = self._source_reference_lines(answer_sections)
        blocks: list[str] = []
        if _contains_any(normalized_question, WORKFLOW_PATTERNS) or plan.intent in {"Import Procedure", "Export Procedure"}:
            blocks.append(
                "Based on the uploaded documents, this topic is explained across multiple DGFT knowledge-base sections rather than one exact heading."
            )
            blocks.append("Relevant guidance from the uploaded documents:\n" + _bullet_lines(summary_points, limit=4))
            if workflow_steps:
                blocks.append("Combined workflow:\n" + _numbered_lines(workflow_steps, limit=8))
            if condition_items:
                blocks.append("Key requirements and checks:\n" + _bullet_lines(condition_items, limit=6))
            if required_documents:
                blocks.append("Related documents mentioned in the uploaded knowledge base:\n" + _bullet_lines(required_documents, limit=6))
        else:
            blocks.append("Based on the uploaded documents:\n" + _bullet_lines(summary_points, limit=4))
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
            return "\n\n".join(rendered_tables) if rendered_tables else "I couldn't find this information in the uploaded document."

        if "xml" in normalized_question:
            xml_tags = sorted(
                {
                    match
                    for section in answer_sections
                    for match in re.findall(r"<\s*/?\s*([A-Za-z_][\w:.-]*)", str(section.get("rawText", "")))
                }
            )
            return (
                f"I found these XML tags in the uploaded document: {_natural_list(xml_tags, limit=8)}."
                if xml_tags
                else "I couldn't find this information in the uploaded document."
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
                f"I found these JSON keys in the uploaded document: {_natural_list(json_keys, limit=8)}."
                if json_keys
                else "I couldn't find this information in the uploaded document."
            )

        if "validation" in normalized_question:
            validations = _unique(
                [
                    *[_clean(validation, 220) for section in answer_sections for validation in section.get("validations", [])],
                    *condition_items,
                ]
            )
            return (
                f"The uploaded document mainly requires the following validations: {_natural_list(validations, limit=6)}."
                if validations
                else "I couldn't find this information in the uploaded document."
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
                f"I found these error-related references in the uploaded document: {_natural_list(error_lines, limit=5)}."
                if error_lines
                else "I couldn't find this information in the uploaded document."
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
                f"I found these HS code references in the uploaded document: {_natural_list(unique_matches, limit=5)}."
                if unique_matches
                else "I couldn't find this information in the uploaded document."
            )

        if any(term in normalized_question for term in ("document", "documents")):
            return (
                f"According to the uploaded document, the required documents include {_natural_list(required_documents, limit=6)}."
                if required_documents
                else "The uploaded document does not clearly list the required documents for this topic."
            )

        if "workflow" in normalized_question:
            return (
                f"The process described in the uploaded document is: {_natural_list(workflow_steps, limit=6)}."
                if workflow_steps
                else "I couldn't find this information in the uploaded document."
            )

        if "condition" in normalized_question or "criteria" in normalized_question or "eligibility" in normalized_question:
            return (
                f"The main conditions mentioned in the uploaded document are {_natural_list(condition_items, limit=6)}."
                if condition_items
                else "I couldn't find this information in the uploaded document."
            )

        if "exception" in normalized_question or "exemption" in normalized_question:
            return (
                f"The uploaded document mentions these exceptions or exemptions: {_natural_list(exception_items, limit=6)}."
                if exception_items
                else "I couldn't find this information in the uploaded document."
            )

        if "rule" in normalized_question or "logic" in normalized_question:
            return (
                f"The main rules described in the uploaded document are {_natural_list(business_logic, limit=6)}."
                if business_logic
                else "I couldn't find this information in the uploaded document."
            )

        section_summaries = [self._section_narrative(section) for section in answer_sections[:3]]
        return "\n\n".join(section_summaries) if section_summaries else "I couldn't find this information in the uploaded document."

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
            f"The most relevant matches in the uploaded document are {_natural_list(matches, limit=3)}."
            if matches
            else "I couldn't find this information in the uploaded document."
        )

    def _comparison_response(self, answer_sections: list[dict[str, Any]]) -> str:
        if len(answer_sections) < 2:
            return "I couldn't find this information in the uploaded document."
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
        return " ".join(_ensure_sentence(summary) for summary in summaries[:3] if summary) if any(summaries) else "I couldn't find this information in the uploaded document."

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
                f"According to the uploaded documents, the required documents include {_natural_list(required_documents, limit=6)}."
                if required_documents
                else "The uploaded documents do not explicitly list the required documents for this topic."
            )

        if _contains_any(normalized_question, WORKFLOW_PATTERNS) and not broad_process_question:
            explicit_detail_request = True
            response_blocks.append(
                f"The process described in the uploaded documents is {_natural_list(workflow_steps, limit=6)}."
                if workflow_steps
                else "No explicit workflow was extracted for this topic in the uploaded documents."
            )

        if _contains_any(normalized_question, CONDITION_PATTERNS):
            explicit_detail_request = True
            response_blocks.append(
                f"The main conditions mentioned are {_natural_list(condition_items, limit=6)}."
                if condition_items
                else "The uploaded documents do not explicitly list conditions for this topic."
            )

        if _contains_any(normalized_question, EXCEPTION_PATTERNS):
            explicit_detail_request = True
            response_blocks.append(
                f"The uploaded documents mention these exceptions or exemptions: {_natural_list(exception_items, limit=6)}."
                if exception_items
                else "The uploaded documents do not explicitly list exceptions for this topic."
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
                _ensure_sentence(example_text) if example_text else "No explicit example was extracted for this topic in the uploaded document."
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
                response_blocks.append(f"This answer is based on the uploaded PDF {source_pdfs[0]}.")

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

        if self._is_full_content_request(question, plan):
            return self._full_content_response(question, plan, answer_sections, chapters), source_payload

        if plan.user_intent in {"Data Extraction", "Table Extraction", "XML Extraction", "JSON Extraction", "PDF Parsing"}:
            return (
                self._extract_structured_response(
                    question,
                    answer_sections,
                    selected_chunks,
                    workflow_steps,
                    condition_items,
                    exception_items,
                    business_logic,
                    required_documents,
                ),
                source_payload,
            )

        if plan.user_intent == "Comparison":
            return self._comparison_response(answer_sections), source_payload

        if plan.user_intent in {"Summarization", "Report Generation"}:
            return self._summary_response(question, plan, answer_sections, selected_chunks, chapters), source_payload

        if plan.user_intent in {"Search", "Information Retrieval"}:
            return (
                self._general_answer(
                    question,
                    plan,
                    answer_sections[0],
                    selected_chunks,
                    chapters,
                    answer_sections=answer_sections,
                    workflow_steps=workflow_steps,
                    condition_items=condition_items,
                    required_documents=required_documents,
                ),
                source_payload,
            )

        if plan.user_intent == "Document Analysis":
            summaries = _unique(
                [_clean(str(section.get("summary", "")), 220) for section in answer_sections]
                + [_clean(str(section.get("businessMeaning", "")), 180) for section in answer_sections]
            )
            return " ".join(_ensure_sentence(summary) for summary in summaries[:3] if summary), source_payload

        if plan.user_intent == "Translation":
            return "I couldn't find this information in the uploaded document.", source_payload

        primary_section = answer_sections[0]
        answer_text, _ = self._detail_answer(
            question,
            plan,
            primary_section,
            answer_sections,
            selected_chunks,
            chapters,
            business_logic,
            workflow_steps,
            condition_items,
            exception_items,
            required_documents,
            section_examples,
            source_pdfs,
            source_pages,
            relevant_chapters,
            relevant_sections,
        )
        return answer_text, source_payload

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
                business_explanation="If the uploaded HS Master is available, DEKAI will search only that dataset after you provide product-specific details.",
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
        selected_scope_label = ""

        current_document_name = getattr(self, "_current_document_name", "")
        if current_document_name:
            current_ready_document = self._find_ready_document_by_name(current_document_name, ready_documents)

        scope_candidates = self._document_scope_candidates(
            explicit_document=target_ready_document,
            current_document=current_ready_document,
            ready_documents=ready_documents,
            plan=plan,
        )

        for scope in scope_candidates:
            scope_retrieval, scope_debug = self._retrieve_grounding(
                question,
                plan,
                scope_label=str(scope.get("label", "")),
                target_document_name=str(scope.get("target_document_name", "")),
                document_names=[str(name) for name in scope.get("document_names", []) if str(name).strip()],
                collection_filters=scope.get("collection_filters"),
            )
            if plan.user_intent != "Comparison":
                primary_document_name = self._primary_document_name(scope_retrieval)
                if primary_document_name:
                    scope_retrieval = self._filter_retrieval_by_documents(scope_retrieval, [primary_document_name])
            if scope_retrieval:
                retrieval = scope_retrieval
                search_debug = scope_debug
                selected_scope_label = str(scope.get("label", ""))
                allowed_document_names = [self._primary_document_name(scope_retrieval)] if plan.user_intent != "Comparison" else [
                    str(item.get("documentName", "")).strip()
                    for item in scope_retrieval
                    if str(item.get("documentName", "")).strip()
                ]
            if scope_retrieval and (bool(scope.get("strict")) or self._scope_has_grounding(scope_retrieval)):
                break

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
            direct_answer = f'{definition_answer_payload["term"]} stands for {definition_answer_payload["definition"]}.'
            answer = self._empty_answer(
                question,
                plan,
                confidence_score=0.96,
                direct_answer=direct_answer,
                business_explanation=f'Answered from the uploaded document {definition_answer_payload["documentName"]}.',
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
            self._log_retrieval(
                question=question,
                plan=plan,
                retrieval=retrieval,
                confidence_score=0.96,
                selected_chunks=[],
                decision=f'Returned exact definition for term {definition_answer_payload["term"]} from the uploaded document.',
                debug=search_debug,
                llm_response=direct_answer,
                final_context_documents=[str(definition_answer_payload.get("documentName", "")).strip()],
            )
            return answer

        if document_identity_payload:
            section = document_identity_payload.get("section", {}) or {}
            answer = self._empty_answer(
                question,
                plan,
                confidence_score=0.92,
                direct_answer=str(document_identity_payload.get("answer", "")),
                business_explanation=f'Answered from the uploaded document {document_identity_payload.get("documentName", "")}.',
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
            self._log_retrieval(
                question=question,
                plan=plan,
                retrieval=retrieval,
                confidence_score=0.92,
                selected_chunks=[],
                decision=f'Returned document identity answer for {document_identity_payload.get("documentName", "")} from the uploaded document introduction/definition path.',
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
        if not answer_sections:
            chapter_overview = self._chapter_overview(question, plan, chapters)
            if chapter_overview:
                answer = self._empty_answer(
                    question,
                    plan,
                    confidence_score=confidence_score,
                    direct_answer=chapter_overview,
                    business_explanation="",
                    ai_model=ai_model,
                    language=language,
                )
                answer["title"] = "Chapter overview"
                answer["directAnswer"] = chapter_overview
                answer["sourceChapter"] = next(iter(plan.likely_chapters), "")
                self._log_retrieval(
                    question=question,
                    plan=plan,
                    retrieval=retrieval,
                    confidence_score=confidence_score,
                    selected_chunks=[],
                    decision="Returned chapter overview from indexed chapter summaries because no section met the retrieval threshold.",
                    debug=search_debug,
                    final_prompt=f"Question: {question}\nSelected source: chapter overview\nSelected scope: {selected_scope_label}",
                    llm_response=chapter_overview,
                    final_context_documents=[],
                )
                return answer
            answer = self._empty_answer(
                question,
                plan,
                confidence_score=confidence_score,
                ai_model=ai_model,
                language=language,
                direct_answer="I couldn't find this information in the uploaded documents.",
            )
            self._log_retrieval(
                question=question,
                plan=plan,
                retrieval=retrieval,
                confidence_score=confidence_score,
                selected_chunks=[],
                decision="Rejected answer because no section in the selected document scope met the confidence threshold.",
                debug=search_debug,
                final_prompt=f"Question: {question}\nSelected source: none\nSelected scope: {selected_scope_label}",
                llm_response=answer["directAnswer"],
                final_context_documents=[],
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
                *[_clean(rule.get("description", ""), 220) for rule in section_rules if rule.get("description")],
                *[_clean(validation, 220) for section in answer_sections for validation in section.get("validations", [])[:3]],
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
                *[_clean(condition.get("text", ""), 220) for condition in section_conditions if condition.get("text")],
                *[_clean(rule.get("condition", ""), 220) for rule in section_rules if rule.get("condition")],
            ]
        )[:6]

        exception_items = _unique(
            [
                *[_clean(rule.get("exception", ""), 220) for rule in section_rules if rule.get("exception")],
                *[_clean(exception, 220) for section in answer_sections for exception in section.get("exceptions", [])[:4]],
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
            decision="Accepted the relevant section(s) after document-aware retrieval, source validation, and complete-section grounding.",
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
