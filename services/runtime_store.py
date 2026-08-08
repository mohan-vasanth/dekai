from __future__ import annotations

import json
import os
import time
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
        self.conversations_path = self.runtime_dir / "conversations.json"

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

    def _cleanup_stale_temp_files(self, path: Path, *, max_age_seconds: float = 600.0) -> None:
        cutoff = time.time() - max_age_seconds
        for stale_temp_path in path.parent.glob(f"{path.name}.*.tmp"):
            try:
                if stale_temp_path.stat().st_mtime >= cutoff:
                    continue
            except OSError:
                continue
            try:
                stale_temp_path.unlink()
            except OSError:
                # A stale temp file can be locked by another process. Ignore and continue.
                pass

    def write_json(self, path: Path, payload: Any) -> None:
        serialized = json.dumps(payload, indent=2)
        with self._path_lock(path):
            path.parent.mkdir(parents=True, exist_ok=True)
            self._cleanup_stale_temp_files(path)
            last_error: OSError | None = None
            for attempt in range(8):
                temp_path = path.with_name(f"{path.name}.{uuid4().hex}.tmp")
                try:
                    temp_path.write_text(serialized, encoding="utf-8")
                    os.replace(temp_path, path)
                    return
                except OSError as exc:
                    last_error = exc
                    try:
                        temp_path.unlink(missing_ok=True)
                    except OSError:
                        pass
                    if attempt == 7:
                        break
                    time.sleep(0.15 * (attempt + 1))
            if last_error is not None:
                raise last_error


runtime_store = RuntimeStore()
