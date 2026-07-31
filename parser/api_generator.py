from __future__ import annotations

from typing import Dict, List

from .models import SectionKnowledge
from .utils import compact_records, slugify, unique_preserve


class APIGenerator:
    def generate(self, section: SectionKnowledge) -> List[Dict[str, object]]:
        resource_name = slugify(section.title).replace("_", "-")
        required_fields = [field["name"] for field in section.database_fields if field.get("required")]
        endpoints = [
            {
                "method": "GET",
                "path": f"/api/dgft/sections/{section.section}",
                "purpose": f"Retrieve knowledge payload for section {section.section}",
                "query_params": ["include=workflow,decision_tree,validations"],
                "response_fields": [
                    "section",
                    "title",
                    "summary",
                    "conditions",
                    "validations",
                    "exceptions",
                    "workflow",
                    "decision_tree",
                ],
            },
            {
                "method": "POST",
                "path": f"/api/dgft/{resource_name}/validate",
                "purpose": f"Validate inputs and documents for {section.title}",
                "request_fields": required_fields or ["applicant_id", "documents", "context"],
                "response_fields": ["status", "errors", "warnings", "next_actions"],
            },
        ]
        if section.actions:
            endpoints.append(
                {
                    "method": "POST",
                    "path": f"/api/dgft/{resource_name}/execute",
                    "purpose": f"Trigger business action for {section.actions[0]}",
                    "request_fields": required_fields or ["application_payload"],
                    "response_fields": ["reference_id", "status", "authority", "timeline"],
                }
            )
        return compact_records(endpoints)

    def document_catalog(self, sections: List[SectionKnowledge]) -> Dict[str, object]:
        return {
            "resources": unique_preserve([slugify(section.title).replace("_", "-") for section in sections]),
            "sections": [
                {
                    "section": section.section,
                    "title": section.title,
                    "apis": section.apis,
                }
                for section in sections
            ],
        }
