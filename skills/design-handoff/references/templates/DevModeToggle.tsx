import { useDevMode } from "./DevModeProvider";

export function DevModeToggle() {
  const { enabled, toggle, showOutlines, setShowOutlines } = useDevMode();

  return (
    <div
      style={{
        position: "fixed",
        bottom: "16px",
        left: "16px",
        zIndex: 10002,
        display: "flex",
        alignItems: "center",
        gap: "8px",
        padding: "6px 8px",
        borderRadius: "10px",
        background: enabled ? "rgba(26, 26, 46, 0.95)" : "rgba(255, 255, 255, 0.95)",
        boxShadow: "0 4px 20px rgba(0, 0, 0, 0.15), 0 0 0 1px rgba(0, 0, 0, 0.05)",
        backdropFilter: "blur(8px)",
        transition: "all 0.2s ease",
      }}
    >
      <button
        onClick={toggle}
        title={`Dev mode: ${enabled ? "on" : "off"} (Ctrl+Shift+D)`}
        style={{
          display: "flex",
          alignItems: "center",
          gap: "6px",
          padding: "6px 12px",
          borderRadius: "6px",
          border: enabled ? "1px solid rgba(96, 165, 250, 0.4)" : "1px solid #d1d5db",
          background: enabled ? "rgba(0, 65, 217, 0.15)" : "transparent",
          color: enabled ? "#60a5fa" : "#6b7280",
          cursor: "pointer",
          fontFamily: "'SF Mono', 'Fira Code', monospace",
          fontSize: "12px",
          fontWeight: 600,
          lineHeight: "20px",
          transition: "all 0.15s ease",
        }}
      >
        <span style={{ fontSize: "14px" }}>{enabled ? "⚡" : "🔧"}</span>
        Dev
      </button>
      {enabled && (
        <button
          onClick={() => setShowOutlines(!showOutlines)}
          title={showOutlines ? "Hide outlines" : "Show outlines"}
          style={{
            padding: "6px 10px",
            borderRadius: "6px",
            border: "1px solid rgba(255, 255, 255, 0.1)",
            background: showOutlines ? "rgba(0, 65, 217, 0.1)" : "transparent",
            color: showOutlines ? "#60a5fa" : "#9ca3af",
            cursor: "pointer",
            fontFamily: "'SF Mono', 'Fira Code', monospace",
            fontSize: "11px",
            fontWeight: 500,
            lineHeight: "18px",
            transition: "all 0.15s ease",
          }}
        >
          {showOutlines ? "▣" : "▢"} Outlines
        </button>
      )}
    </div>
  );
}
