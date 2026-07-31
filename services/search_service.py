from __future__ import annotations

from collections import Counter, defaultdict
from math import log
from typing import Any

from .embedding_service import embedding_service
from .knowledge_engine import knowledge_engine_service
from .retrieval_service import QueryAnalysis, analyze_question, infer_record_collections


def _tokenize(value: str) -> list[str]:
    return embedding_service.tokenize(value)


class SearchService:
    type_aliases = {
        "keyword": {"section", "rule", "workflow", "condition", "definition", "chunk", "document", "chapter", "concept"},
        "document": {"document"},
        "chapter": {"chapter", "section", "concept"},
        "section": {"section", "chunk"},
        "rule": {"rule"},
        "workflow": {"workflow"},
        "authority": {"section", "rule"},
        "condition": {"condition", "rule"},
        "definition": {"definition", "concept"},
    }
    type_weights = {
        "section": 1.45,
        "chunk": 1.3,
        "rule": 1.2,
        "workflow": 1.1,
        "condition": 1.05,
        "chapter": 0.95,
        "document": 0.9,
        "concept": 0.8,
        "definition": 0.55,
    }
    stopwords = {"how", "what", "when", "where", "why", "which", "who", "can", "should", "would", "could", "about", "explain", "tell"}
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
                str(candidate.get("text", "")),
                str(candidate.get("chapterTitle", "")),
                str(candidate.get("documentName", "")),
                str(candidate.get("preview", "")),
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
    ) -> bool:
        candidate_type = str(candidate.get("type", "")).lower()
        if candidate_type not in allowed_types:
            return False

        collection_tags = infer_record_collections(candidate)
        if collection_filters and not collection_tags.intersection(collection_filters):
            return False

        candidate_section = str(candidate.get("sectionId", "")).strip()
        candidate_chapter = str(candidate.get("chapterNumber", "")).strip()
        if section_filters and candidate_section:
            if candidate_section not in section_filters:
                return False
        elif section_filters and candidate_type in {"section", "chunk", "rule", "workflow", "condition", "definition"}:
            return False

        if chapter_filters and candidate_chapter:
            if candidate_chapter not in chapter_filters:
                return False
        elif chapter_filters and candidate_type in {"chapter", "section", "chunk", "rule", "workflow", "condition", "definition"}:
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
            if not exact_hs and not exact_section and not exact_chapter:
                continue

            score = 0.0
            if exact_hs:
                score += 1000 + (50 if candidate.get("isTableRow") else 0)
            if exact_section:
                score += 200
            if exact_chapter:
                score += 120
            results.append(
                {
                    **candidate,
                    "metadataScore": round(score, 4),
                    "exactHsMatch": sorted(exact_hs),
                    "exactSectionMatch": exact_section,
                    "exactChapterMatch": exact_chapter,
                    "confidence": 0.99 if exact_hs else 0.93 if exact_section else 0.88,
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
            if score <= 0:
                continue
            results.append(
                {
                    **candidate,
                    "bm25Score": round(score, 4),
                    "matchedTokens": matched_tokens,
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
            results.append(
                {
                    **candidate,
                    "vectorSimilarity": round(similarity, 4),
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
        if candidate.get("exactSectionMatch"):
            return 0.94
        if candidate.get("exactChapterMatch"):
            return 0.9
        keyword_score = float(candidate.get("bm25Score", 0.0))
        semantic_score = float(candidate.get("vectorSimilarity", 0.0))
        return round(min(0.9, 0.45 + min(0.3, keyword_score / 20) + min(0.15, semantic_score / 2)), 4)

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
            exact_table = 1 if candidate.get("isTableRow") and (not analysis.hs_codes or candidate.get("exactHsMatch")) else 0
            keyword_score = float(candidate.get("metadataScore", 0.0)) + float(candidate.get("bm25Score", 0.0))
            semantic_score = float(candidate.get("vectorSimilarity", 0.0))
            final_score = (
                (exact_hs * 500.0)
                + (exact_section * 120.0)
                + (exact_chapter * 80.0)
                + (exact_table * 50.0)
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
            if self._passes_filters(candidate, allowed_types, collection_filters, chapter_filters, section_filters)
        ]

        metadata_results = self._metadata_lookup(analysis, filtered_candidates)
        bm25_results = self._bm25_search(analysis, filtered_candidates)
        vector_results = self._vector_search(analysis, filtered_candidates)
        merged_results, merged_total = self._merge_results(analysis, metadata_results, bm25_results, vector_results, limit)

        self._last_debug = {
            "user_question": analysis.question,
            "detected_intent": analysis.question_classification,
            "detected_entities": list(analysis.entities),
            "detected_hs_code": list(analysis.hs_codes),
            "metadata_results_count": len(metadata_results),
            "bm25_results_count": len(bm25_results),
            "vector_results_count": len(vector_results),
            "merged_results_count": merged_total,
            "top_ranked_chunks": [
                {
                    "id": item.get("id", ""),
                    "title": item.get("title", ""),
                    "sectionId": item.get("sectionId", ""),
                    "documentName": item.get("documentName", ""),
                    "score": item.get("score", 0),
                    "confidence": item.get("confidence", 0),
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
