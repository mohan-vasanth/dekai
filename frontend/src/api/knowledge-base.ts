import { apiRequest } from "./client";
import type { DekaiData } from "../types/api";

export const knowledgeBaseApi = {
  get() {
    return apiRequest<DekaiData>("/api/knowledge-base");
  },
};
