from __future__ import annotations

import base64
import hashlib
import hmac
import json
import os
import secrets
import time
from dataclasses import dataclass
from typing import Any

from .runtime_store import runtime_store


@dataclass
class AuthUser:
    email: str
    name: str
    role: str


class AuthService:
    def __init__(self) -> None:
        self.secret_key = os.getenv("DEKAI_SECRET_KEY", "dekai-ai-local-secret").encode("utf-8")
        self.token_ttl_seconds = int(os.getenv("DEKAI_TOKEN_TTL_SECONDS", "43200"))

    def _hash_password(self, password: str, salt: str) -> str:
        return hashlib.pbkdf2_hmac("sha256", password.encode("utf-8"), salt.encode("utf-8"), 120_000).hex()

    def _seed_users(self) -> list[dict[str, Any]]:
        admin_salt = secrets.token_hex(16)
        user_salt = secrets.token_hex(16)
        admin_password = os.getenv("DEKAI_ADMIN_PASSWORD", "dekai-ai")
        user_password = os.getenv("DEKAI_USER_PASSWORD", "dekai-user")
        users = [
          {
            "email": os.getenv("DEKAI_ADMIN_EMAIL", "admin@dekai.ai"),
            "name": os.getenv("DEKAI_ADMIN_NAME", "DEKAI Admin"),
            "role": "admin",
            "salt": admin_salt,
            "password_hash": self._hash_password(admin_password, admin_salt),
          },
          {
            "email": os.getenv("DEKAI_USER_EMAIL", "user@dekai.ai"),
            "name": os.getenv("DEKAI_USER_NAME", "DEKAI User"),
            "role": "user",
            "salt": user_salt,
            "password_hash": self._hash_password(user_password, user_salt),
          },
        ]
        runtime_store.write_json(runtime_store.users_path, users)
        return users

    def list_users(self) -> list[dict[str, Any]]:
        users = runtime_store.read_json(runtime_store.users_path, [])
        return users if users else self._seed_users()

    def authenticate(self, email: str, password: str) -> AuthUser | None:
        normalized = email.strip().lower()
        for user in self.list_users():
            if user["email"].lower() != normalized:
                continue
            if hmac.compare_digest(user["password_hash"], self._hash_password(password, user["salt"])):
                return AuthUser(email=user["email"], name=user["name"], role=user["role"])
        return None

    def _encode_payload(self, payload: dict[str, Any]) -> str:
        raw = json.dumps(payload, separators=(",", ":")).encode("utf-8")
        return base64.urlsafe_b64encode(raw).rstrip(b"=").decode("utf-8")

    def _decode_payload(self, token_part: str) -> dict[str, Any]:
        padding = "=" * (-len(token_part) % 4)
        raw = base64.urlsafe_b64decode(f"{token_part}{padding}".encode("utf-8"))
        return json.loads(raw.decode("utf-8"))

    def issue_token(self, user: AuthUser) -> str:
        payload = {
            "sub": user.email,
            "name": user.name,
            "role": user.role,
            "exp": int(time.time()) + self.token_ttl_seconds,
        }
        encoded = self._encode_payload(payload)
        signature = hmac.new(self.secret_key, encoded.encode("utf-8"), hashlib.sha256).hexdigest()
        return f"{encoded}.{signature}"

    def verify_token(self, token: str) -> AuthUser | None:
        try:
            encoded, signature = token.split(".", 1)
        except ValueError:
            return None

        expected = hmac.new(self.secret_key, encoded.encode("utf-8"), hashlib.sha256).hexdigest()
        if not hmac.compare_digest(signature, expected):
            return None

        payload = self._decode_payload(encoded)
        if int(payload.get("exp", 0)) < int(time.time()):
            return None

        return AuthUser(email=payload["sub"], name=payload["name"], role=payload["role"])


auth_service = AuthService()
