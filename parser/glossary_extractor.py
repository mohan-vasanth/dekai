from __future__ import annotations

import re
from typing import Dict, Iterable, List

from .base import BaseExtractor
from .models import SectionKnowledge
from .utils import split_sentences


class GlossaryExtractor(BaseExtractor):
    def extract(self, sections: Iterable[SectionKnowledge]) -> Dict[str, str]:
        glossary: Dict[str, str] = {}
        acronym_pattern = re.compile(r"\b([A-Z][A-Z0-9]{1,9})\b")
        definition_pattern = re.compile(
            r"\b(?P<term>[A-Z][A-Z0-9]{1,9})\b\s+(?:means|refers to|denotes|stands for)\s+(?P<definition>[^.]{5,200})",
            flags=re.IGNORECASE,
        )

        for section in sections:
            for sentence in split_sentences(section.raw_text):
                for match in definition_pattern.finditer(sentence):
                    glossary[match.group("term").upper()] = match.group("definition").strip()

                for acronym in acronym_pattern.findall(sentence):
                    if acronym in glossary:
                        continue
                    glossary[acronym] = self._fallback_definition(acronym, sentence, section.title)
        return dict(sorted(glossary.items()))

    def _fallback_definition(self, term: str, sentence: str, title: str) -> str:
        lowered = sentence.casefold()
        if term.casefold() in title.casefold():
            return f"Referenced in section title '{title}'."
        return f"Referenced in context: {sentence[:140].strip()}"
