from __future__ import annotations

import asyncio
import logging
from collections import defaultdict
from datetime import datetime
from pathlib import Path
from typing import Any
from urllib.parse import quote

from fastapi import Depends, FastAPI, File, HTTPException, UploadFile, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse, StreamingResponse
from pydantic import BaseModel

from config import CONFIG
from services.auth_service import AuthUser, auth_service
from services.chat_service import chat_service
from services.data_service import data_service
from services.document_version_service import document_version_service
from services.knowledge_engine import knowledge_engine_service
from services.pipeline_service import PipelineBusyError, pipeline_service
from services.pdf_markdown_service import pdf_markdown_service
from services.search_service import search_service
from services.settings_service import settings_service
from .deps import get_admin_user, get_current_user


class LoginRequest(BaseModel):
    email: str
    password: str


class ChatRequest(BaseModel):
    question: str
    aiModel: str | None = None
    language: str | None = None
    currentDocumentName: str | None = None
    conversationId: str | None = None


class SettingsPatch(BaseModel):
    theme: str | None = None
    language: str | None = None
    aiModel: str | None = None
    knowledgeStatus: str | None = None
    version: str | None = None
    about: str | None = None


app = FastAPI(title="DEKAI AI API", version="2026.07")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
logger = logging.getLogger(__name__)


def _job_error(exc: PipelineBusyError) -> HTTPException:
    return HTTPException(status_code=status.HTTP_409_CONFLICT, detail=str(exc))


def _friendly_failure_reason(value: Any) -> str:
    message = " ".join(str(value or "").strip().split()).casefold()
    if not message:
        return "Unexpected Server Error"
    if any(token in message for token in ("document_versions.json", "jobs.json", "settings.json", "users.json", "replace(", "access is denied", "permission denied", "winerror 5")):
        return "Database Save Failed"
    if any(token in message for token in ("password", "encrypted", "decrypt")):
        return "Password Protected PDF"
    if any(token in message for token in ("ocr", "tesseract", "image-only", "image only")):
        return "OCR Failed"
    if any(token in message for token in ("markdown", "html conversion", "conversion failed")):
        return "Markdown Conversion Failed"
    if any(token in message for token in ("embedding", "vector", "similarity")):
        return "Embedding Generation Failed"
    if any(token in message for token in ("index", "knowledge base", "search record", "search index")):
        return "Knowledge Base Indexing Failed"
    if any(token in message for token in ("invalid pdf", "malformed pdf", "corrupt", "cannot open", "failed to read", "pdf syntax", "eof")):
        return "Invalid PDF"
    if "interrupted" in message:
        return "Processing Interrupted"
    return "Unexpected Server Error"


def _find_document_name(document_id: str) -> str:
    state = data_service.get_app_state()
    match = next((document for document in state["documents"] if document["id"] == document_id), None)
    if match:
        return str(match["name"])
    history_match = next((item for item in document_version_service.list_documents() if item.get("currentDocumentId") == document_id and not item.get("archived")), None)
    if history_match:
        return str(history_match["currentName"])
    raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Document not found.")


def _find_document_versions(document_id: str) -> list[dict[str, Any]]:
    state = data_service.get_app_state()
    document = next((item for item in state["documents"] if item["id"] == document_id), None)
    lineage_id = document.get("lineageId") if document else None
    if not lineage_id:
        history = next((item for item in document_version_service.list_documents() if item.get("currentDocumentId") == document_id), None)
        if history:
            return history.get("versions", [])
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Document not found.")
    history = next((item for item in document_version_service.list_documents() if item.get("lineageId") == lineage_id), None)
    return history.get("versions", []) if history else []


def _find_document_path(document_id: str) -> tuple[str, Path]:
    document_name = _find_document_name(document_id)
    document_path = CONFIG.input_pdf_dir / Path(document_name).name
    if not document_path.exists():
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="File is unavailable.")
    return document_name, document_path


def _document_summary(document: dict[str, Any], job: dict[str, Any] | None = None) -> dict[str, Any]:
    next_document = dict(document)
    if job:
        next_document["status"] = job.get("status", next_document.get("status", "processing"))
        next_document["progress"] = int(job.get("progress", next_document.get("progress", 0)) or 0)
        next_document["stages"] = job.get("stages", next_document.get("stages", []))
        if job.get("error"):
            next_document["summary"] = str(job["error"])
    return next_document


