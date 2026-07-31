import { Component, type ErrorInfo, type ReactNode } from "react";

type Props = {
  children: ReactNode;
};

type State = {
  errorMessage: string | null;
};

export class RootErrorBoundary extends Component<Props, State> {
  state: State = {
    errorMessage: null,
  };

  static getDerivedStateFromError(error: unknown): State {
    return {
      errorMessage: error instanceof Error ? error.message : "Unknown application error.",
    };
  }

  componentDidCatch(error: unknown, info: ErrorInfo) {
    console.error("DEKAI root render error", error, info);
  }

  render() {
    if (this.state.errorMessage) {
      return (
        <div className="flex min-h-screen items-center justify-center bg-[var(--background)] px-4 py-8">
          <div className="w-full max-w-2xl rounded-[1.75rem] border border-[var(--border)] bg-[var(--panel)] p-6 shadow-[0_24px_64px_rgba(15,23,42,0.08)]">
            <p className="text-xs font-semibold uppercase tracking-[0.24em] text-[var(--muted-foreground)]">DEKAI AI</p>
            <h1 className="mt-3 text-2xl font-semibold text-[var(--foreground)]">Application Error</h1>
            <p className="mt-3 text-sm leading-7 text-[var(--muted-foreground)]">
              The interface failed during startup. The current runtime error is shown below.
            </p>
            <pre className="mt-5 overflow-x-auto rounded-[1.25rem] bg-[var(--panel-subtle)] p-4 text-sm text-[var(--foreground)]">
              {this.state.errorMessage}
            </pre>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}
