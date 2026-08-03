from __future__ import annotations

from collections import OrderedDict
from html import escape
from typing import Any, Iterable

from .models import DocumentKnowledge, SectionKnowledge
from .utils import normalise_whitespace, source_document_markdown_name, unique_preserve


class DocumentMarkdownConverter:
    def convert_document(self, document: DocumentKnowledge) -> str:
        return self.convert_payload(
            document_name=document.source_pdf.name,
            page_count=document.page_count,
            sections=[self._section_payload(section) for section in document.sections],
            glossary=document.glossary,
        )

    def convert_payload(
        self,
        *,
        document_name: str,
        page_count: int,
        sections: Iterable[dict[str, Any]],
        glossary: dict[str, str] | None = None,
    ) -> str:
        normalized_sections = [self._normalize_section(section) for section in sections]
        chapter_index: OrderedDict[tuple[str, str], list[dict[str, Any]]] = OrderedDict()
        for section in sorted(
            normalized_sections,
            key=lambda item: (self._numeric_key(item["chapter_number"]), self._numeric_key(item["section"]), item["title"].casefold()),
        ):
            chapter_key = (section["chapter_number"], section["chapter_title"])
            chapter_index.setdefault(chapter_key, []).append(section)

        lines: list[str] = [
            f"# {document_name}",
            "",
            "## Document Metadata",
            f"- Source File: {document_name}",
            f"- Markdown File: {source_document_markdown_name(document_name)}",
            f"- Total Pages: {int(page_count or 0)}",
            f"- Total Chapters: {len(chapter_index)}",
            f"- Total Sections: {len(normalized_sections)}",
            "",
        ]

        if normalized_sections:
            lines.extend(["## Table of Contents", ""])
            for chapter_number, chapter_title in chapter_index:
                lines.append(f"- Chapter {chapter_number}: {chapter_title}")
                for section in chapter_index[(chapter_number, chapter_title)]:
                    lines.append(f"  - Section {section['section']}: {section['title']}")
            lines.append("")

        for chapter_number, chapter_title in chapter_index:
            chapter_sections = chapter_index[(chapter_number, chapter_title)]
            lines.extend(
                [
                    f"## Chapter {chapter_number}: {chapter_title}",
                    "",
                    f"- Sections: {len(chapter_sections)}",
                    f"- Pages Covered: {self._pages_label(page for section in chapter_sections for page in section['pages'])}",
                    "",
                ]
            )
            for section in chapter_sections:
                lines.extend(
                    [
                        f"### Section {section['section']}: {section['title']}",
                        "",
                        f"- Pages: {self._pages_label(section['pages'])}",
                        "",
                    ]
                )
                if section["summary"]:
                    lines.extend(["#### Summary", "", section["summary"], ""])
                if section["purpose"]:
                    lines.extend(["#### Purpose", "", section["purpose"], ""])
                if section["business_meaning"]:
                    lines.extend(["#### Business Meaning", "", section["business_meaning"], ""])
                if section["required_documents"]:
                    lines.extend(["#### Required Documents", *[f"- {item}" for item in section["required_documents"]], ""])
                if section["authorities"]:
                    lines.extend(["#### Authorities", *[f"- {item}" for item in section["authorities"]], ""])
                if section["workflow"]:
                    lines.extend(["#### Workflow", *[f"{index}. {step}" for index, step in enumerate(section["workflow"], start=1)], ""])
                if section["conditions"]:
                    lines.extend(["#### Conditions", *[f"- {item}" for item in section["conditions"]], ""])
                if section["exceptions"]:
                    lines.extend(["#### Exceptions", *[f"- {item}" for item in section["exceptions"]], ""])
                if section["tables"]:
                    lines.extend(["#### HTML Tables", ""])
                    for table_index, table in enumerate(section["tables"], start=1):
                        lines.append(f"<!-- dekai:html-table {section['section']}:{table_index} -->")
                        lines.append(self._render_html_table(table))
                        lines.append("")
                if section["raw_text"]:
                    lines.extend(["#### Source Content", "", "~~~text", section["raw_text"], "~~~", ""])

        if glossary:
            glossary_items = [(term, normalise_whitespace(definition)) for term, definition in glossary.items() if normalise_whitespace(definition)]
            if glossary_items:
                lines.extend(["## Glossary", ""])
                for term, definition in glossary_items:
                    lines.append(f"- **{term}**: {definition}")
                lines.append("")

        return "\n".join(lines).strip() + "\n"

    def _section_payload(self, section: SectionKnowledge) -> dict[str, Any]:
        return {
            "chapter_number": section.chapter_number,
            "chapter_title": section.chapter_title,
            "section": section.section,
            "title": section.title,
            "summary": section.summary,
            "purpose": section.purpose,
            "business_meaning": section.business_meaning,
            "raw_text": section.raw_text,
            "pages": section.pages,
            "required_documents": section.required_documents or section.documents,
            "tables": section.tables,
            "authorities": section.authorities,
            "workflow": section.workflow,
            "conditions": section.conditions,
            "exceptions": section.exceptions,
        }

    def _normalize_section(self, section: dict[str, Any]) -> dict[str, Any]:
        pages = sorted({int(page) for page in section.get("pages", []) if str(page).isdigit() or isinstance(page, int)})
        return {
            "chapter_number": str(section.get("chapter_number", "")).strip() or "Unspecified",
            "chapter_title": str(section.get("chapter_title", "")).strip() or "Untitled Chapter",
            "section": str(section.get("section", "")).strip() or "Unspecified",
            "title": str(section.get("title", "")).strip() or "Untitled Section",
            "summary": normalise_whitespace(str(section.get("summary", ""))),
            "purpose": normalise_whitespace(str(section.get("purpose", ""))),
            "business_meaning": normalise_whitespace(str(section.get("business_meaning", ""))),
            "raw_text": str(section.get("raw_text", "")).strip(),
            "pages": pages,
            "required_documents": unique_preserve(section.get("required_documents", []) or section.get("documents", [])),
            "tables": [self._normalize_table(table) for table in section.get("tables", []) if self._normalize_table(table)],
            "authorities": unique_preserve(section.get("authorities", [])),
            "workflow": unique_preserve(section.get("workflow", [])),
            "conditions": unique_preserve(section.get("conditions", [])),
            "exceptions": unique_preserve(section.get("exceptions", [])),
        }

    def _pages_label(self, pages: Iterable[int]) -> str:
        ordered_pages = sorted({int(page) for page in pages if isinstance(page, int)})
        return ", ".join(str(page) for page in ordered_pages) if ordered_pages else "Not available"

    def _numeric_key(self, value: str) -> tuple[int, ...]:
        parts: list[int] = []
        for item in str(value or "").split("."):
            try:
                parts.append(int(item))
            except ValueError:
                parts.append(9999)
        return tuple(parts or [9999])

    def _normalize_table(self, table: Any) -> list[list[str]]:
        normalized_rows: list[list[str]] = []
        if not isinstance(table, list):
            return normalized_rows

        for row in table:
            if not isinstance(row, list):
                continue
            normalized_row = [normalise_whitespace(str(cell or "")) for cell in row]
            if any(normalized_row):
                normalized_rows.append(normalized_row)

        return normalized_rows

    def _render_html_table(self, table: list[list[str]]) -> str:
        if not table:
            return ""

        if len(table) == 1:
            body_rows = table
            lines = ["<table>", "  <tbody>"]
        else:
            header_row = table[0]
            body_rows = table[1:]
            lines = ["<table>", "  <thead>", "    <tr>"]
            for cell in header_row:
                lines.append(f"      <th>{self._render_html_cell(cell)}</th>")
            lines.extend(["    </tr>", "  </thead>", "  <tbody>"])

        for row in body_rows:
            lines.append("    <tr>")
            for cell in row:
                lines.append(f"      <td>{self._render_html_cell(cell)}</td>")
            lines.append("    </tr>")

        lines.extend(["  </tbody>", "</table>"])
        return "\n".join(lines)

    def _render_html_cell(self, value: str) -> str:
        escaped = escape(str(value or ""), quote=False)
        return escaped.replace("\n", "<br />")
