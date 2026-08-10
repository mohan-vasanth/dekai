from __future__ import annotations

import logging
from pathlib import Path
from typing import Any, List, Sequence

import fitz
import pdfplumber

from .models import PageAnalysis
from .utils import flatten_table, normalise_whitespace, unique_preserve


class PDFLoader:
    TEXT_TABLE_SETTINGS = {
        "vertical_strategy": "text",
        "horizontal_strategy": "text",
        "intersection_tolerance": 5,
        "join_tolerance": 4,
        "snap_tolerance": 3,
        "text_x_tolerance": 3,
        "text_y_tolerance": 3,
        "min_words_vertical": 2,
        "min_words_horizontal": 1,
    }

    def __init__(self) -> None:
        self.logger = logging.getLogger(self.__class__.__name__)

    def load(self, pdf_path: Path) -> List[PageAnalysis]:
        self.logger.info("Loading PDF %s", pdf_path)
        pages: List[PageAnalysis] = []
        with pdfplumber.open(pdf_path) as plumber_doc, fitz.open(pdf_path) as fitz_doc:
            total_pages = max(len(plumber_doc.pages), fitz_doc.page_count)
            for index in range(total_pages):
                plumber_page = plumber_doc.pages[index] if index < len(plumber_doc.pages) else None
                fitz_page = fitz_doc.load_page(index)
                text_segments: List[str] = []
                tables = []
                blocks: List[str] = []
                metadata = {
                    "width": fitz_page.rect.width,
                    "height": fitz_page.rect.height,
                    "rotation": fitz_page.rotation,
                }

                if plumber_page:
                    plumber_text = plumber_page.extract_text() or ""
                    if plumber_text.strip():
                        text_segments.append(plumber_text)
                    extracted_tables = self._extract_tables(plumber_page)
                    for table in extracted_tables:
                        tables.append(table)
                        flattened = flatten_table(table)
                        if flattened:
                            text_segments.append(flattened)

                fitz_text = fitz_page.get_text("text") or ""
                if fitz_text.strip() and normalise_whitespace(fitz_text) != normalise_whitespace("\n".join(text_segments)):
                    text_segments.append(fitz_text)

                block_items = fitz_page.get_text("blocks")
                for block in block_items:
                    block_text = normalise_whitespace(block[4] or "")
                    if block_text and block_text not in "\n".join(text_segments):
                        blocks.append(block_text)

                merged_segments = unique_preserve(text_segments)
                merged_text = normalise_whitespace("\n".join(merged_segments))
                pages.append(
                    PageAnalysis(
                        page_number=index + 1,
                        text=merged_text,
                        tables=tables,
                        blocks=blocks,
                        metadata=metadata,
                    )
                )
        self.logger.info("Loaded %s pages from %s", len(pages), pdf_path.name)
        return pages

    def _extract_tables(self, plumber_page: pdfplumber.page.Page) -> list[list[list[str]]]:
        collected: list[list[list[str]]] = []
        seen: set[tuple[tuple[str, ...], ...]] = set()

        def add_table(candidate: Sequence[Sequence[Any]] | None) -> bool:
            normalized = self._normalize_table(candidate or [])
            if not self._table_looks_structured(normalized):
                return False
            fingerprint = tuple(tuple(row) for row in normalized)
            if fingerprint in seen:
                return False
            seen.add(fingerprint)
            collected.append(normalized)
            return True

        for table in plumber_page.extract_tables() or []:
            add_table(table)

        if collected:
            return collected

        for table in plumber_page.find_tables(table_settings=self.TEXT_TABLE_SETTINGS) or []:
            add_table(table.extract())

        return collected

    def _normalize_table(self, table: Sequence[Sequence[Any]]) -> list[list[str]]:
        normalized_rows: list[list[str]] = []
        for row in table:
            normalized_row = [normalise_whitespace(str(cell or "")) for cell in row]
            if any(normalized_row):
                normalized_rows.append(normalized_row)
        return normalized_rows

    def _table_looks_structured(self, table: Sequence[Sequence[str]]) -> bool:
        if not table:
            return False

        non_empty_rows = [[cell for cell in row if cell] for row in table]
        populated_rows = [row for row in non_empty_rows if row]
        if not populated_rows:
            return False

        if len(populated_rows) == 1:
            return len(populated_rows[0]) >= 2

        meaningful_rows = sum(1 for row in populated_rows if len(row) >= 2)
        column_count = max(len(row) for row in table)
        return meaningful_rows >= 1 and column_count >= 2
