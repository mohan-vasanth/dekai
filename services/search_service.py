from __future__ import annotations

from collections import Counter, defaultdict
from difflib import SequenceMatcher
from math import log
import re
from typing import Any

from .embedding_service import embedding_service
from .knowledge_engine import knowledge_engine_service
from .retrieval_service import QueryAnalysis, analyze_question, infer_record_collections, rewrite_query
from parser.xml_utils import (
    canonical_xml_tag,
    extract_field_code_references,
    field_search_aliases,
    is_xml_field_query,
    normalized_tag_key,
    normalized_tag_root,
)


def _tokenize(value: str) -> list[str]:
    return embedding_service.tokenize(value)


def _normalize_filter_value(value: str) -> str:
    return " ".join((value or "").lower().split())


def _normalize_match_text(value: str) -> str:
    return re.sub(r"[^a-z0-9]+", " ", str(value or "").lower()).strip()


class SearchService:
    structured_list_question_types = {"COUNT_REQUEST", "LIST_REQUEST", "CODELIST_LOOKUP", "TABLE_LOOKUP"}
    type_aliases = {
        "keyword": {"section", "rule", "workflow", "condition", "definition", "chunk", "hierarchy", "document", "chapter", "concept", "field", "table", "example"},
        "document": {"document"},
        "chapter": {"chapter", "section", "concept"},
        "section": {"section", "chunk", "hierarchy", "field", "table"},
        "rule": {"rule"},
        "workflow": {"workflow"},
        "authority": {"section", "rule"},
        "condition": {"condition", "rule"},
        "definition": {"definition", "concept", "field"},
        "field": {"field", "chunk", "hierarchy", "section"},
        "table": {"table", "chunk", "section"},
        "example": {"example", "section", "chunk"},
    }
    type_weights = {
        "section": 1.45,
        "chunk": 1.3,
        "hierarchy": 1.35,
        "field": 1.5,
        "table": 1.25,
        "example": 1.0,
        "rule": 1.2,
        "workflow": 1.1,
        "condition": 1.05,
        "chapter": 0.95,
        "document": 0.9,
        "concept": 0.8,
        "definition": 0.55,
    }
    stopwords = {
        "a",
        "about",
        "an",
        "and",
        "are",
        "as",
        "at",
        "be",
        "by",
        "can",
        "could",
        "did",
        "do",
        "does",
        "document",
        "documents",
        "explain",
        "file",
        "files",
        "for",
        "from",
        "how",
        "in",
        "into",
        "is",
        "it",
        "of",
        "on",
        "or",
        "pdf",
        "show",
        "stand",
        "tell",
        "the",
        "this",
        "to",
        "what",
        "when",
        "where",
        "which",
        "who",
        "why",
        "with",
        "would",
    }
    expansions = {
        "modify": {"modification", "modify", "update", "updation", "change", "amend"},
        "modification": {"modification", "modify", "update", "updation", "change", "amend"},
        "surrender": {"surrender", "cancel", "cancellation", "close"},
    }

    def __init__(self) -> None:
        self._last_debug: dict[str, Any] = {}
        self._query_cache: dict[tuple[Any, ...], tuple[str | None, list[dict[str, Any]], dict[str, Any]]] = {}

    def _query_terms(self, value: str) -> set[str]:
        tokens = {token for token in _tokenize(value) if token not in self.stopwords}
        expanded = set(tokens)
        for token in list(tokens):
            expanded.update(self.expansions.get(token, {token}))
        return expanded or set(_tokenize(value))

    def _question_phrases(self, value: str) -> list[str]:
        normalized = _normalize_match_text(value)
        if not normalized:
            return []

        stripped = normalized
        for prefix in (
            "what is",
            "what are",
            "where is",
            "where are",
            "tell me about",
            "explain",
            "show",
            "define",
            "describe",
        ):
            if stripped.startswith(f"{prefix} "):
                stripped = stripped[len(prefix) + 1 :].strip()
                break

        tokens = [token for token in stripped.split() if token and token not in self.stopwords]
        phrases = [normalized]
        if stripped and stripped != normalized:
            phrases.append(stripped)
        if 1 <= len(tokens) <= 6:
            for size in range(min(4, len(tokens)), 0, -1):
                for index in range(0, len(tokens) - size + 1):
                    phrase = " ".join(tokens[index : index + size]).strip()
                    if phrase and len(phrase) >= 3:
                        phrases.append(phrase)
        return list(dict.fromkeys(phrases))

    def _similarity_score(self, left: str, right: str) -> float:
        if not left or not right:
            return 0.0
        if left == right:
            return 1.0
        if left in right or right in left:
            return 0.96
        return SequenceMatcher(None, left, right).ratio()

    def _structured_match_features(self, question: str, candidate: dict[str, Any]) -> dict[str, Any]:
        phrases = self._question_phrases(question)
        query_xml_tag = canonical_xml_tag(question)
        query_xml_tag_label = query_xml_tag.split(":", 1)[1] if ":" in query_xml_tag else ""
        query_section_phrase = query_xml_tag_label or _normalize_match_text(phrases[1] if len(phrases) > 1 else question)
        heading = _normalize_match_text(candidate.get("heading", "") or candidate.get("title", ""))
        query_field_codes = {code.upper() for code in extract_field_code_references(question)}
        query_aliases = [
            alias
            for alias in field_search_aliases(question)
            if len(_normalize_match_text(alias)) >= 3
        ]
        query_compact_keys = {
            normalized_tag_key(alias)
            for alias in query_aliases
            if normalized_tag_key(alias)
        }
        query_root_keys = {
            normalized_tag_root(alias)
            for alias in query_aliases
                if normalized_tag_root(alias)
        }
        candidate_xml_tags = {
            canonical_xml_tag(raw_value)
            for raw_value in [
                candidate.get("xmlTag", ""),
                candidate.get("fieldName", ""),
                candidate.get("tagName", ""),
            ]
            if canonical_xml_tag(raw_value)
        }
        section_names = {
            _normalize_match_text(value)
            for value in [
                candidate.get("sectionName", ""),
                candidate.get("heading", ""),
                candidate.get("title", ""),
            ]
            if _normalize_match_text(value)
        }
        section_path = _normalize_match_text(candidate.get("sectionPath", ""))

        raw_candidate_fields = [
            str(field)
            for field in [candidate.get("tagName", ""), candidate.get("normalizedTagName", ""), *candidate.get("fieldNames", [])]
            if str(field).strip()
        ]
        candidate_field_codes = {
            str(code).strip().upper()
            for code in [
                candidate.get("fieldCode", ""),
                *[
                    field.get("field_code", "")
                    for field in candidate.get("xmlFields", [])
                    if isinstance(field, dict)
                ],
            ]
            if str(code).strip()
        }
        field_aliases: list[str] = []
        for field in candidate.get("fieldNames", []):
            field_aliases.extend(field_search_aliases(str(field)))
        for raw_field in (
            candidate.get("tagName", ""),
            candidate.get("normalizedTagName", ""),
        ):
            field_aliases.extend(field_search_aliases(str(raw_field)))
        for xml_field in candidate.get("xmlFields", []):
            if not isinstance(xml_field, dict):
                continue
            field_aliases.extend(xml_field.get("search_aliases", []))
            field_aliases.extend(
                field_search_aliases(
                    str(xml_field.get("tag_name", "")) or str(xml_field.get("normalized_tag_name", ""))
                )
            )
        field_aliases.extend(
            match
            for match in re.findall(
                r"\b[A-Za-z]{2,5}:[A-Za-z][A-Za-z0-9]+(?:\s+[A-Za-z][A-Za-z0-9]+){0,3}\b",
                str(candidate.get("text", "")),
            )
        )

        candidate_field_entries = [
            (
                raw_field,
                _normalize_match_text(raw_field),
                normalized_tag_key(raw_field),
                normalized_tag_root(raw_field),
            )
            for raw_field in raw_candidate_fields
            if _normalize_match_text(raw_field) and len(_normalize_match_text(raw_field)) >= 3
        ]
        normalized_field_values = [
            _normalize_match_text(field)
            for field in field_aliases
            if _normalize_match_text(field) and len(_normalize_match_text(field)) >= 3
        ]
        field_values = list(dict.fromkeys([*normalized_field_values, *[entry[1] for entry in candidate_field_entries]]))
        candidate_compact_keys = {
            normalized_tag_key(field)
            for field in field_aliases
            if normalized_tag_key(field)
        }
        candidate_root_keys = {
            normalized_tag_root(field)
            for field in field_aliases
            if normalized_tag_root(field)
        }

        xml_tag_exact_match = bool(query_xml_tag and query_xml_tag in candidate_xml_tags)
        section_name_exact_match = bool(query_section_phrase and query_section_phrase in section_names)
        section_path_match = bool(
            query_xml_tag
            and (
                query_xml_tag in section_path
                or query_xml_tag_label in section_path
            )
        ) or bool(query_section_phrase and query_section_phrase in section_path)
        exact_heading = heading and any(phrase == heading for phrase in phrases)
        contains_heading = bool(heading) and any(phrase and (phrase in heading or heading in phrase) for phrase in phrases)
        exact_field_entry = next(
            (
                entry
                for entry in candidate_field_entries
                if any(phrase == entry[1] for phrase in phrases)
            ),
            None,
        )
        exact_field = exact_field_entry[1] if exact_field_entry else ""
        exact_field_label = exact_field_entry[0] if exact_field_entry else ""
        compact_field_match = bool(query_compact_keys and query_compact_keys.intersection(candidate_compact_keys))
        root_field_match = bool(query_root_keys and query_root_keys.intersection(candidate_root_keys))
        contains_field_entry = next(
            (
                entry
                for entry in candidate_field_entries
                if any(phrase and (phrase in entry[1] or entry[1] in phrase) for phrase in phrases)
            ),
            None,
        )
        contains_field = contains_field_entry[1] if contains_field_entry else ""
        exact_field_code = next(iter(sorted(query_field_codes.intersection(candidate_field_codes))), "")
        if not exact_field and compact_field_match:
            exact_field_entry = next(
                (
                    entry
                    for entry in candidate_field_entries
                    if entry[2] and entry[2] in query_compact_keys
                ),
                None,
            )
            if exact_field_entry:
                exact_field = exact_field_entry[1]
                exact_field_label = exact_field_entry[0]

        fuzzy_heading_score = max((self._similarity_score(phrase, heading) for phrase in phrases), default=0.0) if heading else 0.0
        fuzzy_field_score = max(
            (
                self._similarity_score(phrase, field)
                for phrase in phrases
                for field in field_values
            ),
            default=0.0,
        )

        matched_heading = heading if exact_heading or contains_heading or section_name_exact_match or section_path_match or fuzzy_heading_score >= 0.84 else ""
        matched_field = exact_field_label or (contains_field_entry[0] if contains_field_entry else "")
        if xml_tag_exact_match and not matched_field:
            matched_field = next(
                (
                    value
                    for value in [candidate.get("fieldName", ""), candidate.get("xmlTag", ""), candidate.get("tagName", ""), candidate.get("title", "")]
                    if str(value).strip()
                ),
                "",
            )
        if not matched_field and fuzzy_field_score >= 0.86 and candidate_field_entries:
            matched_field = max(
                candidate_field_entries,
                key=lambda entry: max(self._similarity_score(phrase, entry[1]) for phrase in phrases),
            )[0]
        if not matched_field and (compact_field_match or root_field_match):
            matched_field = next(
                (
                    entry[0]
                    for entry in candidate_field_entries
                    if (entry[2] and entry[2] in query_compact_keys) or (entry[3] and entry[3] in query_root_keys)
                ),
                "",
            )

        return {
            "questionPhrases": phrases,
            "xmlTagExactMatch": xml_tag_exact_match,
            "fieldCodeExactMatch": bool(exact_field_code),
            "matchedFieldCode": exact_field_code,
            "sectionNameExactMatch": section_name_exact_match,
            "sectionPathMatch": section_path_match,
            "headingExactMatch": bool(exact_heading),
            "headingContainsMatch": bool(contains_heading),
            "fieldExactMatch": bool(exact_field),
            "fieldContainsMatch": bool(contains_field or compact_field_match or root_field_match),
            "fuzzyHeadingScore": round(fuzzy_heading_score, 4),
            "fuzzyFieldScore": round(fuzzy_field_score, 4),
            "matchedHeading": matched_heading,
            "matchedField": matched_field,
            "queryLooksLikeField": is_xml_field_query(question),
            "normalizedFieldExactMatch": compact_field_match,
            "normalizedFieldRootMatch": root_field_match,
        }

    def _chapter_records(self, index: dict[str, Any]) -> list[dict[str, Any]]:
        return [
            {
                "id": f'chapter-{chapter["chapter_number"]}',
                "type": "chapter",
                "title": f'Chapter {chapter["chapter_number"]} {chapter["chapter_title"]}',
                "text": chapter["summary_en"],
                "preview": chapter["summary_en"],
                "sectionId": "",
                "chapterNumber": chapter["chapter_number"],
                "chapterTitle": chapter["chapter_title"],
                "documentName": "",
                "documentId": "",
                "sourcePages": [],
                "hsCodes": [],
                "eximCodes": [],
                "vector": embedding_service.embed_text(
                    f'{chapter["chapter_number"]} {chapter["chapter_title"]} {chapter["summary_en"]}'
                ),
            }
            for chapter in index.get("chapters", [])
        ]

    def _document_records(self, index: dict[str, Any]) -> list[dict[str, Any]]:
        return [
            {
                "id": document["id"],
                "type": "document",
                "title": document["name"],
                "text": document["summary"],
                "preview": document["summary"],
                "sectionId": "",
                "chapterNumber": "",
                "chapterTitle": document["chapterTitle"],
                "documentName": document["name"],
                "documentId": document["id"],
                "sourcePages": [],
                "hsCodes": [],
                "eximCodes": [],
                "vector": embedding_service.embed_text(f'{document["name"]} {document["summary"]}'),
            }
            for document in index.get("documents", [])
            if str(document.get("status", "ready")) == "ready"
        ]

    def _concept_records(self, index: dict[str, Any]) -> list[dict[str, Any]]:
        return [
            {
                "id": concept["id"],
                "type": "concept",
                "title": concept["title"],
                "text": " ".join([*concept.get("keywords", []), *concept.get("sections", [])]),
                "preview": f'Related chapters: {", ".join(concept.get("chapters", [])[:4])}',
                "sectionId": "",
                "chapterNumber": concept.get("chapters", [""])[0] if concept.get("chapters") else "",
                "chapterTitle": "",
                "documentName": "",
                "documentId": "",
                "sourcePages": [],
                "hsCodes": [],
                "eximCodes": [],
                "vector": concept.get("vector", []),
            }
            for concept in index.get("concepts", [])
        ]

    def _candidates(self, index: dict[str, Any]) -> list[dict[str, Any]]:
        return [
            *index.get("searchRecords", []),
            *self._chapter_records(index),
            *self._document_records(index),
            *self._concept_records(index),
        ]

    def _candidate_text(self, candidate: dict[str, Any]) -> str:
        return " ".join(
            [
                str(candidate.get("title", "")),
                str(candidate.get("heading", "")),
                str(candidate.get("text", "")),
                str(candidate.get("chapterTitle", "")),
                str(candidate.get("documentName", "")),
                str(candidate.get("preview", "")),
                str(candidate.get("fieldCode", "")),
                " ".join(str(field) for field in candidate.get("fieldNames", [])),
                str(candidate.get("tagName", "")),
                str(candidate.get("normalizedTagName", "")),
                " ".join(str(alias) for alias in candidate.get("searchAliases", [])),
                " ".join(str(column) for column in candidate.get("tableColumns", [])),
                " ".join(
                    str(field.get("field_code", ""))
                    for field in candidate.get("xmlFields", [])
                    if isinstance(field, dict)
                ),
                " ".join(
                    str(field.get("tag_name", ""))
                    for field in candidate.get("xmlFields", [])
                    if isinstance(field, dict)
                ),
                " ".join(
                    str(field.get("normalized_tag_name", ""))
                    for field in candidate.get("xmlFields", [])
                    if isinstance(field, dict)
                ),
                " ".join(str(code) for code in candidate.get("hsCodes", [])),
                str(candidate.get("description", "")),
            ]
        ).lower()

    def _passes_filters(
        self,
        candidate: dict[str, Any],
        allowed_types: set[str],
        collection_filters: set[str] | frozenset[str] | None,
        chapter_filters: set[str] | frozenset[str] | None,
        section_filters: set[str] | frozenset[str] | None,
        document_filters: set[str] | frozenset[str] | None,
    ) -> bool:
        candidate_type = str(candidate.get("type", "")).lower()
        if candidate_type not in allowed_types:
            return False

        if document_filters:
            candidate_document_names = {
                _normalize_filter_value(str(candidate.get("documentName", "")).strip()),
                _normalize_filter_value(str(candidate.get("title", "")).strip()) if candidate_type == "document" else "",
            }
            candidate_document_names.discard("")
            if not candidate_document_names.intersection(document_filters):
                return False

        collection_tags = infer_record_collections(candidate)
        if collection_filters and not collection_tags.intersection(collection_filters):
            return False

        candidate_section = str(candidate.get("sectionId", "")).strip()
        candidate_chapter = str(candidate.get("chapterNumber", "")).strip()
        if section_filters and candidate_section:
            if candidate_section not in section_filters:
                return False
        elif section_filters and candidate_type in {"section", "chunk", "hierarchy", "rule", "workflow", "condition", "definition"}:
            return False

        if chapter_filters and candidate_chapter:
            if candidate_chapter not in chapter_filters:
                return False
        elif chapter_filters and candidate_type in {"chapter", "section", "chunk", "hierarchy", "rule", "workflow", "condition", "definition"}:
            return False
        return True

    def _cache_key(
        self,
        query: str,
        mode: str,
        collection_filters: set[str] | frozenset[str] | None,
        chapter_filters: set[str] | frozenset[str] | None,
        section_filters: set[str] | frozenset[str] | None,
        document_filters: set[str] | frozenset[str] | None,
        limit: int,
    ) -> tuple[Any, ...]:
        return (
            query.strip(),
            mode,
            tuple(sorted(collection_filters or [])),
            tuple(sorted(chapter_filters or [])),
            tuple(sorted(section_filters or [])),
            tuple(sorted(document_filters or [])),
            int(limit),
        )

    def _candidate_lookup(self, candidates: list[dict[str, Any]]) -> dict[str, dict[str, Any]]:
        return {str(candidate.get("id", "")).strip(): candidate for candidate in candidates if str(candidate.get("id", "")).strip()}

    def _index_candidates(
        self,
        index: dict[str, Any],
        candidate_lookup: dict[str, dict[str, Any]],
        values: list[str],
        *index_names: str,
    ) -> list[dict[str, Any]]:
        matches: list[dict[str, Any]] = []
        indexes = index.get("indexes", {})
        seen_ids: set[str] = set()
        for index_name in index_names:
            mapping = indexes.get(index_name, {}) if isinstance(indexes, dict) else {}
            if not isinstance(mapping, dict):
                continue
            for value in values:
                normalized_value = _normalize_filter_value(value)
                for candidate_id in mapping.get(normalized_value, []):
                    candidate = candidate_lookup.get(str(candidate_id).strip())
                    if not candidate:
                        continue
                    key = str(candidate.get("id", "")).strip()
                    if key in seen_ids:
                        continue
                    seen_ids.add(key)
                    matches.append(candidate)
        return matches

    def _entity_variants(self, analysis: QueryAnalysis) -> list[str]:
        variants: list[str] = []
        requested_entity = str(analysis.requested_entity or "").strip()
        if requested_entity:
            variants.append(requested_entity)
            variants.extend(field_search_aliases(requested_entity))
            if requested_entity.endswith(" type"):
                variants.append(requested_entity.replace(" type", " types"))
            elif requested_entity.endswith(" types"):
                variants.append(requested_entity.replace(" types", " type"))
        variants.extend(analysis.field_codes)
        if not (requested_entity and analysis.question_type in self.structured_list_question_types):
            variants.extend(
                keyword
                for keyword in analysis.keywords
                if len(keyword) >= 4 and keyword not in {"available", "count", "list", "many", "show", "total"}
            )
        normalized = []
        for value in variants:
            cleaned = _normalize_match_text(value)
            if cleaned and cleaned not in normalized:
                normalized.append(cleaned)
        return normalized

    def _candidate_entity_values(self, candidate: dict[str, Any]) -> set[str]:
        values = {
            _normalize_match_text(value)
            for value in [
                candidate.get("title", ""),
                candidate.get("heading", ""),
                candidate.get("fieldName", ""),
                candidate.get("xmlTag", ""),
                candidate.get("tagName", ""),
                candidate.get("normalizedTagName", ""),
                candidate.get("sectionName", ""),
            ]
            if _normalize_match_text(value)
        }
        values.update(
            _normalize_match_text(value)
            for value in candidate.get("fieldNames", [])
            if _normalize_match_text(value)
        )
        values.update(
            _normalize_match_text(value)
            for value in candidate.get("tableColumns", [])
            if _normalize_match_text(value)
        )
        return values

    def _exact_entity_candidates(
        self,
        analysis: QueryAnalysis,
        candidates: list[dict[str, Any]],
        *,
        prefer_table: bool = False,
    ) -> list[dict[str, Any]]:
        variants = self._entity_variants(analysis)
        if not variants:
            return []

        matches: list[tuple[tuple[float, ...], dict[str, Any]]] = []
        for rank, candidate in enumerate(candidates):
            candidate_type = str(candidate.get("type", "")).lower()
            entity_values = self._candidate_entity_values(candidate)
            if not entity_values:
                continue

            exact_variant = next((variant for variant in variants if variant in entity_values), "")
            contains_variant = next(
                (
                    variant
                    for variant in variants
                    for value in entity_values
                    if variant != value and (variant in value or value in variant)
                ),
                "",
            )
            candidate_text = _normalize_match_text(
                " ".join(
                    [
                        str(candidate.get("fieldName", "")),
                        str(candidate.get("text", "")),
                        " ".join(str(field) for field in candidate.get("fieldNames", [])),
                    ]
                )
            )
            has_tabular_context = bool(candidate.get("isTableRow")) or (
                "code" in entity_values
                or "transfer conditions" in entity_values
                or "table" in _normalize_match_text(str(candidate.get("title", "")))
                or str(candidate.get("title", "")).strip().startswith(tuple(str(digit) for digit in range(10)))
            )

            if prefer_table:
                if not (
                    (exact_variant and has_tabular_context)
                    or any(variant in candidate_text for variant in variants if variant)
                    or (contains_variant and has_tabular_context)
                ):
                    continue
            elif not exact_variant and not contains_variant:
                continue

            matches.append(
                (
                    (
                        1.0 if exact_variant else 0.0,
                        1.0 if prefer_table and has_tabular_context else 0.0,
                        1.0 if candidate_type in {"field", "table"} else 0.0,
                        1.0 if candidate.get("isTableRow") else 0.0,
                        float(candidate.get("confidence", 0.0)),
                        float(candidate.get("score", 0.0)),
                        -float(rank),
                    ),
                    candidate,
                )
            )

        matches.sort(key=lambda item: item[0], reverse=True)
        return [candidate for _score, candidate in matches]

    def _normalized_codes(self, candidate: dict[str, Any]) -> set[str]:
        codes = {str(code).strip() for code in candidate.get("hsCodes", []) if str(code).strip()}
        codes.update(str(code).strip() for code in candidate.get("eximCodes", []) if str(code).strip())
        return codes

    def _exact_xml_tag_candidates(self, analysis: QueryAnalysis, candidates: list[dict[str, Any]]) -> list[dict[str, Any]]:
        if not analysis.canonical_field_reference:
            return []
        return [
            candidate
            for candidate in candidates
            if self._structured_match_features(analysis.question, candidate).get("xmlTagExactMatch")
        ]

    def _exact_section_candidates(self, analysis: QueryAnalysis, candidates: list[dict[str, Any]]) -> list[dict[str, Any]]:
        if not analysis.section_request_name and not analysis.detected_tag_name:
            return []
        return [
            candidate
            for candidate in candidates
            if self._structured_match_features(analysis.question, candidate).get("sectionNameExactMatch")
            or self._structured_match_features(analysis.question, candidate).get("sectionPathMatch")
        ]

    def _exact_field_code_candidates(self, analysis: QueryAnalysis, candidates: list[dict[str, Any]]) -> list[dict[str, Any]]:
        if not analysis.field_codes:
            return []
        return [
            candidate
            for candidate in candidates
            if self._structured_match_features(analysis.question, candidate).get("fieldCodeExactMatch")
        ]

    def _related_xml_tag_candidates(self, analysis: QueryAnalysis, candidates: list[dict[str, Any]]) -> list[dict[str, Any]]:
        if not analysis.canonical_field_reference:
            return []
        related: list[dict[str, Any]] = []
        for candidate in candidates:
            features = self._structured_match_features(analysis.question, candidate)
            namespace = str(candidate.get("namespace", "")).strip().lower()
            if analysis.detected_namespace and namespace and namespace != analysis.detected_namespace:
                continue
            if any(
                features.get(flag)
                for flag in (
                    "normalizedFieldExactMatch",
                    "normalizedFieldRootMatch",
                    "fieldContainsMatch",
                    "headingContainsMatch",
                    "sectionPathMatch",
                )
            ):
                related.append(candidate)
        return related

    def _metadata_lookup(self, analysis: QueryAnalysis, candidates: list[dict[str, Any]]) -> list[dict[str, Any]]:
        results: list[dict[str, Any]] = []
        for candidate in candidates:
            exact_hs = self._normalized_codes(candidate).intersection(analysis.hs_codes)
            exact_section = str(candidate.get("sectionId", "")).strip() in analysis.section_numbers
            exact_chapter = str(candidate.get("chapterNumber", "")).strip() in analysis.chapter_numbers
            structure_matches = self._structured_match_features(analysis.question, candidate)
            if (
                not exact_hs
                and not exact_section
                and not exact_chapter
                and not structure_matches["xmlTagExactMatch"]
                and not structure_matches["sectionNameExactMatch"]
                and not structure_matches["sectionPathMatch"]
                and not structure_matches["headingExactMatch"]
                and not structure_matches["fieldExactMatch"]
                and not structure_matches["fieldCodeExactMatch"]
                and not structure_matches["normalizedFieldExactMatch"]
                and not structure_matches["normalizedFieldRootMatch"]
                and structure_matches["fuzzyHeadingScore"] < 0.9
                and structure_matches["fuzzyFieldScore"] < 0.92
            ):
                continue

            score = 0.0
            if exact_hs:
                score += 1000 + (50 if candidate.get("isTableRow") else 0)
            if exact_section:
                score += 200
            if exact_chapter:
                score += 120
            if structure_matches["xmlTagExactMatch"]:
                score += 420
            if structure_matches["sectionNameExactMatch"]:
                score += 280
            if structure_matches["sectionPathMatch"]:
                score += 240
            if structure_matches["headingExactMatch"]:
                score += 260
            elif structure_matches["headingContainsMatch"]:
                score += 140
            elif structure_matches["fuzzyHeadingScore"] >= 0.9:
                score += 90 * structure_matches["fuzzyHeadingScore"]
            if structure_matches["fieldExactMatch"]:
                score += 230
            elif structure_matches["fieldCodeExactMatch"]:
                score += 220
            elif structure_matches["normalizedFieldExactMatch"]:
                score += 215
            elif structure_matches["normalizedFieldRootMatch"]:
                score += 185
            elif structure_matches["fieldContainsMatch"]:
                score += 125
            elif structure_matches["fuzzyFieldScore"] >= 0.92:
                score += 85 * structure_matches["fuzzyFieldScore"]
            results.append(
                {
                    **candidate,
                    "metadataScore": round(score, 4),
                    "exactHsMatch": sorted(exact_hs),
                    "exactSectionMatch": exact_section,
                    "exactChapterMatch": exact_chapter,
                    **structure_matches,
                    "confidence": 0.995 if structure_matches["xmlTagExactMatch"] else 0.99 if exact_hs else 0.972 if structure_matches["sectionNameExactMatch"] or structure_matches["sectionPathMatch"] else 0.968 if structure_matches["fieldCodeExactMatch"] else 0.96 if structure_matches["fieldExactMatch"] or structure_matches["normalizedFieldExactMatch"] else 0.93 if exact_section else 0.88,
                }
            )
        results.sort(key=lambda item: float(item.get("metadataScore", 0.0)), reverse=True)
        return results[:20]

    def _bm25_search(self, analysis: QueryAnalysis, candidates: list[dict[str, Any]], rewrites: tuple[str, ...] = ()) -> list[dict[str, Any]]:
        query_texts = rewrites or (analysis.question,)
        query_tokens = list({token for value in query_texts for token in self._query_terms(value)})
        if not query_tokens:
            return []

        tokenized_docs = [Counter(_tokenize(self._candidate_text(candidate))) for candidate in candidates]
        doc_lengths = [sum(counter.values()) for counter in tokenized_docs]
        avg_doc_length = max(1.0, sum(doc_lengths) / max(1, len(doc_lengths)))
        document_frequency: Counter[str] = Counter()
        for counter in tokenized_docs:
            for token in counter:
                document_frequency[token] += 1

        results: list[dict[str, Any]] = []
        k1 = 1.5
        b = 0.75
        total_documents = max(1, len(candidates))
        for candidate, counter, doc_length in zip(candidates, tokenized_docs, doc_lengths):
            candidate_codes = self._normalized_codes(candidate)
            if analysis.hs_codes and candidate_codes and not candidate_codes.intersection(analysis.hs_codes):
                continue
            haystack = self._candidate_text(candidate)
            title_text = str(candidate.get("title", "")).lower()
            structure_matches = self._structured_match_features(analysis.question, candidate)
            score = 0.0
            matched_tokens: list[str] = []
            for token in query_tokens:
                frequency = counter.get(token, 0)
                if frequency <= 0:
                    continue
                matched_tokens.append(token)
                doc_freq = document_frequency.get(token, 0)
                idf = log(1 + ((total_documents - doc_freq + 0.5) / (doc_freq + 0.5)))
                denominator = frequency + k1 * (1 - b + b * (doc_length / avg_doc_length))
                score += idf * ((frequency * (k1 + 1)) / max(1e-9, denominator))
            if any(value.lower() in haystack for value in query_texts if value.strip()):
                score += 6.0
            if any(code in haystack.replace(" ", "") for code in analysis.hs_codes):
                score += 8.0
            if matched_tokens and any(token in title_text for token in matched_tokens):
                score += 2.5
            if structure_matches["xmlTagExactMatch"]:
                score += 12.0
            if structure_matches["sectionNameExactMatch"]:
                score += 9.5
            elif structure_matches["sectionPathMatch"]:
                score += 7.5
            if structure_matches["headingExactMatch"]:
                score += 10.0
            elif structure_matches["headingContainsMatch"]:
                score += 5.5
            elif structure_matches["fuzzyHeadingScore"] >= 0.88:
                score += structure_matches["fuzzyHeadingScore"] * 4.0
            if structure_matches["fieldExactMatch"]:
                score += 9.0
            elif structure_matches["fieldCodeExactMatch"]:
                score += 8.8
            elif structure_matches["normalizedFieldExactMatch"]:
                score += 8.5
            elif structure_matches["normalizedFieldRootMatch"]:
                score += 7.0
            elif structure_matches["fieldContainsMatch"]:
                score += 4.5
            elif structure_matches["fuzzyFieldScore"] >= 0.9:
                score += structure_matches["fuzzyFieldScore"] * 3.5
            if score <= 0:
                continue
            results.append(
                {
                    **candidate,
                    "bm25Score": round(score, 4),
                    "matchedTokens": matched_tokens,
                    **structure_matches,
                }
            )
        results.sort(key=lambda item: float(item.get("bm25Score", 0.0)), reverse=True)
        return results[:20]

    def _vector_search(self, analysis: QueryAnalysis, candidates: list[dict[str, Any]], rewrites: tuple[str, ...] = ()) -> list[dict[str, Any]]:
        query_vector = embedding_service.embed_text(" ".join(rewrites or (analysis.question,)))
        results: list[dict[str, Any]] = []
        for candidate in candidates:
            candidate_codes = self._normalized_codes(candidate)
            if analysis.hs_codes and candidate_codes and not candidate_codes.intersection(analysis.hs_codes):
                continue
            similarity = max(0.0, embedding_service.similarity(query_vector, candidate.get("vector", [])))
            if similarity <= 0:
                continue
            structure_matches = self._structured_match_features(analysis.question, candidate)
            results.append(
                {
                    **candidate,
                    "vectorSimilarity": round(similarity, 4),
                    **structure_matches,
                }
            )
        results.sort(key=lambda item: float(item.get("vectorSimilarity", 0.0)), reverse=True)
        return results[:20]

    def _result_key(self, candidate: dict[str, Any]) -> str:
        chunk_hash = str(candidate.get("chunkHash", "")).strip()
        if chunk_hash:
            return chunk_hash
        pages = ",".join(str(page) for page in candidate.get("sourcePages", []))
        text = self._candidate_text(candidate)[:180]
        return "|".join(
            [
                str(candidate.get("documentName", "")),
                str(candidate.get("sectionId", "")),
                pages,
                text,
            ]
        )

    def _confidence(self, candidate: dict[str, Any]) -> float:
        if candidate.get("xmlTagExactMatch"):
            return 0.995
        if candidate.get("exactHsMatch"):
            return 0.99
        if candidate.get("sectionNameExactMatch") or candidate.get("sectionPathMatch"):
            return 0.972
        if candidate.get("headingExactMatch") or candidate.get("fieldExactMatch"):
            return 0.97
        if candidate.get("fieldCodeExactMatch"):
            return 0.968
        if candidate.get("normalizedFieldExactMatch"):
            return 0.965
        if candidate.get("normalizedFieldRootMatch"):
            return 0.94
        if candidate.get("exactSectionMatch"):
            return 0.94
        if candidate.get("exactChapterMatch"):
            return 0.9
        keyword_score = float(candidate.get("bm25Score", 0.0))
        semantic_score = float(candidate.get("vectorSimilarity", 0.0))
        structure_boost = max(float(candidate.get("fuzzyHeadingScore", 0.0)), float(candidate.get("fuzzyFieldScore", 0.0))) * 0.18
        return round(min(0.95, 0.45 + min(0.3, keyword_score / 20) + min(0.15, semantic_score / 2) + structure_boost), 4)

    def _merge_results(
        self,
        analysis: QueryAnalysis,
        metadata_results: list[dict[str, Any]],
        bm25_results: list[dict[str, Any]],
        vector_results: list[dict[str, Any]],
        limit: int,
    ) -> tuple[list[dict[str, Any]], int]:
        merged: dict[str, dict[str, Any]] = {}
        for source_name, items in (
            ("metadata", metadata_results),
            ("bm25", bm25_results),
            ("vector", vector_results),
        ):
            for item in items:
                key = self._result_key(item)
                existing = merged.get(key, {})
                combined = {**existing, **item}
                combined.setdefault("retrievalChannels", [])
                channels = set(existing.get("retrievalChannels", []))
                channels.add(source_name)
                combined["retrievalChannels"] = sorted(channels)
                merged[key] = combined

        reranked: list[dict[str, Any]] = []
        for candidate in merged.values():
            exact_xml_tag = 1 if candidate.get("xmlTagExactMatch") else 0
            exact_hs = 1 if candidate.get("exactHsMatch") else 0
            exact_section = 1 if candidate.get("exactSectionMatch") else 0
            exact_chapter = 1 if candidate.get("exactChapterMatch") else 0
            exact_table = 1 if candidate.get("isTableRow") and bool(analysis.hs_codes) and candidate.get("exactHsMatch") else 0
            exact_section_name = 1 if candidate.get("sectionNameExactMatch") else 0
            section_path_match = 1 if candidate.get("sectionPathMatch") else 0
            exact_heading = 1 if candidate.get("headingExactMatch") else 0
            exact_field = 1 if candidate.get("fieldExactMatch") else 0
            exact_field_code = 1 if candidate.get("fieldCodeExactMatch") else 0
            normalized_field = 1 if candidate.get("normalizedFieldExactMatch") else 0
            normalized_root = 1 if candidate.get("normalizedFieldRootMatch") else 0
            contains_heading = 1 if candidate.get("headingContainsMatch") else 0
            contains_field = 1 if candidate.get("fieldContainsMatch") else 0
            fuzzy_heading = float(candidate.get("fuzzyHeadingScore", 0.0))
            fuzzy_field = float(candidate.get("fuzzyFieldScore", 0.0))
            keyword_score = float(candidate.get("metadataScore", 0.0)) + float(candidate.get("bm25Score", 0.0))
            semantic_score = float(candidate.get("vectorSimilarity", 0.0))
            final_score = (
                (exact_xml_tag * 720.0)
                + (exact_hs * 500.0)
                + (exact_section_name * 360.0)
                + (section_path_match * 300.0)
                + (exact_section * 120.0)
                + (exact_chapter * 80.0)
                + (exact_table * 50.0)
                + (exact_heading * 220.0)
                + (exact_field * 200.0)
                + (exact_field_code * 190.0)
                + (normalized_field * 180.0)
                + (normalized_root * 150.0)
                + (contains_heading * 110.0)
                + (contains_field * 95.0)
                + (fuzzy_heading * 70.0 if fuzzy_heading >= 0.84 else 0.0)
                + (fuzzy_field * 65.0 if fuzzy_field >= 0.86 else 0.0)
                + keyword_score
                + (semantic_score * 25.0)
            ) * self.type_weights.get(str(candidate.get("type", "")).lower(), 1.0)
            candidate["score"] = round(final_score, 4)
            candidate["confidence"] = self._confidence(candidate)
            candidate["rankingReasons"] = [
                reason
                for reason, enabled in (
                    ("exact_xml_tag_match", bool(exact_xml_tag)),
                    ("exact_hs_code_match", bool(exact_hs)),
                    ("exact_section_name_match", bool(exact_section_name)),
                    ("section_path_match", bool(section_path_match)),
                    ("exact_section_match", bool(exact_section)),
                    ("exact_chapter_match", bool(exact_chapter)),
                    ("exact_table_row_match", bool(exact_table)),
                    ("exact_heading_match", bool(exact_heading)),
                    ("exact_field_match", bool(exact_field)),
                    ("exact_field_code_match", bool(exact_field_code)),
                    ("normalized_field_exact_match", bool(normalized_field)),
                    ("normalized_field_root_match", bool(normalized_root)),
                    ("heading_contains_match", bool(contains_heading)),
                    ("field_contains_match", bool(contains_field)),
                    ("fuzzy_heading_match", fuzzy_heading >= 0.84),
                    ("fuzzy_field_match", fuzzy_field >= 0.86),
                    ("keyword_match", keyword_score > 0),
                    ("semantic_similarity", semantic_score > 0),
                )
                if enabled
            ]
            reranked.append(candidate)

        reranked.sort(
            key=lambda item: (
                1 if item.get("xmlTagExactMatch") else 0,
                1 if item.get("exactHsMatch") else 0,
                1 if item.get("sectionNameExactMatch") else 0,
                1 if item.get("sectionPathMatch") else 0,
                1 if item.get("exactSectionMatch") else 0,
                1 if item.get("exactChapterMatch") else 0,
                1 if item.get("isTableRow") else 0,
                1 if item.get("headingExactMatch") else 0,
                1 if item.get("fieldExactMatch") else 0,
                1 if item.get("fieldCodeExactMatch") else 0,
                1 if item.get("normalizedFieldExactMatch") else 0,
                1 if item.get("normalizedFieldRootMatch") else 0,
                float(item.get("fuzzyHeadingScore", 0.0)),
                float(item.get("fuzzyFieldScore", 0.0)),
                float(item.get("metadataScore", 0.0)) + float(item.get("bm25Score", 0.0)),
                float(item.get("vectorSimilarity", 0.0)),
                float(item.get("score", 0.0)),
            ),
            reverse=True,
        )
        return reranked[:limit], len(reranked)

    def get_last_debug(self) -> dict[str, Any]:
        return dict(self._last_debug)

    def retrieve(
        self,
        query: str,
        mode: str = "keyword",
        limit: int = 20,
        collection_filters: set[str] | frozenset[str] | None = None,
        chapter_filters: set[str] | frozenset[str] | None = None,
        section_filters: set[str] | frozenset[str] | None = None,
        document_filters: set[str] | frozenset[str] | None = None,
    ) -> list[dict[str, Any]]:
        index = knowledge_engine_service.load_index()
        normalized = query.strip()
        if not normalized:
            self._last_debug = {}
            return []

        analysis = analyze_question(normalized)

        cache_key = self._cache_key(
            normalized,
            mode,
            collection_filters,
            chapter_filters,
            section_filters,
            document_filters,
            limit,
        ) + (
            analysis.question_type,
            analysis.document_scope,
            analysis.requested_entity,
            tuple(analysis.document_codes),
        )
        cache_token = str(index.get("generatedAt", ""))
        cached = self._query_cache.get(cache_key)
        if cached and cached[0] == cache_token:
            self._last_debug = {**cached[2], "cacheHit": True}
            return [dict(item) for item in cached[1]]

        rewrites = rewrite_query(normalized, analysis)
        allowed_types = self.type_aliases.get(mode, self.type_aliases["keyword"])
        filtered_candidates = [
            candidate
            for candidate in self._candidates(index)
            if self._passes_filters(candidate, allowed_types, collection_filters, chapter_filters, section_filters, document_filters)
        ]
        candidate_lookup = self._candidate_lookup(filtered_candidates)
        entity_variants = self._entity_variants(analysis)
        indexed_field_candidates = self._index_candidates(
            index,
            candidate_lookup,
            [
                analysis.canonical_field_reference,
                analysis.normalized_field_reference,
                analysis.detected_tag_name,
                *analysis.field_codes,
                *analysis.keywords,
            ],
            "fieldIndex",
            "aliasIndex",
        )
        indexed_table_candidates = self._index_candidates(
            index,
            candidate_lookup,
            [analysis.requested_entity, *entity_variants, analysis.section_request_name, analysis.question],
            "tableIndex",
        )
        exact_field_candidates = self._exact_entity_candidates(analysis, filtered_candidates)
        exact_table_candidates = self._exact_entity_candidates(analysis, filtered_candidates, prefer_table=True)
        exact_xml_tag_candidates = self._exact_xml_tag_candidates(analysis, filtered_candidates)
        exact_section_candidates = [] if exact_xml_tag_candidates or indexed_field_candidates or exact_field_candidates else self._exact_section_candidates(analysis, filtered_candidates)
        exact_field_code_candidates = [] if exact_xml_tag_candidates or exact_section_candidates or indexed_field_candidates or exact_field_candidates else self._exact_field_code_candidates(analysis, filtered_candidates)
        related_xml_tag_candidates = [] if exact_xml_tag_candidates or exact_section_candidates or exact_field_code_candidates or indexed_field_candidates or exact_field_candidates else self._related_xml_tag_candidates(analysis, filtered_candidates)
        retrieval_stage = "all_candidates"
        stage_candidates = filtered_candidates
        suppress_semantic = False

        if exact_xml_tag_candidates:
            retrieval_stage = "exact_xml_tag"
            stage_candidates = exact_xml_tag_candidates
            suppress_semantic = True
        elif analysis.question_type in {"COUNT_REQUEST", "LIST_REQUEST", "CODELIST_LOOKUP", "TABLE_LOOKUP"} and (indexed_table_candidates or exact_table_candidates):
            retrieval_stage = "exact_table"
            stage_candidates = indexed_table_candidates or exact_table_candidates
            suppress_semantic = True
        elif exact_field_candidates:
            retrieval_stage = "exact_field"
            stage_candidates = exact_field_candidates
            suppress_semantic = True
        elif indexed_field_candidates:
            retrieval_stage = "indexed_field"
            stage_candidates = indexed_field_candidates
            suppress_semantic = True
        elif indexed_table_candidates and analysis.question_type == "TABLE_LOOKUP":
            retrieval_stage = "indexed_table"
            stage_candidates = indexed_table_candidates
        elif exact_section_candidates:
            retrieval_stage = "exact_section"
            stage_candidates = exact_section_candidates
        elif exact_field_code_candidates:
            retrieval_stage = "exact_field_code"
            stage_candidates = exact_field_code_candidates
            suppress_semantic = True
        elif related_xml_tag_candidates:
            retrieval_stage = "related_xml_tag"
            stage_candidates = related_xml_tag_candidates
        elif analysis.canonical_field_reference:
            retrieval_stage = "exact_xml_tag_not_found"
            stage_candidates = []
            suppress_semantic = True

        metadata_results = self._metadata_lookup(analysis, stage_candidates)
        bm25_results = self._bm25_search(analysis, stage_candidates, rewrites)
        vector_results = [] if suppress_semantic else self._vector_search(analysis, stage_candidates, rewrites)
        merged_results, merged_total = self._merge_results(analysis, metadata_results, bm25_results, vector_results, limit)
        retrieved_document_ids = list(
            dict.fromkeys(
                str(item.get("documentId", "")).strip()
                for item in merged_results
                if str(item.get("documentId", "")).strip()
            )
        )

        self._last_debug = {
            "user_question": analysis.question,
            "original_query": query,
            "normalized_query": analysis.normalized_question,
            "detected_intent": analysis.question_classification,
            "question_type": analysis.question_type,
            "document_scope": analysis.document_scope,
            "detected_namespace": analysis.detected_namespace,
            "normalized_field_reference": analysis.normalized_field_reference,
            "requested_entity": analysis.requested_entity,
            "document_codes": list(analysis.document_codes),
            "detected_entities": list(analysis.entities),
            "detected_hs_code": list(analysis.hs_codes),
            "detected_keywords": sorted(self._query_terms(analysis.question)),
            "detected_phrases": self._question_phrases(analysis.question),
            "query_rewrites": list(rewrites),
            "document_filters": sorted(document_filters) if document_filters else [],
            "applied_document_filter": sorted(document_filters) if document_filters else [],
            "filtered_candidates_count": len(filtered_candidates),
            "retrieval_stage": retrieval_stage,
            "indexed_field_match_count": len(indexed_field_candidates),
            "indexed_table_match_count": len(indexed_table_candidates),
            "exact_field_match_count": len(exact_field_candidates),
            "exact_table_match_count": len(exact_table_candidates),
            "exact_xml_tag_query": analysis.canonical_field_reference,
            "exact_xml_tag_match_count": len(exact_xml_tag_candidates),
            "exact_section_match_count": len(exact_section_candidates),
            "exact_field_code_match_count": len(exact_field_code_candidates),
            "related_xml_tag_match_count": len(related_xml_tag_candidates),
            "stage_candidates_count": len(stage_candidates),
            "metadata_results_count": len(metadata_results),
            "bm25_results_count": len(bm25_results),
            "vector_results_count": len(vector_results),
            "merged_results_count": merged_total,
            "retrieved_document_ids": retrieved_document_ids,
            "retrieved_document_names": list(
                dict.fromkeys(
                    str(item.get("documentName", "")).strip()
                    for item in merged_results
                    if str(item.get("documentName", "")).strip()
                )
            ),
            "retrieved_headings": list(
                dict.fromkeys(
                    str(item.get("heading", "")).strip()
                    for item in merged_results
                    if str(item.get("heading", "")).strip()
                )
            )[:10],
            "retrieved_chunk_count": len(
                [
                    item
                    for item in merged_results
                    if str(item.get("type", "")).lower() in {"section", "chunk", "hierarchy", "rule", "condition", "workflow", "definition"}
                ]
            ),
            "top_ranked_chunks": [
                {
                    "id": item.get("id", ""),
                    "title": item.get("title", ""),
                    "documentId": item.get("documentId", ""),
                    "sectionId": item.get("sectionId", ""),
                    "documentName": item.get("documentName", ""),
                    "heading": item.get("heading", ""),
                    "fieldNames": item.get("fieldNames", []),
                    "fieldCode": item.get("fieldCode", ""),
                    "fieldName": item.get("fieldName", ""),
                    "xmlTag": item.get("xmlTag", ""),
                    "sectionName": item.get("sectionName", ""),
                    "sectionPath": item.get("sectionPath", ""),
                    "sourcePages": item.get("sourcePages", []),
                    "matchedFieldCode": item.get("matchedFieldCode", ""),
                    "matchedHeading": item.get("matchedHeading", ""),
                    "matchedField": item.get("matchedField", ""),
                    "xmlTagExactMatch": bool(item.get("xmlTagExactMatch")),
                    "sectionNameExactMatch": bool(item.get("sectionNameExactMatch")),
                    "sectionPathMatch": bool(item.get("sectionPathMatch")),
                    "headingExactMatch": bool(item.get("headingExactMatch")),
                    "fieldExactMatch": bool(item.get("fieldExactMatch")),
                    "fieldCodeExactMatch": bool(item.get("fieldCodeExactMatch")),
                    "normalizedFieldExactMatch": bool(item.get("normalizedFieldExactMatch")),
                    "normalizedFieldRootMatch": bool(item.get("normalizedFieldRootMatch")),
                    "score": item.get("score", 0),
                    "confidence": item.get("confidence", 0),
                    "metadataScore": item.get("metadataScore", 0),
                    "bm25Score": item.get("bm25Score", 0),
                    "vectorSimilarity": item.get("vectorSimilarity", 0),
                    "rankingReasons": item.get("rankingReasons", []),
                }
                for item in merged_results[:5]
            ],
            "cacheHit": False,
        }
        self._query_cache[cache_key] = (cache_token, [dict(item) for item in merged_results], dict(self._last_debug))
        return merged_results

    def search(self, query: str, mode: str = "keyword") -> list[dict[str, Any]]:
        results = self.retrieve(query, mode=mode, limit=30)
        return [
            {
                "id": result["id"],
                "type": str(result["type"]).title(),
                "title": result["title"],
                "preview": result["preview"],
                "chapter": f'Chapter {result["chapterNumber"]}' if result.get("chapterNumber") else result.get("chapterTitle", ""),
                "sectionId": result.get("sectionId", ""),
                "documentId": result.get("documentId", ""),
                "documentName": result.get("documentName", ""),
                "sourcePages": result.get("sourcePages", []),
                "score": result.get("score", 0),
            }
            for result in results
        ]


search_service = SearchService()
