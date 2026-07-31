from __future__ import annotations

import logging
import re
from typing import List

from config import CONFIG

from .models import SectionKnowledge, SemanticChunk
from .utils import extract_numeric_identifiers, stable_text_hash, unique_preserve


class Chunker:
    def __init__(self) -> None:
        self.logger = logging.getLogger(self.__class__.__name__)

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

    def chunk_section(self, section: SectionKnowledge) -> List[SemanticChunk]:
        words = section.raw_text.split()
        if not words:
            return []

        chunks: List[SemanticChunk] = self._table_row_chunks(section)
        start = 0
        chunk_index = len(chunks) + 1
        while start < len(words):
            end = min(start + CONFIG.chunk_size_words, len(words))
            if end - start < CONFIG.min_chunk_size_words and chunks:
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
                    },
                }
            )
        return payload
