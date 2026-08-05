import { useMutation, useQueryClient } from "@tanstack/react-query";
import { ArrowUpRight, BrainCircuit, DatabaseZap, FileCog, SearchCheck, Upload } from "lucide-react";
import { useDeferredValue, useEffect, useMemo, useRef, useState, type DragEvent, type ReactNode } from "react";
import { useSearchParams } from "react-router-dom";
import { documentsApi } from "../api/documents";
import { PageBackButton, useAppBack } from "../components/navigation";
import { Badge, Button, PageMotion, Panel, ProgressBar, useToast } from "../components/ui";
import { useDocuments } from "../hooks/use-documents";
import { usePreferences } from "../lib/preferences";
import { formatDateTime, formatFullNumber } from "../lib/utils";
import { activeDocumentStorage } from "../services/active-document";
import type { DocumentRecord, DocumentsKnowledgeStats, DocumentsResponse } from "../types/api";
import { PipelineVisual, statusTone } from "./dekai-ui";

const fullKnowledgePipeline = [
  "Validate File",
  "Extract Text",
  "Convert to Markdown",
  "Identify Sections",
  "Generate Chunks",
  "Create Embeddings",
  "Index into Knowledge Base",
  "Ready",
];

function formatKnowledgeSize(value: number | undefined) {
  const sizeKb = Math.max(0, value ?? 0);
  if (sizeKb < 1024) {
    return `${formatFullNumber(sizeKb)} KB`;
  }
  const sizeMb = sizeKb / 1024;
  return `${sizeMb >= 10 ? sizeMb.toFixed(0) : sizeMb.toFixed(1)} MB`;
}

function formatIndexedTime(value: string | null | undefined) {
  return value ? formatDateTime(value) : "Not indexed yet";
}

function getDocumentScopeLabel(scope: DocumentRecord["knowledgeScope"] | DocumentsKnowledgeStats["scope"] | undefined) {
  if (scope === "single-document-index") {
    return "Single-document index";
  }
  return "Shared knowledge base";
}

function getKnowledgeStatusLabel(document: DocumentRecord) {
  if (document.knowledgeStatus === "knowledge-ready" || document.status === "ready") {
    return "Knowledge Ready";
  }
  if (document.knowledgeStatus === "action-required" || document.status === "failed") {
    return "Action required";
  }
  return "Processing knowledge";
}

function getSearchIndexLabel(status: DocumentRecord["searchIndexStatus"] | DocumentsKnowledgeStats["searchIndexStatus"] | undefined) {
  if (status === "indexed") return "Indexed";
  if (status === "attention-required") return "Needs attention";
  if (status === "failed") return "Failed";
  if (status === "idle") return "Idle";
  return "Updating";
}

function getVectorDatabaseLabel(status: DocumentRecord["vectorDatabaseStatus"] | undefined) {
  if (status === "stored") return "Stored";
  if (status === "failed") return "Failed";
  return "Updating";
}

function getPrimaryActionLabel(document: DocumentRecord) {
  return document.status === "failed" ? "Retry Processing" : "Re-index";
}

function getSecondaryActionLabel(document: DocumentRecord) {
  return document.status === "failed" ? "Re-upload Document" : "Replace";
}

function getStatusBadgeTone(status?: string): "success" | "warning" | "danger" | "info" | "default" {
  if (status === "indexed" || status === "stored") return "success";
  if (status === "attention-required" || status === "failed") return "danger";
  if (status === "idle") return "default";
  return "warning";
}

function toExecutionStages(document: DocumentRecord) {
  const stages = document.stages ?? [];
  const activeIndex = stages.findIndex((stage) => stage.state === "current");
  const firstUpcomingIndex = stages.findIndex((stage) => stage.state === "upcoming");
  const failedIndex = activeIndex >= 0 ? activeIndex : Math.max(0, firstUpcomingIndex - 1);

  return stages.map((stage, index) => ({
    label: stage.label,
    state:
      document.status === "failed" && index === failedIndex && stage.state !== "complete"
        ? ("failed" as const)
        : stage.state,
  }));
}

