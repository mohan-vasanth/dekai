from __future__ import annotations

import json
import re
from collections import defaultdict
from datetime import datetime, timezone
from html import escape
from pathlib import Path
from typing import Any

from config import CONFIG
from parser.utils import (
    extract_numeric_identifiers,
    normalise_whitespace,
    safe_document_section_slug,
    stable_text_hash,
    split_lines,
    split_sentences,
    unique_preserve,
)
from parser.xml_utils import build_section_hierarchy, canonical_xml_tag, extract_xml_fields, field_search_aliases

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


def _normalize_name(value: str) -> str:
    return " ".join(str(value or "").lower().split())


def _infer_document_type(document_name: str) -> str:
    match = re.search(r"\b([A-Z]{3,8}DEC)\b", str(document_name or ""), flags=re.IGNORECASE)
    return match.group(1).upper() if match else ""


def _section_name(section_id: str, title: str) -> str:
    candidate = normalise_whitespace(str(title or "")).strip()
    candidate = re.sub(rf"^{re.escape(str(section_id or '').strip())}\s*[.:-]?\s*", "", candidate).strip()
    return candidate or normalise_whitespace(str(title or "")).strip()


def _section_path(section_id: str, title: str, heading: str = "", xml_tag: str = "") -> str:
    return " > ".join(
        part
        for part in [
            str(section_id or "").strip(),
            normalise_whitespace(str(title or "")).strip(),
            normalise_whitespace(str(heading or "")).strip(),
            str(xml_tag or "").strip(),
        ]
        if part
    )


