from __future__ import annotations

import re
from dataclasses import dataclass
from typing import Any

from parser.utils import extract_numeric_identifiers, normalize_numeric_identifier, unique_preserve


def _normalize(value: str) -> str:
    return " ".join((value or "").lower().split())


def _contains_any(value: str, phrases: tuple[str, ...]) -> bool:
    return any(phrase in value for phrase in phrases)


@dataclass(frozen=True)
class RetrievalPlan:
    question_understood: str
    user_intent: str
    intent: str
    topic: str
    knowledge_sources: tuple[str, ...]
    collection_filters: frozenset[str]
    likely_chapters: tuple[str, ...]
    likely_sections: tuple[str, ...]
    chapter_filters: frozenset[str] = frozenset()
    section_filters: frozenset[str] = frozenset()
    needs_clarification: bool = False
    clarification_message: str = ""


@dataclass(frozen=True)
class QueryAnalysis:
    question: str
    normalized_question: str
    user_intent: str
    question_classification: str
    entities: tuple[str, ...]
    hs_codes: tuple[str, ...]
    section_numbers: tuple[str, ...]
    chapter_numbers: tuple[str, ...]
    document_terms: tuple[str, ...]
    keywords: tuple[str, ...]


HS_TERMS = (
    "hs code",
    "hscode",
    "hsn",
    "tariff",
    "classification",
    "customs tariff",
    "find hs code",
    "correct hs code",
    "product description",
)
HS_GENERIC_TOKENS = {
    "need",
    "needs",
    "i",
    "want",
    "hs",
    "code",
    "hscode",
    "hsn",
    "tariff",
    "classification",
    "classify",
    "classifying",
    "customs",
    "find",
    "correct",
    "product",
    "description",
    "for",
    "the",
    "a",
    "an",
}
BUSINESS_ENTITY_PATTERNS: tuple[tuple[str, str], ...] = (
    ("HBP", r"\bhbp\b|handbook of procedures|hand book of procedures"),
    ("FTP", r"\bftp\b|foreign trade policy"),
    ("Notification", r"\bnotification\b"),
    ("Public Notice", r"\bpublic notice\b"),
    ("Appendix", r"\bappendix\b"),
    ("Import", r"\bimport\b"),
    ("Export", r"\bexport\b"),
    ("Licence", r"\blicen[cs]e\b|\bauthori[sz]ation\b"),
    ("EOU", r"\beou\b"),
    ("SEZ", r"\bsez\b"),
    ("Scrap", r"\bscrap\b|\bwaste\b"),
    ("Restriction", r"\brestrict(?:ed|ion)?\b"),
    ("Prohibition", r"\bprohibit(?:ed|ion)?\b"),
)

INTENT_PRIORITY: tuple[tuple[str, tuple[str, ...], tuple[str, ...]], ...] = (
    ("Public Notices", ("public notice", "public notices"), ("public_notices",)),
    ("Trade Notices", ("trade notice", "trade notices"), ("trade_notices",)),
    ("Notifications", ("notification", "notifications"), ("notifications",)),
    ("ICEGATE", ("icegate", "bill of entry", "shipping bill"), ("icegate",)),
    ("GST", ("gst", "igst", "cgst", "sgst"), ("gst",)),
    ("RBI/FEMA", ("fema", "rbi", "ad code", "softex", "foreign exchange"), ("rbi_fema",)),
    ("SCOMET", ("scomet",), ("scomet", "ftp", "hbp")),
    ("RoSCTL", ("rosctl",), ("rosctl", "ftp", "hbp")),
    ("RODTEP", ("rodtep",), ("rodtep", "ftp", "hbp", "chapter_4")),
    ("Advance Authorisation", ("advance authorisation", "advance authorization"), ("advance_authorisation", "ftp", "hbp", "chapter_4")),
    ("DFIA", ("dfia",), ("dfia", "ftp", "hbp", "chapter_4")),
    ("EPCG", ("epcg",), ("epcg", "epcg_sections", "ftp", "hbp", "chapter_5")),
    ("IEC", ("iec", "importer exporter code", "import export code"), ("iec_rules", "ftp", "hbp", "chapter_2")),
    ("Import Procedure", ("import procedure", "import process", "import workflow", "import steps"), ("import_rules", "ftp", "hbp")),
    ("Export Procedure", ("export procedure", "export process", "export workflow", "export steps"), ("export_rules", "ftp", "hbp")),
    ("Authorisation", ("authorisation", "authorization", "licence", "license"), ("authorisation", "ftp", "hbp")),
    ("Customs", ("customs", "assessment", "duty", "bill of entry"), ("customs", "customs_tariff")),
    ("DGFT Policy", ("dgft", "ftp", "hbp", "policy", "chapter"), ("dgft_policy", "ftp", "hbp")),
)


