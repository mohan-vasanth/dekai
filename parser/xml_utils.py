from __future__ import annotations

import re
from typing import Any, Iterable

from .utils import normalise_whitespace, unique_preserve

XML_NAMESPACES = ("ipt", "inp", "out", "tnp", "coo", "cac", "cbc", "ext", "sac", "udt", "qdt")
_XML_NAMESPACE_REGEX = "|".join(XML_NAMESPACES)
XML_NAMESPACE_PATTERN = re.compile(
    rf"^/?(?P<namespace>{_XML_NAMESPACE_REGEX}):(?P<body>[A-Za-z][A-Za-z0-9._-]*)$",
    flags=re.IGNORECASE,
)
XML_INLINE_NAMESPACE_PATTERN = re.compile(
    rf"/?(?:{_XML_NAMESPACE_REGEX}):[A-Za-z][A-Za-z0-9._-]*",
    flags=re.IGNORECASE,
)
XML_BARE_NAMESPACE_PATTERN = re.compile(
    rf"^(?P<namespace>{_XML_NAMESPACE_REGEX})\s+(?P<body>[A-Za-z][A-Za-z0-9._/-]*(?:\s+[A-Za-z][A-Za-z0-9._/-]*){0,5})$",
    flags=re.IGNORECASE,
)
XML_FIELD_HINT_WORDS = {
    "declarant",
    "header",
    "invoice",
    "code",
    "date",
    "declaration",
    "document",
    "equipment",
    "exporter",
    "identifier",
    "importer",
    "location",
    "mode",
    "name",
    "number",
    "party",
    "reference",
    "supporting",
    "transport",
    "type",
}
ROOT_SUFFIXES = ("identifier", "number", "code", "id")
FIELD_LINE_PATTERN = re.compile(
    r"^(?P<code>[A-Z]\d{2,4})\s+(?P<tag>(?:ipt|cac|cbc|ext):[A-Za-z][A-Za-z0-9._-]*(?:\s+[A-Za-z][A-Za-z0-9._/-]*){0,5})(?:\s+(?P<body>.*))?$",
    flags=re.IGNORECASE,
)
UPPER_SECTION_PATTERN = re.compile(r"^[A-Z][A-Z0-9/&()' _-]{2,80}(?:SECTION|DETAILS|HEADER|SUMMARY|PIPELINE|FUNCTION|DEFINITION|INVOICE)$")
SECTION_REQUEST_PATTERNS = (
    re.compile(r"^(?:explain|describe|summarize|summarise|tell me about|show me|what is)\s+(?:the\s+)?(?P<label>.+?)\s+section$", flags=re.IGNORECASE),
    re.compile(r"^(?:explain|describe|summarize|summarise|tell me about|show me|what is)\s+(?:the\s+)?(?P<label>declaration header|message details|message definition|message function|header section)$", flags=re.IGNORECASE),
)
QUERY_PREFIX_PATTERN = re.compile(
    r"^(?:explain|describe|summarize|summarise|tell me about|show me|show|define|describe|what is|what are)\s+",
    flags=re.IGNORECASE,
)


def split_camel_case(value: str) -> str:
    raw = str(value or "")
    raw = re.sub(r"([A-Z]+)([A-Z][a-z])", r"\1 \2", raw)
    raw = re.sub(r"([a-z0-9])([A-Z])", r"\1 \2", raw)
    return raw


def strip_xml_namespace(value: str) -> str:
    cleaned = normalise_whitespace(str(value or "").strip().lstrip("/"))
    if ":" not in cleaned:
        return cleaned
    return cleaned.split(":", 1)[1].strip()


def xml_namespace(value: str) -> str:
    cleaned = normalise_whitespace(str(value or "").strip())
    match = re.match(rf"^/?(?P<namespace>{_XML_NAMESPACE_REGEX}):", cleaned, flags=re.IGNORECASE)
    return match.group("namespace").lower() if match else ""


def normalize_xml_tag_name(value: str) -> str:
    base = split_camel_case(strip_xml_namespace(value))
    words = re.findall(r"[A-Za-z0-9]+", base)
    return "".join(word[:1].upper() + word[1:] for word in words if word)


def normalized_tag_key(value: str) -> str:
    return normalize_xml_tag_name(value).casefold()


def normalized_tag_root(value: str) -> str:
    normalized = normalized_tag_key(value)
    for suffix in ROOT_SUFFIXES:
        if normalized.endswith(suffix) and len(normalized) > len(suffix) + 2:
            return normalized[: -len(suffix)]
    return normalized


