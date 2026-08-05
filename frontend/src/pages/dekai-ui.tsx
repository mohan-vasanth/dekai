import { motion } from "framer-motion";
import {
  ArrowUp,
  Check,
  Copy,
  Mic,
  Paperclip,
  RefreshCcw,
  ThumbsDown,
  ThumbsUp,
} from "lucide-react";
import type { ChangeEvent, ReactNode } from "react";
import { Button } from "../components/ui";
import { usePreferences } from "../lib/preferences";
import type { AssistantAnswer } from "../lib/dekai";
import { cn } from "../lib/utils";
import type { DekaiData } from "../types/api";

export type DocumentRecord = DekaiData["documents"][number];
type PipelineStageState = DocumentRecord["stages"][number]["state"] | "failed";
type PipelineStage = {
  label: string;
  state: PipelineStageState;
};

export type UserMessage = {
  id: string;
  role: "user";
  text: string;
};

export type AssistantMessage = {
  id: string;
  role: "assistant";
  answer: AssistantAnswer;
  streamedText: string;
  complete: boolean;
  feedback?: "up" | "down";
};

export type ChatMessage = UserMessage | AssistantMessage;

export const uploadStages = [
  "Uploading PDF",
  "Reading PDF",
  "Extracting Sections",
  "Extracting Rules",
  "Creating Embeddings",
  "Knowledge Ready",
] as const;

export const makeId = (prefix: string) =>
  `${prefix}-${Math.random().toString(36).slice(2, 10)}-${Date.now().toString(36)}`;

export const statusTone = (status: string) => {
  if (status === "ready") return "success";
  if (status === "processing") return "warning";
  if (status === "failed") return "danger";
  return "default";
};

export const toProgressStages = (currentIndex: number) =>
  uploadStages.map((label, index) => ({
    label,
    state:
      index < currentIndex
        ? ("complete" as const)
        : index === currentIndex
          ? ("current" as const)
          : ("upcoming" as const),
  }));

export const summarizeQuestionScope = (question: string) =>
  question.trim().split(/\s+/).slice(0, 6).join(" ");

export function ChatComposer({
  compact = false,
  onAttach,
  onChange,
  onSubmit,
  onVoice,
  value,
}: {
  compact?: boolean;
  onAttach: () => void;
  onChange: (value: string) => void;
  onSubmit: () => void;
  onVoice: () => void;
  value: string;
}) {
  const { t } = usePreferences();
  return (
    <div
      className={cn(
        "rounded-[18px] border border-[var(--border)] bg-[linear-gradient(180deg,rgba(255,255,255,0.92),rgba(250,252,249,0.98))] shadow-[0_24px_80px_rgba(15,23,42,0.08)]",
        compact ? "p-3" : "p-3.5 sm:p-4",
      )}
    >
      <div className="flex items-end gap-2 sm:gap-3">
        <button
          aria-label="Attach file"
          className="inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-2xl text-[var(--muted-foreground)] transition hover:bg-[var(--panel-subtle)] hover:text-[var(--foreground)]"
          onClick={onAttach}
          type="button"
        >
          <Paperclip className="h-4.5 w-4.5" />
        </button>

        <div className="min-w-0 flex-1">
          <textarea
            className={cn(
              "block max-h-12 min-h-6 w-full resize-none overflow-y-auto border-none bg-transparent px-1 py-2 text-[var(--foreground)] outline-none placeholder:text-[var(--muted-foreground)]",
              compact ? "text-[15px] leading-6" : "text-base leading-6",
            )}
            onChange={(event) => onChange(event.target.value)}
            onKeyDown={(event) => {
              if (event.key === "Enter" && !event.shiftKey) {
                event.preventDefault();
                onSubmit();
              }
            }}
            placeholder={t("chat.placeholder")}
            rows={1}
            value={value}
          />
        </div>

        <button
          aria-label="Voice input"
          className="inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-2xl text-[var(--muted-foreground)] transition hover:bg-[var(--panel-subtle)] hover:text-[var(--foreground)]"
          onClick={onVoice}
          type="button"
        >
          <Mic className="h-4.5 w-4.5" />
        </button>

        <button
          aria-label="Send message"
          className="inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-2xl bg-[var(--accent)] text-[var(--accent-foreground)] shadow-[0_12px_28px_rgba(15,118,110,0.24)] transition hover:bg-[var(--accent-strong)] disabled:cursor-not-allowed disabled:opacity-50"
          disabled={!value.trim()}
          onClick={onSubmit}
          type="button"
        >
          <ArrowUp className="h-4.5 w-4.5" />
        </button>
      </div>
    </div>
  );
}

