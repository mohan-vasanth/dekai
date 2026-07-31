import { promises as fs } from "node:fs";
import path from "node:path";

const appRoot = path.resolve(import.meta.dirname, "..");
const repoRoot = path.resolve(appRoot, "..");

const safeReadJson = async (filePath, fallback = null) => {
  try {
    return JSON.parse(await fs.readFile(filePath, "utf8"));
  } catch {
    return fallback;
  }
};

const listJsonFiles = async (dirPath) => {
  try {
    const entries = await fs.readdir(dirPath, { withFileTypes: true });
    return entries
      .filter((entry) => entry.isFile() && entry.name.endsWith(".json"))
      .map((entry) => path.join(dirPath, entry.name));
  } catch {
    return [];
  }
};

const cleanText = (value, limit = 180) => {
  if (!value) return "";
  const normalized = String(value).replace(/\s+/g, " ").trim();
  return normalized.length > limit ? `${normalized.slice(0, limit - 1)}…` : normalized;
};

const unique = (values) => [...new Set(values.filter(Boolean))];

const reportDir = path.join(repoRoot, "output", "reports");
const jsonDir = path.join(repoRoot, "output", "json");
const workflowDir = path.join(repoRoot, "output", "workflows");
const glossaryDir = path.join(repoRoot, "output", "glossary");
const inputPdfDir = path.join(repoRoot, "input", "pdf");

const masterReport = await safeReadJson(path.join(reportDir, "master_report.json"), {});
const chapterReports = await safeReadJson(path.join(reportDir, "chapter_reports.json"), []);
const reportFiles = (await listJsonFiles(reportDir)).filter((filePath) => {
  const name = path.basename(filePath);
  return name.endsWith("_report.json");
});
const sectionFiles = await listJsonFiles(jsonDir);
const workflowFiles = await listJsonFiles(workflowDir);
const glossaryFiles = (await listJsonFiles(glossaryDir)).filter((filePath) =>
  filePath.endsWith("_glossary.json"),
);

const pdfEntries = await fs.readdir(inputPdfDir, { withFileTypes: true }).catch(() => []);
const pdfFiles = pdfEntries.filter((entry) => entry.isFile() && entry.name.endsWith(".pdf"));

const reportByDocument = new Map();
for (const reportFile of reportFiles) {
  const report = await safeReadJson(reportFile, null);
  if (report?.summary?.source_pdf) {
    reportByDocument.set(report.summary.source_pdf, report);
  }
}

const chapterByDocument = new Map();
masterReport.source_documents?.forEach((documentName, index) => {
  const chapter = masterReport.chapters?.[index];
  if (chapter) {
    chapterByDocument.set(documentName, chapter);
  }
});

const documents = [];
for (const entry of pdfFiles) {
  const absolutePath = path.join(inputPdfDir, entry.name);
  const stat = await fs.stat(absolutePath);
  const report = reportByDocument.get(entry.name);
  const chapter = chapterByDocument.get(entry.name);
  const pageCount = Math.max(
    ...(chapter?.sections?.flatMap((section) => section.pages || []) || [0]),
  );

  documents.push({
    id: entry.name.replace(/[^a-zA-Z0-9]+/g, "-").toLowerCase(),
    name: entry.name,
    version: "2026.07",
    pages: pageCount,
    sections: report?.summary?.section_count ?? 0,
    rules: report?.summary?.rule_count ?? 0,
    conditions: report?.summary?.condition_count ?? 0,
    exceptions: report?.summary?.exception_count ?? 0,
    authorities: report?.summary?.authority_count ?? 0,
    workflows: report?.summary?.workflow_count ?? 0,
    glossaryTerms: report?.summary?.glossary_count ?? 0,
    chapterCount: 1,
    chapterTitle: chapter?.chapter_title ?? "DGFT Knowledge Source",
    uploadedAt: stat.mtime.toISOString(),
    lastUpdated: stat.mtime.toISOString(),
    sizeKb: Math.round(stat.size / 1024),
    status: "ready",
    progress: 100,
    summary: chapter?.summary_en ?? "Structured DGFT knowledge extracted for search and answer generation.",
    stages: [
      { label: "Upload", state: "complete" },
      { label: "Reading PDF", state: "complete" },
      { label: "Extracting Sections", state: "complete" },
      { label: "Extracting Rules", state: "complete" },
      { label: "Extracting Conditions", state: "complete" },
      { label: "Creating Embeddings", state: "complete" },
      { label: "Knowledge Base Ready", state: "complete" },
    ],
  });
}

