from __future__ import annotations

import re
from typing import List

from config import CONFIG

from .base import BaseExtractor
from .utils import sentence_contains_any, split_sentences, unique_preserve


class TimelineExtractor(BaseExtractor):
    def extract(self, text: str) -> List[str]:
        matches = []
        for sentence in split_sentences(text):
            if sentence_contains_any(sentence, CONFIG.timeline_markers):
                matches.append(sentence)
                continue
            if re.search(r"\b\d+\s+(day|days|month|months|year|years)\b", sentence, flags=re.IGNORECASE):
                matches.append(sentence)
        return unique_preserve(matches)