def _parse_timestamp(value: Any) -> datetime | None:
    text = str(value or "").strip()
    if not text:
        return None
    normalized = text[:-1] + "+00:00" if text.endswith("Z") else text
    try:
        return datetime.fromisoformat(normalized)
    except ValueError:
        return None


def _timestamp_text(value: Any) -> str | None:
    timestamp = _parse_timestamp(value)
    return timestamp.isoformat().replace("+00:00", "Z") if timestamp else None


def _latest_timestamp_text(*values: Any) -> str | None:
    timestamps = [timestamp for timestamp in (_parse_timestamp(value) for value in values) if timestamp]
    if not timestamps:
        return None
    return max(timestamps).isoformat().replace("+00:00", "Z")


def _document_stage_fallback(status_value: str) -> list[dict[str, str]]:
    return [
        {"label": "Validate PDF", "state": "complete"},
        {"label": "Extract Text", "state": "current" if status_value == "processing" else "complete"},
        {"label": "Convert to Markdown", "state": "upcoming" if status_value == "processing" else "complete"},
        {"label": "Identify Sections", "state": "upcoming" if status_value == "processing" else "complete"},
        {"label": "Generate Chunks", "state": "upcoming" if status_value == "processing" else "complete"},
        {"label": "Create Embeddings", "state": "upcoming" if status_value == "processing" else "complete"},
        {"label": "Index into Knowledge Base", "state": "upcoming" if status_value == "processing" else "complete"},
        {"label": "Ready", "state": "upcoming" if status_value == "processing" else "complete"},
    ]


def _knowledge_status(status_value: str, *, search_records: int, vector_records: int) -> str:
    if status_value == "failed":
        return "action-required"
    if status_value == "ready" and search_records > 0 and vector_records > 0:
        return "knowledge-ready"
    return "processing"


def _document_detail_stats(index: dict[str, Any]) -> dict[str, dict[str, int]]:
    stats_by_document: dict[str, dict[str, int]] = defaultdict(
        lambda: {
            "sectionsIndexed": 0,
            "totalChunks": 0,
            "totalEmbeddings": 0,
            "businessRulesExtracted": 0,
            "conditionsExtracted": 0,
            "metadataGenerated": 0,
            "vectorRecordsStored": 0,
            "knowledgeSizeKb": 0,
            "searchRecords": 0,
            "validationsExtracted": 0,
        }
    )

    for section in index.get("sections", []):
        document_name = str(section.get("documentName", "")).strip()
        if not document_name:
            continue
        stats = stats_by_document[document_name]
        stats["sectionsIndexed"] += 1
        stats["validationsExtracted"] += len([item for item in section.get("validations", []) if isinstance(item, str)])

    for chunk in index.get("chunks", []):
        document_name = str(chunk.get("documentName", "")).strip()
        if not document_name:
            continue
        stats = stats_by_document[document_name]
        stats["totalChunks"] += 1
        chunk_text = str(chunk.get("text", ""))
        if chunk_text:
            stats["knowledgeSizeKb"] += max(1, round(len(chunk_text.encode("utf-8")) / 1024))

    for rule in index.get("rules", []):
        document_name = str(rule.get("documentName", "")).strip()
        if document_name:
            stats_by_document[document_name]["businessRulesExtracted"] += 1

    for condition in index.get("conditions", []):
        document_name = str(condition.get("documentName", "")).strip()
        if document_name:
            stats_by_document[document_name]["conditionsExtracted"] += 1

    for search_record in index.get("searchRecords", []):
        document_name = str(search_record.get("documentName", "")).strip()
        if document_name:
            stats_by_document[document_name]["searchRecords"] += 1

    metadata_collections = ("definitions", "exceptions", "authorities", "workflows")
    for collection_name in metadata_collections:
        for item in index.get(collection_name, []):
            document_name = str(item.get("documentName", "")).strip()
            if document_name:
                stats_by_document[document_name]["metadataGenerated"] += 1

    for document_name, stats in stats_by_document.items():
        stats["metadataGenerated"] += (
            stats["sectionsIndexed"]
            + stats["businessRulesExtracted"]
            + stats["conditionsExtracted"]
            + stats["validationsExtracted"]
        )
        stats["vectorRecordsStored"] = stats["totalChunks"] + stats["searchRecords"]
        stats["totalEmbeddings"] = stats["vectorRecordsStored"]

    return dict(stats_by_document)


