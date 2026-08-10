import {
  ArrowLeftRight,
  ChevronDown,
  ChevronLeft,
  ChevronRight,
  ChevronUp,
  Clipboard,
  Columns2,
  Copy,
  Eye,
  FileCode2,
  Grid2x2,
  Redo2,
  Rows3,
  Save,
  Trash2,
  Undo2,
  X,
} from "lucide-react";
import { useEffect, useState } from "react";
import {
  cloneEditableTable,
  createEmptyRow,
  extractTablesFromMarkdown,
  normalizeRowIds,
  serializeTableForSourceFormat,
  serializeTableToHtml,
  parseHtmlTable,
  replaceTablesInMarkdown,
  validateTableHtmlSource,
  type DetectedTableMatch,
  type EditableTable,
  type ExtractTablesOptions,
  type TableSourceFormat,
} from "../lib/html-table-editor";
import { Badge, Button } from "./ui";

type HtmlTableEditorModalProps = {
  fileName: string;
  initialTableId?: string | null;
  isOpen: boolean;
  markdown: string;
  onClose: () => void;
  onSave: (markdown: string) => void;
  tableExtractionOptions?: ExtractTablesOptions;
};

type EditorTab = "grid" | "html" | "preview" | "markdown";

type TableSnapshot = {
  html: string;
  source: string;
  table: EditableTable;
};

type TableDraft = {
  currentHtml: string;
  currentSource: string;
  hadMergedCells: boolean;
  history: TableSnapshot[];
  historyIndex: number;
  htmlSource: string;
  id: string;
  index: number;
  originalSource: string;
  start: number;
  end: number;
  sourceFormat: TableSourceFormat;
  table: EditableTable;
};

type GridCellPosition = {
  row: number;
  col: number;
};

type GridSelection = {
  startRow: number;
  endRow: number;
  startCol: number;
  endCol: number;
};

function createDraft(match: DetectedTableMatch): TableDraft {
  const html = serializeTableToHtml(match.table);
  const source = serializeTableForSourceFormat(match.table, match.sourceFormat);
  return {
    currentHtml: html,
    currentSource: source,
    hadMergedCells: match.table.hadMergedCells,
    history: [{ html, source, table: cloneEditableTable(match.table) }],
    historyIndex: 0,
    htmlSource: html,
    id: match.id,
    index: match.index,
    originalSource: match.source,
    start: match.start,
    end: match.end,
    sourceFormat: match.sourceFormat,
    table: cloneEditableTable(match.table),
  };
}

function buildSelection(anchor: GridCellPosition, focus: GridCellPosition): GridSelection {
  return {
    startRow: Math.min(anchor.row, focus.row),
    endRow: Math.max(anchor.row, focus.row),
    startCol: Math.min(anchor.col, focus.col),
    endCol: Math.max(anchor.col, focus.col),
  };
}

function isSelected(selection: GridSelection | null, rowIndex: number, colIndex: number) {
  if (!selection) {
    return false;
  }
  return (
    rowIndex >= selection.startRow &&
    rowIndex <= selection.endRow &&
    colIndex >= selection.startCol &&
    colIndex <= selection.endCol
  );
}

function pushDraftSnapshot(draft: TableDraft, table: EditableTable, html: string): TableDraft {
  const source = serializeTableForSourceFormat(table, draft.sourceFormat);
  const snapshot = {
    html,
    source,
    table: cloneEditableTable(table),
  };
  const history = draft.history.slice(0, draft.historyIndex + 1).concat(snapshot);
  return {
    ...draft,
    currentHtml: html,
    currentSource: source,
    history,
    historyIndex: history.length - 1,
    htmlSource: html,
    table: cloneEditableTable(table),
  };
}

function addColumn(table: EditableTable, columnIndex: number | null) {
  const insertAt = columnIndex === null ? table.rows[0]?.cells.length ?? 0 : columnIndex + 1;
  const nextTable = cloneEditableTable(table);
  nextTable.rows = nextTable.rows.map((row, rowIndex) => {
    const nextCells = row.cells.slice();
    const shouldBeHeader = rowIndex === 0 && row.cells.every((cell) => cell.isHeader);
    nextCells.splice(insertAt, 0, { value: "", isHeader: shouldBeHeader });
    return { ...row, cells: nextCells };
  });
  return nextTable;
}

