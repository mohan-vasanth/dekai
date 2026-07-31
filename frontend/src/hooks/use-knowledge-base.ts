import { useQuery } from "@tanstack/react-query";
import { knowledgeBaseApi } from "../api/knowledge-base";

export const useKnowledgeBase = () =>
  useQuery({
    queryKey: ["knowledge-base"],
    queryFn: knowledgeBaseApi.get,
  });