def _augment_document(
    document: dict[str, Any],
    *,
    detail_stats: dict[str, dict[str, int]],
    latest_job: dict[str, Any] | None,
    index_generated_at: str | None,
    knowledge_scope: str,
) -> dict[str, Any]:
    next_document = dict(document)
    document_name = str(document.get("name", "")).strip()
    status_value = str(next_document.get("status", "processing"))
    stats = detail_stats.get(document_name, {})
    search_records = int(stats.get("searchRecords", 0) or 0)
    vector_records = int(stats.get("vectorRecordsStored", 0) or 0)
    knowledge_size_kb = int(stats.get("knowledgeSizeKb", 0) or 0)
    source_size_kb = int(next_document.get("sizeKb", 0) or 0)
    failure_detail = " ".join(str(next_document.get("summary", "") or "").split()).strip() if status_value == "failed" else ""
    is_searchable = status_value == "ready" and search_records > 0 and vector_records > 0

    next_document.update(
        {
            "documentType": "PDF Knowledge Source",
            "knowledgeScope": knowledge_scope,
            "knowledgeStatus": _knowledge_status(status_value, search_records=search_records, vector_records=vector_records),
            "sectionsIndexed": int(stats.get("sectionsIndexed", next_document.get("sections", 0)) or 0),
            "totalChunks": int(stats.get("totalChunks", 0) or 0),
            "totalEmbeddings": int(stats.get("totalEmbeddings", 0) or 0),
            "businessRulesExtracted": int(stats.get("businessRulesExtracted", next_document.get("rules", 0)) or 0),
            "conditionsExtracted": int(stats.get("conditionsExtracted", next_document.get("conditions", 0)) or 0),
            "metadataGenerated": int(stats.get("metadataGenerated", 0) or 0),
            "vectorRecordsStored": vector_records,
            "knowledgeSizeKb": max(source_size_kb, knowledge_size_kb),
            "validations": int(stats.get("validationsExtracted", 0) or 0),
            "searchIndexStatus": "failed" if status_value == "failed" else "indexed" if status_value == "ready" and search_records > 0 else "updating",
            "vectorDatabaseStatus": "failed" if status_value == "failed" else "stored" if status_value == "ready" and vector_records > 0 else "updating",
            "lastIndexedAt": _latest_timestamp_text(
                (latest_job or {}).get("updatedAt"),
                next_document.get("lastUpdated"),
                index_generated_at,
            ),
            "failureReason": _friendly_failure_reason(failure_detail) if failure_detail else None,
            "failureDetail": failure_detail or None,
            "searchable": is_searchable,
        }
    )
    return next_document


