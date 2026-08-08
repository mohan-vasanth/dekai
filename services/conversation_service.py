from __future__ import annotations

from datetime import datetime, timezone
from typing import Any

from .runtime_store import runtime_store

MAX_TURNS_PER_CONVERSATION = 12
MAX_RECENT_TURNS = 6


def _utc_now() -> str:
    return datetime.now(tz=timezone.utc).isoformat().replace("+00:00", "Z")


class ConversationService:
    def _load_store(self) -> dict[str, Any]:
        store = runtime_store.read_json(runtime_store.conversations_path, {})
        return store if isinstance(store, dict) else {}

    def _save_store(self, store: dict[str, Any]) -> None:
        runtime_store.write_json(runtime_store.conversations_path, store)

    def recent_turns(self, user_email: str, conversation_id: str, limit: int = MAX_RECENT_TURNS) -> list[dict[str, Any]]:
        if not user_email or not conversation_id:
            return []
        store = self._load_store()
        user_store = store.get(user_email.strip().lower(), {})
        if not isinstance(user_store, dict):
            return []
        turns = user_store.get(conversation_id, [])
        if not isinstance(turns, list):
            return []
        recent_turns = [turn for turn in turns if isinstance(turn, dict)]
        return recent_turns[-limit:]

    def append_turn(
        self,
        *,
        user_email: str,
        conversation_id: str,
        question: str,
        answer: str,
        metadata: dict[str, Any] | None = None,
    ) -> None:
        if not user_email or not conversation_id:
            return

        normalized_email = user_email.strip().lower()
        store = self._load_store()
        user_store = store.setdefault(normalized_email, {})
        conversation = user_store.setdefault(conversation_id, [])
        if not isinstance(conversation, list):
            conversation = []
            user_store[conversation_id] = conversation

        conversation.append(
            {
                "question": " ".join((question or "").split()).strip(),
                "answer": " ".join((answer or "").split()).strip(),
                "metadata": metadata or {},
                "timestamp": _utc_now(),
            }
        )
        user_store[conversation_id] = conversation[-MAX_TURNS_PER_CONVERSATION:]
        store[normalized_email] = user_store
        self._save_store(store)


conversation_service = ConversationService()
