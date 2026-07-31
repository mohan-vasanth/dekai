import { AnimatePresence, motion, type HTMLMotionProps } from "framer-motion";
import { createContext, useContext, useMemo, useState, type ButtonHTMLAttributes, type PropsWithChildren } from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "../lib/utils";

const buttonVariants = cva(
  "inline-flex items-center justify-center gap-2 rounded-2xl font-medium transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[var(--accent)]/30 disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        primary: "bg-[var(--accent)] px-4 py-2.5 text-[var(--accent-foreground)] shadow-[0_12px_32px_rgba(37,99,235,0.22)] hover:bg-[var(--accent-strong)]",
        secondary: "border border-[var(--border)] bg-[var(--panel)] px-4 py-2.5 text-[var(--foreground)] hover:border-[var(--accent)]/35 hover:bg-[var(--panel-subtle)]",
        ghost: "px-3 py-2.5 text-[var(--muted-foreground)] hover:bg-[var(--panel-subtle)] hover:text-[var(--foreground)]",
        danger: "bg-[var(--danger)] px-4 py-2.5 text-white shadow-[0_12px_28px_rgba(239,68,68,0.18)] hover:brightness-95",
      },
      size: {
        sm: "text-sm",
        md: "text-sm",
        lg: "px-5 py-3 text-base",
      },
    },
    defaultVariants: {
      variant: "primary",
      size: "md",
    },
  },
);

type ButtonProps = ButtonHTMLAttributes<HTMLButtonElement> & VariantProps<typeof buttonVariants>;

export function Button({ className, size, variant, ...props }: ButtonProps) {
  return <button className={cn(buttonVariants({ size, variant }), className)} {...props} />;
}

export function Badge({
  children,
  tone = "default",
}: PropsWithChildren<{ tone?: "default" | "success" | "warning" | "danger" | "info" }>) {
  const tones = {
    default: "border border-[var(--border)] bg-[var(--panel-subtle)] text-[var(--foreground)]",
    success: "bg-emerald-500/12 text-emerald-500 ring-1 ring-emerald-500/20",
    warning: "bg-amber-500/12 text-amber-500 ring-1 ring-amber-500/20",
    danger: "bg-rose-500/12 text-rose-500 ring-1 ring-rose-500/20",
    info: "bg-sky-500/12 text-sky-500 ring-1 ring-sky-500/20",
  };

  return <span className={cn("inline-flex items-center rounded-full px-3 py-1 text-xs font-semibold", tones[tone])}>{children}</span>;
}

export function Panel({
  children,
  className,
}: PropsWithChildren<{ className?: string }>) {
  return <section className={cn("panel", className)}>{children}</section>;
}

export function ProgressBar({
  label,
  value,
}: {
  label?: string;
  value: number;
}) {
  return (
    <div className="space-y-2">
      <div className="flex items-center justify-between text-xs font-medium text-[var(--muted-foreground)]">
        <span>{label ?? "Progress"}</span>
        <span>{Math.round(value)}%</span>
      </div>
      <div className="h-2 overflow-hidden rounded-full bg-[var(--panel-subtle)]">
        <motion.div
          animate={{ width: `${Math.max(0, Math.min(100, value))}%` }}
          className="h-full rounded-full bg-[linear-gradient(90deg,var(--accent),#60a5fa)]"
          transition={{ duration: 0.35, ease: "easeOut" }}
        />
      </div>
    </div>
  );
}

type Toast = {
  id: number;
  title: string;
  description?: string;
  tone?: "success" | "warning" | "info";
};

const ToastContext = createContext<{ pushToast: (toast: Omit<Toast, "id">) => void } | null>(null);

export function ToastProvider({ children }: PropsWithChildren) {
  const [toasts, setToasts] = useState<Toast[]>([]);

  const value = useMemo(
    () => ({
      pushToast: (toast: Omit<Toast, "id">) => {
        const id = Date.now() + Math.round(Math.random() * 1000);
        const next = { ...toast, id };
        setToasts((current) => [...current, next]);
        window.setTimeout(() => {
          setToasts((current) => current.filter((item) => item.id !== id));
        }, 2600);
      },
    }),
    [],
  );

  return (
    <ToastContext.Provider value={value}>
      {children}
      <div className="pointer-events-none fixed bottom-5 right-5 z-[60] space-y-3">
        <AnimatePresence>
          {toasts.map((toast) => (
            <motion.div
              key={toast.id}
              animate={{ opacity: 1, y: 0 }}
              className="pointer-events-auto w-80 rounded-[1.4rem] border border-[var(--border)] bg-[var(--panel)] p-4 shadow-[0_22px_48px_rgba(15,23,42,0.16)]"
              exit={{ opacity: 0, y: 12 }}
              initial={{ opacity: 0, y: 12 }}
            >
              <div className="flex items-center justify-between gap-3">
                <Badge tone={toast.tone ?? "info"}>{toast.tone ?? "info"}</Badge>
                <span className="text-xs font-medium text-[var(--muted-foreground)]">DEKAI AI</span>
              </div>
              <p className="mt-3 text-sm font-semibold text-[var(--foreground)]">{toast.title}</p>
              {toast.description ? <p className="mt-1 text-sm leading-6 text-[var(--muted-foreground)]">{toast.description}</p> : null}
            </motion.div>
          ))}
        </AnimatePresence>
      </div>
    </ToastContext.Provider>
  );
}

export const useToast = () => {
  const context = useContext(ToastContext);
  if (!context) {
    throw new Error("useToast must be used inside ToastProvider");
  }

  return context;
};

export function PageMotion({
  children,
  ...props
}: PropsWithChildren<HTMLMotionProps<"div">>) {
  return (
    <motion.div
      animate={{ opacity: 1, y: 0 }}
      initial={{ opacity: 0, y: 10 }}
      transition={{ duration: 0.24, ease: "easeOut" }}
      {...props}
    >
      {children}
    </motion.div>
  );
}