def _documents_payload() -> dict[str, Any]:
    index = knowledge_engine_service.load_index()
    stats = index.get("statistics", {})
    jobs = pipeline_service.list_jobs()
    version_history = document_version_service.list_documents()
    latest_jobs_by_document_name: dict[str, dict[str, Any]] = {}
    processing_jobs_by_document_name: dict[str, dict[str, Any]] = {}
    for job in jobs:
        document_name = str(job.get("documentName", "")).strip()
        if not document_name or "documents" in document_name.casefold():
            continue
        current = latest_jobs_by_document_name.get(document_name)
        if current is None:
            latest_jobs_by_document_name[document_name] = job
        else:
            current_timestamp = _parse_timestamp(current.get("updatedAt"))
            job_timestamp = _parse_timestamp(job.get("updatedAt"))
            if current_timestamp is None or (job_timestamp and job_timestamp >= current_timestamp):
                latest_jobs_by_document_name[document_name] = job
        if job.get("status") == "processing":
            processing_jobs_by_document_name[document_name] = job

    detail_stats = _document_detail_stats(index)
    documents = []
    known_ids: set[str] = set()

    for document in index.get("documents", []):
        job = processing_jobs_by_document_name.get(str(document.get("name", "")))
        summarized = _document_summary(document, job) if job else dict(document)
        documents.append(summarized)
        known_ids.add(str(summarized["id"]))

    for entry in version_history:
        if entry.get("archived"):
            continue
        document_id = str(entry.get("currentDocumentId", "")).strip()
        document_name = str(entry.get("currentName", "")).strip()
        if not document_id or not document_name or document_id in known_ids:
            continue
        versions = entry.get("versions", [])
        latest_version = versions[-1] if versions else {}
        metadata = latest_version.get("metadata", {}) if isinstance(latest_version, dict) else {}
        job = processing_jobs_by_document_name.get(document_name)
        latest_version_updated_at = _parse_timestamp((latest_version or {}).get("createdAt"))
        job_updated_at = _parse_timestamp((job or {}).get("updatedAt"))
        use_job = bool(job and (latest_version_updated_at is None or (job_updated_at and job_updated_at >= latest_version_updated_at)))
        status_value = str(((job if use_job else None) or latest_version).get("status", "processing"))
        documents.append(
            _document_summary(
                {
                    "id": document_id,
                    "lineageId": entry.get("lineageId"),
                    "name": document_name,
                    "version": latest_version.get("label", f'v{len(versions) or 1}'),
                    "versionCount": len(versions) or 1,
                    "pages": int(metadata.get("pages", 0) or 0),
                    "sections": int(metadata.get("sections", 0) or 0),
                    "rules": int(metadata.get("rules", 0) or 0),
                    "conditions": int(metadata.get("conditions", 0) or 0),
                    "exceptions": int(metadata.get("exceptions", 0) or 0),
                    "authorities": int(metadata.get("authorities", 0) or 0),
                    "workflows": int(metadata.get("workflows", 0) or 0),
                    "glossaryTerms": int(metadata.get("glossaryTerms", 0) or 0),
                    "chapterCount": 1,
                    "chapterTitle": str(metadata.get("chapterTitle", "DGFT Knowledge Source")),
                    "uploadedAt": latest_version.get("createdAt", entry.get("createdAt")),
                    "lastUpdated": entry.get("updatedAt", latest_version.get("createdAt", entry.get("createdAt"))),
                    "sizeKb": 0,
                    "status": status_value,
                    "progress": int(((job if use_job else {}) or {}).get("progress", 100 if status_value != "processing" else 5) or 0),
                    "summary": str(latest_version.get("error", "") or metadata.get("error", "") or f"{document_name} is being processed."),
                    "stages": ((job if use_job else {}) or {}).get("stages", _document_stage_fallback(status_value)),
                },
                job if use_job else None,
            )
        )

    documents.sort(key=lambda item: str(item.get("name", "")).casefold())
    knowledge_scope = "shared-knowledge-base" if len(documents) > 1 else "single-document-index"
    documents = [
        _augment_document(
            document,
            detail_stats=detail_stats,
            latest_job=latest_jobs_by_document_name.get(str(document.get("name", ""))),
            index_generated_at=index.get("generatedAt"),
            knowledge_scope=knowledge_scope,
        )
        for document in documents
    ]

    ready_documents = [document for document in documents if document.get("knowledgeStatus") == "knowledge-ready"]
    failed_documents = [document for document in documents if document.get("status") == "failed"]
    processing_documents = [document for document in documents if document.get("status") == "processing"]
    knowledge_stats = {
        "scope": knowledge_scope,
        "documentsInKnowledgeBase": len(documents),
        "knowledgeReadyDocuments": len(ready_documents),
        "pagesProcessed": sum(int(document.get("pages", 0) or 0) for document in documents),
        "chunksCreated": sum(int(document.get("totalChunks", 0) or 0) for document in documents),
        "sectionsIndexed": sum(int(document.get("sectionsIndexed", 0) or 0) for document in documents),
        "businessRulesExtracted": sum(int(document.get("businessRulesExtracted", 0) or 0) for document in documents),
        "conditionsExtracted": sum(int(document.get("conditionsExtracted", 0) or 0) for document in documents),
        "metadataObjects": sum(int(document.get("metadataGenerated", 0) or 0) for document in documents),
        "embeddingsCreated": sum(int(document.get("totalEmbeddings", 0) or 0) for document in documents),
        "vectorRecordsStored": sum(int(document.get("vectorRecordsStored", 0) or 0) for document in documents),
        "knowledgeSizeKb": sum(int(document.get("knowledgeSizeKb", 0) or 0) for document in documents),
        "searchIndexStatus": (
            "updating"
            if processing_documents
            else "attention-required"
            if failed_documents
            else "indexed"
            if ready_documents and len(ready_documents) == len(documents)
            else "idle"
        ),
        "knowledgeReady": bool(documents) and len(ready_documents) == len(documents),
        "lastIndexedAt": _latest_timestamp_text(
            *[document.get("lastIndexedAt") for document in documents],
            index.get("generatedAt"),
        ),
    }
    return {
        "documents": documents,
        "metrics": {
            "totalPdfs": int(stats.get("documents", 0)),
            "totalPages": int(stats.get("pages", 0)),
            "totalSections": int(stats.get("sections", 0)),
            "totalRules": int(stats.get("businessRules", 0)),
            "totalWorkflows": int(stats.get("workflows", 0)),
            "totalConditions": int(stats.get("conditions", 0)),
            "totalExceptions": int(stats.get("exceptions", 0)),
            "totalAuthorities": int(stats.get("authorities", 0)),
            "totalGlossaryTerms": int(stats.get("definitions", 0)),
        },
        "knowledgeStats": knowledge_stats,
        "jobs": jobs,
    }


