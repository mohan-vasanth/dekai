import { useMutation } from "@tanstack/react-query";
import { Download, FileText, Sparkles, Upload } from "lucide-react";
import { useEffect, useRef, useState, type DragEvent } from "react";
import { useSearchParams } from "react-router-dom";
import { pdfToMarkdownApi } from "../api/pdf-to-markdown";
import { PageBackButton } from "../components/navigation";
import { Badge, Button, PageMotion, Panel, useToast } from "../components/ui";
import { usePreferences } from "../lib/preferences";
import { formatFullNumber } from "../lib/utils";
import type { PdfMarkdownConversion } from "../types/api";

const PREVIEW_PARAM = "preview";
const PREVIEW_STORAGE_PREFIX = "dekai-pdf-preview:";

type StoredPreviewState = {
  errorMessage: string;
  result: PdfMarkdownConversion | null;
  sourceFileName: string;
};

const getPreviewStorageKey = (token: string) => `${PREVIEW_STORAGE_PREFIX}${token}`;

const loadStoredPreviewState = (token: string | null): StoredPreviewState | null => {
  if (!token) {
    return null;
  }
  const raw = window.sessionStorage.getItem(getPreviewStorageKey(token));
  if (!raw) {
    return null;
  }

  try {
    const parsed = JSON.parse(raw) as Partial<StoredPreviewState>;
    return {
      errorMessage: typeof parsed.errorMessage === "string" ? parsed.errorMessage : "",
      result: parsed.result ?? null,
      sourceFileName: typeof parsed.sourceFileName === "string" ? parsed.sourceFileName : "",
    };
  } catch {
    return null;
  }
};

const persistPreviewState = (token: string, value: StoredPreviewState) => {
  window.sessionStorage.setItem(getPreviewStorageKey(token), JSON.stringify(value));
};

function triggerMarkdownDownload(content: string, fileName: string) {
  const blob = new Blob([content], { type: "text/markdown;charset=utf-8" });
  const objectUrl = window.URL.createObjectURL(blob);
  const link = window.document.createElement("a");
  link.href = objectUrl;
  link.download = fileName;
  window.document.body.appendChild(link);
  link.click();
  link.remove();
  window.setTimeout(() => window.URL.revokeObjectURL(objectUrl), 1_000);
}

async function downloadMarkdown(result: PdfMarkdownConversion) {
  if (result.content) {
    triggerMarkdownDownload(result.content, result.fileName);
    return;
  }

  throw new Error("Markdown content is unavailable for download.");
}