function deleteColumn(table: EditableTable, columnIndex: number) {
  const nextTable = cloneEditableTable(table);
  nextTable.rows = nextTable.rows.map((row) => ({
    ...row,
    cells: row.cells.filter((_, index) => index !== columnIndex),
  }));
  return nextTable;
}

function moveColumn(table: EditableTable, columnIndex: number, direction: -1 | 1) {
  const targetIndex = columnIndex + direction;
  if (targetIndex < 0 || targetIndex >= (table.rows[0]?.cells.length ?? 0)) {
    return table;
  }

  const nextTable = cloneEditableTable(table);
  nextTable.rows = nextTable.rows.map((row) => {
    const nextCells = row.cells.slice();
    const [moved] = nextCells.splice(columnIndex, 1);
    nextCells.splice(targetIndex, 0, moved);
    return { ...row, cells: nextCells };
  });
  return nextTable;
}

function moveRow(table: EditableTable, rowIndex: number, direction: -1 | 1) {
  const targetIndex = rowIndex + direction;
  if (targetIndex < 0 || targetIndex >= table.rows.length) {
    return table;
  }

  const nextRows = table.rows.slice();
  const [moved] = nextRows.splice(rowIndex, 1);
  nextRows.splice(targetIndex, 0, moved);
  return normalizeRowIds({ ...table, rows: nextRows });
}

function addRow(table: EditableTable, rowIndex: number | null) {
  const insertAt = rowIndex === null ? table.rows.length : rowIndex + 1;
  const columnCount = table.rows[0]?.cells.length ?? 1;
  const nextRows = table.rows.slice();
  nextRows.splice(insertAt, 0, createEmptyRow(columnCount, false, insertAt));
  return normalizeRowIds({ ...table, rows: nextRows });
}

function deleteRow(table: EditableTable, rowIndex: number) {
  const nextRows = table.rows.filter((_, index) => index !== rowIndex);
  return normalizeRowIds({ ...table, rows: nextRows });
}

function pasteTabularData(table: EditableTable, start: GridCellPosition, content: string) {
  const rows = content
    .replace(/\r\n/g, "\n")
    .split("\n")
    .filter((line, index, all) => !(index === all.length - 1 && line === ""))
    .map((line) => line.split("\t"));

  if (!rows.length) {
    return table;
  }

  const nextTable = cloneEditableTable(table);
  const requiredRowCount = start.row + rows.length;
  while (nextTable.rows.length < requiredRowCount) {
    nextTable.rows.push(createEmptyRow(nextTable.rows[0]?.cells.length ?? 1, false, nextTable.rows.length));
  }

  rows.forEach((rowValues, rowOffset) => {
    const targetRowIndex = start.row + rowOffset;
    const targetRow = nextTable.rows[targetRowIndex];
    const requiredColumnCount = start.col + rowValues.length;

    while (targetRow.cells.length < requiredColumnCount) {
      targetRow.cells.push({ value: "", isHeader: false });
    }

    rowValues.forEach((value, colOffset) => {
      targetRow.cells[start.col + colOffset].value = value;
    });
  });

  return normalizeRowIds(nextTable);
}

function selectionToClipboardText(table: EditableTable, selection: GridSelection) {
  const lines: string[] = [];
  for (let rowIndex = selection.startRow; rowIndex <= selection.endRow; rowIndex += 1) {
    const values: string[] = [];
    for (let colIndex = selection.startCol; colIndex <= selection.endCol; colIndex += 1) {
      values.push(table.rows[rowIndex]?.cells[colIndex]?.value ?? "");
    }
    lines.push(values.join("\t"));
  }
  return lines.join("\n");
}

function restoreDraftSnapshot(draft: TableDraft, direction: -1 | 1) {
  const nextIndex = draft.historyIndex + direction;
  if (nextIndex < 0 || nextIndex >= draft.history.length) {
    return draft;
  }
  const snapshot = draft.history[nextIndex];
  return {
    ...draft,
    currentHtml: snapshot.html,
    currentSource: snapshot.source,
    historyIndex: nextIndex,
    htmlSource: snapshot.html,
    table: cloneEditableTable(snapshot.table),
  };
}

