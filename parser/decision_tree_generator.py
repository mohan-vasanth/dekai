from __future__ import annotations

from typing import Dict, List

from .models import SectionKnowledge
from .utils import ascii_vertical_flow, unique_preserve


class DecisionTreeGenerator:
    def generate(self, section: SectionKnowledge) -> Dict[str, str | List[str]]:
        tree_rules: List[str] = []
        for condition in section.conditions[:5]:
            if section.actions:
                tree_rules.append(f"IF {condition} THEN {section.actions[0]}")
        for exception in section.exceptions[:3]:
            tree_rules.append(f"IF exception applies ({exception}) THEN route to manual review")
        if not tree_rules:
            default_action = section.actions[0] if section.actions else "proceed with standard DGFT workflow"
            tree_rules.append(f"IF section {section.section} applies THEN {default_action}")

        tree_rules = unique_preserve(tree_rules)
        mermaid = self._mermaid(tree_rules)
        plantuml = self._plantuml(tree_rules)
        ascii_diagram = ascii_vertical_flow(f"{section.title} Decision", tree_rules)
        return {"decision_tree": tree_rules, "mermaid": mermaid, "plantuml": plantuml, "ascii": ascii_diagram}

    def _mermaid(self, rules: List[str]) -> str:
        lines = ["flowchart TD", '    Root["Section Decision"]']
        for index, rule in enumerate(rules, start=1):
            node = f"D{index}"
            lines.append(f'    {node}["{rule.replace(chr(34), chr(39))}"]')
            lines.append(f"    Root --> {node}")
        return "\n".join(lines)

    def _plantuml(self, rules: List[str]) -> str:
        lines = ["@startuml", "start"]
        for rule in rules:
            lines.append(f":{rule.replace(':', r'\\:')};")
        lines.extend(["stop", "@enduml"])
        return "\n".join(lines)
