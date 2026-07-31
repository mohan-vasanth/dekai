from __future__ import annotations

import json
import re
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from config import CONFIG
from parser.utils import (
    extract_numeric_identifiers,
    normalise_whitespace,
    safe_section_slug,
    stable_text_hash,
    split_lines,
    split_sentences,
    unique_preserve,
)

from .document_version_service import document_version_service
from .embedding_service import embedding_service
from .runtime_store import runtime_store


def _safe_json(path: Path, fallback: Any) -> Any:
    if not path.exists():
        return fallback
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return fallback


def _clean(value: Any, limit: int = 240) -> str:
    normalized = normalise_whitespace(str(value or ""))
    if len(normalized) <= limit:
        return normalized
    return normalized[: limit - 3].rstrip() + "..."


def _iso_timestamp(path: Path) -> str | None:
    if not path.exists():
        return None
    return datetime.fromtimestamp(path.stat().st_mtime, tz=timezone.utc).isoformat().replace("+00:00", "Z")


class KnowledgeEngineService:
    def __init__(self) -> None:
        self.index_path = runtime_store.knowledge_index_path
        self.schema_path = runtime_store.knowledge_schema_path

    def _document_stages(self, status: str) -> list[dict[str, str]]:
        labels = [
            "Uploading",
            "Reading PDF",
            "Extracting Chapters",
            "Extracting Sections",
            "Extracting Headings",
            "Extracting Tables",
            "Extracting Notes",
            "Extracting Definitions",
            "Extracting Business Rules",
            "Extracting Conditions",
            "Extracting Validations",
            "Extracting Exceptions",
            "Extracting Authorities",
            "Extracting Required Documents",
            "Extracting Timelines",
            "Extracting Workflows",
            "Generating Searchable Chunks",
            "Generating Embeddings",
            "Building Knowledge Graph",
            "Storing Knowledge Base",
            "Knowledge Base Ready",
        ]
        if status == "ready":
            return [{"label": label, "state": "complete"} for label in labels]
        if status == "failed":
            return [
                {"label": label, "state": "complete" if index == 0 else "current" if index == 1 else "upcoming"}
                for index, label in enumerate(labels)
            ]
        return [
            {"label": label, "state": "complete" if index == 0 else "current" if index == 1 else "upcoming"}
            for index, label in enumerate(labels)
        ]

    def load_index(self, refresh: bool = False) -> dict[str, Any]:
        if refresh or not self.index_path.exists():
            return self.build_index()
        cached = runtime_store.read_json(self.index_path, {})
        if cached:
            return cached
        return self.build_index()

    def build_index(self) -> dict[str, Any]:
        master_path = CONFIG.json_dir / "master_knowledge_base.json"
        master = _safe_json(master_path, {})
        if not isinstance(master, dict) or not master:
            empty = self._empty_index()
            self._write_index(empty)
            return empty

        chapter_reports = [item for item in _safe_json(CONFIG.reports_dir / "chapter_reports.json", []) if isinstance(item, dict)]
        glossary = master.get("glossary", {}) if isinstance(master.get("glossary", {}), dict) else {}
        topics = [item for item in master.get("unified_topics", []) if isinstance(item, dict)]
        dependency_edges = [item for item in master.get("dependency_edges", []) if isinstance(item, dict)]
        chapter_relationships = [item for item in master.get("chapter_relationships", []) if isinstance(item, dict)]

        report_by_document: dict[str, dict[str, Any]] = {}
        for report_file in CONFIG.reports_dir.glob("*_report.json"):
            report = _safe_json(report_file, {})
            if isinstance(report, dict) and report.get("summary", {}).get("source_pdf"):
                report_by_document[report["summary"]["source_pdf"]] = report

        sections_raw = []
        for section_file in CONFIG.json_dir.glob("*.json"):
            if section_file.name in {"master_knowledge_base.json", "unified_topics.json"} or section_file.name.endswith("_searchable.json"):
                continue
            payload = _safe_json(section_file, None)
            if isinstance(payload, dict) and payload.get("section"):
                sections_raw.append(payload)

        sections = []
        rules: list[dict[str, Any]] = []
        conditions: list[dict[str, Any]] = []
        workflows: list[dict[str, Any]] = []
        definitions: list[dict[str, Any]] = []
        authorities: list[dict[str, Any]] = []
        exceptions: list[dict[str, Any]] = []
        timelines: list[dict[str, Any]] = []
        examples: list[dict[str, Any]] = []
        faqs: list[dict[str, Any]] = []
        keywords: list[dict[str, Any]] = []
        relationships: list[dict[str, Any]] = []
        chunks: list[dict[str, Any]] = []
        search_records: list[dict[str, Any]] = []

        definitions_by_term = {term.casefold(): definition for term, definition in glossary.items()}

        for section_payload in sorted(sections_raw, key=lambda item: str(item.get("section", ""))):
            section_id = str(section_payload.get("section", ""))
            chapter_number = str(section_payload.get("chapter_number", ""))
            title = str(section_payload.get("title", ""))
            document_name = str(section_payload.get("source_document", ""))
            pages = [int(page) for page in section_payload.get("pages", []) if isinstance(page, int)]
            raw_text = str(section_payload.get("raw_text", ""))
            headings = self._extract_headings(raw_text, title)
            tables = self._extract_tables(raw_text)
            notes = self._extract_notes(raw_text)
            section_definitions = self._extract_definitions(section_payload, definitions_by_term)
            section_keywords = unique_preserve([*section_payload.get("search_keywords", []), *section_payload.get("keywords", []), *section_definitions.keys()])
            section_hs_codes = self._extract_hs_codes(*[" | ".join(row) for row in tables])
            related_sections = unique_preserve(section_payload.get("related_sections", []))
            related_chapters = unique_preserve(section_payload.get("related_chapters", []))
            business_rules = [rule for rule in section_payload.get("business_rules", []) if isinstance(rule, dict)]
            workflow_steps = [step for step in section_payload.get("workflow", []) if isinstance(step, str)]
            faq_items = [item for item in section_payload.get("faq", []) if isinstance(item, dict)]
            example_items = [item for item in section_payload.get("examples", []) if isinstance(item, str)]
            if section_payload.get("real_world_example"):
                example_items.append(str(section_payload.get("real_world_example")))

            section_record = {
                "id": section_id,
                "title": title,
                "chapterNumber": chapter_number,
                "chapterTitle": str(section_payload.get("chapter_title", "DGFT Chapter")),
                "documentName": document_name,
                "purpose": _clean(section_payload.get("purpose", "")),
                "summary": _clean(section_payload.get("summary", ""), 320),
                "businessMeaning": _clean(section_payload.get("business_meaning", ""), 260),
                "businessExplanation": _clean(section_payload.get("business_explanation", ""), 320),
                "rulesCount": len(business_rules),
                "conditionsCount": len(section_payload.get("conditions", [])),
                "validationsCount": len(section_payload.get("validations", [])),
                "exceptionsCount": len(section_payload.get("exceptions", [])),
                "authorities": unique_preserve(section_payload.get("authorities", [])),
                "timelines": unique_preserve(section_payload.get("timelines", [])),
                "workflow": workflow_steps,
                "relatedChapters": related_chapters,
                "businessRules": [
                    {
                        "id": rule.get("rule_id") or f"{section_id}-rule-{index + 1}",
                        "name": _clean(rule.get("trigger") or title, 120),
                        "description": _clean(rule.get("rule_description") or rule.get("output"), 240),
                        "condition": _clean(rule.get("condition"), 180),
                        "exception": _clean(rule.get("exception"), 180),
                        "output": _clean(rule.get("output"), 180),
                    }
                    for index, rule in enumerate(business_rules)
                ],
                "documents": unique_preserve(section_payload.get("required_documents", []) or section_payload.get("documents", [])),
                "pages": pages,
                "headings": headings,
                "tables": tables,
                "notes": notes,
                "definitions": [
                    {"term": term, "definition": definition, "sectionId": section_id, "chapterNumber": chapter_number}
                    for term, definition in section_definitions.items()
                ],
                "validations": unique_preserve(section_payload.get("validations", [])),
                "exceptions": unique_preserve(section_payload.get("exceptions", [])),
                "requiredDocuments": unique_preserve(section_payload.get("required_documents", []) or section_payload.get("documents", [])),
                "authoritiesExpanded": unique_preserve(section_payload.get("authorities", [])),
                "faqs": faq_items,
                "examples": unique_preserve(example_items),
                "keywords": section_keywords,
                "hsCodes": section_hs_codes,
                "eximCodes": section_hs_codes,
                "relatedSections": related_sections,
                "sourcePages": pages,
                "rawText": raw_text,
            }
            section_record["tableRows"] = self._extract_table_rows(section_record, raw_text, pages)
            section_record["hsCodes"] = unique_preserve(
                [*section_record["hsCodes"], *[code for row in section_record["tableRows"] for code in row.get("hsCodes", [])]]
            )
            section_record["eximCodes"] = list(section_record["hsCodes"])
            sections.append(section_record)

            chunk_payload = _safe_json(CONFIG.chunk_output_dir / f"{safe_section_slug(section_id, title)}.json", [])
            if not isinstance(chunk_payload, list) or not chunk_payload:
                chunk_payload = [
                    {
                        "chunk_id": f"{section_id}-1",
                        "document_name": document_name,
                        "chapter_number": chapter_number,
                        "chapter_title": section_record["chapterTitle"],
                        "section": section_id,
                        "title": title,
                        "chunk_index": 1,
                        "text": raw_text,
                        "keywords": section_keywords[:15],
                        "intent": section_payload.get("intent", ""),
                        "tags": section_payload.get("tags", []),
                        "related_sections": related_sections,
                        "source_pages": pages,
                    }
                ]
            for chunk in chunk_payload:
                if not isinstance(chunk, dict):
                    continue
                chunk_record = {
                    "id": chunk.get("chunk_id") or f"{section_id}-chunk-{chunk.get('chunk_index', 1)}",
                    "entityType": "chunk",
                    "documentName": document_name,
                    "chapterNumber": chapter_number,
                    "chapterTitle": section_record["chapterTitle"],
                    "sectionId": section_id,
                    "title": title,
                    "text": str(chunk.get("text", "")),
                    "keywords": unique_preserve(chunk.get("keywords", [])),
                    "intent": str(chunk.get("intent", "")),
                    "tags": unique_preserve(chunk.get("tags", [])),
                    "relatedSections": unique_preserve(chunk.get("related_sections", [])),
                    "sourcePages": [int(page) for page in chunk.get("source_pages", pages) if isinstance(page, int)],
                    "hsCodes": self._extract_hs_codes(chunk.get("text", ""), *chunk.get("hs_codes", [])),
                    "eximCodes": self._extract_hs_codes(chunk.get("text", ""), *chunk.get("exim_codes", [])),
                    "description": str(chunk.get("description", "")).strip(),
                    "chunkHash": str(chunk.get("chunk_hash", "")).strip() or stable_text_hash(str(chunk.get("text", ""))),
                    "isTableRow": bool(chunk.get("is_table_row", False)),
                }
                chunk_record["vector"] = embedding_service.embed_text(
                    " ".join(
                        [
                            chunk_record["title"],
                            chunk_record["text"],
                            " ".join(chunk_record["keywords"]),
                            " ".join(chunk_record["tags"]),
                            " ".join(chunk_record["hsCodes"]),
                            chunk_record["description"],
                        ]
                    )
                )
                chunks.append(chunk_record)

            chunks.extend(section_record["tableRows"])

            for rule in section_record["businessRules"]:
                rule_record = {
                    "id": rule["id"],
                    "sectionId": section_id,
                    "sectionTitle": title,
                    "chapterNumber": chapter_number,
                    "chapterTitle": section_record["chapterTitle"],
                    "documentName": document_name,
                    "ruleName": rule["name"],
                    "description": rule["description"],
                    "condition": rule["condition"],
                    "exception": rule["exception"],
                    "output": rule["output"],
                    "sourcePages": pages,
                }
                rules.append(rule_record)
                search_records.append(self._search_record("rule", rule_record["id"], rule_record["ruleName"], rule_record["description"], section_record, pages))

            for index, condition in enumerate(section_payload.get("conditions", []), start=1):
                condition_record = {
                    "id": f"{section_id}-condition-{index}",
                    "sectionId": section_id,
                    "title": title,
                    "chapterNumber": chapter_number,
                    "documentName": document_name,
                    "text": _clean(condition, 220),
                    "sourcePages": pages,
                }
                conditions.append(condition_record)
                search_records.append(self._search_record("condition", condition_record["id"], title, condition_record["text"], section_record, pages))

            workflow_record = {
                "id": f"{section_id}-workflow",
                "section": section_id,
                "title": title,
                "chapterNumber": chapter_number,
                "authority": section_record["authorities"][0] if section_record["authorities"] else "DGFT",
                "timeline": section_record["timelines"][0] if section_record["timelines"] else "Timeline not explicit",
                "steps": workflow_steps,
                "ascii": str(section_payload.get("workflow_ascii", "")),
                "mermaid": str(section_payload.get("mermaid", "")),
                "sourcePages": pages,
                "documentName": document_name,
            }
            workflows.append(workflow_record)
            if workflow_steps:
                search_records.append(
                    self._search_record("workflow", workflow_record["id"], title, " ".join(workflow_steps[:6]), section_record, pages)
                )

            for term, definition in section_definitions.items():
                definition_record = {
                    "id": f"{section_id}-definition-{term.casefold().replace(' ', '-')}",
                    "term": term,
                    "definition": _clean(definition, 220),
                    "sectionId": section_id,
                    "chapterNumber": chapter_number,
                    "documentName": document_name,
                    "sourcePages": pages,
                }
                definitions.append(definition_record)
                search_records.append(
                    self._search_record("definition", definition_record["id"], term, definition_record["definition"], section_record, pages)
                )

            for authority in section_record["authorities"]:
                authorities.append(
                    {
                        "id": f"{section_id}-authority-{authority.casefold().replace(' ', '-')}",
                        "name": authority,
                        "sectionId": section_id,
                        "chapterNumber": chapter_number,
                        "documentName": document_name,
                        "sourcePages": pages,
                    }
                )

            for index, exception in enumerate(section_record["exceptions"], start=1):
                exceptions.append(
                    {
                        "id": f"{section_id}-exception-{index}",
                        "text": _clean(exception, 220),
                        "sectionId": section_id,
                        "chapterNumber": chapter_number,
                        "documentName": document_name,
                        "sourcePages": pages,
                    }
                )

            for index, timeline in enumerate(section_record["timelines"], start=1):
                timelines.append(
                    {
                        "id": f"{section_id}-timeline-{index}",
                        "text": _clean(timeline, 180),
                        "sectionId": section_id,
                        "chapterNumber": chapter_number,
                        "documentName": document_name,
                        "sourcePages": pages,
                    }
                )

            for index, example in enumerate(section_record["examples"], start=1):
                examples.append(
                    {
                        "id": f"{section_id}-example-{index}",
                        "text": _clean(example, 220),
                        "sectionId": section_id,
                        "chapterNumber": chapter_number,
                        "documentName": document_name,
                        "sourcePages": pages,
                    }
                )

            for faq_index, faq_item in enumerate(faq_items, start=1):
                question = str(faq_item.get("question_en") or faq_item.get("question") or "")
                answer = str(faq_item.get("answer_en") or faq_item.get("answer") or "")
                faqs.append(
                    {
                        "id": f"{section_id}-faq-{faq_index}",
                        "question": question,
                        "answer": answer,
                        "sectionId": section_id,
                        "chapterNumber": chapter_number,
                        "documentName": document_name,
                        "sourcePages": pages,
                    }
                )

            for keyword in section_keywords:
                keywords.append(
                    {
                        "id": f"{section_id}-keyword-{keyword.casefold().replace(' ', '-')}",
                        "term": keyword,
                        "sectionId": section_id,
                        "chapterNumber": chapter_number,
                        "documentName": document_name,
                    }
                )

            relationships.extend(
                [
                    {
                        "id": f"{section_id}-section-{related_section}",
                        "sourceType": "section",
                        "sourceId": section_id,
                        "targetType": "section",
                        "targetId": related_section,
                        "relation": "related_section",
                    }
                    for related_section in related_sections
                ]
            )
            relationships.extend(
                [
                    {
                        "id": f"{section_id}-chapter-{related_chapter}",
                        "sourceType": "section",
                        "sourceId": section_id,
                        "targetType": "chapter",
                        "targetId": related_chapter,
                        "relation": "related_chapter",
                    }
                    for related_chapter in related_chapters
                ]
            )
            search_records.append(
                self._search_record(
                    "section",
                    section_id,
                    f"{section_id} {title}",
                    " ".join([section_record["summary"], section_record["businessMeaning"], " ".join(section_keywords[:10])]),
                    section_record,
                    pages,
                    extra={
                        "hsCodes": section_record["hsCodes"],
                        "eximCodes": section_record["eximCodes"],
                    },
                )
            )

        search_records.extend(
            self._search_record(
                "chunk",
                chunk["id"],
                f'{chunk["sectionId"]} {chunk["title"]}',
                chunk["text"],
                next((section for section in sections if section["id"] == chunk["sectionId"]), {}),
                chunk["sourcePages"],
                extra={
                    "hsCodes": chunk.get("hsCodes", []),
                    "eximCodes": chunk.get("eximCodes", []),
                    "description": chunk.get("description", ""),
                    "chunkHash": chunk.get("chunkHash", ""),
                    "isTableRow": chunk.get("isTableRow", False),
                },
            )
            for chunk in chunks
        )

        chapters = self._chapters(chapter_reports)
        concepts, concept_edges = self._concept_graph(topics, sections)
        relationships.extend(concept_edges)
        documents = self._documents(master, chapter_reports, report_by_document)

        for document in documents:
            document_version_service.update_document_metadata(
                document["name"],
                {
                    "pages": document["pages"],
                    "sections": document["sections"],
                    "rules": document["rules"],
                    "conditions": document["conditions"],
                    "exceptions": document["exceptions"],
                    "workflows": document["workflows"],
                    "chapterTitle": document["chapterTitle"],
                    "sourcePdf": document["name"],
                },
                status="failed" if int(document["pages"]) <= 0 else "ready",
            )

        documents = self._documents(master, chapter_reports, report_by_document)
        statistics = {
            "documents": len(documents),
            "pages": sum(document["pages"] for document in documents),
            "chapters": len(chapters),
            "sections": len(sections),
            "businessRules": len(rules),
            "conditions": len(conditions),
            "exceptions": len(exceptions),
            "workflows": len([workflow for workflow in workflows if workflow["steps"]]),
            "definitions": len(definitions),
            "authorities": len(authorities),
            "timelines": len(timelines),
            "examples": len(examples),
            "faqs": len(faqs),
            "keywords": len(keywords),
            "relationships": len(relationships),
            "embeddings": len(chunks) + len(search_records) + len(concepts),
            "vectorCount": len(chunks) + len(search_records) + len(concepts),
        }

        explorer = self._explorer(documents, chapters, sections, rules, conditions, workflows, examples)
        schema = self._database_schema()
        index = {
            "generatedAt": _iso_timestamp(master_path),
            "knowledgeBaseName": master.get("knowledge_base_name", "DEKAI DGFT Knowledge Base"),
            "documents": documents,
            "chapters": chapters,
            "sections": sections,
            "rules": rules,
            "conditions": conditions,
            "workflows": workflows,
            "definitions": definitions,
            "authorities": authorities,
            "exceptions": exceptions,
            "timelines": timelines,
            "examples": examples,
            "faqs": faqs,
            "keywords": keywords,
            "relationships": relationships,
            "chunks": chunks,
            "searchRecords": search_records,
            "concepts": concepts,
            "knowledgeGraph": {"nodes": concepts, "edges": relationships},
            "statistics": statistics,
            "explorer": explorer,
            "versionHistory": document_version_service.list_documents(),
            "schema": schema,
        }
        self._write_index(index)
        return index

    def _documents(self, master: dict[str, Any], chapter_reports: list[dict[str, Any]], report_by_document: dict[str, dict[str, Any]]) -> list[dict[str, Any]]:
        documents = []
        current_docs = {path.name: path for path in CONFIG.input_pdf_dir.glob("*.pdf")}
        source_documents = unique_preserve([*master.get("source_documents", []), *sorted(current_docs.keys(), key=str.casefold)])
        ready_documents = set(master.get("source_documents", []))
        for document_name in source_documents:
            path = current_docs.get(document_name)
            if not path:
                continue
            lineage = document_version_service.get_lineage(document_name)
            report = report_by_document.get(document_name, {})
            latest_version = lineage["versions"][-1] if lineage and lineage.get("versions") else None
            latest_metadata = latest_version.get("metadata", {}) if latest_version else {}
            chapter_number = report.get("summary", {}).get("chapter_number")
            if not chapter_number:
                filename_match = re.search(r"chapter[\s_\-+]*(\d+)", document_name, flags=re.IGNORECASE)
                chapter_number = filename_match.group(1) if filename_match else ""
            chapter_candidates = [
                chapter
                for chapter in chapter_reports
                if str(chapter.get("chapter_number", "")) == str(chapter_number or "")
            ]
            page_count = max(
                [
                    0,
                    *[
                        page
                        for chapter in chapter_candidates
                        for section in chapter.get("sections", [])
                        if isinstance(section, dict)
                        for page in section.get("pages", [])
                        if isinstance(page, int)
                    ],
                ]
            )
            if not page_count:
                searchable = _safe_json(CONFIG.json_dir / f"{Path(document_name).stem}_searchable.json", {})
                searchable_pages = [
                    int(page)
                    for section in searchable.get("sections", [])
                    if isinstance(section, dict)
                    for page in section.get("pages", [])
                    if isinstance(page, int)
                ]
                page_count = max([0, *searchable_pages])
            page_count = int(page_count or report.get("summary", {}).get("page_count", 0) or latest_metadata.get("pages", 0) or 0)
            version_status = str(latest_version.get("status", "")) if latest_version else ""
            status = version_status or ("ready" if document_name in ready_documents else "processing")
            if document_name not in ready_documents and status == "ready":
                status = "processing"
            if page_count <= 0:
                status = "failed"
            error_message = ""
            if latest_version:
                error_message = str(latest_version.get("error", "") or latest_metadata.get("error", "")).strip()
            documents.append(
                {
                    "id": "-".join("".join(char.lower() if char.isalnum() else "-" for char in document_name).split("-")),
                    "lineageId": lineage["lineageId"] if lineage else None,
                    "name": document_name,
                    "version": latest_version["label"] if latest_version else "v1",
                    "versionCount": len(lineage["versions"]) if lineage else 1,
                    "pages": page_count,
                    "sections": int(report.get("summary", {}).get("section_count", latest_metadata.get("sections", 0)) or 0),
                    "rules": int(report.get("summary", {}).get("rule_count", latest_metadata.get("rules", 0)) or 0),
                    "conditions": int(report.get("summary", {}).get("condition_count", latest_metadata.get("conditions", 0)) or 0),
                    "exceptions": int(report.get("summary", {}).get("exception_count", latest_metadata.get("exceptions", 0)) or 0),
                    "authorities": int(report.get("summary", {}).get("authority_count", 0) or 0),
                    "workflows": int(report.get("summary", {}).get("workflow_count", latest_metadata.get("workflows", 0)) or 0),
                    "glossaryTerms": int(report.get("summary", {}).get("glossary_count", 0) or 0),
                    "chapterCount": 1,
                    "chapterTitle": next((chapter["chapter_title"] for chapter in chapter_candidates), "DGFT Knowledge Source"),
                    "uploadedAt": _iso_timestamp(path),
                    "lastUpdated": _iso_timestamp(path),
                    "sizeKb": round(path.stat().st_size / 1024),
                    "status": status,
                    "progress": 100 if status != "processing" else 65,
                    "summary": _clean(
                        error_message
                        or next(
                            (chapter["summary_en"] for chapter in chapter_candidates),
                            "Structured DGFT knowledge extracted for semantic search and grounded answers.",
                        ),
                        220,
                    ),
                    "stages": self._document_stages(status),
                }
            )
        return sorted(documents, key=lambda item: item["name"])

    def _chapters(self, chapter_reports: list[dict[str, Any]]) -> list[dict[str, Any]]:
        return [
            {
                "chapter_number": str(chapter.get("chapter_number", "")),
                "chapter_title": str(chapter.get("chapter_title", "")),
                "summary_en": str(chapter.get("summary_en", "")),
                "summary_thanglish": str(chapter.get("summary_thanglish", "")),
                "section_count": int(chapter.get("section_count", 0)),
                "rule_count": int(chapter.get("rule_count", 0)),
                "condition_count": int(chapter.get("condition_count", 0)),
                "validation_count": int(chapter.get("validation_count", 0)),
                "workflow_count": int(chapter.get("workflow_count", 0)),
                "authority_count": int(chapter.get("authority_count", 0)),
                "timeline_count": int(chapter.get("timeline_count", 0)),
                "exception_count": int(chapter.get("exception_count", 0)),
                "related_chapters": unique_preserve(chapter.get("related_chapters", [])),
                "sections": [section for section in chapter.get("sections", []) if isinstance(section, dict)],
            }
            for chapter in chapter_reports
        ]

    def _concept_graph(self, topics: list[dict[str, Any]], sections: list[dict[str, Any]]) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
        nodes: list[dict[str, Any]] = []
        edges: list[dict[str, Any]] = []
        section_by_code = {section["id"]: section for section in sections}
        for topic in topics:
            topic_name = str(topic.get("topic", ""))
            topic_id = f'concept-{topic_name.casefold().replace(" ", "-")}'
            nodes.append(
                {
                    "id": topic_id,
                    "nodeType": "concept",
                    "title": topic_name,
                    "chapters": unique_preserve(topic.get("chapters", [])),
                    "sections": unique_preserve(topic.get("sections", [])),
                    "keywords": unique_preserve(topic.get("keywords", [])),
                    "vector": embedding_service.embed_text(
                        " ".join(
                            [
                                topic_name,
                                " ".join(topic.get("keywords", [])),
                                " ".join(topic.get("sections", [])),
                            ]
                        )
                    ),
                }
            )
            for chapter in topic.get("chapters", []):
                edges.append(
                    {
                        "id": f"{topic_id}-chapter-{chapter}",
                        "sourceType": "concept",
                        "sourceId": topic_id,
                        "targetType": "chapter",
                        "targetId": str(chapter),
                        "relation": "relates_to_chapter",
                    }
                )
            for section_entry in topic.get("sections", []):
                section_id = str(section_entry).split(" ", 1)[0]
                if section_id in section_by_code:
                    edges.append(
                        {
                            "id": f"{topic_id}-section-{section_id}",
                            "sourceType": "concept",
                            "sourceId": topic_id,
                            "targetType": "section",
                            "targetId": section_id,
                            "relation": "relates_to_section",
                        }
                    )
        return nodes, edges

    def _explorer(
        self,
        documents: list[dict[str, Any]],
        chapters: list[dict[str, Any]],
        sections: list[dict[str, Any]],
        rules: list[dict[str, Any]],
        conditions: list[dict[str, Any]],
        workflows: list[dict[str, Any]],
        examples: list[dict[str, Any]],
    ) -> list[dict[str, Any]]:
        sections_by_chapter: dict[str, list[dict[str, Any]]] = defaultdict(list)
        rules_by_section: dict[str, list[dict[str, Any]]] = defaultdict(list)
        conditions_by_section: dict[str, list[dict[str, Any]]] = defaultdict(list)
        workflows_by_section: dict[str, list[dict[str, Any]]] = defaultdict(list)
        examples_by_section: dict[str, list[dict[str, Any]]] = defaultdict(list)

        for section in sections:
            sections_by_chapter[section["chapterNumber"]].append(section)
        for rule in rules:
            rules_by_section[rule["sectionId"]].append(rule)
        for condition in conditions:
            conditions_by_section[condition["sectionId"]].append(condition)
        for workflow in workflows:
            workflows_by_section[workflow["section"]].append(workflow)
        for example in examples:
            examples_by_section[example["sectionId"]].append(example)

        explorer = []
        for document in documents:
            document_chapters = [chapter for chapter in chapters if any(section.get("section") in {item["id"] for item in sections if item["documentName"] == document["name"]} for section in chapter.get("sections", []))]
            explorer.append(
                {
                    "documentId": document["id"],
                    "documentName": document["name"],
                    "version": document["version"],
                    "chapters": [
                        {
                            "chapterNumber": chapter["chapter_number"],
                            "chapterTitle": chapter["chapter_title"],
                            "sections": [
                                {
                                    "sectionId": section["id"],
                                    "title": section["title"],
                                    "rules": rules_by_section.get(section["id"], []),
                                    "conditions": conditions_by_section.get(section["id"], []),
                                    "workflows": workflows_by_section.get(section["id"], []),
                                    "examples": examples_by_section.get(section["id"], []),
                                }
                                for section in sections_by_chapter.get(chapter["chapter_number"], [])
                                if section["documentName"] == document["name"]
                            ],
                        }
                        for chapter in document_chapters
                    ],
                }
            )
        return explorer

    def _extract_hs_codes(self, *values: Any) -> list[str]:
        codes: list[str] = []
        for value in values:
            codes.extend(extract_numeric_identifiers(str(value or "")))
        return unique_preserve(codes)

    def _extract_table_rows(self, section: dict[str, Any], raw_text: str, pages: list[int]) -> list[dict[str, Any]]:
        row_patterns = (
            re.compile(r"^\s*(?:\d+\s*[\.\|]\s*)?(?P<code>(?:\d[\s-]*){6,10})\s*\|\s*(?P<description>.+?)\s*$"),
            re.compile(r"^\s*(?:\d+\.\s+)?(?P<code>(?:\d[\s-]*){6,10})\s+(?P<description>[A-Za-z].+?)\s*$"),
        )
        rows: list[dict[str, Any]] = []
        seen_rows: set[tuple[str, str]] = set()
        for line in split_lines(raw_text):
            for pattern in row_patterns:
                match = pattern.match(line.strip(" |"))
                if not match:
                    continue
                code_candidates = self._extract_hs_codes(match.group("code"))
                if not code_candidates:
                    continue
                code = code_candidates[0]
                description = normalise_whitespace(match.group("description")).strip(" |")
                if len(description) < 3 or description.casefold().startswith(("pg.", "page ", "sl. no")):
                    continue
                row_key = (code, description.casefold())
                if row_key in seen_rows:
                    continue
                seen_rows.add(row_key)
                rows.append(
                    {
                        "id": f'{section["id"]}-row-{code}',
                        "entityType": "chunk",
                        "documentName": section.get("documentName", ""),
                        "chapterNumber": section.get("chapterNumber", ""),
                        "chapterTitle": section.get("chapterTitle", ""),
                        "sectionId": section.get("id", ""),
                        "title": f'{section.get("title", "")} - HS Code {code}',
                        "text": f"HS Code {code}: {description}",
                        "keywords": unique_preserve([code, description, *section.get("keywords", [])[:10]]),
                        "intent": "HS Code Lookup",
                        "tags": unique_preserve([*section.get("headings", [])[:2], "table-row", "hs-code"]),
                        "relatedSections": unique_preserve(section.get("relatedSections", [])),
                        "sourcePages": pages,
                        "hsCodes": [code],
                        "eximCodes": [code],
                        "description": description,
                        "chunkHash": stable_text_hash(f'{section.get("documentName", "")}|{section.get("id", "")}|{code}|{description}'),
                        "isTableRow": True,
                    }
                )
                break
        return rows

    def _search_record(
        self,
        record_type: str,
        record_id: str,
        title: str,
        text: str,
        section: dict[str, Any],
        source_pages: list[int],
        extra: dict[str, Any] | None = None,
    ) -> dict[str, Any]:
        searchable_text = " ".join(
            [
                title,
                text,
                section.get("chapterTitle", ""),
                " ".join(section.get("authorities", [])),
                " ".join(section.get("keywords", [])),
                " ".join(str(code) for code in (extra or {}).get("hsCodes", [])),
                str((extra or {}).get("description", "")),
            ]
        )
        payload = {
            "id": record_id,
            "type": record_type,
            "title": title,
            "text": text,
            "preview": _clean(text, 220),
            "sectionId": section.get("id", ""),
            "chapterNumber": section.get("chapterNumber", ""),
            "chapterTitle": section.get("chapterTitle", ""),
            "documentName": section.get("documentName", ""),
            "documentId": "-".join("".join(char.lower() if char.isalnum() else "-" for char in str(section.get("documentName", ""))).split("-")),
            "sourcePages": source_pages,
            "vector": embedding_service.embed_text(searchable_text),
        }
        if extra:
            payload.update(extra)
        return payload

    def _extract_headings(self, raw_text: str, title: str) -> list[str]:
        lines = split_lines(raw_text)
        headings = [title]
        for line in lines[:20]:
            if len(line) > 120:
                continue
            if line == title:
                continue
            if line.isupper() or line.istitle():
                headings.append(line)
        return unique_preserve(headings)[:8]

    def _extract_tables(self, raw_text: str) -> list[list[str]]:
        rows = []
        for line in split_lines(raw_text):
            if "|" in line:
                cells = [cell.strip() for cell in line.split("|") if cell.strip()]
                if len(cells) >= 2:
                    rows.append(cells)
        return rows[:10]

    def _extract_notes(self, raw_text: str) -> list[str]:
        return unique_preserve(
            sentence
            for sentence in split_sentences(raw_text)
            if any(marker in sentence.casefold() for marker in ["note", "provided that", "important", "caution", "explanation"])
        )[:8]

    def _extract_definitions(self, section_payload: dict[str, Any], definitions_by_term: dict[str, str]) -> dict[str, str]:
        matches = {}
        raw_text = str(section_payload.get("raw_text", ""))
        title = str(section_payload.get("title", ""))
        combined = f"{title} {raw_text}".casefold()
        generic_terms = {"and", "the", "for", "with", "from", "that", "this", "into", "have", "has", "not", "are", "was", "were", "been", "shall", "must", "may", "can", "all", "any", "to", "of", "or", "be", "it"}
        for term, definition in definitions_by_term.items():
            if len(term) < 3 or term in generic_terms:
                continue
            if f" {term} " in f" {combined} ":
                matches[term.upper() if len(term) <= 6 else term.title()] = definition
        if "definition" in title.casefold():
            for keyword in section_payload.get("keywords", [])[:6]:
                keyword_normalized = keyword.casefold()
                if len(keyword_normalized) < 3 or keyword_normalized in generic_terms:
                    continue
                if keyword_normalized not in {item.casefold() for item in matches}:
                    matches[keyword] = f"Referenced in section {section_payload.get('section')} and derived from the uploaded DGFT source."
        return matches

    def _database_schema(self) -> dict[str, Any]:
        schema = {
            "collections": {
                "documents": ["id", "lineageId", "name", "version", "versionCount", "pages", "sections", "rules", "conditions", "exceptions", "workflows"],
                "chapters": ["chapter_number", "chapter_title", "summary_en", "section_count", "rule_count"],
                "sections": ["id", "title", "chapterNumber", "documentName", "summary", "businessMeaning", "pages", "keywords", "hsCodes", "eximCodes"],
                "rules": ["id", "sectionId", "ruleName", "description", "condition", "exception", "sourcePages"],
                "conditions": ["id", "sectionId", "text", "sourcePages"],
                "workflows": ["id", "section", "steps", "sourcePages"],
                "definitions": ["id", "term", "definition", "sectionId", "sourcePages"],
                "chunks": ["id", "sectionId", "text", "sourcePages", "vector", "hsCodes", "eximCodes", "description", "chunkHash", "isTableRow"],
                "relationships": ["id", "sourceType", "sourceId", "targetType", "targetId", "relation"],
                "versionHistory": ["lineageId", "currentName", "versions"],
            },
            "storage": {
                "knowledgeIndex": str(self.index_path),
                "knowledgeSchema": str(self.schema_path),
                "documentVersions": str(runtime_store.document_versions_path),
                "chunkDirectory": str(CONFIG.chunk_output_dir),
                "embeddingDirectory": str(CONFIG.embeddings_dir),
            },
        }
        runtime_store.write_json(self.schema_path, schema)
        return schema

    def _write_index(self, payload: dict[str, Any]) -> None:
        runtime_store.write_json(self.index_path, payload)

    def _empty_index(self) -> dict[str, Any]:
        schema = self._database_schema()
        return {
            "generatedAt": None,
            "knowledgeBaseName": "DEKAI DGFT Knowledge Base",
            "documents": [],
            "chapters": [],
            "sections": [],
            "rules": [],
            "conditions": [],
            "workflows": [],
            "definitions": [],
            "authorities": [],
            "exceptions": [],
            "timelines": [],
            "examples": [],
            "faqs": [],
            "keywords": [],
            "relationships": [],
            "chunks": [],
            "searchRecords": [],
            "concepts": [],
            "knowledgeGraph": {"nodes": [], "edges": []},
            "statistics": {
                "documents": 0,
                "pages": 0,
                "chapters": 0,
                "sections": 0,
                "businessRules": 0,
                "conditions": 0,
                "exceptions": 0,
                "workflows": 0,
                "definitions": 0,
                "authorities": 0,
                "timelines": 0,
                "examples": 0,
                "faqs": 0,
                "keywords": 0,
                "relationships": 0,
                "embeddings": 0,
                "vectorCount": 0,
            },
            "explorer": [],
            "versionHistory": document_version_service.list_documents(),
            "schema": schema,
        }


knowledge_engine_service = KnowledgeEngineService()
