import { Navigate, Outlet, Route, Routes } from "react-router-dom";
import { AppShell } from "./components/layout";
import { RequireAdmin, RequireAuth } from "./hooks/use-auth";
import { ChatPage, DocumentsPage, KnowledgeBasePage, LoginPage, PdfToMarkdownPage, SearchPage, SettingsPage } from "./pages/index";

function ShellLayout() {
  return (
    <AppShell>
      <Outlet />
    </AppShell>
  );
}

export default function App() {
  return (
    <Routes>
      <Route element={<LoginPage />} path="/login" />
      <Route element={<ShellLayout />}>
        <Route element={<Navigate replace to="/chat" />} path="/" />
        <Route
          element={
            <RequireAuth>
              <ChatPage />
            </RequireAuth>
          }
          path="/chat"
        />
        <Route
          element={
            <RequireAdmin>
              <DocumentsPage />
            </RequireAdmin>
          }
          path="/documents"
        />
        <Route
          element={
            <RequireAuth>
              <PdfToMarkdownPage />
            </RequireAuth>
          }
          path="/pdf-to-markdown"
        />
        <Route
          element={
            <RequireAuth>
              <KnowledgeBasePage />
            </RequireAuth>
          }
          path="/knowledge-base"
        />
        <Route
          element={
            <RequireAuth>
              <SearchPage />
            </RequireAuth>
          }
          path="/search"
        />
        <Route
          element={
            <RequireAuth>
              <SettingsPage />
            </RequireAuth>
          }
          path="/settings"
        />
      </Route>
      <Route element={<Navigate replace to="/chat" />} path="*" />
    </Routes>
  );
}
