import { createContext, useContext, useEffect, useMemo, useState, type PropsWithChildren } from "react";
import { useAuth } from "../hooks/use-auth";
import { useSettings } from "../hooks/use-settings";

type AppLanguage = "English" | "Hindi" | "Tamil";
type TranslationParams = Record<string, string | number>;

const LANGUAGE_STORAGE_KEY = "dekai-language";
const MODEL_STORAGE_KEY = "dekai-ai-model";
const DEFAULT_LANGUAGE: AppLanguage = "English";
const DEFAULT_MODEL = "Ollama (Qwen 2.5)";

const SUPPORTED_LANGUAGES: AppLanguage[] = ["English", "Hindi", "Tamil"];
const KNOWN_MODELS = [
  "GPT-4.1",
  "Claude Sonnet",
  "Gemini Pro",
  "Ollama (Llama 3.2)",
  "Ollama (Qwen 2.5)",
] as const;

const LOCALE_BY_LANGUAGE: Record<AppLanguage, "en" | "hi" | "ta"> = {
  English: "en",
  Hindi: "hi",
  Tamil: "ta",
};

const EN_TRANSLATIONS = {
  "common.back": "Back",
  "common.settings": "Settings",
  "common.search": "Search",
  "common.documents": "Documents",
  "common.pdfToMarkdown": "PDF to Markdown",
  "common.knowledgeBase": "Knowledge Base",
  "common.chat": "AI Chat",
  "common.language": "Language",
  "common.aiModel": "AI Model",
  "common.uploadPdf": "Upload PDF",
  "common.uploadPdfs": "Upload PDFs",
  "common.download": "Download",
  "common.view": "View",
  "common.replace": "Replace",
  "common.reindex": "Re-index",
  "common.delete": "Delete",
  "common.pages": "Pages",
  "common.sections": "Sections",
  "common.chapters": "Chapters",
  "common.chapter": "Chapter",
  "common.glossaryTerms": "Glossary Terms",
  "common.processing": "Processing",
  "common.ready": "Ready",
  "common.idle": "Idle",
  "common.status": "Status",
  "common.actions": "Actions",
  "common.openResult": "Open Result",
  "common.openSection": "Open Section",
  "common.downloadMarkdown": "Download Markdown",
  "common.downloadHtml": "Download HTML",
  "common.appliesInstantly": "Applies instantly",
  "common.success": "success",
  "common.warning": "warning",
  "common.info": "info",
  "layout.brandSubtitle": "Customs & DGFT Assistant",
  "layout.newChat": "New Chat",
  "layout.chatHistory": "Chat History",
  "layout.chatHistoryEmpty": "Your recent customs and DGFT questions will appear here.",
  "layout.builtForTrade": "Built for trade workflows",
  "layout.builtForTradeBody": "Ask about IEC, HSN codes, DGFT chapters, import process, export process, authorisations, and exceptions.",
  "layout.page.documents.title": "Documents",
  "layout.page.documents.subtitle": "Admin uploads PDFs and builds the knowledge base.",
  "layout.page.pdf.title": "PDF to Markdown",
  "layout.page.pdf.subtitle": "Convert a standalone PDF into Markdown without changing indexed knowledge.",
  "layout.page.knowledge.title": "Knowledge Base",
  "layout.page.knowledge.subtitle": "Browse DGFT, FTP, and HBP chapters in a clean tree view.",
  "layout.page.search.title": "Search",
  "layout.page.search.subtitle": "Find chapters, sections, rules, and source references.",
  "layout.page.settings.title": "Settings",
  "layout.page.settings.subtitle": "Theme, language, and AI model preferences.",
  "layout.page.chat.title": "AI Chat",
  "layout.page.chat.subtitle": "Ask naturally about DGFT, Customs, Import, Export, IEC, and HSN.",
  "settings.title": "Personalize the DEKAI AI workspace",
  "settings.subtitle": "Keep settings simple: theme, language, and AI model.",
  "settings.languageDescription": "Choose the interface language.",
  "settings.modelDescription": "Select the primary answer model for this workspace.",
  "settings.themeDescription": "Use {value} mode across DEKAI AI.",
  "settings.themeSystem": "Follows device preference. Currently {value}.",
  "settings.success": "Settings updated successfully.",
  "settings.failed": "Unable to save settings. Please try again.",
  "settings.themeUpdated": "Settings updated",
  "search.title": "Search DGFT, Customs, Import and Export knowledge",
  "search.subtitle": "Search by keyword, rule, chapter, section, HS code, IEC, import, or export and open the best matching result.",
  "search.placeholder": "Search keyword, rule, chapter, section, HS code, IEC, import or export",
  "search.noResults": "No results matched the current search.",
  "search.start": "Start with a keyword, section, rule, IEC, HS code, import or export query.",
  "documents.adminOnly": "Admin only",
  "documents.userNeverUploads": "User never uploads",
  "documents.title": "Build the knowledge base from uploaded PDFs",
  "documents.subtitle": "Upload one PDF or a full document set. Every PDF is validated, processed independently, chunked, embedded, stored, and indexed before it becomes Knowledge Ready for AI chat and search.",
  "documents.multiUpload": "Multi-file drag & drop supported",
  "documents.uploadedDocuments": "Uploaded Documents",
  "documents.uploadedDocumentsSubtitle": "All source PDFs with live processing, indexing, and knowledge-readiness status.",
  "documents.searchPlaceholder": "Search document or chapter",
  "documents.processingProgress": "Processing Progress",
  "documents.processingProgressSubtitle": "Knowledge Ready means the full processing and indexing pipeline completed successfully.",
  "documents.selectDocument": "Select a document to inspect its knowledge pipeline and index health.",
  "documents.knowledgeStatus": "Knowledge Status",
  "documents.knowledgeReady": "Knowledge Ready",
  "documents.actionRequired": "Action required",
  "documents.knowledgeFootprint": "Knowledge Footprint",
  "documents.documentType": "Document Type",
  "documents.documentName": "Document Name",
  "documents.uploadDate": "Upload Date",
  "documents.version": "Version",
  "documents.pdf": "PDF",
  "documents.uploadStarted": "Upload started",
  "documents.batchUploadStarted": "Batch upload started",
  "documents.uploadStartedDescription": "Live processing has started on the backend.",
  "documents.batchUploadStartedDescription": "{count} PDFs were queued for shared knowledge-base indexing.",
  "documents.uploadFailed": "Upload failed",
  "documents.documentDeleted": "Document deleted",
  "documents.documentDeletedDescription": "Document deleted successfully.",
  "documents.deleteFailed": "Delete failed",
  "documents.replacementStarted": "Replacement started",
  "documents.replacementStartedDescription": "The backend is reprocessing the document.",
  "documents.replacementFailed": "Replacement failed",
  "documents.reindexStarted": "Re-index started",
  "documents.reindexStartedDescription": "The backend is rebuilding this document in the shared knowledge base.",
  "documents.reindexFailed": "Re-index failed",
  "pdf.independentModule": "Independent module",
  "pdf.noKbIndexing": "No KB indexing",
  "pdf.title": "Convert any PDF into structured Markdown",
  "pdf.subtitle": "Upload one PDF, let DEKAI read the document structure, generate Markdown, preview the output, and download the `.md` file without affecting the existing knowledge base workflow.",
  "pdf.singleFile": "Single-file conversion",
  "pdf.summary": "Conversion Summary",
  "pdf.summarySubtitle": "Latest PDF-to-Markdown result.",
  "pdf.preview": "Markdown Preview",
  "pdf.previewSubtitle": "Generated markdown for the uploaded PDF.",
  "pdf.previewEmpty": "The Markdown preview appears here after conversion.",
  "pdf.uploadPrompt": "Upload a PDF to generate a standalone markdown file.",
  "pdf.markdownReady": "Markdown ready",
  "pdf.markdownReadyDescription": "{fileName} was generated without changing the shared knowledge base.",
  "pdf.conversionFailed": "Conversion failed",
  "pdf.unsupportedFile": "Unsupported file",
  "pdf.unsupportedFileDescription": "Only PDF files are supported.",
  "pdf.emptyFile": "Empty file",
  "pdf.emptyFileDescription": "The selected PDF is empty.",
  "pdf.processingDescription": "Processing {fileName} and generating a standalone markdown file.",
  "chat.title": "AI Chat",
  "chat.subtitle": "Ask naturally. DEKAI answers only the question asked, and adds more only when you ask for it.",
  "chat.currentTopic": "Current topic:",
  "chat.activeModel": "Active model: {model}",
  "chat.voiceOptional": "Voice input is optional",
  "chat.voiceOptionalDescription": "Wire this button to speech capture when backend support is ready.",
  "chat.speechIntegration": "Speech integration can be added on top of this composer.",
  "chat.requestFailed": "Chat request failed",
  "chat.regenerationFailed": "Regeneration failed",
  "chat.answerCopied": "Answer copied",
  "chat.clipboardUnavailable": "Clipboard unavailable",
  "chat.clipboardUnavailableDescription": "The browser could not copy this answer.",
  "chat.feedbackPositive": "Positive feedback recorded",
  "chat.feedbackRecorded": "Feedback recorded",
  "chat.attachDraft": "{fileName} attached to draft",
  "chat.attachDraftDescription": "Attachment support is ready for backend integration.",
  "chat.placeholder": "Ask anything about DGFT, Customs, Import, Export...",
  "chat.focusedAnswer": "Focused answer",
  "chat.copy": "Copy",
  "chat.regenerate": "Regenerate",
  "chat.thinking": "Thinking through the uploaded document...",
  "chat.heroTitle": "Your AI Customs & DGFT Assistant",
  "chat.heroSubtitle": "What would you like to know about DGFT, Customs, Import or Export today?",
  "chat.suggestedQuestions": "Suggested Questions",
  "chat.suggestedQuestion1": "What is IEC?",
  "chat.suggestedQuestion2": "Explain Import Process",
  "chat.suggestedQuestion3": "Explain Export Process",
  "chat.suggestedQuestion4": "Explain HBP Chapter 2",
  "chat.suggestedQuestion5": "Find HS Code",
  "chat.suggestedQuestion6": "Explain Advance Authorisation",
  "chat.suggestedQuestion7": "What is EPCG?",
  "knowledge.title": "DGFT / FTP / HBP Tree View",
  "knowledge.subtitle": "Browse chapters and sections in a clean tree, then inspect business meaning, rules, conditions, and related references.",
  "knowledge.visibleSections": "{count} visible sections",
  "knowledge.searchPlaceholder": "Search chapter, section, title, business meaning, or keywords",
  "knowledge.dgft": "DGFT",
  "knowledge.ftpHbp": "FTP / HBP",
  "knowledge.noMatch": "No matching chapters or sections found.",
  "knowledge.noSectionMatch": "No sections match the current search.",
  "knowledge.businessMeaning": "Business Meaning",
  "knowledge.knowledgeSignals": "Knowledge Signals",
  "knowledge.authorities": "Authorities",
  "knowledge.relatedChapters": "Related Chapters",
  "knowledge.noAuthorities": "No authorities extracted.",
  "knowledge.noRelatedChapters": "No related chapters linked.",
  "knowledge.sectionViewer": "Section Viewer",
  "knowledge.noBusinessRules": "No extracted business rules were available for this section.",
  "knowledge.coverage": "Coverage",
  "knowledge.matchingSections": "Matching Sections",
  "knowledge.homeTag": "Knowledge Base Home",
  "knowledge.homeTitle": "Browse chapters, then drill into sections",
  "knowledge.homeSubtitle": "Select a chapter from the left panel to review coverage, or open a section to inspect business meaning, rules, conditions, exceptions, and related references.",
  "knowledge.openSectionFailed": "Unable to open the selected section.",
  "knowledge.chapterWithNumber": "Chapter {value}",
  "knowledge.ruleSummary": "{rules} rules • {conditions} conditions • {exceptions} exceptions",
  "knowledge.coverageSummary": "{sections} sections • {workflows} workflows • {authorities} authority references",
  "login.title": "Access DEKAI AI",
  "login.subtitle": "Sign in to explore your indexed DGFT and Customs knowledge base with grounded AI answers.",
  "login.demoAccess": "Demo Access",
  "login.demoAccessSubtitle": "Default credentials are already prefilled for local development. Update them below if needed.",
  "login.email": "Email",
  "login.password": "Password",
  "login.signingIn": "Signing in...",
  "login.login": "Login",
  "login.success": "Login successful",
  "login.failed": "Login failed",
  "login.failedDescription": "Unable to login.",
  "login.heroBadge": "DGFT • Customs • Import • Export",
  "login.heroTitle": "Your AI Assistant for DGFT & Customs",
  "login.heroBody1": "Ask questions about DGFT, FTP, HBP, IEC, HS Codes, Import Procedures, Export Procedures, Customs Regulations, and Trade Policies.",
  "login.heroBody2": "DEKAI AI retrieves information from your knowledge base and provides accurate, context-aware answers in a conversational format.",
  "login.quickActions": "Quick Actions",
  "login.quickActionsTitle": "Common questions to explore first",
  "login.quickActionsSubtitle": "These prompts adapt cleanly across desktop, tablet, and mobile layouts.",
  "login.mode": "Mode",
  "login.answers": "Answers",
  "login.focus": "Focus",
  "login.modeValue": "Knowledge-grounded",
  "login.answersValue": "Context-aware",
  "login.focusValue": "Trade intelligence",
  "login.enterpriseAssistant": "Enterprise Knowledge Assistant",
  "login.quickAction1": "What is IEC?",
  "login.quickAction2": "Explain Import Process",
  "login.quickAction3": "Find HS Code",
  "login.quickAction4": "Explain Advance Authorisation",
  "login.quickAction5": "Import workflow",
  "login.quickAction6": "Export documents required",
  "login.capability1": "DGFT, FTP, and HBP guidance",
  "login.capability2": "IEC, HS Code, import, and export queries",
  "login.capability3": "Grounded answers from your knowledge base",
} as const;
const HI_TRANSLATIONS = {
  ...EN_TRANSLATIONS,
  "common.back": "वापस",
  "common.settings": "सेटिंग्स",
  "common.search": "खोज",
  "common.documents": "दस्तावेज़",
  "common.pdfToMarkdown": "PDF से Markdown",
  "common.knowledgeBase": "ज्ञान आधार",
  "common.chat": "AI चैट",
  "common.language": "भाषा",
  "common.aiModel": "AI मॉडल",
  "common.uploadPdf": "PDF अपलोड करें",
  "common.uploadPdfs": "PDFs अपलोड करें",
  "common.download": "डाउनलोड",
  "common.view": "देखें",
  "common.replace": "बदलिए",
  "common.reindex": "री-इंडेक्स",
  "common.delete": "हटाएं",
  "common.processing": "प्रोसेसिंग",
  "common.ready": "तैयार",
  "common.idle": "निष्क्रिय",
  "common.chapter": "अध्याय",
  "layout.newChat": "नई चैट",
  "layout.chatHistory": "चैट इतिहास",
  "layout.builtForTrade": "ट्रेड वर्कफ़्लो के लिए निर्मित",
  "settings.success": "सेटिंग्स सफलतापूर्वक अपडेट हो गईं।",
  "settings.failed": "सेटिंग्स सहेजी नहीं जा सकीं। कृपया पुनः प्रयास करें।",
  "knowledge.visibleSections": "{count} दृश्य खंड",
  "knowledge.businessMeaning": "व्यावसायिक अर्थ",
  "knowledge.knowledgeSignals": "ज्ञान संकेत",
  "knowledge.authorities": "प्राधिकरण",
  "knowledge.relatedChapters": "संबंधित अध्याय",
  "knowledge.matchingSections": "मिलते-जुलते खंड",
  "knowledge.coverage": "कवरेज",
  "search.noResults": "मौजूदा खोज से कोई परिणाम नहीं मिला।",
  "chat.copy": "कॉपी",
  "chat.regenerate": "फिर से बनाएं",
  "chat.feedbackPositive": "सकारात्मक प्रतिक्रिया दर्ज की गई",
  "chat.feedbackRecorded": "प्रतिक्रिया दर्ज की गई",
  "login.login": "लॉगिन",
  "login.signingIn": "लॉगिन हो रहा है...",
  "login.success": "लॉगिन सफल रहा",
  "login.failed": "लॉगिन विफल",
} as const;

