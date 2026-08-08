from __future__ import annotations

import json
import logging
import os
from dataclasses import dataclass
from typing import Any, Generator, Iterable

import httpx

logger = logging.getLogger(__name__)


class LLMConfigurationError(RuntimeError):
    pass


@dataclass(frozen=True)
class ModelSpec:
    label: str
    provider: str
    model_id: str
    env_key_name: str | None = None
    input_cost_per_million: float | None = None
    output_cost_per_million: float | None = None


@dataclass
class LLMResult:
    text: str
    display_model: str
    provider: str
    api_model: str
    prompt_tokens: int | None = None
    completion_tokens: int | None = None
    total_tokens: int | None = None
    total_cost_usd: float | None = None

    def telemetry(self) -> dict[str, Any]:
        return {
            "provider": self.provider,
            "displayModel": self.display_model,
            "apiModel": self.api_model,
            "promptTokens": self.prompt_tokens,
            "completionTokens": self.completion_tokens,
            "totalTokens": self.total_tokens,
            "totalCostUsd": self.total_cost_usd,
        }


MODEL_SPECS: dict[str, ModelSpec] = {
    "GPT-4.1": ModelSpec(
        label="GPT-4.1",
        provider="openai",
        model_id=os.getenv("DEKAI_OPENAI_MODEL", "gpt-4.1"),
        env_key_name="OPENAI_API_KEY",
        input_cost_per_million=float(os.getenv("DEKAI_OPENAI_INPUT_COST_PER_1M", "2.0")),
        output_cost_per_million=float(os.getenv("DEKAI_OPENAI_OUTPUT_COST_PER_1M", "8.0")),
    ),
    "Claude Sonnet": ModelSpec(
        label="Claude Sonnet",
        provider="anthropic",
        model_id=os.getenv("DEKAI_ANTHROPIC_MODEL", "claude-sonnet-5"),
        env_key_name="ANTHROPIC_API_KEY",
        input_cost_per_million=float(os.getenv("DEKAI_ANTHROPIC_INPUT_COST_PER_1M", "2.0")),
        output_cost_per_million=float(os.getenv("DEKAI_ANTHROPIC_OUTPUT_COST_PER_1M", "10.0")),
    ),
    "Gemini Pro": ModelSpec(
        label="Gemini Pro",
        provider="gemini",
        model_id=os.getenv("DEKAI_GEMINI_MODEL", "gemini-2.5-pro"),
        env_key_name="GOOGLE_API_KEY",
        input_cost_per_million=float(os.getenv("DEKAI_GEMINI_INPUT_COST_PER_1M", "1.25")),
        output_cost_per_million=float(os.getenv("DEKAI_GEMINI_OUTPUT_COST_PER_1M", "10.0")),
    ),
    "Ollama (Llama 3.2)": ModelSpec(
        label="Ollama (Llama 3.2)",
        provider="ollama",
        model_id=os.getenv("DEKAI_OLLAMA_LLAMA_MODEL", "llama3.2"),
    ),
    "Ollama (Qwen 2.5)": ModelSpec(
        label="Ollama (Qwen 2.5)",
        provider="ollama",
        model_id=os.getenv("DEKAI_OLLAMA_QWEN_MODEL", "qwen2.5"),
    ),
    "GPT-4.1 Mini": ModelSpec(
        label="GPT-4.1 Mini",
        provider="openai",
        model_id=os.getenv("DEKAI_OPENAI_MINI_MODEL", "gpt-4.1-mini"),
        env_key_name="OPENAI_API_KEY",
        input_cost_per_million=float(os.getenv("DEKAI_OPENAI_MINI_INPUT_COST_PER_1M", "0.4")),
        output_cost_per_million=float(os.getenv("DEKAI_OPENAI_MINI_OUTPUT_COST_PER_1M", "1.6")),
    ),
}

MODEL_ALIASES = {
    "GPT-4.1 / Claude / Gemini compatible": "GPT-4.1",
}

DEFAULT_MODEL_LABEL = "GPT-4.1"


