import { startTransition, useCallback, useEffect, useRef, useState } from "react";
import { useSearchParams } from "react-router-dom";
import { streamChat } from "../api/chat";
import { PageBackButton, useAppBack } from "../components/navigation";
import { PageMotion, useToast } from "../components/ui";
import { formatAnswerForClipboard } from "../lib/answer-format";
import { usePreferences } from "../lib/preferences";
import { chatHistoryStorage } from "../services/chat-history";
import type { AssistantAnswer } from "../types/api";
import {
  AssistantBubble,
  ChatComposer,
  handleFileAttach,
  HomeHero,
  makeId,
  summarizeQuestionScope,
  type ChatMessage,
  UserBubble,
} from "./dekai-ui";

const strictModeAutoSubmitKeys = new Set<string>();
const pendingRequestKeys = new Set<string>();

function normalizeMessageKeyPart(value: string) {
  return value.trim().replace(/\s+/g, " ").toLowerCase();
}

function buildRequestKey(question: string, currentDocumentName: string, aiModel: string, language: string) {
  return [
    normalizeMessageKeyPart(question),
    normalizeMessageKeyPart(currentDocumentName),
    normalizeMessageKeyPart(aiModel),
    normalizeMessageKeyPart(language),
  ].join("::");
}

function buildAnswerFingerprint(answer: AssistantAnswer) {
  const sourceEntries = (answer.sources ?? [])
    .map((source) =>
      [
        normalizeMessageKeyPart(source.documentName),
        normalizeMessageKeyPart(source.chapter),
        normalizeMessageKeyPart(source.section),
        [...source.pageNumbers].sort((left, right) => left - right).join(","),
      ].join("|"),
    )
    .join("||");

  return JSON.stringify({
    question: normalizeMessageKeyPart(answer.question),
    directAnswer: normalizeMessageKeyPart(answer.directAnswer),
    referencedPdf: normalizeMessageKeyPart(answer.referencedPdf),
    sourceChapter: normalizeMessageKeyPart(answer.sourceChapter),
    sourceSection: normalizeMessageKeyPart(answer.sourceSection),
    sourcePages: [...answer.sourcePages].sort((left, right) => left - right).join(","),
    sources: sourceEntries,
  });
}

function resolveResponseDocumentName(answer: AssistantAnswer) {
  return (
    answer.documentSync?.responseDocumentName?.trim() ||
    answer.documentSync?.retrievedDocumentName?.trim() ||
    answer.referencedPdf?.trim() ||
    answer.sourcePdfs.find((value) => value.trim())?.trim() ||
    ""
  );
}

