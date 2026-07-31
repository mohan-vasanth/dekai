import { useEffect } from "react";
import { useLocation, useNavigationType } from "react-router-dom";

const STORAGE_PREFIX = "dekai-scroll:";

const getScrollKey = (pathname: string, search: string, hash: string) => `${pathname}${search}${hash}`;

export function RouteScrollRestoration() {
  const location = useLocation();
  const navigationType = useNavigationType();
  const scrollKey = getScrollKey(location.pathname, location.search, location.hash);

  useEffect(() => {
    const saved = window.sessionStorage.getItem(`${STORAGE_PREFIX}${scrollKey}`);
    const top = navigationType === "POP" && saved !== null ? Number(saved) : 0;
    const frame = window.requestAnimationFrame(() => {
      window.scrollTo({ top, left: 0, behavior: "auto" });
    });

    return () => window.cancelAnimationFrame(frame);
  }, [navigationType, scrollKey]);

  useEffect(() => {
    return () => {
      window.sessionStorage.setItem(`${STORAGE_PREFIX}${scrollKey}`, String(window.scrollY));
    };
  }, [scrollKey]);

  return null;
}
