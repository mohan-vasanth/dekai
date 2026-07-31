from __future__ import annotations

import shutil
import threading
import time
from datetime import datetime, timezone
from typing import Any
from uuid import uuid4

from config import CONFIG
from run import DGFTKnowledgePipeline, configure_logging

from .document_version_service import document_version_service
from .knowledge_engine import knowledge_engine_service
from .runtime_store import runtime_store


class PipelineBusyError(RuntimeError):
    pass


class PipelineService:
    def __init__(self) -> None:
        self._lock = threading.Lock()
        self._logging_ready = False

    def _ensure_logging(self) -> None:
        if not self._logging_ready:
            configure_logging()
            self._logging_ready = True

    def _load_jobs(self) -> list[dict[str, Any]]:
        return runtime_store.read_json(runtime_store.jobs_path, [])

    def _save_jobs(self, jobs: list[dict[str, Any]]) -> None:
        runtime_store.write_json(runtime_store.jobs_path, jobs)

    def list_jobs(self) -> list[dict[str, Any]]:
        jobs = self._load_jobs()
        return self._reconcile_jobs(jobs)

    def get_job(self, job_id: str) -> dict[str, Any] | None:
        return next((job for job in self.list_jobs() if job["id"] == job_id), None)

    def _stages(self) -> list[dict[str, str]]:
        return [
            {"label": "Uploading", "state": "current"},
            {"label": "Reading PDF", "state": "upcoming"},
            {"label": "Extracting Chapters", "state": "upcoming"},
            {"label": "Extracting Sections", "state": "upcoming"},
            {"label": "Extracting Headings", "state": "upcoming"},
            {"label": "Extracting Tables", "state": "upcoming"},
            {"label": "Extracting Notes", "state": "upcoming"},
            {"label": "Extracting Definitions", "state": "upcoming"},
            {"label": "Extracting Business Rules", "state": "upcoming"},
            {"label": "Extracting Conditions", "state": "upcoming"},
            {"label": "Extracting Validations", "state": "upcoming"},
            {"label": "Extracting Exceptions", "state": "upcoming"},
            {"label": "Extracting Authorities", "state": "upcoming"},
            {"label": "Extracting Required Documents", "state": "upcoming"},
            {"label": "Extracting Timelines", "state": "upcoming"},
            {"label": "Extracting Workflows", "state": "upcoming"},
            {"label": "Generating Searchable Chunks", "state": "upcoming"},
            {"label": "Generating Embeddings", "state": "upcoming"},
            {"label": "Building Knowledge Graph", "state": "upcoming"},
            {"label": "Storing Knowledge Base", "state": "upcoming"},
            {"label": "Knowledge Base Ready", "state": "upcoming"},
        ]

    def _upsert_job(self, next_job: dict[str, Any]) -> None:
        jobs = self._load_jobs()
        existing_index = next((index for index, job in enumerate(jobs) if job["id"] == next_job["id"]), None)
        if existing_index is None:
            jobs.insert(0, next_job)
        else:
            jobs[existing_index] = next_job
        self._save_jobs(jobs[:50])

    def _create_job(self, document_id: str, document_name: str, action: str) -> dict[str, Any]:
        now = time.strftime("%Y-%m-%dT%H:%M:%S.000Z", time.gmtime())
        job = {
            "id": uuid4().hex,
            "documentId": document_id,
            "documentName": document_name,
            "action": action,
            "status": "processing",
            "stage": "Uploading",
            "progress": 5,
            "error": None,
            "startedAt": now,
            "updatedAt": now,
            "stages": self._stages(),
        }
        self._upsert_job(job)
        return job

    def _update_job(self, job: dict[str, Any], stage: str, progress: int, status: str = "processing", error: str | None = None) -> None:
        labels = [item["label"] for item in job["stages"]]
        current_index = labels.index(stage) if stage in labels else len(labels) - 1
        job["stage"] = stage
        job["progress"] = progress
        job["status"] = status
        job["error"] = error
        job["updatedAt"] = time.strftime("%Y-%m-%dT%H:%M:%S.000Z", time.gmtime())
        job["stages"] = [
            {
                "label": label,
                "state": "complete" if index < current_index or (status == "ready" and index == current_index) else "current" if index == current_index else "upcoming",
            }
            for index, label in enumerate(labels)
        ]
        self._upsert_job(job)

    def _document_id(self, name: str) -> str:
        return "-".join("".join(char.lower() if char.isalnum() else "-" for char in name).split("-"))

    def _job_timestamp(self, value: str | None) -> datetime | None:
        if not value:
            return None
        try:
            return datetime.strptime(value, "%Y-%m-%dT%H:%M:%S.000Z").replace(tzinfo=timezone.utc)
        except ValueError:
            return None

    def _reconcile_jobs(self, jobs: list[dict[str, Any]]) -> list[dict[str, Any]]:
        if self._lock.locked():
            return jobs

        now = datetime.now(timezone.utc)
        changed = False
        for job in jobs:
            if job.get("status") == "ready":
                stage_name = str(job.get("stage", ""))
                stages = job.get("stages", [])
                stage_changed = False
                for stage in stages:
                    if stage.get("label") == stage_name and stage.get("state") != "complete":
                        stage["state"] = "complete"
                        stage_changed = True
                changed = changed or stage_changed
                continue
            if job.get("status") != "processing":
                continue
            updated_at = self._job_timestamp(job.get("updatedAt"))
            if updated_at and (now - updated_at).total_seconds() < 30:
                continue
            job["status"] = "failed"
            job["error"] = "Processing was interrupted before completion. Retry the operation."
            job["updatedAt"] = time.strftime("%Y-%m-%dT%H:%M:%S.000Z", time.gmtime())
            changed = True
            document_version_service.update_document_status(str(job.get("documentName", "")), "failed", str(job["error"]))

        if changed:
            self._save_jobs(jobs)
        return jobs

    def _clear_generated_outputs(self) -> None:
        for directory in CONFIG.output_directories().values():
            if directory == CONFIG.runtime_dir:
                continue
            for child in directory.iterdir():
                if directory == CONFIG.reports_dir and child.suffix == ".log":
                    continue
                if child.is_dir():
                    shutil.rmtree(child)
                else:
                    child.unlink()

    def _mark_document_failed(self, filename: str, error: str) -> None:
        document_version_service.update_document_metadata(
            filename,
            {
                "pages": 0,
                "sections": 0,
                "rules": 0,
                "conditions": 0,
                "exceptions": 0,
                "workflows": 0,
                "sourcePdf": filename,
                "error": error,
            },
            status="failed",
        )
        document_version_service.update_document_status(filename, "failed", error)

    def _run_pipeline(self, target_name: str | None, job: dict[str, Any] | None = None) -> None:
        self._ensure_logging()
        self._clear_generated_outputs()
        pipeline = DGFTKnowledgePipeline()
        pdf_files = pipeline._ordered_pdf_files()
        if not pdf_files:
            knowledge_engine_service.build_index()
            return

        documents = []
        target_name = target_name or ""
        target_error: str | None = None
        total_files = len(pdf_files)
        if job and not target_name:
            self._update_job(job, "Reading PDF", 12)
        for pdf_path in pdf_files:
            is_target = bool(job and pdf_path.name == target_name)
            if is_target:
                staged_updates = [
                    ("Reading PDF", 18),
                    ("Extracting Chapters", 24),
                    ("Extracting Sections", 34),
                    ("Extracting Headings", 40),
                    ("Extracting Tables", 44),
                    ("Extracting Notes", 48),
                    ("Extracting Definitions", 52),
                    ("Extracting Business Rules", 58),
                    ("Extracting Conditions", 62),
                    ("Extracting Validations", 66),
                    ("Extracting Exceptions", 70),
                    ("Extracting Authorities", 72),
                    ("Extracting Required Documents", 74),
                    ("Extracting Timelines", 76),
                    ("Extracting Workflows", 78),
                ]
                for stage_name, progress in staged_updates:
                    self._update_job(job, stage_name, progress)
            try:
                document = pipeline._process_pdf(pdf_path)
            except Exception as exc:
                error_message = str(exc) or f"Failed to process {pdf_path.name}."
                self._mark_document_failed(pdf_path.name, error_message)
                if is_target:
                    target_error = error_message
                continue
            if is_target:
                self._update_job(job, "Generating Searchable Chunks", 84)
                self._update_job(job, "Generating Embeddings", 90)
            elif job and total_files:
                processed_count = len(documents)
                progress = min(82, 12 + int((processed_count / total_files) * 64))
                self._update_job(job, "Extracting Sections", progress)
            documents.append(document)

        knowledge_base = pipeline.knowledge_base_builder.build_master_knowledge_base(documents)
        pipeline._write_master_outputs(documents, knowledge_base)
        if job:
            self._update_job(job, "Building Knowledge Graph", 94)
            self._update_job(job, "Storing Knowledge Base", 97)
        knowledge_engine_service.build_index()
        if job:
            if target_error:
                self._update_job(job, job["stage"], 100, status="failed", error=target_error)
            else:
                self._update_job(job, "Knowledge Base Ready", 100, status="ready")
            if target_name and not target_error:
                document_version_service.update_document_status(target_name, "ready")

    def ensure_knowledge_base(self) -> None:
        master_path = CONFIG.json_dir / "master_knowledge_base.json"
        if master_path.exists():
            return
        with self._lock:
            if master_path.exists():
                return
            self._run_pipeline(target_name=None, job=None)

    def _start_background_rebuild(self, source_name: str, job: dict[str, Any]) -> None:
        def runner() -> None:
            try:
                with self._lock:
                    self._run_pipeline(source_name, job)
            except Exception as exc:
                self._update_job(job, job["stage"], job["progress"], status="failed", error=str(exc))
                document_version_service.update_document_status(source_name, "failed", str(exc))

        thread = threading.Thread(target=runner, daemon=True)
        thread.start()

    def upload_document(self, filename: str, content: bytes) -> dict[str, Any]:
        if self._lock.locked():
            raise PipelineBusyError("A document processing job is already running.")
        target_path = CONFIG.input_pdf_dir / filename
        target_path.write_bytes(content)
        document_version_service.record_upload(filename)
        job = self._create_job(self._document_id(filename), filename, "upload")
        self._start_background_rebuild(filename, job)
        return job

    def upload_documents(self, files: list[tuple[str, bytes]]) -> dict[str, Any]:
        if self._lock.locked():
            raise PipelineBusyError("A document processing job is already running.")
        if not files:
            raise ValueError("At least one PDF file is required.")

        for filename, content in files:
            (CONFIG.input_pdf_dir / filename).write_bytes(content)
            document_version_service.record_upload(filename)

        label = f"{len(files)} documents" if len(files) > 1 else files[0][0]
        document_id = "batch-upload" if len(files) > 1 else self._document_id(files[0][0])
        job = self._create_job(document_id, label, "upload-batch" if len(files) > 1 else "upload")
        self._start_background_rebuild("", job)
        return job

    def replace_document(self, current_filename: str, replacement_name: str, content: bytes) -> dict[str, Any]:
        if self._lock.locked():
            raise PipelineBusyError("A document processing job is already running.")

        current_path = CONFIG.input_pdf_dir / current_filename
        if current_path.exists():
            current_path.unlink()
        replacement_path = CONFIG.input_pdf_dir / replacement_name
        replacement_path.write_bytes(content)
        document_version_service.record_replace(current_filename, replacement_name)
        job = self._create_job(self._document_id(replacement_name), replacement_name, "replace")
        self._start_background_rebuild(replacement_name, job)
        return job

    def reindex_document(self, filename: str) -> dict[str, Any]:
        if self._lock.locked():
            raise PipelineBusyError("A document processing job is already running.")

        target_path = CONFIG.input_pdf_dir / filename
        if not target_path.exists():
            raise FileNotFoundError(filename)

        document_version_service.update_document_status(filename, "processing")
        job = self._create_job(self._document_id(filename), filename, "reindex")
        self._start_background_rebuild(filename, job)
        return job

    def delete_document(self, filename: str) -> dict[str, Any]:
        if self._lock.locked():
            raise PipelineBusyError("A document processing job is already running.")

        target_path = CONFIG.input_pdf_dir / filename
        if target_path.exists():
            target_path.unlink()

        document_version_service.record_delete(filename)
        job = self._create_job(self._document_id(filename), filename, "delete")
        try:
            with self._lock:
                self._update_job(job, "Reading PDF", 20)
                if any(CONFIG.input_pdf_dir.glob("*.pdf")):
                    self._run_pipeline(target_name=None, job=job)
                else:
                    self._clear_generated_outputs()
                    knowledge_engine_service.build_index()
                    self._update_job(job, "Knowledge Base Ready", 100, status="ready")
                document_version_service.update_document_status(filename, "ready")
        except Exception as exc:
            self._update_job(job, job["stage"], job["progress"], status="failed", error=str(exc))
            document_version_service.update_document_status(filename, "failed", str(exc))
            raise
        return job


pipeline_service = PipelineService()
