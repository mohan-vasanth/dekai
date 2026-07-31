from __future__ import annotations

from typing import Any

from config import CONFIG

from .knowledge_engine import knowledge_engine_service
from .pipeline_service import pipeline_service
from .settings_service import settings_service


class DataService:
    def get_app_state(self) -> dict[str, Any]:
        pipeline_service.ensure_knowledge_base()
        settings = settings_service.get_settings()
        index = knowledge_engine_service.load_index()
        stats = index.get("statistics", {})

        return {
            "metadata": {
                "generatedAt": index.get("generatedAt"),
                "knowledgeBaseName": index.get("knowledgeBaseName", settings["metadata"]["knowledgeBaseName"]),
                "models": {
                    "llm": settings.get("aiModel"),
                    "embeddings": settings["metadata"]["embeddings"],
                    "vectorDatabase": settings["metadata"]["vectorDatabase"],
                    "chunking": settings["metadata"]["chunking"],
                },
            },
            "metrics": {
                "totalPdfs": int(stats.get("documents", 0)),
                "totalPages": int(stats.get("pages", 0)),
                "totalSections": int(stats.get("sections", 0)),
                "totalRules": int(stats.get("businessRules", 0)),
                "totalWorkflows": int(stats.get("workflows", 0)),
                "totalConditions": int(stats.get("conditions", 0)),
                "totalExceptions": int(stats.get("exceptions", 0)),
                "totalAuthorities": int(stats.get("authorities", 0)),
                "totalGlossaryTerms": len(index.get("definitions", [])),
            },
            "documents": index.get("documents", []),
            "chapters": index.get("chapters", []),
            "sections": index.get("sections", []),
            "rules": [
                {
                    "ruleId": rule["id"],
                    "ruleName": rule["ruleName"],
                    "section": rule["sectionId"],
                    "sectionTitle": rule["sectionTitle"],
                    "description": rule["description"],
                    "condition": rule["condition"],
                    "exception": rule["exception"],
                    "authority": next(
                        (
                            section["authorities"][0]
                            for section in index.get("sections", [])
                            if section["id"] == rule["sectionId"] and section.get("authorities")
                        ),
                        "DGFT",
                    ),
                    "timeline": next(
                        (
                            section["timelines"][0]
                            for section in index.get("sections", [])
                            if section["id"] == rule["sectionId"] and section.get("timelines")
                        ),
                        "Timeline not explicit",
                    ),
                }
                for rule in index.get("rules", [])
            ],
            "workflows": index.get("workflows", []),
            "glossary": [
                {
                    "term": definition["term"],
                    "definition": definition["definition"],
                    "chapterSource": definition["chapterNumber"],
                }
                for definition in index.get("definitions", [])
            ],
            "definitions": index.get("definitions", []),
            "conditions": index.get("conditions", []),
            "relationships": index.get("relationships", []),
            "statistics": stats,
            "explorer": index.get("explorer", []),
            "knowledgeGraph": index.get("knowledgeGraph", {}),
            "versionHistory": index.get("versionHistory", []),
            "schema": index.get("schema", {}),
        }

    def get_overview(self) -> dict[str, Any]:
        state = self.get_app_state()
        return {
            "metrics": state["metrics"],
            "metadata": state["metadata"],
            "knowledgeStatus": "Ready" if state["metrics"]["totalPdfs"] > 0 else settings_service.get_settings().get("knowledgeStatus", "Ready"),
        }

    def get_statistics(self) -> dict[str, Any]:
        return self.get_app_state().get("statistics", {})

    def get_explorer(self) -> list[dict[str, Any]]:
        return self.get_app_state().get("explorer", [])

    def get_graph(self) -> dict[str, Any]:
        return self.get_app_state().get("knowledgeGraph", {})

    def get_schema(self) -> dict[str, Any]:
        return self.get_app_state().get("schema", {})


data_service = DataService()
