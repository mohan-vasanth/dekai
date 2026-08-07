const configuredApiBase = (import.meta.env.VITE_API_BASE_URL as string | undefined)?.replace(/\/$/, "");

function runtimeApiBase() {
  if (configuredApiBase) {
    return configuredApiBase;
  }
  if (import.meta.env.DEV && typeof window !== "undefined") {
    return `${window.location.protocol}//${window.location.hostname}:8001`;
  }
  return "";
}

export const API_BASE = runtimeApiBase();
