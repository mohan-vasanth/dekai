import { apiRequest } from "./client";
import type { SettingsResponse } from "../types/api";

export const settingsApi = {
  get() {
    return apiRequest<SettingsResponse>("/api/settings");
  },
  update(payload: Partial<SettingsResponse>) {
    return apiRequest<SettingsResponse>("/api/settings", {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
  },
};