def normalized_search_words(value: str) -> str:
    base = split_camel_case(strip_xml_namespace(value))
    return " ".join(re.findall(r"[A-Za-z0-9]+", base)).casefold().strip()


def extract_query_namespace(value: str) -> str:
    return xml_namespace(_coerce_xml_query_candidate(value))


def normalize_query_field_reference(value: str) -> str:
    cleaned = _coerce_xml_query_candidate(value)
    if not cleaned:
        return ""
    namespace = xml_namespace(cleaned)
    normalized = normalize_xml_tag_name(cleaned)
    if namespace and normalized:
        return f"{namespace}:{normalized}"
    return normalized or normalise_whitespace(cleaned)


def _strip_query_prefix(value: str) -> str:
    cleaned = normalise_whitespace(str(value or "").strip().strip("'\""))
    if not cleaned:
        return ""
    stripped = QUERY_PREFIX_PATTERN.sub("", cleaned, count=1).strip()
    return stripped or cleaned


def _coerce_xml_query_candidate(value: str) -> str:
    cleaned = _strip_query_prefix(value).lstrip("/")
    match = XML_BARE_NAMESPACE_PATTERN.match(cleaned)
    if match:
        body = normalise_whitespace(match.group("body"))
        return f'{match.group("namespace").lower()}:{body}'
    return cleaned


def field_search_aliases(value: str) -> list[str]:
    cleaned = _coerce_xml_query_candidate(value)
    if not cleaned:
        return []
    namespace = xml_namespace(cleaned)
    normalized = normalize_xml_tag_name(cleaned)
    search_words = normalized_search_words(cleaned)
    compact = normalized.casefold()
    root = normalized_tag_root(cleaned)
    aliases = [
        cleaned,
        strip_xml_namespace(cleaned),
        normalized,
        search_words,
        compact,
        root,
    ]
    if namespace and normalized:
        aliases.append(f"{namespace}:{normalized}")
    return unique_preserve(alias for alias in aliases if alias)


def iter_query_field_aliases(value: str) -> list[str]:
    cleaned = _coerce_xml_query_candidate(value)
    if not cleaned:
        return []
    aliases = field_search_aliases(cleaned)
    if not aliases and cleaned:
        aliases = unique_preserve(
            [
                cleaned,
                normalize_xml_tag_name(cleaned),
                normalized_search_words(cleaned),
                normalized_tag_key(cleaned),
                normalized_tag_root(cleaned),
            ]
        )
    return aliases


def is_xml_field_query(value: str) -> bool:
    cleaned = _coerce_xml_query_candidate(value)
    if not cleaned:
        return False
    if XML_INLINE_NAMESPACE_PATTERN.search(cleaned):
        return True

    tokens = re.findall(r"[A-Za-z0-9]+", split_camel_case(cleaned))
    raw_tokens = re.findall(r"[A-Za-z0-9]+", cleaned)
    if len(raw_tokens) == 1:
        token = raw_tokens[0]
        if len(token) >= 6 and any(char.isupper() for char in token[1:]):
            return True
    if 1 <= len(tokens) <= 4 and any(token.casefold() in XML_FIELD_HINT_WORDS for token in tokens):
        return all(token[:1].isupper() or token.isupper() for token in tokens if token)
    return False


def hierarchy_search_aliases(value: str) -> list[str]:
    cleaned = normalise_whitespace(str(value or "").strip().strip("'\""))
    if not cleaned:
        return []
    aliases = [
        cleaned,
        split_camel_case(cleaned),
        re.sub(r"\bsection\b", "", split_camel_case(cleaned), flags=re.IGNORECASE).strip(),
        re.sub(r"\bheader\b", "", split_camel_case(cleaned), flags=re.IGNORECASE).strip(),
    ]
    if XML_INLINE_NAMESPACE_PATTERN.search(cleaned):
        aliases.extend(field_search_aliases(cleaned))
    normalized_aliases = []
    for alias in aliases:
        alias_clean = normalise_whitespace(alias)
        if not alias_clean:
            continue
        normalized_aliases.extend(
            [
                alias_clean,
                " ".join(re.findall(r"[A-Za-z0-9]+", split_camel_case(alias_clean))),
                "".join(re.findall(r"[A-Za-z0-9]+", split_camel_case(alias_clean))),
            ]
        )
    return unique_preserve(item for item in normalized_aliases if item)


