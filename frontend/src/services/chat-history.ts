export type ChatHistoryEntry = {
  id: string;
  question: string;
  createdAt: string;
};

const STORAGE_KEY = "dekai-chat-history";
const UPDATE_EVENT = "dekai-chat-history-updated";
const MAX_HISTORY_ITEMS = 10;

function normalizeHistoryEntry(value: unknown, index: number): ChatHistoryEntry | null {
  if (typeof value === "string") {
    const question = value.trim();
    if (!question) return null;
    return {
      id: `legacy-${index}-${question.slice(0, 16)}`,
      question,
      createdAt: new Date(0).toISOString(),
    };
  }

  if (!value || typeof value !== "object") {
    return null;
  }

  const entry = value as Record<string, unknown>;
  const question = typeof entry.question === "string" ? entry.question.trim() : "";
  if (!question) {
    return null;
  }

  return {
    id: typeof entry.id === "string" && entry.id.trim() ? entry.id : `history-${index}-${question.slice(0, 16)}`,
    question,
    createdAt:
      typeof entry.createdAt === "string" && entry.createdAt.trim()
        ? entry.createdAt
        : new Date(0).toISOString(),
  };
}

function readHistory(): ChatHistoryEntry[] {
  if (typeof window === "undefined") {
    return [];
  }

  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    if (!raw) return [];
    const parsed = JSON.parse(raw) as unknown;
    if (!Array.isArray(parsed)) {
      return [];
    }

    return parsed
      .map((entry, index) => normalizeHistoryEntry(entry, index))
      .filter((entry): entry is ChatHistoryEntry => entry !== null)
      .slice(0, MAX_HISTORY_ITEMS);
  } catch {
    return [];
  }
}

function writeHistory(entries: ChatHistoryEntry[]) {
  if (typeof window === "undefined") {
    return;
  }

  window.localStorage.setItem(STORAGE_KEY, JSON.stringify(entries));
  window.dispatchEvent(new Event(UPDATE_EVENT));
}

export const chatHistoryStorage = {
  add(question: string) {
    const normalized = question.trim();
    if (!normalized) return;

    const nextEntries = [
      {
        id: `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`,
        question: normalized,
        createdAt: new Date().toISOString(),
      },
      ...readHistory().filter((entry) => entry.question !== normalized),
    ].slice(0, MAX_HISTORY_ITEMS);

    writeHistory(nextEntries);
  },
  list() {
    return readHistory();
  },
  subscribe(callback: () => void) {
    if (typeof window === "undefined") {
      return () => undefined;
    }

    window.addEventListener(UPDATE_EVENT, callback);
    window.addEventListener("storage", callback);

    return () => {
      window.removeEventListener(UPDATE_EVENT, callback);
      window.removeEventListener("storage", callback);
    };
  },
};
