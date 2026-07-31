CREATE TABLE IF NOT EXISTS sections (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    source_document TEXT NOT NULL,
    chapter_number TEXT NOT NULL,
    chapter_title TEXT NOT NULL,
    section_code TEXT NOT NULL,
    title TEXT NOT NULL,
    purpose TEXT,
    purpose_thanglish TEXT,
    summary TEXT,
    business_meaning TEXT,
    business_explanation TEXT,
    business_explanation_thanglish TEXT,
    raw_text TEXT,
    pages TEXT,
    keywords TEXT,
    intent TEXT,
    tags TEXT
);

CREATE TABLE IF NOT EXISTS rules (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    rule_id TEXT NOT NULL,
    section_code TEXT NOT NULL,
    rule_text TEXT NOT NULL,
    rule_type TEXT NOT NULL,
    trigger_text TEXT,
    condition_text TEXT,
    validation_text TEXT,
    action_text TEXT,
    exception_text TEXT,
    output_text TEXT
);

CREATE TABLE IF NOT EXISTS conditions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    section_code TEXT NOT NULL,
    condition_text TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS documents (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    section_code TEXT NOT NULL,
    document_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS authorities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    section_code TEXT NOT NULL,
    authority_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS timelines (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    section_code TEXT NOT NULL,
    timeline_text TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS workflows (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    section_code TEXT NOT NULL,
    step_index INTEGER NOT NULL,
    step_text TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS exceptions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    section_code TEXT NOT NULL,
    exception_text TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS glossary (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    term TEXT NOT NULL,
    definition TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS entities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    section_code TEXT NOT NULL,
    entity_type TEXT NOT NULL,
    entity_value TEXT NOT NULL
);