def extract_section_request_target(value: str) -> str:
    cleaned = normalise_whitespace(str(value or "").strip().strip("'\""))
    if not cleaned:
        return ""
    for pattern in SECTION_REQUEST_PATTERNS:
        match = pattern.match(cleaned)
        if match:
            return normalise_whitespace(match.group("label"))
    return ""


def _clean_xml_token(token: str) -> str:
    return token.strip(" |,;:()[]{}").replace("\u00a0", " ")


def _is_xml_continuation_token(token: str) -> bool:
    cleaned = _clean_xml_token(token)
    if not cleaned:
        return False
    if re.match(r"^/?(?:ipt|cac|cbc|ext):", cleaned, flags=re.IGNORECASE):
        return False
    if re.match(r"^[AB]\d{2,4}$", cleaned):
        return False
    if re.match(r"^(?:M|C|R|S|N|AN|n\.\.?|an\.\.?|\d+|boolean)$", cleaned, flags=re.IGNORECASE):
        return False
    if cleaned.isupper() and len(cleaned) > 4:
        return False
    return bool(re.match(r"^[A-Za-z][A-Za-z0-9._/-]*$", cleaned))


def extract_xml_fields(
    text: Any,
    *,
    page_numbers: Iterable[int] | None = None,
    section_number: str = "",
    section_title: str = "",
    document_name: str = "",
) -> list[dict[str, Any]]:
    page_list = [int(page) for page in (page_numbers or []) if isinstance(page, int)]
    page_number = page_list[0] if page_list else 0
    fields: list[dict[str, Any]] = []
    seen: set[tuple[str, str, str]] = set()

    for raw_line in str(text or "").replace("\r\n", "\n").split("\n"):
        line = normalise_whitespace(raw_line)
        if not line:
            continue
        tokens = [_clean_xml_token(token) for token in line.split()]
        index = 0
        while index < len(tokens):
            token = tokens[index]
            match = XML_NAMESPACE_PATTERN.match(token)
            if not match:
                index += 1
                continue

            namespace = match.group("namespace").lower()
            tag_parts = [match.group("body")]
            cursor = index + 1
            while cursor < len(tokens) and len(tag_parts) < 6:
                next_token = tokens[cursor]
                if not _is_xml_continuation_token(next_token):
                    break
                tag_parts.append(next_token)
                cursor += 1

            tag_name = f'{namespace}:{normalise_whitespace(" ".join(tag_parts))}'
            normalized_tag_name = normalize_xml_tag_name(tag_name)
            if normalized_tag_name:
                key = (tag_name.casefold(), normalized_tag_name.casefold(), line.casefold())
                if key not in seen:
                    seen.add(key)
                    fields.append(
                        {
                            "tag_name": tag_name,
                            "normalized_tag_name": normalized_tag_name,
                            "namespace": namespace,
                            "section_number": section_number,
                            "section_title": section_title,
                            "page_number": page_number,
                            "document_name": document_name,
                            "content": line,
                            "search_aliases": field_search_aliases(tag_name),
                            "normalized_key": normalized_tag_key(tag_name),
                            "root_key": normalized_tag_root(tag_name),
                        }
                    )
            index = cursor if cursor > index else index + 1

    return fields


def _node_id(section_number: str, index: int, node_type: str, label: str) -> str:
    safe_label = re.sub(r"[^a-z0-9]+", "-", label.casefold()).strip("-")[:48] or node_type
    return f"{section_number or 'section'}::{node_type}::{index}::{safe_label}"


def _line_page_number(index: int, total_lines: int, page_numbers: list[int]) -> int:
    if not page_numbers:
        return 0
    if len(page_numbers) == 1 or total_lines <= 1:
        return page_numbers[0]
    bucket = min(len(page_numbers) - 1, int((index / max(1, total_lines)) * len(page_numbers)))
    return page_numbers[bucket]


def _looks_like_subsection_heading(line: str, section_title: str) -> bool:
    cleaned = normalise_whitespace(line).strip(" :|-")
    if not cleaned:
        return False
    if cleaned.casefold() == normalise_whitespace(section_title).casefold():
        return False
    if XML_INLINE_NAMESPACE_PATTERN.search(cleaned):
        return False
    if FIELD_LINE_PATTERN.match(cleaned):
        return False
    if len(cleaned) > 90:
        return False
    if UPPER_SECTION_PATTERN.match(cleaned):
        return True
    return bool(re.search(r"\bsection\b", cleaned, flags=re.IGNORECASE)) and sum(char.isalpha() for char in cleaned) >= 6


