from __future__ import annotations

import re
from dataclasses import dataclass
from typing import Any

from parser.utils import extract_numeric_identifiers, normalize_numeric_identifier, unique_preserve
from parser.xml_utils import (
    canonical_xml_tag,
    extract_field_code_references,
    extract_query_namespace,
    extract_section_request_target,
    field_search_aliases,
    is_xml_field_query,
    normalize_query_field_reference,
)


TRADE_NET_XML_FIELD_INTENT = "TRADE_NET_XML_FIELD"
TRADE_NET_RETRIEVAL_ENGINE = "trade_net_xml_field"
TRADE_NET_STRUCTURED_INTENT = "TRADE_NET_STRUCTURED_LOOKUP"


def _normalize(value: str) -> str:
    return " ".join((value or "").lower().split())


def _contains_any(value: str, phrases: tuple[str, ...]) -> bool:
    return any(phrase in value for phrase in phrases)


def _contains_xml_like_tag(value: str) -> bool:
    return bool(extract_query_namespace(value))


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
    section_request_name: str = ""
    needs_clarification: bool = False
    clarification_message: str = ""
    detected_namespace: str = ""
    retrieval_engine: str = ""
    lock_to_document: str = ""
    disable_cross_document: bool = False
    disable_semantic_expansion: bool = False


@dataclass(frozen=True)
class QueryAnalysis:
    question: str
    normalized_question: str
    user_intent: str
    question_classification: str
    question_type: str
    document_scope: str
    entities: tuple[str, ...]
    hs_codes: tuple[str, ...]
    section_numbers: tuple[str, ...]
    chapter_numbers: tuple[str, ...]
    field_codes: tuple[str, ...]
    document_terms: tuple[str, ...]
    keywords: tuple[str, ...]
    section_request_name: str = ""
    detected_namespace: str = ""
    normalized_field_reference: str = ""
    canonical_field_reference: str = ""
    detected_tag_name: str = ""
    document_codes: tuple[str, ...] = ()
    requested_entity: str = ""


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
TRADE_NET_STRUCTURED_HINTS: tuple[str, ...] = (
    "trade net",
    "tradenet",
    "message specification",
    "message details",
    "message definition",
    "message function",
    "header section",
    "summary section",
    "transport mode",
    "mode code",
    "declaration type",
    "declaration indicator",
    "customs procedure code",
    "transport field",
)
TRADE_NET_DOCUMENT_CODES: tuple[str, ...] = ("INPDEC", "IPTDEC", "TNPDEC", "COODEC", "OUTDEC")
DOCUMENT_ALIAS_MAP: dict[str, tuple[str, ...]] = {
    "INPDEC": ("inpdec", "inp", "import declaration"),
    "IPTDEC": ("iptdec", "ipt", "import permit"),
    "OUTDEC": ("outdec", "out", "export declaration"),
    "COODEC": ("coodec", "coo", "certificate of origin"),
    "TNPDEC": ("tnpdec", "tnp", "trade net declaration"),
    "DGFT": ("dgft",),
    "HBP": ("hbp", "handbook of procedures", "hand book of procedures"),
}
DOCUMENT_PREFIX_TO_CODE: dict[str, str] = {
    "inp": "INPDEC",
    "ipt": "IPTDEC",
    "out": "OUTDEC",
    "coo": "COODEC",
    "tnp": "TNPDEC",
}


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


def _extract_document_codes(question: str) -> tuple[str, ...]:
    normalized_question = _normalize(question)
    detected: list[str] = []
    detected_namespace = extract_query_namespace(question).lower()
    if detected_namespace in DOCUMENT_PREFIX_TO_CODE:
        detected.append(DOCUMENT_PREFIX_TO_CODE[detected_namespace])
    for code, aliases in DOCUMENT_ALIAS_MAP.items():
        for alias in aliases:
            if re.search(rf"(?<![a-z0-9]){re.escape(alias)}(?![a-z0-9])", normalized_question, flags=re.IGNORECASE):
                detected.append(code)
                break
    return tuple(unique_preserve(detected))


