from __future__ import annotations

from collections import OrderedDict
from html import escape
import re
from typing import Any, Iterable

from .models import DocumentKnowledge, SectionKnowledge
from .utils import normalise_whitespace, source_document_markdown_name, unique_preserve


class DocumentMarkdownConverter:
    DEFAULT_CONTINUATION_HEADERS = [
        "Pallete/ Box\nYour Order\nOur Order",
        "Pallete/ Box Description\nCustomer product code\nCommercial code\nProduct description",
        "Gross weight\n(kg)",
        "Net weight\n(kg)",
        "Quantity",
        "Balance",
    ]

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
        tables = self._normalize_tables(section.get("tables", []))
        return {
            "chapter_number": str(section.get("chapter_number", "")).strip() or "Unspecified",
            "chapter_title": str(section.get("chapter_title", "")).strip() or "Untitled Chapter",
            "section": str(section.get("section", "")).strip() or "Unspecified",
            "title": str(section.get("title", "")).strip() or "Untitled Section",
            "summary": self._sanitize_single_block(str(section.get("summary", "")), tables),
            "purpose": self._sanitize_single_block(str(section.get("purpose", "")), tables),
            "business_meaning": self._sanitize_single_block(str(section.get("business_meaning", "")), tables),
            "raw_text": self._sanitize_multiline_block(str(section.get("raw_text", "")).strip(), tables),
            "pages": pages,
            "required_documents": self._sanitize_list(section.get("required_documents", []) or section.get("documents", []), tables),
            "tables": tables,
            "authorities": unique_preserve(section.get("authorities", [])),
            "workflow": self._sanitize_list(section.get("workflow", []), tables),
            "conditions": self._sanitize_list(section.get("conditions", []), tables),
            "exceptions": self._sanitize_list(section.get("exceptions", []), tables),
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

    def _normalize_tables(self, raw_tables: Iterable[Any]) -> list[list[list[str]]]:
        normalized_tables: list[list[list[str]]] = []
        last_line_item_headers: list[str] | None = None

        for table in raw_tables:
            normalized_table = self._normalize_table(table)
            if not normalized_table:
                continue

            compact_table = self._collapse_empty_columns(normalized_table)
            expanded_tables, last_line_item_headers = self._reshape_table(compact_table, last_line_item_headers)
            normalized_tables.extend(expanded_tables)

        return [table for table in normalized_tables if table]

    def _reshape_table(
        self,
        table: list[list[str]],
        last_line_item_headers: list[str] | None,
    ) -> tuple[list[list[list[str]]], list[str] | None]:
        if self._looks_like_headered_line_item_table(table):
            merged = self._merge_box_row_pairs(table)
            return [merged], merged[0]

        if self._looks_like_continuation_line_item_table(table):
            metadata_rows, line_item_rows = self._split_continuation_table(table)
            reshaped_tables: list[list[list[str]]] = []
            if metadata_rows:
                metadata_table = self._key_value_table(metadata_rows)
                if metadata_table:
                    reshaped_tables.append(metadata_table)
            line_item_headers = last_line_item_headers or list(self.DEFAULT_CONTINUATION_HEADERS)
            line_item_table = self._build_continuation_line_item_table(line_item_rows, line_item_headers)
            if line_item_table:
                reshaped_tables.append(line_item_table)
                last_line_item_headers = line_item_table[0]
            return reshaped_tables or [table], last_line_item_headers

        if self._looks_like_sparse_form_table(table):
            return [self._collapse_sparse_form_rows(table)], last_line_item_headers

        return [table], last_line_item_headers

    def _collapse_empty_columns(self, table: list[list[str]]) -> list[list[str]]:
        if not table:
            return table

        width = max(len(row) for row in table)
        keep_indexes = [index for index in range(width) if any((row[index] if index < len(row) else "").strip() for row in table)]
        if len(keep_indexes) == width:
            return table

        collapsed: list[list[str]] = []
        for row in table:
            collapsed.append([row[index] if index < len(row) else "" for index in keep_indexes])
        return collapsed

    def _looks_like_headered_line_item_table(self, table: list[list[str]]) -> bool:
        if len(table) < 2:
            return False
        header = " ".join(table[0]).casefold()
        return "customer product code" in header and "balance" in header and "quantity" in header

    def _looks_like_continuation_line_item_table(self, table: list[list[str]]) -> bool:
        if len(table) < 4:
            return False

        flattened = "\n".join(" ".join(row) for row in table).casefold()
        return (
            "shipped from:" in flattened
            and "shipping method:" in flattened
            and "box no" in flattened
            and "customer product code:" in flattened
            and "customs code:" in flattened
        )

    def _looks_like_sparse_form_table(self, table: list[list[str]]) -> bool:
        if len(table) < 2:
            return False
        width = max(len(row) for row in table)
        sparse_rows = sum(1 for row in table if sum(1 for cell in row if cell) <= max(1, width // 3))
        return width >= 5 and sparse_rows >= max(2, len(table) // 2)

    def _collapse_sparse_form_rows(self, table: list[list[str]]) -> list[list[str]]:
        collapsed: list[list[str]] = []
        for row in table:
            values = [cell for cell in row if cell]
            if values:
                collapsed.append(values)
        return collapsed or table

    def _merge_box_row_pairs(self, table: list[list[str]]) -> list[list[str]]:
        if len(table) < 2:
            return table

        header = table[0]
        merged_rows = [header]
        index = 1
        while index < len(table):
            row = table[index]
            next_row = table[index + 1] if index + 1 < len(table) else None
            if self._is_box_summary_row(row) and next_row and self._is_box_detail_row(next_row):
                merged_rows.append(self._merge_box_pair(row, next_row, len(header)))
                index += 2
                continue
            merged_rows.append(row)
            index += 1
        return merged_rows

    def _split_continuation_table(self, table: list[list[str]]) -> tuple[list[list[str]], list[list[str]]]:
        first_box_index = next((index for index, row in enumerate(table) if self._is_box_summary_row(row)), len(table))
        return table[:first_box_index], table[first_box_index:]

    def _build_continuation_line_item_table(
        self,
        rows: list[list[str]],
        headers: list[str],
    ) -> list[list[str]]:
        if not rows:
            return []

        merged_rows: list[list[str]] = [headers]
        width = len(headers)
        index = 0
        while index < len(rows):
            row = rows[index]
            next_row = rows[index + 1] if index + 1 < len(rows) else None
            if self._is_box_summary_row(row) and next_row and self._is_box_detail_row(next_row):
                merged_rows.append(self._merge_box_pair(row, next_row, width))
                index += 2
                continue
            if any(row):
                merged_rows.append((row + [""] * width)[:width])
            index += 1
        return merged_rows if len(merged_rows) > 1 else []

    def _merge_box_pair(self, summary_row: list[str], detail_row: list[str], width: int) -> list[str]:
        summary = (summary_row + [""] * width)[:width]
        detail = (detail_row + [""] * width)[:width]
        merged = [""] * width

        first_parts = [part for part in (summary[0], detail[0]) if part]
        merged[0] = "\n".join(first_parts)
        if width > 1:
            merged[1] = detail[1]
        if width > 2:
            merged[2] = summary[2] or detail[2]
        if width > 3:
            merged[3] = summary[3] or detail[3]
        if width > 4:
            merged[4] = summary[4] or detail[4]
        if width > 5:
            merged[5] = summary[5] or detail[5]

        for index in range(6, width):
            merged[index] = summary[index] or detail[index]

        return merged

    def _is_box_summary_row(self, row: list[str]) -> bool:
        return any(cell.casefold().startswith("box no") for cell in row if cell)

    def _is_box_detail_row(self, row: list[str]) -> bool:
        flattened = " ".join(cell for cell in row if cell).casefold()
        return "customer product code:" in flattened or "customs code:" in flattened

    def _key_value_table(self, rows: list[list[str]]) -> list[list[str]]:
        body_rows: list[list[str]] = []
        for row in rows:
            values = [cell for cell in row if cell]
            if not values:
                continue
            if len(values) == 1:
                label, value = self._split_label_value(values[0])
                body_rows.append([label, value])
                continue
            if len(values) == 2:
                split_values = [self._split_label_value(value) for value in values]
                if all(label and value for label, value in split_values):
                    body_rows.extend([[label, value] for label, value in split_values])
                else:
                    body_rows.append(values)
                continue
            emitted = False
            for value in values:
                label, parsed_value = self._split_label_value(value)
                if label and parsed_value:
                    body_rows.append([label, parsed_value])
                    emitted = True
            if not emitted:
                body_rows.append([values[0], "\n".join(values[1:])])

        return [["Field", "Value"], *body_rows] if body_rows else []

    def _split_label_value(self, value: str) -> tuple[str, str]:
        lines = [line for line in value.split("\n") if normalise_whitespace(line)]
        if not lines:
            return "", ""
        first_line = lines[0]
        if ":" in first_line:
            label, remainder = first_line.split(":", 1)
            merged_value = "\n".join([remainder.strip(), *lines[1:]]).strip()
            return normalise_whitespace(label), merged_value
        return first_line, "\n".join(lines[1:]).strip()

    def _render_html_table(self, table: list[list[str]]) -> str:
        if not table:
            return ""

        if len(table) == 1:
            body_rows = table
            lines = ['<table class="document-table">', "  <tbody>"]
        else:
            header_row = table[0]
            body_rows = table[1:]
            lines = ['<table class="document-table">', "  <thead>", "    <tr>"]
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

    def _sanitize_list(self, items: Iterable[Any], tables: list[list[list[str]]]) -> list[str]:
        cleaned: list[str] = []
        for item in items:
            normalized = self._sanitize_multiline_block(str(item or ""), tables)
            if normalized:
                cleaned.append(normalized)
        return unique_preserve(cleaned)

    def _sanitize_single_block(self, value: str, tables: list[list[list[str]]]) -> str:
        return normalise_whitespace(self._sanitize_multiline_block(value, tables).replace("\n", " "))

    def _sanitize_multiline_block(self, value: str, tables: list[list[list[str]]]) -> str:
        normalized = str(value or "").strip()
        if not normalized or not tables:
            return normalized

        lines = normalized.splitlines()
        filtered_lines = [line for line in lines if not self._line_is_table_derived(line, tables)]
        result = "\n".join(line for line in filtered_lines if normalise_whitespace(line)).strip()

        if result:
            return result

        return ""

    def _line_is_table_derived(self, line: str, tables: list[list[list[str]]]) -> bool:
        normalized_line = normalise_whitespace(line)
        if not normalized_line:
            return False

        if normalized_line.count("|") >= 2:
            return True

        folded_line = self._normalize_table_comparison_text(normalized_line)
        matched_cells = 0
        for table in tables:
            for row in table:
                non_empty_cells = [normalise_whitespace(cell) for cell in row if normalise_whitespace(cell)]
                if not non_empty_cells:
                    continue

                normalized_cells = [self._normalize_table_comparison_text(cell) for cell in non_empty_cells]
                joined_row = " ".join(normalized_cells)
                if folded_line == joined_row or folded_line in joined_row or joined_row in folded_line:
                    return True

                row_cell_matches = 0
                fragments = self._table_comparison_fragments(non_empty_cells)
                for fragment in fragments:
                    if len(fragment) < 3:
                        continue
                    if folded_line == fragment:
                        return True
                    if fragment in folded_line or folded_line in fragment:
                        row_cell_matches += 1
                        matched_cells += 1
                if row_cell_matches >= 2:
                    return True

        return matched_cells >= 2

    def _normalize_table_comparison_text(self, value: str) -> str:
        normalized = normalise_whitespace(str(value or ""))
        normalized = re.sub(r"\s*:\s*", ": ", normalized)
        normalized = re.sub(r"\s*/\s*", "/", normalized)
        normalized = re.sub(r"\s+", " ", normalized)
        return normalized.strip().casefold()

    def _table_comparison_fragments(self, cells: list[str]) -> list[str]:
        fragments: list[str] = []
        for cell in cells:
            normalized_cell = self._normalize_table_comparison_text(cell)
            if normalized_cell:
                fragments.append(normalized_cell)
            for line in str(cell).splitlines():
                normalized_line = self._normalize_table_comparison_text(line)
                if normalized_line and normalized_line != normalized_cell:
                    fragments.append(normalized_line)
        return fragments
