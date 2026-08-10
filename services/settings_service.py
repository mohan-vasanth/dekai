from __future__ import annotations

from typing import Any

from config import CONFIG
from .llm_service import llm_service
from .runtime_store import runtime_store

SUPPORTED_THEMES = {"light", "dark", "system"}
SUPPORTED_LANGUAGES = {"English", "Hindi", "Tamil"}
SUPPORTED_MODELS = set(llm_service.supported_model_labels())
LEGACY_MODEL_ALIASES = {
    "GPT-4.1 / Claude / Gemini compatible": "GPT-4.1",
}


class SettingsService:
    def _available_models(self) -> list[str]:
        return llm_service.available_model_labels()

    def _default_model(self) -> str:
        return llm_service.preferred_model_label()

    def default_settings(self) -> dict[str, Any]:
        return {
            "theme": "system",
            "language": "English",
            "aiModel": self._default_model(),
            "knowledgeStatus": "Ready",
            "version": "2026.07",
            "about": "DEKAI AI is a DGFT, customs, import, and export knowledge assistant for grounded AI retrieval.",
            "metadata": {
                "knowledgeBaseName": "DEKAI DGFT Knowledge Base",
                "generatedAt": None,
                "vectorDatabase": "pgvector",
                "embeddings": "text-embedding-3-large",
                "chunking": "500-800 tokens with overlap",
                "supportedModels": self._available_models(),
            },
        }

    def _normalize_model(self, value: Any) -> Any:
        if not isinstance(value, str):
            return value
        normalized = LEGACY_MODEL_ALIASES.get(value.strip(), value.strip())
        if normalized in self._available_models():
            return normalized
        if normalized in SUPPORTED_MODELS:
            return self._default_model()
        return normalized

    def _normalize_store(self) -> dict[str, Any]:
        existing = runtime_store.read_json(runtime_store.settings_path, {})
        defaults = self.default_settings()

        if not existing:
            normalized = {"defaults": defaults, "users": {}}
            runtime_store.write_json(runtime_store.settings_path, normalized)
            return normalized

        if "defaults" not in existing or "users" not in existing:
            normalized = {"defaults": {**defaults, **existing}, "users": {}}
            runtime_store.write_json(runtime_store.settings_path, normalized)
            return normalized

        normalized = {
            "defaults": {**defaults, **dict(existing.get("defaults", {}))},
            "users": dict(existing.get("users", {})),
        }
        normalized["defaults"]["aiModel"] = self._normalize_model(normalized["defaults"].get("aiModel"))
        normalized["defaults"]["metadata"] = {
            **defaults["metadata"],
            **dict(normalized["defaults"].get("metadata", {})),
            "supportedModels": self._available_models(),
        }
        for email, settings in list(normalized["users"].items()):
            if not isinstance(settings, dict):
                continue
            settings["aiModel"] = self._normalize_model(settings.get("aiModel"))
            metadata = settings.get("metadata", {})
            settings["metadata"] = {
                **defaults["metadata"],
                **dict(metadata if isinstance(metadata, dict) else {}),
                "supportedModels": self._available_models(),
            }
            normalized["users"][email] = settings
        if normalized != existing:
            runtime_store.write_json(runtime_store.settings_path, normalized)
        return normalized

    def _validate_patch(self, patch: dict[str, Any]) -> None:
        theme = patch.get("theme")
        if theme is not None and theme not in SUPPORTED_THEMES:
            raise ValueError("Unsupported theme.")

        language = patch.get("language")
        if language is not None and language not in SUPPORTED_LANGUAGES:
            raise ValueError("Unsupported language.")

        ai_model = self._normalize_model(patch.get("aiModel"))
        if ai_model is not None and ai_model not in self._available_models():
            raise ValueError("Unsupported AI model.")

    def get_settings(self, user_email: str | None = None) -> dict[str, Any]:
        store = self._normalize_store()
        settings = dict(store["defaults"])
        if user_email:
            overrides = store["users"].get(user_email.strip().lower(), {})
            settings.update({key: value for key, value in overrides.items() if value is not None})
        return settings

    def update_settings(self, patch: dict[str, Any], user_email: str | None = None) -> dict[str, Any]:
        self._validate_patch(patch)
        store = self._normalize_store()
        normalized_patch = {key: self._normalize_model(value) if key == "aiModel" else value for key, value in patch.items() if value is not None}

        if user_email:
            email_key = user_email.strip().lower()
            settings = self.get_settings(email_key)
            settings.update(normalized_patch)
            store["users"][email_key] = settings
            runtime_store.write_json(runtime_store.settings_path, store)
            return settings

        settings = self.get_settings()
        settings.update(normalized_patch)
        store["defaults"] = settings
        runtime_store.write_json(runtime_store.settings_path, store)
        return settings


settings_service = SettingsService()