function buildFallbackKnowledgeStats(documents: DocumentRecord[]): DocumentsKnowledgeStats {
  const readyDocuments = documents.filter((document) => document.status === "ready").length;
  const failedDocuments = documents.filter((document) => document.status === "failed").length;
  const processingDocuments = documents.filter((document) => document.status === "processing").length;

  return {
    scope: documents.length > 1 ? "shared-knowledge-base" : "single-document-index",
    documentsInKnowledgeBase: documents.length,
    knowledgeReadyDocuments: readyDocuments,
    pagesProcessed: documents.reduce((total, document) => total + (document.pages ?? 0), 0),
    chunksCreated: documents.reduce((total, document) => total + (document.totalChunks ?? 0), 0),
    sectionsIndexed: documents.reduce((total, document) => total + (document.sectionsIndexed ?? document.sections ?? 0), 0),
    businessRulesExtracted: documents.reduce((total, document) => total + (document.businessRulesExtracted ?? document.rules ?? 0), 0),
    conditionsExtracted: documents.reduce((total, document) => total + (document.conditionsExtracted ?? document.conditions ?? 0), 0),
    metadataObjects: documents.reduce((total, document) => total + (document.metadataGenerated ?? 0), 0),
    embeddingsCreated: documents.reduce((total, document) => total + (document.totalEmbeddings ?? 0), 0),
    vectorRecordsStored: documents.reduce((total, document) => total + (document.vectorRecordsStored ?? 0), 0),
    knowledgeSizeKb: documents.reduce((total, document) => total + (document.knowledgeSizeKb ?? document.sizeKb ?? 0), 0),
    searchIndexStatus: processingDocuments > 0 ? "updating" : failedDocuments > 0 ? "attention-required" : readyDocuments > 0 ? "indexed" : "idle",
    knowledgeReady: documents.length > 0 && readyDocuments === documents.length,
    lastIndexedAt: documents
      .map((document) => document.lastIndexedAt ?? document.lastUpdated)
      .filter(Boolean)
      .sort()
      .at(-1) ?? null,
  };
}

function DocumentDetailField({ label, value }: { label: string; value: ReactNode }) {
  return (
    <div className="rounded-[1.4rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
      <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{label}</p>
      <div className="mt-2 text-sm font-medium text-[var(--foreground)]">{value}</div>
    </div>
  );
}

function SummaryMetricCard({
  icon,
  label,
  value,
  helper,
}: {
  icon: ReactNode;
  label: string;
  value: string;
  helper?: string;
}) {
  return (
    <div className="rounded-[1.6rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
      <div className="flex items-start justify-between gap-3">
        <div>
          <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{label}</p>
          <p className="mt-2 text-2xl font-semibold tracking-tight text-[var(--foreground)]">{value}</p>
          {helper ? <p className="mt-2 text-sm text-[var(--muted-foreground)]">{helper}</p> : null}
        </div>
        <div className="flex h-11 w-11 items-center justify-center rounded-[1rem] bg-[var(--panel)] text-[var(--accent)]">{icon}</div>
      </div>
    </div>
  );
}

