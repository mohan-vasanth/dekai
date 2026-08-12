import unittest

from services.chat_service import chat_service
from services.knowledge_engine import knowledge_engine_service
from services.retrieval_service import TRADE_NET_XML_FIELD_INTENT, retrieval_decision_service


class TradeNetXmlRoutingTests(unittest.TestCase):
    EXPECTED_SECTIONS = {
        "Explain ipt:Transport": "7 Pipeline",
        "Explain cac:ImporterParty": "7 Pipeline",
        "Explain cbc:TransportModeCode": "7 Pipeline",
        "Explain DeclarationTypeCode": "8 MESSAGE DETAILS",
        "Explain SupportingDocumentReference": "7 Pipeline",
    }

    @classmethod
    def setUpClass(cls) -> None:
        cls.index = knowledge_engine_service.load_index()
        ready_documents = chat_service._ready_documents(cls.index)
        trade_net_documents = chat_service._trade_net_ready_documents(ready_documents)
        if not trade_net_documents:
            raise AssertionError("Expected at least one ready TradeNet document in the knowledge base.")

        cls.trade_net_document_name = str(trade_net_documents[0]["name"])
        cls.section_pages = {
            f'{section.get("id", "")} {section.get("title", "")}'.strip(): list(section.get("sourcePages", []))
            for section in cls.index.get("sections", [])
            if str(section.get("documentName", "")).strip() == cls.trade_net_document_name
        }
        cls.query_results: dict[str, dict] = {}
        for query in cls.EXPECTED_SECTIONS:
            plan = retrieval_decision_service.detect_intent(query)
            retrieval, debug, locked_document_name = chat_service._retrieve_trade_net_field_grounding(
                query,
                plan,
                trade_net_document_names=[cls.trade_net_document_name],
                scope_label="trade_net_xml_field",
            )
            payload = chat_service._hierarchical_answer_payload(
                query,
                plan,
                cls.index.get("sections", []),
                allowed_document_names=[locked_document_name],
            )
            cls.query_results[query] = {
                "plan": plan,
                "retrieval": retrieval,
                "debug": debug,
                "locked_document_name": locked_document_name,
                "payload": payload,
            }

        cls.ipt_transport_bundle = chat_service._prepare_answer_bundle(
            "Explain ipt:Transport",
            ai_model="GPT-4.1",
            language="English",
            conversation_id="trade-net-test",
        )

    def assert_trade_net_route(self, query: str) -> None:
        result = self.query_results[query]
        plan = result["plan"]
        retrieval = result["retrieval"]
        debug = result["debug"]
        locked_document_name = result["locked_document_name"]
        payload = result["payload"]

        self.assertEqual(plan.intent, TRADE_NET_XML_FIELD_INTENT)
        self.assertEqual(plan.retrieval_engine, "trade_net_xml_field")
        self.assertEqual(tuple(plan.knowledge_sources), ("TradeNet",))
        self.assertEqual(debug.get("selected_retrieval_engine"), "trade_net_xml_field")
        self.assertEqual(locked_document_name, self.trade_net_document_name)
        self.assertIsNotNone(payload)

        section = payload["section"]
        section_label = f'{section.get("id", "")} {section.get("title", "")}'.strip()
        self.assertEqual(section_label, self.EXPECTED_SECTIONS[query])
        self.assertEqual(section.get("documentName"), self.trade_net_document_name)

        retrieval_documents = {
            str(item.get("documentName", "")).strip()
            for item in retrieval
            if str(item.get("documentName", "")).strip()
        }
        self.assertEqual(retrieval_documents, {self.trade_net_document_name})
        self.assertFalse(
            any(
                token in document_name.casefold()
                for document_name in retrieval_documents
                for token in ("dgft", "ftp", "hbp")
            )
        )

    def test_ipt_transport_routes_to_trade_net_pipeline(self) -> None:
        self.assert_trade_net_route("Explain ipt:Transport")

    def test_importer_party_routes_to_trade_net_pipeline(self) -> None:
        self.assert_trade_net_route("Explain cac:ImporterParty")

    def test_transport_mode_code_stays_inside_trade_net(self) -> None:
        self.assert_trade_net_route("Explain cbc:TransportModeCode")

    def test_declaration_type_code_routes_to_message_details(self) -> None:
        self.assert_trade_net_route("Explain DeclarationTypeCode")

    def test_supporting_document_reference_routes_to_trade_net_pipeline(self) -> None:
        self.assert_trade_net_route("Explain SupportingDocumentReference")

    def test_ipt_transport_bundle_metadata_stays_trade_net_only(self) -> None:
        bundle = self.ipt_transport_bundle
        answer = bundle["answer"]
        debug = bundle["searchDebug"]

        self.assertEqual(answer.get("detectedIntent"), TRADE_NET_XML_FIELD_INTENT)
        self.assertEqual(answer.get("knowledgeSourcesUsed"), ["TradeNet"])
        self.assertEqual(answer.get("referencedPdf"), self.trade_net_document_name)
        self.assertEqual(answer.get("sourceSection"), "8 MESSAGE DETAILS")
        self.assertEqual(answer.get("sourcePages"), [12])
        self.assertEqual(debug.get("selected_retrieval_engine"), "trade_net_xml_field")
        self.assertEqual(debug.get("selected_document"), self.trade_net_document_name)
        self.assertEqual(debug.get("selected_section"), "8 MESSAGE DETAILS")
        self.assertEqual(
            {
                str(item.get("documentName", "")).strip()
                for item in bundle.get("retrieval", [])
                if str(item.get("documentName", "")).strip()
            },
            {self.trade_net_document_name},
        )


if __name__ == "__main__":
    unittest.main()