def _strip_leading_document_alias(question: str, document_codes: tuple[str, ...]) -> str:
    cleaned_question = " ".join(str(question or "").split()).strip()
    if not cleaned_question or not document_codes:
        return cleaned_question
    stripped = cleaned_question
    for code in document_codes:
        for alias in DOCUMENT_ALIAS_MAP.get(code, ()):
            stripped = re.sub(rf"^\s*{re.escape(alias)}\s*[:\-]?\s*", "", stripped, flags=re.IGNORECASE)
    return " ".join(stripped.split()).strip() or cleaned_question


def _query_keywords(question: str) -> tuple[str, ...]:
    tokens = [
        token
        for token in re.findall(r"\b[a-z0-9][a-z0-9/&._-]{1,}\b", question.lower())
        if token not in HS_GENERIC_TOKENS
    ]
    return tuple(unique_preserve(tokens))


def _singularize_token(value: str) -> str:
    token = str(value or "").strip().lower()
    if token.endswith("ies") and len(token) > 4:
        return token[:-3] + "y"
    if token.endswith("ses") and len(token) > 4:
        return token[:-2]
    if token.endswith("s") and not token.endswith("ss") and len(token) > 4:
        return token[:-1]
    return token


def _extract_requested_entity(question: str, normalized: str, document_codes: tuple[str, ...]) -> str:
    if is_xml_field_query(question):
        normalized_field_reference = normalize_query_field_reference(question)
        if ":" in normalized_field_reference:
            namespace, remainder = normalized_field_reference.split(":", 1)
            if namespace.lower() in DOCUMENT_PREFIX_TO_CODE:
                return remainder.strip()
        return normalized_field_reference

    explicit_section = extract_section_request_target(question)
    if explicit_section:
        return explicit_section.strip()

    working = _normalize(_strip_leading_document_alias(question, document_codes))
    for prefix in (
        "how many ",
        "count ",
        "total ",
        "list all ",
        "list the ",
        "list ",
        "show all ",
        "show the ",
        "show ",
        "what is ",
        "what are ",
        "which ",
        "explain ",
        "define ",
        "meaning of ",
    ):
        if working.startswith(prefix):
            working = working[len(prefix) :].strip()
            break

    working = re.sub(r"\b(?:available|listed|present|defined|there|in|the|a|an|all)\b", " ", working, flags=re.IGNORECASE)
    working = re.sub(r"\b(?:pdf|document|declaration)\b(?=\s+pdf|\s+document|$)", " ", working, flags=re.IGNORECASE)
    working = re.sub(r"\b(?:for|from|of|in|within|under)\b\s+[a-z0-9._-]+\b(?:\s+pdf|\s+document)?", " ", working, flags=re.IGNORECASE)
    for document_code in document_codes:
        working = re.sub(rf"\b{re.escape(document_code.lower())}\b", " ", working, flags=re.IGNORECASE)
    working = re.sub(r"\b(?:pdf|document|documents|file|files)\b", " ", working, flags=re.IGNORECASE)
    working = re.sub(r"[^a-z0-9:/&._ -]+", " ", working)
    tokens = [token for token in working.split() if token]
    if not tokens:
        return ""

    cleaned_tokens: list[str] = []
    skip_tokens = {
        "all",
        "and",
        "any",
        "are",
        "available",
        "count",
        "every",
        "how",
        "is",
        "list",
        "listed",
        "many",
        "show",
        "the",
        "them",
        "there",
        "total",
    }
    for token in re.findall(r"\b[a-z0-9:/&._-]+\b", " ".join(tokens)):
        if token in skip_tokens:
            continue
        cleaned_tokens.append(token)

    if not cleaned_tokens:
        return ""

    phrase = " ".join(cleaned_tokens[:4]).strip()
    phrase = re.sub(r"\btypes\b", "type", phrase, flags=re.IGNORECASE)
    phrase = re.sub(r"\bvalues\b", "value", phrase, flags=re.IGNORECASE)
    phrase = re.sub(r"\bcodes\b", "code", phrase, flags=re.IGNORECASE)
    words = [_singularize_token(word) for word in phrase.split() if word]
    return " ".join(words[:4]).strip()


