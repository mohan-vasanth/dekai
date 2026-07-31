import { ArrowRight, LockKeyhole, Mail } from "lucide-react";
import { useState } from "react";
import { Navigate, useLocation, useNavigate } from "react-router-dom";
import { Button, Panel, useToast } from "../components/ui";
import { useAuth } from "../hooks/use-auth";
import { usePreferences } from "../lib/preferences";

export function LoginPage() {
  const location = useLocation();
  const navigate = useNavigate();
  const { pushToast } = useToast();
  const { isAuthenticated, login } = useAuth();
  const { t } = usePreferences();
  const redirectTo = (location.state as { from?: string } | null)?.from ?? "/chat";
  const [email, setEmail] = useState("admin@dekai.ai");
  const [password, setPassword] = useState("dekai-ai");
  const [isSubmitting, setIsSubmitting] = useState(false);

  const quickActions = [
    t("login.quickAction1"),
    t("login.quickAction2"),
    t("login.quickAction3"),
    t("login.quickAction4"),
    t("login.quickAction5"),
    t("login.quickAction6"),
  ];

  const assistantCapabilities = [
    t("login.capability1"),
    t("login.capability2"),
    t("login.capability3"),
  ];

  if (isAuthenticated) {
    return <Navigate replace to="/chat" />;
  }

  const submit = async () => {
    try {
      setIsSubmitting(true);
      await login(email, password);
      pushToast({ title: t("login.success"), tone: "success" });
      navigate(redirectTo, { replace: true });
    } catch (error) {
      const message = error instanceof Error ? error.message : t("login.failedDescription");
      pushToast({ title: t("login.failed"), description: message, tone: "warning" });
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="min-h-screen bg-[var(--background)] px-4 py-4 sm:px-5 sm:py-5 lg:px-6">
      <div className="mx-auto flex min-h-[calc(100vh-2rem)] max-w-7xl flex-col gap-5 lg:min-h-[calc(100vh-2.5rem)] lg:gap-6">
        <div className="grid items-stretch gap-5 lg:grid-cols-[minmax(0,1.18fr)_minmax(420px,0.82fr)] lg:gap-6">
          <section className="relative overflow-hidden rounded-[2rem] border border-[var(--border)] bg-[linear-gradient(180deg,rgba(15,118,110,0.12),rgba(255,255,255,0.92))] p-6 shadow-[0_24px_80px_rgba(15,23,42,0.08)] sm:p-8 lg:min-h-[620px] lg:p-10 xl:p-12">
            <div className="absolute inset-0 bg-[radial-gradient(circle_at_top_left,rgba(15,118,110,0.16),transparent_34%)]" />
            <div className="absolute -right-20 top-16 h-56 w-56 rounded-full bg-[radial-gradient(circle,rgba(17,94,89,0.12),transparent_66%)] blur-2xl" />
            <div className="absolute bottom-0 left-0 right-0 h-48 bg-[linear-gradient(180deg,transparent,rgba(255,255,255,0.45))]" />
            <div className="relative flex h-full flex-col justify-between gap-10">
              <div className="space-y-8">
                <div className="flex items-center gap-3">
                  <div className="flex h-12 w-12 items-center justify-center rounded-2xl bg-[linear-gradient(135deg,var(--accent),var(--accent-strong))] text-sm font-semibold text-white shadow-[0_20px_40px_rgba(15,118,110,0.24)]">
                    DK
                  </div>
                  <div>
                    <p className="text-[11px] font-semibold uppercase tracking-[0.34em] text-[var(--muted-foreground)]">DEKAI AI</p>
                    <p className="text-sm font-semibold text-[var(--foreground)] sm:text-base">{t("login.enterpriseAssistant")}</p>
                  </div>
                </div>

                <div className="max-w-3xl space-y-5">
                  <div className="inline-flex items-center rounded-full border border-[rgba(15,118,110,0.16)] bg-[rgba(255,255,255,0.66)] px-4 py-2 text-xs font-semibold uppercase tracking-[0.22em] text-[var(--accent)]">
                    {t("login.heroBadge")}
                  </div>
                  <h1 className="max-w-3xl text-[2.2rem] font-semibold leading-[1.04] tracking-[-0.03em] text-[var(--foreground)] sm:text-[2.7rem] lg:text-[3.15rem] xl:text-[3.45rem]">
                    {t("login.heroTitle")}
                  </h1>
                  <p className="max-w-2xl text-sm leading-7 text-[var(--muted-foreground)] sm:text-[15px] sm:leading-8 lg:text-base">
                    {t("login.heroBody1")}
                  </p>
                  <p className="max-w-2xl text-sm leading-7 text-[var(--muted-foreground)] sm:text-[15px] sm:leading-8 lg:text-base">
                    {t("login.heroBody2")}
                  </p>
                </div>
              </div>

              <div className="grid gap-3 sm:grid-cols-3">
                {assistantCapabilities.map((item) => (
                  <div
                    key={item}
                    className="rounded-[1.4rem] border border-[rgba(15,118,110,0.1)] bg-[rgba(255,255,255,0.78)] px-4 py-4 shadow-[0_12px_30px_rgba(15,23,42,0.04)]"
                  >
                    <p className="text-sm font-medium leading-6 text-[var(--foreground)]">{item}</p>
                  </div>
                ))}
              </div>
            </div>
          </section>

          <Panel className="flex h-full items-center p-4 sm:p-5 lg:p-6">
            <div className="mx-auto w-full max-w-[30rem] rounded-[1.8rem] border border-[var(--border)] bg-[linear-gradient(180deg,rgba(255,255,255,0.94),rgba(247,248,244,0.86))] p-6 shadow-[0_24px_64px_rgba(15,23,42,0.08)] sm:p-7 lg:p-8">
              <div className="space-y-6">
                <div className="space-y-3">
                  <p className="text-[11px] font-semibold uppercase tracking-[0.3em] text-[var(--muted-foreground)]">{t("login.login")}</p>
                  <h2 className="text-[2rem] font-semibold tracking-tight text-[var(--foreground)] sm:text-[2.15rem]">{t("login.title")}</h2>
                  <p className="text-sm leading-7 text-[var(--muted-foreground)]">
                    {t("login.subtitle")}
                  </p>
                </div>

                <div className="rounded-[1.4rem] border border-[rgba(15,118,110,0.12)] bg-[rgba(255,255,255,0.72)] px-4 py-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--accent)]">{t("login.demoAccess")}</p>
                  <p className="mt-2 text-sm leading-6 text-[var(--muted-foreground)]">
                    {t("login.demoAccessSubtitle")}
                  </p>
                </div>

                <form
                  className="space-y-4"
                  onSubmit={(event) => {
                    event.preventDefault();
                    void submit();
                  }}
                >
                  <label className="block space-y-2">
                    <span className="text-sm font-medium text-[var(--foreground)]">{t("login.email")}</span>
                    <div className="relative">
                      <Mail className="pointer-events-none absolute left-4 top-1/2 h-4 w-4 -translate-y-1/2 text-[var(--muted-foreground)]" />
                      <input
                        autoComplete="email"
                        className="field pl-11"
                        onChange={(event) => setEmail(event.target.value)}
                        type="email"
                        value={email}
                      />
                    </div>
                  </label>

                  <label className="block space-y-2">
                    <span className="text-sm font-medium text-[var(--foreground)]">{t("login.password")}</span>
                    <div className="relative">
                      <LockKeyhole className="pointer-events-none absolute left-4 top-1/2 h-4 w-4 -translate-y-1/2 text-[var(--muted-foreground)]" />
                      <input
                        autoComplete="current-password"
                        className="field pl-11"
                        onChange={(event) => setPassword(event.target.value)}
                        type="password"
                        value={password}
                      />
                    </div>
                  </label>

                  <Button className="mt-2 w-full justify-center" disabled={isSubmitting} size="lg" type="submit">
                    {isSubmitting ? t("login.signingIn") : t("login.login")}
                    <ArrowRight className="h-4 w-4" />
                  </Button>
                </form>

                <div className="grid gap-3 sm:grid-cols-3">
                  <div className="rounded-[1.25rem] border border-[var(--border)] bg-[var(--panel)] px-4 py-3">
                    <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{t("login.mode")}</p>
                    <p className="mt-2 text-sm font-medium text-[var(--foreground)]">{t("login.modeValue")}</p>
                  </div>
                  <div className="rounded-[1.25rem] border border-[var(--border)] bg-[var(--panel)] px-4 py-3">
                    <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{t("login.answers")}</p>
                    <p className="mt-2 text-sm font-medium text-[var(--foreground)]">{t("login.answersValue")}</p>
                  </div>
                  <div className="rounded-[1.25rem] border border-[var(--border)] bg-[var(--panel)] px-4 py-3">
                    <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{t("login.focus")}</p>
                    <p className="mt-2 text-sm font-medium text-[var(--foreground)]">{t("login.focusValue")}</p>
                  </div>
                </div>
              </div>
            </div>
          </Panel>
        </div>

        <Panel className="space-y-4 p-5 sm:p-6">
          <div className="flex flex-col gap-2 sm:flex-row sm:items-end sm:justify-between">
            <div>
              <p className="text-[11px] font-semibold uppercase tracking-[0.3em] text-[var(--muted-foreground)]">{t("login.quickActions")}</p>
              <h3 className="mt-2 text-xl font-semibold tracking-tight text-[var(--foreground)]">{t("login.quickActionsTitle")}</h3>
            </div>
            <p className="text-sm leading-6 text-[var(--muted-foreground)]">
              {t("login.quickActionsSubtitle")}
            </p>
          </div>

          <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-3">
            {quickActions.map((prompt) => (
              <button
                key={prompt}
                className="flex min-h-[4.25rem] items-center rounded-[1.4rem] border border-[var(--border)] bg-[linear-gradient(180deg,rgba(255,255,255,0.94),rgba(247,248,244,0.82))] px-4 py-4 text-left text-sm font-medium text-[var(--foreground)] shadow-[0_12px_30px_rgba(15,23,42,0.04)] transition hover:-translate-y-0.5 hover:border-[var(--accent)]/30 hover:bg-[var(--panel-subtle)] focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[var(--accent)]/30"
                type="button"
              >
                {prompt}
              </button>
            ))}
          </div>
        </Panel>
      </div>
    </div>
  );
}
