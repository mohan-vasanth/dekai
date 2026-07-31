import { useQuery } from "@tanstack/react-query";
import { settingsApi } from "../api/settings";

export const useSettings = (enabled = true) =>
  useQuery({
    queryKey: ["settings"],
    queryFn: settingsApi.get,
    enabled,
  });
