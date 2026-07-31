import type { DekaiData } from "../types/api";

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
};

type Section = DekaiData["sections"][number];

const unique = <T,>(items: T[]) => Array.from(new Set(items));

const cleanSnippet = (value: string, limit = 220) => {
  const normalized = value.replace(/\s+/g, " ").trim();
  if (normalized.length <= limit) {
    return normalized;
  }

  return `${normalized.slice(0, limit).trimEnd()}...`;
};

const tokenize = (value: string) =>
  value
    .toLowerCase()
    .replace(/[^a-z0-9\s]/g, " ")
    .split(/\s+/)
    .filter((token) => token.length > 2);

const scoreSection = (question: string, section: Section) => {
  const tokens = tokenize(question);
  const haystack = [
    section.id,
    section.title,
    section.chapterTitle,
    section.summary,
    section.businessMeaning,
    ...section.authorities,
  ]
    .join(" ")
    .toLowerCase();

  return tokens.reduce((score, token) => {
    if (haystack.includes(token)) {
      return score + (section.title.toLowerCase().includes(token) ? 4 : 1);
    }
    return score;
  }, 0);
};

export const findBestSection = (question: string, data: DekaiData) =>
  data.sections.reduce<Section>(
    (best, current) => (scoreSection(question, current) > scoreSection(question, best) ? current : best),
    data.sections[0],
  );

export const buildAssistantAnswer = (question: string, data: DekaiData): AssistantAnswer => {
  const section = findBestSection(question, data);
  const workflow = data.workflows.find((item) => item.section === section.id);
  const rules = data.rules.filter((item) => item.section === section.id).slice(0, 4);
  const chapter = data.chapters.find((item) => item.chapter_number === section.chapterNumber);
  const relatedSections = data.sections
    .filter((item) => item.chapterNumber === section.chapterNumber && item.id !== section.id)
    .slice(0, 4);

  const sourcePdfs = unique([section.documentName, ...section.documents].filter(Boolean));
  const businessRules = section.businessRules
    .slice(0, 4)
    .map((rule) => cleanSnippet(rule.description, 180));
  const conditions = unique(
    section.businessRules
      .map((rule) => cleanSnippet(rule.condition, 160))
      .filter(Boolean),
  ).slice(0, 3);
  const exceptions = unique(
    section.businessRules
      .map((rule) => cleanSnippet(rule.exception, 160))
      .filter(Boolean),
  ).slice(0, 3);

  const directAnswer = [
    `${section.id} ${section.title} is the most relevant DGFT section for this question.`,
    cleanSnippet(section.summary, 200),
    cleanSnippet(section.businessMeaning, 160),
  ].join(" ");

  const businessExplanation = [
    cleanSnippet(chapter?.summary_en ?? section.summary, 220),
    section.authorities.length
      ? `The main authority signals extracted here are ${section.authorities.slice(0, 3).join(", ")}.`
      : "No explicit authority list was extracted for this section.",
    section.timelines.length
      ? `Timeline references include ${section.timelines.slice(0, 2).join(" and ")}.`
      : "The parser did not detect an explicit statutory timeline in this section.",
  ].join(" ");

  const workflowSteps =
    workflow?.steps.slice(0, 5) ??
    section.workflow.slice(0, 5) ??
    ["Ask DEKAI to retrieve the relevant section and validate the governing rule set."];

  const realExample = [
    `If a user asks about ${section.title.toLowerCase()}, DEKAI can start from section ${section.id},`,
    `explain the governing rule,`,
    `highlight ${section.conditionsCount} extracted condition signals,`,
    `and cite ${sourcePdfs[0] ?? "the uploaded DGFT source"} instead of asking the user to read the PDF manually.`,
  ].join(" ");

  return {
    question,
    questionUnderstood: question,
    title: section.title,
    sectionId: section.id,
    chapterNumber: section.chapterNumber,
    detectedIntent: "General Question",
    detectedTopic: "General Question",
    knowledgeSourcesUsed: ["DGFT Knowledge Base"],
    confidenceScore: 1,
    relevantChapters: section.relatedChapters.slice(0, 4).map((chapter) => `Chapter ${chapter}`),
    relevantSections: [`${section.id} ${section.title}`],
    directAnswer,
    businessExplanation,
    businessLogic: businessRules,
    workflow: workflowSteps.map((step) => cleanSnippet(step, 180)),
    businessRules:
      businessRules.length > 0
        ? businessRules
        : rules.map((rule) => cleanSnippet(rule.description, 180)),
    conditions:
      conditions.length > 0
        ? conditions
        : [`This section has ${section.conditionsCount} extracted condition signals in the knowledge base.`],
    exceptions:
      exceptions.length > 0
        ? exceptions
        : section.exceptionsCount > 0
          ? [`This section has ${section.exceptionsCount} extracted exception signals that should be reviewed in context.`]
          : ["No explicit exception snippet was extracted for the top-ranked rules in this section."],
    requiredDocuments: section.documents.slice(0, 5),
    importantNotes: section.authorities.slice(0, 3),
    realExample,
    relatedChapters: section.relatedChapters.slice(0, 4),
    relatedSections: relatedSections.map((item) => `${item.id} ${item.title}`),
    sourcePdfs,
    referencedPdf: sourcePdfs[0] ?? section.documentName,
    sourcePages: [],
    sourceChapter: `Chapter ${section.chapterNumber}`,
    sourceSection: `${section.id} ${section.title}`,
  };
};

export const formatAnswerForClipboard = (answer: AssistantAnswer) =>
  answer.directAnswer.trim();
