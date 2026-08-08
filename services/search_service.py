from __future__ import annotations

from collections import Counter, defaultdict
from difflib import SequenceMatcher
from math import log
import re
from typing import Any

from .embedding_service import embedding_service
from .knowledge_engine import knowledge_engine_service
from .retrieval_service import QueryAnalysis, analyze_question, infer_record_collections
from parser.xml_utils import field_search_aliases, is_xml_field_query, normalized_tag_key, normalized_tag_root


def _tokenize(value: str) -> list[str]:
    return embedding_service.tokenize(value)


def _normalize_filter_value(value: str) -> str:
    return " ".join((value or "").lower().split())


def _normalize_match_text(value: str) -> str:
    return re.sub(r"[^a-z0-9]+", " ", str(value or "").lower()).strip()


class SearchService:
    type_aliases = {
        "keyword": {"section", "rule", "workflow", "condition", "definition", "chunk", "hierarchy", "document", "chapter", "concept"},
        "document": {"document"},
        "chapter": {"chapter", "section", "concept"},
        "section": {"section", "chunk", "hierarchy"},
        "rule": {"rule"},
        "workflow": {"workflow"},
        "authority": {"section", "rule"},
        "condition": {"condition", "rule"},
        "definition": {"definition", "concept"},
    }
    type_weights = {
        "section": 1.45,
        "chunk": 1.3,
        "hierarchy": 1.35,
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
        heading = _normalize_match_text(candidate.get("heading", "") or candidate.get("title", ""))
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

        raw_candidate_fields = [
            str(field)
            for field in [candidate.get("tagName", ""), candidate.get("normalizedTagName", ""), *candidate.get("fieldNames", [])]
            if str(field).strip()
        ]
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
        if not exact_field and (compact_field_match or root_field_match):
            exact_field_entry = next(
                (
                    entry
                    for entry in candidate_field_entries
                    if entry[2] and entry[2] in query_compact_keys
                ),
                None,
            )
            if exact_field_entry is None:
                exact_field_entry = next(
                    (
                        entry
                        for entry in candidate_field_entries
                        if entry[3] and entry[3] in query_root_keys
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

        matched_heading = heading if exact_heading or contains_heading or fuzzy_heading_score >= 0.84 else ""
        matched_field = exact_field_label or (contains_field_entry[0] if contains_field_entry else "")
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
                " ".join(str(field) for field in candidate.get("fieldNames", [])),
                str(candidate.get("tagName", "")),
                str(candidate.get("normalizedTagName", "")),
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

    def _normalized_codes(self, candidate: dict[str, Any]) -> set[str]:
        codes = {str(code).strip() for code in candidate.get("hsCodes", []) if str(code).strip()}
        codes.update(str(code).strip() for code in candidate.get("eximCodes", []) if str(code).strip())
        return codes

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
                and not structure_matches["headingExactMatch"]
                and not structure_matches["fieldExactMatch"]
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
            if structure_matches["headingExactMatch"]:
                score += 260
            elif structure_matches["headingContainsMatch"]:
                score += 140
            elif structure_matches["fuzzyHeadingScore"] >= 0.9:
                score += 90 * structure_matches["fuzzyHeadingScore"]
            if structure_matches["fieldExactMatch"]:
                score += 230
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
                    "confidence": 0.99 if exact_hs else 0.96 if structure_matches["fieldExactMatch"] or structure_matches["normalizedFieldExactMatch"] else 0.93 if exact_section else 0.88,
                }
            )
        results.sort(key=lambda item: float(item.get("metadataScore", 0.0)), reverse=True)
        return results[:20]

    def _bm25_search(self, analysis: QueryAnalysis, candidates: list[dict[str, Any]]) -> list[dict[str, Any]]:
        query_tokens = list(self._query_terms(analysis.question))
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
            if analysis.question.lower() in haystack:
                score += 6.0
            if any(code in haystack.replace(" ", "") for code in analysis.hs_codes):
                score += 8.0
            if matched_tokens and any(token in title_text for token in matched_tokens):
                score += 2.5
            if structure_matches["headingExactMatch"]:
                score += 10.0
            elif structure_matches["headingContainsMatch"]:
                score += 5.5
            elif structure_matches["fuzzyHeadingScore"] >= 0.88:
                score += structure_matches["fuzzyHeadingScore"] * 4.0
            if structure_matches["fieldExactMatch"]:
                score += 9.0
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

    def _vector_search(self, analysis: QueryAnalysis, candidates: list[dict[str, Any]]) -> list[dict[str, Any]]:
        query_vector = embedding_service.embed_text(analysis.question)
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
        if candidate.get("exactHsMatch"):
            return 0.99
        if candidate.get("headingExactMatch") or candidate.get("fieldExactMatch"):
            return 0.97
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
            exact_hs = 1 if candidate.get("exactHsMatch") else 0
            exact_section = 1 if candidate.get("exactSectionMatch") else 0
            exact_chapter = 1 if candidate.get("exactChapterMatch") else 0
            exact_table = 1 if candidate.get("isTableRow") and bool(analysis.hs_codes) and candidate.get("exactHsMatch") else 0
            exact_heading = 1 if candidate.get("headingExactMatch") else 0
            exact_field = 1 if candidate.get("fieldExactMatch") else 0
            normalized_field = 1 if candidate.get("normalizedFieldExactMatch") else 0
            normalized_root = 1 if candidate.get("normalizedFieldRootMatch") else 0
            contains_heading = 1 if candidate.get("headingContainsMatch") else 0
            contains_field = 1 if candidate.get("fieldContainsMatch") else 0
            fuzzy_heading = float(candidate.get("fuzzyHeadingScore", 0.0))
            fuzzy_field = float(candidate.get("fuzzyFieldScore", 0.0))
            keyword_score = float(candidate.get("metadataScore", 0.0)) + float(candidate.get("bm25Score", 0.0))
            semantic_score = float(candidate.get("vectorSimilarity", 0.0))
            final_score = (
                (exact_hs * 500.0)
                + (exact_section * 120.0)
                + (exact_chapter * 80.0)
                + (exact_table * 50.0)
                + (exact_heading * 220.0)
                + (exact_field * 200.0)
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
                    ("exact_hs_code_match", bool(exact_hs)),
                    ("exact_section_match", bool(exact_section)),
                    ("exact_chapter_match", bool(exact_chapter)),
                    ("exact_table_row_match", bool(exact_table)),
                    ("exact_heading_match", bool(exact_heading)),
                    ("exact_field_match", bool(exact_field)),
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
                1 if item.get("exactHsMatch") else 0,
                1 if item.get("exactSectionMatch") else 0,
                1 if item.get("exactChapterMatch") else 0,
                1 if item.get("isTableRow") else 0,
                1 if item.get("headingExactMatch") else 0,
                1 if item.get("fieldExactMatch") else 0,
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
        allowed_types = self.type_aliases.get(mode, self.type_aliases["keyword"])
        filtered_candidates = [
            candidate
            for candidate in self._candidates(index)
            if self._passes_filters(candidate, allowed_types, collection_filters, chapter_filters, section_filters, document_filters)
        ]

        metadata_results = self._metadata_lookup(analysis, filtered_candidates)
        bm25_results = self._bm25_search(analysis, filtered_candidates)
        vector_results = self._vector_search(analysis, filtered_candidates)
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
            "detected_namespace": analysis.detected_namespace,
            "normalized_field_reference": analysis.normalized_field_reference,
            "detected_entities": list(analysis.entities),
            "detected_hs_code": list(analysis.hs_codes),
            "detected_keywords": sorted(self._query_terms(analysis.question)),
            "detected_phrases": self._question_phrases(analysis.question),
            "document_filters": sorted(document_filters) if document_filters else [],
            "applied_document_filter": sorted(document_filters) if document_filters else [],
            "filtered_candidates_count": len(filtered_candidates),
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
                    "sourcePages": item.get("sourcePages", []),
                    "matchedHeading": item.get("matchedHeading", ""),
                    "matchedField": item.get("matchedField", ""),
                    "headingExactMatch": bool(item.get("headingExactMatch")),
                    "fieldExactMatch": bool(item.get("fieldExactMatch")),
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
        }
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
