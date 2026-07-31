from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List


@dataclass(frozen=True)
class AppConfig:
    project_root: Path = Path(__file__).resolve().parent
    input_pdf_dir: Path = project_root / "input" / "pdf"
    input_processed_dir: Path = project_root / "input" / "processed"
    output_dir: Path = project_root / "output"
    log_dir: Path = project_root / "output" / "reports"
    chunk_size_words: int = 700
    min_chunk_size_words: int = 500
    chunk_overlap_words: int = 100
    chunk_output_dir: Path = project_root / "output" / "chunks"
    markdown_dir: Path = project_root / "output" / "markdown"
    json_dir: Path = project_root / "output" / "json"
    embeddings_dir: Path = project_root / "output" / "embeddings"
    rules_dir: Path = project_root / "output" / "rules"
    workflows_dir: Path = project_root / "output" / "workflows"
    glossary_dir: Path = project_root / "output" / "glossary"
    entities_dir: Path = project_root / "output" / "entities"
    validations_dir: Path = project_root / "output" / "validations"
    timelines_dir: Path = project_root / "output" / "timelines"
    conditions_dir: Path = project_root / "output" / "conditions"
    exceptions_dir: Path = project_root / "output" / "exceptions"
    authorities_dir: Path = project_root / "output" / "authorities"
    decision_trees_dir: Path = project_root / "output" / "decision_trees"
    api_design_dir: Path = project_root / "output" / "api_design"
    ui_design_dir: Path = project_root / "output" / "ui_design"
    sql_dir: Path = project_root / "output" / "sql"
    reports_dir: Path = project_root / "output" / "reports"
    runtime_dir: Path = project_root / "output" / "runtime"
    supported_suffixes: List[str] = field(default_factory=lambda: [".pdf"])
    section_heading_patterns: List[str] = field(
        default_factory=lambda: [
            r"^(?P<section>\d{1,2}(?:\.\d+)+)\s+(?P<title>[A-Z][A-Za-z0-9/&(),:;.\- ]{3,})$",
            r"^(?P<section>\d{1,2}(?:\.\d+)+)\s*[-:]\s*(?P<title>[A-Z][A-Za-z0-9/&(),:;.\- ]{3,})$",
        ]
    )
    sentence_split_pattern: str = r"(?<=[.?!])\s+"
    list_split_pattern: str = r"(?:\n|^)\s*(?:[-*]|\d+[.)]|[a-zA-Z][.)])\s+"
    condition_markers: List[str] = field(
        default_factory=lambda: [
            "if",
            "when",
            "where",
            "provided that",
            "subject to",
            "unless",
            "in case",
            "only if",
            "after",
            "before",
            "upon",
        ]
    )
    validation_markers: List[str] = field(
        default_factory=lambda: [
            "must",
            "shall",
            "required",
            "verify",
            "validated",
            "ensure",
            "complete",
            "correct",
            "rejected",
            "incomplete",
            "eligible",
        ]
    )
    exception_markers: List[str] = field(
        default_factory=lambda: [
            "except",
            "however",
            "provided that",
            "notwithstanding",
            "exempt",
            "unless",
            "but",
            "waived",
        ]
    )
    authority_markers: List[str] = field(
        default_factory=lambda: [
            "authority",
            "directorate",
            "customs",
            "regional authority",
            "ra",
            "dgft",
            "commissioner",
            "officer",
            "government",
            "ministry",
        ]
    )
    document_markers: List[str] = field(
        default_factory=lambda: [
            "certificate",
            "licence",
            "license",
            "application",
            "undertaking",
            "invoice",
            "bill",
            "declaration",
            "annexure",
            "statement",
            "proof",
            "copy",
            "document",
        ]
    )
    timeline_markers: List[str] = field(
        default_factory=lambda: [
            "days",
            "months",
            "years",
            "within",
            "before",
            "after",
            "immediately",
            "not later than",
            "valid for",
            "deadline",
        ]
    )
    action_verbs: List[str] = field(
        default_factory=lambda: [
            "apply",
            "submit",
            "upload",
            "issue",
            "verify",
            "amend",
            "modify",
            "obtain",
            "register",
            "approve",
            "reject",
            "maintain",
            "pay",
            "report",
            "furnish",
        ]
    )
    default_api_methods: List[str] = field(default_factory=lambda: ["GET", "POST"])

    def ensure_directories(self) -> None:
        for path in self.output_directories().values():
            path.mkdir(parents=True, exist_ok=True)
        self.input_pdf_dir.mkdir(parents=True, exist_ok=True)
        self.input_processed_dir.mkdir(parents=True, exist_ok=True)

    def output_directories(self) -> Dict[str, Path]:
        return {
            "markdown": self.markdown_dir,
            "json": self.json_dir,
            "chunks": self.chunk_output_dir,
            "embeddings": self.embeddings_dir,
            "rules": self.rules_dir,
            "workflows": self.workflows_dir,
            "glossary": self.glossary_dir,
            "entities": self.entities_dir,
            "validations": self.validations_dir,
            "timelines": self.timelines_dir,
            "conditions": self.conditions_dir,
            "exceptions": self.exceptions_dir,
            "authorities": self.authorities_dir,
            "decision_trees": self.decision_trees_dir,
            "api_design": self.api_design_dir,
            "ui_design": self.ui_design_dir,
            "sql": self.sql_dir,
            "reports": self.reports_dir,
            "runtime": self.runtime_dir,
        }


CONFIG = AppConfig()
