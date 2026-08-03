export type ThemeMode = "light" | "dark" | "system";

export type Metrics = {
  totalPdfs: number;
  totalPages: number;
  totalSections: number;
  totalRules: number;
  totalWorkflows: number;
  totalConditions: number;
  totalExceptions: number;
  totalAuthorities: number;
  totalGlossaryTerms: number;
};

export type Metadata = {
  generatedAt: string | null;
  knowledgeBaseName: string;
  models: {
    llm: string;
    embeddings: string;
    vectorDatabase: string;
    chunking: string;
  };
};

export type DocumentStage = {
  label: string;
  state: "complete" | "current" | "upcoming";
};

export type DocumentRecord = {
  id: string;
  name: string;
  version: string;
  pages: number;
  sections: number;
  rules: number;
  conditions: number;
  exceptions: number;
  authorities: number;
  workflows: number;
  glossaryTerms: number;
  chapterCount: number;
  chapterTitle: string;
  uploadedAt: string;
  lastUpdated: string;
  sizeKb: number;
  status: "ready" | "processing" | "failed";
  progress: number;
  summary: string;
  stages: DocumentStage[];
  documentType?: string;
  knowledgeScope?: "single-document-index" | "shared-knowledge-base";
  knowledgeStatus?: "knowledge-ready" | "processing" | "action-required";
  sectionsIndexed?: number;
  totalChunks?: number;
  totalEmbeddings?: number;
  businessRulesExtracted?: number;
  conditionsExtracted?: number;
  metadataGenerated?: number;
  vectorRecordsStored?: number;
  knowledgeSizeKb?: number;
  validations?: number;
  searchIndexStatus?: "indexed" | "updating" | "failed";
  vectorDatabaseStatus?: "stored" | "updating" | "failed";
  lastIndexedAt?: string | null;
  failureReason?: string | null;
  failureDetail?: string | null;
  searchable?: boolean;
};

export type DocumentsKnowledgeStats = {
  scope: "single-document-index" | "shared-knowledge-base";
  documentsInKnowledgeBase: number;
  knowledgeReadyDocuments: number;
  pagesProcessed: number;
  chunksCreated: number;
  sectionsIndexed: number;
  businessRulesExtracted: number;
  conditionsExtracted: number;
  metadataObjects: number;
  embeddingsCreated: number;
  vectorRecordsStored: number;
  knowledgeSizeKb: number;
  searchIndexStatus: "indexed" | "updating" | "attention-required" | "idle";
  knowledgeReady: boolean;
  lastIndexedAt: string | null;
};

export type ChapterRecord = {
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

export type SectionBusinessRule = {
  id: string;
  name: string;
  description: string;
  condition: string;
  exception: string;
  output: string;
};

export type SectionRecord = {
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
  businessRules: SectionBusinessRule[];
  documents: string[];
};

export type RuleRecord = {
  ruleId: string;
  ruleName: string;
  section: string;
  sectionTitle: string;
  description: string;
  condition: string;
  exception: string;
  authority: string;
  timeline: string;
};

export type WorkflowRecord = {
  id: string;
  section: string;
  title: string;
  chapterNumber: string;
  authority: string;
  timeline: string;
  steps: string[];
  mermaid: string;
  ascii: string;
};

export type GlossaryRecord = {
  term: string;
  definition: string;
  chapterSource: string;
};

export type DekaiData = {
  metadata: Metadata;
  metrics: Metrics;
  documents: DocumentRecord[];
  chapters: ChapterRecord[];
  sections: SectionRecord[];
  rules: RuleRecord[];
  workflows: WorkflowRecord[];
  glossary: GlossaryRecord[];
};

export type OverviewResponse = {
  metrics: Metrics;
  metadata: Metadata;
  knowledgeStatus: string;
};

export type AuthUser = {
  email: string;
  name: string;
  role: "admin" | "user";
};

export type LoginResponse = {
  token: string;
  user: AuthUser;
};

export type SearchResult = {
  id: string;
  type: string;
  title: string;
  preview: string;
  chapter: string;
  sectionId: string;
  documentId: string;
  documentName: string;
  sourcePages?: number[];
  score?: number;
};

export type SearchResponse = {
  results: SearchResult[];
};

export type SettingsResponse = {
  theme: ThemeMode;
  language: string;
  aiModel: string;
  knowledgeStatus: string;
  version: string;
  about: string;
  metadata: {
    knowledgeBaseName: string;
    generatedAt: string | null;
    vectorDatabase: string;
    embeddings: string;
    chunking: string;
  };
};

export type DocumentJob = {
  id: string;
  documentId: string;
  documentName: string;
  action: string;
  status: "processing" | "ready" | "failed";
  stage: string;
  progress: number;
  error: string | null;
  startedAt: string;
  updatedAt: string;
  stages: DocumentStage[];
};

export type PdfMarkdownConversion = {
  documentName: string;
  fileName: string;
  content: string;
  pageCount: number;
  sectionCount: number;
  chapterCount: number;
  glossaryCount: number;
  htmlTableCount?: number;
  htmlTagCount?: number;
  downloadUrl?: string;
};

export type DocumentsResponse = {
  documents: DocumentRecord[];
  metrics: Metrics;
  knowledgeStats: DocumentsKnowledgeStats;
  jobs: DocumentJob[];
};

export type AssistantAnswer = {
  question: string;
  questionUnderstood: string;
  title: string;
  sectionId: string;
  chapterNumber: string;
  detectedIntent: string;
  detectedTopic: string;
  knowledgeSourcesUsed: string[];
  confidenceScore: number;
  relevantChapters: string[];
  relevantSections: string[];
  directAnswer: string;
  businessExplanation: string;
  businessLogic: string[];
  workflow: string[];
  businessRules: string[];
  conditions: string[];
  exceptions: string[];
  requiredDocuments: string[];
  importantNotes: string[];
  realExample: string;
  relatedChapters: string[];
  relatedSections: string[];
  sourcePdfs: string[];
  referencedPdf: string;
  sourcePages: number[];
  sourceChapter: string;
  sourceSection: string;
  modelUsed?: string;
  languageUsed?: string;
};

export type ChatStreamEvent =
  | { type: "start" }
  | { type: "delta"; text: string }
  | { type: "complete"; answer: AssistantAnswer };
