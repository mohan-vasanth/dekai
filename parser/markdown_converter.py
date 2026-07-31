from __future__ import annotations

import logging
from typing import Iterable, List

from markdown import markdown as render_markdown

from .models import SectionKnowledge


class MarkdownConverter:
    def __init__(self) -> None:
        self.logger = logging.getLogger(self.__class__.__name__)

    def convert(self, section: SectionKnowledge) -> str:
        lines: List[str] = [
            f"# Chapter {section.chapter_number} / Section {section.section}: {section.title}",
            "",
            f"**Chapter Title:** {section.chapter_title}",
            "",
            f"**Pages:** {', '.join(str(page) for page in section.pages)}",
            "",
            f"**Purpose:** {section.purpose or 'Not explicitly stated; inferred from the section context.'}",
            "",
            f"**Purpose Thanglish:** {section.purpose_thanglish}",
            "",
            f"**Summary:** {section.summary}",
            "",
            f"**Business Meaning:** {section.business_meaning}",
            "",
            f"**Business Explanation:** {section.business_explanation}",
            "",
            f"**Business Explanation Thanglish:** {section.business_explanation_thanglish}",
            "",
            "## Business Logic",
            *self._bulletize(section.business_logic),
            "",
            "## Business Rules",
            *self._dict_bulletize(section.business_rules),
            "",
            "## Conditions",
            *self._bulletize(section.conditions),
            "",
            "## Condition Logic",
            *self._dict_bulletize(section.condition_logic),
            "",
            "## Validations",
            *self._bulletize(section.validations),
            "",
            "## Exceptions",
            *self._bulletize(section.exceptions),
            "",
            "## Dependencies",
            *self._bulletize(section.dependencies),
            "",
            "## Authorities",
            *self._bulletize(section.authorities),
            "",
            "## Required Documents",
            *self._bulletize(section.required_documents or section.documents),
            "",
            "## Timelines",
            *self._bulletize(section.timelines),
            "",
            "## Actions",
            *self._bulletize(section.actions),
            "",
            "## Workflow",
            *self._bulletize(section.workflow),
            "",
            "## Workflow ASCII",
            "```text",
            section.workflow_ascii or "No workflow extracted",
            "```",
            "",
            "## Decision Tree",
            *self._bulletize(section.decision_tree),
            "",
            "## Decision Tree ASCII",
            "```text",
            section.decision_tree_ascii or "No decision tree extracted",
            "```",
            "",
            "## Examples",
            *self._bulletize(section.examples),
            "",
            f"**Real-world Example:** {section.real_world_example}",
            "",
            f"**Real-world Example Thanglish:** {section.real_world_example_thanglish}",
            "",
            "## AI Rules",
            *self._bulletize(section.ai_rules),
            "",
            "## Database Fields",
            *self._dict_bulletize(section.database_fields),
            "",
            "## API Requirements",
            *self._dict_bulletize(section.apis),
            "",
            "## UI Screens",
            *self._dict_bulletize(section.ui),
            "",
            "## Error Messages",
            *self._bulletize(section.error_messages),
            "",
            "## FAQ",
            *self._dict_bulletize(section.faq),
            "",
            "## Questions Users May Ask",
            *self._bulletize(section.questions_users_may_ask),
            "",
            "## Expected AI Answers",
            *self._bulletize(section.expected_ai_answers),
            "",
            "## AI Q&A Examples",
            *self._dict_bulletize(section.ai_qa_examples),
            "",
            "## DEKAI AI Implementation Notes",
            *self._bulletize(section.dekai_ai_implementation_notes),
            "",
            "## DEKAI AI Implementation Notes Thanglish",
            *self._bulletize(section.dekai_ai_implementation_notes_thanglish),
            "",
            "## AI Metadata",
            f"- Keywords: {', '.join(section.keywords)}",
            f"- Search Keywords: {', '.join(section.search_keywords)}",
            f"- Intent: {section.intent}",
            f"- Tags: {', '.join(section.tags)}",
            f"- Related Sections: {', '.join(section.related_sections)}",
            f"- Related Chapters: {', '.join(section.related_chapters)}",
            f"- Related Rules: {', '.join(section.related_rules)}",
            "",
            "## Mermaid",
            "```mermaid",
            section.mermaid or "flowchart TD\n    A[No workflow extracted]",
            "```",
            "",
            "## PlantUML",
            "```plantuml",
            section.plantuml or "@startuml\nstart\n:No workflow extracted;\nstop\n@enduml",
            "```",
        ]
        markdown_text = "\n".join(lines).strip() + "\n"
        render_markdown(markdown_text)
        return markdown_text

    def _bulletize(self, values: Iterable[str]) -> List[str]:
        values = list(values)
        return [f"- {value}" for value in values] if values else ["- None identified"]

    def _dict_bulletize(self, values: Iterable[dict]) -> List[str]:
        values = list(values)
        if not values:
            return ["- None identified"]
        formatted = []
        for value in values:
            pairs = ", ".join(f"{key}={item}" for key, item in value.items())
            formatted.append(f"- {pairs}")
        return formatted
