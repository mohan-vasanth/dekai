# dekai-dgft-parser

`dekai-dgft-parser` is a DGFT PDF knowledge extraction system for the DEKAI AI Customs Platform. It is designed to analyze every PDF page and convert policy text into structured business knowledge rather than plain text dumps.

## What It Produces

For each detected section, the pipeline extracts and generates:

- Section number and title
- Purpose, summary, business meaning, and business logic
- Conditions, validations, exceptions, dependencies, authorities, and required documents
- Timelines, actions, workflows, and decision trees
- Examples, AI rules, database fields, API requirements, UI requirements, error messages, and likely user questions
- Mermaid and PlantUML workflow artifacts
- Semantic chunks with vector-ready metadata
- Searchable JSON, glossary data, entity catalogs, SQL schema and seed data, and document-level reports

## Folder Layout

```text
dekai-dgft-parser/
├── input/
│   ├── pdf/
│   └── processed/
├── output/
│   ├── markdown/
│   ├── json/
│   ├── chunks/
│   ├── embeddings/
│   ├── rules/
│   ├── workflows/
│   ├── glossary/
│   ├── entities/
│   ├── validations/
│   ├── timelines/
│   ├── conditions/
│   ├── exceptions/
│   ├── authorities/
│   ├── decision_trees/
│   ├── api_design/
│   ├── ui_design/
│   ├── sql/
│   └── reports/
├── parser/
├── config.py
├── requirements.txt
├── run.py
└── README.md
```

## Installation

```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

## Environment Configuration

Create a local environment file or export these variables before running the API:

```bash
OPENAI_API_KEY=
ANTHROPIC_API_KEY=
GOOGLE_API_KEY=
OLLAMA_BASE_URL=http://localhost:11434
```

Optional model overrides:

```bash
DEKAI_OPENAI_MODEL=gpt-4.1
DEKAI_ANTHROPIC_MODEL=claude-sonnet-5
DEKAI_GEMINI_MODEL=gemini-2.5-pro
DEKAI_OLLAMA_LLAMA_MODEL=llama3.2
DEKAI_OLLAMA_QWEN_MODEL=qwen2.5
```

## Usage

1. Place DGFT PDF files into `input/pdf/`.
2. Run the pipeline:

```bash
python run.py
```

3. Review extracted knowledge in `output/`.
4. Processed PDFs are moved to `input/processed/` with a timestamped filename.

## Extraction Strategy

- `pdfplumber` captures page text and table structures.
- `PyMuPDF` captures page blocks and fallback text.
- `TextCleaner` removes repeated lines, normalizes whitespace, and preserves page-level context.
- `RuleExtractor` detects sections dynamically and infers business logic from modal, eligibility, and action language.
- Specialized extractors derive conditions, validations, timelines, authorities, exceptions, glossary terms, dependencies, workflows, and decision trees.
- `Chunker` produces 500-800 word vector-ready semantic chunks with 100-word overlap.
- SQL, API, UI, report, and metadata generators materialize downstream integration artifacts.

## Output Examples

- Markdown section file: `output/markdown/2.14_Modification_of_IEC.md`
- Searchable JSON section file: `output/json/2.14_Modification_of_IEC.json`
- Chunks: `output/chunks/2.14_Modification_of_IEC.json`
- Embedding payloads: `output/embeddings/2.14_Modification_of_IEC.json`
- SQL schema: `output/sql/schema.sql`
- Report: `output/reports/<pdf-name>_report.json`

## JSON Contract

```json
{
  "section": "2.14",
  "title": "Modification of IEC",
  "purpose": "",
  "summary": "",
  "business_rules": [],
  "conditions": [],
  "actions": [],
  "validations": [],
  "exceptions": [],
  "dependencies": [],
  "documents": [],
  "authorities": [],
  "timelines": [],
  "workflow": [],
  "decision_tree": [],
  "database_fields": [],
  "apis": [],
  "ui": [],
  "examples": []
}
```

## Logging And Error Handling

- Pipeline logs are written to `output/reports/pipeline.log`.
- Each PDF is processed inside an exception boundary so one failing file does not stop the batch.
- Empty-run reports are generated when no PDF is available yet.

## Notes

- The extractor is dynamic and heuristic-driven. It does not hardcode section-specific DGFT rules.
- Sample output files are included in `output/` to show expected artifact shape before a live PDF is added.
"# dekai" 
"# dekai" 
