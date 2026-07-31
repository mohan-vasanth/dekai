import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter } from "react-router-dom";
import App from "./App";
import { RootErrorBoundary } from "./components/error-boundary";
import { AppNavigationProvider } from "./components/navigation";
import { RouteScrollRestoration } from "./components/scroll-restoration";
import { ToastProvider } from "./components/ui";
import { AuthProvider } from "./hooks/use-auth";
import "./index.css";
import { PreferencesProvider } from "./lib/preferences";
import { ThemeProvider } from "./lib/theme";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: 2,
      refetchOnWindowFocus: false,
    },
    mutations: {
      retry: 1,
    },
  },
});

let bootFailed = false;

function renderBootError(message: string) {
  if (bootFailed) return;
  bootFailed = true;
  const root = document.getElementById("root");
  if (!root) return;
  root.innerHTML = `
    <div style="min-height:100vh;display:flex;align-items:center;justify-content:center;padding:32px;background:var(--background);font-family:Manrope,system-ui,sans-serif;">
      <div style="width:100%;max-width:720px;border:1px solid var(--border);background:var(--panel);border-radius:28px;padding:24px;box-shadow:0 24px 64px rgba(15,23,42,.08);color:var(--foreground);">
        <div style="font-size:12px;font-weight:700;letter-spacing:.24em;text-transform:uppercase;color:var(--muted-foreground);">DEKAI AI</div>
        <h1 style="margin:12px 0 0;font-size:28px;line-height:1.2;">Startup Error</h1>
        <p style="margin:12px 0 0;color:var(--muted-foreground);line-height:1.7;">The application failed before React could finish rendering.</p>
        <pre style="margin:20px 0 0;white-space:pre-wrap;overflow:auto;padding:16px;border-radius:20px;background:var(--panel-subtle);color:var(--foreground);">${message}</pre>
      </div>
    </div>
  `;
}

window.addEventListener("error", (event) => {
  if (!bootFailed && event.error instanceof Error && !document.querySelector("[data-dekai-root='mounted']")) {
    renderBootError(event.error.message);
  }
});

window.addEventListener("unhandledrejection", (event) => {
  if (!bootFailed && !document.querySelector("[data-dekai-root='mounted']")) {
    const reason = event.reason instanceof Error ? event.reason.message : String(event.reason ?? "Unknown promise rejection");
    renderBootError(reason);
  }
});

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <div data-dekai-root="mounted">
      <RootErrorBoundary>
        <QueryClientProvider client={queryClient}>
          <ThemeProvider>
            <AuthProvider>
              <PreferencesProvider>
                <ToastProvider>
                  <BrowserRouter>
                    <AppNavigationProvider>
                      <RouteScrollRestoration />
                      <App />
                    </AppNavigationProvider>
                  </BrowserRouter>
                </ToastProvider>
              </PreferencesProvider>
            </AuthProvider>
          </ThemeProvider>
        </QueryClientProvider>
      </RootErrorBoundary>
    </div>
  </StrictMode>,
);
