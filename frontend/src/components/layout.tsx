import { AnimatePresence, motion } from "framer-motion";
import {
  BookOpenText,
  FileText,
  Menu,
  MessageSquarePlus,
  MoonStar,
  Search,
  Settings2,
  SunMedium,
  Upload,
  X,
} from "lucide-react";
import { useEffect, useMemo, useState, type PropsWithChildren } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import { useAuth } from "../hooks/use-auth";
import { useSettings } from "../hooks/use-settings";
import { usePreferences } from "../lib/preferences";
import { useTheme } from "../lib/theme";
import { cn, getInitials } from "../lib/utils";
import { chatHistoryStorage, type ChatHistoryEntry } from "../services/chat-history";
import { Badge, Button } from "./ui";

function BrandBlock() {
  const { t } = usePreferences();
  return (
    <div className="rounded-[1.75rem] border border-[var(--border)] bg-[linear-gradient(180deg,rgba(15,118,110,0.08),rgba(255,255,255,0.96))] p-4">
      <div className="flex items-center gap-3">
        <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-[linear-gradient(135deg,var(--accent),var(--accent-strong))] text-sm font-semibold text-white shadow-[0_18px_40px_rgba(15,118,110,0.24)]">
          DK
        </div>
        <div>
          <p className="text-xs font-semibold uppercase tracking-[0.26em] text-[var(--muted-foreground)]">DEKAI AI</p>
          <p className="text-sm font-semibold text-[var(--foreground)]">{t("layout.brandSubtitle")}</p>
        </div>
      </div>
    </div>
  );
}

function Sidebar({ onNavigate }: { onNavigate?: () => void }) {
  const location = useLocation();
  const navigate = useNavigate();
  const { user } = useAuth();
  const { t } = usePreferences();
  const [chatHistory, setChatHistory] = useState<ChatHistoryEntry[]>([]);
  const navigation = [
    { label: t("common.documents"), path: "/documents", icon: Upload, adminOnly: true },
    { label: t("common.pdfToMarkdown"), path: "/pdf-to-markdown", icon: FileText },
    { label: t("common.knowledgeBase"), path: "/knowledge-base", icon: BookOpenText },
    { label: t("common.search"), path: "/search", icon: Search },
    { label: t("common.settings"), path: "/settings", icon: Settings2 },
  ];
  const visibleNavigation = navigation.filter((item) => !item.adminOnly || user?.role === "admin");
  const recentHistory = Array.isArray(chatHistory)
    ? chatHistory.filter((entry) => entry && typeof entry.id === "string" && typeof entry.question === "string")
    : [];

  useEffect(() => {
    const syncHistory = () => setChatHistory(chatHistoryStorage.list());
    syncHistory();
    return chatHistoryStorage.subscribe(syncHistory);
  }, []);

  return (
    <aside className="flex h-full flex-col gap-4">
      <BrandBlock />

      <Button
        className="w-full justify-center"
        onClick={() => {
          navigate(`/chat?new=${Date.now()}`);
          onNavigate?.();
        }}
      >
        <MessageSquarePlus className="h-4 w-4" />
        {t("layout.newChat")}
      </Button>

      <div className="space-y-2">
        {visibleNavigation.map((item) => {
          const active = location.pathname.startsWith(item.path);
          const Icon = item.icon;
          return (
            <Link
              key={item.path}
              className={cn(
                "flex items-center justify-between rounded-2xl px-4 py-3 text-sm font-medium transition",
                active
                  ? "bg-[var(--panel-strong)] text-[var(--foreground)]"
                  : "text-[var(--muted-foreground)] hover:bg-[var(--panel-subtle)] hover:text-[var(--foreground)]",
              )}
              onClick={onNavigate}
              to={item.path}
            >
              <span className="flex items-center gap-3">
                <Icon className="h-4 w-4" />
                {item.label}
              </span>
              {item.adminOnly ? <Badge>Admin</Badge> : null}
            </Link>
          );
        })}
      </div>

      <div className="space-y-3 rounded-[1.75rem] border border-[var(--border)] bg-[var(--panel)] p-4">
        <div className="flex items-center justify-between gap-3">
          <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--muted-foreground)]">{t("layout.chatHistory")}</p>
          <Badge>Recent</Badge>
        </div>

        <div className="space-y-2">
          {recentHistory.length > 0 ? (
            recentHistory.map((item) => (
              <button
                key={item.id}
                className="w-full rounded-2xl px-3 py-3 text-left text-sm text-[var(--muted-foreground)] transition hover:bg-[var(--panel-subtle)] hover:text-[var(--foreground)]"
                onClick={() => {
                  navigate(`/chat?new=${Date.now()}&q=${encodeURIComponent(item.question)}`);
                  onNavigate?.();
                }}
                type="button"
              >
                {item.question}
              </button>
            ))
          ) : (
            <div className="rounded-2xl bg-[var(--panel-subtle)] px-3 py-3 text-sm text-[var(--muted-foreground)]">
              {t("layout.chatHistoryEmpty")}
            </div>
          )}
        </div>
      </div>

      <div className="mt-auto rounded-[1.75rem] border border-[var(--border)] bg-[var(--panel-subtle)] p-4">
        <p className="text-sm font-semibold text-[var(--foreground)]">{t("layout.builtForTrade")}</p>
        <p className="mt-2 text-sm leading-6 text-[var(--muted-foreground)]">
          {t("layout.builtForTradeBody")}
        </p>
      </div>
    </aside>
  );
}