const TA_TRANSLATIONS = {
  ...EN_TRANSLATIONS,
  "common.back": "பின்",
  "common.settings": "அமைப்புகள்",
  "common.search": "தேடல்",
  "common.documents": "ஆவணங்கள்",
  "common.pdfToMarkdown": "PDF முதல் Markdown",
  "common.knowledgeBase": "அறிவு தளம்",
  "common.chat": "AI அரட்டை",
  "common.language": "மொழி",
  "common.aiModel": "AI மாதிரி",
  "common.uploadPdf": "PDF பதிவேற்று",
  "common.uploadPdfs": "PDFகளை பதிவேற்று",
  "common.download": "பதிவிறக்கு",
  "common.view": "பார்க்க",
  "common.replace": "மாற்று",
  "common.reindex": "மீள் அட்டவணையிடு",
  "common.delete": "நீக்கு",
  "common.processing": "செயலாக்கம்",
  "common.ready": "தயார்",
  "common.idle": "காத்திருக்கிறது",
  "common.chapter": "அத்தியாயம்",
  "layout.newChat": "புதிய அரட்டை",
  "layout.chatHistory": "அரட்டை வரலாறு",
  "layout.builtForTrade": "வர்த்தக செயல்முறைகளுக்காக உருவாக்கப்பட்டது",
  "settings.success": "அமைப்புகள் வெற்றிகரமாக புதுப்பிக்கப்பட்டன.",
  "settings.failed": "அமைப்புகளை சேமிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.",
  "knowledge.visibleSections": "{count} காணக்கூடிய பிரிவுகள்",
  "knowledge.businessMeaning": "வணிக பொருள்",
  "knowledge.knowledgeSignals": "அறிவு சுட்டிகள்",
  "knowledge.authorities": "அதிகாரங்கள்",
  "knowledge.relatedChapters": "தொடர்புடைய அத்தியாயங்கள்",
  "knowledge.matchingSections": "பொருந்தும் பிரிவுகள்",
  "knowledge.coverage": "பரப்பு",
  "search.noResults": "தற்போதைய தேடலுக்கு பொருந்தும் முடிவுகள் இல்லை.",
  "chat.copy": "நகலெடு",
  "chat.regenerate": "மீண்டும் உருவாக்கு",
  "chat.feedbackPositive": "நல்ல பின்னூட்டம் பதிவு செய்யப்பட்டது",
  "chat.feedbackRecorded": "பின்னூட்டம் பதிவு செய்யப்பட்டது",
  "login.login": "உள்நுழை",
  "login.signingIn": "உள்நுழைகிறது...",
  "login.success": "உள்நுழைவு வெற்றி",
  "login.failed": "உள்நுழைவு தோல்வி",
} as const;

