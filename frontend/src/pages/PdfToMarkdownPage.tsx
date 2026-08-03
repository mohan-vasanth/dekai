import { useMutation } from "@tanstack/react-query";
import {
  ChevronLeft,
  ChevronRight,
  Download,
  FileText,
  Maximize2,
  Minimize2,
  Printer,
  Search,
  Table2,
  Upload,
  ZoomIn,
  ZoomOut,
} from "lucide-react";
import { useEffect, useMemo, useRef, useState, type DragEvent } from "react";
import { useSearchParams } from "react-router-dom";
import { pdfToMarkdownApi } from "../api/pdf-to-markdown";
import { HtmlTableEditorModal } from "../components/html-table-editor-modal";
import { PageBackButton } from "../components/navigation";
import { Badge, Button, PageMotion, Panel, useToast } from "../components/ui";
import { extractTablesFromMarkdown } from "../lib/html-table-editor";
import { buildProfessionalDocument, type ProfessionalDocumentModel } from "../lib/pdf-document-renderer";
import { usePreferences } from "../lib/preferences";
import { cn, formatFullNumber } from "../lib/utils";
import type { PdfMarkdownConversion } from "../types/api";

const PREVIEW_PARAM = "preview";
const PREVIEW_STORAGE_PREFIX = "dekai-pdf-preview:";
const MAX_PREVIEW_CACHE_ENTRIES = 8;
const MIN_ZOOM = 0.75;
const MAX_ZOOM = 1.7;
const ZOOM_STEP = 0.1;

type StoredPreviewState = {
  errorMessage: string;
  result: PdfMarkdownConversion | null;
  sourceFileName: string;
};

type ViewerFitMode = "width" | "page";

const previewStateCache = new Map<string, StoredPreviewState>();

const getPreviewStorageKey = (token: string) => `${PREVIEW_STORAGE_PREFIX}${token}`;

const clearLegacyPreviewState = (token: string | null = null) => {
  if (typeof window === "undefined") {
    return;
  }

  const clearMatchingKeys = (storage: Storage) => {
    if (token) {
      storage.removeItem(getPreviewStorageKey(token));
      return;
    }

    const matchingKeys: string[] = [];
    for (let index = 0; index < storage.length; index += 1) {
      const key = storage.key(index);
      if (key?.startsWith(PREVIEW_STORAGE_PREFIX)) {
        matchingKeys.push(key);
      }
    }

    matchingKeys.forEach((key) => storage.removeItem(key));
  };

  try {
    clearMatchingKeys(window.sessionStorage);
  } catch {
    // Ignore unavailable session storage.
  }

  try {
    clearMatchingKeys(window.localStorage);
  } catch {
    // Ignore unavailable local storage.
  }
};

const loadStoredPreviewState = (token: string | null): StoredPreviewState | null => {
  if (!token) {
    return null;
  }

  return previewStateCache.get(token) ?? null;
};

const persistPreviewState = (token: string, value: StoredPreviewState) => {
  previewStateCache.delete(token);
  previewStateCache.set(token, value);
  while (previewStateCache.size > MAX_PREVIEW_CACHE_ENTRIES) {
    const oldestToken = previewStateCache.keys().next().value;
    if (!oldestToken) {
      break;
    }
    previewStateCache.delete(oldestToken);
  }
  clearLegacyPreviewState(token);
};

const persistPreviewStateAndReturnToken = (token: string | null, value: StoredPreviewState) => {
  const nextToken = token ?? `${Date.now()}`;
  persistPreviewState(nextToken, value);
  return nextToken;
};