export function AppShell({ children }: PropsWithChildren) {
  const location = useLocation();
  const [mobileOpen, setMobileOpen] = useState(false);
  const { resolvedTheme, setMode, toggleTheme } = useTheme();
  const { t } = usePreferences();
  const { logout, user } = useAuth();
  const { data: settings } = useSettings(Boolean(user));

  useEffect(() => {
    if (settings?.theme) {
      setMode(settings.theme);
    }
  }, [setMode, settings?.theme]);

  const pageMeta = useMemo(() => {
    if (location.pathname.startsWith("/documents")) {
      return { title: t("layout.page.documents.title"), subtitle: t("layout.page.documents.subtitle") };
    }
    if (location.pathname.startsWith("/pdf-to-markdown")) {
      return { title: t("layout.page.pdf.title"), subtitle: t("layout.page.pdf.subtitle") };
    }
    if (location.pathname.startsWith("/knowledge-base")) {
      return { title: t("layout.page.knowledge.title"), subtitle: t("layout.page.knowledge.subtitle") };
    }
    if (location.pathname.startsWith("/search")) {
      return { title: t("layout.page.search.title"), subtitle: t("layout.page.search.subtitle") };
    }
    if (location.pathname.startsWith("/settings")) {
      return { title: t("layout.page.settings.title"), subtitle: t("layout.page.settings.subtitle") };
    }
    return { title: t("layout.page.chat.title"), subtitle: t("layout.page.chat.subtitle") };
  }, [location.pathname, t]);

  return (
    <div className="min-h-screen bg-[var(--background)] text-[var(--foreground)]">
      <div className="mx-auto grid min-h-screen max-w-[1640px] gap-4 px-3 py-3 lg:grid-cols-[300px_minmax(0,1fr)] lg:px-5 lg:py-5">
        <div className="hidden lg:block">
          <div className="sticky top-5 h-[calc(100vh-2.5rem)] rounded-[2rem] border border-[var(--border)] bg-[var(--surface)] p-4 shadow-[0_24px_64px_rgba(15,23,42,0.06)] backdrop-blur-xl">
            <Sidebar />
          </div>
        </div>

        <div className="min-w-0">
          <header className="sticky top-3 z-30 flex items-center justify-between rounded-[1.75rem] border border-[var(--border)] bg-[var(--surface)] px-4 py-3 shadow-[0_18px_48px_rgba(15,23,42,0.06)] backdrop-blur-xl lg:px-5">
            <div className="flex items-center gap-3">
              <button
                className="inline-flex h-11 w-11 items-center justify-center rounded-2xl border border-[var(--border)] bg-[var(--panel)] text-[var(--foreground)] lg:hidden"
                onClick={() => setMobileOpen(true)}
                type="button"
              >
                <Menu className="h-4 w-4" />
              </button>
              <div>
                <p className="text-xs font-semibold uppercase tracking-[0.22em] text-[var(--muted-foreground)]">DEKAI AI</p>
                <h2 className="text-base font-semibold text-[var(--foreground)] sm:text-lg">{pageMeta.title}</h2>
                <p className="hidden text-sm text-[var(--muted-foreground)] sm:block">{pageMeta.subtitle}</p>
              </div>
            </div>

            <div className="flex items-center gap-2 sm:gap-3">
              <button
                className="inline-flex h-11 w-11 items-center justify-center rounded-2xl border border-[var(--border)] bg-[var(--panel)] text-[var(--foreground)] transition hover:border-[var(--accent)]/35"
                onClick={toggleTheme}
                type="button"
              >
                {resolvedTheme === "dark" ? <SunMedium className="h-4 w-4" /> : <MoonStar className="h-4 w-4" />}
              </button>

              <button
                className="flex items-center gap-3 rounded-2xl border border-[var(--border)] bg-[var(--panel)] px-3 py-2"
                onClick={logout}
                type="button"
              >
                <span className="flex h-9 w-9 items-center justify-center rounded-2xl bg-[var(--panel-strong)] text-sm font-semibold text-[var(--foreground)]">
                  {getInitials(user?.name ?? "DEKAI User")}
                </span>
                <div className="hidden text-left sm:block">
                  <p className="text-sm font-semibold text-[var(--foreground)]">{user?.name ?? "DEKAI User"}</p>
                  <p className="text-xs text-[var(--muted-foreground)]">{user?.email ?? "Logged in"}</p>
                </div>
              </button>
            </div>
          </header>

          <main className="px-1 pb-8 pt-5 lg:px-2">{children}</main>
        </div>
      </div>

      <AnimatePresence>
        {mobileOpen ? (
          <motion.div
            animate={{ opacity: 1 }}
            className="fixed inset-0 z-50 bg-slate-950/45 p-3 lg:hidden"
            exit={{ opacity: 0 }}
            initial={{ opacity: 0 }}
          >
            <motion.div
              animate={{ x: 0 }}
              className="h-full max-w-sm rounded-[2rem] border border-[var(--border)] bg-[var(--surface)] p-4 shadow-[0_24px_64px_rgba(15,23,42,0.16)] backdrop-blur-xl"
              exit={{ x: -20 }}
              initial={{ x: -20 }}
            >
              <div className="mb-4 flex justify-end">
                <button
                  className="inline-flex h-11 w-11 items-center justify-center rounded-2xl border border-[var(--border)] bg-[var(--panel)] text-[var(--foreground)]"
                  onClick={() => setMobileOpen(false)}
                  type="button"
                >
                  <X className="h-4 w-4" />
                </button>
              </div>
              <Sidebar onNavigate={() => setMobileOpen(false)} />
            </motion.div>
          </motion.div>
        ) : null}
      </AnimatePresence>
    </div>
  );
}
