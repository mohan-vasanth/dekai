import { ArrowRight, Search } from "lucide-react";
import { useDeferredValue, useEffect, useMemo, useRef, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { PageBackButton } from "../components/navigation";
import { useKnowledgeBase } from "../hooks/use-knowledge-base";
import { usePreferences } from "../lib/preferences";
import { Badge, Button, PageMotion, Panel } from "../components/ui";
import type { ChapterRecord, DekaiData, RuleRecord, SectionRecord, WorkflowRecord } from "../types/api";

type SearchMode = "keyword" | "chapter" | "section" | "rule" | "workflow" | "authority";
type SearchSuggestion = "IEC" | "Rule" | "Chapter" | "Section" | "HS Code" | "Import" | "Export";
type SearchFilter = SearchSuggestion | SearchMode;

type IndexedSection = {
  chapterBadge: string;
  chapterNumber: string;
  chapterTitle: string;
  compactByMode: Record<SearchMode, string>;
  compactBySuggestion: Record<SearchSuggestion, string>;
  documentName: string;
  modeLabels: SearchMode[];
  preview: string;
  sectionId: string;
  sectionTitle: string;
  textByMode: Record<SearchMode, string>;
  textBySuggestion: Record<SearchSuggestion, string>;
};

type SearchResultCard = {
  chapterBadge: string;
  chapterNumber: string;
  chapterTitle: string;
  documentName: string;
  matchLabel: string;
  preview: string;
  score: number;
  sectionId: string;
  sectionTitle: string;
};

const searchSuggestions = ["IEC", "Rule", "Chapter", "Section", "HS Code", "Import", "Export"] as const;
const searchModes = ["keyword", "chapter", "section", "rule", "workflow", "authority"] as const;
const TOPIC_PARAM = "topic";
const suggestionModeMap = {
  IEC: "keyword",
  Rule: "rule",
  Chapter: "chapter",
  Section: "section",
  "HS Code": "keyword",
  Import: "keyword",
  Export: "keyword",
} satisfies Record<SearchSuggestion, SearchMode>;

const normalize = (value: string) => value.toLowerCase().replace(/\s+/g, " ").trim();
const compact = (value: string) => normalize(value).replace(/\s+/g, "");

const tokenize = (value: string) =>
  normalize(value)
    .split(" ")
    .map((token) => token.trim())
    .filter(Boolean);

const isSearchSuggestion = (value: string | null): value is SearchSuggestion => searchSuggestions.includes(value as SearchSuggestion);
const isSearchMode = (value: string | null): value is SearchMode => searchModes.includes(value as SearchMode);

const asTextArray = (value: unknown): string[] => {
  if (!Array.isArray(value)) {
    return [];
  }

  return value.flatMap((item) => {
    if (typeof item === "string" || typeof item === "number") {
      return [String(item)];
    }
    if (item && typeof item === "object") {
      return Object.values(item)
        .filter((entry): entry is string | number => typeof entry === "string" || typeof entry === "number")
        .map((entry) => String(entry));
    }
    return [];
  });
};

const unique = (values: string[]) => Array.from(new Set(values.map((value) => value.trim()).filter(Boolean)));

const join = (...groups: string[][]) => unique(groups.flat()).join(" ");

const chipClassName = (active: boolean) =>
  active
    ? "rounded-full bg-[var(--accent)] px-4 py-2 text-sm font-semibold text-[var(--accent-foreground)]"
    : "rounded-full border border-[var(--border)] bg-[var(--panel)] px-4 py-2 text-sm font-medium text-[var(--foreground)] transition hover:border-[var(--accent)]/35 hover:bg-[var(--panel-subtle)]";

const trimPreview = (value: string) => {
  const cleaned = value.replace(/\s+/g, " ").trim();
  if (cleaned.length <= 220) {
    return cleaned;
  }
  return `${cleaned.slice(0, 217).trimEnd()}...`;
};

const buildRuleMap = (rules: RuleRecord[]) => {
  const map = new Map<string, RuleRecord[]>();
  for (const rule of rules) {
    const current = map.get(rule.section) ?? [];
    current.push(rule);
    map.set(rule.section, current);
  }
  return map;
};

const buildWorkflowMap = (workflows: WorkflowRecord[]) => {
  const map = new Map<string, WorkflowRecord[]>();
  for (const workflow of workflows) {
    const current = map.get(workflow.section) ?? [];
    current.push(workflow);
    map.set(workflow.section, current);
  }
  return map;
};

const buildSectionIndex = (data: DekaiData): IndexedSection[] => {
  const chaptersByNumber = new Map<string, ChapterRecord>(data.chapters.map((chapter) => [chapter.chapter_number, chapter]));
  const rulesBySection = buildRuleMap(data.rules);
  const workflowsBySection = buildWorkflowMap(data.workflows);

  return data.sections.map((section) => {
    const extras = section as SectionRecord & Record<string, unknown>;
    const chapter = chaptersByNumber.get(section.chapterNumber);
    const rules = rulesBySection.get(section.id) ?? [];
    const workflows = workflowsBySection.get(section.id) ?? [];
    const authorities = unique([
      ...section.authorities,
      ...rules.map((rule) => rule.authority),
      ...asTextArray(extras.authority),
      ...asTextArray(extras.authorities),
    ]);
    const timelines = unique([...section.timelines, ...rules.map((rule) => rule.timeline), ...workflows.map((workflow) => workflow.timeline)]);
    const keywords = unique([
      ...asTextArray(extras.keywords),
      ...asTextArray(extras.searchKeywords),
      ...asTextArray(extras.search_keywords),
      ...asTextArray(extras.tags),
      ...asTextArray(extras.hsCodes),
      ...asTextArray(extras.hs_codes),
      ...asTextArray(extras.eximCodes),
      ...asTextArray(extras.exim_codes),
    ]);
    const documents = unique([...section.documents, ...asTextArray(extras.requiredDocuments), ...asTextArray(extras.documents)]);

    const chapterBits = [
      `chapter ${section.chapterNumber}`,
      `chapter${section.chapterNumber}`,
      section.chapterNumber,
      section.chapterTitle,
      chapter?.chapter_title ?? "",
      chapter?.summary_en ?? "",
      chapter?.summary_thanglish ?? "",
    ];
    const sectionBits = [
      section.id,
      `${section.id} ${section.title}`,
      section.title,
      section.summary,
      section.businessMeaning,
      section.purpose,
      section.documentName,
      typeof extras.rawText === "string" ? extras.rawText : "",
      ...documents,
      ...keywords,
      ...asTextArray(extras.notes),
      ...asTextArray(extras.definitions),
    ];
    const ruleBits = [
      ...section.businessRules.flatMap((rule) => [rule.id, rule.name, rule.description, rule.condition, rule.exception, rule.output]),
      ...rules.flatMap((rule) => [rule.ruleId, rule.ruleName, rule.description, rule.condition, rule.exception]),
      ...asTextArray(extras.ai_rules),
      ...asTextArray(extras.aiRules),
    ];
    const workflowBits = [
      ...section.workflow,
      ...workflows.flatMap((workflow) => [workflow.id, workflow.title, workflow.authority, workflow.timeline, workflow.ascii, workflow.mermaid, ...workflow.steps]),
    ];
    const authorityBits = [...authorities, ...timelines];
    const hsCodeBits = unique([
      ...asTextArray(extras.hsCodes),
      ...asTextArray(extras.hs_codes),
      ...asTextArray(extras.eximCodes),
      ...asTextArray(extras.exim_codes),
      ...keywords.filter((keyword) => /\d/.test(keyword)),
      section.id,
      section.title,
      section.summary,
    ]);
    const importBits = unique([
      ...sectionBits,
      ...ruleBits,
      ...workflowBits,
      ...keywords.filter((keyword) => normalize(keyword).includes("import") || normalize(keyword).includes("importer")),
      "import importer imported imports import process import procedure import licence import license import authorization",
    ]);
    const exportBits = unique([
      ...sectionBits,
      ...ruleBits,
      ...workflowBits,
      ...keywords.filter((keyword) => normalize(keyword).includes("export") || normalize(keyword).includes("exporter")),
      "export exporter exported exports export process export procedure export licence export license export authorization",
    ]);

    const textByMode = {
      keyword: join(chapterBits, sectionBits, ruleBits, workflowBits, authorityBits),
      chapter: join(chapterBits, [section.id, section.title]),
      section: join(sectionBits, [section.chapterTitle]),
      rule: join(sectionBits, ruleBits),
      workflow: join(sectionBits, workflowBits),
      authority: join(sectionBits, authorityBits),
    } satisfies Record<SearchMode, string>;

    const compactByMode = {
      keyword: compact(textByMode.keyword),
      chapter: compact(textByMode.chapter),
      section: compact(textByMode.section),
      rule: compact(textByMode.rule),
      workflow: compact(textByMode.workflow),
      authority: compact(textByMode.authority),
    } satisfies Record<SearchMode, string>;

    const textBySuggestion = {
      IEC: join(sectionBits, ruleBits, authorityBits, keywords, ["iec importer exporter pan"]),
      Rule: join(sectionBits, ruleBits),
      Chapter: join(chapterBits, [section.id, section.title]),
      Section: join(sectionBits, [section.chapterTitle]),
      "HS Code": join(hsCodeBits, sectionBits),
      Import: join(importBits, chapterBits),
      Export: join(exportBits, chapterBits),
    } satisfies Record<SearchSuggestion, string>;

    const compactBySuggestion = {
      IEC: compact(textBySuggestion.IEC),
      Rule: compact(textBySuggestion.Rule),
      Chapter: compact(textBySuggestion.Chapter),
      Section: compact(textBySuggestion.Section),
      "HS Code": compact(textBySuggestion["HS Code"]),
      Import: compact(textBySuggestion.Import),
      Export: compact(textBySuggestion.Export),
    } satisfies Record<SearchSuggestion, string>;

    const modeLabels = searchModes.filter((mode) =>
      mode === "keyword" ? false : textByMode[mode].trim().length > join([section.id, section.title, section.summary]).trim().length,
    );

    return {
      chapterBadge: `Chapter ${section.chapterNumber}`,
      chapterNumber: section.chapterNumber,
      chapterTitle: section.chapterTitle,
      compactByMode,
      compactBySuggestion,
      documentName: section.documentName,
      modeLabels,
      preview: trimPreview(section.businessMeaning || section.summary || section.purpose || section.title),
      sectionId: section.id,
      sectionTitle: section.title,
      textByMode,
      textBySuggestion,
    };
  });
};

const scoreSurface = (haystack: string, compactHaystack: string, query: string, tokens: string[], compactQuery: string) => {
  const phraseMatch = haystack.includes(query);
  const compactMatch = compactQuery.length > 1 && compactHaystack.includes(compactQuery);
  const matchingTokens = unique(tokens.filter((token) => haystack.includes(token) || compactHaystack.includes(token.replace(/\s+/g, ""))));

  return {
    compactMatch,
    matchingTokens,
    phraseMatch,
  };
};

const scoreEntry = (entry: IndexedSection, mode: SearchMode, suggestion: SearchSuggestion | null, query: string, tokens: string[], compactQuery: string) => {
  const modeSurface = scoreSurface(normalize(entry.textByMode[mode]), entry.compactByMode[mode], query, tokens, compactQuery);
  const suggestionSurface = suggestion
    ? scoreSurface(normalize(entry.textBySuggestion[suggestion]), entry.compactBySuggestion[suggestion], query, tokens, compactQuery)
    : null;
  const sectionLabel = normalize(`${entry.sectionId} ${entry.sectionTitle}`);
  const chapterLabel = normalize(`${entry.chapterBadge} ${entry.chapterTitle}`);
  const matchingTokens = unique([...(modeSurface.matchingTokens ?? []), ...(suggestionSurface?.matchingTokens ?? [])]);

  if (
    !modeSurface.phraseMatch &&
    !modeSurface.compactMatch &&
    !suggestionSurface?.phraseMatch &&
    !suggestionSurface?.compactMatch &&
    matchingTokens.length === 0
  ) {
    return null;
  }

  let score = 0;
  if (modeSurface.phraseMatch) {
    score += 120;
  }
  if (modeSurface.compactMatch) {
    score += 70;
  }
  if (suggestionSurface?.phraseMatch) {
    score += 90;
  }
  if (suggestionSurface?.compactMatch) {
    score += 55;
  }
  if (normalize(entry.sectionId) === query) {
    score += 160;
  } else if (normalize(entry.sectionId).startsWith(query)) {
    score += 120;
  }
  if (normalize(entry.chapterNumber) === query || normalize(entry.chapterBadge) === query) {
    score += 110;
  }

  for (const token of matchingTokens) {
    if (sectionLabel.includes(token)) {
      score += 28;
      continue;
    }
    if (chapterLabel.includes(token)) {
      score += mode === "chapter" ? 24 : 16;
      continue;
    }
    score += 10;
  }

  if (mode !== "keyword" && entry.modeLabels.includes(mode)) {
    score += 12;
  }
  if (suggestion) {
    score += 14;
  }

  return {
    chapterBadge: entry.chapterBadge,
    chapterNumber: entry.chapterNumber,
    chapterTitle: entry.chapterTitle,
    documentName: entry.documentName,
    matchLabel: mode === "keyword" ? "Best match" : mode[0].toUpperCase() + mode.slice(1),
    preview: entry.preview,
    score,
    sectionId: entry.sectionId,
    sectionTitle: entry.sectionTitle,
  } satisfies SearchResultCard;
};

const runSearch = (index: IndexedSection[], query: string, mode: SearchMode, suggestion: SearchSuggestion | null) => {
  const normalizedQuery = normalize(query);
  if (!normalizedQuery) {
    return [];
  }

  const compactQuery = compact(query);
  const tokens = tokenize(query);

  return index
    .map((entry) => scoreEntry(entry, mode, suggestion, normalizedQuery, tokens, compactQuery))
    .filter((entry): entry is SearchResultCard => entry !== null)
    .sort((left, right) => right.score - left.score || left.chapterNumber.localeCompare(right.chapterNumber) || left.sectionId.localeCompare(right.sectionId))
    .slice(0, 40);
};

const getModeLabel = (mode: SearchMode) => mode[0].toUpperCase() + mode.slice(1);
const getModeForSuggestion = (suggestion: SearchSuggestion | null) => (suggestion ? suggestionModeMap[suggestion] : "keyword");
const getFilterLabel = (filter: SearchFilter | null) => (filter ? filter : "");
const resolveFilterSelection = (filter: SearchFilter | null, fallbackMode: SearchMode) => {
  if (filter && isSearchSuggestion(filter)) {
    return {
      mode: getModeForSuggestion(filter),
      topic: filter,
    };
  }

  if (filter && isSearchMode(filter)) {
    return {
      mode: filter,
      topic: null,
    };
  }

  return {
    mode: fallbackMode,
    topic: null,
  };
};
const getFilterFromParams = (params: URLSearchParams): SearchFilter | null => {
  const topic = params.get(TOPIC_PARAM);
  if (isSearchSuggestion(topic)) {
    return topic;
  }

  const mode = params.get("mode");
  if (isSearchMode(mode) && mode !== "keyword") {
    return mode;
  }

  return null;
};

export function SearchPage() {
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();
  const { t } = usePreferences();
  const { data, error, isLoading } = useKnowledgeBase();
  const inputRef = useRef<HTMLInputElement | null>(null);
  const [draftQuery, setDraftQuery] = useState(searchParams.get("q") ?? "");
  const [activeQuery, setActiveQuery] = useState(searchParams.get("q") ?? "");
  const [prefilledFromFilter, setPrefilledFromFilter] = useState(false);
  const [activeFilter, setActiveFilter] = useState<SearchFilter | null>(() => getFilterFromParams(searchParams));
  const [topic, setTopic] = useState<SearchSuggestion | null>(() => {
    const candidate = searchParams.get(TOPIC_PARAM);
    return isSearchSuggestion(candidate) ? candidate : null;
  });
  const [mode, setMode] = useState<SearchMode>(() => {
    const candidate = searchParams.get("mode");
    return isSearchMode(candidate) ? candidate : "keyword";
  });

  const deferredQuery = useDeferredValue(activeQuery);
  const deferredMode = useDeferredValue(mode);
  const deferredTopic = useDeferredValue(topic);

  useEffect(() => {
    const nextQuery = searchParams.get("q") ?? "";
    const nextTopic = searchParams.get(TOPIC_PARAM);
    const nextMode = searchModes.includes(searchParams.get("mode") as SearchMode)
      ? (searchParams.get("mode") as SearchMode)
      : "keyword";

    if (nextQuery !== draftQuery) {
      setDraftQuery(nextQuery);
    }
    if (nextQuery !== activeQuery) {
      setActiveQuery(nextQuery);
    }
    const resolvedFilter = getFilterFromParams(searchParams);
    if (resolvedFilter !== activeFilter) {
      setActiveFilter(resolvedFilter);
    }
    const resolvedTopic = isSearchSuggestion(nextTopic) ? nextTopic : null;
    if (resolvedTopic !== topic) {
      setTopic(resolvedTopic);
    }
    const resolvedMode = resolvedTopic ? getModeForSuggestion(resolvedTopic) : nextMode;
    if (resolvedMode !== mode) {
      setMode(resolvedMode);
    }
    if (nextQuery.trim().length > 0) {
      setPrefilledFromFilter(false);
    }
  }, [searchParams]);

  const knowledgeBase = useMemo(() => data ?? null, [data]);
  const sectionIndex = useMemo(() => (knowledgeBase ? buildSectionIndex(knowledgeBase) : []), [knowledgeBase]);
  const results = useMemo(() => runSearch(sectionIndex, deferredQuery, deferredMode, deferredTopic), [deferredMode, deferredQuery, deferredTopic, sectionIndex]);

  const syncSearchParams = (nextQuery: string, nextMode: SearchMode, nextTopic: SearchSuggestion | null) => {
    const normalizedQuery = nextQuery.replace(/\s+/g, " ").trim();
    const next = new URLSearchParams(searchParams);

    if (normalizedQuery) {
      next.set("q", normalizedQuery);
    } else {
      next.delete("q");
    }

    if (nextMode === "keyword") {
      next.delete("mode");
    } else {
      next.set("mode", nextMode);
    }

    if (nextTopic) {
      next.set(TOPIC_PARAM, nextTopic);
    } else {
      next.delete(TOPIC_PARAM);
    }

    const currentSerialized = searchParams.toString();
    const nextSerialized = next.toString();
    if (currentSerialized !== nextSerialized) {
      setSearchParams(next, { replace: true });
    }
  };

  const commitSearch = (nextQuery: string, nextMode: SearchMode, nextTopic: SearchSuggestion | null) => {
    const normalizedQuery = nextQuery.replace(/\s+/g, " ").trim();
    setDraftQuery(nextQuery);
    setActiveQuery(normalizedQuery);
    setMode(nextMode);
    setTopic(nextTopic);
    syncSearchParams(normalizedQuery, nextMode, nextTopic);
  };

  const submitSearch = () => {
    const selection = resolveFilterSelection(activeFilter, mode);
    commitSearch(draftQuery, selection.mode, selection.topic);
  };

  const handleDraftChange = (value: string) => {
    setPrefilledFromFilter(false);
    setDraftQuery(value);
  };

  const handleFilterSelect = (nextFilter: SearchFilter) => {
    setActiveFilter(nextFilter);
    setDraftQuery(getFilterLabel(nextFilter));
    setPrefilledFromFilter(true);

    window.requestAnimationFrame(() => {
      const input = inputRef.current;
      if (!input) {
        return;
      }

      input.focus();
      input.setSelectionRange(0, input.value.length);
    });
  };

  return (
    <PageMotion className="mx-auto max-w-6xl space-y-6">
      <Panel className="space-y-6 p-6 sm:p-8">
        <div className="flex items-start justify-between gap-4">
          <PageBackButton />
        </div>

        <div className="mx-auto max-w-4xl text-center">
          <p className="text-sm font-semibold uppercase tracking-[0.22em] text-[var(--accent)]">{t("common.search")}</p>
          <h1 className="mt-3 text-3xl font-semibold tracking-tight text-[var(--foreground)] sm:text-4xl">
            {t("search.title")}
          </h1>
          <p className="mt-3 text-sm leading-7 text-[var(--muted-foreground)] sm:text-base">
            {t("search.subtitle")}
          </p>
        </div>

        <form
          className="mx-auto flex max-w-4xl flex-col gap-3 sm:flex-row"
          onSubmit={(event) => {
            event.preventDefault();
            submitSearch();
          }}
        >
          <label className="relative block flex-1">
            <Search className="pointer-events-none absolute left-5 top-1/2 h-5 w-5 -translate-y-1/2 text-[var(--muted-foreground)]" />
            <input
              className="field h-16 rounded-[1.75rem] pl-14 pr-5 text-base"
              onChange={(event) => handleDraftChange(event.target.value)}
              onFocus={(event) => {
                if (prefilledFromFilter) {
                  event.target.select();
                }
              }}
              placeholder={activeFilter ? getFilterLabel(activeFilter) : t("search.placeholder")}
              ref={inputRef}
              value={draftQuery}
            />
          </label>

          <Button className="h-16 rounded-[1.75rem] px-6" type="submit" variant="secondary">
            <Search className="h-4 w-4" />
            {t("common.search")}
          </Button>
        </form>

        <div className="flex flex-wrap justify-center gap-2">
          {searchSuggestions.map((item) => (
            <button
              key={item}
              className={chipClassName(activeFilter === item)}
              onClick={() => handleFilterSelect(item)}
              type="button"
            >
              {item}
            </button>
          ))}
        </div>

        <div className="flex flex-wrap justify-center gap-2">
          {searchModes.map((item) => (
            <button
              key={item}
              className={chipClassName(activeFilter === item)}
              onClick={() => handleFilterSelect(item)}
              type="button"
            >
              {item}
            </button>
          ))}
        </div>
      </Panel>

      {isLoading && !knowledgeBase ? (
        <Panel className="animate-pulse p-8">
          <div className="h-6 w-48 rounded-full bg-[var(--panel-subtle)]" />
          <div className="mt-6 h-64 rounded-[1.5rem] bg-[var(--panel-subtle)]" />
        </Panel>
      ) : error && !knowledgeBase ? (
        <Panel className="space-y-2 p-8 text-sm text-[var(--muted-foreground)]">
          <p className="font-medium text-[var(--foreground)]">Search is unavailable right now.</p>
          <p>The knowledge base could not be loaded. Refresh the page and try again.</p>
        </Panel>
      ) : (
        <div className="grid gap-4">
          {activeQuery ? (
            results.length > 0 ? (
              <>
                <div className="flex items-center justify-between px-2">
                  <p className="text-sm text-[var(--muted-foreground)]">
                    {results.length} results for <span className="font-semibold text-[var(--foreground)]">{activeQuery}</span>
                  </p>
                  <div className="flex flex-wrap items-center justify-end gap-2">
                    {topic ? <Badge tone="success">{topic}</Badge> : null}
                    {!topic || getModeLabel(mode) !== topic ? <Badge tone="info">{getModeLabel(mode)}</Badge> : null}
                  </div>
                </div>

                {results.map((result) => (
                  <Panel key={`${result.sectionId}-${result.matchLabel}`} className="space-y-4 p-5 sm:p-6">
                    <div className="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                      <div>
                        <div className="flex flex-wrap items-center gap-2">
                          <Badge tone="info">{result.matchLabel}</Badge>
                          <span className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">
                            {result.chapterBadge}
                          </span>
                        </div>

                        <h2 className="mt-3 text-xl font-semibold text-[var(--foreground)]">
                          {result.sectionId} {result.sectionTitle}
                        </h2>

                        <p className="mt-3 max-w-3xl text-sm leading-7 text-[var(--muted-foreground)]">{result.preview}</p>

                        <div className="mt-4 flex flex-wrap items-center gap-3 text-xs font-medium text-[var(--muted-foreground)]">
                          <span>{result.chapterTitle}</span>
                          <span>{result.documentName}</span>
                        </div>
                      </div>

                      <Button
                        onClick={() =>
                          navigate(
                            `/knowledge-base?chapter=${encodeURIComponent(result.chapterNumber)}&section=${encodeURIComponent(result.sectionId)}`,
                          )
                        }
                        type="button"
                        variant="secondary"
                      >
                        {t("common.openSection")}
                        <ArrowRight className="h-4 w-4" />
                      </Button>
                    </div>
                  </Panel>
                ))}
              </>
            ) : (
              <Panel className="space-y-2 p-8 text-sm text-[var(--muted-foreground)]">
                <p className="font-medium text-[var(--foreground)]">No matching results found.</p>
                <p>Try another keyword, section number, chapter, or HS Code.</p>
              </Panel>
            )
          ) : (
            <Panel className="p-8 text-sm text-[var(--muted-foreground)]">
              Start typing to search the Knowledge Base.
            </Panel>
          )}
        </div>
      )}
    </PageMotion>
  );
}
