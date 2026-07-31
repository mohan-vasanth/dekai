import { ArrowDown } from "lucide-react";
import { Panel } from "./ui";

export function WorkflowGraph({
  title,
  steps,
}: {
  title: string;
  steps: string[];
}) {
  return (
    <Panel className="overflow-hidden">
      <div className="mb-6 flex items-center justify-between gap-3">
        <div>
          <p className="text-sm uppercase tracking-[0.2em] text-[var(--muted-foreground)]">
            Workflow
          </p>
          <h3 className="mt-2 text-2xl font-semibold text-[var(--foreground)]">{title}</h3>
        </div>
      </div>
      <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-4">
        {steps.map((step, index) => (
          <div key={`${step}-${index}`} className="relative rounded-3xl border border-[var(--border)] bg-[var(--surface)] p-5">
            <span className="text-xs uppercase tracking-[0.24em] text-[var(--muted-foreground)]">
              Step {index + 1}
            </span>
            <p className="mt-3 text-sm leading-6 text-[var(--foreground)]">{step}</p>
            {index < steps.length - 1 ? (
              <ArrowDown className="mt-6 h-5 w-5 text-[var(--accent)] md:hidden" />
            ) : null}
          </div>
        ))}
      </div>
    </Panel>
  );
}