def _classify_question(
    question: str,
    hs_codes: tuple[str, ...],
    sections: tuple[str, ...],
    chapters: tuple[str, ...],
    field_codes: tuple[str, ...],
    normalized: str,
    section_request_name: str = "",
) -> str:
    if hs_codes:
        return "HS Code Lookup"
    if field_codes:
        return "TRADE_NET_FIELD_CODE"
    if is_xml_field_query(question):
        return "TRADE_NET_XML_FIELD"
    if section_request_name:
        return "SECTION_REQUEST"
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


def _detect_question_type(normalized: str) -> str:
    if re.search(r"\b(how many|count|total)\b", normalized):
        return "COUNT_REQUEST"
    if "table" in normalized:
        return "TABLE_LOOKUP"
    if _contains_any(normalized, ("code list", "codelist", "codes", "available types", "available values", "dropdown", "enumeration", "enumerate", "options", "values")):
        return "CODELIST_LOOKUP"
    if _contains_any(normalized, ("list", "show all", "show the", "what are the", "which are the", "available")):
        return "LIST_REQUEST"
    if _contains_any(normalized, ("example", "sample")):
        return "EXAMPLE_REQUEST"
    if _contains_any(normalized, ("validation", "mandatory", "required", "must", "shall")):
        return "RULE_REQUEST"
    if _contains_any(normalized, ("define", "definition", "meaning", "what is", "what are")):
        return "DEFINITION_REQUEST"
    if _contains_any(normalized, ("which section", "where", "under which section", "section")):
        return "SECTION_REQUEST"
    if _contains_any(normalized, ("compare", "difference", "versus", "vs")):
        return "COMPARISON"
    if re.match(r"^(is|are|does|do|can|should|must)\b", normalized):
        return "YES_NO"
    if _contains_any(normalized, ("summary", "summarize", "summarise")):
        return "GENERAL_SEARCH"
    return "FIELD_LOOKUP"


def _detect_document_scope(normalized: str, document_terms: tuple[str, ...], sections: tuple[str, ...], chapters: tuple[str, ...], document_codes: tuple[str, ...] = ()) -> str:
    if document_codes or document_terms or "pdf" in normalized or "document" in normalized:
        return "document"
    if sections:
        return "section"
    if chapters:
        return "chapter"
    return "global"


def _is_trade_net_structured_query(analysis: QueryAnalysis) -> bool:
    normalized = analysis.normalized_question
    if any(code.upper().endswith("DEC") or code.upper() in TRADE_NET_DOCUMENT_CODES for code in analysis.document_codes):
        return True
    if _contains_any(normalized, TRADE_NET_STRUCTURED_HINTS):
        return True
    requested_entity = _normalize(analysis.requested_entity)
    if requested_entity and _contains_any(requested_entity, TRADE_NET_STRUCTURED_HINTS):
        return True
    if analysis.question_type in {"LIST_REQUEST", "COUNT_REQUEST", "CODELIST_LOOKUP", "TABLE_LOOKUP"}:
        if requested_entity and requested_entity in {"transport mode", "declaration type", "mode code"}:
            return True
    return False


