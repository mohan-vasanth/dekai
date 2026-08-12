INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.IPTDEC Ver2.1 (2).pdf', '', 'TradeNetDeclaration.IPTDEC Ver2.1 (2)', '1', 'INTRODUCTION', 'INTRODUCTION
This specification provides the definition of the Customs Declaration message to be used in Extensible Markup Language
(XML) between trading partners involved in Administration, commerce and transport.', 'Indha INTRODUCTION section-la, INTRODUCTION
This specification provides the definition of the Customs Declaration message to be used in Extensible Markup Language
(XML) between trading partners involved in Administration, commerce and transport.', '1. INTRODUCTION
This specification provides the definition of the Customs Declaration message to be used in Extensible Markup Language
(XML) between trading partners involved in Administration, commerce and transport. This document shall be used as a baseline for the interface software design and shall be agreed upon by representatives
from the Singapore Customs (SC)and Crimson Logic Pte Ltd.', 'INTRODUCTION governs how DGFT business controls should be applied, validated, and enforced.', 'INTRODUCTION explains the operating rule set that DEKAI should enforce. Key control points include This document shall be used as a baseline for the interface software design and shall be agreed upon by representatives
from the Singapore Customs (SC)and Crimson Logic Pte Ltd.', 'Indha INTRODUCTION section-la, INTRODUCTION explains the operating rule set that DEKAI should enforce. Key control points include This document kandippa be used as a baseline for the interface software design and kandippa be agreed upon by representatives
from the Singapore Customs (SC)and Crimson Logic Pte Ltd.', '1. INTRODUCTION
This specification provides the definition of the Customs Declaration message to be used in Extensible Markup Language
(XML) between trading partners involved in Administration, commerce and transport.
This document shall be used as a baseline for the interface software design and shall be agreed upon by representatives
from the Singapore Customs (SC)and Crimson Logic Pte Ltd.', '[2]', '["the", "XML", "and", "for", "Pte", "Ltd", "This", "used", "upon", "from", "shall", "Logic", "Markup", "design", "agreed", "Customs", "message", "between", "trading", "Crimson"]', 'Provide knowledge guidance for INTRODUCTION.', '["1", "INTRODUCTION", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC1-R001', '1', 'This document shall be used as a baseline for the interface software design and shall be agreed upon by representatives
from the Singapore Customs (SC)and Crimson Logic Pte Ltd.', 'business_rule', 'INTRODUCTION', 'INTRODUCTION
This specification provides the definition of the Customs Declaration message to be used in Extensible Markup Language
(XML) between trading partners involved in Administration, commerce and transport.', 'This document shall be used as a baseline for the interface software design and shall be agreed upon by representatives
from the Singapore Customs (SC)and Crimson Logic Pte Ltd.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 1 - INTRODUCTION.');
INSERT INTO conditions (section_code, condition_text) VALUES ('1', 'INTRODUCTION
This specification provides the definition of the Customs Declaration message to be used in Extensible Markup Language
(XML) between trading partners involved in Administration, commerce and transport.');
INSERT INTO conditions (section_code, condition_text) VALUES ('1', 'This document shall be used as a baseline for the interface software design and shall be agreed upon by representatives
from the Singapore Customs (SC)and Crimson Logic Pte Ltd.');
INSERT INTO documents (section_code, document_name) VALUES ('1', 'This specification provides the definition of the Customs Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('1', 'This document shall be used as a baseline for the interface software design and shall be agreed upon by representatives
from the Singapore Customs (SC)and Crimson Logic Pte Ltd.');
INSERT INTO authorities (section_code, authority_name) VALUES ('1', 'Customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('1', 'This specification provides the definition of the Customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('1', 'Singapore Customs');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('1', 1, 'Evaluate condition: INTRODUCTION
This specification provides the definition of the Customs Declaration message to be used in Extensible Markup Language
(XML) between trading partners involved in Administration, commerce and transport.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('1', 2, 'Evaluate condition: This document shall be used as a baseline for the interface software design and shall be agreed upon by representatives
from the Singapore Customs (SC)and Crimson Logic Pte Ltd.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('1', 3, 'Run validation: This document shall be used as a baseline for the interface software design and shall be agreed upon by representatives
from the Singapore Customs (SC)and Crimson Logic Pte Ltd.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'XML');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'Pte');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'Ltd');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'This');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'used');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'upon');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'from');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'shall');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'Logic');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'Markup');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'design');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'agreed');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'Customs');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'message');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'between');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'trading');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'Crimson');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'tags', '1');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'tags', 'INTRODUCTION');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.IPTDEC Ver2.1 (2).pdf', '', 'TradeNetDeclaration.IPTDEC Ver2.1 (2)', '2', 'SCOPE', 'SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to SC and CAs (if
applicable).', 'Indha SCOPE section-la, SCOPE
The document kandippa provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to SC and CAs (if
applicable).', '2. SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to SC and CAs (if
applicable). - message format.', 'SCOPE governs how DGFT business controls should be applied, validated, and enforced.', 'SCOPE explains the operating rule set that DEKAI should enforce. Key control points include SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to SC and CAs (if
applicable).', 'Indha SCOPE section-la, SCOPE explains the operating rule set that DEKAI should enforce. Key control points include SCOPE
The document kandippa provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to SC and CAs (if
applicable).', '2. SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to SC and CAs (if
applicable).
- message format.
The segments, composite data elements, data elements and codes used in this document are based on the respective
directories in the UN/CEFACT. Refer to references 3 to 12 for more details.
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
2. SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to SC and CAs (if
applicable).
- message format.
The segments, composite data elements, data elements and codes used in this document are based on the respective
directories in the UN/CEFACT. Refer to references 3 to 12 for more details.
OFFICIAL (CLOSED)
AM', '[2, 3]', '["The", "and", "for", "CAs", "are", "Net", "doc", "XML", "Ver", "from", "data", "used", "this", "more", "Date", "SCOPE", "shall", "Cargo", "codes", "based"]', 'Provide knowledge guidance for SCOPE.', '["2", "SCOPE", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC2-R001', '2', 'SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to SC and CAs (if
applicable).', 'business_rule', 'SCOPE', 'SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to SC and CAs (if
applicable).', 'SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to SC and CAs (if
applicable).', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 2 - SCOPE.');
INSERT INTO conditions (section_code, condition_text) VALUES ('2', 'SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to SC and CAs (if
applicable).');
INSERT INTO conditions (section_code, condition_text) VALUES ('2', 'Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
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
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to SC and CAs (if
applicable).');
INSERT INTO documents (section_code, document_name) VALUES ('2', 'The segments, composite data elements, data elements and codes used in this document are based on the respective
directories in the UN/CEFACT.');
INSERT INTO documents (section_code, document_name) VALUES ('2', 'Trade Net Declaration');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('2', 1, 'Evaluate condition: SCOPE
The document shall provide the following principles and details for the following:
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to SC and CAs (if
applicable).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('2', 2, 'Evaluate condition: Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
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
- criteria for passing information from Traders, Freight Forwarders, Cargo Agents and Shipping Agents to SC and CAs (if
applicable).');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'The');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'CAs');
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
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'codes');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'based');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'tags', '2');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'tags', 'SCOPE');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.IPTDEC Ver2.1 (2).pdf', '', 'TradeNetDeclaration.IPTDEC Ver2.1 (2)', '3', 'FIELD OF APPLICATION', 'FIELD OF APPLICATION
The message specification provided in this document are intended for use for the exchange of information between the
trading partners in international trade.', 'Indha FIELD OF APPLICATION section-la, FIELD OF application
The message specification provided in this document are intended for use for the exchange of information between the
trading partners in international trade.', '3. FIELD OF APPLICATION
The message specification provided in this document are intended for use for the exchange of information between the
trading partners in international trade. This message may be applied for both national and international trade.', '3.', '3. FIELD OF APPLICATION
The message specification provided in this document are intended for use for the exchange of information between the
trading partners in international trade. This message may be applied for both national and international trade.', 'Indha FIELD OF APPLICATION section-la, 3. FIELD OF application
The message specification provided in this document are intended for use for the exchange of information between the
trading partners in international trade. This message may be applied for both national and international trade.', '3. FIELD OF APPLICATION
The message specification provided in this document are intended for use for the exchange of information between the
trading partners in international trade. This message may be applied for both national and international trade. It is
based on universal practice and is not dependent on the type of business or industry.', '[3]', '["The", "are", "for", "use", "may", "and", "not", "this", "both", "type", "FIELD", "trade", "based", "message", "between", "trading", "applied", "provided", "document", "intended"]', 'Provide knowledge guidance for FIELD OF APPLICATION.', '["3", "FIELD OF APPLICATION", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC3-R001', '3', '3. FIELD OF APPLICATION
The message specification provided in this document are intended for use for the exchange of information between the
trading partners in international trade. This message may be applied for both national and international trade.', 'business_rule', 'FIELD OF APPLICATION', 'FIELD OF APPLICATION
The message specification provided in this document are intended for use for the exchange of information between the
trading partners in international trade.', 'Not explicitly covered in uploaded documents.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 3 - FIELD OF APPLICATION.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3', 'FIELD OF APPLICATION
The message specification provided in this document are intended for use for the exchange of information between the
trading partners in international trade.');
INSERT INTO documents (section_code, document_name) VALUES ('3', 'FIELD OF APPLICATION
The message specification provided in this document are intended for use for the exchange of information between the
trading partners in international trade.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3', 1, 'Evaluate condition: FIELD OF APPLICATION
The message specification provided in this document are intended for use for the exchange of information between the
trading partners in international trade.');
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
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.IPTDEC Ver2.1 (2).pdf', '', 'TradeNetDeclaration.IPTDEC Ver2.1 (2)', '3.1', 'Principles', 'Provision has also been
made for the inclusion of appropriate commercial information which may be accepted by the Issuing Authorities in lieu of
supporting documentation.', 'Indha Principles section-la, Provision has also been
made for the inclusion of appropriate commercial information which may be accepted by the Issuing Authorities in lieu of
supporting documentation.', '3.1 Principles
This message incorporates the necessary transport, statistical, and declaration information. Provision has also been
made for the inclusion of appropriate commercial information which may be accepted by the Issuing Authorities in lieu of
supporting documentation. The design principles adopted allow for referencing one or more commercial documents pertaining to the same declaration
and for the grouping of document lines into a single customs item.', '3.1 Principles
This message incorporates the necessary transport, statistical, and declaration information.', '3.1 Principles
This message incorporates the necessary transport, statistical, and declaration information. Provision has also been
made for the inclusion of appropriate commercial information which may be accepted by the Issuing Authorities in lieu of
supporting documentation. The design principles adopted allow for referencing one or more commercial documents pertaining to the same declaration
and for the grouping of document lines into a single customs item.', 'Indha Principles section-la, 3.1 Principles
This message incorporates the necessary transport, statistical, and declaration information. Provision has also been
made for the inclusion of appropriate commercial information which may be accepted by the Issuing Authorities in lieu of
supporting documentation. The design principles adopted allow for referencing one or more commercial documents pertaining to the same declaration
and for the grouping of document lines into a single customs item.', '3.1 Principles
This message incorporates the necessary transport, statistical, and declaration information. Provision has also been
made for the inclusion of appropriate commercial information which may be accepted by the Issuing Authorities in lieu of
supporting documentation.
The design principles adopted allow for referencing one or more commercial documents pertaining to the same declaration
and for the grouping of document lines into a single customs item. A customs item consists of the grouping of those
document lines having the same customs characteristics (eg. invoice number, Declaration Type etc). The message
correspondingly permits the use of single or multi-packaging concepts and their identification to a customs item.
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
3.1 Principles
This message incorporates the necessary transport, statistical, and declaration information. Provision has also been
made for the inclusion of appropriate commercial information which may be accepted by the Issuing Authorities in lieu of
supporting documentation.
The design principles adopted allow for referencing one or more commercial documents pertaining to the same declaration
and for the grouping of document lines into a single customs item. A customs item consists of the grouping of those
document lines having the same customs characteristics (eg. invoice number, Declaration Type etc). The message
correspondingly permits the use of single or multi-packaging concepts and their identification to a customs item.
OFFICIAL (CLOSED)
AM', '[3, 4]', '["the", "and", "has", "for", "may", "one", "etc", "use", "Net", "doc", "XML", "Ver", "This", "also", "been", "made", "lieu", "more", "same", "into"]', 'Provide knowledge guidance for Principles.', '["3.1", "Principles", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC3_1-R001', '3.1', '3.1 Principles
This message incorporates the necessary transport, statistical, and declaration information. Provision has also been
made for the inclusion of appropriate commercial information which may be accepted by the Issuing Authorities in lieu of
supporting documentation. The design principles adopted allow for referencing one or more commercial documents pertaining to the same declaration
and for the grouping of document lines into a single customs item.', 'business_rule', 'Principles', 'The message
correspondingly permits the use of single or multi-packaging concepts and their identification to a customs item.', 'Provision has also been
made for the inclusion of appropriate commercial information which may be accepted by the Issuing Authorities in lieu of
supporting documentation.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 3.1 - Principles.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3.1', 'The message
correspondingly permits the use of single or multi-packaging concepts and their identification to a customs item.');
INSERT INTO conditions (section_code, condition_text) VALUES ('3.1', 'Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO documents (section_code, document_name) VALUES ('3.1', '3.1 Principles
This message incorporates the necessary transport, statistical, and declaration information.');
INSERT INTO documents (section_code, document_name) VALUES ('3.1', 'Provision has also been
made for the inclusion of appropriate commercial information which may be accepted by the Issuing Authorities in lieu of
supporting documentation.');
INSERT INTO documents (section_code, document_name) VALUES ('3.1', 'The design principles adopted allow for referencing one or more commercial documents pertaining to the same declaration
and for the grouping of document lines into a single customs item.');
INSERT INTO documents (section_code, document_name) VALUES ('3.1', 'A customs item consists of the grouping of those
document lines having the same customs characteristics (eg.');
INSERT INTO documents (section_code, document_name) VALUES ('3.1', 'invoice number, Declaration Type etc).');
INSERT INTO documents (section_code, document_name) VALUES ('3.1', 'Trade Net Declaration');
INSERT INTO authorities (section_code, authority_name) VALUES ('3.1', 'Issuing Authorities');
INSERT INTO authorities (section_code, authority_name) VALUES ('3.1', 'customs');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3.1', 1, 'Evaluate condition: The message
correspondingly permits the use of single or multi-packaging concepts and their identification to a customs item.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3.1', 2, 'Evaluate condition: Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3.1', 3, 'Run validation: Provision has also been
made for the inclusion of appropriate commercial information which may be accepted by the Issuing Authorities in lieu of
supporting documentation.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'has');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'may');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'one');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'etc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3.1', 'keywords', 'use');
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
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.IPTDEC Ver2.1 (2).pdf', '', 'TradeNetDeclaration.IPTDEC Ver2.1 (2)', '4', 'REFERENCES', '3, Code for the ECE/TRADE/201 1 Jan 96
Representation of Names of Countries - ISO Country Code
5 UN/ECE WP Trade Facilitation Recommendation No.', 'Indha REFERENCES section-la, 3, Code for the ECE/TRADE/201 1 Jan 96
Representation of Names of Countries - ISO Country Code
5 UN/ECE WP Trade Facilitation Recommendation No.', '4. REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Net Declaration message specification TDS41-MDS-XML-
DECLARATION-TX
2 Trade Net Response message specification TDS41-MDS-XML-
RESPONSE-TX
3 UN/CEFACT XML Naming and Design Rules Naming And Design Rules
_2.0.doc
4 UN/ECE WP Recommendation No. 3, Code for the ECE/TRADE/201 1 Jan 96
Representation of Names of Countries - ISO Country Code
5 UN/ECE WP Trade Facilitation Recommendation No.', '4.', '4. REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Net Declaration message specification TDS41-MDS-XML-
DECLARATION-TX
2 Trade Net Response message specification TDS41-MDS-XML-
RESPONSE-TX
3 UN/CEFACT XML Naming and Design Rules Naming And Design Rules
_2.0.doc
4 UN/ECE WP Recommendation No. 3, Code for the ECE/TRADE/201 1 Jan 96
Representation of Names of Countries - ISO Country Code
5 UN/ECE WP Trade Facilitation Recommendation No.', 'Indha REFERENCES section-la, 4. REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Net Declaration message specification TDS41-MDS-XML-
DECLARATION-TX
2 Trade Net Response message specification TDS41-MDS-XML-
RESPONSE-TX
3 UN/CEFACT XML Naming and Design Rules Naming And Design Rules
_2.0.doc
4 UN/ECE WP Recommendation No. 3, Code for the ECE/TRADE/201 1 Jan 96
Representation of Names of Countries - ISO Country Code
5 UN/ECE WP Trade Facilitation Recommendation No.', '4. REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Net Declaration message specification TDS41-MDS-XML-
DECLARATION-TX
2 Trade Net Response message specification TDS41-MDS-XML-
RESPONSE-TX
3 UN/CEFACT XML Naming and Design Rules Naming And Design Rules
_2.0.doc
4 UN/ECE WP Recommendation No. 3, Code for the ECE/TRADE/201 1 Jan 96
Representation of Names of Countries - ISO Country Code
5 UN/ECE WP Trade Facilitation Recommendation No. 9, ECE/TRADE/203 1 Jan 96
Alphabetic Code for the Representation of Currencies
6 UN/ECE WP Trade Facilitation Recommendation No. 16, ECE/TRADE/227 Dec 98
UN/LOCODE - Code for the Trade and Transport Locations
7 UN/ECE WP Trade Facilitation Recommendation No. 19, Code TRADE/CEFACT/2001/19 15 Jan 01
for modes of transport
8 UN/ECE WP Trade Facilitation Recommendation No. 20, Codes CEFACT/ICG/2010/IC01 13 Sep 10
for Units of Measure Used in International Trade 3
9 Codes for Units of Measure Used in International Trade CEFACT/ICG/2010/IC01 13 Sep 10
Annex B: Code elements listed by Quantity 3
Annex I
10 Codes for Units of Measure Used in International Trade CEFACT/ICG/2010/IC01 13 Sep 10
Annex C: Code elements listed by common code & name 3
Annex II & Annex III
11 UN/ECE WP Trade Facilitation Recommendation No. 21, Codes CEFACT/ICG/2010/IC01 12 Jul 10
for Types of Cargo, Packages and Packaging Material 0/Rev.1
12 STDID Code Lists STDID-TDS41-COD
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
S/
N | Document Name | Document/Directory
Reference | Rev | Date
1 | Trade Net Declaration message specification | TDS41-MDS-XML-
DECLARATION-TX | |
2 | Trade Net Response message specification | TDS41-MDS-XML-
RESPONSE-TX | |
3 | UN/CEFACT XML Naming and Design Rules | Naming And Design Rules
_2.0.doc | |
4 | UN/ECE WP Recommendation No. 3, Code for the
Representation of Names of Countries - ISO Country Code | ECE/TRADE/201 | | 1 Jan 96
5 | UN/ECE WP Trade Facilitation Recommendation No. 9,
Alphabetic Code for the Representation of Currencies | ECE/TRADE/203 | | 1 Jan 96
6 | UN/ECE WP Trade Facilitation Recommendation No. 16,
UN/LOCODE - Code for the Trade and Transport Locations | ECE/TRADE/227 | | Dec 98
7 | UN/ECE WP Trade Facilitation Recommendation No. 19, Code
for modes of transport | TRADE/CEFACT/2001/19 | | 15 Jan 01
8 | UN/ECE WP Trade Facilitation Recommendation No. 20, Codes
for Units of Measure Used in International Trade | CEFACT/ICG/2010/IC01
3 | | 13 Sep 10
9 | Codes for Units of Measure Used in International Trade
Annex B: Code elements listed by Quantity | CEFACT/ICG/2010/IC01
3
Annex I | | 13 Sep 10
10 | Codes for Units of Measure Used in International Trade
Annex C: Code elements listed by common code & name | CEFACT/ICG/2010/IC01
3
Annex II & Annex III | | 13 Sep 10
11 | UN/ECE WP Trade Facilitation Recommendation No. 21, Codes
for Types of Cargo, Packages and Packaging Material | CEFACT/ICG/2010/IC01
0/Rev.1 | | 12 Jul 10
12 | STDID Code Lists | STDID-TDS41-COD | |
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
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
Trade Net Declaration message specification
TDS41-MDS-XML-
DECLARATION-TX
2
Trade Net Response message specification
TDS41-MDS-XML-
RESPONSE-TX
3
UN/CEFACT XML Naming and Design Rules
Naming And Design Rules
_2.0.doc
4
UN/ECE WP Recommendation No. 3, Code for the
Representation of Names of Countries - ISO Country Code
ECE/TRADE/201
1 Jan 96
5
UN/ECE WP Trade Facilitation Recommendation No. 9,
Alphabetic Code for the Representation of Currencies
ECE/TRADE/203
1 Jan 96
6
UN/ECE WP Trade Facilitation Recommendation No. 16,
UN/LOCODE - Code for the Trade and Transport Locations
ECE/TRADE/227
Dec 98
7
UN/ECE WP Trade Facilitation Recommendation No. 19, Code
for modes of transport
TRADE/CEFACT/2001/19
15 Jan 01
8
UN/ECE WP Trade Facilitation Recommendation No. 20, Codes
for Units of Measure Used in International Trade
CEFACT/ICG/2010/IC01
3
13 Sep 10
9
Codes for Units of Measure Used in International Trade
Annex B: Code elements listed by Quantity
CEFACT/ICG/2010/IC01
3
Annex I
13 Sep 10
10
Codes for Units of Measure Used in International Trade
Annex C: Code elements listed by common code & name
CEFACT/ICG/2010/IC01
3
Annex II & Annex III
13 Sep 10
11
UN/ECE WP Trade Facilitation Recommendation No. 21, Codes
for Types of Cargo, Packages and Packaging Material
CEFACT/ICG/2010/IC01
0/Rev.1
12 Jul 10
12
STDID Code Lists
STDID-TDS41-COD
OFFICIAL (CLOSED)
AM', '[4, 5]', '["Rev", "Net", "XML", "and", "doc", "for", "the", "Jan", "ISO", "Dec", "Sep", "III", "Jul", "COD", "Ver", "Name", "Date", "Code", "Used", "Trade"]', 'Provide knowledge guidance for REFERENCES.', '["4", "REFERENCES", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC4-R001', '4', '4. REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Net Declaration message specification TDS41-MDS-XML-
DECLARATION-TX
2 Trade Net Response message specification TDS41-MDS-XML-
RESPONSE-TX
3 UN/CEFACT XML Naming and Design Rules Naming And Design Rules
_2.0.doc
4 UN/ECE WP Recommendation No. 3, Code for the ECE/TRADE/201 1 Jan 96
Representation of Names of Countries - ISO Country Code
5 UN/ECE WP Trade Facilitation Recommendation No.', 'business_rule', 'REFERENCES', 'REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Net Declaration message specification TDS41-MDS-XML-
DECLARATION-TX
2 Trade Net Response message specification TDS41-MDS-XML-
RESPONSE-TX
3 UN/CEFACT XML Naming and Design Rules Naming And Design Rules
_2.0.doc
4 UN/ECE WP Recommendation No.', 'Not explicitly covered in uploaded documents.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 4 - REFERENCES.');
INSERT INTO conditions (section_code, condition_text) VALUES ('4', 'REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Net Declaration message specification TDS41-MDS-XML-
DECLARATION-TX
2 Trade Net Response message specification TDS41-MDS-XML-
RESPONSE-TX
3 UN/CEFACT XML Naming and Design Rules Naming And Design Rules
_2.0.doc
4 UN/ECE WP Recommendation No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('4', '21, Codes CEFACT/ICG/2010/IC01 12 Jul 10
for Types of Cargo, Packages and Packaging Material 0/Rev.1
12 STDID Code Lists STDID-TDS41-COD
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
S/
N | Document Name | Document/Directory
Reference | Rev | Date
1 | Trade Net Declaration message specification | TDS41-MDS-XML-
DECLARATION-TX | |
2 | Trade Net Response message specification | TDS41-MDS-XML-
RESPONSE-TX | |
3 | UN/CEFACT XML Naming and Design Rules | Naming And Design Rules
_2.0.doc | |
4 | UN/ECE WP Recommendation No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('4', 'REFERENCES
S/
N
Document Name
Document/Directory
Reference
Rev
Date
1
Trade Net Declaration message specification
TDS41-MDS-XML-
DECLARATION-TX
2
Trade Net Response message specification
TDS41-MDS-XML-
RESPONSE-TX
3
UN/CEFACT XML Naming and Design Rules
Naming And Design Rules
_2.0.doc
4
UN/ECE WP Recommendation No.');
INSERT INTO documents (section_code, document_name) VALUES ('4', 'S/ Document Name Document');
INSERT INTO documents (section_code, document_name) VALUES ('4', 'Trade Net Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('4', '21, Codes
for Types of Cargo, Packages and Packaging Material | CEFACT/ICG/2010/IC01
0/Rev.1 | | 12 Jul 10
12 | STDID Code Lists | STDID-TDS41-COD | |
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
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
1 Trade Net Declaration message specification TDS41-MDS-XML-
DECLARATION-TX
2 Trade Net Response message specification TDS41-MDS-XML-
RESPONSE-TX
3 UN/CEFACT XML Naming and Design Rules Naming And Design Rules
_2.0.doc
4 UN/ECE WP Recommendation No.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('4', 2, 'Evaluate condition: 21, Codes CEFACT/ICG/2010/IC01 12 Jul 10
for Types of Cargo, Packages and Packaging Material 0/Rev.1
12 STDID Code Lists STDID-TDS41-COD
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
S/
N | Document Name | Document/Directory
Reference | Rev | Date
1 | Trade Net Declaration message specification | TDS41-MDS-XML-
DECLARATION-TX | |
2 | Trade Net Response message specification | TDS41-MDS-XML-
RESPONSE-TX | |
3 | UN/CEFACT XML Naming and Design Rules | Naming And Design Rules
_2.0.doc | |
4 | UN/ECE WP Recommendation No.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('4', 3, 'Evaluate condition: REFERENCES
S/
N
Document Name
Document/Directory
Reference
Rev
Date
1
Trade Net Declaration message specification
TDS41-MDS-XML-
DECLARATION-TX
2
Trade Net Response message specification
TDS41-MDS-XML-
RESPONSE-TX
3
UN/CEFACT XML Naming and Design Rules
Naming And Design Rules
_2.0.doc
4
UN/ECE WP Recommendation No.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Rev');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Net');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'XML');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'doc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Jan');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'ISO');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Dec');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Sep');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'III');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Jul');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'COD');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Ver');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Name');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Date');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Code');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Used');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'keywords', 'Trade');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'tags', '4');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'tags', 'REFERENCES');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('4', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.IPTDEC Ver2.1 (2).pdf', '', 'TradeNetDeclaration.IPTDEC Ver2.1 (2)', '5', 'DEFINITIONS AND ABBREVIATIONS', 'Defines the operational requirements for DEFINITIONS AND ABBREVIATIONS.', 'Indha DEFINITIONS AND ABBREVIATIONS section-la, Defines the operational requirements for DEFINITIONS AND ABBREVIATIONS.', '5. DEFINITIONS AND ABBREVIATIONS', '5.', '5. DEFINITIONS AND ABBREVIATIONS', 'Indha DEFINITIONS AND ABBREVIATIONS section-la, 5. DEFINITIONS AND ABBREVIATIONS', '5. DEFINITIONS AND ABBREVIATIONS', '[5]', '["AND", "DEFINITIONS", "ABBREVIATIONS"]', 'Provide knowledge guidance for DEFINITIONS AND ABBREVIATIONS.', '["5", "DEFINITIONS AND ABBREVIATIONS", "dgft"]');
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
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.IPTDEC Ver2.1 (2).pdf', '', 'TradeNetDeclaration.IPTDEC Ver2.1 (2)', '5.1', 'Abbreviations', '5.1 Abbreviations
CA Controlling Agency
Crimson Logic Crimson Logic Pte Ltd
XML Extensible Markup Language
FTZ Free Trade Zone
GST Goods and Services Tax
ISO International Standards Organisation
MDS Message Design Specifications
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', 'Indha Abbreviations section-la, 5.1 Abbreviations
CA Controlling Agency
Crimson Logic Crimson Logic Pte Ltd
XML Extensible Markup Language
FTZ Free Trade Zone
GST Goods and Services Tax
ISO International Standards Organisation
MDS Message Design Specifications
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', '5.1 Abbreviations
CA Controlling Agency
Crimson Logic Crimson Logic Pte Ltd
XML Extensible Markup Language
FTZ Free Trade Zone
GST Goods and Services Tax
ISO International Standards Organisation
MDS Message Design Specifications
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id. TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
5.1 Abbreviations
CA
Controlling Agency
Crimson Logic
XML
Extensible Markup Language
FTZ
Free Trade Zone
GST
Goods and Services Tax
ISO
International Standards Organisation
MDS
Message Design Specifications
SC
Singapore Customs
STDID
Singapore Trade Data Interchange Directory
OFFICIAL (CLOSED)
AM', '5.1 Abbreviations
CA Controlling Agency
Crimson Logic Crimson Logic Pte Ltd
XML Extensible Markup Language
FTZ Free Trade Zone
GST Goods and Services Tax
ISO International Standards Organisation
MDS Message Design Specifications
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', '5.1 Abbreviations
CA Controlling Agency
Crimson Logic Crimson Logic Pte Ltd
XML Extensible Markup Language
FTZ Free Trade Zone
GST Goods and Services Tax
ISO International Standards Organisation
MDS Message Design Specifications
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id. TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
5.1 Abbreviations
CA
Controlling Agency
Crimson Logic
XML
Extensible Markup Language
FTZ
Free Trade Zone
GST
Goods and Services Tax
ISO
International Standards Organisation
MDS
Message Design Specifications
SC
Singapore Customs
STDID
Singapore Trade Data Interchange Directory
OFFICIAL (CLOSED)
AM', 'Indha Abbreviations section-la, 5.1 Abbreviations
CA Controlling Agency
Crimson Logic Crimson Logic Pte Ltd
XML Extensible Markup Language
FTZ Free Trade Zone
GST Goods and Services Tax
ISO International Standards Organisation
MDS Message Design Specifications
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id. TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
5.1 Abbreviations
CA
Controlling Agency
Crimson Logic
XML
Extensible Markup Language
FTZ
Free Trade Zone
GST
Goods and Services Tax
ISO
International Standards Organisation
MDS
Message Design Specifications
SC
Singapore Customs
STDID
Singapore Trade Data Interchange Directory
OFFICIAL (CLOSED)
AM', '5.1 Abbreviations
CA Controlling Agency
Crimson Logic Crimson Logic Pte Ltd
XML Extensible Markup Language
FTZ Free Trade Zone
GST Goods and Services Tax
ISO International Standards Organisation
MDS Message Design Specifications
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
5.1 Abbreviations
CA
Controlling Agency
Crimson Logic
XML
Extensible Markup Language
FTZ
Free Trade Zone
GST
Goods and Services Tax
ISO
International Standards Organisation
MDS
Message Design Specifications
SC
Singapore Customs
STDID
Singapore Trade Data Interchange Directory
OFFICIAL (CLOSED)
AM', '[5, 6]', '["Pte", "Ltd", "XML", "FTZ", "GST", "and", "Tax", "ISO", "MDS", "Net", "doc", "For", "Ver", "Free", "Zone", "Data", "Date", "Logic", "Trade", "Goods"]', 'Provide knowledge guidance for Abbreviations.', '["5.1", "Abbreviations", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC5_1-R001', '5.1', '5.1 Abbreviations
CA Controlling Agency
Crimson Logic Crimson Logic Pte Ltd
XML Extensible Markup Language
FTZ Free Trade Zone
GST Goods and Services Tax
ISO International Standards Organisation
MDS Message Design Specifications
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id. TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
5.1 Abbreviations
CA
Controlling Agency
Crimson Logic
XML
Extensible Markup Language
FTZ
Free Trade Zone
GST
Goods and Services Tax
ISO
International Standards Organisation
MDS
Message Design Specifications
SC
Singapore Customs
STDID
Singapore Trade Data Interchange Directory
OFFICIAL (CLOSED)
AM', 'business_rule', 'Abbreviations', '5.1 Abbreviations
CA Controlling Agency
Crimson Logic Crimson Logic Pte Ltd
XML Extensible Markup Language
FTZ Free Trade Zone
GST Goods and Services Tax
ISO International Standards Organisation
MDS Message Design Specifications
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', 'Not explicitly covered in uploaded documents.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.1 - Abbreviations.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.1', '5.1 Abbreviations
CA Controlling Agency
Crimson Logic Crimson Logic Pte Ltd
XML Extensible Markup Language
FTZ Free Trade Zone
GST Goods and Services Tax
ISO International Standards Organisation
MDS Message Design Specifications
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.1', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
5.1 Abbreviations
CA
Controlling Agency
Crimson Logic
XML
Extensible Markup Language
FTZ
Free Trade Zone
GST
Goods and Services Tax
ISO
International Standards Organisation
MDS
Message Design Specifications
SC
Singapore Customs
STDID
Singapore Trade Data Interchange Directory
OFFICIAL (CLOSED)
AM');
INSERT INTO documents (section_code, document_name) VALUES ('5.1', 'Trade Net Declaration');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.1', 'Customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.1', 'SC Singapore Customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.1', 'Singapore Customs');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.1', 1, 'Evaluate condition: 5.1 Abbreviations
CA Controlling Agency
Crimson Logic Crimson Logic Pte Ltd
XML Extensible Markup Language
FTZ Free Trade Zone
GST Goods and Services Tax
ISO International Standards Organisation
MDS Message Design Specifications
SC Singapore Customs
STDID Singapore Trade Data Interchange Directory
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.1', 2, 'Evaluate condition: TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
5.1 Abbreviations
CA
Controlling Agency
Crimson Logic
XML
Extensible Markup Language
FTZ
Free Trade Zone
GST
Goods and Services Tax
ISO
International Standards Organisation
MDS
Message Design Specifications
SC
Singapore Customs
STDID
Singapore Trade Data Interchange Directory
OFFICIAL (CLOSED)
AM');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Pte');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Ltd');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'XML');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'FTZ');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'GST');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Tax');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'ISO');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'MDS');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Net');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'doc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'For');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Ver');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Free');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Zone');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Data');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Date');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Logic');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Trade');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'keywords', 'Goods');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'tags', '5.1');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'tags', 'Abbreviations');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.1', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.IPTDEC Ver2.1 (2).pdf', '', 'TradeNetDeclaration.IPTDEC Ver2.1 (2)', '6', 'MESSAGE FUNCTION', 'MESSAGE FUNCTION
The Trade Net Declaration message permits the transfer of data from the Declarant to SC and CA (if applicable) for the
purpose of meeting legislative and/or operational requirements in respect of the declaration of goods for import, export
or transit.', 'Indha MESSAGE FUNCTION section-la, MESSAGE FUNCTION
The Trade Net Declaration message permits the transfer of data from the Declarant to SC and CA (if applicable) for the
purpose of meeting legislative and/or operational requirements in respect of the declaration of goods for import, export
or transit.', '6. MESSAGE FUNCTION
The Trade Net Declaration message permits the transfer of data from the Declarant to SC and CA (if applicable) for the
purpose of meeting legislative and/or operational requirements in respect of the declaration of goods for import, export
or transit. Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST GST (including duty exemption) To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG Duty & GST To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
Code | Declaration Type | Transfer Conditions
DUT | Duty | To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST | GST (including duty exemption) | To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG | Duty & GST | To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', '6.', '6. MESSAGE FUNCTION
The Trade Net Declaration message permits the transfer of data from the Declarant to SC and CA (if applicable) for the
purpose of meeting legislative and/or operational requirements in respect of the declaration of goods for import, export
or transit. Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST GST (including duty exemption) To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG Duty & GST To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
Code | Declaration Type | Transfer Conditions
DUT | Duty | To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST | GST (including duty exemption) | To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG | Duty & GST | To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', 'Indha MESSAGE FUNCTION section-la, 6. MESSAGE FUNCTION
The Trade Net Declaration message permits the transfer of data from the Declarant to SC and CA (if applicable) for the
purpose of meeting legislative and/or operational requirements in respect of the declaration of goods for import, export
or transit. Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST GST (including duty exemption) To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG Duty & GST To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
Code | Declaration Type | Transfer Conditions
DUT | Duty | To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST | GST (including duty exemption) | To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG | Duty & GST | To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', '6. MESSAGE FUNCTION
The Trade Net Declaration message permits the transfer of data from the Declarant to SC and CA (if applicable) for the
purpose of meeting legislative and/or operational requirements in respect of the declaration of goods for import, export
or transit.
Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST GST (including duty exemption) To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG Duty & GST To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
Code | Declaration Type | Transfer Conditions
DUT | Duty | To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST | GST (including duty exemption) | To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG | Duty & GST | To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
6. MESSAGE FUNCTION
The Trade Net Declaration message permits the transfer of data from the Declarant to SC and CA (if applicable) for the
purpose of meeting legislative and/or operational requirements in respect of the declaration of goods for import, export
or transit.
Transfer conditions are:
Code Declaration Type
Transfer Conditions
DUT
Duty
To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST
GST (including duty exemption)
To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG
Duty & GST
To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
OFFICIAL (CLOSED)
AM
d) Release of goods from FTZ
e) Release of goods from LW
f) Release of AD goods from FTZ
g) Release of Class II cargoes from BWCY
h) Short payment of GST and duty
BKT Blanket To allow the Declarant to submit Declarations such as:
a) gas
b) water
c) video tapes
d) petroleum
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
| | d) Release of goods from FTZ
e) Release of goods from LW
f) Release of AD goods from FTZ
g) Release of Class II cargoes from BWCY
h) Short payment of GST and duty
BKT | Blanket | To allow the Declarant to submit Declarations such as:
a) gas
b) water
c) video tapes
d) petroleum
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
d) Release of goods from FTZ
e) Release of goods from LW
f) Release of AD goods from FTZ
g) Release of Class II cargoes from BWCY
h) Short payment of GST and duty
BKT
Blanket
To allow the Declarant to submit Declarations such as:
a) gas
b) water
c) video tapes
d) petroleum
OFFICIAL (CLOSED)
AM
Sender: Traders, Freight Forwarders, Air Cargo Agents, Shipping Agents
Logical Destinations: SC and CAs (if applicable)(via Trade Net system)
Response message: Trade Net Response message
- for the Issuing Authorities to issue the respective Permit to the Declarant; refer to
reference 2 for more details
- for the Issuing Authorities to inform the Declarant on the rejection of
the declaration; refer to reference 3 for more details)
- for the Issuing Authorities and Trade Net system to inform the Declarant
on the errors found when processing the declaration message; refer to
reference 4 for more details)', '[6, 7, 8]', '["The", "Net", "and", "for", "are", "DUT", "GST", "FTZ", "iii", "lab", "use", "SAF", "DNG", "doc", "XML", "Ver", "BKT", "gas", "Air", "CAs"]', 'Support MESSAGE FUNCTION processing and compliance validation.', '["6", "MESSAGE FUNCTION", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC6-R001', '6', 'IF validations pass THEN recommend action: Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST GST (including duty exemption) To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG Duty & GST To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
Code | Declaration Type | Transfer Conditions
DUT | Duty | To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST | GST (including duty exemption) | To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG | Duty & GST | To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', 'business_rule', 'MESSAGE FUNCTION', 'MESSAGE FUNCTION
The Trade Net Declaration message permits the transfer of data from the Declarant to SC and CA (if applicable) for the
purpose of meeting legislative and/or operational requirements in respect of the declaration of goods for import, export
or transit.', 'Not explicitly covered in uploaded documents.', 'Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST GST (including duty exemption) To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG Duty & GST To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
Code | Declaration Type | Transfer Conditions
DUT | Duty | To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST | GST (including duty exemption) | To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG | Duty & GST | To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', 'Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST GST (including duty exemption) To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG Duty & GST To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
Code | Declaration Type | Transfer Conditions
DUT | Duty | To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST | GST (including duty exemption) | To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG | Duty & GST | To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', 'DEKAI should produce a compliance decision for 6 - MESSAGE FUNCTION.');
INSERT INTO conditions (section_code, condition_text) VALUES ('6', 'MESSAGE FUNCTION
The Trade Net Declaration message permits the transfer of data from the Declarant to SC and CA (if applicable) for the
purpose of meeting legislative and/or operational requirements in respect of the declaration of goods for import, export
or transit.');
INSERT INTO conditions (section_code, condition_text) VALUES ('6', 'Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST GST (including duty exemption) To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG Duty & GST To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
Code | Declaration Type | Transfer Conditions
DUT | Duty | To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST | GST (including duty exemption) | To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG | Duty & GST | To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('6', 'Transfer conditions are:
Code Declaration Type
Transfer Conditions
DUT
Duty
To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST
GST (including duty exemption)
To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG
Duty & GST
To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
OFFICIAL (CLOSED)
AM
d) Release of goods from FTZ
e) Release of goods from LW
f) Release of AD goods from FTZ
g) Release of Class II cargoes from BWCY
h) Short payment of GST and duty
BKT Blanket To allow the Declarant to submit Declarations such as:
a) gas
b) water
c) video tapes
d) petroleum
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
| | d) Release of goods from FTZ
e) Release of goods from LW
f) Release of AD goods from FTZ
g) Release of Class II cargoes from BWCY
h) Short payment of GST and duty
BKT | Blanket | To allow the Declarant to submit Declarations such as:
a) gas
b) water
c) video tapes
d) petroleum
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('6', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
d) Release of goods from FTZ
e) Release of goods from LW
f) Release of AD goods from FTZ
g) Release of Class II cargoes from BWCY
h) Short payment of GST and duty
BKT
Blanket
To allow the Declarant to submit Declarations such as:
a) gas
b) water
c) video tapes
d) petroleum
OFFICIAL (CLOSED)
AM
Sender: Traders, Freight Forwarders, Air Cargo Agents, Shipping Agents
Logical Destinations: SC and CAs (if applicable)(via Trade Net system)
Response message: Trade Net Response message
- for the Issuing Authorities to issue the respective Permit to the Declarant; refer to
reference 2 for more details
- for the Issuing Authorities to inform the Declarant on the rejection of
the declaration; refer to reference 3 for more details)
- for the Issuing Authorities and Trade Net system to inform the Declarant
on the errors found when processing the declaration message; refer to
reference 4 for more details)');
INSERT INTO documents (section_code, document_name) VALUES ('6', 'The Trade Net Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('6', 'Code Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('6', 'Trade Net Declaration');
INSERT INTO authorities (section_code, authority_name) VALUES ('6', 'customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('6', 'Issuing Authorities');
INSERT INTO exceptions (section_code, exception_text) VALUES ('6', 'Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST GST (including duty exemption) To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG Duty & GST To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
Code | Declaration Type | Transfer Conditions
DUT | Duty | To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST | GST (including duty exemption) | To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG | Duty & GST | To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('6', 'Transfer conditions are:
Code Declaration Type
Transfer Conditions
DUT
Duty
To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST
GST (including duty exemption)
To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG
Duty & GST
To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
OFFICIAL (CLOSED)
AM
d) Release of goods from FTZ
e) Release of goods from LW
f) Release of AD goods from FTZ
g) Release of Class II cargoes from BWCY
h) Short payment of GST and duty
BKT Blanket To allow the Declarant to submit Declarations such as:
a) gas
b) water
c) video tapes
d) petroleum
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
| | d) Release of goods from FTZ
e) Release of goods from LW
f) Release of AD goods from FTZ
g) Release of Class II cargoes from BWCY
h) Short payment of GST and duty
BKT | Blanket | To allow the Declarant to submit Declarations such as:
a) gas
b) water
c) video tapes
d) petroleum
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('6', 1, 'Evaluate condition: MESSAGE FUNCTION
The Trade Net Declaration message permits the transfer of data from the Declarant to SC and CA (if applicable) for the
purpose of meeting legislative and/or operational requirements in respect of the declaration of goods for import, export
or transit.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('6', 2, 'Evaluate condition: Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST GST (including duty exemption) To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG Duty & GST To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
Code | Declaration Type | Transfer Conditions
DUT | Duty | To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST | GST (including duty exemption) | To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG | Duty & GST | To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('6', 3, 'Evaluate condition: Transfer conditions are:
Code Declaration Type
Transfer Conditions
DUT
Duty
To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST
GST (including duty exemption)
To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG
Duty & GST
To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
OFFICIAL (CLOSED)
AM
d) Release of goods from FTZ
e) Release of goods from LW
f) Release of AD goods from FTZ
g) Release of Class II cargoes from BWCY
h) Short payment of GST and duty
BKT Blanket To allow the Declarant to submit Declarations such as:
a) gas
b) water
c) video tapes
d) petroleum
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
| | d) Release of goods from FTZ
e) Release of goods from LW
f) Release of AD goods from FTZ
g) Release of Class II cargoes from BWCY
h) Short payment of GST and duty
BKT | Blanket | To allow the Declarant to submit Declarations such as:
a) gas
b) water
c) video tapes
d) petroleum
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('6', 4, 'Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST GST (including duty exemption) To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG Duty & GST To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
Code | Declaration Type | Transfer Conditions
DUT | Duty | To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST | GST (including duty exemption) | To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG | Duty & GST | To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('6', 5, 'Transfer conditions are:
Code Declaration Type
Transfer Conditions
DUT
Duty
To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST
GST (including duty exemption)
To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG
Duty & GST
To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
OFFICIAL (CLOSED)
AM
d) Release of goods from FTZ
e) Release of goods from LW
f) Release of AD goods from FTZ
g) Release of Class II cargoes from BWCY
h) Short payment of GST and duty
BKT Blanket To allow the Declarant to submit Declarations such as:
a) gas
b) water
c) video tapes
d) petroleum
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
| | d) Release of goods from FTZ
e) Release of goods from LW
f) Release of AD goods from FTZ
g) Release of Class II cargoes from BWCY
h) Short payment of GST and duty
BKT | Blanket | To allow the Declarant to submit Declarations such as:
a) gas
b) water
c) video tapes
d) petroleum
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('6', 6, 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
d) Release of goods from FTZ
e) Release of goods from LW
f) Release of AD goods from FTZ
g) Release of Class II cargoes from BWCY
h) Short payment of GST and duty
BKT
Blanket
To allow the Declarant to submit Declarations such as:
a) gas
b) water
c) video tapes
d) petroleum
OFFICIAL (CLOSED)
AM
Sender: Traders, Freight Forwarders, Air Cargo Agents, Shipping Agents
Logical Destinations: SC and CAs (if applicable)(via Trade Net system)
Response message: Trade Net Response message
- for the Issuing Authorities to issue the respective Permit to the Declarant; refer to
reference 2 for more details
- for the Issuing Authorities to inform the Declarant on the rejection of
the declaration; refer to reference 3 for more details)
- for the Issuing Authorities and Trade Net system to inform the Declarant
on the errors found when processing the declaration message; refer to
reference 4 for more details)');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('6', 7, 'Handle exception: Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST GST (including duty exemption) To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG Duty & GST To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
Code | Declaration Type | Transfer Conditions
DUT | Duty | To allow the Declarant to submit Declarations such as anti-dumping
duties, excise for local manufacturing, previously exempted vehicles
and short payment
GST | GST (including duty exemption) | To allow the Declarant to submit Declarations such as:
a) non-dutiable HS for
i) direct import
ii) release from FTZ to customs territories
iii) release from BW to customs territories and,
iv) release of Class II cargoes from BWCY
b) dutiable HS
i) Motor vehicles
ii) Ethyl alcohol for lab use
iii) Industrial exemption
iv) Beer for SAF
c) Short Payment
d) Auction cargoes release from FTZ or local cargoes which entered
ALPS & subsequently enter customs territory
DNG | Duty & GST | To allow the Declarant to submit Declarations such as:
a) Direct import
b) Local manufacturing
c) Sale of:
i) embassy vehicles to others
ii) vehicles by foreign armed forces
iii) vehicles by disabled persons
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'The');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'Net');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'are');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'DUT');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'GST');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'FTZ');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'iii');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'lab');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'use');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'SAF');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'DNG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'doc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'XML');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'Ver');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'BKT');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'gas');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'Air');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'CAs');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'tags', '6');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'tags', 'MESSAGE FUNCTION');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.IPTDEC Ver2.1 (2).pdf', '', 'TradeNetDeclaration.IPTDEC Ver2.1 (2)', '7', 'MESSAGE DEFINITION', 'MESSAGE DEFINITION
Refer to reference 1, chapter 4, Message Definition.', 'Indha MESSAGE DEFINITION section-la, MESSAGE DEFINITION
Refer to reference 1, chapter 4, Message Definition.', '7. MESSAGE DEFINITION
Refer to reference 1, chapter 4, Message Definition. Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', '7.', '7. MESSAGE DEFINITION
Refer to reference 1, chapter 4, Message Definition. Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', 'Indha MESSAGE DEFINITION section-la, 7. MESSAGE DEFINITION
Refer to reference 1, chapter 4, Message Definition. Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
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
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
Sender
: Traders, Freight Forwarders, Air Cargo Agents, Shipping Agents
Logical Destinations
: SC and CAs (if applicable)(via Trade Net system)
Response message: Trade Net Response message
- for the Issuing Authorities to issue the respective Permit to the Declarant; refer to
reference 2 for more details
- for the Issuing Authorities to inform the Declarant on the rejection of
the declaration; refer to reference 3 for more details)
- for the Issuing Authorities and Trade Net system to inform the Declarant
on the errors found when processing the declaration message; refer to
reference 4 for more details)
7. MESSAGE DEFINITION
Refer to reference 1, chapter 4, Message Definition.
OFFICIAL (CLOSED)
AM', '[8, 9]', '["Net", "doc", "XML", "For", "Ver", "Air", "and", "CAs", "via", "the", "Date", "more", "when", "Refer", "Trade", "Cargo", "issue", "found", "IPTDEC", "CLOSED"]', 'Support MESSAGE DEFINITION processing and compliance validation.', '["7", "MESSAGE DEFINITION", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC7-R001', '7', 'IF validations pass THEN recommend action: TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
Sender
: Traders, Freight Forwarders, Air Cargo Agents, Shipping Agents
Logical Destinations
: SC and CAs (if applicable)(via Trade Net system)
Response message: Trade Net Response message
- for the Issuing Authorities to issue the respective Permit to the Declarant; refer to
reference 2 for more details
- for the Issuing Authorities to inform the Declarant on the rejection of
the declaration; refer to reference 3 for more details)
- for the Issuing Authorities and Trade Net system to inform the Declarant
on the errors found when processing the declaration message; refer to
reference 4 for more details)
7.', 'business_rule', 'MESSAGE DEFINITION', 'Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', 'Not explicitly covered in uploaded documents.', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
Sender
: Traders, Freight Forwarders, Air Cargo Agents, Shipping Agents
Logical Destinations
: SC and CAs (if applicable)(via Trade Net system)
Response message: Trade Net Response message
- for the Issuing Authorities to issue the respective Permit to the Declarant; refer to
reference 2 for more details
- for the Issuing Authorities to inform the Declarant on the rejection of
the declaration; refer to reference 3 for more details)
- for the Issuing Authorities and Trade Net system to inform the Declarant
on the errors found when processing the declaration message; refer to
reference 4 for more details)
7.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 7 - MESSAGE DEFINITION.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
Sender
: Traders, Freight Forwarders, Air Cargo Agents, Shipping Agents
Logical Destinations
: SC and CAs (if applicable)(via Trade Net system)
Response message: Trade Net Response message
- for the Issuing Authorities to issue the respective Permit to the Declarant; refer to
reference 2 for more details
- for the Issuing Authorities to inform the Declarant on the rejection of
the declaration; refer to reference 3 for more details)
- for the Issuing Authorities and Trade Net system to inform the Declarant
on the errors found when processing the declaration message; refer to
reference 4 for more details)
7.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'Trade Net Declaration');
INSERT INTO authorities (section_code, authority_name) VALUES ('7', 'Issuing Authorities');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('7', 1, 'Evaluate condition: Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('7', 2, 'Evaluate condition: TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
Sender
: Traders, Freight Forwarders, Air Cargo Agents, Shipping Agents
Logical Destinations
: SC and CAs (if applicable)(via Trade Net system)
Response message: Trade Net Response message
- for the Issuing Authorities to issue the respective Permit to the Declarant; refer to
reference 2 for more details
- for the Issuing Authorities to inform the Declarant on the rejection of
the declaration; refer to reference 3 for more details)
- for the Issuing Authorities and Trade Net system to inform the Declarant
on the errors found when processing the declaration message; refer to
reference 4 for more details)
7.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('7', 3, 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
Sender
: Traders, Freight Forwarders, Air Cargo Agents, Shipping Agents
Logical Destinations
: SC and CAs (if applicable)(via Trade Net system)
Response message: Trade Net Response message
- for the Issuing Authorities to issue the respective Permit to the Declarant; refer to
reference 2 for more details
- for the Issuing Authorities to inform the Declarant on the rejection of
the declaration; refer to reference 3 for more details)
- for the Issuing Authorities and Trade Net system to inform the Declarant
on the errors found when processing the declaration message; refer to
reference 4 for more details)
7.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Net');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'doc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'XML');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'For');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Ver');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Air');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'CAs');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'via');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Date');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'more');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'when');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Refer');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Trade');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Cargo');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'issue');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'found');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'IPTDEC');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'CLOSED');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'tags', '7');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'tags', 'MESSAGE DEFINITION');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.IPTDEC Ver2.1 (2).pdf', '', 'TradeNetDeclaration.IPTDEC Ver2.1 (2)', '8', 'MESSAGE DETAILS', 'Defines the operational requirements for MESSAGE DETAILS.', 'Indha MESSAGE DETAILS section-la, Defines the operational requirements for MESSAGE DETAILS.', '8. MESSAGE DETAILS
User defined
Ref Tag name S R Repr Remarks
HEADER SECTION
ipt:Header M 1
B045 cbc:Message Reference M 1 an..14 Sender unique message reference. Sequence number of messages in the
interchange (Sender generated).', 'MESSAGE DETAILS governs how DGFT business controls should be applied, validated, and enforced.', 'MESSAGE DETAILS explains the operating rule set that DEKAI should enforce. Key control points include /cac:Unique Reference Number
B065 cbc:Declarant ID M 1 an..17 Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header). The section also drives actions such as DUT = Duty
GST = GST (including duty exemption)
DNG = Duty and GST
BKT = Blanket (including blanket GST payment and duty exemption)
B037 cbc:Declaration Indicator M boolean Mandatory for all Declaration Types..', 'Indha MESSAGE DETAILS section-la, MESSAGE DETAILS explains the operating rule set that DEKAI should enforce. Key control points include /cac:Unique Reference Number
B065 cbc:Declarant ID M 1 an..17 Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header). The section also drives actions such as DUT = Duty
GST = GST (including duty exemption)
DNG = Duty and GST
BKT = Blanket (including blanket GST payment and duty exemption)
B037 cbc:Declaration Indicator M boolean Mandatory for all Declaration Types..', '8. MESSAGE DETAILS
User defined
Ref Tag name S R Repr Remarks
HEADER SECTION
ipt:Header M 1
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
B065 cbc:Declarant ID M 1 an..17 Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header).
B083 cbc:Common Access Reference M 1 an..7 IPTDEC
B021 cbc:Declaration Type M 1 an..7 Specify Declaration Type eg.
DUT = Duty
GST = GST (including duty exemption)
DNG = Duty and GST
BKT = Blanket (including blanket GST payment and duty exemption)
B037 cbc:Declaration Indicator M boolean Mandatory for all Declaration Types. Refers to the declaration at
the frontend software: “I/We declare that all the particulars in
this Application are true and correct”.
B064 cbc:Previous Permit Number C 1 an..35 Specify previous Permit Number if applicable.
A066 cac:Remarks C 1 Provide additional details such as the source of the exchange rate
obtained eg. bank, tel, date, etc if currency code is not on Customs
Exchange Rate List.
B034 cbc:Free Text M 2 an..512 Specify general/trader’s remarks.
/cac:Remarks
B065 cbc:Additional Recipient ID C 3 an..17 Repeat at most 3 times for additional Recipient (for the purpose of
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
Ref Tag name | User defined
S R Repr | Remarks
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
8. MESSAGE DETAILS
User defined
Ref
Tag name
S
R Repr
Remarks
HEADER SECTION
ipt:Header
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
Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header).
B083
cbc:Common Access Reference
M
1 an..7
IPTDEC
B021
cbc:Declaration Type
M
1 an..7
Specify Declaration Type eg.
DUT = Duty
GST = GST (including duty exemption)
DNG = Duty and GST
BKT = Blanket (including blanket GST payment and duty exemption)
B037
cbc:Declaration Indicator
M
boolean
Mandatory for all Declaration Types. Refers to the declaration at
the frontend software: “I/We declare that all the particulars in
this Application are true and correct”.
B064
cbc:Previous Permit Number
C
1 an..35
Specify previous Permit Number if applicable.
A066
cac:Remarks
C
1
Provide additional details such as the source of the exchange rate
obtained eg. bank, tel, date, etc if currency code is not on Customs
Exchange Rate List.
B034
cbc:Free Text
M
2 an..512
Specify general/trader’s remarks.
/cac:Remarks
B065
cbc:Additional Recipient ID
C
3 an..17
Repeat at most 3 times for additional Recipient (for the purpose of
OFFICIAL (CLOSED)
AM
receiving a copy of the message) ids.
B007 cbc:Banker Guarantee Code C 1 an..3 Specify BG indicator (if any).
A068 cac:Customs Procedure Code Information C 5 Repeat at most 5 times.
B089 cbc:Customs Procedure Code M 1 an..7 Specify Customs Procedure Code (CPC).
A069 cac:CPCProcessing Code C 5 Repeat at most 5 times each for Processing code 1, 2 and 3.
B057 cbc:Processing Code One M 1 an..35 Specify processing code 1.
B057 cbc:Processing Code Two C 1 an..35 Specify processing code 2.
B057 cbc:Processing Code Three C 1 an..35 Specify processing code 3.
/cac:CPCProcessing Code
/cac:Customs Procedure Code Information
ipt:Cargo M 1
B009 cbc:Cargo Packing Type M 1 an..3 Specify Cargo Packing Type (refer to STDID Code List).
A032 cac:Release Location M 1 Specify Place of Release.
B039 cbc:Location Code M 1 an..7 Specify location code (refer to STDID Code Lists).
B040 cbc:Location Name C 1 an..256 Specify name and/address of location if the location code = SY
(shipyard) or SC (sailing club) or O (others).
/cac:Release Location
A032 cac:Receipt Location M 1 Specify Place of Receipt.
B039 cbc:Location Code M 1 an..7 Specify location code (refer to STDID Code Lists).
B040 cbc:Location Name C 1 an..256 Specify name and/address of location if the location code = SY
(shipyard) or SC (sailing club) or O (others).
/cac:Receipt Location
A059 cac:Transport Equipment C 99 Repeat at most 99 times for containers at point of clearance.
B068 cbc:Sequence Numeric M 1 n.. 5 Specify sequence number.
B027 cbc:Equipment ID M 1 an..13 Specify container number.
B069 cbc:Size Type Code M 1 an5 Specify container type and size using the following valid codes:
FCL20
FCL40
FCL45
LCL20
LCL40
LCL45
where:
FCL: Full Container Load
LCL: Less Than Container Load
B028 cbc:Equipment Weight Measure Numeric M 1 n.. 3 Specify container weight (TNE).
A058 cac:Transport Equipment Seal M 1 Specify the shipper seal number affixed to the container at the time
of arrival.
B067 cbc:Seal ID M 1 an..35 Specify shipper seal number.
/cac:Transport Equipment Seal
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
receiving a copy of the message) ids.
B007
cbc:Banker Guarantee Code
C
1 an..3
Specify BG indicator (if any).
A068
cac:Customs Procedure Code Information
C
5
Repeat at most 5 times.
B089
cbc:Customs Procedure Code
M
1 an..7
Specify Customs Procedure Code (CPC).
A069
cac:CPCProcessing Code
C
5
Repeat at most 5 times each for Processing code 1, 2 and 3.
B057
cbc:Processing Code One
M
1 an..35
Specify processing code 1.
B057
cbc:Processing Code Two
C
1 an..35
Specify processing code 2.
B057
cbc:Processing Code Three
C
1 an..35
Specify processing code 3.
/cac:CPCProcessing Code
/cac:Customs Procedure Code Information
ipt:Cargo
M
1
B009
cbc:Cargo Packing Type
M
1 an..3
Specify Cargo Packing Type (refer to STDID Code List).
A032
cac:Release Location
M
1
Specify Place of Release.
B039
cbc:Location Code
M
1 an..7
Specify location code (refer to STDID Code Lists).
B040
cbc:Location Name
C
1 an..256
Specify name and/address of location if the location code = SY
(shipyard) or SC (sailing club) or O (others).
/cac:Release Location
A032
cac:Receipt Location
M
1
Specify Place of Receipt.
B039
cbc:Location Code
M
1 an..7
Specify location code (refer to STDID Code Lists).
B040
cbc:Location Name
C
1 an..256
Specify name and/address of location if the location code = SY
(shipyard) or SC (sailing club) or O (others).
/cac:Receipt Location
A059
cac:Transport Equipment
C
99
Repeat at most 99 times for containers at point of clearance.
B068
cbc:Sequence Numeric
M
1 n.. 5
Specify sequence number.
B027
cbc:Equipment ID
M
1 an..13
Specify container number.
B069
cbc:Size Type Code
M
1 an5
Specify container type and size using the following valid codes:
FCL20
FCL40
FCL45
LCL20
LCL40
LCL45
where:
FCL: Full Container Load
LCL: Less Than Container Load
B028
cbc:Equipment Weight Measure Numeric
M
1 n.. 3
Specify container weight (TNE).
A058
cac:Transport Equipment Seal
M
1
Specify the shipper seal number affixed to the container at the time
of arrival.
B067
cbc:Seal ID
M
1 an..35
Specify shipper seal number.
/cac:Transport Equipment Seal
OFFICIAL (CLOSED)
AM
/cac:Transport Equipment
B037 cbc:Supply Indicator C 1 boolean Specify Supply Indicator for:
a) all dutiable goods of Singapore origin released from Licensed
Warehouse, if there is a supply.
b) all imported goods where there is a supply prior to its release
from Customs'' control.
B020 cbc:Blanket Start Date C 1 n8 Format: CCYYMMDD
For blanket imports, specify Start Date of Blanket.
ipt:Transport C 1 Notes:
For all Declaration Types, specify for inward transport, except for
the following:
(i) Goods released from licensed premises such as Licensed
Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse
(ii) short payment where place of receipt = SPSTK, SPNOSTK
(iii) declaration type = BKT (Blanket)
(iv) recovery payment where place of receipt = RCNOSTK
(v) payment for goods previously exempted from duties/taxes (e.g.
place of release = EM, EXEMPT)
(vi) Supplementary declaration for schemes under AISS, IGDS such as
Place of Receipt = AISSLOC, SPIGDS
A026 cac:Inward Transport M 1 Mandatory to specify Inward transport.
A060 cac:Transport Means C 1 Specify inward transport mode.
A060 cac:Transport Mode M 1 For all Declaration Types, valid codes (refer to UN/ECE
Recommendation No. 19) are:', '[9, 10, 11]', '["Ref", "Tag", "ipt", "cbc", "the", "cac", "DUT", "GST", "DNG", "and", "BKT", "for", "all", "are", "tel", "etc", "not", "Net", "doc", "XML"]', 'Support MESSAGE DETAILS processing and compliance validation.', '["8", "MESSAGE DETAILS", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC8-R001', '8', '/cac:Unique Reference Number
B065 cbc:Declarant ID M 1 an..17 Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header).', 'business_rule', 'MESSAGE DETAILS', 'A062 cac:Unique Reference Number M 1 Format:
Declarant entity identifier = XXXXXXXXXXXXXXXXX
Date of Creation = CCYYMMDD
Sequence Numeric = 9999
B036 cbc:ID M 1 an..17 Specify Declarant entity identifier.', '/cac:Unique Reference Number
B065 cbc:Declarant ID M 1 an..17 Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header).', 'DUT = Duty
GST = GST (including duty exemption)
DNG = Duty and GST
BKT = Blanket (including blanket GST payment and duty exemption)
B037 cbc:Declaration Indicator M boolean Mandatory for all Declaration Types.', 'DUT = Duty
GST = GST (including duty exemption)
DNG = Duty and GST
BKT = Blanket (including blanket GST payment and duty exemption)
B037 cbc:Declaration Indicator M boolean Mandatory for all Declaration Types.', 'DEKAI should produce a compliance decision for 8 - MESSAGE DETAILS.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC8-R002', '8', '/cac:Unique Reference Number
B065
cbc:Declarant ID
M
1 an..17
Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header).', 'business_rule', 'MESSAGE DETAILS', 'B020 cbc:Date M 1 n8 Specify date of Creation.', 'Refers to the declaration at
the frontend software: “I/We declare that all the particulars in
this Application are true and correct”.', 'A066 cac:Remarks C 1 Provide additional details such as the source of the exchange rate
obtained eg.', 'DUT = Duty
GST = GST (including duty exemption)
DNG = Duty and GST
BKT = Blanket (including blanket GST payment and duty exemption)
B037
cbc:Declaration Indicator
M
boolean
Mandatory for all Declaration Types.', 'DEKAI should produce a compliance decision for 8 - MESSAGE DETAILS.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'A062 cac:Unique Reference Number M 1 Format:
Declarant entity identifier = XXXXXXXXXXXXXXXXX
Date of Creation = CCYYMMDD
Sequence Numeric = 9999
B036 cbc:ID M 1 an..17 Specify Declarant entity identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B020 cbc:Date M 1 n8 Specify date of Creation.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '4 Specify sequence number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '/cac:Unique Reference Number
B065 cbc:Declarant ID M 1 an..17 Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header).');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B083 cbc:Common Access Reference M 1 an..7 IPTDEC
B021 cbc:Declaration Type M 1 an..7 Specify Declaration Type eg.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B064 cbc:Previous Permit Number C 1 an..35 Specify previous Permit Number if applicable.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'bank, tel, date, etc if currency code is not on Customs
Exchange Rate List.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B034 cbc:Free Text M 2 an..512 Specify general/trader’s remarks.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '/cac:Remarks
B065 cbc:Additional Recipient ID C 3 an..17 Repeat at most 3 times for additional Recipient (for the purpose of
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
Ref Tag name | User defined
S R Repr | Remarks
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
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
Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header).');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B083
cbc:Common Access Reference
M
1 an..7
IPTDEC
B021
cbc:Declaration Type
M
1 an..7
Specify Declaration Type eg.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B064
cbc:Previous Permit Number
C
1 an..35
Specify previous Permit Number if applicable.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B034
cbc:Free Text
M
2 an..512
Specify general/trader’s remarks.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B007 cbc:Banker Guarantee Code C 1 an..3 Specify BG indicator (if any).');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B089 cbc:Customs Procedure Code M 1 an..7 Specify Customs Procedure Code (CPC).');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B057 cbc:Processing Code One M 1 an..35 Specify processing code 1.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B057 cbc:Processing Code Two C 1 an..35 Specify processing code 2.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B057 cbc:Processing Code Three C 1 an..35 Specify processing code 3.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '/cac:CPCProcessing Code
/cac:Customs Procedure Code Information
ipt:Cargo M 1
B009 cbc:Cargo Packing Type M 1 an..3 Specify Cargo Packing Type (refer to STDID Code List).');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'A032 cac:Release Location M 1 Specify Place of Release.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B039 cbc:Location Code M 1 an..7 Specify location code (refer to STDID Code Lists).');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B040 cbc:Location Name C 1 an..256 Specify name and/address of location if the location code = SY
(shipyard) or SC (sailing club) or O (others).');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '/cac:Release Location
A032 cac:Receipt Location M 1 Specify Place of Receipt.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '5 Specify sequence number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B027 cbc:Equipment ID M 1 an..13 Specify container number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B069 cbc:Size Type Code M 1 an5 Specify container type and size using the following valid codes:
FCL20
FCL40
FCL45
LCL20
LCL40
LCL45
where:
FCL: Full Container Load
LCL: Less Than Container Load
B028 cbc:Equipment Weight Measure Numeric M 1 n..');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '3 Specify container weight (TNE).');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'A058 cac:Transport Equipment Seal M 1 Specify the shipper seal number affixed to the container at the time
of arrival.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B067 cbc:Seal ID M 1 an..35 Specify shipper seal number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '/cac:Transport Equipment Seal
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B007
cbc:Banker Guarantee Code
C
1 an..3
Specify BG indicator (if any).');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B089
cbc:Customs Procedure Code
M
1 an..7
Specify Customs Procedure Code (CPC).');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B057
cbc:Processing Code One
M
1 an..35
Specify processing code 1.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B057
cbc:Processing Code Two
C
1 an..35
Specify processing code 2.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B057
cbc:Processing Code Three
C
1 an..35
Specify processing code 3.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '/cac:CPCProcessing Code
/cac:Customs Procedure Code Information
ipt:Cargo
M
1
B009
cbc:Cargo Packing Type
M
1 an..3
Specify Cargo Packing Type (refer to STDID Code List).');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'A032
cac:Release Location
M
1
Specify Place of Release.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B039
cbc:Location Code
M
1 an..7
Specify location code (refer to STDID Code Lists).');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B040
cbc:Location Name
C
1 an..256
Specify name and/address of location if the location code = SY
(shipyard) or SC (sailing club) or O (others).');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '/cac:Release Location
A032
cac:Receipt Location
M
1
Specify Place of Receipt.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '5
Specify sequence number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B027
cbc:Equipment ID
M
1 an..13
Specify container number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B069
cbc:Size Type Code
M
1 an5
Specify container type and size using the following valid codes:
FCL20
FCL40
FCL45
LCL20
LCL40
LCL45
where:
FCL: Full Container Load
LCL: Less Than Container Load
B028
cbc:Equipment Weight Measure Numeric
M
1 n..');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '3
Specify container weight (TNE).');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'A058
cac:Transport Equipment Seal
M
1
Specify the shipper seal number affixed to the container at the time
of arrival.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B067
cbc:Seal ID
M
1 an..35
Specify shipper seal number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', '/cac:Transport Equipment Seal
OFFICIAL (CLOSED)
AM
/cac:Transport Equipment
B037 cbc:Supply Indicator C 1 boolean Specify Supply Indicator for:
a) all dutiable goods of Singapore origin released from Licensed
Warehouse, if there is a supply.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'b) all imported goods where there is a supply prior to its release
from Customs'' control.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'B020 cbc:Blanket Start Date C 1 n8 Format: CCYYMMDD
For blanket imports, specify Start Date of Blanket.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'ipt:Transport C 1 Notes:
For all Declaration Types, specify for inward transport, except for
the following:
(i) Goods released from licensed premises such as Licensed
Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse
(ii) short payment where place of receipt = SPSTK, SPNOSTK
(iii) declaration type = BKT (Blanket)
(iv) recovery payment where place of receipt = RCNOSTK
(v) payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'place of release = EM, EXEMPT)
(vi) Supplementary declaration for schemes under AISS, IGDS such as
Place of Receipt = AISSLOC, SPIGDS
A026 cac:Inward Transport M 1 Mandatory to specify Inward transport.');
INSERT INTO conditions (section_code, condition_text) VALUES ('8', 'A060 cac:Transport Means C 1 Specify inward transport mode.');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Specify Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Declaration Indicator M boolean Mandatory for all Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Refers to the declaration at
the frontend software: “I/We declare that all the particulars in
this Application are true and correct”.');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Trade Net Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Mandatory for all Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('8', '/cac:Remarks
B065
cbc:Additional Recipient ID
C
3 an..17
Repeat at most 3 times for additional Recipient (for the purpose of
OFFICIAL (CLOSED)
AM
receiving a copy of the message) ids.');
INSERT INTO documents (section_code, document_name) VALUES ('8', '/cac:Transport Equipment Seal
OFFICIAL (CLOSED)
AM
/cac:Transport Equipment
B037 cbc:Supply Indicator C 1 boolean Specify Supply Indicator for:
a) all dutiable goods of Singapore origin released from Licensed
Warehouse, if there is a supply.');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'For all Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'place of release = EM, EXEMPT)
(vi) Supplementary declaration for schemes under AISS, IGDS such as
Place of Receipt = AISSLOC, SPIGDS
A026 cac:Inward Transport M 1 Mandatory to specify Inward transport.');
INSERT INTO documents (section_code, document_name) VALUES ('8', 'Transport Mode M 1 For all Declaration');
INSERT INTO authorities (section_code, authority_name) VALUES ('8', 'Customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('8', 'Specify Customs');
INSERT INTO exceptions (section_code, exception_text) VALUES ('8', 'DUT = Duty
GST = GST (including duty exemption)
DNG = Duty and GST
BKT = Blanket (including blanket GST payment and duty exemption)
B037 cbc:Declaration Indicator M boolean Mandatory for all Declaration Types.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('8', 'DUT = Duty
GST = GST (including duty exemption)
DNG = Duty and GST
BKT = Blanket (including blanket GST payment and duty exemption)
B037
cbc:Declaration Indicator
M
boolean
Mandatory for all Declaration Types.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('8', 'ipt:Transport C 1 Notes:
For all Declaration Types, specify for inward transport, except for
the following:
(i) Goods released from licensed premises such as Licensed
Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse
(ii) short payment where place of receipt = SPSTK, SPNOSTK
(iii) declaration type = BKT (Blanket)
(iv) recovery payment where place of receipt = RCNOSTK
(v) payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('8', 'place of release = EM, EXEMPT)
(vi) Supplementary declaration for schemes under AISS, IGDS such as
Place of Receipt = AISSLOC, SPIGDS
A026 cac:Inward Transport M 1 Mandatory to specify Inward transport.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 1, 'Evaluate condition: A062 cac:Unique Reference Number M 1 Format:
Declarant entity identifier = XXXXXXXXXXXXXXXXX
Date of Creation = CCYYMMDD
Sequence Numeric = 9999
B036 cbc:ID M 1 an..17 Specify Declarant entity identifier.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 2, 'Evaluate condition: B020 cbc:Date M 1 n8 Specify date of Creation.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 3, 'Evaluate condition: 4 Specify sequence number.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 4, 'DUT = Duty
GST = GST (including duty exemption)
DNG = Duty and GST
BKT = Blanket (including blanket GST payment and duty exemption)
B037 cbc:Declaration Indicator M boolean Mandatory for all Declaration Types.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 5, 'A066 cac:Remarks C 1 Provide additional details such as the source of the exchange rate
obtained eg.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 6, 'DUT = Duty
GST = GST (including duty exemption)
DNG = Duty and GST
BKT = Blanket (including blanket GST payment and duty exemption)
B037
cbc:Declaration Indicator
M
boolean
Mandatory for all Declaration Types.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 7, 'A066
cac:Remarks
C
1
Provide additional details such as the source of the exchange rate
obtained eg.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 8, 'ipt:Transport C 1 Notes:
For all Declaration Types, specify for inward transport, except for
the following:
(i) Goods released from licensed premises such as Licensed
Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse
(ii) short payment where place of receipt = SPSTK, SPNOSTK
(iii) declaration type = BKT (Blanket)
(iv) recovery payment where place of receipt = RCNOSTK
(v) payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 9, 'Run validation: /cac:Unique Reference Number
B065 cbc:Declarant ID M 1 an..17 Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 10, 'Run validation: Refers to the declaration at
the frontend software: “I/We declare that all the particulars in
this Application are true and correct”.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 11, 'Run validation: /cac:Unique Reference Number
B065
cbc:Declarant ID
M
1 an..17
Mandatory to specify Message Sender Id (must be same as the Sender
Id as specified in the interchange header).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('8', 12, 'Handle exception: DUT = Duty
GST = GST (including duty exemption)
DNG = Duty and GST
BKT = Blanket (including blanket GST payment and duty exemption)
B037 cbc:Declaration Indicator M boolean Mandatory for all Declaration Types.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'Ref');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'Tag');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'ipt');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'cbc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'cac');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'DUT');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'GST');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'DNG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'BKT');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'all');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'are');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'tel');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'etc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'not');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'Net');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'doc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'keywords', 'XML');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'tags', '8');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'tags', 'MESSAGE DETAILS');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('8', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.IPTDEC Ver2.1 (2).pdf', '', 'TradeNetDeclaration.IPTDEC Ver2.1 (2)', '1', 'Maritime', 'Defines the operational requirements for Maritime.', 'Indha Maritime section-la, Defines the operational requirements for Maritime.', '1: Maritime', '1: Maritime', '1: Maritime', 'Indha Maritime section-la, 1: Maritime', '1: Maritime', '[11]', '["Maritime"]', 'Provide knowledge guidance for Maritime.', '["1", "Maritime", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC1-R001', '1', '1: Maritime', 'business_rule', 'Maritime', 'Not explicitly covered in uploaded documents.', 'Not explicitly covered in uploaded documents.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 1 - Maritime.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('1', 1, 'Review section 1 requirements');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('1', 2, 'Capture applicant inputs');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('1', 3, 'Route for authority decision');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'keywords', 'Maritime');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'tags', '1');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'tags', 'Maritime');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('1', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.IPTDEC Ver2.1 (2).pdf', '', 'TradeNetDeclaration.IPTDEC Ver2.1 (2)', '2', 'Rail', 'Defines the operational requirements for Rail.', 'Indha Rail section-la, Defines the operational requirements for Rail.', '2: Rail', '2: Rail', '2: Rail', 'Indha Rail section-la, 2: Rail', '2: Rail', '[11]', '["Rail"]', 'Provide knowledge guidance for Rail.', '["2", "Rail", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC2-R001', '2', '2: Rail', 'business_rule', 'Rail', 'Not explicitly covered in uploaded documents.', 'Not explicitly covered in uploaded documents.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 2 - Rail.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('2', 1, 'Review section 2 requirements');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('2', 2, 'Capture applicant inputs');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('2', 3, 'Route for authority decision');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'keywords', 'Rail');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'tags', '2');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'tags', 'Rail');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('2', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.IPTDEC Ver2.1 (2).pdf', '', 'TradeNetDeclaration.IPTDEC Ver2.1 (2)', '3', 'Road', 'Defines the operational requirements for Road.', 'Indha Road section-la, Defines the operational requirements for Road.', '3: Road
4: Air', '3: Road
4: Air', '3: Road
4: Air', 'Indha Road section-la, 3: Road
4: Air', '3: Road
4: Air', '[11]', '["Air", "Road"]', 'Provide knowledge guidance for Road.', '["3", "Road", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC3-R001', '3', '3: Road
4: Air', 'business_rule', 'Road', 'Not explicitly covered in uploaded documents.', 'Not explicitly covered in uploaded documents.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 3 - Road.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3', 1, 'Review section 3 requirements');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3', 2, 'Capture applicant inputs');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('3', 3, 'Route for authority decision');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'Air');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'keywords', 'Road');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'tags', '3');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'tags', 'Road');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('3', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.IPTDEC Ver2.1 (2).pdf', '', 'TradeNetDeclaration.IPTDEC Ver2.1 (2)', '5', 'Mail', 'Defines the operational requirements for Mail.', 'Indha Mail section-la, Defines the operational requirements for Mail.', '5: Mail', '5: Mail', '5: Mail', 'Indha Mail section-la, 5: Mail', '5: Mail', '[11]', '["Mail"]', 'Provide knowledge guidance for Mail.', '["5", "Mail", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC5-R001', '5', '5: Mail', 'business_rule', 'Mail', 'Not explicitly covered in uploaded documents.', 'Not explicitly covered in uploaded documents.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5 - Mail.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5', 1, 'Review section 5 requirements');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5', 2, 'Capture applicant inputs');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5', 3, 'Route for authority decision');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5', 'keywords', 'Mail');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5', 'tags', '5');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5', 'tags', 'Mail');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.IPTDEC Ver2.1 (2).pdf', '', 'TradeNetDeclaration.IPTDEC Ver2.1 (2)', '6', 'Multimodal (For future use)', '6: Multimodal (For future use)', 'Indha Multimodal (For future use) section-la, 6: Multimodal (For future use)', '6: Multimodal (For future use)', '6: Multimodal (For future use)', '6: Multimodal (For future use)', 'Indha Multimodal (For future use) section-la, 6: Multimodal (For future use)', '6: Multimodal (For future use)', '[11]', '["For", "use", "future", "Multimodal"]', 'Provide knowledge guidance for Multimodal (For future use).', '["6", "Multimodal (For future use)", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC6-R001', '6', '6: Multimodal (For future use)', 'business_rule', 'Multimodal (For future use)', 'Not explicitly covered in uploaded documents.', 'Not explicitly covered in uploaded documents.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 6 - Multimodal (For future use).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('6', 1, 'Review section 6 requirements');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('6', 2, 'Capture applicant inputs');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('6', 3, 'Route for authority decision');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'For');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'use');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'future');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'keywords', 'Multimodal');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'tags', '6');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'tags', 'Multimodal (For future use)');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('6', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('TradeNetDeclaration.IPTDEC Ver2.1 (2).pdf', '', 'TradeNetDeclaration.IPTDEC Ver2.1 (2)', '7', 'Pipeline', 'B076 cbc:Conveyance Reference Number C 1 an..17 For transport mode = 1, specify inward voyage number.', 'Indha Pipeline section-la, B076 cbc:Conveyance Reference Number C 1 an..17 For transport mode = 1, specify inward voyage number.', '7: Pipeline
B082 cbc:Mode Code M 1 n1 Specify Inward Transport Mode. B076 cbc:Conveyance Reference Number C 1 an..17 For transport mode = 1, specify inward voyage number. Specify ‘NA’
if there is no inward voyage number.', 'Pipeline governs how DGFT business controls should be applied, validated, and enforced.', 'Pipeline explains the operating rule set that DEKAI should enforce. Key control points include /cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Inward Carrier Agent Party C 1 a) Specify Inward Carrier Agent, must be registered with Customs. The section also drives actions such as ipt:Transport
C
1
Notes:
For all Declaration Types, specify for inward transport, except for
the following:
(i)
Goods released from licensed premises such as Licensed
Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse
(ii)
short payment where place of receipt = SPSTK, SPNOSTK
(iii)
declaration type = BKT (Blanket)
(iv)
recovery payment where place of receipt = RCNOSTK
(v)
payment for goods previously exempted from duties/taxes (e.g..', 'Indha Pipeline section-la, Pipeline explains the operating rule set that DEKAI should enforce. Key control points include /cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Inward Carrier Agent Party C 1 a) Specify Inward Carrier Agent, must be registered with Customs. The section also drives actions such as ipt:Transport
C
1
Notes:
For all Declaration Types, specify for inward transport, except for
the following:
(i)
Goods released from licensed premises such as Licensed
Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse
(ii)
short payment where place of receipt = SPSTK, SPNOSTK
(iii)
declaration type = BKT (Blanket)
(iv)
recovery payment where place of receipt = RCNOSTK
(v)
payment for goods previously exempted from duties/taxes (e.g..', '7: Pipeline
B082 cbc:Mode Code M 1 n1 Specify Inward Transport Mode.
B076 cbc:Conveyance Reference Number C 1 an..17 For transport mode = 1, specify inward voyage number. Specify ‘NA’
if there is no inward voyage number.
For transport mode = 4, specify inward flight number. Specify ‘NA’
if there is no inward flight number.
B049 cbc:Transport Identifier C 1 an..35 For transport mode = 1, specify inward vessel name.
For transport mode = 3, specify Vehicle Licence/Registration Number,
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
/cac:Transport Equipment
B037
cbc:Supply Indicator
C
1 boolean
Specify Supply Indicator for:
a) all dutiable goods of Singapore origin released from Licensed
Warehouse, if there is a supply.
b) all imported goods where there is a supply prior to its release
from Customs'' control.
B020
cbc:Blanket Start Date
C
1 n8
Format: CCYYMMDD
For blanket imports, specify Start Date of Blanket.
ipt:Transport
C
1
Notes:
For all Declaration Types, specify for inward transport, except for
the following:
(i)
Goods released from licensed premises such as Licensed
Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse
(ii)
short payment where place of receipt = SPSTK, SPNOSTK
(iii)
declaration type = BKT (Blanket)
(iv)
recovery payment where place of receipt = RCNOSTK
(v)
payment for goods previously exempted from duties/taxes (e.g.
place of release = EM, EXEMPT)
(vi)
Supplementary declaration for schemes under AISS, IGDS such as
Place of Receipt = AISSLOC, SPIGDS
A026
cac:Inward Transport
M
1
Mandatory to specify Inward transport.
A060
cac:Transport Means
C
1
Specify inward transport mode.
A060
cac:Transport Mode
M
1
For all Declaration Types, valid codes (refer to UN/ECE
Recommendation No. 19) are:
7: Pipeline
B082
cbc:Mode Code
M
1 n1
Specify Inward Transport Mode.
B076
cbc:Conveyance Reference Number
C
1 an..17
For transport mode = 1, specify inward voyage number. Specify ‘NA’
if there is no inward voyage number.
For transport mode = 4, specify inward flight number. Specify ‘NA’
if there is no inward flight number.
B049
cbc:Transport Identifier
C
1 an..35
For transport mode = 1, specify inward vessel name.
For transport mode = 3, specify Vehicle Licence/Registration Number,
OFFICIAL (CLOSED)
AM
if any.
For transport mode = 4, specify inward Aircraft Registration Number
for chartered flights, if any.
/cac:Transport Mode
B064 cbc:MAWBOUCROBLNumber C 1 an..35 For transport mode = 1, to specify inward OUCR/ Ocean Bill of Lading
Number.
For transport mode = 4, specify inward Master Air Waybill.
/cac:Transport Means
B020 cbc:Arrival Date M 1 n8 Format: CCYYMMDD
For inward transport, specify Date of Arrival.
B055 cbc:Loading Port C 1 an..5 For inward transport, Specify Place/Port of Loading.
Specify the port code
(refer to UN/ECE Recommendation No. 16).
/cac:Inward Transport
ipt:Party M 1 Specify party details.
a) For Declaration Type = GST and BKT, specify party type:
- (Declarant)
- (Claimant, if required)
- (Declaring Agent, if declared by Agent)
- (Inward Carrier Agent; optional)
- (Importer)
- (Freight Forwarder; mandatory for consol consignment)
b) For others, specify Party Type:
- (Declarant)
- (Declaring Agent, if declared by Agent)
- (Inward Carrier Agent; optional for transport mode = 2, 3, 5 or
7)
- (Importer)
- (Freight Forwarder; mandatory for consol consignment)
A014 cac:Declarant Party M 1 Specify the identity of the Declarant.
A043 cac:Person Information M 1 Specify Declarant Person Information.
B012 cbc:Code Value M 1 an..17 Specify Declarant Code.
B093 cbc:Name M 1 an..100 Specify Declarant name.
/cac:Person Information
B071 cbc:Telephone M 1 an..25 Mandatory to specify Declarant contact number.
/cac:Declarant Party
A040 cac:Declaring Agent Party C 1 Specify Declaring Agent.
A038 cac:Party Identification M 1 Specify Declaring Agent Party Identification.
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
if any.
For transport mode = 4, specify inward Aircraft Registration Number
for chartered flights, if any.
/cac:Transport Mode
B064
cbc:MAWBOUCROBLNumber
C
1 an..35
For transport mode = 1, to specify inward OUCR/ Ocean Bill of Lading
Number.
For transport mode = 4, specify inward Master Air Waybill.
/cac:Transport Means
B020
cbc:Arrival Date
M
1 n8
Format: CCYYMMDD
For inward transport, specify Date of Arrival.
B055
cbc:Loading Port
C
1 an..5
For inward transport, Specify Place/Port of Loading.
Specify the port code
(refer to UN/ECE Recommendation No. 16).
/cac:Inward Transport
ipt:Party
M
1
Specify party details.
a) For Declaration Type = GST and BKT, specify party type:
- (Declarant)
- (Claimant, if required)
- (Declaring Agent, if declared by Agent)
- (Inward Carrier Agent; optional)
- (Importer)
- (Freight Forwarder; mandatory for consol consignment)
b) For others, specify Party Type:
- (Declarant)
- (Declaring Agent, if declared by Agent)
- (Inward Carrier Agent; optional for transport mode = 2, 3, 5 or
7)
- (Importer)
- (Freight Forwarder; mandatory for consol consignment)
A014
cac:Declarant Party
M
1
Specify the identity of the Declarant.
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
OFFICIAL (CLOSED)
AM
B036 cbc:ID M 1 an..17 Specify Declaring Agent Entity Identifier.
/cac:Party Identification
A039 cac:Party Name M 1 Specify Declaring Agent Party Name.
B093 cbc:Name M 2 an..50 Specify Declaring Agent name.
/cac:Party Name
/cac:Declaring Agent Party
A040 cac:Freight Forwarder Party C 1 Mandatory to specify Freight Forwarder/NVOCC/Cargo
Agent/Consolidator for consol consignment.
A038 cac:Party Identification M 1 Specify Freight Forwarder Party Identification.
B036 cbc:ID M 1 an..17 Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator Entity
Identifier.
/cac:Party Identification
A039 cac:Party Name M 1 Specify Freight Forwarder Party Name.
B093 cbc:Name M 2 an..50 Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator name.
/cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Inward Carrier Agent Party C 1 a) Specify Inward Carrier Agent, must be registered with Customs.
b) Mandatory to specify inward carrier agent if inward transport
mode = 1 or 4 (optional for inward transport mode = 2, 3, 5 or 7;
optional for declaration type = BKT).
A038 cac:Party Identification M 1 Specify Inward Carrier Agent Party Identification.
B036 cbc:ID M 1 an..17 Specify Inward Carrier Agent Entity Identifier.
/cac:Party Identification
A039 cac:Party Name M 1 Specify Inward Carrier Agent Party Name.
B093 cbc:Name M 2 an..50 Specify Inward Carrier Agent name.
/cac:Party Name
/cac:Inward Carrier Agent Party
A040 cac:Importer Party M 1 Specify Importer details.
A038 cac:Party Identification M 1 Specify Importer Party Identification.
B036 cbc:ID M 1 an..17 Specify Importer Entity Identifier.
/cac:Party Identification
A039 cac:Party Name M 1 Specify Importer Party Name.
B093 cbc:Name M 2 an..35 Specify Importer name.
/cac:Party Name
/cac:Importer Party
A011 cac:Claimant Party C 1 Specify Claimant information for Declaration Type = GST and BKT
only. (not applicable for others)
A040 cac:Party Detail M 1 Specify Claimant Party details.
A038 cac:Party Identification M 1 Specify Claimant Party Identification.
B036 cbc:ID M 1 an..17 Specify Claimant company Entity Identifier.
/cac:Party Identification
A039 cac:Party Name M 1 Specify Claimant Party Name.
B093 cbc:Name M 2 an..50 Specify Claimant company name.
/cac:Party Name
/cac:Party Detail
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
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
Mandatory to specify Freight Forwarder/NVOCC/Cargo
Agent/Consolidator for consol consignment.
A038
cac:Party Identification
M
1
Specify Freight Forwarder Party Identification.
B036
cbc:ID
M
1 an..17
Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator Entity
Identifier.
/cac:Party Identification
A039
cac:Party Name
M
1
Specify Freight Forwarder Party Name.
B093
cbc:Name
M
2 an..50
Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator name.
/cac:Party Name
/cac:Freight Forwarder Party
A040
cac:Inward Carrier Agent Party
C
1
a) Specify Inward Carrier Agent, must be registered with Customs.
b) Mandatory to specify inward carrier agent if inward transport
mode = 1 or 4 (optional for inward transport mode = 2, 3, 5 or 7;
optional for declaration type = BKT).
A038
cac:Party Identification
M
1
Specify Inward Carrier Agent Party Identification.
B036
cbc:ID
M
1 an..17
Specify Inward Carrier Agent Entity Identifier.
/cac:Party Identification
A039
cac:Party Name
M
1
Specify Inward Carrier Agent Party Name.
B093
cbc:Name
M
2 an..50
Specify Inward Carrier Agent name.
/cac:Party Name
/cac:Inward Carrier Agent Party
A040
cac:Importer Party
M
1
Specify Importer details.
A038
cac:Party Identification
M
1
Specify Importer Party Identification.
B036
cbc:ID
M
1 an..17
Specify Importer Entity Identifier.
/cac:Party Identification
A039
cac:Party Name
M
1
Specify Importer Party Name.
B093
cbc:Name
M
2 an..35
Specify Importer name.
/cac:Party Name
/cac:Importer Party
A011
cac:Claimant Party
C
1
Specify Claimant information for Declaration Type = GST and BKT
only. (not applicable for others)
A040
cac:Party Detail
M
1
Specify Claimant Party details.
A038
cac:Party Identification
M
1
Specify Claimant Party Identification.
B036
cbc:ID
M
1 an..17
Specify Claimant company Entity Identifier.
/cac:Party Identification
A039
cac:Party Name
M
1
Specify Claimant Party Name.
B093
cbc:Name
M
2 an..50
Specify Claimant company name.
/cac:Party Name
/cac:Party Detail
OFFICIAL (CLOSED)
AM
A043 cac:Claimant Information M 1 Specify Claimant Information.
B012 cbc:Code Value M 1 an..17 Specify Claimant Code.
B093 cbc:Name M 1 an..100 Specify Claimant name.
/cac:Claimant Information
/cac:Claimant Party
cac:Licence C 5 Specify licences or other documents.
B064 cbc:Reference ID M 1 an..35 Specify licences or other documents.
/cac:Licence
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
INVOICE SECTION
cac:Invoice C 20 Repeat at most 20 times.
B064 cbc:Invoice Number C 1 an..35 Mandatory to specify invoice number and invoice date for all cases
except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.
place of release = EM, EXEMPT)
(v) supplementary declaration for schemes under AISS, IGDS such
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
A043
cac:Claimant Information
M
1
Specify Claimant Information.
B012
cbc:Code Value
M
1 an..17
Specify Claimant Code.
B093
cbc:Name
M
1 an..100
Specify Claimant name.
/cac:Claimant Information
/cac:Claimant Party
cac:Licence
C
5
Specify licences or other documents.
B064
cbc:Reference ID
M
1 an..35
Specify licences or other documents.
/cac:Licence
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
INVOICE SECTION
cac:Invoice
C
20
Repeat at most 20 times.
B064
cbc:Invoice Number
C
1 an..35
Mandatory to specify invoice number and invoice date for all cases
except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.
place of release = EM, EXEMPT)
(v) supplementary declaration for schemes under AISS, IGDS such
OFFICIAL (CLOSED)
AM
as place of receipt = AISSLOC, SPIGDS
B020 cbc:Invoice Date C 1 n8 Format: CCYYMMDD
A043 cac:Supplier Manufacturer Party C 1 a) Specify the supplier/ manufacturer name except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.
place of release = EM, EXEMPT)
(v) supplementary declaration for schemes under AISS, IGDS such
as place of receipt = AISSLOC, SPIGDS
b) Specify Supplier code if the Supplier and Importer are related.
B012 cbc:Code Value C 1 an..17 Specify Supplier/Manufacturer code.
B093 cbc:Name C 2 an..50 Specify Supplier/Manufacturer name.
/cac:Supplier Manufacturer Party
B072 cbc:Unit Price Term Type C 1 a3 Specify Unit Price Term Type of the unit price (refer to STDID Code
Lists).
A022 cac:Total Invoice Value C 1 Specify Total Invoice value (excluding other charges listed
separately).
B004 cbc:Amount M 1 n..16 Specify total invoice value.
currency ID (attribute) M 1 a3 Specify the currency code (refer to UN/ECE Recommendation No. 9)
B031 cbc:Exchange Rate C 1 n..11 Specify rate of exchange if currency code is not in SGD.
/cac:Total Invoice Value
A010 cac:Freight Charge C 1 Specify
a) freight charges to derive at CNF value.
b) percentage of freight charge component, if any.
B004 cbc:Amount M 1 n..16 Specify freight charge amount.
currency ID (attribute) M 1 a3 Specify the currency code (refer to UN/ECE Recommendation No. 9)
B031 cbc:Exchange Rate C 1 n..11 Specify rate of exchange if currency code is not in SGD.
B052 cbc:Charge Percent C 1 n..7 Specify percentage of freight charge, if any.
/cac:Freight Charge
A010 cac:Insurance Charge C 1 Specify
a) insurance charges to derive at CIF value, if any.
b) percentage of insurance, if any.
B004 cbc:Amount M 1 n..16 Specify insurance charge amount.
currency ID (attribute) M 1 a3 Specify the currency code (refer to UN/ECE Recommendation No. 9)
B031 cbc:Exchange Rate C 1 n..11 Specify rate of exchange if currency code is not in SGD.
B052 cbc:Charge Percent C 1 n..7 Specify percentage of insurance charges, if any.
/cac:Insurance Charge
A010 cac:Other Taxable Charge C 1 Specify
a) other taxable charges (commission, discount, etc), if any.
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
as place of receipt = AISSLOC, SPIGDS
B020
cbc:Invoice Date
C
1 n8
Format: CCYYMMDD
A043
cac:Supplier Manufacturer Party
C
1
a) Specify the supplier/ manufacturer name except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.
place of release = EM, EXEMPT)
(v) supplementary declaration for schemes under AISS, IGDS such
as place of receipt = AISSLOC, SPIGDS
b) Specify Supplier code if the Supplier and Importer are related.
B012
cbc:Code Value
C
1 an..17
Specify Supplier/Manufacturer code.
B093
cbc:Name
C
2 an..50
Specify Supplier/Manufacturer name.
/cac:Supplier Manufacturer Party
B072
cbc:Unit Price Term Type
C
1 a3
Specify Unit Price Term Type of the unit price (refer to STDID Code
Lists).
A022
cac:Total Invoice Value
C
1
Specify Total Invoice value (excluding other charges listed
separately).
B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify total invoice value.
Specify the currency code (refer to UN/ECE Recommendation No. 9)
B031
cbc:Exchange Rate
C
1 n..11
Specify rate of exchange if currency code is not in SGD.
/cac:Total Invoice Value
A010
cac:Freight Charge
C
1
Specify
a) freight charges to derive at CNF value.
b) percentage of freight charge component, if any.
B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify freight charge amount.
Specify the currency code (refer to UN/ECE Recommendation No. 9)
B031
cbc:Exchange Rate
C
1 n..11
Specify rate of exchange if currency code is not in SGD.
B052
cbc:Charge Percent
C
1 n..7
Specify percentage of freight charge, if any.
/cac:Freight Charge
A010
cac:Insurance Charge
C
1
Specify
a) insurance charges to derive at CIF value, if any.
b) percentage of insurance, if any.
B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify insurance charge amount.
Specify the currency code (refer to UN/ECE Recommendation No. 9)
B031
cbc:Exchange Rate
C
1 n..11
Specify rate of exchange if currency code is not in SGD.
B052
cbc:Charge Percent
C
1 n..7
Specify percentage of insurance charges, if any.
/cac:Insurance Charge
A010
cac:Other Taxable Charge
C
1
Specify
a) other taxable charges (commission, discount, etc), if any.
OFFICIAL (CLOSED)
AM
b) percentage of other taxable charges, if any.
B004 cbc:Amount M 1 n..16 Specify other taxable charge amount.
currency ID (attribute) M 1 a3 Specify the currency code (refer to UN/ECE Recommendation No. 9)
B031 cbc:Exchange Rate C 1 n..11 Specify rate of exchange if currency code is not in SGD.
B052 cbc:Charge Percent C 1 n..7 Specify percentage of other taxable charge, if any.
/cac:Other Taxable Charge
/cac:Invoice
ITEM SECTION
ipt:Item M 50 Repeat at most 50 times.
B068 cbc:Item Sequence Numeric M 1 n..5 Specify item Sequence Number.
B035 cbc:Item Harmonized System Code M 1 an..10 Specify Item Harmonized System code.
B034 cbc:Goods Description M 1 an..512 Specify description of the item.
A030 cac:Item Quantity M 1 Specify the following for both dutiable and non-dutiable cargo.
B058 cbc:Harmonized System Quantity M 1 n..16 For all Declaration Types, specify HS code quantity and the measure
unit specifier must match the measurement unit in the Singapore
Trade Classification.Specify quantity and unit according to invoice
if the measurement unit in Singapore Trade Classification = ‘-’
unit Code (attribute) M 1 an..3 (value).
Specify unit (refer to STDID code list).
B058 cbc:Total Dutiable Quantity C 1 n..16 For goods to be bonded into or released from licensed premises such
as Licensed Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse: specify Total dutiable quantity/weight/volume
i) for products based on specific rates, specify either weight or
volume according to duty rate unit specifier
ii) for others, specify dutiable quantity according to unit price
measurement.
unit Code (attribute) M 1 an..3 Specify unit (refer to STDID code list).
B058 cbc:Dutiable Quantity C 1 n..16 For dutiable cargo based on specific rates in accordance with duty
rate unit specifier:
i) Dutiable quantity/weight/volume.
unit Code (attribute) M 1 an..3 Specify unit (refer to STDID code list).
B052 cbc:Alcohol Percent C 1 n..7 Specify percentage of alcohol by volume for liquor attracting duty
based on alcoholic strength.
/cac:Item Quantity
B016 cbc:Origin Country M 1 a2 Specify Country of Origin of goods.
A057 cac:Transaction Value M 1 Specify item CIF/FOB, LSP, Unit price and optional item charge
amount.
B003 cbc:Item CIFFOBValue M 1 n..16 Mandatory for all Declaration Types to specify item CIF/FOB value in
SGD.
B003 cbc:Last Selling Price Value C 1 n..16 Specify item LSP value.
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
b) percentage of other taxable charges, if any.
B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify other taxable charge amount.
Specify the currency code (refer to UN/ECE Recommendation No. 9)
B031
cbc:Exchange Rate
C
1 n..11
Specify rate of exchange if currency code is not in SGD.
B052
cbc:Charge Percent
C
1 n..7
Specify percentage of other taxable charge, if any.
/cac:Other Taxable Charge
/cac:Invoice
ITEM SECTION
ipt:Item
M
50
Repeat at most 50 times.
B068
cbc:Item Sequence Numeric
M
1 n..5
Specify item Sequence Number.
B035
cbc:Item Harmonized System Code
M
1 an..10
Specify Item Harmonized System code.
B034
cbc:Goods Description
M
1 an..512
Specify description of the item.
A030
cac:Item Quantity
M
1
Specify the following for both dutiable and non-dutiable cargo.
B058
cbc:Harmonized System Quantity
unit Code (attribute)
M
M
1 n..16
1 an..3
For all Declaration Types, specify HS code quantity and the measure
unit specifier must match the measurement unit in the Singapore
Trade Classification.Specify quantity and unit according to invoice
if the measurement unit in Singapore Trade Classification = ‘-’
(value).
Specify unit (refer to STDID code list).
B058
cbc:Total Dutiable Quantity
unit Code (attribute)
C
M
1 n..16
1 an..3
For goods to be bonded into or released from licensed premises such
as Licensed Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse: specify Total dutiable quantity/weight/volume
i) for products based on specific rates, specify either weight or
volume according to duty rate unit specifier
ii) for others, specify dutiable quantity according to unit price
measurement.
Specify unit (refer to STDID code list).
B058
cbc:Dutiable Quantity
unit Code (attribute)
C
M
1 n..16
1 an..3
For dutiable cargo based on specific rates in accordance with duty
rate unit specifier:
i) Dutiable quantity/weight/volume.
Specify unit (refer to STDID code list).
B052
cbc:Alcohol Percent
C
1 n..7
Specify percentage of alcohol by volume for liquor attracting duty
based on alcoholic strength.
/cac:Item Quantity
B016
cbc:Origin Country
M
1 a2
Specify Country of Origin of goods.
A057
cac:Transaction Value
M
1
Specify item CIF/FOB, LSP, Unit price and optional item charge
amount.
B003
cbc:Item CIFFOBValue
M
1 n..16
Mandatory for all Declaration Types to specify item CIF/FOB value in
SGD.
B003
cbc:Last Selling Price Value
C
1 n..16
Specify item LSP value.
OFFICIAL (CLOSED)
AM
Specify LSP if Supply Indicator = true.
A022 cac:Unit Price Value C 1 Specify item unit price value.
B004 cbc:Amount M 1 n..16 Specify item unit price value (amount).
currency ID (attribute) M 1 a3 Specify the currency code (refer to UN/ECE Recommendation No. 9)
B031 cbc:Exchange Rate C 1 n..11 Specify rate of exchange if currency code is not in SGD.
/cac:Unit Price Value
A022 cac:Optional Item Charge C 1 i) specify optional item charges for motor vehicles (eg Accessories
Charge, not included in unit price of motor vehicle).
B004 cbc:Amount M 1 n..16 Specify optional item charges amount.
currency ID (attribute) M 1 a3 Specify the currency code (refer to UN/ECE Recommendation No. 9)
B031 cbc:Exchange Rate C 1 n..11 Specify rate of exchange if currency code is not in SGD.
/cac:Optional Item Charge
/cac:Transaction Value
A008 cac:CASCProduct C 5 Repeat at most 5 times, specify CA/SC product details.
For other uses (refer to Appendix A of SITDED data dictionary).
B057 cbc:CASCProduct Code C 1 an..17 Specify CA/SC product code such as:
(1) Dutiable Motor Vehicle product code
(2) ICDV No.
(3) Item code (to be declared for IEF exemption quota)
B058 cbc:CASCProduct Quantity C 1 n..16 Specify quantity and measurement unit of CA/SC product code.
unit Code (attribute) M 1 an..3 Specify unit (refer to UN/ECE Recommendation No. 20).
A001 cac:Additional CASCIdentification C 50 Repeat at most 50 times.
Specify additional product details (ie. CA/SC code 1, 2, 3).
B057 cbc:CASCCode One M 1 an..35 Examples: Engine No. for motor vehicles when MV product code is
filled.
B057 cbc:CASCCode Two C 1 an..35 Examples: Chassis No. for motor vehicles when MV product code is
filled.
B057 cbc:CASCCode Three C 1 an..35 Examples: Vehicle Type when MV product code is filled.
/cac:Additional CASCIdentification
/cac:CASCProduct
B049 cbc:Brand Name M 1 an..35 Specify brand name.
B022 cbc:Model Description C 1 an..35 Specify model description (if any).
B037 cbc:Dangerous Goods Indicator C Boolean Specify DG indicator for dangerous goods.
A037 cac:Packing Description C 1 Specify packing description for liquor/tobacco products; optional
for others.
Repeat at most 4 times and specify:
1st time: outer-pack quantity
2nd time: in-pack quantity
3rd time: inner-pack quantity
4th time: inmost-pack quantity
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
Specify LSP if Supply Indicator = true.
A022
cac:Unit Price Value
C
1
Specify item unit price value.
B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify item unit price value (amount).
Specify the currency code (refer to UN/ECE Recommendation No. 9)
B031
cbc:Exchange Rate
C
1 n..11
Specify rate of exchange if currency code is not in SGD.
/cac:Unit Price Value
A022
cac:Optional Item Charge
C
1
i) specify optional item charges for motor vehicles (eg Accessories
Charge, not included in unit price of motor vehicle).
B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify optional item charges amount.
Specify the currency code (refer to UN/ECE Recommendation No. 9)
B031
cbc:Exchange Rate
C
1 n..11
Specify rate of exchange if currency code is not in SGD.
/cac:Optional Item Charge
/cac:Transaction Value
A008
cac:CASCProduct
C
5
Repeat at most 5 times, specify CA/SC product details.
For other uses (refer to Appendix A of SITDED data dictionary).
B057
cbc:CASCProduct Code
C
1 an..17
Specify CA/SC product code such as:
(1) Dutiable Motor Vehicle product code
(2) ICDV No.
(3) Item code (to be declared for IEF exemption quota)
B058
cbc:CASCProduct Quantity
unit Code (attribute)
C
M
1 n..16
1 an..3
Specify quantity and measurement unit of CA/SC product code.
Specify unit (refer to UN/ECE Recommendation No. 20).
A001
cac:Additional CASCIdentification
C
50
Repeat at most 50 times.
Specify additional product details (ie. CA/SC code 1, 2, 3).
B057
cbc:CASCCode One
M
1 an..35
Examples: Engine No. for motor vehicles when MV product code is
filled.
B057
cbc:CASCCode Two
C
1 an..35
Examples: Chassis No. for motor vehicles when MV product code is
filled.
B057
cbc:CASCCode Three
C
1 an..35
Examples: Vehicle Type when MV product code is filled.
/cac:Additional CASCIdentification
/cac:CASCProduct
B049
cbc:Brand Name
M
1 an..35
Specify brand name.
B022
cbc:Model Description
C
1 an..35
Specify model description (if any).
B037
cbc:Dangerous Goods Indicator
C
Boolean
Specify DG indicator for dangerous goods.
A037
cac:Packing Description
C
1
Specify packing description for liquor/tobacco products; optional
for others.
Repeat at most 4 times and specify:
1st time: outer-pack quantity
2nd time: in-pack quantity
3rd time: inner-pack quantity
4th time: inmost-pack quantity
OFFICIAL (CLOSED)
AM
B051 cbc:Outer Pack Quantity C 1 n..8 Specify outer-pack quantity.
unit Code (attribute) M 1 an..3 For Packing unit type (refer to STDID Code Lists).
B051 cbc:In Pack Quantity C 1 n..8 Specify in-pack quantity.
unit Code (attribute) M 1 an..3 For Packing unit type (refer to STDID Code Lists).
B051 cbc:Inner Pack Quantity C 1 n..8 Specify inner-pack quantity.
unit Code (attribute) M 1 an..3 For Packing unit type (refer to STDID Code Lists).
B051 cbc:Inmost Pack Quantity C 1 n..8 Specify inmost-pack quantity.
unit Code (attribute) M 1 an..3 For Packing unit type (refer to STDID Code Lists).
/cac:Packing Description
B070 cac:Shipping Marks Information C 4 Specify markings on cargo for marks and numbers, if any.
Repeat at most 4 times and specify:
(1) 1st occurrence: 10 lines x 17 = 170 chars
(2) 2nd occurrence: 10 lines x 17 = 170 chars
(3) 3rd occurrence: 8 lines x 17 = 136 chars
(4) 4th occurrence: 3 lines x 12 = 36 chars
B065 cbc:Shipping Marks M 10 an..17 Specify markings on cargo for marks and numbers.
/cac:Shipping Marks Information
A033 cac:Lot Identification C 1 For goods received into or released from Licensed Premises such as
Licensed Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse, specify current, previous lot number and marking, if
applicable.
B041 cbc:Current Lot Number C 1 an..30 Specify current lot number, if applicable.
B041 cbc:Previous Lot Number C 1 an..30 Specify previous lot number, if applicable.
B043 cbc:Marking C 1 an..2 Specify marking for the goods, if applicable, such as “HW” Health
Warning for tobacco products.
/cac:Lot Identification
B064 cbc:In HAWBHUCRHBLNumber C 1 an..35 Specify Inward HAWB/HUCR/HBL number for transport mode 1 or 4.
B064 cbc:Item Invoice Number C 1 an..35 Mandatory to specify Invoice number except for
i) Used motor vehicle already registered in Singapore under duty
exemption.
ii) Goods under single invoice.
A035 cac:Motor Vehicle C 1 Note:
Mandatory for vehicle products, except for Place of Receipt =
SPNOSTK, SPSTK.
B026 cbc:Engine Capacity C 1 n..7 Specify engine capacity/power for dutiable motor vehicles (refer to
Note).
unit Code (attribute) M 1 an..2 Specify engine capacity (in cubic capacity – cc) or power unit (in
kilo watt - k W).
B020 cbc:Original Registration Date C n8 Format: CCYYMMDD
Specify date of first registration (for used motor vehicles).
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
B051
cbc:Outer Pack Quantity
unit Code (attribute)
C
M
1 n..8
1 an..3
Specify outer-pack quantity.
For Packing unit type (refer to STDID Code Lists).
B051
cbc:In Pack Quantity
unit Code (attribute)
C
M
1 n..8
1 an..3
Specify in-pack quantity.
For Packing unit type (refer to STDID Code Lists).
B051
cbc:Inner Pack Quantity
unit Code (attribute)
C
M
1 n..8
1 an..3
Specify inner-pack quantity.
For Packing unit type (refer to STDID Code Lists).
B051
cbc:Inmost Pack Quantity
unit Code (attribute)
C
M
1 n..8
1 an..3
Specify inmost-pack quantity.
For Packing unit type (refer to STDID Code Lists).
/cac:Packing Description
B070
cac:Shipping Marks Information
C
4
Specify markings on cargo for marks and numbers, if any.
Repeat at most 4 times and specify:
(1) 1st occurrence: 10 lines x 17 = 170 chars
(2) 2nd occurrence: 10 lines x 17 = 170 chars
(3) 3rd occurrence: 8 lines x 17 = 136 chars
(4) 4th occurrence: 3 lines x 12 = 36 chars
B065
cbc:Shipping Marks
M
10 an..17
Specify markings on cargo for marks and numbers.
/cac:Shipping Marks Information
A033
cac:Lot Identification
C
1
For goods received into or released from Licensed Premises such as
Licensed Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse, specify current, previous lot number and marking, if
applicable.
B041
cbc:Current Lot Number
C
1 an..30
Specify current lot number, if applicable.
B041
cbc:Previous Lot Number
C
1 an..30
Specify previous lot number, if applicable.
B043
cbc:Marking
C
1 an..2
Specify marking for the goods, if applicable, such as “HW” Health
Warning for tobacco products.
/cac:Lot Identification
B064
cbc:In HAWBHUCRHBLNumber
C
1 an..35
Specify Inward HAWB/HUCR/HBL number for transport mode 1 or 4.
B064
cbc:Item Invoice Number
C
1 an..35
Mandatory to specify Invoice number except for
i) Used motor vehicle already registered in Singapore under duty
exemption.
ii) Goods under single invoice.
A035
cac:Motor Vehicle
C
1
Note:
Mandatory for vehicle products, except for Place of Receipt =
SPNOSTK, SPSTK.
B026
cbc:Engine Capacity
unit Code (attribute)
C
M
1 n..7
1 an..2
Specify engine capacity/power for dutiable motor vehicles (refer to
Note).
Specify engine capacity (in cubic capacity – cc) or power unit (in
kilo watt - k W).
B020
cbc:Original Registration Date
C
n8
Format: CCYYMMDD
Specify date of first registration (for used motor vehicles).
OFFICIAL (CLOSED)
AM
Mandatory for used dutiable motor vehicles (refer to Note).
/cac:Motor Vehicle
A054 cac:Tariff C 1 Specify duties and taxes amount
B056 cbc:Preferential Code C 1 an..3 Specify “PRF” if goods are imported under preferential duty rates.
A023 cac:Goods And Services Tax C 1 Specify the item GST:
a) For Declaration Type = GST, the declared item GST payable amount
must be equal to (CIF/LSP x GST rate).
b) For other Declaration Types, the declared item GST payable
amount must equal to (CIF/LSP + Customs Duty + Excise Duty +
Other tax) X GST rate, where applicable
B060 cbc:Goods And Services Tax Percent M 1 n..2 Specify percentage for GST rate.
B003 cbc:Goods And Services Tax Amount M 1 n..16 Specify item GST payable amount.
/cac:Goods And Services Tax
A016 cac:Excise Duty C 1 For dutiable goods subject to Excise Duty:
B024 cbc:Duty Rate M 1 n..8 Specify item Excise Duty rate for dutiable goods subject to Excise
Duty.
B025 cbc:Duty Rate Unit M 1 an..3 Specify the unit which the excise duty rate applies to.
B003 cbc:Duty Amount M 1 n..16 Specify item Excise Duty amount.
/cac:Excise Duty
A016 cac:Customs Duty C 1 For dutiable goods subject to Customs Duty, if any:
B024 cbc:Duty Rate M 1 n..8 Specify item Customs Duty rate for dutiable goods subject to Customs
Duty, if any.
B025 cbc:Duty Rate Unit M 1 an..3 Specify the unit which the customs duty rate applies to.
B003 cbc:Duty Amount M 1 n..16 Specify item Customs Duty amount.
/cac:Customs Duty
A016 cac:Other Tax C 1 For all Declaration Types, specify Other tax, if applicable.
B024 cbc:Duty Rate M 1 n..8 Specify item Other tax rate, if any.
B025 cbc:Duty Rate Unit M 1 an..3 Specify the unit which the other tax rate applies to.
B003 cbc:Duty Amount M 1 n..16 specify item other tax amount.
/cac:Other Tax
/cac:Tariff
SUMMARY SECTION
ipt:Summary M 1
B068 cbc:Number Of Items M 1 n..5 Specify total number of items declared.
B003 cbc:Total CIFFOBValue M 1 n..16 Specify Total CIF/FOB value in SGD based on the sum of CIF/FOB
amount declared at line items.
B092 cbc:Total Outer Pack M 1 n..8 Specify Total Outer Pack.
unit Code (attribute) M 1 an..3 Specify unit (refer to STDID Code List).
B091 cbc:Total Gross Weight M 1 n..15 Specify Total Gross Weight
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
Mandatory for used dutiable motor vehicles (refer to Note).
/cac:Motor Vehicle
A054
cac:Tariff
C
1
Specify duties and taxes amount
B056
cbc:Preferential Code
C
1 an..3
Specify “PRF” if goods are imported under preferential duty rates.
A023
cac:Goods And Services Tax
C
1
Specify the item GST:
a)
For Declaration Type = GST, the declared item GST payable amount
must be equal to (CIF/LSP x GST rate).
b)
For other Declaration Types, the declared item GST payable
amount must equal to (CIF/LSP + Customs Duty + Excise Duty +
Other tax) X GST rate, where applicable
B060
cbc:Goods And Services Tax Percent
M
1 n..2
Specify percentage for GST rate.
B003
cbc:Goods And Services Tax Amount
M
1 n..16
Specify item GST payable amount.
/cac:Goods And Services Tax
A016
cac:Excise Duty
C
1
For dutiable goods subject to Excise Duty:
B024
cbc:Duty Rate
M
1 n..8
Specify item Excise Duty rate for dutiable goods subject to Excise
Duty.
B025
cbc:Duty Rate Unit
M
1 an..3
Specify the unit which the excise duty rate applies to.
B003
cbc:Duty Amount
M
1 n..16
Specify item Excise Duty amount.
/cac:Excise Duty
A016
cac:Customs Duty
C
1
For dutiable goods subject to Customs Duty, if any:
B024
cbc:Duty Rate
M
1 n..8
Specify item Customs Duty rate for dutiable goods subject to Customs
Duty, if any.
B025
cbc:Duty Rate Unit
M
1 an..3
Specify the unit which the customs duty rate applies to.
B003
cbc:Duty Amount
M
1 n..16
Specify item Customs Duty amount.
/cac:Customs Duty
A016
cac:Other Tax
C
1
For all Declaration Types, specify Other tax, if applicable.
B024
cbc:Duty Rate
M
1 n..8
Specify item Other tax rate, if any.
B025
cbc:Duty Rate Unit
M
1 an..3
Specify the unit which the other tax rate applies to.
B003
cbc:Duty Amount
M
1 n..16
specify item other tax amount.
/cac:Other Tax
/cac:Tariff
SUMMARY SECTION
ipt:Summary
M
1
B068
cbc:Number Of Items
M
1 n..5
Specify total number of items declared.
B003
cbc:Total CIFFOBValue
M
1 n..16
Specify Total CIF/FOB value in SGD based on the sum of CIF/FOB
amount declared at line items.
B092
cbc:Total Outer Pack
unit Code (attribute)
M
M
1 n..8
1 an..3
Specify Total Outer Pack.
Specify unit (refer to STDID Code List).
B091
cbc:Total Gross Weight
M
1 n..15
Specify Total Gross Weight
OFFICIAL (CLOSED)
AM
unit Code (attribute) M 1 an..3 Specify unit (refer to weight measurement code in STDID Code List).
i) For transport mode = 1, the unit code must be set to TNE.
ii) For transport mode = 4, the unit code must be set to KGM.
A056 cac:Total Tariff C 1
B003 cbc:Total Goods And Services Tax Amount C 1 n..16 Specify Total GST amount payable based on the sum of GST amount
declared at line items.
B003 cbc:Total Excise Duty Amount C 1 n..16 Specify Total Excise Duty amount payable based on the sum of excise
duty amount declared at line items.
B003 cbc:Total Customs Duty Amount C 1 n..16 Specify Total Customs Duty amount payable based on the sum of
customs duty amount declared at line items.
B003 cbc:Total Other Tax Amount C 1 n..16 Specify Total Other Tax amount payable based on the sum of other tax
amount declared at line items.
B003 cbc:Total Amount Payable C 1 n..16 Specify Total Amount Payable:
i) if declaration type = GST, total amount payable = total GST
ii) if declaration type = DUT, total amount payable = total
customs duty + total excise duty + total other tax
iii) if declaration type = DNG, total amount payable = total
customs duty + total excise duty + total other tax + total
GST
iv) if declaration type = BKT, total amount payable = total
customs duty + total excise duty + total other tax + total
GST (Total GST is not applicable for dutiable goods of
Singapore origin where supply indicator = blank)
/cac:Total Tariff
End Declaration ---------------------
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.
TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
unit Code (attribute)
M
1 an..3
Specify unit (refer to weight measurement code in STDID Code List).
i) For transport mode = 1, the unit code must be set to TNE.
ii) For transport mode = 4, the unit code must be set to KGM.
A056
cac:Total Tariff
C
1
B003
cbc:Total Goods And Services Tax Amount
C
1 n..16
Specify Total GST amount payable based on the sum of GST amount
declared at line items.
B003
cbc:Total Excise Duty Amount
C
1 n..16
Specify Total Excise Duty amount payable based on the sum of excise
duty amount declared at line items.
B003
cbc:Total Customs Duty Amount
C
1 n..16
Specify Total Customs Duty amount payable based on the sum of
customs duty amount declared at line items.
B003
cbc:Total Other Tax Amount
C
1 n..16
Specify Total Other Tax amount payable based on the sum of other tax
amount declared at line items.
B003
cbc:Total Amount Payable
C
1 n..16
Specify Total Amount Payable:
i)
if declaration type = GST, total amount payable = total GST
ii)
if declaration type = DUT, total amount payable = total
customs duty + total excise duty + total other tax
iii) if declaration type = DNG, total amount payable = total
customs duty + total excise duty + total other tax + total
GST
iv)
if declaration type = BKT, total amount payable = total
customs duty + total excise duty + total other tax + total
GST (Total GST is not applicable for dutiable goods of
Singapore origin where supply indicator = blank)
/cac:Total Tariff
End Declaration ---------------------', '[11, 12, 13, 14, 15, 16, 17, 18, 19, 20]', '["cbc", "For", "Net", "doc", "XML", "Ver", "cac", "all", "its", "ipt", "the", "iii", "BKT", "are", "any", "Air", "GST", "and", "not", "PDF"]', 'Support Pipeline processing and compliance validation.', '["7", "Pipeline", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC7-R001', '7', '/cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Inward Carrier Agent Party C 1 a) Specify Inward Carrier Agent, must be registered with Customs.', 'business_rule', 'Pipeline', '7: Pipeline
B082 cbc:Mode Code M 1 n1 Specify Inward Transport Mode.', 'a) For Declaration Type = GST and BKT, specify party type:
- (Declarant)
- (Claimant, if required)
- (Declaring Agent, if declared by Agent)
- (Inward Carrier Agent; optional)
- (Importer)
- (Freight Forwarder; mandatory for consol consignment)
b) For others, specify Party Type:
- (Declarant)
- (Declaring Agent, if declared by Agent)
- (Inward Carrier Agent; optional for transport mode = 2, 3, 5 or
7)
- (Importer)
- (Freight Forwarder; mandatory for consol consignment)
A014 cac:Declarant Party M 1 Specify the identity of the Declarant.', 'ipt:Transport
C
1
Notes:
For all Declaration Types, specify for inward transport, except for
the following:
(i)
Goods released from licensed premises such as Licensed
Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse
(ii)
short payment where place of receipt = SPSTK, SPNOSTK
(iii)
declaration type = BKT (Blanket)
(iv)
recovery payment where place of receipt = RCNOSTK
(v)
payment for goods previously exempted from duties/taxes (e.g.', 'ipt:Transport
C
1
Notes:
For all Declaration Types, specify for inward transport, except for
the following:
(i)
Goods released from licensed premises such as Licensed
Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse
(ii)
short payment where place of receipt = SPSTK, SPNOSTK
(iii)
declaration type = BKT (Blanket)
(iv)
recovery payment where place of receipt = RCNOSTK
(v)
payment for goods previously exempted from duties/taxes (e.g.', 'DEKAI should produce a compliance decision for 7 - Pipeline.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC7-R002', '7', '/cac:Party Name
/cac:Freight Forwarder Party
A040
cac:Inward Carrier Agent Party
C
1
a) Specify Inward Carrier Agent, must be registered with Customs.', 'business_rule', 'Pipeline', 'B076 cbc:Conveyance Reference Number C 1 an..17 For transport mode = 1, specify inward voyage number.', 'a) For Declaration Type = GST and BKT, specify party type:
- (Declarant)
- (Claimant, if required)
- (Declaring Agent, if declared by Agent)
- (Inward Carrier Agent; optional)
- (Importer)
- (Freight Forwarder; mandatory for consol consignment)
b) For others, specify Party Type:
- (Declarant)
- (Declaring Agent, if declared by Agent)
- (Inward Carrier Agent; optional for transport mode = 2, 3, 5 or
7)
- (Importer)
- (Freight Forwarder; mandatory for consol consignment)
A014
cac:Declarant Party
M
1
Specify the identity of the Declarant.', '/cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Inward Carrier Agent Party C 1 a) Specify Inward Carrier Agent, must be registered with Customs.', 'place of release = EM, EXEMPT)
(vi)
Supplementary declaration for schemes under AISS, IGDS such as
Place of Receipt = AISSLOC, SPIGDS
A026
cac:Inward Transport
M
1
Mandatory to specify Inward transport.', 'DEKAI should produce a compliance decision for 7 - Pipeline.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC7-R003', '7', 'B058 cbc:Harmonized System Quantity M 1 n..16 For all Declaration Types, specify HS code quantity and the measure
unit specifier must match the measurement unit in the Singapore
Trade Classification.Specify quantity and unit according to invoice
if the measurement unit in Singapore Trade Classification = ‘-’
unit Code (attribute) M 1 an..3 (value).', 'business_rule', 'Pipeline', 'Specify ‘NA’
if there is no inward voyage number.', '/cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Inward Carrier Agent Party C 1 a) Specify Inward Carrier Agent, must be registered with Customs.', '/cac:Party Name
/cac:Freight Forwarder Party
A040
cac:Inward Carrier Agent Party
C
1
a) Specify Inward Carrier Agent, must be registered with Customs.', 'B064 cbc:Invoice Number C 1 an..35 Mandatory to specify invoice number and invoice date for all cases
except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.', 'DEKAI should produce a compliance decision for 7 - Pipeline.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC7-R004', '7', 'B058
cbc:Harmonized System Quantity
unit Code (attribute)
M
M
1 n..16
1 an..3
For all Declaration Types, specify HS code quantity and the measure
unit specifier must match the measurement unit in the Singapore
Trade Classification.Specify quantity and unit according to invoice
if the measurement unit in Singapore Trade Classification = ‘-’
(value).', 'business_rule', 'Pipeline', 'For transport mode = 4, specify inward flight number.', '/cac:Party Name
/cac:Freight Forwarder Party
A040
cac:Inward Carrier Agent Party
C
1
a) Specify Inward Carrier Agent, must be registered with Customs.', 'B064 cbc:Invoice Number C 1 an..35 Mandatory to specify invoice number and invoice date for all cases
except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.', 'place of release = EM, EXEMPT)
(v) supplementary declaration for schemes under AISS, IGDS such
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', 'DEKAI should produce a compliance decision for 7 - Pipeline.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC7-R005', '7', 'A023 cac:Goods And Services Tax C 1 Specify the item GST:
a) For Declaration Type = GST, the declared item GST payable amount
must be equal to (CIF/LSP x GST rate).', 'business_rule', 'Pipeline', 'Specify ‘NA’
if there is no inward flight number.', 'B058 cbc:Harmonized System Quantity M 1 n..16 For all Declaration Types, specify HS code quantity and the measure
unit specifier must match the measurement unit in the Singapore
Trade Classification.Specify quantity and unit according to invoice
if the measurement unit in Singapore Trade Classification = ‘-’
unit Code (attribute) M 1 an..3 (value).', 'B064
cbc:Invoice Number
C
1 an..35
Mandatory to specify invoice number and invoice date for all cases
except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.', 'B064
cbc:Invoice Number
C
1 an..35
Mandatory to specify invoice number and invoice date for all cases
except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.', 'DEKAI should produce a compliance decision for 7 - Pipeline.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC7-R006', '7', 'b) For other Declaration Types, the declared item GST payable
amount must equal to (CIF/LSP + Customs Duty + Excise Duty +
Other tax) X GST rate, where applicable
B060 cbc:Goods And Services Tax Percent M 1 n..2 Specify percentage for GST rate.', 'business_rule', 'Pipeline', 'B049 cbc:Transport Identifier C 1 an..35 For transport mode = 1, specify inward vessel name.', 'B058
cbc:Harmonized System Quantity
unit Code (attribute)
M
M
1 n..16
1 an..3
For all Declaration Types, specify HS code quantity and the measure
unit specifier must match the measurement unit in the Singapore
Trade Classification.Specify quantity and unit according to invoice
if the measurement unit in Singapore Trade Classification = ‘-’
(value).', 'place of release = EM, EXEMPT)
(v) supplementary declaration for schemes under AISS, IGDS such
OFFICIAL (CLOSED)
AM
as place of receipt = AISSLOC, SPIGDS
B020 cbc:Invoice Date C 1 n8 Format: CCYYMMDD
A043 cac:Supplier Manufacturer Party C 1 a) Specify the supplier/ manufacturer name except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.', 'place of release = EM, EXEMPT)
(v) supplementary declaration for schemes under AISS, IGDS such
OFFICIAL (CLOSED)
AM
as place of receipt = AISSLOC, SPIGDS
B020 cbc:Invoice Date C 1 n8 Format: CCYYMMDD
A043 cac:Supplier Manufacturer Party C 1 a) Specify the supplier/ manufacturer name except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.', 'DEKAI should produce a compliance decision for 7 - Pipeline.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC7-R007', '7', '/cac:Goods And Services Tax
A016 cac:Excise Duty C 1 For dutiable goods subject to Excise Duty:
B024 cbc:Duty Rate M 1 n..8 Specify item Excise Duty rate for dutiable goods subject to Excise
Duty.', 'business_rule', 'Pipeline', 'For transport mode = 3, specify Vehicle Licence/Registration Number,
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.', 'A023 cac:Goods And Services Tax C 1 Specify the item GST:
a) For Declaration Type = GST, the declared item GST payable amount
must be equal to (CIF/LSP x GST rate).', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
as place of receipt = AISSLOC, SPIGDS
B020
cbc:Invoice Date
C
1 n8
Format: CCYYMMDD
A043
cac:Supplier Manufacturer Party
C
1
a) Specify the supplier/ manufacturer name except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.', 'place of release = EM, EXEMPT)
(v) supplementary declaration for schemes under AISS, IGDS such
as place of receipt = AISSLOC, SPIGDS
b) Specify Supplier code if the Supplier and Importer are related.', 'DEKAI should produce a compliance decision for 7 - Pipeline.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC7-R008', '7', '/cac:Excise Duty
A016 cac:Customs Duty C 1 For dutiable goods subject to Customs Duty, if any:
B024 cbc:Duty Rate M 1 n..8 Specify item Customs Duty rate for dutiable goods subject to Customs
Duty, if any.', 'business_rule', 'Pipeline', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
/cac:Transport Equipment
B037
cbc:Supply Indicator
C
1 boolean
Specify Supply Indicator for:
a) all dutiable goods of Singapore origin released from Licensed
Warehouse, if there is a supply.', 'b) For other Declaration Types, the declared item GST payable
amount must equal to (CIF/LSP + Customs Duty + Excise Duty +
Other tax) X GST rate, where applicable
B060 cbc:Goods And Services Tax Percent M 1 n..2 Specify percentage for GST rate.', 'B064 cbc:Item Invoice Number C 1 an..35 Mandatory to specify Invoice number except for
i) Used motor vehicle already registered in Singapore under duty
exemption.', 'currency ID (attribute) M 1 a3 Specify the currency code (refer to UN/ECE Recommendation No.', 'DEKAI should produce a compliance decision for 7 - Pipeline.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC7-R009', '7', 'A023
cac:Goods And Services Tax
C
1
Specify the item GST:
a)
For Declaration Type = GST, the declared item GST payable amount
must be equal to (CIF/LSP x GST rate).', 'business_rule', 'Pipeline', 'b) all imported goods where there is a supply prior to its release
from Customs'' control.', 'A023
cac:Goods And Services Tax
C
1
Specify the item GST:
a)
For Declaration Type = GST, the declared item GST payable amount
must be equal to (CIF/LSP x GST rate).', 'B064
cbc:Item Invoice Number
C
1 an..35
Mandatory to specify Invoice number except for
i) Used motor vehicle already registered in Singapore under duty
exemption.', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
as place of receipt = AISSLOC, SPIGDS
B020
cbc:Invoice Date
C
1 n8
Format: CCYYMMDD
A043
cac:Supplier Manufacturer Party
C
1
a) Specify the supplier/ manufacturer name except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.', 'DEKAI should produce a compliance decision for 7 - Pipeline.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC7-R010', '7', 'b)
For other Declaration Types, the declared item GST payable
amount must equal to (CIF/LSP + Customs Duty + Excise Duty +
Other tax) X GST rate, where applicable
B060
cbc:Goods And Services Tax Percent
M
1 n..2
Specify percentage for GST rate.', 'business_rule', 'Pipeline', 'B020
cbc:Blanket Start Date
C
1 n8
Format: CCYYMMDD
For blanket imports, specify Start Date of Blanket.', 'b)
For other Declaration Types, the declared item GST payable
amount must equal to (CIF/LSP + Customs Duty + Excise Duty +
Other tax) X GST rate, where applicable
B060
cbc:Goods And Services Tax Percent
M
1 n..2
Specify percentage for GST rate.', 'A023 cac:Goods And Services Tax C 1 Specify the item GST:
a) For Declaration Type = GST, the declared item GST payable amount
must be equal to (CIF/LSP x GST rate).', 'B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify total invoice value.', 'DEKAI should produce a compliance decision for 7 - Pipeline.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC7-R011', '7', '/cac:Goods And Services Tax
A016
cac:Excise Duty
C
1
For dutiable goods subject to Excise Duty:
B024
cbc:Duty Rate
M
1 n..8
Specify item Excise Duty rate for dutiable goods subject to Excise
Duty.', 'business_rule', 'Pipeline', 'ipt:Transport
C
1
Notes:
For all Declaration Types, specify for inward transport, except for
the following:
(i)
Goods released from licensed premises such as Licensed
Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse
(ii)
short payment where place of receipt = SPSTK, SPNOSTK
(iii)
declaration type = BKT (Blanket)
(iv)
recovery payment where place of receipt = RCNOSTK
(v)
payment for goods previously exempted from duties/taxes (e.g.', 'i) For transport mode = 1, the unit code must be set to TNE.', 'b) For other Declaration Types, the declared item GST payable
amount must equal to (CIF/LSP + Customs Duty + Excise Duty +
Other tax) X GST rate, where applicable
B060 cbc:Goods And Services Tax Percent M 1 n..2 Specify percentage for GST rate.', 'B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify freight charge amount.', 'DEKAI should produce a compliance decision for 7 - Pipeline.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC7-R012', '7', '/cac:Excise Duty
A016
cac:Customs Duty
C
1
For dutiable goods subject to Customs Duty, if any:
B024
cbc:Duty Rate
M
1 n..8
Specify item Customs Duty rate for dutiable goods subject to Customs
Duty, if any.', 'business_rule', 'Pipeline', 'place of release = EM, EXEMPT)
(vi)
Supplementary declaration for schemes under AISS, IGDS such as
Place of Receipt = AISSLOC, SPIGDS
A026
cac:Inward Transport
M
1
Mandatory to specify Inward transport.', 'ii) For transport mode = 4, the unit code must be set to KGM.', 'B003 cbc:Goods And Services Tax Amount M 1 n..16 Specify item GST payable amount.', 'B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify insurance charge amount.', 'DEKAI should produce a compliance decision for 7 - Pipeline.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC7-R013', '7', 'i) For transport mode = 1, the unit code must be set to TNE.', 'business_rule', 'Pipeline', 'A060
cac:Transport Means
C
1
Specify inward transport mode.', 'ii) For transport mode = 4, the unit code must be set to KGM.', 'A023
cac:Goods And Services Tax
C
1
Specify the item GST:
a)
For Declaration Type = GST, the declared item GST payable amount
must be equal to (CIF/LSP x GST rate).', 'B058 cbc:Harmonized System Quantity M 1 n..16 For all Declaration Types, specify HS code quantity and the measure
unit specifier must match the measurement unit in the Singapore
Trade Classification.Specify quantity and unit according to invoice
if the measurement unit in Singapore Trade Classification = ‘-’
unit Code (attribute) M 1 an..3 (value).', 'DEKAI should produce a compliance decision for 7 - Pipeline.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH-SEC7-R014', '7', 'ii) For transport mode = 4, the unit code must be set to KGM.', 'business_rule', 'Pipeline', '19) are:
7: Pipeline
B082
cbc:Mode Code
M
1 n1
Specify Inward Transport Mode.', 'ii) For transport mode = 4, the unit code must be set to KGM.', 'b)
For other Declaration Types, the declared item GST payable
amount must equal to (CIF/LSP + Customs Duty + Excise Duty +
Other tax) X GST rate, where applicable
B060
cbc:Goods And Services Tax Percent
M
1 n..2
Specify percentage for GST rate.', 'unit Code (attribute) M 1 an..3 Specify unit (refer to STDID code list).', 'DEKAI should produce a compliance decision for 7 - Pipeline.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '7: Pipeline
B082 cbc:Mode Code M 1 n1 Specify Inward Transport Mode.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B076 cbc:Conveyance Reference Number C 1 an..17 For transport mode = 1, specify inward voyage number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'Specify ‘NA’
if there is no inward voyage number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'For transport mode = 4, specify inward flight number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'Specify ‘NA’
if there is no inward flight number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B049 cbc:Transport Identifier C 1 an..35 For transport mode = 1, specify inward vessel name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'For transport mode = 3, specify Vehicle Licence/Registration Number,
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
/cac:Transport Equipment
B037
cbc:Supply Indicator
C
1 boolean
Specify Supply Indicator for:
a) all dutiable goods of Singapore origin released from Licensed
Warehouse, if there is a supply.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'b) all imported goods where there is a supply prior to its release
from Customs'' control.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B020
cbc:Blanket Start Date
C
1 n8
Format: CCYYMMDD
For blanket imports, specify Start Date of Blanket.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'ipt:Transport
C
1
Notes:
For all Declaration Types, specify for inward transport, except for
the following:
(i)
Goods released from licensed premises such as Licensed
Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse
(ii)
short payment where place of receipt = SPSTK, SPNOSTK
(iii)
declaration type = BKT (Blanket)
(iv)
recovery payment where place of receipt = RCNOSTK
(v)
payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'place of release = EM, EXEMPT)
(vi)
Supplementary declaration for schemes under AISS, IGDS such as
Place of Receipt = AISSLOC, SPIGDS
A026
cac:Inward Transport
M
1
Mandatory to specify Inward transport.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A060
cac:Transport Means
C
1
Specify inward transport mode.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '19) are:
7: Pipeline
B082
cbc:Mode Code
M
1 n1
Specify Inward Transport Mode.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B076
cbc:Conveyance Reference Number
C
1 an..17
For transport mode = 1, specify inward voyage number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B049
cbc:Transport Identifier
C
1 an..35
For transport mode = 1, specify inward vessel name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'For transport mode = 3, specify Vehicle Licence/Registration Number,
OFFICIAL (CLOSED)
AM
if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'For transport mode = 4, specify inward Aircraft Registration Number
for chartered flights, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Transport Mode
B064 cbc:MAWBOUCROBLNumber C 1 an..35 For transport mode = 1, to specify inward OUCR/ Ocean Bill of Lading
Number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'For transport mode = 4, specify inward Master Air Waybill.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Transport Means
B020 cbc:Arrival Date M 1 n8 Format: CCYYMMDD
For inward transport, specify Date of Arrival.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B055 cbc:Loading Port C 1 an..5 For inward transport, Specify Place/Port of Loading.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'Specify the port code
(refer to UN/ECE Recommendation No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Inward Transport
ipt:Party M 1 Specify party details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'a) For Declaration Type = GST and BKT, specify party type:
- (Declarant)
- (Claimant, if required)
- (Declaring Agent, if declared by Agent)
- (Inward Carrier Agent; optional)
- (Importer)
- (Freight Forwarder; mandatory for consol consignment)
b) For others, specify Party Type:
- (Declarant)
- (Declaring Agent, if declared by Agent)
- (Inward Carrier Agent; optional for transport mode = 2, 3, 5 or
7)
- (Importer)
- (Freight Forwarder; mandatory for consol consignment)
A014 cac:Declarant Party M 1 Specify the identity of the Declarant.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A043 cac:Person Information M 1 Specify Declarant Person Information.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B012 cbc:Code Value M 1 an..17 Specify Declarant Code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B093 cbc:Name M 1 an..100 Specify Declarant name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Person Information
B071 cbc:Telephone M 1 an..25 Mandatory to specify Declarant contact number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Declarant Party
A040 cac:Declaring Agent Party C 1 Specify Declaring Agent.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A038 cac:Party Identification M 1 Specify Declaring Agent Party Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Transport Mode
B064
cbc:MAWBOUCROBLNumber
C
1 an..35
For transport mode = 1, to specify inward OUCR/ Ocean Bill of Lading
Number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Transport Means
B020
cbc:Arrival Date
M
1 n8
Format: CCYYMMDD
For inward transport, specify Date of Arrival.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B055
cbc:Loading Port
C
1 an..5
For inward transport, Specify Place/Port of Loading.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Inward Transport
ipt:Party
M
1
Specify party details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'a) For Declaration Type = GST and BKT, specify party type:
- (Declarant)
- (Claimant, if required)
- (Declaring Agent, if declared by Agent)
- (Inward Carrier Agent; optional)
- (Importer)
- (Freight Forwarder; mandatory for consol consignment)
b) For others, specify Party Type:
- (Declarant)
- (Declaring Agent, if declared by Agent)
- (Inward Carrier Agent; optional for transport mode = 2, 3, 5 or
7)
- (Importer)
- (Freight Forwarder; mandatory for consol consignment)
A014
cac:Declarant Party
M
1
Specify the identity of the Declarant.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A043
cac:Person Information
M
1
Specify Declarant Person Information.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B012
cbc:Code Value
M
1 an..17
Specify Declarant Code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B093
cbc:Name
M
1 an..100
Specify Declarant name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Person Information
B071
cbc:Telephone
M
1 an..25
Mandatory to specify Declarant contact number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Declarant Party
A040
cac:Declaring Agent Party
C
1
Specify Declaring Agent.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A038
cac:Party Identification
M
1
Specify Declaring Agent Party Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'OFFICIAL (CLOSED)
AM
B036 cbc:ID M 1 an..17 Specify Declaring Agent Entity Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Identification
A039 cac:Party Name M 1 Specify Declaring Agent Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B093 cbc:Name M 2 an..50 Specify Declaring Agent name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Name
/cac:Declaring Agent Party
A040 cac:Freight Forwarder Party C 1 Mandatory to specify Freight Forwarder/NVOCC/Cargo
Agent/Consolidator for consol consignment.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A038 cac:Party Identification M 1 Specify Freight Forwarder Party Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B036 cbc:ID M 1 an..17 Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator Entity
Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Identification
A039 cac:Party Name M 1 Specify Freight Forwarder Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B093 cbc:Name M 2 an..50 Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Inward Carrier Agent Party C 1 a) Specify Inward Carrier Agent, must be registered with Customs.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'b) Mandatory to specify inward carrier agent if inward transport
mode = 1 or 4 (optional for inward transport mode = 2, 3, 5 or 7;
optional for declaration type = BKT).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A038 cac:Party Identification M 1 Specify Inward Carrier Agent Party Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B036 cbc:ID M 1 an..17 Specify Inward Carrier Agent Entity Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Identification
A039 cac:Party Name M 1 Specify Inward Carrier Agent Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B093 cbc:Name M 2 an..50 Specify Inward Carrier Agent name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Name
/cac:Inward Carrier Agent Party
A040 cac:Importer Party M 1 Specify Importer details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A038 cac:Party Identification M 1 Specify Importer Party Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B036 cbc:ID M 1 an..17 Specify Importer Entity Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Identification
A039 cac:Party Name M 1 Specify Importer Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B093 cbc:Name M 2 an..35 Specify Importer name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Name
/cac:Importer Party
A011 cac:Claimant Party C 1 Specify Claimant information for Declaration Type = GST and BKT
only.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '(not applicable for others)
A040 cac:Party Detail M 1 Specify Claimant Party details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A038 cac:Party Identification M 1 Specify Claimant Party Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B036 cbc:ID M 1 an..17 Specify Claimant company Entity Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Identification
A039 cac:Party Name M 1 Specify Claimant Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B093 cbc:Name M 2 an..50 Specify Claimant company name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Name
/cac:Party Detail
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
B036
cbc:ID
M
1 an..17
Specify Declaring Agent Entity Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Identification
A039
cac:Party Name
M
1
Specify Declaring Agent Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B093
cbc:Name
M
2 an..50
Specify Declaring Agent name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Name
/cac:Declaring Agent Party
A040
cac:Freight Forwarder Party
C
1
Mandatory to specify Freight Forwarder/NVOCC/Cargo
Agent/Consolidator for consol consignment.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A038
cac:Party Identification
M
1
Specify Freight Forwarder Party Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B036
cbc:ID
M
1 an..17
Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator Entity
Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Identification
A039
cac:Party Name
M
1
Specify Freight Forwarder Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B093
cbc:Name
M
2 an..50
Specify Freight Forwarder/NVOCC/Cargo Agent/Consolidator name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Name
/cac:Freight Forwarder Party
A040
cac:Inward Carrier Agent Party
C
1
a) Specify Inward Carrier Agent, must be registered with Customs.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A038
cac:Party Identification
M
1
Specify Inward Carrier Agent Party Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B036
cbc:ID
M
1 an..17
Specify Inward Carrier Agent Entity Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Identification
A039
cac:Party Name
M
1
Specify Inward Carrier Agent Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B093
cbc:Name
M
2 an..50
Specify Inward Carrier Agent name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Name
/cac:Inward Carrier Agent Party
A040
cac:Importer Party
M
1
Specify Importer details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A038
cac:Party Identification
M
1
Specify Importer Party Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B036
cbc:ID
M
1 an..17
Specify Importer Entity Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Identification
A039
cac:Party Name
M
1
Specify Importer Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B093
cbc:Name
M
2 an..35
Specify Importer name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Name
/cac:Importer Party
A011
cac:Claimant Party
C
1
Specify Claimant information for Declaration Type = GST and BKT
only.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '(not applicable for others)
A040
cac:Party Detail
M
1
Specify Claimant Party details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A038
cac:Party Identification
M
1
Specify Claimant Party Identification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B036
cbc:ID
M
1 an..17
Specify Claimant company Entity Identifier.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Identification
A039
cac:Party Name
M
1
Specify Claimant Party Name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B093
cbc:Name
M
2 an..50
Specify Claimant company name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Party Name
/cac:Party Detail
OFFICIAL (CLOSED)
AM
A043 cac:Claimant Information M 1 Specify Claimant Information.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B012 cbc:Code Value M 1 an..17 Specify Claimant Code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B093 cbc:Name M 1 an..100 Specify Claimant name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Claimant Information
/cac:Claimant Party
cac:Licence C 5 Specify licences or other documents.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B064 cbc:Reference ID M 1 an..35 Specify licences or other documents.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Licence
cac:Supporting Document Reference C 10 Repeat at most 10 times, specify supporting documents attached to
the declaration if applicable.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'Only the following file formats are allowed:
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
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B033 cbc:Filename M 1 an..70 Specify Filename of the document.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B064 cbc:Invoice Number C 1 an..35 Mandatory to specify invoice number and invoice date for all cases
except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'place of release = EM, EXEMPT)
(v) supplementary declaration for schemes under AISS, IGDS such
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
A043
cac:Claimant Information
M
1
Specify Claimant Information.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B012
cbc:Code Value
M
1 an..17
Specify Claimant Code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B093
cbc:Name
M
1 an..100
Specify Claimant name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Claimant Information
/cac:Claimant Party
cac:Licence
C
5
Specify licences or other documents.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B064
cbc:Reference ID
M
1 an..35
Specify licences or other documents.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Licence
cac:Supporting Document Reference
C
10
Repeat at most 10 times, specify supporting documents attached to
the declaration if applicable.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'Only the following file formats are allowed:
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
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B033
cbc:Filename
M
1 an..70
Specify Filename of the document.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B064
cbc:Invoice Number
C
1 an..35
Mandatory to specify invoice number and invoice date for all cases
except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'place of release = EM, EXEMPT)
(v) supplementary declaration for schemes under AISS, IGDS such
OFFICIAL (CLOSED)
AM
as place of receipt = AISSLOC, SPIGDS
B020 cbc:Invoice Date C 1 n8 Format: CCYYMMDD
A043 cac:Supplier Manufacturer Party C 1 a) Specify the supplier/ manufacturer name except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'place of release = EM, EXEMPT)
(v) supplementary declaration for schemes under AISS, IGDS such
as place of receipt = AISSLOC, SPIGDS
b) Specify Supplier code if the Supplier and Importer are related.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B012 cbc:Code Value C 1 an..17 Specify Supplier/Manufacturer code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B093 cbc:Name C 2 an..50 Specify Supplier/Manufacturer name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Supplier Manufacturer Party
B072 cbc:Unit Price Term Type C 1 a3 Specify Unit Price Term Type of the unit price (refer to STDID Code
Lists).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A022 cac:Total Invoice Value C 1 Specify Total Invoice value (excluding other charges listed
separately).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B004 cbc:Amount M 1 n..16 Specify total invoice value.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'currency ID (attribute) M 1 a3 Specify the currency code (refer to UN/ECE Recommendation No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '9)
B031 cbc:Exchange Rate C 1 n..11 Specify rate of exchange if currency code is not in SGD.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Total Invoice Value
A010 cac:Freight Charge C 1 Specify
a) freight charges to derive at CNF value.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'b) percentage of freight charge component, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B004 cbc:Amount M 1 n..16 Specify freight charge amount.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B052 cbc:Charge Percent C 1 n..7 Specify percentage of freight charge, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Freight Charge
A010 cac:Insurance Charge C 1 Specify
a) insurance charges to derive at CIF value, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'b) percentage of insurance, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B004 cbc:Amount M 1 n..16 Specify insurance charge amount.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B052 cbc:Charge Percent C 1 n..7 Specify percentage of insurance charges, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Insurance Charge
A010 cac:Other Taxable Charge C 1 Specify
a) other taxable charges (commission, discount, etc), if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
as place of receipt = AISSLOC, SPIGDS
B020
cbc:Invoice Date
C
1 n8
Format: CCYYMMDD
A043
cac:Supplier Manufacturer Party
C
1
a) Specify the supplier/ manufacturer name except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B012
cbc:Code Value
C
1 an..17
Specify Supplier/Manufacturer code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B093
cbc:Name
C
2 an..50
Specify Supplier/Manufacturer name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Supplier Manufacturer Party
B072
cbc:Unit Price Term Type
C
1 a3
Specify Unit Price Term Type of the unit price (refer to STDID Code
Lists).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A022
cac:Total Invoice Value
C
1
Specify Total Invoice value (excluding other charges listed
separately).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify total invoice value.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'Specify the currency code (refer to UN/ECE Recommendation No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '9)
B031
cbc:Exchange Rate
C
1 n..11
Specify rate of exchange if currency code is not in SGD.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Total Invoice Value
A010
cac:Freight Charge
C
1
Specify
a) freight charges to derive at CNF value.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify freight charge amount.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B052
cbc:Charge Percent
C
1 n..7
Specify percentage of freight charge, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Freight Charge
A010
cac:Insurance Charge
C
1
Specify
a) insurance charges to derive at CIF value, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify insurance charge amount.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B052
cbc:Charge Percent
C
1 n..7
Specify percentage of insurance charges, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Insurance Charge
A010
cac:Other Taxable Charge
C
1
Specify
a) other taxable charges (commission, discount, etc), if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'OFFICIAL (CLOSED)
AM
b) percentage of other taxable charges, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B004 cbc:Amount M 1 n..16 Specify other taxable charge amount.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B052 cbc:Charge Percent C 1 n..7 Specify percentage of other taxable charge, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B068 cbc:Item Sequence Numeric M 1 n..5 Specify item Sequence Number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B035 cbc:Item Harmonized System Code M 1 an..10 Specify Item Harmonized System code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B034 cbc:Goods Description M 1 an..512 Specify description of the item.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A030 cac:Item Quantity M 1 Specify the following for both dutiable and non-dutiable cargo.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B058 cbc:Harmonized System Quantity M 1 n..16 For all Declaration Types, specify HS code quantity and the measure
unit specifier must match the measurement unit in the Singapore
Trade Classification.Specify quantity and unit according to invoice
if the measurement unit in Singapore Trade Classification = ‘-’
unit Code (attribute) M 1 an..3 (value).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'Specify unit (refer to STDID code list).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B058 cbc:Total Dutiable Quantity C 1 n..16 For goods to be bonded into or released from licensed premises such
as Licensed Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse: specify Total dutiable quantity/weight/volume
i) for products based on specific rates, specify either weight or
volume according to duty rate unit specifier
ii) for others, specify dutiable quantity according to unit price
measurement.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'unit Code (attribute) M 1 an..3 Specify unit (refer to STDID code list).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B058 cbc:Dutiable Quantity C 1 n..16 For dutiable cargo based on specific rates in accordance with duty
rate unit specifier:
i) Dutiable quantity/weight/volume.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B052 cbc:Alcohol Percent C 1 n..7 Specify percentage of alcohol by volume for liquor attracting duty
based on alcoholic strength.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Item Quantity
B016 cbc:Origin Country M 1 a2 Specify Country of Origin of goods.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A057 cac:Transaction Value M 1 Specify item CIF/FOB, LSP, Unit price and optional item charge
amount.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003 cbc:Item CIFFOBValue M 1 n..16 Mandatory for all Declaration Types to specify item CIF/FOB value in
SGD.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003 cbc:Last Selling Price Value C 1 n..16 Specify item LSP value.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
b) percentage of other taxable charges, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify other taxable charge amount.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B052
cbc:Charge Percent
C
1 n..7
Specify percentage of other taxable charge, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B068
cbc:Item Sequence Numeric
M
1 n..5
Specify item Sequence Number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B035
cbc:Item Harmonized System Code
M
1 an..10
Specify Item Harmonized System code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B034
cbc:Goods Description
M
1 an..512
Specify description of the item.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A030
cac:Item Quantity
M
1
Specify the following for both dutiable and non-dutiable cargo.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B058
cbc:Harmonized System Quantity
unit Code (attribute)
M
M
1 n..16
1 an..3
For all Declaration Types, specify HS code quantity and the measure
unit specifier must match the measurement unit in the Singapore
Trade Classification.Specify quantity and unit according to invoice
if the measurement unit in Singapore Trade Classification = ‘-’
(value).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B058
cbc:Total Dutiable Quantity
unit Code (attribute)
C
M
1 n..16
1 an..3
For goods to be bonded into or released from licensed premises such
as Licensed Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse: specify Total dutiable quantity/weight/volume
i) for products based on specific rates, specify either weight or
volume according to duty rate unit specifier
ii) for others, specify dutiable quantity according to unit price
measurement.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B058
cbc:Dutiable Quantity
unit Code (attribute)
C
M
1 n..16
1 an..3
For dutiable cargo based on specific rates in accordance with duty
rate unit specifier:
i) Dutiable quantity/weight/volume.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B052
cbc:Alcohol Percent
C
1 n..7
Specify percentage of alcohol by volume for liquor attracting duty
based on alcoholic strength.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Item Quantity
B016
cbc:Origin Country
M
1 a2
Specify Country of Origin of goods.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A057
cac:Transaction Value
M
1
Specify item CIF/FOB, LSP, Unit price and optional item charge
amount.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003
cbc:Item CIFFOBValue
M
1 n..16
Mandatory for all Declaration Types to specify item CIF/FOB value in
SGD.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003
cbc:Last Selling Price Value
C
1 n..16
Specify item LSP value.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'OFFICIAL (CLOSED)
AM
Specify LSP if Supply Indicator = true.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A022 cac:Unit Price Value C 1 Specify item unit price value.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B004 cbc:Amount M 1 n..16 Specify item unit price value (amount).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Unit Price Value
A022 cac:Optional Item Charge C 1 i) specify optional item charges for motor vehicles (eg Accessories
Charge, not included in unit price of motor vehicle).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B004 cbc:Amount M 1 n..16 Specify optional item charges amount.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Optional Item Charge
/cac:Transaction Value
A008 cac:CASCProduct C 5 Repeat at most 5 times, specify CA/SC product details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B057 cbc:CASCProduct Code C 1 an..17 Specify CA/SC product code such as:
(1) Dutiable Motor Vehicle product code
(2) ICDV No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '(3) Item code (to be declared for IEF exemption quota)
B058 cbc:CASCProduct Quantity C 1 n..16 Specify quantity and measurement unit of CA/SC product code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'unit Code (attribute) M 1 an..3 Specify unit (refer to UN/ECE Recommendation No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A001 cac:Additional CASCIdentification C 50 Repeat at most 50 times.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'Specify additional product details (ie.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'for motor vehicles when MV product code is
filled.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B057 cbc:CASCCode Three C 1 an..35 Examples: Vehicle Type when MV product code is filled.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Additional CASCIdentification
/cac:CASCProduct
B049 cbc:Brand Name M 1 an..35 Specify brand name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B022 cbc:Model Description C 1 an..35 Specify model description (if any).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B037 cbc:Dangerous Goods Indicator C Boolean Specify DG indicator for dangerous goods.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A037 cac:Packing Description C 1 Specify packing description for liquor/tobacco products; optional
for others.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'Repeat at most 4 times and specify:
1st time: outer-pack quantity
2nd time: in-pack quantity
3rd time: inner-pack quantity
4th time: inmost-pack quantity
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
Specify LSP if Supply Indicator = true.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A022
cac:Unit Price Value
C
1
Specify item unit price value.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify item unit price value (amount).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Unit Price Value
A022
cac:Optional Item Charge
C
1
i) specify optional item charges for motor vehicles (eg Accessories
Charge, not included in unit price of motor vehicle).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify optional item charges amount.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Optional Item Charge
/cac:Transaction Value
A008
cac:CASCProduct
C
5
Repeat at most 5 times, specify CA/SC product details.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B057
cbc:CASCProduct Code
C
1 an..17
Specify CA/SC product code such as:
(1) Dutiable Motor Vehicle product code
(2) ICDV No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '(3) Item code (to be declared for IEF exemption quota)
B058
cbc:CASCProduct Quantity
unit Code (attribute)
C
M
1 n..16
1 an..3
Specify quantity and measurement unit of CA/SC product code.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'Specify unit (refer to UN/ECE Recommendation No.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A001
cac:Additional CASCIdentification
C
50
Repeat at most 50 times.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B057
cbc:CASCCode Three
C
1 an..35
Examples: Vehicle Type when MV product code is filled.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Additional CASCIdentification
/cac:CASCProduct
B049
cbc:Brand Name
M
1 an..35
Specify brand name.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B022
cbc:Model Description
C
1 an..35
Specify model description (if any).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B037
cbc:Dangerous Goods Indicator
C
Boolean
Specify DG indicator for dangerous goods.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A037
cac:Packing Description
C
1
Specify packing description for liquor/tobacco products; optional
for others.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'Repeat at most 4 times and specify:
1st time: outer-pack quantity
2nd time: in-pack quantity
3rd time: inner-pack quantity
4th time: inmost-pack quantity
OFFICIAL (CLOSED)
AM
B051 cbc:Outer Pack Quantity C 1 n..8 Specify outer-pack quantity.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B051 cbc:In Pack Quantity C 1 n..8 Specify in-pack quantity.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B051 cbc:Inner Pack Quantity C 1 n..8 Specify inner-pack quantity.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B051 cbc:Inmost Pack Quantity C 1 n..8 Specify inmost-pack quantity.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Packing Description
B070 cac:Shipping Marks Information C 4 Specify markings on cargo for marks and numbers, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'Repeat at most 4 times and specify:
(1) 1st occurrence: 10 lines x 17 = 170 chars
(2) 2nd occurrence: 10 lines x 17 = 170 chars
(3) 3rd occurrence: 8 lines x 17 = 136 chars
(4) 4th occurrence: 3 lines x 12 = 36 chars
B065 cbc:Shipping Marks M 10 an..17 Specify markings on cargo for marks and numbers.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Shipping Marks Information
A033 cac:Lot Identification C 1 For goods received into or released from Licensed Premises such as
Licensed Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse, specify current, previous lot number and marking, if
applicable.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B041 cbc:Current Lot Number C 1 an..30 Specify current lot number, if applicable.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B041 cbc:Previous Lot Number C 1 an..30 Specify previous lot number, if applicable.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B043 cbc:Marking C 1 an..2 Specify marking for the goods, if applicable, such as “HW” Health
Warning for tobacco products.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Lot Identification
B064 cbc:In HAWBHUCRHBLNumber C 1 an..35 Specify Inward HAWB/HUCR/HBL number for transport mode 1 or 4.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B064 cbc:Item Invoice Number C 1 an..35 Mandatory to specify Invoice number except for
i) Used motor vehicle already registered in Singapore under duty
exemption.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B026 cbc:Engine Capacity C 1 n..7 Specify engine capacity/power for dutiable motor vehicles (refer to
Note).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'unit Code (attribute) M 1 an..2 Specify engine capacity (in cubic capacity – cc) or power unit (in
kilo watt - k W).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B020 cbc:Original Registration Date C n8 Format: CCYYMMDD
Specify date of first registration (for used motor vehicles).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
B051
cbc:Outer Pack Quantity
unit Code (attribute)
C
M
1 n..8
1 an..3
Specify outer-pack quantity.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B051
cbc:In Pack Quantity
unit Code (attribute)
C
M
1 n..8
1 an..3
Specify in-pack quantity.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B051
cbc:Inner Pack Quantity
unit Code (attribute)
C
M
1 n..8
1 an..3
Specify inner-pack quantity.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B051
cbc:Inmost Pack Quantity
unit Code (attribute)
C
M
1 n..8
1 an..3
Specify inmost-pack quantity.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Packing Description
B070
cac:Shipping Marks Information
C
4
Specify markings on cargo for marks and numbers, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'Repeat at most 4 times and specify:
(1) 1st occurrence: 10 lines x 17 = 170 chars
(2) 2nd occurrence: 10 lines x 17 = 170 chars
(3) 3rd occurrence: 8 lines x 17 = 136 chars
(4) 4th occurrence: 3 lines x 12 = 36 chars
B065
cbc:Shipping Marks
M
10 an..17
Specify markings on cargo for marks and numbers.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Shipping Marks Information
A033
cac:Lot Identification
C
1
For goods received into or released from Licensed Premises such as
Licensed Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse, specify current, previous lot number and marking, if
applicable.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B041
cbc:Current Lot Number
C
1 an..30
Specify current lot number, if applicable.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B041
cbc:Previous Lot Number
C
1 an..30
Specify previous lot number, if applicable.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B043
cbc:Marking
C
1 an..2
Specify marking for the goods, if applicable, such as “HW” Health
Warning for tobacco products.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Lot Identification
B064
cbc:In HAWBHUCRHBLNumber
C
1 an..35
Specify Inward HAWB/HUCR/HBL number for transport mode 1 or 4.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B064
cbc:Item Invoice Number
C
1 an..35
Mandatory to specify Invoice number except for
i) Used motor vehicle already registered in Singapore under duty
exemption.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B026
cbc:Engine Capacity
unit Code (attribute)
C
M
1 n..7
1 an..2
Specify engine capacity/power for dutiable motor vehicles (refer to
Note).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'Specify engine capacity (in cubic capacity – cc) or power unit (in
kilo watt - k W).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B020
cbc:Original Registration Date
C
n8
Format: CCYYMMDD
Specify date of first registration (for used motor vehicles).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Motor Vehicle
A054 cac:Tariff C 1 Specify duties and taxes amount
B056 cbc:Preferential Code C 1 an..3 Specify “PRF” if goods are imported under preferential duty rates.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A023 cac:Goods And Services Tax C 1 Specify the item GST:
a) For Declaration Type = GST, the declared item GST payable amount
must be equal to (CIF/LSP x GST rate).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'b) For other Declaration Types, the declared item GST payable
amount must equal to (CIF/LSP + Customs Duty + Excise Duty +
Other tax) X GST rate, where applicable
B060 cbc:Goods And Services Tax Percent M 1 n..2 Specify percentage for GST rate.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003 cbc:Goods And Services Tax Amount M 1 n..16 Specify item GST payable amount.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Goods And Services Tax
A016 cac:Excise Duty C 1 For dutiable goods subject to Excise Duty:
B024 cbc:Duty Rate M 1 n..8 Specify item Excise Duty rate for dutiable goods subject to Excise
Duty.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B025 cbc:Duty Rate Unit M 1 an..3 Specify the unit which the excise duty rate applies to.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003 cbc:Duty Amount M 1 n..16 Specify item Excise Duty amount.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Excise Duty
A016 cac:Customs Duty C 1 For dutiable goods subject to Customs Duty, if any:
B024 cbc:Duty Rate M 1 n..8 Specify item Customs Duty rate for dutiable goods subject to Customs
Duty, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B025 cbc:Duty Rate Unit M 1 an..3 Specify the unit which the customs duty rate applies to.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003 cbc:Duty Amount M 1 n..16 Specify item Customs Duty amount.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Customs Duty
A016 cac:Other Tax C 1 For all Declaration Types, specify Other tax, if applicable.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B024 cbc:Duty Rate M 1 n..8 Specify item Other tax rate, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B025 cbc:Duty Rate Unit M 1 an..3 Specify the unit which the other tax rate applies to.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003 cbc:Duty Amount M 1 n..16 specify item other tax amount.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Other Tax
/cac:Tariff
SUMMARY SECTION
ipt:Summary M 1
B068 cbc:Number Of Items M 1 n..5 Specify total number of items declared.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003 cbc:Total CIFFOBValue M 1 n..16 Specify Total CIF/FOB value in SGD based on the sum of CIF/FOB
amount declared at line items.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B092 cbc:Total Outer Pack M 1 n..8 Specify Total Outer Pack.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B091 cbc:Total Gross Weight M 1 n..15 Specify Total Gross Weight
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Motor Vehicle
A054
cac:Tariff
C
1
Specify duties and taxes amount
B056
cbc:Preferential Code
C
1 an..3
Specify “PRF” if goods are imported under preferential duty rates.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A023
cac:Goods And Services Tax
C
1
Specify the item GST:
a)
For Declaration Type = GST, the declared item GST payable amount
must be equal to (CIF/LSP x GST rate).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'b)
For other Declaration Types, the declared item GST payable
amount must equal to (CIF/LSP + Customs Duty + Excise Duty +
Other tax) X GST rate, where applicable
B060
cbc:Goods And Services Tax Percent
M
1 n..2
Specify percentage for GST rate.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003
cbc:Goods And Services Tax Amount
M
1 n..16
Specify item GST payable amount.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Goods And Services Tax
A016
cac:Excise Duty
C
1
For dutiable goods subject to Excise Duty:
B024
cbc:Duty Rate
M
1 n..8
Specify item Excise Duty rate for dutiable goods subject to Excise
Duty.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B025
cbc:Duty Rate Unit
M
1 an..3
Specify the unit which the excise duty rate applies to.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003
cbc:Duty Amount
M
1 n..16
Specify item Excise Duty amount.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Excise Duty
A016
cac:Customs Duty
C
1
For dutiable goods subject to Customs Duty, if any:
B024
cbc:Duty Rate
M
1 n..8
Specify item Customs Duty rate for dutiable goods subject to Customs
Duty, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B025
cbc:Duty Rate Unit
M
1 an..3
Specify the unit which the customs duty rate applies to.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003
cbc:Duty Amount
M
1 n..16
Specify item Customs Duty amount.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Customs Duty
A016
cac:Other Tax
C
1
For all Declaration Types, specify Other tax, if applicable.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B024
cbc:Duty Rate
M
1 n..8
Specify item Other tax rate, if any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B025
cbc:Duty Rate Unit
M
1 an..3
Specify the unit which the other tax rate applies to.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003
cbc:Duty Amount
M
1 n..16
specify item other tax amount.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', '/cac:Other Tax
/cac:Tariff
SUMMARY SECTION
ipt:Summary
M
1
B068
cbc:Number Of Items
M
1 n..5
Specify total number of items declared.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003
cbc:Total CIFFOBValue
M
1 n..16
Specify Total CIF/FOB value in SGD based on the sum of CIF/FOB
amount declared at line items.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B092
cbc:Total Outer Pack
unit Code (attribute)
M
M
1 n..8
1 an..3
Specify Total Outer Pack.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B091
cbc:Total Gross Weight
M
1 n..15
Specify Total Gross Weight
OFFICIAL (CLOSED)
AM
unit Code (attribute) M 1 an..3 Specify unit (refer to weight measurement code in STDID Code List).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A056 cac:Total Tariff C 1
B003 cbc:Total Goods And Services Tax Amount C 1 n..16 Specify Total GST amount payable based on the sum of GST amount
declared at line items.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003 cbc:Total Excise Duty Amount C 1 n..16 Specify Total Excise Duty amount payable based on the sum of excise
duty amount declared at line items.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003 cbc:Total Customs Duty Amount C 1 n..16 Specify Total Customs Duty amount payable based on the sum of
customs duty amount declared at line items.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003 cbc:Total Other Tax Amount C 1 n..16 Specify Total Other Tax amount payable based on the sum of other tax
amount declared at line items.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003 cbc:Total Amount Payable C 1 n..16 Specify Total Amount Payable:
i) if declaration type = GST, total amount payable = total GST
ii) if declaration type = DUT, total amount payable = total
customs duty + total excise duty + total other tax
iii) if declaration type = DNG, total amount payable = total
customs duty + total excise duty + total other tax + total
GST
iv) if declaration type = BKT, total amount payable = total
customs duty + total excise duty + total other tax + total
GST (Total GST is not applicable for dutiable goods of
Singapore origin where supply indicator = blank)
/cac:Total Tariff
End Declaration ---------------------
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
unit Code (attribute)
M
1 an..3
Specify unit (refer to weight measurement code in STDID Code List).');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'A056
cac:Total Tariff
C
1
B003
cbc:Total Goods And Services Tax Amount
C
1 n..16
Specify Total GST amount payable based on the sum of GST amount
declared at line items.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003
cbc:Total Excise Duty Amount
C
1 n..16
Specify Total Excise Duty amount payable based on the sum of excise
duty amount declared at line items.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003
cbc:Total Customs Duty Amount
C
1 n..16
Specify Total Customs Duty amount payable based on the sum of
customs duty amount declared at line items.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003
cbc:Total Other Tax Amount
C
1 n..16
Specify Total Other Tax amount payable based on the sum of other tax
amount declared at line items.');
INSERT INTO conditions (section_code, condition_text) VALUES ('7', 'B003
cbc:Total Amount Payable
C
1 n..16
Specify Total Amount Payable:
i)
if declaration type = GST, total amount payable = total GST
ii)
if declaration type = DUT, total amount payable = total
customs duty + total excise duty + total other tax
iii) if declaration type = DNG, total amount payable = total
customs duty + total excise duty + total other tax + total
GST
iv)
if declaration type = BKT, total amount payable = total
customs duty + total excise duty + total other tax + total
GST (Total GST is not applicable for dutiable goods of
Singapore origin where supply indicator = blank)
/cac:Total Tariff
End Declaration ---------------------');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'Vehicle Licence');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'Trade Net Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'For all Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'place of release = EM, EXEMPT)
(vi)
Supplementary declaration for schemes under AISS, IGDS such as
Place of Receipt = AISSLOC, SPIGDS
A026
cac:Inward Transport
M
1
Mandatory to specify Inward transport.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'OUCR/ Ocean Bill');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'For transport mode = 4, specify inward Master Air Waybill.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'For Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'b) Mandatory to specify inward carrier agent if inward transport
mode = 1 or 4 (optional for inward transport mode = 2, 3, 5 or 7;
optional for declaration type = BKT).');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'Claimant Party C 1 Specify Claimant information for Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'Specify Claimant information for Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('7', '/cac:Claimant Information
/cac:Claimant Party
cac:Licence C 5 Specify licences or other documents.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'B064 cbc:Reference ID M 1 an..35 Specify licences or other documents.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'Supporting Document');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'Specify Document');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'B033 cbc:Filename M 1 an..70 Specify Filename of the document.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'B064 cbc:Invoice Number C 1 an..35 Mandatory to specify invoice number and invoice date for all cases
except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO documents (section_code, document_name) VALUES ('7', '/cac:Claimant Information
/cac:Claimant Party
cac:Licence
C
5
Specify licences or other documents.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'B064
cbc:Reference ID
M
1 an..35
Specify licences or other documents.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'B033
cbc:Filename
M
1 an..70
Specify Filename of the document.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'B064
cbc:Invoice Number
C
1 an..35
Mandatory to specify invoice number and invoice date for all cases
except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'place of release = EM, EXEMPT)
(v) supplementary declaration for schemes under AISS, IGDS such
OFFICIAL (CLOSED)
AM
as place of receipt = AISSLOC, SPIGDS
B020 cbc:Invoice Date C 1 n8 Format: CCYYMMDD
A043 cac:Supplier Manufacturer Party C 1 a) Specify the supplier/ manufacturer name except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'place of release = EM, EXEMPT)
(v) supplementary declaration for schemes under AISS, IGDS such
as place of receipt = AISSLOC, SPIGDS
b) Specify Supplier code if the Supplier and Importer are related.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'Total Invoice Value C 1 Specify Total Invoice');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'B004 cbc:Amount M 1 n..16 Specify total invoice value.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'Total Invoice');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'Specify Total Invoice');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify total invoice value.');
INSERT INTO documents (section_code, document_name) VALUES ('7', '/cac:Other Taxable Charge
/cac:Invoice
ITEM SECTION
ipt:Item M 50 Repeat at most 50 times.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'B058 cbc:Total Dutiable Quantity C 1 n..16 For goods to be bonded into or released from licensed premises such
as Licensed Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse: specify Total dutiable quantity/weight/volume
i) for products based on specific rates, specify either weight or
volume according to duty rate unit specifier
ii) for others, specify dutiable quantity according to unit price
measurement.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'Mandatory for all Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('7', '/cac:Other Taxable Charge
/cac:Invoice
ITEM SECTION
ipt:Item
M
50
Repeat at most 50 times.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'B058
cbc:Total Dutiable Quantity
unit Code (attribute)
C
M
1 n..16
1 an..3
For goods to be bonded into or released from licensed premises such
as Licensed Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse: specify Total dutiable quantity/weight/volume
i) for products based on specific rates, specify either weight or
volume according to duty rate unit specifier
ii) for others, specify dutiable quantity according to unit price
measurement.');
INSERT INTO documents (section_code, document_name) VALUES ('7', '/cac:Shipping Marks Information
A033 cac:Lot Identification C 1 For goods received into or released from Licensed Premises such as
Licensed Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse, specify current, previous lot number and marking, if
applicable.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'Item Invoice');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'Mandatory to specify Invoice');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'ii) Goods under single invoice.');
INSERT INTO documents (section_code, document_name) VALUES ('7', '/cac:Shipping Marks Information
A033
cac:Lot Identification
C
1
For goods received into or released from Licensed Premises such as
Licensed Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse, specify current, previous lot number and marking, if
applicable.');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'For other Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'Other Tax C 1 For all Declaration');
INSERT INTO documents (section_code, document_name) VALUES ('7', 'End Declaration');
INSERT INTO authorities (section_code, authority_name) VALUES ('7', 'Customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('7', 'For dutiable goods subject to Customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('7', 'Specify item Customs Duty rate for dutiable goods subject to Customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('7', 'Specify item Customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('7', 'Total Customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('7', 'Specify Total Customs');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'ipt:Transport
C
1
Notes:
For all Declaration Types, specify for inward transport, except for
the following:
(i)
Goods released from licensed premises such as Licensed
Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse
(ii)
short payment where place of receipt = SPSTK, SPNOSTK
(iii)
declaration type = BKT (Blanket)
(iv)
recovery payment where place of receipt = RCNOSTK
(v)
payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'place of release = EM, EXEMPT)
(vi)
Supplementary declaration for schemes under AISS, IGDS such as
Place of Receipt = AISSLOC, SPIGDS
A026
cac:Inward Transport
M
1
Mandatory to specify Inward transport.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B064 cbc:Invoice Number C 1 an..35 Mandatory to specify invoice number and invoice date for all cases
except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'place of release = EM, EXEMPT)
(v) supplementary declaration for schemes under AISS, IGDS such
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (CLOSED)
TRADENET MESSAGE
18/11/2021 11:10
AM
Prepared by:
For:
Release Date
18/11/2021
Ver
4.1
Reference
TRADENET
Document Id.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B064
cbc:Invoice Number
C
1 an..35
Mandatory to specify invoice number and invoice date for all cases
except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'place of release = EM, EXEMPT)
(v) supplementary declaration for schemes under AISS, IGDS such
OFFICIAL (CLOSED)
AM
as place of receipt = AISSLOC, SPIGDS
B020 cbc:Invoice Date C 1 n8 Format: CCYYMMDD
A043 cac:Supplier Manufacturer Party C 1 a) Specify the supplier/ manufacturer name except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'place of release = EM, EXEMPT)
(v) supplementary declaration for schemes under AISS, IGDS such
as place of receipt = AISSLOC, SPIGDS
b) Specify Supplier code if the Supplier and Importer are related.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'currency ID (attribute) M 1 a3 Specify the currency code (refer to UN/ECE Recommendation No.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
as place of receipt = AISSLOC, SPIGDS
B020
cbc:Invoice Date
C
1 n8
Format: CCYYMMDD
A043
cac:Supplier Manufacturer Party
C
1
a) Specify the supplier/ manufacturer name except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify total invoice value.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify freight charge amount.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify insurance charge amount.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B058 cbc:Harmonized System Quantity M 1 n..16 For all Declaration Types, specify HS code quantity and the measure
unit specifier must match the measurement unit in the Singapore
Trade Classification.Specify quantity and unit according to invoice
if the measurement unit in Singapore Trade Classification = ‘-’
unit Code (attribute) M 1 an..3 (value).');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'unit Code (attribute) M 1 an..3 Specify unit (refer to STDID code list).');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify other taxable charge amount.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B058
cbc:Harmonized System Quantity
unit Code (attribute)
M
M
1 n..16
1 an..3
For all Declaration Types, specify HS code quantity and the measure
unit specifier must match the measurement unit in the Singapore
Trade Classification.Specify quantity and unit according to invoice
if the measurement unit in Singapore Trade Classification = ‘-’
(value).');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B058
cbc:Total Dutiable Quantity
unit Code (attribute)
C
M
1 n..16
1 an..3
For goods to be bonded into or released from licensed premises such
as Licensed Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse: specify Total dutiable quantity/weight/volume
i) for products based on specific rates, specify either weight or
volume according to duty rate unit specifier
ii) for others, specify dutiable quantity according to unit price
measurement.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B058
cbc:Dutiable Quantity
unit Code (attribute)
C
M
1 n..16
1 an..3
For dutiable cargo based on specific rates in accordance with duty
rate unit specifier:
i) Dutiable quantity/weight/volume.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', '(3) Item code (to be declared for IEF exemption quota)
B058 cbc:CASCProduct Quantity C 1 n..16 Specify quantity and measurement unit of CA/SC product code.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'unit Code (attribute) M 1 an..3 Specify unit (refer to UN/ECE Recommendation No.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify item unit price value (amount).');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B004
cbc:Amount
currency ID (attribute)
M
M
1 n..16
1 a3
Specify optional item charges amount.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', '(3) Item code (to be declared for IEF exemption quota)
B058
cbc:CASCProduct Quantity
unit Code (attribute)
C
M
1 n..16
1 an..3
Specify quantity and measurement unit of CA/SC product code.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'unit Code (attribute) M 1 an..3 For Packing unit type (refer to STDID Code Lists).');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B064 cbc:Item Invoice Number C 1 an..35 Mandatory to specify Invoice number except for
i) Used motor vehicle already registered in Singapore under duty
exemption.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'A035 cac:Motor Vehicle C 1 Note:
Mandatory for vehicle products, except for Place of Receipt =
SPNOSTK, SPSTK.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'unit Code (attribute) M 1 an..2 Specify engine capacity (in cubic capacity – cc) or power unit (in
kilo watt - k W).');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
B051
cbc:Outer Pack Quantity
unit Code (attribute)
C
M
1 n..8
1 an..3
Specify outer-pack quantity.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B051
cbc:In Pack Quantity
unit Code (attribute)
C
M
1 n..8
1 an..3
Specify in-pack quantity.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B051
cbc:Inner Pack Quantity
unit Code (attribute)
C
M
1 n..8
1 an..3
Specify inner-pack quantity.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B051
cbc:Inmost Pack Quantity
unit Code (attribute)
C
M
1 n..8
1 an..3
Specify inmost-pack quantity.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B064
cbc:Item Invoice Number
C
1 an..35
Mandatory to specify Invoice number except for
i) Used motor vehicle already registered in Singapore under duty
exemption.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'A035
cac:Motor Vehicle
C
1
Note:
Mandatory for vehicle products, except for Place of Receipt =
SPNOSTK, SPSTK.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B026
cbc:Engine Capacity
unit Code (attribute)
C
M
1 n..7
1 an..2
Specify engine capacity/power for dutiable motor vehicles (refer to
Note).');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B092
cbc:Total Outer Pack
unit Code (attribute)
M
M
1 n..8
1 an..3
Specify Total Outer Pack.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'B091
cbc:Total Gross Weight
M
1 n..15
Specify Total Gross Weight
OFFICIAL (CLOSED)
AM
unit Code (attribute) M 1 an..3 Specify unit (refer to weight measurement code in STDID Code List).');
INSERT INTO exceptions (section_code, exception_text) VALUES ('7', 'TDS41-MDS-XML-IPTDEC-M
Trade Net Declaration.IPTDEC Ver2.1.doc
OFFICIAL (CLOSED)
unit Code (attribute)
M
1 an..3
Specify unit (refer to weight measurement code in STDID Code List).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('7', 1, 'Evaluate condition: 7: Pipeline
B082 cbc:Mode Code M 1 n1 Specify Inward Transport Mode.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('7', 2, 'Evaluate condition: B076 cbc:Conveyance Reference Number C 1 an..17 For transport mode = 1, specify inward voyage number.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('7', 3, 'Evaluate condition: Specify ‘NA’
if there is no inward voyage number.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('7', 4, 'ipt:Transport
C
1
Notes:
For all Declaration Types, specify for inward transport, except for
the following:
(i)
Goods released from licensed premises such as Licensed
Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse
(ii)
short payment where place of receipt = SPSTK, SPNOSTK
(iii)
declaration type = BKT (Blanket)
(iv)
recovery payment where place of receipt = RCNOSTK
(v)
payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('7', 5, '/cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Inward Carrier Agent Party C 1 a) Specify Inward Carrier Agent, must be registered with Customs.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('7', 6, '/cac:Party Name
/cac:Freight Forwarder Party
A040
cac:Inward Carrier Agent Party
C
1
a) Specify Inward Carrier Agent, must be registered with Customs.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('7', 7, 'B064 cbc:Invoice Number C 1 an..35 Mandatory to specify invoice number and invoice date for all cases
except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('7', 8, 'B064
cbc:Invoice Number
C
1 an..35
Mandatory to specify invoice number and invoice date for all cases
except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('7', 9, 'place of release = EM, EXEMPT)
(v) supplementary declaration for schemes under AISS, IGDS such
OFFICIAL (CLOSED)
AM
as place of receipt = AISSLOC, SPIGDS
B020 cbc:Invoice Date C 1 n8 Format: CCYYMMDD
A043 cac:Supplier Manufacturer Party C 1 a) Specify the supplier/ manufacturer name except for the following:
(i) short payment where place of receipt = SPSTK, SPNOSTK, SPIGDS
(ii) declaration type = BKT (Blanket)
(iii) recovery payment where place of receipt = RCNOSTK
(iv) payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('7', 10, 'Run validation: a) For Declaration Type = GST and BKT, specify party type:
- (Declarant)
- (Claimant, if required)
- (Declaring Agent, if declared by Agent)
- (Inward Carrier Agent; optional)
- (Importer)
- (Freight Forwarder; mandatory for consol consignment)
b) For others, specify Party Type:
- (Declarant)
- (Declaring Agent, if declared by Agent)
- (Inward Carrier Agent; optional for transport mode = 2, 3, 5 or
7)
- (Importer)
- (Freight Forwarder; mandatory for consol consignment)
A014 cac:Declarant Party M 1 Specify the identity of the Declarant.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('7', 11, 'Run validation: a) For Declaration Type = GST and BKT, specify party type:
- (Declarant)
- (Claimant, if required)
- (Declaring Agent, if declared by Agent)
- (Inward Carrier Agent; optional)
- (Importer)
- (Freight Forwarder; mandatory for consol consignment)
b) For others, specify Party Type:
- (Declarant)
- (Declaring Agent, if declared by Agent)
- (Inward Carrier Agent; optional for transport mode = 2, 3, 5 or
7)
- (Importer)
- (Freight Forwarder; mandatory for consol consignment)
A014
cac:Declarant Party
M
1
Specify the identity of the Declarant.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('7', 12, 'Run validation: /cac:Party Name
/cac:Freight Forwarder Party
A040 cac:Inward Carrier Agent Party C 1 a) Specify Inward Carrier Agent, must be registered with Customs.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('7', 13, 'Handle exception: ipt:Transport
C
1
Notes:
For all Declaration Types, specify for inward transport, except for
the following:
(i)
Goods released from licensed premises such as Licensed
Warehouse, Excise Factory, Zero-GST Warehouse, Bonded
Warehouse
(ii)
short payment where place of receipt = SPSTK, SPNOSTK
(iii)
declaration type = BKT (Blanket)
(iv)
recovery payment where place of receipt = RCNOSTK
(v)
payment for goods previously exempted from duties/taxes (e.g.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'cbc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'For');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Net');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'doc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'XML');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Ver');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'cac');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'all');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'its');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'ipt');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'iii');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'BKT');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'are');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'any');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'Air');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'GST');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'not');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'keywords', 'PDF');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'tags', '7');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'tags', 'Pipeline');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('7', 'tags', 'dgft');
INSERT INTO glossary (term, definition) VALUES ('A001', 'Referenced in context: A001 cac:Additional CASCIdentification C 50 Repeat at most 50 times.');
INSERT INTO glossary (term, definition) VALUES ('A008', 'Referenced in context: /cac:Optional Item Charge
/cac:Transaction Value
A008 cac:CASCProduct C 5 Repeat at most 5 times, specify CA/SC product details.');
INSERT INTO glossary (term, definition) VALUES ('A010', 'Referenced in context: /cac:Total Invoice Value
A010 cac:Freight Charge C 1 Specify
a) freight charges to derive at CNF value.');
INSERT INTO glossary (term, definition) VALUES ('A011', 'Referenced in context: /cac:Party Name
/cac:Importer Party
A011 cac:Claimant Party C 1 Specify Claimant information for Declaration Type = GST and BKT
only.');
INSERT INTO glossary (term, definition) VALUES ('A014', 'Referenced in context: a) For Declaration Type = GST and BKT, specify party type:
- (Declarant)
- (Claimant, if required)
- (Declaring Agent, if declared by Agent)');
INSERT INTO glossary (term, definition) VALUES ('A016', 'Referenced in context: /cac:Goods And Services Tax
A016 cac:Excise Duty C 1 For dutiable goods subject to Excise Duty:
B024 cbc:Duty Rate M 1 n..8 Specify item Exc');
INSERT INTO glossary (term, definition) VALUES ('A022', 'Referenced in context: A022 cac:Total Invoice Value C 1 Specify Total Invoice value (excluding other charges listed
separately).');
INSERT INTO glossary (term, definition) VALUES ('A023', 'Referenced in context: A023 cac:Goods And Services Tax C 1 Specify the item GST:
a) For Declaration Type = GST, the declared item GST payable amount
must be equal');
INSERT INTO glossary (term, definition) VALUES ('A026', 'Referenced in context: place of release = EM, EXEMPT)
(vi) Supplementary declaration for schemes under AISS, IGDS such as
Place of Receipt = AISSLOC, SPIGDS
A026 c');
INSERT INTO glossary (term, definition) VALUES ('A030', 'Referenced in context: A030 cac:Item Quantity M 1 Specify the following for both dutiable and non-dutiable cargo.');
INSERT INTO glossary (term, definition) VALUES ('A032', 'Referenced in context: A032 cac:Release Location M 1 Specify Place of Release.');
INSERT INTO glossary (term, definition) VALUES ('A033', 'Referenced in context: /cac:Shipping Marks Information
A033 cac:Lot Identification C 1 For goods received into or released from Licensed Premises such as
Licensed');
INSERT INTO glossary (term, definition) VALUES ('A035', 'Referenced in context: A035 cac:Motor Vehicle C 1 Note:
Mandatory for vehicle products, except for Place of Receipt =
SPNOSTK, SPSTK.');
INSERT INTO glossary (term, definition) VALUES ('A037', 'Referenced in context: A037 cac:Packing Description C 1 Specify packing description for liquor/tobacco products; optional
for others.');
INSERT INTO glossary (term, definition) VALUES ('A038', 'Referenced in context: A038 cac:Party Identification M 1 Specify Declaring Agent Party Identification.');
INSERT INTO glossary (term, definition) VALUES ('A039', 'Referenced in context: /cac:Party Identification
A039 cac:Party Name M 1 Specify Declaring Agent Party Name.');
INSERT INTO glossary (term, definition) VALUES ('A040', 'Referenced in context: /cac:Declarant Party
A040 cac:Declaring Agent Party C 1 Specify Declaring Agent.');
INSERT INTO glossary (term, definition) VALUES ('A043', 'Referenced in context: A043 cac:Person Information M 1 Specify Declarant Person Information.');
INSERT INTO glossary (term, definition) VALUES ('A054', 'Referenced in context: /cac:Motor Vehicle
A054 cac:Tariff C 1 Specify duties and taxes amount
B056 cbc:Preferential Code C 1 an..3 Specify “PRF” if goods are impor');
INSERT INTO glossary (term, definition) VALUES ('A056', 'Referenced in context: A056 cac:Total Tariff C 1
B003 cbc:Total Goods And Services Tax Amount C 1 n..16 Specify Total GST amount payable based on the sum of GST am');
INSERT INTO glossary (term, definition) VALUES ('A057', 'Referenced in context: A057 cac:Transaction Value M 1 Specify item CIF/FOB, LSP, Unit price and optional item charge
amount.');
INSERT INTO glossary (term, definition) VALUES ('A058', 'Referenced in context: A058 cac:Transport Equipment Seal M 1 Specify the shipper seal number affixed to the container at the time
of arrival.');
INSERT INTO glossary (term, definition) VALUES ('A059', 'Referenced in context: /cac:Receipt Location
A059 cac:Transport Equipment C 99 Repeat at most 99 times for containers at point of clearance.');
INSERT INTO glossary (term, definition) VALUES ('A060', 'Referenced in context: A060 cac:Transport Means C 1 Specify inward transport mode.');
INSERT INTO glossary (term, definition) VALUES ('A062', 'Referenced in context: A062 cac:Unique Reference Number M 1 Format:
Declarant entity identifier = XXXXXXXXXXXXXXXXX
Date of Creation = CCYYMMDD
Sequence Numeric =');
INSERT INTO glossary (term, definition) VALUES ('A066', 'Referenced in context: A066 cac:Remarks C 1 Provide additional details such as the source of the exchange rate
obtained eg.');
INSERT INTO glossary (term, definition) VALUES ('A068', 'Referenced in context: A068 cac:Customs Procedure Code Information C 5 Repeat at most 5 times.');
INSERT INTO glossary (term, definition) VALUES ('A069', 'Referenced in context: A069 cac:CPCProcessing Code C 5 Repeat at most 5 times each for Processing code 1, 2 and 3.');
INSERT INTO glossary (term, definition) VALUES ('AD', 'Referenced in context: Transfer conditions are:
Code Declaration Type
Transfer Conditions
DUT
Duty
To allow the Declarant to submit Declarations such as anti-dumpi');
INSERT INTO glossary (term, definition) VALUES ('AISS', 'Referenced in context: place of release = EM, EXEMPT)
(vi) Supplementary declaration for schemes under AISS, IGDS such as
Place of Receipt = AISSLOC, SPIGDS
A026 c');
INSERT INTO glossary (term, definition) VALUES ('AISSLOC', 'Referenced in context: place of release = EM, EXEMPT)
(vi) Supplementary declaration for schemes under AISS, IGDS such as
Place of Receipt = AISSLOC, SPIGDS
A026 c');
INSERT INTO glossary (term, definition) VALUES ('ALPS', 'Referenced in context: Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumpi');
INSERT INTO glossary (term, definition) VALUES ('AM', 'Referenced in context: Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (C');
INSERT INTO glossary (term, definition) VALUES ('AND', 'Referenced in section title ''DEFINITIONS AND ABBREVIATIONS''.');
INSERT INTO glossary (term, definition) VALUES ('B003', 'Referenced in context: B003 cbc:Item CIFFOBValue M 1 n..16 Mandatory for all Declaration Types to specify item CIF/FOB value in
SGD.');
INSERT INTO glossary (term, definition) VALUES ('B004', 'Referenced in context: B004 cbc:Amount M 1 n..16 Specify total invoice value.');
INSERT INTO glossary (term, definition) VALUES ('B007', 'Referenced in context: B007 cbc:Banker Guarantee Code C 1 an..3 Specify BG indicator (if any).');
INSERT INTO glossary (term, definition) VALUES ('B009', 'Referenced in context: /cac:CPCProcessing Code
/cac:Customs Procedure Code Information
ipt:Cargo M 1
B009 cbc:Cargo Packing Type M 1 an..3 Specify Cargo Packing Ty');
INSERT INTO glossary (term, definition) VALUES ('B012', 'Referenced in context: B012 cbc:Code Value M 1 an..17 Specify Declarant Code.');
INSERT INTO glossary (term, definition) VALUES ('B016', 'Referenced in context: /cac:Item Quantity
B016 cbc:Origin Country M 1 a2 Specify Country of Origin of goods.');
INSERT INTO glossary (term, definition) VALUES ('B020', 'Referenced in context: B020 cbc:Date M 1 n8 Specify date of Creation.');
INSERT INTO glossary (term, definition) VALUES ('B021', 'Referenced in context: B083 cbc:Common Access Reference M 1 an..7 IPTDEC
B021 cbc:Declaration Type M 1 an..7 Specify Declaration Type eg.');
INSERT INTO glossary (term, definition) VALUES ('B022', 'Referenced in context: B022 cbc:Model Description C 1 an..35 Specify model description (if any).');
INSERT INTO glossary (term, definition) VALUES ('B023', 'Referenced in context: Only the following file formats are allowed:
1) MS Word
2) Adobe PDF
3) MS Excel
4) Image Files
a) Bitmap
b) JPEG
c) GIF Image
d) EMF Image');
INSERT INTO glossary (term, definition) VALUES ('B024', 'Referenced in context: /cac:Goods And Services Tax
A016 cac:Excise Duty C 1 For dutiable goods subject to Excise Duty:
B024 cbc:Duty Rate M 1 n..8 Specify item Exc');
INSERT INTO glossary (term, definition) VALUES ('B025', 'Referenced in context: B025 cbc:Duty Rate Unit M 1 an..3 Specify the unit which the excise duty rate applies to.');
INSERT INTO glossary (term, definition) VALUES ('B026', 'Referenced in context: B026 cbc:Engine Capacity C 1 n..7 Specify engine capacity/power for dutiable motor vehicles (refer to
Note).');
INSERT INTO glossary (term, definition) VALUES ('B027', 'Referenced in context: B027 cbc:Equipment ID M 1 an..13 Specify container number.');
INSERT INTO glossary (term, definition) VALUES ('B028', 'Referenced in context: B069 cbc:Size Type Code M 1 an5 Specify container type and size using the following valid codes:
FCL20
FCL40
FCL45
LCL20
LCL40
LCL45
where:');
INSERT INTO glossary (term, definition) VALUES ('B031', 'Referenced in context: 9)
B031 cbc:Exchange Rate C 1 n..11 Specify rate of exchange if currency code is not in SGD.');
INSERT INTO glossary (term, definition) VALUES ('B033', 'Referenced in context: B033 cbc:Filename M 1 an..70 Specify Filename of the document.');
INSERT INTO glossary (term, definition) VALUES ('B034', 'Referenced in context: B034 cbc:Free Text M 2 an..512 Specify general/trader’s remarks.');
INSERT INTO glossary (term, definition) VALUES ('B035', 'Referenced in context: B035 cbc:Item Harmonized System Code M 1 an..10 Specify Item Harmonized System code.');
INSERT INTO glossary (term, definition) VALUES ('B036', 'Referenced in context: A062 cac:Unique Reference Number M 1 Format:
Declarant entity identifier = XXXXXXXXXXXXXXXXX
Date of Creation = CCYYMMDD
Sequence Numeric =');
INSERT INTO glossary (term, definition) VALUES ('B037', 'Referenced in context: DUT = Duty
GST = GST (including duty exemption)
DNG = Duty and GST
BKT = Blanket (including blanket GST payment and duty exemption)
B037 cbc');
INSERT INTO glossary (term, definition) VALUES ('B039', 'Referenced in context: B039 cbc:Location Code M 1 an..7 Specify location code (refer to STDID Code Lists).');
INSERT INTO glossary (term, definition) VALUES ('B040', 'Referenced in context: B040 cbc:Location Name C 1 an..256 Specify name and/address of location if the location code = SY
(shipyard) or SC (sailing club) or O (othe');
INSERT INTO glossary (term, definition) VALUES ('B041', 'Referenced in context: B041 cbc:Current Lot Number C 1 an..30 Specify current lot number, if applicable.');
INSERT INTO glossary (term, definition) VALUES ('B043', 'Referenced in context: B043 cbc:Marking C 1 an..2 Specify marking for the goods, if applicable, such as “HW” Health
Warning for tobacco products.');
INSERT INTO glossary (term, definition) VALUES ('B045', 'Referenced in context: MESSAGE DETAILS
User defined
Ref Tag name S R Repr Remarks
HEADER SECTION
ipt:Header M 1
B045 cbc:Message Reference M 1 an..14 Sender unique');
INSERT INTO glossary (term, definition) VALUES ('B049', 'Referenced in context: B049 cbc:Transport Identifier C 1 an..35 For transport mode = 1, specify inward vessel name.');
INSERT INTO glossary (term, definition) VALUES ('B051', 'Referenced in context: Repeat at most 4 times and specify:
1st time: outer-pack quantity
2nd time: in-pack quantity
3rd time: inner-pack quantity
4th time: inmost-');
INSERT INTO glossary (term, definition) VALUES ('B052', 'Referenced in context: B052 cbc:Charge Percent C 1 n..7 Specify percentage of freight charge, if any.');
INSERT INTO glossary (term, definition) VALUES ('B055', 'Referenced in context: B055 cbc:Loading Port C 1 an..5 For inward transport, Specify Place/Port of Loading.');
INSERT INTO glossary (term, definition) VALUES ('B056', 'Referenced in context: /cac:Motor Vehicle
A054 cac:Tariff C 1 Specify duties and taxes amount
B056 cbc:Preferential Code C 1 an..3 Specify “PRF” if goods are impor');
INSERT INTO glossary (term, definition) VALUES ('B057', 'Referenced in context: B057 cbc:Processing Code One M 1 an..35 Specify processing code 1.');
INSERT INTO glossary (term, definition) VALUES ('B058', 'Referenced in context: B058 cbc:Harmonized System Quantity M 1 n..16 For all Declaration Types, specify HS code quantity and the measure
unit specifier must match');
INSERT INTO glossary (term, definition) VALUES ('B060', 'Referenced in context: b) For other Declaration Types, the declared item GST payable
amount must equal to (CIF/LSP + Customs Duty + Excise Duty +
Other tax) X GST');
INSERT INTO glossary (term, definition) VALUES ('B064', 'Referenced in context: B064 cbc:Previous Permit Number C 1 an..35 Specify previous Permit Number if applicable.');
INSERT INTO glossary (term, definition) VALUES ('B065', 'Referenced in context: /cac:Unique Reference Number
B065 cbc:Declarant ID M 1 an..17 Mandatory to specify Message Sender Id (must be same as the Sender
Id as speci');
INSERT INTO glossary (term, definition) VALUES ('B067', 'Referenced in context: B067 cbc:Seal ID M 1 an..35 Specify shipper seal number.');
INSERT INTO glossary (term, definition) VALUES ('B068', 'Referenced in context: B068 cbc:Sequence Numeric M 1 n..');
INSERT INTO glossary (term, definition) VALUES ('B069', 'Referenced in context: B069 cbc:Size Type Code M 1 an5 Specify container type and size using the following valid codes:
FCL20
FCL40
FCL45
LCL20
LCL40
LCL45
where:');
INSERT INTO glossary (term, definition) VALUES ('B070', 'Referenced in context: /cac:Packing Description
B070 cac:Shipping Marks Information C 4 Specify markings on cargo for marks and numbers, if any.');
INSERT INTO glossary (term, definition) VALUES ('B071', 'Referenced in context: /cac:Person Information
B071 cbc:Telephone M 1 an..25 Mandatory to specify Declarant contact number.');
INSERT INTO glossary (term, definition) VALUES ('B072', 'Referenced in context: /cac:Supplier Manufacturer Party
B072 cbc:Unit Price Term Type C 1 a3 Specify Unit Price Term Type of the unit price (refer to STDID Code
Li');
INSERT INTO glossary (term, definition) VALUES ('B076', 'Referenced in context: B076 cbc:Conveyance Reference Number C 1 an..17 For transport mode = 1, specify inward voyage number.');
INSERT INTO glossary (term, definition) VALUES ('B082', 'Referenced in context: 7: Pipeline
B082 cbc:Mode Code M 1 n1 Specify Inward Transport Mode.');
INSERT INTO glossary (term, definition) VALUES ('B083', 'Referenced in context: B083 cbc:Common Access Reference M 1 an..7 IPTDEC
B021 cbc:Declaration Type M 1 an..7 Specify Declaration Type eg.');
INSERT INTO glossary (term, definition) VALUES ('B089', 'Referenced in context: B089 cbc:Customs Procedure Code M 1 an..7 Specify Customs Procedure Code (CPC).');
INSERT INTO glossary (term, definition) VALUES ('B091', 'Referenced in context: B091 cbc:Total Gross Weight M 1 n..15 Specify Total Gross Weight
Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)');
INSERT INTO glossary (term, definition) VALUES ('B092', 'Referenced in context: B092 cbc:Total Outer Pack M 1 n..8 Specify Total Outer Pack.');
INSERT INTO glossary (term, definition) VALUES ('B093', 'Referenced in context: B093 cbc:Name M 1 an..100 Specify Declarant name.');
INSERT INTO glossary (term, definition) VALUES ('BG', 'Referenced in context: B007 cbc:Banker Guarantee Code C 1 an..3 Specify BG indicator (if any).');
INSERT INTO glossary (term, definition) VALUES ('BKT', 'Referenced in context: Transfer conditions are:
Code Declaration Type
Transfer Conditions
DUT
Duty
To allow the Declarant to submit Declarations such as anti-dumpi');
INSERT INTO glossary (term, definition) VALUES ('BW', 'Referenced in context: Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumpi');
INSERT INTO glossary (term, definition) VALUES ('BWCY', 'Referenced in context: Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumpi');
INSERT INTO glossary (term, definition) VALUES ('CA', 'Referenced in context: 5.1 Abbreviations
CA Controlling Agency
Crimson Logic Crimson Logic Pte Ltd
XML Extensible Markup Language
FTZ Free Trade Zone
GST Goods and');
INSERT INTO glossary (term, definition) VALUES ('CCYYMMDD', 'Referenced in context: A062 cac:Unique Reference Number M 1 Format:
Declarant entity identifier = XXXXXXXXXXXXXXXXX
Date of Creation = CCYYMMDD
Sequence Numeric =');
INSERT INTO glossary (term, definition) VALUES ('CEFACT', 'Referenced in context: The segments, composite data elements, data elements and codes used in this document are based on the respective
directories in the UN/CEFAC');
INSERT INTO glossary (term, definition) VALUES ('CIF', 'Referenced in context: /cac:Freight Charge
A010 cac:Insurance Charge C 1 Specify
a) insurance charges to derive at CIF value, if any.');
INSERT INTO glossary (term, definition) VALUES ('CLOSED', 'Referenced in context: Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (C');
INSERT INTO glossary (term, definition) VALUES ('CNF', 'Referenced in context: /cac:Total Invoice Value
A010 cac:Freight Charge C 1 Specify
a) freight charges to derive at CNF value.');
INSERT INTO glossary (term, definition) VALUES ('COD', 'Referenced in context: 21, Codes CEFACT/ICG/2010/IC01 12 Jul 10
for Types of Cargo, Packages and Packaging Material 0/Rev.1
12 STDID Code Lists STDID-TDS41-COD
Tra');
INSERT INTO glossary (term, definition) VALUES ('CPC', 'Referenced in context: B089 cbc:Customs Procedure Code M 1 an..7 Specify Customs Procedure Code (CPC).');
INSERT INTO glossary (term, definition) VALUES ('DEFINITION', 'Referenced in section title ''MESSAGE DEFINITION''.');
INSERT INTO glossary (term, definition) VALUES ('DETAILS', 'Referenced in section title ''MESSAGE DETAILS''.');
INSERT INTO glossary (term, definition) VALUES ('DG', 'Referenced in context: B037 cbc:Dangerous Goods Indicator C Boolean Specify DG indicator for dangerous goods.');
INSERT INTO glossary (term, definition) VALUES ('DNG', 'Referenced in context: Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumpi');
INSERT INTO glossary (term, definition) VALUES ('DUT', 'Referenced in context: Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumpi');
INSERT INTO glossary (term, definition) VALUES ('ECE', 'Referenced in context: REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Net Declaration message specification TDS41-MDS-XML-
DECLARATION');
INSERT INTO glossary (term, definition) VALUES ('EM', 'Referenced in context: place of release = EM, EXEMPT)
(vi) Supplementary declaration for schemes under AISS, IGDS such as
Place of Receipt = AISSLOC, SPIGDS
A026 c');
INSERT INTO glossary (term, definition) VALUES ('EMF', 'Referenced in context: Only the following file formats are allowed:
1) MS Word
2) Adobe PDF
3) MS Excel
4) Image Files
a) Bitmap
b) JPEG
c) GIF Image
d) EMF Image');
INSERT INTO glossary (term, definition) VALUES ('EXEMPT', 'Referenced in context: place of release = EM, EXEMPT)
(vi) Supplementary declaration for schemes under AISS, IGDS such as
Place of Receipt = AISSLOC, SPIGDS
A026 c');
INSERT INTO glossary (term, definition) VALUES ('FCL', 'Referenced in context: B069 cbc:Size Type Code M 1 an5 Specify container type and size using the following valid codes:
FCL20
FCL40
FCL45
LCL20
LCL40
LCL45
where:');
INSERT INTO glossary (term, definition) VALUES ('FCL20', 'Referenced in context: B069 cbc:Size Type Code M 1 an5 Specify container type and size using the following valid codes:
FCL20
FCL40
FCL45
LCL20
LCL40
LCL45
where:');
INSERT INTO glossary (term, definition) VALUES ('FCL40', 'Referenced in context: B069 cbc:Size Type Code M 1 an5 Specify container type and size using the following valid codes:
FCL20
FCL40
FCL45
LCL20
LCL40
LCL45
where:');
INSERT INTO glossary (term, definition) VALUES ('FCL45', 'Referenced in context: B069 cbc:Size Type Code M 1 an5 Specify container type and size using the following valid codes:
FCL20
FCL40
FCL45
LCL20
LCL40
LCL45
where:');
INSERT INTO glossary (term, definition) VALUES ('FIELD', 'Referenced in section title ''FIELD OF APPLICATION''.');
INSERT INTO glossary (term, definition) VALUES ('FOB', 'Referenced in context: A057 cac:Transaction Value M 1 Specify item CIF/FOB, LSP, Unit price and optional item charge
amount.');
INSERT INTO glossary (term, definition) VALUES ('FTZ', 'Referenced in context: 5.1 Abbreviations
CA Controlling Agency
Crimson Logic Crimson Logic Pte Ltd
XML Extensible Markup Language
FTZ Free Trade Zone
GST Goods and');
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
INSERT INTO glossary (term, definition) VALUES ('GST', 'Referenced in context: 5.1 Abbreviations
CA Controlling Agency
Crimson Logic Crimson Logic Pte Ltd
XML Extensible Markup Language
FTZ Free Trade Zone
GST Goods and');
INSERT INTO glossary (term, definition) VALUES ('HAWB', 'Referenced in context: /cac:Lot Identification
B064 cbc:In HAWBHUCRHBLNumber C 1 an..35 Specify Inward HAWB/HUCR/HBL number for transport mode 1 or 4.');
INSERT INTO glossary (term, definition) VALUES ('HBL', 'Referenced in context: /cac:Lot Identification
B064 cbc:In HAWBHUCRHBLNumber C 1 an..35 Specify Inward HAWB/HUCR/HBL number for transport mode 1 or 4.');
INSERT INTO glossary (term, definition) VALUES ('HEADER', 'Referenced in context: MESSAGE DETAILS
User defined
Ref Tag name S R Repr Remarks
HEADER SECTION
ipt:Header M 1
B045 cbc:Message Reference M 1 an..14 Sender unique');
INSERT INTO glossary (term, definition) VALUES ('HS', 'Referenced in context: Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumpi');
INSERT INTO glossary (term, definition) VALUES ('HUCR', 'Referenced in context: /cac:Lot Identification
B064 cbc:In HAWBHUCRHBLNumber C 1 an..35 Specify Inward HAWB/HUCR/HBL number for transport mode 1 or 4.');
INSERT INTO glossary (term, definition) VALUES ('HW', 'Referenced in context: B043 cbc:Marking C 1 an..2 Specify marking for the goods, if applicable, such as “HW” Health
Warning for tobacco products.');
INSERT INTO glossary (term, definition) VALUES ('IC01', 'Referenced in context: 20, Codes CEFACT/ICG/2010/IC01 13 Sep 10
for Units of Measure Used in International Trade 3
9 Codes for Units of Measure Used in Internation');
INSERT INTO glossary (term, definition) VALUES ('ICDV', 'Referenced in context: B057 cbc:CASCProduct Code C 1 an..17 Specify CA/SC product code such as:
(1) Dutiable Motor Vehicle product code
(2) ICDV No.');
INSERT INTO glossary (term, definition) VALUES ('ICG', 'Referenced in context: 20, Codes CEFACT/ICG/2010/IC01 13 Sep 10
for Units of Measure Used in International Trade 3
9 Codes for Units of Measure Used in Internation');
INSERT INTO glossary (term, definition) VALUES ('ID', 'Referenced in context: A062 cac:Unique Reference Number M 1 Format:
Declarant entity identifier = XXXXXXXXXXXXXXXXX
Date of Creation = CCYYMMDD
Sequence Numeric =');
INSERT INTO glossary (term, definition) VALUES ('IEF', 'Referenced in context: (3) Item code (to be declared for IEF exemption quota)
B058 cbc:CASCProduct Quantity C 1 n..16 Specify quantity and measurement unit of CA/S');
INSERT INTO glossary (term, definition) VALUES ('IGDS', 'Referenced in context: place of release = EM, EXEMPT)
(vi) Supplementary declaration for schemes under AISS, IGDS such as
Place of Receipt = AISSLOC, SPIGDS
A026 c');
INSERT INTO glossary (term, definition) VALUES ('II', 'Referenced in context: 20, Codes CEFACT/ICG/2010/IC01 13 Sep 10
for Units of Measure Used in International Trade 3
9 Codes for Units of Measure Used in Internation');
INSERT INTO glossary (term, definition) VALUES ('III', 'Referenced in context: 20, Codes CEFACT/ICG/2010/IC01 13 Sep 10
for Units of Measure Used in International Trade 3
9 Codes for Units of Measure Used in Internation');
INSERT INTO glossary (term, definition) VALUES ('INVOICE', 'Referenced in context: /cac:Supporting Document Reference
INVOICE SECTION
cac:Invoice C 20 Repeat at most 20 times.');
INSERT INTO glossary (term, definition) VALUES ('IPTDEC', 'Referenced in context: Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (C');
INSERT INTO glossary (term, definition) VALUES ('ISO', 'Referenced in context: 3, Code for the ECE/TRADE/201 1 Jan 96
Representation of Names of Countries - ISO Country Code
5 UN/ECE WP Trade Facilitation Recommendation');
INSERT INTO glossary (term, definition) VALUES ('ITEM', 'Referenced in context: /cac:Other Taxable Charge
/cac:Invoice
ITEM SECTION
ipt:Item M 50 Repeat at most 50 times.');
INSERT INTO glossary (term, definition) VALUES ('JPEG', 'Referenced in context: Only the following file formats are allowed:
1) MS Word
2) Adobe PDF
3) MS Excel
4) Image Files
a) Bitmap
b) JPEG
c) GIF Image
d) EMF Image');
INSERT INTO glossary (term, definition) VALUES ('KGM', 'Referenced in context: ii) For transport mode = 4, the unit code must be set to KGM.');
INSERT INTO glossary (term, definition) VALUES ('LCL', 'Referenced in context: B069 cbc:Size Type Code M 1 an5 Specify container type and size using the following valid codes:
FCL20
FCL40
FCL45
LCL20
LCL40
LCL45
where:');
INSERT INTO glossary (term, definition) VALUES ('LCL20', 'Referenced in context: B069 cbc:Size Type Code M 1 an5 Specify container type and size using the following valid codes:
FCL20
FCL40
FCL45
LCL20
LCL40
LCL45
where:');
INSERT INTO glossary (term, definition) VALUES ('LCL40', 'Referenced in context: B069 cbc:Size Type Code M 1 an5 Specify container type and size using the following valid codes:
FCL20
FCL40
FCL45
LCL20
LCL40
LCL45
where:');
INSERT INTO glossary (term, definition) VALUES ('LCL45', 'Referenced in context: B069 cbc:Size Type Code M 1 an5 Specify container type and size using the following valid codes:
FCL20
FCL40
FCL45
LCL20
LCL40
LCL45
where:');
INSERT INTO glossary (term, definition) VALUES ('LOCODE', 'Referenced in context: 16, ECE/TRADE/227 Dec 98
UN/LOCODE - Code for the Trade and Transport Locations
7 UN/ECE WP Trade Facilitation Recommendation No.');
INSERT INTO glossary (term, definition) VALUES ('LSP', 'Referenced in context: A057 cac:Transaction Value M 1 Specify item CIF/FOB, LSP, Unit price and optional item charge
amount.');
INSERT INTO glossary (term, definition) VALUES ('LW', 'Referenced in context: Transfer conditions are:
Code Declaration Type
Transfer Conditions
DUT
Duty
To allow the Declarant to submit Declarations such as anti-dumpi');
INSERT INTO glossary (term, definition) VALUES ('MDS', 'Referenced in context: Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (C');
INSERT INTO glossary (term, definition) VALUES ('MESSAGE', 'Referenced in context: Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
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
INSERT INTO glossary (term, definition) VALUES ('MV', 'Referenced in context: for motor vehicles when MV product code is
filled.');
INSERT INTO glossary (term, definition) VALUES ('NA', 'Referenced in context: Specify ‘NA’
if there is no inward voyage number.');
INSERT INTO glossary (term, definition) VALUES ('NVOCC', 'Referenced in context: /cac:Party Name
/cac:Declaring Agent Party
A040 cac:Freight Forwarder Party C 1 Mandatory to specify Freight Forwarder/NVOCC/Cargo
Agent/Con');
INSERT INTO glossary (term, definition) VALUES ('OF', 'Referenced in section title ''FIELD OF APPLICATION''.');
INSERT INTO glossary (term, definition) VALUES ('OFFICIAL', 'Referenced in context: Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (C');
INSERT INTO glossary (term, definition) VALUES ('OUCR', 'Referenced in context: /cac:Transport Mode
B064 cbc:MAWBOUCROBLNumber C 1 an..35 For transport mode = 1, to specify inward OUCR/ Ocean Bill of Lading
Number.');
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
INSERT INTO glossary (term, definition) VALUES ('PRF', 'Referenced in context: /cac:Motor Vehicle
A054 cac:Tariff C 1 Specify duties and taxes amount
B056 cbc:Preferential Code C 1 an..3 Specify “PRF” if goods are impor');
INSERT INTO glossary (term, definition) VALUES ('RCNOSTK', 'Referenced in context: ipt:Transport C 1 Notes:
For all Declaration Types, specify for inward transport, except for
the following:
(i) Goods released from licensed');
INSERT INTO glossary (term, definition) VALUES ('REFERENCES', 'Referenced in section title ''REFERENCES''.');
INSERT INTO glossary (term, definition) VALUES ('RESPONSE', 'Referenced in context: REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Net Declaration message specification TDS41-MDS-XML-
DECLARATION');
INSERT INTO glossary (term, definition) VALUES ('SAF', 'Referenced in context: Transfer conditions are:
Code Declaration Type Transfer Conditions
DUT Duty To allow the Declarant to submit Declarations such as anti-dumpi');
INSERT INTO glossary (term, definition) VALUES ('SC', 'Referenced in context: This document shall be used as a baseline for the interface software design and shall be agreed upon by representatives
from the Singapore C');
INSERT INTO glossary (term, definition) VALUES ('SCOPE', 'Referenced in section title ''SCOPE''.');
INSERT INTO glossary (term, definition) VALUES ('SECTION', 'Referenced in context: MESSAGE DETAILS
User defined
Ref Tag name S R Repr Remarks
HEADER SECTION
ipt:Header M 1
B045 cbc:Message Reference M 1 an..14 Sender unique');
INSERT INTO glossary (term, definition) VALUES ('SGD', 'Referenced in context: 9)
B031 cbc:Exchange Rate C 1 n..11 Specify rate of exchange if currency code is not in SGD.');
INSERT INTO glossary (term, definition) VALUES ('SITDED', 'Referenced in context: For other uses (refer to Appendix A of SITDED data dictionary).');
INSERT INTO glossary (term, definition) VALUES ('SPIGDS', 'Referenced in context: place of release = EM, EXEMPT)
(vi) Supplementary declaration for schemes under AISS, IGDS such as
Place of Receipt = AISSLOC, SPIGDS
A026 c');
INSERT INTO glossary (term, definition) VALUES ('SPNOSTK', 'Referenced in context: ipt:Transport C 1 Notes:
For all Declaration Types, specify for inward transport, except for
the following:
(i) Goods released from licensed');
INSERT INTO glossary (term, definition) VALUES ('SPSTK', 'Referenced in context: ipt:Transport C 1 Notes:
For all Declaration Types, specify for inward transport, except for
the following:
(i) Goods released from licensed');
INSERT INTO glossary (term, definition) VALUES ('STDID', 'Referenced in context: 21, Codes CEFACT/ICG/2010/IC01 12 Jul 10
for Types of Cargo, Packages and Packaging Material 0/Rev.1
12 STDID Code Lists STDID-TDS41-COD
Tra');
INSERT INTO glossary (term, definition) VALUES ('SUMMARY', 'Referenced in context: /cac:Other Tax
/cac:Tariff
SUMMARY SECTION
ipt:Summary M 1
B068 cbc:Number Of Items M 1 n..5 Specify total number of items declared.');
INSERT INTO glossary (term, definition) VALUES ('SY', 'Referenced in context: B040 cbc:Location Name C 1 an..256 Specify name and/address of location if the location code = SY
(shipyard) or SC (sailing club) or O (othe');
INSERT INTO glossary (term, definition) VALUES ('TDS41', 'Referenced in context: Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
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
INSERT INTO glossary (term, definition) VALUES ('TNE', 'Referenced in context: 3 Specify container weight (TNE).');
INSERT INTO glossary (term, definition) VALUES ('TRADE', 'Referenced in context: 3, Code for the ECE/TRADE/201 1 Jan 96
Representation of Names of Countries - ISO Country Code
5 UN/ECE WP Trade Facilitation Recommendation');
INSERT INTO glossary (term, definition) VALUES ('TRADENET', 'Referenced in context: Trade Net Declaration.IPTDEC Ver2.1.doc Message Specification XML (IPTDEC)
OFFICIAL (CLOSED)
Prepared by:
TDS41-MDS-XML-IPTDEC-M
OFFICIAL (C');
INSERT INTO glossary (term, definition) VALUES ('TRANSPORT', 'B020
cbc:Arrival Date
M
1 n8
Format: CCYYMMDD
For inward transport, specify Date of Arrival');
INSERT INTO glossary (term, definition) VALUES ('TX', 'Referenced in context: REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Net Declaration message specification TDS41-MDS-XML-
DECLARATION');
INSERT INTO glossary (term, definition) VALUES ('UN', 'Referenced in context: The segments, composite data elements, data elements and codes used in this document are based on the respective
directories in the UN/CEFAC');
INSERT INTO glossary (term, definition) VALUES ('WP', 'Referenced in context: REFERENCES
S/ Document Name Document/Directory Rev Date
N Reference
1 Trade Net Declaration message specification TDS41-MDS-XML-
DECLARATION');
INSERT INTO glossary (term, definition) VALUES ('XML', 'Referenced in context: INTRODUCTION
This specification provides the definition of the Customs Declaration message to be used in Extensible Markup Language
(XML) be');