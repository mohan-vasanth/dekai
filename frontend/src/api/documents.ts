import { apiBlobRequest, apiRequest } from "./client";
import type { DocumentJob, DocumentsResponse, DocumentsSearchResponse } from "../types/api";

export const documentsApi = {
  delete(documentId: string) {
    return apiRequest<{ job: DocumentJob }>(`/api/documents/${documentId}`, {
      method: "DELETE",
    });
  },
  get() {
    return apiRequest<DocumentsResponse>("/api/documents");
  },
  search(query: string) {
    return apiRequest<DocumentsSearchResponse>(`/api/documents/search?q=${encodeURIComponent(query)}`);
  },
  getFile(documentId: string) {
    return apiBlobRequest(`/api/documents/${documentId}/file`);
  },
  getJob(jobId: string) {
    return apiRequest<{ job: DocumentJob }>(`/api/documents/jobs/${jobId}`);
  },
  replace(documentId: string, file: File) {
    const body = new FormData();
    body.append("file", file);
    return apiRequest<{ job: DocumentJob }>(`/api/documents/${documentId}/replace`, {
      method: "POST",
      body,
    });
  },
  reindex(documentId: string) {
    return apiRequest<{ job: DocumentJob }>(`/api/documents/${documentId}/reindex`, {
      method: "POST",
    });
  },
  upload(files: File[]) {
    const body = new FormData();
    if (files.length > 1) {
      for (const file of files) {
        body.append("files", file);
      }
      return apiRequest<{ job: DocumentJob }>("/api/documents/upload-batch", {
        method: "POST",
        body,
      });
    }
    body.append("file", files[0]);
    return apiRequest<{ job: DocumentJob }>("/api/documents/upload", {
      method: "POST",
      body,
    });
  },
};
