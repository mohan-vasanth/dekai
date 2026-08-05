from __future__ import annotations

import logging
import re
from typing import List

from config import CONFIG

from .models import SectionKnowledge, SemanticChunk
from .utils import extract_numeric_identifiers, slugify, split_lines, stable_text_hash, unique_preserve


STRUCTURAL_HEADING_TERMS = {
    "section",
    "details",
    "detail",
    "item",
    "items",
    "consignee",
    "shipment",
    "declaration",
    "remarks",
    "goods",
    "party",
    "cargo",
    "transport",
    "header",
}
HEADING_NOISE_LINES = (
    "official (closed)",
    "tradenet message",
    "prepared by",
    "release date",
    "document id",
    "reference",
)


class Chunker:
    def __init__(self) -> None:
        self.logger = logging.getLogger(self.__class__.__name__)

    def _normalize_table(self, table: List[List[str]]) -> List[List[str]]:
        normalized: List[List[str]] = []
        for row in table:
            if not isinstance(row, list):
                continue
            cells = [" ".join(str(cell or "").split()) for cell in row]
            if any(cell for cell in cells):
                normalized.append(cells)
        return normalized

    def _table_field_names(self, table: List[List[str]]) -> List[str]:
        if not table:
            return []
        field_names = [cell for cell in table[0] if cell and len(cell) <= 80]
        for row in table[1:4]:
            field_names.extend(self._extract_field_names(row))
        return unique_preserve(field_names)

    def _serialize_table_rows(self, headers: List[str], rows: List[List[str]], limit: int = 8) -> List[str]:
        serialized: List[str] = []
        normalized_headers = [header.strip() for header in headers if header.strip()]
        for row in rows[:limit]:
            cleaned_row = [" ".join(str(cell or "").split()) for cell in row]
            if not any(cleaned_row):
                continue
            if normalized_headers and len(cleaned_row) >= len(normalized_headers):
                pairs = [
                    f"{header}: {value}"
                    for header, value in zip(normalized_headers, cleaned_row)
                    if header and value
                ]
                if pairs:
                    serialized.append("; ".join(pairs))
                    continue
            serialized.append(" | ".join(cell for cell in cleaned_row if cell))
        return serialized

    def _table_chunks(self, section: SectionKnowledge) -> List[SemanticChunk]:
        chunks: List[SemanticChunk] = []
        for table_index, raw_table in enumerate(section.tables[:8], start=1):
            table = self._normalize_table(raw_table)
            if len(table) < 2:
                continue

            headers = [cell for cell in table[0] if cell][:8]
            field_names = self._table_field_names(table)
            row_summaries = self._serialize_table_rows(headers, table[1:], limit=8)
            if not row_summaries:
                continue

            block_heading = headers[0] if len(headers) == 1 else f"{section.title} Table {table_index}"
            block_text = " ".join(
                [
                    block_heading,
                    f"Columns: {', '.join(headers[:8])}" if headers else "",
                    *row_summaries,
                ]
            ).strip()
            block_keywords = [
                *headers[:8],
                *field_names[:12],
                *[
                    token
                    for row in table[1:4]
                    for token in row[:4]
                    if isinstance(token, str) and token.strip()
                ],
                *section.keywords[:8],
            ]
            chunks.append(
                SemanticChunk(
                    chunk_id=f"{section.section}-table-{table_index}",
                    document_name=section.source_document,
                    chapter_number=section.chapter_number,
                    chapter_title=section.chapter_title,
                    section=section.section,
                    title=f"{section.title} Table {table_index}",
                    chunk_index=len(chunks) + 1,
                    text=block_text,
                    keywords=unique_preserve(block_keywords),
                    intent=section.intent,
                    tags=unique_preserve([*section.tags, "table", "table-block"]),
                    related_sections=section.related_sections,
                    source_pages=section.pages,
                    hs_codes=extract_numeric_identifiers(block_text),
                    exim_codes=extract_numeric_identifiers(block_text),
                    description=f"Table columns: {', '.join(headers[:8])}" if headers else f"Table {table_index} in {section.title}",
                    chunk_hash=stable_text_hash(f"{section.section}|table|{table_index}|{block_text}"),
                    heading=section.title,
                    field_names=field_names,
                )
            )

            for row_index, row_summary in enumerate(row_summaries[:12], start=1):
                row_field_names = unique_preserve([*headers[:8], *self._extract_field_names([row_summary])])
                chunks.append(
                    SemanticChunk(
                        chunk_id=f"{section.section}-table-{table_index}-row-{row_index}",
                        document_name=section.source_document,
                        chapter_number=section.chapter_number,
                        chapter_title=section.chapter_title,
                        section=section.section,
                        title=f"{section.title} Table {table_index} Row {row_index}",
                        chunk_index=len(chunks) + 1,
                        text=row_summary,
                        keywords=unique_preserve([*row_field_names, *section.keywords[:8]]),
                        intent=section.intent,
                        tags=unique_preserve([*section.tags, "table", "table-row"]),
                        related_sections=section.related_sections,
                        source_pages=section.pages,
                        hs_codes=extract_numeric_identifiers(row_summary),
                        exim_codes=extract_numeric_identifiers(row_summary),
                        description=f"Table row {row_index} in {section.title}",
                        chunk_hash=stable_text_hash(f"{section.section}|table|{table_index}|row|{row_index}|{row_summary}"),
                        is_table_row=True,
                        heading=section.title,
                        field_names=row_field_names,
                    )
                )
        return chunks

    def _table_row_chunks(self, section: SectionKnowledge) -> List[SemanticChunk]:
        chunks: List[SemanticChunk] = []
        seen_rows: set[tuple[str, str]] = set()
        line_patterns = (
            re.compile(r"^\s*(?:\d+\s*[\.\|]\s*)?(?P<code>(?:\d[\s-]*){6,10})\s*\|\s*(?P<description>.+?)\s*$"),
            re.compile(r"^\s*(?:\d+\.\s+)?(?P<code>(?:\d[\s-]*){6,10})\s+(?P<description>[A-Za-z].+?)\s*$"),
        )

        for line in section.raw_text.splitlines():
            cleaned_line = " ".join(line.split()).strip(" |")
            if not cleaned_line:
                continue
            for pattern in line_patterns:
                match = pattern.match(cleaned_line)
                if not match:
                    continue
                normalized_code = extract_numeric_identifiers(match.group("code"))
                if not normalized_code:
                    continue
                description = " ".join(match.group("description").split())
                if len(description) < 3 or description.lower().startswith(("pg.", "page ", "sl. no")):
                    continue
                code = normalized_code[0]
                row_key = (code, description.casefold())
                if row_key in seen_rows:
                    continue
                seen_rows.add(row_key)
                chunks.append(
                    SemanticChunk(
                        chunk_id=f"{section.section}-row-{code}",
                        document_name=section.source_document,
                        chapter_number=section.chapter_number,
                        chapter_title=section.chapter_title,
                        section=section.section,
                        title=f"{section.title} - HS Code {code}",
                        chunk_index=len(chunks) + 1,
                        text=f"HS Code {code}: {description}",
                        keywords=unique_preserve([code, description, *section.keywords[:10]]),
                        intent=section.intent,
                        tags=unique_preserve([*section.tags, "table-row", "hs-code"]),
                        related_sections=section.related_sections,
                        source_pages=section.pages,
                        hs_codes=[code],
                        exim_codes=[code],
                        description=description,
                        chunk_hash=stable_text_hash(f"{code}|{description}|{section.section}|{section.source_document}"),
                        is_table_row=True,
                    )
                )
                break
        return chunks

    def _is_noise_line(self, line: str) -> bool:
        lowered = line.casefold()
        return lowered == "am" or any(noise in lowered for noise in HEADING_NOISE_LINES)

    def _looks_like_structural_heading(self, line: str) -> bool:
        cleaned = " ".join(str(line or "").replace("|", " ").split()).strip(" -:")
        if not cleaned or len(cleaned) > 80:
            return False
        words = re.findall(r"[A-Za-z][A-Za-z0-9/&-]*", cleaned)
        if len(words) < 2 or len(words) > 6:
            return False
        if not any(term in {word.casefold() for word in words} for term in STRUCTURAL_HEADING_TERMS):
            return False
        uppercase_chars = [char for char in cleaned if char.isalpha()]
        if not uppercase_chars:
            return False
        uppercase_ratio = sum(1 for char in uppercase_chars if char.isupper()) / len(uppercase_chars)
        return uppercase_ratio >= 0.75

    def _extract_field_names(self, lines: List[str]) -> List[str]:
        field_names: List[str] = []
        for line in lines:
            normalized_line = " ".join(line.split())
            if not normalized_line:
                continue
            field_names.extend(
                match.group(1)
                for match in re.finditer(
                    r"\b([A-Za-z]{2,5}:[A-Za-z][A-Za-z0-9]+(?:\s+[A-Za-z][A-Za-z0-9]+){0,3})\b",
                    normalized_line,
                )
            )
        return unique_preserve(field_names)

    def _heading_block_chunks(self, section: SectionKnowledge) -> List[SemanticChunk]:
        lines = split_lines(section.raw_text)
        if not lines:
            return []

        chunks: List[SemanticChunk] = []
        current_heading = ""
        current_lines: List[str] = []

        def flush() -> None:
            nonlocal current_heading, current_lines
            if not current_heading or not current_lines:
                current_heading = ""
                current_lines = []
                return
            filtered_lines = [line for line in current_lines if not self._is_noise_line(line)]
            field_names = self._extract_field_names(filtered_lines)
            if len(filtered_lines) < 2 and not field_names:
                current_heading = ""
                current_lines = []
                return

            block_lines = [current_heading, *filtered_lines]
            words = " ".join(block_lines).split()
            block_text = " ".join(words[:360]).strip()
            if not block_text:
                current_heading = ""
                current_lines = []
                return

            heading_keywords = re.findall(r"[A-Za-z][A-Za-z0-9/&-]{2,}", current_heading)
            chunks.append(
                SemanticChunk(
                    chunk_id=f"{section.section}-heading-{slugify(current_heading)}",
                    document_name=section.source_document,
                    chapter_number=section.chapter_number,
                    chapter_title=section.chapter_title,
                    section=section.section,
                    title=current_heading,
                    chunk_index=len(chunks) + 1,
                    text=block_text,
                    keywords=unique_preserve([*heading_keywords, *field_names, *section.keywords[:10]]),
                    intent=section.intent,
                    tags=unique_preserve([*section.tags, "heading-block", current_heading.casefold()]),
                    related_sections=section.related_sections,
                    source_pages=section.pages,
                    hs_codes=extract_numeric_identifiers(block_text),
                    exim_codes=extract_numeric_identifiers(block_text),
                    description=f"{current_heading} fields: {', '.join(field_names[:8])}" if field_names else current_heading,
                    chunk_hash=stable_text_hash(f"{section.section}|{current_heading}|{block_text}"),
                    heading=current_heading,
                    field_names=field_names,
                )
            )
            current_heading = ""
            current_lines = []

        for line in lines:
            if self._looks_like_structural_heading(line):
                flush()
                current_heading = " ".join(line.replace("|", " ").split()).strip(" -:")
                current_lines = []
                continue
            if current_heading:
                current_lines.append(line)

        flush()
        return chunks

    def chunk_section(self, section: SectionKnowledge) -> List[SemanticChunk]:
        words = section.raw_text.split()
        if not words:
            return []

        chunks: List[SemanticChunk] = [
            *self._table_row_chunks(section),
            *self._table_chunks(section),
            *self._heading_block_chunks(section),
        ]
        base_chunk_count = len(chunks)
        start = 0
        chunk_index = len(chunks) + 1
        while start < len(words):
            end = min(start + CONFIG.chunk_size_words, len(words))
            if end - start < CONFIG.min_chunk_size_words and chunk_index > base_chunk_count + 1:
                previous = chunks[-1]
                previous.text = f"{previous.text} {' '.join(words[start:end])}".strip()
                break

            chunk_text = " ".join(words[start:end]).strip()
            chunks.append(
                SemanticChunk(
                    chunk_id=f"{section.section}-{chunk_index}",
                    document_name=section.source_document,
                    chapter_number=section.chapter_number,
                    chapter_title=section.chapter_title,
                    section=section.section,
                    title=section.title,
                    chunk_index=chunk_index,
                    text=chunk_text,
                    keywords=section.keywords[:15],
                    intent=section.intent,
                    tags=section.tags,
                    related_sections=section.related_sections,
                    source_pages=section.pages,
                    hs_codes=extract_numeric_identifiers(chunk_text),
                    exim_codes=extract_numeric_identifiers(chunk_text),
                    chunk_hash=stable_text_hash(f"{section.section}|{chunk_index}|{chunk_text}"),
                    field_names=self._extract_field_names([chunk_text]),
                )
            )
            if end >= len(words):
                break
            start = max(0, end - CONFIG.chunk_overlap_words)
            chunk_index += 1
        self.logger.info("Created %s chunks for section %s", len(chunks), section.section)
        return chunks

    def embedding_payload(self, chunks: List[SemanticChunk]) -> List[dict]:
        payload = []
        for chunk in chunks:
            payload.append(
                {
                    "id": chunk.chunk_id,
                    "text": chunk.text,
                    "metadata": {
                        "document_name": chunk.document_name,
                        "chapter_number": chunk.chapter_number,
                        "chapter_title": chunk.chapter_title,
                        "section": chunk.section,
                        "title": chunk.title,
                        "keywords": unique_preserve(chunk.keywords),
                        "intent": chunk.intent,
                        "tags": unique_preserve(chunk.tags),
                        "related_sections": unique_preserve(chunk.related_sections),
                        "source_pages": chunk.source_pages,
                        "heading": chunk.heading,
                        "field_names": unique_preserve(chunk.field_names),
                    },
                }
            )
        return payload
