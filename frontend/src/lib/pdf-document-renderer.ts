import { extractTablesFromMarkdown, renderMarkdownToHtml, replaceTablesInMarkdown, serializeTableToHtml } from "./html-table-editor";

export type DocumentType =
  | "invoice"
  | "packing-list"
  | "purchase-order"
  | "commercial-invoice"
  | "bill-of-lading"
  | "certificate"
  | "declaration"
  | "report"
  | "business-document";

export type RenderedDocumentHeading = {
  id: string;
  label: string;
  level: number;
};

export type RenderedDocumentTable = {
  id: string;
  label: string;
};

export type ProfessionalDocumentModel = {
  bodyHtml: string;
  documentType: DocumentType;
  headings: RenderedDocumentHeading[];
  htmlTagCount: number;
  sectionCount: number;
  tables: RenderedDocumentTable[];
  title: string;
};

export type RenderedDocumentHtmlOptions = {
  pageWidth?: string;
  sanitize?: boolean;
  zoom?: number;
};

type ParsedField = {
  key: string;
  value: string;
};

type ParsedSection = {
  bodyHtml: string;
  fields: ParsedField[];
  heading: string;
  id: string;
  kind: string;
  level: number;
  tableIds: string[];
  tablesHtml: string[];
};

const DOCUMENT_TYPE_KEYWORDS: Array<{ type: DocumentType; patterns: RegExp[] }> = [
  { type: "commercial-invoice", patterns: [/\bcommercial invoice\b/i] },
  { type: "invoice", patterns: [/\binvoice\b/i, /\binvoice no\b/i, /\btax invoice\b/i] },
  { type: "packing-list", patterns: [/\bpacking list\b/i, /\bpacking details\b/i, /\bpackage count\b/i, /\bgross weight\b/i] },
  { type: "purchase-order", patterns: [/\bpurchase order\b/i, /\bpo number\b/i] },
  { type: "bill-of-lading", patterns: [/\bbill of lading\b/i, /\bbl number\b/i, /\bconsignee\b/i, /\bshipment details\b/i] },
  { type: "certificate", patterns: [/\bcertificate\b/i] },
  { type: "declaration", patterns: [/\bdeclaration\b/i] },
  { type: "report", patterns: [/\breport\b/i, /\bsummary\b/i, /\bfindings\b/i] },
];

const SECTION_KIND_PATTERNS: Array<{ kind: string; patterns: RegExp[] }> = [
  { kind: "invoice-information", patterns: [/\binvoice\b/i, /\bdocument metadata\b/i, /\binformation\b/i] },
  { kind: "customer-details", patterns: [/\bcustomer\b/i, /\bbuyer\b/i, /\bbill to\b/i] },
  { kind: "consignee-details", patterns: [/\bconsignee\b/i, /\bship to\b/i] },
  { kind: "supplier-details", patterns: [/\bsupplier\b/i, /\bvendor\b/i, /\bseller\b/i] },
  { kind: "packing-details", patterns: [/\bpacking\b/i, /\bpackage\b/i, /\bgross weight\b/i, /\bnet weight\b/i] },
  { kind: "shipment-details", patterns: [/\bshipment\b/i, /\btransport\b/i, /\bvessel\b/i, /\bawb\b/i] },
  { kind: "container-details", patterns: [/\bcontainer\b/i] },
  { kind: "line-items", patterns: [/\bline items?\b/i, /\bitem details\b/i, /\bproduct details\b/i] },
  { kind: "tax-details", patterns: [/\btax\b/i, /\bduty\b/i, /\bgst\b/i, /\bvat\b/i] },
  { kind: "summary", patterns: [/\bsummary\b/i, /\btotals?\b/i, /\bamount due\b/i] },
  { kind: "notes", patterns: [/\bnotes?\b/i, /\bremarks?\b/i, /\bcomments?\b/i] },
  { kind: "signature", patterns: [/\bsignature\b/i, /\bauthori[sz]ed\b/i] },
];