class LLMService:
    def resolve_model(self, display_model: str) -> ModelSpec:
        requested_model = MODEL_ALIASES.get((display_model or "").strip(), (display_model or "").strip()) or DEFAULT_MODEL_LABEL
        spec = MODEL_SPECS.get(requested_model)
        if spec:
            return spec
        return MODEL_SPECS[DEFAULT_MODEL_LABEL]

    def ensure_configured(self, spec: ModelSpec) -> None:
        if spec.provider == "ollama":
            return
        if spec.env_key_name and not os.getenv(spec.env_key_name, "").strip():
            raise LLMConfigurationError(
                f'{spec.label} is selected, but {spec.env_key_name} is not set. Configure the provider API key and try again.'
            )

    def generate(self, *, display_model: str, system_prompt: str, user_prompt: str) -> LLMResult:
        spec = self.resolve_model(display_model)
        self.ensure_configured(spec)

        if spec.provider == "openai":
            return self._openai_generate(spec, system_prompt, user_prompt)
        if spec.provider == "anthropic":
            return self._anthropic_generate(spec, system_prompt, user_prompt)
        if spec.provider == "gemini":
            return self._gemini_generate(spec, system_prompt, user_prompt)
        if spec.provider == "ollama":
            return self._ollama_generate(spec, system_prompt, user_prompt)
        raise LLMConfigurationError(f"Unsupported provider: {spec.provider}")

    def stream(
        self,
        *,
        display_model: str,
        system_prompt: str,
        user_prompt: str,
    ) -> Generator[dict[str, Any], None, None]:
        spec = self.resolve_model(display_model)
        self.ensure_configured(spec)

        if spec.provider == "openai":
            yield from self._openai_stream(spec, system_prompt, user_prompt)
            return
        if spec.provider == "anthropic":
            yield from self._anthropic_stream(spec, system_prompt, user_prompt)
            return
        if spec.provider == "gemini":
            yield from self._gemini_stream(spec, system_prompt, user_prompt)
            return
        if spec.provider == "ollama":
            yield from self._ollama_stream(spec, system_prompt, user_prompt)
            return
        raise LLMConfigurationError(f"Unsupported provider: {spec.provider}")

    def _total_tokens(self, prompt_tokens: int | None, completion_tokens: int | None) -> int | None:
        if prompt_tokens is None and completion_tokens is None:
            return None
        return int(prompt_tokens or 0) + int(completion_tokens or 0)

    def _estimate_cost(
        self,
        spec: ModelSpec,
        *,
        prompt_tokens: int | None,
        completion_tokens: int | None,
    ) -> float | None:
        if (
            prompt_tokens is None
            or completion_tokens is None
            or spec.input_cost_per_million is None
            or spec.output_cost_per_million is None
        ):
            return None
        input_cost = (prompt_tokens / 1_000_000) * spec.input_cost_per_million
        output_cost = (completion_tokens / 1_000_000) * spec.output_cost_per_million
        return round(input_cost + output_cost, 8)

    def _openai_generate(self, spec: ModelSpec, system_prompt: str, user_prompt: str) -> LLMResult:
        from openai import OpenAI

        client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
        response = client.chat.completions.create(
            model=spec.model_id,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt},
            ],
            temperature=0,
        )
        text = response.choices[0].message.content or ""
        prompt_tokens = getattr(response.usage, "prompt_tokens", None)
        completion_tokens = getattr(response.usage, "completion_tokens", None)
        return LLMResult(
            text=text.strip(),
            display_model=spec.label,
            provider=spec.provider,
            api_model=spec.model_id,
            prompt_tokens=prompt_tokens,
            completion_tokens=completion_tokens,
            total_tokens=self._total_tokens(prompt_tokens, completion_tokens),
            total_cost_usd=self._estimate_cost(spec, prompt_tokens=prompt_tokens, completion_tokens=completion_tokens),
        )

    def _openai_stream(self, spec: ModelSpec, system_prompt: str, user_prompt: str) -> Generator[dict[str, Any], None, None]:
        from openai import OpenAI

        client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
        stream = client.chat.completions.create(
            model=spec.model_id,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt},
            ],
            temperature=0,
            stream=True,
            stream_options={"include_usage": True},
        )
        text_parts: list[str] = []
        prompt_tokens = None
        completion_tokens = None

        for chunk in stream:
            if getattr(chunk, "usage", None):
                prompt_tokens = getattr(chunk.usage, "prompt_tokens", prompt_tokens)
                completion_tokens = getattr(chunk.usage, "completion_tokens", completion_tokens)
            choices = getattr(chunk, "choices", []) or []
            if not choices:
                continue
            delta = getattr(choices[0], "delta", None)
            delta_text = getattr(delta, "content", None)
            if not delta_text:
                continue
            text_parts.append(delta_text)
            yield {"type": "delta", "text": delta_text}

        final_text = "".join(text_parts).strip()
        yield {
            "type": "complete",
            "result": LLMResult(
                text=final_text,
                display_model=spec.label,
                provider=spec.provider,
                api_model=spec.model_id,
                prompt_tokens=prompt_tokens,
                completion_tokens=completion_tokens,
                total_tokens=self._total_tokens(prompt_tokens, completion_tokens),
                total_cost_usd=self._estimate_cost(spec, prompt_tokens=prompt_tokens, completion_tokens=completion_tokens),
            ),
        }

    def _anthropic_generate(self, spec: ModelSpec, system_prompt: str, user_prompt: str) -> LLMResult:
        from anthropic import Anthropic

        client = Anthropic(api_key=os.getenv("ANTHROPIC_API_KEY"))
        response = client.messages.create(
            model=spec.model_id,
            max_tokens=1400,
            system=system_prompt,
            messages=[{"role": "user", "content": user_prompt}],
        )
        text = "".join(block.text for block in response.content if getattr(block, "type", "") == "text").strip()
        prompt_tokens = getattr(response.usage, "input_tokens", None)
        completion_tokens = getattr(response.usage, "output_tokens", None)
        return LLMResult(
            text=text,
            display_model=spec.label,
            provider=spec.provider,
            api_model=spec.model_id,
            prompt_tokens=prompt_tokens,
            completion_tokens=completion_tokens,
            total_tokens=self._total_tokens(prompt_tokens, completion_tokens),
            total_cost_usd=self._estimate_cost(spec, prompt_tokens=prompt_tokens, completion_tokens=completion_tokens),
        )

    def _anthropic_stream(self, spec: ModelSpec, system_prompt: str, user_prompt: str) -> Generator[dict[str, Any], None, None]:
        from anthropic import Anthropic

        client = Anthropic(api_key=os.getenv("ANTHROPIC_API_KEY"))
        with client.messages.stream(
            model=spec.model_id,
            max_tokens=1400,
            system=system_prompt,
            messages=[{"role": "user", "content": user_prompt}],
        ) as stream:
            text_parts: list[str] = []
            for delta_text in stream.text_stream:
                if not delta_text:
                    continue
                text_parts.append(delta_text)
                yield {"type": "delta", "text": delta_text}
            final_message = stream.get_final_message()

        prompt_tokens = getattr(final_message.usage, "input_tokens", None)
        completion_tokens = getattr(final_message.usage, "output_tokens", None)
        yield {
            "type": "complete",
            "result": LLMResult(
                text="".join(text_parts).strip(),
                display_model=spec.label,
                provider=spec.provider,
                api_model=spec.model_id,
                prompt_tokens=prompt_tokens,
                completion_tokens=completion_tokens,
                total_tokens=self._total_tokens(prompt_tokens, completion_tokens),
                total_cost_usd=self._estimate_cost(spec, prompt_tokens=prompt_tokens, completion_tokens=completion_tokens),
            ),
        }

    def _gemini_generate(self, spec: ModelSpec, system_prompt: str, user_prompt: str) -> LLMResult:
        from google import genai
        from google.genai import types

        client = genai.Client(api_key=os.getenv("GOOGLE_API_KEY"))
        response = client.models.generate_content(
            model=spec.model_id,
            contents=user_prompt,
            config=types.GenerateContentConfig(
                system_instruction=system_prompt,
                temperature=0,
                max_output_tokens=1400,
            ),
        )
        usage = getattr(response, "usage_metadata", None)
        prompt_tokens = getattr(usage, "prompt_token_count", None)
        completion_tokens = getattr(usage, "candidates_token_count", None)
        return LLMResult(
            text=(response.text or "").strip(),
            display_model=spec.label,
            provider=spec.provider,
            api_model=spec.model_id,
            prompt_tokens=prompt_tokens,
            completion_tokens=completion_tokens,
            total_tokens=self._total_tokens(prompt_tokens, completion_tokens),
            total_cost_usd=self._estimate_cost(spec, prompt_tokens=prompt_tokens, completion_tokens=completion_tokens),
        )

    def _gemini_stream(self, spec: ModelSpec, system_prompt: str, user_prompt: str) -> Generator[dict[str, Any], None, None]:
        from google import genai
        from google.genai import types

        client = genai.Client(api_key=os.getenv("GOOGLE_API_KEY"))
        text_parts: list[str] = []
        prompt_tokens = None
        completion_tokens = None
        response = client.models.generate_content_stream(
            model=spec.model_id,
            contents=user_prompt,
            config=types.GenerateContentConfig(
                system_instruction=system_prompt,
                temperature=0,
                max_output_tokens=1400,
            ),
        )

        for chunk in response:
            delta_text = getattr(chunk, "text", "") or ""
            usage = getattr(chunk, "usage_metadata", None)
            if usage is not None:
                prompt_tokens = getattr(usage, "prompt_token_count", prompt_tokens)
                completion_tokens = getattr(usage, "candidates_token_count", completion_tokens)
            if not delta_text:
                continue
            text_parts.append(delta_text)
            yield {"type": "delta", "text": delta_text}

        yield {
            "type": "complete",
            "result": LLMResult(
                text="".join(text_parts).strip(),
                display_model=spec.label,
                provider=spec.provider,
                api_model=spec.model_id,
                prompt_tokens=prompt_tokens,
                completion_tokens=completion_tokens,
                total_tokens=self._total_tokens(prompt_tokens, completion_tokens),
                total_cost_usd=self._estimate_cost(spec, prompt_tokens=prompt_tokens, completion_tokens=completion_tokens),
            ),
        }

    def _ollama_generate(self, spec: ModelSpec, system_prompt: str, user_prompt: str) -> LLMResult:
        response = self._ollama_request(spec, system_prompt=system_prompt, user_prompt=user_prompt, stream=False)
        prompt_tokens = response.get("prompt_eval_count")
        completion_tokens = response.get("eval_count")
        return LLMResult(
            text=str(response.get("response", "")).strip(),
            display_model=spec.label,
            provider=spec.provider,
            api_model=spec.model_id,
            prompt_tokens=prompt_tokens,
            completion_tokens=completion_tokens,
            total_tokens=self._total_tokens(prompt_tokens, completion_tokens),
            total_cost_usd=None,
        )

    def _ollama_stream(self, spec: ModelSpec, system_prompt: str, user_prompt: str) -> Generator[dict[str, Any], None, None]:
        payload = {
            "model": spec.model_id,
            "prompt": self._ollama_prompt(system_prompt, user_prompt),
            "stream": True,
            "options": {"temperature": 0},
        }
        text_parts: list[str] = []
        prompt_tokens = None
        completion_tokens = None
        with httpx.Client(timeout=httpx.Timeout(120.0, connect=15.0)) as client:
            with client.stream(
                "POST",
                f'{os.getenv("OLLAMA_BASE_URL", "http://localhost:11434").rstrip("/")}/api/generate',
                json=payload,
            ) as response:
                response.raise_for_status()
                for line in response.iter_lines():
                    if not line:
                        continue
                    event = json.loads(line)
                    delta_text = str(event.get("response", ""))
                    if delta_text:
                        text_parts.append(delta_text)
                        yield {"type": "delta", "text": delta_text}
                    if event.get("done"):
                        prompt_tokens = event.get("prompt_eval_count")
                        completion_tokens = event.get("eval_count")

        yield {
            "type": "complete",
            "result": LLMResult(
                text="".join(text_parts).strip(),
                display_model=spec.label,
                provider=spec.provider,
                api_model=spec.model_id,
                prompt_tokens=prompt_tokens,
                completion_tokens=completion_tokens,
                total_tokens=self._total_tokens(prompt_tokens, completion_tokens),
                total_cost_usd=None,
            ),
        }

    def _ollama_request(self, spec: ModelSpec, *, system_prompt: str, user_prompt: str, stream: bool) -> dict[str, Any]:
        payload = {
            "model": spec.model_id,
            "prompt": self._ollama_prompt(system_prompt, user_prompt),
            "stream": stream,
            "options": {"temperature": 0},
        }
        with httpx.Client(timeout=httpx.Timeout(120.0, connect=15.0)) as client:
            response = client.post(
                f'{os.getenv("OLLAMA_BASE_URL", "http://localhost:11434").rstrip("/")}/api/generate',
                json=payload,
            )
            response.raise_for_status()
            return response.json()

    def _ollama_prompt(self, system_prompt: str, user_prompt: str) -> str:
        return f"{system_prompt}\n\n{user_prompt}".strip()


llm_service = LLMService()
