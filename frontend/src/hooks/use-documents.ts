import { useQuery } from "@tanstack/react-query";
import { documentsApi } from "../api/documents";

export const useDocuments = () =>
  useQuery({
    queryKey: ["documents"],
    queryFn: documentsApi.get,
  });
