import { useKnowledgeBase } from "../hooks/use-knowledge-base";

export type { DekaiData } from "../types/api";

export const useDekaiData = () => useKnowledgeBase();