export function ChatPage() {
  const { pushToast } = useToast();
  const { canGoBack, goBack } = useAppBack();
  const { aiModel, language, t } = usePreferences();
  const attachmentInputRef = useRef<HTMLInputElement | null>(null);
  const [searchParams] = useSearchParams();
  const newChatKey = searchParams.get("new");
  const prefilledQuestion = searchParams.get("q") ?? "";
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [draft, setDraft] = useState("");
  const draftRef = useRef("");
  const [resolvedDocumentName, setResolvedDocumentName] = useState("");
  const [conversationId, setConversationId] = useState(() => makeId("conversation"));
  const [isRequestInFlight, setIsRequestInFlight] = useState(false);
  const isRequestInFlightRef = useRef(false);
  const activeRequestKeyRef = useRef<string | null>(null);
  const lastAutoSubmittedRef = useRef("");

  useEffect(() => {
    setMessages([]);
    setDraft("");
    setResolvedDocumentName("");
    setConversationId(makeId("conversation"));
  }, [newChatKey]);

  useEffect(() => {
    draftRef.current = draft;
  }, [draft]);

  useEffect(() => {
    return () => {
      const activeRequestKey = activeRequestKeyRef.current;
      if (activeRequestKey) {
        pendingRequestKeys.delete(activeRequestKey);
      }
    };
  }, []);

  const submitQuestion = useCallback(async (questionValue?: string) => {
    const nextDraft = questionValue ?? draftRef.current;
    const question = nextDraft.trim();
    if (!question || isRequestInFlightRef.current) return;

    const currentDocumentName = resolvedDocumentName.trim();
    const requestKey = buildRequestKey(question, currentDocumentName, aiModel, language);
    if (pendingRequestKeys.has(requestKey)) return;
    const userId = makeId("user");
    const assistantId = makeId("assistant");
    const placeholder: AssistantAnswer = {
      question,
      questionUnderstood: question,
      title: "Thinking",
      sectionId: "",
      chapterNumber: "",
      detectedIntent: "General Question",
      detectedTopic: "General Question",
      knowledgeSourcesUsed: [],
      confidenceScore: 0,
      relevantChapters: [],
      relevantSections: [],
      directAnswer: "",
      businessExplanation: "",
      businessLogic: [],
      workflow: [],
      businessRules: [],
      conditions: [],
      exceptions: [],
      requiredDocuments: [],
      importantNotes: [],
      realExample: "",
      relatedChapters: [],
      relatedSections: [],
      sourcePdfs: [],
      referencedPdf: "",
      sourcePages: [],
      sourceChapter: "",
      sourceSection: "",
    };

    isRequestInFlightRef.current = true;
    activeRequestKeyRef.current = requestKey;
    pendingRequestKeys.add(requestKey);
    setIsRequestInFlight(true);
    chatHistoryStorage.add(question);

    startTransition(() => {
      setMessages((current) => {
        if (current.some((message) => message.role === "assistant" && message.requestKey === requestKey && !message.complete)) {
          return current;
        }

        return [
          ...current,
          { id: userId, role: "user", text: question, requestKey },
          { id: assistantId, role: "assistant", answer: placeholder, streamedText: "", complete: false, requestKey },
        ];
      });
      setDraft("");
    });

    try {
      await streamChat(question, (event) => {
        if (event.type === "start") {
          const syncedDocumentName =
            event.documentSync?.responseDocumentName?.trim() || event.documentSync?.retrievedDocumentName?.trim() || "";
          if (syncedDocumentName) {
            setResolvedDocumentName(syncedDocumentName);
          }
          console.debug("dekai_document_sync_start", {
            question,
            requestedDocumentName: event.documentSync?.requestedDocumentName ?? currentDocumentName,
            retrievedDocumentName: event.documentSync?.retrievedDocumentName ?? "",
            responseDocumentName: event.documentSync?.responseDocumentName ?? syncedDocumentName,
          });
          return;
        }

        if (event.type === "complete") {
          const responseDocumentName = resolveResponseDocumentName(event.answer);
          setResolvedDocumentName(responseDocumentName);
          console.debug("dekai_document_sync_complete", {
            question,
            requestedDocumentName: event.answer.documentSync?.requestedDocumentName ?? currentDocumentName,
            retrievedDocumentName: event.answer.documentSync?.retrievedDocumentName ?? responseDocumentName,
            responseDocumentName,
            uiDisplayedDocumentName: responseDocumentName,
          });
        }

        setMessages((current) => {
          const target = current.find((message) => message.id === assistantId && message.role === "assistant");
          if (!target || target.role !== "assistant") {
            return current;
          }

          if (event.type === "delta") {
            if (target.complete) {
              return current;
            }
            return current.map((message) =>
              message.id === assistantId && message.role === "assistant"
                ? { ...message, streamedText: `${message.streamedText}${event.text}` }
                : message,
            );
          }

          if (event.type === "complete") {
            const responseFingerprint = buildAnswerFingerprint(event.answer);
            const duplicateResponseExists = current.some(
              (message) =>
                message.id !== assistantId &&
                message.role === "assistant" &&
                message.requestKey === requestKey &&
                message.responseFingerprint === responseFingerprint,
            );

            if (duplicateResponseExists) {
              return current.filter((message) => message.id !== assistantId);
            }

            if (target.complete && target.responseFingerprint === responseFingerprint) {
              return current;
            }

            return current.map((message) =>
              message.id === assistantId && message.role === "assistant"
                ? {
                    ...message,
                    answer: event.answer,
                    streamedText: event.answer.directAnswer,
                    complete: true,
                    responseFingerprint,
                  }
                : message,
            );
          }

          return current;
        });
      }, { aiModel, language, currentDocumentName, conversationId });
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : t("chat.requestFailed");
      pushToast({ title: t("chat.requestFailed"), description: errorMessage, tone: "warning" });
      setMessages((current) =>
        current.map((message) =>
          message.id === assistantId && message.role === "assistant"
            ? {
                ...message,
                complete: true,
                streamedText: t("chat.requestFailed"),
                answer: { ...placeholder, directAnswer: t("chat.requestFailed") },
                responseFingerprint: undefined,
              }
            : message,
        ),
      );
    } finally {
      pendingRequestKeys.delete(requestKey);
      if (activeRequestKeyRef.current === requestKey) {
        activeRequestKeyRef.current = null;
      }
      isRequestInFlightRef.current = false;
      setIsRequestInFlight(false);
    }
  }, [aiModel, conversationId, language, pushToast, resolvedDocumentName, t]);

  useEffect(() => {
    const autoSubmitKey = `${newChatKey ?? "default"}:${prefilledQuestion}`;
    if (!prefilledQuestion.trim()) {
      lastAutoSubmittedRef.current = "";
      return;
    }
    setDraft(prefilledQuestion);
    if (
      messages.length > 0 ||
      lastAutoSubmittedRef.current === autoSubmitKey ||
      strictModeAutoSubmitKeys.has(autoSubmitKey)
    ) {
      return;
    }
      lastAutoSubmittedRef.current = autoSubmitKey;
      strictModeAutoSubmitKeys.add(autoSubmitKey);
      void submitQuestion(prefilledQuestion);
  }, [messages.length, newChatKey, prefilledQuestion, submitQuestion]);

  const regenerateAnswer = async (messageId: string) => {
    if (isRequestInFlightRef.current) return;
    const target = messages.find((message) => message.id === messageId && message.role === "assistant");
    if (!target || target.role !== "assistant") return;
    const question = target.answer.question;
    const currentDocumentName = resolveResponseDocumentName(target.answer);
    const requestKey = target.requestKey ?? buildRequestKey(question, currentDocumentName, aiModel, language);
    if (pendingRequestKeys.has(requestKey)) return;

    isRequestInFlightRef.current = true;
    activeRequestKeyRef.current = requestKey;
    pendingRequestKeys.add(requestKey);
    setIsRequestInFlight(true);
    setMessages((current) =>
      current.map((message) =>
        message.id === messageId && message.role === "assistant"
          ? { ...message, streamedText: "", complete: false, responseFingerprint: undefined }
          : message,
      ),
    );

    try {
      await streamChat(question, (event) => {
        if (event.type === "start") {
          const syncedDocumentName =
            event.documentSync?.responseDocumentName?.trim() || event.documentSync?.retrievedDocumentName?.trim() || "";
          if (syncedDocumentName) {
            setResolvedDocumentName(syncedDocumentName);
          }
          console.debug("dekai_document_sync_start", {
            question,
            requestedDocumentName: event.documentSync?.requestedDocumentName ?? currentDocumentName,
            retrievedDocumentName: event.documentSync?.retrievedDocumentName ?? "",
            responseDocumentName: event.documentSync?.responseDocumentName ?? syncedDocumentName,
          });
          return;
        }

        if (event.type === "complete") {
          const responseDocumentName = resolveResponseDocumentName(event.answer);
          setResolvedDocumentName(responseDocumentName);
          console.debug("dekai_document_sync_complete", {
            question,
            requestedDocumentName: event.answer.documentSync?.requestedDocumentName ?? currentDocumentName,
            retrievedDocumentName: event.answer.documentSync?.retrievedDocumentName ?? responseDocumentName,
            responseDocumentName,
            uiDisplayedDocumentName: responseDocumentName,
          });
        }

        setMessages((current) => {
          const currentMessage = current.find((message) => message.id === messageId && message.role === "assistant");
          if (!currentMessage || currentMessage.role !== "assistant") {
            return current;
          }

          if (event.type === "delta") {
            if (currentMessage.complete) {
              return current;
            }
            return current.map((message) =>
              message.id === messageId && message.role === "assistant"
                ? { ...message, streamedText: `${message.streamedText}${event.text}` }
                : message,
            );
          }

          if (event.type === "complete") {
            const responseFingerprint = buildAnswerFingerprint(event.answer);
            if (currentMessage.complete && currentMessage.responseFingerprint === responseFingerprint) {
              return current;
            }

            return current.map((message) =>
              message.id === messageId && message.role === "assistant"
                ? {
                    ...message,
                    answer: event.answer,
                    streamedText: event.answer.directAnswer,
                    complete: true,
                    responseFingerprint,
                  }
                : message,
            );
          }

          return current;
        });
      }, { aiModel, language, currentDocumentName, conversationId });
    } catch (error) {
      const message = error instanceof Error ? error.message : t("chat.regenerationFailed");
      pushToast({ title: t("chat.regenerationFailed"), description: message, tone: "warning" });
    } finally {
      pendingRequestKeys.delete(requestKey);
      if (activeRequestKeyRef.current === requestKey) {
        activeRequestKeyRef.current = null;
      }
      isRequestInFlightRef.current = false;
      setIsRequestInFlight(false);
    }
  };

  const copyAnswer = async (answer: AssistantAnswer) => {
    try {
      await navigator.clipboard.writeText(formatAnswerForClipboard(answer));
      pushToast({ title: t("chat.answerCopied"), tone: "success" });
    } catch {
      pushToast({ title: t("chat.clipboardUnavailable"), description: t("chat.clipboardUnavailableDescription"), tone: "warning" });
    }
  };

  const lastAssistant = [...messages].reverse().find((message) => message.role === "assistant");
  const showBackButton = canGoBack && (messages.length > 0 || draft.trim().length > 0 || prefilledQuestion.trim().length > 0);

  return (
    <PageMotion className="space-y-6">
      <input
        accept=".pdf"
        className="hidden"
        onChange={(event) =>
          handleFileAttach(
            event,
            {
              title: t("chat.attachDraft"),
              description: t("chat.attachDraftDescription"),
            },
            pushToast,
          )
        }
        ref={attachmentInputRef}
        type="file"
      />

      <div className="flex items-start justify-between gap-4">
        {showBackButton ? <PageBackButton onBack={goBack} /> : null}
      </div>

      {messages.length === 0 ? (
        <HomeHero
          disabled={isRequestInFlight}
          onAttach={() => attachmentInputRef.current?.click()}
          onChange={setDraft}
          onSubmit={() => submitQuestion()}
          onSuggestion={(value) => submitQuestion(value)}
          onVoice={() =>
            pushToast({
              title: t("chat.voiceOptional"),
              description: t("chat.voiceOptionalDescription"),
              tone: "info",
            })
          }
          value={draft}
        />
      ) : (
        <div className="mx-auto max-w-5xl space-y-6">
          <div className="rounded-[2rem] border border-[var(--border)] bg-[linear-gradient(180deg,rgba(15,118,110,0.07),transparent_72%),var(--panel)] p-5 sm:p-6">
            <div className="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
              <div>
                <p className="text-xs font-semibold uppercase tracking-[0.22em] text-[var(--muted-foreground)]">DEKAI AI</p>
                <h1 className="mt-2 text-3xl font-semibold tracking-tight text-[var(--foreground)]">{t("chat.title")}</h1>
                <p className="mt-2 max-w-3xl text-sm leading-7 text-[var(--muted-foreground)]">
                  {t("chat.subtitle")}
                </p>
              </div>

              <div className="flex flex-col gap-3 lg:items-end">
                <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel)] px-4 py-3 text-sm text-[var(--muted-foreground)]">
                  {t("chat.activeModel", { model: aiModel })}
                </div>
                {resolvedDocumentName ? (
                  <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel)] px-4 py-3 text-sm text-[var(--muted-foreground)]">
                    Retrieved from document{" "}
                    <span className="font-medium text-[var(--foreground)]">{resolvedDocumentName}</span>
                  </div>
                ) : null}
                {lastAssistant && lastAssistant.role === "assistant" ? (
                  <div className="rounded-[1.5rem] border border-[var(--border)] bg-[var(--panel)] px-4 py-3 text-sm text-[var(--muted-foreground)]">
                    {t("chat.currentTopic")}{" "}
                    <span className="font-medium text-[var(--foreground)]">{summarizeQuestionScope(lastAssistant.answer.question)}</span>
                  </div>
                ) : null}
              </div>
            </div>
          </div>

          <div className="space-y-5">
            {messages.map((message) =>
              message.role === "user" ? (
                <UserBubble key={message.id} message={message} />
              ) : (
                <AssistantBubble
                  key={message.id}
                  message={message}
                  onCopy={() => copyAnswer(message.answer)}
                  onFeedback={(value) => {
                    setMessages((current) =>
                      current.map((item) =>
                        item.id === message.id && item.role === "assistant" ? { ...item, feedback: value } : item,
                      ),
                    );
                    pushToast({ title: value === "up" ? t("chat.feedbackPositive") : t("chat.feedbackRecorded"), tone: "info" });
                  }}
                  onRegenerate={() => regenerateAnswer(message.id)}
                />
              ),
            )}
          </div>

          <div className="sticky bottom-4">
            <ChatComposer
              compact
              disabled={isRequestInFlight}
              onAttach={() => attachmentInputRef.current?.click()}
              onChange={setDraft}
              onSubmit={() => submitQuestion()}
              onVoice={() =>
                pushToast({
                  title: t("chat.voiceOptional"),
                  description: t("chat.speechIntegration"),
                  tone: "info",
                })
              }
              value={draft}
            />
          </div>
        </div>
      )}
    </PageMotion>
  );
}
