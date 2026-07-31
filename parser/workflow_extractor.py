from __future__ import annotations

from typing import Dict, List

from .base import BaseExtractor
from .models import SectionKnowledge
from .utils import ascii_vertical_flow, unique_preserve


class WorkflowExtractor(BaseExtractor):
    def extract(self, section: SectionKnowledge) -> Dict[str, str | List[str]]:
        steps: List[str] = []
        if section.conditions:
            steps.extend([f"Evaluate condition: {condition}" for condition in section.conditions[:3]])
        steps.extend(section.actions[:6])
        if section.validations:
            steps.extend([f"Run validation: {validation}" for validation in section.validations[:3]])
        if section.exceptions:
            steps.append(f"Handle exception: {section.exceptions[0]}")
        if not steps:
            steps = [f"Review section {section.section} requirements", "Capture applicant inputs", "Route for authority decision"]

        steps = unique_preserve(steps)
        mermaid = self._build_mermaid(steps)
        plantuml = self._build_plantuml(steps)
        ascii_diagram = ascii_vertical_flow(section.title, steps)
        return {"workflow": steps, "mermaid": mermaid, "plantuml": plantuml, "ascii": ascii_diagram}

    def _build_mermaid(self, steps: List[str]) -> str:
        lines = ["flowchart TD"]
        for index, step in enumerate(steps, start=1):
            node = f"S{index}"
            label = step.replace('"', "'")
            lines.append(f'    {node}["{label}"]')
            if index > 1:
                lines.append(f"    S{index - 1} --> {node}")
        return "\n".join(lines)

    def _build_plantuml(self, steps: List[str]) -> str:
        lines = ["@startuml", "start"]
        for step in steps:
            label = step.replace(":", r"\:")
            lines.append(f":{label};")
        lines.extend(["stop", "@enduml"])
        return "\n".join(lines)
