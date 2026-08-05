from __future__ import annotations

import logging
import re
from pathlib import Path
from typing import Callable, Dict, List

from config import CONFIG
from parser.api_generator import APIGenerator
from parser.authority_extractor import AuthorityExtractor
from parser.chunker import Chunker
from parser.condition_extractor import ConditionExtractor
from parser.decision_tree_generator import DecisionTreeGenerator
from parser.dependency_extractor import DependencyExtractor
from parser.glossary_extractor import GlossaryExtractor
from parser.knowledge_base_builder import KnowledgeBaseBuilder
from parser.markdown_converter import MarkdownConverter
from parser.models import DocumentKnowledge, SectionKnowledge
from parser.pdf_loader import PDFLoader
from parser.report_generator import ReportGenerator
from parser.rule_extractor import RuleExtractor
from parser.sql_generator import SQLGenerator
from parser.text_cleaner import TextCleaner
from parser.timeline_extractor import TimelineExtractor
from parser.ui_generator import UIGenerator
from parser.utils import safe_section_slug, write_json, write_text
from parser.validation_extractor import ValidationExtractor
from parser.exception_extractor import ExceptionExtractor
from parser.workflow_extractor import WorkflowExtractor


def configure_logging() -> None:
    CONFIG.ensure_directories()
    log_path = CONFIG.reports_dir / "pipeline.log"
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s | %(levelname)s | %(name)s | %(message)s",
        handlers=[
            logging.StreamHandler(),
            logging.FileHandler(log_path, encoding="utf-8"),
        ],
    )