def _document_search_values(value: Any) -> list[str]:
    if value is None:
        return []
    if isinstance(value, str):
        normalized = " ".join(value.split()).strip()
        return [normalized] if normalized else []
    if isinstance(value, (int, float, bool)):
        return [str(value)]
    if isinstance(value, dict):
        values: list[str] = []
        for nested_value in value.values():
            values.extend(_document_search_values(nested_value))
        return values
    if isinstance(value, list):
        values: list[str] = []
        for nested_value in value:
            values.extend(_document_search_values(nested_value))
        return values
    return []


def _document_search_surface(document: dict[str, Any]) -> str:
    scope = str(document.get("knowledgeScope", "")).strip()
    scope_labels = {
        "single-document-index": "single document index",
        "shared-knowledge-base": "shared knowledge base",
    }
    searchable_payload = {
        "name": document.get("name"),
        "version": document.get("version"),
        "description": document.get("summary"),
        "chapterTitle": document.get("chapterTitle"),
        "documentType": document.get("documentType"),
        "knowledgeScope": scope,
        "knowledgeScopeLabel": scope_labels.get(scope, ""),
        "knowledgeStatus": document.get("knowledgeStatus"),
        "status": document.get("status"),
        "failureReason": document.get("failureReason"),
        "failureDetail": document.get("failureDetail"),
        "metadata": {
            "sectionsIndexed": document.get("sectionsIndexed"),
            "totalChunks": document.get("totalChunks"),
            "totalEmbeddings": document.get("totalEmbeddings"),
            "businessRulesExtracted": document.get("businessRulesExtracted"),
            "conditionsExtracted": document.get("conditionsExtracted"),
            "metadataGenerated": document.get("metadataGenerated"),
            "vectorRecordsStored": document.get("vectorRecordsStored"),
            "searchIndexStatus": document.get("searchIndexStatus"),
            "vectorDatabaseStatus": document.get("vectorDatabaseStatus"),
            "stages": document.get("stages"),
        },
    }
    return " ".join(_document_search_values(searchable_payload)).casefold()


def _matches_document_query(document: dict[str, Any], query: str) -> bool:
    normalized_query = " ".join(str(query or "").split()).casefold()
    if not normalized_query:
        return True
    surface = _document_search_surface(document)
    if normalized_query in surface:
        return True
    tokens = [token for token in normalized_query.split(" ") if token]
    return bool(tokens) and all(token in surface for token in tokens)


def _document_index_debug_payload(document_name: str) -> dict[str, Any]:
    snapshot = knowledge_engine_service.document_index_snapshot(document_name)
    return {
        "document": snapshot,
        "versionHistory": document_version_service.get_lineage(document_name),
    }


@app.get("/api/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/api/auth/login")
def login(payload: LoginRequest) -> dict[str, Any]:
    user = auth_service.authenticate(payload.email, payload.password)
    if not user:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid email or password.")
    return {
        "token": auth_service.issue_token(user),
        "user": {"email": user.email, "name": user.name, "role": user.role},
    }


@app.get("/api/auth/me")
def me(user: AuthUser = Depends(get_current_user)) -> dict[str, Any]:
    return {"user": {"email": user.email, "name": user.name, "role": user.role}}


@app.get("/api/overview")
def overview(user: AuthUser = Depends(get_current_user)) -> dict[str, Any]:
    return data_service.get_overview()


@app.get("/api/documents")
def documents(user: AuthUser = Depends(get_admin_user)) -> dict[str, Any]:
    return _documents_payload()


@app.get("/api/documents/search")
def search_documents(q: str = "", user: AuthUser = Depends(get_admin_user)) -> dict[str, Any]:
    payload = _documents_payload()
    documents = payload.get("documents", [])
    matching_documents = [document for document in documents if isinstance(document, dict) and _matches_document_query(document, q)]
    return {"documents": matching_documents}