export function PdfToMarkdownPage() {
  const { pushToast } = useToast();
  const { t } = usePreferences();
  const [searchParams, setSearchParams] = useSearchParams();
  const fileInputRef = useRef<HTMLInputElement | null>(null);
  const [dragActive, setDragActive] = useState(false);
  const [result, setResult] = useState<PdfMarkdownConversion | null>(null);
  const [errorMessage, setErrorMessage] = useState("");
  const [sourceFileName, setSourceFileName] = useState("");
  const previewToken = searchParams.get(PREVIEW_PARAM);

  useEffect(() => {
    const stored = loadStoredPreviewState(previewToken);
    if (!stored) {
      setResult(null);
      setErrorMessage("");
      setSourceFileName("");
      return;
    }
    setResult(stored.result);
    setErrorMessage(stored.errorMessage);
    setSourceFileName(stored.sourceFileName);
  }, [previewToken]);

  const convertMutation = useMutation({
    mutationFn: (file: File) => pdfToMarkdownApi.convert(file),
    onSuccess: (response, file) => {
      const token = `${Date.now()}`;
      persistPreviewState(token, {
        errorMessage: "",
        result: response,
        sourceFileName: file.name,
      });
      setResult(response);
      setErrorMessage("");
      setSourceFileName(file.name);
      const next = new URLSearchParams(searchParams);
      next.set(PREVIEW_PARAM, token);
      setSearchParams(next, { replace: false });
      pushToast({
        title: t("pdf.markdownReady"),
        description: t("pdf.markdownReadyDescription", { fileName: response.fileName }),
        tone: "success",
      });
    },
    onError: (error) => {
      const message = error instanceof Error ? error.message : t("pdf.conversionFailed");
      const token = `${Date.now()}`;
      persistPreviewState(token, {
        errorMessage: message,
        result: null,
        sourceFileName,
      });
      setResult(null);
      setErrorMessage(message);
      const next = new URLSearchParams(searchParams);
      next.set(PREVIEW_PARAM, token);
      setSearchParams(next, { replace: false });
      pushToast({ title: t("pdf.conversionFailed"), description: message, tone: "warning" });
    },
  });

  const handleFile = (file: File | null | undefined) => {
    if (!file) return;
    if (!file.name.toLowerCase().endsWith(".pdf")) {
      pushToast({ title: t("pdf.unsupportedFile"), description: t("pdf.unsupportedFileDescription"), tone: "warning" });
      return;
    }
    if (file.size === 0) {
      pushToast({ title: t("pdf.emptyFile"), description: t("pdf.emptyFileDescription"), tone: "warning" });
      return;
    }
    const next = new URLSearchParams(searchParams);
    next.delete(PREVIEW_PARAM);
    setSearchParams(next, { replace: true });
    setResult(null);
    setErrorMessage("");
    setSourceFileName(file.name);
    convertMutation.mutate(file);
  };

  const onDrop = (event: DragEvent<HTMLDivElement>) => {
    event.preventDefault();
    setDragActive(false);
    handleFile(event.dataTransfer.files?.[0]);
  };

  const handleDownload = async (nextResult: PdfMarkdownConversion) => {
    try {
      await downloadMarkdown(nextResult);
    } catch (error) {
      const message = error instanceof Error ? error.message : "Failed to download the Markdown file.";
      pushToast({ title: "Download failed", description: message, tone: "warning" });
    }
  };

  return (
    <PageMotion className="space-y-6">
      <input
        accept=".pdf"
        className="hidden"
        onChange={(event) => {
          handleFile(event.target.files?.[0]);
          event.target.value = "";
        }}
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
          <div className="mx-auto flex max-w-3xl flex-col items-center text-center">
            <div className="flex h-16 w-16 items-center justify-center rounded-[1.75rem] bg-[var(--panel-subtle)] text-[var(--accent)]">
              <FileText className="h-7 w-7" />
            </div>
            <div className="mt-6 flex items-center gap-2">
              <Badge tone="info">{t("pdf.independentModule")}</Badge>
              <Badge tone="success">{t("pdf.noKbIndexing")}</Badge>
            </div>
            <h1 className="mt-4 text-3xl font-semibold tracking-tight text-[var(--foreground)]">{t("pdf.title")}</h1>
            <p className="mt-3 max-w-2xl text-base leading-8 text-[var(--muted-foreground)]">
              {t("pdf.subtitle")}
            </p>
            <div className="mt-6 flex flex-wrap justify-center gap-3">
              <Button disabled={convertMutation.isPending} onClick={() => fileInputRef.current?.click()} type="button">
                <Upload className="h-4 w-4" />
                {convertMutation.isPending ? t("common.processing") : t("common.uploadPdf")}
              </Button>
              <Badge tone="info">{t("pdf.singleFile")}</Badge>
            </div>
            <div className="mt-8 grid w-full gap-3 sm:grid-cols-2 lg:grid-cols-4">
              {["Upload PDF", "Read Structure", "Generate Markdown", "Preview & Download"].map((stage) => (
                <div key={stage} className="rounded-[1.35rem] border border-[var(--border)] bg-[var(--panel-subtle)] px-4 py-4 text-sm font-medium text-[var(--foreground)]">
                  {stage}
                </div>
              ))}
            </div>
          </div>
        </div>
      </Panel>

      <div className="grid gap-6 xl:grid-cols-[320px_minmax(0,1fr)]">
        <Panel className="space-y-4">
          <div className="flex items-center justify-between gap-3">
            <div>
              <p className="text-sm font-semibold text-[var(--foreground)]">{t("pdf.summary")}</p>
              <p className="mt-1 text-sm text-[var(--muted-foreground)]">{t("pdf.summarySubtitle")}</p>
            </div>
            {convertMutation.isPending ? <Badge tone="warning">{t("common.processing")}</Badge> : result ? <Badge tone="success">{t("common.ready")}</Badge> : <Badge>{t("common.idle")}</Badge>}
          </div>

          {result ? (
            <>
              <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
                <p className="text-base font-semibold text-[var(--foreground)]">{sourceFileName || result.documentName}</p>
                <p className="mt-2 text-sm text-[var(--muted-foreground)]">{result.fileName}</p>
              </div>

              <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-1">
                <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{t("common.pages")}</p>
                  <p className="mt-2 text-lg font-semibold text-[var(--foreground)]">{formatFullNumber(result.pageCount)}</p>
                </div>
                <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{t("common.sections")}</p>
                  <p className="mt-2 text-lg font-semibold text-[var(--foreground)]">{formatFullNumber(result.sectionCount)}</p>
                </div>
                <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{t("common.chapters")}</p>
                  <p className="mt-2 text-lg font-semibold text-[var(--foreground)]">{formatFullNumber(result.chapterCount)}</p>
                </div>
                <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{t("common.glossaryTerms")}</p>
                  <p className="mt-2 text-lg font-semibold text-[var(--foreground)]">{formatFullNumber(result.glossaryCount)}</p>
                </div>
              </div>

              <Button className="w-full justify-center" onClick={() => void handleDownload(result)} type="button" variant="secondary">
                <Download className="h-4 w-4" />
                {t("common.downloadMarkdown")}
              </Button>
            </>
          ) : convertMutation.isPending ? (
            <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-5 text-sm text-[var(--muted-foreground)]">
              {t("pdf.processingDescription", { fileName: sourceFileName || "the selected PDF" })}
            </div>
          ) : errorMessage ? (
            <div className="rounded-[1.5rem] border border-rose-500/20 bg-rose-500/8 p-5 text-sm text-rose-700">
              {errorMessage}
            </div>
          ) : (
            <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-5 text-sm text-[var(--muted-foreground)]">
              {t("pdf.uploadPrompt")}
            </div>
          )}
        </Panel>

        <Panel className="space-y-4">
          <div className="flex items-center justify-between gap-3">
            <div>
              <p className="text-sm font-semibold text-[var(--foreground)]">{t("pdf.preview")}</p>
              <p className="mt-1 text-sm text-[var(--muted-foreground)]">{t("pdf.previewSubtitle")}</p>
            </div>
            {result ? (
              <Button onClick={() => void handleDownload(result)} size="sm" type="button" variant="ghost">
                <Sparkles className="h-4 w-4" />
                {t("common.download")}
              </Button>
            ) : null}
          </div>

          {convertMutation.isPending ? (
            <div className="animate-pulse rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-5">
              <div className="h-4 w-40 rounded-full bg-[var(--panel)]" />
              <div className="mt-3 h-[30rem] rounded-[1.25rem] bg-[var(--panel)]" />
            </div>
          ) : result ? (
            <div className="overflow-hidden rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel)]">
              <div className="border-b border-[var(--border)] px-4 py-3 text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">
                {result.fileName}
              </div>
              <pre className="max-h-[44rem] overflow-auto px-4 py-4 text-xs leading-6 text-[var(--foreground)]">{result.content}</pre>
            </div>
          ) : (
            <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-6 text-sm text-[var(--muted-foreground)]">
              {t("pdf.previewEmpty")}
            </div>
          )}
        </Panel>
      </div>
    </PageMotion>
  );
}
