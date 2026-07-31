import { startTransition, useCallback, useEffect, useRef, useState } from "react";
import { useSearchParams } from "react-router-dom";
import { streamChat } from "../api/chat";
import { PageBackButton, useAppBack } from "../components/navigation";
import { PageMotion, useToast } from "../components/ui";
import { formatAnswerForClipboard, type AssistantAnswer } from "../lib/dekai";
import { usePreferences } from "../lib/preferences";
import { chatHistoryStorage } from "../services/chat-history";
import type { AssistantAnswer as ApiAssistantAnswer } from "../types/api";
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
  const lastAutoSubmittedRef = useRef("");

  useEffect(() => {
    setMessages([]);
    setDraft("");
  }, [newChatKey]);

  const submitQuestion = useCallback(async (questionValue?: string) => {
    const nextDraft = questionValue ?? draft;
    const question = nextDraft.trim();
    if (!question) return;
    chatHistoryStorage.add(question);

    const userId = makeId("user");
    const assistantId = makeId("assistant");
    const placeholder: ApiAssistantAnswer = {
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

    startTransition(() => {
      setMessages((current) => [
        ...current,
        { id: userId, role: "user", text: question },
        { id: assistantId, role: "assistant", answer: placeholder, streamedText: "", complete: false },
      ]);
      setDraft("");
    });

    try {
      await streamChat(question, (event) => {
        setMessages((current) =>
          current.map((message) => {
            if (message.id !== assistantId || message.role !== "assistant") {
              return message;
            }
            if (event.type === "delta") {
              return { ...message, streamedText: `${message.streamedText}${event.text}` };
            }
            if (event.type === "complete") {
              return { ...message, answer: event.answer, streamedText: event.answer.directAnswer, complete: true };
            }
            return message;
          }),
        );
      }, { aiModel, language });
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
              }
            : message,
        ),
      );
    }
  }, [aiModel, draft, language, pushToast, t]);

  useEffect(() => {
    const autoSubmitKey = `${newChatKey ?? "default"}:${prefilledQuestion}`;
    if (!prefilledQuestion.trim()) {
      lastAutoSubmittedRef.current = "";
      return;
    }
    setDraft(prefilledQuestion);
    if (messages.length > 0 || lastAutoSubmittedRef.current === autoSubmitKey) {
      return;
    }
    lastAutoSubmittedRef.current = autoSubmitKey;
    void submitQuestion(prefilledQuestion);
  }, [messages.length, newChatKey, prefilledQuestion, submitQuestion]);

  const regenerateAnswer = async (messageId: string) => {
    const target = messages.find((message) => message.id === messageId && message.role === "assistant");
    if (!target || target.role !== "assistant") return;
    const question = target.answer.question;
    setMessages((current) =>
      current.map((message) => (message.id === messageId && message.role === "assistant" ? { ...message, streamedText: "", complete: false } : message)),
    );
    try {
      await streamChat(question, (event) => {
        setMessages((current) =>
          current.map((message) => {
            if (message.id !== messageId || message.role !== "assistant") {
              return message;
            }
            if (event.type === "delta") {
              return { ...message, streamedText: `${message.streamedText}${event.text}` };
            }
            if (event.type === "complete") {
              return { ...message, answer: event.answer, streamedText: event.answer.directAnswer, complete: true };
            }
            return message;
          }),
        );
      }, { aiModel, language });
    } catch (error) {
      const message = error instanceof Error ? error.message : t("chat.regenerationFailed");
      pushToast({ title: t("chat.regenerationFailed"), description: message, tone: "warning" });
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
