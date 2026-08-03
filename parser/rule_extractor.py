from __future__ import annotations

import re
from collections import Counter
from typing import Dict, List, Sequence

from config import CONFIG

from .base import BaseExtractor
from .models import SectionDraft, SectionKnowledge
from .utils import (
    flatten_table,
    keyword_candidates,
    normalise_whitespace,
    sentence_contains_any,
    split_lines,
    split_sentences,
    take_first,
    to_thanglish,
    unique_preserve,
)


class RuleExtractor(BaseExtractor):
    def __init__(self) -> None:
        super().__init__()
        self._compiled_patterns = [re.compile(pattern) for pattern in CONFIG.section_heading_patterns]

    def extract_sections(self, pages: Sequence, source_document: str) -> List[SectionDraft]:
        chapter_number, chapter_title = self.extract_chapter_metadata(pages, source_document)
        pages_by_number = {int(page.page_number): page for page in pages}
        lines_with_pages: List[tuple[int, str]] = []
        for page in pages:
            for line in split_lines(page.text):
                lines_with_pages.append((page.page_number, line))

        sections: List[SectionDraft] = []
        current_section: str | None = None
        current_title: str | None = None
        current_lines: List[str] = []
        current_pages: List[int] = []

        def flush() -> None:
            nonlocal current_section, current_title, current_lines, current_pages
            if current_section and current_title and current_lines:
                sections.append(
                    SectionDraft(
                        chapter_number=chapter_number,
                        chapter_title=chapter_title,
                        section_number=current_section,
                        title=current_title,
                        content="\n".join(current_lines).strip(),
                        page_numbers=unique_preserve([str(page) for page in current_pages]),
                        source_document=source_document,
                        tables=self._tables_for_content("\n".join(current_lines), current_pages, pages_by_number),
                    )
                )
            current_section = None
            current_title = None
            current_lines = []
            current_pages = []

        for page_number, line in lines_with_pages:
            heading = self._match_heading(line)
            if heading:
                flush()
                current_section = heading["section"]
                current_title = heading["title"]
                current_lines = [line]
                current_pages = [page_number]
            elif current_section:
                current_lines.append(line)
                current_pages.append(page_number)

        flush()

        if not sections:
            combined = "\n".join(line for _, line in lines_with_pages)
            sections.append(
                SectionDraft(
                    chapter_number=chapter_number,
                    chapter_title=chapter_title,
                    section_number="1",
                    title=chapter_title or "Document Overview",
                    content=combined,
                    page_numbers=[page.page_number for page in pages],
                    source_document=source_document,
                    tables=self._tables_for_content(combined, [page.page_number for page in pages], pages_by_number),
                )
            )

        normalised_sections: List[SectionDraft] = []
        for section in sections:
            pages_as_int = [int(page) for page in section.page_numbers]
            normalised_sections.append(
                SectionDraft(
                    chapter_number=section.chapter_number,
                    chapter_title=section.chapter_title,
                    section_number=section.section_number,
                    title=section.title,
                    content=section.content,
                    page_numbers=pages_as_int,
                    source_document=section.source_document,
                    tables=section.tables,
                )
            )
        merged_sections = self._merge_duplicate_sections(normalised_sections)
        self.logger.info("Extracted %s section drafts from %s", len(merged_sections), source_document)
        return merged_sections

    def extract(self, draft: SectionDraft, all_section_numbers: Sequence[str]) -> SectionKnowledge:
        raw_text = normalise_whitespace(draft.content)
        sentences = split_sentences(raw_text)
        business_logic = self._business_logic(sentences)
        actions = self._actions(sentences)
        documents = self._documents(sentences)
        questions, answers = self._qa_pairs(draft.title, actions, documents)
        keywords = self._keywords(draft.title, raw_text)
        related_sections = [section for section in all_section_numbers if section != draft.section_number and section in raw_text]
        purpose = self._purpose(sentences, draft.title)
        summary = self._summary(sentences)
        business_meaning = self._business_meaning(draft.title, sentences, business_logic)
        business_explanation = self._business_explanation(draft.title, summary, business_logic, actions)
        real_world_example = self._real_world_example(draft.title, actions, documents)

        knowledge = SectionKnowledge(
            chapter_number=draft.chapter_number,
            chapter_title=draft.chapter_title,
            section=draft.section_number,
            title=draft.title,
            purpose=purpose,
            purpose_thanglish=to_thanglish(purpose, draft.title),
            summary=summary,
            business_meaning=business_meaning,
            business_explanation=business_explanation,
            business_explanation_thanglish=to_thanglish(business_explanation, draft.title),
            business_logic=business_logic,
            documents=documents,
            required_documents=documents,
            tables=draft.tables,
            actions=actions,
            examples=self._examples(sentences, draft.title),
            real_world_example=real_world_example,
            real_world_example_thanglish=to_thanglish(real_world_example, draft.title),
            ai_rules=self._ai_rules(business_logic, actions),
            database_fields=self._database_fields(draft, documents, keywords),
            error_messages=self._error_messages(sentences),
            questions_users_may_ask=questions,
            expected_ai_answers=answers,
            keywords=keywords,
            search_keywords=keywords,
            intent=self._intent(actions, draft.title),
            tags=self._tags(draft, business_logic, documents),
            related_sections=unique_preserve(related_sections),
            related_rules=business_logic[:5],
            raw_text=raw_text,
            pages=draft.page_numbers,
            source_document=draft.source_document,
        )
        return knowledge

    def extract_chapter_metadata(self, pages: Sequence, source_document: str) -> tuple[str, str]:
        filename_match = re.search(r"chapter[\s_\-+]*(\d+)", source_document, flags=re.IGNORECASE)
        chapter_number = filename_match.group(1) if filename_match else ""
        candidate_lines: List[str] = []
        for page in pages[:2]:
            candidate_lines.extend(split_lines(page.text))

        chapter_index = -1
        for index, line in enumerate(candidate_lines):
            match = re.search(r"\bCHAPTER\s+(\d+)\b", line, flags=re.IGNORECASE)
            if match:
                chapter_number = match.group(1)
                chapter_index = index
                break

        title_lines: List[str] = []
        if chapter_index >= 0:
            before = []
            index = chapter_index - 1
            while index >= 0 and len(before) < 4:
                line = candidate_lines[index]
                if self._skip_title_line(line):
                    break
                before.insert(0, line)
                index -= 1

            after = []
            index = chapter_index + 1
            while index < len(candidate_lines) and len(after) < 6:
                line = candidate_lines[index]
                if self._skip_title_line(line):
                    break
                after.append(line)
                index += 1
            title_lines = before + after

        chapter_title = normalise_whitespace(" ".join(title_lines))
        if not chapter_title:
            chapter_title = source_document.replace(".pdf", "").replace("_", " ").replace("+", " ").replace("-", " ").strip()
        return chapter_number, chapter_title

    def _match_heading(self, line: str) -> Dict[str, str] | None:
        for pattern in self._compiled_patterns:
            match = pattern.match(line)
            if match and self._looks_like_title(match.group("title")):
                return {
                    "section": match.group("section").strip(),
                    "title": normalise_whitespace(match.group("title")),
                }
        return None

    def _looks_like_title(self, value: str) -> bool:
        words = value.split()
        return len(words) >= 1 and sum(char.isalpha() for char in value) >= 4

    def _skip_title_line(self, value: str) -> bool:
        return bool(
            re.match(r"^(?:pg\.?\s*\d+|page\s+\d+|\d+(?:\.\d+)+\b)", value, flags=re.IGNORECASE)
            or re.match(r"^\d+$", value)
            or "chapter" in value.casefold()
        )

    def _merge_duplicate_sections(self, sections: Sequence[SectionDraft]) -> List[SectionDraft]:
        merged: Dict[tuple[str, str], SectionDraft] = {}
        order: List[tuple[str, str]] = []
        for section in sections:
            key = (section.section_number, section.title)
            if key not in merged:
                merged[key] = SectionDraft(
                    chapter_number=section.chapter_number,
                    chapter_title=section.chapter_title,
                    section_number=section.section_number,
                    title=section.title,
                    content=section.content,
                    page_numbers=list(section.page_numbers),
                    source_document=section.source_document,
                    tables=[[[cell for cell in row] for row in table] for table in section.tables],
                )
                order.append(key)
                continue

            current = merged[key]
            if section.content not in current.content:
                current.content = f"{current.content}\n{section.content}".strip()
            current.page_numbers = sorted(set(current.page_numbers).union(section.page_numbers))
            current.tables = self._merge_tables(current.tables, section.tables)
        return [merged[key] for key in order]

    def _tables_for_content(
        self,
        content: str,
        page_numbers: Sequence[int],
        pages_by_number: Dict[int, object],
    ) -> List[List[List[str]]]:
        normalized_content = normalise_whitespace(content).casefold()
        collected: List[List[List[str]]] = []
        seen: set[tuple[tuple[str, ...], ...]] = set()

        for page_number in unique_preserve([str(page) for page in page_numbers]):
            page = pages_by_number.get(int(page_number))
            if not page:
                continue
            for table in getattr(page, "tables", []) or []:
                normalized_table = self._normalize_table(table)
                if not normalized_table:
                    continue
                fingerprint = tuple(tuple(row) for row in normalized_table)
                if fingerprint in seen:
                    continue
                if self._table_matches_content(normalized_table, normalized_content):
                    seen.add(fingerprint)
                    collected.append(normalized_table)

        return collected

    def _normalize_table(self, table: Sequence[Sequence[str]]) -> List[List[str]]:
        normalized_rows: List[List[str]] = []
        for row in table:
            normalized_row = [normalise_whitespace(str(cell or "")) for cell in row]
            if any(normalized_row):
                normalized_rows.append(normalized_row)
        return normalized_rows

    def _table_matches_content(self, table: Sequence[Sequence[str]], normalized_content: str) -> bool:
        if not normalized_content:
            return False

        flattened = normalise_whitespace(flatten_table(table))
        if flattened and flattened.casefold() in normalized_content:
            return True

        matching_cells = 0
        meaningful_cells = 0
        for row in table:
            for cell in row:
                normalized_cell = normalise_whitespace(cell)
                if len(normalized_cell) < 3:
                    continue
                meaningful_cells += 1
                if normalized_cell.casefold() in normalized_content:
                    matching_cells += 1

        if meaningful_cells == 0:
            return False
        return matching_cells >= min(2, meaningful_cells) or matching_cells >= max(1, meaningful_cells // 2)

    def _merge_tables(
        self,
        existing: Sequence[Sequence[Sequence[str]]],
        incoming: Sequence[Sequence[Sequence[str]]],
    ) -> List[List[List[str]]]:
        merged: List[List[List[str]]] = []
        seen: set[tuple[tuple[str, ...], ...]] = set()

        for table in list(existing) + list(incoming):
            normalized_table = self._normalize_table(table)
            if not normalized_table:
                continue
            fingerprint = tuple(tuple(row) for row in normalized_table)
            if fingerprint in seen:
                continue
            seen.add(fingerprint)
            merged.append(normalized_table)

        return merged

    def _purpose(self, sentences: Sequence[str], title: str) -> str:
        candidates = [sentence for sentence in sentences[:6] if re.search(r"\b(for|to|in order to|meant to|shall)\b", sentence, re.IGNORECASE)]
        return take_first(candidates, default=f"Defines the operational requirements for {title}.")

    def _summary(self, sentences: Sequence[str]) -> str:
        return " ".join(sentences[:3]) if sentences else "No textual summary available."

    def _business_meaning(self, title: str, sentences: Sequence[str], business_logic: Sequence[str]) -> str:
        if business_logic:
            return f"{title} governs how DGFT business controls should be applied, validated, and enforced."
        return take_first(sentences[:2], default=f"{title} is relevant to DGFT operational processing.")

    def _business_explanation(
        self,
        title: str,
        summary: str,
        business_logic: Sequence[str],
        actions: Sequence[str],
    ) -> str:
        if business_logic:
            return (
                f"{title} explains the operating rule set that DEKAI should enforce. "
                f"Key control points include {business_logic[0]}"
                + (f" The section also drives actions such as {actions[0]}." if actions else "")
            )
        return summary or f"{title} is not fully elaborated in the uploaded documents."

    def _business_logic(self, sentences: Sequence[str]) -> List[str]:
        logic = []
        for sentence in sentences:
            if re.search(r"\b(shall|must|may not|should|eligible|subject to|required to)\b", sentence, flags=re.IGNORECASE):
                logic.append(sentence)
        return unique_preserve(logic)

    def _actions(self, sentences: Sequence[str]) -> List[str]:
        actions = []
        for sentence in sentences:
            if sentence_contains_any(sentence, CONFIG.action_verbs):
                actions.append(sentence)
        return unique_preserve(actions)

    def _documents(self, sentences: Sequence[str]) -> List[str]:
        documents = []
        for sentence in sentences:
            if sentence_contains_any(sentence, CONFIG.document_markers):
                noun_like = re.findall(r"\b[A-Z][A-Za-z0-9/&()\- ]{2,60}(?:Certificate|Licence|License|Application|Invoice|Bill|Declaration|Annexure|Statement|Document|Proof|Copy)\b", sentence)
                if noun_like:
                    documents.extend(noun_like)
                else:
                    documents.append(sentence)
        return unique_preserve(documents)

    def _examples(self, sentences: Sequence[str], title: str) -> List[str]:
        examples = [sentence for sentence in sentences if re.search(r"\b(example|for instance|such as)\b", sentence, flags=re.IGNORECASE)]
        if examples:
            return unique_preserve(examples)
        return [f"User asks to process {title}; the platform checks conditions, validations, and documents before action."]

    def _ai_rules(self, business_logic: Sequence[str], actions: Sequence[str]) -> List[str]:
        rules = []
        for logic in business_logic[:6]:
            rules.append(f"IF detected context matches section rule THEN enforce: {logic}")
        if actions:
            rules.append(f"IF validations pass THEN recommend action: {actions[0]}")
        return unique_preserve(rules)

    def _database_fields(self, draft: SectionDraft, documents: Sequence[str], keywords: Sequence[str]) -> List[Dict[str, object]]:
        fields = [
            {
                "name": "section_code",
                "type": "string",
                "required": True,
                "source": "parsed_section_heading",
            },
            {
                "name": "section_title",
                "type": "string",
                "required": True,
                "source": "parsed_section_heading",
            },
        ]
        for keyword in keywords[:8]:
            fields.append(
                {
                    "name": f"{keyword.lower().replace('/', '_').replace('-', '_')}_flag",
                    "type": "boolean",
                    "required": False,
                    "source": f"keyword:{keyword}",
                }
            )
        for index, document in enumerate(documents[:6], start=1):
            fields.append(
                {
                    "name": f"document_{index}_submitted",
                    "type": "boolean",
                    "required": True,
                    "source": document,
                }
            )
        return fields

    def _error_messages(self, sentences: Sequence[str]) -> List[str]:
        messages = []
        for sentence in sentences:
            if re.search(r"\b(reject|invalid|incomplete|missing|not permitted|not allowed)\b", sentence, flags=re.IGNORECASE):
                messages.append(sentence)
        if not messages:
            messages.append("Validation failed because the section requirements were not fully met.")
        return unique_preserve(messages)

    def _real_world_example(self, title: str, actions: Sequence[str], documents: Sequence[str]) -> str:
        document_text = ", ".join(documents[:3]) if documents else "the prescribed DGFT records"
        action_text = actions[0] if actions else f"follow the {title} process"
        return (
            f"Example: an importer or exporter invokes {title}, submits {document_text}, "
            f"and DEKAI uses the extracted rules to {action_text.lower()}."
        )

    def _qa_pairs(self, title: str, actions: Sequence[str], documents: Sequence[str]) -> tuple[List[str], List[str]]:
        questions = [
            f"What does {title} require?",
            f"Which documents are needed for {title}?",
            f"How does DEKAI validate {title} requests?",
        ]
        answers = [
            f"{title} requires the platform to interpret the section text, apply the extracted business rules, and present the correct next action.",
            f"Required documents are inferred from the section text: {', '.join(documents[:5]) if documents else 'no explicit documents were detected.'}",
            f"DEKAI validates {title} by checking conditions, required documents, authority references, and exception clauses before recommending an outcome.",
        ]
        if actions:
            questions.append(f"What action should be taken for {title}?")
            answers.append(f"The primary extracted action is: {actions[0]}")
        return questions, answers

    def _keywords(self, title: str, raw_text: str) -> List[str]:
        bag = keyword_candidates(f"{title} {raw_text}", min_length=3)
        frequency = Counter(word.casefold() for word in bag)
        ranked = sorted(bag, key=lambda item: (-frequency[item.casefold()], len(item)))
        return unique_preserve(ranked[:20])

    def _intent(self, actions: Sequence[str], title: str) -> str:
        if actions:
            return f"Support {title} processing and compliance validation."
        return f"Provide knowledge guidance for {title}."

    def _tags(self, draft: SectionDraft, business_logic: Sequence[str], documents: Sequence[str]) -> List[str]:
        tags = [draft.section_number, draft.title]
        if business_logic:
            tags.append("business-rule")
        if documents:
            tags.append("document-driven")
        tags.append("dgft")
        return unique_preserve(tags)