function DocumentTable({
  documents,
  onDelete,
  onView,
  onReindex,
  onReplace,
  onSelect,
  selectedId,
  t,
  translateStatus,
}: {
  documents: DocumentRecord[];
  onDelete: (document: DocumentRecord) => void;
  onView: (document: DocumentRecord) => void;
  onReindex: (document: DocumentRecord) => void;
  onReplace: (document: DocumentRecord) => void;
  onSelect: (document: DocumentRecord) => void;
  selectedId?: string;
  t: (key: any, params?: Record<string, string | number>) => string;
  translateStatus: (value: string) => string;
}) {
  const columns = [
    { key: "documentName", label: t("documents.documentName"), className: "w-[34%]" },
    { key: "knowledgeScope", label: "Knowledge Scope", className: "w-[16%]" },
    { key: "processingStatus", label: "Processing Status", className: "w-[14%]" },
    { key: "knowledgeStatus", label: t("documents.knowledgeStatus"), className: "w-[18%]" },
    { key: "progress", label: "Progress", className: "w-[18%]" },
    { key: "sectionsIndexed", label: "Sections Indexed", className: "hidden 2xl:table-cell 2xl:w-[8%]" },
    { key: "chunks", label: "Chunks", className: "hidden 2xl:table-cell 2xl:w-[7%]" },
    { key: "embeddings", label: "Embeddings", className: "hidden 2xl:table-cell 2xl:w-[8%]" },
    { key: "lastIndexed", label: "Last Indexed", className: "hidden 2xl:table-cell 2xl:w-[11%]" },
    { key: "actions", label: t("common.actions"), className: "hidden 2xl:table-cell 2xl:w-[18%]" },
  ] as const;

  return (
    <div className="overflow-hidden rounded-[2rem] border border-[var(--border)] bg-[var(--panel)]">
      <div className="overflow-hidden">
        <table className="w-full table-fixed border-collapse">
          <thead className="bg-[var(--panel-subtle)]">
            <tr>
              {columns.map((column) => (
                <th
                  className={`px-4 py-4 text-left text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)] ${column.className}`}
                  key={column.key}
                >
                  {column.label}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {documents.length === 0 ? (
              <tr>
                <td className="border-t border-[var(--border)] px-4 py-8 text-sm text-[var(--muted-foreground)]" colSpan={10}>
                  No documents match the current filter.
                </td>
              </tr>
            ) : null}
            {documents.map((document) => (
              <tr
                key={document.id}
                className={selectedId === document.id ? "bg-[var(--panel-strong)]" : "bg-[var(--panel)] hover:bg-[var(--panel-subtle)]"}
              >
                <td className="border-t border-[var(--border)] px-4 py-4">
                  <button className="block min-w-0 text-left" onClick={() => onSelect(document)} type="button">
                    <p className="truncate text-sm font-semibold text-[var(--foreground)]">{document.name}</p>
                    <p className="mt-1 truncate text-xs text-[var(--muted-foreground)]">
                      {document.status === "failed" ? document.failureReason || document.failureDetail || "Processing failed" : document.chapterTitle}
                    </p>
                  </button>
                </td>
                <td className="border-t border-[var(--border)] px-4 py-4 text-sm text-[var(--muted-foreground)]">
                  <span className="block break-words">{getDocumentScopeLabel(document.knowledgeScope)}</span>
                </td>
                <td className="border-t border-[var(--border)] px-4 py-4">
                  <Badge tone={statusTone(document.status)}>{translateStatus(document.status)}</Badge>
                </td>
                <td className="border-t border-[var(--border)] px-4 py-4">
                  <Badge tone={getStatusBadgeTone(document.knowledgeStatus)}>{getKnowledgeStatusLabel(document)}</Badge>
                </td>
                <td className="border-t border-[var(--border)] px-4 py-4">
                  <div className="min-w-0">
                    <ProgressBar value={document.progress} />
                  </div>
                </td>
                <td className="hidden border-t border-[var(--border)] px-4 py-4 text-sm text-[var(--muted-foreground)] 2xl:table-cell">
                  {formatFullNumber(document.sectionsIndexed ?? document.sections)}
                </td>
                <td className="hidden border-t border-[var(--border)] px-4 py-4 text-sm text-[var(--muted-foreground)] 2xl:table-cell">
                  {formatFullNumber(document.totalChunks ?? 0)}
                </td>
                <td className="hidden border-t border-[var(--border)] px-4 py-4 text-sm text-[var(--muted-foreground)] 2xl:table-cell">
                  {formatFullNumber(document.totalEmbeddings ?? 0)}
                </td>
                <td className="hidden border-t border-[var(--border)] px-4 py-4 text-sm text-[var(--muted-foreground)] 2xl:table-cell">
                  {formatIndexedTime(document.lastIndexedAt)}
                </td>
                <td className="hidden border-t border-[var(--border)] px-4 py-4 2xl:table-cell">
                  <div className="flex flex-wrap gap-2">
                    <Button onClick={() => onView(document)} size="sm" type="button" variant="secondary">
                      {t("common.view")}
                    </Button>
                    <Button onClick={() => onReplace(document)} size="sm" type="button" variant="ghost">
                      {getSecondaryActionLabel(document)}
                    </Button>
                    <Button onClick={() => onReindex(document)} size="sm" type="button" variant="ghost">
                      {getPrimaryActionLabel(document)}
                    </Button>
                    <Button onClick={() => onDelete(document)} size="sm" type="button" variant="ghost">
                      {t("common.delete")}
                    </Button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export function DocumentsPage() {
  const queryClient = useQueryClient();
  const { data, isLoading } = useDocuments();
  const { pushToast } = useToast();
  const { t, translateStatus } = usePreferences();
  const [searchParams, setSearchParams] = useSearchParams();
  const selectionHistoryModeRef = useRef<"replace" | "push">("replace");
  useAppBack();
  const fileInputRef = useRef<HTMLInputElement | null>(null);
  const [dragActive, setDragActive] = useState(false);
  const [selectedId, setSelectedId] = useState(searchParams.get("document") ?? "");
  const [search, setSearch] = useState(searchParams.get("q") ?? "");
  const deferredSearch = useDeferredValue(search);

  useEffect(() => {
    const nextSearch = searchParams.get("q") ?? "";
    const nextDocument = searchParams.get("document") ?? "";
    if (nextSearch !== search) {
      setSearch(nextSearch);
    }
    if (nextDocument !== selectedId) {
      setSelectedId(nextDocument);
    }
  }, [searchParams, search, selectedId]);

  useEffect(() => {
    const next = new URLSearchParams(searchParams);
    const normalizedSearch = search.trim();

    if (normalizedSearch) {
      next.set("q", normalizedSearch);
    } else {
      next.delete("q");
    }

    if (selectedId) {
      next.set("document", selectedId);
    } else {
      next.delete("document");
    }

    const currentSerialized = searchParams.toString();
    const nextSerialized = next.toString();
    if (currentSerialized !== nextSerialized) {
      const replace = selectionHistoryModeRef.current !== "push";
      selectionHistoryModeRef.current = "replace";
      setSearchParams(next, { replace });
    }
  }, [search, searchParams, selectedId, setSearchParams]);

  const uploadMutation = useMutation({
    mutationFn: (files: File[]) => documentsApi.upload(files),
    onSuccess: (_data, files) => {
      void queryClient.invalidateQueries({ queryKey: ["documents"] });
      void queryClient.invalidateQueries({ queryKey: ["overview"] });
      void queryClient.invalidateQueries({ queryKey: ["knowledge-base"] });
      pushToast({
        title: files.length > 1 ? t("documents.batchUploadStarted") : t("documents.uploadStarted"),
        description:
          files.length > 1
            ? t("documents.batchUploadStartedDescription", { count: files.length })
            : t("documents.uploadStartedDescription"),
        tone: "info",
      });
    },
    onError: (error) => {
      const message = error instanceof Error ? error.message : t("documents.uploadFailed");
      pushToast({ title: t("documents.uploadFailed"), description: message, tone: "warning" });
    },
  });

  const deleteMutation = useMutation({
    mutationFn: (documentId: string) => documentsApi.delete(documentId),
    onSuccess: async (_data, documentId) => {
      setSelectedId((current) => (current === documentId ? "" : current));
      queryClient.setQueryData<DocumentsResponse | undefined>(["documents"], (current) =>
        current
          ? {
              ...current,
              documents: current.documents.filter((document) => document.id !== documentId),
            }
          : current,
      );
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: ["documents"] }),
        queryClient.invalidateQueries({ queryKey: ["overview"] }),
        queryClient.invalidateQueries({ queryKey: ["knowledge-base"] }),
      ]);
      pushToast({ title: t("documents.documentDeleted"), description: t("documents.documentDeletedDescription"), tone: "info" });
    },
    onError: (error) => {
      const message = error instanceof Error ? error.message : t("documents.deleteFailed");
      pushToast({ title: t("documents.deleteFailed"), description: message, tone: "warning" });
    },
  });

  const replaceMutation = useMutation({
    mutationFn: ({ documentId, file }: { documentId: string; file: File }) => documentsApi.replace(documentId, file),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["documents"] });
      void queryClient.invalidateQueries({ queryKey: ["overview"] });
      void queryClient.invalidateQueries({ queryKey: ["knowledge-base"] });
      pushToast({ title: t("documents.replacementStarted"), description: t("documents.replacementStartedDescription"), tone: "info" });
    },
    onError: (error) => {
      const message = error instanceof Error ? error.message : t("documents.replacementFailed");
      pushToast({ title: t("documents.replacementFailed"), description: message, tone: "warning" });
    },
  });

  const reindexMutation = useMutation({
    mutationFn: (documentId: string) => documentsApi.reindex(documentId),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["documents"] });
      void queryClient.invalidateQueries({ queryKey: ["overview"] });
      void queryClient.invalidateQueries({ queryKey: ["knowledge-base"] });
      pushToast({ title: t("documents.reindexStarted"), description: t("documents.reindexStartedDescription"), tone: "info" });
    },
    onError: (error) => {
      const message = error instanceof Error ? error.message : t("documents.reindexFailed");
      pushToast({ title: t("documents.reindexFailed"), description: message, tone: "warning" });
    },
  });

  const documents = useMemo(() => data?.documents ?? [], [data?.documents]);
  const knowledgeStats = useMemo(() => data?.knowledgeStats ?? buildFallbackKnowledgeStats(documents), [data?.knowledgeStats, documents]);
  const filteredDocuments = useMemo(() => {
    const query = deferredSearch.trim().toLowerCase();
    if (!query) return documents;
    return documents.filter((document) =>
      `${document.name} ${document.chapterTitle} ${document.summary} ${document.documentType ?? ""}`.toLowerCase().includes(query),
    );
  }, [deferredSearch, documents]);

  const selectedDocument = useMemo(() => {
    if (selectedId) {
      return filteredDocuments.find((document) => document.id === selectedId) ?? documents.find((document) => document.id === selectedId) ?? null;
    }
    return filteredDocuments[0] ?? documents[0] ?? null;
  }, [documents, filteredDocuments, selectedId]);

  useEffect(() => {
    if (!selectedDocument) {
      return;
    }
    activeDocumentStorage.set({ id: selectedDocument.id, name: selectedDocument.name });
  }, [selectedDocument]);

  const selectedPipeline = useMemo(() => (selectedDocument ? toExecutionStages(selectedDocument) : []), [selectedDocument]);

  const handleUpload = (files: FileList | null) => {
    const nextFiles = Array.from(files ?? []).filter((file) => file.name.toLowerCase().endsWith(".pdf"));
    if (nextFiles.length === 0) return;
    uploadMutation.mutate(nextFiles);
  };

  const handleViewDocument = async (document: DocumentRecord) => {
    selectionHistoryModeRef.current = "push";
    setSelectedId(document.id);
    activeDocumentStorage.set({ id: document.id, name: document.name });

    const previewWindow = window.open("", "_blank");
    if (!previewWindow) {
      pushToast({
        title: "Failed to load document",
        description: "The PDF preview was blocked by the browser. Please allow pop-ups and try again.",
        tone: "warning",
      });
      return;
    }

    previewWindow.document.title = document.name;
    previewWindow.document.body.innerHTML =
      "<div style=\"font-family:system-ui,-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;padding:24px;color:#0f172a;background:#f8fafc;\">Loading PDF preview...</div>";

    try {
      const blob = await documentsApi.getFile(document.id);
      if (!blob || blob.size === 0) {
        throw new Error("File is unavailable.");
      }
      const pdfBlob = blob.type === "application/pdf" ? blob : new Blob([blob], { type: "application/pdf" });
      const previewUrl = URL.createObjectURL(pdfBlob);
      previewWindow.location.replace(previewUrl);
    } catch (error) {
      previewWindow.close();
      const message = error instanceof Error ? error.message : "Failed to load document. Please try again.";
      pushToast({
        title: message === "Document not found." || message === "File is unavailable." ? message : "Failed to load document",
        description: message === "Document not found." || message === "File is unavailable." ? "Please try again." : message,
        tone: "warning",
      });
    }
  };

  const onDrop = (event: DragEvent<HTMLDivElement>) => {
    event.preventDefault();
    setDragActive(false);
    handleUpload(event.dataTransfer.files);
  };

  if (isLoading) {
    return (
      <PageMotion className="space-y-4">
        <Panel className="animate-pulse p-8">
          <div className="h-6 w-48 rounded-full bg-[var(--panel-subtle)]" />
          <div className="mt-6 h-56 rounded-[1.5rem] bg-[var(--panel-subtle)]" />
        </Panel>
      </PageMotion>
    );
  }

  return (
    <PageMotion className="space-y-6">
      <input
        accept=".pdf"
        className="hidden"
        onChange={(event) => {
          handleUpload(event.target.files);
          event.target.value = "";
        }}
        multiple
        ref={fileInputRef}
        type="file"
      />

      <div className="flex items-start justify-between gap-4">
        <PageBackButton />
      </div>

      <Panel className={dragActive ? "border-[var(--accent)] bg-[var(--accent)]/6 p-8 transition" : "border-dashed p-8 transition"}>
        <div
          onDragEnter={(event) => {
            event.preventDefault();
            setDragActive(true);
          }}
          onDragLeave={(event) => {
            event.preventDefault();
            setDragActive(false);
          }}
          onDragOver={(event) => event.preventDefault()}
          onDrop={onDrop}
        >
          <div className="mx-auto flex max-w-6xl flex-col items-center text-center">
            <div className="flex h-16 w-16 items-center justify-center rounded-[1.75rem] bg-[var(--panel-subtle)] text-[var(--accent)]">
              <Upload className="h-7 w-7" />
            </div>
            <div className="mt-6 flex flex-wrap items-center justify-center gap-2">
              <Badge tone="info">{getDocumentScopeLabel(knowledgeStats.scope)}</Badge>
              <Badge tone="info">Single PDF or batch upload</Badge>
              <Badge tone="info">Incremental indexing</Badge>
            </div>
            <h1 className="mt-4 text-3xl font-semibold tracking-tight text-[var(--foreground)]">{t("documents.title")}</h1>
            <p className="mt-3 max-w-3xl text-base leading-8 text-[var(--muted-foreground)]">{t("documents.subtitle")}</p>
            <div className="mt-6 flex flex-wrap justify-center gap-3">
              <Button onClick={() => fileInputRef.current?.click()} type="button">
                {t("common.uploadPdfs")}
              </Button>
              <Button onClick={() => selectedDocument && reindexMutation.mutate(selectedDocument.id)} type="button" variant="secondary">
                {selectedDocument?.status === "failed" ? "Retry processing selected document" : "Re-index selected document"}
              </Button>
            </div>

            <div className="mt-8 grid w-full gap-3 lg:grid-cols-3">
              <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-5 text-left">
                <p className="text-sm font-semibold text-[var(--foreground)]">Processing scope</p>
                <p className="mt-2 text-sm leading-7 text-[var(--muted-foreground)]">
                  {knowledgeStats.scope === "shared-knowledge-base"
                    ? "Each PDF is processed independently and then merged into one searchable company knowledge base."
                    : "A single uploaded PDF is processed into its own searchable knowledge index."}
                </p>
              </div>
              <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-5 text-left">
                <p className="text-sm font-semibold text-[var(--foreground)]">Incremental processing</p>
                <p className="mt-2 text-sm leading-7 text-[var(--muted-foreground)]">
                  New uploads should be processed as new knowledge units. Existing ready documents remain unchanged while indexing catches up.
                </p>
              </div>
              <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-5 text-left">
                <p className="text-sm font-semibold text-[var(--foreground)]">AI retrieval contract</p>
                <p className="mt-2 text-sm leading-7 text-[var(--muted-foreground)]">
                  AI chat should retrieve only from processed chunks, vectors, and search records after the document becomes Knowledge Ready.
                </p>
              </div>
            </div>

            <div className="mt-8 w-full">
              <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">Full Knowledge Pipeline</p>
              <div className="mt-4 grid gap-3 sm:grid-cols-2 xl:grid-cols-5">
                {fullKnowledgePipeline.map((stage, index) => (
                  <div key={stage} className="rounded-[1.35rem] border border-[var(--border)] bg-[var(--panel-subtle)] px-4 py-4 text-left">
                    <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{index + 1}</p>
                    <p className="mt-2 text-sm font-medium text-[var(--foreground)]">{stage}</p>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      </Panel>

      <Panel className="space-y-5">
        <div className="flex flex-col gap-4 xl:flex-row xl:items-start xl:justify-between">
          <div>
            <h2 className="text-xl font-semibold text-[var(--foreground)]">Knowledge Base Summary</h2>
            <p className="mt-1 text-sm text-[var(--muted-foreground)]">
              The Documents page now reflects processing, vector storage, and search-index readiness instead of just upload completion.
            </p>
          </div>
          <div className="flex flex-wrap items-center gap-2">
            <Badge tone={getStatusBadgeTone(knowledgeStats.searchIndexStatus)}>{getSearchIndexLabel(knowledgeStats.searchIndexStatus)}</Badge>
            <Badge tone={knowledgeStats.knowledgeReady ? "success" : "warning"}>
              {knowledgeStats.knowledgeReadyDocuments}/{knowledgeStats.documentsInKnowledgeBase} Knowledge Ready
            </Badge>
            <Badge tone="info">{getDocumentScopeLabel(knowledgeStats.scope)}</Badge>
          </div>
        </div>

        <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
          <SummaryMetricCard
            helper="Total document pages processed into the knowledge pipeline."
            icon={<FileCog className="h-5 w-5" />}
            label="Pages Processed"
            value={formatFullNumber(knowledgeStats.pagesProcessed)}
          />
          <SummaryMetricCard
            helper="Searchable chunk records generated from uploaded PDFs."
            icon={<BrainCircuit className="h-5 w-5" />}
            label="Chunks Created"
            value={formatFullNumber(knowledgeStats.chunksCreated)}
          />
          <SummaryMetricCard
            helper="Sections that are now available for retrieval."
            icon={<SearchCheck className="h-5 w-5" />}
            label="Sections Indexed"
            value={formatFullNumber(knowledgeStats.sectionsIndexed)}
          />
          <SummaryMetricCard
            helper="Business rules and conditions extracted for grounded answers."
            icon={<ArrowUpRight className="h-5 w-5" />}
            label="Rules + Conditions"
            value={`${formatFullNumber(knowledgeStats.businessRulesExtracted)} + ${formatFullNumber(knowledgeStats.conditionsExtracted)}`}
          />
          <SummaryMetricCard
            helper="Metadata objects created from sections, rules, conditions, and supporting entities."
            icon={<FileCog className="h-5 w-5" />}
            label="Metadata Objects"
            value={formatFullNumber(knowledgeStats.metadataObjects)}
          />
          <SummaryMetricCard
            helper="Embedding vectors created for chunk and search records."
            icon={<BrainCircuit className="h-5 w-5" />}
            label="Embeddings Created"
            value={formatFullNumber(knowledgeStats.embeddingsCreated)}
          />
          <SummaryMetricCard
            helper="Vector records currently stored for retrieval."
            icon={<DatabaseZap className="h-5 w-5" />}
            label="Vector Records Stored"
            value={formatFullNumber(knowledgeStats.vectorRecordsStored)}
          />
          <SummaryMetricCard
            helper={`Last indexed: ${formatIndexedTime(knowledgeStats.lastIndexedAt)}`}
            icon={<SearchCheck className="h-5 w-5" />}
            label="Knowledge Size"
            value={formatKnowledgeSize(knowledgeStats.knowledgeSizeKb)}
          />
        </div>
      </Panel>

      <div className="grid gap-6 2xl:grid-cols-[minmax(0,1.35fr)_430px]">
        <div className="space-y-4">
          <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
            <div>
              <h2 className="text-xl font-semibold text-[var(--foreground)]">{t("documents.uploadedDocuments")}</h2>
              <p className="mt-1 text-sm text-[var(--muted-foreground)]">{t("documents.uploadedDocumentsSubtitle")}</p>
            </div>
            <input
              className="field max-w-sm"
              onChange={(event) => setSearch(event.target.value)}
              placeholder={t("documents.searchPlaceholder")}
              value={search}
            />
          </div>

          <DocumentTable
            documents={filteredDocuments}
            onDelete={(document) => deleteMutation.mutate(document.id)}
            onView={handleViewDocument}
            onReindex={(document) => reindexMutation.mutate(document.id)}
            onReplace={(document) => {
              const replacementInput = window.document.createElement("input");
              replacementInput.type = "file";
              replacementInput.accept = ".pdf";
              replacementInput.onchange = () => {
                const file = replacementInput.files?.[0];
                if (file) {
                  replaceMutation.mutate({ documentId: document.id, file });
                }
              };
              replacementInput.click();
            }}
            onSelect={(document) => {
              selectionHistoryModeRef.current = "push";
              setSelectedId(document.id);
            }}
            selectedId={selectedDocument?.id}
            t={t}
            translateStatus={translateStatus}
          />
        </div>

        <Panel className="space-y-5 2xl:sticky 2xl:top-24 2xl:self-start">
          <div className="flex items-center justify-between gap-3">
            <div>
              <p className="text-sm font-semibold text-[var(--foreground)]">{t("documents.processingProgress")}</p>
              <p className="mt-1 text-sm text-[var(--muted-foreground)]">{t("documents.processingProgressSubtitle")}</p>
            </div>
            {selectedDocument ? <Badge tone={statusTone(selectedDocument.status)}>{translateStatus(selectedDocument.status)}</Badge> : null}
          </div>

          {selectedDocument ? (
            <>
              <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-5">
                <div className="flex flex-wrap items-center gap-2">
                  <Badge tone={getStatusBadgeTone(selectedDocument.knowledgeStatus)}>{getKnowledgeStatusLabel(selectedDocument)}</Badge>
                  <Badge tone={getStatusBadgeTone(selectedDocument.searchIndexStatus)}>{getSearchIndexLabel(selectedDocument.searchIndexStatus)}</Badge>
                  <Badge tone={getStatusBadgeTone(selectedDocument.vectorDatabaseStatus)}>{getVectorDatabaseLabel(selectedDocument.vectorDatabaseStatus)}</Badge>
                </div>
                <p className="mt-4 text-base font-semibold text-[var(--foreground)]">{selectedDocument.name}</p>
                <p className="mt-2 text-sm leading-6 text-[var(--muted-foreground)]">{selectedDocument.summary}</p>
                <div className="mt-4">
                  <ProgressBar label="Processing Progress" value={selectedDocument.progress} />
                </div>
                {selectedDocument.status === "failed" ? (
                  <div className="mt-4 rounded-[1.25rem] border border-rose-500/20 bg-rose-500/8 p-4 text-sm">
                    <p className="font-semibold text-rose-700">Failure reason: {selectedDocument.failureReason || "Unexpected Server Error"}</p>
                    {selectedDocument.failureDetail ? <p className="mt-2 leading-6 text-rose-700/90">{selectedDocument.failureDetail}</p> : null}
                    <p className="mt-2 leading-6 text-rose-700/90">
                      AI chat and search will ignore this document until processing completes successfully and the document becomes Knowledge Ready.
                    </p>
                  </div>
                ) : null}
              </div>

              <div className="grid gap-3 sm:grid-cols-2">
                <DocumentDetailField label={t("documents.documentName")} value={selectedDocument.name} />
                <DocumentDetailField label={t("documents.documentType")} value={selectedDocument.documentType ?? t("documents.pdf")} />
                <DocumentDetailField label={t("documents.version")} value={selectedDocument.version} />
                <DocumentDetailField label="Total Pages" value={formatFullNumber(selectedDocument.pages)} />
                <DocumentDetailField label={t("documents.uploadDate")} value={formatDateTime(selectedDocument.uploadedAt)} />
                <DocumentDetailField label="Processing Status" value={translateStatus(selectedDocument.status)} />
                <DocumentDetailField label={t("documents.knowledgeStatus")} value={getKnowledgeStatusLabel(selectedDocument)} />
                <DocumentDetailField label="Knowledge Scope" value={getDocumentScopeLabel(selectedDocument.knowledgeScope)} />
                <DocumentDetailField label="AI Search Availability" value={selectedDocument.searchable ? "Ready" : "Blocked until Knowledge Ready"} />
                <DocumentDetailField label="Failure Reason" value={selectedDocument.failureReason ?? "Not applicable"} />
                <DocumentDetailField label="Sections Indexed" value={formatFullNumber(selectedDocument.sectionsIndexed ?? selectedDocument.sections)} />
                <DocumentDetailField label="Total Chunks" value={formatFullNumber(selectedDocument.totalChunks ?? 0)} />
                <DocumentDetailField label="Total Embeddings" value={formatFullNumber(selectedDocument.totalEmbeddings ?? 0)} />
                <DocumentDetailField label="Business Rules Extracted" value={formatFullNumber(selectedDocument.businessRulesExtracted ?? selectedDocument.rules)} />
                <DocumentDetailField label="Conditions Extracted" value={formatFullNumber(selectedDocument.conditionsExtracted ?? selectedDocument.conditions)} />
                <DocumentDetailField label="Metadata Generated" value={formatFullNumber(selectedDocument.metadataGenerated ?? 0)} />
                <DocumentDetailField label="Search Index Status" value={getSearchIndexLabel(selectedDocument.searchIndexStatus)} />
                <DocumentDetailField label="Vector Database Status" value={getVectorDatabaseLabel(selectedDocument.vectorDatabaseStatus)} />
                <DocumentDetailField label="Knowledge Size" value={formatKnowledgeSize(selectedDocument.knowledgeSizeKb ?? selectedDocument.sizeKb)} />
                <DocumentDetailField label="Last Indexed Time" value={formatIndexedTime(selectedDocument.lastIndexedAt)} />
              </div>

              <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-5">
                <div className="flex items-center justify-between gap-3">
                  <div>
                    <p className="text-sm font-semibold text-[var(--foreground)]">Backend Execution Stages</p>
                    <p className="mt-1 text-sm text-[var(--muted-foreground)]">
                      These stages show how the uploaded PDF was transformed into searchable AI knowledge.
                    </p>
                  </div>
                </div>
                <div className="mt-5">
                  <PipelineVisual stages={selectedPipeline} />
                </div>
              </div>

              <div className="flex flex-wrap gap-3">
                <Button onClick={() => reindexMutation.mutate(selectedDocument.id)} type="button" variant="secondary">
                  {getPrimaryActionLabel(selectedDocument)}
                </Button>
                <Button
                  onClick={() => {
                    const replacementInput = window.document.createElement("input");
                    replacementInput.type = "file";
                    replacementInput.accept = ".pdf";
                    replacementInput.onchange = () => {
                      const file = replacementInput.files?.[0];
                      if (file) {
                        replaceMutation.mutate({ documentId: selectedDocument.id, file });
                      }
                    };
                    replacementInput.click();
                  }}
                  type="button"
                  variant="ghost"
                >
                  {getSecondaryActionLabel(selectedDocument)}
                </Button>
              </div>
            </>
          ) : (
            <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-5 text-sm text-[var(--muted-foreground)]">
              {t("documents.selectDocument")}
            </div>
          )}
        </Panel>
      </div>
    </PageMotion>
  );
}
