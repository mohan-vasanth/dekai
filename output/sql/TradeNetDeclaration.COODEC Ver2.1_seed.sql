INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.COODEC Ver2.1.pdf', '', 'TradeNetDeclaration.COODEC Ver2.1', '1', 'INTRODUCTION', 'COODEC
message to be used in Extensible Markup Language (XML) between trading partners involved in administration, commerce and
transport.', 'Indha INTRODUCTION section-la, COODEC
message to be used in Extensible Markup Language (XML) between trading partners involved in administration, commerce and
transport.', '1. INTRODUCTION
This specification provides the definition of the Trade Declaration and Application of Certificate of Origin ie. COODEC
message to be used in Extensible Markup Language (XML) between trading partners involved in administration, commerce and
transport.', 'INTRODUCTION governs how DGFT business controls should be applied, validated, and enforced.', 'INTRODUCTION explains the operating rule set that DEKAI should enforce. Key control points include This document shall be used as a baseline for the interface software design and shall be agreed upon by representative from
IE Singapore and Crimson Logic Pte Ltd.', 'Indha INTRODUCTION section-la, INTRODUCTION explains the operating rule set that DEKAI should enforce. Key control points include This document kandippa be used as a baseline for the interface software design and kandippa be agreed upon by representative from
IE Singapore and Crimson Logic Pte Ltd.', '1. INTRODUCTION
This specification provides the definition of the Trade Declaration and Application of Certificate of Origin ie. COODEC
message to be used in Extensible Markup Language (XML) between trading partners involved in administration, commerce and
transport.
This document shall be used as a baseline for the interface software design and shall be agreed upon by representative from
IE Singapore and Crimson Logic Pte Ltd.', '[2]', '["the", "and", "XML", "for", "Pte", "Ltd", "This", "used", "upon", "from", "Trade", "shall", "Logic", "Origin", "COODEC", "Markup", "design", "agreed", "message", "between"]', 'Provide knowledge guidance for INTRODUCTION.', '["1", "INTRODUCTION", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC1-R001', '1', 'This document shall be used as a baseline for the interface software design and shall be agreed upon by representative from
IE Singapore and Crimson Logic Pte Ltd.', 'business_rule', 'INTRODUCTION', 'INTRODUCTION
This specification provides the definition of the Trade Declaration and Application of Certificate of Origin ie.', 'This document shall be used as a baseline for the interface software design and shall be agreed upon by representative from
IE Singapore and Crimson Logic Pte Ltd.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 1 - INTRODUCTION.');
INSERT INTO conditions (section_code, condition_text) VALUES ('1', 'INTRODUCTION
This specification provides the definition of the Trade Declaration and Application of Certificate of Origin ie.');
INSERT INTO conditions (section_code, condition_text) VALUES ('1', 'This document shall be used as a baseline for the interface software design and shall be agreed upon by representative from
IE Singapore and Crimson Logic Pte Ltd.');
INSERT INTO documents (section_code, document_name) VALUES ('1', 'This specification provides the definition of the Trade Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('1', 'Application of Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('1', 'This document shall be used as a baseline for the interface software design and shall be agreed upon by representative from
IE Singapore and Crimson Logic Pte Ltd.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('1', 1, 'Evaluate condition: INTRODUCTION
This specification provides the definition of the Trade Declaration and Application of Certificate of Origin ie.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('1', 2, 'Evaluate condition: This document shall be used as a baseline for the interface software design and shall be agreed upon by representative from
IE Singapore and Crimson Logic Pte Ltd.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('1', 3, 'Run validation: This document shall be used as a baseline for the interface software design and shall be agreed upon by representative from
IE Singapore and Crimson Logic Pte Ltd.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'XML');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'Pte');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'Ltd');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'This');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'used');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'upon');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'from');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'Trade');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'shall');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'Logic');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'Origin');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'COODEC');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'Markup');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'design');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'agreed');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'message');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'between');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'tags', '1');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'tags', 'INTRODUCTION');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.COODEC Ver2.1.pdf', '', 'TradeNetDeclaration.COODEC Ver2.1', '2', 'SCOPE', 'SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to IESGP, CA or
Chambers.', 'Indha SCOPE section-la, SCOPE
The document kandippa provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to IESGP, CA or
Chambers.', '2. SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to IESGP, CA or
Chambers. - message format.', 'SCOPE governs how DGFT business controls should be applied, validated, and enforced.', 'SCOPE explains the operating rule set that DEKAI should enforce. Key control points include SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to IESGP, CA or
Chambers.', 'Indha SCOPE section-la, SCOPE explains the operating rule set that DEKAI should enforce. Key control points include SCOPE
The document kandippa provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to IESGP, CA or
Chambers.', '2. SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to IESGP, CA or
Chambers.
- message format.
The segments, composite data elements, data elements and codes used in this document are based on the respective directories
in the UN/EDIFACT D.09B Directory. Refer to references 5 to 16 for more details.
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
2. SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to IESGP, CA or
Chambers.
- message format.
The segments, composite data elements, data elements and codes used in this document are based on the respective directories
in the UN/EDIFACT D.09B Directory. Refer to references 5 to 16 for more details.
OFFICIAL (CLOSED)', '[2, 3]', '["The", "and", "for", "are", "Net", "doc", "XML", "Ver", "from", "data", "used", "this", "more", "Date", "SCOPE", "shall", "Cargo", "IESGP", "codes", "based"]', 'Provide knowledge guidance for SCOPE.', '["2", "SCOPE", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC2-R001', '2', 'SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to IESGP, CA or
Chambers.', 'business_rule', 'SCOPE', 'The segments, composite data elements, data elements and codes used in this document are based on the respective directories
in the UN/EDIFACT D.09B Directory.', 'SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to IESGP, CA or
Chambers.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 2 - SCOPE.');
INSERT INTO conditions (section_code, condition_text) VALUES ('2', 'The segments, composite data elements, data elements and codes used in this document are based on the respective directories
in the UN/EDIFACT D.09B Directory.');
INSERT INTO conditions (section_code, condition_text) VALUES ('2', 'Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO documents (section_code, document_name) VALUES ('2', 'SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to IESGP, CA or
Chambers.');
INSERT INTO documents (section_code, document_name) VALUES ('2', 'The segments, composite data elements, data elements and codes used in this document are based on the respective directories
in the UN/EDIFACT D.09B Directory.');
INSERT INTO documents (section_code, document_name) VALUES ('2', 'Trade Net Declaration');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('2', 1, 'Evaluate condition: The segments, composite data elements, data elements and codes used in this document are based on the respective directories
in the UN/EDIFACT D.09B Directory.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('2', 2, 'Evaluate condition: Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('2', 3, 'Run validation: SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to IESGP, CA or
Chambers.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'The');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'are');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'Net');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'doc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'XML');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'Ver');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'from');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'data');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'used');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'this');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'more');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'Date');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'SCOPE');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'shall');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'Cargo');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'IESGP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'codes');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'based');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'tags', '2');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'tags', 'SCOPE');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.COODEC Ver2.1.pdf', '', 'TradeNetDeclaration.COODEC Ver2.1', '3', 'FIELD OF APPLICATION', 'FIELD OF APPLICATION
The message specification provided in this document are intended for use for the exchange of information between the trading
partners in international trade.', 'Indha FIELD OF APPLICATION section-la, FIELD OF application
The message specification provided in this document are intended for use for the exchange of information between the trading
partners in international trade.', '3. FIELD OF APPLICATION
The message specification provided in this document are intended for use for the exchange of information between the trading
partners in international trade. This message may be applied for both national and international trade.', '3.', '3. FIELD OF APPLICATION
The message specification provided in this document are intended for use for the exchange of information between the trading
partners in international trade. This message may be applied for both national and international trade.', 'Indha FIELD OF APPLICATION section-la, 3. FIELD OF application
The message specification provided in this document are intended for use for the exchange of information between the trading
partners in international trade. This message may be applied for both national and international trade.', '3. FIELD OF APPLICATION
The message specification provided in this document are intended for use for the exchange of information between the trading
partners in international trade. This message may be applied for both national and international trade. It is based on
universal practice and is not dependent on the type of business or industry.', '[3]', '["The", "are", "for", "use", "may", "and", "not", "this", "both", "type", "FIELD", "trade", "based", "message", "between", "trading", "applied", "provided", "document", "intended"]', 'Provide knowledge guidance for FIELD OF APPLICATION.', '["3", "FIELD OF APPLICATION", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC3-R001', '3', '3. FIELD OF APPLICATION
The message specification provided in this document are intended for use for the exchange of information between the trading
partners in international trade. This message may be applied for both national and international trade.', 'business_rule', 'FIELD OF APPLICATION', 'FIELD OF APPLICATION
The message specification provided in this document are intended for use for the exchange of information between the trading
partners in international trade.', 'Not explicitly covered in uploaded documents.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 3 - FIELD OF APPLICATION.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'FIELD OF APPLICATION
The message specification provided in this document are intended for use for the exchange of information between the trading
partners in international trade.');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'FIELD OF APPLICATION
The message specification provided in this document are intended for use for the exchange of information between the trading
partners in international trade.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3', 1, 'Evaluate condition: FIELD OF APPLICATION
The message specification provided in this document are intended for use for the exchange of information between the trading
partners in international trade.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'The');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'are');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'use');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'may');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'not');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'this');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'both');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'type');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'FIELD');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'trade');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'based');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'message');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'between');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'trading');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'applied');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'provided');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'document');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'intended');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'tags', '3');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'tags', 'FIELD OF APPLICATION');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.COODEC Ver2.1.pdf', '', 'TradeNetDeclaration.COODEC Ver2.1', '3.1', 'Principles', '3.1 Principles
This message incorporates the necessary trade, transport, statistical and Applicant/Declarant information on the application
for Certificate of Origin and/or IESGP Outward Declaration.', 'Indha Principles section-la, 3.1 Principles
This message incorporates the necessary trade, transport, statistical and Applicant/Declarant information on the application
for Certificate of Origin and/or IESGP Outward Declaration.', '3.1 Principles
This message incorporates the necessary trade, transport, statistical and Applicant/Declarant information on the application
for Certificate of Origin and/or IESGP Outward Declaration. Provision has also been made for the inclusion of appropriate
commercial information which may be accepted by Issuing Authorities in lieu of supporting documentation. The design principles adopted allow for referencing one or more commercial documents pertaining to the same declaration and
for the grouping of document lines into a single trade item.', '3.1 Principles
This message incorporates the necessary trade, transport, statistical and Applicant/Declarant information on the application
for Certificate of Origin and/or IESGP Outward Declaration.', '3.1 Principles
This message incorporates the necessary trade, transport, statistical and Applicant/Declarant information on the application
for Certificate of Origin and/or IESGP Outward Declaration. Provision has also been made for the inclusion of appropriate
commercial information which may be accepted by Issuing Authorities in lieu of supporting documentation. The design principles adopted allow for referencing one or more commercial documents pertaining to the same declaration and
for the grouping of document lines into a single trade item.', 'Indha Principles section-la, 3.1 Principles
This message incorporates the necessary trade, transport, statistical and Applicant/Declarant information on the application
for Certificate of Origin and/or IESGP Outward Declaration. Provision has also been made for the inclusion of appropriate
commercial information which may be accepted by Issuing Authorities in lieu of supporting documentation. The design principles adopted allow for referencing one or more commercial documents pertaining to the same declaration and
for the grouping of document lines into a single trade item.', '3.1 Principles
This message incorporates the necessary trade, transport, statistical and Applicant/Declarant information on the application
for Certificate of Origin and/or IESGP Outward Declaration. Provision has also been made for the inclusion of appropriate
commercial information which may be accepted by Issuing Authorities in lieu of supporting documentation.
The design principles adopted allow for referencing one or more commercial documents pertaining to the same declaration and
for the grouping of document lines into a single trade item. A trade item consists of the grouping of those documents lines
having the same customs characteristics (eg. tariff number, declared use etc). The message correspondingly permits the use of
single or multi-packaging concepts and their identification to a trade item.
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
3.1 Principles
This message incorporates the necessary trade, transport, statistical and Applicant/Declarant information on the application
for Certificate of Origin and/or IESGP Outward Declaration. Provision has also been made for the inclusion of appropriate
commercial information which may be accepted by Issuing Authorities in lieu of supporting documentation.
The design principles adopted allow for referencing one or more commercial documents pertaining to the same declaration and
for the grouping of document lines into a single trade item. A trade item consists of the grouping of those documents lines
having the same customs characteristics (eg. tariff number, declared use etc). The message correspondingly permits the use of
single or multi-packaging concepts and their identification to a trade item.
OFFICIAL (CLOSED)', '[3, 4]', '["the", "and", "for", "has", "may", "one", "use", "etc", "Net", "doc", "XML", "Ver", "This", "also", "been", "made", "lieu", "more", "same", "into"]', 'Provide knowledge guidance for Principles.', '["3.1", "Principles", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC3_1-R001', '3.1', '3.1 Principles
This message incorporates the necessary trade, transport, statistical and Applicant/Declarant information on the application
for Certificate of Origin and/or IESGP Outward Declaration. Provision has also been made for the inclusion of appropriate
commercial information which may be accepted by Issuing Authorities in lieu of supporting documentation. The design principles adopted allow for referencing one or more commercial documents pertaining to the same declaration and
for the grouping of document lines into a single trade item.', 'business_rule', 'Principles', '3.1 Principles
This message incorporates the necessary trade, transport, statistical and Applicant/Declarant information on the application
for Certificate of Origin and/or IESGP Outward Declaration.', 'Provision has also been made for the inclusion of appropriate
commercial information which may be accepted by Issuing Authorities in lieu of supporting documentation.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 3.1 - Principles.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3.1', '3.1 Principles
This message incorporates the necessary trade, transport, statistical and Applicant/Declarant information on the application
for Certificate of Origin and/or IESGP Outward Declaration.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3.1', 'tariff number, declared use etc).');
INSERT INTO conditions (section_code, condition_text) VALUES ('3.1', 'The message correspondingly permits the use of
single or multi-packaging concepts and their identification to a trade item.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3.1', 'Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3.1', 'TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
3.1 Principles
This message incorporates the necessary trade, transport, statistical and Applicant/Declarant information on the application
for Certificate of Origin and/or IESGP Outward Declaration.');
INSERT INTO documents (section_code, document_name) VALUES ('3.1', 'Certificate of Origin and/or IESGP Outward Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('3.1', 'Provision has also been made for the inclusion of appropriate
commercial information which may be accepted by Issuing Authorities in lieu of supporting documentation.');
INSERT INTO documents (section_code, document_name) VALUES ('3.1', 'The design principles adopted allow for referencing one or more commercial documents pertaining to the same declaration and
for the grouping of document lines into a single trade item.');
INSERT INTO documents (section_code, document_name) VALUES ('3.1', 'A trade item consists of the grouping of those documents lines
having the same customs characteristics (eg.');
INSERT INTO documents (section_code, document_name) VALUES ('3.1', 'Trade Net Declaration');
INSERT INTO authorities (section_code, authority_name) VALUES ('3.1', 'Issuing Authorities');
INSERT INTO authorities (section_code, authority_name) VALUES ('3.1', 'customs');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3.1', 1, 'Evaluate condition: 3.1 Principles
This message incorporates the necessary trade, transport, statistical and Applicant/Declarant information on the application
for Certificate of Origin and/or IESGP Outward Declaration.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3.1', 2, 'Evaluate condition: tariff number, declared use etc).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3.1', 3, 'Evaluate condition: The message correspondingly permits the use of
single or multi-packaging concepts and their identification to a trade item.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3.1', 4, 'Run validation: Provision has also been made for the inclusion of appropriate
commercial information which may be accepted by Issuing Authorities in lieu of supporting documentation.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'has');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'may');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'one');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'use');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'etc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'Net');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'doc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'XML');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'Ver');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'This');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'also');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'been');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'made');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'lieu');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'more');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'same');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'into');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'tags', '3.1');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'tags', 'Principles');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.COODEC Ver2.1.pdf', '', 'TradeNetDeclaration.COODEC Ver2.1', '4', 'REFERENCES', '9, ECE/TRADE/203 1 Jan 96
Alphabetic Code for the Representation of Currencies
9 UN/ECE WP Trade Facilitation Recommendation No.', 'Indha REFERENCES section-la, 9, ECE/TRADE/203 1 Jan 96
Alphabetic Code for the Representation of Currencies
9 UN/ECE WP Trade Facilitation Recommendation No.', '4. REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and Application of Certificate of Origin 0.1
(TCODEC) message
2 TCODEC (COODCI) message specification TDS41-MDS-XML-COODCI-M
3 APERAK (STATUS) message specification TDS41-MDS-XML-STATUSA-M
4 APERAK (ERRORM) message specification TDS41-MDS-XML-ERRORM-M
5 Trade Net Declaration message specification TDS41-MDS-XML-DECLARATION-
TX
6 Trade Net Response message specification TDS41-MDS-XML-RESPONSE-TX
7 UN/CEFACT XML Naming and Design Rules Naming And Design Rules_2.0.d
oc
8 UN/ECE WP Trade Facilitation Recommendation No. 9, ECE/TRADE/203 1 Jan 96
Alphabetic Code for the Representation of Currencies
9 UN/ECE WP Trade Facilitation Recommendation No.', '4.', '4. REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and Application of Certificate of Origin 0.1
(TCODEC) message
2 TCODEC (COODCI) message specification TDS41-MDS-XML-COODCI-M
3 APERAK (STATUS) message specification TDS41-MDS-XML-STATUSA-M
4 APERAK (ERRORM) message specification TDS41-MDS-XML-ERRORM-M
5 Trade Net Declaration message specification TDS41-MDS-XML-DECLARATION-
TX
6 Trade Net Response message specification TDS41-MDS-XML-RESPONSE-TX
7 UN/CEFACT XML Naming and Design Rules Naming And Design Rules_2.0.d
oc
8 UN/ECE WP Trade Facilitation Recommendation No. 9, ECE/TRADE/203 1 Jan 96
Alphabetic Code for the Representation of Currencies
9 UN/ECE WP Trade Facilitation Recommendation No.', 'Indha REFERENCES section-la, 4. REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and application of Certificate of Origin 0.1
(TCODEC) message
2 TCODEC (COODCI) message specification TDS41-MDS-XML-COODCI-M
3 APERAK (STATUS) message specification TDS41-MDS-XML-STATUSA-M
4 APERAK (ERRORM) message specification TDS41-MDS-XML-ERRORM-M
5 Trade Net Declaration message specification TDS41-MDS-XML-DECLARATION-
TX
6 Trade Net Response message specification TDS41-MDS-XML-RESPONSE-TX
7 UN/CEFACT XML Naming and Design Rules Naming And Design Rules_2.0.d
oc
8 UN/ECE WP Trade Facilitation Recommendation No. 9, ECE/TRADE/203 1 Jan 96
Alphabetic Code for the Representation of Currencies
9 UN/ECE WP Trade Facilitation Recommendation No.', '4. REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and Application of Certificate of Origin 0.1
(TCODEC) message
2 TCODEC (COODCI) message specification TDS41-MDS-XML-COODCI-M
3 APERAK (STATUS) message specification TDS41-MDS-XML-STATUSA-M
4 APERAK (ERRORM) message specification TDS41-MDS-XML-ERRORM-M
5 Trade Net Declaration message specification TDS41-MDS-XML-DECLARATION-
TX
6 Trade Net Response message specification TDS41-MDS-XML-RESPONSE-TX
7 UN/CEFACT XML Naming and Design Rules Naming And Design Rules_2.0.d
oc
8 UN/ECE WP Trade Facilitation Recommendation No. 9, ECE/TRADE/203 1 Jan 96
Alphabetic Code for the Representation of Currencies
9 UN/ECE WP Trade Facilitation Recommendation No. 16, ECE/TRADE/227 Dec 98
UN/LOCODE - Code for the Trade and Transport Locations
10 UN/ECE WP Trade Facilitation Recommendation No. 19, Code TRADE/CEFACT/2001/19 15 Jan 01
for modes of transport
11 UN/ECE WP Trade Facilitation Recommendation No. 20, Codes CEFACT/ICG/2010/IC013 13 Sep 10
for Units of Measure Used in International Trade
12 Codes for Units of Measure Used in International Trade CEFACT/ICG/2010/IC013 13 Sep 10
Annex B: Code elements listed by Quantity Annex I
13 Codes for Units of Measure Used in International Trade CEFACT/ICG/2010/IC013 13 Sep 10
Annex C: Code elements listed by common code & name Annex II & Annex III
14 STDID Code Lists STDID-TDS41-COD
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
| S/ | | Document Name | | Document/Directory | | Rev | Date
| N | | | | Reference | | |
1 | | | Trade Declaration and Application of Certificate of Origin
(TCODEC) message | 0.1 | | | |
2 | | | TCODEC (COODCI) message specification | TDS41-MDS-XML-COODCI-M | | | |
3 | | | APERAK (STATUS) message specification | TDS41-MDS-XML-STATUSA-M | | | |
4 | | | APERAK (ERRORM) message specification | TDS41-MDS-XML-ERRORM-M | | | |
5 | | | Trade Net Declaration message specification | TDS41-MDS-XML-DECLARATION-
TX | | | |
6 | | | Trade Net Response message specification | TDS41-MDS-XML-RESPONSE-TX | | | |
7 | | | UN/CEFACT XML Naming and Design Rules | Naming And Design Rules_2.0.d
oc | | | |
8 | | | UN/ECE WP Trade Facilitation Recommendation No. 9,
Alphabetic Code for the Representation of Currencies | ECE/TRADE/203 | | | | 1 Jan 96
9 | | | UN/ECE WP Trade Facilitation Recommendation No. 16,
UN/LOCODE - Code for the Trade and Transport Locations | ECE/TRADE/227 | | | | Dec 98
10 | | | UN/ECE WP Trade Facilitation Recommendation No. 19, Code
for modes of transport | TRADE/CEFACT/2001/19 | | | | 15 Jan 01
11 | | | UN/ECE WP Trade Facilitation Recommendation No. 20, Codes
for Units of Measure Used in International Trade | CEFACT/ICG/2010/IC013 | | | | 13 Sep 10
12 | | | Codes for Units of Measure Used in International Trade
Annex B: Code elements listed by Quantity | CEFACT/ICG/2010/IC013
Annex I | | | | 13 Sep 10
13 | | | Codes for Units of Measure Used in International Trade
Annex C: Code elements listed by common code & name | CEFACT/ICG/2010/IC013
Annex II & Annex III | | | | 13 Sep 10
14 | | | STDID Code Lists | STDID-TDS41-COD | | | |
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
4. REFERENCES
S/
N
Document Name
Document/Directory
Reference
Rev
Date
1
Trade Declaration and Application of Certificate of Origin
(TCODEC) message
0.1
2
TCODEC (COODCI) message specification
TDS41-MDS-XML-COODCI-M
3
APERAK (STATUS) message specification
TDS41-MDS-XML-STATUSA-M
4
APERAK (ERRORM) message specification
TDS41-MDS-XML-ERRORM-M
5
Trade Net Declaration message specification
TDS41-MDS-XML-DECLARATION-
TX
6
Trade Net Response message specification
TDS41-MDS-XML-RESPONSE-TX
7
UN/CEFACT XML Naming and Design Rules
Naming And Design Rules_2.0.d
oc
8
UN/ECE WP Trade Facilitation Recommendation No. 9,
Alphabetic Code for the Representation of Currencies
ECE/TRADE/203
1 Jan 96
9
UN/ECE WP Trade Facilitation Recommendation No. 16,
UN/LOCODE - Code for the Trade and Transport Locations
ECE/TRADE/227
Dec 98
10
UN/ECE WP Trade Facilitation Recommendation No. 19, Code
for modes of transport
TRADE/CEFACT/2001/19
15 Jan 01
11
UN/ECE WP Trade Facilitation Recommendation No. 20, Codes
for Units of Measure Used in International Trade
CEFACT/ICG/2010/IC013
13 Sep 10
12
Codes for Units of Measure Used in International Trade
Annex B: Code elements listed by Quantity
CEFACT/ICG/2010/IC013
Annex I
13 Sep 10
13
Codes for Units of Measure Used in International Trade
Annex C: Code elements listed by common code & name
CEFACT/ICG/2010/IC013
Annex II & Annex III
13 Sep 10
14
STDID Code Lists
STDID-TDS41-COD
OFFICIAL (CLOSED)', '[4, 5]', '["Rev", "and", "Net", "XML", "Jan", "for", "the", "Dec", "Sep", "III", "COD", "doc", "Ver", "Name", "Date", "Code", "Used", "Trade", "Rules", "modes"]', 'Provide knowledge guidance for REFERENCES.', '["4", "REFERENCES", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC4-R001', '4', '4. REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and Application of Certificate of Origin 0.1
(TCODEC) message
2 TCODEC (COODCI) message specification TDS41-MDS-XML-COODCI-M
3 APERAK (STATUS) message specification TDS41-MDS-XML-STATUSA-M
4 APERAK (ERRORM) message specification TDS41-MDS-XML-ERRORM-M
5 Trade Net Declaration message specification TDS41-MDS-XML-DECLARATION-
TX
6 Trade Net Response message specification TDS41-MDS-XML-RESPONSE-TX
7 UN/CEFACT XML Naming and Design Rules Naming And Design Rules_2.0.d
oc
8 UN/ECE WP Trade Facilitation Recommendation No. 9, ECE/TRADE/203 1 Jan 96
Alphabetic Code for the Representation of Currencies
9 UN/ECE WP Trade Facilitation Recommendation No.', 'business_rule', 'REFERENCES', 'REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and Application of Certificate of Origin 0.1
(TCODEC) message
2 TCODEC (COODCI) message specification TDS41-MDS-XML-COODCI-M
3 APERAK (STATUS) message specification TDS41-MDS-XML-STATUSA-M
4 APERAK (ERRORM) message specification TDS41-MDS-XML-ERRORM-M
5 Trade Net Declaration message specification TDS41-MDS-XML-DECLARATION-
TX
6 Trade Net Response message specification TDS41-MDS-XML-RESPONSE-TX
7 UN/CEFACT XML Naming and Design Rules Naming And Design Rules_2.0.d
oc
8 UN/ECE WP Trade Facilitation Recommendation No.', 'Not explicitly covered in uploaded documents.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 4 - REFERENCES.');
INSERT INTO conditions (section_code, condition_text) VALUES ('4', 'REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and Application of Certificate of Origin 0.1
(TCODEC) message
2 TCODEC (COODCI) message specification TDS41-MDS-XML-COODCI-M
3 APERAK (STATUS) message specification TDS41-MDS-XML-STATUSA-M
4 APERAK (ERRORM) message specification TDS41-MDS-XML-ERRORM-M
5 Trade Net Declaration message specification TDS41-MDS-XML-DECLARATION-
TX
6 Trade Net Response message specification TDS41-MDS-XML-RESPONSE-TX
7 UN/CEFACT XML Naming and Design Rules Naming And Design Rules_2.0.d
oc
8 UN/ECE WP Trade Facilitation Recommendation No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('4', '20, Codes CEFACT/ICG/2010/IC013 13 Sep 10
for Units of Measure Used in International Trade
12 Codes for Units of Measure Used in International Trade CEFACT/ICG/2010/IC013 13 Sep 10
Annex B: Code elements listed by Quantity Annex I
13 Codes for Units of Measure Used in International Trade CEFACT/ICG/2010/IC013 13 Sep 10
Annex C: Code elements listed by common code & name Annex II & Annex III
14 STDID Code Lists STDID-TDS41-COD
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
| S/ | | Document Name | | Document/Directory | | Rev | Date
| N | | | | Reference | | |
1 | | | Trade Declaration and Application of Certificate of Origin
(TCODEC) message | 0.1 | | | |
2 | | | TCODEC (COODCI) message specification | TDS41-MDS-XML-COODCI-M | | | |
3 | | | APERAK (STATUS) message specification | TDS41-MDS-XML-STATUSA-M | | | |
4 | | | APERAK (ERRORM) message specification | TDS41-MDS-XML-ERRORM-M | | | |
5 | | | Trade Net Declaration message specification | TDS41-MDS-XML-DECLARATION-
TX | | | |
6 | | | Trade Net Response message specification | TDS41-MDS-XML-RESPONSE-TX | | | |
7 | | | UN/CEFACT XML Naming and Design Rules | Naming And Design Rules_2.0.d
oc | | | |
8 | | | UN/ECE WP Trade Facilitation Recommendation No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('4', 'REFERENCES
S/
N
Document Name
Document/Directory
Reference
Rev
Date
1
Trade Declaration and Application of Certificate of Origin
(TCODEC) message
0.1
2
TCODEC (COODCI) message specification
TDS41-MDS-XML-COODCI-M
3
APERAK (STATUS) message specification
TDS41-MDS-XML-STATUSA-M
4
APERAK (ERRORM) message specification
TDS41-MDS-XML-ERRORM-M
5
Trade Net Declaration message specification
TDS41-MDS-XML-DECLARATION-
TX
6
Trade Net Response message specification
TDS41-MDS-XML-RESPONSE-TX
7
UN/CEFACT XML Naming and Design Rules
Naming And Design Rules_2.0.d
oc
8
UN/ECE WP Trade Facilitation Recommendation No.');
INSERT INTO documents (section_code, document_name) VALUES ('4', 'S/ Document Name Document');
INSERT INTO documents (section_code, document_name) VALUES ('4', 'Trade Declaration and Application of Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('4', 'Trade Net Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('4', '20, Codes
for Units of Measure Used in International Trade | CEFACT/ICG/2010/IC013 | | | | 13 Sep 10
12 | | | Codes for Units of Measure Used in International Trade
Annex B: Code elements listed by Quantity | CEFACT/ICG/2010/IC013
Annex I | | | | 13 Sep 10
13 | | | Codes for Units of Measure Used in International Trade
Annex C: Code elements listed by common code & name | CEFACT/ICG/2010/IC013
Annex II & Annex III | | | | 13 Sep 10
14 | | | STDID Code Lists | STDID-TDS41-COD | | | |
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('4', 1, 'Evaluate condition: REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and Application of Certificate of Origin 0.1
(TCODEC) message
2 TCODEC (COODCI) message specification TDS41-MDS-XML-COODCI-M
3 APERAK (STATUS) message specification TDS41-MDS-XML-STATUSA-M
4 APERAK (ERRORM) message specification TDS41-MDS-XML-ERRORM-M
5 Trade Net Declaration message specification TDS41-MDS-XML-DECLARATION-
TX
6 Trade Net Response message specification TDS41-MDS-XML-RESPONSE-TX
7 UN/CEFACT XML Naming and Design Rules Naming And Design Rules_2.0.d
oc
8 UN/ECE WP Trade Facilitation Recommendation No.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('4', 2, 'Evaluate condition: 20, Codes CEFACT/ICG/2010/IC013 13 Sep 10
for Units of Measure Used in International Trade
12 Codes for Units of Measure Used in International Trade CEFACT/ICG/2010/IC013 13 Sep 10
Annex B: Code elements listed by Quantity Annex I
13 Codes for Units of Measure Used in International Trade CEFACT/ICG/2010/IC013 13 Sep 10
Annex C: Code elements listed by common code & name Annex II & Annex III
14 STDID Code Lists STDID-TDS41-COD
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
| S/ | | Document Name | | Document/Directory | | Rev | Date
| N | | | | Reference | | |
1 | | | Trade Declaration and Application of Certificate of Origin
(TCODEC) message | 0.1 | | | |
2 | | | TCODEC (COODCI) message specification | TDS41-MDS-XML-COODCI-M | | | |
3 | | | APERAK (STATUS) message specification | TDS41-MDS-XML-STATUSA-M | | | |
4 | | | APERAK (ERRORM) message specification | TDS41-MDS-XML-ERRORM-M | | | |
5 | | | Trade Net Declaration message specification | TDS41-MDS-XML-DECLARATION-
TX | | | |
6 | | | Trade Net Response message specification | TDS41-MDS-XML-RESPONSE-TX | | | |
7 | | | UN/CEFACT XML Naming and Design Rules | Naming And Design Rules_2.0.d
oc | | | |
8 | | | UN/ECE WP Trade Facilitation Recommendation No.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('4', 3, 'Evaluate condition: REFERENCES
S/
N
Document Name
Document/Directory
Reference
Rev
Date
1
Trade Declaration and Application of Certificate of Origin
(TCODEC) message
0.1
2
TCODEC (COODCI) message specification
TDS41-MDS-XML-COODCI-M
3
APERAK (STATUS) message specification
TDS41-MDS-XML-STATUSA-M
4
APERAK (ERRORM) message specification
TDS41-MDS-XML-ERRORM-M
5
Trade Net Declaration message specification
TDS41-MDS-XML-DECLARATION-
TX
6
Trade Net Response message specification
TDS41-MDS-XML-RESPONSE-TX
7
UN/CEFACT XML Naming and Design Rules
Naming And Design Rules_2.0.d
oc
8
UN/ECE WP Trade Facilitation Recommendation No.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Rev');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Net');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'XML');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Jan');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Dec');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Sep');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'III');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'COD');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'doc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Ver');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Name');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Date');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Code');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Used');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Trade');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Rules');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'modes');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'tags', '4');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'tags', 'REFERENCES');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.COODEC Ver2.1.pdf', '', 'TradeNetDeclaration.COODEC Ver2.1', '5', 'DEFINITIONS AND ABBREVIATIONS', 'Defines the operational requirements for DEFINITIONS AND ABBREVIATIONS.', 'Indha DEFINITIONS AND ABBREVIATIONS section-la, Defines the operational requirements for DEFINITIONS AND ABBREVIATIONS.', '5. DEFINITIONS AND ABBREVIATIONS', '5.', '5. DEFINITIONS AND ABBREVIATIONS', 'Indha DEFINITIONS AND ABBREVIATIONS section-la, 5. DEFINITIONS AND ABBREVIATIONS', '5. DEFINITIONS AND ABBREVIATIONS', '[5]', '["AND", "DEFINITIONS", "ABBREVIATIONS"]', 'Provide knowledge guidance for DEFINITIONS AND ABBREVIATIONS.', '["5", "DEFINITIONS AND ABBREVIATIONS", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC5-R001', '5', '5. DEFINITIONS AND ABBREVIATIONS', 'business_rule', 'DEFINITIONS AND ABBREVIATIONS', 'Not explicitly covered in uploaded documents.', 'Not explicitly covered in uploaded documents.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5 - DEFINITIONS AND ABBREVIATIONS.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5', 1, 'Review section 5 requirements');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5', 2, 'Capture applicant inputs');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5', 3, 'Route for authority decision');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5', 'keywords', 'AND');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5', 'keywords', 'DEFINITIONS');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5', 'keywords', 'ABBREVIATIONS');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5', 'tags', '5');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5', 'tags', 'DEFINITIONS AND ABBREVIATIONS');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.COODEC Ver2.1.pdf', '', 'TradeNetDeclaration.COODEC Ver2.1', '5.1', 'Abbreviations', '5.1 Abbreviations
APERAK Application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic Data Interchange
ERRORM Error Message
GST Goods and Services Tax
IESGP/IE Singapore International Enterprise Singapore Board
COODEC Application of Certificate of Origin
COODCI Issue of Certificate of Origin
MDS Message Design Specifications
Crimsonlogic Crimson Logic Pte Ltd
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
TCODEC Trade Certificate of Origin Declaration
UNSM United Nation Standard Message
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', 'Indha Abbreviations section-la, 5.1 Abbreviations
APERAK application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic Data Interchange
ERRORM Error Message
GST Goods and Services Tax
IESGP/IE Singapore International Enterprise Singapore Board
COODEC application of Certificate of Origin
COODCI Issue of Certificate of Origin
MDS Message Design Specifications
Crimsonlogic Crimson Logic Pte Ltd
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
TCODEC Trade Certificate of Origin Declaration
UNSM United Nation Standard Message
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', '5.1 Abbreviations
APERAK Application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic Data Interchange
ERRORM Error Message
GST Goods and Services Tax
IESGP/IE Singapore International Enterprise Singapore Board
COODEC Application of Certificate of Origin
COODCI Issue of Certificate of Origin
MDS Message Design Specifications
Crimsonlogic Crimson Logic Pte Ltd
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
TCODEC Trade Certificate of Origin Declaration
UNSM United Nation Standard Message
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id. TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
5.1 Abbreviations
APERAK
Application Error and Acknowledgement
CA
Controlling Agency
CO
Certificate of Origin
DE
Data Element
EDI
Electronic Data Interchange
ERRORM
Error Message
GST
Goods and Services Tax
IESGP/IE Singapore
International Enterprise Singapore Board
COODEC
Application of Certificate of Origin
COODCI
Issue of Certificate of Origin
MDS
Message Design Specifications
Crimsonlogic
SC
Singapore Customs
STDID
Singapore Trade Data Interchange Directory
TCODEC
Trade Certificate of Origin Declaration
UNSM
United Nation Standard Message
OFFICIAL (CLOSED)', '5.1 Abbreviations
APERAK Application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic Data Interchange
ERRORM Error Message
GST Goods and Services Tax
IESGP/IE Singapore International Enterprise Singapore Board
COODEC Application of Certificate of Origin
COODCI Issue of Certificate of Origin
MDS Message Design Specifications
Crimsonlogic Crimson Logic Pte Ltd
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
TCODEC Trade Certificate of Origin Declaration
UNSM United Nation Standard Message
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', '5.1 Abbreviations
APERAK Application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic Data Interchange
ERRORM Error Message
GST Goods and Services Tax
IESGP/IE Singapore International Enterprise Singapore Board
COODEC Application of Certificate of Origin
COODCI Issue of Certificate of Origin
MDS Message Design Specifications
Crimsonlogic Crimson Logic Pte Ltd
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
TCODEC Trade Certificate of Origin Declaration
UNSM United Nation Standard Message
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id. TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
5.1 Abbreviations
APERAK
Application Error and Acknowledgement
CA
Controlling Agency
CO
Certificate of Origin
DE
Data Element
EDI
Electronic Data Interchange
ERRORM
Error Message
GST
Goods and Services Tax
IESGP/IE Singapore
International Enterprise Singapore Board
COODEC
Application of Certificate of Origin
COODCI
Issue of Certificate of Origin
MDS
Message Design Specifications
Crimsonlogic
SC
Singapore Customs
STDID
Singapore Trade Data Interchange Directory
TCODEC
Trade Certificate of Origin Declaration
UNSM
United Nation Standard Message
OFFICIAL (CLOSED)', 'Indha Abbreviations section-la, 5.1 Abbreviations
APERAK application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic Data Interchange
ERRORM Error Message
GST Goods and Services Tax
IESGP/IE Singapore International Enterprise Singapore Board
COODEC application of Certificate of Origin
COODCI Issue of Certificate of Origin
MDS Message Design Specifications
Crimsonlogic Crimson Logic Pte Ltd
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
TCODEC Trade Certificate of Origin Declaration
UNSM United Nation Standard Message
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id. TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
5.1 Abbreviations
APERAK
application Error and Acknowledgement
CA
Controlling Agency
CO
Certificate of Origin
DE
Data Element
EDI
Electronic Data Interchange
ERRORM
Error Message
GST
Goods and Services Tax
IESGP/IE Singapore
International Enterprise Singapore Board
COODEC
application of Certificate of Origin
COODCI
Issue of Certificate of Origin
MDS
Message Design Specifications
Crimsonlogic
SC
Singapore Customs
STDID
Singapore Trade Data Interchange Directory
TCODEC
Trade Certificate of Origin Declaration
UNSM
United Nation Standard Message
OFFICIAL (CLOSED)', '5.1 Abbreviations
APERAK Application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic Data Interchange
ERRORM Error Message
GST Goods and Services Tax
IESGP/IE Singapore International Enterprise Singapore Board
COODEC Application of Certificate of Origin
COODCI Issue of Certificate of Origin
MDS Message Design Specifications
Crimsonlogic Crimson Logic Pte Ltd
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
TCODEC Trade Certificate of Origin Declaration
UNSM United Nation Standard Message
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
5.1 Abbreviations
APERAK
Application Error and Acknowledgement
CA
Controlling Agency
CO
Certificate of Origin
DE
Data Element
EDI
Electronic Data Interchange
ERRORM
Error Message
GST
Goods and Services Tax
IESGP/IE Singapore
International Enterprise Singapore Board
COODEC
Application of Certificate of Origin
COODCI
Issue of Certificate of Origin
MDS
Message Design Specifications
Crimsonlogic
SC
Singapore Customs
STDID
Singapore Trade Data Interchange Directory
TCODEC
Trade Certificate of Origin Declaration
UNSM
United Nation Standard Message
OFFICIAL (CLOSED)', '[5, 6]', '["and", "EDI", "GST", "Tax", "MDS", "Pte", "Ltd", "Net", "doc", "XML", "For", "Ver", "Data", "UNSM", "Date", "Error", "Goods", "Board", "Issue", "Logic"]', 'Support Abbreviations processing and compliance validation.', '["5.1", "Abbreviations", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC5_1-R001', '5.1', 'IF validations pass THEN recommend action: 5.1 Abbreviations
APERAK Application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic Data Interchange
ERRORM Error Message
GST Goods and Services Tax
IESGP/IE Singapore International Enterprise Singapore Board
COODEC Application of Certificate of Origin
COODCI Issue of Certificate of Origin
MDS Message Design Specifications
Crimsonlogic Crimson Logic Pte Ltd
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
TCODEC Trade Certificate of Origin Declaration
UNSM United Nation Standard Message
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', 'business_rule', 'Abbreviations', '5.1 Abbreviations
APERAK Application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic Data Interchange
ERRORM Error Message
GST Goods and Services Tax
IESGP/IE Singapore International Enterprise Singapore Board
COODEC Application of Certificate of Origin
COODCI Issue of Certificate of Origin
MDS Message Design Specifications
Crimsonlogic Crimson Logic Pte Ltd
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
TCODEC Trade Certificate of Origin Declaration
UNSM United Nation Standard Message
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', 'Not explicitly covered in uploaded documents.', '5.1 Abbreviations
APERAK Application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic Data Interchange
ERRORM Error Message
GST Goods and Services Tax
IESGP/IE Singapore International Enterprise Singapore Board
COODEC Application of Certificate of Origin
COODCI Issue of Certificate of Origin
MDS Message Design Specifications
Crimsonlogic Crimson Logic Pte Ltd
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
TCODEC Trade Certificate of Origin Declaration
UNSM United Nation Standard Message
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.1 - Abbreviations.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.1', '5.1 Abbreviations
APERAK Application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic Data Interchange
ERRORM Error Message
GST Goods and Services Tax
IESGP/IE Singapore International Enterprise Singapore Board
COODEC Application of Certificate of Origin
COODCI Issue of Certificate of Origin
MDS Message Design Specifications
Crimsonlogic Crimson Logic Pte Ltd
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
TCODEC Trade Certificate of Origin Declaration
UNSM United Nation Standard Message
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.1', 'TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
5.1 Abbreviations
APERAK
Application Error and Acknowledgement
CA
Controlling Agency
CO
Certificate of Origin
DE
Data Element
EDI
Electronic Data Interchange
ERRORM
Error Message
GST
Goods and Services Tax
IESGP/IE Singapore
International Enterprise Singapore Board
COODEC
Application of Certificate of Origin
COODCI
Issue of Certificate of Origin
MDS
Message Design Specifications
Crimsonlogic
SC
Singapore Customs
STDID
Singapore Trade Data Interchange Directory
TCODEC
Trade Certificate of Origin Declaration
UNSM
United Nation Standard Message
OFFICIAL (CLOSED)');
INSERT INTO documents (section_code, document_name) VALUES ('5.1', 'APERAK Application');
INSERT INTO documents (section_code, document_name) VALUES ('5.1', 'CO Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('5.1', 'COODEC Application of Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('5.1', 'COODCI Issue of Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('5.1', 'TCODEC Trade Certificate of Origin Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('5.1', 'Trade Net Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('5.1', 'Application of Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('5.1', 'Issue of Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('5.1', 'Trade Certificate of Origin Declaration');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.1', 'Customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.1', 'SC Singapore Customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.1', 'Singapore Customs');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.1', 1, 'Evaluate condition: 5.1 Abbreviations
APERAK Application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic Data Interchange
ERRORM Error Message
GST Goods and Services Tax
IESGP/IE Singapore International Enterprise Singapore Board
COODEC Application of Certificate of Origin
COODCI Issue of Certificate of Origin
MDS Message Design Specifications
Crimsonlogic Crimson Logic Pte Ltd
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
TCODEC Trade Certificate of Origin Declaration
UNSM United Nation Standard Message
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.1', 2, 'Evaluate condition: TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
5.1 Abbreviations
APERAK
Application Error and Acknowledgement
CA
Controlling Agency
CO
Certificate of Origin
DE
Data Element
EDI
Electronic Data Interchange
ERRORM
Error Message
GST
Goods and Services Tax
IESGP/IE Singapore
International Enterprise Singapore Board
COODEC
Application of Certificate of Origin
COODCI
Issue of Certificate of Origin
MDS
Message Design Specifications
Crimsonlogic
SC
Singapore Customs
STDID
Singapore Trade Data Interchange Directory
TCODEC
Trade Certificate of Origin Declaration
UNSM
United Nation Standard Message
OFFICIAL (CLOSED)');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.1', 3, '5.1 Abbreviations
APERAK Application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic Data Interchange
ERRORM Error Message
GST Goods and Services Tax
IESGP/IE Singapore International Enterprise Singapore Board
COODEC Application of Certificate of Origin
COODCI Issue of Certificate of Origin
MDS Message Design Specifications
Crimsonlogic Crimson Logic Pte Ltd
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
TCODEC Trade Certificate of Origin Declaration
UNSM United Nation Standard Message
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.1', 4, 'TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
5.1 Abbreviations
APERAK
Application Error and Acknowledgement
CA
Controlling Agency
CO
Certificate of Origin
DE
Data Element
EDI
Electronic Data Interchange
ERRORM
Error Message
GST
Goods and Services Tax
IESGP/IE Singapore
International Enterprise Singapore Board
COODEC
Application of Certificate of Origin
COODCI
Issue of Certificate of Origin
MDS
Message Design Specifications
Crimsonlogic
SC
Singapore Customs
STDID
Singapore Trade Data Interchange Directory
TCODEC
Trade Certificate of Origin Declaration
UNSM
United Nation Standard Message
OFFICIAL (CLOSED)');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'EDI');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'GST');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Tax');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'MDS');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Pte');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Ltd');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Net');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'doc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'XML');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'For');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Ver');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Data');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'UNSM');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Date');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Error');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Goods');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Board');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Issue');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Logic');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'tags', '5.1');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'tags', 'Abbreviations');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.COODEC Ver2.1.pdf', '', 'TradeNetDeclaration.COODEC Ver2.1', '6', 'MESSAGE FUNCTION', 'MESSAGE FUNCTION
Transfer conditions for the TCODEC (COODEC) message are dependent on the Application Type.', 'Indha MESSAGE FUNCTION section-la, MESSAGE FUNCTION
Transfer conditions for the TCODEC (COODEC) message are dependent on the application Type.', '6. MESSAGE FUNCTION
Transfer conditions for the TCODEC (COODEC) message are dependent on the Application Type. They are:
Code Application Type Transfer Conditions
COO Application for Certificate of To allow the Declarant to apply for the Certificate of Origin for
Origin only export purposes.', '6.', '6. MESSAGE FUNCTION
Transfer conditions for the TCODEC (COODEC) message are dependent on the Application Type. They are:
Code Application Type Transfer Conditions
COO Application for Certificate of To allow the Declarant to apply for the Certificate of Origin for
Origin only export purposes.', 'Indha MESSAGE FUNCTION section-la, 6. MESSAGE FUNCTION
Transfer conditions for the TCODEC (COODEC) message are dependent on the application Type. They are:
Code application Type Transfer Conditions
COO application for Certificate of To allow the Declarant to apply for the Certificate of Origin for
Origin only export purposes.', '6. MESSAGE FUNCTION
Transfer conditions for the TCODEC (COODEC) message are dependent on the Application Type. They are:
Code Application Type Transfer Conditions
COO Application for Certificate of To allow the Declarant to apply for the Certificate of Origin for
Origin only export purposes.
Sender: Traders, Freight Forwarders, Air Cargo Agents, Shipping Agents, Declaring Agents
Logical Destinations: SC
(via Trade Net system)
Response message: TCODEC (COODCI) message (for Issuing Authorities to inform the Applicant/Declarant on their
approval to the application for the Certificate of Origin. Refer to
reference 2 for more details)
APERAK (STATUS) message (for Issuing Authorities to inform the Applicant/Declarant on the
rejection of the application; refer to reference 3 for more details)
APERAK (ERRORM) message (for Issuing Authorities and Trade Net System to inform the Declarant on
the errors found when processing the declaration message; refer to
reference 4 for more details)
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
| Code | | | Application Type | | | Transfer Conditions |
COO | | | Application for Certificate of
Origin only | | | To allow the Declarant to apply for the Certificate of Origin for
export purposes. | |
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
6. MESSAGE FUNCTION
Transfer conditions for the TCODEC (COODEC) message are dependent on the Application Type. They are:
Code Application Type
Transfer Conditions
COO
Application
for
Certificate
of
Origin only
To allow the Declarant to apply for the Certificate of Origin for
export purposes.
Sender
: Traders, Freight Forwarders, Air Cargo Agents, Shipping Agents, Declaring Agents
Logical Destinations
: SC
(via Trade Net system)
Response message
: TCODEC (COODCI) message
(for Issuing Authorities to inform the Applicant/Declarant on their
approval to the application for the Certificate of Origin. Refer to
reference 2 for more details)
APERAK (STATUS) message
(for Issuing Authorities to inform the Applicant/Declarant on the
rejection of the application; refer to reference 3 for more details)
APERAK (ERRORM) message
(for Issuing Authorities and Trade Net System to inform the Declarant on
the errors found when processing the declaration message; refer to
reference 4 for more details)
OFFICIAL (CLOSED)', '[6, 7]', '["for", "the", "are", "COO", "Air", "via", "Net", "and", "doc", "XML", "Ver", "Type", "They", "Code", "only", "more", "when", "Date", "allow", "apply"]', 'Support MESSAGE FUNCTION processing and compliance validation.', '["6", "MESSAGE FUNCTION", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC6-R001', '6', 'IF validations pass THEN recommend action: They are:
Code Application Type Transfer Conditions
COO Application for Certificate of To allow the Declarant to apply for the Certificate of Origin for
Origin only export purposes.', 'business_rule', 'MESSAGE FUNCTION', 'They are:
Code Application Type Transfer Conditions
COO Application for Certificate of To allow the Declarant to apply for the Certificate of Origin for
Origin only export purposes.', 'Not explicitly covered in uploaded documents.', 'They are:
Code Application Type Transfer Conditions
COO Application for Certificate of To allow the Declarant to apply for the Certificate of Origin for
Origin only export purposes.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 6 - MESSAGE FUNCTION.');
INSERT INTO conditions (section_code, condition_text) VALUES ('6', 'They are:
Code Application Type Transfer Conditions
COO Application for Certificate of To allow the Declarant to apply for the Certificate of Origin for
Origin only export purposes.');
INSERT INTO conditions (section_code, condition_text) VALUES ('6', 'Sender: Traders, Freight Forwarders, Air Cargo Agents, Shipping Agents, Declaring Agents
Logical Destinations: SC
(via Trade Net system)
Response message: TCODEC (COODCI) message (for Issuing Authorities to inform the Applicant/Declarant on their
approval to the application for the Certificate of Origin.');
INSERT INTO conditions (section_code, condition_text) VALUES ('6', 'Refer to
reference 2 for more details)
APERAK (STATUS) message (for Issuing Authorities to inform the Applicant/Declarant on the
rejection of the application; refer to reference 3 for more details)
APERAK (ERRORM) message (for Issuing Authorities and Trade Net System to inform the Declarant on
the errors found when processing the declaration message; refer to
reference 4 for more details)
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
| Code | | | Application Type | | | Transfer Conditions |
COO | | | Application for Certificate of
Origin only | | | To allow the Declarant to apply for the Certificate of Origin for
export purposes.');
INSERT INTO conditions (section_code, condition_text) VALUES ('6', 'They are:
Code Application Type
Transfer Conditions
COO
Application
for
Certificate
of
Origin only
To allow the Declarant to apply for the Certificate of Origin for
export purposes.');
INSERT INTO conditions (section_code, condition_text) VALUES ('6', 'Sender
: Traders, Freight Forwarders, Air Cargo Agents, Shipping Agents, Declaring Agents
Logical Destinations
: SC
(via Trade Net system)
Response message
: TCODEC (COODCI) message
(for Issuing Authorities to inform the Applicant/Declarant on their
approval to the application for the Certificate of Origin.');
INSERT INTO conditions (section_code, condition_text) VALUES ('6', 'Refer to
reference 2 for more details)
APERAK (STATUS) message
(for Issuing Authorities to inform the Applicant/Declarant on the
rejection of the application; refer to reference 3 for more details)
APERAK (ERRORM) message
(for Issuing Authorities and Trade Net System to inform the Declarant on
the errors found when processing the declaration message; refer to
reference 4 for more details)
OFFICIAL (CLOSED)');
INSERT INTO documents (section_code, document_name) VALUES ('6', 'TCODEC (COODEC) message are dependent on the Application');
INSERT INTO documents (section_code, document_name) VALUES ('6', 'Code Application');
INSERT INTO documents (section_code, document_name) VALUES ('6', 'COO Application for Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('6', 'To allow the Declarant to apply for the Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('6', 'Sender: Traders, Freight Forwarders, Air Cargo Agents, Shipping Agents, Declaring Agents
Logical Destinations: SC
(via Trade Net system)
Response message: TCODEC (COODCI) message (for Issuing Authorities to inform the Applicant/Declarant on their
approval to the application for the Certificate of Origin.');
INSERT INTO documents (section_code, document_name) VALUES ('6', 'Trade Net Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('6', 'Application for Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('6', '| |
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO documents (section_code, document_name) VALUES ('6', 'Sender
: Traders, Freight Forwarders, Air Cargo Agents, Shipping Agents, Declaring Agents
Logical Destinations
: SC
(via Trade Net system)
Response message
: TCODEC (COODCI) message
(for Issuing Authorities to inform the Applicant/Declarant on their
approval to the application for the Certificate of Origin.');
INSERT INTO documents (section_code, document_name) VALUES ('6', 'Refer to
reference 2 for more details)
APERAK (STATUS) message
(for Issuing Authorities to inform the Applicant/Declarant on the
rejection of the application; refer to reference 3 for more details)
APERAK (ERRORM) message
(for Issuing Authorities and Trade Net System to inform the Declarant on
the errors found when processing the declaration message; refer to
reference 4 for more details)
OFFICIAL (CLOSED)');
INSERT INTO authorities (section_code, authority_name) VALUES ('6', 'TCODEC (COODCI) message (for Issuing Authorities');
INSERT INTO authorities (section_code, authority_name) VALUES ('6', 'APERAK (STATUS) message (for Issuing Authorities');
INSERT INTO authorities (section_code, authority_name) VALUES ('6', 'APERAK (ERRORM) message (for Issuing Authorities');
INSERT INTO authorities (section_code, authority_name) VALUES ('6', 'Issuing Authorities');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('6', 1, 'Evaluate condition: They are:
Code Application Type Transfer Conditions
COO Application for Certificate of To allow the Declarant to apply for the Certificate of Origin for
Origin only export purposes.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('6', 2, 'Evaluate condition: Sender: Traders, Freight Forwarders, Air Cargo Agents, Shipping Agents, Declaring Agents
Logical Destinations: SC
(via Trade Net system)
Response message: TCODEC (COODCI) message (for Issuing Authorities to inform the Applicant/Declarant on their
approval to the application for the Certificate of Origin.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('6', 3, 'Evaluate condition: Refer to
reference 2 for more details)
APERAK (STATUS) message (for Issuing Authorities to inform the Applicant/Declarant on the
rejection of the application; refer to reference 3 for more details)
APERAK (ERRORM) message (for Issuing Authorities and Trade Net System to inform the Declarant on
the errors found when processing the declaration message; refer to
reference 4 for more details)
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
| Code | | | Application Type | | | Transfer Conditions |
COO | | | Application for Certificate of
Origin only | | | To allow the Declarant to apply for the Certificate of Origin for
export purposes.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('6', 4, 'They are:
Code Application Type Transfer Conditions
COO Application for Certificate of To allow the Declarant to apply for the Certificate of Origin for
Origin only export purposes.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('6', 5, 'Refer to
reference 2 for more details)
APERAK (STATUS) message (for Issuing Authorities to inform the Applicant/Declarant on the
rejection of the application; refer to reference 3 for more details)
APERAK (ERRORM) message (for Issuing Authorities and Trade Net System to inform the Declarant on
the errors found when processing the declaration message; refer to
reference 4 for more details)
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
| Code | | | Application Type | | | Transfer Conditions |
COO | | | Application for Certificate of
Origin only | | | To allow the Declarant to apply for the Certificate of Origin for
export purposes.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('6', 6, 'They are:
Code Application Type
Transfer Conditions
COO
Application
for
Certificate
of
Origin only
To allow the Declarant to apply for the Certificate of Origin for
export purposes.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('6', 7, 'Refer to
reference 2 for more details)
APERAK (STATUS) message
(for Issuing Authorities to inform the Applicant/Declarant on the
rejection of the application; refer to reference 3 for more details)
APERAK (ERRORM) message
(for Issuing Authorities and Trade Net System to inform the Declarant on
the errors found when processing the declaration message; refer to
reference 4 for more details)
OFFICIAL (CLOSED)');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'are');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'COO');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'Air');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'via');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'Net');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'doc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'XML');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'Ver');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'Type');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'They');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'Code');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'only');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'more');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'when');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'Date');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'allow');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'apply');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'tags', '6');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'tags', 'MESSAGE FUNCTION');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.COODEC Ver2.1.pdf', '', 'TradeNetDeclaration.COODEC Ver2.1', '7', 'MESSAGE DEFINITION', 'MESSAGE DEFINITION
Refer to reference 1, chapter 4, Message Definition.', 'Indha MESSAGE DEFINITION section-la, MESSAGE DEFINITION
Refer to reference 1, chapter 4, Message Definition.', '7. MESSAGE DEFINITION
Refer to reference 1, chapter 4, Message Definition. Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', '7.', '7. MESSAGE DEFINITION
Refer to reference 1, chapter 4, Message Definition. Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', 'Indha MESSAGE DEFINITION section-la, 7. MESSAGE DEFINITION
Refer to reference 1, chapter 4, Message Definition. Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', '7. MESSAGE DEFINITION
Refer to reference 1, chapter 4, Message Definition.
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
7. MESSAGE DEFINITION
Refer to reference 1, chapter 4, Message Definition.
OFFICIAL (CLOSED)', '[7, 8]', '["Net", "doc", "XML", "For", "Ver", "Date", "Refer", "Trade", "COODEC", "CLOSED", "MESSAGE", "chapter", "Release", "OFFICIAL", "Prepared", "TRADENET", "Document", "reference", "DEFINITION", "Declaration"]', 'Provide knowledge guidance for MESSAGE DEFINITION.', '["7", "MESSAGE DEFINITION", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC7-R001', '7', '7. MESSAGE DEFINITION
Refer to reference 1, chapter 4, Message Definition. Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', 'business_rule', 'MESSAGE DEFINITION', 'Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', 'Not explicitly covered in uploaded documents.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 7 - MESSAGE DEFINITION.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'Trade Net Declaration');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('7', 1, 'Evaluate condition: Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Net');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'doc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'XML');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'For');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Ver');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Date');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Refer');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Trade');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'COODEC');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'CLOSED');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'MESSAGE');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'chapter');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Release');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'OFFICIAL');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Prepared');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'TRADENET');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Document');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'reference');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'DEFINITION');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Declaration');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'tags', '7');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'tags', 'MESSAGE DEFINITION');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.COODEC Ver2.1.pdf', '', 'TradeNetDeclaration.COODEC Ver2.1', '8', 'MESSAGE DETAILS', 'Defines the operational requirements for MESSAGE DETAILS.', 'Indha MESSAGE DETAILS section-la, Defines the operational requirements for MESSAGE DETAILS.', '8. MESSAGE DETAILS
User defined
Ref Tag name S R Repr Remarks
HEADER SECTION
coo:Header M 1
B045 cbc:Message Reference M 1 an..14 Sender unique message reference. Sequence number of messages in the
interchange (Sender generated).', 'MESSAGE DETAILS governs how DGFT business controls should be applied, validated, and enforced.', 'MESSAGE DETAILS explains the operating rule set that DEKAI should enforce. Key control points include Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header). The section also drives actions such as “I/We declare that all the product(s) to be exported in this
Application has/have been registered with the TTSB of Singapore
Customs and qualify(s) for the respective Certificates applied for”..', 'Indha MESSAGE DETAILS section-la, MESSAGE DETAILS explains the operating rule set that DEKAI should enforce. Key control points include Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header). The section also drives actions such as “I/We declare that all the product(s) to be exported in this
application has/have been registered with the TTSB of Singapore
Customs and qualify(s) for the respective Certificates applied for”..', '8. MESSAGE DETAILS
User defined
Ref Tag name S R Repr Remarks
HEADER SECTION
coo:Header M 1
B045 cbc:Message Reference M 1 an..14 Sender unique message reference. Sequence number of messages in the
interchange (Sender generated).
A062 cac:Unique Reference Number M 1 Format:
Declarant entity identifier = XXXXXXXXXXXXXXXXX
Date of Creation = CCYYMMDD
Sequence Numeric = 9999
B036 cbc:ID M 1 an..17 Specify Declarant entity identifier.
B020 cbc:Date M 1 n8 Specify date of Creation.
B068 cbc:Sequence Numeric M 1 n.. 4 Specify sequence number.
/cac:Unique Reference Number
B065 cbc:Declarant ID M 1 an..17 Specify Applicant/Declarant Id.
Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header).
B083 cbc:Common Access Reference M 1 an..7 COODEC
B006 cbc:Application Type M 1 an3 Specify Application Type eg.
COO=Application of Certificate Of Origin
B037 cbc:Declaration Indicator M boolean Mandatory to specify declaration indicator. Refers to the
declaration at the frontend software:
“I/We declare that all the particulars in this Application are true
and correct”.
“I/We declare that all the product(s) to be exported in this
Application has/have been registered with the TTSB of Singapore
Customs and qualify(s) for the respective Certificates applied for”.
B064 cbc:Previous Permit Number C 1 an..35 Specify previous Permit Number.
A027 cac:Certificate Additional Information C 5 Repeat at most five times.
B038 cbc:Line M 5 an..35 specify certificate additional information.
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
Ref Tag name | User defined
S R Repr | Remarks
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
8. MESSAGE DETAILS
User defined
Ref
Tag name
S
R Repr
Remarks
HEADER SECTION
coo:Header
M
1
B045
cbc:Message Reference
M
1 an..14
Sender unique message reference. Sequence number of messages in the
interchange (Sender generated).
A062
cac:Unique Reference Number
M
1
Format:
Declarant entity identifier = XXXXXXXXXXXXXXXXX
Date of Creation = CCYYMMDD
Sequence Numeric = 9999
B036
cbc:ID
M
1 an..17
Specify Declarant entity identifier.
B020
cbc:Date
M
1 n8
Specify date of Creation.
B068
cbc:Sequence Numeric
M
1 n.. 4
Specify sequence number.
/cac:Unique Reference Number
B065
cbc:Declarant ID
M
1 an..17
Specify Applicant/Declarant Id.
Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header).
B083
cbc:Common Access Reference
M
1 an..7
COODEC
B006
cbc:Application Type
M
1 an3
Specify Application Type eg.
COO=Application of Certificate Of Origin
B037
cbc:Declaration Indicator
M
boolean
Mandatory to specify declaration indicator. Refers to the
declaration at the frontend software:
“I/We declare that all the particulars in this Application are true
and correct”.
“I/We declare that all the product(s) to be exported in this
Application has/have been registered with the TTSB of Singapore
Customs and qualify(s) for the respective Certificates applied for”.
B064
cbc:Previous Permit Number
C
1 an..35
Specify previous Permit Number.
A027
cac:Certificate Additional Information
C
5
Repeat at most five times.
B038
cbc:Line
M
5 an..35
specify certificate additional information.
OFFICIAL (CLOSED)
/cac:Certificate Additional Information
coo:Certificate M 1 Mandatory to specify certificate details
B005 cbc:Application Product Type M 1 an2 Specify Application Product Type. The valid application product
types are:
NA=Application for non-textile products at Airport
NH=Application for non-textile products at Headquarters
TX=Application for textile products
B079 cbc:Entry Year C 1 n4 FORMAT: CCYY
Optional to specify Entry Year if Application Product Type = TX and
Certificate Type = 9 or 18. Not applicable for others.
B016 cbc:GSPDonor Country C 1 an2 Mandatory for Certificate Type 2 to specify GSP Donor Country
(Donation Acting Country). Not applicable for others.
Specify Country code (refer to UN/ECE Recommendation No. 3).
A009 cac:Certificate Detail M 2 Repeat at most 2 times.
B068 cbc:Sequence Numeric M 1 n..5 Specify the sequence number of the Certificate.
B011 cbc:Certificate Type M 1 an..2 Specify Certificate Type eg.
1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Processing)
5 (Commonwealth Preference Certificate)
7 (Form W – reserve)
9 (Ordinary Certificate of Origin for textile products to EU
countries only)
10 (Export Certificate for fresh cut orchids)
12 (GSTP – Global System of Trade Preferences)
16 (ATIGA Form D)
17 (Back-to-Back ATIGA Form D)
18 (Preferential CO for FTA)
19 (Asean-China FTA Form E)
20 (Back-to-Back ACFTA Form E)
21 (India-Singapore CECA CO)
22 (Back-to-Back AKFTA Form AK)
23 (Asean-Korea FTA Form AK)
24 (CO Generic Form Z)
25 (Asean-Japan CEP Form AJ)
26 (Back-to-Back AJCEP Form AJ)
27 (Asean-India FTA Form AI)
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
/cac:Certificate Additional Information
coo:Certificate
M
1
Mandatory to specify certificate details
B005
cbc:Application Product Type
M
1 an2
Specify Application Product Type. The valid application product
types are:
NA=Application for non-textile products at Airport
NH=Application for non-textile products at Headquarters
TX=Application for textile products
B079
cbc:Entry Year
C
1 n4
FORMAT: CCYY
Optional to specify Entry Year if Application Product Type = TX and
Certificate Type = 9 or 18. Not applicable for others.
B016
cbc:GSPDonor Country
C
1 an2
Mandatory for Certificate Type 2 to specify GSP Donor Country
(Donation Acting Country). Not applicable for others.
Specify Country code (refer to UN/ECE Recommendation No. 3).
A009
cac:Certificate Detail
M
2
Repeat at most 2 times.
B068
cbc:Sequence Numeric
M
1 n..5
Specify the sequence number of the Certificate.
B011
cbc:Certificate Type
M
1 an..2
Specify Certificate Type eg.
1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Processing)
5 (Commonwealth Preference Certificate)
7 (Form W – reserve)
9 (Ordinary Certificate of Origin for textile products to EU
countries only)
10 (Export Certificate for fresh cut orchids)
12 (GSTP – Global System of Trade Preferences)
16 (ATIGA Form D)
17 (Back-to-Back ATIGA Form D)
18 (Preferential CO for FTA)
19 (Asean-China FTA Form E)
20 (Back-to-Back ACFTA Form E)
21 (India-Singapore CECA CO)
22 (Back-to-Back AKFTA Form AK)
23 (Asean-Korea FTA Form AK)
24 (CO Generic Form Z)
25 (Asean-Japan CEP Form AJ)
26 (Back-to-Back AJCEP Form AJ)
27 (Asean-India FTA Form AI)
OFFICIAL (CLOSED)
28 (Back-to-Back AIFTA Form AI)
29 (Asean-Australia-New Zealand FTA Form AANZ)
30 (Back-to-Back AANZFTA Form AANZ)
31 (ASEAN-Hong Kong FTA Form AHK)
32 (Back-to-Back AHKFTA Form AHK)
33 Regional Comprehensive Economic Partnership (RCEP) Form RCEP
34 Back-to-Back Form RCEP
B015 cbc:Copies Numeric C 1 n..2 Specify additional number of copies required for this Certificate
Type.
/cac:Certificate Detail
B014 cbc:Preference Content Percent C 1 n..3 i) If Certificate Type = 5, mandatory to specify the percentage of
Commonwealth Preference Content in which the value of each and every
manufactured article in its condition described in the Certificate
is not less than the specified percentage.
ii) Not applicable for other Certificate Type.
B018 cbc:Currency Code C 1 a3 All values in the Certificate at item level will be assumed to be
SGD unless specified here.
Specify currency code (refer to UN/ECE Recommendation No. 9).
B038 cbc:Additional Certificate Details C 5 an..35 Specify certificate additional details.
B038 cbc:Transport Details C 5 an..35 Specify transport details.
coo:Transport M 1
A036 cac:Outward Transport M 1 Mandatory to specify OUT transport details.
A060 cac:Transport Means M 1 Mandatory to specify outward transport mode.
A061 cac:Transport Mode M 1 For all Declaration Types, valid codes (refer to UN/ECE
Recommendation No. 19) are:', '[8, 9, 10]', '["Ref", "Tag", "coo", "cbc", "the", "cac", "all", "are", "and", "for", "Net", "doc", "XML", "Ver", "Not", "GSP", "cut", "FTA", "CEP", "AHK"]', 'Support MESSAGE DETAILS processing and compliance validation.', '["8", "MESSAGE DETAILS", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC8-R001', '8', 'Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header).', 'business_rule', 'MESSAGE DETAILS', 'A062 cac:Unique Reference Number M 1 Format:
Declarant entity identifier = XXXXXXXXXXXXXXXXX
Date of Creation = CCYYMMDD
Sequence Numeric = 9999
B036 cbc:ID M 1 an..17 Specify Declarant entity identifier.', 'Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header).', '“I/We declare that all the product(s) to be exported in this
Application has/have been registered with the TTSB of Singapore
Customs and qualify(s) for the respective Certificates applied for”.', 'B018 cbc:Currency Code C 1 a3 All values in the Certificate at item level will be assumed to be
SGD unless specified here.', 'DEKAI should produce a compliance decision for 8 - MESSAGE DETAILS.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'A062 cac:Unique Reference Number M 1 Format:
Declarant entity identifier = XXXXXXXXXXXXXXXXX
Date of Creation = CCYYMMDD
Sequence Numeric = 9999
B036 cbc:ID M 1 an..17 Specify Declarant entity identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B020 cbc:Date M 1 n8 Specify date of Creation.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '4 Specify sequence number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '/cac:Unique Reference Number
B065 cbc:Declarant ID M 1 an..17 Specify Applicant/Declarant Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header).');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B083 cbc:Common Access Reference M 1 an..7 COODEC
B006 cbc:Application Type M 1 an3 Specify Application Type eg.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'COO=Application of Certificate Of Origin
B037 cbc:Declaration Indicator M boolean Mandatory to specify declaration indicator.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '“I/We declare that all the product(s) to be exported in this
Application has/have been registered with the TTSB of Singapore
Customs and qualify(s) for the respective Certificates applied for”.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B064 cbc:Previous Permit Number C 1 an..35 Specify previous Permit Number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'A027 cac:Certificate Additional Information C 5 Repeat at most five times.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B038 cbc:Line M 5 an..35 specify certificate additional information.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
Ref Tag name | User defined
S R Repr | Remarks
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'A062
cac:Unique Reference Number
M
1
Format:
Declarant entity identifier = XXXXXXXXXXXXXXXXX
Date of Creation = CCYYMMDD
Sequence Numeric = 9999
B036
cbc:ID
M
1 an..17
Specify Declarant entity identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B020
cbc:Date
M
1 n8
Specify date of Creation.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '4
Specify sequence number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '/cac:Unique Reference Number
B065
cbc:Declarant ID
M
1 an..17
Specify Applicant/Declarant Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B083
cbc:Common Access Reference
M
1 an..7
COODEC
B006
cbc:Application Type
M
1 an3
Specify Application Type eg.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'COO=Application of Certificate Of Origin
B037
cbc:Declaration Indicator
M
boolean
Mandatory to specify declaration indicator.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B064
cbc:Previous Permit Number
C
1 an..35
Specify previous Permit Number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'A027
cac:Certificate Additional Information
C
5
Repeat at most five times.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B038
cbc:Line
M
5 an..35
specify certificate additional information.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'OFFICIAL (CLOSED)
/cac:Certificate Additional Information
coo:Certificate M 1 Mandatory to specify certificate details
B005 cbc:Application Product Type M 1 an2 Specify Application Product Type.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'The valid application product
types are:
NA=Application for non-textile products at Airport
NH=Application for non-textile products at Headquarters
TX=Application for textile products
B079 cbc:Entry Year C 1 n4 FORMAT: CCYY
Optional to specify Entry Year if Application Product Type = TX and
Certificate Type = 9 or 18.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B016 cbc:GSPDonor Country C 1 an2 Mandatory for Certificate Type 2 to specify GSP Donor Country
(Donation Acting Country).');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'Specify Country code (refer to UN/ECE Recommendation No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'A009 cac:Certificate Detail M 2 Repeat at most 2 times.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B068 cbc:Sequence Numeric M 1 n..5 Specify the sequence number of the Certificate.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B011 cbc:Certificate Type M 1 an..2 Specify Certificate Type eg.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Processing)
5 (Commonwealth Preference Certificate)
7 (Form W – reserve)
9 (Ordinary Certificate of Origin for textile products to EU
countries only)
10 (Export Certificate for fresh cut orchids)
12 (GSTP – Global System of Trade Preferences)
16 (ATIGA Form D)
17 (Back-to-Back ATIGA Form D)
18 (Preferential CO for FTA)
19 (Asean-China FTA Form E)
20 (Back-to-Back ACFTA Form E)
21 (India-Singapore CECA CO)
22 (Back-to-Back AKFTA Form AK)
23 (Asean-Korea FTA Form AK)
24 (CO Generic Form Z)
25 (Asean-Japan CEP Form AJ)
26 (Back-to-Back AJCEP Form AJ)
27 (Asean-India FTA Form AI)
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
/cac:Certificate Additional Information
coo:Certificate
M
1
Mandatory to specify certificate details
B005
cbc:Application Product Type
M
1 an2
Specify Application Product Type.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'The valid application product
types are:
NA=Application for non-textile products at Airport
NH=Application for non-textile products at Headquarters
TX=Application for textile products
B079
cbc:Entry Year
C
1 n4
FORMAT: CCYY
Optional to specify Entry Year if Application Product Type = TX and
Certificate Type = 9 or 18.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B016
cbc:GSPDonor Country
C
1 an2
Mandatory for Certificate Type 2 to specify GSP Donor Country
(Donation Acting Country).');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'A009
cac:Certificate Detail
M
2
Repeat at most 2 times.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B068
cbc:Sequence Numeric
M
1 n..5
Specify the sequence number of the Certificate.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B011
cbc:Certificate Type
M
1 an..2
Specify Certificate Type eg.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Processing)
5 (Commonwealth Preference Certificate)
7 (Form W – reserve)
9 (Ordinary Certificate of Origin for textile products to EU
countries only)
10 (Export Certificate for fresh cut orchids)
12 (GSTP – Global System of Trade Preferences)
16 (ATIGA Form D)
17 (Back-to-Back ATIGA Form D)
18 (Preferential CO for FTA)
19 (Asean-China FTA Form E)
20 (Back-to-Back ACFTA Form E)
21 (India-Singapore CECA CO)
22 (Back-to-Back AKFTA Form AK)
23 (Asean-Korea FTA Form AK)
24 (CO Generic Form Z)
25 (Asean-Japan CEP Form AJ)
26 (Back-to-Back AJCEP Form AJ)
27 (Asean-India FTA Form AI)
OFFICIAL (CLOSED)
28 (Back-to-Back AIFTA Form AI)
29 (Asean-Australia-New Zealand FTA Form AANZ)
30 (Back-to-Back AANZFTA Form AANZ)
31 (ASEAN-Hong Kong FTA Form AHK)
32 (Back-to-Back AHKFTA Form AHK)
33 Regional Comprehensive Economic Partnership (RCEP) Form RCEP
34 Back-to-Back Form RCEP
B015 cbc:Copies Numeric C 1 n..2 Specify additional number of copies required for this Certificate
Type.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '/cac:Certificate Detail
B014 cbc:Preference Content Percent C 1 n..3 i) If Certificate Type = 5, mandatory to specify the percentage of
Commonwealth Preference Content in which the value of each and every
manufactured article in its condition described in the Certificate
is not less than the specified percentage.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'ii) Not applicable for other Certificate Type.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B018 cbc:Currency Code C 1 a3 All values in the Certificate at item level will be assumed to be
SGD unless specified here.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'Specify currency code (refer to UN/ECE Recommendation No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B038 cbc:Additional Certificate Details C 5 an..35 Specify certificate additional details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B038 cbc:Transport Details C 5 an..35 Specify transport details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'coo:Transport M 1
A036 cac:Outward Transport M 1 Mandatory to specify OUT transport details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'A060 cac:Transport Means M 1 Mandatory to specify outward transport mode.');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Application Type M 1 an3 Specify Application');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Application of Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'I/We declare that all the particulars in this Application');
INSERT INTO documents (section_code, document_name) VALUES ('8', '“I/We declare that all the product(s) to be exported in this
Application has/have been registered with the TTSB of Singapore
Customs and qualify(s) for the respective Certificates applied for”.');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'A027 cac:Certificate Additional Information C 5 Repeat at most five times.');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'B038 cbc:Line M 5 an..35 specify certificate additional information.');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Trade Net Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Specify Application');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'A027
cac:Certificate Additional Information
C
5
Repeat at most five times.');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'B038
cbc:Line
M
5 an..35
specify certificate additional information.');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Application Product Type M 1 an2 Specify Application');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Optional to specify Entry Year if Application');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'GSPDonor Country C 1 an2 Mandatory for Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'A009 cac:Certificate Detail M 2 Repeat at most 2 times.');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Specify the sequence number of the Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Specify Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Ordinary Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Commonwealth Preference Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Export Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Mandatory for Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'A009
cac:Certificate Detail
M
2
Repeat at most 2 times.');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Specify additional number of copies required for this Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'If Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Not applicable for other Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Currency Code C 1 a3 All values in the Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Additional Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Transport Mode M 1 For all Declaration');
INSERT INTO authorities (section_code, authority_name) VALUES ('8', 'Customs');
INSERT INTO exceptions (section_code, exception_text) VALUES ('8', 'B018 cbc:Currency Code C 1 a3 All values in the Certificate at item level will be assumed to be
SGD unless specified here.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 1, 'Evaluate condition: A062 cac:Unique Reference Number M 1 Format:
Declarant entity identifier = XXXXXXXXXXXXXXXXX
Date of Creation = CCYYMMDD
Sequence Numeric = 9999
B036 cbc:ID M 1 an..17 Specify Declarant entity identifier.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 2, 'Evaluate condition: B020 cbc:Date M 1 n8 Specify date of Creation.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 3, 'Evaluate condition: 4 Specify sequence number.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 4, '“I/We declare that all the product(s) to be exported in this
Application has/have been registered with the TTSB of Singapore
Customs and qualify(s) for the respective Certificates applied for”.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 5, 'Run validation: Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 6, 'Run validation: Refers to the
declaration at the frontend software:
“I/We declare that all the particulars in this Application are true
and correct”.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 7, 'Run validation: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Processing)
5 (Commonwealth Preference Certificate)
7 (Form W – reserve)
9 (Ordinary Certificate of Origin for textile products to EU
countries only)
10 (Export Certificate for fresh cut orchids)
12 (GSTP – Global System of Trade Preferences)
16 (ATIGA Form D)
17 (Back-to-Back ATIGA Form D)
18 (Preferential CO for FTA)
19 (Asean-China FTA Form E)
20 (Back-to-Back ACFTA Form E)
21 (India-Singapore CECA CO)
22 (Back-to-Back AKFTA Form AK)
23 (Asean-Korea FTA Form AK)
24 (CO Generic Form Z)
25 (Asean-Japan CEP Form AJ)
26 (Back-to-Back AJCEP Form AJ)
27 (Asean-India FTA Form AI)
OFFICIAL (CLOSED)
28 (Back-to-Back AIFTA Form AI)
29 (Asean-Australia-New Zealand FTA Form AANZ)
30 (Back-to-Back AANZFTA Form AANZ)
31 (ASEAN-Hong Kong FTA Form AHK)
32 (Back-to-Back AHKFTA Form AHK)
33 Regional Comprehensive Economic Partnership (RCEP) Form RCEP
34 Back-to-Back Form RCEP
B015 cbc:Copies Numeric C 1 n..2 Specify additional number of copies required for this Certificate
Type.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 8, 'Handle exception: B018 cbc:Currency Code C 1 a3 All values in the Certificate at item level will be assumed to be
SGD unless specified here.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'Ref');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'Tag');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'coo');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'cbc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'cac');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'all');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'are');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'Net');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'doc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'XML');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'Ver');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'Not');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'GSP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'cut');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'FTA');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'CEP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'AHK');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'tags', '8');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'tags', 'MESSAGE DETAILS');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.COODEC Ver2.1.pdf', '', 'TradeNetDeclaration.COODEC Ver2.1', '1', 'Maritime', 'Defines the operational requirements for Maritime.', 'Indha Maritime section-la, Defines the operational requirements for Maritime.', '1: Maritime', '1: Maritime', '1: Maritime', 'Indha Maritime section-la, 1: Maritime', '1: Maritime', '[10]', '["Maritime"]', 'Provide knowledge guidance for Maritime.', '["1", "Maritime", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC1-R001', '1', '1: Maritime', 'business_rule', 'Maritime', 'Not explicitly covered in uploaded documents.', 'Not explicitly covered in uploaded documents.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 1 - Maritime.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('1', 1, 'Review section 1 requirements');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('1', 2, 'Capture applicant inputs');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('1', 3, 'Route for authority decision');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'Maritime');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'tags', '1');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'tags', 'Maritime');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.COODEC Ver2.1.pdf', '', 'TradeNetDeclaration.COODEC Ver2.1', '2', 'Rail', 'Defines the operational requirements for Rail.', 'Indha Rail section-la, Defines the operational requirements for Rail.', '2: Rail', '2: Rail', '2: Rail', 'Indha Rail section-la, 2: Rail', '2: Rail', '[10]', '["Rail"]', 'Provide knowledge guidance for Rail.', '["2", "Rail", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC2-R001', '2', '2: Rail', 'business_rule', 'Rail', 'Not explicitly covered in uploaded documents.', 'Not explicitly covered in uploaded documents.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 2 - Rail.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('2', 1, 'Review section 2 requirements');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('2', 2, 'Capture applicant inputs');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('2', 3, 'Route for authority decision');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'Rail');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'tags', '2');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'tags', 'Rail');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.COODEC Ver2.1.pdf', '', 'TradeNetDeclaration.COODEC Ver2.1', '3', 'Road', 'B076 cbc:Conveyance Reference Number C 1 an..17 Mandatory for transport mode = 1, specify voyage number.', 'Indha Road section-la, B076 cbc:Conveyance Reference Number C 1 an..17 Mandatory for transport mode = 1, specify voyage number.', '3: Road
4: Air
B082 cbc:Mode Code M 1 n1 Specify Outward Transport Mode. B076 cbc:Conveyance Reference Number C 1 an..17 Mandatory for transport mode = 1, specify voyage number. Specify ‘NA’ if there is no voyage number.', 'Road governs how DGFT business controls should be applied, validated, and enforced.', 'Road explains the operating rule set that DEKAI should enforce. Key control points include /cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Outward Carrier Agent Party C 1 a) Specify Outward Carrier Agent, must be registered with Customs. The section also drives actions such as /cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Outward Carrier Agent Party C 1 a) Specify Outward Carrier Agent, must be registered with Customs..', 'Indha Road section-la, Road explains the operating rule set that DEKAI should enforce. Key control points include /cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Outward Carrier Agent Party C 1 a) Specify Outward Carrier Agent, must be registered with Customs. The section also drives actions such as /cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Outward Carrier Agent Party C 1 a) Specify Outward Carrier Agent, must be registered with Customs..', '3: Road
4: Air
B082 cbc:Mode Code M 1 n1 Specify Outward Transport Mode.
B076 cbc:Conveyance Reference Number C 1 an..17 Mandatory for transport mode = 1, specify voyage number.
Specify ‘NA’ if there is no voyage number.
For transport mode = 4, specify outward flight number. Specify ‘NA’
if there is no outward flight number.
B049 cbc:Transport Identifier C 1 an..35 Mandatory for transport mode = 1, specify vessel name.
For transport mode = 3, specify Vehicle Licence/Registration Number,
if any.
For transport mode = 4, specify outward Aircraft Registration Number
for chartered flights, if any.
/cac:Transport Mode
/cac:Transport Means
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
28 (Back-to-Back AIFTA Form AI)
29 (Asean-Australia-New Zealand FTA Form AANZ)
30 (Back-to-Back AANZFTA Form AANZ)
31 (ASEAN-Hong Kong FTA Form AHK)
32 (Back-to-Back AHKFTA Form AHK)
33 Regional Comprehensive Economic Partnership (RCEP) Form RCEP
34 Back-to-Back Form RCEP
B015
cbc:Copies Numeric
C
1 n..2
Specify additional number of copies required for this Certificate
Type.
/cac:Certificate Detail
B014
cbc:Preference Content Percent
C
1 n..3
i) If Certificate Type = 5, mandatory to specify the percentage of
Commonwealth Preference Content in which the value of each and every
manufactured article in its condition described in the Certificate
is not less than the specified percentage.
ii) Not applicable for other Certificate Type.
B018
cbc:Currency Code
C
1 a3
All values in the Certificate at item level will be assumed to be
SGD unless specified here.
Specify currency code (refer to UN/ECE Recommendation No. 9).
B038
cbc:Additional Certificate Details
C
5 an..35
Specify certificate additional details.
B038
cbc:Transport Details
C
5 an..35
Specify transport details.
coo:Transport
M
1
A036
cac:Outward Transport
M
1
Mandatory to specify OUT transport details.
A060
cac:Transport Means
M
1
Mandatory to specify outward transport mode.
A061
cac:Transport Mode
M
1
For all Declaration Types, valid codes (refer to UN/ECE
Recommendation No. 19) are:
3: Road
4: Air
B082
cbc:Mode Code
M
1 n1
Specify Outward Transport Mode.
B076
cbc:Conveyance Reference Number
C
1 an..17
Mandatory for transport mode = 1, specify voyage number.
Specify ‘NA’ if there is no voyage number.
For transport mode = 4, specify outward flight number. Specify ‘NA’
if there is no outward flight number.
B049
cbc:Transport Identifier
C
1 an..35
Mandatory for transport mode = 1, specify vessel name.
For transport mode = 3, specify Vehicle Licence/Registration Number,
if any.
For transport mode = 4, specify outward Aircraft Registration Number
for chartered flights, if any.
/cac:Transport Mode
/cac:Transport Means
OFFICIAL (CLOSED)
B020 cbc:Departure Date M 1 n8 Format: CCYYMMDD
For outward transport, mandatory to specify Date of Departure.
B055 cbc:Discharge Port M 1 an..5 For outward transport, mandatory to specify Port of Discharge.
Specify port code (refer to UN/ECE Recommendation No. 16).
B016 cbc:Final Destination Country M 1 a2 Mandatory to specify Country of Final Destination for outward
transport.
Specify country code (refer to UN/ECE Recommendation No. 3).
/cac:Outward Transport
coo:Party M 1 Mandatory to specify party details.
Applicable Party Types:
- (Declarant)
- (Declaring Agent, if declared by Agent)
- (Freight Forwarder; optional)
- (Outward Carrier Agent; mandatory if Mode of Transport = 1 and
4; optional for transport mode 2 or 3)
- (Exporter)
- (Consignee)
- (Manufacturer; optional)
A014 cac:Declarant Party M 1 Mandatory to specify the identity of the Declarant.
A043 cac:Person Information M 1 Specify Declarant Person Information.
B012 cbc:Code Value M 1 an..17 Specify Declarant Code.
B093 cbc:Name M 1 an..100 Specify Declarant name.
/cac:Person Information
B071 cbc:Telephone M 1 an..25 Mandatory to specify Declarant contact number.
/cac:Declarant Party
A040 cac:Declaring Agent Party C 1 Specify Declaring Agent.
A038 cac:Party Identification M 1 Specify Declaring Agent Party Identification.
B036 cbc:ID M 1 an..17 Specify Declaring Agent Entity Identifier.
/cac:Party Identification
A039 cac:Party Name M 1 Specify Declaring Agent Party Name.
B093 cbc:Name M 2 an..50 Specify Declaring Agent name.
/cac:Party Name
/cac:Declaring Agent Party
A040 cac:Freight Forwarder Party C 1 Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator for consol
consignment.
A038 cac:Party Identification M 1 Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator Party
Identification.
B036 cbc:ID M 1 an..17 Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator Entity
Identifier.
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
B020
cbc:Departure Date
M
1 n8
Format: CCYYMMDD
For outward transport, mandatory to specify Date of Departure.
B055
cbc:Discharge Port
M
1 an..5
For outward transport, mandatory to specify Port of Discharge.
Specify port code (refer to UN/ECE Recommendation No. 16).
B016
cbc:Final Destination Country
M
1 a2
Mandatory to specify Country of Final Destination for outward
transport.
Specify country code (refer to UN/ECE Recommendation No. 3).
/cac:Outward Transport
coo:Party
M
1
Mandatory to specify party details.
Applicable Party Types:
- (Declarant)
- (Declaring Agent, if declared by Agent)
- (Freight Forwarder; optional)
- (Outward Carrier Agent; mandatory if Mode of Transport = 1 and
4; optional for transport mode 2 or 3)
- (Exporter)
- (Consignee)
- (Manufacturer; optional)
A014
cac:Declarant Party
M
1
Mandatory to specify the identity of the Declarant.
A043
cac:Person Information
M
1
Specify Declarant Person Information.
B012
cbc:Code Value
M
1 an..17
Specify Declarant Code.
B093
cbc:Name
M
1 an..100
Specify Declarant name.
/cac:Person Information
B071
cbc:Telephone
M
1 an..25
Mandatory to specify Declarant contact number.
/cac:Declarant Party
A040
cac:Declaring Agent Party
C
1
Specify Declaring Agent.
A038
cac:Party Identification
M
1
Specify Declaring Agent Party Identification.
B036
cbc:ID
M
1 an..17
Specify Declaring Agent Entity Identifier.
/cac:Party Identification
A039
cac:Party Name
M
1
Specify Declaring Agent Party Name.
B093
cbc:Name
M
2 an..50
Specify Declaring Agent name.
/cac:Party Name
/cac:Declaring Agent Party
A040
cac:Freight Forwarder Party
C
1
Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator for consol
consignment.
A038
cac:Party Identification
M
1
Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator Party
Identification.
B036
cbc:ID
M
1 an..17
Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator Entity
Identifier.
OFFICIAL (CLOSED)
/cac:Party Identification
A039 cac:Party Name M 1 Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator Party Name.
B093 cbc:Name M 2 an..50 Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator name.
/cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Outward Carrier Agent Party C 1 a) Specify Outward Carrier Agent, must be registered with Customs.
b) Mandatory to specify outward carrier agent if outward transport
mode = 1 or 4 (optional for outward transport mode = 2 or 3).
A038 cac:Party Identification M 1 Specify Outward Carrier Agent Party Identification.
B036 cbc:ID M 1 an..17 Specify Outward Carrier Agent Entity Identifier.
/cac:Party Identification
A039 cac:Party Name M 1 Specify Outward Carrier Agent Party Name.
B093 cbc:Name M 2 an..50 Specify Outward Carrier Agent name.
/cac:Party Name
/cac:Outward Carrier Agent Party
A020 cac:Exporter Party M 1 Mandatory to specify Exporter details.
A040 cac:Party Detail M 1 Specify Exporter Party details.
A038 cac:Party Identification M 1 Specify Exporter Party Identification.
B036 cbc:ID M 1 an..17 Specify Exporter Entity Identifier.
/cac:Party Identification
A039 cac:Party Name M 1 Specify Exporter Party Name.
B093 cbc:Name M 2 an..35 Specify Exporter name.
/cac:Party Name
/cac:Party Detail
A003 cac:Address Line M 1 Specify Exporter address line.
B038 cbc:Line M 3 an..35 Specify Exporter address.
/cac:Address Line
/cac:Exporter Party
A013 cac:Consignee Party M 1 Mandatory to specify consignee name and address.
A039 cac:Party Name M 1 Specify Consignee Party Name.
B093 cbc:Name M 2 an..35 Specify Consignee name.
/cac:Party Name
A003 cac:Address Line M 1 Specify Consignee address line.
B038 cbc:Line M 3 an..35 Specify Consignee address.
/cac:Address Line
/cac:Consignee Party
A020 cac:Manufacturer Party C 1 Specify Manufacturer details. Mandatory for Certificate Types =
1,2,5,9,10,16,18,19,21, 23, 25, 27, 29, 31 & 33. Optional for other
Certificate Types.
A040 cac:Party Detail M 1 Specify Manufacturer Party details.
A038 cac:Party Identification M 1 Specify Manufacturer Party Identification.
B036 cbc:ID M 1 an..17 Specify Manufacturer Entity Identifier.
/cac:Party Identification
A039 cac:Party Name M 1 Specify Manufacturer Party Name.
B093 cbc:Name M 2 an..35 Specify Manufacturer name.
/cac:Party Name
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
/cac:Party Identification
A039
cac:Party Name
M
1
Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator Party Name.
B093
cbc:Name
M
2 an..50
Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator name.
/cac:Party Name
/cac:Freight Forwarder Party
A040
cac:Outward Carrier Agent Party
C
1
a) Specify Outward Carrier Agent, must be registered with Customs.
b) Mandatory to specify outward carrier agent if outward transport
mode = 1 or 4 (optional for outward transport mode = 2 or 3).
A038
cac:Party Identification
M
1
Specify Outward Carrier Agent Party Identification.
B036
cbc:ID
M
1 an..17
Specify Outward Carrier Agent Entity Identifier.
/cac:Party Identification
A039
cac:Party Name
M
1
Specify Outward Carrier Agent Party Name.
B093
cbc:Name
M
2 an..50
Specify Outward Carrier Agent name.
/cac:Party Name
/cac:Outward Carrier Agent Party
A020
cac:Exporter Party
M
1
Mandatory to specify Exporter details.
A040
cac:Party Detail
M
1
Specify Exporter Party details.
A038
cac:Party Identification
M
1
Specify Exporter Party Identification.
B036
cbc:ID
M
1 an..17
Specify Exporter Entity Identifier.
/cac:Party Identification
A039
cac:Party Name
M
1
Specify Exporter Party Name.
B093
cbc:Name
M
2 an..35
Specify Exporter name.
/cac:Party Name
/cac:Party Detail
A003
cac:Address Line
M
1
Specify Exporter address line.
B038
cbc:Line
M
3 an..35
Specify Exporter address.
/cac:Address Line
/cac:Exporter Party
A013
cac:Consignee Party
M
1
Mandatory to specify consignee name and address.
A039
cac:Party Name
M
1
Specify Consignee Party Name.
B093
cbc:Name
M
2 an..35
Specify Consignee name.
/cac:Party Name
A003
cac:Address Line
M
1
Specify Consignee address line.
B038
cbc:Line
M
3 an..35
Specify Consignee address.
/cac:Address Line
/cac:Consignee Party
A020
cac:Manufacturer Party
C
1
Specify Manufacturer details. Mandatory for Certificate Types =
1,2,5,9,10,16,18,19,21, 23, 25, 27, 29, 31 & 33. Optional for other
Certificate Types.
A040
cac:Party Detail
M
1
Specify Manufacturer Party details.
A038
cac:Party Identification
M
1
Specify Manufacturer Party Identification.
B036
cbc:ID
M
1 an..17
Specify Manufacturer Entity Identifier.
/cac:Party Identification
A039
cac:Party Name
M
1
Specify Manufacturer Party Name.
B093
cbc:Name
M
2 an..35
Specify Manufacturer name.
/cac:Party Name
OFFICIAL (CLOSED)
/cac:Party Detail
A067 cac:Address M 1 Specify Manufacturer address in following format
A003 cac:Address Line M 1
B038 cbc:Line M 2 an..35 Specify Manufacturer Street and Number/PO Box.
/cac:Address Line
B084 cbc:City Name C 1 an..35 Specify Manufacturer city name.
B085 cbc:Country Subentity Code C 1 an..9 Specify Manufacturer country subdivision code.
B086 cbc:Country Subentity C 1 an..35 Specify Manufacturer country subdivision name.
B087 cbc:Postal Zone C 1 an..9 Specify Manufacturer postal code.
B016 cbc:Country Code M 1 a2 Specify Manufacturer country code.
/cac:Address
/cac:Manufacturer Party
cac:Supporting Document Reference C 10 Repeat at most 10 times, specify supporting documents attached to
the declaration if applicable.
Only the following file formats are allowed:
1) MS Word
2) Adobe PDF
3) MS Excel
4) Image Files
a) Bitmap
b) JPEG
c) GIF Image
d) EMF Image
e) PNG Image
f) TIF Image
B023 cbc:Document ID M 1 an..3 Specify Document type code. (Refer to STDID Code List).
B033 cbc:Filename M 1 an..70 Specify Filename of the document.
/cac:Supporting Document Reference
ITEM SECTION
coo:Item M 50 Mandatory to repeat at most 50 times.
B068 cbc:Item Sequence Numeric M 1 n..5 Mandatory to specify item Sequence Number.
B035 cbc:Item Harmonized System Code M 1 an..10 Mandatory to specify item Harmonized System code.
B058 cbc:Harmonized System Quantity M 1 n..16 Specify the item quantity and measure unit specifier.
unit Code (attribute) M 1 an..3 Specify unit (refer to UN/ECE Recommendation No. 20).
B016 cbc:Origin Country M 1 an2 Mandatory to specify Country of Origin of goods.
B003 cbc:Item CIFFOBValue M 1 n..16 i) Specify FOB value in SGD for permit details.
ii) This FOB value will be printed on the Certificate if the
corresponding FOB value in Item Value below is not provided.
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
/cac:Party Detail
A067
cac:Address
M
1
Specify Manufacturer address in following format
A003
cac:Address Line
M
1
B038
cbc:Line
M
2 an..35
Specify Manufacturer Street and Number/PO Box.
/cac:Address Line
B084
cbc:City Name
C
1 an..35
Specify Manufacturer city name.
B085
cbc:Country Subentity Code
C
1 an..9
Specify Manufacturer country subdivision code.
B086
cbc:Country Subentity
C
1 an..35
Specify Manufacturer country subdivision name.
B087
cbc:Postal Zone
C
1 an..9
Specify Manufacturer postal code.
B016
cbc:Country Code
M
1 a2
Specify Manufacturer country code.
/cac:Address
/cac:Manufacturer Party
cac:Supporting Document Reference
C
10
Repeat at most 10 times, specify supporting documents attached to
the declaration if applicable.
Only the following file formats are allowed:
1) MS Word
2) Adobe PDF
3) MS Excel
4) Image Files
a) Bitmap
b) JPEG
c) GIF Image
d) EMF Image
e) PNG Image
f) TIF Image
B023
cbc:Document ID
M
1 an..3
Specify Document type code. (Refer to STDID Code List).
B033
cbc:Filename
M
1 an..70
Specify Filename of the document.
/cac:Supporting Document Reference
ITEM SECTION
coo:Item
M
50
Mandatory to repeat at most 50 times.
B068
cbc:Item Sequence Numeric
M
1 n..5
Mandatory to specify item Sequence Number.
B035
cbc:Item Harmonized System Code
M
1 an..10
Mandatory to specify item Harmonized System code.
B058
cbc:Harmonized System Quantity
unit Code (attribute)
M
M
1 n..16
1 an..3
Specify the item quantity and measure unit specifier.
Specify unit (refer to UN/ECE Recommendation No. 20).
B016
cbc:Origin Country
M
1 an2
Mandatory to specify Country of Origin of goods.
B003
cbc:Item CIFFOBValue
M
1 n..16
i) Specify FOB value in SGD for permit details.
ii) This FOB value will be printed on the Certificate if the
corresponding FOB value in Item Value below is not provided.
OFFICIAL (CLOSED)
B070 cac:Shipping Marks Information C 1 Specify markings on cargo for marks and numbers, if any.
B065 cbc:Shipping Marks M 10 an..17 Repeat at most 10 times, specify markings on cargo for marks and
numbers.
/cac:Shipping Marks Information
A028 cac:Item Certificate M 1 Specify Item Certificate detail.
B058 cbc:Item Certificate Quantity C 1 n..16 Optional to specify Certificate item quantity and measurement unit
to be printed on the Certificate. The measurement unit need not
match the measurement unit in the Singapore Trade Classification.
unit Code (attribute) M 1 an3 Specify unit (refer to UN/ECE Recommendation No. 20).
B003 cbc:Item Value C 1 n..16 i) This CIF/FOB value will be printed on the relevant certificates
ii) Optional for Certificate Type = 9, 16, 17, 19, 20, 21, 22, 23,
24, 25, 26, 27, 28, 29, 30, 31, 32, 33 & 34. Not applicable for
other Certificate Types.
A027 cac:Item Certificate Description M 10 Repeat at most ten times, Provide description of the item, including
number and type of packages to be printed on the Certificate.
B038 cbc:Line M 5 an..35 Specify certificate item description.
/cac:Item Certificate Description
B020 cbc:Manufacturing Cost Date C 1 n8 Format: CCYYMMDD
Specify Date of Manufacturing Cost Statement/Letter of Undertaking.
B010 cbc:Textile Category Code C 1 an..5 a) Applicable only for Application Product Type = TX.
b) Mandatory to Certificate Type = 9.
c) Optional for other Certificate Type.
Specify textile category code.
B058 cbc:Textile Quota Quantity C 1 n..16 a) Applicable only for Application Product Type = TX.
b) Mandatory to Certificate Type = 9.
c) Optional for other Certificate Type.
Specify textile quota quantity and measurement unit. The measurement
unit need not match the measurement unit in the Singapore Trade
Classification.
unit Code (attribute) M 1 an3 Specify unit (refer to UN/ECE Recommendation No. 20).
B064 cbc:Item Invoice Number C 1 an..35 a) Optional for Certificate Types = 1, 2, 3, 12, 16, 17, 19, 20, 21,
22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33 & 34.
b) Not applicable for other Certificate Types.
Specify invoice number except for goods under single invoice.
B020 cbc:Item Invoice Date C 1 n8 Format: CCYYMMDD
Specify item invoice date.
B050 cbc:Origin Criterion C 3 an..25 a) Mandatory to specify Origin Criterion details if Certificate Type
= 1, 2, 3, 12, 16, 17, 19, 20, 21, 22, 23, 25, 26, 27, 28, 29,
30, 31, 32, 33 & 34.
b) Optional for Certificate Type = 24.
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
B070
cac:Shipping Marks Information
C
1
Specify markings on cargo for marks and numbers, if any.
B065
cbc:Shipping Marks
M
10 an..17
Repeat at most 10 times, specify markings on cargo for marks and
numbers.
/cac:Shipping Marks Information
A028
cac:Item Certificate
M
1
Specify Item Certificate detail.
B058
cbc:Item Certificate Quantity
unit Code (attribute)
C
M
1 n..16
1 an3
Optional to specify Certificate item quantity and measurement unit
to be printed on the Certificate. The measurement unit need not
match the measurement unit in the Singapore Trade Classification.
Specify unit (refer to UN/ECE Recommendation No. 20).
B003
cbc:Item Value
C
1 n..16
i) This CIF/FOB value will be printed on the relevant certificates
ii) Optional for Certificate Type = 9, 16, 17, 19, 20, 21, 22, 23,
24, 25, 26, 27, 28, 29, 30, 31, 32, 33 & 34. Not applicable for
other Certificate Types.
A027
cac:Item Certificate Description
M
10
Repeat at most ten times, Provide description of the item, including
number and type of packages to be printed on the Certificate.
B038
cbc:Line
M
5 an..35
Specify certificate item description.
/cac:Item Certificate Description
B020
cbc:Manufacturing Cost Date
C
1 n8
Format: CCYYMMDD
Specify Date of Manufacturing Cost Statement/Letter of Undertaking.
B010
cbc:Textile Category Code
C
1 an..5
a) Applicable only for Application Product Type = TX.
b) Mandatory to Certificate Type = 9.
c) Optional for other Certificate Type.
Specify textile category code.
B058
cbc:Textile Quota Quantity
unit Code (attribute)
C
M
1 n..16
1 an3
a) Applicable only for Application Product Type = TX.
b) Mandatory to Certificate Type = 9.
c) Optional for other Certificate Type.
Specify textile quota quantity and measurement unit. The measurement
unit need not match the measurement unit in the Singapore Trade
Classification.
Specify unit (refer to UN/ECE Recommendation No. 20).
B064
cbc:Item Invoice Number
C
1 an..35
a) Optional for Certificate Types = 1, 2, 3, 12, 16, 17, 19, 20, 21,
22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33 & 34.
b) Not applicable for other Certificate Types.
Specify invoice number except for goods under single invoice.
B020
cbc:Item Invoice Date
C
1 n8
Format: CCYYMMDD
Specify item invoice date.
B050
cbc:Origin Criterion
C
3 an..25
a) Mandatory to specify Origin Criterion details if Certificate Type
= 1, 2, 3, 12, 16, 17, 19, 20, 21, 22, 23, 25, 26, 27, 28, 29,
30, 31, 32, 33 & 34.
b) Optional for Certificate Type = 24.
OFFICIAL (CLOSED)
c) Not applicable for other Certificate Types.
Specify Origin Criterion according to rules and conditions.
B035 cbc:Harmonized System Code C 1 an..10 Specify Harmonized System code (cater for 6 digit), if applicable.
B014 cbc:Content Percent C 1 n..3 Specify percentage content of origin criterion details, if
applicable.
/cac:Item Certificate
SUMMARY SECTION
coo:Summary M 1 Mandatory to specify summary details.
B068 cbc:Number Of Items M 1 n..5 Mandatory to specify total number of items declared.
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
c) Not applicable for other Certificate Types.
Specify Origin Criterion according to rules and conditions.
B035
cbc:Harmonized System Code
C
1 an..10
Specify Harmonized System code (cater for 6 digit), if applicable.
B014
cbc:Content Percent
C
1 n..3
Specify percentage content of origin criterion details, if
applicable.
/cac:Item Certificate
SUMMARY SECTION
coo:Summary
M
1
Mandatory to specify summary details.
B068
cbc:Number Of Items
M
1 n..5
Mandatory to specify total number of items declared.', '[10, 11, 12, 13, 14, 15]', '["Air", "cbc", "for", "any", "cac", "Net", "doc", "XML", "Ver", "FTA", "AHK", "the", "and", "its", "not", "All", "SGD", "coo", "OUT", "are"]', 'Support Road processing and compliance validation.', '["3", "Road", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC3-R001', '3', '/cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Outward Carrier Agent Party C 1 a) Specify Outward Carrier Agent, must be registered with Customs.', 'business_rule', 'Road', '3: Road
4: Air
B082 cbc:Mode Code M 1 n1 Specify Outward Transport Mode.', 'TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
28 (Back-to-Back AIFTA Form AI)
29 (Asean-Australia-New Zealand FTA Form AANZ)
30 (Back-to-Back AANZFTA Form AANZ)
31 (ASEAN-Hong Kong FTA Form AHK)
32 (Back-to-Back AHKFTA Form AHK)
33 Regional Comprehensive Economic Partnership (RCEP) Form RCEP
34 Back-to-Back Form RCEP
B015
cbc:Copies Numeric
C
1 n..2
Specify additional number of copies required for this Certificate
Type.', '/cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Outward Carrier Agent Party C 1 a) Specify Outward Carrier Agent, must be registered with Customs.', 'B018
cbc:Currency Code
C
1 a3
All values in the Certificate at item level will be assumed to be
SGD unless specified here.', 'DEKAI should produce a compliance decision for 3 - Road.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC3-R002', '3', '/cac:Party Name
/cac:Freight Forwarder Party
A040
cac:Outward Carrier Agent Party
C
1
a) Specify Outward Carrier Agent, must be registered with Customs.', 'business_rule', 'Road', 'B076 cbc:Conveyance Reference Number C 1 an..17 Mandatory for transport mode = 1, specify voyage number.', '/cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Outward Carrier Agent Party C 1 a) Specify Outward Carrier Agent, must be registered with Customs.', '/cac:Party Name
/cac:Freight Forwarder Party
A040
cac:Outward Carrier Agent Party
C
1
a) Specify Outward Carrier Agent, must be registered with Customs.', 'unit Code (attribute) M 1 an..3 Specify unit (refer to UN/ECE Recommendation No.', 'DEKAI should produce a compliance decision for 3 - Road.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '3: Road
4: Air
B082 cbc:Mode Code M 1 n1 Specify Outward Transport Mode.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B076 cbc:Conveyance Reference Number C 1 an..17 Mandatory for transport mode = 1, specify voyage number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'Specify ‘NA’ if there is no voyage number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'For transport mode = 4, specify outward flight number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'Specify ‘NA’
if there is no outward flight number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B049 cbc:Transport Identifier C 1 an..35 Mandatory for transport mode = 1, specify vessel name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'For transport mode = 3, specify Vehicle Licence/Registration Number,
if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'For transport mode = 4, specify outward Aircraft Registration Number
for chartered flights, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Transport Mode
/cac:Transport Means
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
28 (Back-to-Back AIFTA Form AI)
29 (Asean-Australia-New Zealand FTA Form AANZ)
30 (Back-to-Back AANZFTA Form AANZ)
31 (ASEAN-Hong Kong FTA Form AHK)
32 (Back-to-Back AHKFTA Form AHK)
33 Regional Comprehensive Economic Partnership (RCEP) Form RCEP
34 Back-to-Back Form RCEP
B015
cbc:Copies Numeric
C
1 n..2
Specify additional number of copies required for this Certificate
Type.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Certificate Detail
B014
cbc:Preference Content Percent
C
1 n..3
i) If Certificate Type = 5, mandatory to specify the percentage of
Commonwealth Preference Content in which the value of each and every
manufactured article in its condition described in the Certificate
is not less than the specified percentage.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'ii) Not applicable for other Certificate Type.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B018
cbc:Currency Code
C
1 a3
All values in the Certificate at item level will be assumed to be
SGD unless specified here.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'Specify currency code (refer to UN/ECE Recommendation No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B038
cbc:Additional Certificate Details
C
5 an..35
Specify certificate additional details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B038
cbc:Transport Details
C
5 an..35
Specify transport details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'coo:Transport
M
1
A036
cac:Outward Transport
M
1
Mandatory to specify OUT transport details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A060
cac:Transport Means
M
1
Mandatory to specify outward transport mode.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '19) are:
3: Road
4: Air
B082
cbc:Mode Code
M
1 n1
Specify Outward Transport Mode.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B076
cbc:Conveyance Reference Number
C
1 an..17
Mandatory for transport mode = 1, specify voyage number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B049
cbc:Transport Identifier
C
1 an..35
Mandatory for transport mode = 1, specify vessel name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Transport Mode
/cac:Transport Means
OFFICIAL (CLOSED)
B020 cbc:Departure Date M 1 n8 Format: CCYYMMDD
For outward transport, mandatory to specify Date of Departure.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B055 cbc:Discharge Port M 1 an..5 For outward transport, mandatory to specify Port of Discharge.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'Specify port code (refer to UN/ECE Recommendation No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B016 cbc:Final Destination Country M 1 a2 Mandatory to specify Country of Final Destination for outward
transport.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'Specify country code (refer to UN/ECE Recommendation No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Outward Transport
coo:Party M 1 Mandatory to specify party details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'Applicable Party Types:
- (Declarant)
- (Declaring Agent, if declared by Agent)
- (Freight Forwarder; optional)
- (Outward Carrier Agent; mandatory if Mode of Transport = 1 and
4; optional for transport mode 2 or 3)
- (Exporter)
- (Consignee)
- (Manufacturer; optional)
A014 cac:Declarant Party M 1 Mandatory to specify the identity of the Declarant.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A043 cac:Person Information M 1 Specify Declarant Person Information.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B012 cbc:Code Value M 1 an..17 Specify Declarant Code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B093 cbc:Name M 1 an..100 Specify Declarant name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Person Information
B071 cbc:Telephone M 1 an..25 Mandatory to specify Declarant contact number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Declarant Party
A040 cac:Declaring Agent Party C 1 Specify Declaring Agent.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A038 cac:Party Identification M 1 Specify Declaring Agent Party Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B036 cbc:ID M 1 an..17 Specify Declaring Agent Entity Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Identification
A039 cac:Party Name M 1 Specify Declaring Agent Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B093 cbc:Name M 2 an..50 Specify Declaring Agent name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Name
/cac:Declaring Agent Party
A040 cac:Freight Forwarder Party C 1 Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator for consol
consignment.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A038 cac:Party Identification M 1 Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator Party
Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B036 cbc:ID M 1 an..17 Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator Entity
Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
B020
cbc:Departure Date
M
1 n8
Format: CCYYMMDD
For outward transport, mandatory to specify Date of Departure.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B055
cbc:Discharge Port
M
1 an..5
For outward transport, mandatory to specify Port of Discharge.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B016
cbc:Final Destination Country
M
1 a2
Mandatory to specify Country of Final Destination for outward
transport.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Outward Transport
coo:Party
M
1
Mandatory to specify party details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'Applicable Party Types:
- (Declarant)
- (Declaring Agent, if declared by Agent)
- (Freight Forwarder; optional)
- (Outward Carrier Agent; mandatory if Mode of Transport = 1 and
4; optional for transport mode 2 or 3)
- (Exporter)
- (Consignee)
- (Manufacturer; optional)
A014
cac:Declarant Party
M
1
Mandatory to specify the identity of the Declarant.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A043
cac:Person Information
M
1
Specify Declarant Person Information.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B012
cbc:Code Value
M
1 an..17
Specify Declarant Code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B093
cbc:Name
M
1 an..100
Specify Declarant name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Person Information
B071
cbc:Telephone
M
1 an..25
Mandatory to specify Declarant contact number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Declarant Party
A040
cac:Declaring Agent Party
C
1
Specify Declaring Agent.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A038
cac:Party Identification
M
1
Specify Declaring Agent Party Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B036
cbc:ID
M
1 an..17
Specify Declaring Agent Entity Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Identification
A039
cac:Party Name
M
1
Specify Declaring Agent Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B093
cbc:Name
M
2 an..50
Specify Declaring Agent name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Name
/cac:Declaring Agent Party
A040
cac:Freight Forwarder Party
C
1
Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator for consol
consignment.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A038
cac:Party Identification
M
1
Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator Party
Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B036
cbc:ID
M
1 an..17
Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator Entity
Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'OFFICIAL (CLOSED)
/cac:Party Identification
A039 cac:Party Name M 1 Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B093 cbc:Name M 2 an..50 Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Outward Carrier Agent Party C 1 a) Specify Outward Carrier Agent, must be registered with Customs.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'b) Mandatory to specify outward carrier agent if outward transport
mode = 1 or 4 (optional for outward transport mode = 2 or 3).');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A038 cac:Party Identification M 1 Specify Outward Carrier Agent Party Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B036 cbc:ID M 1 an..17 Specify Outward Carrier Agent Entity Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Identification
A039 cac:Party Name M 1 Specify Outward Carrier Agent Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B093 cbc:Name M 2 an..50 Specify Outward Carrier Agent name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Name
/cac:Outward Carrier Agent Party
A020 cac:Exporter Party M 1 Mandatory to specify Exporter details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A040 cac:Party Detail M 1 Specify Exporter Party details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A038 cac:Party Identification M 1 Specify Exporter Party Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B036 cbc:ID M 1 an..17 Specify Exporter Entity Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Identification
A039 cac:Party Name M 1 Specify Exporter Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B093 cbc:Name M 2 an..35 Specify Exporter name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Name
/cac:Party Detail
A003 cac:Address Line M 1 Specify Exporter address line.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B038 cbc:Line M 3 an..35 Specify Exporter address.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Address Line
/cac:Exporter Party
A013 cac:Consignee Party M 1 Mandatory to specify consignee name and address.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A039 cac:Party Name M 1 Specify Consignee Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B093 cbc:Name M 2 an..35 Specify Consignee name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Name
A003 cac:Address Line M 1 Specify Consignee address line.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B038 cbc:Line M 3 an..35 Specify Consignee address.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Address Line
/cac:Consignee Party
A020 cac:Manufacturer Party C 1 Specify Manufacturer details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'Mandatory for Certificate Types =
1,2,5,9,10,16,18,19,21, 23, 25, 27, 29, 31 & 33.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'Optional for other
Certificate Types.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A040 cac:Party Detail M 1 Specify Manufacturer Party details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A038 cac:Party Identification M 1 Specify Manufacturer Party Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B036 cbc:ID M 1 an..17 Specify Manufacturer Entity Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Identification
A039 cac:Party Name M 1 Specify Manufacturer Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B093 cbc:Name M 2 an..35 Specify Manufacturer name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Name
Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
/cac:Party Identification
A039
cac:Party Name
M
1
Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B093
cbc:Name
M
2 an..50
Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Name
/cac:Freight Forwarder Party
A040
cac:Outward Carrier Agent Party
C
1
a) Specify Outward Carrier Agent, must be registered with Customs.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A038
cac:Party Identification
M
1
Specify Outward Carrier Agent Party Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B036
cbc:ID
M
1 an..17
Specify Outward Carrier Agent Entity Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Identification
A039
cac:Party Name
M
1
Specify Outward Carrier Agent Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B093
cbc:Name
M
2 an..50
Specify Outward Carrier Agent name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Name
/cac:Outward Carrier Agent Party
A020
cac:Exporter Party
M
1
Mandatory to specify Exporter details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A040
cac:Party Detail
M
1
Specify Exporter Party details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A038
cac:Party Identification
M
1
Specify Exporter Party Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B036
cbc:ID
M
1 an..17
Specify Exporter Entity Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Identification
A039
cac:Party Name
M
1
Specify Exporter Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B093
cbc:Name
M
2 an..35
Specify Exporter name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Name
/cac:Party Detail
A003
cac:Address Line
M
1
Specify Exporter address line.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B038
cbc:Line
M
3 an..35
Specify Exporter address.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Address Line
/cac:Exporter Party
A013
cac:Consignee Party
M
1
Mandatory to specify consignee name and address.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A039
cac:Party Name
M
1
Specify Consignee Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B093
cbc:Name
M
2 an..35
Specify Consignee name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Name
A003
cac:Address Line
M
1
Specify Consignee address line.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B038
cbc:Line
M
3 an..35
Specify Consignee address.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Address Line
/cac:Consignee Party
A020
cac:Manufacturer Party
C
1
Specify Manufacturer details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A040
cac:Party Detail
M
1
Specify Manufacturer Party details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A038
cac:Party Identification
M
1
Specify Manufacturer Party Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B036
cbc:ID
M
1 an..17
Specify Manufacturer Entity Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Identification
A039
cac:Party Name
M
1
Specify Manufacturer Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B093
cbc:Name
M
2 an..35
Specify Manufacturer name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Party Name
OFFICIAL (CLOSED)
/cac:Party Detail
A067 cac:Address M 1 Specify Manufacturer address in following format
A003 cac:Address Line M 1
B038 cbc:Line M 2 an..35 Specify Manufacturer Street and Number/PO Box.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Address Line
B084 cbc:City Name C 1 an..35 Specify Manufacturer city name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B085 cbc:Country Subentity Code C 1 an..9 Specify Manufacturer country subdivision code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B086 cbc:Country Subentity C 1 an..35 Specify Manufacturer country subdivision name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B087 cbc:Postal Zone C 1 an..9 Specify Manufacturer postal code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B016 cbc:Country Code M 1 a2 Specify Manufacturer country code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Address
/cac:Manufacturer Party
cac:Supporting Document Reference C 10 Repeat at most 10 times, specify supporting documents attached to
the declaration if applicable.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'Only the following file formats are allowed:
1) MS Word
2) Adobe PDF
3) MS Excel
4) Image Files
a) Bitmap
b) JPEG
c) GIF Image
d) EMF Image
e) PNG Image
f) TIF Image
B023 cbc:Document ID M 1 an..3 Specify Document type code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B033 cbc:Filename M 1 an..70 Specify Filename of the document.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B068 cbc:Item Sequence Numeric M 1 n..5 Mandatory to specify item Sequence Number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B035 cbc:Item Harmonized System Code M 1 an..10 Mandatory to specify item Harmonized System code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B058 cbc:Harmonized System Quantity M 1 n..16 Specify the item quantity and measure unit specifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'unit Code (attribute) M 1 an..3 Specify unit (refer to UN/ECE Recommendation No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B016 cbc:Origin Country M 1 an2 Mandatory to specify Country of Origin of goods.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B003 cbc:Item CIFFOBValue M 1 n..16 i) Specify FOB value in SGD for permit details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'ii) This FOB value will be printed on the Certificate if the
corresponding FOB value in Item Value below is not provided.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
/cac:Party Detail
A067
cac:Address
M
1
Specify Manufacturer address in following format
A003
cac:Address Line
M
1
B038
cbc:Line
M
2 an..35
Specify Manufacturer Street and Number/PO Box.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Address Line
B084
cbc:City Name
C
1 an..35
Specify Manufacturer city name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B085
cbc:Country Subentity Code
C
1 an..9
Specify Manufacturer country subdivision code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B086
cbc:Country Subentity
C
1 an..35
Specify Manufacturer country subdivision name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B087
cbc:Postal Zone
C
1 an..9
Specify Manufacturer postal code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B016
cbc:Country Code
M
1 a2
Specify Manufacturer country code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Address
/cac:Manufacturer Party
cac:Supporting Document Reference
C
10
Repeat at most 10 times, specify supporting documents attached to
the declaration if applicable.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'Only the following file formats are allowed:
1) MS Word
2) Adobe PDF
3) MS Excel
4) Image Files
a) Bitmap
b) JPEG
c) GIF Image
d) EMF Image
e) PNG Image
f) TIF Image
B023
cbc:Document ID
M
1 an..3
Specify Document type code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B033
cbc:Filename
M
1 an..70
Specify Filename of the document.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B068
cbc:Item Sequence Numeric
M
1 n..5
Mandatory to specify item Sequence Number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B035
cbc:Item Harmonized System Code
M
1 an..10
Mandatory to specify item Harmonized System code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B058
cbc:Harmonized System Quantity
unit Code (attribute)
M
M
1 n..16
1 an..3
Specify the item quantity and measure unit specifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'Specify unit (refer to UN/ECE Recommendation No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B016
cbc:Origin Country
M
1 an2
Mandatory to specify Country of Origin of goods.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B003
cbc:Item CIFFOBValue
M
1 n..16
i) Specify FOB value in SGD for permit details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'OFFICIAL (CLOSED)
B070 cac:Shipping Marks Information C 1 Specify markings on cargo for marks and numbers, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B065 cbc:Shipping Marks M 10 an..17 Repeat at most 10 times, specify markings on cargo for marks and
numbers.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Shipping Marks Information
A028 cac:Item Certificate M 1 Specify Item Certificate detail.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B058 cbc:Item Certificate Quantity C 1 n..16 Optional to specify Certificate item quantity and measurement unit
to be printed on the Certificate.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'The measurement unit need not
match the measurement unit in the Singapore Trade Classification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'unit Code (attribute) M 1 an3 Specify unit (refer to UN/ECE Recommendation No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B003 cbc:Item Value C 1 n..16 i) This CIF/FOB value will be printed on the relevant certificates
ii) Optional for Certificate Type = 9, 16, 17, 19, 20, 21, 22, 23,
24, 25, 26, 27, 28, 29, 30, 31, 32, 33 & 34.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'Not applicable for
other Certificate Types.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A027 cac:Item Certificate Description M 10 Repeat at most ten times, Provide description of the item, including
number and type of packages to be printed on the Certificate.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B038 cbc:Line M 5 an..35 Specify certificate item description.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Item Certificate Description
B020 cbc:Manufacturing Cost Date C 1 n8 Format: CCYYMMDD
Specify Date of Manufacturing Cost Statement/Letter of Undertaking.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'b) Mandatory to Certificate Type = 9.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'c) Optional for other Certificate Type.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'Specify textile category code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'Specify textile quota quantity and measurement unit.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'The measurement
unit need not match the measurement unit in the Singapore Trade
Classification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B064 cbc:Item Invoice Number C 1 an..35 a) Optional for Certificate Types = 1, 2, 3, 12, 16, 17, 19, 20, 21,
22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33 & 34.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'b) Not applicable for other Certificate Types.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'Specify invoice number except for goods under single invoice.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B020 cbc:Item Invoice Date C 1 n8 Format: CCYYMMDD
Specify item invoice date.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B050 cbc:Origin Criterion C 3 an..25 a) Mandatory to specify Origin Criterion details if Certificate Type
= 1, 2, 3, 12, 16, 17, 19, 20, 21, 22, 23, 25, 26, 27, 28, 29,
30, 31, 32, 33 & 34.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'b) Optional for Certificate Type = 24.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
B070
cac:Shipping Marks Information
C
1
Specify markings on cargo for marks and numbers, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B065
cbc:Shipping Marks
M
10 an..17
Repeat at most 10 times, specify markings on cargo for marks and
numbers.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Shipping Marks Information
A028
cac:Item Certificate
M
1
Specify Item Certificate detail.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B058
cbc:Item Certificate Quantity
unit Code (attribute)
C
M
1 n..16
1 an3
Optional to specify Certificate item quantity and measurement unit
to be printed on the Certificate.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B003
cbc:Item Value
C
1 n..16
i) This CIF/FOB value will be printed on the relevant certificates
ii) Optional for Certificate Type = 9, 16, 17, 19, 20, 21, 22, 23,
24, 25, 26, 27, 28, 29, 30, 31, 32, 33 & 34.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'A027
cac:Item Certificate Description
M
10
Repeat at most ten times, Provide description of the item, including
number and type of packages to be printed on the Certificate.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B038
cbc:Line
M
5 an..35
Specify certificate item description.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Item Certificate Description
B020
cbc:Manufacturing Cost Date
C
1 n8
Format: CCYYMMDD
Specify Date of Manufacturing Cost Statement/Letter of Undertaking.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B064
cbc:Item Invoice Number
C
1 an..35
a) Optional for Certificate Types = 1, 2, 3, 12, 16, 17, 19, 20, 21,
22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33 & 34.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B020
cbc:Item Invoice Date
C
1 n8
Format: CCYYMMDD
Specify item invoice date.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B050
cbc:Origin Criterion
C
3 an..25
a) Mandatory to specify Origin Criterion details if Certificate Type
= 1, 2, 3, 12, 16, 17, 19, 20, 21, 22, 23, 25, 26, 27, 28, 29,
30, 31, 32, 33 & 34.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'OFFICIAL (CLOSED)
c) Not applicable for other Certificate Types.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'Specify Origin Criterion according to rules and conditions.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B035 cbc:Harmonized System Code C 1 an..10 Specify Harmonized System code (cater for 6 digit), if applicable.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B014 cbc:Content Percent C 1 n..3 Specify percentage content of origin criterion details, if
applicable.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Item Certificate
SUMMARY SECTION
coo:Summary M 1 Mandatory to specify summary details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B068 cbc:Number Of Items M 1 n..5 Mandatory to specify total number of items declared.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
c) Not applicable for other Certificate Types.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B035
cbc:Harmonized System Code
C
1 an..10
Specify Harmonized System code (cater for 6 digit), if applicable.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B014
cbc:Content Percent
C
1 n..3
Specify percentage content of origin criterion details, if
applicable.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', '/cac:Item Certificate
SUMMARY SECTION
coo:Summary
M
1
Mandatory to specify summary details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'B068
cbc:Number Of Items
M
1 n..5
Mandatory to specify total number of items declared.');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Vehicle Licence');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Trade Net Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Specify additional number of copies required for this Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'If Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Not applicable for other Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'All values in the Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Additional Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'For all Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Mandatory for Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Optional for other
Certificate Types.');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Supporting Document');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Specify Document');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'B033 cbc:Filename M 1 an..70 Specify Filename of the document.');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'This FOB value will be printed on the Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'B033
cbc:Filename
M
1 an..70
Specify Filename of the document.');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Item Certificate M 1 Specify Item Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Item Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Optional to specify Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Optional for Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Not applicable for
other Certificate Types.');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'B038 cbc:Line M 5 an..35 Specify certificate item description.');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Specify Date of Manufacturing Cost Statement');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Applicable only for Application');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Mandatory to Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Optional for other Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Item Invoice');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Specify invoice number except for goods under single invoice.');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Mandatory to specify Origin Criterion details if Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'Specify Item Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'B038
cbc:Line
M
5 an..35
Specify certificate item description.');
INSERT INTO authorities (section_code, authority_name) VALUES ('3', 'Customs');
INSERT INTO exceptions (section_code, exception_text) VALUES ('3', 'B018
cbc:Currency Code
C
1 a3
All values in the Certificate at item level will be assumed to be
SGD unless specified here.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('3', 'unit Code (attribute) M 1 an..3 Specify unit (refer to UN/ECE Recommendation No.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('3', 'B058
cbc:Harmonized System Quantity
unit Code (attribute)
M
M
1 n..16
1 an..3
Specify the item quantity and measure unit specifier.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('3', 'unit Code (attribute) M 1 an3 Specify unit (refer to UN/ECE Recommendation No.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('3', 'Specify invoice number except for goods under single invoice.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('3', 'B058
cbc:Item Certificate Quantity
unit Code (attribute)
C
M
1 n..16
1 an3
Optional to specify Certificate item quantity and measurement unit
to be printed on the Certificate.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('3', 'B058
cbc:Textile Quota Quantity
unit Code (attribute)
C
M
1 n..16
1 an3
a) Applicable only for Application Product Type = TX.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3', 1, 'Evaluate condition: 3: Road
4: Air
B082 cbc:Mode Code M 1 n1 Specify Outward Transport Mode.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3', 2, 'Evaluate condition: B076 cbc:Conveyance Reference Number C 1 an..17 Mandatory for transport mode = 1, specify voyage number.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3', 3, 'Evaluate condition: Specify ‘NA’ if there is no voyage number.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3', 4, '/cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Outward Carrier Agent Party C 1 a) Specify Outward Carrier Agent, must be registered with Customs.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3', 5, '/cac:Party Name
/cac:Freight Forwarder Party
A040
cac:Outward Carrier Agent Party
C
1
a) Specify Outward Carrier Agent, must be registered with Customs.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3', 6, 'Run validation: TDS41-MDS-XML-COODEC-M
Trade Net Declaration.COODEC Ver2.1.doc
OFFICIAL (CLOSED)
28 (Back-to-Back AIFTA Form AI)
29 (Asean-Australia-New Zealand FTA Form AANZ)
30 (Back-to-Back AANZFTA Form AANZ)
31 (ASEAN-Hong Kong FTA Form AHK)
32 (Back-to-Back AHKFTA Form AHK)
33 Regional Comprehensive Economic Partnership (RCEP) Form RCEP
34 Back-to-Back Form RCEP
B015
cbc:Copies Numeric
C
1 n..2
Specify additional number of copies required for this Certificate
Type.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3', 7, 'Run validation: /cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Outward Carrier Agent Party C 1 a) Specify Outward Carrier Agent, must be registered with Customs.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3', 8, 'Run validation: /cac:Party Name
/cac:Freight Forwarder Party
A040
cac:Outward Carrier Agent Party
C
1
a) Specify Outward Carrier Agent, must be registered with Customs.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3', 9, 'Handle exception: B018
cbc:Currency Code
C
1 a3
All values in the Certificate at item level will be assumed to be
SGD unless specified here.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'Air');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'cbc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'any');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'cac');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'Net');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'doc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'XML');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'Ver');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'FTA');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'AHK');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'its');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'not');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'All');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'SGD');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'coo');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'OUT');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'are');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'tags', '3');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'tags', 'Road');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'tags', 'dgft');
INSERT INTO glossary (term, definition) VALUES ('A003', 'Referenced in context: /cac:Party Name
/cac:Party Detail
A003 cac:Address Line M 1 Specify Exporter address line.');
INSERT INTO glossary (term, definition) VALUES ('A009', 'Referenced in context: A009 cac:Certificate Detail M 2 Repeat at most 2 times.');
INSERT INTO glossary (term, definition) VALUES ('A013', 'Referenced in context: /cac:Address Line
/cac:Exporter Party
A013 cac:Consignee Party M 1 Mandatory to specify consignee name and address.');
INSERT INTO glossary (term, definition) VALUES ('A014', 'Referenced in context: Applicable Party Types:
- (Declarant)
- (Declaring Agent, if declared by Agent)
- (Freight Forwarder; optional)
- (Outward Carrier Agent; ma');
INSERT INTO glossary (term, definition) VALUES ('A020', 'Referenced in context: /cac:Party Name
/cac:Outward Carrier Agent Party
A020 cac:Exporter Party M 1 Mandatory to specify Exporter details.');
INSERT INTO glossary (term, definition) VALUES ('A027', 'Referenced in context: A027 cac:Certificate Additional Information C 5 Repeat at most five times.');
INSERT INTO glossary (term, definition) VALUES ('A028', 'Referenced in context: /cac:Shipping Marks Information
A028 cac:Item Certificate M 1 Specify Item Certificate detail.');
INSERT INTO glossary (term, definition) VALUES ('A036', 'Referenced in context: coo:Transport M 1
A036 cac:Outward Transport M 1 Mandatory to specify OUT transport details.');
INSERT INTO glossary (term, definition) VALUES ('A038', 'Referenced in context: A038 cac:Party Identification M 1 Specify Declaring Agent Party Identification.');
INSERT INTO glossary (term, definition) VALUES ('A039', 'Referenced in context: /cac:Party Identification
A039 cac:Party Name M 1 Specify Declaring Agent Party Name.');
INSERT INTO glossary (term, definition) VALUES ('A040', 'Referenced in context: /cac:Declarant Party
A040 cac:Declaring Agent Party C 1 Specify Declaring Agent.');
INSERT INTO glossary (term, definition) VALUES ('A043', 'Referenced in context: A043 cac:Person Information M 1 Specify Declarant Person Information.');
INSERT INTO glossary (term, definition) VALUES ('A060', 'Referenced in context: A060 cac:Transport Means M 1 Mandatory to specify outward transport mode.');
INSERT INTO glossary (term, definition) VALUES ('A061', 'Referenced in context: A061 cac:Transport Mode M 1 For all Declaration Types, valid codes (refer to UN/ECE
Recommendation No.');
INSERT INTO glossary (term, definition) VALUES ('A062', 'Referenced in context: A062 cac:Unique Reference Number M 1 Format:
Declarant entity identifier = XXXXXXXXXXXXXXXXX
Date of Creation = CCYYMMDD
Sequence Numeric =');
INSERT INTO glossary (term, definition) VALUES ('A067', 'Referenced in context: /cac:Party Name
OFFICIAL (CLOSED)
/cac:Party Detail
A067 cac:Address M 1 Specify Manufacturer address in following format
A003 cac:Address L');
INSERT INTO glossary (term, definition) VALUES ('AANZ', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('AANZFTA', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('ACFTA', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('AHK', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('AHKFTA', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('AI', 'Referenced in section title ''MESSAGE DETAILS''.');
INSERT INTO glossary (term, definition) VALUES ('AIFTA', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('AJ', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('AJCEP', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('AK', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('AKFTA', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('AND', 'Referenced in section title ''DEFINITIONS AND ABBREVIATIONS''.');
INSERT INTO glossary (term, definition) VALUES ('APERAK', 'Referenced in context: REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and Application of Certificate of Origin 0.1
(TCODEC');
INSERT INTO glossary (term, definition) VALUES ('ASEAN', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('ATIGA', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('B003', 'Referenced in context: B003 cbc:Item CIFFOBValue M 1 n..16 i) Specify FOB value in SGD for permit details.');
INSERT INTO glossary (term, definition) VALUES ('B005', 'Referenced in context: OFFICIAL (CLOSED)
/cac:Certificate Additional Information
coo:Certificate M 1 Mandatory to specify certificate details
B005 cbc:Application');
INSERT INTO glossary (term, definition) VALUES ('B006', 'Referenced in context: B083 cbc:Common Access Reference M 1 an..7 COODEC
B006 cbc:Application Type M 1 an3 Specify Application Type eg.');
INSERT INTO glossary (term, definition) VALUES ('B010', 'Referenced in context: B010 cbc:Textile Category Code C 1 an..5 a) Applicable only for Application Product Type = TX.');
INSERT INTO glossary (term, definition) VALUES ('B011', 'Referenced in context: B011 cbc:Certificate Type M 1 an..2 Specify Certificate Type eg.');
INSERT INTO glossary (term, definition) VALUES ('B012', 'Referenced in context: B012 cbc:Code Value M 1 an..17 Specify Declarant Code.');
INSERT INTO glossary (term, definition) VALUES ('B014', 'Referenced in context: /cac:Certificate Detail
B014 cbc:Preference Content Percent C 1 n..3 i) If Certificate Type = 5, mandatory to specify the percentage of
Comm');
INSERT INTO glossary (term, definition) VALUES ('B015', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('B016', 'Referenced in context: B016 cbc:GSPDonor Country C 1 an2 Mandatory for Certificate Type 2 to specify GSP Donor Country
(Donation Acting Country).');
INSERT INTO glossary (term, definition) VALUES ('B018', 'Referenced in context: B018 cbc:Currency Code C 1 a3 All values in the Certificate at item level will be assumed to be
SGD unless specified here.');
INSERT INTO glossary (term, definition) VALUES ('B020', 'Referenced in context: B020 cbc:Date M 1 n8 Specify date of Creation.');
INSERT INTO glossary (term, definition) VALUES ('B023', 'Referenced in context: Only the following file formats are allowed:
1) MS Word
2) Adobe PDF
3) MS Excel
4) Image Files
a) Bitmap
b) JPEG
c) GIF Image
d) EMF Image');
INSERT INTO glossary (term, definition) VALUES ('B033', 'Referenced in context: B033 cbc:Filename M 1 an..70 Specify Filename of the document.');
INSERT INTO glossary (term, definition) VALUES ('B035', 'Referenced in context: B035 cbc:Item Harmonized System Code M 1 an..10 Mandatory to specify item Harmonized System code.');
INSERT INTO glossary (term, definition) VALUES ('B036', 'Referenced in context: A062 cac:Unique Reference Number M 1 Format:
Declarant entity identifier = XXXXXXXXXXXXXXXXX
Date of Creation = CCYYMMDD
Sequence Numeric =');
INSERT INTO glossary (term, definition) VALUES ('B037', 'Referenced in context: COO=Application of Certificate Of Origin
B037 cbc:Declaration Indicator M boolean Mandatory to specify declaration indicator.');
INSERT INTO glossary (term, definition) VALUES ('B038', 'Referenced in context: B038 cbc:Line M 5 an..35 specify certificate additional information.');
INSERT INTO glossary (term, definition) VALUES ('B045', 'Referenced in context: MESSAGE DETAILS
User defined
Ref Tag name S R Repr Remarks
HEADER SECTION
coo:Header M 1
B045 cbc:Message Reference M 1 an..14 Sender unique');
INSERT INTO glossary (term, definition) VALUES ('B049', 'Referenced in context: B049 cbc:Transport Identifier C 1 an..35 Mandatory for transport mode = 1, specify vessel name.');
INSERT INTO glossary (term, definition) VALUES ('B050', 'Referenced in context: B050 cbc:Origin Criterion C 3 an..25 a) Mandatory to specify Origin Criterion details if Certificate Type
= 1, 2, 3, 12, 16, 17, 19, 20, 21,');
INSERT INTO glossary (term, definition) VALUES ('B055', 'Referenced in context: B055 cbc:Discharge Port M 1 an..5 For outward transport, mandatory to specify Port of Discharge.');
INSERT INTO glossary (term, definition) VALUES ('B058', 'Referenced in context: B058 cbc:Harmonized System Quantity M 1 n..16 Specify the item quantity and measure unit specifier.');
INSERT INTO glossary (term, definition) VALUES ('B064', 'Referenced in context: B064 cbc:Previous Permit Number C 1 an..35 Specify previous Permit Number.');
INSERT INTO glossary (term, definition) VALUES ('B065', 'Referenced in context: /cac:Unique Reference Number
B065 cbc:Declarant ID M 1 an..17 Specify Applicant/Declarant Id.');
INSERT INTO glossary (term, definition) VALUES ('B068', 'Referenced in context: B068 cbc:Sequence Numeric M 1 n..');
INSERT INTO glossary (term, definition) VALUES ('B070', 'Referenced in context: OFFICIAL (CLOSED)
B070 cac:Shipping Marks Information C 1 Specify markings on cargo for marks and numbers, if any.');
INSERT INTO glossary (term, definition) VALUES ('B071', 'Referenced in context: /cac:Person Information
B071 cbc:Telephone M 1 an..25 Mandatory to specify Declarant contact number.');
INSERT INTO glossary (term, definition) VALUES ('B076', 'Referenced in context: B076 cbc:Conveyance Reference Number C 1 an..17 Mandatory for transport mode = 1, specify voyage number.');
INSERT INTO glossary (term, definition) VALUES ('B079', 'Referenced in context: The valid application product
types are:
NA=Application for non-textile products at Airport
NH=Application for non-textile products at Headq');
INSERT INTO glossary (term, definition) VALUES ('B082', 'Referenced in context: 3: Road
4: Air
B082 cbc:Mode Code M 1 n1 Specify Outward Transport Mode.');
INSERT INTO glossary (term, definition) VALUES ('B083', 'Referenced in context: B083 cbc:Common Access Reference M 1 an..7 COODEC
B006 cbc:Application Type M 1 an3 Specify Application Type eg.');
INSERT INTO glossary (term, definition) VALUES ('B084', 'Referenced in context: /cac:Address Line
B084 cbc:City Name C 1 an..35 Specify Manufacturer city name.');
INSERT INTO glossary (term, definition) VALUES ('B085', 'Referenced in context: B085 cbc:Country Subentity Code C 1 an..9 Specify Manufacturer country subdivision code.');
INSERT INTO glossary (term, definition) VALUES ('B086', 'Referenced in context: B086 cbc:Country Subentity C 1 an..35 Specify Manufacturer country subdivision name.');
INSERT INTO glossary (term, definition) VALUES ('B087', 'Referenced in context: B087 cbc:Postal Zone C 1 an..9 Specify Manufacturer postal code.');
INSERT INTO glossary (term, definition) VALUES ('B093', 'Referenced in context: B093 cbc:Name M 1 an..100 Specify Declarant name.');
INSERT INTO glossary (term, definition) VALUES ('CA', 'Referenced in context: SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Fr');
INSERT INTO glossary (term, definition) VALUES ('CCYY', 'Referenced in context: The valid application product
types are:
NA=Application for non-textile products at Airport
NH=Application for non-textile products at Headq');
INSERT INTO glossary (term, definition) VALUES ('CCYYMMDD', 'Referenced in context: A062 cac:Unique Reference Number M 1 Format:
Declarant entity identifier = XXXXXXXXXXXXXXXXX
Date of Creation = CCYYMMDD
Sequence Numeric =');
INSERT INTO glossary (term, definition) VALUES ('CECA', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('CEFACT', 'Referenced in context: REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and Application of Certificate of Origin 0.1
(TCODEC');
INSERT INTO glossary (term, definition) VALUES ('CEP', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('CIF', 'Referenced in context: B003 cbc:Item Value C 1 n..16 i) This CIF/FOB value will be printed on the relevant certificates
ii) Optional for Certificate Type = 9, 16,');
INSERT INTO glossary (term, definition) VALUES ('CLOSED', 'Referenced in context: Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (C');
INSERT INTO glossary (term, definition) VALUES ('CO', 'Referenced in context: 5.1 Abbreviations
APERAK Application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic');
INSERT INTO glossary (term, definition) VALUES ('COD', 'Referenced in context: 20, Codes CEFACT/ICG/2010/IC013 13 Sep 10
for Units of Measure Used in International Trade
12 Codes for Units of Measure Used in Internation');
INSERT INTO glossary (term, definition) VALUES ('COO', 'Referenced in context: They are:
Code Application Type Transfer Conditions
COO Application for Certificate of To allow the Declarant to apply for the Certificate o');
INSERT INTO glossary (term, definition) VALUES ('COODCI', 'Referenced in context: REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and Application of Certificate of Origin 0.1
(TCODEC');
INSERT INTO glossary (term, definition) VALUES ('COODEC', 'Referenced in context: COODEC
message to be used in Extensible Markup Language (XML) between trading partners involved in administration, commerce and
transport.');
INSERT INTO glossary (term, definition) VALUES ('DE', 'Referenced in context: 5.1 Abbreviations
APERAK Application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic');
INSERT INTO glossary (term, definition) VALUES ('DEFINITION', 'Referenced in section title ''MESSAGE DEFINITION''.');
INSERT INTO glossary (term, definition) VALUES ('DETAILS', 'Referenced in section title ''MESSAGE DETAILS''.');
INSERT INTO glossary (term, definition) VALUES ('ECE', 'Referenced in context: REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and Application of Certificate of Origin 0.1
(TCODEC');
INSERT INTO glossary (term, definition) VALUES ('EDI', 'Referenced in context: 5.1 Abbreviations
APERAK Application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic');
INSERT INTO glossary (term, definition) VALUES ('EDIFACT', 'Referenced in context: The segments, composite data elements, data elements and codes used in this document are based on the respective directories
in the UN/EDIFA');
INSERT INTO glossary (term, definition) VALUES ('EMF', 'Referenced in context: Only the following file formats are allowed:
1) MS Word
2) Adobe PDF
3) MS Excel
4) Image Files
a) Bitmap
b) JPEG
c) GIF Image
d) EMF Image');
INSERT INTO glossary (term, definition) VALUES ('ERRORM', 'Referenced in context: REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and Application of Certificate of Origin 0.1
(TCODEC');
INSERT INTO glossary (term, definition) VALUES ('EU', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('FIELD', 'Referenced in section title ''FIELD OF APPLICATION''.');
INSERT INTO glossary (term, definition) VALUES ('FOB', 'Referenced in context: B003 cbc:Item CIFFOBValue M 1 n..16 i) Specify FOB value in SGD for permit details.');
INSERT INTO glossary (term, definition) VALUES ('FORMAT', 'Referenced in context: The valid application product
types are:
NA=Application for non-textile products at Airport
NH=Application for non-textile products at Headq');
INSERT INTO glossary (term, definition) VALUES ('FTA', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('FUNCTION', 'Referenced in section title ''MESSAGE FUNCTION''.');
INSERT INTO glossary (term, definition) VALUES ('GIF', 'Referenced in context: Only the following file formats are allowed:
1) MS Word
2) Adobe PDF
3) MS Excel
4) Image Files
a) Bitmap
b) JPEG
c) GIF Image
d) EMF Image');
INSERT INTO glossary (term, definition) VALUES ('GSP', 'Referenced in context: B016 cbc:GSPDonor Country C 1 an2 Mandatory for Certificate Type 2 to specify GSP Donor Country
(Donation Acting Country).');
INSERT INTO glossary (term, definition) VALUES ('GST', 'Referenced in context: 5.1 Abbreviations
APERAK Application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic');
INSERT INTO glossary (term, definition) VALUES ('GSTP', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('HEADER', 'Referenced in context: MESSAGE DETAILS
User defined
Ref Tag name S R Repr Remarks
HEADER SECTION
coo:Header M 1
B045 cbc:Message Reference M 1 an..14 Sender unique');
INSERT INTO glossary (term, definition) VALUES ('IC013', 'Referenced in context: 20, Codes CEFACT/ICG/2010/IC013 13 Sep 10
for Units of Measure Used in International Trade
12 Codes for Units of Measure Used in Internation');
INSERT INTO glossary (term, definition) VALUES ('ICG', 'Referenced in context: 20, Codes CEFACT/ICG/2010/IC013 13 Sep 10
for Units of Measure Used in International Trade
12 Codes for Units of Measure Used in Internation');
INSERT INTO glossary (term, definition) VALUES ('ID', 'Referenced in context: A062 cac:Unique Reference Number M 1 Format:
Declarant entity identifier = XXXXXXXXXXXXXXXXX
Date of Creation = CCYYMMDD
Sequence Numeric =');
INSERT INTO glossary (term, definition) VALUES ('IE', 'Referenced in context: This document shall be used as a baseline for the interface software design and shall be agreed upon by representative from
IE Singapore and');
INSERT INTO glossary (term, definition) VALUES ('IESGP', 'Referenced in context: SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Fr');
INSERT INTO glossary (term, definition) VALUES ('II', 'Referenced in context: 20, Codes CEFACT/ICG/2010/IC013 13 Sep 10
for Units of Measure Used in International Trade
12 Codes for Units of Measure Used in Internation');
INSERT INTO glossary (term, definition) VALUES ('III', 'Referenced in context: 20, Codes CEFACT/ICG/2010/IC013 13 Sep 10
for Units of Measure Used in International Trade
12 Codes for Units of Measure Used in Internation');
INSERT INTO glossary (term, definition) VALUES ('ITEM', 'Referenced in context: /cac:Supporting Document Reference
ITEM SECTION
coo:Item M 50 Mandatory to repeat at most 50 times.');
INSERT INTO glossary (term, definition) VALUES ('JPEG', 'Referenced in context: Only the following file formats are allowed:
1) MS Word
2) Adobe PDF
3) MS Excel
4) Image Files
a) Bitmap
b) JPEG
c) GIF Image
d) EMF Image');
INSERT INTO glossary (term, definition) VALUES ('LOCODE', 'Referenced in context: 16, ECE/TRADE/227 Dec 98
UN/LOCODE - Code for the Trade and Transport Locations
10 UN/ECE WP Trade Facilitation Recommendation No.');
INSERT INTO glossary (term, definition) VALUES ('MDS', 'Referenced in context: Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (C');
INSERT INTO glossary (term, definition) VALUES ('MESSAGE', 'Referenced in context: Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (C');
INSERT INTO glossary (term, definition) VALUES ('MS', 'Referenced in context: Only the following file formats are allowed:
1) MS Word
2) Adobe PDF
3) MS Excel
4) Image Files
a) Bitmap
b) JPEG
c) GIF Image
d) EMF Image');
INSERT INTO glossary (term, definition) VALUES ('NA', 'Referenced in context: The valid application product
types are:
NA=Application for non-textile products at Airport
NH=Application for non-textile products at Headq');
INSERT INTO glossary (term, definition) VALUES ('NH', 'Referenced in context: The valid application product
types are:
NA=Application for non-textile products at Airport
NH=Application for non-textile products at Headq');
INSERT INTO glossary (term, definition) VALUES ('NVOCC', 'Referenced in context: /cac:Party Name
/cac:Declaring Agent Party
A040 cac:Freight Forwarder Party C 1 Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator for');
INSERT INTO glossary (term, definition) VALUES ('OF', 'Referenced in section title ''FIELD OF APPLICATION''.');
INSERT INTO glossary (term, definition) VALUES ('OFFICIAL', 'Referenced in context: Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (C');
INSERT INTO glossary (term, definition) VALUES ('OUT', 'Referenced in context: coo:Transport M 1
A036 cac:Outward Transport M 1 Mandatory to specify OUT transport details.');
INSERT INTO glossary (term, definition) VALUES ('PDF', 'Referenced in context: Only the following file formats are allowed:
1) MS Word
2) Adobe PDF
3) MS Excel
4) Image Files
a) Bitmap
b) JPEG
c) GIF Image
d) EMF Image');
INSERT INTO glossary (term, definition) VALUES ('PNG', 'Referenced in context: Only the following file formats are allowed:
1) MS Word
2) Adobe PDF
3) MS Excel
4) Image Files
a) Bitmap
b) JPEG
c) GIF Image
d) EMF Image');
INSERT INTO glossary (term, definition) VALUES ('PO', 'Referenced in context: /cac:Party Name
OFFICIAL (CLOSED)
/cac:Party Detail
A067 cac:Address M 1 Specify Manufacturer address in following format
A003 cac:Address L');
INSERT INTO glossary (term, definition) VALUES ('RCEP', 'Referenced in context: 1 (GSP Form A)
2 (GSP Form A under Cumulative ASEAN)
3 (Back-to-Back GSP Form A)
4 (Ordinary Certificate of Origin)
4A (Certificate of Proce');
INSERT INTO glossary (term, definition) VALUES ('REFERENCES', 'Referenced in section title ''REFERENCES''.');
INSERT INTO glossary (term, definition) VALUES ('RESPONSE', 'Referenced in context: REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and Application of Certificate of Origin 0.1
(TCODEC');
INSERT INTO glossary (term, definition) VALUES ('SC', 'Referenced in context: 5.1 Abbreviations
APERAK Application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic');
INSERT INTO glossary (term, definition) VALUES ('SCOPE', 'Referenced in section title ''SCOPE''.');
INSERT INTO glossary (term, definition) VALUES ('SECTION', 'Referenced in context: MESSAGE DETAILS
User defined
Ref Tag name S R Repr Remarks
HEADER SECTION
coo:Header M 1
B045 cbc:Message Reference M 1 an..14 Sender unique');
INSERT INTO glossary (term, definition) VALUES ('SGD', 'Referenced in context: B018 cbc:Currency Code C 1 a3 All values in the Certificate at item level will be assumed to be
SGD unless specified here.');
INSERT INTO glossary (term, definition) VALUES ('STATUS', 'Referenced in context: REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and Application of Certificate of Origin 0.1
(TCODEC');
INSERT INTO glossary (term, definition) VALUES ('STATUSA', 'Referenced in context: REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and Application of Certificate of Origin 0.1
(TCODEC');
INSERT INTO glossary (term, definition) VALUES ('STDID', 'Referenced in context: 20, Codes CEFACT/ICG/2010/IC013 13 Sep 10
for Units of Measure Used in International Trade
12 Codes for Units of Measure Used in Internation');
INSERT INTO glossary (term, definition) VALUES ('SUMMARY', 'Referenced in context: /cac:Item Certificate
SUMMARY SECTION
coo:Summary M 1 Mandatory to specify summary details.');
INSERT INTO glossary (term, definition) VALUES ('TCODEC', 'Referenced in context: REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and Application of Certificate of Origin 0.1
(TCODEC');
INSERT INTO glossary (term, definition) VALUES ('TDS41', 'Referenced in context: Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (C');
INSERT INTO glossary (term, definition) VALUES ('TIF', 'Referenced in context: Only the following file formats are allowed:
1) MS Word
2) Adobe PDF
3) MS Excel
4) Image Files
a) Bitmap
b) JPEG
c) GIF Image
d) EMF Image');
INSERT INTO glossary (term, definition) VALUES ('TRADE', 'Referenced in context: 9, ECE/TRADE/203 1 Jan 96
Alphabetic Code for the Representation of Currencies
9 UN/ECE WP Trade Facilitation Recommendation No.');
INSERT INTO glossary (term, definition) VALUES ('TRADENET', 'Referenced in context: Trade Net Declaration.COODEC Ver2.1.doc Message Specification XML (COODEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-COODEC-M
OFFICIAL (C');
INSERT INTO glossary (term, definition) VALUES ('TRANSPORT', 'OFFICIAL (CLOSED)
B020 cbc:Departure Date M 1 n8 Format: CCYYMMDD
For outward transport, mandatory to specify Date of Departure');
INSERT INTO glossary (term, definition) VALUES ('TTSB', 'Referenced in context: “I/We declare that all the product(s) to be exported in this
Application has/have been registered with the TTSB of Singapore
Customs and qua');
INSERT INTO glossary (term, definition) VALUES ('TX', 'Referenced in context: REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and Application of Certificate of Origin 0.1
(TCODEC');
INSERT INTO glossary (term, definition) VALUES ('UN', 'Referenced in context: The segments, composite data elements, data elements and codes used in this document are based on the respective directories
in the UN/EDIFA');
INSERT INTO glossary (term, definition) VALUES ('UNSM', 'Referenced in context: 5.1 Abbreviations
APERAK Application Error and Acknowledgement
CA Controlling Agency
CO Certificate of Origin
DE Data Element
EDI Electronic');
INSERT INTO glossary (term, definition) VALUES ('WP', 'Referenced in context: REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Declaration and Application of Certificate of Origin 0.1
(TCODEC');
INSERT INTO glossary (term, definition) VALUES ('XML', 'Referenced in context: COODEC
message to be used in Extensible Markup Language (XML) between trading partners involved in administration, commerce and
transport.');