from __future__ import annotations

import re
from collections import defaultdict
from typing import Dict, Iterable, List, Sequence

import networkx as nx

from .models import DependencyEdge, DocumentKnowledge, SectionKnowledge
from .utils import ascii_vertical_flow, normalise_whitespace, to_thanglish, unique_preserve
from .xml_utils import build_section_hierarchy


class KnowledgeBaseBuilder:
    def __init__(self) -> None:
        self.domain_entities = [
            "DGFT",
            "IEC",
            "FTP",
            "HBP",
            "RA",
            "SCOMET",
            "EPCG",
            "DFIA",
            "Advance Authorisation",
            "Advance Authorization",
            "EOU",
            "EHTP",
            "STP",
            "BTP",
            "SEZ",
            "DTA",
            "CBIC",
            "Customs",
            "Banks",
            "PAN",
            "LEO",
            "EODC",
            "ANF",
            "Appendices",
            "District Export Hubs",
            "Deemed Exports",
            "Quality Complaints",
            "Trade Disputes",
            "E-Commerce Export Hubs",
        ]

    def enrich_sections(self, sections: Sequence[SectionKnowledge]) -> None:
        section_index = {section.section: section for section in sections}
        chapter_by_section = {section.section: section.chapter_number for section in sections}

        for section in sections:
            section.condition_logic = self._condition_logic(section)
            section.business_rules = self._business_rules(section)
            section.workflow_ascii = section.workflow_ascii or ascii_vertical_flow(section.title, section.workflow)
            section.decision_tree_ascii = section.decision_tree_ascii or ascii_vertical_flow(
                f"{section.title} Decision", section.decision_tree
            )
            section.faq = self._faq(section)
            section.ai_qa_examples = self._ai_qa_examples(section)
            section.dekai_ai_implementation_notes = self._implementation_notes(section)
            section.dekai_ai_implementation_notes_thanglish = [
                to_thanglish(note, section.title) for note in section.dekai_ai_implementation_notes
            ]
            section.hierarchy_nodes = build_section_hierarchy(
                section.raw_text,
                page_numbers=section.pages,
                section_number=section.section,
                section_title=section.title,
                document_name=section.source_document,
                exceptions=section.exceptions,
                business_rules=section.business_rules,
                validations=section.validations,
            )

            shared_chapters = []
            for related_section in section.related_sections:
                chapter = chapter_by_section.get(related_section)
                if chapter and chapter != section.chapter_number:
                    shared_chapters.append(chapter)
            entity_chapters = self._related_chapters_by_entities(section, sections)
            shared_chapters.extend(entity_chapters)
            section.related_chapters = unique_preserve(shared_chapters)

            if not section.dependencies:
                section.dependencies = [
                    f"{related}: {section_index[related].title}"
                    for related in section.related_sections
                    if related in section_index
                ]

    def build_master_knowledge_base(self, documents: Sequence[DocumentKnowledge]) -> Dict[str, object]:
        all_sections = [section for document in documents for section in document.sections]
        self.enrich_sections(all_sections)
        glossary = self._merge_glossary(documents)
        entities = self._merge_entities(documents, all_sections)
        unified_topics = self._unified_topics(all_sections)
        chapter_reports = self._chapter_reports(all_sections)
        dependency_edges = self._dependency_edges(documents)
        chapter_relationships = self._chapter_relationships(all_sections)
        master_map_ascii = self._master_map_ascii(all_sections, unified_topics)
        graph_payload = self._graph_payload(all_sections, unified_topics, chapter_relationships)
        searchable_sections = [
            {
                "chapter_number": section.chapter_number,
                "chapter_title": section.chapter_title,
                "section": section.section,
                "title": section.title,
                "keywords": section.search_keywords,
                "entities": self._match_entities(section),
                "related_sections": section.related_sections,
                "related_chapters": section.related_chapters,
                "business_rules": section.business_rules,
            }
            for section in all_sections
        ]

        return {
            "knowledge_base_name": "DEKAI DGFT Knowledge Base",
            "source_documents": [document.source_pdf.name for document in documents],
            "chapter_count": len(chapter_reports),
            "section_count": len(all_sections),
            "chapters": chapter_reports,
            "sections": [section.to_dict() for section in all_sections],
            "glossary": glossary,
            "entities": entities,
            "unified_topics": unified_topics,
            "chapter_relationships": chapter_relationships,
            "dependency_edges": dependency_edges,
            "master_knowledge_map_ascii": master_map_ascii,
            "master_knowledge_graph": graph_payload,
            "searchable_sections": searchable_sections,
        }

    def _condition_logic(self, section: SectionKnowledge) -> List[Dict[str, str]]:
        logic = []
        for index, condition in enumerate(section.conditions, start=1):
            trigger = f"{section.chapter_number}.{section.section}.{index}"
            if_match = re.search(r"\bif\b\s*(.*?)(?:,| then | shall | must )", condition, flags=re.IGNORECASE)
            then_match = re.search(r"\bthen\b\s*(.*)$", condition, flags=re.IGNORECASE)
            if_text = if_match.group(1).strip() if if_match else condition
            then_text = then_match.group(1).strip() if then_match else (section.actions[0] if section.actions else "Route for review")
            logic.append({"id": trigger, "if": if_text, "then": then_text, "source": condition})
        if not logic and section.actions:
            logic.append(
                {
                    "id": f"{section.chapter_number}.{section.section}.1",
                    "if": f"Section {section.section} is applicable",
                    "then": section.actions[0],
                    "source": "Derived from uploaded documents",
                }
            )
        return logic

    def _business_rules(self, section: SectionKnowledge) -> List[Dict[str, str]]:
        rules = []
        source_rules = section.business_logic or section.ai_rules or [section.summary]
        for index, rule_text in enumerate(source_rules, start=1):
            rule_id = f"CH{section.chapter_number}-SEC{section.section.replace('.', '_')}-R{index:03d}"
            rules.append(
                {
                    "rule_id": rule_id,
                    "rule_description": rule_text,
                    "trigger": section.title,
                    "condition": section.condition_logic[min(index - 1, len(section.condition_logic) - 1)]["if"]
                    if section.condition_logic
                    else "Not explicitly covered in uploaded documents.",
                    "validation": section.validations[min(index - 1, len(section.validations) - 1)]
                    if section.validations
                    else "Not explicitly covered in uploaded documents.",
                    "action": section.actions[min(index - 1, len(section.actions) - 1)]
                    if section.actions
                    else "Manual review required.",
                    "exception": section.exceptions[min(index - 1, len(section.exceptions) - 1)]
                    if section.exceptions
                    else "No explicit exception found in uploaded documents.",
                    "output": f"DEKAI should produce a compliance decision for {section.section} - {section.title}.",
                }
            )
        return rules

    def _faq(self, section: SectionKnowledge) -> List[Dict[str, str]]:
        questions = [
            f"What is the purpose of section {section.section}?",
            f"What documents are required under {section.title}?",
            f"Which authority handles {section.title}?",
        ]
        answers = [
            section.business_explanation,
            ", ".join(section.required_documents) if section.required_documents else "Not explicitly covered in uploaded documents.",
            ", ".join(section.authorities) if section.authorities else "Not explicitly covered in uploaded documents.",
        ]
        faq = []
        for question, answer in zip(questions, answers):
            faq.append(
                {
                    "question_en": question,
                    "answer_en": answer,
                    "question_thanglish": to_thanglish(question, section.title),
                    "answer_thanglish": to_thanglish(answer, section.title),
                }
            )
        return faq

    def _ai_qa_examples(self, section: SectionKnowledge) -> List[Dict[str, str]]:
        samples = [
            (
                f"User asks: How do I comply with {section.title}?",
                f"AI answers: DEKAI should evaluate section {section.section}, apply the extracted rules, and guide the user through {section.workflow[0] if section.workflow else 'the prescribed workflow'}.",
            ),
            (
                f"User asks: Which validations apply to {section.title}?",
                f"AI answers: Applicable validations are {', '.join(section.validations[:3]) if section.validations else 'not explicitly covered in the uploaded documents.'}",
            ),
        ]
        return [
            {
                "question_en": question,
                "answer_en": answer,
                "question_thanglish": to_thanglish(question, section.title),
                "answer_thanglish": to_thanglish(answer, section.title),
            }
            for question, answer in samples
        ]

    def _implementation_notes(self, section: SectionKnowledge) -> List[str]:
        notes = [
            f"Capture chapter {section.chapter_number}, section {section.section}, title, and page references as immutable knowledge metadata.",
            f"Bind validations for {section.title} into a rule engine keyed by the rule IDs extracted for this section.",
        ]
        if section.required_documents:
            notes.append(f"Expose document upload controls for: {', '.join(section.required_documents[:6])}.")
        if section.authorities:
            notes.append(f"Route escalations or approvals to: {', '.join(section.authorities[:4])}.")
        if section.exceptions:
            notes.append("Trigger manual review when exception clauses are detected.")
        if section.related_sections:
            notes.append(f"Show contextual links to related sections: {', '.join(section.related_sections)}.")
        return unique_preserve(notes)

    def _related_chapters_by_entities(self, target: SectionKnowledge, sections: Sequence[SectionKnowledge]) -> List[str]:
        target_entities = set(entity.casefold() for entity in self._match_entities(target))
        related = []
        for section in sections:
            if section.section == target.section:
                continue
            if section.chapter_number == target.chapter_number:
                continue
            section_entities = set(entity.casefold() for entity in self._match_entities(section))
            if target_entities.intersection(section_entities):
                related.append(section.chapter_number)
        return related

    def _merge_glossary(self, documents: Sequence[DocumentKnowledge]) -> Dict[str, str]:
        glossary: Dict[str, str] = {}
        for document in documents:
            glossary.update(document.glossary)
        for term in self.domain_entities:
            glossary.setdefault(term, "Referenced in uploaded DGFT HBP chapters.")
        return dict(sorted(glossary.items()))

    def _merge_entities(self, documents: Sequence[DocumentKnowledge], sections: Sequence[SectionKnowledge]) -> Dict[str, List[str]]:
        merged: Dict[str, set[str]] = defaultdict(set)
        for document in documents:
            for key, values in document.entities.items():
                merged[key].update(values)
        merged["domain_entities"].update(self.domain_entities)
        merged["section_entities"].update(entity for section in sections for entity in self._match_entities(section))
        return {key: sorted(values) for key, values in merged.items()}

    def _unified_topics(self, sections: Sequence[SectionKnowledge]) -> List[Dict[str, object]]:
        topic_index: Dict[str, Dict[str, object]] = {}
        for section in sections:
            topic_names = self._match_entities(section) or [section.title]
            for topic in topic_names:
                key = topic.casefold()
                bucket = topic_index.setdefault(
                    key,
                    {
                        "topic": topic,
                        "chapters": [],
                        "sections": [],
                        "related_sections": [],
                        "business_rules": [],
                        "documents": [],
                        "authorities": [],
                        "keywords": [],
                    },
                )
                bucket["chapters"].append(section.chapter_number)
                bucket["sections"].append(f"{section.section} {section.title}")
                bucket["related_sections"].extend(section.related_sections)
                bucket["business_rules"].extend(rule["rule_id"] for rule in section.business_rules)
                bucket["documents"].extend(section.required_documents)
                bucket["authorities"].extend(section.authorities)
                bucket["keywords"].extend(section.search_keywords)

        topics = []
        for bucket in topic_index.values():
            topics.append(
                {
                    "topic": bucket["topic"],
                    "chapters": unique_preserve(bucket["chapters"]),
                    "sections": unique_preserve(bucket["sections"]),
                    "related_sections": unique_preserve(bucket["related_sections"]),
                    "business_rules": unique_preserve(bucket["business_rules"]),
                    "documents": unique_preserve(bucket["documents"]),
                    "authorities": unique_preserve(bucket["authorities"]),
                    "keywords": unique_preserve(bucket["keywords"]),
                }
            )
        return sorted(topics, key=lambda item: item["topic"])

    def _chapter_reports(self, sections: Sequence[SectionKnowledge]) -> List[Dict[str, object]]:
        grouped: Dict[str, List[SectionKnowledge]] = defaultdict(list)
        for section in sections:
            grouped[section.chapter_number].append(section)

        reports = []
        for chapter_number, chapter_sections in sorted(grouped.items(), key=lambda item: int(item[0] or 0)):
            chapter_title = chapter_sections[0].chapter_title
            section_titles = ", ".join(section.title for section in chapter_sections[:8])
            summary_en = (
                f"Chapter {chapter_number} covers {chapter_title}. "
                f"Key section topics include {section_titles}."
            )
            summary_thanglish = to_thanglish(summary_en, f"Chapter {chapter_number}")
            reports.append(
                {
                    "chapter_number": chapter_number,
                    "chapter_title": chapter_title,
                    "summary_en": summary_en,
                    "summary_thanglish": summary_thanglish,
                    "section_count": len(chapter_sections),
                    "rule_count": sum(len(section.business_rules) for section in chapter_sections),
                    "condition_count": sum(len(section.condition_logic) for section in chapter_sections),
                    "validation_count": sum(len(section.validations) for section in chapter_sections),
                    "workflow_count": sum(len(section.workflow) for section in chapter_sections),
                    "authority_count": sum(len(section.authorities) for section in chapter_sections),
                    "timeline_count": sum(len(section.timelines) for section in chapter_sections),
                    "exception_count": sum(len(section.exceptions) for section in chapter_sections),
                    "related_chapters": unique_preserve(
                        related for section in chapter_sections for related in section.related_chapters
                    ),
                    "sections": [
                        {
                            "section": section.section,
                            "title": section.title,
                            "pages": section.pages,
                        }
                        for section in chapter_sections
                    ],
                }
            )
        return reports

    def _dependency_edges(self, documents: Sequence[DocumentKnowledge]) -> List[Dict[str, str]]:
        edges = []
        for document in documents:
            for edge in document.dependency_edges:
                edges.append(edge.__dict__)
        return edges

    def _chapter_relationships(self, sections: Sequence[SectionKnowledge]) -> List[Dict[str, object]]:
        relationships: Dict[str, Dict[str, object]] = {}
        for section in sections:
            key = section.chapter_number
            bucket = relationships.setdefault(
                key,
                {
                    "chapter_number": section.chapter_number,
                    "chapter_title": section.chapter_title,
                    "linked_topics": [],
                    "linked_chapters": [],
                    "sections": [],
                },
            )
            bucket["linked_topics"].extend(self._match_entities(section))
            bucket["linked_chapters"].extend(section.related_chapters)
            bucket["sections"].append(section.section)

        return [
            {
                "chapter_number": value["chapter_number"],
                "chapter_title": value["chapter_title"],
                "linked_topics": unique_preserve(value["linked_topics"]),
                "linked_chapters": unique_preserve(value["linked_chapters"]),
                "sections": unique_preserve(value["sections"]),
            }
            for _, value in sorted(relationships.items(), key=lambda item: int(item[0] or 0))
        ]

    def _master_map_ascii(self, sections: Sequence[SectionKnowledge], unified_topics: Sequence[Dict[str, object]]) -> str:
        lines = ["DGFT", "|"]
        for chapter_number in unique_preserve(section.chapter_number for section in sections):
            chapter_sections = [section for section in sections if section.chapter_number == chapter_number]
            title = chapter_sections[0].chapter_title if chapter_sections else ""
            lines.append(f"+-- Chapter {chapter_number}: {title}")
            for section in chapter_sections[:12]:
                lines.append(f"|   +-- {section.section} {section.title}")
        lines.append("|")
        lines.append("+-- Unified Topics")
        for topic in unified_topics[:20]:
            lines.append(f"    +-- {topic['topic']} -> Chapters {', '.join(topic['chapters'])}")
        return "\n".join(lines)

    def _graph_payload(
        self,
        sections: Sequence[SectionKnowledge],
        unified_topics: Sequence[Dict[str, object]],
        chapter_relationships: Sequence[Dict[str, object]],
    ) -> Dict[str, object]:
        graph = nx.Graph()
        for relationship in chapter_relationships:
            chapter_node = f"Chapter {relationship['chapter_number']}"
            graph.add_node(chapter_node, node_type="chapter", title=relationship["chapter_title"])
            for linked_chapter in relationship["linked_chapters"]:
                graph.add_edge(chapter_node, f"Chapter {linked_chapter}", relation="related")
            for topic in relationship["linked_topics"]:
                graph.add_node(topic, node_type="topic")
                graph.add_edge(chapter_node, topic, relation="contains")
        return {
            "nodes": [{"id": node, **graph.nodes[node]} for node in graph.nodes],
            "edges": [
                {"source": source, "target": target, **graph.edges[source, target]}
                for source, target in graph.edges
            ],
            "topic_count": len(unified_topics),
        }

    def _match_entities(self, section: SectionKnowledge) -> List[str]:
        text = f"{section.title} {section.raw_text}"
        matches = [entity for entity in self.domain_entities if entity.casefold() in text.casefold()]
        capitalized_terms = re.findall(r"\b[A-Z][A-Z0-9/&-]{1,10}\b", text)
        matches.extend(capitalized_terms)
        return unique_preserve(matches)
