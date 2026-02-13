import React, { createContext, useContext, useState, useEffect, useCallback, useMemo } from "react";

interface DevModeContextValue {
  enabled: boolean;
  toggle: () => void;
  showOutlines: boolean;
  setShowOutlines: (v: boolean) => void;
}

const DevModeContext = createContext<DevModeContextValue>({
  enabled: false,
  toggle: () => {},
  showOutlines: true,
  setShowOutlines: () => {},
});

export function useDevMode() {
  return useContext(DevModeContext);
}

export function DevModeProvider({ children }: { children: React.ReactNode }) {
  const [enabled, setEnabled] = useState(false);
  const [showOutlines, setShowOutlines] = useState(true);

  const toggle = useCallback(() => setEnabled((v) => !v), []);

  useEffect(() => {
    function handleKeyDown(e: KeyboardEvent) {
      if ((e.ctrlKey || e.metaKey) && e.shiftKey && e.key === "D") {
        e.preventDefault();
        toggle();
      }
    }
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [toggle]);

  const outlineSelector = showOutlines ? "[data-dev-annotation]" : "[data-dev-annotation]:hover";

  const cssText = useMemo(() => `
    ${outlineSelector} {
      outline: 1px dashed rgba(0, 65, 217, 0.4) !important;
      outline-offset: 1px;
    }
    [data-dev-annotation]:hover {
      outline: 2px solid rgba(0, 65, 217, 0.8) !important;
      outline-offset: 1px;
    }
  `, [outlineSelector]);

  return (
    <DevModeContext.Provider value={{ enabled, toggle, showOutlines, setShowOutlines }}>
      {children}
      {enabled && <style>{cssText}</style>}
    </DevModeContext.Provider>
  );
}
