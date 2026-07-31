const TOKEN_KEY = "dekai-auth-token";
const USER_KEY = "dekai-auth-user";

const isValidRole = (value: unknown): value is "admin" | "user" =>
  value === "admin" || value === "user";

const isValidUser = (
  value: unknown,
): value is { email: string; name: string; role: "admin" | "user" } => {
  if (!value || typeof value !== "object") {
    return false;
  }

  const candidate = value as Record<string, unknown>;
  return (
    typeof candidate.email === "string" &&
    typeof candidate.name === "string" &&
    isValidRole(candidate.role)
  );
};

export const authStorage = {
  clear() {
    window.localStorage.removeItem(TOKEN_KEY);
    window.localStorage.removeItem(USER_KEY);
  },
  getToken() {
    return window.localStorage.getItem(TOKEN_KEY);
  },
  getUser() {
    const raw = window.localStorage.getItem(USER_KEY);
    if (!raw) {
      return null;
    }
    try {
      const parsed = JSON.parse(raw) as unknown;
      if (!isValidUser(parsed)) {
        window.localStorage.removeItem(USER_KEY);
        window.localStorage.removeItem(TOKEN_KEY);
        return null;
      }
      return parsed;
    } catch {
      window.localStorage.removeItem(USER_KEY);
      window.localStorage.removeItem(TOKEN_KEY);
      return null;
    }
  },
  setSession(token: string, user: unknown) {
    window.localStorage.setItem(TOKEN_KEY, token);
    window.localStorage.setItem(USER_KEY, JSON.stringify(user));
  },
};
