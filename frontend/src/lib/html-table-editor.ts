import MarkdownIt from "markdown-it";

export type TableCell = {
  value: string;
  isHeader: boolean;
};

export type TableRow = {
  id: string;
  cells: TableCell[];
};

export type TableSourceFormat = "html" | "markdown";

export type ExtractedHtmlElement = {
  containsTableId: string | null;
  end: number;
  name: string;
  source: string;
  start: number;
};

export type EditableTable = {
  id: string;
  attributes: Array<{ name: string; value: string }>;
  rows: TableRow[];
  hadMergedCells: boolean;
};

export type DetectedTableMatch = {
  id: string;
  index: number;
  start: number;
  end: number;
  source: string;
  sourceFormat: TableSourceFormat;
  table: EditableTable;
};

export type ExtractTablesOptions = {
  includeHtml?: boolean;
  includeMarkdown?: boolean;
  includePipeFallback?: boolean;
};

type SourceRange = {
  start: number;
  end: number;
};

type LineRange = {
  startLine: number;
  endLine: number;
};

const OPEN_TABLE_PATTERN = /<table\b[^>]*>/gi;
const CLOSE_TABLE_PATTERN = /<\/table>/gi;
const HTML_TAG_PATTERN = /<\/?(table|thead|tbody|tfoot|tr|td|th)\b[^>]*>/gi;
const markdownParser = new MarkdownIt({ html: true });
const SUPPORTED_HTML_ELEMENT_NAMES = ["table", "thead", "tbody", "tfoot", "tr", "th", "td", "div", "img", "span", "p", "ul", "ol", "li", "br", "hr", "strong", "em", "a"] as const;
const SUPPORTED_HTML_ELEMENT_SET = new Set<string>(SUPPORTED_HTML_ELEMENT_NAMES);
const VOID_HTML_ELEMENTS = new Set<string>(["img", "br", "hr"]);

function isInsideRanges(index: number, ranges: SourceRange[]) {
  return ranges.some((range) => index >= range.start && index < range.end);
}

function overlapsRanges(start: number, end: number, ranges: SourceRange[]) {
  return ranges.some((range) => start < range.end && end > range.start);
}

function lineRangeOverlaps(startLine: number, endLine: number, ranges: LineRange[]) {
  return ranges.some((range) => startLine < range.endLine && endLine > range.startLine);
}

function createRowId(index: number) {
  return `row-${index + 1}`;
}

function createEmptyCell(isHeader = false): TableCell {
  return { value: "", isHeader };
}

function decodeMarkdownCell(value: string) {
  return value.replace(/\\\|/g, "|").trim();
}

function normalizeMarkdownCellValue(value: string) {
  return value
    .replace(/\r\n/g, "\n")
    .replace(/\n/g, "<br />")
    .replace(/\|/g, "\\|")
    .trim();
}

function splitPipeRow(line: string) {
  const trimmed = line.trim();
  const body = trimmed.startsWith("|") ? trimmed.slice(1) : trimmed;
  const normalized = body.endsWith("|") ? body.slice(0, -1) : body;
  return normalized.split("|").map((cell) => decodeMarkdownCell(cell));
}

function isMarkdownSeparatorLine(line: string) {
  const cells = splitPipeRow(line);
  if (!cells.length) {
    return false;
  }
  return cells.every((cell) => /^:?-{3,}:?$/.test(cell.replace(/\s+/g, "")));
}

function buildLineOffsets(markdown: string) {
  const lines = markdown.match(/.*?(?:\r\n|\n|$)/g) ?? [];
  const offsets: number[] = [];
  let cursor = 0;

  lines.forEach((line) => {
    offsets.push(cursor);
    cursor += line.length;
  });

  return { lines, offsets };
}

function charRangeFromLines(offsets: number[], lines: string[], startLine: number, endLine: number) {
  const start = offsets[startLine] ?? 0;
  const end = endLine >= lines.length ? offsets[offsets.length - 1] + (lines[lines.length - 1]?.length ?? 0) : offsets[endLine];
  return { start, end };
}

