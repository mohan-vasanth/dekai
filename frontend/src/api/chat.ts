import type { ChatStreamEvent } from "../types/api";
import { authStorage } from "../services/auth-storage";
import { API_BASE } from "./base-url";

export async function streamChat(
  question: string,
  onEvent: (event: ChatStreamEvent) => void,
  options?: { aiModel?: string; language?: string; currentDocumentName?: string; conversationId?: string },
) {
  const token = authStorage.getToken();
  const response = await fetch(`${API_BASE}/api/chat/stream`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
    body: JSON.stringify({
      question,
      aiModel: options?.aiModel,
      language: options?.language,
      currentDocumentName: options?.currentDocumentName,
      conversationId: options?.conversationId,
    }),
  });

  if (!response.ok || !response.body) {
    let message = "Unable to stream chat response.";
    try {
      const errorPayload = (await response.json()) as { detail?: string };
      if (errorPayload?.detail) {
        message = errorPayload.detail;
      }
    } catch {
      // Ignore malformed error responses and keep the default message.
    }
    throw new Error(message);
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
