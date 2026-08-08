import { useQuery } from "@tanstack/react-query";
import { documentsApi } from "../api/documents";

export const useDocumentSearch = (query: string) => {
  const normalizedQuery = query.trim();

  return useQuery({
    queryKey: ["documents", "search", normalizedQuery],
    queryFn: () => documentsApi.search(normalizedQuery),
    enabled: normalizedQuery.length > 0,
    placeholderData: (previousData) => previousData,
    staleTime: 30_000,
  });
};
