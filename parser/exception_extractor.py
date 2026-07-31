from __future__ import annotations

from typing import List

from config import CONFIG

from .base import BaseExtractor
from .utils import sentence_contains_any, split_sentences, unique_preserve


class ExceptionExtractor(BaseExtractor):
    def extract(self, text: str) -> List[str]:
        exceptions = [sentence for sentence in split_sentences(text) if sentence_contains_any(sentence, CONFIG.exception_markers)]
        return unique_preserve(exceptions)
