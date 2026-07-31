from __future__ import annotations

import logging
import re
from collections import Counter
from typing import Iterable, List

from .models import PageAnalysis
from .utils import normalise_whitespace


class TextCleaner:
    def __init__(self) -> None:
        self.logger = logging.getLogger(self.__class__.__name__)

    def clean_pages(self, pages: Iterable[PageAnalysis]) -> List[PageAnalysis]:
        page_list = list(pages)
        repeated_lines = self._repeated_lines(page_list)
        cleaned_pages: List[PageAnalysis] = []
        for page in page_list:
            lines = []
            for raw_line in page.text.splitlines():
                line = normalise_whitespace(raw_line)
                if not line:
                    continue
                if line in repeated_lines and len(line.split()) > 2:
                    continue
                line = re.sub(r"Page\s+\d+\s+of\s+\d+", "", line, flags=re.IGNORECASE)
                line = re.sub(r"\s+([,.;:])", r"\1", line)
                line = re.sub(r"([a-z])([A-Z])", r"\1 \2", line)
                line = normalise_whitespace(line)
                if line:
                    lines.append(line)
            page.text = "\n".join(lines)
            page.blocks = [block for block in (normalise_whitespace(item) for item in page.blocks) if block]
            cleaned_pages.append(page)
        self.logger.info("Cleaned %s pages", len(cleaned_pages))
        return cleaned_pages

    def _repeated_lines(self, pages: List[PageAnalysis]) -> set[str]:
        counter: Counter[str] = Counter()
        for page in pages:
            unique_lines = {normalise_whitespace(line) for line in page.text.splitlines() if normalise_whitespace(line)}
            counter.update(unique_lines)
        threshold = max(2, len(pages) // 3) if pages else 0
        return {line for line, count in counter.items() if count >= threshold}
