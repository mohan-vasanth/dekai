from __future__ import annotations

import logging
from pathlib import Path
from typing import List

import fitz
import pdfplumber

from .models import PageAnalysis
from .utils import flatten_table, normalise_whitespace, unique_preserve


class PDFLoader:
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
                    extracted_tables = plumber_page.extract_tables() or []
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
