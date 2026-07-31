from __future__ import annotations

from typing import Dict

import pandas as pd

from .models import DocumentKnowledge


class ReportGenerator:
    def generate(self, document: DocumentKnowledge) -> Dict[str, object]:
        summary = {
            "source_pdf": document.source_pdf.name,
            "page_count": int(document.page_count),
            "section_count": len(document.sections),
            "rule_count": sum(len(section.business_logic) + len(section.ai_rules) for section in document.sections),
            "condition_count": sum(len(section.conditions) for section in document.sections),
            "workflow_count": sum(len(section.workflow) for section in document.sections),
            "validation_count": sum(len(section.validations) for section in document.sections),
            "exception_count": sum(len(section.exceptions) for section in document.sections),
            "timeline_count": sum(len(section.timelines) for section in document.sections),
            "authority_count": sum(len(section.authorities) for section in document.sections),
            "glossary_count": len(document.glossary),
        }

        section_rows = [
            {
                "section": section.section,
                "title": section.title,
                "rules": len(section.business_logic),
                "conditions": len(section.conditions),
                "validations": len(section.validations),
                "exceptions": len(section.exceptions),
                "timelines": len(section.timelines),
                "authorities": len(section.authorities),
                "documents": len(section.required_documents or section.documents),
            }
            for section in document.sections
        ]
        table = pd.DataFrame(section_rows)
        return {
            "summary": summary,
            "sections": section_rows,
            "section_table_markdown": self._to_markdown(table) if not table.empty else "No sections extracted.",
            "section_table_csv": table.to_csv(index=False) if not table.empty else "",
        }

    def _to_markdown(self, dataframe: pd.DataFrame) -> str:
        headers = list(dataframe.columns)
        header_row = "| " + " | ".join(headers) + " |"
        separator = "| " + " | ".join(["---"] * len(headers)) + " |"
        rows = []
        for _, row in dataframe.iterrows():
            rows.append("| " + " | ".join(str(row[column]) for column in headers) + " |")
        return "\n".join([header_row, separator, *rows])
