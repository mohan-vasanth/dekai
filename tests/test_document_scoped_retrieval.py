import unittest

from services.chat_service import chat_service
from services.knowledge_engine import knowledge_engine_service


class DocumentScopedRetrievalTests(unittest.TestCase):
    INPDEC_DOCUMENT = "TradeNetDeclaration.INPDEC Ver2.1.pdf"
    NOT_FOUND_MESSAGE = "The requested information was not found in the selected document."

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

    def _assert_exact_field_answer(
        self,
        bundle: dict,
        *,
        expected_document: str,
        expected_section: str,
        expected_pages: list[int],
        required_phrases: tuple[str, ...],
        forbidden_phrases: tuple[str, ...] = (),
        top_heading: str = "",
    ) -> None:
        answer = bundle["answer"]
        direct_answer = str(answer.get("directAnswer", ""))

        self.assertTrue(bundle["skipLlm"])
        self.assertEqual(bundle["finalContextDocuments"], [expected_document])
        self.assertEqual(answer.get("referencedPdf"), expected_document)
        self.assertEqual(answer.get("sourceSection"), expected_section)
        self.assertEqual(answer.get("sourcePages"), expected_pages)
        self.assertIn("Answer:\n", direct_answer)
        self.assertIn("\nDetails:\n", direct_answer)
        self.assertIn("\nSource:\n", direct_answer)
        for phrase in required_phrases:
            self.assertIn(phrase, direct_answer)
        for phrase in forbidden_phrases:
            self.assertNotIn(phrase, direct_answer)
        self.assertEqual(
            {
                str(item.get("documentName", "")).strip()
                for item in bundle.get("retrieval", [])
                if str(item.get("documentName", "")).strip()
            },
            {expected_document},
        )
        top_result = bundle["retrieval"][0]
        self.assertEqual(str(top_result.get("documentName", "")).strip(), expected_document)
        self.assertTrue(
            bool(top_result.get("fieldExactMatch"))
            or bool(top_result.get("normalizedFieldExactMatch"))
            or bool(top_result.get("fieldCodeExactMatch"))
            or bool(top_result.get("headingExactMatch"))
        )
        if top_heading:
            self.assertEqual(str(top_result.get("heading", "")).strip(), top_heading)

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

    def test_exact_inp_transport_query_returns_only_transport_field_context(self) -> None:
        bundle = self._prepare_bundle(
            "inp:transport",
            current_document_name=self.INPDEC_DOCUMENT,
        )

        self._assert_exact_field_answer(
            bundle,
            expected_document=self.INPDEC_DOCUMENT,
            expected_section="8 MESSAGE DETAILS",
            expected_pages=[12],
            required_phrases=("inp:Transport", "Specify Transport details"),
            forbidden_phrases=("Header Section", "Summary Section", "Tariff Section"),
            top_heading="inp:Transport",
        )
        self.assertTrue(all(str(item.get("fieldCode", "")).strip().upper() not in {"B021", "B089"} for item in bundle["retrieval"]))

    def test_what_is_inp_transport_uses_exact_field_routing(self) -> None:
        bundle = self._prepare_bundle(
            "What is inp:transport?",
            current_document_name=self.INPDEC_DOCUMENT,
        )

        self._assert_exact_field_answer(
            bundle,
            expected_document=self.INPDEC_DOCUMENT,
            expected_section="8 MESSAGE DETAILS",
            expected_pages=[12],
            required_phrases=("inp:Transport", "Specify Transport details"),
            forbidden_phrases=("Header Section", "Summary Section", "Tariff Section"),
            top_heading="inp:Transport",
        )

    def test_exact_declaration_type_query_returns_allowed_codes(self) -> None:
        bundle = self._prepare_bundle(
            "cbc:Declaration Type",
            current_document_name=self.INPDEC_DOCUMENT,
        )

        self._assert_exact_field_answer(
            bundle,
            expected_document=self.INPDEC_DOCUMENT,
            expected_section="8 MESSAGE DETAILS",
            expected_pages=[9],
            required_phrases=("cbc:Declaration Type", "SFZ: Storage in FTZ", "APS: Approved Premises/Schemes"),
            forbidden_phrases=("Header Section", "Summary Section", "Tariff Section"),
            top_heading="cbc:Declaration Type",
        )
        self.assertIn("Allowed Values / Codes:", str(bundle["answer"].get("directAnswer", "")))

    def test_transport_field_question_in_inpdec_uses_exact_field_context(self) -> None:
        bundle = self._prepare_bundle(
            "What is the transport field in INPDEC?",
            current_document_name=self.INPDEC_DOCUMENT,
        )

        self._assert_exact_field_answer(
            bundle,
            expected_document=self.INPDEC_DOCUMENT,
            expected_section="8 MESSAGE DETAILS",
            expected_pages=[12],
            required_phrases=("inp:Transport", "Specify Transport details"),
            forbidden_phrases=("Header Section", "Summary Section", "Tariff Section"),
            top_heading="inp:Transport",
        )

    def test_exact_b076_query_prefers_field_code_match(self) -> None:
        bundle = self._prepare_bundle(
            "B076",
            current_document_name=self.INPDEC_DOCUMENT,
        )

        self._assert_exact_field_answer(
            bundle,
            expected_document=self.INPDEC_DOCUMENT,
            expected_section="7 Pipeline",
            expected_pages=[12],
            required_phrases=("B076 cbc:Conveyance Reference Number", "specify inward voyage number", "Specify ‘NA’"),
            forbidden_phrases=("Header Section", "Summary Section", "Tariff Section"),
        )
        self.assertTrue(bool(bundle["retrieval"][0].get("fieldCodeExactMatch")))

    def test_transport_field_follow_up_stays_in_selected_inpdec_document(self) -> None:
        bundle = self._prepare_bundle(
            "What is the transport field?",
            current_document_name=self.INPDEC_DOCUMENT,
        )

        self._assert_exact_field_answer(
            bundle,
            expected_document=self.INPDEC_DOCUMENT,
            expected_section="8 MESSAGE DETAILS",
            expected_pages=[12],
            required_phrases=("inp:Transport", "Specify Transport details"),
            forbidden_phrases=("TradeNetDeclaration.IPTDEC", "TradeNetDeclaration.TNPDEC", "DGFT", "HBP"),
        )

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

    def test_exact_inp_transport_retrieval(self) -> None:
        bundle = self._prepare_bundle("inp:transport", current_document_name=self.INPDEC_DOCUMENT)
        self.assertEqual(bundle["answer"].get("sourceSection"), "8 MESSAGE DETAILS")
        self.assertTrue(all(str(item.get("xmlTag", "")).strip() in {"", "inp:transport"} for item in bundle["retrieval"][:5]))

    def test_exact_inp_header_retrieval(self) -> None:
        bundle = self._prepare_bundle("inp:Header", current_document_name=self.INPDEC_DOCUMENT)
        self._assert_exact_field_answer(
            bundle,
            expected_document=self.INPDEC_DOCUMENT,
            expected_section="8 MESSAGE DETAILS",
            expected_pages=[9],
            required_phrases=("inp:Header", "B045"),
            forbidden_phrases=("Transport", "Customs Procedure Code"),
            top_heading="inp:Header",
        )

    def test_exact_b021_retrieval(self) -> None:
        bundle = self._prepare_bundle("B021", current_document_name=self.INPDEC_DOCUMENT)
        self._assert_exact_field_answer(
            bundle,
            expected_document=self.INPDEC_DOCUMENT,
            expected_section="8 MESSAGE DETAILS",
            expected_pages=[9],
            required_phrases=("B021 cbc:Declaration Type", "Specify Declaration Type"),
            forbidden_phrases=("Customs Procedure Code",),
        )

    def test_exact_b089_retrieval(self) -> None:
        bundle = self._prepare_bundle("B089", current_document_name=self.INPDEC_DOCUMENT)
        self._assert_exact_field_answer(
            bundle,
            expected_document=self.INPDEC_DOCUMENT,
            expected_section="8 MESSAGE DETAILS",
            expected_pages=[10],
            required_phrases=("B089 cbc:Customs Procedure Code", "Specify Customs Procedure Code"),
            forbidden_phrases=("Declaration Type",),
        )

    def test_case_insensitive_xml_tag_retrieval(self) -> None:
        bundle = self._prepare_bundle("INP:TRANSPORT", current_document_name=self.INPDEC_DOCUMENT)
        self.assertIn("inp:Transport", str(bundle["answer"].get("directAnswer", "")))
        self.assertEqual(bundle["answer"].get("referencedPdf"), self.INPDEC_DOCUMENT)

    def test_natural_language_xml_tag_retrieval(self) -> None:
        bundle = self._prepare_bundle("What is inp:transport?", current_document_name=self.INPDEC_DOCUMENT)
        self.assertIn("inp:Transport", str(bundle["answer"].get("directAnswer", "")))
        self.assertNotIn("B021", str(bundle["answer"].get("directAnswer", "")))
        self.assertNotIn("B089", str(bundle["answer"].get("directAnswer", "")))

    def test_transport_query_does_not_return_header(self) -> None:
        bundle = self._prepare_bundle("inp:transport", current_document_name=self.INPDEC_DOCUMENT)
        retrieval_titles = " ".join(str(item.get("title", "")) for item in bundle["retrieval"][:10])
        self.assertNotIn("HEADER SECTION", retrieval_titles.upper())

    def test_transport_query_does_not_return_declaration_type(self) -> None:
        bundle = self._prepare_bundle("inp:transport", current_document_name=self.INPDEC_DOCUMENT)
        joined_text = " ".join(str(item.get("text", "")) for item in bundle["retrieval"][:10])
        self.assertNotIn("B021", joined_text)
        self.assertNotIn("B089", joined_text)
        self.assertNotIn("Customs Procedure Code", joined_text)

    def test_missing_exact_tag_returns_not_found(self) -> None:
        bundle = self._prepare_bundle("inp:MissingTag", current_document_name=self.INPDEC_DOCUMENT)
        self.assertTrue(bundle["skipLlm"])
        self.assertEqual(str(bundle["answer"].get("directAnswer", "")), self.NOT_FOUND_MESSAGE)


if __name__ == "__main__":
    unittest.main()
