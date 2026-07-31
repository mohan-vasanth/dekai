import { createContext, useContext, useEffect, useMemo, useState, type PropsWithChildren } from "react";
import { Navigate, useLocation } from "react-router-dom";
import { authApi } from "../api/auth";
import { authStorage } from "../services/auth-storage";
import type { AuthUser } from "../types/api";

type AuthContextValue = {
  isAuthenticated: boolean;
  isLoading: boolean;
  login: (email: string, password: string) => Promise<AuthUser>;
  logout: () => void;
  user: AuthUser | null;
};

const AuthContext = createContext<AuthContextValue | null>(null);

export function AuthProvider({ children }: PropsWithChildren) {
  const [user, setUser] = useState<AuthUser | null>(authStorage.getUser());
  const [isLoading, setIsLoading] = useState(Boolean(authStorage.getToken()));

  useEffect(() => {
    const token = authStorage.getToken();
    if (!token) {
      setIsLoading(false);
      return;
    }

    authApi
      .me()
      .then((response) => setUser(response.user))
      .catch(() => {
        authStorage.clear();
        setUser(null);
      })
      .finally(() => setIsLoading(false));
  }, []);

  const value = useMemo<AuthContextValue>(
    () => ({
      isAuthenticated: Boolean(user),
      isLoading,
      async login(email: string, password: string) {
        const response = await authApi.login(email, password);
        authStorage.setSession(response.token, response.user);
        setUser(response.user);
        return response.user;
      },
      logout() {
        authStorage.clear();
        setUser(null);
      },
      user,
    }),
    [isLoading, user],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth must be used inside AuthProvider");
  }
  return context;
}

function AuthLoadingScreen() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-[var(--background)] px-4">
      <div className="rounded-[1.75rem] border border-[var(--border)] bg-[var(--panel)] px-6 py-5 text-center shadow-[0_24px_64px_rgba(15,23,42,0.08)]">
        <p className="text-xs font-semibold uppercase tracking-[0.24em] text-[var(--muted-foreground)]">DEKAI AI</p>
        <p className="mt-3 text-sm text-[var(--foreground)]">Loading workspace...</p>
      </div>
    </div>
  );
}

export function RequireAuth({ children }: PropsWithChildren) {
  const { isAuthenticated, isLoading } = useAuth();
  const location = useLocation();

  if (isLoading) {
    return <AuthLoadingScreen />;
  }

  if (!isAuthenticated) {
    return <Navigate replace state={{ from: location.pathname }} to="/login" />;
  }

  return children;
}

export function RequireAdmin({ children }: PropsWithChildren) {
  const { isAuthenticated, isLoading, user } = useAuth();
  const location = useLocation();

  if (isLoading) {
    return <AuthLoadingScreen />;
  }

  if (!isAuthenticated) {
    return <Navigate replace state={{ from: location.pathname }} to="/login" />;
  }

  if (user?.role !== "admin") {
    return <Navigate replace to="/chat" />;
  }

  return children;
}