const TRANSLATIONS = {
  en: EN_TRANSLATIONS,
  hi: HI_TRANSLATIONS,
  ta: TA_TRANSLATIONS,
} as const;

type TranslationKey = keyof typeof EN_TRANSLATIONS;

type PreferencesContextValue = {
  aiModel: string;
  language: AppLanguage;
  locale: "en" | "hi" | "ta";
  modelOptions: readonly string[];
  setAiModel: (value: string) => void;
  setLanguage: (value: AppLanguage) => void;
  t: (key: TranslationKey, params?: TranslationParams) => string;
  translateStageState: (value: string) => string;
  translateStatus: (value: string) => string;
  getLanguageLabel: (value: string) => string;
};

const PreferencesContext = createContext<PreferencesContextValue | null>(null);

const isSupportedLanguage = (value: unknown): value is AppLanguage =>
  typeof value === "string" && SUPPORTED_LANGUAGES.includes(value as AppLanguage);

const isKnownModel = (value: unknown): value is string =>
  typeof value === "string" && KNOWN_MODELS.includes(value as (typeof KNOWN_MODELS)[number]);

const resolveModelOptions = (supportedModels?: string[]) => {
  const dynamicModels = (supportedModels ?? []).filter((value): value is string => isKnownModel(value));
  return dynamicModels.length > 0 ? dynamicModels : [...KNOWN_MODELS];
};