function escapeHtml(value: string) {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

function slugify(value: string) {
  const normalized = value
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
  return normalized || "section";
}

function normalizeWhitespace(value: string) {
  return value.replace(/\r\n/g, "\n").replace(/[ \t]+/g, " ").trim();
}

function stripViewerOnlySubsections(markdown: string) {
  return markdown
    .replace(/^####\s+HTML Tables\s*$/gim, "")
    .replace(/^####\s+Source Content\s*$[\r\n]+~~~[^\n]*[\s\S]*?^~~~\s*$/gim, "")
    .replace(/^```[^\n]*[\s\S]*?^```\s*$/gim, "")
    .replace(/^~~~[^\n]*[\s\S]*?^~~~\s*$/gim, "")
    .replace(/^<!--\s*dekai:html-table.*?-->\s*$/gim, "")
    .trim();
}

function isViewerInternalHeading(heading: string) {
  const normalized = normalizeWhitespace(heading).toLowerCase();
  return normalized === "html tables" || normalized === "source content";
}

function parseDocumentTitle(markdown: string, fallbackTitle: string) {
  const titleMatch = markdown.match(/^#\s+(.+)$/m);
  return normalizeWhitespace(titleMatch?.[1] ?? fallbackTitle);
}

function detectDocumentType(markdown: string, title: string): DocumentType {
  const source = `${title}\n${markdown}`;
  for (const candidate of DOCUMENT_TYPE_KEYWORDS) {
    if (candidate.patterns.some((pattern) => pattern.test(source))) {
      return candidate.type;
    }
  }
  return "business-document";
}

function inferSectionKind(heading: string, documentType: DocumentType, hasTables: boolean) {
  for (const candidate of SECTION_KIND_PATTERNS) {
    if (candidate.patterns.some((pattern) => pattern.test(heading))) {
      return candidate.kind;
    }
  }

  if (hasTables) {
    return documentType === "packing-list" ? "packing-details" : "line-items";
  }

  return "details";
}

function stripMarkdownTitle(markdown: string) {
  const lines = markdown.replace(/\r\n/g, "\n").split("\n");
  if (lines[0]?.startsWith("# ")) {
    return lines.slice(1).join("\n").trim();
  }
  return markdown.trim();
}

function splitMarkdownSections(markdown: string) {
  const content = stripMarkdownTitle(markdown);
  const lines = content.split("\n");
  const sections: Array<{ heading: string; level: number; content: string }> = [];
  let currentHeading = "Document Overview";
  let currentLevel = 2;
  let buffer: string[] = [];

  const flush = () => {
    const normalized = buffer.join("\n").trim();
    if (!normalized) {
      return;
    }
    sections.push({
      heading: currentHeading,
      level: currentLevel,
      content: normalized,
    });
  };

  lines.forEach((line) => {
    const headingMatch = /^(#{2,4})\s+(.+)$/.exec(line);
    if (headingMatch) {
      if (isViewerInternalHeading(headingMatch[2])) {
        return;
      }
      flush();
      currentHeading = normalizeWhitespace(headingMatch[2]);
      currentLevel = headingMatch[1].length;
      buffer = [];
      return;
    }

    buffer.push(line);
  });

  flush();
  return sections.length ? sections : [{ heading: "Document Overview", level: 2, content }];
}

function parseFieldLine(line: string): ParsedField | null {
  const cleaned = normalizeWhitespace(line.replace(/^-+\s*/, ""));
  if (/^<!--[\s\S]*-->$/.test(cleaned) || cleaned.startsWith("<!--")) {
    return null;
  }
  if (/<\/?[a-z][^>]*>/i.test(cleaned)) {
    return null;
  }
  const boldMatch = /^\*\*([^*]+)\*\*:\s*(.+)$/.exec(cleaned);
  if (boldMatch) {
    return {
      key: normalizeWhitespace(boldMatch[1]),
      value: normalizeWhitespace(boldMatch[2]),
    };
  }

  const plainMatch = /^([^:#|]{2,48}):\s*(.+)$/.exec(cleaned);
  if (!plainMatch) {
    return null;
  }

  const key = normalizeWhitespace(plainMatch[1]);
  const value = normalizeWhitespace(plainMatch[2]);
  if (!key || !value || key.length > 48) {
    return null;
  }

  if (/[.]{2,}/.test(key) || /\b(section|chapter)\b/i.test(key)) {
    return null;
  }

  return { key, value };
}

function extractFieldsFromLines(lines: string[]) {
  const fields: ParsedField[] = [];
  const remaining: string[] = [];

  lines.forEach((line) => {
    const field = parseFieldLine(line);
    if (field) {
      fields.push(field);
      return;
    }
    remaining.push(line);
  });

  return { fields, remaining };
}

function renderFieldsGrid(fields: ParsedField[]) {
  if (!fields.length) {
    return "";
  }

  return `<div class="dekai-card-grid">${fields
    .map(
      (field) => `<div class="dekai-info-card">
  <span class="dekai-info-label">${escapeHtml(field.key)}</span>
  <strong class="dekai-info-value">${escapeHtml(field.value)}</strong>
</div>`,
    )
    .join("")}</div>`;
}

function renderSectionBody(sectionMarkdown: string) {
  const trimmed = stripViewerOnlySubsections(sectionMarkdown).trim();
  if (!trimmed) {
    return "";
  }

  return `<div class="dekai-rich-text">${renderMarkdownToHtml(trimmed)}</div>`;
}

function renderSectionTables(
  sectionMarkdown: string,
  globalTableIds: string[],
  tableCursor: { value: number },
  heading: string,
) {
  const matches = extractTablesFromMarkdown(sectionMarkdown, { includePipeFallback: false });
  const tableIds: string[] = [];
  const tablesHtml: string[] = [];
  const replacements: Array<{ start: number; end: number; content: string }> = [];

  matches.forEach((match, index) => {
    const tableId = globalTableIds[tableCursor.value] ?? `table-${tableCursor.value + 1}`;
    tableCursor.value += 1;
    tableIds.push(tableId);
    replacements.push({ start: match.start, end: match.end, content: "" });
    tablesHtml.push(`<section class="dekai-table-section" data-table-id="${escapeHtml(tableId)}">
  <div class="dekai-table-header">
    <span class="dekai-section-kicker">Professional Table</span>
    <h4>${escapeHtml(`${heading} Table ${index + 1}`)}</h4>
  </div>
  <div class="dekai-table-shell">${serializeTableToHtml({ ...match.table, id: tableId })}</div>
</section>`);
  });

  return {
    sectionMarkdown: replaceTablesInMarkdown(sectionMarkdown, replacements),
    tableIds,
    tablesHtml,
  };
}

function renderSection(
  heading: string,
  level: number,
  content: string,
  documentType: DocumentType,
  globalTableIds: string[],
  tableCursor: { value: number },
): ParsedSection {
  const { sectionMarkdown: markdownWithoutTables, tableIds, tablesHtml } = renderSectionTables(content, globalTableIds, tableCursor, heading);
  const sanitizedMarkdown = stripViewerOnlySubsections(markdownWithoutTables);
  const lines = sanitizedMarkdown.replace(/\r\n/g, "\n").split("\n");
  const { fields, remaining } = extractFieldsFromLines(lines);
  const sectionWithoutFieldLines = remaining.join("\n").trim();
  const bodyHtml = renderSectionBody(sectionWithoutFieldLines);
  const kind = inferSectionKind(heading, documentType, Boolean(tableIds.length));

  return {
    bodyHtml,
    fields,
    heading,
    id: `dekai-section-${slugify(heading)}`,
    kind,
    level,
    tableIds,
    tablesHtml,
  };
}

function renderHero(documentType: DocumentType, title: string, sections: ParsedSection[]) {
  const fieldCount = sections.reduce((count, section) => count + section.fields.length, 0);
  const tableCount = sections.reduce((count, section) => count + section.tableIds.length, 0);

  return `<header class="dekai-doc-hero">
  <div class="dekai-doc-hero-copy">
    <span class="dekai-doc-badge">${escapeHtml(documentType.replaceAll("-", " "))}</span>
    <h1>${escapeHtml(title)}</h1>
    <p>DEKAI converted the intermediate markdown into a structured HTML document with semantic sections, information cards, and responsive business tables.</p>
  </div>
  <div class="dekai-doc-hero-stats">
    <div class="dekai-doc-stat">
      <span>Sections</span>
      <strong>${sections.length}</strong>
    </div>
    <div class="dekai-doc-stat">
      <span>Fields</span>
      <strong>${fieldCount}</strong>
    </div>
    <div class="dekai-doc-stat">
      <span>Tables</span>
      <strong>${tableCount}</strong>
    </div>
  </div>
</header>`;
}

function renderParsedSection(section: ParsedSection) {
  return `<article class="dekai-doc-section dekai-doc-section--${escapeHtml(section.kind)}" id="${escapeHtml(section.id)}">
  <header class="dekai-doc-section-head">
    <div>
      <span class="dekai-section-kicker">${escapeHtml(section.kind.replaceAll("-", " "))}</span>
      <h2>${escapeHtml(section.heading)}</h2>
    </div>
    <div class="dekai-doc-section-meta">
      ${section.fields.length ? `<span>${section.fields.length} fields</span>` : ""}
      ${section.tableIds.length ? `<span>${section.tableIds.length} table${section.tableIds.length === 1 ? "" : "s"}</span>` : ""}
    </div>
  </header>
  ${renderFieldsGrid(section.fields)}
  ${section.tablesHtml.join("")}
  ${section.bodyHtml}
</article>`;
}

function buildDocumentStyles() {
  return `<section class="dekai-doc-shell">
  <div class="dekai-doc-stack">%CONTENT%</div>
</section>`;
}

function countTags(source: string) {
  const matches = source.match(/<\/?[a-zA-Z][\w:-]*\b[^>]*>/g) ?? [];
  return matches.length;
}

function sanitizeDocumentBodyHtml(bodyHtml: string) {
  return bodyHtml
    .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gis, "")
    .replace(/<(iframe|object|embed|form|meta|base)\b[^>]*>[\s\S]*?<\/\1>/gis, "")
    .replace(/<(iframe|object|embed|form|meta|base)\b[^>]*\/?>/gi, "")
    .replace(/\s+on[a-z]+\s*=\s*(".*?"|'.*?'|[^\s>]+)/gis, "")
    .replace(/\s+(href|src)\s*=\s*("javascript:[^"]*"|'javascript:[^']*'|javascript:[^\s>]+)/gis, "");
}

export function buildRenderedDocumentHtml(documentModel: ProfessionalDocumentModel, options: RenderedDocumentHtmlOptions = {}) {
  const pageWidth = options.pageWidth ?? "1080px";
  const zoom = options.zoom ?? 1;
  const bodyHtml = options.sanitize ? sanitizeDocumentBodyHtml(documentModel.bodyHtml) : documentModel.bodyHtml;

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
        ${bodyHtml}
      </div>
    </div>
  </body>
</html>`;
}

export function buildProfessionalDocument(markdown: string, titleFallback: string, globalTableIds: string[] = []): ProfessionalDocumentModel {
  const title = parseDocumentTitle(markdown, titleFallback);
  const documentType = detectDocumentType(markdown, title);
  const sections = splitMarkdownSections(markdown);
  const tableCursor = { value: 0 };
  const parsedSections = sections.map((section) =>
    renderSection(section.heading, section.level, section.content, documentType, globalTableIds, tableCursor),
  );

  const headings = parsedSections.map((section) => ({
    id: section.id,
    label: section.heading,
    level: section.level,
  }));
  const tables = parsedSections.flatMap((section) =>
    section.tableIds.map((tableId, index) => ({
      id: tableId,
      label: `${section.heading} Table ${index + 1}`,
    })),
  );

  const content = [
    renderHero(documentType, title, parsedSections),
    `<main class="dekai-doc-main">${parsedSections.map(renderParsedSection).join("")}</main>`,
    `<footer class="dekai-doc-footer">
  <span>Intermediate markdown hidden from the end-user view.</span>
  <span>Rendered as a professional HTML document in DEKAI.</span>
</footer>`,
  ].join("");

  const bodyHtml = buildDocumentStyles().replace("%CONTENT%", content);

  return {
    bodyHtml,
    documentType,
    headings,
    htmlTagCount: countTags(bodyHtml),
    sectionCount: parsedSections.length,
    tables,
    title,
  };
}
