from __future__ import annotations

import hashlib
import math
import re
from typing import Iterable


class EmbeddingService:
    def __init__(self, dimensions: int = 96) -> None:
        self.dimensions = dimensions

    def tokenize(self, value: str) -> list[str]:
        return [token for token in re.findall(r"\b[a-zA-Z0-9][a-zA-Z0-9/&._-]{1,}\b", value.lower()) if len(token) > 1]

    def embed_text(self, value: str) -> list[float]:
        tokens = self.tokenize(value)
        if not tokens:
            return [0.0] * self.dimensions

        vector = [0.0] * self.dimensions
        for token in tokens:
            digest = hashlib.sha256(token.encode("utf-8")).digest()
            index = digest[0] % self.dimensions
            sign = 1.0 if digest[1] % 2 == 0 else -1.0
            weight = 1.0 + (digest[2] / 255.0)
            vector[index] += sign * weight

        norm = math.sqrt(sum(component * component for component in vector))
        if norm == 0:
            return [0.0] * self.dimensions
        return [round(component / norm, 6) for component in vector]

    def similarity(self, left: Iterable[float], right: Iterable[float]) -> float:
        left_list = list(left)
        right_list = list(right)
        if not left_list or not right_list or len(left_list) != len(right_list):
            return 0.0
        return sum(a * b for a, b in zip(left_list, right_list))


embedding_service = EmbeddingService()
