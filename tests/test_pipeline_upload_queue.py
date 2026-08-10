from __future__ import annotations

import tempfile
import time
import unittest
from pathlib import Path

from config import CONFIG
from services.document_version_service import document_version_service
from services.pipeline_service import DuplicateDocumentError, PipelineService
from services.runtime_store import runtime_store


def _pdf_bytes(label: str) -> bytes:
    return f"%PDF-1.4\n% {label}\n1 0 obj\n<< /Type /Catalog >>\nendobj\ntrailer\n<<>>\n%%EOF".encode("utf-8")


class PipelineUploadQueueTests(unittest.TestCase):
    def setUp(self) -> None:
        self._tempdir = tempfile.TemporaryDirectory()
        self.temp_root = Path(self._tempdir.name)

        self._original_input_pdf_dir = CONFIG.input_pdf_dir
        self._original_runtime_dir = runtime_store.runtime_dir
        self._original_jobs_path = runtime_store.jobs_path
        self._original_document_versions_path = runtime_store.document_versions_path

        object.__setattr__(CONFIG, "input_pdf_dir", self.temp_root / "input" / "pdf")
        CONFIG.input_pdf_dir.mkdir(parents=True, exist_ok=True)

        runtime_store.runtime_dir = self.temp_root / "runtime"
        runtime_store.runtime_dir.mkdir(parents=True, exist_ok=True)
        runtime_store.jobs_path = runtime_store.runtime_dir / "jobs.json"
        runtime_store.document_versions_path = runtime_store.runtime_dir / "document_versions.json"

        self.service = PipelineService()
        self.execution_order: list[str] = []

        def fake_run_pipeline(target_names: set[str] | None, jobs_by_document: dict[str, dict[str, object]] | None = None) -> None:
            document_name = next(iter(target_names or set()), "")
            if document_name:
                self.execution_order.append(document_name)
            time.sleep(0.05)
            for job in (jobs_by_document or {}).values():
                self.service._update_job(job, "Extract Text", 35, status="processing")
            time.sleep(0.05)
            for document_name, job in (jobs_by_document or {}).items():
                self.service._update_job(job, "Ready", 100, status="ready")
                document_version_service.update_document_status(document_name, "ready")

        self.service._run_pipeline = fake_run_pipeline  # type: ignore[method-assign]

    def tearDown(self) -> None:
        object.__setattr__(CONFIG, "input_pdf_dir", self._original_input_pdf_dir)
        runtime_store.runtime_dir = self._original_runtime_dir
        runtime_store.jobs_path = self._original_jobs_path
        runtime_store.document_versions_path = self._original_document_versions_path
        self._tempdir.cleanup()

    def _wait_for_job_status(self, job_id: str, expected: set[str], timeout_seconds: float = 5.0) -> dict[str, object]:
        deadline = time.time() + timeout_seconds
        while time.time() < deadline:
            job = self.service.get_job(job_id)
            if job and str(job.get("status")) in expected:
                return job
            time.sleep(0.02)
        self.fail(f"Timed out waiting for job {job_id} to reach one of {sorted(expected)}.")

    def _wait_for_jobs(self, job_ids: list[str], expected_status: str, timeout_seconds: float = 5.0) -> dict[str, dict[str, object]]:
        deadline = time.time() + timeout_seconds
        while time.time() < deadline:
            jobs = {str(job["id"]): job for job in self.service.list_jobs()}
            if all(str(jobs.get(job_id, {}).get("status", "")) == expected_status for job_id in job_ids):
                return jobs
            time.sleep(0.02)
        self.fail(f"Timed out waiting for jobs {job_ids} to reach {expected_status}.")

    def test_distinct_uploads_queue_and_duplicate_active_file_is_rejected(self) -> None:
        job_a = self.service.upload_document("A.pdf", _pdf_bytes("A"))
        self.assertIn(job_a["status"], {"queued", "processing"})

        with self.assertRaises(DuplicateDocumentError):
            self.service.upload_document("A-copy.pdf", _pdf_bytes("A"))

        job_b = self.service.upload_document("B.pdf", _pdf_bytes("B"))
        job_c = self.service.upload_document("C.pdf", _pdf_bytes("C"))

        self.assertIn(job_b["status"], {"queued", "processing"})
        self.assertIn(job_c["status"], {"queued", "processing"})

        jobs = self._wait_for_jobs([str(job_a["id"]), str(job_b["id"]), str(job_c["id"])], "ready")
        final_a = jobs[str(job_a["id"])]
        final_b = jobs[str(job_b["id"])]
        final_c = jobs[str(job_c["id"])]

        self.assertEqual(final_a["documentName"], "A.pdf")
        self.assertEqual(final_b["documentName"], "B.pdf")
        self.assertEqual(final_c["documentName"], "C.pdf")
        self.assertEqual(self.execution_order, ["A.pdf", "B.pdf", "C.pdf"])

        input_files = sorted(path.name for path in CONFIG.input_pdf_dir.glob("*.pdf"))
        self.assertEqual(input_files, ["A.pdf", "B.pdf", "C.pdf"])

    def test_stale_processing_job_fails_and_next_queued_job_runs(self) -> None:
        document_version_service.record_upload("stale.pdf")
        document_version_service.update_document_status("stale.pdf", "processing")
        stale_job = self.service._create_job(
            self.service._document_id("stale.pdf"),
            "stale.pdf",
            "upload",
            file_hash="stale-hash",
            status="processing",
        )
        self.service._update_job(stale_job, "Extract Text", 35, status="processing")

        document_version_service.record_upload("queued.pdf")
        document_version_service.update_document_metadata("queued.pdf", {"fileHash": "queued-hash"}, status="queued")
        queued_job = self.service._create_job(
            self.service._document_id("queued.pdf"),
            "queued.pdf",
            "upload",
            file_hash="queued-hash",
            status="queued",
        )
        staged_path = self.service._staged_upload_path(str(queued_job["id"]), "queued.pdf")
        staged_path.write_bytes(_pdf_bytes("queued"))
        queued_job["sourcePath"] = str(staged_path)
        self.service._upsert_job(queued_job)

        jobs = self.service.list_jobs()
        stale_snapshot = next(job for job in jobs if job["id"] == stale_job["id"])
        self.assertEqual(stale_snapshot["status"], "failed")
        self.assertIn("interrupted", str(stale_snapshot.get("error", "")).casefold())

        final_queued = self._wait_for_job_status(str(queued_job["id"]), {"ready"})
        self.assertEqual(final_queued["status"], "ready")
        self.assertEqual(self.execution_order, ["queued.pdf"])


if __name__ == "__main__":
    unittest.main()
