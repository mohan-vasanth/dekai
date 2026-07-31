import { ArrowLeft } from "lucide-react";
import { createContext, useCallback, useContext, useEffect, useMemo, useState, type PropsWithChildren } from "react";
import { useLocation, useNavigate, useNavigationType, type NavigationType } from "react-router-dom";
import { Button } from "./ui";

type HistoryEntry = {
  idx: number;
  url: string;
};

type StoredHistory = {
  entries: HistoryEntry[];
};

type NavigationContextValue = {
  canGoBack: boolean;
  goBack: () => void;
};

const STORAGE_KEY = "dekai-app-navigation-history";

const NavigationContext = createContext<NavigationContextValue | null>(null);

const readCurrentIndex = () => {
  if (typeof window === "undefined") {
    return null;
  }

  const index = window.history.state && typeof window.history.state.idx === "number" ? window.history.state.idx : null;
  return typeof index === "number" ? index : null;
};

const readStoredHistory = (): HistoryEntry[] => {
  if (typeof window === "undefined") {
    return [];
  }

  const raw = window.sessionStorage.getItem(STORAGE_KEY);
  if (!raw) {
    return [];
  }

  try {
    const parsed = JSON.parse(raw) as Partial<StoredHistory>;
    if (!Array.isArray(parsed.entries)) {
      return [];
    }

    return parsed.entries
      .filter((entry): entry is HistoryEntry => typeof entry?.idx === "number" && typeof entry?.url === "string")
      .sort((left, right) => left.idx - right.idx);
  } catch {
    return [];
  }
};

const writeStoredHistory = (entries: HistoryEntry[]) => {
  if (typeof window === "undefined") {
    return;
  }

  window.sessionStorage.setItem(
    STORAGE_KEY,
    JSON.stringify({
      entries,
    } satisfies StoredHistory),
  );
};

const getLocationUrl = (pathname: string, search: string, hash: string) => `${pathname}${search}${hash}`;

const upsertHistoryEntry = (entries: HistoryEntry[], nextEntry: HistoryEntry, navigationType: NavigationType) => {
  const withoutFuture = entries.filter((entry) => entry.idx <= nextEntry.idx);
  const existingIndex = withoutFuture.findIndex((entry) => entry.idx === nextEntry.idx);

  if (existingIndex >= 0) {
    const updated = [...withoutFuture];
    updated[existingIndex] = nextEntry;
    return updated.sort((left, right) => left.idx - right.idx);
  }

  if (navigationType === "REPLACE" && withoutFuture.length > 0) {
    const updated = [...withoutFuture];
    updated[updated.length - 1] = nextEntry;
    return updated.sort((left, right) => left.idx - right.idx);
  }

  return [...withoutFuture, nextEntry].sort((left, right) => left.idx - right.idx);
};

const previousEntryForIndex = (entries: HistoryEntry[], currentIdx: number | null) => {
  if (currentIdx === null) {
    return null;
  }

  const previousEntries = entries.filter((entry) => entry.idx < currentIdx);
  return previousEntries.length > 0 ? previousEntries[previousEntries.length - 1] : null;
};

function AppNavigationTracker({ children }: PropsWithChildren) {
  const location = useLocation();
  const navigate = useNavigate();
  const navigationType = useNavigationType();
  const [entries, setEntries] = useState<HistoryEntry[]>(() => readStoredHistory());

  const currentIndex = readCurrentIndex();
  const currentUrl = getLocationUrl(location.pathname, location.search, location.hash);

  useEffect(() => {
    if (currentIndex === null) {
      return;
    }

    setEntries((current) => {
      const nextEntries = upsertHistoryEntry(current, { idx: currentIndex, url: currentUrl }, navigationType);
      writeStoredHistory(nextEntries);
      return nextEntries;
    });
  }, [currentIndex, currentUrl, navigationType]);

  const canGoBack = useMemo(() => previousEntryForIndex(entries, currentIndex) !== null, [currentIndex, entries]);

  const goBack = useCallback(() => {
    const previousEntry = previousEntryForIndex(entries, currentIndex);
    if (!previousEntry) {
      return;
    }

    if (currentIndex !== null && previousEntry.idx === currentIndex - 1) {
      navigate(-1);
      return;
    }

    navigate(previousEntry.url, { replace: true });
  }, [currentIndex, entries, navigate]);

  const value = useMemo(
    () => ({
      canGoBack,
      goBack,
    }),
    [canGoBack, goBack],
  );

  return <NavigationContext.Provider value={value}>{children}</NavigationContext.Provider>;
}

export function AppNavigationProvider({ children }: PropsWithChildren) {
  return <AppNavigationTracker>{children}</AppNavigationTracker>;
}

export function useAppBack() {
  const context = useContext(NavigationContext);

  if (!context) {
    throw new Error("useAppBack must be used inside AppNavigationProvider");
  }

  return context;
}

export function PageBackButton({
  className,
  onBack,
}: {
  className?: string;
  onBack?: () => void;
}) {
  const { goBack } = useAppBack();

  return (
    <Button
      className={className}
      onClick={() => {
        if (onBack) {
          onBack();
          return;
        }
        goBack();
      }}
      size="sm"
      type="button"
      variant="secondary"
    >
      <ArrowLeft className="h-4 w-4" />
      Back
    </Button>
  );
}
