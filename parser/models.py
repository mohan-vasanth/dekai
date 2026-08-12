from __future__ import annotations

from dataclasses import asdict, dataclass, field
from pathlib import Path
from typing import Any, Dict, List


@dataclass
class PageAnalysis:
    page_number: int
    text: str
    tables: List[List[List[str]]] = field(default_factory=list)
    blocks: List[str] = field(default_factory=list)
    metadata: Dict[str, Any] = field(default_factory=dict)


@dataclass
class SectionDraft:
    chapter_number: str
    chapter_title: str
    section_number: str
    title: str
    content: str
    page_numbers: List[int]
    source_document: str
    tables: List[List[List[str]]] = field(default_factory=list)


@dataclass
class DependencyEdge:
    source_section: str
    target: str
    relation: str


@dataclass
class SemanticChunk:
    chunk_id: str
    document_name: str
    chapter_number: str
    chapter_title: str
    section: str
    title: str
    chunk_index: int
    text: str
    keywords: List[str]
    intent: str
    tags: List[str]
    related_sections: List[str]
    source_pages: List[int]
    hs_codes: List[str] = field(default_factory=list)
    exim_codes: List[str] = field(default_factory=list)
    description: str = ""
    chunk_hash: str = ""
    is_table_row: bool = False
    heading: str = ""
    field_names: List[str] = field(default_factory=list)
    document_type: str = ""
    xml_tag: str = ""
    field_code: str = ""
    field_name: str = ""
    section_name: str = ""
    section_path: str = ""
    page_number: int = 0
    source_text: str = ""
    tag_name: str = ""
    normalized_tag_name: str = ""
    namespace: str = ""
    xml_fields: List[Dict[str, Any]] = field(default_factory=list)

    def to_dict(self) -> Dict[str, Any]:
        return asdict(self)


@dataclass
class SectionKnowledge:
    chapter_number: str
    chapter_title: str
    section: str
    title: str
    purpose: str
    purpose_thanglish: str
    summary: str
    business_meaning: str
    business_explanation: str
    business_explanation_thanglish: str
    business_logic: List[str] = field(default_factory=list)
    conditions: List[str] = field(default_factory=list)
    condition_logic: List[Dict[str, Any]] = field(default_factory=list)
    validations: List[str] = field(default_factory=list)
    exceptions: List[str] = field(default_factory=list)
    dependencies: List[str] = field(default_factory=list)
    authorities: List[str] = field(default_factory=list)
    documents: List[str] = field(default_factory=list)
    timelines: List[str] = field(default_factory=list)
    actions: List[str] = field(default_factory=list)
    workflow: List[str] = field(default_factory=list)
    workflow_ascii: str = ""
    decision_tree: List[str] = field(default_factory=list)
    decision_tree_ascii: str = ""
    examples: List[str] = field(default_factory=list)
    real_world_example: str = ""
    real_world_example_thanglish: str = ""
    ai_rules: List[str] = field(default_factory=list)
    business_rules: List[Dict[str, Any]] = field(default_factory=list)
    database_fields: List[Dict[str, Any]] = field(default_factory=list)
    apis: List[Dict[str, Any]] = field(default_factory=list)
    ui: List[Dict[str, Any]] = field(default_factory=list)
    error_messages: List[str] = field(default_factory=list)
    questions_users_may_ask: List[str] = field(default_factory=list)
    expected_ai_answers: List[str] = field(default_factory=list)
    faq: List[Dict[str, str]] = field(default_factory=list)
    ai_qa_examples: List[Dict[str, str]] = field(default_factory=list)
    dekai_ai_implementation_notes: List[str] = field(default_factory=list)
    dekai_ai_implementation_notes_thanglish: List[str] = field(default_factory=list)
    keywords: List[str] = field(default_factory=list)
    search_keywords: List[str] = field(default_factory=list)
    intent: str = ""
    tags: List[str] = field(default_factory=list)
    related_sections: List[str] = field(default_factory=list)
    related_chapters: List[str] = field(default_factory=list)
    related_rules: List[str] = field(default_factory=list)
    required_documents: List[str] = field(default_factory=list)
    tables: List[List[List[str]]] = field(default_factory=list)
    hierarchy_nodes: List[Dict[str, Any]] = field(default_factory=list)
    raw_text: str = ""
    pages: List[int] = field(default_factory=list)
    source_document: str = ""
    mermaid: str = ""
    plantuml: str = ""

    def to_dict(self) -> Dict[str, Any]:
        return {
            "chapter_number": self.chapter_number,
            "chapter_title": self.chapter_title,
            "section": self.section,
            "title": self.title,
            "purpose": self.purpose,
            "purpose_thanglish": self.purpose_thanglish,
            "summary": self.summary,
            "business_meaning": self.business_meaning,
            "business_explanation": self.business_explanation,
            "business_explanation_thanglish": self.business_explanation_thanglish,
            "business_logic": self.business_logic,
            "business_rules": self.business_rules,
            "conditions": self.conditions,
            "condition_logic": self.condition_logic,
            "validations": self.validations,
            "exceptions": self.exceptions,
            "dependencies": self.dependencies,
            "documents": self.documents,
            "required_documents": self.required_documents,
            "tables": self.tables,
            "hierarchy_nodes": self.hierarchy_nodes,
            "authorities": self.authorities,
            "timelines": self.timelines,
            "actions": self.actions,
            "workflow": self.workflow,
            "workflow_ascii": self.workflow_ascii,
            "decision_tree": self.decision_tree,
            "decision_tree_ascii": self.decision_tree_ascii,
            "examples": self.examples,
            "real_world_example": self.real_world_example,
            "real_world_example_thanglish": self.real_world_example_thanglish,
            "ai_rules": self.ai_rules,
            "database_fields": self.database_fields,
            "apis": self.apis,
            "ui": self.ui,
            "error_messages": self.error_messages,
            "questions_users_may_ask": self.questions_users_may_ask,
            "expected_ai_answers": self.expected_ai_answers,
            "faq": self.faq,
            "ai_question_and_answer_examples": self.ai_qa_examples,
            "dekai_ai_implementation_notes": self.dekai_ai_implementation_notes,
            "dekai_ai_implementation_notes_thanglish": self.dekai_ai_implementation_notes_thanglish,
            "keywords": self.keywords,
            "search_keywords": self.search_keywords,
            "intent": self.intent,
            "tags": self.tags,
            "related_sections": self.related_sections,
            "related_chapters": self.related_chapters,
            "related_rules": self.related_rules,
            "page_numbers": self.pages,
            "pages": self.pages,
            "source_document": self.source_document,
            "raw_text": self.raw_text,
            "mermaid": self.mermaid,
            "plantuml": self.plantuml,
        }


@dataclass
class DocumentKnowledge:
    source_pdf: Path
    sections: List[SectionKnowledge] = field(default_factory=list)
    glossary: Dict[str, str] = field(default_factory=dict)
    entities: Dict[str, List[str]] = field(default_factory=dict)
    dependency_edges: List[DependencyEdge] = field(default_factory=list)
    report_counts: Dict[str, int] = field(default_factory=dict)
    page_count: int = 0

    def to_dict(self) -> Dict[str, Any]:
        return {
            "source_pdf": str(self.source_pdf),
            "sections": [section.to_dict() for section in self.sections],
            "glossary": self.glossary,
            "entities": self.entities,
            "dependency_edges": [asdict(edge) for edge in self.dependency_edges],
            "report_counts": self.report_counts,
            "page_count": self.page_count,
        }