def infer_record_collections(record: dict[str, Any]) -> set[str]:
    chapter_number = str(record.get("chapterNumber") or record.get("chapter_number") or "").strip()
    combined = _normalize(
        " ".join(
            [
                str(record.get("title", "")),
                str(record.get("text", "")),
                str(record.get("chapterTitle", "")),
                str(record.get("chapter_title", "")),
                str(record.get("documentName", "")),
                str(record.get("name", "")),
                chapter_number,
            ]
        )
    )
    tags: set[str] = set()

    if chapter_number:
        tags.add(f"chapter_{chapter_number}")

    if _contains_any(combined, ("ftp", "foreign trade policy")):
        tags.update({"ftp", "dgft_policy", "general_policy"})
    if _contains_any(combined, ("hbp", "hand book of procedures", "handbook of procedures")):
        tags.update({"hbp", "general_policy"})
    if "policy" in combined or "dgft" in combined:
        tags.update({"dgft_policy", "general_policy"})

    normalized_codes = {
        *[normalize_numeric_identifier(value) for value in record.get("hsCodes", []) if str(value).strip()],
        *[normalize_numeric_identifier(value) for value in record.get("eximCodes", []) if str(value).strip()],
        *extract_numeric_identifiers(combined),
    }
    if normalized_codes or _contains_any(combined, ("itc(hs)", "itc hs", "exim code", "hs master", "hs code", "hscode", "hsn", "customs tariff", "tariff classification")):
        tags.update({"hs_code", "hs_master", "itc_hs", "customs_tariff"})
    if _contains_any(combined, ("iec", "importer exporter code", "import export code")):
        tags.add("iec_rules")
    if "epcg" in combined:
        tags.update({"epcg", "epcg_sections"})
    if _contains_any(combined, ("advance authorisation", "advance authorization")):
        tags.update({"advance_authorisation", "authorisation"})
    if "dfia" in combined:
        tags.add("dfia")
    if "rodtep" in combined:
        tags.add("rodtep")
    if "rosctl" in combined:
        tags.add("rosctl")
    if "scomet" in combined:
        tags.add("scomet")
    if "customs" in combined:
        tags.add("customs")
    if "icegate" in combined:
        tags.add("icegate")
    if _contains_any(combined, ("gst", "igst", "cgst", "sgst")):
        tags.add("gst")
    if _contains_any(combined, ("rbi", "fema", "foreign exchange", "ad code")):
        tags.add("rbi_fema")
    if _contains_any(combined, ("notification", "notifications")):
        tags.add("notifications")
    if _contains_any(combined, ("public notice", "public notices")):
        tags.add("public_notices")
    if _contains_any(combined, ("trade notice", "trade notices")):
        tags.add("trade_notices")
    if "import" in combined:
        tags.add("import_rules")
    if "export" in combined:
        tags.add("export_rules")
    if _contains_any(combined, ("authorisation", "authorization", "licence", "license")):
        tags.add("authorisation")

    return tags


def _needs_hs_clarification(question: str) -> bool:
    if not is_hs_intent(question):
        return False
    if extract_numeric_identifiers(question):
        return False
    tokens = [token for token in re.findall(r"\b[a-z0-9][a-z0-9/&._-]*\b", question.lower()) if token not in HS_GENERIC_TOKENS]
    return len(tokens) == 0


def is_hs_intent(question: str) -> bool:
    return _contains_any(_normalize(question), HS_TERMS) or bool(extract_numeric_identifiers(question))


def _extract_explicit_section_ids(question: str) -> tuple[str, ...]:
    matches = re.findall(r"\b\d{1,2}\.\d{1,2}\b", question)
    return tuple(dict.fromkeys(matches))


