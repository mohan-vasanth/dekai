from __future__ import annotations

import time
from typing import Any
from uuid import uuid4

from .runtime_store import runtime_store


class DocumentVersionService:
    def _now(self) -> str:
        return time.strftime("%Y-%m-%dT%H:%M:%S.000Z", time.gmtime())

    def _document_id(self, name: str) -> str:
        return "-".join("".join(char.lower() if char.isalnum() else "-" for char in name).split("-"))

    def _load_state(self) -> dict[str, Any]:
        state = runtime_store.read_json(runtime_store.document_versions_path, {})
        if not state:
            state = {"documents": []}
            runtime_store.write_json(runtime_store.document_versions_path, state)
        return state

    def _save_state(self, state: dict[str, Any]) -> None:
        runtime_store.write_json(runtime_store.document_versions_path, state)

    def _find_entry(self, state: dict[str, Any], *, filename: str | None = None, document_id: str | None = None) -> dict[str, Any] | None:
        for entry in state["documents"]:
            names = {entry.get("currentName"), *(entry.get("aliases") or [])}
            ids = {entry.get("currentDocumentId"), self._document_id(entry.get("currentName") or "")}
            ids.update(self._document_id(name) for name in names if name)
            if filename and filename in names:
                return entry
            if document_id and document_id in ids:
                return entry
        return None

    def _append_version(self, entry: dict[str, Any], *, name: str, action: str, status: str, replaced_from: str | None = None) -> dict[str, Any]:
        version_number = len(entry["versions"]) + 1
        version = {
            "versionId": uuid4().hex,
            "versionNumber": version_number,
            "label": f"v{version_number}",
            "documentName": name,
            "documentId": self._document_id(name),
            "action": action,
            "status": status,
            "replacedFrom": replaced_from,
            "createdAt": self._now(),
            "metadata": {},
        }
        entry["versions"].append(version)
        entry["currentName"] = name
        entry["currentDocumentId"] = self._document_id(name)
        entry["aliases"] = sorted({*(entry.get("aliases") or []), name, *( [replaced_from] if replaced_from else [] )})
        entry["archived"] = action == "delete"
        entry["updatedAt"] = version["createdAt"]
        return version

    def record_upload(self, filename: str) -> dict[str, Any]:
        state = self._load_state()
        entry = self._find_entry(state, filename=filename)
        if entry and not entry.get("archived"):
            return entry

        entry = {
            "lineageId": uuid4().hex,
            "currentName": filename,
            "currentDocumentId": self._document_id(filename),
            "aliases": [filename],
            "archived": False,
            "createdAt": self._now(),
            "updatedAt": self._now(),
            "versions": [],
        }
        self._append_version(entry, name=filename, action="upload", status="processing")
        state["documents"].insert(0, entry)
        self._save_state(state)
        return entry

    def record_replace(self, current_filename: str, replacement_name: str) -> dict[str, Any]:
        state = self._load_state()
        entry = self._find_entry(state, filename=current_filename)
        if not entry:
            entry = self.record_upload(current_filename)
            state = self._load_state()
            entry = self._find_entry(state, filename=current_filename)
            if not entry:
                raise RuntimeError("Unable to create version lineage for replacement.")

        self._append_version(entry, name=replacement_name, action="replace", status="processing", replaced_from=current_filename)
        self._save_state(state)
        return entry

    def record_delete(self, filename: str) -> dict[str, Any]:
        state = self._load_state()
        entry = self._find_entry(state, filename=filename)
        if not entry:
            entry = self.record_upload(filename)
            state = self._load_state()
            entry = self._find_entry(state, filename=filename)
            if not entry:
                raise RuntimeError("Unable to create version lineage for delete.")

        self._append_version(entry, name=filename, action="delete", status="processing")
        entry["archived"] = True
        self._save_state(state)
        return entry

    def update_document_metadata(self, filename: str, metadata: dict[str, Any], status: str = "ready") -> None:
        state = self._load_state()
        entry = self._find_entry(state, filename=filename)
        if not entry:
            entry = self.record_upload(filename)
            state = self._load_state()
            entry = self._find_entry(state, filename=filename)
            if not entry:
                return

        entry["archived"] = False
        entry["currentName"] = filename
        entry["currentDocumentId"] = self._document_id(filename)
        entry["updatedAt"] = self._now()
        current_version = entry["versions"][-1] if entry["versions"] else None
        if current_version:
            current_version["status"] = status
            current_version["metadata"] = {**current_version.get("metadata", {}), **metadata}
            if status == "ready":
                current_version.pop("error", None)
        self._save_state(state)

    def update_document_status(self, filename: str, status: str, error: str | None = None) -> None:
        state = self._load_state()
        entry = self._find_entry(state, filename=filename)
        if not entry or not entry.get("versions"):
            return
        entry["updatedAt"] = self._now()
        version = entry["versions"][-1]
        version["status"] = status
        if error:
            version["error"] = error
        else:
            version.pop("error", None)
        self._save_state(state)

    def list_documents(self) -> list[dict[str, Any]]:
        state = self._load_state()
        return state["documents"]

    def get_versions(self, document_id: str) -> list[dict[str, Any]]:
        state = self._load_state()
        entry = self._find_entry(state, document_id=document_id)
        return entry.get("versions", []) if entry else []

    def get_lineage(self, filename: str) -> dict[str, Any] | None:
        state = self._load_state()
        return self._find_entry(state, filename=filename)


document_version_service = DocumentVersionService()
