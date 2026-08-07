import { ChevronDown, ChevronRight, FolderTree, Search } from "lucide-react";
import { useDeferredValue, useEffect, useMemo, useRef, useState } from "react";
import { useLocation, useSearchParams } from "react-router-dom";
import { PageBackButton, useAppBack } from "../components/navigation";
import { Badge, Button, PageMotion, Panel, useToast } from "../components/ui";
import { useKnowledgeBase } from "../hooks/use-knowledge-base";
import { usePreferences } from "../lib/preferences";
import { SourceChip } from "./dekai-ui";

type Selection =
  | { kind: "chapter"; chapterKey: string }
  | { kind: "section"; chapterKey: string; sectionKey: string }
  | null;

type ChapterItem = {
  chapter_number: string;
  chapter_title: string;
  summary_en: string;
  summary_thanglish: string;
  section_count: number;
  rule_count: number;
  condition_count: number;
  validation_count: number;
  workflow_count: number;
  authority_count: number;
  timeline_count: number;
  exception_count: number;
  related_chapters: string[];
  sections: Array<{ section: string; title: string; pages: number[] }>;
};

type SectionItem = {
  id: string;
  title: string;
  chapterNumber: string;
  chapterTitle: string;
  documentName: string;
  purpose: string;
  summary: string;
  businessMeaning: string;
  rulesCount: number;
  conditionsCount: number;
  validationsCount: number;
  exceptionsCount: number;
  authorities: string[];
  timelines: string[];
  workflow: string[];
  relatedChapters: string[];
  businessRules: Array<{
    id: string;
    name: string;
    description: string;
    condition: string;
    exception: string;
    output: string;
  }>;
};

type ViewSection = SectionItem & {
  chapterKey: string;
  sectionKey: string;
};

type FilteredChapter = ChapterItem & {
  chapterKey: string;
  chapterMatch: boolean;
  visibleSections: ViewSection[];
  allSections: ViewSection[];
};

const normalize = (value: string) => value.toLowerCase().replace(/\s+/g, " ").trim();

const stripExtension = (value: string) => value.replace(/\.[a-z0-9]{1,6}$/i, "");

const chapterKeyFromParts = (chapterNumber: string, fallback: string) => {
  const normalizedChapter = normalize(chapterNumber);
  if (normalizedChapter) {
    return `chapter:${normalizedChapter}`;
  }
  return `document:${normalize(stripExtension(fallback))}`;
};

const chapterKeyForChapter = (chapter: ChapterItem) =>
  chapterKeyFromParts(chapter.chapter_number, chapter.chapter_title);

const chapterKeyForSection = (section: SectionItem) =>
  chapterKeyFromParts(section.chapterNumber, section.documentName || section.chapterTitle);

const sectionKeyForSection = (section: SectionItem) =>
  [chapterKeyForSection(section), normalize(section.id), normalize(section.title)].join("::");

const chapterLabel = (chapter: ChapterItem) =>
  chapter.chapter_number ? `Chapter ${chapter.chapter_number}` : "Document";

const chapterHeading = (chapter: ChapterItem) =>
  chapter.chapter_number ? `Chapter ${chapter.chapter_number} ${chapter.chapter_title}` : chapter.chapter_title;

const tokenize = (value: string) =>
  normalize(value)
    .split(" ")
    .map((token) => token.trim())
    .filter(Boolean);

const listText = (value: unknown) =>
  Array.isArray(value)
    ? value
        .map((item) => {
          if (typeof item === "string") return item;
          if (item && typeof item === "object") {
            return Object.values(item)
              .filter((entry) => typeof entry === "string")
              .join(" ");
          }
          return "";
        })
        .join(" ")
    : "";

const includesQuery = (haystack: string, query: string) => {
  if (!query) return true;
  const normalizedHaystack = normalize(haystack);
  if (normalizedHaystack.includes(query)) return true;
  return tokenize(query).every((token) => normalizedHaystack.includes(token));
};