export function cloneEditableTable(table: EditableTable): EditableTable {
  return {
    ...table,
    attributes: table.attributes.map((attribute) => ({ ...attribute })),
    rows: table.rows.map((row) => ({
      ...row,
      cells: row.cells.map((cell) => ({ ...cell })),
    })),
  };
}

function buildCodeFenceRanges(markdown: string) {
  const ranges: SourceRange[] = [];
  const lines = markdown.match(/.*?(?:\r\n|\n|$)/g) ?? [];
  let offset = 0;
  let activeFence: { marker: "`" | "~"; length: number; start: number } | null = null;

  for (const line of lines) {
    const trimmed = line.trimStart();
    const fenceMatch = /^(?<marker>`|~)\1{2,}/.exec(trimmed);
    if (fenceMatch?.groups?.marker) {
      const marker = fenceMatch.groups.marker as "`" | "~";
      const length = fenceMatch[0].length;
      if (!activeFence) {
        activeFence = { marker, length, start: offset };
      } else if (activeFence.marker === marker && length >= activeFence.length) {
        ranges.push({ start: activeFence.start, end: offset + line.length });
        activeFence = null;
      }
    }
    offset += line.length;
  }

  if (activeFence) {
    ranges.push({ start: activeFence.start, end: markdown.length });
  }

  return ranges;
}

function codeFenceLineRanges(markdown: string) {
  const charRanges = buildCodeFenceRanges(markdown);
  const { lines, offsets } = buildLineOffsets(markdown);

  return charRanges.map((range) => {
    let startLine = 0;
    let endLine = lines.length;

    for (let lineIndex = 0; lineIndex < offsets.length; lineIndex += 1) {
      const lineStart = offsets[lineIndex];
      const lineEnd = lineStart + (lines[lineIndex]?.length ?? 0);
      if (range.start >= lineStart && range.start < lineEnd) {
        startLine = lineIndex;
      }
      if (range.end > lineStart && range.end <= lineEnd) {
        endLine = lineIndex + 1;
        break;
      }
    }

    return { startLine, endLine };
  });
}

function parseTableAttributes(element: Element) {
  return Array.from(element.attributes).map((attribute) => ({
    name: attribute.name,
    value: attribute.value,
  }));
}

function fillMissingCells(rows: TableRow[], columnCount: number) {
  return rows.map((row, rowIndex) => {
    const nextCells = row.cells.slice();
    while (nextCells.length < columnCount) {
      const shouldUseHeader = rowIndex === 0 && row.cells.every((cell) => cell.isHeader);
      nextCells.push(createEmptyCell(shouldUseHeader));
    }
    return { ...row, cells: nextCells };
  });
}

export function parseHtmlTable(html: string, id = "table-1"): EditableTable {
  const parser = new DOMParser();
  const documentNode = parser.parseFromString(html, "text/html");
  const tableElement = documentNode.querySelector("table");
  if (!tableElement) {
    throw new Error("No <table> element was found.");
  }

  const rowElements = Array.from(tableElement.querySelectorAll("tr"));
  const occupancy: TableCell[][] = [];
  const rows: TableRow[] = [];
  let maxColumns = 0;
  let hadMergedCells = false;

  rowElements.forEach((rowElement, rowIndex) => {
    const rowCells: TableCell[] = occupancy[rowIndex] ? occupancy[rowIndex].slice() : [];
    let columnIndex = 0;

    while (rowCells[columnIndex]) {
      columnIndex += 1;
    }

    Array.from(rowElement.children)
      .filter((child): child is HTMLTableCellElement => child.tagName === "TD" || child.tagName === "TH")
      .forEach((cellElement) => {
        while (rowCells[columnIndex]) {
          columnIndex += 1;
        }

        const colSpan = Math.max(1, Number.parseInt(cellElement.getAttribute("colspan") || "1", 10) || 1);
        const rowSpan = Math.max(1, Number.parseInt(cellElement.getAttribute("rowspan") || "1", 10) || 1);
        const value = cellElement.innerHTML.trim();
        const isHeader = cellElement.tagName === "TH";

        if (colSpan > 1 || rowSpan > 1) {
          hadMergedCells = true;
        }

        for (let rowOffset = 0; rowOffset < rowSpan; rowOffset += 1) {
          const targetRowIndex = rowIndex + rowOffset;
          if (!occupancy[targetRowIndex]) {
            occupancy[targetRowIndex] = [];
          }

          for (let colOffset = 0; colOffset < colSpan; colOffset += 1) {
            occupancy[targetRowIndex][columnIndex + colOffset] = {
              value,
              isHeader,
            };
          }
        }

        columnIndex += colSpan;
      });

    maxColumns = Math.max(maxColumns, rowCells.length);
    rows.push({
      id: createRowId(rowIndex),
      cells: rowCells.map((cell) => ({ ...cell })),
    });
  });

  return {
    id,
    attributes: parseTableAttributes(tableElement),
    rows: fillMissingCells(rows, maxColumns),
    hadMergedCells,
  };
}