class DGFTKnowledgePipeline:
    def __init__(self) -> None:
        self.logger = logging.getLogger(self.__class__.__name__)
        self.loader = PDFLoader()
        self.cleaner = TextCleaner()
        self.rule_extractor = RuleExtractor()
        self.condition_extractor = ConditionExtractor()
        self.validation_extractor = ValidationExtractor()
        self.exception_extractor = ExceptionExtractor()
        self.timeline_extractor = TimelineExtractor()
        self.authority_extractor = AuthorityExtractor()
        self.dependency_extractor = DependencyExtractor()
        self.workflow_extractor = WorkflowExtractor()
        self.decision_tree_generator = DecisionTreeGenerator()
        self.glossary_extractor = GlossaryExtractor()
        self.chunker = Chunker()
        self.markdown_converter = MarkdownConverter()
        self.sql_generator = SQLGenerator()
        self.api_generator = APIGenerator()
        self.ui_generator = UIGenerator()
        self.report_generator = ReportGenerator()
        self.knowledge_base_builder = KnowledgeBaseBuilder()

    def run(self) -> Dict[str, object]:
        CONFIG.ensure_directories()
        self._bootstrap_schema()
        pdf_files = self._ordered_pdf_files()
        if not pdf_files:
            self.logger.info("No PDF files found in %s", CONFIG.input_pdf_dir)
            self._write_empty_report()
            return {}

        documents: List[DocumentKnowledge] = []
        for pdf_path in pdf_files:
            try:
                documents.append(self._process_pdf(pdf_path))
            except Exception as exc:
                self.logger.exception("Failed to process %s: %s", pdf_path.name, exc)

        if not documents:
            self._write_empty_report()
            return {}

        master_knowledge_base = self.knowledge_base_builder.build_master_knowledge_base(documents)
        self._write_master_outputs(documents, master_knowledge_base)
        return master_knowledge_base

    def _ordered_pdf_files(self) -> List[Path]:
        pdf_files = [path for path in CONFIG.input_pdf_dir.glob("*.pdf") if path.suffix.lower() in CONFIG.supported_suffixes]
        return sorted(pdf_files, key=self._sort_key)

    def _sort_key(self, path: Path) -> tuple[int, str]:
        match = re.search(r"chapter[\s_\-+]*(\d+)", path.name, flags=re.IGNORECASE)
        return (int(match.group(1)) if match else 999, path.name.casefold())

    def _process_pdf(self, pdf_path: Path, progress_callback: Callable[[str, int], None] | None = None) -> DocumentKnowledge:
        self.logger.info("Processing %s", pdf_path.name)
        if progress_callback:
            progress_callback("Extract Text", 18)
        pages = self.cleaner.clean_pages(self.loader.load(pdf_path))
        if not pages:
            raise ValueError(f"{pdf_path.name} contains 0 pages and cannot be indexed.")
        if progress_callback:
            progress_callback("Identify Sections", 34)
        drafts = self.rule_extractor.extract_sections(pages, pdf_path.name)
        section_numbers = [draft.section_number for draft in drafts]
        section_knowledge: List[SectionKnowledge] = []
        dependency_edges = []

        for draft in drafts:
            section = self.rule_extractor.extract(draft, section_numbers)
            section.conditions = self.condition_extractor.extract(section.raw_text)
            section.validations = self.validation_extractor.extract(section.raw_text)
            section.exceptions = self.exception_extractor.extract(section.raw_text)
            section.timelines = self.timeline_extractor.extract(section.raw_text)
            section.authorities = self.authority_extractor.extract(section.raw_text)
            section.dependencies, edges, _ = self.dependency_extractor.extract(section, section_numbers)
            dependency_edges.extend(edges)

            workflow_bundle = self.workflow_extractor.extract(section)
            section.workflow = workflow_bundle["workflow"]  # type: ignore[assignment]
            section.workflow_ascii = str(workflow_bundle["ascii"])
            section.mermaid = str(workflow_bundle["mermaid"])
            section.plantuml = str(workflow_bundle["plantuml"])

            decision_bundle = self.decision_tree_generator.generate(section)
            section.decision_tree = decision_bundle["decision_tree"]  # type: ignore[assignment]
            section.decision_tree_ascii = str(decision_bundle["ascii"])

            section.apis = self.api_generator.generate(section)
            section.ui = self.ui_generator.generate(section)
            section_knowledge.append(section)

        document = DocumentKnowledge(
            source_pdf=pdf_path,
            sections=section_knowledge,
            glossary=self.glossary_extractor.extract(section_knowledge),
            entities=self._build_entity_index(section_knowledge),
            dependency_edges=dependency_edges,
            page_count=len(pages),
        )
        self.knowledge_base_builder.enrich_sections(document.sections)
        report = self.report_generator.generate(document)
        document.report_counts = report["summary"]  # type: ignore[assignment]

        if progress_callback:
            progress_callback("Convert to Markdown", 50)
        self._write_document_outputs(document, report)
        if progress_callback:
            progress_callback("Generate Chunks", 64)
        for section in document.sections:
            self._write_section_outputs(section)
        if progress_callback:
            progress_callback("Create Embeddings", 82)
        return document

    def _write_section_outputs(self, section: SectionKnowledge) -> None:
        output_name = safe_section_slug(section.section, section.title)
        markdown_path = CONFIG.markdown_dir / f"{output_name}.md"
        json_path = CONFIG.json_dir / f"{output_name}.json"
        rules_path = CONFIG.rules_dir / f"{output_name}.json"
        conditions_path = CONFIG.conditions_dir / f"{output_name}.json"
        validations_path = CONFIG.validations_dir / f"{output_name}.json"
        exceptions_path = CONFIG.exceptions_dir / f"{output_name}.json"
        authorities_path = CONFIG.authorities_dir / f"{output_name}.json"
        timelines_path = CONFIG.timelines_dir / f"{output_name}.json"
        workflows_path = CONFIG.workflows_dir / f"{output_name}.json"
        decision_path = CONFIG.decision_trees_dir / f"{output_name}.json"
        api_path = CONFIG.api_design_dir / f"{output_name}.json"
        ui_path = CONFIG.ui_design_dir / f"{output_name}.json"
        entity_path = CONFIG.entities_dir / f"{output_name}.json"

        write_text(markdown_path, self.markdown_converter.convert(section))
        write_json(json_path, section.to_dict())
        write_json(
            rules_path,
            {
                "chapter_number": section.chapter_number,
                "chapter_title": section.chapter_title,
                "section": section.section,
                "title": section.title,
                "business_rules": section.business_rules,
                "ai_rules": section.ai_rules,
            },
        )
        write_json(
            conditions_path,
            {
                "section": section.section,
                "conditions": section.conditions,
                "condition_logic": section.condition_logic,
            },
        )
        write_json(
            validations_path,
            {
                "section": section.section,
                "validations": section.validations,
                "errors": section.error_messages,
            },
        )
        write_json(exceptions_path, {"section": section.section, "exceptions": section.exceptions})
        write_json(authorities_path, {"section": section.section, "authorities": section.authorities})
        write_json(timelines_path, {"section": section.section, "timelines": section.timelines})
        write_json(
            workflows_path,
            {
                "section": section.section,
                "workflow": section.workflow,
                "workflow_ascii": section.workflow_ascii,
                "mermaid": section.mermaid,
                "plantuml": section.plantuml,
            },
        )
        write_json(
            decision_path,
            {
                "section": section.section,
                "decision_tree": section.decision_tree,
                "decision_tree_ascii": section.decision_tree_ascii,
            },
        )
        write_json(api_path, {"section": section.section, "apis": section.apis})
        write_json(ui_path, {"section": section.section, "ui": section.ui})
        write_json(
            entity_path,
            {
                "chapter_number": section.chapter_number,
                "section": section.section,
                "keywords": section.keywords,
                "search_keywords": section.search_keywords,
                "documents": section.required_documents,
                "authorities": section.authorities,
                "related_sections": section.related_sections,
                "related_chapters": section.related_chapters,
            },
        )

        chunks = self.chunker.chunk_section(section)
        if chunks:
            write_json(CONFIG.chunk_output_dir / f"{output_name}.json", [chunk.to_dict() for chunk in chunks])
            write_json(CONFIG.embeddings_dir / f"{output_name}.json", self.chunker.embedding_payload(chunks))

    def _write_document_outputs(self, document: DocumentKnowledge, report: Dict[str, object]) -> None:
        stem = document.source_pdf.stem
        write_json(CONFIG.glossary_dir / f"{stem}_glossary.json", document.glossary)
        write_json(CONFIG.entities_dir / f"{stem}_entities.json", document.entities)
        write_json(
            CONFIG.json_dir / f"{stem}_searchable.json",
            {
                "source_pdf": document.source_pdf.name,
                "sections": [section.to_dict() for section in document.sections],
                "glossary": document.glossary,
                "entities": document.entities,
                "dependency_edges": [edge.__dict__ for edge in document.dependency_edges],
            },
        )
        write_json(CONFIG.api_design_dir / f"{stem}_catalog.json", self.api_generator.document_catalog(document.sections))
        write_json(CONFIG.ui_design_dir / f"{stem}_catalog.json", self.ui_generator.screen_catalog(document.sections))
        write_text(CONFIG.sql_dir / "schema.sql", self.sql_generator.generate_schema())
        write_text(CONFIG.sql_dir / f"{stem}_seed.sql", self.sql_generator.generate_seed(document))
        write_json(CONFIG.reports_dir / f"{stem}_report.json", report)
        write_text(CONFIG.reports_dir / f"{stem}_report.md", self._report_markdown(report))
        write_text(CONFIG.reports_dir / f"{stem}_report.csv", str(report["section_table_csv"]))

    def _write_master_outputs(self, documents: List[DocumentKnowledge], knowledge_base: Dict[str, object]) -> None:
        write_json(CONFIG.json_dir / "master_knowledge_base.json", knowledge_base)
        write_json(CONFIG.json_dir / "unified_topics.json", knowledge_base["unified_topics"])
        write_json(CONFIG.entities_dir / "master_entities.json", knowledge_base["entities"])
        write_json(CONFIG.glossary_dir / "master_glossary.json", knowledge_base["glossary"])
        write_json(CONFIG.reports_dir / "chapter_reports.json", knowledge_base["chapters"])
        write_json(CONFIG.reports_dir / "master_report.json", self._master_report(documents, knowledge_base))
        write_text(CONFIG.reports_dir / "master_report.md", self._master_report_markdown(knowledge_base))
        write_text(CONFIG.workflows_dir / "master_knowledge_map.txt", str(knowledge_base["master_knowledge_map_ascii"]))
        write_json(CONFIG.workflows_dir / "chapter_relationships.json", knowledge_base["chapter_relationships"])
        write_json(CONFIG.decision_trees_dir / "master_knowledge_graph.json", knowledge_base["master_knowledge_graph"])
        write_text(CONFIG.sql_dir / "master_seed.sql", self._master_seed(documents))

    def _build_entity_index(self, sections: List[SectionKnowledge]) -> Dict[str, List[str]]:
        return {
            "keywords": sorted({keyword for section in sections for keyword in section.keywords}),
            "documents": sorted({document for section in sections for document in (section.required_documents or section.documents)}),
            "authorities": sorted({authority for section in sections for authority in section.authorities}),
            "tags": sorted({tag for section in sections for tag in section.tags}),
            "chapters": sorted({section.chapter_number for section in sections}),
        }

    def _bootstrap_schema(self) -> None:
        write_text(CONFIG.sql_dir / "schema.sql", self.sql_generator.generate_schema())

    def _write_empty_report(self) -> None:
        report = {
            "summary": {
                "source_pdf": "",
                "section_count": 0,
                "rule_count": 0,
                "condition_count": 0,
                "workflow_count": 0,
                "validation_count": 0,
                "exception_count": 0,
                "timeline_count": 0,
                "authority_count": 0,
                "glossary_count": 0,
            },
            "sections": [],
            "section_table_markdown": "No sections extracted.",
            "section_table_csv": "",
        }
        write_json(CONFIG.reports_dir / "run_report.json", report)
        write_text(CONFIG.reports_dir / "run_report.md", self._report_markdown(report))

    def _report_markdown(self, report: Dict[str, object]) -> str:
        summary = report["summary"]
        lines = ["# DGFT Knowledge Extraction Report", "", "## Summary"]
        for key, value in summary.items():  # type: ignore[union-attr]
            lines.append(f"- {key}: {value}")
        lines.extend(["", "## Section Metrics", str(report["section_table_markdown"]), ""])
        return "\n".join(lines)

    def _master_report(self, documents: List[DocumentKnowledge], knowledge_base: Dict[str, object]) -> Dict[str, object]:
        return {
            "knowledge_base_name": knowledge_base["knowledge_base_name"],
            "source_documents": [document.source_pdf.name for document in documents],
            "chapter_count": knowledge_base["chapter_count"],
            "section_count": knowledge_base["section_count"],
            "chapters": knowledge_base["chapters"],
            "topic_count": len(knowledge_base["unified_topics"]),
            "entity_count": len(knowledge_base["entities"]),
        }

    def _master_report_markdown(self, knowledge_base: Dict[str, object]) -> str:
        lines = [
            "# DEKAI DGFT Master Knowledge Report",
            "",
            f"- Knowledge Base: {knowledge_base['knowledge_base_name']}",
            f"- Source Documents: {', '.join(knowledge_base['source_documents'])}",
            f"- Chapters: {knowledge_base['chapter_count']}",
            f"- Sections: {knowledge_base['section_count']}",
            f"- Unified Topics: {len(knowledge_base['unified_topics'])}",
            "",
            "## Chapter Reports",
        ]
        for chapter in knowledge_base["chapters"]:
            lines.append(
                f"- Chapter {chapter['chapter_number']} {chapter['chapter_title']}: "
                f"rules={chapter['rule_count']}, conditions={chapter['condition_count']}, validations={chapter['validation_count']}, "
                f"workflows={chapter['workflow_count']}, authorities={chapter['authority_count']}, timelines={chapter['timeline_count']}, "
                f"exceptions={chapter['exception_count']}"
            )
        lines.extend(["", "## Master Knowledge Map", str(knowledge_base["master_knowledge_map_ascii"]), ""])
        return "\n".join(lines)

    def _master_seed(self, documents: List[DocumentKnowledge]) -> str:
        return "\n".join(self.sql_generator.generate_seed(document) for document in documents)


if __name__ == "__main__":
    configure_logging()
    pipeline = DGFTKnowledgePipeline()
    pipeline.run()
