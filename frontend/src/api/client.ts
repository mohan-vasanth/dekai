import { authStorage } from "../services/auth-storage";
import { API_BASE } from "./base-url";

type RequestOptions = RequestInit & {
  skipAuth?: boolean;
};

export class ApiError extends Error {
  status: number;
  constructor(message: string, status: number) {
    super(message);
    this.status = status;
  }
}

async function apiFetch(path: string, options: RequestOptions = {}): Promise<Response> {
  const headers = new Headers(options.headers);
  const token = authStorage.getToken();
  if (!options.skipAuth && token) {
    headers.set("Authorization", `Bearer ${token}`);
  }

  const response = await fetch(`${API_BASE}${path}`, {
    ...options,
    headers,
  });

  if (!response.ok) {
    let detail = response.statusText;
    try {
      const body = await response.json();
      detail = body.detail || body.message || detail;
    } catch {
      // ignore parse failure
    }
    throw new ApiError(detail, response.status);
  }

  return response;
}

export async function apiRequest<T>(path: string, options: RequestOptions = {}): Promise<T> {
  const response = await apiFetch(path, options);
  if (response.status === 204) {
    return undefined as T;
  }

  return response.json() as Promise<T>;
}

export async function apiTextRequest(path: string, options: RequestOptions = {}): Promise<string> {
  const response = await apiFetch(path, options);
  return response.text();
}

export async function apiBlobRequest(path: string, options: RequestOptions = {}): Promise<Blob> {
  const response = await apiFetch(path, options);
  return response.blob();
}