@app.get("/api/documents/{document_id}/file")
def document_file(document_id: str, user: AuthUser = Depends(get_admin_user)) -> FileResponse:
    document_name, document_path = _find_document_path(document_id)
    return FileResponse(
        document_path,
        media_type="application/pdf",
        filename=document_name,
        content_disposition_type="inline",
    )


@app.get("/api/documents/jobs/{job_id}")
def document_job(job_id: str, user: AuthUser = Depends(get_admin_user)) -> dict[str, Any]:
    job = pipeline_service.get_job(job_id)
    if not job:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Job not found.")
    return {"job": job}


@app.post("/api/documents/upload")
async def upload_document(file: UploadFile = File(...), user: AuthUser = Depends(get_admin_user)) -> dict[str, Any]:
    try:
        job = pipeline_service.upload_document(file.filename, await file.read())
    except PipelineBusyError as exc:
        raise _job_error(exc) from exc
    return {"job": job}


@app.post("/api/documents/upload-batch")
async def upload_documents(files: list[UploadFile] = File(...), user: AuthUser = Depends(get_admin_user)) -> dict[str, Any]:
    try:
        payload = [(file.filename, await file.read()) for file in files]
        job = pipeline_service.upload_documents(payload)
    except PipelineBusyError as exc:
        raise _job_error(exc) from exc
    return {"job": job}


@app.post("/api/documents/{document_id}/replace")
async def replace_document(document_id: str, file: UploadFile = File(...), user: AuthUser = Depends(get_admin_user)) -> dict[str, Any]:
    current_name = _find_document_name(document_id)
    try:
        job = pipeline_service.replace_document(current_name, file.filename, await file.read())
    except PipelineBusyError as exc:
        raise _job_error(exc) from exc
    return {"job": job}


@app.delete("/api/documents/{document_id}")
def delete_document(document_id: str, user: AuthUser = Depends(get_admin_user)) -> dict[str, Any]:
    current_name = _find_document_name(document_id)
    try:
        job = pipeline_service.delete_document(current_name)
    except PipelineBusyError as exc:
        raise _job_error(exc) from exc
    return {"job": job}


@app.post("/api/documents/{document_id}/reindex")
def reindex_document(document_id: str, user: AuthUser = Depends(get_admin_user)) -> dict[str, Any]:
    current_name = _find_document_name(document_id)
    try:
        job = pipeline_service.reindex_document(current_name)
    except FileNotFoundError as exc:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Document file not found.") from exc
    except PipelineBusyError as exc:
        raise _job_error(exc) from exc
    return {"job": job}


@app.get("/api/documents/{document_id}/versions")
def document_versions(document_id: str, user: AuthUser = Depends(get_admin_user)) -> dict[str, Any]:
    return {"versions": _find_document_versions(document_id)}


@app.post("/api/pdf-to-markdown/convert")
async def convert_pdf_to_markdown(file: UploadFile = File(...), user: AuthUser = Depends(get_current_user)) -> dict[str, Any]:
    if not str(file.filename or "").lower().endswith(".pdf"):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Only PDF files are supported.")
    try:
        return pdf_markdown_service.convert_pdf(file.filename or "document.pdf", await file.read())
    except ValueError as exc:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(exc)) from exc
    except Exception as exc:
        logger.exception("PDF-to-Markdown conversion failed for %s", file.filename)
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Failed to convert the uploaded PDF.") from exc


@app.get("/api/pdf-to-markdown/files/{file_name}")
def download_converted_markdown(file_name: str, user: AuthUser = Depends(get_current_user)) -> FileResponse:
    safe_name = Path(file_name).name
    if not safe_name.endswith(".md"):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Only Markdown files can be downloaded.")
    markdown_path = CONFIG.markdown_dir / safe_name
    if not markdown_path.exists():
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Generated Markdown file not found.")
    quoted_name = safe_name.replace("\\", "\\\\").replace('"', '\\"')
    content_disposition = f'attachment; filename="{quoted_name}"; filename*=UTF-8\'\'{quote(safe_name)}'
    return FileResponse(
        markdown_path,
        media_type="text/markdown; charset=utf-8",
        headers={"Content-Disposition": content_disposition},
    )


@app.get("/api/knowledge-base")
def knowledge_base(user: AuthUser = Depends(get_admin_user)) -> dict[str, Any]:
    return data_service.get_app_state()


