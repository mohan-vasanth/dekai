import unittest

from services.chat_service import chat_service
from services.knowledge_engine import knowledge_engine_service


class DocumentScopedRetrievalTests(unittest.TestCase):
    INPDEC_DOCUMENT = "TradeNetDeclaration.INPDEC Ver2.1.pdf"

    @classmethod
    def setUpClass(cls) -> None:
        cls.index = knowledge_engine_service.load_index(refresh=True)
        cls.ready_documents = chat_service._ready_documents(cls.index)
        cls.current_inpdec_document = chat_service._find_ready_document_by_name(cls.INPDEC_DOCUMENT, cls.ready_documents)
        if cls.current_inpdec_document is None:
            raise AssertionError("Expected the INPDEC TradeNet document to be ready in the knowledge base.")

    def _prepare_bundle(self, question: str, *, current_document_name: str = "") -> dict:
        chat_service._current_document_name = current_document_name
        try:
            return chat_service._prepare_answer_bundle(
                question,
                ai_model="",
                language="English",
                user_email="test@example.com",
                conversation_id="document-scoped-retrieval",
            )
        finally:
            if hasattr(chat_service, "_current_document_name"):
                delattr(chat_service, "_current_document_name")

    def test_rebuilt_index_contains_inpdec_search_records(self) -> None:
        section_documents = {
            str(item.get("documentName", "")).strip()
            for item in self.index.get("sections", [])
            if str(item.get("documentName", "")).strip()
        }
        search_documents = {
            str(item.get("documentName", "")).strip()
            for item in self.index.get("searchRecords", [])
            if str(item.get("documentName", "")).strip()
        }
        self.assertIn(self.INPDEC_DOCUMENT, section_documents)
        self.assertIn(self.INPDEC_DOCUMENT, search_documents)

    def test_transport_modes_question_stays_inpdec_scoped(self) -> None:
        bundle = self._prepare_bundle("What are the transport modes listed in the INPDEC PDF?")
        answer = bundle["answer"]
        direct_answer = str(answer.get("directAnswer", ""))

        self.assertFalse(bundle["skipLlm"])
        self.assertEqual(bundle["finalContextDocuments"], [self.INPDEC_DOCUMENT])
        self.assertEqual(answer.get("referencedPdf"), self.INPDEC_DOCUMENT)
        self.assertEqual(answer.get("sourceSection"), "1 Maritime")
        self.assertEqual(answer.get("sourcePages"), [12, 13])
        for expected_value in ("Maritime", "Rail", "Road", "Air", "Mail", "Multimodal", "Pipeline"):
            self.assertIn(expected_value, direct_answer)
        self.assertNotIn("MESSAGE DETAILS", direct_answer)
        self.assertEqual(
            {
                str(item.get("documentName", "")).strip()
                for item in bundle.get("retrieval", [])
                if str(item.get("documentName", "")).strip()
            },
            {self.INPDEC_DOCUMENT},
        )
        self.assertEqual(
            [(chunk.get("sectionId"), chunk.get("title")) for chunk in bundle.get("selectedChunks", [])],
            [
                ("1", "Maritime"),
                ("2", "Rail"),
                ("3", "Road"),
                ("4", "Air"),
                ("5", "Mail"),
                ("6", "Multimodal (For future use)"),
                ("7", "Pipeline"),
            ],
        )

    def test_declaration_types_question_stays_inpdec_scoped(self) -> None:
        bundle = self._prepare_bundle("What are the declaration types listed in the INPDEC PDF?")
        answer = bundle["answer"]

        self.assertFalse(bundle["skipLlm"])
        self.assertEqual(bundle["finalContextDocuments"], [self.INPDEC_DOCUMENT])
        self.assertEqual(answer.get("referencedPdf"), self.INPDEC_DOCUMENT)
        self.assertEqual(answer.get("sourceSection"), "8 MESSAGE DETAILS")
        self.assertEqual(
            {
                str(item.get("documentName", "")).strip()
                for item in bundle.get("retrieval", [])
                if str(item.get("documentName", "")).strip()
            },
            {self.INPDEC_DOCUMENT},
        )

    def test_current_trade_net_document_locks_follow_up_transport_question(self) -> None:
        bundle = self._prepare_bundle(
            "What are the transport modes?",
            current_document_name=self.INPDEC_DOCUMENT,
        )
        answer = bundle["answer"]

        self.assertFalse(bundle["skipLlm"])
        self.assertEqual(bundle["finalContextDocuments"], [self.INPDEC_DOCUMENT])
        self.assertEqual(answer.get("referencedPdf"), self.INPDEC_DOCUMENT)
        self.assertEqual(answer.get("sourceSection"), "1 Maritime")
        self.assertIn("Pipeline", str(answer.get("directAnswer", "")))

    def test_transport_mode_code_lookup_stays_grounded(self) -> None:
        bundle = self._prepare_bundle(
            "What transport mode corresponds to code 4?",
            current_document_name=self.INPDEC_DOCUMENT,
        )
        answer = bundle["answer"]

        self.assertFalse(bundle["skipLlm"])
        self.assertEqual(answer.get("referencedPdf"), self.INPDEC_DOCUMENT)
        self.assertEqual(answer.get("sourceSection"), "4 Air")
        self.assertEqual(answer.get("sourcePages"), [12, 13])
        self.assertEqual(str(answer.get("directAnswer", "")), "According to the selected document, code 4 corresponds to Air.")

    def test_transport_mode_code_seven_uses_pipeline_evidence(self) -> None:
        bundle = self._prepare_bundle(
            "What is transport mode code 7?",
            current_document_name=self.INPDEC_DOCUMENT,
        )
        answer = bundle["answer"]

        self.assertFalse(bundle["skipLlm"])
        self.assertEqual(answer.get("referencedPdf"), self.INPDEC_DOCUMENT)
        self.assertEqual(answer.get("sourceSection"), "7 Pipeline")
        self.assertEqual(answer.get("sourcePages"), [12])
        self.assertEqual(str(answer.get("directAnswer", "")), "According to the selected document, code 7 corresponds to Pipeline.")


if __name__ == "__main__":
    unittest.main()