def analyze_question(question: str) -> QueryAnalysis:
    cleaned_question = " ".join((question or "").split()).strip()
    normalized = _normalize(cleaned_question)
    hs_codes = tuple(extract_numeric_identifiers(cleaned_question))
    field_codes = tuple(extract_field_code_references(cleaned_question))
    sections = _extract_explicit_section_ids(cleaned_question)
    chapters = _extract_explicit_chapters(cleaned_question)
    document_terms = _extract_document_terms(normalized)
    document_codes = _extract_document_codes(cleaned_question)
    keywords = _query_keywords(cleaned_question)
    section_request_name = extract_section_request_target(cleaned_question)
    detected_namespace = extract_query_namespace(cleaned_question)
    normalized_field_reference = normalize_query_field_reference(cleaned_question) if is_xml_field_query(cleaned_question) else ""
    canonical_field_reference = canonical_xml_tag(cleaned_question) if is_xml_field_query(cleaned_question) else ""
    detected_tag_name = canonical_field_reference.split(":", 1)[1] if ":" in canonical_field_reference else ""
    requested_entity = _extract_requested_entity(cleaned_question, normalized, document_codes)
    entities = tuple(
        unique_preserve(
            [
                *hs_codes,
                *[f"Section {section}" for section in sections],
                *[f"Chapter {chapter}" for chapter in chapters],
                *field_codes,
                *([detected_namespace] if detected_namespace else []),
                *([normalized_field_reference] if normalized_field_reference else []),
                *([canonical_field_reference] if canonical_field_reference else []),
                *([section_request_name] if section_request_name else []),
                *([requested_entity] if requested_entity else []),
                *document_terms,
                *document_codes,
                *keywords[:8],
            ]
        )
    )
    user_intent = _classify_user_intent(normalized)
    return QueryAnalysis(
        question=cleaned_question,
        normalized_question=normalized,
        user_intent=user_intent,
        question_classification=_classify_question(
            cleaned_question,
            hs_codes,
            sections,
            chapters,
            field_codes,
            normalized,
            section_request_name,
        ),
        question_type=_detect_question_type(normalized),
        document_scope=_detect_document_scope(normalized, document_terms, sections, chapters, document_codes),
        entities=entities,
        hs_codes=hs_codes,
        section_numbers=sections,
        chapter_numbers=chapters,
        field_codes=field_codes,
        document_terms=document_terms,
        keywords=keywords,
        section_request_name=section_request_name,
        detected_namespace=detected_namespace,
        normalized_field_reference=normalized_field_reference,
        canonical_field_reference=canonical_field_reference,
        detected_tag_name=detected_tag_name,
        document_codes=document_codes,
        requested_entity=requested_entity,
    )


def rewrite_query(question: str, analysis: QueryAnalysis | None = None) -> tuple[str, ...]:
    base = analysis or analyze_question(question)
    rewrites: list[str] = [base.question]

    def add(value: str) -> None:
        cleaned = " ".join(str(value or "").split()).strip()
        if cleaned and cleaned not in rewrites:
            rewrites.append(cleaned)

    normalized_reference = base.normalized_field_reference or base.canonical_field_reference or base.detected_tag_name
    if normalized_reference:
        add(normalized_reference)
        for alias in field_search_aliases(normalized_reference):
            add(alias)

    if base.requested_entity:
        add(base.requested_entity)
        singular_entity = " ".join(_singularize_token(token) for token in base.requested_entity.split())
        add(singular_entity)
        for alias in field_search_aliases(base.requested_entity):
            add(alias)

    for field_code in base.field_codes:
        add(field_code)

    for entity in base.entities[:8]:
        add(entity)

    for keyword in base.keywords[:10]:
        add(keyword)
        if keyword.endswith("s") and len(keyword) > 4:
            add(keyword[:-1])

    if base.question_type in {"LIST_REQUEST", "COUNT_REQUEST", "CODELIST_LOOKUP"}:
        for token in ("list", "types", "values", "codes", "options"):
            if token in base.normalized_question:
                add(base.normalized_question.replace(token, "").strip())
    if "transport mode" in base.normalized_question or ("transport" in base.normalized_question and "mode" in base.normalized_question):
        for variant in ("transport mode", "transport", "mode", "transport list", "means of transport", "transport field"):
            add(variant)
    if "declaration type" in base.normalized_question:
        for variant in ("declaration type", "declaration", "type", "declaration codes", "declaration list"):
            add(variant)
    if base.section_request_name:
        add(base.section_request_name)

    return tuple(unique_preserve(rewrites))[:12]