def _extract_explicit_chapters(question: str) -> tuple[str, ...]:
    return tuple(dict.fromkeys(re.findall(r"\bchapter\s+(\d{1,2})\b", question.lower())))


def _chapter_labels(chapters: tuple[str, ...], prefix: str = "Chapter") -> tuple[str, ...]:
    return tuple(f"{prefix} {chapter}" for chapter in chapters)


def _classify_user_intent(normalized: str) -> str:
    if _contains_any(normalized, ("scrape", "crawler", "crawl", "website", "web page", "webpage")):
        return "Web Scraping"
    if _contains_any(normalized, ("ocr", "scan image", "read image", "extract text from image")):
        return "OCR"
    if _contains_any(normalized, ("xml", "xml tag", "xml tags")) and _contains_any(normalized, ("extract", "capture", "parse", "get all")):
        return "XML Extraction"
    if _contains_any(normalized, ("json", "json key", "json keys")) and _contains_any(normalized, ("extract", "capture", "parse", "get all")):
        return "JSON Extraction"
    if "table" in normalized and _contains_any(normalized, ("extract", "capture", "parse", "get all")):
        return "Table Extraction"
    if _contains_any(normalized, ("compare", "comparison", "difference", "differences", "vs", "versus")):
        return "Comparison"
    if _contains_any(normalized, ("summarize", "summary", "summarise")):
        return "Summarization"
    if "translate" in normalized or "translation" in normalized:
        return "Translation"
    if _contains_any(normalized, ("report", "generate report", "create report")):
        return "Report Generation"
    if _contains_any(normalized, ("extract", "capture", "collect", "get all data", "parse")):
        if "pdf" in normalized:
            return "PDF Parsing"
        return "Data Extraction"
    if _contains_any(normalized, ("analyze", "analyse", "review document", "document analysis")):
        return "Document Analysis"
    if _contains_any(normalized, ("search", "find", "look up", "lookup", "retrieve", "show me")):
        return "Search"
    if _contains_any(normalized, ("explain", "meaning of", "what does", "how does")):
        return "Explanation"
    if "?" in normalized or _contains_any(normalized, ("what", "when", "where", "which", "who", "why", "can", "does", "is")):
        return "Question Answering"
    return "Information Retrieval"


def _extract_document_terms(normalized: str) -> tuple[str, ...]:
    return tuple(label for label, pattern in BUSINESS_ENTITY_PATTERNS if re.search(pattern, normalized, flags=re.IGNORECASE))


def _query_keywords(question: str) -> tuple[str, ...]:
    tokens = [
        token
        for token in re.findall(r"\b[a-z0-9][a-z0-9/&._-]{1,}\b", question.lower())
        if token not in HS_GENERIC_TOKENS
    ]
    return tuple(unique_preserve(tokens))


def _classify_question(
    question: str,
    hs_codes: tuple[str, ...],
    sections: tuple[str, ...],
    chapters: tuple[str, ...],
    normalized: str,
) -> str:
    if hs_codes:
        return "HS Code Lookup"
    if sections:
        return "Section Lookup"
    if chapters:
        return "Chapter Lookup"
    if _contains_any(normalized, ("restriction", "restricted", "prohibited", "prohibition")):
        return "Restriction"
    if _contains_any(normalized, ("licence", "license", "authorisation", "authorization")):
        return "Licence"
    if _contains_any(normalized, ("procedure", "process", "workflow", "steps")):
        return "Workflow"
    if _contains_any(normalized, ("document", "documents")):
        return "Documents"
    return "General Question"


def analyze_question(question: str) -> QueryAnalysis:
    cleaned_question = " ".join((question or "").split()).strip()
    normalized = _normalize(cleaned_question)
    hs_codes = tuple(extract_numeric_identifiers(cleaned_question))
    sections = _extract_explicit_section_ids(cleaned_question)
    chapters = _extract_explicit_chapters(cleaned_question)
    document_terms = _extract_document_terms(normalized)
    keywords = _query_keywords(cleaned_question)
    entities = tuple(
        unique_preserve(
            [
                *hs_codes,
                *[f"Section {section}" for section in sections],
                *[f"Chapter {chapter}" for chapter in chapters],
                *document_terms,
                *keywords[:8],
            ]
        )
    )
    user_intent = _classify_user_intent(normalized)
    return QueryAnalysis(
        question=cleaned_question,
        normalized_question=normalized,
        user_intent=user_intent,
        question_classification=_classify_question(cleaned_question, hs_codes, sections, chapters, normalized),
        entities=entities,
        hs_codes=hs_codes,
        section_numbers=sections,
        chapter_numbers=chapters,
        document_terms=document_terms,
        keywords=keywords,
    )