const isExactChapterMatch = (chapter: ChapterItem, query: string) => {
  const normalized = normalize(query);
  if (!normalized) return false;
  const chapterText = chapterHeading(chapter);
  return (
    normalized === normalize(chapterLabel(chapter)) ||
    normalized === normalize(chapter.chapter_number) ||
    normalized === normalize(chapter.chapter_title) ||
    normalized === normalize(chapterText)
  );
};

const isExactSectionMatch = (section: ViewSection, query: string) => {
  const normalized = normalize(query);
  if (!normalized) return false;
  return (
    normalized === normalize(section.id) ||
    normalized === normalize(section.title) ||
    normalized === normalize(`${section.id} ${section.title}`)
  );
};

const buildChapterSearchText = (chapter: ChapterItem) =>
  [
    chapterLabel(chapter),
    chapterHeading(chapter),
    chapter.chapter_number,
    chapter.chapter_title,
    chapter.summary_en,
    chapter.summary_thanglish,
    ...chapter.sections.map((section) => `${section.section} ${section.title}`),
  ].join(" ");

const buildSectionSearchText = (section: ViewSection, chapter: ChapterItem | undefined) => {
  const extras = section as ViewSection & Record<string, unknown>;
  return [
    chapterLabel(chapter ?? { ...section, chapter_number: section.chapterNumber, chapter_title: section.chapterTitle, summary_en: "", summary_thanglish: "", section_count: 0, rule_count: 0, condition_count: 0, validation_count: 0, workflow_count: 0, authority_count: 0, timeline_count: 0, exception_count: 0, related_chapters: [], sections: [] }),
    `chapter ${section.chapterNumber}`,
    section.chapterNumber,
    chapter?.chapter_title ?? section.chapterTitle,
    chapter?.summary_en ?? "",
    section.id,
    section.title,
    section.summary,
    section.businessMeaning,
    section.purpose,
    section.documentName,
    listText(section.authorities),
    listText(section.timelines),
    listText(section.workflow),
    listText(section.businessRules),
    listText(extras.documents),
    listText(extras.requiredDocuments),
    listText(extras.keywords),
    listText(extras.searchKeywords),
    listText(extras.notes),
    listText(extras.definitions),
    typeof extras.rawText === "string" ? extras.rawText : "",
  ].join(" ");
};

const sameSelection = (left: Selection, right: Selection) => {
  if (left === right) return true;
  if (!left || !right) return false;
  if (left.kind !== right.kind) return false;
  if (left.chapterKey !== right.chapterKey) return false;
  return left.kind === "section" && right.kind === "section" ? left.sectionKey === right.sectionKey : true;
};

const isSelectionVisible = (selection: Selection, chapters: FilteredChapter[]) => {
  if (!selection) return false;
  if (selection.kind === "chapter") {
    return chapters.some((chapter) => chapter.chapterKey === selection.chapterKey);
  }
  return chapters.some(
    (chapter) =>
      chapter.chapterKey === selection.chapterKey &&
      chapter.visibleSections.some((section) => section.sectionKey === selection.sectionKey),
  );
};

const OPEN_CHAPTERS_STORAGE_PREFIX = "dekai-kb-open-chapters:";

const selectionFromSearchParams = (searchParams: URLSearchParams): Selection => {
  const section = searchParams.get("section") ?? "";
  const chapter = searchParams.get("chapter") ?? "";
  if (section) {
    return { kind: "section", chapterKey: chapter, sectionKey: section };
  }
  if (chapter) {
    return { kind: "chapter", chapterKey: chapter };
  }
  return null;
};

