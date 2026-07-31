from __future__ import annotations

import re
from typing import List

from .base import BaseExtractor
from .utils import split_sentences, unique_preserve


class AuthorityExtractor(BaseExtractor):
    def __init__(self) -> None:
        super().__init__()
        self.authority_patterns = [
            r"\bDGFT\b",
            r"\bDirectorate General of Foreign Trade\b",
            r"\bRA\b",
            r"\bRegional Authority\b",
            r"\bJurisdictional RA\b",
            r"\bNodal DGFT Regional Authority\b",
            r"\bCustoms\b",
            r"\bCommissioner of Customs\b",
            r"\bCustoms Authority\b",
            r"\bCBIC\b",
            r"\bCentral Government\b",
            r"\bState Government\b",
            r"\bDevelopment Commissioner\b",
            r"\bMinistry of Commerce(?: and Industry)?\b",
            r"\bDistrict Export Promotion Committees?\b",
            r"\bState/UT Export Promotion Committees?\b",
            r"\bExport Promotion Committee\b",
            r"\bCommittee on Quality Complaint & Trade Dispute\b",
            r"\bCQCTD\b",
            r"\bInter Ministerial Working Group\b",
            r"\bLicensing Authority\b",
        ]
        self.compiled = [re.compile(pattern, flags=re.IGNORECASE) for pattern in self.authority_patterns]
        self.generic_pattern = re.compile(
            r"\b([A-Z][A-Za-z/&()\- ]{2,80}(?:Authority|Authorities|Committee|Commissioner|Government|Ministry|Customs|DGFT|RA))\b"
        )

    def extract(self, text: str) -> List[str]:
        authorities = []
        for sentence in split_sentences(text):
            for pattern in self.compiled:
                for match in pattern.findall(sentence):
                    if isinstance(match, tuple):
                        authorities.extend(match)
                    else:
                        authorities.append(str(match))
            authorities.extend(self.generic_pattern.findall(sentence))
        return unique_preserve(authorities)
