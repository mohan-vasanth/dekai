import { apiRequest } from "./client";
import type { PdfMarkdownConversion } from "../types/api";

export const pdfToMarkdownApi = {
  convert(file: File) {
    const body = new FormData();
    body.append("file", file, file.name);
    return apiRequest<PdfMarkdownConversion>("/api/pdf-to-markdown/convert", {
      method: "POST",
      body,
    });
  },
};
