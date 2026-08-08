import type { AnswerSource, AssistantAnswer } from "../types/api";

const formatSourceLine = (source: AnswerSource) => {
  const parts = [
    source.documentName || "Unknown document",
    source.chapter || "Unknown chapter",
    source.section || "Unknown section",
    source.pageNumbers.length > 0 ? `Pages ${source.pageNumbers.join(", ")}` : "Pages not available",
  ];
  return `- ${parts.join(" | ")}`;
};

export const answerSourceEntries = (answer: AssistantAnswer): AnswerSource[] => {
  if (Array.isArray(answer.sources) && answer.sources.length > 0) {
    return answer.sources;
  }
  if (!answer.referencedPdf && !answer.sourceChapter && !answer.sourceSection && answer.sourcePages.length === 0) {
    return [];
  }
  return [
    {
      documentName: answer.referencedPdf || "",
      chapter: answer.sourceChapter || "",
      section: answer.sourceSection || "",
      pageNumbers: answer.sourcePages || [],
    },
  ];
};

export const formatAnswerForClipboard = (answer: AssistantAnswer) => {
  const sources = answerSourceEntries(answer);
  return [
    "Answer",
    "",
    answer.directAnswer.trim(),
    "",
    "Source",
    ...sources.map(formatSourceLine),
  ]
    .filter(Boolean)
    .join("\n");
};
