from __future__ import annotations

from typing import Dict, List

from .models import SectionKnowledge
from .utils import compact_records, slugify, unique_preserve


class UIGenerator:
    def generate(self, section: SectionKnowledge) -> List[Dict[str, object]]:
        field_names = [field["name"] for field in section.database_fields[:8]]
        screens = [
            {
                "screen_id": f"{slugify(section.title)}_overview",
                "name": f"{section.title} Overview",
                "purpose": "Show section summary, authority, timeline, and eligibility cues.",
                "widgets": ["summary_card", "conditions_table", "authority_badges", "timeline_panel"],
            },
            {
                "screen_id": f"{slugify(section.title)}_submission",
                "name": f"{section.title} Submission",
                "purpose": "Capture applicant data and supporting documents.",
                "widgets": ["dynamic_form", "document_uploader", "validation_panel", "next_action_footer"],
                "fields": field_names or ["applicant_name", "iec_number", "document_bundle"],
            },
        ]
        if section.exceptions:
            screens.append(
                {
                    "screen_id": f"{slugify(section.title)}_exceptions",
                    "name": f"{section.title} Exception Review",
                    "purpose": "Explain exception handling and manual review triggers.",
                    "widgets": ["exception_banner", "decision_tree", "case_notes"],
                }
            )
        return compact_records(screens)

    def screen_catalog(self, sections: List[SectionKnowledge]) -> Dict[str, object]:
        return {
            "screen_ids": unique_preserve(
                screen["screen_id"] for section in sections for screen in section.ui if "screen_id" in screen
            ),
            "sections": [{"section": section.section, "title": section.title, "ui": section.ui} for section in sections],
        }