export function SourceChip({ children }: { children: ReactNode }) {
  return (
    <span className="inline-flex rounded-full border border-[var(--border)] bg-[var(--panel-subtle)] px-3 py-1 text-xs font-medium text-[var(--foreground)]">
      {children}
    </span>
  );
}

export function AnswerSection({
  children,
  title,
}: {
  children: ReactNode;
  title: string;
}) {
  return (
    <div className="rounded-[1.6rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4 sm:p-5">
      <p className="text-xs font-semibold uppercase tracking-[0.2em] text-[var(--muted-foreground)]">{title}</p>
      <div className="mt-3 text-sm leading-7 text-[var(--foreground)]">{children}</div>
    </div>
  );
}

export function AssistantBubble({
  message,
  onCopy,
  onFeedback,
  onRegenerate,
}: {
  message: AssistantMessage;
  onCopy: () => void;
  onFeedback: (value: "up" | "down") => void;
  onRegenerate: () => void;
}) {
  const { t } = usePreferences();
  return (
    <div className="flex justify-start">
      <div className="w-full max-w-4xl rounded-[2rem] border border-[var(--border)] bg-[var(--panel)] p-5 shadow-[0_24px_80px_rgba(15,23,42,0.08)] lg:p-6">
        <div className="mb-4 flex items-start justify-between gap-4">
          <div className="flex items-center gap-3">
            <span className="flex h-10 w-10 items-center justify-center rounded-2xl bg-[linear-gradient(135deg,var(--accent),var(--accent-strong))] text-sm font-semibold text-white shadow-[0_16px_36px_rgba(15,118,110,0.25)]">
              AI
            </span>
            <div>
              <p className="text-sm font-semibold text-[var(--foreground)]">DEKAI AI</p>
              <p className="text-xs text-[var(--muted-foreground)]">{t("chat.focusedAnswer")}</p>
            </div>
          </div>

          <div className="flex flex-wrap items-center gap-2">
            <Button onClick={onCopy} size="sm" type="button" variant="ghost">
              <Copy className="h-4 w-4" />
              {t("chat.copy")}
            </Button>
            <Button onClick={onRegenerate} size="sm" type="button" variant="ghost">
              <RefreshCcw className="h-4 w-4" />
              {t("chat.regenerate")}
            </Button>
            <Button
              className={message.feedback === "up" ? "bg-[var(--panel-subtle)] text-[var(--foreground)]" : undefined}
              onClick={() => onFeedback("up")}
              size="sm"
              type="button"
              variant="ghost"
            >
              <ThumbsUp className="h-4 w-4" />
            </Button>
            <Button
              className={message.feedback === "down" ? "bg-[var(--panel-subtle)] text-[var(--foreground)]" : undefined}
              onClick={() => onFeedback("down")}
              size="sm"
              type="button"
              variant="ghost"
            >
              <ThumbsDown className="h-4 w-4" />
            </Button>
          </div>
        </div>

        <div className="rounded-[1.6rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4 text-sm leading-7 text-[var(--foreground)] sm:p-5">
          <p className="whitespace-pre-line">{message.streamedText || t("chat.thinking")}</p>
          {!message.complete ? (
            <motion.div
              animate={{ opacity: [0.25, 1, 0.25] }}
              className="mt-3 h-1.5 w-28 rounded-full bg-[var(--accent)]/30"
              transition={{ duration: 1.2, ease: "easeInOut", repeat: Infinity }}
            />
          ) : null}
        </div>
        {message.complete && (message.answer.referencedPdf || message.answer.sourceChapter || message.answer.sourceSection) ? (
          <div className="mt-4 space-y-3">
            <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">Source</p>
            <div className="flex flex-wrap gap-2">
              {message.answer.referencedPdf ? <SourceChip>{message.answer.referencedPdf}</SourceChip> : null}
              {message.answer.sourceChapter ? <SourceChip>{message.answer.sourceChapter}</SourceChip> : null}
              {message.answer.sourceSection ? <SourceChip>{message.answer.sourceSection}</SourceChip> : null}
              {message.answer.sourcePages.length > 0 ? <SourceChip>{`Pages ${message.answer.sourcePages.join(", ")}`}</SourceChip> : null}
            </div>
          </div>
        ) : null}
      </div>
    </div>
  );
}

export function UserBubble({ message }: { message: UserMessage }) {
  return (
    <div className="flex justify-end">
      <div className="max-w-2xl rounded-[2rem] bg-[linear-gradient(135deg,var(--accent),var(--accent-strong))] px-5 py-4 text-sm leading-7 text-white shadow-[0_18px_42px_rgba(15,118,110,0.2)]">
        {message.text}
      </div>
    </div>
  );
}