documents.sort((a, b) => new Date(b.uploadedAt).getTime() - new Date(a.uploadedAt).getTime());

const sections = [];
for (const sectionFile of sectionFiles) {
  const section = await safeReadJson(sectionFile, null);
  if (!section?.section) continue;

  const businessRules = (section.business_rules || []).map((rule, index) => ({
    id: rule.rule_id || `${section.section}-R${index + 1}`,
    name: cleanText(rule.trigger || section.title, 64),
    description: cleanText(rule.rule_description || rule.output || section.summary, 240),
    condition: cleanText(rule.condition || section.conditions?.[0], 180),
    exception: cleanText(rule.exception || section.exceptions?.[0] || "No explicit exception found.", 120),
    output: cleanText(rule.output, 120),
  }));

  sections.push({
    id: section.section,
    title: section.title,
    chapterNumber: section.chapter_number ?? section.section.split(".")[0],
    chapterTitle: section.chapter_title ?? "DGFT Chapter",
    documentName:
      masterReport.source_documents?.[Number((section.chapter_number ?? "1").split(".")[0]) - 1] ?? "",
    purpose: cleanText(section.purpose || section.summary, 180),
    summary: cleanText(section.summary, 280),
    businessMeaning: cleanText(section.business_meaning || section.business_explanation, 180),
    rulesCount: businessRules.length,
    conditionsCount: section.conditions?.length ?? 0,
    validationsCount: section.validations?.length ?? 0,
    exceptionsCount: section.exceptions?.length ?? 0,
    authorities: unique((section.authorities || []).map((authority) => cleanText(authority, 90))).slice(0, 6),
    timelines: unique((section.timelines || []).map((timeline) => cleanText(timeline, 120))).slice(0, 4),
    workflow: (section.workflow || []).map((step) => cleanText(step, 120)).slice(0, 7),
    relatedChapters: chapterReports
      .find((chapter) => chapter.chapter_number === String(section.chapter_number ?? "").replace(".00", ""))
      ?.related_chapters ?? [],
    businessRules,
    documents: unique((section.required_documents || section.documents || []).map((item) => cleanText(item, 90))).slice(
      0,
      6,
    ),
  });
}

sections.sort((a, b) => a.id.localeCompare(b.id, undefined, { numeric: true }));

const rules = sections.flatMap((section) =>
  section.businessRules.map((rule, index) => ({
    ruleId: rule.id,
    ruleName: rule.name || `${section.title} Rule ${index + 1}`,
    section: section.id,
    sectionTitle: section.title,
    description: rule.description,
    condition: rule.condition,
    exception: rule.exception,
    authority: section.authorities[0] || "DGFT",
    timeline: section.timelines[0] || "Timeline not explicit",
  })),
);

const workflowFileMap = new Map();
for (const workflowFile of workflowFiles) {
  const workflow = await safeReadJson(workflowFile, null);
  if (workflow?.section) {
    workflowFileMap.set(workflow.section, workflow);
  }
}

const workflows = sections
  .filter((section) => section.workflow.length)
  .map((section) => {
    const workflow = workflowFileMap.get(section.id);
    return {
      id: `${section.id}-workflow`,
      section: section.id,
      title: section.title,
      chapterNumber: section.chapterNumber,
      authority: section.authorities[0] || "DGFT",
      timeline: section.timelines[0] || "Timeline not explicit",
      steps: section.workflow,
      mermaid: workflow?.mermaid || "",
      ascii: workflow?.workflow_ascii || "",
    };
  });

const glossaryMap = new Map();
for (const glossaryFile of glossaryFiles) {
  const glossary = await safeReadJson(glossaryFile, {});
  const chapterSource = path.basename(glossaryFile).replace("_glossary.json", "");
  for (const [term, definition] of Object.entries(glossary)) {
    if (!glossaryMap.has(term)) {
      glossaryMap.set(term, {
        term,
        definition: cleanText(definition, 240),
        chapterSource,
      });
    }
  }
}

const glossary = [...glossaryMap.values()].sort((a, b) => a.term.localeCompare(b.term));

const knowledgeGrowth = documents
  .slice()
  .sort((a, b) => new Date(a.uploadedAt).getTime() - new Date(b.uploadedAt).getTime())
  .reduce((acc, document, index) => {
    const previous = acc[index - 1] || { sections: 0, rules: 0, workflows: 0 };
    acc.push({
      date: document.uploadedAt.slice(0, 10),
      sections: previous.sections + document.sections,
      rules: previous.rules + document.rules,
      workflows: previous.workflows + document.workflows,
    });
    return acc;
  }, []);

