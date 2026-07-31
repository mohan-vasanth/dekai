import type { ChatStreamEvent } from "../types/api";
import { authStorage } from "../services/auth-storage";
import { API_BASE } from "./base-url";

export async function streamChat(
  question: string,
  onEvent: (event: ChatStreamEvent) => void,
  options?: { aiModel?: string; language?: string },
) {
  const token = authStorage.getToken();
  const response = await fetch(`${API_BASE}/api/chat/stream`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
    body: JSON.stringify({ question, aiModel: options?.aiModel, language: options?.language }),
  });

  if (!response.ok || !response.body) {
    throw new Error("Unable to stream chat response.");
  }

  const reader = response.body.getReader();
  const decoder = new TextDecoder();
  let buffer = "";

  while (true) {
    const { done, value } = await reader.read();
    if (done) {
      break;
    }

    buffer += decoder.decode(value, { stream: true });
    const lines = buffer.split("\n");
    buffer = lines.pop() ?? "";

    for (const line of lines) {
      const trimmed = line.trim();
      if (!trimmed) continue;
      onEvent(JSON.parse(trimmed) as ChatStreamEvent);
    }
  }

  if (buffer.trim()) {
    onEvent(JSON.parse(buffer.trim()) as ChatStreamEvent);
  }
}
