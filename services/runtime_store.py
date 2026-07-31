from __future__ import annotations

import json
from pathlib import Path
from threading import Lock
from typing import Any
from uuid import uuid4

from config import CONFIG


class RuntimeStore:
    def __init__(self) -> None:
        CONFIG.ensure_directories()
        self._locks_guard = Lock()
        self._locks: dict[str, Lock] = {}
        self.runtime_dir = CONFIG.runtime_dir
        self.users_path = self.runtime_dir / "users.json"
        self.settings_path = self.runtime_dir / "settings.json"
        self.jobs_path = self.runtime_dir / "jobs.json"
        self.document_versions_path = self.runtime_dir / "document_versions.json"
        self.knowledge_index_path = self.runtime_dir / "knowledge_index.json"
        self.knowledge_schema_path = self.runtime_dir / "knowledge_schema.json"

    def _path_lock(self, path: Path) -> Lock:
        key = str(path.resolve())
        with self._locks_guard:
            lock = self._locks.get(key)
            if lock is None:
                lock = Lock()
                self._locks[key] = lock
            return lock

    def read_json(self, path: Path, fallback: Any) -> Any:
        with self._path_lock(path):
            if not path.exists():
                return fallback
            try:
                return json.loads(path.read_text(encoding="utf-8"))
            except json.JSONDecodeError:
                return fallback

    def write_json(self, path: Path, payload: Any) -> None:
        serialized = json.dumps(payload, indent=2)
        with self._path_lock(path):
            path.parent.mkdir(parents=True, exist_ok=True)
            temp_path = path.with_name(f"{path.name}.{uuid4().hex}.tmp")
            temp_path.write_text(serialized, encoding="utf-8")
            temp_path.replace(path)


runtime_store = RuntimeStore()
