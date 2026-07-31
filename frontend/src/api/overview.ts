import { apiRequest } from "./client";
import type { OverviewResponse } from "../types/api";

export const overviewApi = {
  get() {
    return apiRequest<OverviewResponse>("/api/overview");
  },
};
