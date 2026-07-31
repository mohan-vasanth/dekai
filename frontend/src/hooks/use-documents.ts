import { useQuery } from "@tanstack/react-query";
import { documentsApi } from "../api/documents";

export const useDocuments = () =>
  useQuery({
    queryKey: ["documents"],
    queryFn: documentsApi.get,
    refetchInterval: (query) => {
      const data = query.state.data;
      const hasActiveJob = data?.jobs?.some((job) => job.status === "processing");
      return hasActiveJob ? 1500 : false;
    },
  });
