import { useQueryClient } from "@tanstack/react-query";
import { useEffect, useMemo, useRef } from "react";
import { documentsApi } from "../api/documents";
import type { DocumentJob, DocumentRecord, DocumentsResponse } from "../types/api";

const DOCUMENTS_QUERY_KEY = ["documents"] as const;
const OVERVIEW_QUERY_KEY = ["overview"] as const;
const KNOWLEDGE_BASE_QUERY_KEY = ["knowledge-base"] as const;
const POLL_INTERVAL_MS = 2500;

function parseTimestamp(value: string | undefined) {
  const timestamp = Date.parse(value ?? "");
  return Number.isNaN(timestamp) ? 0 : timestamp;
}

function latestProcessingJobs(jobs: DocumentJob[] | undefined) {
  const latestByDocumentId = new Map<string, DocumentJob>();

  for (const job of jobs ?? []) {
    if (job.status !== "queued" && job.status !== "processing") {
      continue;
    }

    const current = latestByDocumentId.get(job.documentId);
    if (!current || parseTimestamp(job.updatedAt) >= parseTimestamp(current.updatedAt)) {
      latestByDocumentId.set(job.documentId, job);
    }
  }

  return Array.from(latestByDocumentId.values());
}

function applyJobToDocumentsResponse(current: DocumentsResponse | undefined, job: DocumentJob) {
  if (!current) {
    return current;
  }

  const jobs = current.jobs.some((currentJob) => currentJob.id === job.id)
    ? current.jobs.map((currentJob) => (currentJob.id === job.id ? job : currentJob))
    : [job, ...current.jobs];

  const documents = current.documents.map<DocumentRecord>((document) => {
    const matchesDocument = document.id === job.documentId || document.name === job.documentName;
    if (!matchesDocument) {
      return document;
    }

    const knowledgeStatus: DocumentRecord["knowledgeStatus"] =
      job.status === "ready" ? "knowledge-ready" : job.status === "failed" ? "action-required" : "processing";
    const searchIndexStatus: DocumentRecord["searchIndexStatus"] =
      job.status === "failed" ? "failed" : job.status === "ready" ? document.searchIndexStatus : "updating";
    const vectorDatabaseStatus: DocumentRecord["vectorDatabaseStatus"] =
      job.status === "failed" ? "failed" : job.status === "ready" ? document.vectorDatabaseStatus : "updating";

    return {
      ...document,
      status: job.status,
      progress: job.progress,
      stages: job.stages,
      lastUpdated: job.updatedAt || document.lastUpdated,
      summary:
        job.status === "failed"
          ? job.error || document.summary
          : job.status === "queued"
            ? `${job.documentName} is queued for processing.`
            : job.status === "processing"
            ? `${job.documentName} is being processed.`
            : document.summary,
      knowledgeStatus,
      searchIndexStatus,
      vectorDatabaseStatus,
      failureReason: job.status === "failed" ? job.error : null,
      failureDetail: job.status === "failed" ? job.error : null,
      searchable: job.status === "ready" ? document.searchable : false,
    };
  });

  return {
    ...current,
    jobs,
    documents,
  };
}

export function useDocumentJobPolling(jobs: DocumentJob[] | undefined) {
  const queryClient = useQueryClient();
  const timersRef = useRef(new Map<string, number>());
  const controllersRef = useRef(new Map<string, AbortController>());
  const inFlightRef = useRef(new Set<string>());

  const processingJobs = useMemo(() => latestProcessingJobs(jobs), [jobs]);

  useEffect(() => {
    const timers = timersRef.current;
    const controllers = controllersRef.current;
    const inFlight = inFlightRef.current;

    const stopPolling = (jobId: string) => {
      const timerId = timers.get(jobId);
      if (timerId !== undefined) {
        window.clearTimeout(timerId);
        timers.delete(jobId);
      }

      const controller = controllers.get(jobId);
      if (controller) {
        controller.abort();
        controllers.delete(jobId);
      }

      inFlight.delete(jobId);
    };

    const schedulePoll = (job: DocumentJob) => {
      if (timers.has(job.id)) {
        return;
      }

      const tick = () => {
        if (inFlight.has(job.id)) {
          timers.set(job.id, window.setTimeout(tick, POLL_INTERVAL_MS));
          return;
        }

        const controller = new AbortController();
        inFlight.add(job.id);
        controllers.set(job.id, controller);

        void documentsApi
          .getJob(job.id, { signal: controller.signal })
          .then(({ job: nextJob }) => {
            queryClient.setQueryData<DocumentsResponse | undefined>(DOCUMENTS_QUERY_KEY, (current) =>
              applyJobToDocumentsResponse(current, nextJob),
            );

            if (nextJob.status === "queued" || nextJob.status === "processing") {
              timers.set(nextJob.id, window.setTimeout(tick, POLL_INTERVAL_MS));
              return;
            }

            stopPolling(nextJob.id);
            void Promise.all([
              queryClient.invalidateQueries({ queryKey: DOCUMENTS_QUERY_KEY }),
              queryClient.invalidateQueries({ queryKey: OVERVIEW_QUERY_KEY }),
              queryClient.invalidateQueries({ queryKey: KNOWLEDGE_BASE_QUERY_KEY }),
            ]);
          })
          .catch((error) => {
            if (error instanceof DOMException && error.name === "AbortError") {
              return;
            }

            stopPolling(job.id);
            void queryClient.invalidateQueries({ queryKey: DOCUMENTS_QUERY_KEY });
          })
          .finally(() => {
            inFlight.delete(job.id);
            const currentController = controllers.get(job.id);
            if (currentController === controller) {
              controllers.delete(job.id);
            }
          });
      };

      timers.set(job.id, window.setTimeout(tick, POLL_INTERVAL_MS));
    };

    const activeJobIds = new Set(processingJobs.map((job) => job.id));

    for (const [jobId, timerId] of timers.entries()) {
      if (activeJobIds.has(jobId)) {
        continue;
      }

      window.clearTimeout(timerId);
      timers.delete(jobId);
      const controller = controllers.get(jobId);
      if (controller) {
        controller.abort();
        controllers.delete(jobId);
      }
      inFlight.delete(jobId);
    }

    for (const job of processingJobs) {
      schedulePoll(job);
    }

    return () => {
      for (const timerId of timers.values()) {
        window.clearTimeout(timerId);
      }
      timers.clear();

      for (const controller of controllers.values()) {
        controller.abort();
      }
      controllers.clear();
      inFlight.clear();
    };
  }, [processingJobs, queryClient]);
}
