import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useEffect } from "react";
import { settingsApi } from "../api/settings";
import { PageBackButton } from "../components/navigation";
import { Badge, PageMotion, Panel, useToast } from "../components/ui";
import { useSettings } from "../hooks/use-settings";
import { usePreferences } from "../lib/preferences";
import { useTheme } from "../lib/theme";
import type { SettingsResponse, ThemeMode } from "../types/api";

export function SettingsPage() {
  const queryClient = useQueryClient();
  const { pushToast } = useToast();
  const { data: settings, isLoading } = useSettings();
  const { aiModel, getLanguageLabel, language, modelOptions, setAiModel, setLanguage, t } = usePreferences();
  const { mode, resolvedTheme, setMode } = useTheme();

  useEffect(() => {
    if (!settings) return;
    if (settings.theme !== mode) {
      setMode(settings.theme);
    }
  }, [setMode, settings]);

  const updateMutation = useMutation({
    mutationFn: settingsApi.update,
    onMutate: async (patch: Partial<SettingsResponse>) => {
      await queryClient.cancelQueries({ queryKey: ["settings"] });
      const previousSettings = queryClient.getQueryData<SettingsResponse>(["settings"]);

      if (previousSettings) {
        queryClient.setQueryData<SettingsResponse>(["settings"], {
          ...previousSettings,
          ...patch,
        });
      }

      return { previousSettings };
    },
    onSuccess: async (updatedSettings) => {
      queryClient.setQueryData<SettingsResponse>(["settings"], updatedSettings);
      pushToast({ title: t("settings.success"), tone: "success" });
      await queryClient.invalidateQueries({ queryKey: ["settings"] });
    },
    onError: (error, _patch, context) => {
      if (context?.previousSettings) {
        queryClient.setQueryData<SettingsResponse>(["settings"], context.previousSettings);
      }
      const message = error instanceof Error ? error.message : t("settings.failed");
      pushToast({ title: t("settings.failed"), description: message, tone: "warning" });
    },
  });

  const updateSettings = (patch: Partial<{ theme: ThemeMode; language: string; aiModel: string }>) => {
    updateMutation.mutate({
      theme: patch.theme ?? (mode as ThemeMode),
      language: patch.language ?? language,
      aiModel: patch.aiModel ?? aiModel,
    });
  };

  if (isLoading || !settings) {
    return (
      <PageMotion className="space-y-4">
        <Panel className="animate-pulse p-8">
          <div className="h-6 w-40 rounded-full bg-[var(--panel-subtle)]" />
          <div className="mt-6 h-28 rounded-[1.5rem] bg-[var(--panel-subtle)]" />
        </Panel>
      </PageMotion>
    );
  }

  return (
    <PageMotion className="mx-auto max-w-5xl space-y-6">
      <Panel className="space-y-6 p-6 sm:p-8">
        <div className="flex items-start justify-between gap-4">
          <PageBackButton />
        </div>

        <div className="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
          <div>
            <p className="text-sm font-semibold uppercase tracking-[0.22em] text-[var(--accent)]">{t("common.settings")}</p>
            <h1 className="mt-2 text-3xl font-semibold tracking-tight text-[var(--foreground)]">{t("settings.title")}</h1>
            <p className="mt-3 max-w-3xl text-sm leading-7 text-[var(--muted-foreground)]">
              {t("settings.subtitle")}
            </p>
          </div>
          <Badge tone="info">{t("common.appliesInstantly")}</Badge>
        </div>

        <div className="grid gap-4 lg:grid-cols-3">
          {(["light", "dark", "system"] as const).map((value) => (
            <button
              key={value}
              className={
                mode === value
                  ? "rounded-[1.75rem] border border-[var(--accent)]/35 bg-[var(--panel-strong)] p-5 text-left"
                  : "rounded-[1.75rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-5 text-left"
              }
              onClick={() => {
                setMode(value);
                updateSettings({ theme: value });
              }}
              type="button"
            >
              <p className="text-base font-semibold capitalize text-[var(--foreground)]">{value}</p>
              <p className="mt-2 text-sm leading-6 text-[var(--muted-foreground)]">
                {value === "system"
                  ? t("settings.themeSystem", { value: resolvedTheme })
                  : t("settings.themeDescription", { value })}
              </p>
            </button>
          ))}
        </div>
      </Panel>

      <div className="grid gap-6 lg:grid-cols-2">
        <Panel className="space-y-4 p-6">
          <div>
            <p className="text-sm font-semibold text-[var(--foreground)]">{t("common.language")}</p>
            <p className="mt-1 text-sm text-[var(--muted-foreground)]">{t("settings.languageDescription")}</p>
          </div>
          <select
            className="field"
            onChange={(event) => {
              setLanguage(event.target.value as "English" | "Hindi" | "Tamil");
              updateSettings({ language: event.target.value });
            }}
            value={language}
          >
            <option value="English">{getLanguageLabel("English")}</option>
            <option value="Hindi">{getLanguageLabel("Hindi")}</option>
            <option value="Tamil">{getLanguageLabel("Tamil")}</option>
          </select>
        </Panel>

        <Panel className="space-y-4 p-6">
          <div>
            <p className="text-sm font-semibold text-[var(--foreground)]">{t("common.aiModel")}</p>
            <p className="mt-1 text-sm text-[var(--muted-foreground)]">{t("settings.modelDescription")}</p>
          </div>
          <select
            className="field"
            onChange={(event) => {
              setAiModel(event.target.value);
              updateSettings({ aiModel: event.target.value });
            }}
            value={aiModel}
          >
            {modelOptions.map((option) => (
              <option key={option} value={option}>
                {option}
              </option>
            ))}
          </select>
        </Panel>
      </div>
    </PageMotion>
  );
}
