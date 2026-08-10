from __future__ import annotations

import hashlib
import shutil
import threading
import time
from datetime import datetime, timezone
from pathlib import Path
from typing import Any
from uuid import uuid4

from config import CONFIG
from run import DGFTKnowledgePipeline, configure_logging

from .document_version_service import document_version_service
from .knowledge_engine import knowledge_engine_service
from .runtime_store import runtime_store


class PipelineBusyError(RuntimeError):
    pass


class DuplicateDocumentError(RuntimeError):
    pass


class PipelineService:
    def __init__(self) -> None:
        self._lock = threading.Lock()
        self._dispatch_lock = threading.Lock()
        self._logging_ready = False
        self._staged_upload_dir = runtime_store.runtime_dir / "queued_uploads"
        self._staged_upload_dir.mkdir(parents=True, exist_ok=True)

    def _stage_order(self) -> list[str]:
        return [
            "Queued",
            "Validate PDF",
            "Extract Text",
            "Convert to Markdown",
            "Identify Sections",
            "Generate Chunks",
            "Create Embeddings",
            "Index into Knowledge Base",
            "Ready",
        ]

    def _ensure_logging(self) -> None:
        if not self._logging_ready:
            configure_logging()
            self._logging_ready = True

    def _load_jobs(self) -> list[dict[str, Any]]:
        return runtime_store.read_json(runtime_store.jobs_path, [])

    def _save_jobs(self, jobs: list[dict[str, Any]]) -> None:
        runtime_store.write_json(runtime_store.jobs_path, jobs)

    def list_jobs(self) -> list[dict[str, Any]]:
        jobs = self._reconcile_jobs(self._load_jobs())
        self._maybe_start_next_job()
        return self._reconcile_jobs(self._load_jobs())

    def get_job(self, job_id: str) -> dict[str, Any] | None:
        return next((job for job in self.list_jobs() if job["id"] == job_id), None)

    def _stages(self) -> list[dict[str, str]]:
        labels = self._stage_order()
        return [{"label": label, "state": "current" if index == 0 else "upcoming"} for index, label in enumerate(labels)]

    def _upsert_job(self, next_job: dict[str, Any]) -> None:
        jobs = self._load_jobs()
        existing_index = next((index for index, job in enumerate(jobs) if job["id"] == next_job["id"]), None)
        if existing_index is None:
            jobs.insert(0, next_job)
        else:
            jobs[existing_index] = next_job
        self._save_jobs(jobs[:50])

    def _create_job(
        self,
        document_id: str,
        document_name: str,
        action: str,
        *,
        file_hash: str | None = None,
        status: str = "queued",
    ) -> dict[str, Any]:
        now = time.strftime("%Y-%m-%dT%H:%M:%S.000Z", time.gmtime())
        stage = "Queued" if status == "queued" else "Validate PDF"
        progress = 0 if status == "queued" else 5
        job = {
            "id": uuid4().hex,
            "documentId": document_id,
            "documentName": document_name,
            "action": action,
            "status": status,
            "stage": stage,
            "progress": progress,
            "error": None,
            "fileHash": file_hash,
            "startedAt": now,
            "updatedAt": now,
            "stages": self._stages(),
            "queueSequence": time.time_ns(),
        }
        self._upsert_job(job)
        return job

    def _update_job(self, job: dict[str, Any], stage: str, progress: int, status: str = "processing", error: str | None = None) -> None:
        labels = [item["label"] for item in job["stages"]]
        current_index = labels.index(stage) if stage in labels else 0
        job["stage"] = stage
        job["progress"] = progress
        job["status"] = status
        job["error"] = error
        job["updatedAt"] = time.strftime("%Y-%m-%dT%H:%M:%S.000Z", time.gmtime())
        if status == "ready":
            job["stages"] = [
                {
                    "label": label,
                    "state": "complete" if index <= current_index else "upcoming",
                }
                for index, label in enumerate(labels)
            ]
        elif status == "failed":
            job["stages"] = [
                {
                    "label": label,
                    "state": "complete" if index < current_index else "current" if index == current_index else "upcoming",
                }
                for index, label in enumerate(labels)
            ]
        else:
            job["stages"] = [
                {
                    "label": label,
                    "state": "current" if index == current_index else "complete" if index < current_index else "upcoming",
                }
                for index, label in enumerate(labels)
            ]
        self._upsert_job(job)

    def _validate_upload(self, filename: str, content: bytes) -> None:
        if not str(filename or "").lower().endswith(".pdf"):
            raise ValueError("Only PDF files are supported.")
        if not content:
            raise ValueError("The uploaded PDF is empty.")
        header = bytes(content[:1024]).lstrip()
        if not header.startswith(b"%PDF"):
            raise ValueError("Invalid PDF")

    def _document_id(self, name: str) -> str:
        return "-".join("".join(char.lower() if char.isalnum() else "-" for char in name).split("-"))

    def _file_hash(self, content: bytes) -> str:
        return hashlib.sha256(content).hexdigest()

    def _staged_upload_path(self, job_id: str, filename: str) -> Path:
        safe_name = Path(filename).name or "document.pdf"
        return self._staged_upload_dir / f"{job_id}__{safe_name}"

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

    def _active_jobs(self, jobs: list[dict[str, Any]]) -> list[dict[str, Any]]:
        return [job for job in jobs if str(job.get("status", "")) in {"queued", "processing"}]

    def _existing_document_name_for_hash(self, file_hash: str) -> str | None:
        for entry in document_version_service.list_documents():
            if entry.get("archived"):
                continue
            versions = [version for version in entry.get("versions", []) if isinstance(version, dict)]
            if any(str(version.get("metadata", {}).get("fileHash", "")) == file_hash for version in versions):
                return str(entry.get("currentName", "")).strip() or None

        for pdf_path in CONFIG.input_pdf_dir.glob("*.pdf"):
            try:
                if self._file_hash(pdf_path.read_bytes()) == file_hash:
                    return pdf_path.name
            except OSError:
                continue
        return None

    def _ensure_upload_is_unique(self, filename: str, file_hash: str) -> None:
        document_id = self._document_id(filename)
        jobs = self._reconcile_jobs(self._load_jobs())
        for job in self._active_jobs(jobs):
            if str(job.get("documentId", "")) == document_id:
                raise DuplicateDocumentError(
                    f"{filename} already has an active job ({job.get('id')}). Use replace or wait for that job to finish."
                )
            if file_hash and str(job.get("fileHash", "")) == file_hash:
                raise DuplicateDocumentError(
                    f"The same PDF is already queued or processing as {job.get('documentName', filename)} ({job.get('id')})."
                )

        existing_name = self._existing_document_name_for_hash(file_hash)
        if existing_name:
            raise DuplicateDocumentError(f"The same PDF is already indexed as {existing_name}.")

        existing_path = CONFIG.input_pdf_dir / filename
        if existing_path.exists():
            raise DuplicateDocumentError(
                f"A document named {filename} already exists. Replace the existing document instead of uploading a second copy."
            )

    def _create_failed_job(self, filename: str, action: str, error: str) -> dict[str, Any]:
        document_version_service.record_upload(filename)
        self._mark_document_failed(filename, error)
        job = self._create_job(self._document_id(filename), filename, action, status="processing")
        self._update_job(job, "Validate PDF", 100, status="failed", error=error)
        return job

    def _run_pipeline(self, target_names: set[str] | None, jobs_by_document: dict[str, dict[str, Any]] | None = None) -> None:
        self._ensure_logging()
        self._clear_generated_outputs()
        pipeline = DGFTKnowledgePipeline()
        pdf_files = pipeline._ordered_pdf_files()
        if not pdf_files:
            knowledge_engine_service.build_index()
            return

        documents = []
        target_names = target_names or set()
        jobs_by_document = jobs_by_document or {}
        target_errors: dict[str, str] = {}
        for pdf_path in pdf_files:
            is_target = pdf_path.name in target_names
            target_job = jobs_by_document.get(pdf_path.name)
            if target_job:
                self._update_job(target_job, "Validate PDF", 10)
            try:
                document = pipeline._process_pdf(
                    pdf_path,
                    progress_callback=(
                        (lambda stage_name, progress, document_name=pdf_path.name: self._update_job(jobs_by_document[document_name], stage_name, progress))
                        if target_job
                        else None
                    ),
                )
            except Exception as exc:
                error_message = str(exc) or f"Failed to process {pdf_path.name}."
                self._mark_document_failed(pdf_path.name, error_message)
                if target_job:
                    self._update_job(target_job, str(target_job.get("stage", "Validate PDF")), 100, status="failed", error=error_message)
                if is_target:
                    target_errors[pdf_path.name] = error_message
                continue
            documents.append(document)

        knowledge_base = pipeline.knowledge_base_builder.build_master_knowledge_base(documents) if documents else {}
        if documents:
            for target_job in jobs_by_document.values():
                if target_job.get("status") == "processing":
                    self._update_job(target_job, "Index into Knowledge Base", 92)
            pipeline._write_master_outputs(documents, knowledge_base)
        knowledge_engine_service.build_index()
        for document_name, target_job in jobs_by_document.items():
            if document_name in target_errors or target_job.get("status") == "failed":
                continue
            if not knowledge_engine_service.document_is_queryable(document_name):
                snapshot = knowledge_engine_service.document_index_snapshot(document_name)
                error_message = (
                    f"Index verification failed for {document_name}: "
                    f"sections={snapshot['counts']['sections']}, "
                    f"chunks={snapshot['counts']['chunks']}, "
                    f"embeddings={snapshot['counts']['embeddings']}."
                )
                self._update_job(target_job, "Index into Knowledge Base", 100, status="failed", error=error_message)
                document_version_service.update_document_status(document_name, "failed", error_message)
                continue
            self._update_job(target_job, "Ready", 100, status="ready")
            document_version_service.update_document_status(document_name, "ready")

    def ensure_knowledge_base(self) -> None:
        master_path = CONFIG.json_dir / "master_knowledge_base.json"
        self._maybe_start_next_job()
        if master_path.exists():
            return
        with self._lock:
            if master_path.exists():
                return
            self._run_pipeline(target_names=None, jobs_by_document=None)

    def _materialize_staged_upload(self, job: dict[str, Any]) -> None:
        staged_path = Path(str(job.get("sourcePath", "")))
        if not staged_path.exists():
            raise FileNotFoundError(f"Staged upload for {job.get('documentName', 'document')} is unavailable.")
        target_path = CONFIG.input_pdf_dir / str(job.get("documentName", "document.pdf"))
        target_path.write_bytes(staged_path.read_bytes())

    def _cleanup_staged_upload(self, job: dict[str, Any]) -> None:
        staged_path = Path(str(job.get("sourcePath", "")))
        if not str(staged_path):
            return
        try:
            staged_path.unlink(missing_ok=True)
        except OSError:
            pass

    def _run_queued_job(self, job: dict[str, Any]) -> None:
        document_name = str(job.get("documentName", ""))
        try:
            with self._lock:
                self._update_job(job, "Validate PDF", 5, status="processing")
                self._materialize_staged_upload(job)
                document_version_service.update_document_status(document_name, "processing")
                self._run_pipeline({document_name}, {document_name: job})
        except Exception as exc:
            if job.get("status") != "failed":
                self._update_job(
                    job,
                    str(job.get("stage", "Validate PDF")),
                    int(job.get("progress", 0) or 0),
                    status="failed",
                    error=str(exc),
                )
                document_version_service.update_document_status(document_name, "failed", str(exc))
        finally:
            self._cleanup_staged_upload(job)
            self._maybe_start_next_job()

    def _maybe_start_next_job(self) -> None:
        if self._lock.locked():
            return

        with self._dispatch_lock:
            if self._lock.locked():
                return
            jobs = self._reconcile_jobs(self._load_jobs())
            queued_jobs = sorted(
                (job for job in jobs if job.get("status") == "queued"),
                key=lambda job: int(job.get("queueSequence", 0) or 0),
            )
            if not queued_jobs:
                return
            next_job = queued_jobs[0]
            thread = threading.Thread(target=lambda: self._run_queued_job(next_job), daemon=True)
            thread.start()

    def _queue_upload_job(self, filename: str, content: bytes, action: str) -> dict[str, Any]:
        self._validate_upload(filename, content)
        file_hash = self._file_hash(content)
        self._ensure_upload_is_unique(filename, file_hash)

        document_version_service.record_upload(filename)
        document_version_service.update_document_metadata(filename, {"fileHash": file_hash}, status="queued")
        job = self._create_job(self._document_id(filename), filename, action, file_hash=file_hash, status="queued")
        staged_path = self._staged_upload_path(job["id"], filename)
        staged_path.write_bytes(content)
        job["sourcePath"] = str(staged_path)
        self._upsert_job(job)
        self._maybe_start_next_job()
        return job

    def _start_background_rebuild(self, source_names: set[str], jobs_by_document: dict[str, dict[str, Any]]) -> None:
        def runner() -> None:
            try:
                with self._lock:
                    for job in jobs_by_document.values():
                        if job.get("status") == "queued":
                            self._update_job(job, "Validate PDF", 5, status="processing")
                    self._run_pipeline(source_names, jobs_by_document)
            except Exception as exc:
                for document_name, job in jobs_by_document.items():
                    if job.get("status") == "failed":
                        continue
                    self._update_job(job, str(job.get("stage", "Index into Knowledge Base")), int(job.get("progress", 0) or 0), status="failed", error=str(exc))
                    document_version_service.update_document_status(document_name, "failed", str(exc))

        thread = threading.Thread(target=runner, daemon=True)
        thread.start()

    def upload_document(self, filename: str, content: bytes) -> dict[str, Any]:
        return self._queue_upload_job(filename, content, "upload")

    def upload_documents(self, files: list[tuple[str, bytes]]) -> dict[str, Any]:
        if not files:
            raise ValueError("At least one PDF file is required.")

        jobs: list[dict[str, Any]] = []
        rejected: list[dict[str, str]] = []
        first_failure: ValueError | None = None
        for filename, content in files:
            try:
                jobs.append(self._queue_upload_job(filename, content, "upload-batch" if len(files) > 1 else "upload"))
            except DuplicateDocumentError as exc:
                rejected.append({"fileName": filename, "reason": str(exc)})
            except ValueError as exc:
                failed_job = self._create_failed_job(filename, "upload-batch", str(exc))
                jobs.append(failed_job)
                if first_failure is None:
                    first_failure = exc
        if jobs:
            return {"job": jobs[0], "jobs": jobs, "rejected": rejected}
        if first_failure:
            raise first_failure
        if rejected:
            raise DuplicateDocumentError(rejected[0]["reason"])
        raise ValueError("No uploadable PDF files were provided.")

    def replace_document(self, current_filename: str, replacement_name: str, content: bytes) -> dict[str, Any]:
        if self._lock.locked():
            raise PipelineBusyError("A document processing job is already running.")
        self._validate_upload(replacement_name, content)

        current_path = CONFIG.input_pdf_dir / current_filename
        if current_path.exists():
            current_path.unlink()
        replacement_path = CONFIG.input_pdf_dir / replacement_name
        replacement_path.write_bytes(content)
        document_version_service.record_replace(current_filename, replacement_name)
        document_version_service.update_document_metadata(replacement_name, {"fileHash": self._file_hash(content)}, status="queued")
        job = self._create_job(
            self._document_id(replacement_name),
            replacement_name,
            "replace",
            file_hash=self._file_hash(content),
            status="queued",
        )
        self._start_background_rebuild({replacement_name}, {replacement_name: job})
        return job

    def reindex_document(self, filename: str) -> dict[str, Any]:
        if self._lock.locked():
            raise PipelineBusyError("A document processing job is already running.")

        target_path = CONFIG.input_pdf_dir / filename
        if not target_path.exists():
            raise FileNotFoundError(filename)

        document_version_service.update_document_status(filename, "queued")
        file_hash = self._file_hash(target_path.read_bytes())
        document_version_service.update_document_metadata(filename, {"fileHash": file_hash}, status="queued")
        job = self._create_job(self._document_id(filename), filename, "reindex", file_hash=file_hash, status="queued")
        self._start_background_rebuild({filename}, {filename: job})
        return job

    def delete_document(self, filename: str) -> dict[str, Any]:
        if self._lock.locked():
            raise PipelineBusyError("A document processing job is already running.")

        target_path = CONFIG.input_pdf_dir / filename
        if target_path.exists():
            target_path.unlink()

        document_version_service.record_delete(filename)
        job = self._create_job(self._document_id(filename), filename, "delete", status="processing")
        try:
            with self._lock:
                self._update_job(job, "Validate PDF", 20)
                if any(CONFIG.input_pdf_dir.glob("*.pdf")):
                    self._run_pipeline(target_names=None, jobs_by_document={})
                    self._update_job(job, "Index into Knowledge Base", 92)
                else:
                    self._clear_generated_outputs()
                    knowledge_engine_service.build_index()
                self._update_job(job, "Ready", 100, status="ready")
                document_version_service.update_document_status(filename, "ready")
        except Exception as exc:
            self._update_job(job, job["stage"], job["progress"], status="failed", error=str(exc))
            document_version_service.update_document_status(filename, "failed", str(exc))
            raise
        return job


pipeline_service = PipelineService()
