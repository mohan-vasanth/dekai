from __future__ import annotations

import json
import re
from hashlib import sha1
from pathlib import Path
from typing import Any, Dict, Iterable, List, Sequence


def normalise_whitespace(value: str) -> str:
    value = value.replace("\u00a0", " ")
    value = re.sub(r"[ \t]+", " ", value)
    value = re.sub(r"\n{3,}", "\n\n", value)
    return value.strip()


def unique_preserve(items: Iterable[str]) -> List[str]:
    seen = set()
    ordered: List[str] = []
    for item in items:
        cleaned = normalise_whitespace(str(item))
        if not cleaned:
            continue
        key = cleaned.casefold()
        if key in seen:
            continue
        seen.add(key)
        ordered.append(cleaned)
    return ordered


def slugify(value: str) -> str:
    cleaned = re.sub(r"[^A-Za-z0-9]+", "_", value.strip())
    cleaned = re.sub(r"_+", "_", cleaned)
    return cleaned.strip("_") or "untitled"


def source_document_markdown_name(filename: str) -> str:
    return f"{Path(str(filename or '').strip()).stem or 'document'}.md"


def safe_section_slug(section: str, title: str) -> str:
    safe_section = re.sub(r"[^0-9A-Za-z.]+", "_", section.strip()).strip("_")
    return f"{safe_section}_{slugify(title)}"


def safe_document_section_slug(document_name: str, section: str, title: str) -> str:
    document_stem = Path(str(document_name or "").strip()).stem or "document"
    return f"{slugify(document_stem)}__{safe_section_slug(section, title)}"


def split_sentences(text: str) -> List[str]:
    text = normalise_whitespace(text)
    if not text:
        return []
    return [sentence.strip() for sentence in re.split(r"(?<=[.?!])\s+", text) if sentence.strip()]


def split_lines(text: str) -> List[str]:
    return [normalise_whitespace(line) for line in text.splitlines() if normalise_whitespace(line)]


def write_json(path: Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, ensure_ascii=False), encoding="utf-8")


def write_text(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def flatten_table(table: Sequence[Sequence[str]]) -> str:
    rows = []
    for row in table:
        cells = [normalise_whitespace(cell or "") for cell in row]
        if any(cells):
            rows.append(" | ".join(cells))
    return "\n".join(rows)


def normalize_numeric_identifier(value: str) -> str:
    return re.sub(r"\D", "", str(value or ""))


def extract_numeric_identifiers(text: str, lengths: Sequence[int] = (6, 8, 10)) -> List[str]:
    matches = []
    for raw_match in re.findall(r"(?<!\d)(?:\d[\s-]*){6,10}(?!\d)", str(text or "")):
        normalized = normalize_numeric_identifier(raw_match)
        if len(normalized) in lengths:
            matches.append(normalized)
    return unique_preserve(matches)


def stable_text_hash(value: str) -> str:
    return sha1(normalise_whitespace(str(value or "")).encode("utf-8")).hexdigest()


def keyword_candidates(text: str, min_length: int = 3) -> List[str]:
    tokens = re.findall(r"\b[A-Za-z][A-Za-z/&-]{%d,}\b" % (min_length - 1), text)
    return unique_preserve(tokens)


def take_first(items: Sequence[str], default: str = "") -> str:
    for item in items:
        if item:
            return item
    return default


def compact_records(records: Sequence[Dict[str, Any]]) -> List[Dict[str, Any]]:
    compacted: List[Dict[str, Any]] = []
    for record in records:
        compacted.append({key: value for key, value in record.items() if value not in ("", [], {}, None)})
    return compacted


def sentence_contains_any(sentence: str, needles: Sequence[str]) -> bool:
    lowered = sentence.casefold()
    return any(needle.casefold() in lowered for needle in needles)


def to_thanglish(text: str, topic: str = "") -> str:
    cleaned = normalise_whitespace(text)
    if not cleaned:
        if topic:
            return f"Indha {topic} section pathi uploaded documents-la explicit-a information illa."
        return "Uploaded documents-la explicit-a information illa."

    replacements = [
        ("must", "must"),
        ("shall", "kandippa"),
        ("required", "required"),
        ("application", "application"),
        ("documents", "documents"),
        ("authority", "authority"),
        ("validation", "validation"),
        ("export", "export"),
        ("import", "import"),
        ("license", "license"),
        ("licence", "licence"),
    ]
    transformed = cleaned
    for source, target in replacements:
        transformed = re.sub(rf"\b{re.escape(source)}\b", target, transformed, flags=re.IGNORECASE)
    prefix = f"Indha {topic} section-la, " if topic else "Indha section-la, "
    return f"{prefix}{transformed}"


def ascii_vertical_flow(title: str, steps: Sequence[str]) -> str:
    clean_steps = [normalise_whitespace(step) for step in steps if normalise_whitespace(step)]
    if not clean_steps:
        clean_steps = ["No workflow extracted from uploaded documents"]

    lines = [title]
    for index, step in enumerate(clean_steps):
        if index > 0:
            lines.extend(["   |", "   v"])
        lines.append(step)
    return "\n".join(lines)