function parseRowsToEditableTable(rows: string[][], id: string, hasExplicitHeader: boolean) {
  const columnCount = rows.reduce((max, row) => Math.max(max, row.length), 0);
  const normalizedRows = rows.map((row, rowIndex) => ({
    id: createRowId(rowIndex),
    cells: Array.from({ length: columnCount }, (_, columnIndex) => ({
      value: row[columnIndex]?.trim() ?? "",
      isHeader: hasExplicitHeader && rowIndex === 0,
    })),
  }));

  return {
    id,
    attributes: [],
    rows: normalizedRows,
    hadMergedCells: false,
  };
}

function extractHtmlTables(markdown: string) {
  const matches: DetectedTableMatch[] = [];
  const codeFenceRanges = buildCodeFenceRanges(markdown);
  let searchIndex = 0;

  while (searchIndex < markdown.length) {
    OPEN_TABLE_PATTERN.lastIndex = searchIndex;
    const openMatch = OPEN_TABLE_PATTERN.exec(markdown);
    if (!openMatch) {
      break;
    }

    const start = openMatch.index;
    if (isInsideRanges(start, codeFenceRanges)) {
      searchIndex = start + openMatch[0].length;
      continue;
    }

    CLOSE_TABLE_PATTERN.lastIndex = start;
    const closeMatch = CLOSE_TABLE_PATTERN.exec(markdown);
    if (!closeMatch) {
      break;
    }

    const end = closeMatch.index + closeMatch[0].length;
    const source = markdown.slice(start, end);
    const id = `table-${matches.length + 1}`;

    try {
      matches.push({
        id,
        index: matches.length,
        start,
        end,
        source,
        sourceFormat: "html",
        table: parseHtmlTable(source, id),
      });
    } catch {
      // Skip malformed HTML tables that do not round-trip safely.
    }

    searchIndex = end;
  }

  return matches;
}

function extractMarkdownAstTables(markdown: string, excludedRanges: SourceRange[]) {
  const { lines, offsets } = buildLineOffsets(markdown);
  const matches: DetectedTableMatch[] = [];
  const tokens = markdownParser.parse(markdown, {});

  tokens.forEach((token) => {
    if (token.type !== "table_open" || !token.map) {
      return;
    }

    const [startLine, endLine] = token.map;
    const { start, end } = charRangeFromLines(offsets, lines, startLine, endLine);
    if (overlapsRanges(start, end, excludedRanges)) {
      return;
    }

    const source = markdown.slice(start, end);
    const blockRows = source
      .replace(/\r\n/g, "\n")
      .split("\n")
      .filter((line) => line.trim().length > 0);

    if (blockRows.length < 2) {
      return;
    }

    const bodyRows = blockRows.filter((_, index) => index !== 1).map(splitPipeRow);
    const id = `table-${matches.length + 1}`;
    matches.push({
      id,
      index: matches.length,
      start,
      end,
      source,
      sourceFormat: "markdown",
      table: parseRowsToEditableTable(bodyRows, id, true),
    });
  });

  return matches;
}

