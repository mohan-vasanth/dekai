import { apiRequest } from "./client";
import type { SearchResponse } from "../types/api";

export const searchApi = {
  search(query: string, mode: string) {
    const params = new URLSearchParams({ q: query, mode });
    return apiRequest<SearchResponse>(`/api/search?${params.toString()}`);
  },
};