export function KnowledgeBasePage() {
  const { data, isLoading } = useKnowledgeBase();
  const { pushToast } = useToast();
  const { t } = usePreferences();
  const location = useLocation();
  const [searchParams, setSearchParams] = useSearchParams();
  const selectionHistoryModeRef = useRef<"replace" | "push">("replace");
  useAppBack();
  const [query, setQuery] = useState(searchParams.get("q") ?? "");
  const deferredQuery = useDeferredValue(query);
  const [openChapters, setOpenChapters] = useState<Record<string, boolean>>({});
  const sectionButtonRefs = useRef<Record<string, HTMLButtonElement | null>>({});
  const [selection, setSelection] = useState<Selection>(() => selectionFromSearchParams(searchParams));

  useEffect(() => {
    const q = searchParams.get("q") ?? "";
    const nextSelection = selectionFromSearchParams(searchParams);
    setQuery((current) => (current === q ? current : q));
    setSelection((current) => (sameSelection(current, nextSelection) ? current : nextSelection));
  }, [location.search, searchParams]);

  useEffect(() => {
    const saved = window.sessionStorage.getItem(`${OPEN_CHAPTERS_STORAGE_PREFIX}${location.pathname}${location.search}`);
    if (!saved) {
      setOpenChapters({});
      return;
    }
    try {
      const parsed = JSON.parse(saved) as Record<string, boolean>;
      setOpenChapters(parsed && typeof parsed === "object" ? parsed : {});
    } catch {
      setOpenChapters({});
    }
  }, [location.pathname, location.search]);

  const sectionViews = useMemo<ViewSection[]>(() => {
    if (!data) return [];
    return data.sections.map((section) => ({
      ...section,
      chapterKey: chapterKeyForSection(section),
      sectionKey: sectionKeyForSection(section),
    }));
  }, [data]);

  const sectionsByChapter = useMemo(() => {
    const map = new Map<string, ViewSection[]>();
    for (const section of sectionViews) {
      const current = map.get(section.chapterKey) ?? [];
      current.push(section);
      map.set(section.chapterKey, current);
    }
    return map;
  }, [sectionViews]);

  const filteredChapters = useMemo<FilteredChapter[]>(() => {
    if (!data) return [];
    const normalizedQuery = normalize(deferredQuery);

    return data.chapters
      .map((chapter) => {
        const chapterKey = chapterKeyForChapter(chapter);
        const allSections = sectionsByChapter.get(chapterKey) ?? [];
        const chapterMatch = !normalizedQuery || includesQuery(buildChapterSearchText(chapter), normalizedQuery);
        const visibleSections =
          !normalizedQuery || chapterMatch
            ? allSections
            : allSections.filter((section) => includesQuery(buildSectionSearchText(section, chapter), normalizedQuery));

        return {
          ...chapter,
          chapterKey,
          allSections,
          chapterMatch,
          visibleSections,
        };
      })
      .filter((chapter) => chapter.chapterMatch || chapter.visibleSections.length > 0);
  }, [data, deferredQuery, sectionsByChapter]);

  const visibleSections = useMemo(
    () => filteredChapters.flatMap((chapter) => chapter.visibleSections),
    [filteredChapters],
  );

  const activeSelection = useMemo(() => {
    if (!data) return null;
    const normalizedQuery = normalize(deferredQuery);
    if (!filteredChapters.length) return null;

    const exactSection = visibleSections.find((section) => isExactSectionMatch(section, normalizedQuery));
    if (exactSection) {
      return { kind: "section", chapterKey: exactSection.chapterKey, sectionKey: exactSection.sectionKey } satisfies Selection;
    }

    if (normalizedQuery && selection?.kind === "section" && isSelectionVisible(selection, filteredChapters)) {
      return selection;
    }

    const exactChapter = filteredChapters.find((chapter) => isExactChapterMatch(chapter, normalizedQuery));
    if (exactChapter) {
      return { kind: "chapter", chapterKey: exactChapter.chapterKey } satisfies Selection;
    }

    if (!normalizedQuery) {
      if (selection?.kind === "section" && sectionViews.some((section) => section.sectionKey === selection.sectionKey)) {
        const selected = sectionViews.find((section) => section.sectionKey === selection.sectionKey);
        return {
          kind: "section",
          chapterKey: selection.chapterKey || selected?.chapterKey || "",
          sectionKey: selection.sectionKey,
        } satisfies Selection;
      }
      if (selection?.kind === "chapter" && filteredChapters.some((chapter) => chapter.chapterKey === selection.chapterKey)) {
        return selection;
      }
      return null;
    }

    if (filteredChapters.length === 1 && filteredChapters[0].chapterMatch) {
      return { kind: "chapter", chapterKey: filteredChapters[0].chapterKey } satisfies Selection;
    }

    if (visibleSections.length === 1) {
      const onlySection = visibleSections[0];
      return { kind: "section", chapterKey: onlySection.chapterKey, sectionKey: onlySection.sectionKey } satisfies Selection;
    }

    if (isSelectionVisible(selection, filteredChapters)) {
      return selection;
    }

    const firstChapter = filteredChapters[0];
    if (firstChapter.chapterMatch) {
      return { kind: "chapter", chapterKey: firstChapter.chapterKey } satisfies Selection;
    }
    const firstSection = firstChapter.visibleSections[0];
    return firstSection
      ? ({ kind: "section", chapterKey: firstSection.chapterKey, sectionKey: firstSection.sectionKey } satisfies Selection)
      : ({ kind: "chapter", chapterKey: firstChapter.chapterKey } satisfies Selection);
  }, [data, deferredQuery, filteredChapters, sectionViews, selection, visibleSections]);

  useEffect(() => {
    if (!sameSelection(selection, activeSelection)) {
      setSelection(activeSelection);
    }
  }, [activeSelection, selection]);

  useEffect(() => {
    if (activeSelection?.kind !== "section") return;
    setOpenChapters((current) => {
      if (current[activeSelection.chapterKey]) {
        return current;
      }
      return { ...current, [activeSelection.chapterKey]: true };
    });
  }, [activeSelection]);

  useEffect(() => {
    if (activeSelection?.kind !== "section") return;
    const element = sectionButtonRefs.current[activeSelection.sectionKey];
    if (!element) return;
    const frame = window.requestAnimationFrame(() => {
      element.scrollIntoView({ block: "nearest", behavior: "smooth" });
    });
    return () => window.cancelAnimationFrame(frame);
  }, [activeSelection]);

  useEffect(() => {
    const next = new URLSearchParams(searchParams);
    const normalizedQuery = query.trim();

    if (normalizedQuery) {
      next.set("q", normalizedQuery);
    } else {
      next.delete("q");
    }

    if (activeSelection?.kind === "section") {
      next.set("chapter", activeSelection.chapterKey);
      next.set("section", activeSelection.sectionKey);
    } else if (activeSelection?.kind === "chapter") {
      next.set("chapter", activeSelection.chapterKey);
      next.delete("section");
    } else {
      next.delete("chapter");
      next.delete("section");
    }

    const currentSerialized = searchParams.toString();
    const nextSerialized = next.toString();
    if (currentSerialized !== nextSerialized) {
      const replace = selectionHistoryModeRef.current !== "push";
      selectionHistoryModeRef.current = "replace";
      setSearchParams(next, { replace });
    }
  }, [activeSelection, query, searchParams, setSearchParams]);

  useEffect(() => {
    window.sessionStorage.setItem(`${OPEN_CHAPTERS_STORAGE_PREFIX}${location.pathname}${location.search}`, JSON.stringify(openChapters));
  }, [location.pathname, location.search, openChapters]);

  const selectedChapter = activeSelection
    ? filteredChapters.find((chapter) => chapter.chapterKey === activeSelection.chapterKey) ?? null
    : null;

  const selectedSection =
    activeSelection?.kind === "section"
      ? sectionViews.find((section) => section.sectionKey === activeSelection.sectionKey) ?? null
      : null;

  const selectedSectionChapter =
    selectedSection ? filteredChapters.find((chapter) => chapter.chapterKey === selectedSection.chapterKey) ?? null : null;

  const visibleSectionCount = visibleSections.length;

  const openSection = (sectionKey: string, chapterKey: string) => {
    if (!data) {
      pushToast({ title: t("knowledge.openSectionFailed"), tone: "warning" });
      return;
    }
    const section = sectionViews.find((item) => item.sectionKey === sectionKey && item.chapterKey === chapterKey);
    if (!section) {
      pushToast({ title: t("knowledge.openSectionFailed"), tone: "warning" });
      return;
    }
    selectionHistoryModeRef.current = "push";
    setOpenChapters((current) => ({ ...current, [chapterKey]: true }));
    setSelection({ kind: "section", chapterKey, sectionKey });
  };

  if (isLoading || !data) {
    return (
      <PageMotion className="space-y-4">
        <Panel className="animate-pulse p-8">
          <div className="h-6 w-48 rounded-full bg-[var(--panel-subtle)]" />
          <div className="mt-6 h-80 rounded-[1.5rem] bg-[var(--panel-subtle)]" />
        </Panel>
      </PageMotion>
    );
  }

  return (
    <PageMotion className="space-y-6">
      <Panel className="space-y-5 p-6 sm:p-8">
        <div className="flex items-start justify-between gap-4">
          <PageBackButton />
        </div>

        <div className="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
          <div>
            <p className="text-sm font-semibold uppercase tracking-[0.22em] text-[var(--accent)]">{t("common.knowledgeBase")}</p>
            <h1 className="mt-2 text-3xl font-semibold tracking-tight text-[var(--foreground)]">{t("knowledge.title")}</h1>
            <p className="mt-3 max-w-3xl text-sm leading-7 text-[var(--muted-foreground)]">
              {t("knowledge.subtitle")}
            </p>
          </div>
          <Badge tone="info">{t("knowledge.visibleSections", { count: visibleSectionCount })}</Badge>
        </div>

        <label className="relative block">
          <Search className="pointer-events-none absolute left-4 top-1/2 h-4 w-4 -translate-y-1/2 text-[var(--muted-foreground)]" />
          <input
            className="field pl-11"
            onChange={(event) => {
              setQuery(event.target.value);
            }}
            placeholder={t("knowledge.searchPlaceholder")}
            value={query}
          />
        </label>
      </Panel>

      <div className="grid gap-6 xl:grid-cols-[360px_minmax(0,1fr)]">
        <Panel className="space-y-4 p-4 sm:p-5">
          <div className="flex items-center gap-3 rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
            <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-[var(--panel)] text-[var(--accent)]">
              <FolderTree className="h-5 w-5" />
            </div>
            <div>
              <p className="text-sm font-semibold text-[var(--foreground)]">{t("knowledge.dgft")}</p>
              <p className="text-sm text-[var(--muted-foreground)]">{t("knowledge.ftpHbp")}</p>
            </div>
          </div>

          {filteredChapters.length > 0 ? (
            <div className="space-y-3">
              {filteredChapters.map((chapter) => {
                const queryActive = Boolean(normalize(deferredQuery));
                const open = queryActive || openChapters[chapter.chapterKey] || chapter.chapterKey === (activeSelection?.chapterKey ?? "");
                const chapterSelected = activeSelection?.kind === "chapter" && activeSelection.chapterKey === chapter.chapterKey;

                return (
                  <div key={chapter.chapterKey} className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel)]">
                    <button
                      className={chapterSelected ? "flex w-full items-center justify-between gap-3 rounded-[1.5rem] bg-[var(--panel-strong)] px-4 py-4 text-left" : "flex w-full items-center justify-between gap-3 px-4 py-4 text-left"}
                      onClick={() => {
                        selectionHistoryModeRef.current = "push";
                        setSelection({ kind: "chapter", chapterKey: chapter.chapterKey });
                        if (!queryActive) {
                          setOpenChapters((current) => ({ ...current, [chapter.chapterKey]: !open }));
                        }
                      }}
                      type="button"
                    >
                      <div>
                        <p className="text-sm font-semibold text-[var(--foreground)]">{chapterLabel(chapter)}</p>
                        <p className="mt-1 text-sm text-[var(--muted-foreground)]">{chapter.chapter_title}</p>
                      </div>
                      {open ? (
                        <ChevronDown className="h-4 w-4 text-[var(--muted-foreground)]" />
                      ) : (
                        <ChevronRight className="h-4 w-4 text-[var(--muted-foreground)]" />
                      )}
                    </button>

                    {open ? (
                      <div className="border-t border-[var(--border)] px-3 py-3">
                        <div className="space-y-2">
                          {chapter.visibleSections.map((section) => {
                            const isSelected = activeSelection?.kind === "section" && activeSelection.sectionKey === section.sectionKey;
                            return (
                              <button
                                key={section.sectionKey}
                                ref={(element) => {
                                  sectionButtonRefs.current[section.sectionKey] = element;
                                }}
                                className={isSelected ? "w-full rounded-2xl bg-[var(--panel-strong)] px-3 py-3 text-left" : "w-full rounded-2xl px-3 py-3 text-left hover:bg-[var(--panel-subtle)]"}
                                onClick={() => openSection(section.sectionKey, section.chapterKey)}
                                type="button"
                              >
                                <p className="text-sm font-medium text-[var(--foreground)]">
                                  {section.id} {section.title}
                                </p>
                              </button>
                            );
                          })}
                          {chapter.visibleSections.length === 0 ? (
                            <div className="rounded-2xl bg-[var(--panel-subtle)] px-3 py-3 text-sm text-[var(--muted-foreground)]">
                              {t("knowledge.noSectionMatch")}
                            </div>
                          ) : null}
                        </div>
                      </div>
                    ) : null}
                  </div>
                );
              })}
            </div>
          ) : (
            <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-5 text-sm text-[var(--muted-foreground)]">
              {t("knowledge.noMatch")}
            </div>
          )}
        </Panel>

        <Panel className="space-y-5 p-5 sm:p-6">
          {!filteredChapters.length ? (
            <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-5 text-sm text-[var(--muted-foreground)]">
              {t("knowledge.noMatch")}
            </div>
          ) : selectedSection ? (
            <>
              <div>
                <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">
                  {selectedSectionChapter ? chapterLabel(selectedSectionChapter) : selectedSection.chapterNumber ? `Chapter ${selectedSection.chapterNumber}` : "Document"}
                </p>
                <h2 className="mt-2 text-2xl font-semibold text-[var(--foreground)]">
                  {selectedSection.id} {selectedSection.title}
                </h2>
                <p className="mt-3 max-w-3xl text-sm leading-7 text-[var(--muted-foreground)]">{selectedSection.summary}</p>
              </div>

              <div className="grid gap-4 lg:grid-cols-2">
                <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{t("knowledge.businessMeaning")}</p>
                  <p className="mt-3 text-sm leading-7 text-[var(--foreground)]">{selectedSection.businessMeaning}</p>
                </div>
                <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{t("knowledge.knowledgeSignals")}</p>
                  <p className="mt-3 text-sm leading-7 text-[var(--foreground)]">
                    {t("knowledge.ruleSummary", {
                      rules: selectedSection.rulesCount,
                      conditions: selectedSection.conditionsCount,
                      exceptions: selectedSection.exceptionsCount,
                    })}
                  </p>
                </div>
              </div>

              <div className="grid gap-4 lg:grid-cols-2">
                <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{t("knowledge.authorities")}</p>
                  <div className="mt-3 flex flex-wrap gap-2">
                    {selectedSection.authorities.map((authority) => (
                      <SourceChip key={authority}>{authority}</SourceChip>
                    ))}
                    {selectedSection.authorities.length === 0 ? <p className="text-sm text-[var(--muted-foreground)]">{t("knowledge.noAuthorities")}</p> : null}
                  </div>
                </div>

                <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{t("knowledge.relatedChapters")}</p>
                  <div className="mt-3 flex flex-wrap gap-2">
                    {selectedSection.relatedChapters.map((chapter) => (
                      <SourceChip key={chapter}>{t("knowledge.chapterWithNumber", { value: chapter })}</SourceChip>
                    ))}
                    {selectedSection.relatedChapters.length === 0 ? <p className="text-sm text-[var(--muted-foreground)]">{t("knowledge.noRelatedChapters")}</p> : null}
                  </div>
                </div>
              </div>

              <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
                <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{t("knowledge.sectionViewer")}</p>
                <div className="mt-4 space-y-3">
                  {selectedSection.businessRules.slice(0, 5).map((rule) => (
                    <div key={rule.id} className="rounded-[1.25rem] border border-[var(--border)] bg-[var(--panel)] p-4">
                      <p className="text-sm font-semibold text-[var(--foreground)]">{rule.name}</p>
                      <p className="mt-2 text-sm leading-7 text-[var(--muted-foreground)]">{rule.description}</p>
                    </div>
                  ))}
                  {selectedSection.businessRules.length === 0 ? (
                    <div className="rounded-[1.25rem] border border-[var(--border)] bg-[var(--panel)] p-4 text-sm text-[var(--muted-foreground)]">
                      {t("knowledge.noBusinessRules")}
                    </div>
                  ) : null}
                </div>
              </div>
            </>
          ) : selectedChapter ? (
            <>
              <div>
                <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">
                  {chapterLabel(selectedChapter)}
                </p>
                <h2 className="mt-2 text-2xl font-semibold text-[var(--foreground)]">
                  {chapterHeading(selectedChapter)}
                </h2>
                <p className="mt-3 max-w-3xl text-sm leading-7 text-[var(--muted-foreground)]">{selectedChapter.summary_en}</p>
              </div>

              <div className="grid gap-4 lg:grid-cols-2">
                <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{t("knowledge.knowledgeSignals")}</p>
                  <p className="mt-3 text-sm leading-7 text-[var(--foreground)]">
                    {t("knowledge.ruleSummary", {
                      rules: selectedChapter.rule_count,
                      conditions: selectedChapter.condition_count,
                      exceptions: selectedChapter.exception_count,
                    })}
                  </p>
                </div>
                <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{t("knowledge.coverage")}</p>
                  <p className="mt-3 text-sm leading-7 text-[var(--foreground)]">
                    {t("knowledge.coverageSummary", {
                      sections: selectedChapter.section_count,
                      workflows: selectedChapter.workflow_count,
                      authorities: selectedChapter.authority_count,
                    })}
                  </p>
                </div>
              </div>

              <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
                <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{t("knowledge.matchingSections")}</p>
                <div className="mt-4 space-y-3">
                  {selectedChapter.visibleSections.map((section) => (
                    <div key={section.sectionKey} className="rounded-[1.25rem] border border-[var(--border)] bg-[var(--panel)] p-4">
                      <p className="text-sm font-semibold text-[var(--foreground)]">
                        {section.id} {section.title}
                      </p>
                      <p className="mt-2 text-sm leading-7 text-[var(--muted-foreground)]">{section.businessMeaning || section.summary}</p>
                      <Button
                        className="mt-3"
                        onClick={() => openSection(section.sectionKey, section.chapterKey)}
                        size="sm"
                        type="button"
                        variant="secondary"
                      >
                        Open Section
                      </Button>
                    </div>
                  ))}
                </div>
              </div>
            </>
          ) : (
            <div className="space-y-4 rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-5">
              <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{t("knowledge.homeTag")}</p>
              <h2 className="text-2xl font-semibold text-[var(--foreground)]">{t("knowledge.homeTitle")}</h2>
              <p className="max-w-3xl text-sm leading-7 text-[var(--muted-foreground)]">
                {t("knowledge.homeSubtitle")}
              </p>
            </div>
          )}
        </Panel>
      </div>
    </PageMotion>
  );
}
