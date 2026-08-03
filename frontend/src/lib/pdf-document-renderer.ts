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
  const trimmed = sectionMarkdown.trim();
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
  const matches = extractTablesFromMarkdown(sectionMarkdown);
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
  const lines = content.replace(/\r\n/g, "\n").split("\n");
  const { fields, remaining } = extractFieldsFromLines(lines);
  const sectionWithoutFieldLines = remaining.join("\n").trim();
  const { sectionMarkdown, tableIds, tablesHtml } = renderSectionTables(sectionWithoutFieldLines, globalTableIds, tableCursor, heading);
  const bodyHtml = renderSectionBody(sectionMarkdown);
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
  ${section.bodyHtml}
  ${section.tablesHtml.join("")}
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
