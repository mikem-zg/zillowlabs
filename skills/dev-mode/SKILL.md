Dev Mode Canvas
Add a visual debugging canvas to any React web application. The canvas renders every screen, state, variant, and responsive breakpoint simultaneously as live iframes on a dark-themed, pannable, zoomable surface.

Use when: The user asks to add a "dev mode", "screen overview", "design review canvas", "all screens view", or any visual debugging tool that shows multiple routes/states at once.

Prerequisites: React 18+, any routing library (wouter, react-router, etc.), Vite or any bundler that supports iframe loading of routes.

Quick Start
Two files are needed:

components/
  screen-flow-fab.tsx      — FAB button + mounts canvas (always rendered in app root)
  screen-flow-canvas.tsx   — Full canvas with all rendering, data, and interaction logic
Mount the FAB in the app's root layout (e.g., App.tsx):

import ScreenFlowFab from "./components/screen-flow-fab";
function App() {
  return (
    <>
      {/* ... your app routes ... */}
      <ScreenFlowFab />
    </>
  );
}
Step 1: Inventory the Application
Before writing any canvas code, inventory every screen the app has. For each, capture:

Field	Description	Example
id	Unique slug	"login", "dashboard", "settings-edit"
label	Human-readable name	"Login", "Dashboard", "Edit Settings Modal"
path	Route path including query params	"/login", "/dashboard", "/settings?modal=edit"
group	Logical category	"auth", "main", "settings"
edgeCases	What makes this variant notable (optional)	["Empty state", "No data loaded"]
Also identify:

Connections: Which screens flow into which (e.g., Login → Dashboard)
Groups: Logical categories and their visual color
Responsive routes: Which routes need breakpoint testing
Handling Edge Cases and Variants
Edge cases are alternate states of the same screen, triggered by query parameters. The app must handle these params and render the appropriate variant.

/account                        → Normal account page
/account?edge=no-data           → Account with no onboarding data
/account?avatar=true            → Account with profile photo
/account?modal=edit             → Account with edit modal open
/account?edge=no-data&modal=edit → Edit modal with empty fields
The canvas renders each variant as a separate card with its own iframe pointing to the appropriate URL.

Step 2: Create the FAB Component
The FAB (Floating Action Button) is a fixed-position button that opens the canvas. It uses zero design system dependencies — only inline styles and native HTML.

// screen-flow-fab.tsx
import { useState } from "react";
import ScreenFlowCanvas from "./screen-flow-canvas";
const MONO = "'JetBrains Mono', 'Fira Code', 'SF Mono', 'Cascadia Code', Menlo, Consolas, monospace";
export default function ScreenFlowFab() {
  const [open, setOpen] = useState(false);
  return (
    <>
      <button
        onClick={() => setOpen(true)}
        style={{
          position: "fixed",
          bottom: 88,
          right: 24,
          zIndex: 100,
          display: open ? "none" : "flex",
          height: 36,
          borderRadius: 8,
          border: "1px solid #333",
          cursor: "pointer",
          alignItems: "center",
          gap: 8,
          padding: "0 14px",
          backgroundColor: "#1a1a1a",
          boxShadow: "0 4px 14px rgba(0, 0, 0, 0.4)",
          fontFamily: MONO,
          transition: "transform 0.15s ease, box-shadow 0.15s ease",
        }}
        onMouseEnter={(e) => {
          (e.currentTarget as HTMLButtonElement).style.transform = "scale(1.04)";
        }}
        onMouseLeave={(e) => {
          (e.currentTarget as HTMLButtonElement).style.transform = "scale(1)";
        }}
        title="Open dev mode"
      >
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#7DD3FC" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z" />
        </svg>
        <span style={{ color: "#E0E0E0", fontWeight: 600, fontSize: 12, fontFamily: MONO, letterSpacing: "-0.02em" }}>
          DEV
        </span>
      </button>
      <ScreenFlowCanvas open={open} onClose={() => setOpen(false)} />
    </>
  );
}
Step 3: Create the Canvas Component
The canvas component is large (~900 lines) but follows a clear structure. Build it in this order:

3A. Constants and Theme
const MONO = "'JetBrains Mono', 'Fira Code', 'SF Mono', 'Cascadia Code', Menlo, Consolas, monospace";
const DK = {
  bg: "#0D0D0D",
  surface: "#161616",
  card: "#1A1A1A",
  border: "#2A2A2A",
  borderHover: "#3A3A3A",
  text: "#E0E0E0",
  textMuted: "#777",
  textDim: "#555",
  accent: "#6EAAFF",
  sectionBg: "#111111",
  sectionBorder: "#3A3A3A",
  connLine: "#555",
  connArrow: "#888",
  connLabelBg: "#1E1E1E",
  connLabelBorder: "#444",
  connLabelText: "#CCC",
  respLabel: "#999",
  respFooterBg: "#141414",
  edgeCaseBg: "#1E1A10",
  edgeCaseBorder: "#5A4A1A",
  // Add group-specific colors here:
  // badge[GroupName]: "#xxxxxx",
  // badgeBorder[GroupName]: "#xxxxxx",
};
3B. Data Types
interface ScreenNode {
  id: string;
  label: string;
  path: string;
  x: number;
  y: number;
  group: string;
  edgeCases?: string[];
}
interface Connection {
  from: string;
  to: string;
  label?: string;
}
interface Section {
  label: string;
  x: number;
  y: number;
  w: number;
  h: number;
}
interface ResponsiveRow {
  label: string;
  path: string;
  y: number;
}
interface CardRect {
  key: string;
  x: number;
  y: number;
  w: number;
  h: number;
}
3C. Layout Constants
const SCREEN_W = 1920;
const SCREEN_H = 1080;
const CARD_W = SCREEN_W;
const CARD_H = SCREEN_H;
const LABEL_H = 60;
const TOTAL_H = CARD_H + LABEL_H;
const COL_GAP = 120;
const ROW_GAP = 200;
// Define columns
const COL_1 = 100;
const COL_2 = COL_1 + CARD_W + COL_GAP;
const COL_3 = COL_2 + CARD_W + COL_GAP;
// Add more as needed: COL_4 = COL_3 + CARD_W + COL_GAP; ...
// Define rows
const ROW_1 = 80;
const ROW_2 = ROW_1 + TOTAL_H + ROW_GAP;
const ROW_3 = ROW_2 + TOTAL_H + ROW_GAP;
// Add more as needed
// Responsive grid
const breakpoints = [
  { label: "sm", width: 320 },
  { label: "md", width: 480 },
  { label: "lg", width: 768 },
  { label: "xl", width: 1024 },
  { label: "xxl", width: 1280 },
];
const RESP_GAP = 80;
const RESP_SECTION_X = 50;
const RESP_IFRAME_H = 900;
const RESP_ROW_GAP = 160;
3D. Screen Data (PROJECT-SPECIFIC)
This is the part that changes for every project. Populate these arrays from the inventory in Step 1:

const screens: ScreenNode[] = [
  // Row 1: Primary flow
  { id: "login", label: "Login", path: "/login", x: COL_1, y: ROW_1, group: "auth" },
  { id: "register", label: "Register", path: "/register", x: COL_2, y: ROW_1, group: "auth" },
  // Row 2: Main app
  { id: "dashboard", label: "Dashboard", path: "/dashboard", x: COL_1, y: ROW_2, group: "main" },
  // ... add all screens
];
const connections: Connection[] = [
  { from: "login", to: "dashboard", label: "Login success" },
  { from: "register", to: "dashboard", label: "Registration complete" },
  // ... add all connections
];
const groupColors: Record<string, { border: string; badge: string }> = {
  auth: { border: "#2E4A6E", badge: "#1C2A3D" },
  main: { border: DK.border, badge: DK.card },
  settings: { border: "#5A4020", badge: "#2A2016" },
  // ... add all groups
};
const responsiveRows: ResponsiveRow[] = [
  { label: "Login", path: "/login", y: 0 },
  { label: "Dashboard", path: "/dashboard", y: 1 },
  // ... add routes to test responsively
];
3E. Viewport-Aware Lazy Loading
This is the performance-critical system. Copy these exactly:

const GRACE_MS = 30000;
const BUFFER_PX = 800;
function getVisibleKeys(
  cards: CardRect[],
  pan: { x: number; y: number },
  zoom: number,
  viewW: number,
  viewH: number,
): Set<string> {
  const vpLeft = -pan.x / zoom - BUFFER_PX;
  const vpTop = -pan.y / zoom - BUFFER_PX;
  const vpRight = vpLeft + viewW / zoom + BUFFER_PX * 2;
  const vpBottom = vpTop + viewH / zoom + BUFFER_PX * 2;
  const visible = new Set<string>();
  for (const c of cards) {
    if (c.x + c.w > vpLeft && c.x < vpRight && c.y + c.h > vpTop && c.y < vpBottom) {
      visible.add(c.key);
    }
  }
  return visible;
}
function useViewportLazy(
  cards: CardRect[],
  pan: { x: number; y: number },
  zoom: number,
  containerRef: React.RefObject<HTMLDivElement | null>,
) {
  const [mounted, setMounted] = useState<Set<string>>(new Set());
  const [loaded, setLoaded] = useState<Set<string>>(new Set());
  const graceTimers = useRef<Map<string, ReturnType<typeof setTimeout>>>(new Map());
  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  useEffect(() => {
    if (debounceRef.current) clearTimeout(debounceRef.current);
    debounceRef.current = setTimeout(() => {
      const el = containerRef.current;
      const viewW = el ? el.clientWidth : window.innerWidth;
      const viewH = el ? el.clientHeight : window.innerHeight;
      const visible = getVisibleKeys(cards, pan, zoom, viewW, viewH);
      setMounted((prev) => {
        const next = new Set(prev);
        for (const key of visible) {
          next.add(key);
          const timer = graceTimers.current.get(key);
          if (timer) {
            clearTimeout(timer);
            graceTimers.current.delete(key);
          }
        }
        for (const key of prev) {
          if (!visible.has(key) && !graceTimers.current.has(key)) {
            graceTimers.current.set(key, setTimeout(() => {
              setMounted((p) => { const n = new Set(p); n.delete(key); return n; });
              setLoaded((p) => { const n = new Set(p); n.delete(key); return n; });
              graceTimers.current.delete(key);
            }, GRACE_MS));
          }
        }
        return next;
      });
    }, 150);
  }, [cards, pan, zoom, containerRef]);
  useEffect(() => {
    return () => {
      if (debounceRef.current) clearTimeout(debounceRef.current);
      graceTimers.current.forEach((t) => clearTimeout(t));
      graceTimers.current.clear();
    };
  }, []);
  const markLoaded = useCallback((key: string) => {
    setLoaded((prev) => new Set(prev).add(key));
  }, []);
  const isMounted = useCallback((key: string) => mounted.has(key), [mounted]);
  const isLoaded = useCallback((key: string) => loaded.has(key), [loaded]);
  return { isMounted, isLoaded, markLoaded, mountedCount: mounted.size, loadedCount: loaded.size };
}
3F. LazyIframe Component
function LazyIframe({ cardKey, path, width, height, isMounted, isLoaded, onLoaded }: {
  cardKey: string; path: string; width: number; height: number;
  isMounted: boolean; isLoaded: boolean; onLoaded: (key: string) => void;
}) {
  if (!isMounted) {
    return (
      <div style={{ width, height, position: "absolute", top: 0, left: 0, display: "flex", alignItems: "center", justifyContent: "center", backgroundColor: DK.surface }}>
        <span style={{ fontSize: Math.max(12, Math.min(16, width / 20)), color: DK.textDim, fontFamily: MONO }}>○</span>
      </div>
    );
  }
  return (
    <>
      <iframe
        src={path}
        title={cardKey}
        onLoad={() => onLoaded(cardKey)}
        style={{ width, height, border: "none", pointerEvents: "none", position: "absolute", top: 0, left: 0, opacity: isLoaded ? 1 : 0, transition: "opacity 0.3s ease" }}
      />
      {!isLoaded && (
        <div style={{ width, height, position: "absolute", top: 0, left: 0, display: "flex", alignItems: "center", justifyContent: "center", backgroundColor: DK.surface, zIndex: 1 }}>
          <div style={{ textAlign: "center" }}>
            <div style={{ width: Math.max(16, Math.min(24, width / 30)), height: Math.max(16, Math.min(24, width / 30)), border: `2px solid ${DK.border}`, borderTopColor: DK.accent, borderRadius: "50%", animation: "qspin 0.8s linear infinite", margin: "0 auto 8px" }} />
            <span style={{ fontSize: Math.max(10, Math.min(14, width / 25)), color: DK.textDim, fontFamily: MONO }}>loading...</span>
          </div>
        </div>
      )}
    </>
  );
}
3G. ALL_CARD_RECTS
Build the card rects array from screens and responsive rows. This is what drives the viewport visibility calculations:

const ALL_CARD_RECTS: CardRect[] = [
  ...screens.map((s) => ({
    key: `screen-${s.id}`,
    x: s.x,
    y: s.y,
    w: CARD_W,
    h: TOTAL_H,
  })),
  ...responsiveRows.flatMap((row) =>
    breakpoints.map((bp, colIdx) => ({
      key: `resp-${row.y}-${bp.label}`,
      x: getResponsiveColumnX(colIdx),
      y: RESP_SECTION_Y + 40 + row.y * respRowH,
      w: bp.width,
      h: RESP_IFRAME_H + 36,
    }))
  ),
];
3H. Main Component Structure
The ScreenFlowCanvas component follows this structure:

State: pan, zoom, dragging, didDrag + viewport lazy loading hook
Effects: Reset pan/zoom when opened; wheel/gesture event listeners
Handlers: handleMouseDown/Move/Up, handleNodeClick, handleZoomIn/Out
Render: Fixed overlay → header bar → scroll container → transform wrapper → sections → connections SVG → screen cards → responsive grid
Key rendering patterns:

Sections: Dashed-border rectangles with uppercase labels
Row/column labels: Absolute-positioned text above their content
Connection arrows: SVG <line> elements with <marker> arrowheads and label <rect> + <text> at midpoints
Screen cards: <LazyIframe> inside a bordered container, with label bar below and optional edge-case box
Responsive cells: Same pattern but with breakpoint-width iframes
Step 4: Wire Up the App
4A. Mount the FAB
Add <ScreenFlowFab /> to your app's root layout so it renders on every page:

// App.tsx
import ScreenFlowFab from "./components/screen-flow-fab";
function App() {
  return (
    <>
      <Router>
        <Route path="/" component={Home} />
        <Route path="/settings" component={Settings} />
        {/* ... */}
      </Router>
      <ScreenFlowFab />
    </>
  );
}
4B. Handle Query Params for Variants
If you have edge-case variants, add query param handling to the relevant pages:

// In account.tsx or similar
function AccountPage() {
  const params = new URLSearchParams(window.location.search);
  const edge = params.get("edge");
  const showModal = params.get("modal") === "edit";
  const hasAvatar = params.get("avatar") === "true";
  // Render different states based on params
  if (edge === "no-data") {
    return <AccountNoDataView />;
  }
  // ...
}
4C. Navigation Adapter
The handleNodeClick function needs to work with your router. Adjust for your routing library:

// For wouter:
import { useLocation } from "wouter";
const [, setLocation] = useLocation();
// ...
if (path.startsWith("/?")) {
  window.location.href = path;  // Query-param routes need full reload
} else {
  setLocation(path);
}
// For react-router:
import { useNavigate } from "react-router-dom";
const navigate = useNavigate();
// ...
navigate(path);
Common Patterns
Adding a Group Color
// In DK constant:
badgePayments: "#1A2A1A",
badgeBorderPayments: "#2A5A2A",
// In groupColors:
payments: { border: DK.badgeBorderPayments, badge: DK.badgePayments },
Color conventions:

Blue tints → flows, journeys, onboarding
Amber tints → settings, configuration, account
Green tints → payments, success states
Red tints → errors, destructive actions
Neutral → default/main screens
Section Bounding Boxes
Calculate section boundaries from screen positions:

const sections: Section[] = [
  {
    label: "Auth flow",
    x: 50,
    y: 10,
    w: COL_2 + CARD_W + 50,  // Spans columns 1-2
    h: TOTAL_H + 80,          // One row of cards + padding
  },
  {
    label: "Main app",
    x: 50,
    y: ROW_2 - 80,
    w: COL_3 + CARD_W + 50,  // Spans columns 1-3
    h: TOTAL_H + 200,
  },
];
Default Zoom by App Size
Screen Count	Recommended Default Zoom
1–5	0.20
6–15	0.15
16–30	0.10
30+	0.08
Performance Tuning
Parameter	Default	When to Adjust
BUFFER_PX	800	Increase for faster connections; decrease on low-memory devices
GRACE_MS	30000	Decrease to free memory faster; increase if user pans back and forth frequently
Debounce	150ms	Decrease for more responsive loading; increase if pan feels laggy
Min zoom	0.05	Lower for very large apps; 0.03 is practical minimum
Max zoom	2.0	Increase if users need pixel-level inspection
Gotchas
Canvas must use display: none/block, NOT conditional rendering. If you conditionally render ({open && <Canvas />}), all iframe state is lost when closing.

Iframes are pointerEvents: "none". This prevents the iframes from capturing mouse events meant for canvas panning. Clicking still works because the click handler is on the card wrapper, not the iframe.

Query-param routes may need window.location.href instead of router navigation. Some routers don't handle ?param=value changes as navigation events.

The @keyframes qspin style tag must be inside the component. It cannot be in an external CSS file because the canvas must be fully self-contained.

Each screen card renders the iframe at full 1920×1080 size (not scaled). The parent container uses overflow: hidden to clip it. This ensures pixel-perfect rendering — the browser renders at true resolution, and the canvas zoom handles the visual scaling.

Edge case variants need app-level support. The canvas just loads the URL — the app must parse query params and render the appropriate state.

On Replit specifically: The data-replit-metadata prop warning on React.Fragment and occasional "Invalid hook call" warnings are platform-level injections, not from the canvas code. They can be safely ignored.