function looksLikePipeTableLine(line: string) {
  const pipeCount = (line.match(/\|/g) ?? []).length;
  return pipeCount >= 1 && line.trim().length > 0;
}

function extractPipeFallbackTables(markdown: string, excludedRanges: SourceRange[]) {
  const { lines, offsets } = buildLineOffsets(markdown);
  const codeFenceRanges = codeFenceLineRanges(markdown);
  const matches: DetectedTableMatch[] = [];
  let lineIndex = 0;

  while (lineIndex < lines.length) {
    const rawLine = lines[lineIndex] ?? "";
    const trimmedLine = rawLine.trim();

    if (!looksLikePipeTableLine(trimmedLine) || isMarkdownSeparatorLine(trimmedLine) || lineRangeOverlaps(lineIndex, lineIndex + 1, codeFenceRanges)) {
      lineIndex += 1;
      continue;
    }

    const startLine = lineIndex;
    const blockLines: string[] = [];

    while (lineIndex < lines.length) {
      const candidate = (lines[lineIndex] ?? "").replace(/\r?\n$/, "");
      const candidateTrimmed = candidate.trim();
      if (!looksLikePipeTableLine(candidateTrimmed) || isMarkdownSeparatorLine(candidateTrimmed) || lineRangeOverlaps(lineIndex, lineIndex + 1, codeFenceRanges)) {
        break;
      }
      blockLines.push(candidate);
      lineIndex += 1;
    }

    if (blockLines.length < 2) {
      continue;
    }

    const { start, end } = charRangeFromLines(offsets, lines, startLine, lineIndex);
    if (overlapsRanges(start, end, excludedRanges)) {
      continue;
    }

    const parsedRows = blockLines
      .map((line) => splitPipeRow(line))
      .filter((row) => row.length >= 2 && row.some((cell) => cell.length > 0));

    if (parsedRows.length < 2) {
      continue;
    }

    const id = `table-${matches.length + 1}`;
    matches.push({
      id,
      index: matches.length,
      start,
      end,
      source: markdown.slice(start, end),
      sourceFormat: "markdown",
      table: parseRowsToEditableTable(parsedRows, id, true),
    });
  }

  return matches;
}

