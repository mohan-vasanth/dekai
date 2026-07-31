from __future__ import annotations

import json
from typing import List

from .models import DocumentKnowledge, SectionKnowledge


class SQLGenerator:
    def generate_schema(self) -> str:
        return """CREATE TABLE IF NOT EXISTS sections (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    source_document TEXT NOT NULL,
    chapter_number TEXT NOT NULL,
    chapter_title TEXT NOT NULL,
    section_code TEXT NOT NULL,
    title TEXT NOT NULL,
    purpose TEXT,
    purpose_thanglish TEXT,
    summary TEXT,
    business_meaning TEXT,
    business_explanation TEXT,
    business_explanation_thanglish TEXT,
    raw_text TEXT,
    pages TEXT,
    keywords TEXT,
    intent TEXT,
    tags TEXT
);

CREATE TABLE IF NOT EXISTS rules (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    rule_id TEXT NOT NULL,
    section_code TEXT NOT NULL,
    rule_text TEXT NOT NULL,
    rule_type TEXT NOT NULL,
    trigger_text TEXT,
    condition_text TEXT,
    validation_text TEXT,
    action_text TEXT,
    exception_text TEXT,
    output_text TEXT
);

CREATE TABLE IF NOT EXISTS conditions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    section_code TEXT NOT NULL,
    condition_text TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS documents (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    section_code TEXT NOT NULL,
    document_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS authorities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    section_code TEXT NOT NULL,
    authority_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS timelines (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    section_code TEXT NOT NULL,
    timeline_text TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS workflows (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    section_code TEXT NOT NULL,
    step_index INTEGER NOT NULL,
    step_text TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS exceptions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    section_code TEXT NOT NULL,
    exception_text TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS glossary (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    term TEXT NOT NULL,
    definition TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS entities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    section_code TEXT NOT NULL,
    entity_type TEXT NOT NULL,
    entity_value TEXT NOT NULL
);
"""

    def generate_seed(self, document: DocumentKnowledge) -> str:
        statements: List[str] = []
        for section in document.sections:
            statements.append(self._insert_section(section))
            statements.extend(self._insert_rules(section))
            statements.extend(self._insert_simple(section.section, "conditions", "condition_text", section.conditions))
            statements.extend(self._insert_simple(section.section, "documents", "document_name", section.required_documents or section.documents))
            statements.extend(self._insert_simple(section.section, "authorities", "authority_name", section.authorities))
            statements.extend(self._insert_simple(section.section, "timelines", "timeline_text", section.timelines))
            statements.extend(self._insert_simple(section.section, "exceptions", "exception_text", section.exceptions))
            for index, step in enumerate(section.workflow, start=1):
                statements.append(
                    "INSERT INTO workflows (section_code, step_index, step_text) VALUES "
                    f"('{self._escape(section.section)}', {index}, '{self._escape(step)}');"
                )
            for entity_type, values in {"keywords": section.keywords, "tags": section.tags}.items():
                for value in values:
                    statements.append(
                        "INSERT INTO entities (section_code, entity_type, entity_value) VALUES "
                        f"('{self._escape(section.section)}', '{entity_type}', '{self._escape(value)}');"
                    )
        for term, definition in document.glossary.items():
            statements.append(
                "INSERT INTO glossary (term, definition) VALUES "
                f"('{self._escape(term)}', '{self._escape(definition)}');"
            )
        return "\n".join(statements)

    def _insert_section(self, section: SectionKnowledge) -> str:
        return (
            "INSERT INTO sections "
            "(source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) "
            "VALUES "
            f"('{self._escape(section.source_document)}', "
            f"'{self._escape(section.chapter_number)}', "
            f"'{self._escape(section.chapter_title)}', "
            f"'{self._escape(section.section)}', "
            f"'{self._escape(section.title)}', "
            f"'{self._escape(section.purpose)}', "
            f"'{self._escape(section.purpose_thanglish)}', "
            f"'{self._escape(section.summary)}', "
            f"'{self._escape(section.business_meaning)}', "
            f"'{self._escape(section.business_explanation)}', "
            f"'{self._escape(section.business_explanation_thanglish)}', "
            f"'{self._escape(section.raw_text)}', "
            f"'{self._escape(json.dumps(section.pages))}', "
            f"'{self._escape(json.dumps(section.keywords))}', "
            f"'{self._escape(section.intent)}', "
            f"'{self._escape(json.dumps(section.tags))}');"
        )

    def _insert_rules(self, section: SectionKnowledge) -> List[str]:
        rules = []
        for rule in section.business_rules:
            rules.append(
                "INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES "
                f"('{self._escape(rule['rule_id'])}', "
                f"'{self._escape(section.section)}', "
                f"'{self._escape(rule['rule_description'])}', "
                f"'business_rule', "
                f"'{self._escape(rule['trigger'])}', "
                f"'{self._escape(rule['condition'])}', "
                f"'{self._escape(rule['validation'])}', "
                f"'{self._escape(rule['action'])}', "
                f"'{self._escape(rule['exception'])}', "
                f"'{self._escape(rule['output'])}');"
            )
        return rules

    def _insert_simple(self, section: str, table: str, column: str, values: List[str]) -> List[str]:
        return [
            f"INSERT INTO {table} (section_code, {column}) VALUES ('{self._escape(section)}', '{self._escape(value)}');"
            for value in values
        ]

    def _escape(self, value: str) -> str:
        return str(value).replace("'", "''")
