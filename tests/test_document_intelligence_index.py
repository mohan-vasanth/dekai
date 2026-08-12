import unittest

from services.knowledge_engine import knowledge_engine_service
from services.retrieval_service import TRADE_NET_STRUCTURED_INTENT, analyze_question, retrieval_decision_service, rewrite_query
from services.search_service import search_service


class DocumentIntelligenceIndexTests(unittest.TestCase):
    INPDEC_DOCUMENT = "TradeNetDeclaration.INPDEC Ver2.1.pdf"

    @classmethod
    def setUpClass(cls) -> None:
        cls.index = knowledge_engine_service.load_index()

    def test_index_exposes_document_memory_collections_and_indexes(self) -> None:
        for key in (
            "documentMemories",
            "sectionMemories",
            "fieldMemories",
            "tableMemories",
            "ruleMemories",
            "definitionMemories",
            "exampleMemories",
            "relationshipMemories",
            "keywordMemories",
            "entityMemories",
            "synonymMemories",
            "indexes",
        ):
            self.assertIn(key, self.index)

        self.assertGreater(len(self.index["documentMemories"]), 0)
        self.assertGreater(len(self.index["sectionMemories"]), 0)
        self.assertGreater(len(self.index["fieldMemories"]), 0)
        self.assertGreater(len(self.index["tableMemories"]), 0)
        self.assertIsInstance(self.index["indexes"].get("fieldIndex"), dict)
        self.assertIsInstance(self.index["indexes"].get("tableIndex"), dict)
        self.assertIsInstance(self.index["indexes"].get("aliasIndex"), dict)
        self.assertIsInstance(self.index["indexes"].get("entityIndex"), dict)

    def test_search_records_include_field_table_and_example_types(self) -> None:
        record_types = {str(item.get("type", "")).strip().lower() for item in self.index.get("searchRecords", [])}
        self.assertIn("field", record_types)
        self.assertIn("table", record_types)
        self.assertIn("example", record_types)

    def test_query_rewrite_expands_transport_mode_lookup(self) -> None:
        analysis = analyze_question("What transport modes are available?")
        rewrites = rewrite_query("What transport modes are available?", analysis)

        self.assertIn("transport mode", rewrites)
        self.assertIn("transport", rewrites)
        self.assertIn("mode", rewrites)
        self.assertEqual(analysis.question_type, "LIST_REQUEST")

    def test_query_analysis_detects_document_code_and_exact_entity_for_count_request(self) -> None:
        analysis = analyze_question("How many declaration types are available in the OUTDEC declaration PDF? List them all.")

        self.assertEqual(analysis.question_type, "COUNT_REQUEST")
        self.assertIn("OUTDEC", analysis.document_codes)
        self.assertEqual(analysis.requested_entity, "declaration type")

    def test_query_analysis_detects_document_aliases_and_strips_prefix_from_entity(self) -> None:
        cases = (
            ("inp:Header", ("INPDEC",), "Header"),
            ("ipt transport mode", ("IPTDEC",), "transport mode"),
            ("Import Declaration header", ("INPDEC",), "header"),
            ("Certificate of Origin header", ("COODEC",), "header"),
            ("Handbook of Procedures chapter 2", ("HBP",), "chapter 2"),
            ("DGFT notification", ("DGFT",), "notification"),
        )

        for question, expected_codes, expected_entity in cases:
            analysis = analyze_question(question)
            self.assertEqual(analysis.document_codes, expected_codes)
            self.assertEqual(analysis.requested_entity, expected_entity)
            self.assertEqual(analysis.document_scope, "document")

    def test_transport_mode_list_routes_to_trade_net_structured_plan(self) -> None:
        plan = retrieval_decision_service.detect_intent("transport mode list")

        self.assertEqual(plan.intent, TRADE_NET_STRUCTURED_INTENT)
        self.assertIn("TradeNet", plan.knowledge_sources)
        self.assertIn("Message Specification", plan.knowledge_sources)

    def test_search_cache_and_query_rewrites_are_exposed_in_debug(self) -> None:
        filters = {self.INPDEC_DOCUMENT.lower()}

        results = search_service.retrieve(
            "What transport modes are available?",
            mode="keyword",
            limit=12,
            document_filters=filters,
        )
        debug = search_service.get_last_debug()

        self.assertGreater(len(results), 0)
        self.assertFalse(bool(debug.get("cacheHit")))
        self.assertIn("transport mode", debug.get("query_rewrites", []))

        cached_results = search_service.retrieve(
            "What transport modes are available?",
            mode="keyword",
            limit=12,
            document_filters=filters,
        )
        cached_debug = search_service.get_last_debug()

        self.assertEqual(len(cached_results), len(results))
        self.assertTrue(bool(cached_debug.get("cacheHit")))


if __name__ == "__main__":
    unittest.main()