class KnowledgeEngineService:
    def __init__(self) -> None:
        self.index_path = runtime_store.knowledge_index_path
        self.schema_path = runtime_store.knowledge_schema_path

    def _index_requires_refresh(self, payload: dict[str, Any]) -> bool:
        required_top_level_keys = {
            "documentMemories",
            "sectionMemories",
            "fieldMemories",
            "tableMemories",
            "ruleMemories",
            "definitionMemories",
            "exampleMemories",
            "relationshipMemories",
            "keywordMemories",
            "entityMemories",
            "synonymMemories",
            "indexes",
        }
        if any(key not in payload for key in required_top_level_keys):
            return True
        for collection_name in ("chunks", "searchRecords"):
            for item in payload.get(collection_name, []):
                if not isinstance(item, dict):
                    continue
                if any(key not in item for key in ("documentType", "sectionName", "sectionPath")):
                    return True
                if collection_name == "chunks" and any(key not in item for key in ("xmlTag", "fieldName", "pageNumber", "sourceText")):
                    return True
                if collection_name == "searchRecords" and any(key not in item for key in ("pageNumber", "sourceText")):
                    return True
                break
        return False

    def _latest_source_mtime(self) -> float:
        paths: list[Path] = [
            CONFIG.json_dir / "master_knowledge_base.json",
            CONFIG.reports_dir / "chapter_reports.json",
            runtime_store.document_versions_path,
        ]
        paths.extend(CONFIG.json_dir.glob("*_searchable.json"))
        paths.extend(CONFIG.reports_dir.glob("*_report.json"))
        paths.extend(CONFIG.chunk_output_dir.glob("*.json"))

        latest_mtime = 0.0
        for path in paths:
            if not path.exists():
                continue
            try:
                latest_mtime = max(latest_mtime, path.stat().st_mtime)
            except OSError:
                continue
        return latest_mtime

    def _document_stages(self, status: str) -> list[dict[str, str]]:
        labels = [
            "Queued",
            "Validate PDF",
            "Extract Text",
            "Convert to Markdown",
            "Identify Sections",
            "Generate Chunks",
            "Create Embeddings",
            "Index into Knowledge Base",
            "Ready",
        ]
        if status == "queued":
            return [
                {"label": label, "state": "current" if index == 0 else "upcoming"}
                for index, label in enumerate(labels)
            ]
        if status == "ready":
            return [{"label": label, "state": "complete"} for label in labels]
        if status == "failed":
            return [
                {"label": label, "state": "complete" if index <= 1 else "current" if index == 2 else "upcoming"}
                for index, label in enumerate(labels)
            ]
        return [
            {"label": label, "state": "complete" if index <= 1 else "current" if index == 2 else "upcoming"}
            for index, label in enumerate(labels)
        ]

    def load_index(self, refresh: bool = False) -> dict[str, Any]:
        if refresh or not self.index_path.exists():
            return self.build_index()
        try:
            if self._latest_source_mtime() > self.index_path.stat().st_mtime:
                return self.build_index()
        except OSError:
            return self.build_index()
        cached = runtime_store.read_json(self.index_path, {})
        if cached:
            if self._index_requires_refresh(cached):
                return self.build_index()
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
        known_documents = {
            str(name).strip()
            for name in [
                *master.get("source_documents", []),
                *[path.name for path in CONFIG.input_pdf_dir.glob("*.pdf")],
            ]
            if str(name).strip()
        }
        for searchable_file in CONFIG.json_dir.glob("*_searchable.json"):
            payload = _safe_json(searchable_file, None)
            if not isinstance(payload, dict):
                continue
            source_pdf = str(payload.get("source_pdf", "")).strip()
            if known_documents and source_pdf and source_pdf not in known_documents:
                continue
            for section_payload in payload.get("sections", []):
                if isinstance(section_payload, dict) and section_payload.get("section"):
                    sections_raw.append(section_payload)

        if not sections_raw:
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
            section_xml_fields = extract_xml_fields(
                raw_text,
                page_numbers=pages,
                section_number=section_id,
                section_title=title,
                document_name=document_name,
            )
            headings = self._extract_headings(raw_text, title)
            tables = self._extract_tables(raw_text)
            notes = self._extract_notes(raw_text)
            section_definitions = self._extract_definitions(section_payload, definitions_by_term)
            hierarchy_nodes = [
                node
                for node in section_payload.get("hierarchy_nodes", [])
                if isinstance(node, dict)
            ]
            if not hierarchy_nodes:
                hierarchy_nodes = build_section_hierarchy(
                    raw_text,
                    page_numbers=pages,
                    section_number=section_id,
                    section_title=title,
                    document_name=document_name,
                    notes=notes,
                    exceptions=section_payload.get("exceptions", []),
                    business_rules=section_payload.get("business_rules", []),
                    validations=section_payload.get("validations", []),
                    definitions=[
                        {"term": term, "definition": definition}
                        for term, definition in section_definitions.items()
                    ],
                )
            section_field_names = unique_preserve(
                [
                    *[str(field.get("tag_name", "")) for field in section_xml_fields],
                    *[str(field.get("normalized_tag_name", "")) for field in section_xml_fields],
                ]
            )
            section_keywords = unique_preserve(
                [
                    *section_payload.get("search_keywords", []),
                    *section_payload.get("keywords", []),
                    *section_definitions.keys(),
                    *section_field_names,
                ]
            )
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
                "documentTitle": Path(document_name).stem,
                "documentName": document_name,
                "documentType": _infer_document_type(document_name),
                "sectionName": _section_name(section_id, title),
                "sectionPath": _section_path(section_id, title),
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
                "conditions": unique_preserve(section_payload.get("conditions", [])),
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
                "fieldNames": section_field_names,
                "xmlFields": section_xml_fields,
                "hierarchyNodes": hierarchy_nodes,
                "hsCodes": section_hs_codes,
                "eximCodes": section_hs_codes,
                "relatedSections": related_sections,
                "sourcePages": pages,
                "rawText": raw_text,
                "keyValuePairs": self._extract_key_value_pairs(raw_text),
                "codeBlocks": self._extract_code_blocks(raw_text),
                "references": self._extract_references(raw_text),
                "enumerations": self._extract_enumerations(raw_text),
            }
            section_record["fieldDefinitions"] = self._field_definitions(section_record)
            section_record["semanticTree"] = self._section_semantic_tree(section_record)
            section_record["tableRows"] = self._extract_table_rows(section_record, raw_text, pages)
            section_record["codeLists"] = self._extract_code_lists(section_record)
            section_record["hsCodes"] = unique_preserve(
                [*section_record["hsCodes"], *[code for row in section_record["tableRows"] for code in row.get("hsCodes", [])]]
            )
            section_record["eximCodes"] = list(section_record["hsCodes"])
            sections.append(section_record)

            chunk_payload = _safe_json(CONFIG.chunk_output_dir / f"{safe_document_section_slug(document_name, section_id, title)}.json", [])
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
                        "field_names": section_field_names,
                        "xml_fields": section_xml_fields,
                    }
                ]
            for chunk in chunk_payload:
                if not isinstance(chunk, dict):
                    continue
                chunk_text = str(chunk.get("text", ""))
                chunk_xml_fields = [
                    field
                    for field in chunk.get("xml_fields", [])
                    if isinstance(field, dict)
                ]
                if not chunk_xml_fields:
                    chunk_xml_fields = extract_xml_fields(
                        chunk_text,
                        page_numbers=[int(page) for page in chunk.get("source_pages", pages) if isinstance(page, int)],
                        section_number=section_id,
                        section_title=title,
                        document_name=document_name,
                    )
                primary_xml_field = chunk_xml_fields[0] if chunk_xml_fields else {}
                primary_tag_name = str(chunk.get("tag_name", "")).strip() or str(primary_xml_field.get("tag_name", ""))
                primary_field_code = str(chunk.get("field_code", "")).strip() or str(primary_xml_field.get("field_code", ""))
                primary_field_name = str(chunk.get("field_name", "")).strip() or primary_tag_name
                primary_xml_tag = str(chunk.get("xml_tag", "")).strip() or canonical_xml_tag(primary_tag_name)
                heading = str(chunk.get("heading", "")).strip()
                chunk_field_names = unique_preserve(
                    [
                        *chunk.get("field_names", []),
                        *[str(field.get("tag_name", "")) for field in chunk_xml_fields],
                        *[str(field.get("normalized_tag_name", "")) for field in chunk_xml_fields],
                    ]
                )
                chunk_record = {
                    "id": chunk.get("chunk_id") or f"{section_id}-chunk-{chunk.get('chunk_index', 1)}",
                    "entityType": "chunk",
                    "documentName": document_name,
                    "documentType": str(chunk.get("document_type", "")).strip() or _infer_document_type(document_name),
                    "chapterNumber": chapter_number,
                    "chapterTitle": section_record["chapterTitle"],
                    "sectionId": section_id,
                    "sectionName": str(chunk.get("section_name", "")).strip() or section_record["sectionName"],
                    "sectionPath": str(chunk.get("section_path", "")).strip() or _section_path(section_id, title, heading, primary_xml_tag),
                    "title": title,
                    "text": chunk_text,
                    "sourceText": str(chunk.get("source_text", "")).strip() or chunk_text,
                    "keywords": unique_preserve(chunk.get("keywords", [])),
                    "intent": str(chunk.get("intent", "")),
                    "tags": unique_preserve(chunk.get("tags", [])),
                    "relatedSections": unique_preserve(chunk.get("related_sections", [])),
                    "sourcePages": [int(page) for page in chunk.get("source_pages", pages) if isinstance(page, int)],
                    "pageNumber": int(chunk.get("page_number", 0) or 0) or ([int(page) for page in chunk.get("source_pages", pages) if isinstance(page, int)] or [0])[0],
                    "hsCodes": self._extract_hs_codes(chunk_text, *chunk.get("hs_codes", [])),
                    "eximCodes": self._extract_hs_codes(chunk_text, *chunk.get("exim_codes", [])),
                    "description": str(chunk.get("description", "")).strip(),
                    "chunkHash": str(chunk.get("chunk_hash", "")).strip() or stable_text_hash(chunk_text),
                    "isTableRow": bool(chunk.get("is_table_row", False)),
                    "heading": heading,
                    "fieldNames": chunk_field_names,
                    "fieldCode": primary_field_code,
                    "fieldName": primary_field_name,
                    "xmlTag": primary_xml_tag,
                    "tagName": primary_tag_name,
                    "normalizedTagName": str(chunk.get("normalized_tag_name", "")).strip() or str(primary_xml_field.get("normalized_tag_name", "")),
                    "namespace": str(chunk.get("namespace", "")).strip() or str(primary_xml_field.get("namespace", "")),
                    "xmlFields": chunk_xml_fields,
                }
                chunk_record["vector"] = embedding_service.embed_text(
                    " ".join(
                        [
                            chunk_record["tagName"],
                            chunk_record["normalizedTagName"],
                            chunk_record["heading"],
                            chunk_record["title"],
                            chunk_record["text"],
                            " ".join(chunk_record["keywords"]),
                            " ".join(chunk_record["tags"]),
                            " ".join(chunk_record["fieldNames"]),
                            " ".join(
                                alias
                                for field in chunk_xml_fields
                                for alias in field_search_aliases(str(field.get("tag_name", "")))
                            ),
                            " ".join(chunk_record["hsCodes"]),
                            chunk_record["description"],
                        ]
                    )
                )
                chunks.append(chunk_record)

            chunks.extend(section_record["tableRows"])

            for field_index, field_definition in enumerate(section_record["fieldDefinitions"], start=1):
                field_record = {
                    "id": str(field_definition.get("id", "")) or f"{section_id}-field-{field_index}",
                    "sectionId": section_id,
                    "title": str(field_definition.get("fieldName", "") or field_definition.get("xmlTag", "") or title).strip(),
                    "chapterNumber": chapter_number,
                    "chapterTitle": section_record["chapterTitle"],
                    "documentName": document_name,
                    "fieldCode": str(field_definition.get("fieldCode", "")).strip(),
                    "fieldName": str(field_definition.get("fieldName", "")).strip(),
                    "xmlTag": str(field_definition.get("xmlTag", "")).strip(),
                    "tagName": str(field_definition.get("tagName", "")).strip(),
                    "normalizedTagName": str(field_definition.get("normalizedTagName", "")).strip(),
                    "namespace": str(field_definition.get("namespace", "")).strip(),
                    "aliases": unique_preserve(field_definition.get("aliases", [])),
                    "summary": str(field_definition.get("summary", "")).strip(),
                    "required": bool(field_definition.get("required", False)),
                    "allowedValues": unique_preserve(field_definition.get("allowedValues", [])),
                    "sourcePages": pages,
                }
                search_records.append(
                    self._search_record(
                        "field",
                        field_record["id"],
                        field_record["title"],
                        " ".join(
                            [
                                field_record["summary"],
                                " ".join(field_record["aliases"]),
                                " ".join(field_record["allowedValues"]),
                                "mandatory" if field_record["required"] else "",
                            ]
                        ).strip(),
                        section_record,
                        pages,
                        extra={
                            "heading": field_record["title"],
                            "fieldNames": unique_preserve(
                                [
                                    field_record["fieldName"],
                                    field_record["xmlTag"],
                                    field_record["tagName"],
                                    field_record["normalizedTagName"],
                                    *field_record["aliases"],
                                ]
                            ),
                            "fieldCode": field_record["fieldCode"],
                            "fieldName": field_record["fieldName"] or field_record["title"],
                            "xmlTag": field_record["xmlTag"],
                            "tagName": field_record["tagName"],
                            "normalizedTagName": field_record["normalizedTagName"],
                            "namespace": field_record["namespace"],
                            "documentType": section_record.get("documentType", ""),
                            "sectionName": section_record.get("sectionName", ""),
                            "sectionPath": section_record.get("sectionPath", ""),
                            "sourceText": field_record["summary"],
                            "searchAliases": field_record["aliases"],
                            "required": field_record["required"],
                            "allowedValues": field_record["allowedValues"],
                        },
                    )
                )

            for table_index, table in enumerate(section_record["tables"], start=1):
                table_title = f"{title} Table {table_index}"
                flattened_rows = [" | ".join(str(cell) for cell in row if str(cell).strip()) for row in table[:8]]
                html_table = self._render_html_table(table)
                search_records.append(
                    self._search_record(
                        "table",
                        f"{section_id}-table-{table_index}",
                        table_title,
                        " ".join(flattened_rows),
                        section_record,
                        pages,
                        extra={
                            "heading": table_title,
                            "fieldNames": unique_preserve(table[0] if table else []),
                            "documentType": section_record.get("documentType", ""),
                            "sectionName": section_record.get("sectionName", ""),
                            "sectionPath": f'{section_record.get("sectionPath", "")} > Table {table_index}'.strip(),
                            "sourceText": "\n".join(flattened_rows),
                            "htmlTable": html_table,
                            "tableColumns": unique_preserve(table[0] if table else []),
                            "tableRows": table[1:] if len(table) > 1 else [],
                        },
                    )
                )

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
                example_record = {
                    "id": f"{section_id}-example-{index}",
                    "text": _clean(example, 220),
                    "sectionId": section_id,
                    "chapterNumber": chapter_number,
                    "documentName": document_name,
                    "sourcePages": pages,
                }
                examples.append(example_record)
                search_records.append(
                    self._search_record("example", example_record["id"], title, example_record["text"], section_record, pages)
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
                        "fieldNames": section_record.get("fieldNames", []),
                        "documentType": section_record.get("documentType", ""),
                        "sectionName": section_record.get("sectionName", ""),
                        "sectionPath": section_record.get("sectionPath", ""),
                    },
                )
            )
            for node in hierarchy_nodes:
                node_type = str(node.get("type", "")).strip()
                node_title = str(node.get("title", "")).strip()
                node_content = str(node.get("content", "") or node.get("description", "")).strip()
                if not node_type or not node_title or not node_content:
                    continue
                search_records.append(
                    self._search_record(
                        "hierarchy",
                        str(node.get("id", "")) or f"{section_id}-hierarchy-{len(search_records) + 1}",
                        node_title,
                        node_content,
                        section_record,
                        [int(node.get("pageNumber", 0))] if str(node.get("pageNumber", "")).isdigit() else pages,
                        extra={
                            "heading": node_title,
                            "fieldNames": unique_preserve(
                                [
                                    str(node.get("title", "")),
                                    str(node.get("tagName", "")),
                                    str(node.get("normalizedTagName", "")),
                                ]
                            ),
                            "fieldCode": str(node.get("fieldCode", "")),
                            "fieldName": str(node.get("tagName", "") or node.get("title", "")).strip(),
                            "xmlTag": canonical_xml_tag(str(node.get("tagName", "") or node.get("title", ""))),
                            "tagName": str(node.get("tagName", "")),
                            "normalizedTagName": str(node.get("normalizedTagName", "")),
                            "namespace": str(node.get("namespace", "")),
                            "documentType": section_record.get("documentType", ""),
                            "sectionName": section_record.get("sectionName", ""),
                            "sectionPath": _section_path(section_id, title, node_title, canonical_xml_tag(str(node.get("tagName", "") or node_title))),
                            "nodeType": node_type,
                            "parentId": str(node.get("parentId", "")),
                            "pageNumber": int(node.get("pageNumber", 0) or 0),
                            "sourceText": node_content,
                            "searchAliases": unique_preserve(node.get("searchAliases", [])),
                        },
                    )
                )

        section_lookup = {
            (str(section.get("documentName", "")), str(section.get("id", ""))): section
            for section in sections
        }
        search_records.extend(
            self._search_record(
                "chunk",
                chunk["id"],
                f'{chunk["sectionId"]} {chunk["title"]}',
                chunk["text"],
                section_lookup.get(
                    (str(chunk.get("documentName", "")), str(chunk.get("sectionId", ""))),
                    next(
                        (
                            section
                            for section in sections
                            if str(section.get("documentName", "")) == str(chunk.get("documentName", ""))
                            and str(section.get("id", "")) == str(chunk.get("sectionId", ""))
                        ),
                        {},
                    ),
                ),
                chunk["sourcePages"],
                extra={
                    "hsCodes": chunk.get("hsCodes", []),
                    "eximCodes": chunk.get("eximCodes", []),
                    "description": chunk.get("description", ""),
                    "chunkHash": chunk.get("chunkHash", ""),
                    "isTableRow": chunk.get("isTableRow", False),
                    "heading": chunk.get("heading", ""),
                    "fieldNames": chunk.get("fieldNames", []),
                    "fieldCode": chunk.get("fieldCode", ""),
                    "fieldName": chunk.get("fieldName", "") or chunk.get("tagName", ""),
                    "xmlTag": chunk.get("xmlTag", "") or canonical_xml_tag(str(chunk.get("tagName", ""))),
                    "tagName": chunk.get("tagName", ""),
                    "normalizedTagName": chunk.get("normalizedTagName", ""),
                    "namespace": chunk.get("namespace", ""),
                    "documentType": chunk.get("documentType", ""),
                    "sectionName": chunk.get("sectionName", ""),
                    "sectionPath": chunk.get("sectionPath", ""),
                    "pageNumber": chunk.get("pageNumber", 0),
                    "sourceText": chunk.get("sourceText", "") or chunk.get("text", ""),
                    "xmlFields": chunk.get("xmlFields", []),
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
        document_memories = self._document_memories(documents, sections)
        section_memories = self._section_memories(sections)
        field_memories = self._field_memories(sections)
        table_memories = self._table_memories(sections)
        rule_memories = self._rule_memories(rules)
        definition_memories = self._definition_memories(definitions)
        example_memories = self._example_memories(examples)
        relationship_memories = self._relationship_memories(relationships)
        keyword_memories = self._keyword_memories(keywords, sections)
        entity_memories = self._entity_memories(sections, documents)
        synonym_memories = self._synonym_memories(field_memories, documents, sections)
        indexes = self._memory_indexes(
            documents=documents,
            sections=sections,
            chunks=chunks,
            search_records=search_records,
            field_memories=field_memories,
            table_memories=table_memories,
            relationship_memories=relationship_memories,
            keyword_memories=keyword_memories,
            entity_memories=entity_memories,
            synonym_memories=synonym_memories,
        )
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
            "fieldMemories": len(field_memories),
            "tableMemories": len(table_memories),
            "documentMemories": len(document_memories),
            "sectionMemories": len(section_memories),
            "entityMemories": len(entity_memories),
            "synonymMemories": len(synonym_memories),
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
            "documentMemories": document_memories,
            "sectionMemories": section_memories,
            "fieldMemories": field_memories,
            "tableMemories": table_memories,
            "ruleMemories": rule_memories,
            "definitionMemories": definition_memories,
            "exampleMemories": example_memories,
            "relationshipMemories": relationship_memories,
            "keywordMemories": keyword_memories,
            "entityMemories": entity_memories,
            "synonymMemories": synonym_memories,
            "indexes": indexes,
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
                    "progress": 100 if status not in {"queued", "processing"} else 0 if status == "queued" else 65,
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

    def _normalize_index_key(self, value: Any) -> str:
        return _normalize_name(str(value or ""))

    def _document_memories(self, documents: list[dict[str, Any]], sections: list[dict[str, Any]]) -> list[dict[str, Any]]:
        sections_by_document: dict[str, list[dict[str, Any]]] = defaultdict(list)
        for section in sections:
            sections_by_document[str(section.get("documentName", ""))].append(section)

        memories: list[dict[str, Any]] = []
        for document in documents:
            document_name = str(document.get("name", "")).strip()
            document_sections = sections_by_document.get(document_name, [])
            memories.append(
                {
                    "id": f'document-memory::{document.get("id", "")}',
                    "documentId": document.get("id", ""),
                    "documentName": document_name,
                    "documentType": _infer_document_type(document_name),
                    "summary": str(document.get("summary", "")).strip(),
                    "keywords": unique_preserve(
                        [
                            *[str(section.get("title", "")) for section in document_sections[:10]],
                            *[keyword for section in document_sections[:8] for keyword in section.get("keywords", [])[:6]],
                        ]
                    )[:40],
                    "entities": unique_preserve(
                        [
                            *[str(section.get("documentType", "")) for section in document_sections if str(section.get("documentType", "")).strip()],
                            *[code for section in document_sections for code in section.get("hsCodes", [])[:4]],
                            *[str(field.get("fieldName", "")) for section in document_sections for field in section.get("fieldDefinitions", [])[:6]],
                        ]
                    )[:40],
                    "chapters": unique_preserve(str(section.get("chapterNumber", "")) for section in document_sections if str(section.get("chapterNumber", "")).strip()),
                    "sections": unique_preserve(str(section.get("id", "")) for section in document_sections if str(section.get("id", "")).strip()),
                    "tree": [
                        {
                            "chapter": str(section.get("chapterNumber", "")).strip(),
                            "section": str(section.get("id", "")).strip(),
                            "title": str(section.get("title", "")).strip(),
                            "children": list(section.get("semanticTree", [])),
                        }
                        for section in document_sections
                    ],
                    "vector": embedding_service.embed_text(
                        " ".join(
                            [
                                document_name,
                                str(document.get("summary", "")),
                                " ".join(str(section.get("title", "")) for section in document_sections[:12]),
                            ]
                        )
                    ),
                }
            )
        return memories

    def _section_memories(self, sections: list[dict[str, Any]]) -> list[dict[str, Any]]:
        return [
            {
                "id": f'section-memory::{section.get("documentName", "")}::{section.get("id", "")}',
                "documentId": "-".join("".join(char.lower() if char.isalnum() else "-" for char in str(section.get("documentName", ""))).split("-")),
                "documentName": section.get("documentName", ""),
                "chapter": section.get("chapterNumber", ""),
                "section": section.get("id", ""),
                "subsection": "",
                "page": section.get("sourcePages", [0])[0] if section.get("sourcePages") else 0,
                "heading": section.get("title", ""),
                "aliases": unique_preserve([section.get("title", ""), section.get("sectionName", "")]),
                "keywords": unique_preserve(section.get("keywords", [])),
                "entities": unique_preserve(
                    [
                        *section.get("hsCodes", []),
                        *[definition.get("term", "") for definition in section.get("definitions", []) if isinstance(definition, dict)],
                        *[field.get("fieldName", "") for field in section.get("fieldDefinitions", []) if isinstance(field, dict)],
                    ]
                ),
                "relationships": unique_preserve(section.get("relatedSections", [])),
                "summary": str(section.get("summary", "")).strip(),
                "vector": embedding_service.embed_text(
                    " ".join(
                        [
                            str(section.get("title", "")),
                            str(section.get("summary", "")),
                            " ".join(section.get("keywords", [])[:20]),
                            " ".join(section.get("fieldNames", [])[:20]),
                        ]
                    )
                ),
            }
            for section in sections
        ]

    def _field_memories(self, sections: list[dict[str, Any]]) -> list[dict[str, Any]]:
        memories: list[dict[str, Any]] = []
        for section in sections:
            for index, field in enumerate(section.get("fieldDefinitions", []), start=1):
                if not isinstance(field, dict):
                    continue
                field_name = str(field.get("fieldName", "")).strip() or str(field.get("xmlTag", "")).strip()
                if not field_name:
                    continue
                field_code = str(field.get("fieldCode", "")).strip()
                xml_tag = str(field.get("xmlTag", "")).strip()
                aliases = unique_preserve(field.get("aliases", []))
                memories.append(
                    {
                        "id": str(field.get("id", "")) or f'{section.get("id", "")}-field-memory-{index}',
                        "documentId": "-".join("".join(char.lower() if char.isalnum() else "-" for char in str(section.get("documentName", ""))).split("-")),
                        "documentName": section.get("documentName", ""),
                        "chapter": section.get("chapterNumber", ""),
                        "section": section.get("id", ""),
                        "subsection": str(field.get("parentId", "")).strip(),
                        "page": section.get("sourcePages", [0])[0] if section.get("sourcePages") else 0,
                        "field": field_name,
                        "fieldCode": field_code,
                        "xmlTag": xml_tag,
                        "aliases": aliases,
                        "keywords": unique_preserve([field_name, field_code, xml_tag, *aliases]),
                        "entities": unique_preserve(field.get("allowedValues", [])),
                        "relationships": unique_preserve([str(field.get("parentId", "")).strip()]),
                        "summary": str(field.get("summary", "")).strip(),
                        "required": bool(field.get("required", False)),
                        "vector": embedding_service.embed_text(
                            " ".join([field_name, field_code, xml_tag, str(field.get("summary", "")), " ".join(aliases)])
                        ),
                    }
                )
        return memories

    def _table_memories(self, sections: list[dict[str, Any]]) -> list[dict[str, Any]]:
        memories: list[dict[str, Any]] = []
        for section in sections:
            for index, table in enumerate(section.get("tables", []), start=1):
                if not isinstance(table, list) or not table:
                    continue
                columns = unique_preserve(table[0] if table else [])
                row_text = [" | ".join(str(cell) for cell in row if str(cell).strip()) for row in table[1:9]]
                memories.append(
                    {
                        "id": f'{section.get("id", "")}-table-memory-{index}',
                        "documentId": "-".join("".join(char.lower() if char.isalnum() else "-" for char in str(section.get("documentName", ""))).split("-")),
                        "documentName": section.get("documentName", ""),
                        "chapter": section.get("chapterNumber", ""),
                        "section": section.get("id", ""),
                        "page": section.get("sourcePages", [0])[0] if section.get("sourcePages") else 0,
                        "heading": f'{section.get("title", "")} Table {index}',
                        "columns": columns,
                        "rows": table[1:] if len(table) > 1 else [],
                        "html": self._render_html_table(table),
                        "aliases": columns,
                        "keywords": unique_preserve([*columns, *section.get("keywords", [])[:12]]),
                        "summary": " ".join(row_text[:4]).strip(),
                        "vector": embedding_service.embed_text(
                            " ".join([str(section.get("title", "")), " ".join(columns), " ".join(row_text[:6])])
                        ),
                    }
                )
        return memories

    def _rule_memories(self, rules: list[dict[str, Any]]) -> list[dict[str, Any]]:
        return [
            {
                "id": f'rule-memory::{rule.get("id", "")}',
                "documentName": rule.get("documentName", ""),
                "chapter": rule.get("chapterNumber", ""),
                "section": rule.get("sectionId", ""),
                "aliases": unique_preserve([rule.get("ruleName", ""), rule.get("sectionTitle", "")]),
                "keywords": unique_preserve([rule.get("ruleName", ""), rule.get("condition", ""), rule.get("exception", "")]),
                "summary": rule.get("description", ""),
            }
            for rule in rules
        ]

    def _definition_memories(self, definitions: list[dict[str, Any]]) -> list[dict[str, Any]]:
        return [
            {
                "id": f'definition-memory::{item.get("id", "")}',
                "documentName": item.get("documentName", ""),
                "chapter": item.get("chapterNumber", ""),
                "section": item.get("sectionId", ""),
                "field": item.get("term", ""),
                "aliases": unique_preserve([item.get("term", "")]),
                "summary": item.get("definition", ""),
            }
            for item in definitions
        ]

    def _example_memories(self, examples: list[dict[str, Any]]) -> list[dict[str, Any]]:
        return [
            {
                "id": f'example-memory::{item.get("id", "")}',
                "documentName": item.get("documentName", ""),
                "chapter": item.get("chapterNumber", ""),
                "section": item.get("sectionId", ""),
                "summary": item.get("text", ""),
            }
            for item in examples
        ]

    def _relationship_memories(self, relationships: list[dict[str, Any]]) -> list[dict[str, Any]]:
        return [
            {
                "id": f'relationship-memory::{item.get("id", "")}',
                "sourceType": item.get("sourceType", ""),
                "sourceId": item.get("sourceId", ""),
                "targetType": item.get("targetType", ""),
                "targetId": item.get("targetId", ""),
                "relation": item.get("relation", ""),
            }
            for item in relationships
        ]

    def _keyword_memories(self, keywords: list[dict[str, Any]], sections: list[dict[str, Any]]) -> list[dict[str, Any]]:
        section_lookup = {str(section.get("id", "")): section for section in sections}
        memories: list[dict[str, Any]] = []
        for item in keywords:
            section = section_lookup.get(str(item.get("sectionId", "")), {})
            memories.append(
                {
                    "id": f'keyword-memory::{item.get("id", "")}',
                    "documentName": item.get("documentName", ""),
                    "chapter": item.get("chapterNumber", ""),
                    "section": item.get("sectionId", ""),
                    "keyword": item.get("term", ""),
                    "summary": str(section.get("summary", "")).strip(),
                }
            )
        return memories

    def _entity_memories(self, sections: list[dict[str, Any]], documents: list[dict[str, Any]]) -> list[dict[str, Any]]:
        memories: list[dict[str, Any]] = []
        document_lookup = {str(document.get("name", "")): document for document in documents}
        for section in sections:
            entities = unique_preserve(
                [
                    *section.get("hsCodes", []),
                    *[definition.get("term", "") for definition in section.get("definitions", []) if isinstance(definition, dict)],
                    *[field.get("fieldName", "") for field in section.get("fieldDefinitions", []) if isinstance(field, dict)],
                ]
            )
            for entity in entities:
                if not str(entity).strip():
                    continue
                document = document_lookup.get(str(section.get("documentName", "")), {})
                memories.append(
                    {
                        "id": f'entity-memory::{section.get("id", "")}::{self._normalize_index_key(entity)}',
                        "documentId": document.get("id", ""),
                        "documentName": section.get("documentName", ""),
                        "chapter": section.get("chapterNumber", ""),
                        "section": section.get("id", ""),
                        "entity": entity,
                        "aliases": field_search_aliases(str(entity)),
                        "summary": str(section.get("summary", "")).strip(),
                    }
                )
        return memories

    def _synonym_memories(
        self,
        field_memories: list[dict[str, Any]],
        documents: list[dict[str, Any]],
        sections: list[dict[str, Any]],
    ) -> list[dict[str, Any]]:
        document_aliases = {
            str(document.get("name", "")): unique_preserve(
                [
                    str(document.get("name", "")),
                    Path(str(document.get("name", ""))).stem,
                    str(document.get("chapterTitle", "")),
                ]
            )
            for document in documents
        }
        section_aliases = {
            f'{section.get("documentName", "")}::{section.get("id", "")}': unique_preserve(
                [
                    str(section.get("title", "")),
                    str(section.get("sectionName", "")),
                    f'{section.get("id", "")} {section.get("title", "")}'.strip(),
                ]
            )
            for section in sections
        }
        memories: list[dict[str, Any]] = []
        for field in field_memories:
            aliases = unique_preserve([field.get("field", ""), field.get("fieldCode", ""), field.get("xmlTag", ""), *field.get("aliases", [])])
            memories.append(
                {
                    "id": f'synonym-memory::{field.get("id", "")}',
                    "targetType": "field",
                    "targetId": field.get("id", ""),
                    "aliases": aliases,
                }
            )
        for document_name, aliases in document_aliases.items():
            memories.append(
                {
                    "id": f'synonym-memory::document::{self._normalize_index_key(document_name)}',
                    "targetType": "document",
                    "targetId": document_name,
                    "aliases": aliases,
                }
            )
        for key, aliases in section_aliases.items():
            memories.append(
                {
                    "id": f'synonym-memory::section::{self._normalize_index_key(key)}',
                    "targetType": "section",
                    "targetId": key,
                    "aliases": aliases,
                }
            )
        return memories

    def _memory_indexes(
        self,
        *,
        documents: list[dict[str, Any]],
        sections: list[dict[str, Any]],
        chunks: list[dict[str, Any]],
        search_records: list[dict[str, Any]],
        field_memories: list[dict[str, Any]],
        table_memories: list[dict[str, Any]],
        relationship_memories: list[dict[str, Any]],
        keyword_memories: list[dict[str, Any]],
        entity_memories: list[dict[str, Any]],
        synonym_memories: list[dict[str, Any]],
    ) -> dict[str, Any]:
        keyword_index: dict[str, list[str]] = defaultdict(list)
        field_index: dict[str, list[str]] = defaultdict(list)
        table_index: dict[str, list[str]] = defaultdict(list)
        hierarchy_index: dict[str, list[str]] = defaultdict(list)
        metadata_index: dict[str, list[str]] = defaultdict(list)
        alias_index: dict[str, list[str]] = defaultdict(list)
        entity_index: dict[str, list[str]] = defaultdict(list)
        document_index: dict[str, list[str]] = defaultdict(list)
        section_index: dict[str, list[str]] = defaultdict(list)
        vector_index: list[dict[str, Any]] = []

        for document in documents:
            document_key = self._normalize_index_key(document.get("name", ""))
            document_index[document_key].append(str(document.get("id", "")))
            metadata_index[f'document::{document_key}'].append(str(document.get("id", "")))
            vector_index.append({"type": "document", "id": str(document.get("id", "")), "documentName": str(document.get("name", ""))})

        for section in sections:
            section_key = self._normalize_index_key(f'{section.get("documentName", "")}::{section.get("id", "")}')
            section_index[section_key].append(str(section.get("id", "")))
            hierarchy_index[section_key].extend(
                str(node.get("id", ""))
                for node in section.get("hierarchyNodes", [])
                if isinstance(node, dict) and str(node.get("id", "")).strip()
            )
            metadata_index[f'section::{section_key}'].append(str(section.get("id", "")))
            for keyword in section.get("keywords", []):
                normalized_keyword = self._normalize_index_key(keyword)
                if normalized_keyword:
                    keyword_index[normalized_keyword].append(str(section.get("id", "")))
            vector_index.append({"type": "section", "id": str(section.get("id", "")), "documentName": str(section.get("documentName", ""))})

        for chunk in chunks:
            vector_index.append({"type": "chunk", "id": str(chunk.get("id", "")), "documentName": str(chunk.get("documentName", ""))})
            metadata_index[f'chunk::{self._normalize_index_key(chunk.get("id", ""))}'].append(str(chunk.get("id", "")))

        for record in search_records:
            metadata_key = self._normalize_index_key(
                " ".join(
                    [
                        str(record.get("documentName", "")),
                        str(record.get("chapterNumber", "")),
                        str(record.get("sectionId", "")),
                        str(record.get("pageNumber", "")),
                    ]
                )
            )
            if metadata_key:
                metadata_index[metadata_key].append(str(record.get("id", "")))

        for field in field_memories:
            for value in [field.get("field", ""), field.get("fieldCode", ""), field.get("xmlTag", ""), *field.get("aliases", [])]:
                normalized_value = self._normalize_index_key(value)
                if normalized_value:
                    field_index[normalized_value].append(str(field.get("id", "")))
                    alias_index[normalized_value].append(str(field.get("id", "")))

        for table in table_memories:
            for value in [table.get("heading", ""), *table.get("columns", []), *table.get("aliases", [])]:
                normalized_value = self._normalize_index_key(value)
                if normalized_value:
                    table_index[normalized_value].append(str(table.get("id", "")))

        for keyword in keyword_memories:
            normalized_value = self._normalize_index_key(keyword.get("keyword", ""))
            if normalized_value:
                keyword_index[normalized_value].append(str(keyword.get("id", "")))

        for entity in entity_memories:
            normalized_value = self._normalize_index_key(entity.get("entity", ""))
            if normalized_value:
                entity_index[normalized_value].append(str(entity.get("id", "")))
            for alias in entity.get("aliases", []):
                normalized_alias = self._normalize_index_key(alias)
                if normalized_alias:
                    alias_index[normalized_alias].append(str(entity.get("id", "")))

        for synonym in synonym_memories:
            for alias in synonym.get("aliases", []):
                normalized_alias = self._normalize_index_key(alias)
                if normalized_alias:
                    alias_index[normalized_alias].append(str(synonym.get("targetId", "")))

        for relationship in relationship_memories:
            hierarchy_index[self._normalize_index_key(relationship.get("sourceId", ""))].append(str(relationship.get("targetId", "")))

        return {
            "vectorIndex": vector_index,
            "keywordIndex": {key: unique_preserve(values) for key, values in keyword_index.items()},
            "fieldIndex": {key: unique_preserve(values) for key, values in field_index.items()},
            "tableIndex": {key: unique_preserve(values) for key, values in table_index.items()},
            "hierarchyIndex": {key: unique_preserve(values) for key, values in hierarchy_index.items()},
            "metadataIndex": {key: unique_preserve(values) for key, values in metadata_index.items()},
            "aliasIndex": {key: unique_preserve(values) for key, values in alias_index.items()},
            "entityIndex": {key: unique_preserve(values) for key, values in entity_index.items()},
            "documentIndex": {key: unique_preserve(values) for key, values in document_index.items()},
            "sectionIndex": {key: unique_preserve(values) for key, values in section_index.items()},
        }

    def _render_html_table(self, table: list[list[str]]) -> str:
        if not table:
            return ""
        rows: list[str] = []
        for row_index, row in enumerate(table):
            tag = "th" if row_index == 0 else "td"
            cells = "".join(f"<{tag}>{escape(str(cell or ''))}</{tag}>" for cell in row)
            rows.append(f"<tr>{cells}</tr>")
        return "<table>" + "".join(rows) + "</table>"

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
                " ".join(section.get("fieldNames", [])),
                str((extra or {}).get("fieldCode", "")),
                " ".join(str(code) for code in (extra or {}).get("hsCodes", [])),
                str((extra or {}).get("description", "")),
                str((extra or {}).get("tagName", "")),
                str((extra or {}).get("normalizedTagName", "")),
                " ".join(str(alias) for alias in (extra or {}).get("searchAliases", [])),
                " ".join(str(field.get("field_code", "")) for field in (extra or {}).get("xmlFields", []) if isinstance(field, dict)),
                " ".join(str(field.get("tag_name", "")) for field in (extra or {}).get("xmlFields", []) if isinstance(field, dict)),
                " ".join(str(field.get("normalized_tag_name", "")) for field in (extra or {}).get("xmlFields", []) if isinstance(field, dict)),
            ]
        )
        payload = {
            "id": record_id,
            "type": record_type,
            "title": title,
            "text": text,
            "preview": _clean(text, 220),
            "sectionId": section.get("id", ""),
            "sectionName": section.get("sectionName", _section_name(str(section.get("id", "")), str(section.get("title", "")))),
            "sectionPath": section.get("sectionPath", _section_path(str(section.get("id", "")), str(section.get("title", "")))),
            "chapterNumber": section.get("chapterNumber", ""),
            "chapterTitle": section.get("chapterTitle", ""),
            "documentName": section.get("documentName", ""),
            "documentType": section.get("documentType", _infer_document_type(str(section.get("documentName", "")))),
            "documentId": "-".join("".join(char.lower() if char.isalnum() else "-" for char in str(section.get("documentName", ""))).split("-")),
            "sourcePages": source_pages,
            "pageNumber": source_pages[0] if source_pages else 0,
            "sourceText": text,
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

    def _extract_key_value_pairs(self, raw_text: str) -> list[dict[str, str]]:
        pairs: list[dict[str, str]] = []
        for line in split_lines(raw_text):
            match = re.match(r"^(?P<key>[A-Za-z][A-Za-z0-9 /&._()-]{1,80}?):\s*(?P<value>.+)$", line)
            if not match:
                continue
            key = normalise_whitespace(match.group("key"))
            value = normalise_whitespace(match.group("value"))
            if len(value) < 2:
                continue
            pairs.append({"key": key, "value": value})
        return pairs[:25]

    def _extract_code_blocks(self, raw_text: str) -> list[str]:
        blocks: list[str] = []
        current: list[str] = []
        for line in split_lines(raw_text):
            looks_like_code = bool(
                re.search(r"[<>]{1}|^\s*(?:cbc|cac|inp|ipt):|[{}]|^\s*/", line, flags=re.IGNORECASE)
            )
            if looks_like_code:
                current.append(line)
                continue
            if len(current) >= 2:
                blocks.append("\n".join(current))
            current = []
        if len(current) >= 2:
            blocks.append("\n".join(current))
        return unique_preserve(blocks)[:8]

    def _extract_references(self, raw_text: str) -> list[str]:
        reference_markers = ("refer", "reference", "appendix", "annexure", "schedule", "chapter", "section", "see also")
        return unique_preserve(
            sentence
            for sentence in split_sentences(raw_text)
            if any(marker in sentence.casefold() for marker in reference_markers)
        )[:12]

    def _extract_enumerations(self, raw_text: str) -> list[str]:
        items = []
        for line in split_lines(raw_text):
            if re.match(r"^\s*(?:\d+[.)]|[a-zA-Z][.)]|[-*•])\s+", line):
                items.append(line)
        return unique_preserve(items)[:20]

    def _field_definitions(self, section: dict[str, Any]) -> list[dict[str, Any]]:
        definitions: list[dict[str, Any]] = []
        seen: set[str] = set()
        for index, field in enumerate(section.get("xmlFields", []), start=1):
            if not isinstance(field, dict):
                continue
            field_name = str(field.get("tag_name", "")).strip() or str(field.get("normalized_tag_name", "")).strip()
            if not field_name:
                continue
            fingerprint = self._normalize_index_key(field_name)
            if fingerprint in seen:
                continue
            seen.add(fingerprint)
            aliases = unique_preserve(field.get("search_aliases", []) or field_search_aliases(field_name))
            definitions.append(
                {
                    "id": f'{section.get("id", "")}-field-{index}',
                    "fieldName": field_name,
                    "fieldCode": str(field.get("field_code", "")).strip(),
                    "xmlTag": canonical_xml_tag(field_name),
                    "tagName": str(field.get("tag_name", "")).strip(),
                    "normalizedTagName": str(field.get("normalized_tag_name", "")).strip(),
                    "namespace": str(field.get("namespace", "")).strip(),
                    "aliases": aliases,
                    "required": bool(str(field.get("cardinality", "")).strip().upper().startswith("M")),
                    "summary": _clean(
                        " ".join(
                            [
                                str(field.get("label", "")),
                                str(field.get("description", "")),
                                str(field.get("usage_notes", "")),
                                str(field.get("title", "")),
                            ]
                        ),
                        240,
                    ),
                    "allowedValues": unique_preserve(
                        [
                            *[str(value) for value in field.get("allowed_values", []) if str(value).strip()],
                            *extract_numeric_identifiers(str(field.get("description", ""))),
                        ]
                    )[:20],
                }
            )
        for definition in section.get("definitions", []):
            if not isinstance(definition, dict):
                continue
            term = str(definition.get("term", "")).strip()
            if not term:
                continue
            fingerprint = self._normalize_index_key(term)
            if fingerprint in seen:
                continue
            seen.add(fingerprint)
            aliases = unique_preserve(field_search_aliases(term))
            definitions.append(
                {
                    "id": f'{section.get("id", "")}-field-definition-{len(definitions) + 1}',
                    "fieldName": term,
                    "fieldCode": "",
                    "xmlTag": canonical_xml_tag(term),
                    "tagName": term,
                    "normalizedTagName": canonical_xml_tag(term),
                    "namespace": "",
                    "aliases": aliases,
                    "required": False,
                    "summary": str(definition.get("definition", "")).strip(),
                    "allowedValues": [],
                }
            )
        return definitions[:40]

    def _extract_code_lists(self, section: dict[str, Any]) -> list[dict[str, str]]:
        code_lists: list[dict[str, str]] = []
        for row in section.get("tableRows", []):
            code = next(iter(row.get("hsCodes", []) or row.get("eximCodes", [])), "")
            description = str(row.get("description", "") or row.get("text", "")).strip()
            if code and description:
                code_lists.append({"code": code, "value": description})
        for line in split_lines(str(section.get("rawText", ""))):
            match = re.match(r"^(?P<code>[A-Za-z0-9._/-]{1,12})\s*[:=-]\s*(?P<value>.+)$", line)
            if not match:
                continue
            code_lists.append({"code": match.group("code"), "value": normalise_whitespace(match.group("value"))})
        unique_rows = []
        seen: set[tuple[str, str]] = set()
        for item in code_lists:
            key = (item["code"], item["value"].casefold())
            if key in seen:
                continue
            seen.add(key)
            unique_rows.append(item)
        return unique_rows[:40]

    def _section_semantic_tree(self, section: dict[str, Any]) -> list[dict[str, Any]]:
        children: list[dict[str, Any]] = []
        for heading in section.get("headings", [])[:8]:
            children.append({"type": "heading", "title": heading})
        for field in section.get("fieldDefinitions", [])[:12]:
            children.append({"type": "field", "title": str(field.get("fieldName", "")).strip()})
        for index, table in enumerate(section.get("tables", []), start=1):
            children.append({"type": "table", "title": f'Table {index}', "columns": unique_preserve(table[0] if table else [])})
        for rule in section.get("businessRules", [])[:8]:
            children.append({"type": "rule", "title": str(rule.get("name", "")).strip()})
        for example in section.get("examples", [])[:4]:
            children.append({"type": "example", "title": _clean(example, 120)})
        return children

    def _extract_definitions(self, section_payload: dict[str, Any], definitions_by_term: dict[str, str]) -> dict[str, str]:
        matches = {}
        raw_text = str(section_payload.get("raw_text", ""))
        title = str(section_payload.get("title", ""))
        combined = f"{title} {raw_text}".casefold()
        generic_terms = {"and", "the", "for", "with", "from", "that", "this", "into", "have", "has", "not", "are", "was", "were", "been", "shall", "must", "may", "can", "all", "any", "to", "of", "or", "be", "it", "section", "details", "detail", "document", "reference", "prepared", "official", "closed"}
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
                "sections": ["id", "title", "chapterNumber", "documentName", "documentType", "sectionName", "sectionPath", "summary", "businessMeaning", "pages", "keywords", "fieldNames", "hsCodes", "eximCodes", "conditions", "hierarchyNodes"],
                "rules": ["id", "sectionId", "ruleName", "description", "condition", "exception", "sourcePages"],
                "conditions": ["id", "sectionId", "text", "sourcePages"],
                "workflows": ["id", "section", "steps", "sourcePages"],
                "definitions": ["id", "term", "definition", "sectionId", "sourcePages"],
                "chunks": ["id", "sectionId", "sectionName", "sectionPath", "text", "sourceText", "documentType", "sourcePages", "pageNumber", "vector", "hsCodes", "eximCodes", "description", "chunkHash", "isTableRow", "heading", "fieldNames", "fieldCode", "fieldName", "xmlTag", "tagName", "normalizedTagName", "namespace", "xmlFields"],
                "searchRecords": ["id", "type", "title", "text", "sourceText", "sectionId", "sectionName", "sectionPath", "documentName", "documentType", "sourcePages", "pageNumber", "heading", "fieldNames", "fieldCode", "fieldName", "xmlTag", "tagName", "normalizedTagName", "namespace", "nodeType", "parentId", "searchAliases"],
                "documentMemories": ["id", "documentId", "documentName", "summary", "keywords", "entities", "chapters", "sections", "tree", "vector"],
                "sectionMemories": ["id", "documentId", "documentName", "chapter", "section", "page", "heading", "aliases", "keywords", "entities", "relationships", "summary", "vector"],
                "fieldMemories": ["id", "documentId", "documentName", "chapter", "section", "page", "field", "fieldCode", "xmlTag", "aliases", "keywords", "entities", "relationships", "summary", "required", "vector"],
                "tableMemories": ["id", "documentId", "documentName", "chapter", "section", "page", "heading", "columns", "rows", "html", "aliases", "keywords", "summary", "vector"],
                "ruleMemories": ["id", "documentName", "chapter", "section", "aliases", "keywords", "summary"],
                "definitionMemories": ["id", "documentName", "chapter", "section", "field", "aliases", "summary"],
                "exampleMemories": ["id", "documentName", "chapter", "section", "summary"],
                "relationshipMemories": ["id", "sourceType", "sourceId", "targetType", "targetId", "relation"],
                "keywordMemories": ["id", "documentName", "chapter", "section", "keyword", "summary"],
                "entityMemories": ["id", "documentId", "documentName", "chapter", "section", "entity", "aliases", "summary"],
                "synonymMemories": ["id", "targetType", "targetId", "aliases"],
                "indexes": ["vectorIndex", "keywordIndex", "fieldIndex", "tableIndex", "hierarchyIndex", "metadataIndex", "aliasIndex", "entityIndex", "documentIndex", "sectionIndex"],
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

    def document_index_snapshot(self, document_name: str, *, refresh: bool = False) -> dict[str, Any]:
        normalized_document_name = _normalize_name(document_name)
        index = self.load_index(refresh=refresh)

        document_record = next(
            (
                document
                for document in index.get("documents", [])
                if _normalize_name(str(document.get("name", ""))) == normalized_document_name
            ),
            None,
        )
        sections = [
            section
            for section in index.get("sections", [])
            if _normalize_name(str(section.get("documentName", ""))) == normalized_document_name
        ]
        chunks = [
            chunk
            for chunk in index.get("chunks", [])
            if _normalize_name(str(chunk.get("documentName", ""))) == normalized_document_name
        ]
        search_records = [
            record
            for record in index.get("searchRecords", [])
            if _normalize_name(str(record.get("documentName", ""))) == normalized_document_name
        ]
        definitions = [
            item
            for item in index.get("definitions", [])
            if _normalize_name(str(item.get("documentName", ""))) == normalized_document_name
        ]
        exceptions = [
            item
            for item in index.get("exceptions", [])
            if _normalize_name(str(item.get("documentName", ""))) == normalized_document_name
        ]
        authorities = [
            item
            for item in index.get("authorities", [])
            if _normalize_name(str(item.get("documentName", ""))) == normalized_document_name
        ]
        workflows = [
            item
            for item in index.get("workflows", [])
            if _normalize_name(str(item.get("documentName", ""))) == normalized_document_name
        ]

        return {
            "documentId": str((document_record or {}).get("id", "")),
            "documentName": str((document_record or {}).get("name", document_name)),
            "indexed": bool(document_record),
            "metadata": {
                "status": str((document_record or {}).get("status", "")),
                "chapterTitle": str((document_record or {}).get("chapterTitle", "")),
                "pages": int((document_record or {}).get("pages", 0) or 0),
                "sections": int((document_record or {}).get("sections", 0) or 0),
            },
            "counts": {
                "sections": len(sections),
                "chunks": len(chunks),
                "searchRecords": len(search_records),
                "embeddings": len(chunks) + len(search_records),
                "definitions": len(definitions),
                "exceptions": len(exceptions),
                "authorities": len(authorities),
                "workflows": len(workflows),
            },
            "sampleChunkIds": [str(chunk.get("id", "")) for chunk in chunks[:10]],
            "sampleSectionIds": [str(section.get("id", "")) for section in sections[:10]],
        }

    def document_is_queryable(self, document_name: str, *, refresh: bool = False) -> bool:
        snapshot = self.document_index_snapshot(document_name, refresh=refresh)
        counts = snapshot.get("counts", {})
        return bool(snapshot.get("indexed")) and int(counts.get("sections", 0) or 0) > 0 and int(counts.get("chunks", 0) or 0) > 0 and int(counts.get("embeddings", 0) or 0) > 0

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
            "documentMemories": [],
            "sectionMemories": [],
            "fieldMemories": [],
            "tableMemories": [],
            "ruleMemories": [],
            "definitionMemories": [],
            "exampleMemories": [],
            "relationshipMemories": [],
            "keywordMemories": [],
            "entityMemories": [],
            "synonymMemories": [],
            "indexes": {
                "vectorIndex": [],
                "keywordIndex": {},
                "fieldIndex": {},
                "tableIndex": {},
                "hierarchyIndex": {},
                "metadataIndex": {},
                "aliasIndex": {},
                "entityIndex": {},
                "documentIndex": {},
                "sectionIndex": {},
            },
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
                "fieldMemories": 0,
                "tableMemories": 0,
                "documentMemories": 0,
                "sectionMemories": 0,
                "entityMemories": 0,
                "synonymMemories": 0,
                "embeddings": 0,
                "vectorCount": 0,
            },
            "explorer": [],
            "versionHistory": document_version_service.list_documents(),
            "schema": schema,
        }


knowledge_engine_service = KnowledgeEngineService()
