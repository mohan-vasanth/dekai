from __future__ import annotations

import unittest
from pathlib import Path

from parser.document_markdown_converter import DocumentMarkdownConverter
from parser.models import DocumentKnowledge, SectionKnowledge


def _section(*, tables: list[list[list[str]]], raw_text: str, required_documents: list[str] | None = None) -> SectionKnowledge:
    return SectionKnowledge(
        chapter_number="1",
        chapter_title="Standalone PDF",
        section="1",
        title="Packing list",
        purpose="",
        purpose_thanglish="",
        summary="",
        business_meaning="",
        business_explanation="",
        business_explanation_thanglish="",
        required_documents=required_documents or [],
        documents=required_documents or [],
        tables=tables,
        raw_text=raw_text,
        pages=[1],
        source_document="pdf-1.pdf",
    )


class DocumentMarkdownConverterTests(unittest.TestCase):
    def setUp(self) -> None:
        self.converter = DocumentMarkdownConverter()

    def test_renders_semantic_html_table_with_document_table_class(self) -> None:
        document = DocumentKnowledge(
            source_pdf=Path("table.pdf"),
            page_count=1,
            sections=[
                _section(
                    tables=[
                        [
                            ["Field", "Value"],
                            ["Customs Code", "8481209090"],
                            ["Country Of Origin", "PL"],
                        ]
                    ],
                    raw_text="Customs Code 8481209090",
                )
            ],
        )

        markdown = self.converter.convert_document(document)

        self.assertIn('<table class="document-table">', markdown)
        self.assertIn("<thead>", markdown)
        self.assertIn("<tbody>", markdown)
        self.assertIn("<th>Field</th>", markdown)
        self.assertIn("<td>8481209090</td>", markdown)

    def test_filters_flattened_table_text_from_required_documents_and_source_content(self) -> None:
        table = [
            ["Field", "Value"],
            ["Shipping method", "DHL Global Forwarding"],
            ["Box Description", "120x80x75"],
            ["Customer product code", "V50766"],
            ["Customs code", "8481805990"],
        ]
        raw_text = "\n".join(
            [
                "Packing list",
                "Shipping method DHL Global Forwarding",
                "Box Description 120x80x75",
                "Customer product code V50766",
                "Customs code 8481805990",
                "Please review shipment totals.",
            ]
        )
        required_documents = [
            "Shipping method DHL Global Forwarding\nCustomer product code V50766\nCustoms code 8481805990",
            "Commercial invoice",
        ]
        document = DocumentKnowledge(
            source_pdf=Path("table.pdf"),
            page_count=1,
            sections=[
                _section(
                    tables=[table],
                    raw_text=raw_text,
                    required_documents=required_documents,
                )
            ],
        )

        markdown = self.converter.convert_document(document)

        self.assertIn("Please review shipment totals.", markdown)
        self.assertIn("- Commercial invoice", markdown)
        self.assertNotIn("Shipping method DHL Global Forwarding", markdown)
        self.assertNotIn("Customer product code V50766", markdown)
        self.assertNotIn("Customs code 8481805990", markdown)

    def test_splits_sparse_continuation_table_into_metadata_and_line_items(self) -> None:
        sparse_table = [
            ["Shipped from:\nEmerson AFCP Poland Sp. z o.o.\nul. Konstruktorska 13\nWarszawa 02-673\nPOLAND\n+48 42 6892032", "", "Shipping method:\nDO Carrier: DHL Global Forwarding\nPrecarrier: LOGISTYKA\nShipment Tracking number: 1062875214", "", "", ""],
            ["Invoice to: (26FVO04980)\nEMERSON ASIA PACIFIC PRIVATE LIMITED\nSINGAPORE 569625\nSINGAPORE", "", "", "", "", ""],
            ["Order by:\nEMERSON ASIA PACIFIC PRIVATE LIMITED\nSINGAPORE 569625\nSINGAPORE", "", "", "", "", ""],
            ["BOX No : 212343402", "", "", "2.71", "", ""],
            ["NP264235\nCO26052528\\3", "Customer product code: V50766\nB316A303-008\nNFETXB316A303.110/DC.16137\nCustoms code: 8481805990 Country Of Origin: PL", "", "", "1.00", "0.00"],
        ]
        document = DocumentKnowledge(
            source_pdf=Path("table.pdf"),
            page_count=1,
            sections=[_section(tables=[sparse_table], raw_text="")],
        )

        markdown = self.converter.convert_document(document)

        self.assertIn("<th>Field</th>", markdown)
        self.assertIn("<td>Shipping method</td>", markdown)
        self.assertIn("DO Carrier: DHL Global Forwarding", markdown)
        self.assertIn("<th>Pallete/ Box<br />Your Order<br />Our Order</th>", markdown)
        self.assertIn("BOX No : 212343402<br />NP264235<br />CO26052528\\3", markdown)
        self.assertIn("Customer product code: V50766", markdown)
        self.assertIn("Customs code: 8481805990 Country Of Origin: PL", markdown)
        self.assertIn("<td>2.71</td>", markdown)
        self.assertIn("<td>1.00</td>", markdown)
        self.assertIn("<td>0.00</td>", markdown)


if __name__ == "__main__":
    unittest.main()