function escapeHtml(value: string) {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

function serializeAttributes(attributes: Array<{ name: string; value: string }>) {
  if (!attributes.length) {
    return "";
  }

  return ` ${attributes
    .map((attribute) => `${attribute.name}="${escapeHtml(attribute.value)}"`)
    .join(" ")}`;
}

function withDocumentTableClass(attributes: Array<{ name: string; value: string }>) {
  const nextAttributes = attributes.map((attribute) => ({ ...attribute }));
  const classAttribute = nextAttributes.find((attribute) => attribute.name === "class");
  if (!classAttribute) {
    nextAttributes.push({ name: "class", value: "document-table" });
    return nextAttributes;
  }

  const classes = classAttribute.value
    .split(/\s+/)
    .map((token) => token.trim())
    .filter(Boolean);
  if (!classes.includes("document-table")) {
    classes.push("document-table");
  }
  classAttribute.value = classes.join(" ");
  return nextAttributes;
}

export function serializeTableToHtml(table: EditableTable) {
  const lines = [`<table${serializeAttributes(withDocumentTableClass(table.attributes))}>`];
  const headerRows = table.rows.filter((row) => row.cells.every((cell) => cell.isHeader));
  const bodyRows = table.rows.slice(headerRows.length || 0);

  if (headerRows.length) {
    lines.push("  <thead>");
    headerRows.forEach((row) => {
      lines.push("    <tr>");
      row.cells.forEach((cell) => {
        lines.push(`      <th>${cell.value}</th>`);
      });
      lines.push("    </tr>");
    });
    lines.push("  </thead>");
  }

  lines.push("  <tbody>");
  (bodyRows.length ? bodyRows : table.rows).forEach((row) => {
    lines.push("    <tr>");
    row.cells.forEach((cell) => {
      const tagName = cell.isHeader && !headerRows.length ? "th" : "td";
      lines.push(`      <${tagName}>${cell.value}</${tagName}>`);
    });
    lines.push("    </tr>");
  });
  lines.push("  </tbody>");
  lines.push("</table>");
  return lines.join("\n");
}

export function serializeTableToMarkdown(table: EditableTable) {
  if (!table.rows.length) {
    return "";
  }

  const rows = table.rows.map((row) => row.cells.map((cell) => normalizeMarkdownCellValue(cell.value)));
  const headerRow = rows[0];
  const separatorRow = headerRow.map(() => "---");
  const bodyRows = rows.slice(1);

  const lines = [
    `| ${headerRow.join(" | ")} |`,
    `| ${separatorRow.join(" | ")} |`,
    ...bodyRows.map((row) => `| ${row.join(" | ")} |`),
  ];

  return lines.join("\n");
}

export function serializeTableForSourceFormat(table: EditableTable, sourceFormat: TableSourceFormat) {
  return sourceFormat === "html" ? serializeTableToHtml(table) : serializeTableToMarkdown(table);
}

export function renderMarkdownToHtml(markdown: string) {
  return markdownParser.render(markdown);
}

export function countSupportedHtmlTags(source: string, options?: { treatAsHtml?: boolean }) {
  const codeFenceRanges = options?.treatAsHtml ? [] : buildCodeFenceRanges(source);
  const matcher = /<\/?([a-zA-Z][\w:-]*)\b[^>]*>/g;
  let count = 0;
  let match: RegExpExecArray | null;

  while ((match = matcher.exec(source))) {
    if (isInsideRanges(match.index, codeFenceRanges)) {
      continue;
    }
    if (SUPPORTED_HTML_ELEMENT_SET.has(match[1].toLowerCase())) {
      count += 1;
    }
  }

  return count;
}

export function extractTablesFromMarkdown(markdown: string, options: ExtractTablesOptions = {}) {
  const includeHtml = options.includeHtml ?? true;
  const includeMarkdown = options.includeMarkdown ?? true;
  const includePipeFallback = options.includePipeFallback ?? true;
  const htmlMatches = includeHtml ? extractHtmlTables(markdown) : [];
  const htmlRanges = htmlMatches.map((match) => ({ start: match.start, end: match.end }));
  const markdownMatches = includeMarkdown ? extractMarkdownAstTables(markdown, htmlRanges) : [];
  const markdownRanges = markdownMatches.map((match) => ({ start: match.start, end: match.end }));
  const fallbackMatches = includePipeFallback ? extractPipeFallbackTables(markdown, htmlRanges.concat(markdownRanges)) : [];

  return htmlMatches
    .concat(markdownMatches, fallbackMatches)
    .sort((left, right) => left.start - right.start)
    .map((match, index) => ({
      ...match,
      id: `table-${index + 1}`,
      index,
      table: {
        ...match.table,
        id: `table-${index + 1}`,
        rows: match.table.rows.map((row, rowIndex) => ({
          ...row,
          id: createRowId(rowIndex),
        })),
      },
    }));
}

function findClosingHtmlElementEnd(source: string, tagName: string, startIndex: number) {
  const matcher = new RegExp(`<\\/?${tagName}\\b[^>]*>`, "gi");
  matcher.lastIndex = startIndex;
  let depth = 0;
  let match: RegExpExecArray | null;

  while ((match = matcher.exec(source))) {
    const raw = match[0];
    const isClosing = raw.startsWith("</");
    const isSelfClosing = raw.endsWith("/>");

    if (!isClosing) {
      depth += 1;
      if (isSelfClosing) {
        depth -= 1;
      }
    } else {
      depth -= 1;
      if (depth === 0) {
        return matcher.lastIndex;
      }
    }
  }

  return startIndex;
}

export function extractHtmlElementsFromMarkdown(markdown: string, tables = extractTablesFromMarkdown(markdown), htmlSource?: string) {
  const elements: ExtractedHtmlElement[] = [];
  const source = htmlSource ?? markdown;
  const codeFenceRanges = htmlSource ? [] : buildCodeFenceRanges(markdown);
  const elementMatcher = /<([a-zA-Z][\w:-]*)(\s[^<>]*?)?(\/?)>/g;
  const tableMatchesInOrder = tables.filter((table) => table.sourceFormat === "html" || table.sourceFormat === "markdown");
  let renderedTableIndex = 0;

  let match: RegExpExecArray | null;
  while ((match = elementMatcher.exec(source))) {
    const start = match.index;
    if (isInsideRanges(start, codeFenceRanges)) {
      continue;
    }

    const sourceName = match[1].toLowerCase();
    if (!SUPPORTED_HTML_ELEMENT_SET.has(sourceName)) {
      continue;
    }

    const raw = match[0];
    const end = VOID_HTML_ELEMENTS.has(sourceName) || raw.endsWith("/>")
      ? elementMatcher.lastIndex
      : findClosingHtmlElementEnd(source, sourceName, start);

    if (end <= start) {
      continue;
    }

    const sourceSlice = source.slice(start, end);
    const containingTable = htmlSource
      ? (sourceName === "table" ? tableMatchesInOrder[renderedTableIndex] ?? null : null)
      : tables.find((table) => table.sourceFormat === "html" && start >= table.start && end <= table.end) ?? null;

    elements.push({
      containsTableId: sourceName === "table" ? containingTable?.id ?? null : null,
      end,
      name: sourceName,
      source: sourceSlice,
      start,
    });

    if (sourceName === "table") {
      renderedTableIndex += 1;
    }
  }

  if (htmlSource && source.trim().length > 0) {
    return [
      {
        containsTableId: null,
        end: source.length,
        name: "document",
        source,
        start: 0,
      },
      ...elements,
    ];
  }

  return elements;
}

export function replaceTablesInMarkdown(markdown: string, replacements: Array<{ start: number; end: number; content: string }>) {
  if (!replacements.length) {
    return markdown;
  }

  const sorted = replacements.slice().sort((left, right) => left.start - right.start);
  let output = "";
  let cursor = 0;

  sorted.forEach((replacement) => {
    output += markdown.slice(cursor, replacement.start);
    output += replacement.content;
    cursor = replacement.end;
  });

  output += markdown.slice(cursor);
  return output;
}

export function validateTableHtmlSource(html: string) {
  const trimmed = html.trim();
  if (!trimmed) {
    throw new Error("HTML source cannot be empty.");
  }

  const stack: string[] = [];
  let seenTable = false;
  let match: RegExpExecArray | null;

  HTML_TAG_PATTERN.lastIndex = 0;
  while ((match = HTML_TAG_PATTERN.exec(trimmed))) {
    const raw = match[0];
    const tagName = match[1].toLowerCase();
    const isClosing = raw.startsWith("</");

    if (!isClosing) {
      if (tagName === "table") {
        seenTable = true;
      }
      stack.push(tagName);
      continue;
    }

    const top = stack.pop();
    if (top !== tagName) {
      throw new Error(`Malformed HTML: expected </${top ?? "unknown"}> before </${tagName}>.`);
    }
  }

  if (!seenTable) {
    throw new Error("The HTML source must include one <table> element.");
  }

  if (stack.length) {
    throw new Error(`Malformed HTML: missing closing tag for <${stack[stack.length - 1]}>.`);
  }

  const parser = new DOMParser();
  const documentNode = parser.parseFromString(trimmed, "text/html");
  const tableElement = documentNode.querySelector("table");
  if (!tableElement) {
    throw new Error("The HTML source must include one <table> element.");
  }

  if (!tableElement.querySelector("tr")) {
    throw new Error("The table must include at least one row.");
  }

  return tableElement.outerHTML;
}

export function createEmptyRow(columnCount: number, header = false, rowIndex = 0): TableRow {
  return {
    id: createRowId(rowIndex),
    cells: Array.from({ length: columnCount }, () => createEmptyCell(header)),
  };
}

export function normalizeRowIds(table: EditableTable): EditableTable {
  return {
    ...table,
    rows: table.rows.map((row, rowIndex) => ({
      ...row,
      id: createRowId(rowIndex),
    })),
  };
}
