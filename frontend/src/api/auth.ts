import { apiRequest } from "./client";
import type { AuthUser, LoginResponse } from "../types/api";

export const authApi = {
  login(email: string, password: string) {
    return apiRequest<LoginResponse>("/api/auth/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password }),
      skipAuth: true,
    });
  },
  me() {
    return apiRequest<{ user: AuthUser }>("/api/auth/me");
  },
};