def _field_node_from_line(
    line: str,
    *,
    section_number: str,
    section_title: str,
    document_name: str,
    page_number: int,
    line_number: int,
    parent_id: str,
    index: int,
) -> dict[str, Any] | None:
    match = FIELD_LINE_PATTERN.match(line)
    if not match:
        return None
    tag_name = normalise_whitespace(match.group("tag"))
    label = normalize_xml_tag_name(tag_name) or tag_name
    description = normalise_whitespace(match.group("body") or line)
    return {
        "id": _node_id(section_number, index, "field", f"{match.group('code')} {label}"),
        "type": "field",
        "title": label,
        "tagName": tag_name,
        "normalizedTagName": normalize_xml_tag_name(tag_name),
        "namespace": xml_namespace(tag_name),
        "fieldCode": match.group("code"),
        "description": description,
        "content": line,
        "parentId": parent_id,
        "sectionId": section_number,
        "sectionTitle": section_title,
        "documentName": document_name,
        "pageNumber": page_number,
        "startLine": line_number,
        "endLine": line_number,
        "searchAliases": unique_preserve([*hierarchy_search_aliases(label), *field_search_aliases(tag_name), match.group("code")]),
        "childIds": [],
    }


def build_section_hierarchy(
    text: Any,
    *,
    page_numbers: Iterable[int] | None = None,
    section_number: str = "",
    section_title: str = "",
    document_name: str = "",
    notes: Iterable[str] | None = None,
    exceptions: Iterable[str] | None = None,
    business_rules: Iterable[dict[str, Any]] | None = None,
    validations: Iterable[str] | None = None,
    definitions: Iterable[dict[str, Any]] | None = None,
) -> list[dict[str, Any]]:
    lines = [normalise_whitespace(line) for line in str(text or "").replace("\r\n", "\n").split("\n") if normalise_whitespace(line)]
    pages = [int(page) for page in (page_numbers or []) if isinstance(page, int)]
    root_node = {
        "id": _node_id(section_number, 0, "section", section_title or section_number or "section"),
        "type": "section",
        "title": section_title or section_number or "Section",
        "tagName": "",
        "normalizedTagName": "",
        "namespace": "",
        "fieldCode": "",
        "description": "",
        "content": normalise_whitespace(str(text or "")),
        "parentId": "",
        "sectionId": section_number,
        "sectionTitle": section_title,
        "documentName": document_name,
        "pageNumber": pages[0] if pages else 0,
        "startLine": 0,
        "endLine": max(0, len(lines) - 1),
        "searchAliases": hierarchy_search_aliases(section_title or section_number or "Section"),
        "childIds": [],
    }
    nodes: list[dict[str, Any]] = [root_node]
    open_heading_index: int | None = None
    open_container_index: int | None = None

    def close_container(end_line: int) -> None:
        nonlocal open_container_index
        if open_container_index is not None and 0 <= open_container_index < len(nodes):
            nodes[open_container_index]["endLine"] = max(nodes[open_container_index]["startLine"], end_line)
            start = nodes[open_container_index]["startLine"]
            finish = nodes[open_container_index]["endLine"]
            nodes[open_container_index]["content"] = " ".join(lines[start : finish + 1]).strip()
        open_container_index = None

    def close_heading(end_line: int) -> None:
        nonlocal open_heading_index
        close_container(end_line)
        if open_heading_index is not None and 0 <= open_heading_index < len(nodes):
            nodes[open_heading_index]["endLine"] = max(nodes[open_heading_index]["startLine"], end_line)
            start = nodes[open_heading_index]["startLine"]
            finish = nodes[open_heading_index]["endLine"]
            nodes[open_heading_index]["content"] = " ".join(lines[start : finish + 1]).strip()
        open_heading_index = None

    for line_number, line in enumerate(lines):
        page_number = _line_page_number(line_number, len(lines), pages)
        if _looks_like_subsection_heading(line, section_title):
            close_heading(line_number - 1)
            node = {
                "id": _node_id(section_number, len(nodes), "subsection", line),
                "type": "subsection",
                "title": line,
                "tagName": "",
                "normalizedTagName": "",
                "namespace": "",
                "fieldCode": "",
                "description": "",
                "content": "",
                "parentId": root_node["id"],
                "sectionId": section_number,
                "sectionTitle": section_title,
                "documentName": document_name,
                "pageNumber": page_number,
                "startLine": line_number,
                "endLine": line_number,
                "searchAliases": hierarchy_search_aliases(line),
                "childIds": [],
            }
            root_node["childIds"].append(node["id"])
            nodes.append(node)
            open_heading_index = len(nodes) - 1
            continue

        xml_fields = extract_xml_fields(
            line,
            page_numbers=[page_number] if page_number else [],
            section_number=section_number,
            section_title=section_title,
            document_name=document_name,
        )
        first_xml_field = xml_fields[0] if xml_fields else {}
        if xml_fields and not FIELD_LINE_PATTERN.match(line):
            close_container(line_number - 1)
            parent_id = nodes[open_heading_index]["id"] if open_heading_index is not None else root_node["id"]
            node_title = str(first_xml_field.get("tag_name", "")) or line
            node = {
                "id": _node_id(section_number, len(nodes), "xml_container", node_title),
                "type": "xml_container",
                "title": node_title,
                "tagName": str(first_xml_field.get("tag_name", "")),
                "normalizedTagName": str(first_xml_field.get("normalized_tag_name", "")),
                "namespace": str(first_xml_field.get("namespace", "")),
                "fieldCode": "",
                "description": "",
                "content": "",
                "parentId": parent_id,
                "sectionId": section_number,
                "sectionTitle": section_title,
                "documentName": document_name,
                "pageNumber": page_number,
                "startLine": line_number,
                "endLine": line_number,
                "searchAliases": unique_preserve([*hierarchy_search_aliases(node_title), *field_search_aliases(node_title)]),
                "childIds": [],
            }
            for candidate in nodes:
                if candidate["id"] == parent_id:
                    candidate["childIds"].append(node["id"])
                    break
            nodes.append(node)
            open_container_index = len(nodes) - 1

        parent_id = (
            nodes[open_container_index]["id"]
            if open_container_index is not None
            else nodes[open_heading_index]["id"]
            if open_heading_index is not None
            else root_node["id"]
        )
        field_node = _field_node_from_line(
            line,
            section_number=section_number,
            section_title=section_title,
            document_name=document_name,
            page_number=page_number,
            line_number=line_number,
            parent_id=parent_id,
            index=len(nodes),
        )
        if field_node:
            for candidate in nodes:
                if candidate["id"] == parent_id:
                    candidate["childIds"].append(field_node["id"])
                    break
            nodes.append(field_node)

    close_heading(len(lines) - 1)

    parent_lookup = {node["id"]: node for node in nodes}

    def append_supplemental(node_type: str, title: str, content: str) -> None:
        if not normalise_whitespace(content):
            return
        node = {
            "id": _node_id(section_number, len(nodes), node_type, title),
            "type": node_type,
            "title": title,
            "tagName": "",
            "normalizedTagName": "",
            "namespace": "",
            "fieldCode": "",
            "description": "",
            "content": normalise_whitespace(content),
            "parentId": root_node["id"],
            "sectionId": section_number,
            "sectionTitle": section_title,
            "documentName": document_name,
            "pageNumber": pages[0] if pages else 0,
            "startLine": 0,
            "endLine": 0,
            "searchAliases": hierarchy_search_aliases(title),
            "childIds": [],
        }
        root_node["childIds"].append(node["id"])
        nodes.append(node)

    for note in unique_preserve(notes or []):
        append_supplemental("note", "Notes", str(note))
    for exception in unique_preserve(exceptions or []):
        append_supplemental("exception", "Exceptions", str(exception))
    for validation in unique_preserve(validations or []):
        append_supplemental("validation", "Validation Rules", str(validation))
    for definition in definitions or []:
        if not isinstance(definition, dict):
            continue
        term = normalise_whitespace(str(definition.get("term", "")))
        definition_text = normalise_whitespace(str(definition.get("definition", "")))
        append_supplemental("definition", term or "Field Definition", f"{term}: {definition_text}".strip(": "))
    for rule in business_rules or []:
        if not isinstance(rule, dict):
            continue
        append_supplemental(
            "business_rule",
            normalise_whitespace(str(rule.get("name") or rule.get("trigger") or "Business Rule")),
            normalise_whitespace(str(rule.get("description") or rule.get("rule_description") or rule.get("output") or "")),
        )

    for node in nodes:
        parent = parent_lookup.get(node.get("parentId", ""))
        node["depth"] = 0 if not parent else int(parent.get("depth", 0)) + 1
        node["boundaryStartLine"] = node.get("startLine", 0)
        node["boundaryEndLine"] = node.get("endLine", 0)

    return nodes