class RetrievalDecisionService:
    def _iec_plan(self, question_understood: str, normalized: str, user_intent: str) -> RetrievalPlan:
        topic = "IEC"
        likely_sections: tuple[str, ...] = ()

        if _contains_any(normalized, ("full form", "stands for", "meaning of iec", "what is iec")):
            topic = "IEC Full Form"
            likely_sections = ("2.06", "2.07", "2.08", "2.09", "2.12")
        elif _contains_any(normalized, ("modification", "modify", "change", "amend", "update", "updation")):
            topic = "IEC Modification"
            likely_sections = ("2.14",)
        elif _contains_any(normalized, ("apply", "application", "register", "new iec")):
            topic = "IEC Application"
            likely_sections = ("2.08",)
        elif "format" in normalized:
            topic = "IEC Format"
            likely_sections = ("2.09",)
        elif "validity" in normalized:
            topic = "IEC Validity"
            likely_sections = ("2.10",)
        elif _contains_any(normalized, ("surrender", "cancel", "cancellation", "close")):
            topic = "IEC Surrender"
            likely_sections = ("2.13",)
        elif _contains_any(normalized, ("exempt", "exemption")):
            topic = "IEC Exemption"
            likely_sections = ("2.07",)
        elif "one pan" in normalized:
            topic = "One PAN One IEC"
            likely_sections = ("2.12",)

        return RetrievalPlan(
            question_understood=question_understood,
            user_intent=user_intent,
            intent="IEC",
            topic=topic,
            knowledge_sources=("FTP", "HBP Chapter 2", "IEC Rules"),
            collection_filters=frozenset({"iec_rules", "ftp", "hbp", "chapter_2"}),
            likely_chapters=("HBP Chapter 2", "FTP"),
            likely_sections=likely_sections,
            chapter_filters=frozenset({"2"}),
            section_filters=frozenset(likely_sections),
        )

    def _authorisation_plan(self, question_understood: str, normalized: str, user_intent: str) -> RetrievalPlan:
        topic = "Authorisation"
        likely_sections: tuple[str, ...] = ()
        likely_chapters = ("HBP Chapter 2", "FTP")
        chapter_filters = frozenset({"2"})

        if "validity" in normalized and _contains_any(normalized, ("export authorisation", "export authorization", "export authorisation validity", "authorisation validity", "authorization validity")):
            topic = "Export Authorisation Validity"
            likely_sections = ("2.16",)
        elif _contains_any(normalized, ("duplicate", "duplicate copy")):
            topic = "Duplicate Authorisation"
            likely_sections = ("2.23", "2.24", "2.25", "2.26", "2.27")
        elif _contains_any(normalized, ("revalidation", "revalidate")):
            topic = "Authorisation Revalidation"
            likely_sections = ("2.20", "2.21", "2.22")

        return RetrievalPlan(
            question_understood=question_understood,
            user_intent=user_intent,
            intent="Authorisation",
            topic=topic,
            knowledge_sources=("FTP", "HBP", "Authorisation"),
            collection_filters=frozenset({"authorisation", "ftp", "hbp"}),
            likely_chapters=likely_chapters,
            likely_sections=likely_sections,
            chapter_filters=chapter_filters,
            section_filters=frozenset(likely_sections),
        )

    def detect_intent(self, question: str) -> RetrievalPlan:
        analysis = analyze_question(question)
        question_understood = analysis.question
        normalized = analysis.normalized_question
        user_intent = analysis.user_intent
        explicit_sections = analysis.section_numbers
        explicit_chapters = analysis.chapter_numbers

        if is_hs_intent(question_understood):
            intent = "HS Code Lookup" if analysis.hs_codes else "HS Code Search"
            clarification_message = (
                "Please provide\n\n• Product Description\n• Product Name\n• Existing HS Code\n\nso I can identify the correct HS Code."
                if _needs_hs_clarification(question_understood)
                else ""
            )
            return RetrievalPlan(
                question_understood=question_understood,
                user_intent="Search" if "search" in user_intent else "Question Answering",
                intent=intent,
                topic=intent,
                knowledge_sources=("HBP", "FTP", "ITC(HS)", "Customs Tariff"),
                collection_filters=frozenset(),
                likely_chapters=("HBP", "FTP", "Customs Tariff"),
                likely_sections=explicit_sections,
                chapter_filters=frozenset(explicit_chapters),
                section_filters=frozenset(explicit_sections),
                needs_clarification=bool(clarification_message),
                clarification_message=clarification_message,
            )

        if user_intent != "Comparison" and _contains_any(normalized, ("iec", "importer exporter code", "import export code")):
            return self._iec_plan(question_understood, normalized, user_intent)

        if user_intent != "Comparison" and _contains_any(normalized, ("export authorisation", "export authorization", "authorisation validity", "authorization validity")):
            return self._authorisation_plan(question_understood, normalized, user_intent)

        for intent, patterns, collections in INTENT_PRIORITY:
            if _contains_any(normalized, patterns):
                source_map = {
                    "Public Notices": (("Public Notices",), (), ()),
                    "Trade Notices": (("Trade Notices",), (), ()),
                    "Notifications": (("Notifications",), (), ()),
                    "ICEGATE": (("ICEGATE",), (), ()),
                    "GST": (("GST",), (), ()),
                    "RBI/FEMA": (("RBI", "FEMA"), (), ()),
                    "SCOMET": (("FTP", "HBP", "SCOMET"), (), ()),
                    "RoSCTL": (("FTP", "HBP", "RoSCTL"), ("FTP Chapter 4", "HBP Chapter 4"), ()),
                    "RODTEP": (("FTP Chapter 4", "HBP Chapter 4"), ("FTP Chapter 4", "HBP Chapter 4"), ()),
                    "Advance Authorisation": (("FTP Chapter 4", "HBP Chapter 4", "Advance Authorisation"), ("FTP Chapter 4", "HBP Chapter 4"), ()),
                    "DFIA": (("FTP Chapter 4", "HBP Chapter 4", "DFIA"), ("FTP Chapter 4", "HBP Chapter 4"), ()),
                    "EPCG": (("FTP Chapter 5", "HBP EPCG Sections"), ("FTP Chapter 5",), ()),
                    "Import Procedure": (("HBP", "FTP", "Import Rules"), tuple(f"Chapter {chapter}" for chapter in explicit_chapters), explicit_sections),
                    "Export Procedure": (("HBP", "FTP", "Export Rules"), tuple(f"Chapter {chapter}" for chapter in explicit_chapters), explicit_sections),
                    "Customs": (("Customs", "Customs Tariff"), tuple(f"Chapter {chapter}" for chapter in explicit_chapters), explicit_sections),
                    "DGFT Policy": (("FTP", "DGFT Policy"), _chapter_labels(explicit_chapters), explicit_sections),
                }
                sources, likely_chapters, likely_sections = source_map.get(intent, (("FTP", "HBP"), (), ()))
                chapter_filters = frozenset(explicit_chapters)
                section_filters = frozenset(explicit_sections if explicit_sections else likely_sections)
                return RetrievalPlan(
                    question_understood=question_understood,
                    user_intent=user_intent,
                    intent=intent,
                    topic=intent,
                    knowledge_sources=sources,
                    collection_filters=frozenset(collections),
                    likely_chapters=likely_chapters,
                    likely_sections=likely_sections,
                    chapter_filters=chapter_filters,
                    section_filters=section_filters,
                )

        return RetrievalPlan(
            question_understood=question_understood,
            user_intent=user_intent,
            intent="General Question",
            topic="General Question",
            knowledge_sources=("FTP", "HBP", "DGFT Policy"),
            collection_filters=frozenset({"ftp", "hbp", "dgft_policy", "general_policy"}),
            likely_chapters=_chapter_labels(explicit_chapters),
            likely_sections=explicit_sections,
            chapter_filters=frozenset(explicit_chapters),
            section_filters=frozenset(explicit_sections),
        )


retrieval_decision_service = RetrievalDecisionService()