const interpolate = (template: string, params?: TranslationParams) => {
  if (!params) return template;
  return template.replace(/\{(\w+)\}/g, (_, key: string) => String(params[key] ?? `{${key}}`));
};

const readStoredLanguage = () => {
  const value = window.localStorage.getItem(LANGUAGE_STORAGE_KEY);
  return isSupportedLanguage(value) ? value : DEFAULT_LANGUAGE;
};

const readStoredModel = () => {
  const value = window.localStorage.getItem(MODEL_STORAGE_KEY);
  return isKnownModel(value) ? value : DEFAULT_MODEL;
};

export function PreferencesProvider({ children }: PropsWithChildren) {
  const { isAuthenticated } = useAuth();
  const { data: settings } = useSettings(isAuthenticated);
  const modelOptions = resolveModelOptions(settings?.metadata?.supportedModels);
  const [language, setLanguageState] = useState<AppLanguage>(() => readStoredLanguage());
  const [aiModel, setAiModelState] = useState<string>(() => readStoredModel());

  useEffect(() => {
    if (!settings) return;
    if (isSupportedLanguage(settings.language)) {
      setLanguageState(settings.language);
    }
    if (modelOptions.includes(settings.aiModel)) {
      setAiModelState(settings.aiModel);
    }
  }, [modelOptions, settings]);

  useEffect(() => {
    if (modelOptions.includes(aiModel)) return;
    setAiModelState(modelOptions[0] ?? DEFAULT_MODEL);
  }, [aiModel, modelOptions]);

  useEffect(() => {
    window.localStorage.setItem(LANGUAGE_STORAGE_KEY, language);
    document.documentElement.lang = LOCALE_BY_LANGUAGE[language];
  }, [language]);

  useEffect(() => {
    window.localStorage.setItem(MODEL_STORAGE_KEY, aiModel);
  }, [aiModel]);

  const locale = LOCALE_BY_LANGUAGE[language];

  const value = useMemo<PreferencesContextValue>(() => {
    const dictionary = TRANSLATIONS[locale];

    return {
      aiModel,
      language,
      locale,
      modelOptions,
      setAiModel: (nextModel: string) => {
        if (modelOptions.includes(nextModel)) {
          setAiModelState(nextModel);
        }
      },
      setLanguage: (nextLanguage: AppLanguage) => {
        if (isSupportedLanguage(nextLanguage)) {
          setLanguageState(nextLanguage);
        }
      },
      t: (key, params) => interpolate(dictionary[key] ?? TRANSLATIONS.en[key] ?? key, params),
      translateStageState: (stage) => {
        if (stage === "complete") return locale === "ta" ? "முடிந்தது" : locale === "hi" ? "पूर्ण" : "complete";
        if (stage === "current") return locale === "ta" ? "நடப்பு" : locale === "hi" ? "वर्तमान" : "current";
        if (stage === "upcoming") return locale === "ta" ? "வரவுள்ளது" : locale === "hi" ? "आगामी" : "upcoming";
        return stage;
      },
      translateStatus: (status) => {
        if (status === "ready") return dictionary["common.ready"];
        if (status === "queued") return locale === "ta" ? "வரிசையில்" : locale === "hi" ? "कतार में" : "queued";
        if (status === "processing") return dictionary["common.processing"];
        if (status === "failed") return locale === "ta" ? "தோல்வி" : locale === "hi" ? "विफल" : "failed";
        return status;
      },
      getLanguageLabel: (value) => {
        if (value === "English") return locale === "ta" ? "ஆங்கிலம்" : locale === "hi" ? "अंग्रेज़ी" : "English";
        if (value === "Hindi") return locale === "ta" ? "இந்தி" : locale === "hi" ? "हिंदी" : "Hindi";
        if (value === "Tamil") return locale === "ta" ? "தமிழ்" : locale === "hi" ? "तमिल" : "Tamil";
        return value;
      },
    };
  }, [aiModel, language, locale, modelOptions]);

  return <PreferencesContext.Provider value={value}>{children}</PreferencesContext.Provider>;
}

export const usePreferences = () => {
  const context = useContext(PreferencesContext);
  if (!context) {
    throw new Error("usePreferences must be used inside PreferencesProvider");
  }
  return context;
};
