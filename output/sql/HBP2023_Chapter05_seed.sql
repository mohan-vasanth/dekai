INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.01', 'Policy', '5.01 Policy
Policy relating to EPCG Scheme is given in Chapter 5 of FTP', 'Indha Policy section-la, 5.01 Policy
Policy relating to EPCG Scheme is given in Chapter 5 of FTP', '5.01 Policy
Policy relating to EPCG Scheme is given in Chapter 5 of FTP', '5.01 Policy
Policy relating to EPCG Scheme is given in Chapter 5 of FTP', '5.01 Policy
Policy relating to EPCG Scheme is given in Chapter 5 of FTP', 'Indha Policy section-la, 5.01 Policy
Policy relating to EPCG Scheme is given in Chapter 5 of FTP', '5.01 Policy
Policy relating to EPCG Scheme is given in Chapter 5 of FTP', '[2]', '["FTP", "EPCG", "given", "Policy", "Scheme", "Chapter", "relating"]', 'Provide knowledge guidance for Policy.', '["5.01", "Policy", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_01-R001', '5.01', '5.01 Policy
Policy relating to EPCG Scheme is given in Chapter 5 of FTP', 'business_rule', 'Policy', 'Not explicitly covered in uploaded documents.', 'Not explicitly covered in uploaded documents.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.01 - Policy.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.01', 1, 'Review section 5.01 requirements');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.01', 2, 'Capture applicant inputs');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.01', 3, 'Route for authority decision');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.01', 'keywords', 'FTP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.01', 'keywords', 'EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.01', 'keywords', 'given');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.01', 'keywords', 'Policy');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.01', 'keywords', 'Scheme');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.01', 'keywords', 'Chapter');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.01', 'keywords', 'relating');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.01', 'tags', '5.01');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.01', 'tags', 'Policy');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.01', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.02', 'Application Form', '5.02 Application Form
An application for grant of an authorisation may be made by Registered Office or
Head Office or a Branch Office or Manufacturing Unit of an eligible exporter to RA
concerned in ANF 5A along with documents prescribed therein.', 'Indha Application Form section-la, 5.02 application Form
An application for grant of an authorisation may be made by Registered Office or
Head Office or a Branch Office or Manufacturing Unit of an eligible exporter to RA
concerned in ANF 5A along with documents prescribed therein.', '5.02 Application Form
An application for grant of an authorisation may be made by Registered Office or
Head Office or a Branch Office or Manufacturing Unit of an eligible exporter to RA
concerned in ANF 5A along with documents prescribed therein.', 'Application Form governs how DGFT business controls should be applied, validated, and enforced.', 'Application Form explains the operating rule set that DEKAI should enforce. Key control points include 5.02 Application Form
An application for grant of an authorisation may be made by Registered Office or
Head Office or a Branch Office or Manufacturing Unit of an eligible exporter to RA
concerned in ANF 5A along with documents prescribed therein. The section also drives actions such as 5.02 Application Form
An application for grant of an authorisation may be made by Registered Office or
Head Office or a Branch Office or Manufacturing Unit of an eligible exporter to RA
concerned in ANF 5A along with documents prescribed therein..', 'Indha Application Form section-la, application Form explains the operating rule set that DEKAI should enforce. Key control points include 5.02 application Form
An application for grant of an authorisation may be made by Registered Office or
Head Office or a Branch Office or Manufacturing Unit of an eligible exporter to RA
concerned in ANF 5A along with documents prescribed therein. The section also drives actions such as 5.02 application Form
An application for grant of an authorisation may be made by Registered Office or
Head Office or a Branch Office or Manufacturing Unit of an eligible exporter to RA
concerned in ANF 5A along with documents prescribed therein..', '5.02 Application Form
An application for grant of an authorisation may be made by Registered Office or
Head Office or a Branch Office or Manufacturing Unit of an eligible exporter to RA
concerned in ANF 5A along with documents prescribed therein.', '[2]', '["for", "may", "ANF", "Form", "made", "Head", "Unit", "with", "grant", "along", "Office", "Branch", "therein", "eligible", "exporter", "concerned", "documents", "Registered", "prescribed", "Application"]', 'Support Application Form processing and compliance validation.', '["5.02", "Application Form", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_02-R001', '5.02', '5.02 Application Form
An application for grant of an authorisation may be made by Registered Office or
Head Office or a Branch Office or Manufacturing Unit of an eligible exporter to RA
concerned in ANF 5A along with documents prescribed therein.', 'business_rule', 'Application Form', 'Section 5.02 is applicable', '5.02 Application Form
An application for grant of an authorisation may be made by Registered Office or
Head Office or a Branch Office or Manufacturing Unit of an eligible exporter to RA
concerned in ANF 5A along with documents prescribed therein.', '5.02 Application Form
An application for grant of an authorisation may be made by Registered Office or
Head Office or a Branch Office or Manufacturing Unit of an eligible exporter to RA
concerned in ANF 5A along with documents prescribed therein.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.02 - Application Form.');
INSERT INTO documents (section_code, document_name) VALUES ('5.02', '5.02 Application Form
An application for grant of an authorisation may be made by Registered Office or
Head Office or a Branch Office or Manufacturing Unit of an eligible exporter to RA
concerned in ANF 5A along with documents prescribed therein.');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.02', 'RA');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.02', 'Head Office or a Branch Office or Manufacturing Unit of an eligible exporter to RA');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.02', 1, '5.02 Application Form
An application for grant of an authorisation may be made by Registered Office or
Head Office or a Branch Office or Manufacturing Unit of an eligible exporter to RA
concerned in ANF 5A along with documents prescribed therein.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.02', 2, 'Run validation: 5.02 Application Form
An application for grant of an authorisation may be made by Registered Office or
Head Office or a Branch Office or Manufacturing Unit of an eligible exporter to RA
concerned in ANF 5A along with documents prescribed therein.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'may');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'ANF');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'Form');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'made');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'Head');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'Unit');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'with');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'grant');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'along');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'Office');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'Branch');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'therein');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'eligible');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'exporter');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'concerned');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'documents');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'Registered');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'prescribed');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'keywords', 'Application');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'tags', '5.02');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'tags', 'Application Form');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.02', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.03', 'Nexus Certification', '5.03 Nexus Certification
(a) RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation.', 'Indha Nexus Certification section-la, 5.03 Nexus Certification
(a) RA concerned kandippa, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation.', '5.03 Nexus Certification
(a) RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation. For issuance of such certificate, the Chartered Engineer
shall act only in the domain of his/her competence. In case of fabrication,
reasonable wastage, if any, anticipated at the time of installation of capital
goods shall be certified by the Chartered Engineer in the nexus certificate
and the same would be mentioned in the condition sheet of the EPCG
authorisation at the time of issue.', 'Nexus Certification governs how DGFT business controls should be applied, validated, and enforced.', 'Nexus Certification explains the operating rule set that DEKAI should enforce. Key control points include 5.03 Nexus Certification
(a) RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation. The section also drives actions such as 5.03 Nexus Certification
(a) RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation..', 'Indha Nexus Certification section-la, Nexus Certification explains the operating rule set that DEKAI should enforce. Key control points include 5.03 Nexus Certification
(a) RA concerned kandippa, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation. The section also drives actions such as 5.03 Nexus Certification
(a) RA concerned kandippa, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation..', '5.03 Nexus Certification
(a) RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation. For issuance of such certificate, the Chartered Engineer
shall act only in the domain of his/her competence. In case of fabrication,
reasonable wastage, if any, anticipated at the time of installation of capital
goods shall be certified by the Chartered Engineer in the nexus certificate
and the same would be mentioned in the condition sheet of the EPCG
authorisation at the time of issue. The wastage so permitted at the time of
issuance of authorisation would be allowed to be sold as scrap/waste on
payment of applicable duty by the authorisation holder.
(b) An application for amendment in the list of import item(s) including
addition(s)/deletion(s), if any, may be filed with RA concerned provided the
authorisation is valid for import. The applicant would give justification for
seeking such amendment(s) along with fresh nexus certificate from an
independent Chartered Engineer.
(c) An application for amendment in the list of export item(s) including
addition(s)/deletion(s) if any, may be filed with RA concerned provided the
Export Obligation period of the authorisation is valid and the CG has nexus
with export product. The applicant would give justification for seeking such
amendment(s) along with fresh nexus certificate from an independent
Chartered Engineer.
5.03 Nexus Certification
(a)
RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation. For issuance of such certificate, the Chartered Engineer
shall act only in the domain of his/her competence. In case of fabrication,
reasonable wastage, if any, anticipated at the time of installation of capital
goods shall be certified by the Chartered Engineer in the nexus certificate
and the same would be mentioned in the condition sheet of the EPCG
authorisation at the time of issue. The wastage so permitted at the time of
issuance of authorisation would be allowed to be sold as scrap/waste on
payment of applicable duty by the authorisation holder.
(b)
An application for amendment in the list of import item(s) including
addition(s)/deletion(s), if any, may be filed with RA concerned provided the
authorisation is valid for import. The applicant would give justification for
seeking such amendment(s) along with fresh nexus certificate from an
independent Chartered Engineer.
(c)
An application for amendment in the list of export item(s) including
addition(s)/deletion(s) if any, may be filed with RA concerned provided the
Export Obligation period of the authorisation is valid and the CG has nexus
with export product. The applicant would give justification for seeking such
amendment(s) along with fresh nexus certificate from an independent
Chartered Engineer.', '[2]', '["the", "CEC", "For", "act", "any", "and", "may", "has", "from", "EPCG", "such", "only", "case", "time", "same", "sold", "duty", "list", "item", "with"]', 'Support Nexus Certification processing and compliance validation.', '["5.03", "Nexus Certification", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_03-R001', '5.03', '5.03 Nexus Certification
(a) RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation.', 'business_rule', 'Nexus Certification', '5.03 Nexus Certification
(a) RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation.', '5.03 Nexus Certification
(a) RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation.', '5.03 Nexus Certification
(a) RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.03 - Nexus Certification.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_03-R002', '5.03', 'For issuance of such certificate, the Chartered Engineer
shall act only in the domain of his/her competence.', 'business_rule', 'Nexus Certification', 'For issuance of such certificate, the Chartered Engineer
shall act only in the domain of his/her competence.', 'For issuance of such certificate, the Chartered Engineer
shall act only in the domain of his/her competence.', 'In case of fabrication,
reasonable wastage, if any, anticipated at the time of installation of capital
goods shall be certified by the Chartered Engineer in the nexus certificate
and the same would be mentioned in the condition sheet of the EPCG
authorisation at the time of issue.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.03 - Nexus Certification.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_03-R003', '5.03', 'In case of fabrication,
reasonable wastage, if any, anticipated at the time of installation of capital
goods shall be certified by the Chartered Engineer in the nexus certificate
and the same would be mentioned in the condition sheet of the EPCG
authorisation at the time of issue.', 'business_rule', 'Nexus Certification', 'any', 'In case of fabrication,
reasonable wastage, if any, anticipated at the time of installation of capital
goods shall be certified by the Chartered Engineer in the nexus certificate
and the same would be mentioned in the condition sheet of the EPCG
authorisation at the time of issue.', 'The wastage so permitted at the time of
issuance of authorisation would be allowed to be sold as scrap/waste on
payment of applicable duty by the authorisation holder.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.03 - Nexus Certification.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_03-R004', '5.03', '5.03 Nexus Certification
(a)
RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation.', 'business_rule', 'Nexus Certification', 'any', '5.03 Nexus Certification
(a)
RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation.', '(b) An application for amendment in the list of import item(s) including
addition(s)/deletion(s), if any, may be filed with RA concerned provided the
authorisation is valid for import.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.03 - Nexus Certification.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.03', '5.03 Nexus Certification
(a) RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.03', 'For issuance of such certificate, the Chartered Engineer
shall act only in the domain of his/her competence.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.03', 'In case of fabrication,
reasonable wastage, if any, anticipated at the time of installation of capital
goods shall be certified by the Chartered Engineer in the nexus certificate
and the same would be mentioned in the condition sheet of the EPCG
authorisation at the time of issue.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.03', '(b) An application for amendment in the list of import item(s) including
addition(s)/deletion(s), if any, may be filed with RA concerned provided the
authorisation is valid for import.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.03', 'The applicant would give justification for
seeking such amendment(s) along with fresh nexus certificate from an
independent Chartered Engineer.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.03', '(c) An application for amendment in the list of export item(s) including
addition(s)/deletion(s) if any, may be filed with RA concerned provided the
Export Obligation period of the authorisation is valid and the CG has nexus
with export product.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.03', 'The applicant would give justification for seeking such
amendment(s) along with fresh nexus certificate from an independent
Chartered Engineer.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.03', '5.03 Nexus Certification
(a)
RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.03', '(b)
An application for amendment in the list of import item(s) including
addition(s)/deletion(s), if any, may be filed with RA concerned provided the
authorisation is valid for import.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.03', '(c)
An application for amendment in the list of export item(s) including
addition(s)/deletion(s) if any, may be filed with RA concerned provided the
Export Obligation period of the authorisation is valid and the CG has nexus
with export product.');
INSERT INTO documents (section_code, document_name) VALUES ('5.03', '5.03 Nexus Certification
(a) RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation.');
INSERT INTO documents (section_code, document_name) VALUES ('5.03', 'For issuance of such certificate, the Chartered Engineer
shall act only in the domain of his/her competence.');
INSERT INTO documents (section_code, document_name) VALUES ('5.03', 'In case of fabrication,
reasonable wastage, if any, anticipated at the time of installation of capital
goods shall be certified by the Chartered Engineer in the nexus certificate
and the same would be mentioned in the condition sheet of the EPCG
authorisation at the time of issue.');
INSERT INTO documents (section_code, document_name) VALUES ('5.03', '(b) An application for amendment in the list of import item(s) including
addition(s)/deletion(s), if any, may be filed with RA concerned provided the
authorisation is valid for import.');
INSERT INTO documents (section_code, document_name) VALUES ('5.03', 'The applicant would give justification for
seeking such amendment(s) along with fresh nexus certificate from an
independent Chartered Engineer.');
INSERT INTO documents (section_code, document_name) VALUES ('5.03', '(c) An application for amendment in the list of export item(s) including
addition(s)/deletion(s) if any, may be filed with RA concerned provided the
Export Obligation period of the authorisation is valid and the CG has nexus
with export product.');
INSERT INTO documents (section_code, document_name) VALUES ('5.03', 'The applicant would give justification for seeking such
amendment(s) along with fresh nexus certificate from an independent
Chartered Engineer.');
INSERT INTO documents (section_code, document_name) VALUES ('5.03', '5.03 Nexus Certification
(a)
RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation.');
INSERT INTO documents (section_code, document_name) VALUES ('5.03', '(b)
An application for amendment in the list of import item(s) including
addition(s)/deletion(s), if any, may be filed with RA concerned provided the
authorisation is valid for import.');
INSERT INTO documents (section_code, document_name) VALUES ('5.03', '(c)
An application for amendment in the list of export item(s) including
addition(s)/deletion(s) if any, may be filed with RA concerned provided the
Export Obligation period of the authorisation is valid and the CG has nexus
with export product.');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.03', 'RA');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.03', '(b) An application for amendment in the list of import item(s) including
addition(s)/deletion(s), if any, may be filed with RA concerned provided the
authorisation is valid for import.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.03', '(b)
An application for amendment in the list of import item(s) including
addition(s)/deletion(s), if any, may be filed with RA concerned provided the
authorisation is valid for import.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.03', 1, 'Evaluate condition: 5.03 Nexus Certification
(a) RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.03', 2, 'Evaluate condition: For issuance of such certificate, the Chartered Engineer
shall act only in the domain of his/her competence.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.03', 3, 'Evaluate condition: In case of fabrication,
reasonable wastage, if any, anticipated at the time of installation of capital
goods shall be certified by the Chartered Engineer in the nexus certificate
and the same would be mentioned in the condition sheet of the EPCG
authorisation at the time of issue.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.03', 4, '5.03 Nexus Certification
(a) RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.03', 5, 'In case of fabrication,
reasonable wastage, if any, anticipated at the time of installation of capital
goods shall be certified by the Chartered Engineer in the nexus certificate
and the same would be mentioned in the condition sheet of the EPCG
authorisation at the time of issue.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.03', 6, 'The wastage so permitted at the time of
issuance of authorisation would be allowed to be sold as scrap/waste on
payment of applicable duty by the authorisation holder.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.03', 7, '(b) An application for amendment in the list of import item(s) including
addition(s)/deletion(s), if any, may be filed with RA concerned provided the
authorisation is valid for import.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.03', 8, 'The applicant would give justification for
seeking such amendment(s) along with fresh nexus certificate from an
independent Chartered Engineer.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.03', 9, '(c) An application for amendment in the list of export item(s) including
addition(s)/deletion(s) if any, may be filed with RA concerned provided the
Export Obligation period of the authorisation is valid and the CG has nexus
with export product.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.03', 10, 'Run validation: 5.03 Nexus Certification
(a) RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by the applicant in Appendix 5A, issue
EPCG authorisation.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.03', 11, 'Run validation: For issuance of such certificate, the Chartered Engineer
shall act only in the domain of his/her competence.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.03', 12, 'Run validation: In case of fabrication,
reasonable wastage, if any, anticipated at the time of installation of capital
goods shall be certified by the Chartered Engineer in the nexus certificate
and the same would be mentioned in the condition sheet of the EPCG
authorisation at the time of issue.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'CEC');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'For');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'act');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'any');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'may');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'has');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'from');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'such');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'only');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'case');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'time');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'same');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'sold');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'duty');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'list');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'item');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'keywords', 'with');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'tags', '5.03');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'tags', 'Nexus Certification');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.03', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.04', 'Certificate of Installation of Capital Goods', '5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
2
2
Chapter-5
Export Promotion Capital Goods (EPCG) Scheme
5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
manufacturer(s).', 'Indha Certificate of Installation of Capital Goods section-la, 5.04 Certificate of Installation of Capital Goods
(a) Authorization holder kandippa produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
2
2
Chapter-5
export Promotion Capital Goods (EPCG) Scheme
5.04 Certificate of Installation of Capital Goods
(a) Authorization holder kandippa produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
manufacturer(s).', '5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
2
2
Chapter-5
Export Promotion Capital Goods (EPCG) Scheme
5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
manufacturer(s). The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs. 10,000/- per year by the authorisation holder.', 'Certificate of Installation of Capital Goods governs how DGFT business controls should be applied, validated, and enforced.', 'Certificate of Installation of Capital Goods explains the operating rule set that DEKAI should enforce. Key control points include 5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
2
2
Chapter-5
Export Promotion Capital Goods (EPCG) Scheme
5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
manufacturer(s). The section also drives actions such as The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs..', 'Indha Certificate of Installation of Capital Goods section-la, Certificate of Installation of Capital Goods explains the operating rule set that DEKAI should enforce. Key control points include 5.04 Certificate of Installation of Capital Goods
(a) Authorization holder kandippa produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
2
2
Chapter-5
export Promotion Capital Goods (EPCG) Scheme
5.04 Certificate of Installation of Capital Goods
(a) Authorization holder kandippa produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
manufacturer(s). The section also drives actions such as The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs..', '5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
2
2
Chapter-5
Export Promotion Capital Goods (EPCG) Scheme
5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
manufacturer(s). The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs. 10,000/- per year by the authorisation holder. Where
the authorisation holder opts for independent Chartered Engineer’s
certificate, he shall send a copy of the certificate to the jurisdictional
Customs Authority for intimation/record. The authorization holder shall be
permitted to shift capital goods during the entire export obligation period
to other units mentioned in the IEC and RCMC of the authorization holder
subject to production of fresh installation certificate to the RA concerned
within six months of the shifting.
(a) Deleted.', '[2, 3]', '["the", "his", "may", "for", "fee", "per", "IEC", "and", "six", "from", "date", "EPCG", "said", "upto", "with", "year", "opts", "send", "copy", "RCMC"]', 'Support Certificate of Installation of Capital Goods processing and compliance validation.', '["5.04", "Certificate of Installation of Capital Goods", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_04-R001', '5.04', '5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
2
2
Chapter-5
Export Promotion Capital Goods (EPCG) Scheme
5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
manufacturer(s).', 'business_rule', 'Certificate of Installation of Capital Goods', '5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
2
2
Chapter-5
Export Promotion Capital Goods (EPCG) Scheme
5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
manufacturer(s).', '5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
2
2
Chapter-5
Export Promotion Capital Goods (EPCG) Scheme
5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
manufacturer(s).', 'The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.04 - Certificate of Installation of Capital Goods.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_04-R002', '5.04', 'Where
the authorisation holder opts for independent Chartered Engineer’s
certificate, he shall send a copy of the certificate to the jurisdictional
Customs Authority for intimation/record.', 'business_rule', 'Certificate of Installation of Capital Goods', 'The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs.', 'Where
the authorisation holder opts for independent Chartered Engineer’s
certificate, he shall send a copy of the certificate to the jurisdictional
Customs Authority for intimation/record.', 'The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.04 - Certificate of Installation of Capital Goods.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_04-R003', '5.04', 'The authorization holder shall be
permitted to shift capital goods during the entire export obligation period
to other units mentioned in the IEC and RCMC of the authorization holder
subject to production of fresh installation certificate to the RA concerned
within six months of the shifting.', 'business_rule', 'Certificate of Installation of Capital Goods', 'Where
the authorisation holder opts for independent Chartered Engineer’s
certificate, he shall send a copy of the certificate to the jurisdictional
Customs Authority for intimation/record.', 'The authorization holder shall be
permitted to shift capital goods during the entire export obligation period
to other units mentioned in the IEC and RCMC of the authorization holder
subject to production of fresh installation certificate to the RA concerned
within six months of the shifting.', 'The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.04 - Certificate of Installation of Capital Goods.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.04', '5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
2
2
Chapter-5
Export Promotion Capital Goods (EPCG) Scheme
5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
manufacturer(s).');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.04', 'The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.04', 'Where
the authorisation holder opts for independent Chartered Engineer’s
certificate, he shall send a copy of the certificate to the jurisdictional
Customs Authority for intimation/record.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.04', 'The authorization holder shall be
permitted to shift capital goods during the entire export obligation period
to other units mentioned in the IEC and RCMC of the authorization holder
subject to production of fresh installation certificate to the RA concerned
within six months of the shifting.');
INSERT INTO documents (section_code, document_name) VALUES ('5.04', '5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
2
2
Chapter-5
Export Promotion Capital Goods (EPCG) Scheme
5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
manufacturer(s).');
INSERT INTO documents (section_code, document_name) VALUES ('5.04', 'The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs.');
INSERT INTO documents (section_code, document_name) VALUES ('5.04', 'Where
the authorisation holder opts for independent Chartered Engineer’s
certificate, he shall send a copy of the certificate to the jurisdictional
Customs Authority for intimation/record.');
INSERT INTO documents (section_code, document_name) VALUES ('5.04', 'The authorization holder shall be
permitted to shift capital goods during the entire export obligation period
to other units mentioned in the IEC and RCMC of the authorization holder
subject to production of fresh installation certificate to the RA concerned
within six months of the shifting.');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.04', 'RA');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.04', 'Customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.04', 'The RA');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.04', 'Customs Authority');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.04', '5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
2
2
Chapter-5
Export Promotion Capital Goods (EPCG) Scheme
5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
manufacturer(s).');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.04', 'The authorization holder shall be
permitted to shift capital goods during the entire export obligation period
to other units mentioned in the IEC and RCMC of the authorization holder
subject to production of fresh installation certificate to the RA concerned
within six months of the shifting.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.04', 1, 'Evaluate condition: 5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
2
2
Chapter-5
Export Promotion Capital Goods (EPCG) Scheme
5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
manufacturer(s).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.04', 2, 'Evaluate condition: The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.04', 3, 'Evaluate condition: Where
the authorisation holder opts for independent Chartered Engineer’s
certificate, he shall send a copy of the certificate to the jurisdictional
Customs Authority for intimation/record.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.04', 4, 'The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.04', 5, 'Run validation: 5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
2
2
Chapter-5
Export Promotion Capital Goods (EPCG) Scheme
5.04 Certificate of Installation of Capital Goods
(a) Authorization holder shall produce, within 3 years from date of completion
of import, to the concerned RA, a certificate from the jurisdictional Customs
authority or an independent Chartered Engineer, at the option of the
authorisation holder, confirming installation of capital goods/spares at
factory/premises of authorization holder or his supporting
manufacturer(s).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.04', 6, 'Run validation: Where
the authorisation holder opts for independent Chartered Engineer’s
certificate, he shall send a copy of the certificate to the jurisdictional
Customs Authority for intimation/record.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.04', 7, 'Run validation: The authorization holder shall be
permitted to shift capital goods during the entire export obligation period
to other units mentioned in the IEC and RCMC of the authorization holder
subject to production of fresh installation certificate to the RA concerned
within six months of the shifting.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'his');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'may');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'fee');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'per');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'IEC');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'six');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'from');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'date');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'said');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'upto');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'with');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'year');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'opts');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'send');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'copy');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'keywords', 'RCMC');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'tags', '5.04');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'tags', 'Certificate of Installation of Capital Goods');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.04', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.05', 'Port of Registration', '5.05 Port of Registration
EPCG Authorisation shall be issued with a single port of registration as per
paragraph 4.35 of HBP, for imports.', 'Indha Port of Registration section-la, 5.05 Port of Registration
EPCG Authorisation kandippa be issued with a single port of registration as per
paragraph 4.35 of HBP, for imports.', '5.05 Port of Registration
EPCG Authorisation shall be issued with a single port of registration as per
paragraph 4.35 of HBP, for imports. However, exports can be made from any port
specified in paragraph 4.35 of HBP.', 'Port of Registration governs how DGFT business controls should be applied, validated, and enforced.', 'Port of Registration explains the operating rule set that DEKAI should enforce. Key control points include 5.05 Port of Registration
EPCG Authorisation shall be issued with a single port of registration as per
paragraph 4.35 of HBP, for imports. The section also drives actions such as 5.05 Port of Registration
EPCG Authorisation shall be issued with a single port of registration as per
paragraph 4.35 of HBP, for imports..', 'Indha Port of Registration section-la, Port of Registration explains the operating rule set that DEKAI should enforce. Key control points include 5.05 Port of Registration
EPCG Authorisation kandippa be issued with a single port of registration as per
paragraph 4.35 of HBP, for imports. The section also drives actions such as 5.05 Port of Registration
EPCG Authorisation kandippa be issued with a single port of registration as per
paragraph 4.35 of HBP, for imports..', '5.05 Port of Registration
EPCG Authorisation shall be issued with a single port of registration as per
paragraph 4.35 of HBP, for imports. However, exports can be made from any port
specified in paragraph 4.35 of HBP.', '[3]', '["per", "HBP", "for", "can", "any", "Port", "EPCG", "with", "made", "from", "shall", "issued", "single", "imports", "However", "exports", "paragraph", "specified", "Registration", "Authorisation"]', 'Support Port of Registration processing and compliance validation.', '["5.05", "Port of Registration", "business-rule", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_05-R001', '5.05', '5.05 Port of Registration
EPCG Authorisation shall be issued with a single port of registration as per
paragraph 4.35 of HBP, for imports.', 'business_rule', 'Port of Registration', 'However, exports can be made from any port
specified in paragraph 4.35 of HBP.', '5.05 Port of Registration
EPCG Authorisation shall be issued with a single port of registration as per
paragraph 4.35 of HBP, for imports.', '5.05 Port of Registration
EPCG Authorisation shall be issued with a single port of registration as per
paragraph 4.35 of HBP, for imports.', 'However, exports can be made from any port
specified in paragraph 4.35 of HBP.', 'DEKAI should produce a compliance decision for 5.05 - Port of Registration.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.05', 'However, exports can be made from any port
specified in paragraph 4.35 of HBP.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('5.05', 'However, exports can be made from any port
specified in paragraph 4.35 of HBP.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.05', 1, 'Evaluate condition: However, exports can be made from any port
specified in paragraph 4.35 of HBP.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.05', 2, '5.05 Port of Registration
EPCG Authorisation shall be issued with a single port of registration as per
paragraph 4.35 of HBP, for imports.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.05', 3, 'Run validation: 5.05 Port of Registration
EPCG Authorisation shall be issued with a single port of registration as per
paragraph 4.35 of HBP, for imports.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.05', 4, 'Handle exception: However, exports can be made from any port
specified in paragraph 4.35 of HBP.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'per');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'HBP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'can');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'any');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'Port');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'with');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'made');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'from');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'shall');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'issued');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'single');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'imports');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'However');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'exports');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'paragraph');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'specified');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'Registration');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'keywords', 'Authorisation');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'tags', '5.05');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'tags', 'Port of Registration');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.05', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.06', 'Import of spares, tools, refractories and catalysts', '5.06 Import of spares, tools, refractories and catalysts
(a) Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP shall contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities.', 'Indha Import of spares, tools, refractories and catalysts section-la, 5.06 import of spares, tools, refractories and catalysts
(a) Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP kandippa contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities.', '5.06 Import of spares, tools, refractories and catalysts
(a) Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP shall contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities. (b) In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i) Name of plant /machinery for which spares are required. (ii) Value of duty saved allowed under the authorisation.', 'Import of spares, tools, refractories and catalysts governs how DGFT business controls should be applied, validated, and enforced.', 'Import of spares, tools, refractories and catalysts explains the operating rule set that DEKAI should enforce. Key control points include 5.06 Import of spares, tools, refractories and catalysts
(a) Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP shall contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities. The section also drives actions such as (c) Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register..', 'Indha Import of spares, tools, refractories and catalysts section-la, import of spares, tools, refractories and catalysts explains the operating rule set that DEKAI should enforce. Key control points include 5.06 import of spares, tools, refractories and catalysts
(a) Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP kandippa contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities. The section also drives actions such as (c) Authorisation holder kandippa maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder kandippa submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register..', '5.06 Import of spares, tools, refractories and catalysts
(a) Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP shall contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities.
(b) In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i) Name of plant /machinery for which spares are required.
(ii) Value of duty saved allowed under the authorisation.
(iii) Description of product to be exported and value of export
obligation.
(c) Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.
i. Para 5.04(a) amended vide Public Notice No. 15/2024-25 dated 25.07.2024.
ii. Para 5.04(b) deleted vide Public Notice No. 15/2024-25 dated 25.07.2024.
3
3
manufacturer(s). The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs. 10,000/- per year by the authorisation holder. Where
the authorisation holder opts for independent Chartered Engineer’s
certificate, he shall send a copy of the certificate to the jurisdictional
Customs Authority for intimation/record. The authorization holder shall be
permitted to shift capital goods during the entire export obligation period
to other units mentioned in the IEC and RCMC of the authorization holder
subject to production of fresh installation certificate to the RA concerned
within six months of the shifting.
(a) Deleted.
5.06 Import of spares, tools, refractories and catalysts
(a)
Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP shall contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities.
(b)
In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i)
Name of plant /machinery for which spares are required.
(ii) Value of duty saved allowed under the authorisation.
(iii) Description of product to be exported and value of export
obligation.
(c)
Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.
i.
Para 5.04(a) amended vide Public Notice No. 15/2024-25 dated 25.07.2024.
ii.
Para 5.04(b) deleted vide Public Notice No. 15/2024-25 dated 25.07.2024.', '[3]', '["and", "for", "sub", "iii", "FTP", "the", "are", "not", "but", "use", "may", "fee", "per", "IEC", "six", "list", "such", "duly", "case", "EPCG"]', 'Support Import of spares, tools, refractories and catalysts processing and compliance validation.', '["5.06", "Import of spares, tools, refractories and catalysts", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_06-R001', '5.06', '5.06 Import of spares, tools, refractories and catalysts
(a) Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP shall contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities.', 'business_rule', 'Import of spares, tools, refractories and catalysts', '5.06 Import of spares, tools, refractories and catalysts
(a) Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP shall contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities.', '5.06 Import of spares, tools, refractories and catalysts
(a) Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP shall contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities.', '(c) Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.', '(b) In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i) Name of plant /machinery for which spares are required.', 'DEKAI should produce a compliance decision for 5.06 - Import of spares, tools, refractories and catalysts.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_06-R002', '5.06', '(b) In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i) Name of plant /machinery for which spares are required.', 'business_rule', 'Import of spares, tools, refractories and catalysts', '(b) In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i) Name of plant /machinery for which spares are required.', '(b) In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i) Name of plant /machinery for which spares are required.', 'Para 5.04(a) amended vide Public Notice No.', '(b)
In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i)
Name of plant /machinery for which spares are required.', 'DEKAI should produce a compliance decision for 5.06 - Import of spares, tools, refractories and catalysts.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_06-R003', '5.06', '(c) Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.', 'business_rule', 'Import of spares, tools, refractories and catalysts', '(c) Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.', '(c) Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.', 'The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs.', '(b)
In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i)
Name of plant /machinery for which spares are required.', 'DEKAI should produce a compliance decision for 5.06 - Import of spares, tools, refractories and catalysts.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_06-R004', '5.06', 'Where
the authorisation holder opts for independent Chartered Engineer’s
certificate, he shall send a copy of the certificate to the jurisdictional
Customs Authority for intimation/record.', 'business_rule', 'Import of spares, tools, refractories and catalysts', 'The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs.', 'Where
the authorisation holder opts for independent Chartered Engineer’s
certificate, he shall send a copy of the certificate to the jurisdictional
Customs Authority for intimation/record.', '(c)
Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.', '(b)
In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i)
Name of plant /machinery for which spares are required.', 'DEKAI should produce a compliance decision for 5.06 - Import of spares, tools, refractories and catalysts.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_06-R005', '5.06', 'The authorization holder shall be
permitted to shift capital goods during the entire export obligation period
to other units mentioned in the IEC and RCMC of the authorization holder
subject to production of fresh installation certificate to the RA concerned
within six months of the shifting.', 'business_rule', 'Import of spares, tools, refractories and catalysts', 'Where
the authorisation holder opts for independent Chartered Engineer’s
certificate, he shall send a copy of the certificate to the jurisdictional
Customs Authority for intimation/record.', 'The authorization holder shall be
permitted to shift capital goods during the entire export obligation period
to other units mentioned in the IEC and RCMC of the authorization holder
subject to production of fresh installation certificate to the RA concerned
within six months of the shifting.', '(c)
Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.', '(b)
In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i)
Name of plant /machinery for which spares are required.', 'DEKAI should produce a compliance decision for 5.06 - Import of spares, tools, refractories and catalysts.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_06-R006', '5.06', '5.06 Import of spares, tools, refractories and catalysts
(a)
Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP shall contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities.', 'business_rule', 'Import of spares, tools, refractories and catalysts', 'The authorization holder shall be
permitted to shift capital goods during the entire export obligation period
to other units mentioned in the IEC and RCMC of the authorization holder
subject to production of fresh installation certificate to the RA concerned
within six months of the shifting.', '5.06 Import of spares, tools, refractories and catalysts
(a)
Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP shall contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities.', '(c)
Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.', '(b)
In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i)
Name of plant /machinery for which spares are required.', 'DEKAI should produce a compliance decision for 5.06 - Import of spares, tools, refractories and catalysts.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_06-R007', '5.06', '(b)
In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i)
Name of plant /machinery for which spares are required.', 'business_rule', 'Import of spares, tools, refractories and catalysts', '5.06 Import of spares, tools, refractories and catalysts
(a)
Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP shall contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities.', '(b)
In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i)
Name of plant /machinery for which spares are required.', '(c)
Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.', '(b)
In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i)
Name of plant /machinery for which spares are required.', 'DEKAI should produce a compliance decision for 5.06 - Import of spares, tools, refractories and catalysts.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_06-R008', '5.06', '(c)
Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.', 'business_rule', 'Import of spares, tools, refractories and catalysts', '(b)
In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i)
Name of plant /machinery for which spares are required.', '(c)
Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.', '(c)
Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.', '(b)
In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i)
Name of plant /machinery for which spares are required.', 'DEKAI should produce a compliance decision for 5.06 - Import of spares, tools, refractories and catalysts.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.06', '5.06 Import of spares, tools, refractories and catalysts
(a) Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP shall contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.06', '(b) In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i) Name of plant /machinery for which spares are required.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.06', '(c) Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.06', 'The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.06', 'Where
the authorisation holder opts for independent Chartered Engineer’s
certificate, he shall send a copy of the certificate to the jurisdictional
Customs Authority for intimation/record.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.06', 'The authorization holder shall be
permitted to shift capital goods during the entire export obligation period
to other units mentioned in the IEC and RCMC of the authorization holder
subject to production of fresh installation certificate to the RA concerned
within six months of the shifting.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.06', '5.06 Import of spares, tools, refractories and catalysts
(a)
Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP shall contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.06', '(b)
In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i)
Name of plant /machinery for which spares are required.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.06', '(c)
Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.');
INSERT INTO documents (section_code, document_name) VALUES ('5.06', '5.06 Import of spares, tools, refractories and catalysts
(a) Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP shall contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities.');
INSERT INTO documents (section_code, document_name) VALUES ('5.06', '(c) Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.');
INSERT INTO documents (section_code, document_name) VALUES ('5.06', 'The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs.');
INSERT INTO documents (section_code, document_name) VALUES ('5.06', 'Where
the authorisation holder opts for independent Chartered Engineer’s
certificate, he shall send a copy of the certificate to the jurisdictional
Customs Authority for intimation/record.');
INSERT INTO documents (section_code, document_name) VALUES ('5.06', 'The authorization holder shall be
permitted to shift capital goods during the entire export obligation period
to other units mentioned in the IEC and RCMC of the authorization holder
subject to production of fresh installation certificate to the RA concerned
within six months of the shifting.');
INSERT INTO documents (section_code, document_name) VALUES ('5.06', '5.06 Import of spares, tools, refractories and catalysts
(a)
Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP shall contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities.');
INSERT INTO documents (section_code, document_name) VALUES ('5.06', '(c)
Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.06', 'Customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.06', 'Engineer or jurisdictional Customs Authorities');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.06', 'RA');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.06', 'The RA');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.06', 'Customs Authority');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.06', 'The authorization holder shall be
permitted to shift capital goods during the entire export obligation period
to other units mentioned in the IEC and RCMC of the authorization holder
subject to production of fresh installation certificate to the RA concerned
within six months of the shifting.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('5.06', '(b) In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i) Name of plant /machinery for which spares are required.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('5.06', '(b)
In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i)
Name of plant /machinery for which spares are required.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.06', 1, 'Evaluate condition: 5.06 Import of spares, tools, refractories and catalysts
(a) Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP shall contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.06', 2, 'Evaluate condition: (b) In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i) Name of plant /machinery for which spares are required.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.06', 3, 'Evaluate condition: (c) Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.06', 4, '(c) Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.06', 5, 'Para 5.04(a) amended vide Public Notice No.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.06', 6, 'The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.06', 7, '(c)
Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.06', 8, 'Run validation: 5.06 Import of spares, tools, refractories and catalysts
(a) Applications for procurement of capital goods covered under sub-
paragraphs (a) (iii) and (iv) of paragraph 5.01 of FTP shall contain a list of
plant/machinery installed in factory/premises of the applicant for which
such capital goods are required, duly certified by independent Chartered
Engineer or jurisdictional Customs Authorities.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.06', 9, 'Run validation: (b) In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i) Name of plant /machinery for which spares are required.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.06', 10, 'Run validation: (c) Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of paragraph
5.01 of FTP imported under the scheme and at the time of application for
EODC, authorisation holder shall submit certificate from independent
Chartered Engineer confirming their use in the installed capital goods on
the basis of such register.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.06', 11, 'Handle exception: (b) In case of import of spares, EPCG authorisation shall not specify list of
spares but shall indicate:
(i) Name of plant /machinery for which spares are required.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'sub');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'iii');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'FTP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'are');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'not');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'but');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'use');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'may');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'fee');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'per');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'IEC');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'six');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'list');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'such');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'duly');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'case');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'keywords', 'EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'tags', '5.06');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'tags', 'Import of spares, tools, refractories and catalysts');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.06', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.07', 'Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG', '5.07 Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG
Scheme
(a) An EOU/a relocated SEZ unit, while converting to a DTA Unit, may apply for
an EPCG authorisation along with documents prescribed.', 'Indha Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG section-la, 5.07 Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG
Scheme
(a) An EOU/a relocated SEZ unit, while converting to a DTA Unit, may apply for
an EPCG authorisation along with documents prescribed.', '5.07 Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG
Scheme
(a) An EOU/a relocated SEZ unit, while converting to a DTA Unit, may apply for
an EPCG authorisation along with documents prescribed. ‘No Objection
Certificate’ should be produced from the concerned Development
Commissioner. (b) The export obligation period for a unit which converts from EOU/SEZ
Scheme to EPCG Scheme would be the same as is available to a direct EPCG
Authorisation holder as per paragraph 5.01 of FTP.', 'Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG governs how DGFT business controls should be applied, validated, and enforced.', 'Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG explains the operating rule set that DEKAI should enforce. Key control points include ‘No Objection
Certificate’ should be produced from the concerned Development
Commissioner. The section also drives actions such as 5.07 Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG
Scheme
(a) An EOU/a relocated SEZ unit, while converting to a DTA Unit, may apply for
an EPCG authorisation along with documents prescribed..', 'Indha Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG section-la, Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG explains the operating rule set that DEKAI should enforce. Key control points include ‘No Objection
Certificate’ should be produced from the concerned Development
Commissioner. The section also drives actions such as 5.07 Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG
Scheme
(a) An EOU/a relocated SEZ unit, while converting to a DTA Unit, may apply for
an EPCG authorisation along with documents prescribed..', '5.07 Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG
Scheme
(a) An EOU/a relocated SEZ unit, while converting to a DTA Unit, may apply for
an EPCG authorisation along with documents prescribed. ‘No Objection
Certificate’ should be produced from the concerned Development
Commissioner.
(b) The export obligation period for a unit which converts from EOU/SEZ
Scheme to EPCG Scheme would be the same as is available to a direct EPCG
Authorisation holder as per paragraph 5.01 of FTP.
(c) If a standalone EOU / SEZ unit wishes to de-bond from EOU to EPCG Scheme,
there shall be no requirement for maintenance of average export obligation
and the unit shall be required to maintain only specific export obligation
equivalent to six times of the proportionate duty saved amount of the
depreciated value of capital goods for which the Authorisation has been
obtained.
(d) In case one unit of a firm / company opts to de-bond from EOU to EPCG
Scheme, while other unit(s) are DTA units, then the average export
obligation in respect of the authorisations issued to the firm / company
(other than de-bonding unit) shall remain unchanged and the average EO,
after de-bonding of the unit, shall be fixed by excluding the exports made by
the de-bonded unit from the total exports of the firm/ company, which runs
concurrently for all the units of the firm/ company. In such a case, specific
EO equivalent to six times of the proportionate duty saved amount on the
depreciated value of the Capital Goods would be imposed on the de- bonding
unit shifting to the EPCG Scheme.
5.07 Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG
Scheme
(a)
An EOU/a relocated SEZ unit, while converting to a DTA Unit, may apply for
an EPCG authorisation along with documents prescribed. ‘No Objection
Certificate’ should be produced from the concerned Development
Commissioner.
(b)
The export obligation period for a unit which converts from EOU/SEZ
Scheme to EPCG Scheme would be the same as is available to a direct EPCG
Authorisation holder as per paragraph 5.01 of FTP.
(c)
If a standalone EOU / SEZ unit wishes to de-bond from EOU to EPCG Scheme,
there shall be no requirement for maintenance of average export obligation
and the unit shall be required to maintain only specific export obligation
equivalent to six times of the proportionate duty saved amount of the
depreciated value of capital goods for which the Authorisation has been
obtained.
(d)
In case one unit of a firm / company opts to de-bond from EOU to EPCG
Scheme, while other unit(s) are DTA units, then the average export
obligation in respect of the authorisations issued to the firm / company
(other than de-bonding unit) shall remain unchanged and the average EO,
after de-bonding of the unit, shall be fixed by excluding the exports made by
the de-bonded unit from the total exports of the firm/ company, which runs
concurrently for all the units of the firm/ company. In such a case, specific
EO equivalent to six times of the proportionate duty saved amount on the
depreciated value of the Capital Goods would be imposed on the de- bonding
unit shifting to the EPCG Scheme.', '[4]', '["SEZ", "DTA", "may", "for", "the", "per", "FTP", "EOU", "and", "six", "has", "one", "are", "all", "Unit", "EPCG", "with", "from", "same", "only"]', 'Support Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG processing and compliance validation.', '["5.07", "Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_07-R001', '5.07', '‘No Objection
Certificate’ should be produced from the concerned Development
Commissioner.', 'business_rule', 'Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG', '‘No Objection
Certificate’ should be produced from the concerned Development
Commissioner.', '(c) If a standalone EOU / SEZ unit wishes to de-bond from EOU to EPCG Scheme,
there shall be no requirement for maintenance of average export obligation
and the unit shall be required to maintain only specific export obligation
equivalent to six times of the proportionate duty saved amount of the
depreciated value of capital goods for which the Authorisation has been
obtained.', '5.07 Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG
Scheme
(a) An EOU/a relocated SEZ unit, while converting to a DTA Unit, may apply for
an EPCG authorisation along with documents prescribed.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.07 - Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_07-R002', '5.07', '(c) If a standalone EOU / SEZ unit wishes to de-bond from EOU to EPCG Scheme,
there shall be no requirement for maintenance of average export obligation
and the unit shall be required to maintain only specific export obligation
equivalent to six times of the proportionate duty saved amount of the
depreciated value of capital goods for which the Authorisation has been
obtained.', 'business_rule', 'Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG', 'a standalone EOU / SEZ unit wishes to de-bond from EOU to EPCG Scheme', '(d) In case one unit of a firm / company opts to de-bond from EOU to EPCG
Scheme, while other unit(s) are DTA units, then the average export
obligation in respect of the authorisations issued to the firm / company
(other than de-bonding unit) shall remain unchanged and the average EO,
after de-bonding of the unit, shall be fixed by excluding the exports made by
the de-bonded unit from the total exports of the firm/ company, which runs
concurrently for all the units of the firm/ company.', '(c) If a standalone EOU / SEZ unit wishes to de-bond from EOU to EPCG Scheme,
there shall be no requirement for maintenance of average export obligation
and the unit shall be required to maintain only specific export obligation
equivalent to six times of the proportionate duty saved amount of the
depreciated value of capital goods for which the Authorisation has been
obtained.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.07 - Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_07-R003', '5.07', '(d) In case one unit of a firm / company opts to de-bond from EOU to EPCG
Scheme, while other unit(s) are DTA units, then the average export
obligation in respect of the authorisations issued to the firm / company
(other than de-bonding unit) shall remain unchanged and the average EO,
after de-bonding of the unit, shall be fixed by excluding the exports made by
the de-bonded unit from the total exports of the firm/ company, which runs
concurrently for all the units of the firm/ company.', 'business_rule', 'Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG', '(d) In case one unit of a firm / company opts to de-bond from EOU to EPCG
Scheme, while other unit(s) are DTA units, then the average export
obligation in respect of the authorisations issued to the firm / company
(other than de-bonding unit) shall remain unchanged and the average EO,
after de-bonding of the unit, shall be fixed by excluding the exports made by
the de-bonded unit from the total exports of the firm/ company, which runs
concurrently for all the units of the firm/ company.', '(c)
If a standalone EOU / SEZ unit wishes to de-bond from EOU to EPCG Scheme,
there shall be no requirement for maintenance of average export obligation
and the unit shall be required to maintain only specific export obligation
equivalent to six times of the proportionate duty saved amount of the
depreciated value of capital goods for which the Authorisation has been
obtained.', '(d) In case one unit of a firm / company opts to de-bond from EOU to EPCG
Scheme, while other unit(s) are DTA units, then the average export
obligation in respect of the authorisations issued to the firm / company
(other than de-bonding unit) shall remain unchanged and the average EO,
after de-bonding of the unit, shall be fixed by excluding the exports made by
the de-bonded unit from the total exports of the firm/ company, which runs
concurrently for all the units of the firm/ company.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.07 - Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_07-R004', '5.07', '(c)
If a standalone EOU / SEZ unit wishes to de-bond from EOU to EPCG Scheme,
there shall be no requirement for maintenance of average export obligation
and the unit shall be required to maintain only specific export obligation
equivalent to six times of the proportionate duty saved amount of the
depreciated value of capital goods for which the Authorisation has been
obtained.', 'business_rule', 'Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG', 'In such a case, specific
EO equivalent to six times of the proportionate duty saved amount on the
depreciated value of the Capital Goods would be imposed on the de- bonding
unit shifting to the EPCG Scheme.', '(d)
In case one unit of a firm / company opts to de-bond from EOU to EPCG
Scheme, while other unit(s) are DTA units, then the average export
obligation in respect of the authorisations issued to the firm / company
(other than de-bonding unit) shall remain unchanged and the average EO,
after de-bonding of the unit, shall be fixed by excluding the exports made by
the de-bonded unit from the total exports of the firm/ company, which runs
concurrently for all the units of the firm/ company.', '5.07 Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG
Scheme
(a)
An EOU/a relocated SEZ unit, while converting to a DTA Unit, may apply for
an EPCG authorisation along with documents prescribed.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.07 - Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_07-R005', '5.07', '(d)
In case one unit of a firm / company opts to de-bond from EOU to EPCG
Scheme, while other unit(s) are DTA units, then the average export
obligation in respect of the authorisations issued to the firm / company
(other than de-bonding unit) shall remain unchanged and the average EO,
after de-bonding of the unit, shall be fixed by excluding the exports made by
the de-bonded unit from the total exports of the firm/ company, which runs
concurrently for all the units of the firm/ company.', 'business_rule', 'Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG', 'a standalone EOU / SEZ unit wishes to de-bond from EOU to EPCG Scheme', '(d)
In case one unit of a firm / company opts to de-bond from EOU to EPCG
Scheme, while other unit(s) are DTA units, then the average export
obligation in respect of the authorisations issued to the firm / company
(other than de-bonding unit) shall remain unchanged and the average EO,
after de-bonding of the unit, shall be fixed by excluding the exports made by
the de-bonded unit from the total exports of the firm/ company, which runs
concurrently for all the units of the firm/ company.', '(c)
If a standalone EOU / SEZ unit wishes to de-bond from EOU to EPCG Scheme,
there shall be no requirement for maintenance of average export obligation
and the unit shall be required to maintain only specific export obligation
equivalent to six times of the proportionate duty saved amount of the
depreciated value of capital goods for which the Authorisation has been
obtained.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.07 - Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.07', '‘No Objection
Certificate’ should be produced from the concerned Development
Commissioner.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.07', '(c) If a standalone EOU / SEZ unit wishes to de-bond from EOU to EPCG Scheme,
there shall be no requirement for maintenance of average export obligation
and the unit shall be required to maintain only specific export obligation
equivalent to six times of the proportionate duty saved amount of the
depreciated value of capital goods for which the Authorisation has been
obtained.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.07', '(d) In case one unit of a firm / company opts to de-bond from EOU to EPCG
Scheme, while other unit(s) are DTA units, then the average export
obligation in respect of the authorisations issued to the firm / company
(other than de-bonding unit) shall remain unchanged and the average EO,
after de-bonding of the unit, shall be fixed by excluding the exports made by
the de-bonded unit from the total exports of the firm/ company, which runs
concurrently for all the units of the firm/ company.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.07', 'In such a case, specific
EO equivalent to six times of the proportionate duty saved amount on the
depreciated value of the Capital Goods would be imposed on the de- bonding
unit shifting to the EPCG Scheme.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.07', '(c)
If a standalone EOU / SEZ unit wishes to de-bond from EOU to EPCG Scheme,
there shall be no requirement for maintenance of average export obligation
and the unit shall be required to maintain only specific export obligation
equivalent to six times of the proportionate duty saved amount of the
depreciated value of capital goods for which the Authorisation has been
obtained.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.07', '(d)
In case one unit of a firm / company opts to de-bond from EOU to EPCG
Scheme, while other unit(s) are DTA units, then the average export
obligation in respect of the authorisations issued to the firm / company
(other than de-bonding unit) shall remain unchanged and the average EO,
after de-bonding of the unit, shall be fixed by excluding the exports made by
the de-bonded unit from the total exports of the firm/ company, which runs
concurrently for all the units of the firm/ company.');
INSERT INTO documents (section_code, document_name) VALUES ('5.07', '5.07 Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG
Scheme
(a) An EOU/a relocated SEZ unit, while converting to a DTA Unit, may apply for
an EPCG authorisation along with documents prescribed.');
INSERT INTO documents (section_code, document_name) VALUES ('5.07', '‘No Objection
Certificate’ should be produced from the concerned Development
Commissioner.');
INSERT INTO documents (section_code, document_name) VALUES ('5.07', '5.07 Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG
Scheme
(a)
An EOU/a relocated SEZ unit, while converting to a DTA Unit, may apply for
an EPCG authorisation along with documents prescribed.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.07', '(d) In case one unit of a firm / company opts to de-bond from EOU to EPCG
Scheme, while other unit(s) are DTA units, then the average export
obligation in respect of the authorisations issued to the firm / company
(other than de-bonding unit) shall remain unchanged and the average EO,
after de-bonding of the unit, shall be fixed by excluding the exports made by
the de-bonded unit from the total exports of the firm/ company, which runs
concurrently for all the units of the firm/ company.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.07', '(d)
In case one unit of a firm / company opts to de-bond from EOU to EPCG
Scheme, while other unit(s) are DTA units, then the average export
obligation in respect of the authorisations issued to the firm / company
(other than de-bonding unit) shall remain unchanged and the average EO,
after de-bonding of the unit, shall be fixed by excluding the exports made by
the de-bonded unit from the total exports of the firm/ company, which runs
concurrently for all the units of the firm/ company.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.07', 1, 'Evaluate condition: ‘No Objection
Certificate’ should be produced from the concerned Development
Commissioner.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.07', 2, 'Evaluate condition: (c) If a standalone EOU / SEZ unit wishes to de-bond from EOU to EPCG Scheme,
there shall be no requirement for maintenance of average export obligation
and the unit shall be required to maintain only specific export obligation
equivalent to six times of the proportionate duty saved amount of the
depreciated value of capital goods for which the Authorisation has been
obtained.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.07', 3, 'Evaluate condition: (d) In case one unit of a firm / company opts to de-bond from EOU to EPCG
Scheme, while other unit(s) are DTA units, then the average export
obligation in respect of the authorisations issued to the firm / company
(other than de-bonding unit) shall remain unchanged and the average EO,
after de-bonding of the unit, shall be fixed by excluding the exports made by
the de-bonded unit from the total exports of the firm/ company, which runs
concurrently for all the units of the firm/ company.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.07', 4, '5.07 Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG
Scheme
(a) An EOU/a relocated SEZ unit, while converting to a DTA Unit, may apply for
an EPCG authorisation along with documents prescribed.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.07', 5, '(c) If a standalone EOU / SEZ unit wishes to de-bond from EOU to EPCG Scheme,
there shall be no requirement for maintenance of average export obligation
and the unit shall be required to maintain only specific export obligation
equivalent to six times of the proportionate duty saved amount of the
depreciated value of capital goods for which the Authorisation has been
obtained.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.07', 6, '(d) In case one unit of a firm / company opts to de-bond from EOU to EPCG
Scheme, while other unit(s) are DTA units, then the average export
obligation in respect of the authorisations issued to the firm / company
(other than de-bonding unit) shall remain unchanged and the average EO,
after de-bonding of the unit, shall be fixed by excluding the exports made by
the de-bonded unit from the total exports of the firm/ company, which runs
concurrently for all the units of the firm/ company.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.07', 7, '5.07 Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG
Scheme
(a)
An EOU/a relocated SEZ unit, while converting to a DTA Unit, may apply for
an EPCG authorisation along with documents prescribed.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.07', 8, '(c)
If a standalone EOU / SEZ unit wishes to de-bond from EOU to EPCG Scheme,
there shall be no requirement for maintenance of average export obligation
and the unit shall be required to maintain only specific export obligation
equivalent to six times of the proportionate duty saved amount of the
depreciated value of capital goods for which the Authorisation has been
obtained.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.07', 9, '(d)
In case one unit of a firm / company opts to de-bond from EOU to EPCG
Scheme, while other unit(s) are DTA units, then the average export
obligation in respect of the authorisations issued to the firm / company
(other than de-bonding unit) shall remain unchanged and the average EO,
after de-bonding of the unit, shall be fixed by excluding the exports made by
the de-bonded unit from the total exports of the firm/ company, which runs
concurrently for all the units of the firm/ company.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.07', 10, 'Run validation: (c) If a standalone EOU / SEZ unit wishes to de-bond from EOU to EPCG Scheme,
there shall be no requirement for maintenance of average export obligation
and the unit shall be required to maintain only specific export obligation
equivalent to six times of the proportionate duty saved amount of the
depreciated value of capital goods for which the Authorisation has been
obtained.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.07', 11, 'Run validation: (d) In case one unit of a firm / company opts to de-bond from EOU to EPCG
Scheme, while other unit(s) are DTA units, then the average export
obligation in respect of the authorisations issued to the firm / company
(other than de-bonding unit) shall remain unchanged and the average EO,
after de-bonding of the unit, shall be fixed by excluding the exports made by
the de-bonded unit from the total exports of the firm/ company, which runs
concurrently for all the units of the firm/ company.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.07', 12, 'Run validation: (c)
If a standalone EOU / SEZ unit wishes to de-bond from EOU to EPCG Scheme,
there shall be no requirement for maintenance of average export obligation
and the unit shall be required to maintain only specific export obligation
equivalent to six times of the proportionate duty saved amount of the
depreciated value of capital goods for which the Authorisation has been
obtained.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'SEZ');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'DTA');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'may');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'per');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'FTP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'EOU');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'six');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'has');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'one');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'are');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'all');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'Unit');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'with');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'from');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'same');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'keywords', 'only');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'tags', '5.07');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'tags', 'Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.07', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.08', 'Procurement from SEZ', '5.08 Procurement from SEZ
(a) If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.', 'Indha Procurement from SEZ section-la, 5.08 Procurement from SEZ
(a) If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.', '5.08 Procurement from SEZ
(a) If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”. The
"Certificate of supplies from SEZ" shall contain the following details:
(i) Name, Address and GSTIN of SEZ unit;
(ii) GSTIN & Address of recipient unit of EPCG authorisation holder
where capital goods would be installed;
(iii) Name, description including specifications, where applicable,
and quantity of items; and
(iv) Individual value of items to be procured. 4
4
5.08 Procurement from SEZ
(a)
If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.', 'Procurement from SEZ governs how DGFT business controls should be applied, validated, and enforced.', 'Procurement from SEZ explains the operating rule set that DEKAI should enforce. Key control points include The
"Certificate of supplies from SEZ" shall contain the following details:
(i) Name, Address and GSTIN of SEZ unit;
(ii) GSTIN & Address of recipient unit of EPCG authorisation holder
where capital goods would be installed;
(iii) Name, description including specifications, where applicable,
and quantity of items; and
(iv) Individual value of items to be procured. The section also drives actions such as 5.08 Procurement from SEZ
(a) If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”..', 'Indha Procurement from SEZ section-la, Procurement from SEZ explains the operating rule set that DEKAI should enforce. Key control points include The
"Certificate of supplies from SEZ" kandippa contain the following details:
(i) Name, Address and GSTIN of SEZ unit;
(ii) GSTIN & Address of recipient unit of EPCG authorisation holder
where capital goods would be installed;
(iii) Name, description including specifications, where applicable,
and quantity of items; and
(iv) Individual value of items to be procured. The section also drives actions such as 5.08 Procurement from SEZ
(a) If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”..', '5.08 Procurement from SEZ
(a) If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”. The
"Certificate of supplies from SEZ" shall contain the following details:
(i) Name, Address and GSTIN of SEZ unit;
(ii) GSTIN & Address of recipient unit of EPCG authorisation holder
where capital goods would be installed;
(iii) Name, description including specifications, where applicable,
and quantity of items; and
(iv) Individual value of items to be procured.
4
4
5.08 Procurement from SEZ
(a)
If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”. The
"Certificate of supplies from SEZ" shall contain the following details:
(i) Name, Address and GSTIN of SEZ unit;
(ii) GSTIN & Address of recipient unit of EPCG authorisation holder
where capital goods would be installed;
(iii) Name, description including specifications, where applicable,
and quantity of items; and
(iv) Individual value of items to be procured.
(b) The said “Certificate of supplies from SEZ" shall be marked in
quadruplicate with a copy each to the authorisation holder, SEZ supplier
unit, designated officer at SEZ and the relevant port customs authorities.
The above certificate shall be issued as an online amendment to the
authorisation and has to be transmitted.
(c) In cases where the request for issue of "Certificate of supplies from SEZ" is
made in due course, it shall be accompanied with an authorisation
utilization status issued by the relevant Customs authorities mentioned on
the authorisation for the RA to verify the actual utilization of authorisation
at the time of application. The certificate may be issued to the extent of
quantity available as per utilization status. In case the request for
"Certificate of supplies from SEZ" is made along with the application for
authorisation, the same procedure shall apply.', '[4, 5]', '["SEZ", "the", "for", "new", "may", "and", "iii", "has", "due", "per", "from", "made", "with", "SEZs", "item", "Name", "unit", "EPCG", "said", "copy"]', 'Support Procurement from SEZ processing and compliance validation.', '["5.08", "Procurement from SEZ", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_08-R001', '5.08', 'The
"Certificate of supplies from SEZ" shall contain the following details:
(i) Name, Address and GSTIN of SEZ unit;
(ii) GSTIN & Address of recipient unit of EPCG authorisation holder
where capital goods would be installed;
(iii) Name, description including specifications, where applicable,
and quantity of items; and
(iv) Individual value of items to be procured.', 'business_rule', 'Procurement from SEZ', '5.08 Procurement from SEZ
(a) If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.', '5.08 Procurement from SEZ
(a) If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.', '5.08 Procurement from SEZ
(a) If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.08 - Procurement from SEZ.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_08-R002', '5.08', '(b) The said “Certificate of supplies from SEZ" shall be marked in
quadruplicate with a copy each to the authorisation holder, SEZ supplier
unit, designated officer at SEZ and the relevant port customs authorities.', 'business_rule', 'Procurement from SEZ', 'The
"Certificate of supplies from SEZ" shall contain the following details:
(i) Name, Address and GSTIN of SEZ unit;
(ii) GSTIN & Address of recipient unit of EPCG authorisation holder
where capital goods would be installed;
(iii) Name, description including specifications, where applicable,
and quantity of items; and
(iv) Individual value of items to be procured.', 'The
"Certificate of supplies from SEZ" shall contain the following details:
(i) Name, Address and GSTIN of SEZ unit;
(ii) GSTIN & Address of recipient unit of EPCG authorisation holder
where capital goods would be installed;
(iii) Name, description including specifications, where applicable,
and quantity of items; and
(iv) Individual value of items to be procured.', '4
4
5.08 Procurement from SEZ
(a)
If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.08 - Procurement from SEZ.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_08-R003', '5.08', 'The above certificate shall be issued as an online amendment to the
authorisation and has to be transmitted.', 'business_rule', 'Procurement from SEZ', '4
4
5.08 Procurement from SEZ
(a)
If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.', '4
4
5.08 Procurement from SEZ
(a)
If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.', 'The above certificate shall be issued as an online amendment to the
authorisation and has to be transmitted.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.08 - Procurement from SEZ.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_08-R004', '5.08', '(c) In cases where the request for issue of "Certificate of supplies from SEZ" is
made in due course, it shall be accompanied with an authorisation
utilization status issued by the relevant Customs authorities mentioned on
the authorisation for the RA to verify the actual utilization of authorisation
at the time of application.', 'business_rule', 'Procurement from SEZ', '(b) The said “Certificate of supplies from SEZ" shall be marked in
quadruplicate with a copy each to the authorisation holder, SEZ supplier
unit, designated officer at SEZ and the relevant port customs authorities.', '(b) The said “Certificate of supplies from SEZ" shall be marked in
quadruplicate with a copy each to the authorisation holder, SEZ supplier
unit, designated officer at SEZ and the relevant port customs authorities.', '(c) In cases where the request for issue of "Certificate of supplies from SEZ" is
made in due course, it shall be accompanied with an authorisation
utilization status issued by the relevant Customs authorities mentioned on
the authorisation for the RA to verify the actual utilization of authorisation
at the time of application.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.08 - Procurement from SEZ.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_08-R005', '5.08', 'In case the request for
"Certificate of supplies from SEZ" is made along with the application for
authorisation, the same procedure shall apply.', 'business_rule', 'Procurement from SEZ', 'The above certificate shall be issued as an online amendment to the
authorisation and has to be transmitted.', 'The above certificate shall be issued as an online amendment to the
authorisation and has to be transmitted.', 'The certificate may be issued to the extent of
quantity available as per utilization status.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.08 - Procurement from SEZ.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.08', '5.08 Procurement from SEZ
(a) If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.08', 'The
"Certificate of supplies from SEZ" shall contain the following details:
(i) Name, Address and GSTIN of SEZ unit;
(ii) GSTIN & Address of recipient unit of EPCG authorisation holder
where capital goods would be installed;
(iii) Name, description including specifications, where applicable,
and quantity of items; and
(iv) Individual value of items to be procured.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.08', '4
4
5.08 Procurement from SEZ
(a)
If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.08', '(b) The said “Certificate of supplies from SEZ" shall be marked in
quadruplicate with a copy each to the authorisation holder, SEZ supplier
unit, designated officer at SEZ and the relevant port customs authorities.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.08', 'The above certificate shall be issued as an online amendment to the
authorisation and has to be transmitted.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.08', '(c) In cases where the request for issue of "Certificate of supplies from SEZ" is
made in due course, it shall be accompanied with an authorisation
utilization status issued by the relevant Customs authorities mentioned on
the authorisation for the RA to verify the actual utilization of authorisation
at the time of application.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.08', 'The certificate may be issued to the extent of
quantity available as per utilization status.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.08', 'In case the request for
"Certificate of supplies from SEZ" is made along with the application for
authorisation, the same procedure shall apply.');
INSERT INTO documents (section_code, document_name) VALUES ('5.08', '5.08 Procurement from SEZ
(a) If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.');
INSERT INTO documents (section_code, document_name) VALUES ('5.08', 'The
"Certificate of supplies from SEZ" shall contain the following details:
(i) Name, Address and GSTIN of SEZ unit;
(ii) GSTIN & Address of recipient unit of EPCG authorisation holder
where capital goods would be installed;
(iii) Name, description including specifications, where applicable,
and quantity of items; and
(iv) Individual value of items to be procured.');
INSERT INTO documents (section_code, document_name) VALUES ('5.08', '4
4
5.08 Procurement from SEZ
(a)
If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.');
INSERT INTO documents (section_code, document_name) VALUES ('5.08', '(b) The said “Certificate of supplies from SEZ" shall be marked in
quadruplicate with a copy each to the authorisation holder, SEZ supplier
unit, designated officer at SEZ and the relevant port customs authorities.');
INSERT INTO documents (section_code, document_name) VALUES ('5.08', 'The above certificate shall be issued as an online amendment to the
authorisation and has to be transmitted.');
INSERT INTO documents (section_code, document_name) VALUES ('5.08', '(c) In cases where the request for issue of "Certificate of supplies from SEZ" is
made in due course, it shall be accompanied with an authorisation
utilization status issued by the relevant Customs authorities mentioned on
the authorisation for the RA to verify the actual utilization of authorisation
at the time of application.');
INSERT INTO documents (section_code, document_name) VALUES ('5.08', 'The certificate may be issued to the extent of
quantity available as per utilization status.');
INSERT INTO documents (section_code, document_name) VALUES ('5.08', 'In case the request for
"Certificate of supplies from SEZ" is made along with the application for
authorisation, the same procedure shall apply.');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.08', 'RA');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.08', 'customs');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.08', '5.08 Procurement from SEZ
(a) If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.08', '4
4
5.08 Procurement from SEZ
(a)
If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.08', 1, 'Evaluate condition: 5.08 Procurement from SEZ
(a) If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.08', 2, 'Evaluate condition: The
"Certificate of supplies from SEZ" shall contain the following details:
(i) Name, Address and GSTIN of SEZ unit;
(ii) GSTIN & Address of recipient unit of EPCG authorisation holder
where capital goods would be installed;
(iii) Name, description including specifications, where applicable,
and quantity of items; and
(iv) Individual value of items to be procured.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.08', 3, 'Evaluate condition: 4
4
5.08 Procurement from SEZ
(a)
If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.08', 4, '5.08 Procurement from SEZ
(a) If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.08', 5, '4
4
5.08 Procurement from SEZ
(a)
If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.08', 6, 'The above certificate shall be issued as an online amendment to the
authorisation and has to be transmitted.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.08', 7, '(c) In cases where the request for issue of "Certificate of supplies from SEZ" is
made in due course, it shall be accompanied with an authorisation
utilization status issued by the relevant Customs authorities mentioned on
the authorisation for the RA to verify the actual utilization of authorisation
at the time of application.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.08', 8, 'The certificate may be issued to the extent of
quantity available as per utilization status.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.08', 9, 'In case the request for
"Certificate of supplies from SEZ" is made along with the application for
authorisation, the same procedure shall apply.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.08', 10, 'Run validation: 5.08 Procurement from SEZ
(a) If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.08', 11, 'Run validation: The
"Certificate of supplies from SEZ" shall contain the following details:
(i) Name, Address and GSTIN of SEZ unit;
(ii) GSTIN & Address of recipient unit of EPCG authorisation holder
where capital goods would be installed;
(iii) Name, description including specifications, where applicable,
and quantity of items; and
(iv) Individual value of items to be procured.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.08', 12, 'Run validation: 4
4
5.08 Procurement from SEZ
(a)
If the request is made along with the application for authorisation for
procurement of new Capital goods from SEZs, the RA may issue a
"Certificate of supplies from SEZ", containing the details for the requested
items after making the import item "Invalid for direct imports”.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'SEZ');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'new');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'may');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'iii');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'has');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'due');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'per');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'from');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'made');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'with');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'SEZs');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'item');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'Name');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'unit');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'said');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'keywords', 'copy');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'tags', '5.08');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'tags', 'Procurement from SEZ');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.08', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.09', 'Sourcing of Capital Goods Manufactured Indigenously', '5.09 Sourcing of Capital Goods Manufactured Indigenously
(a) EPCG authorisation holder intending to source capital goods manufactured
indigenously shall make a request to the RA for issuance of Invalidation
Letter or Advance Release Order (ARO).', 'Indha Sourcing of Capital Goods Manufactured Indigenously section-la, 5.09 Sourcing of Capital Goods Manufactured Indigenously
(a) EPCG authorisation holder intending to source capital goods manufactured
indigenously kandippa make a request to the RA for issuance of Invalidation
Letter or Advance Release Order (ARO).', '5.09 Sourcing of Capital Goods Manufactured Indigenously
(a) EPCG authorisation holder intending to source capital goods manufactured
indigenously shall make a request to the RA for issuance of Invalidation
Letter or Advance Release Order (ARO). (b) Deemed export benefits as given in paragraph 7.03 of FTP shall be
available. (c) This request can be made either along with application or during the
validity period of EPCG Authorisation.', 'Sourcing of Capital Goods Manufactured Indigenously governs how DGFT business controls should be applied, validated, and enforced.', 'Sourcing of Capital Goods Manufactured Indigenously explains the operating rule set that DEKAI should enforce. Key control points include 5.09 Sourcing of Capital Goods Manufactured Indigenously
(a) EPCG authorisation holder intending to source capital goods manufactured
indigenously shall make a request to the RA for issuance of Invalidation
Letter or Advance Release Order (ARO). The section also drives actions such as (e) RA concerned will issue the invalidation letter/ARO, in quadruplicate..', 'Indha Sourcing of Capital Goods Manufactured Indigenously section-la, Sourcing of Capital Goods Manufactured Indigenously explains the operating rule set that DEKAI should enforce. Key control points include 5.09 Sourcing of Capital Goods Manufactured Indigenously
(a) EPCG authorisation holder intending to source capital goods manufactured
indigenously kandippa make a request to the RA for issuance of Invalidation
Letter or Advance Release Order (ARO). The section also drives actions such as (e) RA concerned will issue the invalidation letter/ARO, in quadruplicate..', '5.09 Sourcing of Capital Goods Manufactured Indigenously
(a) EPCG authorisation holder intending to source capital goods manufactured
indigenously shall make a request to the RA for issuance of Invalidation
Letter or Advance Release Order (ARO).
(b) Deemed export benefits as given in paragraph 7.03 of FTP shall be
available.
(c) This request can be made either along with application or during the
validity period of EPCG Authorisation.
(d) Applicant shall give the name and address of the manufacturer(s) of
capital goods.
(e) RA concerned will issue the invalidation letter/ARO, in quadruplicate.
(f) Validity period of invalidation letter/ARO shall be co-terminous with the
validity period of EPCG authorisation.
5.09 Sourcing of Capital Goods Manufactured Indigenously
(a)
EPCG authorisation holder intending to source capital goods manufactured
indigenously shall make a request to the RA for issuance of Invalidation
Letter or Advance Release Order (ARO).
(b)
Deemed export benefits as given in paragraph 7.03 of FTP shall be
available.
(c)
This request can be made either along with application or during the
validity period of EPCG Authorisation.
(d)
Applicant shall give the name and address of the manufacturer(s) of
capital goods.
(e)
RA concerned will issue the invalidation letter/ARO, in quadruplicate.
(f)
Validity period of invalidation letter/ARO shall be co-terminous with the
validity period of EPCG authorisation.', '[5]', '["the", "for", "ARO", "FTP", "can", "and", "EPCG", "make", "This", "made", "with", "give", "name", "will", "Goods", "shall", "Order", "given", "along", "issue"]', 'Support Sourcing of Capital Goods Manufactured Indigenously processing and compliance validation.', '["5.09", "Sourcing of Capital Goods Manufactured Indigenously", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_09-R001', '5.09', '5.09 Sourcing of Capital Goods Manufactured Indigenously
(a) EPCG authorisation holder intending to source capital goods manufactured
indigenously shall make a request to the RA for issuance of Invalidation
Letter or Advance Release Order (ARO).', 'business_rule', 'Sourcing of Capital Goods Manufactured Indigenously', 'Section 5.09 is applicable', '5.09 Sourcing of Capital Goods Manufactured Indigenously
(a) EPCG authorisation holder intending to source capital goods manufactured
indigenously shall make a request to the RA for issuance of Invalidation
Letter or Advance Release Order (ARO).', '(e) RA concerned will issue the invalidation letter/ARO, in quadruplicate.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.09 - Sourcing of Capital Goods Manufactured Indigenously.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_09-R002', '5.09', '(b) Deemed export benefits as given in paragraph 7.03 of FTP shall be
available.', 'business_rule', 'Sourcing of Capital Goods Manufactured Indigenously', 'Section 5.09 is applicable', '(b) Deemed export benefits as given in paragraph 7.03 of FTP shall be
available.', '(e)
RA concerned will issue the invalidation letter/ARO, in quadruplicate.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.09 - Sourcing of Capital Goods Manufactured Indigenously.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_09-R003', '5.09', '(d) Applicant shall give the name and address of the manufacturer(s) of
capital goods.', 'business_rule', 'Sourcing of Capital Goods Manufactured Indigenously', 'Section 5.09 is applicable', '(d) Applicant shall give the name and address of the manufacturer(s) of
capital goods.', '(e)
RA concerned will issue the invalidation letter/ARO, in quadruplicate.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.09 - Sourcing of Capital Goods Manufactured Indigenously.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_09-R004', '5.09', '(f) Validity period of invalidation letter/ARO shall be co-terminous with the
validity period of EPCG authorisation.', 'business_rule', 'Sourcing of Capital Goods Manufactured Indigenously', 'Section 5.09 is applicable', '(f) Validity period of invalidation letter/ARO shall be co-terminous with the
validity period of EPCG authorisation.', '(e)
RA concerned will issue the invalidation letter/ARO, in quadruplicate.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.09 - Sourcing of Capital Goods Manufactured Indigenously.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_09-R005', '5.09', '5.09 Sourcing of Capital Goods Manufactured Indigenously
(a)
EPCG authorisation holder intending to source capital goods manufactured
indigenously shall make a request to the RA for issuance of Invalidation
Letter or Advance Release Order (ARO).', 'business_rule', 'Sourcing of Capital Goods Manufactured Indigenously', 'Section 5.09 is applicable', '5.09 Sourcing of Capital Goods Manufactured Indigenously
(a)
EPCG authorisation holder intending to source capital goods manufactured
indigenously shall make a request to the RA for issuance of Invalidation
Letter or Advance Release Order (ARO).', '(e)
RA concerned will issue the invalidation letter/ARO, in quadruplicate.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.09 - Sourcing of Capital Goods Manufactured Indigenously.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_09-R006', '5.09', '(b)
Deemed export benefits as given in paragraph 7.03 of FTP shall be
available.', 'business_rule', 'Sourcing of Capital Goods Manufactured Indigenously', 'Section 5.09 is applicable', '(b)
Deemed export benefits as given in paragraph 7.03 of FTP shall be
available.', '(e)
RA concerned will issue the invalidation letter/ARO, in quadruplicate.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.09 - Sourcing of Capital Goods Manufactured Indigenously.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_09-R007', '5.09', '(d)
Applicant shall give the name and address of the manufacturer(s) of
capital goods.', 'business_rule', 'Sourcing of Capital Goods Manufactured Indigenously', 'Section 5.09 is applicable', '(d)
Applicant shall give the name and address of the manufacturer(s) of
capital goods.', '(e)
RA concerned will issue the invalidation letter/ARO, in quadruplicate.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.09 - Sourcing of Capital Goods Manufactured Indigenously.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_09-R008', '5.09', '(f)
Validity period of invalidation letter/ARO shall be co-terminous with the
validity period of EPCG authorisation.', 'business_rule', 'Sourcing of Capital Goods Manufactured Indigenously', 'Section 5.09 is applicable', '(f)
Validity period of invalidation letter/ARO shall be co-terminous with the
validity period of EPCG authorisation.', '(e)
RA concerned will issue the invalidation letter/ARO, in quadruplicate.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.09 - Sourcing of Capital Goods Manufactured Indigenously.');
INSERT INTO documents (section_code, document_name) VALUES ('5.09', '(c) This request can be made either along with application or during the
validity period of EPCG Authorisation.');
INSERT INTO documents (section_code, document_name) VALUES ('5.09', '(c)
This request can be made either along with application or during the
validity period of EPCG Authorisation.');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.09', 'RA');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.09', 1, '(e) RA concerned will issue the invalidation letter/ARO, in quadruplicate.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.09', 2, '(e)
RA concerned will issue the invalidation letter/ARO, in quadruplicate.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.09', 3, 'Run validation: 5.09 Sourcing of Capital Goods Manufactured Indigenously
(a) EPCG authorisation holder intending to source capital goods manufactured
indigenously shall make a request to the RA for issuance of Invalidation
Letter or Advance Release Order (ARO).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.09', 4, 'Run validation: (b) Deemed export benefits as given in paragraph 7.03 of FTP shall be
available.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.09', 5, 'Run validation: (d) Applicant shall give the name and address of the manufacturer(s) of
capital goods.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'ARO');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'FTP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'can');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'make');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'This');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'made');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'with');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'give');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'name');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'will');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'Goods');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'shall');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'Order');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'given');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'along');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'keywords', 'issue');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'tags', '5.09');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'tags', 'Sourcing of Capital Goods Manufactured Indigenously');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.09', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.10', 'Conditions for fulfillment of Export Obligation', '5.10 Conditions for fulfillment of Export Obligation
In addition to conditions in paragraph 5.04 of FTP, the following conditions shall
also be applicable for fulfillment of export obligation:
(a) Name of the supporting manufacturer as well as the exporter shall be
indicated on export documents.', 'Indha Conditions for fulfillment of Export Obligation section-la, 5.10 Conditions for fulfillment of export Obligation
In addition to conditions in paragraph 5.04 of FTP, the following conditions kandippa
also be applicable for fulfillment of export obligation:
(a) Name of the supporting manufacturer as well as the exporter kandippa be
indicated on export documents.', '5.10 Conditions for fulfillment of Export Obligation
In addition to conditions in paragraph 5.04 of FTP, the following conditions shall
also be applicable for fulfillment of export obligation:
(a) Name of the supporting manufacturer as well as the exporter shall be
indicated on export documents. (b) In case the Authorisation holder wants to export through a third
party, export documents viz., shipping bills/Bill of exports etc. shall
indicate name of both authorisation holder and supporting
manufacturer, if any, along with EPCG authorisation number.', 'Conditions for fulfillment of Export Obligation governs how DGFT business controls should be applied, validated, and enforced.', 'Conditions for fulfillment of Export Obligation explains the operating rule set that DEKAI should enforce. Key control points include 5.10 Conditions for fulfillment of Export Obligation
In addition to conditions in paragraph 5.04 of FTP, the following conditions shall
also be applicable for fulfillment of export obligation:
(a) Name of the supporting manufacturer as well as the exporter shall be
indicated on export documents. The section also drives actions such as The above certificate shall be issued as an online amendment to the
authorisation and has to be transmitted..', 'Indha Conditions for fulfillment of Export Obligation section-la, Conditions for fulfillment of export Obligation explains the operating rule set that DEKAI should enforce. Key control points include 5.10 Conditions for fulfillment of export Obligation
In addition to conditions in paragraph 5.04 of FTP, the following conditions kandippa
also be applicable for fulfillment of export obligation:
(a) Name of the supporting manufacturer as well as the exporter kandippa be
indicated on export documents. The section also drives actions such as The above certificate kandippa be issued as an online amendment to the
authorisation and has to be transmitted..', '5.10 Conditions for fulfillment of Export Obligation
In addition to conditions in paragraph 5.04 of FTP, the following conditions shall
also be applicable for fulfillment of export obligation:
(a) Name of the supporting manufacturer as well as the exporter shall be
indicated on export documents.
(b) In case the Authorisation holder wants to export through a third
party, export documents viz., shipping bills/Bill of exports etc. shall
indicate name of both authorisation holder and supporting
manufacturer, if any, along with EPCG authorisation number.
Shipping bill/Bill of Export, GST invoice and e-BRC/ export
realisation from RBI’s EDPMS should be in the name of third party
exporter. The goods exported through third party should be
manufactured by the EPCG authorisation holder or the supporting
5
5
(b)
The said “Certificate of supplies from SEZ" shall be marked in
quadruplicate with a copy each to the authorisation holder, SEZ supplier
unit, designated officer at SEZ and the relevant port customs authorities.
The above certificate shall be issued as an online amendment to the
authorisation and has to be transmitted.
(c)
In cases where the request for issue of "Certificate of supplies from SEZ" is
made in due course, it shall be accompanied with an authorisation
utilization status issued by the relevant Customs authorities mentioned on
the authorisation for the RA to verify the actual utilization of authorisation
at the time of application. The certificate may be issued to the extent of
quantity available as per utilization status. In case the request for
"Certificate of supplies from SEZ" is made along with the application for
authorisation, the same procedure shall apply.
5.10 Conditions for fulfillment of Export Obligation
In addition to conditions in paragraph 5.04 of FTP, the following conditions shall
also be applicable for fulfillment of export obligation:
(a)
Name of the supporting manufacturer as well as the exporter shall be
indicated on export documents.
(b)
In case the Authorisation holder wants to export through a third
party, export documents viz., shipping bills/Bill of exports etc. shall
indicate name of both authorisation holder and supporting
manufacturer, if any, along with EPCG authorisation number.
Shipping bill/Bill of Export, GST invoice and e-BRC/ export
realisation from RBI’s EDPMS should be in the name of third party
exporter. The goods exported through third party should be
manufactured by the EPCG authorisation holder or the supporting
manufacturer where the capital goods imported under the
authorisation have been installed. The goods manufactured by the
authorisation holder shall be exported as it is by the ultimate
exporter (third party exporter) without further processing. Proceeds
realised through normal banking channel from third party exporter’s
account to the authorisation holder’s account on account of such
exports shall only be counted towards fulfillment of export obligation.
(c) Disclaimer certificate from third party that they shall not use such
proceeds towards EO fulfillment of any EPCG authorisation (s)
obtained by them.
(d) The EPCG authorisation holder shall submit the following additional
documents for discharge of EO through third party exporter(s):
(i) Proof of having dispatched the goods from authorisation
holder’s factory premises to the ultimate exporter/port of
export viz.
(a) ARE 1 certificate issued by Central Excise/Tax invoice for
export prescribed under the GST rules with due authentication
by the Customs verifying the exports along with the shipping
bill number, date and EPCG authorisation number, or
(b) Invoice duly incorporating the relevant EPCG
authorisation number & date at the time of dispatch in case the
unit is not registered with Central Excise/GST.
(ii) Lorry Receipt (LR) /Logistical evidence for transportation of
goods from the premises of the authorisation holder to the
third party exporter/Port of export.
(iii) An undertaking from the third party exporter on a stamp
paper, declaring that the products exported for fulfillment of
EO by them on behalf of the license holder as per details given
in the statement of exports, were manufactured by the license
holder.
(iv) Financial evidence for having received proceeds through
normal banking channel from third party exporter’s account to
the authorisation holder’s account on account of such exports
towards such third party supplies.
(v) Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.
6
6
manufacturer where the capital goods imported under the
authorisation have been installed. The goods manufactured by the
authorisation holder shall be exported as it is by the ultimate
exporter (third party exporter) without further processing. Proceeds
realised through normal banking channel from third party exporter’s
account to the authorisation holder’s account on account of such
exports shall only be counted towards fulfillment of export obligation.
(c)
Disclaimer certificate from third party that they shall not use such
proceeds towards EO fulfillment of any EPCG authorisation (s)
obtained by them.
(d)
The EPCG authorisation holder shall submit the following additional
documents for discharge of EO through third party exporter(s):
(i)
Proof of having dispatched the goods from authorisation
holder’s factory premises to the ultimate exporter/port of
export viz.
(a) ARE 1 certificate issued by Central Excise/Tax invoice for
export prescribed under the GST rules with due authentication
by the Customs verifying the exports along with the shipping
bill number, date and EPCG authorisation number, or
(b)
Invoice
duly
incorporating
the
relevant
EPCG
authorisation number & date at the time of dispatch in case the
unit is not registered with Central Excise/GST.
(ii)
Lorry Receipt (LR) /Logistical evidence for transportation of
goods from the premises of the authorisation holder to the
third party exporter/Port of export.
(iii)
An undertaking from the third party exporter on a stamp
paper, declaring that the products exported for fulfillment of
EO by them on behalf of the license holder as per details given
in the statement of exports, were manufactured by the license
holder.
(iv)
Financial evidence for having received proceeds through
normal banking channel from third party exporter’s account to
the authorisation holder’s account on account of such exports
towards such third party supplies.
(v)
Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.', '[5, 6]', '["for", "FTP", "the", "viz", "etc", "and", "any", "GST", "RBI", "SEZ", "has", "due", "may", "per", "not", "use", "ARE", "iii", "also", "Name"]', 'Support Conditions for fulfillment of Export Obligation processing and compliance validation.', '["5.10", "Conditions for fulfillment of Export Obligation", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_10-R001', '5.10', '5.10 Conditions for fulfillment of Export Obligation
In addition to conditions in paragraph 5.04 of FTP, the following conditions shall
also be applicable for fulfillment of export obligation:
(a) Name of the supporting manufacturer as well as the exporter shall be
indicated on export documents.', 'business_rule', 'Conditions for fulfillment of Export Obligation', '(b) In case the Authorisation holder wants to export through a third
party, export documents viz., shipping bills/Bill of exports etc.', '5.10 Conditions for fulfillment of Export Obligation
In addition to conditions in paragraph 5.04 of FTP, the following conditions shall
also be applicable for fulfillment of export obligation:
(a) Name of the supporting manufacturer as well as the exporter shall be
indicated on export documents.', 'The above certificate shall be issued as an online amendment to the
authorisation and has to be transmitted.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.10 - Conditions for fulfillment of Export Obligation.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_10-R002', '5.10', 'shall
indicate name of both authorisation holder and supporting
manufacturer, if any, along with EPCG authorisation number.', 'business_rule', 'Conditions for fulfillment of Export Obligation', 'any', 'shall
indicate name of both authorisation holder and supporting
manufacturer, if any, along with EPCG authorisation number.', '(c)
In cases where the request for issue of "Certificate of supplies from SEZ" is
made in due course, it shall be accompanied with an authorisation
utilization status issued by the relevant Customs authorities mentioned on
the authorisation for the RA to verify the actual utilization of authorisation
at the time of application.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.10 - Conditions for fulfillment of Export Obligation.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_10-R003', '5.10', 'Shipping bill/Bill of Export, GST invoice and e-BRC/ export
realisation from RBI’s EDPMS should be in the name of third party
exporter.', 'business_rule', 'Conditions for fulfillment of Export Obligation', 'The goods exported through third party should be
manufactured by the EPCG authorisation holder or the supporting
5
5
(b)
The said “Certificate of supplies from SEZ" shall be marked in
quadruplicate with a copy each to the authorisation holder, SEZ supplier
unit, designated officer at SEZ and the relevant port customs authorities.', 'The goods exported through third party should be
manufactured by the EPCG authorisation holder or the supporting
5
5
(b)
The said “Certificate of supplies from SEZ" shall be marked in
quadruplicate with a copy each to the authorisation holder, SEZ supplier
unit, designated officer at SEZ and the relevant port customs authorities.', 'The certificate may be issued to the extent of
quantity available as per utilization status.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.10 - Conditions for fulfillment of Export Obligation.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_10-R004', '5.10', 'The goods exported through third party should be
manufactured by the EPCG authorisation holder or the supporting
5
5
(b)
The said “Certificate of supplies from SEZ" shall be marked in
quadruplicate with a copy each to the authorisation holder, SEZ supplier
unit, designated officer at SEZ and the relevant port customs authorities.', 'business_rule', 'Conditions for fulfillment of Export Obligation', 'The above certificate shall be issued as an online amendment to the
authorisation and has to be transmitted.', 'The above certificate shall be issued as an online amendment to the
authorisation and has to be transmitted.', 'In case the request for
"Certificate of supplies from SEZ" is made along with the application for
authorisation, the same procedure shall apply.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.10 - Conditions for fulfillment of Export Obligation.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_10-R005', '5.10', 'The above certificate shall be issued as an online amendment to the
authorisation and has to be transmitted.', 'business_rule', 'Conditions for fulfillment of Export Obligation', '(c)
In cases where the request for issue of "Certificate of supplies from SEZ" is
made in due course, it shall be accompanied with an authorisation
utilization status issued by the relevant Customs authorities mentioned on
the authorisation for the RA to verify the actual utilization of authorisation
at the time of application.', '(c)
In cases where the request for issue of "Certificate of supplies from SEZ" is
made in due course, it shall be accompanied with an authorisation
utilization status issued by the relevant Customs authorities mentioned on
the authorisation for the RA to verify the actual utilization of authorisation
at the time of application.', '(c) Disclaimer certificate from third party that they shall not use such
proceeds towards EO fulfillment of any EPCG authorisation (s)
obtained by them.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.10 - Conditions for fulfillment of Export Obligation.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_10-R006', '5.10', '(c)
In cases where the request for issue of "Certificate of supplies from SEZ" is
made in due course, it shall be accompanied with an authorisation
utilization status issued by the relevant Customs authorities mentioned on
the authorisation for the RA to verify the actual utilization of authorisation
at the time of application.', 'business_rule', 'Conditions for fulfillment of Export Obligation', 'The certificate may be issued to the extent of
quantity available as per utilization status.', 'In case the request for
"Certificate of supplies from SEZ" is made along with the application for
authorisation, the same procedure shall apply.', '(d) The EPCG authorisation holder shall submit the following additional
documents for discharge of EO through third party exporter(s):
(i) Proof of having dispatched the goods from authorisation
holder’s factory premises to the ultimate exporter/port of
export viz.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.10 - Conditions for fulfillment of Export Obligation.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_10-R007', '5.10', 'In case the request for
"Certificate of supplies from SEZ" is made along with the application for
authorisation, the same procedure shall apply.', 'business_rule', 'Conditions for fulfillment of Export Obligation', 'In case the request for
"Certificate of supplies from SEZ" is made along with the application for
authorisation, the same procedure shall apply.', '5.10 Conditions for fulfillment of Export Obligation
In addition to conditions in paragraph 5.04 of FTP, the following conditions shall
also be applicable for fulfillment of export obligation:
(a)
Name of the supporting manufacturer as well as the exporter shall be
indicated on export documents.', '(a) ARE 1 certificate issued by Central Excise/Tax invoice for
export prescribed under the GST rules with due authentication
by the Customs verifying the exports along with the shipping
bill number, date and EPCG authorisation number, or
(b) Invoice duly incorporating the relevant EPCG
authorisation number & date at the time of dispatch in case the
unit is not registered with Central Excise/GST.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.10 - Conditions for fulfillment of Export Obligation.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_10-R008', '5.10', '5.10 Conditions for fulfillment of Export Obligation
In addition to conditions in paragraph 5.04 of FTP, the following conditions shall
also be applicable for fulfillment of export obligation:
(a)
Name of the supporting manufacturer as well as the exporter shall be
indicated on export documents.', 'business_rule', 'Conditions for fulfillment of Export Obligation', '(b)
In case the Authorisation holder wants to export through a third
party, export documents viz., shipping bills/Bill of exports etc.', 'The goods manufactured by the
authorisation holder shall be exported as it is by the ultimate
exporter (third party exporter) without further processing.', '(v) Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.10 - Conditions for fulfillment of Export Obligation.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_10-R009', '5.10', 'The goods exported through third party should be
manufactured by the EPCG authorisation holder or the supporting
manufacturer where the capital goods imported under the
authorisation have been installed.', 'business_rule', 'Conditions for fulfillment of Export Obligation', 'The goods exported through third party should be
manufactured by the EPCG authorisation holder or the supporting
manufacturer where the capital goods imported under the
authorisation have been installed.', 'Proceeds
realised through normal banking channel from third party exporter’s
account to the authorisation holder’s account on account of such
exports shall only be counted towards fulfillment of export obligation.', '(c)
Disclaimer certificate from third party that they shall not use such
proceeds towards EO fulfillment of any EPCG authorisation (s)
obtained by them.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.10 - Conditions for fulfillment of Export Obligation.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_10-R010', '5.10', 'The goods manufactured by the
authorisation holder shall be exported as it is by the ultimate
exporter (third party exporter) without further processing.', 'business_rule', 'Conditions for fulfillment of Export Obligation', '(c) Disclaimer certificate from third party that they shall not use such
proceeds towards EO fulfillment of any EPCG authorisation (s)
obtained by them.', '(c) Disclaimer certificate from third party that they shall not use such
proceeds towards EO fulfillment of any EPCG authorisation (s)
obtained by them.', '(d)
The EPCG authorisation holder shall submit the following additional
documents for discharge of EO through third party exporter(s):
(i)
Proof of having dispatched the goods from authorisation
holder’s factory premises to the ultimate exporter/port of
export viz.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.10 - Conditions for fulfillment of Export Obligation.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_10-R011', '5.10', 'Proceeds
realised through normal banking channel from third party exporter’s
account to the authorisation holder’s account on account of such
exports shall only be counted towards fulfillment of export obligation.', 'business_rule', 'Conditions for fulfillment of Export Obligation', '(a) ARE 1 certificate issued by Central Excise/Tax invoice for
export prescribed under the GST rules with due authentication
by the Customs verifying the exports along with the shipping
bill number, date and EPCG authorisation number, or
(b) Invoice duly incorporating the relevant EPCG
authorisation number & date at the time of dispatch in case the
unit is not registered with Central Excise/GST.', '(d) The EPCG authorisation holder shall submit the following additional
documents for discharge of EO through third party exporter(s):
(i) Proof of having dispatched the goods from authorisation
holder’s factory premises to the ultimate exporter/port of
export viz.', '(a) ARE 1 certificate issued by Central Excise/Tax invoice for
export prescribed under the GST rules with due authentication
by the Customs verifying the exports along with the shipping
bill number, date and EPCG authorisation number, or
(b)
Invoice
duly
incorporating
the
relevant
EPCG
authorisation number & date at the time of dispatch in case the
unit is not registered with Central Excise/GST.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.10 - Conditions for fulfillment of Export Obligation.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_10-R012', '5.10', '(c) Disclaimer certificate from third party that they shall not use such
proceeds towards EO fulfillment of any EPCG authorisation (s)
obtained by them.', 'business_rule', 'Conditions for fulfillment of Export Obligation', '(v) Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.', '(a) ARE 1 certificate issued by Central Excise/Tax invoice for
export prescribed under the GST rules with due authentication
by the Customs verifying the exports along with the shipping
bill number, date and EPCG authorisation number, or
(b) Invoice duly incorporating the relevant EPCG
authorisation number & date at the time of dispatch in case the
unit is not registered with Central Excise/GST.', '(v)
Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.10 - Conditions for fulfillment of Export Obligation.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_10-R013', '5.10', '(d) The EPCG authorisation holder shall submit the following additional
documents for discharge of EO through third party exporter(s):
(i) Proof of having dispatched the goods from authorisation
holder’s factory premises to the ultimate exporter/port of
export viz.', 'business_rule', 'Conditions for fulfillment of Export Obligation', '6
6
manufacturer where the capital goods imported under the
authorisation have been installed.', '(v) Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.', '(v)
Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.10 - Conditions for fulfillment of Export Obligation.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_10-R014', '5.10', '(v) Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.', 'business_rule', 'Conditions for fulfillment of Export Obligation', '(c)
Disclaimer certificate from third party that they shall not use such
proceeds towards EO fulfillment of any EPCG authorisation (s)
obtained by them.', '(c)
Disclaimer certificate from third party that they shall not use such
proceeds towards EO fulfillment of any EPCG authorisation (s)
obtained by them.', '(v)
Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.10 - Conditions for fulfillment of Export Obligation.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_10-R015', '5.10', '(c)
Disclaimer certificate from third party that they shall not use such
proceeds towards EO fulfillment of any EPCG authorisation (s)
obtained by them.', 'business_rule', 'Conditions for fulfillment of Export Obligation', '(a) ARE 1 certificate issued by Central Excise/Tax invoice for
export prescribed under the GST rules with due authentication
by the Customs verifying the exports along with the shipping
bill number, date and EPCG authorisation number, or
(b)
Invoice
duly
incorporating
the
relevant
EPCG
authorisation number & date at the time of dispatch in case the
unit is not registered with Central Excise/GST.', '(d)
The EPCG authorisation holder shall submit the following additional
documents for discharge of EO through third party exporter(s):
(i)
Proof of having dispatched the goods from authorisation
holder’s factory premises to the ultimate exporter/port of
export viz.', '(v)
Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.10 - Conditions for fulfillment of Export Obligation.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_10-R016', '5.10', '(d)
The EPCG authorisation holder shall submit the following additional
documents for discharge of EO through third party exporter(s):
(i)
Proof of having dispatched the goods from authorisation
holder’s factory premises to the ultimate exporter/port of
export viz.', 'business_rule', 'Conditions for fulfillment of Export Obligation', '(v)
Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.', '(a) ARE 1 certificate issued by Central Excise/Tax invoice for
export prescribed under the GST rules with due authentication
by the Customs verifying the exports along with the shipping
bill number, date and EPCG authorisation number, or
(b)
Invoice
duly
incorporating
the
relevant
EPCG
authorisation number & date at the time of dispatch in case the
unit is not registered with Central Excise/GST.', '(v)
Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.10 - Conditions for fulfillment of Export Obligation.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_10-R017', '5.10', '(v)
Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.', 'business_rule', 'Conditions for fulfillment of Export Obligation', '(v)
Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.', '(v)
Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.', '(v)
Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.10 - Conditions for fulfillment of Export Obligation.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.10', '(b) In case the Authorisation holder wants to export through a third
party, export documents viz., shipping bills/Bill of exports etc.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.10', 'shall
indicate name of both authorisation holder and supporting
manufacturer, if any, along with EPCG authorisation number.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.10', 'The goods exported through third party should be
manufactured by the EPCG authorisation holder or the supporting
5
5
(b)
The said “Certificate of supplies from SEZ" shall be marked in
quadruplicate with a copy each to the authorisation holder, SEZ supplier
unit, designated officer at SEZ and the relevant port customs authorities.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.10', 'The above certificate shall be issued as an online amendment to the
authorisation and has to be transmitted.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.10', '(c)
In cases where the request for issue of "Certificate of supplies from SEZ" is
made in due course, it shall be accompanied with an authorisation
utilization status issued by the relevant Customs authorities mentioned on
the authorisation for the RA to verify the actual utilization of authorisation
at the time of application.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.10', 'The certificate may be issued to the extent of
quantity available as per utilization status.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.10', 'In case the request for
"Certificate of supplies from SEZ" is made along with the application for
authorisation, the same procedure shall apply.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.10', '(b)
In case the Authorisation holder wants to export through a third
party, export documents viz., shipping bills/Bill of exports etc.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.10', 'The goods exported through third party should be
manufactured by the EPCG authorisation holder or the supporting
manufacturer where the capital goods imported under the
authorisation have been installed.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.10', '(c) Disclaimer certificate from third party that they shall not use such
proceeds towards EO fulfillment of any EPCG authorisation (s)
obtained by them.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.10', '(a) ARE 1 certificate issued by Central Excise/Tax invoice for
export prescribed under the GST rules with due authentication
by the Customs verifying the exports along with the shipping
bill number, date and EPCG authorisation number, or
(b) Invoice duly incorporating the relevant EPCG
authorisation number & date at the time of dispatch in case the
unit is not registered with Central Excise/GST.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.10', '(v) Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.10', '6
6
manufacturer where the capital goods imported under the
authorisation have been installed.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.10', '(c)
Disclaimer certificate from third party that they shall not use such
proceeds towards EO fulfillment of any EPCG authorisation (s)
obtained by them.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.10', '(a) ARE 1 certificate issued by Central Excise/Tax invoice for
export prescribed under the GST rules with due authentication
by the Customs verifying the exports along with the shipping
bill number, date and EPCG authorisation number, or
(b)
Invoice
duly
incorporating
the
relevant
EPCG
authorisation number & date at the time of dispatch in case the
unit is not registered with Central Excise/GST.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.10', '(v)
Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', '5.10 Conditions for fulfillment of Export Obligation
In addition to conditions in paragraph 5.04 of FTP, the following conditions shall
also be applicable for fulfillment of export obligation:
(a) Name of the supporting manufacturer as well as the exporter shall be
indicated on export documents.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', '(b) In case the Authorisation holder wants to export through a third
party, export documents viz., shipping bills/Bill of exports etc.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', 'Shipping bill/Bill');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', 'The goods exported through third party should be
manufactured by the EPCG authorisation holder or the supporting
5
5
(b)
The said “Certificate of supplies from SEZ" shall be marked in
quadruplicate with a copy each to the authorisation holder, SEZ supplier
unit, designated officer at SEZ and the relevant port customs authorities.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', 'The above certificate shall be issued as an online amendment to the
authorisation and has to be transmitted.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', '(c)
In cases where the request for issue of "Certificate of supplies from SEZ" is
made in due course, it shall be accompanied with an authorisation
utilization status issued by the relevant Customs authorities mentioned on
the authorisation for the RA to verify the actual utilization of authorisation
at the time of application.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', 'The certificate may be issued to the extent of
quantity available as per utilization status.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', 'In case the request for
"Certificate of supplies from SEZ" is made along with the application for
authorisation, the same procedure shall apply.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', '5.10 Conditions for fulfillment of Export Obligation
In addition to conditions in paragraph 5.04 of FTP, the following conditions shall
also be applicable for fulfillment of export obligation:
(a)
Name of the supporting manufacturer as well as the exporter shall be
indicated on export documents.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', '(b)
In case the Authorisation holder wants to export through a third
party, export documents viz., shipping bills/Bill of exports etc.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', '(c) Disclaimer certificate from third party that they shall not use such
proceeds towards EO fulfillment of any EPCG authorisation (s)
obtained by them.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', '(d) The EPCG authorisation holder shall submit the following additional
documents for discharge of EO through third party exporter(s):
(i) Proof of having dispatched the goods from authorisation
holder’s factory premises to the ultimate exporter/port of
export viz.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', '(a) ARE 1 certificate issued by Central Excise/Tax invoice for
export prescribed under the GST rules with due authentication
by the Customs verifying the exports along with the shipping
bill number, date and EPCG authorisation number, or
(b) Invoice duly incorporating the relevant EPCG
authorisation number & date at the time of dispatch in case the
unit is not registered with Central Excise/GST.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', '(iii) An undertaking from the third party exporter on a stamp
paper, declaring that the products exported for fulfillment of
EO by them on behalf of the license holder as per details given
in the statement of exports, were manufactured by the license
holder.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', '(v) Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', '(c)
Disclaimer certificate from third party that they shall not use such
proceeds towards EO fulfillment of any EPCG authorisation (s)
obtained by them.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', '(d)
The EPCG authorisation holder shall submit the following additional
documents for discharge of EO through third party exporter(s):
(i)
Proof of having dispatched the goods from authorisation
holder’s factory premises to the ultimate exporter/port of
export viz.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', '(a) ARE 1 certificate issued by Central Excise/Tax invoice for
export prescribed under the GST rules with due authentication
by the Customs verifying the exports along with the shipping
bill number, date and EPCG authorisation number, or
(b)
Invoice
duly
incorporating
the
relevant
EPCG
authorisation number & date at the time of dispatch in case the
unit is not registered with Central Excise/GST.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', '(iii)
An undertaking from the third party exporter on a stamp
paper, declaring that the products exported for fulfillment of
EO by them on behalf of the license holder as per details given
in the statement of exports, were manufactured by the license
holder.');
INSERT INTO documents (section_code, document_name) VALUES ('5.10', '(v)
Disclaimer certificate from third party exporter that they shall
not use such proceeds towards EO fulfillment of any EPCG
authorisation(s) obtained by them.');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.10', 'customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.10', 'RA');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.10', 1, 'Evaluate condition: (b) In case the Authorisation holder wants to export through a third
party, export documents viz., shipping bills/Bill of exports etc.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.10', 2, 'Evaluate condition: shall
indicate name of both authorisation holder and supporting
manufacturer, if any, along with EPCG authorisation number.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.10', 3, 'Evaluate condition: The goods exported through third party should be
manufactured by the EPCG authorisation holder or the supporting
5
5
(b)
The said “Certificate of supplies from SEZ" shall be marked in
quadruplicate with a copy each to the authorisation holder, SEZ supplier
unit, designated officer at SEZ and the relevant port customs authorities.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.10', 4, 'The above certificate shall be issued as an online amendment to the
authorisation and has to be transmitted.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.10', 5, '(c)
In cases where the request for issue of "Certificate of supplies from SEZ" is
made in due course, it shall be accompanied with an authorisation
utilization status issued by the relevant Customs authorities mentioned on
the authorisation for the RA to verify the actual utilization of authorisation
at the time of application.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.10', 6, 'The certificate may be issued to the extent of
quantity available as per utilization status.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.10', 7, 'In case the request for
"Certificate of supplies from SEZ" is made along with the application for
authorisation, the same procedure shall apply.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.10', 8, '(c) Disclaimer certificate from third party that they shall not use such
proceeds towards EO fulfillment of any EPCG authorisation (s)
obtained by them.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.10', 9, '(d) The EPCG authorisation holder shall submit the following additional
documents for discharge of EO through third party exporter(s):
(i) Proof of having dispatched the goods from authorisation
holder’s factory premises to the ultimate exporter/port of
export viz.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.10', 10, 'Run validation: 5.10 Conditions for fulfillment of Export Obligation
In addition to conditions in paragraph 5.04 of FTP, the following conditions shall
also be applicable for fulfillment of export obligation:
(a) Name of the supporting manufacturer as well as the exporter shall be
indicated on export documents.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.10', 11, 'Run validation: shall
indicate name of both authorisation holder and supporting
manufacturer, if any, along with EPCG authorisation number.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.10', 12, 'Run validation: The goods exported through third party should be
manufactured by the EPCG authorisation holder or the supporting
5
5
(b)
The said “Certificate of supplies from SEZ" shall be marked in
quadruplicate with a copy each to the authorisation holder, SEZ supplier
unit, designated officer at SEZ and the relevant port customs authorities.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'FTP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'viz');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'etc');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'any');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'GST');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'RBI');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'SEZ');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'has');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'due');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'may');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'per');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'not');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'use');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'ARE');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'iii');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'also');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'keywords', 'Name');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'tags', '5.10');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'tags', 'Conditions for fulfillment of Export Obligation');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.10', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.11', 'Realization of Export proceeds', '5.11 Realization of Export proceeds
Export proceeds shall be realized in freely convertible currency or in Indian
Rupees as per para 2.53 of FTP, except for Deemed Exports supplies under
Chapter-7 of FTP.', 'Indha Realization of Export proceeds section-la, 5.11 Realization of export proceeds
export proceeds kandippa be realized in freely convertible currency or in Indian
Rupees as per para 2.53 of FTP, except for Deemed Exports supplies under
Chapter-7 of FTP.', '5.11 Realization of Export proceeds
Export proceeds shall be realized in freely convertible currency or in Indian
Rupees as per para 2.53 of FTP, except for Deemed Exports supplies under
Chapter-7 of FTP. Exports to SEZ units/Supplies to developers/co-developers
irrespective of currency of realization would also be counted for discharge of
Export Obligation. Realization in case of supplies to SEZ units shall be from foreign
currency account of the SEZ unit.', 'Realization of Export proceeds governs how DGFT business controls should be applied, validated, and enforced.', 'Realization of Export proceeds explains the operating rule set that DEKAI should enforce. Key control points include 5.11 Realization of Export proceeds
Export proceeds shall be realized in freely convertible currency or in Indian
Rupees as per para 2.53 of FTP, except for Deemed Exports supplies under
Chapter-7 of FTP.', 'Indha Realization of Export proceeds section-la, Realization of export proceeds explains the operating rule set that DEKAI should enforce. Key control points include 5.11 Realization of export proceeds
export proceeds kandippa be realized in freely convertible currency or in Indian
Rupees as per para 2.53 of FTP, except for Deemed Exports supplies under
Chapter-7 of FTP.', '5.11 Realization of Export proceeds
Export proceeds shall be realized in freely convertible currency or in Indian
Rupees as per para 2.53 of FTP, except for Deemed Exports supplies under
Chapter-7 of FTP. Exports to SEZ units/Supplies to developers/co-developers
irrespective of currency of realization would also be counted for discharge of
Export Obligation. Realization in case of supplies to SEZ units shall be from foreign
currency account of the SEZ unit.', '[7]', '["per", "FTP", "for", "SEZ", "the", "para", "also", "case", "from", "unit", "shall", "under", "would", "units", "Export", "freely", "Indian", "Rupees", "except", "Deemed"]', 'Provide knowledge guidance for Realization of Export proceeds.', '["5.11", "Realization of Export proceeds", "business-rule", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_11-R001', '5.11', '5.11 Realization of Export proceeds
Export proceeds shall be realized in freely convertible currency or in Indian
Rupees as per para 2.53 of FTP, except for Deemed Exports supplies under
Chapter-7 of FTP.', 'business_rule', 'Realization of Export proceeds', 'Realization in case of supplies to SEZ units shall be from foreign
currency account of the SEZ unit.', '5.11 Realization of Export proceeds
Export proceeds shall be realized in freely convertible currency or in Indian
Rupees as per para 2.53 of FTP, except for Deemed Exports supplies under
Chapter-7 of FTP.', 'Manual review required.', '5.11 Realization of Export proceeds
Export proceeds shall be realized in freely convertible currency or in Indian
Rupees as per para 2.53 of FTP, except for Deemed Exports supplies under
Chapter-7 of FTP.', 'DEKAI should produce a compliance decision for 5.11 - Realization of Export proceeds.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_11-R002', '5.11', 'Realization in case of supplies to SEZ units shall be from foreign
currency account of the SEZ unit.', 'business_rule', 'Realization of Export proceeds', 'Realization in case of supplies to SEZ units shall be from foreign
currency account of the SEZ unit.', 'Realization in case of supplies to SEZ units shall be from foreign
currency account of the SEZ unit.', 'Manual review required.', '5.11 Realization of Export proceeds
Export proceeds shall be realized in freely convertible currency or in Indian
Rupees as per para 2.53 of FTP, except for Deemed Exports supplies under
Chapter-7 of FTP.', 'DEKAI should produce a compliance decision for 5.11 - Realization of Export proceeds.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.11', 'Realization in case of supplies to SEZ units shall be from foreign
currency account of the SEZ unit.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('5.11', '5.11 Realization of Export proceeds
Export proceeds shall be realized in freely convertible currency or in Indian
Rupees as per para 2.53 of FTP, except for Deemed Exports supplies under
Chapter-7 of FTP.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.11', 1, 'Evaluate condition: Realization in case of supplies to SEZ units shall be from foreign
currency account of the SEZ unit.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.11', 2, 'Run validation: 5.11 Realization of Export proceeds
Export proceeds shall be realized in freely convertible currency or in Indian
Rupees as per para 2.53 of FTP, except for Deemed Exports supplies under
Chapter-7 of FTP.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.11', 3, 'Run validation: Realization in case of supplies to SEZ units shall be from foreign
currency account of the SEZ unit.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.11', 4, 'Handle exception: 5.11 Realization of Export proceeds
Export proceeds shall be realized in freely convertible currency or in Indian
Rupees as per para 2.53 of FTP, except for Deemed Exports supplies under
Chapter-7 of FTP.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'per');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'FTP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'SEZ');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'para');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'also');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'case');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'from');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'unit');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'shall');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'under');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'would');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'units');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'Export');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'freely');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'Indian');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'Rupees');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'except');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'keywords', 'Deemed');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'tags', '5.11');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'tags', 'Realization of Export proceeds');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.11', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.12', 'Calculation of Average Export Obligation', '5.12 Calculation of Average Export Obligation
While calculating Average Export Obligation, exports counted/being counted for
fulfilling specific EO against EPCG Authorisations within valid EO Period (whether
original or extended) that have been made in the preceding 3 years will not be
taken into account.', 'Indha Calculation of Average Export Obligation section-la, 5.12 Calculation of Average export Obligation
While calculating Average export Obligation, exports counted/being counted for
fulfilling specific EO against EPCG Authorisations within valid EO Period (whether
original or extended) that have been made in the preceding 3 years will not be
taken into account.', '5.12 Calculation of Average Export Obligation
While calculating Average Export Obligation, exports counted/being counted for
fulfilling specific EO against EPCG Authorisations within valid EO Period (whether
original or extended) that have been made in the preceding 3 years will not be
taken into account.', '5.12 Calculation of Average Export Obligation
While calculating Average Export Obligation, exports counted/being counted for
fulfilling specific EO against EPCG Authorisations within valid EO Period (whether
original or extended) that have been made in the preceding 3 years will not be
taken into account.', '5.12 Calculation of Average Export Obligation
While calculating Average Export Obligation, exports counted/being counted for
fulfilling specific EO against EPCG Authorisations within valid EO Period (whether
original or extended) that have been made in the preceding 3 years will not be
taken into account.', 'Indha Calculation of Average Export Obligation section-la, 5.12 Calculation of Average export Obligation
While calculating Average export Obligation, exports counted/being counted for
fulfilling specific EO against EPCG Authorisations within valid EO Period (whether
original or extended) that have been made in the preceding 3 years will not be
taken into account.', '5.12 Calculation of Average Export Obligation
While calculating Average Export Obligation, exports counted/being counted for
fulfilling specific EO against EPCG Authorisations within valid EO Period (whether
original or extended) that have been made in the preceding 3 years will not be
taken into account.', '[7]', '["for", "the", "not", "EPCG", "that", "have", "been", "made", "will", "into", "While", "valid", "years", "taken", "Export", "within", "Period", "Average", "exports", "counted"]', 'Provide knowledge guidance for Calculation of Average Export Obligation.', '["5.12", "Calculation of Average Export Obligation", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_12-R001', '5.12', '5.12 Calculation of Average Export Obligation
While calculating Average Export Obligation, exports counted/being counted for
fulfilling specific EO against EPCG Authorisations within valid EO Period (whether
original or extended) that have been made in the preceding 3 years will not be
taken into account.', 'business_rule', 'Calculation of Average Export Obligation', '5.12 Calculation of Average Export Obligation
While calculating Average Export Obligation, exports counted/being counted for
fulfilling specific EO against EPCG Authorisations within valid EO Period (whether
original or extended) that have been made in the preceding 3 years will not be
taken into account.', 'Not explicitly covered in uploaded documents.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.12 - Calculation of Average Export Obligation.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.12', '5.12 Calculation of Average Export Obligation
While calculating Average Export Obligation, exports counted/being counted for
fulfilling specific EO against EPCG Authorisations within valid EO Period (whether
original or extended) that have been made in the preceding 3 years will not be
taken into account.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.12', '5.12 Calculation of Average Export Obligation
While calculating Average Export Obligation, exports counted/being counted for
fulfilling specific EO against EPCG Authorisations within valid EO Period (whether
original or extended) that have been made in the preceding 3 years will not be
taken into account.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.12', 1, 'Evaluate condition: 5.12 Calculation of Average Export Obligation
While calculating Average Export Obligation, exports counted/being counted for
fulfilling specific EO against EPCG Authorisations within valid EO Period (whether
original or extended) that have been made in the preceding 3 years will not be
taken into account.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'not');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'that');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'have');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'been');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'made');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'will');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'into');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'While');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'valid');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'years');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'taken');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'Export');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'within');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'Period');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'Average');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'exports');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'keywords', 'counted');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'tags', '5.12');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'tags', 'Calculation of Average Export Obligation');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.12', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.13', 'Block-wise Fulfillment of EO', '5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
(b) The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.', 'Indha Block-wise Fulfillment of EO section-la, 5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme kandippa, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
(b) The Authorisation holder would intimate the Regional authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.', '5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
(b) The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block. (c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 5,000
More than ₹2 Crores to 10 Crores 10,000
Above ₹10 Crores 15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
7
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 5,000 |
More than ₹2 Crores to 10 Crores 10,000 |
Above ₹10 Crores 15,000 |
7
5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
(b)
The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block. (c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
5,000
More than ₹2 Crores to 10 Crores
10,000
Above ₹10 Crores
15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
Period from the date of issue
of Authorisation
Minimum export
obligation to be fulfilled
Block of 1st to 4th year
50%
Balance EO
Block of 5th and 6th year
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 10,000
More than ₹2 Crores to 10 Crores 20,000
Above ₹10 Crores 30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 15,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 45,000
No refund of earlier paid Composition Fee shall be admissible.', 'Block-wise Fulfillment of EO governs how DGFT business controls should be applied, validated, and enforced.', 'Block-wise Fulfillment of EO explains the operating rule set that DEKAI should enforce. Key control points include 5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
(b) The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block. The section also drives actions such as 5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
(b) The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block..', 'Indha Block-wise Fulfillment of EO section-la, Block-wise Fulfillment of EO explains the operating rule set that DEKAI should enforce. Key control points include 5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme kandippa, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
(b) The Authorisation holder would intimate the Regional authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block. The section also drives actions such as 5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme kandippa, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
(b) The Authorisation holder would intimate the Regional authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block..', '5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
(b) The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.
(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 5,000
More than ₹2 Crores to 10 Crores 10,000
Above ₹10 Crores 15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
7
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 5,000 |
More than ₹2 Crores to 10 Crores 10,000 |
Above ₹10 Crores 15,000 |
7
5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
(b)
The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.
(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
5,000
More than ₹2 Crores to 10 Crores
10,000
Above ₹10 Crores
15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
Period from the date of issue
of Authorisation
Minimum export
obligation to be fulfilled
Block of 1st to 4th year
50%
Balance EO
Block of 5th and 6th year
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 10,000
More than ₹2 Crores to 10 Crores 20,000
Above ₹10 Crores 30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 15,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 45,000
No refund of earlier paid Composition Fee shall be admissible.
Where EO of the first block is not fulfilled in terms of para (a) above, except
in cases where the EO prescribed for first block is extended by the RA, the
Authorisation holder shall, within 6 months from the expiry of the block,
pay duties of customs (along with applicable interest as notified by DOR)
proportionate to duty saved amount on total unfulfilled EO of the first block..
(d) (i) Authorisations issued from 1st April, 2002 upto 31st August, 2004
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-02)
as amended from time to time.
(ii) Authorisations issued from 1st September, 2004 upto 17th April, 2013
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-12) as
amended till 17.04.2013.
(iii) Authorisations issued from 18th April, 2013 till issue of Notification
of FTP 2015-20 shall be governed by provisions of paragraph 5.8 of HBP Vol. 1
as amended vide PN No. 1 dated 18.04.2013.
(iv) Authorisations issued from 1st April, 2015 till 4th December, 2017
shall be governed by provisions of paragraph 5.14 of HBP as amended vide PN
No. 1 dated 01.04.2015.
i. Para 5.13(c) amended vide Public Notice No. 15/2024-25 dated 25.07.2024.
8
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 10,000 |
More than ₹2 Crores to 10 Crores 20,000 |
Above ₹10 Crores 30,000 |
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 15,000 |
More than ₹2 Crores to 10 Crores 30,000 |
Above ₹10 Crores 45,000 |
8
composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
10,000
More than ₹2 Crores to 10 Crores
20,000
Above ₹10 Crores
30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
15,000
More than ₹2 Crores to 10 Crores
30,000
Above ₹10 Crores
45,000
No refund of earlier paid Composition Fee shall be admissible.
Where EO of the first block is not fulfilled in terms of para (a) above, except
in cases where the EO prescribed for first block is extended by the RA, the
Authorisation holder shall, within 6 months from the expiry of the block,
pay duties of customs (along with applicable interest as notified by DOR)
proportionate to duty saved amount on total unfulfilled EO of the first block..
(d)
(i) Authorisations issued from 1st April, 2002 upto 31st August, 2004
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-02)
as amended from time to time.
(ii)
Authorisations issued from 1st September, 2004 upto 17th April, 2013
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-12) as
amended till 17.04.2013.
(iii)
Authorisations issued from 18th April, 2013 till issue of Notification
of FTP 2015-20 shall be governed by provisions of paragraph 5.8 of HBP Vol. 1
as amended vide PN No. 1 dated 18.04.2013.
(iv)
Authorisations issued from 1st April, 2015 till 4th December, 2017
shall be governed by provisions of paragraph 5.14 of HBP as amended vide PN
No. 1 dated 01.04.2015.
i.
Para 5.13(c) amended vide Public Notice No. 15/2024-25 dated 25.07.2024.
(v) Authorisations issued from 5th December, 2017 till 31st March 2023
shall be governed by provisions of paragraph 5.14 of HBP as amended vide PN
No. 43 dated 05.12.2017.
(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', '[7, 8, 9]', '["The", "and", "for", "fee", "may", "but", "not", "pay", "DOR", "HBP", "Vol", "RE-", "iii", "FTP", "EPCG", "over", "from", "date", "year", "well"]', 'Support Block-wise Fulfillment of EO processing and compliance validation.', '["5.13", "Block-wise Fulfillment of EO", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_13-R001', '5.13', '5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
(b) The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.', 'business_rule', 'Block-wise Fulfillment of EO', '5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
(b) The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.', '5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
(b) The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.', '5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
(b) The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.', '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 5,000
More than ₹2 Crores to 10 Crores 10,000
Above ₹10 Crores 15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
7
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 5,000 |
More than ₹2 Crores to 10 Crores 10,000 |
Above ₹10 Crores 15,000 |
7
5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
(b)
The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.', 'DEKAI should produce a compliance decision for 5.13 - Block-wise Fulfillment of EO.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_13-R002', '5.13', '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 5,000
More than ₹2 Crores to 10 Crores 10,000
Above ₹10 Crores 15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
7
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 5,000 |
More than ₹2 Crores to 10 Crores 10,000 |
Above ₹10 Crores 15,000 |
7
5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
(b)
The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.', 'business_rule', 'Block-wise Fulfillment of EO', '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 5,000
More than ₹2 Crores to 10 Crores 10,000
Above ₹10 Crores 15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
7
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 5,000 |
More than ₹2 Crores to 10 Crores 10,000 |
Above ₹10 Crores 15,000 |
7
5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
(b)
The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.', '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 5,000
More than ₹2 Crores to 10 Crores 10,000
Above ₹10 Crores 15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
7
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 5,000 |
More than ₹2 Crores to 10 Crores 10,000 |
Above ₹10 Crores 15,000 |
7
5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
(b)
The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.', '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 5,000
More than ₹2 Crores to 10 Crores 10,000
Above ₹10 Crores 15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
7
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 5,000 |
More than ₹2 Crores to 10 Crores 10,000 |
Above ₹10 Crores 15,000 |
7
5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
(b)
The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.', '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
5,000
More than ₹2 Crores to 10 Crores
10,000
Above ₹10 Crores
15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
Period from the date of issue
of Authorisation
Minimum export
obligation to be fulfilled
Block of 1st to 4th year
50%
Balance EO
Block of 5th and 6th year
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 10,000
More than ₹2 Crores to 10 Crores 20,000
Above ₹10 Crores 30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 15,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 45,000
No refund of earlier paid Composition Fee shall be admissible.', 'DEKAI should produce a compliance decision for 5.13 - Block-wise Fulfillment of EO.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_13-R003', '5.13', '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
5,000
More than ₹2 Crores to 10 Crores
10,000
Above ₹10 Crores
15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
Period from the date of issue
of Authorisation
Minimum export
obligation to be fulfilled
Block of 1st to 4th year
50%
Balance EO
Block of 5th and 6th year
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 10,000
More than ₹2 Crores to 10 Crores 20,000
Above ₹10 Crores 30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 15,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 45,000
No refund of earlier paid Composition Fee shall be admissible.', 'business_rule', 'Block-wise Fulfillment of EO', '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
5,000
More than ₹2 Crores to 10 Crores
10,000
Above ₹10 Crores
15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
Period from the date of issue
of Authorisation
Minimum export
obligation to be fulfilled
Block of 1st to 4th year
50%
Balance EO
Block of 5th and 6th year
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 10,000
More than ₹2 Crores to 10 Crores 20,000
Above ₹10 Crores 30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 15,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 45,000
No refund of earlier paid Composition Fee shall be admissible.', '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
5,000
More than ₹2 Crores to 10 Crores
10,000
Above ₹10 Crores
15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
Period from the date of issue
of Authorisation
Minimum export
obligation to be fulfilled
Block of 1st to 4th year
50%
Balance EO
Block of 5th and 6th year
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 10,000
More than ₹2 Crores to 10 Crores 20,000
Above ₹10 Crores 30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 15,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 45,000
No refund of earlier paid Composition Fee shall be admissible.', '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
5,000
More than ₹2 Crores to 10 Crores
10,000
Above ₹10 Crores
15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
Period from the date of issue
of Authorisation
Minimum export
obligation to be fulfilled
Block of 1st to 4th year
50%
Balance EO
Block of 5th and 6th year
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 10,000
More than ₹2 Crores to 10 Crores 20,000
Above ₹10 Crores 30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 15,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 45,000
No refund of earlier paid Composition Fee shall be admissible.', 'Where EO of the first block is not fulfilled in terms of para (a) above, except
in cases where the EO prescribed for first block is extended by the RA, the
Authorisation holder shall, within 6 months from the expiry of the block,
pay duties of customs (along with applicable interest as notified by DOR)
proportionate to duty saved amount on total unfulfilled EO of the first block..', 'DEKAI should produce a compliance decision for 5.13 - Block-wise Fulfillment of EO.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_13-R004', '5.13', 'Where EO of the first block is not fulfilled in terms of para (a) above, except
in cases where the EO prescribed for first block is extended by the RA, the
Authorisation holder shall, within 6 months from the expiry of the block,
pay duties of customs (along with applicable interest as notified by DOR)
proportionate to duty saved amount on total unfulfilled EO of the first block..', 'business_rule', 'Block-wise Fulfillment of EO', 'Where EO of the first block is not fulfilled in terms of para (a) above, except
in cases where the EO prescribed for first block is extended by the RA, the
Authorisation holder shall, within 6 months from the expiry of the block,
pay duties of customs (along with applicable interest as notified by DOR)
proportionate to duty saved amount on total unfulfilled EO of the first block..', 'Where EO of the first block is not fulfilled in terms of para (a) above, except
in cases where the EO prescribed for first block is extended by the RA, the
Authorisation holder shall, within 6 months from the expiry of the block,
pay duties of customs (along with applicable interest as notified by DOR)
proportionate to duty saved amount on total unfulfilled EO of the first block..', 'Where EO of the first block is not fulfilled in terms of para (a) above, except
in cases where the EO prescribed for first block is extended by the RA, the
Authorisation holder shall, within 6 months from the expiry of the block,
pay duties of customs (along with applicable interest as notified by DOR)
proportionate to duty saved amount on total unfulfilled EO of the first block..', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.13 - Block-wise Fulfillment of EO.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_13-R005', '5.13', '(d) (i) Authorisations issued from 1st April, 2002 upto 31st August, 2004
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-02)
as amended from time to time.', 'business_rule', 'Block-wise Fulfillment of EO', '(iii) Authorisations issued from 18th April, 2013 till issue of Notification
of FTP 2015-20 shall be governed by provisions of paragraph 5.8 of HBP Vol.', '(d) (i) Authorisations issued from 1st April, 2002 upto 31st August, 2004
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-02)
as amended from time to time.', '(d) (i) Authorisations issued from 1st April, 2002 upto 31st August, 2004
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-02)
as amended from time to time.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.13 - Block-wise Fulfillment of EO.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_13-R006', '5.13', '(ii) Authorisations issued from 1st September, 2004 upto 17th April, 2013
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-12) as
amended till 17.04.2013.', 'business_rule', 'Block-wise Fulfillment of EO', '(iii)
Authorisations issued from 18th April, 2013 till issue of Notification
of FTP 2015-20 shall be governed by provisions of paragraph 5.8 of HBP Vol.', '(ii) Authorisations issued from 1st September, 2004 upto 17th April, 2013
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-12) as
amended till 17.04.2013.', '(ii) Authorisations issued from 1st September, 2004 upto 17th April, 2013
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-12) as
amended till 17.04.2013.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.13 - Block-wise Fulfillment of EO.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_13-R007', '5.13', '(iii) Authorisations issued from 18th April, 2013 till issue of Notification
of FTP 2015-20 shall be governed by provisions of paragraph 5.8 of HBP Vol.', 'business_rule', 'Block-wise Fulfillment of EO', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', '(iii) Authorisations issued from 18th April, 2013 till issue of Notification
of FTP 2015-20 shall be governed by provisions of paragraph 5.8 of HBP Vol.', '(iii) Authorisations issued from 18th April, 2013 till issue of Notification
of FTP 2015-20 shall be governed by provisions of paragraph 5.8 of HBP Vol.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.13 - Block-wise Fulfillment of EO.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_13-R008', '5.13', '(iv) Authorisations issued from 1st April, 2015 till 4th December, 2017
shall be governed by provisions of paragraph 5.14 of HBP as amended vide PN
No.', 'business_rule', 'Block-wise Fulfillment of EO', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', '(iv) Authorisations issued from 1st April, 2015 till 4th December, 2017
shall be governed by provisions of paragraph 5.14 of HBP as amended vide PN
No.', '1
as amended vide PN No.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.13 - Block-wise Fulfillment of EO.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_13-R009', '5.13', '8
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 10,000 |
More than ₹2 Crores to 10 Crores 20,000 |
Above ₹10 Crores 30,000 |
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 15,000 |
More than ₹2 Crores to 10 Crores 30,000 |
Above ₹10 Crores 45,000 |
8
composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
10,000
More than ₹2 Crores to 10 Crores
20,000
Above ₹10 Crores
30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
15,000
More than ₹2 Crores to 10 Crores
30,000
Above ₹10 Crores
45,000
No refund of earlier paid Composition Fee shall be admissible.', 'business_rule', 'Block-wise Fulfillment of EO', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', '8
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 10,000 |
More than ₹2 Crores to 10 Crores 20,000 |
Above ₹10 Crores 30,000 |
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 15,000 |
More than ₹2 Crores to 10 Crores 30,000 |
Above ₹10 Crores 45,000 |
8
composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
10,000
More than ₹2 Crores to 10 Crores
20,000
Above ₹10 Crores
30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
15,000
More than ₹2 Crores to 10 Crores
30,000
Above ₹10 Crores
45,000
No refund of earlier paid Composition Fee shall be admissible.', '(iv) Authorisations issued from 1st April, 2015 till 4th December, 2017
shall be governed by provisions of paragraph 5.14 of HBP as amended vide PN
No.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.13 - Block-wise Fulfillment of EO.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_13-R010', '5.13', '(d)
(i) Authorisations issued from 1st April, 2002 upto 31st August, 2004
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-02)
as amended from time to time.', 'business_rule', 'Block-wise Fulfillment of EO', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', '(d)
(i) Authorisations issued from 1st April, 2002 upto 31st August, 2004
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-02)
as amended from time to time.', 'Para 5.13(c) amended vide Public Notice No.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.13 - Block-wise Fulfillment of EO.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_13-R011', '5.13', '(ii)
Authorisations issued from 1st September, 2004 upto 17th April, 2013
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-12) as
amended till 17.04.2013.', 'business_rule', 'Block-wise Fulfillment of EO', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', '(ii)
Authorisations issued from 1st September, 2004 upto 17th April, 2013
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-12) as
amended till 17.04.2013.', '8
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 10,000 |
More than ₹2 Crores to 10 Crores 20,000 |
Above ₹10 Crores 30,000 |
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 15,000 |
More than ₹2 Crores to 10 Crores 30,000 |
Above ₹10 Crores 45,000 |
8
composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
10,000
More than ₹2 Crores to 10 Crores
20,000
Above ₹10 Crores
30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
15,000
More than ₹2 Crores to 10 Crores
30,000
Above ₹10 Crores
45,000
No refund of earlier paid Composition Fee shall be admissible.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.13 - Block-wise Fulfillment of EO.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_13-R012', '5.13', '(iii)
Authorisations issued from 18th April, 2013 till issue of Notification
of FTP 2015-20 shall be governed by provisions of paragraph 5.8 of HBP Vol.', 'business_rule', 'Block-wise Fulfillment of EO', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', '(iii)
Authorisations issued from 18th April, 2013 till issue of Notification
of FTP 2015-20 shall be governed by provisions of paragraph 5.8 of HBP Vol.', '(d)
(i) Authorisations issued from 1st April, 2002 upto 31st August, 2004
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-02)
as amended from time to time.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.13 - Block-wise Fulfillment of EO.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_13-R013', '5.13', '(iv)
Authorisations issued from 1st April, 2015 till 4th December, 2017
shall be governed by provisions of paragraph 5.14 of HBP as amended vide PN
No.', 'business_rule', 'Block-wise Fulfillment of EO', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', '(iv)
Authorisations issued from 1st April, 2015 till 4th December, 2017
shall be governed by provisions of paragraph 5.14 of HBP as amended vide PN
No.', '(ii)
Authorisations issued from 1st September, 2004 upto 17th April, 2013
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-12) as
amended till 17.04.2013.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.13 - Block-wise Fulfillment of EO.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_13-R014', '5.13', '(v) Authorisations issued from 5th December, 2017 till 31st March 2023
shall be governed by provisions of paragraph 5.14 of HBP as amended vide PN
No.', 'business_rule', 'Block-wise Fulfillment of EO', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', '(v) Authorisations issued from 5th December, 2017 till 31st March 2023
shall be governed by provisions of paragraph 5.14 of HBP as amended vide PN
No.', '(iii)
Authorisations issued from 18th April, 2013 till issue of Notification
of FTP 2015-20 shall be governed by provisions of paragraph 5.8 of HBP Vol.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.13 - Block-wise Fulfillment of EO.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_13-R015', '5.13', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'business_rule', 'Block-wise Fulfillment of EO', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', '(iv)
Authorisations issued from 1st April, 2015 till 4th December, 2017
shall be governed by provisions of paragraph 5.14 of HBP as amended vide PN
No.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.13 - Block-wise Fulfillment of EO.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.13', '5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
(b) The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.13', '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 5,000
More than ₹2 Crores to 10 Crores 10,000
Above ₹10 Crores 15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
7
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 5,000 |
More than ₹2 Crores to 10 Crores 10,000 |
Above ₹10 Crores 15,000 |
7
5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
(b)
The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.13', '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
5,000
More than ₹2 Crores to 10 Crores
10,000
Above ₹10 Crores
15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
Period from the date of issue
of Authorisation
Minimum export
obligation to be fulfilled
Block of 1st to 4th year
50%
Balance EO
Block of 5th and 6th year
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 10,000
More than ₹2 Crores to 10 Crores 20,000
Above ₹10 Crores 30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 15,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 45,000
No refund of earlier paid Composition Fee shall be admissible.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.13', 'Where EO of the first block is not fulfilled in terms of para (a) above, except
in cases where the EO prescribed for first block is extended by the RA, the
Authorisation holder shall, within 6 months from the expiry of the block,
pay duties of customs (along with applicable interest as notified by DOR)
proportionate to duty saved amount on total unfulfilled EO of the first block..');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.13', '(iii) Authorisations issued from 18th April, 2013 till issue of Notification
of FTP 2015-20 shall be governed by provisions of paragraph 5.8 of HBP Vol.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.13', '(iii)
Authorisations issued from 18th April, 2013 till issue of Notification
of FTP 2015-20 shall be governed by provisions of paragraph 5.8 of HBP Vol.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.13', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.');
INSERT INTO documents (section_code, document_name) VALUES ('5.13', '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
5,000
More than ₹2 Crores to 10 Crores
10,000
Above ₹10 Crores
15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
Period from the date of issue
of Authorisation
Minimum export
obligation to be fulfilled
Block of 1st to 4th year
50%
Balance EO
Block of 5th and 6th year
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 10,000
More than ₹2 Crores to 10 Crores 20,000
Above ₹10 Crores 30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 15,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 45,000
No refund of earlier paid Composition Fee shall be admissible.');
INSERT INTO documents (section_code, document_name) VALUES ('5.13', '8
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 10,000 |
More than ₹2 Crores to 10 Crores 20,000 |
Above ₹10 Crores 30,000 |
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 15,000 |
More than ₹2 Crores to 10 Crores 30,000 |
Above ₹10 Crores 45,000 |
8
composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
10,000
More than ₹2 Crores to 10 Crores
20,000
Above ₹10 Crores
30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
15,000
More than ₹2 Crores to 10 Crores
30,000
Above ₹10 Crores
45,000
No refund of earlier paid Composition Fee shall be admissible.');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.13', 'Regional Authority');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.13', 'The Authorisation holder would intimate the Regional Authority');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.13', 'RA');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.13', 'customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.13', 'EO prescribed for first block is extended by the RA');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.13', '5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
(b) The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.13', '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 5,000
More than ₹2 Crores to 10 Crores 10,000
Above ₹10 Crores 15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
7
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 5,000 |
More than ₹2 Crores to 10 Crores 10,000 |
Above ₹10 Crores 15,000 |
7
5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
(b)
The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.13', '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
5,000
More than ₹2 Crores to 10 Crores
10,000
Above ₹10 Crores
15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
Period from the date of issue
of Authorisation
Minimum export
obligation to be fulfilled
Block of 1st to 4th year
50%
Balance EO
Block of 5th and 6th year
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 10,000
More than ₹2 Crores to 10 Crores 20,000
Above ₹10 Crores 30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 15,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 45,000
No refund of earlier paid Composition Fee shall be admissible.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.13', 'Where EO of the first block is not fulfilled in terms of para (a) above, except
in cases where the EO prescribed for first block is extended by the RA, the
Authorisation holder shall, within 6 months from the expiry of the block,
pay duties of customs (along with applicable interest as notified by DOR)
proportionate to duty saved amount on total unfulfilled EO of the first block..');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.13', '8
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 10,000 |
More than ₹2 Crores to 10 Crores 20,000 |
Above ₹10 Crores 30,000 |
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 15,000 |
More than ₹2 Crores to 10 Crores 30,000 |
Above ₹10 Crores 45,000 |
8
composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
10,000
More than ₹2 Crores to 10 Crores
20,000
Above ₹10 Crores
30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
15,000
More than ₹2 Crores to 10 Crores
30,000
Above ₹10 Crores
45,000
No refund of earlier paid Composition Fee shall be admissible.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('5.13', '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 5,000
More than ₹2 Crores to 10 Crores 10,000
Above ₹10 Crores 15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
7
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 5,000 |
More than ₹2 Crores to 10 Crores 10,000 |
Above ₹10 Crores 15,000 |
7
5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
(b)
The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('5.13', '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
5,000
More than ₹2 Crores to 10 Crores
10,000
Above ₹10 Crores
15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
Period from the date of issue
of Authorisation
Minimum export
obligation to be fulfilled
Block of 1st to 4th year
50%
Balance EO
Block of 5th and 6th year
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 10,000
More than ₹2 Crores to 10 Crores 20,000
Above ₹10 Crores 30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 15,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 45,000
No refund of earlier paid Composition Fee shall be admissible.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('5.13', 'Where EO of the first block is not fulfilled in terms of para (a) above, except
in cases where the EO prescribed for first block is extended by the RA, the
Authorisation holder shall, within 6 months from the expiry of the block,
pay duties of customs (along with applicable interest as notified by DOR)
proportionate to duty saved amount on total unfulfilled EO of the first block..');
INSERT INTO exceptions (section_code, exception_text) VALUES ('5.13', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.13', 1, 'Evaluate condition: 5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
(b) The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.13', 2, 'Evaluate condition: (c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 5,000
More than ₹2 Crores to 10 Crores 10,000
Above ₹10 Crores 15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
7
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 5,000 |
More than ₹2 Crores to 10 Crores 10,000 |
Above ₹10 Crores 15,000 |
7
5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
(b)
The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.13', 3, 'Evaluate condition: (c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
5,000
More than ₹2 Crores to 10 Crores
10,000
Above ₹10 Crores
15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
Period from the date of issue
of Authorisation
Minimum export
obligation to be fulfilled
Block of 1st to 4th year
50%
Balance EO
Block of 5th and 6th year
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 10,000
More than ₹2 Crores to 10 Crores 20,000
Above ₹10 Crores 30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 15,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 45,000
No refund of earlier paid Composition Fee shall be admissible.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.13', 4, '5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
(b) The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.13', 5, '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 5,000
More than ₹2 Crores to 10 Crores 10,000
Above ₹10 Crores 15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
7
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 5,000 |
More than ₹2 Crores to 10 Crores 10,000 |
Above ₹10 Crores 15,000 |
7
5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
(b)
The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.13', 6, '(c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
5,000
More than ₹2 Crores to 10 Crores
10,000
Above ₹10 Crores
15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
Period from the date of issue
of Authorisation
Minimum export
obligation to be fulfilled
Block of 1st to 4th year
50%
Balance EO
Block of 5th and 6th year
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 10,000
More than ₹2 Crores to 10 Crores 20,000
Above ₹10 Crores 30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 15,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 45,000
No refund of earlier paid Composition Fee shall be admissible.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.13', 7, 'Where EO of the first block is not fulfilled in terms of para (a) above, except
in cases where the EO prescribed for first block is extended by the RA, the
Authorisation holder shall, within 6 months from the expiry of the block,
pay duties of customs (along with applicable interest as notified by DOR)
proportionate to duty saved amount on total unfulfilled EO of the first block..');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.13', 8, '(d) (i) Authorisations issued from 1st April, 2002 upto 31st August, 2004
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-02)
as amended from time to time.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.13', 9, '(ii) Authorisations issued from 1st September, 2004 upto 17th April, 2013
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-12) as
amended till 17.04.2013.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.13', 10, 'Run validation: 5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
(b) The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.13', 11, 'Run validation: (c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 5,000
More than ₹2 Crores to 10 Crores 10,000
Above ₹10 Crores 15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
7
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 5,000 |
More than ₹2 Crores to 10 Crores 10,000 |
Above ₹10 Crores 15,000 |
7
5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
(b)
The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.13', 12, 'Run validation: (c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
5,000
More than ₹2 Crores to 10 Crores
10,000
Above ₹10 Crores
15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
Period from the date of issue
of Authorisation
Minimum export
obligation to be fulfilled
Block of 1st to 4th year
50%
Balance EO
Block of 5th and 6th year
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 10,000
More than ₹2 Crores to 10 Crores 20,000
Above ₹10 Crores 30,000
Application made beyond 6 years, for extension of block-wise EO period for
regularization purpose, shall also be considered by RA concerned, with
composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 15,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 45,000
No refund of earlier paid Composition Fee shall be admissible.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.13', 13, 'Handle exception: (c) Request for extension of Export Obligation period of first block shall be
submitted within 6 months from the date of expiry of first block EO
period along with composition fee as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 5,000
More than ₹2 Crores to 10 Crores 10,000
Above ₹10 Crores 15,000
RA may consider the request for extension of block-wise EO period, received
after 6 months, but within 6 years from date of issue of authorisation, with
7
Period from the date of issue Minimum export
of Authorisation obligation to be fulfilled
Block of 1st to 4th year 50%
Block of 5th and 6th year Balance EO
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 5,000 |
More than ₹2 Crores to 10 Crores 10,000 |
Above ₹10 Crores 15,000 |
7
5.13 Block-wise Fulfillment of EO
(a) The Authorisation holder under the EPCG scheme shall, while maintaining
the average export obligation, fulfill the specific export obligation over
the prescribed block period in the following proportions:
(b)
The Authorisation holder would intimate the Regional Authority on the
fulfilment of the export obligation, as well as average exports, within
three months of completion of the block.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'The');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'fee');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'may');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'but');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'not');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'pay');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'DOR');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'HBP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'Vol');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'RE-');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'iii');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'FTP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'over');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'from');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'date');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'year');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'keywords', 'well');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'tags', '5.13');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'tags', 'Block-wise Fulfillment of EO');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.13', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.14', 'Report for EO fulfilment', '5.14 Report for EO fulfilment
Authorisation holder shall submit to RA concerned a report on fulfilment of export
obligation through online mode after expiry of first block period of four years and
continuously till the expiry of valid EO period.', 'Indha Report for EO fulfilment section-la, 5.14 Report for EO fulfilment
Authorisation holder kandippa submit to RA concerned a report on fulfilment of export
obligation through online mode after expiry of first block period of four years and
continuously till the expiry of valid EO period.', '5.14 Report for EO fulfilment
Authorisation holder shall submit to RA concerned a report on fulfilment of export
obligation through online mode after expiry of first block period of four years and
continuously till the expiry of valid EO period. Such report shall contain a statement
with details of Shipping bill/Invoice number/Bill of Export/FIRC number with date
and number, as applicable, duly certified by Chartered Accountant/Cost
Accountant/Company Secretary for evidencing fulfillment of specific as well as
average EO (wherever applicable). 5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a) In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', 'Report for EO fulfilment governs how DGFT business controls should be applied, validated, and enforced.', 'Report for EO fulfilment explains the operating rule set that DEKAI should enforce. Key control points include 5.14 Report for EO fulfilment
Authorisation holder shall submit to RA concerned a report on fulfilment of export
obligation through online mode after expiry of first block period of four years and
continuously till the expiry of valid EO period. The section also drives actions such as 5.14 Report for EO fulfilment
Authorisation holder shall submit to RA concerned a report on fulfilment of export
obligation through online mode after expiry of first block period of four years and
continuously till the expiry of valid EO period..', 'Indha Report for EO fulfilment section-la, Report for EO fulfilment explains the operating rule set that DEKAI should enforce. Key control points include 5.14 Report for EO fulfilment
Authorisation holder kandippa submit to RA concerned a report on fulfilment of export
obligation through online mode after expiry of first block period of four years and
continuously till the expiry of valid EO period. The section also drives actions such as 5.14 Report for EO fulfilment
Authorisation holder kandippa submit to RA concerned a report on fulfilment of export
obligation through online mode after expiry of first block period of four years and
continuously till the expiry of valid EO period..', '5.14 Report for EO fulfilment
Authorisation holder shall submit to RA concerned a report on fulfilment of export
obligation through online mode after expiry of first block period of four years and
continuously till the expiry of valid EO period. Such report shall contain a statement
with details of Shipping bill/Invoice number/Bill of Export/FIRC number with date
and number, as applicable, duly certified by Chartered Accountant/Cost
Accountant/Company Secretary for evidencing fulfillment of specific as well as
average EO (wherever applicable).
5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a) In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion. Customs shall automatically allow clearance of such goods
without endorsement by RA concerned. The authorisation holder shall
furnish additional fee to cover excess imports effected, in terms of duty
saved amount, to RA concerned, at the time of application for EODC. Export
obligation shall automatically stand enhanced proportionately.
(b) In excess of duty saved amount indicated on the authorisation by more than
10%, the RA concerned, as per its delegated powers, may allow
enhancement in duty saved amount of the EPCG authorisation. The
Authorisation holder shall furnish additional BG/LUT to the Customs
Authority.
(c) Less than the duty saved amount indicated on the authorisation, the export
obligation shall stand reduced on pro-rata basis with reference to actual
utilization of the authorisation.
i. Para 5.13(e) added vide Public Notice No. 15/2024-25 dated 25.07.2024.
ii. Para 5.13(f) added vide Public Notice No. 51/2025-26 dated 06.03.2026.
iii. Para 5.14 amended vide Public Notice No. 24 dated 20.09.2024.
9
9
(v)
Authorisations issued from 5th December, 2017 till 31st March 2023
shall be governed by provisions of paragraph 5.14 of HBP as amended vide PN
No. 43 dated 05.12.2017.
(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.
5.14 Report for EO fulfilment
Authorisation holder shall submit to RA concerned a report on fulfilment of export
obligation through online mode after expiry of first block period of four years and
continuously till the expiry of valid EO period. Such report shall contain a statement
with details of Shipping bill/Invoice number/Bill of Export/FIRC number with date
and number, as applicable, duly certified by Chartered Accountant/Cost
Accountant/Company Secretary for evidencing fulfillment of specific as well as
average EO (wherever applicable).
5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a)
In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion. Customs shall automatically allow clearance of such goods
without endorsement by RA concerned. The authorisation holder shall
furnish additional fee to cover excess imports effected, in terms of duty
saved amount, to RA concerned, at the time of application for EODC. Export
obligation shall automatically stand enhanced proportionately.
(b)
In excess of duty saved amount indicated on the authorisation by more than
10%, the RA concerned, as per its delegated powers, may allow
enhancement in duty saved amount of the EPCG authorisation. The
Authorisation holder shall furnish additional BG/LUT to the Customs
Authority.
(c)
Less than the duty saved amount indicated on the authorisation, the export
obligation shall stand reduced on pro-rata basis with reference to actual
utilization of the authorisation.
i.
Para 5.13(e) added vide Public Notice No. 15/2024-25 dated 25.07.2024.
ii.
Para 5.13(f) added vide Public Notice No. 51/2025-26 dated 06.03.2026.
iii.
Para 5.14 amended vide Public Notice No. 24 dated 20.09.2024.', '[9]', '["for", "and", "the", "pro", "has", "not", "fee", "per", "its", "may", "iii", "HBP", "FTP", "mode", "four", "till", "Such", "with", "date", "duly"]', 'Support Report for EO fulfilment processing and compliance validation.', '["5.14", "Report for EO fulfilment", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_14-R001', '5.14', '5.14 Report for EO fulfilment
Authorisation holder shall submit to RA concerned a report on fulfilment of export
obligation through online mode after expiry of first block period of four years and
continuously till the expiry of valid EO period.', 'business_rule', 'Report for EO fulfilment', '5.14 Report for EO fulfilment
Authorisation holder shall submit to RA concerned a report on fulfilment of export
obligation through online mode after expiry of first block period of four years and
continuously till the expiry of valid EO period.', '5.14 Report for EO fulfilment
Authorisation holder shall submit to RA concerned a report on fulfilment of export
obligation through online mode after expiry of first block period of four years and
continuously till the expiry of valid EO period.', '5.14 Report for EO fulfilment
Authorisation holder shall submit to RA concerned a report on fulfilment of export
obligation through online mode after expiry of first block period of four years and
continuously till the expiry of valid EO period.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.14 - Report for EO fulfilment.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_14-R002', '5.14', 'Such report shall contain a statement
with details of Shipping bill/Invoice number/Bill of Export/FIRC number with date
and number, as applicable, duly certified by Chartered Accountant/Cost
Accountant/Company Secretary for evidencing fulfillment of specific as well as
average EO (wherever applicable).', 'business_rule', 'Report for EO fulfilment', 'Such report shall contain a statement
with details of Shipping bill/Invoice number/Bill of Export/FIRC number with date
and number, as applicable, duly certified by Chartered Accountant/Cost
Accountant/Company Secretary for evidencing fulfillment of specific as well as
average EO (wherever applicable).', 'Such report shall contain a statement
with details of Shipping bill/Invoice number/Bill of Export/FIRC number with date
and number, as applicable, duly certified by Chartered Accountant/Cost
Accountant/Company Secretary for evidencing fulfillment of specific as well as
average EO (wherever applicable).', 'Such report shall contain a statement
with details of Shipping bill/Invoice number/Bill of Export/FIRC number with date
and number, as applicable, duly certified by Chartered Accountant/Cost
Accountant/Company Secretary for evidencing fulfillment of specific as well as
average EO (wherever applicable).', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.14 - Report for EO fulfilment.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_14-R003', '5.14', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a) In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', 'business_rule', 'Report for EO fulfilment', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a) In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a) In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a) In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.14 - Report for EO fulfilment.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_14-R004', '5.14', 'Customs shall automatically allow clearance of such goods
without endorsement by RA concerned.', 'business_rule', 'Report for EO fulfilment', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'Customs shall automatically allow clearance of such goods
without endorsement by RA concerned.', 'The authorisation holder shall
furnish additional fee to cover excess imports effected, in terms of duty
saved amount, to RA concerned, at the time of application for EODC.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.14 - Report for EO fulfilment.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_14-R005', '5.14', 'The authorisation holder shall
furnish additional fee to cover excess imports effected, in terms of duty
saved amount, to RA concerned, at the time of application for EODC.', 'business_rule', 'Report for EO fulfilment', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a)
In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', 'The authorisation holder shall
furnish additional fee to cover excess imports effected, in terms of duty
saved amount, to RA concerned, at the time of application for EODC.', 'The
Authorisation holder shall furnish additional BG/LUT to the Customs
Authority.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.14 - Report for EO fulfilment.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_14-R006', '5.14', 'Export
obligation shall automatically stand enhanced proportionately.', 'business_rule', 'Report for EO fulfilment', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a)
In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', 'Export
obligation shall automatically stand enhanced proportionately.', 'Para 5.14 amended vide Public Notice No.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.14 - Report for EO fulfilment.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_14-R007', '5.14', 'The
Authorisation holder shall furnish additional BG/LUT to the Customs
Authority.', 'business_rule', 'Report for EO fulfilment', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a)
In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', 'The
Authorisation holder shall furnish additional BG/LUT to the Customs
Authority.', '9
9
(v)
Authorisations issued from 5th December, 2017 till 31st March 2023
shall be governed by provisions of paragraph 5.14 of HBP as amended vide PN
No.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.14 - Report for EO fulfilment.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_14-R008', '5.14', '(c) Less than the duty saved amount indicated on the authorisation, the export
obligation shall stand reduced on pro-rata basis with reference to actual
utilization of the authorisation.', 'business_rule', 'Report for EO fulfilment', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a)
In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', '(c) Less than the duty saved amount indicated on the authorisation, the export
obligation shall stand reduced on pro-rata basis with reference to actual
utilization of the authorisation.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.14 - Report for EO fulfilment.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_14-R009', '5.14', '9
9
(v)
Authorisations issued from 5th December, 2017 till 31st March 2023
shall be governed by provisions of paragraph 5.14 of HBP as amended vide PN
No.', 'business_rule', 'Report for EO fulfilment', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a)
In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', '9
9
(v)
Authorisations issued from 5th December, 2017 till 31st March 2023
shall be governed by provisions of paragraph 5.14 of HBP as amended vide PN
No.', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a)
In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.14 - Report for EO fulfilment.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_14-R010', '5.14', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'business_rule', 'Report for EO fulfilment', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a)
In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a)
In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.14 - Report for EO fulfilment.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_14-R011', '5.14', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a)
In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', 'business_rule', 'Report for EO fulfilment', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a)
In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a)
In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a)
In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.14 - Report for EO fulfilment.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_14-R012', '5.14', '(c)
Less than the duty saved amount indicated on the authorisation, the export
obligation shall stand reduced on pro-rata basis with reference to actual
utilization of the authorisation.', 'business_rule', 'Report for EO fulfilment', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a)
In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', '(c)
Less than the duty saved amount indicated on the authorisation, the export
obligation shall stand reduced on pro-rata basis with reference to actual
utilization of the authorisation.', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a)
In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.14 - Report for EO fulfilment.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.14', '5.14 Report for EO fulfilment
Authorisation holder shall submit to RA concerned a report on fulfilment of export
obligation through online mode after expiry of first block period of four years and
continuously till the expiry of valid EO period.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.14', 'Such report shall contain a statement
with details of Shipping bill/Invoice number/Bill of Export/FIRC number with date
and number, as applicable, duly certified by Chartered Accountant/Cost
Accountant/Company Secretary for evidencing fulfillment of specific as well as
average EO (wherever applicable).');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.14', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a) In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.14', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.14', '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a)
In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.');
INSERT INTO documents (section_code, document_name) VALUES ('5.14', 'Shipping bill/Invoice number/Bill');
INSERT INTO documents (section_code, document_name) VALUES ('5.14', 'The authorisation holder shall
furnish additional fee to cover excess imports effected, in terms of duty
saved amount, to RA concerned, at the time of application for EODC.');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.14', 'RA');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.14', 'Authorisation holder shall submit to RA');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.14', 'Customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.14', 'Authorisation holder shall furnish additional BG/LUT to the Customs');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.14', '5.14 Report for EO fulfilment
Authorisation holder shall submit to RA concerned a report on fulfilment of export
obligation through online mode after expiry of first block period of four years and
continuously till the expiry of valid EO period.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('5.14', '(e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.14', 1, 'Evaluate condition: 5.14 Report for EO fulfilment
Authorisation holder shall submit to RA concerned a report on fulfilment of export
obligation through online mode after expiry of first block period of four years and
continuously till the expiry of valid EO period.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.14', 2, 'Evaluate condition: Such report shall contain a statement
with details of Shipping bill/Invoice number/Bill of Export/FIRC number with date
and number, as applicable, duly certified by Chartered Accountant/Cost
Accountant/Company Secretary for evidencing fulfillment of specific as well as
average EO (wherever applicable).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.14', 3, 'Evaluate condition: 5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a) In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.14', 4, '5.14 Report for EO fulfilment
Authorisation holder shall submit to RA concerned a report on fulfilment of export
obligation through online mode after expiry of first block period of four years and
continuously till the expiry of valid EO period.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.14', 5, 'Such report shall contain a statement
with details of Shipping bill/Invoice number/Bill of Export/FIRC number with date
and number, as applicable, duly certified by Chartered Accountant/Cost
Accountant/Company Secretary for evidencing fulfillment of specific as well as
average EO (wherever applicable).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.14', 6, '5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a) In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.14', 7, 'The authorisation holder shall
furnish additional fee to cover excess imports effected, in terms of duty
saved amount, to RA concerned, at the time of application for EODC.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.14', 8, 'The
Authorisation holder shall furnish additional BG/LUT to the Customs
Authority.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.14', 9, 'Para 5.14 amended vide Public Notice No.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.14', 10, 'Run validation: 5.14 Report for EO fulfilment
Authorisation holder shall submit to RA concerned a report on fulfilment of export
obligation through online mode after expiry of first block period of four years and
continuously till the expiry of valid EO period.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.14', 11, 'Run validation: Such report shall contain a statement
with details of Shipping bill/Invoice number/Bill of Export/FIRC number with date
and number, as applicable, duly certified by Chartered Accountant/Cost
Accountant/Company Secretary for evidencing fulfillment of specific as well as
average EO (wherever applicable).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.14', 12, 'Run validation: 5.15 Automatic Reduction/Enhancement upto 10% Duty saved
amount and pro rata Reduction/Enhancement in export obligation
If authorisation issued has been utilized for import of goods:-
(a) In excess of duty saved amount indicated on the authorisation by not more
than 10%, the authorisation shall be deemed to have been enhanced by
that proportion.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.14', 13, 'Handle exception: (e) Notwithstanding sub-para (d) above, sub-para (c) above shall
also be applicable for authorisations issued under FTP (2015-20)
(f) Notwithstanding the provisions contained in Para 5.13 of the
Handbook of Procedures (HBP), 2023, in respect of EPCG
Authorisations where the Block-wise Export Obligation (EO)
period (whether original or as extended) is expiring during the
period 01.03.2026 to 31.05.2026, the concerned Block-wise EO
period shall stand automatically extended up to 31.08.2026.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'pro');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'has');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'not');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'fee');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'per');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'its');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'may');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'iii');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'HBP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'FTP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'mode');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'four');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'till');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'Such');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'with');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'date');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'keywords', 'duly');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'tags', '5.14');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'tags', 'Report for EO fulfilment');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.14', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.16', 'Extension in Export Obligation Period', '5.16 Extension in Export Obligation Period
(a) Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation.', 'Indha Extension in Export Obligation Period section-la, 5.16 Extension in export Obligation Period
(a) Extension in export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 kandippa be governed by relevant
provisions of HBP applicable on the date of issue of authorisation.', '5.16 Extension in Export Obligation Period
(a) Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation. (b) In case of extension of Export obligation period beyond 6 years, two
extensions, from date of expiry, of one year each or two years in one go at
the choice of authorisation holder, may be considered by RA concerned
with composition fee as under:
Composition fee to be
Duty Saved value of EPCG
levied (in Rupees)
Authorisation issued
Up to ₹2 Crores 20,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 60,000
No refund of earlier paid Composition Fee shall be admissible. (c) Request for extension in EO Period shall be made to RA concerned within 6
months from the date of expiry of original EO Period.', 'Extension in Export Obligation Period governs how DGFT business controls should be applied, validated, and enforced.', 'Extension in Export Obligation Period explains the operating rule set that DEKAI should enforce. Key control points include 5.16 Extension in Export Obligation Period
(a) Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation. The section also drives actions such as 5.16 Extension in Export Obligation Period
(a) Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation..', 'Indha Extension in Export Obligation Period section-la, Extension in export Obligation Period explains the operating rule set that DEKAI should enforce. Key control points include 5.16 Extension in export Obligation Period
(a) Extension in export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 kandippa be governed by relevant
provisions of HBP applicable on the date of issue of authorisation. The section also drives actions such as 5.16 Extension in export Obligation Period
(a) Extension in export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 kandippa be governed by relevant
provisions of HBP applicable on the date of issue of authorisation..', '5.16 Extension in Export Obligation Period
(a) Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation.
(b) In case of extension of Export obligation period beyond 6 years, two
extensions, from date of expiry, of one year each or two years in one go at
the choice of authorisation holder, may be considered by RA concerned
with composition fee as under:
Composition fee to be
Duty Saved value of EPCG
levied (in Rupees)
Authorisation issued
Up to ₹2 Crores 20,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 60,000
No refund of earlier paid Composition Fee shall be admissible.
(c) Request for extension in EO Period shall be made to RA concerned within 6
months from the date of expiry of original EO Period. However, RA may
consider the request for extension received after 6 months, but within the
extendable validity of EO period, with a late fee of Rs. 10,000/-. The request
for extension for regularisation purpose, from 6th to 8th year, may also be
considered after expiry of EO period on payment of late fee of Rs. 15,000/-.
This fee is in addition to the composition fee that may be payable on account
of shortfall in export obligation. However, EO extension, beyond 8 years
from date of issue of authorisation, shall not be allowed by RA under this
provision.
(d) Notwithstanding sub-para (a) above, sub-paras (b) and (c) above shall also
be applicable for authorisations issued under FTP (2015-20).
(e) For implementation of all PRC decisions involving levy of Composition Fee
while allowing extension in block-wise/EO period and/or regularisation of
exports already made, the applicable Composition Fee shall be as under:-
10
| Composition fee to be
Duty Saved value of EPCG |
| levied (in Rupees)
Authorisation issued |
Up to ₹2 Crores 20,000 |
More than ₹2 Crores to 10 Crores 30,000 |
Above ₹10 Crores 60,000 |
10
5.16 Extension in Export Obligation Period
(a)
Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation.
(b)
In case of extension of Export obligation period beyond 6 years, two
extensions, from date of expiry, of one year each or two years in one go at
the choice of authorisation holder, may be considered by RA concerned
with composition fee as under:
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
20,000
More than ₹2 Crores to 10 Crores
30,000
Above ₹10 Crores
60,000
No refund of earlier paid Composition Fee shall be admissible.
(c)
Request for extension in EO Period shall be made to RA concerned within 6
months from the date of expiry of original EO Period. However, RA may
consider the request for extension received after 6 months, but within the
extendable validity of EO period, with a late fee of Rs. 10,000/-. The request
for extension for regularisation purpose, from 6th to 8th year, may also be
considered after expiry of EO period on payment of late fee of Rs. 15,000/-.
This fee is in addition to the composition fee that may be payable on account
of shortfall in export obligation. However, EO extension, beyond 8 years
from date of issue of authorisation, shall not be allowed by RA under this
provision.
(d)
Notwithstanding sub-para (a) above, sub-paras (b) and (c) above shall also
be applicable for authorisations issued under FTP (2015-20).
(e)
For implementation of all PRC decisions involving levy of Composition Fee
while allowing extension in block-wise/EO period and/or regularisation of
exports already made, the applicable Composition Fee shall be as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 30,000
More than ₹2 Crores to 10 Crores 60,000
Above ₹10 Crores 1,00,000
No refund of earlier paid Composition Fee shall be admissible.
(f) Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.
i. Para 5.16(b) amended vide Public Notice No. 15/2024-25 dated 25.07.2024
ii. Para 5.16(e) added vide Public Notice No. 15/2024-25 dated 25.07.2024.
iii. Para 5.16 (f) added vide Public Notice No. 51/2025-26 dated 06.03.2026
11
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 30,000 |
More than ₹2 Crores to 10 Crores 60,000
Above ₹10 Crores 1,00,000 |
11
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
30,000
More than ₹2 Crores to 10 Crores
60,000
Above ₹10 Crores
1,00,000
No refund of earlier paid Composition Fee shall be admissible.
(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.
i.
Para 5.16(b) amended vide Public Notice No. 15/2024-25 dated 25.07.2024
ii.
Para 5.16(e) added vide Public Notice No. 15/2024-25 dated 25.07.2024.
iii.
Para 5.16 (f) added vide Public Notice No. 51/2025-26 dated 06.03.2026', '[10, 11]', '["HBP", "the", "two", "one", "may", "fee", "for", "but", "not", "and", "FTP", "all", "PRC", "iii", "EPCG", "date", "case", "from", "year", "each"]', 'Support Extension in Export Obligation Period processing and compliance validation.', '["5.16", "Extension in Export Obligation Period", "business-rule", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_16-R001', '5.16', '5.16 Extension in Export Obligation Period
(a) Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation.', 'business_rule', 'Extension in Export Obligation Period', '5.16 Extension in Export Obligation Period
(a) Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation.', '5.16 Extension in Export Obligation Period
(a) Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation.', '5.16 Extension in Export Obligation Period
(a) Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation.', 'However, RA may
consider the request for extension received after 6 months, but within the
extendable validity of EO period, with a late fee of Rs.', 'DEKAI should produce a compliance decision for 5.16 - Extension in Export Obligation Period.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_16-R002', '5.16', '(b) In case of extension of Export obligation period beyond 6 years, two
extensions, from date of expiry, of one year each or two years in one go at
the choice of authorisation holder, may be considered by RA concerned
with composition fee as under:
Composition fee to be
Duty Saved value of EPCG
levied (in Rupees)
Authorisation issued
Up to ₹2 Crores 20,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 60,000
No refund of earlier paid Composition Fee shall be admissible.', 'business_rule', 'Extension in Export Obligation Period', '(b) In case of extension of Export obligation period beyond 6 years, two
extensions, from date of expiry, of one year each or two years in one go at
the choice of authorisation holder, may be considered by RA concerned
with composition fee as under:
Composition fee to be
Duty Saved value of EPCG
levied (in Rupees)
Authorisation issued
Up to ₹2 Crores 20,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 60,000
No refund of earlier paid Composition Fee shall be admissible.', '(b) In case of extension of Export obligation period beyond 6 years, two
extensions, from date of expiry, of one year each or two years in one go at
the choice of authorisation holder, may be considered by RA concerned
with composition fee as under:
Composition fee to be
Duty Saved value of EPCG
levied (in Rupees)
Authorisation issued
Up to ₹2 Crores 20,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 60,000
No refund of earlier paid Composition Fee shall be admissible.', '(b) In case of extension of Export obligation period beyond 6 years, two
extensions, from date of expiry, of one year each or two years in one go at
the choice of authorisation holder, may be considered by RA concerned
with composition fee as under:
Composition fee to be
Duty Saved value of EPCG
levied (in Rupees)
Authorisation issued
Up to ₹2 Crores 20,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 60,000
No refund of earlier paid Composition Fee shall be admissible.', 'However, EO extension, beyond 8 years
from date of issue of authorisation, shall not be allowed by RA under this
provision.', 'DEKAI should produce a compliance decision for 5.16 - Extension in Export Obligation Period.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_16-R003', '5.16', '(c) Request for extension in EO Period shall be made to RA concerned within 6
months from the date of expiry of original EO Period.', 'business_rule', 'Extension in Export Obligation Period', 'However, RA may
consider the request for extension received after 6 months, but within the
extendable validity of EO period, with a late fee of Rs.', '(c) Request for extension in EO Period shall be made to RA concerned within 6
months from the date of expiry of original EO Period.', 'The request
for extension for regularisation purpose, from 6th to 8th year, may also be
considered after expiry of EO period on payment of late fee of Rs.', '(d) Notwithstanding sub-para (a) above, sub-paras (b) and (c) above shall also
be applicable for authorisations issued under FTP (2015-20).', 'DEKAI should produce a compliance decision for 5.16 - Extension in Export Obligation Period.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_16-R004', '5.16', 'However, EO extension, beyond 8 years
from date of issue of authorisation, shall not be allowed by RA under this
provision.', 'business_rule', 'Extension in Export Obligation Period', 'The request
for extension for regularisation purpose, from 6th to 8th year, may also be
considered after expiry of EO period on payment of late fee of Rs.', 'However, EO extension, beyond 8 years
from date of issue of authorisation, shall not be allowed by RA under this
provision.', 'This fee is in addition to the composition fee that may be payable on account
of shortfall in export obligation.', '(d)
Notwithstanding sub-para (a) above, sub-paras (b) and (c) above shall also
be applicable for authorisations issued under FTP (2015-20).', 'DEKAI should produce a compliance decision for 5.16 - Extension in Export Obligation Period.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_16-R005', '5.16', '(d) Notwithstanding sub-para (a) above, sub-paras (b) and (c) above shall also
be applicable for authorisations issued under FTP (2015-20).', 'business_rule', 'Extension in Export Obligation Period', '(e) For implementation of all PRC decisions involving levy of Composition Fee
while allowing extension in block-wise/EO period and/or regularisation of
exports already made, the applicable Composition Fee shall be as under:-
10
| Composition fee to be
Duty Saved value of EPCG |
| levied (in Rupees)
Authorisation issued |
Up to ₹2 Crores 20,000 |
More than ₹2 Crores to 10 Crores 30,000 |
Above ₹10 Crores 60,000 |
10
5.16 Extension in Export Obligation Period
(a)
Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation.', '(d) Notwithstanding sub-para (a) above, sub-paras (b) and (c) above shall also
be applicable for authorisations issued under FTP (2015-20).', 'However, EO extension, beyond 8 years
from date of issue of authorisation, shall not be allowed by RA under this
provision.', '(f) Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.16 - Extension in Export Obligation Period.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_16-R006', '5.16', '(e) For implementation of all PRC decisions involving levy of Composition Fee
while allowing extension in block-wise/EO period and/or regularisation of
exports already made, the applicable Composition Fee shall be as under:-
10
| Composition fee to be
Duty Saved value of EPCG |
| levied (in Rupees)
Authorisation issued |
Up to ₹2 Crores 20,000 |
More than ₹2 Crores to 10 Crores 30,000 |
Above ₹10 Crores 60,000 |
10
5.16 Extension in Export Obligation Period
(a)
Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation.', 'business_rule', 'Extension in Export Obligation Period', '(b)
In case of extension of Export obligation period beyond 6 years, two
extensions, from date of expiry, of one year each or two years in one go at
the choice of authorisation holder, may be considered by RA concerned
with composition fee as under:
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
20,000
More than ₹2 Crores to 10 Crores
30,000
Above ₹10 Crores
60,000
No refund of earlier paid Composition Fee shall be admissible.', '(e) For implementation of all PRC decisions involving levy of Composition Fee
while allowing extension in block-wise/EO period and/or regularisation of
exports already made, the applicable Composition Fee shall be as under:-
10
| Composition fee to be
Duty Saved value of EPCG |
| levied (in Rupees)
Authorisation issued |
Up to ₹2 Crores 20,000 |
More than ₹2 Crores to 10 Crores 30,000 |
Above ₹10 Crores 60,000 |
10
5.16 Extension in Export Obligation Period
(a)
Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation.', '(d) Notwithstanding sub-para (a) above, sub-paras (b) and (c) above shall also
be applicable for authorisations issued under FTP (2015-20).', '(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.16 - Extension in Export Obligation Period.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_16-R007', '5.16', '(b)
In case of extension of Export obligation period beyond 6 years, two
extensions, from date of expiry, of one year each or two years in one go at
the choice of authorisation holder, may be considered by RA concerned
with composition fee as under:
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
20,000
More than ₹2 Crores to 10 Crores
30,000
Above ₹10 Crores
60,000
No refund of earlier paid Composition Fee shall be admissible.', 'business_rule', 'Extension in Export Obligation Period', '(f) Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', '(b)
In case of extension of Export obligation period beyond 6 years, two
extensions, from date of expiry, of one year each or two years in one go at
the choice of authorisation holder, may be considered by RA concerned
with composition fee as under:
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
20,000
More than ₹2 Crores to 10 Crores
30,000
Above ₹10 Crores
60,000
No refund of earlier paid Composition Fee shall be admissible.', '(e) For implementation of all PRC decisions involving levy of Composition Fee
while allowing extension in block-wise/EO period and/or regularisation of
exports already made, the applicable Composition Fee shall be as under:-
10
| Composition fee to be
Duty Saved value of EPCG |
| levied (in Rupees)
Authorisation issued |
Up to ₹2 Crores 20,000 |
More than ₹2 Crores to 10 Crores 30,000 |
Above ₹10 Crores 60,000 |
10
5.16 Extension in Export Obligation Period
(a)
Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation.', '(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.16 - Extension in Export Obligation Period.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_16-R008', '5.16', '(c)
Request for extension in EO Period shall be made to RA concerned within 6
months from the date of expiry of original EO Period.', 'business_rule', 'Extension in Export Obligation Period', '(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', '(c)
Request for extension in EO Period shall be made to RA concerned within 6
months from the date of expiry of original EO Period.', '(b)
In case of extension of Export obligation period beyond 6 years, two
extensions, from date of expiry, of one year each or two years in one go at
the choice of authorisation holder, may be considered by RA concerned
with composition fee as under:
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
20,000
More than ₹2 Crores to 10 Crores
30,000
Above ₹10 Crores
60,000
No refund of earlier paid Composition Fee shall be admissible.', '(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.16 - Extension in Export Obligation Period.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_16-R009', '5.16', '(d)
Notwithstanding sub-para (a) above, sub-paras (b) and (c) above shall also
be applicable for authorisations issued under FTP (2015-20).', 'business_rule', 'Extension in Export Obligation Period', '(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', '(d)
Notwithstanding sub-para (a) above, sub-paras (b) and (c) above shall also
be applicable for authorisations issued under FTP (2015-20).', '(d)
Notwithstanding sub-para (a) above, sub-paras (b) and (c) above shall also
be applicable for authorisations issued under FTP (2015-20).', '(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.16 - Extension in Export Obligation Period.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_16-R010', '5.16', '(e)
For implementation of all PRC decisions involving levy of Composition Fee
while allowing extension in block-wise/EO period and/or regularisation of
exports already made, the applicable Composition Fee shall be as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 30,000
More than ₹2 Crores to 10 Crores 60,000
Above ₹10 Crores 1,00,000
No refund of earlier paid Composition Fee shall be admissible.', 'business_rule', 'Extension in Export Obligation Period', '(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', '(e)
For implementation of all PRC decisions involving levy of Composition Fee
while allowing extension in block-wise/EO period and/or regularisation of
exports already made, the applicable Composition Fee shall be as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 30,000
More than ₹2 Crores to 10 Crores 60,000
Above ₹10 Crores 1,00,000
No refund of earlier paid Composition Fee shall be admissible.', '(e)
For implementation of all PRC decisions involving levy of Composition Fee
while allowing extension in block-wise/EO period and/or regularisation of
exports already made, the applicable Composition Fee shall be as under:-
Duty Saved value of EPCG Composition fee to be
Authorisation issued levied (in Rupees)
Up to ₹2 Crores 30,000
More than ₹2 Crores to 10 Crores 60,000
Above ₹10 Crores 1,00,000
No refund of earlier paid Composition Fee shall be admissible.', '(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.16 - Extension in Export Obligation Period.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_16-R011', '5.16', '(f) Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', 'business_rule', 'Extension in Export Obligation Period', '(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', '(f) Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', 'Para 5.16(b) amended vide Public Notice No.', '(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.16 - Extension in Export Obligation Period.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_16-R012', '5.16', '51/2025-26 dated 06.03.2026
11
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 30,000 |
More than ₹2 Crores to 10 Crores 60,000
Above ₹10 Crores 1,00,000 |
11
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
30,000
More than ₹2 Crores to 10 Crores
60,000
Above ₹10 Crores
1,00,000
No refund of earlier paid Composition Fee shall be admissible.', 'business_rule', 'Extension in Export Obligation Period', '(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', '51/2025-26 dated 06.03.2026
11
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 30,000 |
More than ₹2 Crores to 10 Crores 60,000
Above ₹10 Crores 1,00,000 |
11
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
30,000
More than ₹2 Crores to 10 Crores
60,000
Above ₹10 Crores
1,00,000
No refund of earlier paid Composition Fee shall be admissible.', '51/2025-26 dated 06.03.2026
11
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 30,000 |
More than ₹2 Crores to 10 Crores 60,000
Above ₹10 Crores 1,00,000 |
11
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
30,000
More than ₹2 Crores to 10 Crores
60,000
Above ₹10 Crores
1,00,000
No refund of earlier paid Composition Fee shall be admissible.', '(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.16 - Extension in Export Obligation Period.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_16-R013', '5.16', '(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', 'business_rule', 'Extension in Export Obligation Period', '(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', '(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', '51/2025-26 dated 06.03.2026
11
Duty Saved value of EPCG | Composition fee to be
Authorisation issued | levied (in Rupees)
Up to ₹2 Crores 30,000 |
More than ₹2 Crores to 10 Crores 60,000
Above ₹10 Crores 1,00,000 |
11
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
30,000
More than ₹2 Crores to 10 Crores
60,000
Above ₹10 Crores
1,00,000
No refund of earlier paid Composition Fee shall be admissible.', '(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.', 'DEKAI should produce a compliance decision for 5.16 - Extension in Export Obligation Period.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.16', '5.16 Extension in Export Obligation Period
(a) Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.16', '(b) In case of extension of Export obligation period beyond 6 years, two
extensions, from date of expiry, of one year each or two years in one go at
the choice of authorisation holder, may be considered by RA concerned
with composition fee as under:
Composition fee to be
Duty Saved value of EPCG
levied (in Rupees)
Authorisation issued
Up to ₹2 Crores 20,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 60,000
No refund of earlier paid Composition Fee shall be admissible.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.16', 'However, RA may
consider the request for extension received after 6 months, but within the
extendable validity of EO period, with a late fee of Rs.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.16', 'The request
for extension for regularisation purpose, from 6th to 8th year, may also be
considered after expiry of EO period on payment of late fee of Rs.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.16', '(e) For implementation of all PRC decisions involving levy of Composition Fee
while allowing extension in block-wise/EO period and/or regularisation of
exports already made, the applicable Composition Fee shall be as under:-
10
| Composition fee to be
Duty Saved value of EPCG |
| levied (in Rupees)
Authorisation issued |
Up to ₹2 Crores 20,000 |
More than ₹2 Crores to 10 Crores 30,000 |
Above ₹10 Crores 60,000 |
10
5.16 Extension in Export Obligation Period
(a)
Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.16', '(b)
In case of extension of Export obligation period beyond 6 years, two
extensions, from date of expiry, of one year each or two years in one go at
the choice of authorisation holder, may be considered by RA concerned
with composition fee as under:
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
20,000
More than ₹2 Crores to 10 Crores
30,000
Above ₹10 Crores
60,000
No refund of earlier paid Composition Fee shall be admissible.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.16', '(f) Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.16', '(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.16', 'RA');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.16', 'Request for extension in EO Period shall be made to RA');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.16', '(b) In case of extension of Export obligation period beyond 6 years, two
extensions, from date of expiry, of one year each or two years in one go at
the choice of authorisation holder, may be considered by RA concerned
with composition fee as under:
Composition fee to be
Duty Saved value of EPCG
levied (in Rupees)
Authorisation issued
Up to ₹2 Crores 20,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 60,000
No refund of earlier paid Composition Fee shall be admissible.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.16', '(c) Request for extension in EO Period shall be made to RA concerned within 6
months from the date of expiry of original EO Period.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.16', 'However, RA may
consider the request for extension received after 6 months, but within the
extendable validity of EO period, with a late fee of Rs.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.16', 'The request
for extension for regularisation purpose, from 6th to 8th year, may also be
considered after expiry of EO period on payment of late fee of Rs.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.16', 'However, EO extension, beyond 8 years
from date of issue of authorisation, shall not be allowed by RA under this
provision.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.16', '(b)
In case of extension of Export obligation period beyond 6 years, two
extensions, from date of expiry, of one year each or two years in one go at
the choice of authorisation holder, may be considered by RA concerned
with composition fee as under:
Duty Saved value of EPCG
Authorisation issued
Composition fee to be
levied (in Rupees)
Up to ₹2 Crores
20,000
More than ₹2 Crores to 10 Crores
30,000
Above ₹10 Crores
60,000
No refund of earlier paid Composition Fee shall be admissible.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.16', '(c)
Request for extension in EO Period shall be made to RA concerned within 6
months from the date of expiry of original EO Period.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('5.16', 'However, RA may
consider the request for extension received after 6 months, but within the
extendable validity of EO period, with a late fee of Rs.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('5.16', 'However, EO extension, beyond 8 years
from date of issue of authorisation, shall not be allowed by RA under this
provision.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('5.16', '(d) Notwithstanding sub-para (a) above, sub-paras (b) and (c) above shall also
be applicable for authorisations issued under FTP (2015-20).');
INSERT INTO exceptions (section_code, exception_text) VALUES ('5.16', '(d)
Notwithstanding sub-para (a) above, sub-paras (b) and (c) above shall also
be applicable for authorisations issued under FTP (2015-20).');
INSERT INTO exceptions (section_code, exception_text) VALUES ('5.16', '(f) Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('5.16', '(f)
Notwithstanding the provisions contained in Para 5.16 of the Handbook of
Procedures (HBP), 2023, in respect of EPCG Authorisations where the original
or extended Export Obligation (EO) period is expiring during the period
01.03.2026 to 31.05.2026, the EO period shall stand automatically extended up
to 31.08.2026.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.16', 1, 'Evaluate condition: 5.16 Extension in Export Obligation Period
(a) Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.16', 2, 'Evaluate condition: (b) In case of extension of Export obligation period beyond 6 years, two
extensions, from date of expiry, of one year each or two years in one go at
the choice of authorisation holder, may be considered by RA concerned
with composition fee as under:
Composition fee to be
Duty Saved value of EPCG
levied (in Rupees)
Authorisation issued
Up to ₹2 Crores 20,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 60,000
No refund of earlier paid Composition Fee shall be admissible.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.16', 3, 'Evaluate condition: However, RA may
consider the request for extension received after 6 months, but within the
extendable validity of EO period, with a late fee of Rs.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.16', 4, '5.16 Extension in Export Obligation Period
(a) Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.16', 5, '(b) In case of extension of Export obligation period beyond 6 years, two
extensions, from date of expiry, of one year each or two years in one go at
the choice of authorisation holder, may be considered by RA concerned
with composition fee as under:
Composition fee to be
Duty Saved value of EPCG
levied (in Rupees)
Authorisation issued
Up to ₹2 Crores 20,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 60,000
No refund of earlier paid Composition Fee shall be admissible.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.16', 6, 'The request
for extension for regularisation purpose, from 6th to 8th year, may also be
considered after expiry of EO period on payment of late fee of Rs.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.16', 7, 'This fee is in addition to the composition fee that may be payable on account
of shortfall in export obligation.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.16', 8, 'However, EO extension, beyond 8 years
from date of issue of authorisation, shall not be allowed by RA under this
provision.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.16', 9, '(d) Notwithstanding sub-para (a) above, sub-paras (b) and (c) above shall also
be applicable for authorisations issued under FTP (2015-20).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.16', 10, 'Run validation: 5.16 Extension in Export Obligation Period
(a) Extension in Export Obligation Period of EPCG authorisation issued prior to
Notification of Foreign Trade Policy 2023 shall be governed by relevant
provisions of HBP applicable on the date of issue of authorisation.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.16', 11, 'Run validation: (b) In case of extension of Export obligation period beyond 6 years, two
extensions, from date of expiry, of one year each or two years in one go at
the choice of authorisation holder, may be considered by RA concerned
with composition fee as under:
Composition fee to be
Duty Saved value of EPCG
levied (in Rupees)
Authorisation issued
Up to ₹2 Crores 20,000
More than ₹2 Crores to 10 Crores 30,000
Above ₹10 Crores 60,000
No refund of earlier paid Composition Fee shall be admissible.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.16', 12, 'Run validation: (c) Request for extension in EO Period shall be made to RA concerned within 6
months from the date of expiry of original EO Period.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.16', 13, 'Handle exception: However, RA may
consider the request for extension received after 6 months, but within the
extendable validity of EO period, with a late fee of Rs.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'HBP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'two');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'one');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'may');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'fee');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'but');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'not');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'FTP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'all');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'PRC');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'iii');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'date');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'case');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'from');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'year');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'keywords', 'each');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'tags', '5.16');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'tags', 'Extension in Export Obligation Period');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.16', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.17', 'Relief in Average Export Obligation', '5.17 Relief in Average Export Obligation
(a) To provide relief to exporters of those sectors where total exports in that
sector/product group has declined by more than 5% as compared to the
previous year, average export obligation for the year may be reduced
proportionate to reduction in exports of that particular sector/product
group during the relevant year as against the preceding year.', 'Indha Relief in Average Export Obligation section-la, 5.17 Relief in Average export Obligation
(a) To provide relief to exporters of those sectors where total exports in that
sector/product group has declined by more than 5% as compared to the
previous year, average export obligation for the year may be reduced
proportionate to reduction in exports of that particular sector/product
group during the relevant year as against the preceding year.', '5.17 Relief in Average Export Obligation
(a) To provide relief to exporters of those sectors where total exports in that
sector/product group has declined by more than 5% as compared to the
previous year, average export obligation for the year may be reduced
proportionate to reduction in exports of that particular sector/product
group during the relevant year as against the preceding year. However, in
case export decline is continuous over consecutive years, the base year for
calculation of eligibility and calculation of reduction in average export
obligation will be taken as the year after which the exports have shown
continuous decline. (b) The sectors /product groups for which this relaxation is to be allowed shall
be conveyed by the DGFT to all the RAs within seven months of the end of
the previous financial year and the RAs shall re-fix the annual average EO
for previous year accordingly for exporters in that sector/ product group.', 'Relief in Average Export Obligation governs how DGFT business controls should be applied, validated, and enforced.', 'Relief in Average Export Obligation explains the operating rule set that DEKAI should enforce. Key control points include (b) The sectors /product groups for which this relaxation is to be allowed shall
be conveyed by the DGFT to all the RAs within seven months of the end of
the previous financial year and the RAs shall re-fix the annual average EO
for previous year accordingly for exporters in that sector/ product group.', 'Indha Relief in Average Export Obligation section-la, Relief in Average export Obligation explains the operating rule set that DEKAI should enforce. Key control points include (b) The sectors /product groups for which this relaxation is to be allowed kandippa
be conveyed by the DGFT to all the RAs within seven months of the end of
the previous financial year and the RAs kandippa re-fix the annual average EO
for previous year accordingly for exporters in that sector/ product group.', '5.17 Relief in Average Export Obligation
(a) To provide relief to exporters of those sectors where total exports in that
sector/product group has declined by more than 5% as compared to the
previous year, average export obligation for the year may be reduced
proportionate to reduction in exports of that particular sector/product
group during the relevant year as against the preceding year. However, in
case export decline is continuous over consecutive years, the base year for
calculation of eligibility and calculation of reduction in average export
obligation will be taken as the year after which the exports have shown
continuous decline.
(b) The sectors /product groups for which this relaxation is to be allowed shall
be conveyed by the DGFT to all the RAs within seven months of the end of
the previous financial year and the RAs shall re-fix the annual average EO
for previous year accordingly for exporters in that sector/ product group.
5.17 Relief in Average Export Obligation
(a)
To provide relief to exporters of those sectors where total exports in that
sector/product group has declined by more than 5% as compared to the
previous year, average export obligation for the year may be reduced
proportionate to reduction in exports of that particular sector/product
group during the relevant year as against the preceding year. However, in
case export decline is continuous over consecutive years, the base year for
calculation of eligibility and calculation of reduction in average export
obligation will be taken as the year after which the exports have shown
continuous decline.
(b)
The sectors /product groups for which this relaxation is to be allowed shall
be conveyed by the DGFT to all the RAs within seven months of the end of
the previous financial year and the RAs shall re-fix the annual average EO
for previous year accordingly for exporters in that sector/ product group.', '[12]', '["has", "the", "for", "may", "and", "all", "RAs", "end", "that", "more", "than", "year", "case", "over", "base", "will", "have", "this", "DGFT", "those"]', 'Provide knowledge guidance for Relief in Average Export Obligation.', '["5.17", "Relief in Average Export Obligation", "business-rule", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_17-R001', '5.17', '(b) The sectors /product groups for which this relaxation is to be allowed shall
be conveyed by the DGFT to all the RAs within seven months of the end of
the previous financial year and the RAs shall re-fix the annual average EO
for previous year accordingly for exporters in that sector/ product group.', 'business_rule', 'Relief in Average Export Obligation', '5.17 Relief in Average Export Obligation
(a) To provide relief to exporters of those sectors where total exports in that
sector/product group has declined by more than 5% as compared to the
previous year, average export obligation for the year may be reduced
proportionate to reduction in exports of that particular sector/product
group during the relevant year as against the preceding year.', '(b) The sectors /product groups for which this relaxation is to be allowed shall
be conveyed by the DGFT to all the RAs within seven months of the end of
the previous financial year and the RAs shall re-fix the annual average EO
for previous year accordingly for exporters in that sector/ product group.', 'Manual review required.', 'However, in
case export decline is continuous over consecutive years, the base year for
calculation of eligibility and calculation of reduction in average export
obligation will be taken as the year after which the exports have shown
continuous decline.', 'DEKAI should produce a compliance decision for 5.17 - Relief in Average Export Obligation.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_17-R002', '5.17', '(b)
The sectors /product groups for which this relaxation is to be allowed shall
be conveyed by the DGFT to all the RAs within seven months of the end of
the previous financial year and the RAs shall re-fix the annual average EO
for previous year accordingly for exporters in that sector/ product group.', 'business_rule', 'Relief in Average Export Obligation', 'However, in
case export decline is continuous over consecutive years, the base year for
calculation of eligibility and calculation of reduction in average export
obligation will be taken as the year after which the exports have shown
continuous decline.', '(b)
The sectors /product groups for which this relaxation is to be allowed shall
be conveyed by the DGFT to all the RAs within seven months of the end of
the previous financial year and the RAs shall re-fix the annual average EO
for previous year accordingly for exporters in that sector/ product group.', 'Manual review required.', 'However, in
case export decline is continuous over consecutive years, the base year for
calculation of eligibility and calculation of reduction in average export
obligation will be taken as the year after which the exports have shown
continuous decline.', 'DEKAI should produce a compliance decision for 5.17 - Relief in Average Export Obligation.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.17', '5.17 Relief in Average Export Obligation
(a) To provide relief to exporters of those sectors where total exports in that
sector/product group has declined by more than 5% as compared to the
previous year, average export obligation for the year may be reduced
proportionate to reduction in exports of that particular sector/product
group during the relevant year as against the preceding year.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.17', 'However, in
case export decline is continuous over consecutive years, the base year for
calculation of eligibility and calculation of reduction in average export
obligation will be taken as the year after which the exports have shown
continuous decline.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.17', '5.17 Relief in Average Export Obligation
(a)
To provide relief to exporters of those sectors where total exports in that
sector/product group has declined by more than 5% as compared to the
previous year, average export obligation for the year may be reduced
proportionate to reduction in exports of that particular sector/product
group during the relevant year as against the preceding year.');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.17', 'DGFT');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.17', 'However, in
case export decline is continuous over consecutive years, the base year for
calculation of eligibility and calculation of reduction in average export
obligation will be taken as the year after which the exports have shown
continuous decline.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.17', '(b) The sectors /product groups for which this relaxation is to be allowed shall
be conveyed by the DGFT to all the RAs within seven months of the end of
the previous financial year and the RAs shall re-fix the annual average EO
for previous year accordingly for exporters in that sector/ product group.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.17', '(b)
The sectors /product groups for which this relaxation is to be allowed shall
be conveyed by the DGFT to all the RAs within seven months of the end of
the previous financial year and the RAs shall re-fix the annual average EO
for previous year accordingly for exporters in that sector/ product group.');
INSERT INTO exceptions (section_code, exception_text) VALUES ('5.17', 'However, in
case export decline is continuous over consecutive years, the base year for
calculation of eligibility and calculation of reduction in average export
obligation will be taken as the year after which the exports have shown
continuous decline.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.17', 1, 'Evaluate condition: 5.17 Relief in Average Export Obligation
(a) To provide relief to exporters of those sectors where total exports in that
sector/product group has declined by more than 5% as compared to the
previous year, average export obligation for the year may be reduced
proportionate to reduction in exports of that particular sector/product
group during the relevant year as against the preceding year.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.17', 2, 'Evaluate condition: However, in
case export decline is continuous over consecutive years, the base year for
calculation of eligibility and calculation of reduction in average export
obligation will be taken as the year after which the exports have shown
continuous decline.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.17', 3, 'Evaluate condition: 5.17 Relief in Average Export Obligation
(a)
To provide relief to exporters of those sectors where total exports in that
sector/product group has declined by more than 5% as compared to the
previous year, average export obligation for the year may be reduced
proportionate to reduction in exports of that particular sector/product
group during the relevant year as against the preceding year.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.17', 4, 'Run validation: (b) The sectors /product groups for which this relaxation is to be allowed shall
be conveyed by the DGFT to all the RAs within seven months of the end of
the previous financial year and the RAs shall re-fix the annual average EO
for previous year accordingly for exporters in that sector/ product group.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.17', 5, 'Run validation: (b)
The sectors /product groups for which this relaxation is to be allowed shall
be conveyed by the DGFT to all the RAs within seven months of the end of
the previous financial year and the RAs shall re-fix the annual average EO
for previous year accordingly for exporters in that sector/ product group.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.17', 6, 'Handle exception: However, in
case export decline is continuous over consecutive years, the base year for
calculation of eligibility and calculation of reduction in average export
obligation will be taken as the year after which the exports have shown
continuous decline.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'has');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'may');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'all');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'RAs');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'end');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'that');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'more');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'than');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'year');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'case');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'over');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'base');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'will');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'have');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'this');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'DGFT');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'keywords', 'those');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'tags', '5.17');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'tags', 'Relief in Average Export Obligation');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.17', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.18', 'Maintenance of Annual Average Export Obligation', '5.18 Maintenance of Annual Average Export Obligation
The excess exports done towards the average export obligation fulfilment of an
EPCG authorisation during a year can be used to offset any shortfall in the Average
EO done in other year(s) of the EO period or the block period as the case may be
provided Average EO imposed is maintained on an overall basis, within the block
period or the EO period as applicable.', 'Indha Maintenance of Annual Average Export Obligation section-la, 5.18 Maintenance of Annual Average export Obligation
The excess exports done towards the average export obligation fulfilment of an
EPCG authorisation during a year can be used to offset any shortfall in the Average
EO done in other year(s) of the EO period or the block period as the case may be
provided Average EO imposed is maintained on an overall basis, within the block
period or the EO period as applicable.', '5.18 Maintenance of Annual Average Export Obligation
The excess exports done towards the average export obligation fulfilment of an
EPCG authorisation during a year can be used to offset any shortfall in the Average
EO done in other year(s) of the EO period or the block period as the case may be
provided Average EO imposed is maintained on an overall basis, within the block
period or the EO period as applicable.', '5.18 Maintenance of Annual Average Export Obligation
The excess exports done towards the average export obligation fulfilment of an
EPCG authorisation during a year can be used to offset any shortfall in the Average
EO done in other year(s) of the EO period or the block period as the case may be
provided Average EO imposed is maintained on an overall basis, within the block
period or the EO period as applicable.', '5.18 Maintenance of Annual Average Export Obligation
The excess exports done towards the average export obligation fulfilment of an
EPCG authorisation during a year can be used to offset any shortfall in the Average
EO done in other year(s) of the EO period or the block period as the case may be
provided Average EO imposed is maintained on an overall basis, within the block
period or the EO period as applicable.', 'Indha Maintenance of Annual Average Export Obligation section-la, 5.18 Maintenance of Annual Average export Obligation
The excess exports done towards the average export obligation fulfilment of an
EPCG authorisation during a year can be used to offset any shortfall in the Average
EO done in other year(s) of the EO period or the block period as the case may be
provided Average EO imposed is maintained on an overall basis, within the block
period or the EO period as applicable.', '5.18 Maintenance of Annual Average Export Obligation
The excess exports done towards the average export obligation fulfilment of an
EPCG authorisation during a year can be used to offset any shortfall in the Average
EO done in other year(s) of the EO period or the block period as the case may be
provided Average EO imposed is maintained on an overall basis, within the block
period or the EO period as applicable.', '[12]', '["The", "can", "any", "may", "done", "EPCG", "year", "used", "case", "other", "block", "basis", "Annual", "Export", "excess", "during", "offset", "period", "within", "Average"]', 'Support Maintenance of Annual Average Export Obligation processing and compliance validation.', '["5.18", "Maintenance of Annual Average Export Obligation", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_18-R001', '5.18', 'IF validations pass THEN recommend action: 5.18 Maintenance of Annual Average Export Obligation
The excess exports done towards the average export obligation fulfilment of an
EPCG authorisation during a year can be used to offset any shortfall in the Average
EO done in other year(s) of the EO period or the block period as the case may be
provided Average EO imposed is maintained on an overall basis, within the block
period or the EO period as applicable.', 'business_rule', 'Maintenance of Annual Average Export Obligation', 'Section 5.18 is applicable', 'Not explicitly covered in uploaded documents.', '5.18 Maintenance of Annual Average Export Obligation
The excess exports done towards the average export obligation fulfilment of an
EPCG authorisation during a year can be used to offset any shortfall in the Average
EO done in other year(s) of the EO period or the block period as the case may be
provided Average EO imposed is maintained on an overall basis, within the block
period or the EO period as applicable.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.18 - Maintenance of Annual Average Export Obligation.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.18', '5.18 Maintenance of Annual Average Export Obligation
The excess exports done towards the average export obligation fulfilment of an
EPCG authorisation during a year can be used to offset any shortfall in the Average
EO done in other year(s) of the EO period or the block period as the case may be
provided Average EO imposed is maintained on an overall basis, within the block
period or the EO period as applicable.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.18', 1, '5.18 Maintenance of Annual Average Export Obligation
The excess exports done towards the average export obligation fulfilment of an
EPCG authorisation during a year can be used to offset any shortfall in the Average
EO done in other year(s) of the EO period or the block period as the case may be
provided Average EO imposed is maintained on an overall basis, within the block
period or the EO period as applicable.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'The');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'can');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'any');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'may');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'done');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'year');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'used');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'case');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'other');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'block');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'basis');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'Annual');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'Export');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'excess');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'during');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'offset');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'period');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'within');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'keywords', 'Average');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'tags', '5.18');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'tags', 'Maintenance of Annual Average Export Obligation');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.18', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.19', 'Automatic EO extension in the event of ban on export product', '5.19 Automatic EO extension in the event of ban on export product
Whenever a ban/restriction is imposed on export of any product, export
obligation period in respect of EPCG authorisations already issued prior to
imposition of ban on such export products would stand automatically extended
for a period equivalent to duration of such ban, without any composition fee.', 'Indha Automatic EO extension in the event of ban on export product section-la, 5.19 Automatic EO extension in the event of ban on export product
Whenever a ban/restriction is imposed on export of any product, export
obligation period in respect of EPCG authorisations already issued prior to
imposition of ban on such export products would stand automatically extended
for a period equivalent to duration of such ban, without any composition fee.', '5.19 Automatic EO extension in the event of ban on export product
Whenever a ban/restriction is imposed on export of any product, export
obligation period in respect of EPCG authorisations already issued prior to
imposition of ban on such export products would stand automatically extended
for a period equivalent to duration of such ban, without any composition fee. Authorisation holder would not be required to maintain average EO as well for the
ban period.', 'Automatic EO extension in the event of ban on export product governs how DGFT business controls should be applied, validated, and enforced.', 'Automatic EO extension in the event of ban on export product explains the operating rule set that DEKAI should enforce. Key control points include Authorisation holder would not be required to maintain average EO as well for the
ban period. The section also drives actions such as 5.19 Automatic EO extension in the event of ban on export product
Whenever a ban/restriction is imposed on export of any product, export
obligation period in respect of EPCG authorisations already issued prior to
imposition of ban on such export products would stand automatically extended
for a period equivalent to duration of such ban, without any composition fee..', 'Indha Automatic EO extension in the event of ban on export product section-la, Automatic EO extension in the event of ban on export product explains the operating rule set that DEKAI should enforce. Key control points include Authorisation holder would not be required to maintain average EO as well for the
ban period. The section also drives actions such as 5.19 Automatic EO extension in the event of ban on export product
Whenever a ban/restriction is imposed on export of any product, export
obligation period in respect of EPCG authorisations already issued prior to
imposition of ban on such export products would stand automatically extended
for a period equivalent to duration of such ban, without any composition fee..', '5.19 Automatic EO extension in the event of ban on export product
Whenever a ban/restriction is imposed on export of any product, export
obligation period in respect of EPCG authorisations already issued prior to
imposition of ban on such export products would stand automatically extended
for a period equivalent to duration of such ban, without any composition fee.
Authorisation holder would not be required to maintain average EO as well for the
ban period.', '[12]', '["the", "ban", "any", "for", "fee", "not", "EPCG", "such", "well", "event", "prior", "would", "stand", "export", "period", "issued", "holder", "product", "imposed", "respect"]', 'Support Automatic EO extension in the event of ban on export product processing and compliance validation.', '["5.19", "Automatic EO extension in the event of ban on export product", "business-rule", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_19-R001', '5.19', 'Authorisation holder would not be required to maintain average EO as well for the
ban period.', 'business_rule', 'Automatic EO extension in the event of ban on export product', '5.19 Automatic EO extension in the event of ban on export product
Whenever a ban/restriction is imposed on export of any product, export
obligation period in respect of EPCG authorisations already issued prior to
imposition of ban on such export products would stand automatically extended
for a period equivalent to duration of such ban, without any composition fee.', 'Authorisation holder would not be required to maintain average EO as well for the
ban period.', '5.19 Automatic EO extension in the event of ban on export product
Whenever a ban/restriction is imposed on export of any product, export
obligation period in respect of EPCG authorisations already issued prior to
imposition of ban on such export products would stand automatically extended
for a period equivalent to duration of such ban, without any composition fee.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.19 - Automatic EO extension in the event of ban on export product.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.19', '5.19 Automatic EO extension in the event of ban on export product
Whenever a ban/restriction is imposed on export of any product, export
obligation period in respect of EPCG authorisations already issued prior to
imposition of ban on such export products would stand automatically extended
for a period equivalent to duration of such ban, without any composition fee.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.19', 1, 'Evaluate condition: 5.19 Automatic EO extension in the event of ban on export product
Whenever a ban/restriction is imposed on export of any product, export
obligation period in respect of EPCG authorisations already issued prior to
imposition of ban on such export products would stand automatically extended
for a period equivalent to duration of such ban, without any composition fee.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.19', 2, '5.19 Automatic EO extension in the event of ban on export product
Whenever a ban/restriction is imposed on export of any product, export
obligation period in respect of EPCG authorisations already issued prior to
imposition of ban on such export products would stand automatically extended
for a period equivalent to duration of such ban, without any composition fee.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.19', 3, 'Authorisation holder would not be required to maintain average EO as well for the
ban period.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.19', 4, 'Run validation: Authorisation holder would not be required to maintain average EO as well for the
ban period.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'ban');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'any');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'fee');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'not');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'such');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'well');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'event');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'prior');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'would');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'stand');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'export');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'period');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'issued');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'holder');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'product');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'imposed');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'keywords', 'respect');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'tags', '5.19');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'tags', 'Automatic EO extension in the event of ban on export product');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.19', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.20', 'Export Obligation Discharge Certificate (EODC)', '5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.', 'Indha Export Obligation Discharge Certificate (EODC) section-la, 5.20 export Obligation Discharge Certificate (EODC)
(a) Authorisation holder kandippa apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.', '5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment. (b) On being satisfied, RA concerned shall issue EODC to the EPCG authorisation
holder and an online copy will be forwarded to ICEGATE through API message
exchange for further action by Jurisdictional Customs Authorities with whom
BG/LUT has been executed. (c) RA shall process such applications ordinarily within 30 days.', 'Export Obligation Discharge Certificate (EODC) governs how DGFT business controls should be applied, validated, and enforced.', 'Export Obligation Discharge Certificate (EODC) explains the operating rule set that DEKAI should enforce. Key control points include 5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment. The section also drives actions such as 5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment..', 'Indha Export Obligation Discharge Certificate (EODC) section-la, export Obligation Discharge Certificate (EODC) explains the operating rule set that DEKAI should enforce. Key control points include 5.20 export Obligation Discharge Certificate (EODC)
(a) Authorisation holder kandippa apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment. The section also drives actions such as 5.20 export Obligation Discharge Certificate (EODC)
(a) Authorisation holder kandippa apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment..', '5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.
(b) On being satisfied, RA concerned shall issue EODC to the EPCG authorisation
holder and an online copy will be forwarded to ICEGATE through API message
exchange for further action by Jurisdictional Customs Authorities with whom
BG/LUT has been executed.
(c) RA shall process such applications ordinarily within 30 days. Shortcomings, if
any, shall be pointed out normally in one go. Once documents are complete in all
12
12
5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.
(b) On being satisfied, RA concerned shall issue EODC to the EPCG authorisation
holder and an online copy will be forwarded to ICEGATE through API message
exchange for further action by Jurisdictional Customs Authorities with whom
BG/LUT has been executed.
(c) RA shall process such applications ordinarily within 30 days. Shortcomings, if
any, shall be pointed out normally in one go. Once documents are complete in all
respects, export obligation shall be discharged within 30 days of receipt of
complete documents /information.', '[12, 13]', '["for", "ANF", "the", "and", "API", "has", "any", "out", "one", "are", "all", "EODC", "with", "EPCG", "copy", "will", "whom", "been", "such", "days"]', 'Support Export Obligation Discharge Certificate (EODC) processing and compliance validation.', '["5.20", "Export Obligation Discharge Certificate (EODC)", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_20-R001', '5.20', '5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.', 'business_rule', 'Export Obligation Discharge Certificate (EODC)', '5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.', '5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.', '5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.20 - Export Obligation Discharge Certificate (EODC).');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_20-R002', '5.20', '(b) On being satisfied, RA concerned shall issue EODC to the EPCG authorisation
holder and an online copy will be forwarded to ICEGATE through API message
exchange for further action by Jurisdictional Customs Authorities with whom
BG/LUT has been executed.', 'business_rule', 'Export Obligation Discharge Certificate (EODC)', 'any', '(b) On being satisfied, RA concerned shall issue EODC to the EPCG authorisation
holder and an online copy will be forwarded to ICEGATE through API message
exchange for further action by Jurisdictional Customs Authorities with whom
BG/LUT has been executed.', '(b) On being satisfied, RA concerned shall issue EODC to the EPCG authorisation
holder and an online copy will be forwarded to ICEGATE through API message
exchange for further action by Jurisdictional Customs Authorities with whom
BG/LUT has been executed.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.20 - Export Obligation Discharge Certificate (EODC).');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_20-R003', '5.20', '(c) RA shall process such applications ordinarily within 30 days.', 'business_rule', 'Export Obligation Discharge Certificate (EODC)', 'Once documents are complete in all
12
12
5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.', '(c) RA shall process such applications ordinarily within 30 days.', 'Once documents are complete in all
12
12
5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.20 - Export Obligation Discharge Certificate (EODC).');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_20-R004', '5.20', 'Shortcomings, if
any, shall be pointed out normally in one go.', 'business_rule', 'Export Obligation Discharge Certificate (EODC)', 'Once documents are complete in all
12
12
5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.', 'Shortcomings, if
any, shall be pointed out normally in one go.', 'Once documents are complete in all
12
12
5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.20 - Export Obligation Discharge Certificate (EODC).');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_20-R005', '5.20', 'Once documents are complete in all
12
12
5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.', 'business_rule', 'Export Obligation Discharge Certificate (EODC)', 'Once documents are complete in all
12
12
5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.', 'Once documents are complete in all
12
12
5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.', 'Once documents are complete in all
12
12
5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.20 - Export Obligation Discharge Certificate (EODC).');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_20-R006', '5.20', 'Once documents are complete in all
respects, export obligation shall be discharged within 30 days of receipt of
complete documents /information.', 'business_rule', 'Export Obligation Discharge Certificate (EODC)', 'Once documents are complete in all
12
12
5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.', 'Once documents are complete in all
respects, export obligation shall be discharged within 30 days of receipt of
complete documents /information.', 'Once documents are complete in all
12
12
5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.20 - Export Obligation Discharge Certificate (EODC).');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.20', '5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.20', 'Shortcomings, if
any, shall be pointed out normally in one go.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.20', 'Once documents are complete in all
12
12
5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.');
INSERT INTO documents (section_code, document_name) VALUES ('5.20', 'Export Obligation Discharge Certificate');
INSERT INTO documents (section_code, document_name) VALUES ('5.20', '(b) On being satisfied, RA concerned shall issue EODC to the EPCG authorisation
holder and an online copy will be forwarded to ICEGATE through API message
exchange for further action by Jurisdictional Customs Authorities with whom
BG/LUT has been executed.');
INSERT INTO documents (section_code, document_name) VALUES ('5.20', '(c) RA shall process such applications ordinarily within 30 days.');
INSERT INTO documents (section_code, document_name) VALUES ('5.20', 'Once documents are complete in all
respects, export obligation shall be discharged within 30 days of receipt of
complete documents /information.');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.20', 'RA');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.20', 'Customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.20', 'Jurisdictional Customs Authorities');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.20', '(c) RA shall process such applications ordinarily within 30 days.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.20', 'Once documents are complete in all
respects, export obligation shall be discharged within 30 days of receipt of
complete documents /information.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.20', 1, 'Evaluate condition: 5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.20', 2, 'Evaluate condition: Shortcomings, if
any, shall be pointed out normally in one go.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.20', 3, 'Evaluate condition: Once documents are complete in all
12
12
5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.20', 4, '5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.20', 5, '(b) On being satisfied, RA concerned shall issue EODC to the EPCG authorisation
holder and an online copy will be forwarded to ICEGATE through API message
exchange for further action by Jurisdictional Customs Authorities with whom
BG/LUT has been executed.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.20', 6, 'Once documents are complete in all
12
12
5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.20', 7, 'Run validation: 5.20 Export Obligation Discharge Certificate (EODC)
(a) Authorisation holder shall apply for online EODC in ANF 5B with documents
prescribed therein as a proof of EO fulfillment.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.20', 8, 'Run validation: (b) On being satisfied, RA concerned shall issue EODC to the EPCG authorisation
holder and an online copy will be forwarded to ICEGATE through API message
exchange for further action by Jurisdictional Customs Authorities with whom
BG/LUT has been executed.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.20', 9, 'Run validation: (c) RA shall process such applications ordinarily within 30 days.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'ANF');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'API');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'has');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'any');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'out');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'one');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'are');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'all');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'EODC');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'with');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'copy');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'will');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'whom');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'been');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'such');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'keywords', 'days');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'tags', '5.20');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'tags', 'Export Obligation Discharge Certificate (EODC)');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.20', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.21', 'Regularization of bonafide default and exit from EPCG scheme', '5.21 Regularization of bonafide default and exit from EPCG scheme
(a) Authorisation holder shall have the option to surrender the unutilised
authorisation at any point of time.', 'Indha Regularization of bonafide default and exit from EPCG scheme section-la, 5.21 Regularization of bonafide default and exit from EPCG scheme
(a) Authorisation holder kandippa have the option to surrender the unutilised
authorisation at any point of time.', '5.21 Regularization of bonafide default and exit from EPCG scheme
(a) Authorisation holder shall have the option to surrender the unutilised
authorisation at any point of time. In such cases no penalty or fees shall be
levied. (b) In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he shall pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
Authority.', 'Regularization of bonafide default and exit from EPCG scheme governs how DGFT business controls should be applied, validated, and enforced.', 'Regularization of bonafide default and exit from EPCG scheme explains the operating rule set that DEKAI should enforce. Key control points include 5.21 Regularization of bonafide default and exit from EPCG scheme
(a) Authorisation holder shall have the option to surrender the unutilised
authorisation at any point of time. The section also drives actions such as (b) In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he shall pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
Authority..', 'Indha Regularization of bonafide default and exit from EPCG scheme section-la, Regularization of bonafide default and exit from EPCG scheme explains the operating rule set that DEKAI should enforce. Key control points include 5.21 Regularization of bonafide default and exit from EPCG scheme
(a) Authorisation holder kandippa have the option to surrender the unutilised
authorisation at any point of time. The section also drives actions such as (b) In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he kandippa pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
authority..', '5.21 Regularization of bonafide default and exit from EPCG scheme
(a) Authorisation holder shall have the option to surrender the unutilised
authorisation at any point of time. In such cases no penalty or fees shall be
levied.
(b) In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he shall pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
Authority. Such facility can also be availed by EPCG authorisation holder to
exit at his option.
(c) In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).
(e) Authorisation holder can also provisionally pay duty and interest suo-
moto on the basis of self/own calculation as per the procedure specified in
paragraph 4.50 of HBP.
5.21 Regularization of bonafide default and exit from EPCG scheme
(a)
Authorisation holder shall have the option to surrender the unutilised
authorisation at any point of time. In such cases no penalty or fees shall be
levied.
(b)
In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he shall pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
Authority. Such facility can also be availed by EPCG authorisation holder to
exit at his option.
(c)
In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).
(e) Authorisation holder can also provisionally pay duty and interest suo-
moto on the basis of self/own calculation as per the procedure specified in
paragraph 4.50 of HBP.', '[13]', '["and", "the", "any", "pay", "can", "his", "FOR", "suo", "per", "HBP", "exit", "from", "EPCG", "have", "time", "such", "fees", "case", "with", "also"]', 'Support Regularization of bonafide default and exit from EPCG scheme processing and compliance validation.', '["5.21", "Regularization of bonafide default and exit from EPCG scheme", "business-rule", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_21-R001', '5.21', '5.21 Regularization of bonafide default and exit from EPCG scheme
(a) Authorisation holder shall have the option to surrender the unutilised
authorisation at any point of time.', 'business_rule', 'Regularization of bonafide default and exit from EPCG scheme', '(b) In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he shall pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
Authority.', '5.21 Regularization of bonafide default and exit from EPCG scheme
(a) Authorisation holder shall have the option to surrender the unutilised
authorisation at any point of time.', '(b) In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he shall pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
Authority.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.21 - Regularization of bonafide default and exit from EPCG scheme.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_21-R002', '5.21', 'In such cases no penalty or fees shall be
levied.', 'business_rule', 'Regularization of bonafide default and exit from EPCG scheme', '(c) In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).', 'In such cases no penalty or fees shall be
levied.', '(c) In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.21 - Regularization of bonafide default and exit from EPCG scheme.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_21-R003', '5.21', '(b) In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he shall pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
Authority.', 'business_rule', 'Regularization of bonafide default and exit from EPCG scheme', '(e) Authorisation holder can also provisionally pay duty and interest suo-
moto on the basis of self/own calculation as per the procedure specified in
paragraph 4.50 of HBP.', '(b) In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he shall pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
Authority.', '(e) Authorisation holder can also provisionally pay duty and interest suo-
moto on the basis of self/own calculation as per the procedure specified in
paragraph 4.50 of HBP.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.21 - Regularization of bonafide default and exit from EPCG scheme.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_21-R004', '5.21', '(c) In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).', 'business_rule', 'Regularization of bonafide default and exit from EPCG scheme', '(b)
In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he shall pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
Authority.', '(c) In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).', '(b)
In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he shall pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
Authority.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.21 - Regularization of bonafide default and exit from EPCG scheme.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_21-R005', '5.21', '5.21 Regularization of bonafide default and exit from EPCG scheme
(a)
Authorisation holder shall have the option to surrender the unutilised
authorisation at any point of time.', 'business_rule', 'Regularization of bonafide default and exit from EPCG scheme', '(c)
In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).', '5.21 Regularization of bonafide default and exit from EPCG scheme
(a)
Authorisation holder shall have the option to surrender the unutilised
authorisation at any point of time.', '(c)
In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.21 - Regularization of bonafide default and exit from EPCG scheme.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_21-R006', '5.21', '(b)
In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he shall pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
Authority.', 'business_rule', 'Regularization of bonafide default and exit from EPCG scheme', '(c)
In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).', '(b)
In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he shall pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
Authority.', '(c)
In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.21 - Regularization of bonafide default and exit from EPCG scheme.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_21-R007', '5.21', '(c)
In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).', 'business_rule', 'Regularization of bonafide default and exit from EPCG scheme', '(c)
In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).', '(c)
In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).', '(c)
In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.21 - Regularization of bonafide default and exit from EPCG scheme.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.21', '(b) In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he shall pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
Authority.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.21', '(c) In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.21', '(e) Authorisation holder can also provisionally pay duty and interest suo-
moto on the basis of self/own calculation as per the procedure specified in
paragraph 4.50 of HBP.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.21', '(b)
In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he shall pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
Authority.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.21', '(c)
In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.21', 'customs');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.21', 1, 'Evaluate condition: (b) In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he shall pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
Authority.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.21', 2, 'Evaluate condition: (c) In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.21', 3, 'Evaluate condition: (e) Authorisation holder can also provisionally pay duty and interest suo-
moto on the basis of self/own calculation as per the procedure specified in
paragraph 4.50 of HBP.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.21', 4, '(b) In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he shall pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
Authority.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.21', 5, '(c) In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.21', 6, '(e) Authorisation holder can also provisionally pay duty and interest suo-
moto on the basis of self/own calculation as per the procedure specified in
paragraph 4.50 of HBP.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.21', 7, '(b)
In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he shall pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
Authority.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.21', 8, '(c)
In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with reference to the
notional Customs duties/taxes/cess saved on the FOR value of capital goods
(including spares, jigs, fixtures, dies and moulds).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.21', 9, 'Run validation: 5.21 Regularization of bonafide default and exit from EPCG scheme
(a) Authorisation holder shall have the option to surrender the unutilised
authorisation at any point of time.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.21', 10, 'Run validation: In such cases no penalty or fees shall be
levied.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.21', 11, 'Run validation: (b) In case, EPCG authorisation holder fails to fulfill prescribed export
obligation, he shall pay customs duty/taxes/cess in proportion of shortfall
in export obligation along with applicable interest as prescribed by Customs
Authority.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'any');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'pay');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'can');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'his');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'FOR');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'suo');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'per');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'HBP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'exit');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'from');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'have');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'time');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'such');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'fees');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'case');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'with');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'keywords', 'also');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'tags', '5.21');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'tags', 'Regularization of bonafide default and exit from EPCG scheme');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.21', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.22', 'Maintenance of Records', '5.22 Maintenance of Records
Every EPCG authorisation holder shall maintain, for a period of 2 years from date
of redemption, a true and proper account of exports/ supplies made and services
rendered towards fulfillment of export obligation.', 'Indha Maintenance of Records section-la, 5.22 Maintenance of Records
Every EPCG authorisation holder kandippa maintain, for a period of 2 years from date
of redemption, a true and proper account of exports/ supplies made and services
rendered towards fulfillment of export obligation.', '5.22 Maintenance of Records
Every EPCG authorisation holder shall maintain, for a period of 2 years from date
of redemption, a true and proper account of exports/ supplies made and services
rendered towards fulfillment of export obligation.', 'Maintenance of Records governs how DGFT business controls should be applied, validated, and enforced.', 'Maintenance of Records explains the operating rule set that DEKAI should enforce. Key control points include 5.22 Maintenance of Records
Every EPCG authorisation holder shall maintain, for a period of 2 years from date
of redemption, a true and proper account of exports/ supplies made and services
rendered towards fulfillment of export obligation. The section also drives actions such as 5.22 Maintenance of Records
Every EPCG authorisation holder shall maintain, for a period of 2 years from date
of redemption, a true and proper account of exports/ supplies made and services
rendered towards fulfillment of export obligation..', 'Indha Maintenance of Records section-la, Maintenance of Records explains the operating rule set that DEKAI should enforce. Key control points include 5.22 Maintenance of Records
Every EPCG authorisation holder kandippa maintain, for a period of 2 years from date
of redemption, a true and proper account of exports/ supplies made and services
rendered towards fulfillment of export obligation. The section also drives actions such as 5.22 Maintenance of Records
Every EPCG authorisation holder kandippa maintain, for a period of 2 years from date
of redemption, a true and proper account of exports/ supplies made and services
rendered towards fulfillment of export obligation..', '5.22 Maintenance of Records
Every EPCG authorisation holder shall maintain, for a period of 2 years from date
of redemption, a true and proper account of exports/ supplies made and services
rendered towards fulfillment of export obligation.', '[13]', '["for", "and", "EPCG", "from", "date", "true", "made", "Every", "shall", "years", "holder", "period", "proper", "export", "Records", "account", "exports", "towards", "maintain", "supplies"]', 'Support Maintenance of Records processing and compliance validation.', '["5.22", "Maintenance of Records", "business-rule", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_22-R001', '5.22', '5.22 Maintenance of Records
Every EPCG authorisation holder shall maintain, for a period of 2 years from date
of redemption, a true and proper account of exports/ supplies made and services
rendered towards fulfillment of export obligation.', 'business_rule', 'Maintenance of Records', 'Section 5.22 is applicable', '5.22 Maintenance of Records
Every EPCG authorisation holder shall maintain, for a period of 2 years from date
of redemption, a true and proper account of exports/ supplies made and services
rendered towards fulfillment of export obligation.', '5.22 Maintenance of Records
Every EPCG authorisation holder shall maintain, for a period of 2 years from date
of redemption, a true and proper account of exports/ supplies made and services
rendered towards fulfillment of export obligation.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.22 - Maintenance of Records.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.22', '5.22 Maintenance of Records
Every EPCG authorisation holder shall maintain, for a period of 2 years from date
of redemption, a true and proper account of exports/ supplies made and services
rendered towards fulfillment of export obligation.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.22', 1, '5.22 Maintenance of Records
Every EPCG authorisation holder shall maintain, for a period of 2 years from date
of redemption, a true and proper account of exports/ supplies made and services
rendered towards fulfillment of export obligation.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.22', 2, 'Run validation: 5.22 Maintenance of Records
Every EPCG authorisation holder shall maintain, for a period of 2 years from date
of redemption, a true and proper account of exports/ supplies made and services
rendered towards fulfillment of export obligation.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'from');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'date');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'true');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'made');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'Every');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'shall');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'years');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'holder');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'period');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'proper');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'export');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'Records');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'account');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'exports');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'towards');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'maintain');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'keywords', 'supplies');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'tags', '5.22');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'tags', 'Maintenance of Records');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.22', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.23', 'Re-Export / Repair/Replacement of Capital Goods Imported', '5.23 Re-Export / Repair/Replacement of Capital Goods Imported
under EPCG Scheme
(a) Capital Goods imported under EPCG scheme, which are found defective or
unfit for use, may be re-exported to foreign supplier within three years from the
date of clearance by Customs of such goods, with permission of RA/Customs
Authority.', 'Indha Re-Export / Repair/Replacement of Capital Goods Imported section-la, 5.23 Re-export / Repair/Replacement of Capital Goods Imported
under EPCG Scheme
(a) Capital Goods imported under EPCG scheme, which are found defective or
unfit for use, may be re-exported to foreign supplier within three years from the
date of clearance by Customs of such goods, with permission of RA/Customs
authority.', '5.23 Re-Export / Repair/Replacement of Capital Goods Imported
under EPCG Scheme
(a) Capital Goods imported under EPCG scheme, which are found defective or
unfit for use, may be re-exported to foreign supplier within three years from the
date of clearance by Customs of such goods, with permission of RA/Customs
Authority. Consequently, EO would be re-fixed. (b) Capital Goods imported and found defective or otherwise unfit for use may be
exported, within two years from the date of clearance by Customs of such goods,
with permission of RA / Customs Authority and Capital Goods in replacement
thereof be imported under EPCG scheme.', 'Re-Export / Repair/Replacement of Capital Goods Imported governs how DGFT business controls should be applied, validated, and enforced.', 'Re-Export / Repair/Replacement of Capital Goods Imported explains the operating rule set that DEKAI should enforce. Key control points include In such cases, while allowing export, the
Customs shall credit the duty benefit availed which can be debited again at the
time of import of such replaced Capital Goods.', 'Indha Re-Export / Repair/Replacement of Capital Goods Imported section-la, Re-export / Repair/Replacement of Capital Goods Imported explains the operating rule set that DEKAI should enforce. Key control points include In such cases, while allowing export, the
Customs kandippa credit the duty benefit availed which can be debited again at the
time of import of such replaced Capital Goods.', '5.23 Re-Export / Repair/Replacement of Capital Goods Imported
under EPCG Scheme
(a) Capital Goods imported under EPCG scheme, which are found defective or
unfit for use, may be re-exported to foreign supplier within three years from the
date of clearance by Customs of such goods, with permission of RA/Customs
Authority. Consequently, EO would be re-fixed.
(b) Capital Goods imported and found defective or otherwise unfit for use may be
exported, within two years from the date of clearance by Customs of such goods,
with permission of RA / Customs Authority and Capital Goods in replacement
thereof be imported under EPCG scheme. In such cases, while allowing export, the
Customs shall credit the duty benefit availed which can be debited again at the
time of import of such replaced Capital Goods.
(c) Capital Goods imported under EPCG scheme, may be re-exported for repairs
abroad within three years from the date of clearance by Customs of such goods,
with permission of RA / Customs Authority. The duty component on the
expenditure incurred on the repairs as well as the insurance and the freight, both
13
13
respects, export obligation shall be discharged within 30 days of receipt of
complete documents /information.
5.23 Re-Export / Repair/Replacement of Capital Goods Imported
under EPCG Scheme
(a) Capital Goods imported under EPCG scheme, which are found defective or
unfit for use, may be re-exported to foreign supplier within three years from the
date of clearance by Customs of such goods, with permission of RA/Customs
Authority. Consequently, EO would be re-fixed.
(b) Capital Goods imported and found defective or otherwise unfit for use may be
exported, within two years from the date of clearance by Customs of such goods,
with permission of RA / Customs Authority and Capital Goods in replacement
thereof be imported under EPCG scheme. In such cases, while allowing export, the
Customs shall credit the duty benefit availed which can be debited again at the
time of import of such replaced Capital Goods.
(c) Capital Goods imported under EPCG scheme, may be re-exported for repairs
abroad within three years from the date of clearance by Customs of such goods,
with permission of RA / Customs Authority. The duty component on the
expenditure incurred on the repairs as well as the insurance and the freight, both
ways shall be taken into account for re-fixation of the EO.', '[13, 14]', '["are", "for", "use", "may", "the", "and", "two", "can", "EPCG", "from", "date", "such", "with", "duty", "time", "well", "both", "days", "ways", "into"]', 'Provide knowledge guidance for Re-Export / Repair/Replacement of Capital Goods Imported.', '["5.23", "Re-Export / Repair/Replacement of Capital Goods Imported", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_23-R001', '5.23', 'In such cases, while allowing export, the
Customs shall credit the duty benefit availed which can be debited again at the
time of import of such replaced Capital Goods.', 'business_rule', 'Re-Export / Repair/Replacement of Capital Goods Imported', 'Not explicitly covered in uploaded documents.', 'In such cases, while allowing export, the
Customs shall credit the duty benefit availed which can be debited again at the
time of import of such replaced Capital Goods.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.23 - Re-Export / Repair/Replacement of Capital Goods Imported.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_23-R002', '5.23', 'The duty component on the
expenditure incurred on the repairs as well as the insurance and the freight, both
13
13
respects, export obligation shall be discharged within 30 days of receipt of
complete documents /information.', 'business_rule', 'Re-Export / Repair/Replacement of Capital Goods Imported', 'Not explicitly covered in uploaded documents.', 'The duty component on the
expenditure incurred on the repairs as well as the insurance and the freight, both
13
13
respects, export obligation shall be discharged within 30 days of receipt of
complete documents /information.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.23 - Re-Export / Repair/Replacement of Capital Goods Imported.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_23-R003', '5.23', 'The duty component on the
expenditure incurred on the repairs as well as the insurance and the freight, both
ways shall be taken into account for re-fixation of the EO.', 'business_rule', 'Re-Export / Repair/Replacement of Capital Goods Imported', 'Not explicitly covered in uploaded documents.', 'The duty component on the
expenditure incurred on the repairs as well as the insurance and the freight, both
ways shall be taken into account for re-fixation of the EO.', 'Manual review required.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.23 - Re-Export / Repair/Replacement of Capital Goods Imported.');
INSERT INTO documents (section_code, document_name) VALUES ('5.23', 'The duty component on the
expenditure incurred on the repairs as well as the insurance and the freight, both
13
13
respects, export obligation shall be discharged within 30 days of receipt of
complete documents /information.');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.23', 'RA');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.23', 'Customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.23', 'RA/Customs');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.23', 'Customs Authority');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.23', 'RA / Customs Authority');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.23', '5.23 Re-Export / Repair/Replacement of Capital Goods Imported
under EPCG Scheme
(a) Capital Goods imported under EPCG scheme, which are found defective or
unfit for use, may be re-exported to foreign supplier within three years from the
date of clearance by Customs of such goods, with permission of RA/Customs
Authority.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.23', '(b) Capital Goods imported and found defective or otherwise unfit for use may be
exported, within two years from the date of clearance by Customs of such goods,
with permission of RA / Customs Authority and Capital Goods in replacement
thereof be imported under EPCG scheme.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.23', '(c) Capital Goods imported under EPCG scheme, may be re-exported for repairs
abroad within three years from the date of clearance by Customs of such goods,
with permission of RA / Customs Authority.');
INSERT INTO timelines (section_code, timeline_text) VALUES ('5.23', 'The duty component on the
expenditure incurred on the repairs as well as the insurance and the freight, both
13
13
respects, export obligation shall be discharged within 30 days of receipt of
complete documents /information.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.23', 1, 'Run validation: In such cases, while allowing export, the
Customs shall credit the duty benefit availed which can be debited again at the
time of import of such replaced Capital Goods.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.23', 2, 'Run validation: The duty component on the
expenditure incurred on the repairs as well as the insurance and the freight, both
13
13
respects, export obligation shall be discharged within 30 days of receipt of
complete documents /information.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.23', 3, 'Run validation: The duty component on the
expenditure incurred on the repairs as well as the insurance and the freight, both
ways shall be taken into account for re-fixation of the EO.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'are');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'use');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'may');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'two');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'can');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'from');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'date');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'such');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'with');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'duty');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'time');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'well');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'both');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'days');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'ways');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'keywords', 'into');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'tags', '5.23');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'tags', 'Re-Export / Repair/Replacement of Capital Goods Imported');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.23', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.24', 'Penal Action', '5.24 Penal Action
In case of failure to fulfil export obligation or any other condition of
authorisation, authorisation holder shall be liable for action under FT (D&R) Act,
1992, as amended, Orders and Rules made thereunder, provisions of FTP/HBP,
Customs Act, 1962, as amended from time to time or any other law in force.', 'Indha Penal Action section-la, 5.24 Penal Action
In case of failure to fulfil export obligation or any other condition of
authorisation, authorisation holder kandippa be liable for action under FT (D&R) Act,
1992, as amended, Orders and Rules made thereunder, provisions of FTP/HBP,
Customs Act, 1962, as amended from time to time or any other law in force.', '5.24 Penal Action
In case of failure to fulfil export obligation or any other condition of
authorisation, authorisation holder shall be liable for action under FT (D&R) Act,
1992, as amended, Orders and Rules made thereunder, provisions of FTP/HBP,
Customs Act, 1962, as amended from time to time or any other law in force.', 'Penal Action governs how DGFT business controls should be applied, validated, and enforced.', 'Penal Action explains the operating rule set that DEKAI should enforce. Key control points include 5.24 Penal Action
In case of failure to fulfil export obligation or any other condition of
authorisation, authorisation holder shall be liable for action under FT (D&R) Act,
1992, as amended, Orders and Rules made thereunder, provisions of FTP/HBP,
Customs Act, 1962, as amended from time to time or any other law in force. The section also drives actions such as 5.24 Penal Action
In case of failure to fulfil export obligation or any other condition of
authorisation, authorisation holder shall be liable for action under FT (D&R) Act,
1992, as amended, Orders and Rules made thereunder, provisions of FTP/HBP,
Customs Act, 1962, as amended from time to time or any other law in force..', 'Indha Penal Action section-la, Penal Action explains the operating rule set that DEKAI should enforce. Key control points include 5.24 Penal Action
In case of failure to fulfil export obligation or any other condition of
authorisation, authorisation holder kandippa be liable for action under FT (D&R) Act,
1992, as amended, Orders and Rules made thereunder, provisions of FTP/HBP,
Customs Act, 1962, as amended from time to time or any other law in force. The section also drives actions such as 5.24 Penal Action
In case of failure to fulfil export obligation or any other condition of
authorisation, authorisation holder kandippa be liable for action under FT (D&R) Act,
1992, as amended, Orders and Rules made thereunder, provisions of FTP/HBP,
Customs Act, 1962, as amended from time to time or any other law in force..', '5.24 Penal Action
In case of failure to fulfil export obligation or any other condition of
authorisation, authorisation holder shall be liable for action under FT (D&R) Act,
1992, as amended, Orders and Rules made thereunder, provisions of FTP/HBP,
Customs Act, 1962, as amended from time to time or any other law in force.', '[14]', '["any", "for", "D&R", "Act", "and", "law", "case", "made", "from", "time", "Penal", "other", "shall", "under", "Rules", "force", "Action", "fulfil", "export", "holder"]', 'Support Penal Action processing and compliance validation.', '["5.24", "Penal Action", "business-rule", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_24-R001', '5.24', '5.24 Penal Action
In case of failure to fulfil export obligation or any other condition of
authorisation, authorisation holder shall be liable for action under FT (D&R) Act,
1992, as amended, Orders and Rules made thereunder, provisions of FTP/HBP,
Customs Act, 1962, as amended from time to time or any other law in force.', 'business_rule', 'Penal Action', '5.24 Penal Action
In case of failure to fulfil export obligation or any other condition of
authorisation, authorisation holder shall be liable for action under FT (D&R) Act,
1992, as amended, Orders and Rules made thereunder, provisions of FTP/HBP,
Customs Act, 1962, as amended from time to time or any other law in force.', '5.24 Penal Action
In case of failure to fulfil export obligation or any other condition of
authorisation, authorisation holder shall be liable for action under FT (D&R) Act,
1992, as amended, Orders and Rules made thereunder, provisions of FTP/HBP,
Customs Act, 1962, as amended from time to time or any other law in force.', '5.24 Penal Action
In case of failure to fulfil export obligation or any other condition of
authorisation, authorisation holder shall be liable for action under FT (D&R) Act,
1992, as amended, Orders and Rules made thereunder, provisions of FTP/HBP,
Customs Act, 1962, as amended from time to time or any other law in force.', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.24 - Penal Action.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.24', '5.24 Penal Action
In case of failure to fulfil export obligation or any other condition of
authorisation, authorisation holder shall be liable for action under FT (D&R) Act,
1992, as amended, Orders and Rules made thereunder, provisions of FTP/HBP,
Customs Act, 1962, as amended from time to time or any other law in force.');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.24', 'Customs');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.24', 1, 'Evaluate condition: 5.24 Penal Action
In case of failure to fulfil export obligation or any other condition of
authorisation, authorisation holder shall be liable for action under FT (D&R) Act,
1992, as amended, Orders and Rules made thereunder, provisions of FTP/HBP,
Customs Act, 1962, as amended from time to time or any other law in force.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.24', 2, '5.24 Penal Action
In case of failure to fulfil export obligation or any other condition of
authorisation, authorisation holder shall be liable for action under FT (D&R) Act,
1992, as amended, Orders and Rules made thereunder, provisions of FTP/HBP,
Customs Act, 1962, as amended from time to time or any other law in force.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.24', 3, 'Run validation: 5.24 Penal Action
In case of failure to fulfil export obligation or any other condition of
authorisation, authorisation holder shall be liable for action under FT (D&R) Act,
1992, as amended, Orders and Rules made thereunder, provisions of FTP/HBP,
Customs Act, 1962, as amended from time to time or any other law in force.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'any');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'D&R');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'Act');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'law');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'case');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'made');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'from');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'time');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'Penal');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'other');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'shall');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'under');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'Rules');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'force');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'Action');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'fulfil');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'export');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'keywords', 'holder');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'tags', '5.24');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'tags', 'Penal Action');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.24', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.25', 'Clubbing of EPCG authorisations', '5.25 Clubbing of EPCG authorisations
(a) Clubbing of two or more EPCG authorisations issued to the same
authorisation holder would be permitted.', 'Indha Clubbing of EPCG authorisations section-la, 5.25 Clubbing of EPCG authorisations
(a) Clubbing of two or more EPCG authorisations issued to the same
authorisation holder would be permitted.', '5.25 Clubbing of EPCG authorisations
(a) Clubbing of two or more EPCG authorisations issued to the same
authorisation holder would be permitted. (b) An application for clubbing can be made to RA concerned in ANF 5C. Clubbing
shall only be permitted in case export products endorsed on the authorisations are
same/similar and if authorisations are issued by the same RA.', 'Clubbing of EPCG authorisations governs how DGFT business controls should be applied, validated, and enforced.', 'Clubbing of EPCG authorisations explains the operating rule set that DEKAI should enforce. Key control points include Clubbing
shall only be permitted in case export products endorsed on the authorisations are
same/similar and if authorisations are issued by the same RA. The section also drives actions such as 5.25 Clubbing of EPCG authorisations
(a) Clubbing of two or more EPCG authorisations issued to the same
authorisation holder would be permitted..', 'Indha Clubbing of EPCG authorisations section-la, Clubbing of EPCG authorisations explains the operating rule set that DEKAI should enforce. Key control points include Clubbing
kandippa only be permitted in case export products endorsed on the authorisations are
same/similar and if authorisations are issued by the same RA. The section also drives actions such as 5.25 Clubbing of EPCG authorisations
(a) Clubbing of two or more EPCG authorisations issued to the same
authorisation holder would be permitted..', '5.25 Clubbing of EPCG authorisations
(a) Clubbing of two or more EPCG authorisations issued to the same
authorisation holder would be permitted.
(b) An application for clubbing can be made to RA concerned in ANF 5C. Clubbing
shall only be permitted in case export products endorsed on the authorisations are
same/similar and if authorisations are issued by the same RA.
(c) Total export obligation would be re-fixed taking into account total of duty
saved amount of the clubbed authorisations.
(d) On Clubbing, authorisations for all purpose shall be deemed to be a single
EPCG authorisation. Export obligation period for clubbed authorisations shall be
reckoned from first authorisation issue date.
(e) Average export obligation for clubbed authorisations would be highest of
average export obligations endorsed on individual authorisations so clubbed.
(f) Clubbing would be permitted during valid EOP including extended period, if
any. However, clubbing in case of all authorisations where EO period is over may
be allowed for regularisation purposes provided they have been issued under
same policy period.
(g) In case of clubbing of EPCG authorisations where EO can be fulfilled by export
of alternate product(s)/service(s), the proportion of alternate
product(s)/service(s) for EO fulfillment/ regularization will be restricted to the
lowest of the percentage of alternate product(s)/service(s) allowed in the clubbed
authorisations.
(h) EPCG authorisations issued prior to 01.04.2007 shall be governed by
provisions contained in Chapter 5 of HBP Vol.1 (RE-2006).The EPCG
Authorisations issued between 01.04.2007 and 17.04.2013 shall be governed by
provisions contained in Chapter 5 of HBP Vol.1 (RE-2012, as amended). The EPCG
Authorisations issued from 18.04.2013 till the issue of notification of HBP 2015-
20 shall be governed by provisions contained in Public Notice No.1 dated
18.04.2013. The EPCG Authorisations issued between notification of HBP 2015-
14
14
ways shall be taken into account for re-fixation of the EO.
5.25 Clubbing of EPCG authorisations
(a) Clubbing of two or more EPCG authorisations issued to the same
authorisation holder would be permitted.
(b) An application for clubbing can be made to RA concerned in ANF 5C. Clubbing
shall only be permitted in case export products endorsed on the authorisations are
same/similar and if authorisations are issued by the same RA.
(c) Total export obligation would be re-fixed taking into account total of duty
saved amount of the clubbed authorisations.
(d) On Clubbing, authorisations for all purpose shall be deemed to be a single
EPCG authorisation. Export obligation period for clubbed authorisations shall be
reckoned from first authorisation issue date.
(e) Average export obligation for clubbed authorisations would be highest of
average export obligations endorsed on individual authorisations so clubbed.
(f) Clubbing would be permitted during valid EOP including extended period, if
any. However, clubbing in case of all authorisations where EO period is over may
be allowed for regularisation purposes provided they have been issued under
same policy period.
(g) In case of clubbing of EPCG authorisations where EO can be fulfilled by export
of
alternate
product(s)/service(s),
the
proportion
of
alternate
product(s)/service(s) for EO fulfillment/ regularization will be restricted to the
lowest of the percentage of alternate product(s)/service(s) allowed in the clubbed
authorisations.
(h)
EPCG authorisations issued prior to 01.04.2007 shall be governed by
provisions contained in Chapter 5 of HBP Vol.1 (RE-2006).The EPCG
Authorisations issued between 01.04.2007 and 17.04.2013 shall be governed by
provisions contained in Chapter 5 of HBP Vol.1 (RE-2012, as amended). The EPCG
Authorisations issued from 18.04.2013 till the issue of notification of HBP 2015-
20 shall be governed by provisions contained in Public Notice No.1 dated
18.04.2013. The EPCG Authorisations issued between notification of HBP 2015-
20 till the notification of HBP 2015-20 (RE-2017) shall be governed by provisions
contained in HBP 2015-20. The EPCG Authorisations issued between notification
of HBP 2015-20 (RE-2017) till the notification of HBP 2023 shall be governed by
provisions contained in HBP 2015-20 (RE-2017).', '[14, 15]', '["two", "the", "for", "can", "ANF", "are", "and", "all", "EOP", "any", "may", "HBP", "Vol", "RE-", "EPCG", "more", "same", "made", "only", "case"]', 'Support Clubbing of EPCG authorisations processing and compliance validation.', '["5.25", "Clubbing of EPCG authorisations", "business-rule", "document-driven", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_25-R001', '5.25', 'Clubbing
shall only be permitted in case export products endorsed on the authorisations are
same/similar and if authorisations are issued by the same RA.', 'business_rule', 'Clubbing of EPCG authorisations', 'Clubbing
shall only be permitted in case export products endorsed on the authorisations are
same/similar and if authorisations are issued by the same RA.', 'Clubbing
shall only be permitted in case export products endorsed on the authorisations are
same/similar and if authorisations are issued by the same RA.', '5.25 Clubbing of EPCG authorisations
(a) Clubbing of two or more EPCG authorisations issued to the same
authorisation holder would be permitted.', 'However, clubbing in case of all authorisations where EO period is over may
be allowed for regularisation purposes provided they have been issued under
same policy period.', 'DEKAI should produce a compliance decision for 5.25 - Clubbing of EPCG authorisations.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_25-R002', '5.25', '(d) On Clubbing, authorisations for all purpose shall be deemed to be a single
EPCG authorisation.', 'business_rule', 'Clubbing of EPCG authorisations', '(f) Clubbing would be permitted during valid EOP including extended period, if
any.', '(d) On Clubbing, authorisations for all purpose shall be deemed to be a single
EPCG authorisation.', 'Clubbing
shall only be permitted in case export products endorsed on the authorisations are
same/similar and if authorisations are issued by the same RA.', 'However, clubbing in case of all authorisations where EO period is over may
be allowed for regularisation purposes provided they have been issued under
same policy period.', 'DEKAI should produce a compliance decision for 5.25 - Clubbing of EPCG authorisations.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_25-R003', '5.25', 'Export obligation period for clubbed authorisations shall be
reckoned from first authorisation issue date.', 'business_rule', 'Clubbing of EPCG authorisations', 'However, clubbing in case of all authorisations where EO period is over may
be allowed for regularisation purposes provided they have been issued under
same policy period.', 'Export obligation period for clubbed authorisations shall be
reckoned from first authorisation issue date.', 'Export obligation period for clubbed authorisations shall be
reckoned from first authorisation issue date.', 'However, clubbing in case of all authorisations where EO period is over may
be allowed for regularisation purposes provided they have been issued under
same policy period.', 'DEKAI should produce a compliance decision for 5.25 - Clubbing of EPCG authorisations.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_25-R004', '5.25', '(h) EPCG authorisations issued prior to 01.04.2007 shall be governed by
provisions contained in Chapter 5 of HBP Vol.1 (RE-2006).The EPCG
Authorisations issued between 01.04.2007 and 17.04.2013 shall be governed by
provisions contained in Chapter 5 of HBP Vol.1 (RE-2012, as amended).', 'business_rule', 'Clubbing of EPCG authorisations', '(g) In case of clubbing of EPCG authorisations where EO can be fulfilled by export
of alternate product(s)/service(s), the proportion of alternate
product(s)/service(s) for EO fulfillment/ regularization will be restricted to the
lowest of the percentage of alternate product(s)/service(s) allowed in the clubbed
authorisations.', '(h) EPCG authorisations issued prior to 01.04.2007 shall be governed by
provisions contained in Chapter 5 of HBP Vol.1 (RE-2006).The EPCG
Authorisations issued between 01.04.2007 and 17.04.2013 shall be governed by
provisions contained in Chapter 5 of HBP Vol.1 (RE-2012, as amended).', 'However, clubbing in case of all authorisations where EO period is over may
be allowed for regularisation purposes provided they have been issued under
same policy period.', 'However, clubbing in case of all authorisations where EO period is over may
be allowed for regularisation purposes provided they have been issued under
same policy period.', 'DEKAI should produce a compliance decision for 5.25 - Clubbing of EPCG authorisations.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_25-R005', '5.25', 'The EPCG
Authorisations issued from 18.04.2013 till the issue of notification of HBP 2015-
20 shall be governed by provisions contained in Public Notice No.1 dated
18.04.2013.', 'business_rule', 'Clubbing of EPCG authorisations', 'The EPCG
Authorisations issued from 18.04.2013 till the issue of notification of HBP 2015-
20 shall be governed by provisions contained in Public Notice No.1 dated
18.04.2013.', 'The EPCG
Authorisations issued from 18.04.2013 till the issue of notification of HBP 2015-
20 shall be governed by provisions contained in Public Notice No.1 dated
18.04.2013.', '(h) EPCG authorisations issued prior to 01.04.2007 shall be governed by
provisions contained in Chapter 5 of HBP Vol.1 (RE-2006).The EPCG
Authorisations issued between 01.04.2007 and 17.04.2013 shall be governed by
provisions contained in Chapter 5 of HBP Vol.1 (RE-2012, as amended).', 'However, clubbing in case of all authorisations where EO period is over may
be allowed for regularisation purposes provided they have been issued under
same policy period.', 'DEKAI should produce a compliance decision for 5.25 - Clubbing of EPCG authorisations.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_25-R006', '5.25', 'The EPCG Authorisations issued between notification of HBP 2015-
14
14
ways shall be taken into account for re-fixation of the EO.', 'business_rule', 'Clubbing of EPCG authorisations', 'The EPCG Authorisations issued between notification of HBP 2015-
14
14
ways shall be taken into account for re-fixation of the EO.', 'The EPCG Authorisations issued between notification of HBP 2015-
14
14
ways shall be taken into account for re-fixation of the EO.', 'The EPCG
Authorisations issued from 18.04.2013 till the issue of notification of HBP 2015-
20 shall be governed by provisions contained in Public Notice No.1 dated
18.04.2013.', 'However, clubbing in case of all authorisations where EO period is over may
be allowed for regularisation purposes provided they have been issued under
same policy period.', 'DEKAI should produce a compliance decision for 5.25 - Clubbing of EPCG authorisations.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_25-R007', '5.25', '(h)
EPCG authorisations issued prior to 01.04.2007 shall be governed by
provisions contained in Chapter 5 of HBP Vol.1 (RE-2006).The EPCG
Authorisations issued between 01.04.2007 and 17.04.2013 shall be governed by
provisions contained in Chapter 5 of HBP Vol.1 (RE-2012, as amended).', 'business_rule', 'Clubbing of EPCG authorisations', '(g) In case of clubbing of EPCG authorisations where EO can be fulfilled by export
of
alternate
product(s)/service(s),
the
proportion
of
alternate
product(s)/service(s) for EO fulfillment/ regularization will be restricted to the
lowest of the percentage of alternate product(s)/service(s) allowed in the clubbed
authorisations.', '(h)
EPCG authorisations issued prior to 01.04.2007 shall be governed by
provisions contained in Chapter 5 of HBP Vol.1 (RE-2006).The EPCG
Authorisations issued between 01.04.2007 and 17.04.2013 shall be governed by
provisions contained in Chapter 5 of HBP Vol.1 (RE-2012, as amended).', 'The EPCG Authorisations issued between notification of HBP 2015-
14
14
ways shall be taken into account for re-fixation of the EO.', 'However, clubbing in case of all authorisations where EO period is over may
be allowed for regularisation purposes provided they have been issued under
same policy period.', 'DEKAI should produce a compliance decision for 5.25 - Clubbing of EPCG authorisations.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_25-R008', '5.25', 'The EPCG Authorisations issued between notification of HBP 2015-
20 till the notification of HBP 2015-20 (RE-2017) shall be governed by provisions
contained in HBP 2015-20.', 'business_rule', 'Clubbing of EPCG authorisations', 'The EPCG Authorisations issued between notification of HBP 2015-
20 till the notification of HBP 2015-20 (RE-2017) shall be governed by provisions
contained in HBP 2015-20.', 'The EPCG Authorisations issued between notification of HBP 2015-
20 till the notification of HBP 2015-20 (RE-2017) shall be governed by provisions
contained in HBP 2015-20.', '(h)
EPCG authorisations issued prior to 01.04.2007 shall be governed by
provisions contained in Chapter 5 of HBP Vol.1 (RE-2006).The EPCG
Authorisations issued between 01.04.2007 and 17.04.2013 shall be governed by
provisions contained in Chapter 5 of HBP Vol.1 (RE-2012, as amended).', 'However, clubbing in case of all authorisations where EO period is over may
be allowed for regularisation purposes provided they have been issued under
same policy period.', 'DEKAI should produce a compliance decision for 5.25 - Clubbing of EPCG authorisations.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_25-R009', '5.25', 'The EPCG Authorisations issued between notification
of HBP 2015-20 (RE-2017) till the notification of HBP 2023 shall be governed by
provisions contained in HBP 2015-20 (RE-2017).', 'business_rule', 'Clubbing of EPCG authorisations', 'The EPCG Authorisations issued between notification
of HBP 2015-20 (RE-2017) till the notification of HBP 2023 shall be governed by
provisions contained in HBP 2015-20 (RE-2017).', 'The EPCG Authorisations issued between notification
of HBP 2015-20 (RE-2017) till the notification of HBP 2023 shall be governed by
provisions contained in HBP 2015-20 (RE-2017).', 'The EPCG Authorisations issued between notification of HBP 2015-
20 till the notification of HBP 2015-20 (RE-2017) shall be governed by provisions
contained in HBP 2015-20.', 'However, clubbing in case of all authorisations where EO period is over may
be allowed for regularisation purposes provided they have been issued under
same policy period.', 'DEKAI should produce a compliance decision for 5.25 - Clubbing of EPCG authorisations.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.25', 'Clubbing
shall only be permitted in case export products endorsed on the authorisations are
same/similar and if authorisations are issued by the same RA.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.25', '(f) Clubbing would be permitted during valid EOP including extended period, if
any.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.25', 'However, clubbing in case of all authorisations where EO period is over may
be allowed for regularisation purposes provided they have been issued under
same policy period.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.25', '(g) In case of clubbing of EPCG authorisations where EO can be fulfilled by export
of alternate product(s)/service(s), the proportion of alternate
product(s)/service(s) for EO fulfillment/ regularization will be restricted to the
lowest of the percentage of alternate product(s)/service(s) allowed in the clubbed
authorisations.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.25', 'The EPCG
Authorisations issued from 18.04.2013 till the issue of notification of HBP 2015-
20 shall be governed by provisions contained in Public Notice No.1 dated
18.04.2013.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.25', 'The EPCG Authorisations issued between notification of HBP 2015-
14
14
ways shall be taken into account for re-fixation of the EO.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.25', '(g) In case of clubbing of EPCG authorisations where EO can be fulfilled by export
of
alternate
product(s)/service(s),
the
proportion
of
alternate
product(s)/service(s) for EO fulfillment/ regularization will be restricted to the
lowest of the percentage of alternate product(s)/service(s) allowed in the clubbed
authorisations.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.25', 'The EPCG Authorisations issued between notification of HBP 2015-
20 till the notification of HBP 2015-20 (RE-2017) shall be governed by provisions
contained in HBP 2015-20.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.25', 'The EPCG Authorisations issued between notification
of HBP 2015-20 (RE-2017) till the notification of HBP 2023 shall be governed by
provisions contained in HBP 2015-20 (RE-2017).');
INSERT INTO documents (section_code, document_name) VALUES ('5.25', '(b) An application for clubbing can be made to RA concerned in ANF 5C.');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.25', 'RA');
INSERT INTO authorities (section_code, authority_name) VALUES ('5.25', 'An application for clubbing can be made to RA');
INSERT INTO exceptions (section_code, exception_text) VALUES ('5.25', 'However, clubbing in case of all authorisations where EO period is over may
be allowed for regularisation purposes provided they have been issued under
same policy period.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.25', 1, 'Evaluate condition: Clubbing
shall only be permitted in case export products endorsed on the authorisations are
same/similar and if authorisations are issued by the same RA.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.25', 2, 'Evaluate condition: (f) Clubbing would be permitted during valid EOP including extended period, if
any.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.25', 3, 'Evaluate condition: However, clubbing in case of all authorisations where EO period is over may
be allowed for regularisation purposes provided they have been issued under
same policy period.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.25', 4, '5.25 Clubbing of EPCG authorisations
(a) Clubbing of two or more EPCG authorisations issued to the same
authorisation holder would be permitted.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.25', 5, 'Clubbing
shall only be permitted in case export products endorsed on the authorisations are
same/similar and if authorisations are issued by the same RA.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.25', 6, 'Export obligation period for clubbed authorisations shall be
reckoned from first authorisation issue date.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.25', 7, 'However, clubbing in case of all authorisations where EO period is over may
be allowed for regularisation purposes provided they have been issued under
same policy period.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.25', 8, '(h) EPCG authorisations issued prior to 01.04.2007 shall be governed by
provisions contained in Chapter 5 of HBP Vol.1 (RE-2006).The EPCG
Authorisations issued between 01.04.2007 and 17.04.2013 shall be governed by
provisions contained in Chapter 5 of HBP Vol.1 (RE-2012, as amended).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.25', 9, 'The EPCG
Authorisations issued from 18.04.2013 till the issue of notification of HBP 2015-
20 shall be governed by provisions contained in Public Notice No.1 dated
18.04.2013.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.25', 10, 'Run validation: Clubbing
shall only be permitted in case export products endorsed on the authorisations are
same/similar and if authorisations are issued by the same RA.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.25', 11, 'Run validation: (d) On Clubbing, authorisations for all purpose shall be deemed to be a single
EPCG authorisation.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.25', 12, 'Run validation: Export obligation period for clubbed authorisations shall be
reckoned from first authorisation issue date.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.25', 13, 'Handle exception: However, clubbing in case of all authorisations where EO period is over may
be allowed for regularisation purposes provided they have been issued under
same policy period.');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'two');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'the');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'can');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'ANF');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'are');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'all');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'EOP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'any');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'may');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'HBP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'Vol');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'RE-');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'EPCG');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'more');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'same');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'made');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'only');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'keywords', 'case');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'tags', '5.25');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'tags', 'Clubbing of EPCG authorisations');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'tags', 'document-driven');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.25', 'tags', 'dgft');
INSERT INTO sections (source_document, chapter_number, chapter_title, section_code, title, purpose, purpose_thanglish, summary, business_meaning, business_explanation, business_explanation_thanglish, raw_text, pages, keywords, intent, tags) VALUES ('HBP2023_Chapter05.pdf', '5', 'Export Promotion Capital Goods (EPCG) Scheme', '5.26', 'Green Technology Products', '5.26 Green Technology Products
The Export Products covered under Paragraph 5.10 of FTP which provides for
reduced export obligation of 75% for green technology products are:
(i) Solar Energy Generating Systems and parts/Equipments thereof,
(ii) Wind Energy Generating Systems and parts/equipment thereof,
(iii) LED lights of various kind,
(iv) Vapour Absorption Chillers,
(v) Waste Heat Boiler,
(vi) Waste Heat Recovery Units,
(vii) Unfired Heat Recovery Steam Generators,
(viii) Water Treatment Plants,
(ix) Battery Electric Vehicles (BEV) [other than Hybrid Electric Vehicles
(HEVs) and Plug-in Hybrid Electric Vehicle (PHEV)] of all types,
(x) Vertical Farming equipment,
(xi) Wastewater Treatment and Recycling,
(xii) Rainwater harvesting system and rainwater filters, and
(xiii) Green Hydrogen.', 'Indha Green Technology Products section-la, 5.26 Green Technology Products
The export Products covered under Paragraph 5.10 of FTP which provides for
reduced export obligation of 75% for green technology products are:
(i) Solar Energy Generating Systems and parts/Equipments thereof,
(ii) Wind Energy Generating Systems and parts/equipment thereof,
(iii) LED lights of various kind,
(iv) Vapour Absorption Chillers,
(v) Waste Heat Boiler,
(vi) Waste Heat Recovery Units,
(vii) Unfired Heat Recovery Steam Generators,
(viii) Water Treatment Plants,
(ix) Battery Electric Vehicles (BEV) [other than Hybrid Electric Vehicles
(HEVs) and Plug-in Hybrid Electric Vehicle (PHEV)] of all types,
(x) Vertical Farming equipment,
(xi) Wastewater Treatment and Recycling,
(xii) Rainwater harvesting system and rainwater filters, and
(xiii) Green Hydrogen.', '5.26 Green Technology Products
The Export Products covered under Paragraph 5.10 of FTP which provides for
reduced export obligation of 75% for green technology products are:
(i) Solar Energy Generating Systems and parts/Equipments thereof,
(ii) Wind Energy Generating Systems and parts/equipment thereof,
(iii) LED lights of various kind,
(iv) Vapour Absorption Chillers,
(v) Waste Heat Boiler,
(vi) Waste Heat Recovery Units,
(vii) Unfired Heat Recovery Steam Generators,
(viii) Water Treatment Plants,
(ix) Battery Electric Vehicles (BEV) [other than Hybrid Electric Vehicles
(HEVs) and Plug-in Hybrid Electric Vehicle (PHEV)] of all types,
(x) Vertical Farming equipment,
(xi) Wastewater Treatment and Recycling,
(xii) Rainwater harvesting system and rainwater filters, and
(xiii) Green Hydrogen. 15
15
20 till the notification of HBP 2015-20 (RE-2017) shall be governed by provisions
contained in HBP 2015-20. The EPCG Authorisations issued between notification
of HBP 2015-20 (RE-2017) till the notification of HBP 2023 shall be governed by
provisions contained in HBP 2015-20 (RE-2017).', 'Green Technology Products governs how DGFT business controls should be applied, validated, and enforced.', 'Green Technology Products explains the operating rule set that DEKAI should enforce. Key control points include 15
15
20 till the notification of HBP 2015-20 (RE-2017) shall be governed by provisions
contained in HBP 2015-20. The section also drives actions such as The EPCG Authorisations issued between notification
of HBP 2015-20 (RE-2017) till the notification of HBP 2023 shall be governed by
provisions contained in HBP 2015-20 (RE-2017)..', 'Indha Green Technology Products section-la, Green Technology Products explains the operating rule set that DEKAI should enforce. Key control points include 15
15
20 till the notification of HBP 2015-20 (RE-2017) kandippa be governed by provisions
contained in HBP 2015-20. The section also drives actions such as The EPCG Authorisations issued between notification
of HBP 2015-20 (RE-2017) till the notification of HBP 2023 kandippa be governed by
provisions contained in HBP 2015-20 (RE-2017)..', '5.26 Green Technology Products
The Export Products covered under Paragraph 5.10 of FTP which provides for
reduced export obligation of 75% for green technology products are:
(i) Solar Energy Generating Systems and parts/Equipments thereof,
(ii) Wind Energy Generating Systems and parts/equipment thereof,
(iii) LED lights of various kind,
(iv) Vapour Absorption Chillers,
(v) Waste Heat Boiler,
(vi) Waste Heat Recovery Units,
(vii) Unfired Heat Recovery Steam Generators,
(viii) Water Treatment Plants,
(ix) Battery Electric Vehicles (BEV) [other than Hybrid Electric Vehicles
(HEVs) and Plug-in Hybrid Electric Vehicle (PHEV)] of all types,
(x) Vertical Farming equipment,
(xi) Wastewater Treatment and Recycling,
(xii) Rainwater harvesting system and rainwater filters, and
(xiii) Green Hydrogen.
15
15
20 till the notification of HBP 2015-20 (RE-2017) shall be governed by provisions
contained in HBP 2015-20. The EPCG Authorisations issued between notification
of HBP 2015-20 (RE-2017) till the notification of HBP 2023 shall be governed by
provisions contained in HBP 2015-20 (RE-2017).', '[15]', '["The", "FTP", "for", "are", "and", "iii", "LED", "vii", "BEV", "all", "xii", "HBP", "RE-", "Wind", "kind", "Heat", "viii", "than", "HEVs", "PHEV"]', 'Support Green Technology Products processing and compliance validation.', '["5.26", "Green Technology Products", "business-rule", "dgft"]');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_26-R001', '5.26', '15
15
20 till the notification of HBP 2015-20 (RE-2017) shall be governed by provisions
contained in HBP 2015-20.', 'business_rule', 'Green Technology Products', '15
15
20 till the notification of HBP 2015-20 (RE-2017) shall be governed by provisions
contained in HBP 2015-20.', '15
15
20 till the notification of HBP 2015-20 (RE-2017) shall be governed by provisions
contained in HBP 2015-20.', 'The EPCG Authorisations issued between notification
of HBP 2015-20 (RE-2017) till the notification of HBP 2023 shall be governed by
provisions contained in HBP 2015-20 (RE-2017).', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.26 - Green Technology Products.');
INSERT INTO rules (rule_id, section_code, rule_text, rule_type, trigger_text, condition_text, validation_text, action_text, exception_text, output_text) VALUES ('CH5-SEC5_26-R002', '5.26', 'The EPCG Authorisations issued between notification
of HBP 2015-20 (RE-2017) till the notification of HBP 2023 shall be governed by
provisions contained in HBP 2015-20 (RE-2017).', 'business_rule', 'Green Technology Products', 'The EPCG Authorisations issued between notification
of HBP 2015-20 (RE-2017) till the notification of HBP 2023 shall be governed by
provisions contained in HBP 2015-20 (RE-2017).', 'The EPCG Authorisations issued between notification
of HBP 2015-20 (RE-2017) till the notification of HBP 2023 shall be governed by
provisions contained in HBP 2015-20 (RE-2017).', 'The EPCG Authorisations issued between notification
of HBP 2015-20 (RE-2017) till the notification of HBP 2023 shall be governed by
provisions contained in HBP 2015-20 (RE-2017).', 'No explicit exception found in uploaded documents.', 'DEKAI should produce a compliance decision for 5.26 - Green Technology Products.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.26', '15
15
20 till the notification of HBP 2015-20 (RE-2017) shall be governed by provisions
contained in HBP 2015-20.');
INSERT INTO conditions (section_code, condition_text) VALUES ('5.26', 'The EPCG Authorisations issued between notification
of HBP 2015-20 (RE-2017) till the notification of HBP 2023 shall be governed by
provisions contained in HBP 2015-20 (RE-2017).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.26', 1, 'Evaluate condition: 15
15
20 till the notification of HBP 2015-20 (RE-2017) shall be governed by provisions
contained in HBP 2015-20.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.26', 2, 'Evaluate condition: The EPCG Authorisations issued between notification
of HBP 2015-20 (RE-2017) till the notification of HBP 2023 shall be governed by
provisions contained in HBP 2015-20 (RE-2017).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.26', 3, 'The EPCG Authorisations issued between notification
of HBP 2015-20 (RE-2017) till the notification of HBP 2023 shall be governed by
provisions contained in HBP 2015-20 (RE-2017).');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.26', 4, 'Run validation: 15
15
20 till the notification of HBP 2015-20 (RE-2017) shall be governed by provisions
contained in HBP 2015-20.');
INSERT INTO workflows (section_code, step_index, step_text) VALUES ('5.26', 5, 'Run validation: The EPCG Authorisations issued between notification
of HBP 2015-20 (RE-2017) till the notification of HBP 2023 shall be governed by
provisions contained in HBP 2015-20 (RE-2017).');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'The');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'FTP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'for');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'are');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'and');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'iii');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'LED');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'vii');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'BEV');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'all');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'xii');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'HBP');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'RE-');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'Wind');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'kind');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'Heat');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'viii');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'than');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'HEVs');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'keywords', 'PHEV');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'tags', '5.26');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'tags', 'Green Technology Products');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'tags', 'business-rule');
INSERT INTO entities (section_code, entity_type, entity_value) VALUES ('5.26', 'tags', 'dgft');
INSERT INTO glossary (term, definition) VALUES ('ANF', 'Referenced in context: 5.02 Application Form
An application for grant of an authorisation may be made by Registered Office or
Head Office or a Branch Office or Man');
INSERT INTO glossary (term, definition) VALUES ('API', 'Referenced in context: (b) On being satisfied, RA concerned shall issue EODC to the EPCG authorisation
holder and an online copy will be forwarded to ICEGATE throu');
INSERT INTO glossary (term, definition) VALUES ('ARE', 'Referenced in context: (a) ARE 1 certificate issued by Central Excise/Tax invoice for
export prescribed under the GST rules with due authentication
by the Customs');
INSERT INTO glossary (term, definition) VALUES ('ARO', 'Referenced in context: 5.09 Sourcing of Capital Goods Manufactured Indigenously
(a) EPCG authorisation holder intending to source capital goods manufactured
indige');
INSERT INTO glossary (term, definition) VALUES ('BEV', 'Referenced in context: 5.26 Green Technology Products
The Export Products covered under Paragraph 5.10 of FTP which provides for
reduced export obligation of 75% f');
INSERT INTO glossary (term, definition) VALUES ('BG', 'Referenced in context: The
Authorisation holder shall furnish additional BG/LUT to the Customs
Authority.');
INSERT INTO glossary (term, definition) VALUES ('BRC', 'Referenced in context: Shipping bill/Bill of Export, GST invoice and e-BRC/ export
realisation from RBI’s EDPMS should be in the name of third party
exporter.');
INSERT INTO glossary (term, definition) VALUES ('CEC', 'Referenced in context: 5.03 Nexus Certification
(a) RA concerned shall, on the basis of nexus certificate from an independent
Chartered Engineer (CEC) submitted by');
INSERT INTO glossary (term, definition) VALUES ('CG', 'Referenced in context: (c) An application for amendment in the list of export item(s) including
addition(s)/deletion(s) if any, may be filed with RA concerned prov');
INSERT INTO glossary (term, definition) VALUES ('DGFT', 'Referenced in context: (b) The sectors /product groups for which this relaxation is to be allowed shall
be conveyed by the DGFT to all the RAs within seven months');
INSERT INTO glossary (term, definition) VALUES ('DOR', 'Referenced in context: Where EO of the first block is not fulfilled in terms of para (a) above, except
in cases where the EO prescribed for first block is extended');
INSERT INTO glossary (term, definition) VALUES ('DTA', 'Referenced in section title ''Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG''.');
INSERT INTO glossary (term, definition) VALUES ('EDPMS', 'Referenced in context: Shipping bill/Bill of Export, GST invoice and e-BRC/ export
realisation from RBI’s EDPMS should be in the name of third party
exporter.');
INSERT INTO glossary (term, definition) VALUES ('EO', 'Referenced in context: The RA may allow extension of the said period for
submission of certificate, upto valid EO period with a payment of a
composition fee of Rs.');
INSERT INTO glossary (term, definition) VALUES ('EODC', 'Referenced in context: (c) Authorisation holder shall maintain a register of stock & utilisation of
capital goods covered under sub-paragraphs (a)(iii) and (iv) of');
INSERT INTO glossary (term, definition) VALUES ('EOP', 'Referenced in context: (f) Clubbing would be permitted during valid EOP including extended period, if
any.');
INSERT INTO glossary (term, definition) VALUES ('EOU', 'Referenced in section title ''Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG''.');
INSERT INTO glossary (term, definition) VALUES ('EPCG', 'Referenced in context: 5.01 Policy
Policy relating to EPCG Scheme is given in Chapter 5 of FTP');
INSERT INTO glossary (term, definition) VALUES ('FIRC', 'Referenced in context: Such report shall contain a statement
with details of Shipping bill/Invoice number/Bill of Export/FIRC number with date
and number, as appli');
INSERT INTO glossary (term, definition) VALUES ('FOR', 'Referenced in context: (c) In case of domestic sourcing of capital goods through invalidation
letter/ARO, the duties, taxes and cess payable shall be with referenc');
INSERT INTO glossary (term, definition) VALUES ('FT', 'Referenced in context: 5.24 Penal Action
In case of failure to fulfil export obligation or any other condition of
authorisation, authorisation holder shall be liab');
INSERT INTO glossary (term, definition) VALUES ('FTP', 'Referenced in context: 5.01 Policy
Policy relating to EPCG Scheme is given in Chapter 5 of FTP');
INSERT INTO glossary (term, definition) VALUES ('GST', 'Referenced in context: Shipping bill/Bill of Export, GST invoice and e-BRC/ export
realisation from RBI’s EDPMS should be in the name of third party
exporter.');
INSERT INTO glossary (term, definition) VALUES ('GSTIN', 'Referenced in context: The
"Certificate of supplies from SEZ" shall contain the following details:
(i) Name, Address and GSTIN of SEZ unit;
(ii) GSTIN & Address of');
INSERT INTO glossary (term, definition) VALUES ('HBP', 'Referenced in context: 5.05 Port of Registration
EPCG Authorisation shall be issued with a single port of registration as per
paragraph 4.35 of HBP, for imports.');
INSERT INTO glossary (term, definition) VALUES ('ICEGATE', 'Referenced in context: (b) On being satisfied, RA concerned shall issue EODC to the EPCG authorisation
holder and an online copy will be forwarded to ICEGATE throu');
INSERT INTO glossary (term, definition) VALUES ('IEC', 'Referenced in context: The authorization holder shall be
permitted to shift capital goods during the entire export obligation period
to other units mentioned in th');
INSERT INTO glossary (term, definition) VALUES ('LED', 'Referenced in context: 5.26 Green Technology Products
The Export Products covered under Paragraph 5.10 of FTP which provides for
reduced export obligation of 75% f');
INSERT INTO glossary (term, definition) VALUES ('LR', 'Referenced in context: (ii) Lorry Receipt (LR) /Logistical evidence for transportation of
goods from the premises of the authorisation holder to the
third party ex');
INSERT INTO glossary (term, definition) VALUES ('LUT', 'Referenced in context: The
Authorisation holder shall furnish additional BG/LUT to the Customs
Authority.');
INSERT INTO glossary (term, definition) VALUES ('PHEV', 'Referenced in context: 5.26 Green Technology Products
The Export Products covered under Paragraph 5.10 of FTP which provides for
reduced export obligation of 75% f');
INSERT INTO glossary (term, definition) VALUES ('PN', 'Referenced in context: 1
as amended vide PN No.');
INSERT INTO glossary (term, definition) VALUES ('PRC', 'Referenced in context: (e) For implementation of all PRC decisions involving levy of Composition Fee
while allowing extension in block-wise/EO period and/or regula');
INSERT INTO glossary (term, definition) VALUES ('RA', 'Referenced in context: 5.02 Application Form
An application for grant of an authorisation may be made by Registered Office or
Head Office or a Branch Office or Man');
INSERT INTO glossary (term, definition) VALUES ('RBI', 'Referenced in context: Shipping bill/Bill of Export, GST invoice and e-BRC/ export
realisation from RBI’s EDPMS should be in the name of third party
exporter.');
INSERT INTO glossary (term, definition) VALUES ('RCMC', 'Referenced in context: The authorization holder shall be
permitted to shift capital goods during the entire export obligation period
to other units mentioned in th');
INSERT INTO glossary (term, definition) VALUES ('RE', 'Referenced in context: (d) (i) Authorisations issued from 1st April, 2002 upto 31st August, 2004
shall be governed by provisions of paragraph 5.8 of HBP Vol.1 (RE-');
INSERT INTO glossary (term, definition) VALUES ('SEZ', 'Referenced in section title ''Conversion of EOU/Relocated SEZ Units to DTA Unit under EPCG''.');