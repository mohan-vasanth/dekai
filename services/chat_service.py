from __future__ import annotations

import json
import logging
import re
from typing import Any

from .knowledge_engine import knowledge_engine_service
from .retrieval_service import RetrievalPlan, retrieval_decision_service
from .search_service import search_service

logger = logging.getLogger(__name__)

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

    def _retrieval_key(self, item: dict[str, Any]) -> str:
        return "|".join(
            [
                str(item.get("type", "")),
                str(item.get("id", "")),
                str(item.get("sectionId", "")),
                str(item.get("documentName", "")),
            ]
        )

    def _semantic_queries(self, question: str, plan: RetrievalPlan) -> list[str]:
        normalized = _normalize(question)
        if plan.intent == "Import Procedure":
            return [
                question,
                "application for iec",
                "filing of application import export restricted goods",
                "import export authorisation restricted items",
                "procedure for import",
                "warehousing customs bonded warehouse import",
                "date of reckoning of import export",
                "profile of importer exporter",
            ]

        if plan.intent == "Export Procedure":
            return [
                question,
                "application for iec",
                "filing of application import export restricted goods",
                "application for grant of export authorisation",
                "export by post documents",
                "date of reckoning of import export",
                "export procedure customs shipping bill",
                "profile of importer exporter",
            ]

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

    def _aggregate_search_debug(self, query: str, plan: RetrievalPlan, queries: list[str], debugs: list[dict[str, Any]], retrieval: list[dict[str, Any]]) -> dict[str, Any]:
        return {
            "user_question": query,
            "detected_intent": plan.intent,
            "detected_entities": _unique([entity for debug in debugs for entity in debug.get("detected_entities", [])]),
            "detected_hs_code": _unique([code for debug in debugs for code in debug.get("detected_hs_code", [])]),
            "metadata_results_count": sum(int(debug.get("metadata_results_count", 0)) for debug in debugs),
            "bm25_results_count": sum(int(debug.get("bm25_results_count", 0)) for debug in debugs),
            "vector_results_count": sum(int(debug.get("vector_results_count", 0)) for debug in debugs),
            "merged_results_count": len(retrieval),
            "expanded_queries": queries,
            "top_ranked_chunks": [
                {
                    "id": item.get("id", ""),
                    "title": item.get("title", ""),
                    "sectionId": item.get("sectionId", ""),
                    "documentName": item.get("documentName", ""),
                    "score": item.get("score", 0),
                    "confidence": item.get("confidence", 0),
                    "rankingReasons": item.get("rankingReasons", []),
                    "matchedQueries": item.get("matchedQueries", []),
                }
                for item in retrieval[:5]
            ],
        }

    def _retrieve_grounding(self, question: str, plan: RetrievalPlan) -> tuple[list[dict[str, Any]], dict[str, Any]]:
        queries = self._semantic_queries(question, plan)
        batches: list[tuple[str, list[dict[str, Any]]]] = []
        debugs: list[dict[str, Any]] = []

        for semantic_query in queries[:4]:
            results = search_service.retrieve(
                semantic_query,
                mode="keyword",
                limit=12,
                collection_filters=plan.collection_filters,
                chapter_filters=plan.chapter_filters or None,
                section_filters=plan.section_filters or None,
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
                    collection_filters=None,
                    chapter_filters=plan.chapter_filters or None,
                    section_filters=plan.section_filters or None,
                )
                batches.append((semantic_query, results))
                debugs.append(search_service.get_last_debug())
            merged = self._merge_retrieval_sets(question, plan, batches)

        return merged, self._aggregate_search_debug(question, plan, queries, debugs, merged)

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
    ) -> list[dict[str, Any]]:
        section_by_id = {str(section.get("id", "")): section for section in sections}
        normalized_question = _normalize(question)

        if plan.chapter_filters and not plan.section_filters and "chapter" in normalized_question:
            return sorted(
                [section for section in sections if str(section.get("chapterNumber", "")) in plan.chapter_filters],
                key=self._section_sort_key,
            )

        if plan.section_filters:
            matched = [section_by_id[section_id] for section_id in plan.section_filters if section_id in section_by_id]
            if matched:
                return sorted(matched, key=self._section_sort_key)

        quoted_phrases = self._quoted_phrases(question)
        if quoted_phrases:
            matched_sections = [
                section
                for section in sections
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

        matched_ids: list[str] = []
        title_matched_ids: list[str] = []
        top_confidence = max((float(item.get("confidence", 0.0)) for item in retrieval), default=0.0)
        for item in retrieval:
            section_id = str(item.get("sectionId", "")).strip()
            if not section_id or section_id not in section_by_id:
                continue
            if section_id in matched_ids:
                continue
            section = section_by_id[section_id]
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
                title_matched_ids.append(section_id)
            confidence = float(item.get("confidence", 0.0))
            if confidence >= max(0.45, top_confidence - 0.18):
                matched_ids.append(section_id)

        selected_ids = _unique([*title_matched_ids, *matched_ids])[:8]
        return [section_by_id[section_id] for section_id in selected_ids if section_id in section_by_id]

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
    ) -> None:
        payload = {
            "question": question,
            "detected_intent": plan.user_intent,
            "detected_topic": plan.topic,
            "knowledge_source": list(plan.knowledge_sources),
            "retrieved_documents": _unique([str(item.get("documentName", "")) for item in retrieval]),
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
            "final_prompt": final_prompt,
            "llm_response": llm_response,
        }
        logger.info("dekai_retrieval %s", json.dumps(payload, ensure_ascii=False))

    def _pick_sections(self, retrieval: list[dict[str, Any]], sections: list[dict[str, Any]], plan: RetrievalPlan) -> tuple[list[dict[str, Any]], float]:
        ranked_section_hits = [
            item
            for item in retrieval
            if item.get("sectionId") and str(item.get("type", "")).lower() in {"section", "chunk", "rule", "condition", "workflow"}
        ]
        if not ranked_section_hits:
            return [], 0.0

        section_by_id = {section["id"]: section for section in sections}
        top_confidence = max(float(item.get("confidence", 0.0)) for item in ranked_section_hits)
        scored_sections: dict[str, dict[str, Any]] = {}

        for item in ranked_section_hits:
            section_id = str(item.get("sectionId", ""))
            if not section_id or section_id not in section_by_id:
                continue
            section = section_by_id[section_id]
            current = scored_sections.setdefault(
                section_id,
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

    def _section_chunks(self, retrieval: list[dict[str, Any]], chunks: list[dict[str, Any]], section_ids: set[str]) -> list[dict[str, Any]]:
        selected: list[dict[str, Any]] = []
        seen_ids: set[str] = set()
        for item in retrieval:
            if item.get("type") != "chunk" or item.get("sectionId") not in section_ids:
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
        return [chunk for chunk in chunks if chunk.get("sectionId") in section_ids][:6]

    def _fallback_sections(
        self,
        retrieval: list[dict[str, Any]],
        sections: list[dict[str, Any]],
        plan: RetrievalPlan,
    ) -> list[dict[str, Any]]:
        section_by_id = {section["id"]: section for section in sections}
        selected_ids: list[str] = []

        if plan.chapter_filters:
            for section in sections:
                if str(section.get("chapterNumber", "")) in plan.chapter_filters and section["id"] not in selected_ids:
                    selected_ids.append(section["id"])
                if len(selected_ids) >= 3:
                    break

        for item in retrieval:
            section_id = str(item.get("sectionId", ""))
            if not section_id or section_id in selected_ids or section_id not in section_by_id:
                continue
            selected_ids.append(section_id)
            if len(selected_ids) >= 3:
                break

        return [section_by_id[section_id] for section_id in selected_ids if section_id in section_by_id][:5]

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

    def _iec_definition_answer(self, question: str, sections: list[dict[str, Any]]) -> str:
        normalized_question = _normalize(question)
        if "iec" not in normalized_question:
            return ""
        if not _contains_any(normalized_question, ("full form", "stands for", "meaning of iec", "what is iec")):
            return ""

        answer_parts = ["IEC stands for Importer Exporter Code."]

        one_pan_section = next((section for section in sections if str(section.get("id", "")).strip() == "2.12"), None)
        one_pan_summary = _first_sentence((one_pan_section or {}).get("summary", ""), 220)
        if one_pan_summary:
            answer_parts.append(f"According to the uploaded document, {one_pan_summary.rstrip('.')}.")

        return " ".join(part for part in answer_parts if part).strip()

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
    ) -> dict[str, Any]:
        primary_section = answer_sections[0] if answer_sections else {}
        return {
            "sourcePdfs": source_pdfs,
            "referencedPdf": source_pdfs[0] if source_pdfs else str(primary_section.get("documentName", "")),
            "sourcePages": [int(page) for page in source_pages if str(page).isdigit()],
            "sourceChapter": relevant_chapters[0] if relevant_chapters else "",
            "sourceSection": relevant_sections[0] if relevant_sections else "",
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
        plan = retrieval_decision_service.detect_intent(question)

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
            )
            return answer

        retrieval, search_debug = self._retrieve_grounding(question, plan)
        chapters = index.get("chapters", [])
        sections = index.get("sections", [])
        rules = index.get("rules", [])
        conditions = index.get("conditions", [])
        workflows = index.get("workflows", [])
        chunks = index.get("chunks", [])
        examples = index.get("examples", [])
        iec_definition_answer = self._iec_definition_answer(question, sections)

        full_content_request = self._is_full_content_request(question, plan)
        answer_sections, confidence_score = self._pick_sections(retrieval, sections, plan)
        if full_content_request:
            full_content_sections = self._full_content_sections(question, plan, retrieval, sections)
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
            answer_sections = self._fallback_sections(retrieval, sections, plan)
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
                    final_prompt=f"Question: {question}\nSelected source: chapter overview",
                    llm_response=chapter_overview,
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
                decision="Rejected answer because no section in the selected DGFT source collection met the confidence threshold.",
                debug=search_debug,
                final_prompt=f"Question: {question}\nSelected source: none",
                llm_response=answer["directAnswer"],
            )
            return answer

        primary_section = answer_sections[0]
        section_ids = {section["id"] for section in answer_sections}
        selected_chunks = self._section_chunks(retrieval, chunks, section_ids)

        section_rules = [rule for rule in rules if rule["sectionId"] in section_ids][:8]
        section_conditions = [condition for condition in conditions if condition["sectionId"] in section_ids][:8]
        section_workflows = [workflow for workflow in workflows if workflow["section"] in section_ids][:2]
        section_examples = [example for example in examples if example["sectionId"] in section_ids][:3]

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
                    f'{_section_reference(next((section for section in answer_sections if section.get("id") == chunk.get("sectionId")), primary_section))}\n{_clean(str(chunk.get("text", "")), 260)}'
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
            decision="Accepted the relevant DGFT section(s) after intent detection, chapter/section filtering, and complete-section grounding.",
            debug=search_debug,
            final_prompt=final_prompt,
            llm_response=answer["directAnswer"],
        )
        return answer

    def stream_events(self, question: str, ai_model: str = "", language: str = "English") -> list[str]:
        answer = self.build_answer(question, ai_model=ai_model, language=language)
        direct_answer = answer["directAnswer"]
        chunks = [direct_answer[index : index + 18] for index in range(0, len(direct_answer), 18)]
        events = [json.dumps({"type": "start"})]
        events.extend(json.dumps({"type": "delta", "text": chunk}) for chunk in chunks)
        events.append(json.dumps({"type": "complete", "answer": answer}))
        return events


chat_service = ChatService()
