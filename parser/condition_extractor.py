from __future__ import annotations

import re
from typing import List

from config import CONFIG

from .base import BaseExtractor
from .utils import sentence_contains_any, split_sentences, unique_preserve


class ConditionExtractor(BaseExtractor):
    def extract(self, text: str) -> List[str]:
        candidates = []
        for sentence in split_sentences(text):
            if sentence_contains_any(sentence, CONFIG.condition_markers):
                candidates.append(sentence)
                continue
            if re.search(r"\b(if|when|where|unless)\b.+\b(then|shall|must|may)\b", sentence, flags=re.IGNORECASE):
                candidates.append(sentence)
        return unique_preserve(candidates)