const uploadHistory = documents.map((document) => ({
  date: document.uploadedAt.slice(0, 10),
  documents: 1,
  pages: document.pages,
}));

const chapterDistribution = chapterReports.map((chapter) => ({
  name: `Chapter ${chapter.chapter_number}`,
  rules: chapter.rule_count,
  conditions: chapter.condition_count,
  workflows: chapter.workflow_count,
}));

const metrics = {
  totalPdfs: documents.length,
  totalPages: documents.reduce((total, document) => total + document.pages, 0),
  totalSections: masterReport.section_count ?? sections.length,
  totalRules: rules.length,
  totalWorkflows: workflows.length,
  totalConditions: sections.reduce((total, section) => total + section.conditionsCount, 0),
  totalExceptions: sections.reduce((total, section) => total + section.exceptionsCount, 0),
  totalAuthorities: unique(sections.flatMap((section) => section.authorities)).length,
  totalGlossaryTerms: glossary.length,
  totalUsers: 24,
};

const users = [
  { id: "USR-001", name: "Aditi Rao", role: "Platform Admin", team: "Compliance", status: "online", lastActive: "2026-07-28T09:45:00.000Z" },
  { id: "USR-002", name: "Rohan Mehta", role: "Customs Analyst", team: "Operations", status: "reviewing", lastActive: "2026-07-28T08:55:00.000Z" },
  { id: "USR-003", name: "Meera Nair", role: "Knowledge Curator", team: "Knowledge Ops", status: "processing", lastActive: "2026-07-28T08:30:00.000Z" },
  { id: "USR-004", name: "Vikram Jain", role: "DGFT Counsel", team: "Legal", status: "offline", lastActive: "2026-07-27T17:15:00.000Z" },
  { id: "USR-005", name: "Sana Khan", role: "Audit Reviewer", team: "Audit", status: "online", lastActive: "2026-07-28T10:05:00.000Z" },
];

const notifications = [
  { id: "NTF-1", title: "Chapter 10 embeddings refreshed", tone: "success", time: "5m ago" },
  { id: "NTF-2", title: "IEC modification rule set updated", tone: "info", time: "18m ago" },
  { id: "NTF-3", title: "2 workflow nodes need review", tone: "warning", time: "42m ago" },
];

const searchExamples = [
  "What is the timeline for IEC modification after a PAN change?",
  "Show workflows related to Status Certificate applications.",
  "List exceptions in Chapter 2 around import authorisation validity.",
  "Find rules mentioning jurisdictional Regional Authority.",
];

const data = {
  metadata: {
    generatedAt: new Date().toISOString(),
    knowledgeBaseName: masterReport.knowledge_base_name || "DEKAI DGFT Knowledge Base",
    theme: "Copilot-grade enterprise workspace",
    models: {
      llm: "GPT-4.1 / Claude / Gemini compatible",
      embeddings: "text-embedding-3-large",
      vectorDatabase: "pgvector",
      chunking: "500-800 tokens with overlap",
    },
  },
  metrics,
  documents,
  chapters: chapterReports,
  sections,
  rules,
  workflows,
  glossary,
  analytics: {
    uploadHistory,
    knowledgeGrowth,
    chapterDistribution,
  },
  liveProcessing: [
    {
      id: "JOB-001",
      documentName: documents[0]?.name || "Latest DGFT upload.pdf",
      stage: "Creating Embeddings",
      progress: 84,
      eta: "3m",
      startedAt: "2026-07-28T09:54:00.000Z",
    },
    {
      id: "JOB-002",
      documentName: documents[1]?.name || "HBP Chapter 2.pdf",
      stage: "Knowledge Base Ready",
      progress: 100,
      eta: "Done",
      startedAt: "2026-07-28T09:10:00.000Z",
    },
  ],
  users,
  notifications,
  searchExamples,
};

const outputPath = path.join(appRoot, "src", "data", "generated", "dgft-data.ts");
await fs.mkdir(path.dirname(outputPath), { recursive: true });
await fs.writeFile(
  outputPath,
  `export const dgftData = ${JSON.stringify(data, null, 2)};\n\nexport type DgftData = typeof dgftData;\n`,
  "utf8",
);

console.log(`DGFT UI data synced to ${path.relative(appRoot, outputPath)}`);