class RetrievalDecisionService:
    def _trade_net_xml_field_plan(self, analysis: QueryAnalysis) -> RetrievalPlan:
        topic = analysis.normalized_field_reference or next(iter(analysis.field_codes), "") or analysis.question
        return RetrievalPlan(
            question_understood=analysis.question,
            user_intent="Question Answering",
            intent=TRADE_NET_XML_FIELD_INTENT,
            topic=topic,
            knowledge_sources=("TradeNet",),
            collection_filters=frozenset(),
            likely_chapters=("TradeNet",),
            likely_sections=analysis.section_numbers,
            chapter_filters=frozenset(analysis.chapter_numbers),
            section_filters=frozenset(analysis.section_numbers),
            section_request_name=analysis.section_request_name,
            detected_namespace=analysis.detected_namespace,
            retrieval_engine=TRADE_NET_RETRIEVAL_ENGINE,
            disable_cross_document=True,
            disable_semantic_expansion=True,
        )

    def _trade_net_structured_plan(self, analysis: QueryAnalysis) -> RetrievalPlan:
        topic = analysis.requested_entity or analysis.section_request_name or "Message Specification"
        return RetrievalPlan(
            question_understood=analysis.question,
            user_intent="Question Answering",
            intent=TRADE_NET_STRUCTURED_INTENT,
            topic=topic,
            knowledge_sources=("Selected Document", "TradeNet", "Message Specification"),
            collection_filters=frozenset(),
            likely_chapters=("TradeNet",),
            likely_sections=analysis.section_numbers,
            chapter_filters=frozenset(analysis.chapter_numbers),
            section_filters=frozenset(analysis.section_numbers),
            section_request_name=analysis.section_request_name,
            detected_namespace=analysis.detected_namespace,
        )

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
        section_request_name = analysis.section_request_name

        if section_request_name:
            return RetrievalPlan(
                question_understood=question_understood,
                user_intent=user_intent if user_intent != "General Question" else "Question Answering",
                intent="Section Request",
                topic=section_request_name,
                knowledge_sources=("Selected Document", "TradeNet", "DGFT Section Hierarchy"),
                collection_filters=frozenset(),
                likely_chapters=(),
                likely_sections=explicit_sections,
                chapter_filters=frozenset(explicit_chapters),
                section_filters=frozenset(explicit_sections),
                section_request_name=section_request_name,
                detected_namespace=analysis.detected_namespace,
            )

        if analysis.field_codes or _contains_xml_like_tag(question_understood) or is_xml_field_query(question_understood):
            return self._trade_net_xml_field_plan(analysis)

        if _is_trade_net_structured_query(analysis):
            return self._trade_net_structured_plan(analysis)

        if _contains_any(
            normalized,
            (
                "header section",
                "item section",
                "summary section",
                "message details",
                "message definition",
                "message function",
                "declaration type",
                "tradenet",
                "message specification",
            ),
        ):
            topic = "Message Specification"
            if _contains_xml_like_tag(question_understood):
                topic = "XML Tag"
            elif is_xml_field_query(question_understood):
                topic = "XML Field"
            elif "header section" in normalized:
                topic = "Header"
            elif "declaration type" in normalized:
                topic = "Declaration Type"
            return RetrievalPlan(
                question_understood=question_understood,
                user_intent=user_intent if user_intent != "General Question" else "Question Answering",
                intent=topic,
                topic=analysis.normalized_field_reference or topic,
                knowledge_sources=("Selected Document", "TradeNet", "Message Specification"),
                collection_filters=frozenset(),
                likely_chapters=(),
                likely_sections=explicit_sections,
                chapter_filters=frozenset(explicit_chapters),
                section_filters=frozenset(explicit_sections),
                section_request_name=section_request_name,
                detected_namespace=analysis.detected_namespace,
                retrieval_engine=TRADE_NET_RETRIEVAL_ENGINE,
            )

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
                section_request_name=section_request_name,
                needs_clarification=bool(clarification_message),
                clarification_message=clarification_message,
                detected_namespace=analysis.detected_namespace,
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
                    section_request_name=section_request_name,
                    detected_namespace=analysis.detected_namespace,
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
            section_request_name=section_request_name,
            detected_namespace=analysis.detected_namespace,
        )


retrieval_decision_service = RetrievalDecisionService()
