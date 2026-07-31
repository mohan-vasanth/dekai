from __future__ import annotations

import logging
from abc import ABC, abstractmethod


class BaseComponent(ABC):
    def __init__(self) -> None:
        self.logger = logging.getLogger(self.__class__.__name__)


class BaseExtractor(BaseComponent):
    @abstractmethod
    def extract(self, *args, **kwargs):
        raise NotImplementedError