@app.get("/api/knowledge-base/explorer")
def knowledge_explorer(user: AuthUser = Depends(get_admin_user)) -> dict[str, Any]:
    return {"items": data_service.get_explorer()}


@app.get("/api/knowledge-base/stats")
def knowledge_stats(user: AuthUser = Depends(get_admin_user)) -> dict[str, Any]:
    return {"statistics": data_service.get_statistics()}


@app.get("/api/knowledge-base/graph")
def knowledge_graph(user: AuthUser = Depends(get_admin_user)) -> dict[str, Any]:
    return data_service.get_graph()


@app.get("/api/knowledge-base/schema")
def knowledge_schema(user: AuthUser = Depends(get_admin_user)) -> dict[str, Any]:
    return data_service.get_schema()


@app.get("/api/search")
def search(q: str, mode: str = "keyword", user: AuthUser = Depends(get_current_user)) -> dict[str, Any]:
    return {"results": search_service.search(q, mode)}


@app.get("/api/debug/documents/{document_id}/index")
def document_index_debug(document_id: str, user: AuthUser = Depends(get_admin_user)) -> dict[str, Any]:
    document_name = _find_document_name(document_id)
    return _document_index_debug_payload(document_name)


@app.post("/api/debug/chat-trace")
def chat_trace(payload: ChatRequest, user: AuthUser = Depends(get_admin_user)) -> dict[str, Any]:
    settings = settings_service.get_settings(user.email)
    ai_model = payload.aiModel or settings.get("aiModel", "")
    language = payload.language or settings.get("language", "English")
    chat_service._current_document_name = payload.currentDocumentName or ""
    try:
        answer = chat_service.build_answer(
            payload.question,
            ai_model=ai_model,
            language=language,
            user_email=user.email,
            conversation_id=payload.conversationId or "",
        )
    finally:
        if hasattr(chat_service, "_current_document_name"):
            delattr(chat_service, "_current_document_name")
    trace = chat_service.get_last_trace()

    debug_documents: dict[str, Any] = {}
    for document_name in {
        str(payload.currentDocumentName or "").strip(),
        str((answer.get("documentSync") or {}).get("requestedDocumentName", "")).strip(),
        str((answer.get("documentSync") or {}).get("retrievedDocumentName", "")).strip(),
        str((answer.get("documentSync") or {}).get("responseDocumentName", "")).strip(),
        str(trace.get("detected_document", "")).strip(),
        str(trace.get("requested_document", "")).strip(),
        str(trace.get("retrieved_document", "")).strip(),
        str(trace.get("response_source_document", "")).strip(),
        str(trace.get("final_source_document", "")).strip(),
        str(answer.get("referencedPdf", "")).strip(),
        *[str(name).strip() for name in answer.get("sourcePdfs", [])],
    }:
        if document_name:
            debug_documents[document_name] = _document_index_debug_payload(document_name)["document"]

    return {
        "question": payload.question,
        "answer": answer,
        "trace": trace,
        "documents": debug_documents,
    }


@app.post("/api/chat/stream")
async def stream_chat(payload: ChatRequest, user: AuthUser = Depends(get_current_user)) -> StreamingResponse:
    settings = settings_service.get_settings(user.email)
    ai_model = payload.aiModel or settings.get("aiModel", "")
    language = payload.language or settings.get("language", "English")

    async def event_stream():
        for event in chat_service.stream_events(
            payload.question,
            ai_model=ai_model,
            language=language,
            current_document_name=payload.currentDocumentName or "",
            user_email=user.email,
            conversation_id=payload.conversationId or "",
        ):
            yield f"{event}\n"
            await asyncio.sleep(0.02)

    return StreamingResponse(event_stream(), media_type="application/x-ndjson")


@app.get("/api/settings")
def get_settings(user: AuthUser = Depends(get_current_user)) -> dict[str, Any]:
    settings = settings_service.get_settings(user.email)
    settings["metadata"]["generatedAt"] = data_service.get_app_state()["metadata"]["generatedAt"]
    settings["knowledgeStatus"] = data_service.get_overview()["knowledgeStatus"]
    return settings


@app.put("/api/settings")
def update_settings(payload: SettingsPatch, user: AuthUser = Depends(get_current_user)) -> dict[str, Any]:
    try:
        return settings_service.update_settings(payload.model_dump(exclude_none=True), user.email)
    except ValueError as exc:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(exc)) from exc