export function HtmlTableEditorModal({
  fileName,
  initialTableId = null,
  isOpen,
  markdown,
  onClose,
  onSave,
  tableExtractionOptions,
}: HtmlTableEditorModalProps) {
  const [drafts, setDrafts] = useState<TableDraft[]>([]);
  const [selectedTableId, setSelectedTableId] = useState("");
  const [activeTab, setActiveTab] = useState<EditorTab>("grid");
  const [activeCell, setActiveCell] = useState<GridCellPosition | null>(null);
  const [selection, setSelection] = useState<GridSelection | null>(null);
  const [statusMessage, setStatusMessage] = useState("");
  const [errorMessage, setErrorMessage] = useState("");

  useEffect(() => {
    if (!isOpen) {
      return;
    }

    const matches = extractTablesFromMarkdown(markdown, tableExtractionOptions);
    const nextDrafts = matches.map(createDraft);
    setDrafts(nextDrafts);
    setSelectedTableId(nextDrafts.find((draft) => draft.id === initialTableId)?.id ?? nextDrafts[0]?.id ?? "");
    setActiveCell(null);
    setSelection(null);
    setStatusMessage("");
    setErrorMessage("");
    setActiveTab("grid");
  }, [initialTableId, isOpen, markdown, tableExtractionOptions]);

  if (!isOpen) {
    return null;
  }

  const selectedDraft = drafts.find((draft) => draft.id === selectedTableId) ?? null;
  const currentMarkdown = replaceTablesInMarkdown(
    markdown,
    drafts.map((draft) => ({
      start: draft.start,
      end: draft.end,
      content: draft.currentSource,
    })),
  );

  const updateDraft = (tableId: string, updater: (draft: TableDraft) => TableDraft) => {
    setDrafts((currentDrafts) => currentDrafts.map((draft) => (draft.id === tableId ? updater(draft) : draft)));
  };

  const updateSelectedTable = (transform: (table: EditableTable) => EditableTable) => {
    if (!selectedDraft) {
      return;
    }

    updateDraft(selectedDraft.id, (draft) => {
      const nextTable = normalizeRowIds(transform(cloneEditableTable(draft.table)));
      return pushDraftSnapshot(draft, nextTable, serializeTableToHtml(nextTable));
    });
    setErrorMessage("");
    setStatusMessage("Table updated.");
  };

  const applyHtmlSource = (draft: TableDraft) => {
    try {
      const normalizedHtml = validateTableHtmlSource(draft.htmlSource);
      const nextTable = parseHtmlTable(normalizedHtml, draft.id);
      updateDraft(draft.id, (currentDraft) => pushDraftSnapshot(currentDraft, nextTable, normalizedHtml));
      setErrorMessage("");
      setStatusMessage("HTML source applied.");
    } catch (error) {
      setStatusMessage("");
      setErrorMessage(error instanceof Error ? error.message : "Unable to apply the HTML source.");
    }
  };

  const handleSave = () => {
    try {
      let nextDrafts = drafts.slice();

      nextDrafts.forEach((draft) => {
        if (draft.htmlSource !== draft.currentHtml) {
          const normalizedHtml = validateTableHtmlSource(draft.htmlSource);
          const nextTable = parseHtmlTable(normalizedHtml, draft.id);
          nextDrafts = nextDrafts.map((currentDraft) =>
            currentDraft.id === draft.id ? pushDraftSnapshot(currentDraft, nextTable, normalizedHtml) : currentDraft,
          );
        }
      });

      const nextMarkdown = replaceTablesInMarkdown(
        markdown,
        nextDrafts.map((draft) => ({
          start: draft.start,
          end: draft.end,
          content: draft.currentSource,
        })),
      );

      setDrafts(nextDrafts);
      setErrorMessage("");
      setStatusMessage("Updated markdown saved.");
      onSave(nextMarkdown);
    } catch (error) {
      setStatusMessage("");
      setErrorMessage(error instanceof Error ? error.message : "Unable to save the edited markdown.");
    }
  };

  const copyMarkdown = async () => {
    try {
      await navigator.clipboard.writeText(currentMarkdown);
      setErrorMessage("");
      setStatusMessage("Updated markdown copied.");
    } catch {
      setStatusMessage("");
      setErrorMessage("Clipboard access is unavailable in this browser.");
    }
  };

  const copySelection = async () => {
    if (!selectedDraft || !selection) {
      return;
    }

    try {
      await navigator.clipboard.writeText(selectionToClipboardText(selectedDraft.table, selection));
      setErrorMessage("");
      setStatusMessage("Selected cells copied.");
    } catch {
      setStatusMessage("");
      setErrorMessage("Clipboard access is unavailable in this browser.");
    }
  };

  const pasteSelection = async () => {
    if (!selectedDraft || !activeCell) {
      return;
    }

    try {
      const clipboardText = await navigator.clipboard.readText();
      updateSelectedTable((table) => pasteTabularData(table, activeCell, clipboardText));
      setStatusMessage("Clipboard data pasted into the table.");
    } catch {
      setStatusMessage("");
      setErrorMessage("Clipboard read is unavailable in this browser.");
    }
  };

  const tabButtonClass = (tab: EditorTab) =>
    activeTab === tab
      ? "border-[var(--accent)] bg-[var(--accent)] text-[var(--accent-foreground)]"
      : "border-[var(--border)] bg-[var(--panel-subtle)] text-[var(--muted-foreground)]";

  return (
    <div className="fixed inset-0 z-[80] bg-[rgba(6,10,9,0.72)] p-3 backdrop-blur-sm sm:p-5">
      <div className="flex h-full flex-col overflow-hidden rounded-[2rem] border border-[var(--border)] bg-[var(--background)] shadow-[0_30px_80px_rgba(0,0,0,0.28)]">
        <div className="flex flex-wrap items-center justify-between gap-3 border-b border-[var(--border)] px-5 py-4 sm:px-6">
          <div>
            <div className="flex flex-wrap items-center gap-2">
              <Badge tone="info">HTML Table Editor</Badge>
              <Badge>{fileName}</Badge>
              <Badge tone="success">Session persisted</Badge>
            </div>
            <h2 className="mt-3 text-2xl font-semibold text-[var(--foreground)]">Edit detected tables without touching the rest of the Markdown</h2>
          </div>

          <div className="flex flex-wrap items-center gap-2">
            <Button onClick={() => void copyMarkdown()} size="sm" type="button" variant="ghost">
              <Copy className="h-4 w-4" />
              Copy Markdown
            </Button>
            <Button onClick={handleSave} size="sm" type="button">
              <Save className="h-4 w-4" />
              Save Changes
            </Button>
            <Button onClick={onClose} size="sm" type="button" variant="ghost">
              <X className="h-4 w-4" />
              Close
            </Button>
          </div>
        </div>

        <div className="grid min-h-0 flex-1 gap-4 p-4 lg:grid-cols-[minmax(320px,0.95fr)_minmax(0,1.35fr)] lg:p-5">
          <section className="flex min-h-0 flex-col overflow-hidden rounded-[1.7rem] border border-[var(--border)] bg-[var(--panel)]">
            <div className="border-b border-[var(--border)] px-4 py-4">
              <div className="flex items-center justify-between gap-3">
                <div>
                  <p className="text-sm font-semibold text-[var(--foreground)]">Original Markdown</p>
                  <p className="mt-1 text-sm text-[var(--muted-foreground)]">The source document stays unchanged until you save.</p>
                </div>
                <Badge>{drafts.length} table{drafts.length === 1 ? "" : "s"}</Badge>
              </div>

              {drafts.length ? (
                <div className="mt-4 flex flex-wrap gap-2">
                  {drafts.map((draft) => (
                    <button
                      className={`rounded-full border px-3 py-1.5 text-xs font-semibold transition ${
                        draft.id === selectedTableId
                          ? "border-[var(--accent)] bg-[var(--accent)] text-[var(--accent-foreground)]"
                          : "border-[var(--border)] bg-[var(--panel-subtle)] text-[var(--muted-foreground)] hover:text-[var(--foreground)]"
                      }`}
                      key={draft.id}
                      onClick={() => {
                        setSelectedTableId(draft.id);
                        setActiveCell(null);
                        setSelection(null);
                        setErrorMessage("");
                        setStatusMessage("");
                      }}
                      type="button"
                    >
                      Table {draft.index + 1}
                    </button>
                  ))}
                </div>
              ) : null}
            </div>

            <pre className="min-h-0 flex-1 overflow-auto px-4 py-4 text-xs leading-6 whitespace-pre-wrap text-[var(--foreground)]">{markdown}</pre>
          </section>

          <section className="flex min-h-0 flex-col overflow-hidden rounded-[1.7rem] border border-[var(--border)] bg-[var(--panel)]">
            {selectedDraft ? (
              <>
                <div className="flex flex-wrap items-center justify-between gap-3 border-b border-[var(--border)] px-4 py-4">
                  <div>
                    <div className="flex items-center gap-2">
                      <p className="text-sm font-semibold text-[var(--foreground)]">Table {selectedDraft.index + 1}</p>
                      {selectedDraft.hadMergedCells ? <Badge tone="warning">Merged cells detected</Badge> : null}
                      <Badge>{selectedDraft.sourceFormat === "html" ? "HTML source" : "Markdown source"}</Badge>
                    </div>
                    <p className="mt-1 text-sm text-[var(--muted-foreground)]">
                      Grid edits are spreadsheet-like. If the table depends on `colspan` or `rowspan`, HTML source preserves it best. Save keeps the original table format.
                    </p>
                  </div>

                  <div className="flex flex-wrap gap-2">
                    <button className={`rounded-full border px-3 py-2 text-xs font-semibold transition ${tabButtonClass("grid")}`} onClick={() => setActiveTab("grid")} type="button">
                      <Grid2x2 className="mr-1 inline h-3.5 w-3.5" />
                      Table Grid
                    </button>
                    <button className={`rounded-full border px-3 py-2 text-xs font-semibold transition ${tabButtonClass("html")}`} onClick={() => setActiveTab("html")} type="button">
                      <FileCode2 className="mr-1 inline h-3.5 w-3.5" />
                      HTML Source
                    </button>
                    <button className={`rounded-full border px-3 py-2 text-xs font-semibold transition ${tabButtonClass("preview")}`} onClick={() => setActiveTab("preview")} type="button">
                      <Eye className="mr-1 inline h-3.5 w-3.5" />
                      Preview
                    </button>
                    <button className={`rounded-full border px-3 py-2 text-xs font-semibold transition ${tabButtonClass("markdown")}`} onClick={() => setActiveTab("markdown")} type="button">
                      <FileCode2 className="mr-1 inline h-3.5 w-3.5" />
                      Markdown
                    </button>
                  </div>
                </div>

                <div className="flex min-h-0 flex-1 flex-col">
                  {activeTab === "grid" ? (
                    <>
                      <div className="flex flex-wrap items-center gap-2 border-b border-[var(--border)] px-4 py-3">
                        <Button onClick={() => updateSelectedTable((table) => addRow(table, activeCell?.row ?? null))} size="sm" type="button" variant="secondary">
                          <Rows3 className="h-4 w-4" />
                          Add Row
                        </Button>
                        <Button onClick={() => updateSelectedTable((table) => addColumn(table, activeCell?.col ?? null))} size="sm" type="button" variant="secondary">
                          <Columns2 className="h-4 w-4" />
                          Add Column
                        </Button>
                        <Button disabled={!selection} onClick={() => void copySelection()} size="sm" type="button" variant="ghost">
                          <Copy className="h-4 w-4" />
                          Copy Selection
                        </Button>
                        <Button disabled={!activeCell} onClick={() => void pasteSelection()} size="sm" type="button" variant="ghost">
                          <Clipboard className="h-4 w-4" />
                          Paste
                        </Button>
                        <Button
                          disabled={!activeCell}
                          onClick={() => {
                            if (activeCell === null) {
                              return;
                            }
                            updateSelectedTable((table) => {
                              const nextTable = cloneEditableTable(table);
                              const cell = nextTable.rows[activeCell.row]?.cells[activeCell.col];
                              if (!cell) {
                                return table;
                              }
                              cell.isHeader = !cell.isHeader;
                              return nextTable;
                            });
                          }}
                          size="sm"
                          type="button"
                          variant="ghost"
                        >
                          <ArrowLeftRight className="h-4 w-4" />
                          Toggle Header Cell
                        </Button>
                        <Button disabled={selectedDraft.historyIndex === 0} onClick={() => updateDraft(selectedDraft.id, (draft) => restoreDraftSnapshot(draft, -1))} size="sm" type="button" variant="ghost">
                          <Undo2 className="h-4 w-4" />
                          Undo
                        </Button>
                        <Button
                          disabled={selectedDraft.historyIndex >= selectedDraft.history.length - 1}
                          onClick={() => updateDraft(selectedDraft.id, (draft) => restoreDraftSnapshot(draft, 1))}
                          size="sm"
                          type="button"
                          variant="ghost"
                        >
                          <Redo2 className="h-4 w-4" />
                          Redo
                        </Button>
                      </div>

                      <div className="min-h-0 flex-1 overflow-auto p-4">
                        <div className="inline-block min-w-full overflow-hidden rounded-[1.35rem] border border-[var(--border)]">
                          <table className="min-w-full border-collapse">
                            <thead className="bg-[var(--panel-subtle)]">
                              <tr>
                                <th className="border-b border-r border-[var(--border)] px-3 py-2 text-left text-xs font-semibold uppercase tracking-[0.16em] text-[var(--muted-foreground)]">
                                  Row
                                </th>
                                {selectedDraft.table.rows[0]?.cells.map((_, columnIndex) => (
                                  <th className="min-w-[12rem] border-b border-r border-[var(--border)] px-3 py-2 align-top" key={`column-${columnIndex}`}>
                                    <div className="space-y-2">
                                      <div className="flex items-center justify-between gap-2">
                                        <span className="text-xs font-semibold uppercase tracking-[0.16em] text-[var(--muted-foreground)]">Column {columnIndex + 1}</span>
                                        <div className="flex items-center gap-1">
                                          <button className="rounded-lg border border-[var(--border)] p-1 text-[var(--muted-foreground)] transition hover:text-[var(--foreground)]" onClick={() => updateSelectedTable((table) => moveColumn(table, columnIndex, -1))} type="button">
                                            <ChevronLeft className="h-3.5 w-3.5" />
                                          </button>
                                          <button className="rounded-lg border border-[var(--border)] p-1 text-[var(--muted-foreground)] transition hover:text-[var(--foreground)]" onClick={() => updateSelectedTable((table) => moveColumn(table, columnIndex, 1))} type="button">
                                            <ChevronRight className="h-3.5 w-3.5" />
                                          </button>
                                          <button className="rounded-lg border border-rose-500/25 p-1 text-rose-500 transition hover:bg-rose-500/8" onClick={() => updateSelectedTable((table) => deleteColumn(table, columnIndex))} type="button">
                                            <Trash2 className="h-3.5 w-3.5" />
                                          </button>
                                        </div>
                                      </div>
                                    </div>
                                  </th>
                                ))}
                              </tr>
                            </thead>
                            <tbody>
                              {selectedDraft.table.rows.map((row, rowIndex) => (
                                <tr className="align-top" key={row.id}>
                                  <td className="border-b border-r border-[var(--border)] bg-[var(--panel-subtle)] px-3 py-3">
                                    <div className="space-y-2">
                                      <p className="text-xs font-semibold uppercase tracking-[0.16em] text-[var(--muted-foreground)]">Row {rowIndex + 1}</p>
                                      <div className="flex flex-wrap gap-1">
                                        <button className="rounded-lg border border-[var(--border)] p-1 text-[var(--muted-foreground)] transition hover:text-[var(--foreground)]" onClick={() => updateSelectedTable((table) => moveRow(table, rowIndex, -1))} type="button">
                                          <ChevronUp className="h-3.5 w-3.5" />
                                        </button>
                                        <button className="rounded-lg border border-[var(--border)] p-1 text-[var(--muted-foreground)] transition hover:text-[var(--foreground)]" onClick={() => updateSelectedTable((table) => moveRow(table, rowIndex, 1))} type="button">
                                          <ChevronDown className="h-3.5 w-3.5" />
                                        </button>
                                        <button className="rounded-lg border border-rose-500/25 p-1 text-rose-500 transition hover:bg-rose-500/8" onClick={() => updateSelectedTable((table) => deleteRow(table, rowIndex))} type="button">
                                          <Trash2 className="h-3.5 w-3.5" />
                                        </button>
                                      </div>
                                    </div>
                                  </td>

                                  {row.cells.map((cell, colIndex) => (
                                    <td
                                      className={`border-b border-r border-[var(--border)] p-2 transition ${
                                        isSelected(selection, rowIndex, colIndex)
                                          ? "bg-[color-mix(in_srgb,var(--accent)_14%,transparent)]"
                                          : cell.isHeader
                                          ? "bg-[var(--panel-subtle)]"
                                          : "bg-[var(--panel)]"
                                      }`}
                                      key={`${row.id}-${colIndex}`}
                                    >
                                      <textarea
                                        className={`min-h-[5.5rem] w-full resize-y rounded-2xl border px-3 py-2 text-sm leading-6 outline-none transition ${
                                          isSelected(selection, rowIndex, colIndex)
                                            ? "border-[var(--accent)] bg-[var(--panel)]"
                                            : "border-[var(--border)] bg-transparent"
                                        }`}
                                        onChange={(event) => {
                                          const value = event.target.value;
                                          updateSelectedTable((table) => {
                                            const nextTable = cloneEditableTable(table);
                                            nextTable.rows[rowIndex].cells[colIndex].value = value;
                                            return nextTable;
                                          });
                                        }}
                                        onClick={(event) => {
                                          const currentCell = { row: rowIndex, col: colIndex };
                                          if (event.shiftKey && activeCell) {
                                            setSelection(buildSelection(activeCell, currentCell));
                                          } else {
                                            setActiveCell(currentCell);
                                            setSelection(buildSelection(currentCell, currentCell));
                                          }
                                        }}
                                        onFocus={() => {
                                          const currentCell = { row: rowIndex, col: colIndex };
                                          setActiveCell(currentCell);
                                          setSelection(buildSelection(currentCell, currentCell));
                                        }}
                                        value={cell.value}
                                      />
                                    </td>
                                  ))}
                                </tr>
                              ))}
                            </tbody>
                          </table>
                        </div>
                      </div>
                    </>
                  ) : null}

                  {activeTab === "html" ? (
                    <>
                      <div className="flex flex-wrap items-center gap-2 border-b border-[var(--border)] px-4 py-3">
                        <Button onClick={() => applyHtmlSource(selectedDraft)} size="sm" type="button" variant="secondary">
                          <FileCode2 className="h-4 w-4" />
                          Apply HTML Source
                        </Button>
                        <Badge tone="info">Validated before save</Badge>
                      </div>
                      <div className="min-h-0 flex-1 p-4">
                        <textarea
                          className="h-full min-h-[24rem] w-full resize-none rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] px-4 py-4 font-mono text-sm leading-7 text-[var(--foreground)] outline-none"
                          onChange={(event) => {
                            const value = event.target.value;
                            updateDraft(selectedDraft.id, (draft) => ({ ...draft, htmlSource: value }));
                            setStatusMessage("");
                            setErrorMessage("");
                          }}
                          value={selectedDraft.htmlSource}
                        />
                      </div>
                    </>
                  ) : null}

                  {activeTab === "preview" ? (
                    <div className="min-h-0 flex-1 overflow-auto p-4">
                      <div className="overflow-auto rounded-[1.5rem] border border-[var(--border)] bg-white p-5 text-slate-900">
                        <div dangerouslySetInnerHTML={{ __html: selectedDraft.currentHtml }} />
                      </div>
                    </div>
                  ) : null}

                  {activeTab === "markdown" ? (
                    <div className="min-h-0 flex-1 overflow-auto p-4">
                      <pre className="h-full overflow-auto rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel-subtle)] px-4 py-4 text-xs leading-6 whitespace-pre-wrap text-[var(--foreground)]">
                        {currentMarkdown}
                      </pre>
                    </div>
                  ) : null}

                  <div className="border-t border-[var(--border)] px-4 py-3">
                    {errorMessage ? <p className="text-sm text-rose-600">{errorMessage}</p> : <p className="text-sm text-[var(--muted-foreground)]">{statusMessage || "Select a table and edit cells, HTML, or markdown preview."}</p>}
                  </div>
                </div>
              </>
            ) : (
              <div className="flex min-h-0 flex-1 flex-col items-center justify-center px-6 text-center">
                <div className="flex h-16 w-16 items-center justify-center rounded-[1.7rem] bg-[var(--panel-subtle)] text-[var(--accent)]">
                  <Grid2x2 className="h-7 w-7" />
                </div>
                <h2 className="mt-5 text-2xl font-semibold text-[var(--foreground)]">No editable tables were found</h2>
                <p className="mt-3 max-w-xl text-sm leading-7 text-[var(--muted-foreground)]">
                  The editor opens HTML tables, markdown tables, and pipe-delimited table blocks. Markdown text, headings, code blocks, links, and images remain untouched.
                </p>
              </div>
            )}
          </section>
        </div>
      </div>
    </div>
  );
}
