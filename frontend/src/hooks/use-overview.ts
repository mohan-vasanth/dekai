import { useQuery } from "@tanstack/react-query";
import { overviewApi } from "../api/overview";

export const useOverview = () =>
  useQuery({
    queryKey: ["overview"],
    queryFn: overviewApi.get,
  });
