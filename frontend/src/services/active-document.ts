const STORAGE_KEY = "dekai-active-document";

export type ActiveDocumentContext = {
  id: string;
  name: string;
};

export const activeDocumentStorage = {
  get(): ActiveDocumentContext | null {
    if (typeof window === "undefined") {
      return null;
    }
    const raw = window.localStorage.getItem(STORAGE_KEY);
    if (!raw) {
      return null;
    }
    try {
      const parsed = JSON.parse(raw) as Partial<ActiveDocumentContext>;
      if (typeof parsed?.id !== "string" || typeof parsed?.name !== "string" || !parsed.name.trim()) {
        return null;
      }
      return { id: parsed.id, name: parsed.name.trim() };
    } catch {
      return null;
    }
  },
  set(document: ActiveDocumentContext) {
    if (typeof window === "undefined") {
      return;
    }
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(document));
  },
  clear() {
    if (typeof window === "undefined") {
      return;
    }
    window.localStorage.removeItem(STORAGE_KEY);
  },
};
