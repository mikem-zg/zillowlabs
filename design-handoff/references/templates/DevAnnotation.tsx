import React, { useState, useRef, useEffect } from "react";
import { useDevMode } from "./DevModeProvider";

export interface AnnotationData {
  component: string;
  props?: Record<string, string>;
  spacing?: string;
  colors?: string;
  typography?: string;
  icons?: string;
  responsive?: string;
  contains?: string[];
  notes?: string;
  status?: "pass" | "warning" | "violation";
  statusNote?: string;
}

interface DevAnnotationProps {
  annotation: AnnotationData;
  children: React.ReactNode;
  as?: "div" | "span";
}

export function DevAnnotation({ annotation, children, as: Tag = "div" }: DevAnnotationProps) {
  const { enabled } = useDevMode();
  const [showPanel, setShowPanel] = useState(false);
  const [panelPosition, setPanelPosition] = useState<{ top: number; left: number }>({ top: 0, left: 0 });
  const ref = useRef<HTMLElement>(null);

  useEffect(() => {
    if (!showPanel || !ref.current) return;
    const rect = ref.current.getBoundingClientRect();
    const panelWidth = 320;
    const panelHeight = 280;
    let top = rect.top;
    let left = rect.right + 8;

    if (left + panelWidth > window.innerWidth) {
      left = rect.left - panelWidth - 8;
    }
    if (left < 8) {
      left = 8;
    }
    if (top + panelHeight > window.innerHeight) {
      top = window.innerHeight - panelHeight - 8;
    }
    if (top < 8) {
      top = 8;
    }
    setPanelPosition({ top, left });
  }, [showPanel]);

  if (!enabled) {
    return <>{children}</>;
  }

  const statusColor =
    annotation.status === "violation"
      ? "#d32f2f"
      : annotation.status === "warning"
        ? "#ed6c02"
        : "#2e7d32";

  const statusIcon =
    annotation.status === "violation"
      ? "❌"
      : annotation.status === "warning"
        ? "⚠️"
        : "✅";

  const fields: { label: string; value: string | undefined; color: string }[] = [
    { label: "Spacing", value: annotation.spacing, color: "#fbbf24" },
    { label: "Colors", value: annotation.colors, color: "#fb923c" },
    { label: "Typography", value: annotation.typography, color: "#a78bfa" },
    { label: "Icons", value: annotation.icons, color: "#67e8f9" },
    { label: "Responsive", value: annotation.responsive, color: "#86efac" },
    { label: "Contains", value: annotation.contains?.join(", "), color: "#f9a8d4" },
    { label: "Notes", value: annotation.notes, color: "#d1d5db" },
  ];

  return (
    <Tag
      ref={ref as any}
      data-dev-annotation={annotation.component}
      onMouseEnter={() => setShowPanel(true)}
      onMouseLeave={() => setShowPanel(false)}
      style={{ display: "contents" }}
    >
      {children}

      <div
        style={{
          position: "absolute",
          top: -1,
          left: -1,
          background: "rgba(0, 65, 217, 0.85)",
          color: "#fff",
          fontSize: "10px",
          fontFamily: "monospace",
          padding: "1px 5px",
          borderRadius: "0 0 4px 0",
          zIndex: 10000,
          pointerEvents: "none",
          lineHeight: "14px",
          whiteSpace: "nowrap",
        }}
      >
        {annotation.component}
      </div>

      {showPanel && (
        <div
          style={{
            position: "fixed",
            top: panelPosition.top,
            left: panelPosition.left,
            width: 320,
            maxHeight: 400,
            overflowY: "auto",
            background: "#1a1a2e",
            color: "#e0e0e0",
            borderRadius: "8px",
            boxShadow: "0 8px 32px rgba(0,0,0,0.4)",
            zIndex: 10001,
            fontFamily: "'SF Mono', 'Fira Code', monospace",
            fontSize: "11px",
            lineHeight: "1.5",
            border: "1px solid rgba(255,255,255,0.1)",
            pointerEvents: "none",
          }}
        >
          <div
            style={{
              padding: "8px 12px",
              borderBottom: "1px solid rgba(255,255,255,0.1)",
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
            }}
          >
            <span style={{ fontWeight: 700, color: "#60a5fa", fontSize: "12px" }}>
              {annotation.component}
            </span>
            {annotation.status && (
              <span style={{ color: statusColor, fontSize: "10px" }}>
                {statusIcon} {annotation.statusNote || annotation.status}
              </span>
            )}
          </div>

          <div style={{ padding: "8px 12px" }}>
            {annotation.props && Object.keys(annotation.props).length > 0 && (
              <div style={{ marginBottom: "6px" }}>
                <div style={{ color: "#9ca3af", fontSize: "9px", textTransform: "uppercase", letterSpacing: "0.5px", marginBottom: "2px" }}>
                  Props
                </div>
                {Object.entries(annotation.props).map(([key, value]) => (
                  <div key={key}>
                    <span style={{ color: "#c084fc" }}>{key}</span>
                    <span style={{ color: "#6b7280" }}>=</span>
                    <span style={{ color: "#34d399" }}>"{value}"</span>
                  </div>
                ))}
              </div>
            )}

            {fields.map(({ label, value, color }) =>
              value ? (
                <div key={label} style={{ marginBottom: "6px" }}>
                  <div style={{ color: "#9ca3af", fontSize: "9px", textTransform: "uppercase", letterSpacing: "0.5px", marginBottom: "2px" }}>
                    {label}
                  </div>
                  <div style={{ color }}>{value}</div>
                </div>
              ) : null
            )}
          </div>
        </div>
      )}
    </Tag>
  );
}