export function HomeHero({
  onAttach,
  onChange,
  onSubmit,
  onSuggestion,
  onVoice,
  value,
}: {
  onAttach: () => void;
  onChange: (value: string) => void;
  onSubmit: () => void;
  onSuggestion: (value: string) => void;
  onVoice: () => void;
  value: string;
}) {
  const { t } = usePreferences();
  const suggestedQuestions = [
    t("chat.suggestedQuestion1"),
    t("chat.suggestedQuestion2"),
    t("chat.suggestedQuestion3"),
    t("chat.suggestedQuestion4"),
    t("chat.suggestedQuestion5"),
    t("chat.suggestedQuestion6"),
    t("chat.suggestedQuestion7"),
  ];
  return (
    <div className="mx-auto flex min-h-[calc(100vh-13rem)] max-w-5xl flex-col items-center justify-center">
      <div className="max-w-4xl text-center">
        <p className="text-sm font-semibold uppercase tracking-[0.28em] text-[var(--accent)]">DEKAI AI</p>
        <h1 className="mt-5 text-4xl font-semibold tracking-tight text-[var(--foreground)] sm:text-5xl lg:text-6xl">
          {t("chat.heroTitle")}
        </h1>
        <p className="mt-4 text-balance text-lg leading-8 text-[var(--foreground)] sm:text-[1.35rem]">
          {t("chat.heroSubtitle")}
        </p>
      </div>

      <div className="mt-10 w-full">
        <ChatComposer onAttach={onAttach} onChange={onChange} onSubmit={onSubmit} onVoice={onVoice} value={value} />
      </div>

      <div className="mt-7 w-full">
        <p className="text-center text-xs font-semibold uppercase tracking-[0.2em] text-[var(--muted-foreground)]">{t("chat.suggestedQuestions")}</p>
        <div className="mt-4 flex w-full flex-wrap justify-center gap-3">
          {suggestedQuestions.map((question) => (
            <button
              key={question}
              className="rounded-full border border-[var(--border)] bg-[var(--panel)] px-4 py-2.5 text-sm font-medium text-[var(--foreground)] transition hover:border-[var(--accent)]/35 hover:bg-[var(--panel-subtle)]"
              onClick={() => onSuggestion(question)}
              type="button"
            >
              {question}
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}

export function PipelineVisual({ stages }: { stages: PipelineStage[] }) {
  const { translateStageState } = usePreferences();
  return (
    <div className="space-y-3">
      {stages.map((stage, index) => {
        const isCurrent = stage.state === "current";
        const isComplete = stage.state === "complete";
        const isFailed = stage.state === "failed";

        return (
          <div key={`${stage.label}-${index}`} className="flex gap-3">
            <div className="flex flex-col items-center">
              <div
                className={cn(
                  "flex h-8 w-8 items-center justify-center rounded-full border text-xs font-semibold",
                  isComplete && "border-emerald-500/30 bg-emerald-500/15 text-emerald-600",
                  isFailed && "border-rose-500/30 bg-rose-500/15 text-rose-600",
                  isCurrent && "border-[var(--accent)]/30 bg-[var(--accent)]/12 text-[var(--accent)]",
                  stage.state === "upcoming" && "border-[var(--border)] bg-[var(--panel)] text-[var(--muted-foreground)]",
                )}
              >
                {isComplete ? <Check className="h-4 w-4" /> : index + 1}
              </div>
              {index < stages.length - 1 ? <div className="mt-2 h-8 w-px bg-[var(--border)]" /> : null}
            </div>
            <div className="pt-1">
              <p className={cn("text-sm font-medium", isCurrent || isComplete || isFailed ? "text-[var(--foreground)]" : "text-[var(--muted-foreground)]")}>
                {stage.label}
              </p>
              <p className={cn("mt-1 text-xs uppercase tracking-[0.16em]", isFailed ? "text-rose-600" : "text-[var(--muted-foreground)]")}>
                {translateStageState(stage.state)}
              </p>
            </div>
          </div>
        );
      })}
    </div>
  );
}

export function attachToastMessage(
  file: File,
  messages: { title: string; description: string },
  pushToast: (toast: { title: string; description?: string; tone?: "success" | "warning" | "info" }) => void,
) {
  pushToast({
    title: messages.title.replace("{fileName}", file.name),
    description: messages.description,
    tone: "info",
  });
}

export function handleFileAttach(
  event: ChangeEvent<HTMLInputElement>,
  messages: { title: string; description: string },
  pushToast: (toast: { title: string; description?: string; tone?: "success" | "warning" | "info" }) => void,
) {
  const file = event.target.files?.[0];
  if (!file) return;
  attachToastMessage(file, messages, pushToast);
  event.target.value = "";
}
