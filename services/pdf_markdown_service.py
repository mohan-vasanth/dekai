from __future__ import annotations

import logging
import re
import tempfile
from pathlib import Path
from typing import Any

from config import CONFIG
from parser.authority_extractor import AuthorityExtractor
from parser.condition_extractor import ConditionExtractor
from parser.dependency_extractor import DependencyExtractor
from parser.document_markdown_converter import DocumentMarkdownConverter
from parser.exception_extractor import ExceptionExtractor
from parser.glossary_extractor import GlossaryExtractor
from parser.knowledge_base_builder import KnowledgeBaseBuilder
from parser.models import DocumentKnowledge
from parser.pdf_loader import PDFLoader
from parser.rule_extractor import RuleExtractor
from parser.text_cleaner import TextCleaner
from parser.timeline_extractor import TimelineExtractor
from parser.validation_extractor import ValidationExtractor
from parser.workflow_extractor import WorkflowExtractor
from parser.utils import source_document_markdown_name


class PdfMarkdownService:
    SUPPORTED_HTML_TAG_PATTERN = re.compile(r"<\/?(table|thead|tbody|tr|th|td|div|span|p|img|a|ul|ol|li|br|hr)\b", re.IGNORECASE)

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
        self.glossary_extractor = GlossaryExtractor()
        self.knowledge_base_builder = KnowledgeBaseBuilder()
        self.document_markdown_converter = DocumentMarkdownConverter()

    def convert_pdf(self, filename: str, content: bytes) -> dict[str, Any]:
        source_name = Path(filename or "document.pdf").name or "document.pdf"
        suffix = Path(source_name).suffix or ".pdf"
        if suffix.lower() != ".pdf":
            raise ValueError("Only PDF files are supported.")
        if not content:
            raise ValueError("The uploaded PDF is empty.")

        CONFIG.ensure_directories()
        self.logger.info("HTML extraction started for %s", source_name)
        with tempfile.NamedTemporaryFile(dir=CONFIG.runtime_dir, suffix=suffix, delete=False) as handle:
            handle.write(content)
            temp_path = Path(handle.name)

        try:
            pages = self.cleaner.clean_pages(self.loader.load(temp_path))
        finally:
            temp_path.unlink(missing_ok=True)

        if not pages:
            raise ValueError("The uploaded PDF contains no readable pages.")

        drafts = self.rule_extractor.extract_sections(pages, filename)
        section_numbers = [draft.section_number for draft in drafts]
        sections = []
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
            sections.append(section)

        self.knowledge_base_builder.enrich_sections(sections)
        document = DocumentKnowledge(
            source_pdf=Path(source_name),
            sections=sections,
            glossary=self.glossary_extractor.extract(sections),
            entities={},
            dependency_edges=dependency_edges,
            page_count=len(pages),
        )
        markdown = self.document_markdown_converter.convert_document(document)
        section_table_count = sum(len(section.tables) for section in document.sections)
        html_table_count = markdown.casefold().count("<table")
        html_tag_count = len(self.SUPPORTED_HTML_TAG_PATTERN.findall(markdown))
        markdown_name = source_document_markdown_name(document.source_pdf.name)
        markdown_path = CONFIG.markdown_dir / markdown_name
        markdown_path.parent.mkdir(parents=True, exist_ok=True)
        with markdown_path.open("w", encoding="utf-8", newline="\n") as handle:
            handle.write(markdown)
        self.logger.info(
            "Generated markdown %s from %s with %s page tables, %s section tables, %s HTML table blocks, and %s supported HTML tags",
            markdown_path.name,
            document.source_pdf.name,
            sum(len(page.tables) for page in pages),
            section_table_count,
            html_table_count,
            html_tag_count,
        )
        return {
            "documentName": document.source_pdf.name,
            "fileName": markdown_name,
            "content": markdown,
            "pageCount": document.page_count,
            "sectionCount": len(document.sections),
            "chapterCount": len({section.chapter_number for section in document.sections}),
            "glossaryCount": len(document.glossary),
            "htmlTableCount": html_table_count,
            "htmlTagCount": html_tag_count,
            "downloadUrl": f"/api/pdf-to-markdown/files/{markdown_name}",
        }


pdf_markdown_service = PdfMarkdownService()