const clearCachedPreviewState = (token: string | null) => {
  if (!token) {
    return;
  }
  previewStateCache.delete(token);
  clearLegacyPreviewState(token);
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

function clampZoom(value: number) {
  return Math.max(MIN_ZOOM, Math.min(MAX_ZOOM, Number(value.toFixed(2))));
}

function escapeHtml(value: string) {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

function buildViewerFrameDocument(documentModel: ProfessionalDocumentModel, zoom: number, fitMode: ViewerFitMode) {
  const pageWidth = fitMode === "width" ? "min(100%, 1440px)" : "1080px";

  return `<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${escapeHtml(documentModel.title)}</title>
    <style>
      @import url("https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Sora:wght@500;600;700&display=swap");

      :root {
        --page-width: ${pageWidth};
        --page-zoom: ${zoom};
        --accent: #0f766e;
        --accent-strong: #115e59;
        --border: #dbe5df;
        --foreground: #16211d;
        --muted: #61716b;
        --surface: #ffffff;
        --surface-soft: #f4f8f6;
        --surface-tint: #ecf6f2;
        --shadow: rgba(17, 31, 26, 0.08);
      }

      * {
        box-sizing: border-box;
      }

      html {
        scroll-behavior: smooth;
      }

      body {
        margin: 0;
        min-height: 100vh;
        background:
          radial-gradient(circle at top left, rgba(15, 118, 110, 0.1), transparent 26%),
          radial-gradient(circle at bottom right, rgba(16, 185, 129, 0.08), transparent 22%),
          linear-gradient(180deg, #eef3f0 0%, #e4ebe7 100%);
        color: var(--foreground);
        font-family: "Manrope", system-ui, sans-serif;
      }

      .dekai-frame-shell {
        padding: 28px;
      }

      .dekai-frame-page {
        zoom: var(--page-zoom);
        width: var(--page-width);
        max-width: 100%;
        margin: 0 auto;
      }

      .dekai-doc-shell {
        display: block;
      }

      .dekai-doc-stack {
        display: grid;
        gap: 24px;
      }

      .dekai-doc-hero,
      .dekai-doc-section,
      .dekai-doc-footer {
        border: 1px solid rgba(22, 33, 29, 0.08);
        border-radius: 28px;
        background: var(--surface);
        box-shadow: 0 24px 60px var(--shadow);
      }

      .dekai-doc-hero {
        display: grid;
        gap: 22px;
        grid-template-columns: minmax(0, 1.4fr) minmax(280px, 0.8fr);
        padding: 34px 36px;
        background:
          linear-gradient(135deg, rgba(15, 118, 110, 0.94), rgba(17, 94, 89, 0.84)),
          var(--surface);
        color: #f7fffc;
      }

      .dekai-doc-badge {
        display: inline-flex;
        align-items: center;
        border-radius: 999px;
        background: rgba(255, 255, 255, 0.14);
        padding: 0.45rem 0.8rem;
        font-size: 0.74rem;
        font-weight: 700;
        letter-spacing: 0.16em;
        text-transform: uppercase;
      }

      .dekai-doc-hero h1 {
        margin: 1rem 0 0.65rem;
        font-family: "Sora", "Manrope", sans-serif;
        font-size: 2.4rem;
        line-height: 1.06;
      }

      .dekai-doc-hero p {
        margin: 0;
        max-width: 62ch;
        font-size: 1rem;
        line-height: 1.8;
        color: rgba(247, 255, 252, 0.84);
      }

      .dekai-doc-hero-stats {
        display: grid;
        gap: 14px;
        align-content: start;
      }

      .dekai-doc-stat {
        border-radius: 22px;
        background: rgba(255, 255, 255, 0.12);
        padding: 18px 20px;
        backdrop-filter: blur(10px);
      }

      .dekai-doc-stat span {
        display: block;
        font-size: 0.78rem;
        font-weight: 700;
        letter-spacing: 0.16em;
        text-transform: uppercase;
        color: rgba(247, 255, 252, 0.68);
      }

      .dekai-doc-stat strong {
        display: block;
        margin-top: 0.45rem;
        font-size: 1.8rem;
        font-weight: 800;
      }

      .dekai-doc-main {
        display: grid;
        gap: 22px;
      }

      .dekai-doc-section {
        padding: 28px 30px 30px;
      }

      .dekai-doc-section-head {
        display: flex;
        flex-wrap: wrap;
        align-items: flex-start;
        justify-content: space-between;
        gap: 16px;
        margin-bottom: 20px;
      }

      .dekai-section-kicker {
        display: inline-flex;
        align-items: center;
        border-radius: 999px;
        background: var(--surface-tint);
        padding: 0.34rem 0.72rem;
        color: var(--accent-strong);
        font-size: 0.72rem;
        font-weight: 800;
        letter-spacing: 0.14em;
        text-transform: uppercase;
      }

      .dekai-doc-section h2,
      .dekai-doc-section h3,
      .dekai-doc-section h4 {
        margin: 0.9rem 0 0;
        color: #13241e;
        font-family: "Sora", "Manrope", sans-serif;
        line-height: 1.2;
      }

      .dekai-doc-section h2 {
        font-size: 1.48rem;
      }

      .dekai-doc-section-meta {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
      }

      .dekai-doc-section-meta span {
        display: inline-flex;
        align-items: center;
        border-radius: 999px;
        border: 1px solid var(--border);
        background: var(--surface-soft);
        padding: 0.45rem 0.72rem;
        color: var(--muted);
        font-size: 0.76rem;
        font-weight: 700;
        letter-spacing: 0.06em;
        text-transform: uppercase;
      }

      .dekai-card-grid {
        display: grid;
        gap: 14px;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        margin-bottom: 18px;
      }

      .dekai-info-card {
        border-radius: 22px;
        border: 1px solid var(--border);
        background: linear-gradient(180deg, #fbfcfb 0%, #f4f8f6 100%);
        padding: 16px 18px;
        box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.55);
      }

      .dekai-info-label {
        display: block;
        color: var(--muted);
        font-size: 0.72rem;
        font-weight: 800;
        letter-spacing: 0.14em;
        text-transform: uppercase;
      }

      .dekai-info-value {
        display: block;
        margin-top: 0.7rem;
        color: #13241e;
        font-size: 1rem;
        font-weight: 700;
        line-height: 1.65;
      }

      .dekai-rich-text {
        color: var(--foreground);
      }

      .dekai-rich-text h1,
      .dekai-rich-text h2,
      .dekai-rich-text h3,
      .dekai-rich-text h4,
      .dekai-rich-text h5,
      .dekai-rich-text h6 {
        margin: 1.2rem 0 0.7rem;
        font-family: "Sora", "Manrope", sans-serif;
        line-height: 1.2;
      }

      .dekai-rich-text p,
      .dekai-rich-text ul,
      .dekai-rich-text ol,
      .dekai-rich-text pre,
      .dekai-rich-text blockquote {
        margin: 0.85rem 0;
      }

      .dekai-rich-text ul,
      .dekai-rich-text ol {
        padding-left: 1.35rem;
      }

      .dekai-rich-text li,
      .dekai-rich-text p {
        line-height: 1.8;
      }

      .dekai-rich-text a {
        color: var(--accent);
        text-decoration: underline;
        text-underline-offset: 0.16rem;
      }

      .dekai-rich-text blockquote {
        border-left: 4px solid rgba(15, 118, 110, 0.22);
        background: #f5fbf8;
        padding: 14px 16px;
        border-radius: 16px;
      }

      .dekai-rich-text pre {
        overflow: auto;
        border-radius: 20px;
        background: #0f172a;
        color: #dbeafe;
        padding: 1rem 1.1rem;
      }

      .dekai-rich-text code {
        border-radius: 10px;
        background: #eef5f2;
        padding: 0.12rem 0.4rem;
        font-family: "Cascadia Code", Consolas, monospace;
      }

      .dekai-rich-text img {
        display: block;
        max-width: 100%;
        border-radius: 22px;
        border: 1px solid var(--border);
      }

      .dekai-table-section + .dekai-table-section {
        margin-top: 18px;
      }

      .dekai-table-header {
        display: flex;
        flex-wrap: wrap;
        align-items: flex-end;
        justify-content: space-between;
        gap: 10px;
        margin-bottom: 10px;
      }

      .dekai-table-header h4 {
        margin: 0.55rem 0 0;
        font-size: 1rem;
      }

      .dekai-table-shell {
        overflow: auto;
        border: 1px solid var(--border);
        border-radius: 22px;
        background: var(--surface);
      }

      .dekai-table-shell table {
        width: 100%;
        min-width: 720px;
        border-collapse: separate;
        border-spacing: 0;
      }

      .dekai-table-shell thead th,
      .dekai-table-shell tbody td,
      .dekai-table-shell tbody th {
        border-bottom: 1px solid var(--border);
        border-right: 1px solid var(--border);
        padding: 0.85rem 0.95rem;
        text-align: left;
        vertical-align: top;
        line-height: 1.7;
      }

      .dekai-table-shell thead th:last-child,
      .dekai-table-shell tbody td:last-child,
      .dekai-table-shell tbody th:last-child {
        border-right: 0;
      }

      .dekai-table-shell thead th {
        position: sticky;
        top: 0;
        z-index: 2;
        background: linear-gradient(180deg, #dcf4eb 0%, #ebf8f3 100%);
        color: #15453d;
        font-size: 0.78rem;
        font-weight: 800;
        letter-spacing: 0.08em;
        text-transform: uppercase;
      }

      .dekai-table-shell tbody tr:nth-child(even) td,
      .dekai-table-shell tbody tr:nth-child(even) th {
        background: #f8fbf9;
      }

      .dekai-table-shell tbody tr:hover td,
      .dekai-table-shell tbody tr:hover th {
        background: #eef8f4;
      }

      .dekai-doc-footer {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        gap: 12px;
        padding: 18px 22px;
        color: var(--muted);
        font-size: 0.84rem;
      }

      .dekai-targeted {
        outline: 3px solid rgba(15, 118, 110, 0.2);
        outline-offset: 6px;
        border-radius: 18px;
        animation: dekai-highlight 1.2s ease;
      }

      @keyframes dekai-highlight {
        from { box-shadow: 0 0 0 0 rgba(15, 118, 110, 0.22); }
        to { box-shadow: 0 0 0 22px rgba(15, 118, 110, 0); }
      }

      @media (max-width: 980px) {
        .dekai-doc-hero {
          grid-template-columns: 1fr;
        }

        .dekai-doc-section {
          padding: 22px;
        }
      }

      @media print {
        body {
          background: white;
        }

        .dekai-frame-shell {
          padding: 0;
        }

        .dekai-frame-page {
          zoom: 1;
          width: 100%;
        }

        .dekai-doc-hero,
        .dekai-doc-section,
        .dekai-doc-footer {
          border: 0;
          border-radius: 0;
          box-shadow: none;
        }
      }
    </style>
  </head>
  <body>
    <div class="dekai-frame-shell">
      <div class="dekai-frame-page">
        ${documentModel.bodyHtml}
      </div>
    </div>
  </body>
</html>`;
}

export function PdfToMarkdownPage() {
  const { pushToast } = useToast();
  const { t } = usePreferences();
  const [searchParams, setSearchParams] = useSearchParams();
  const fileInputRef = useRef<HTMLInputElement | null>(null);
  const iframeRef = useRef<HTMLIFrameElement | null>(null);
  const viewerShellRef = useRef<HTMLDivElement | null>(null);
  const [dragActive, setDragActive] = useState(false);
  const [result, setResult] = useState<PdfMarkdownConversion | null>(null);
  const [errorMessage, setErrorMessage] = useState("");
  const [sourceFileName, setSourceFileName] = useState("");
  const [isEditorOpen, setIsEditorOpen] = useState(false);
  const [editorInitialTableId, setEditorInitialTableId] = useState<string | null>(null);
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedHeadingId, setSelectedHeadingId] = useState("");
  const [selectedTableId, setSelectedTableId] = useState("");
  const [viewerZoom, setViewerZoom] = useState(1);
  const [viewerFitMode, setViewerFitMode] = useState<ViewerFitMode>("page");
  const [isViewerFullscreen, setIsViewerFullscreen] = useState(false);
  const viewerFitModeBeforeFullscreenRef = useRef<ViewerFitMode | null>(null);
  const previewToken = searchParams.get(PREVIEW_PARAM);
  const tableMatches = useMemo(() => (result ? extractTablesFromMarkdown(result.content) : []), [result]);

  const viewerDocument = useMemo(
    () =>
      result
        ? buildProfessionalDocument(
            result.content,
            sourceFileName || result.documentName || result.fileName,
            tableMatches.map((table) => table.id),
          )
        : null,
    [result, sourceFileName, tableMatches],
  );

  const viewerSrcDoc = useMemo(
    () => (viewerDocument ? buildViewerFrameDocument(viewerDocument, viewerZoom, viewerFitMode) : ""),
    [viewerDocument, viewerFitMode, viewerZoom],
  );

  const persistCurrentPreview = (nextToken: string | null, nextResult: PdfMarkdownConversion | null, nextErrorMessage: string, nextSourceFileName: string) => {
    const resolvedToken = persistPreviewStateAndReturnToken(nextToken, {
      errorMessage: nextErrorMessage,
      result: nextResult,
      sourceFileName: nextSourceFileName,
    });
    const nextSearchParams = new URLSearchParams(searchParams);
    nextSearchParams.set(PREVIEW_PARAM, resolvedToken);
    setSearchParams(nextSearchParams, { replace: true });
  };

  useEffect(() => {
    clearLegacyPreviewState();
  }, []);

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

  useEffect(() => {
    setSearchQuery("");
    setViewerZoom(1);
    setViewerFitMode("page");
  }, [result?.content]);

  useEffect(() => {
    const headings = viewerDocument?.headings ?? [];
    if (!headings.length) {
      setSelectedHeadingId("");
      return;
    }
    if (!headings.some((heading) => heading.id === selectedHeadingId)) {
      setSelectedHeadingId(headings[0].id);
    }
  }, [selectedHeadingId, viewerDocument?.headings]);

  useEffect(() => {
    const tables = viewerDocument?.tables ?? [];
    if (!tables.length) {
      setSelectedTableId("");
      return;
    }
    if (!tables.some((table) => table.id === selectedTableId)) {
      setSelectedTableId(tables[0].id);
    }
  }, [selectedTableId, viewerDocument?.tables]);

  useEffect(() => {
    if (!viewerDocument || !result) {
      return;
    }

    console.info("[PDF HTML Viewer] Professional HTML document generated", {
      fileName: result.fileName,
      documentType: viewerDocument.documentType,
      htmlTagCount: viewerDocument.htmlTagCount,
      sectionCount: viewerDocument.sectionCount,
      tableCount: viewerDocument.tables.length,
    });
  }, [result, viewerDocument]);

  useEffect(() => {
    const handleFullscreenChange = () => {
      const isActive = Boolean(document.fullscreenElement && viewerShellRef.current && document.fullscreenElement === viewerShellRef.current);
      setIsViewerFullscreen(isActive);

      if (!isActive && viewerFitModeBeforeFullscreenRef.current) {
        setViewerFitMode(viewerFitModeBeforeFullscreenRef.current);
        viewerFitModeBeforeFullscreenRef.current = null;
      }
    };

    document.addEventListener("fullscreenchange", handleFullscreenChange);
    return () => {
      document.removeEventListener("fullscreenchange", handleFullscreenChange);
    };
  }, []);

  const convertMutation = useMutation({
    mutationFn: (file: File) => pdfToMarkdownApi.convert(file),
    onSuccess: (response, file) => {
      setResult(response);
      setErrorMessage("");
      setSourceFileName(file.name);
      persistCurrentPreview(null, response, "", file.name);
      pushToast({
        title: t("pdf.markdownReady"),
        description: `${response.fileName} is now rendered as a professional HTML document.`,
        tone: "success",
      });
    },
    onError: (error) => {
      const message = error instanceof Error ? error.message : t("pdf.conversionFailed");
      setResult(null);
      setErrorMessage(message);
      persistCurrentPreview(null, null, message, sourceFileName);
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
    clearCachedPreviewState(previewToken);
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

  const openTableEditor = (tableId: string | null = null) => {
    setEditorInitialTableId(tableId);
    setIsEditorOpen(true);
  };

  const navigateViewerToSelector = (selector: string) => {
    const documentNode = iframeRef.current?.contentDocument;
    if (!documentNode) {
      return;
    }

    const target = documentNode.querySelector<HTMLElement>(selector);
    if (!target) {
      return;
    }

    target.scrollIntoView({ behavior: "smooth", block: "start" });
    target.classList.remove("dekai-targeted");
    window.requestAnimationFrame(() => {
      target.classList.add("dekai-targeted");
      window.setTimeout(() => target.classList.remove("dekai-targeted"), 1_400);
    });
  };

  const navigateToHeading = (headingId: string) => {
    setSelectedHeadingId(headingId);
    navigateViewerToSelector(`#${window.CSS.escape(headingId)}`);
  };

  const navigateRelativeHeading = (direction: -1 | 1) => {
    const headings = viewerDocument?.headings ?? [];
    if (!headings.length) {
      return;
    }

    const currentIndex = headings.findIndex((heading) => heading.id === selectedHeadingId);
    const fallbackIndex = currentIndex === -1 ? 0 : currentIndex;
    const nextIndex = Math.max(0, Math.min(headings.length - 1, fallbackIndex + direction));
    navigateToHeading(headings[nextIndex].id);
  };

  const navigateToTable = (tableId: string) => {
    setSelectedTableId(tableId);
    navigateViewerToSelector(`[data-table-id="${window.CSS.escape(tableId)}"]`);
  };

  const handleViewerSearch = (backwards = false) => {
    const query = searchQuery.trim();
    const frameWindow = iframeRef.current?.contentWindow;

    if (!query) {
      pushToast({ title: "Search query required", description: "Enter text to search inside the rendered HTML document.", tone: "warning" });
      return;
    }

    if (!frameWindow) {
      pushToast({ title: "Viewer unavailable", description: "The rendered viewer is still loading.", tone: "warning" });
      return;
    }

    const searchableWindow = frameWindow as Window & {
      find?: (
        text: string,
        caseSensitive?: boolean,
        backwards?: boolean,
        wrapAround?: boolean,
        wholeWord?: boolean,
        searchInFrames?: boolean,
        showDialog?: boolean,
      ) => boolean;
    };

    const found = typeof searchableWindow.find === "function"
      ? searchableWindow.find(query, false, backwards, true, false, false, false)
      : false;

    if (!found) {
      pushToast({ title: "No match found", description: `No rendered content matched "${query}".`, tone: "warning" });
    }
  };

  const handlePrint = () => {
    const frameWindow = iframeRef.current?.contentWindow;
    if (!frameWindow) {
      pushToast({ title: "Viewer unavailable", description: "The rendered viewer is still loading.", tone: "warning" });
      return;
    }

    frameWindow.focus();
    frameWindow.print();
  };

  const handleFullscreenToggle = async () => {
    if (!viewerShellRef.current) {
      return;
    }

    if (document.fullscreenElement === viewerShellRef.current) {
      await document.exitFullscreen();
      return;
    }

    viewerFitModeBeforeFullscreenRef.current = viewerFitMode;
    setViewerFitMode("width");
    await viewerShellRef.current.requestFullscreen();
  };

  const handleIframeLoad = () => {
    if (!result || !viewerDocument) {
      return;
    }

    console.info("[PDF HTML Viewer] HTML render success", {
      fileName: result.fileName,
      documentType: viewerDocument.documentType,
      zoom: viewerZoom,
      fitMode: viewerFitMode,
    });

    if (selectedTableId) {
      navigateViewerToSelector(`[data-table-id="${window.CSS.escape(selectedTableId)}"]`);
      return;
    }

    if (selectedHeadingId) {
      navigateViewerToSelector(`#${window.CSS.escape(selectedHeadingId)}`);
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
              <Badge tone="success">HTML-first output</Badge>
            </div>
            <h1 className="mt-4 text-3xl font-semibold tracking-tight text-[var(--foreground)]">{t("pdf.title")}</h1>
            <p className="mt-3 max-w-2xl text-base leading-8 text-[var(--muted-foreground)]">
              Generated markdown stays internal. DEKAI automatically transforms the extracted structure into a professional HTML document viewer.
            </p>
            <div className="mt-6 flex flex-wrap justify-center gap-3">
              <Button disabled={convertMutation.isPending} onClick={() => fileInputRef.current?.click()} type="button">
                <Upload className="h-4 w-4" />
                {convertMutation.isPending ? t("common.processing") : t("common.uploadPdf")}
              </Button>
            </div>
            <div className="mt-8 grid w-full gap-3 sm:grid-cols-2 lg:grid-cols-5">
              {["Upload PDF", "Extract Content", "Convert to Markdown", "Generate HTML UI", "Render Document"].map((stage) => (
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
              <p className="text-sm font-semibold text-[var(--foreground)]">Document Summary</p>
              <p className="mt-1 text-sm text-[var(--muted-foreground)]">Rendered output details for the latest conversion.</p>
            </div>
            {convertMutation.isPending ? <Badge tone="warning">{t("common.processing")}</Badge> : result ? <Badge tone="success">{t("common.ready")}</Badge> : <Badge>{t("common.idle")}</Badge>}
          </div>

          {result && viewerDocument ? (
            <>
              <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
                <p className="text-base font-semibold text-[var(--foreground)]">{viewerDocument.title}</p>
                <p className="mt-2 text-sm text-[var(--muted-foreground)]">{sourceFileName || result.documentName}</p>
                <div className="mt-3 flex flex-wrap gap-2">
                  <Badge tone="info">{viewerDocument.documentType.replaceAll("-", " ")}</Badge>
                  <Badge tone="success">Professional HTML</Badge>
                </div>
              </div>

              <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-1">
                <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">Pages</p>
                  <p className="mt-2 text-lg font-semibold text-[var(--foreground)]">{formatFullNumber(result.pageCount)}</p>
                </div>
                <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">Sections</p>
                  <p className="mt-2 text-lg font-semibold text-[var(--foreground)]">{formatFullNumber(viewerDocument.sectionCount)}</p>
                </div>
                <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">Rendered Tables</p>
                  <p className="mt-2 text-lg font-semibold text-[var(--foreground)]">{formatFullNumber(viewerDocument.tables.length)}</p>
                </div>
                <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">HTML Tags</p>
                  <p className="mt-2 text-lg font-semibold text-[var(--foreground)]">{formatFullNumber(viewerDocument.htmlTagCount)}</p>
                </div>
              </div>

              <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4 text-sm text-[var(--muted-foreground)]">
                Raw markdown is not shown in the end-user UI. The uploaded PDF is rendered directly as structured HTML cards, sections, and responsive tables.
              </div>

              <Button className="w-full justify-center" onClick={() => void handleDownload(result)} type="button" variant="secondary">
                <Download className="h-4 w-4" />
                {t("common.downloadMarkdown")}
              </Button>
              <Button className="w-full justify-center" disabled={!tableMatches.length} onClick={() => openTableEditor(selectedTableId || null)} type="button" variant="ghost">
                <Table2 className="h-4 w-4" />
                HTML Table Editor
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
              Upload a PDF to render a professional HTML document viewer.
            </div>
          )}
        </Panel>

        <Panel className="space-y-4">
          <div className="flex items-center justify-between gap-3">
            <div>
              <p className="text-sm font-semibold text-[var(--foreground)]">Rendered HTML Document</p>
              <p className="mt-1 text-sm text-[var(--muted-foreground)]">
                Final end-user view with semantic sections, responsive tables, and print-friendly document styling.
              </p>
            </div>
            {result && viewerDocument ? (
              <div className="flex flex-wrap gap-2">
                <Button disabled={!tableMatches.length} onClick={() => openTableEditor(selectedTableId || null)} size="sm" type="button" variant="ghost">
                  <Table2 className="h-4 w-4" />
                  Open in Table Editor
                </Button>
                <Button onClick={handlePrint} size="sm" type="button" variant="ghost">
                  <Printer className="h-4 w-4" />
                  Print
                </Button>
              </div>
            ) : null}
          </div>

          {convertMutation.isPending ? (
            <div className="animate-pulse rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-5">
              <div className="h-4 w-40 rounded-full bg-[var(--panel)]" />
              <div className="mt-3 h-[36rem] rounded-[1.25rem] bg-[var(--panel)]" />
            </div>
          ) : result && viewerDocument ? (
            <div
              className={cn(
                "overflow-hidden rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel)]",
                isViewerFullscreen && "flex h-full w-full flex-col rounded-none border-0",
              )}
              ref={viewerShellRef}
            >
              <div className="border-b border-[var(--border)] px-4 py-3 text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">
                <div className="flex flex-wrap items-center justify-between gap-3">
                  <span>{result.fileName}</span>
                  <Badge tone="info">{viewerDocument.documentType.replaceAll("-", " ")}</Badge>
                </div>
              </div>

              <div className="border-b border-[var(--border)] bg-[var(--panel-subtle)]/70 px-4 py-4">
                <div className="flex flex-wrap items-center gap-2">
                  <Button onClick={() => setViewerZoom((current) => clampZoom(current - ZOOM_STEP))} size="sm" type="button" variant="ghost">
                    <ZoomOut className="h-4 w-4" />
                    Zoom Out
                  </Button>
                  <Badge>{Math.round(viewerZoom * 100)}%</Badge>
                  <Button onClick={() => setViewerZoom((current) => clampZoom(current + ZOOM_STEP))} size="sm" type="button" variant="ghost">
                    <ZoomIn className="h-4 w-4" />
                    Zoom In
                  </Button>
                  <Button onClick={() => setViewerFitMode("width")} size="sm" type="button" variant={viewerFitMode === "width" ? "secondary" : "ghost"}>
                    Fit Width
                  </Button>
                  <Button onClick={() => setViewerFitMode("page")} size="sm" type="button" variant={viewerFitMode === "page" ? "secondary" : "ghost"}>
                    Fit Page
                  </Button>
                  <Button onClick={() => void handleFullscreenToggle()} size="sm" type="button" variant="ghost">
                    {isViewerFullscreen ? <Minimize2 className="h-4 w-4" /> : <Maximize2 className="h-4 w-4" />}
                    {isViewerFullscreen ? "Exit Full Screen" : "Full Screen"}
                  </Button>
                </div>

                <div className="mt-3 grid gap-3 xl:grid-cols-[minmax(220px,1.1fr)_minmax(240px,1fr)_minmax(240px,1fr)]">
                  <div className="flex items-center gap-2 rounded-[1.25rem] border border-[var(--border)] bg-[var(--panel)] px-3 py-2">
                    <Search className="h-4 w-4 text-[var(--muted-foreground)]" />
                    <input
                      className="w-full border-0 bg-transparent text-sm text-[var(--foreground)] outline-none"
                      onChange={(event) => setSearchQuery(event.target.value)}
                      onKeyDown={(event) => {
                        if (event.key === "Enter") {
                          event.preventDefault();
                          handleViewerSearch(event.shiftKey);
                        }
                      }}
                      placeholder="Search rendered document"
                      type="text"
                      value={searchQuery}
                    />
                    <Button onClick={() => handleViewerSearch(true)} size="sm" type="button" variant="ghost">
                      <ChevronLeft className="h-4 w-4" />
                    </Button>
                    <Button onClick={() => handleViewerSearch(false)} size="sm" type="button" variant="ghost">
                      <ChevronRight className="h-4 w-4" />
                    </Button>
                  </div>

                  <div className="flex items-center gap-2 rounded-[1.25rem] border border-[var(--border)] bg-[var(--panel)] px-3 py-2">
                    <Button disabled={viewerDocument.headings.length <= 1} onClick={() => navigateRelativeHeading(-1)} size="sm" type="button" variant="ghost">
                      <ChevronLeft className="h-4 w-4" />
                    </Button>
                    <select
                      className="w-full border-0 bg-transparent text-sm text-[var(--foreground)] outline-none"
                      onChange={(event) => navigateToHeading(event.target.value)}
                      value={selectedHeadingId}
                    >
                      {viewerDocument.headings.map((heading) => (
                        <option key={heading.id} value={heading.id}>
                          {heading.label}
                        </option>
                      ))}
                    </select>
                    <Button disabled={viewerDocument.headings.length <= 1} onClick={() => navigateRelativeHeading(1)} size="sm" type="button" variant="ghost">
                      <ChevronRight className="h-4 w-4" />
                    </Button>
                  </div>

                  <div className="flex items-center gap-2 rounded-[1.25rem] border border-[var(--border)] bg-[var(--panel)] px-3 py-2">
                    <Table2 className="h-4 w-4 text-[var(--muted-foreground)]" />
                    <select
                      className="w-full border-0 bg-transparent text-sm text-[var(--foreground)] outline-none"
                      disabled={!viewerDocument.tables.length}
                      onChange={(event) => navigateToTable(event.target.value)}
                      value={selectedTableId}
                    >
                      {(viewerDocument.tables.length ? viewerDocument.tables : [{ id: "", label: "No tables detected" }]).map((table) => (
                        <option key={table.id || "no-table"} value={table.id}>
                          {table.label}
                        </option>
                      ))}
                    </select>
                    <Button disabled={!tableMatches.length} onClick={() => openTableEditor(selectedTableId || null)} size="sm" type="button" variant="ghost">
                      Edit
                    </Button>
                  </div>
                </div>
              </div>

              <div
                className={cn(
                  "bg-[linear-gradient(180deg,rgba(236,241,238,0.86),rgba(224,232,227,0.95))] p-4",
                  isViewerFullscreen && "min-h-0 flex-1 p-3 md:p-4",
                )}
              >
                <div
                  className={cn(
                    "overflow-hidden rounded-[1.6rem] border border-[var(--border)] bg-[var(--panel)] shadow-[0_20px_48px_rgba(15,23,42,0.08)]",
                    isViewerFullscreen && "h-full rounded-[1.25rem]",
                  )}
                >
                  <iframe
                    className={cn(
                      "w-full border-0 bg-white",
                      isViewerFullscreen ? "h-full min-h-0" : "h-[70rem]",
                    )}
                    onLoad={handleIframeLoad}
                    ref={iframeRef}
                    srcDoc={viewerSrcDoc}
                    title="DEKAI Professional HTML Document Viewer"
                  />
                </div>
              </div>
            </div>
          ) : (
            <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-6 text-sm text-[var(--muted-foreground)]">
              The professional HTML document viewer appears here after conversion.
            </div>
          )}
        </Panel>
      </div>

      <HtmlTableEditorModal
        fileName={result?.fileName ?? ""}
        initialTableId={editorInitialTableId}
        isOpen={isEditorOpen}
        markdown={result?.content ?? ""}
        onClose={() => {
          setIsEditorOpen(false);
          setEditorInitialTableId(null);
        }}
        onSave={(nextMarkdown) => {
          if (!result) {
            return;
          }

          const nextResult = {
            ...result,
            content: nextMarkdown,
          };
          setResult(nextResult);
          setErrorMessage("");
          persistCurrentPreview(previewToken, nextResult, "", sourceFileName || result.documentName);
          setIsEditorOpen(false);
          setEditorInitialTableId(null);
          pushToast({
            title: "Markdown updated",
            description: "The rendered HTML document was refreshed from the edited table content.",
            tone: "success",
          });
        }}
      />
    </PageMotion>
  );
}
