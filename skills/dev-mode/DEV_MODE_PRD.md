Dev Mode Canvas — Product Requirements Document
Version: 2.0
Date: March 31, 2026
Status: Shipped

1. Overview
Dev Mode Canvas is a zero-dependency visual debugging tool that renders every screen, state, variant, and responsive breakpoint of a web application simultaneously on a single pannable, zoomable dark-themed canvas. It is designed to be dropped into any React project regardless of size — from a 3-screen onboarding flow to a 200-screen enterprise dashboard.

The system is two files (~900 lines total), uses only React hooks and inline styles, and has no design system or CSS framework dependencies.

2. Problem Statement
During development of multi-screen applications, developers and designers must:

Navigate to each route manually to verify changes
Resize the browser for each breakpoint to check responsiveness
Remember edge cases and test them individually
Lose context of how screens relate to each other in user flows
Re-test every variant after each change (loading states, empty states, error states, modals)
Dev Mode solves all of these by rendering the entire application at once on a canvas.

3. Core Concepts
3.1 Screen Cards
A screen card is a full-size iframe (default 1920×1080) embedded on the canvas, displaying a single route or state of the application. Each card has:

A live iframe rendering the actual route
A label bar showing the screen name and route path
Optional edge-case annotations
A color-coded border indicating which group it belongs to
Screen cards are positioned manually on the canvas using x, y coordinates. This is intentional — automatic layout cannot capture the semantic relationships between screens (which screens are "step 1 → step 2", which are variants of the same page, etc.).

3.2 Groups
Screens belong to groups which determine their color-coding on the canvas. Groups are arbitrary strings (e.g., "onboarding", "settings", "dashboard", "auth"). Each group maps to a border color and badge background color.

3.3 Connections
Connections are directional arrows between screen cards showing user flow. Each connection has a from screen ID, a to screen ID, and an optional label (e.g., "Next", "Submit", "Cancel").

3.4 Sections
Sections are dashed-border rectangles that visually group related content on the canvas. Each section has a label and a bounding box. The canvas supports three types of content sections:

Section Type	Purpose
Screen flow	Primary user navigation flows
Supporting screens	Edge cases, variants, modal states
Breakpoints	Responsive grid showing all routes at all breakpoints
3.5 Responsive Grid
A matrix showing selected routes rendered at actual breakpoint widths. Columns are breakpoints (e.g., 320px, 480px, 768px, 1024px, 1280px). Rows are routes/states. Each cell is a live iframe at the actual pixel width.

3.6 Edge Cases
Any screen card can have an edgeCases array — a list of strings describing what makes that screen variant notable. These render as amber annotation boxes below the card.

4. Architecture
4.1 File Structure
components/
  screen-flow-fab.tsx      — FAB button (always mounted) + lazy-mounts canvas
  screen-flow-canvas.tsx   — Full canvas with all logic, data, and rendering
The canvas component is mounted once on app load and toggled via CSS display: none/block. Destroying and recreating it would lose all loaded iframes.

4.2 Zero Design System Dependencies
The canvas intentionally uses zero design system components. Everything is native HTML with inline styles.

Reason	Explanation
Isolation	Canvas must not be affected by the app's theme or design system
Performance	No CSS-in-JS overhead for the canvas shell
Portability	Can be dropped into any React project regardless of styling solution
Dark theme control	Full control over the dark palette without fighting a light-mode design system
4.3 Dark Theme Palette
All colors are centralized in a single DK constant object:

const DK = {
  bg: "#0D0D0D",           // Canvas background
  surface: "#161616",       // Header bar, iframe placeholder
  card: "#1A1A1A",          // Card backgrounds
  border: "#2A2A2A",        // Default borders
  borderHover: "#3A3A3A",   // Hover borders
  text: "#E0E0E0",          // Primary text
  textMuted: "#777",        // Secondary text
  textDim: "#555",          // Tertiary text
  accent: "#6EAAFF",        // Brand accent (blue)
  sectionBg: "#111111",     // Section fill
  sectionBorder: "#3A3A3A", // Section dashed border
  connLine: "#555",         // Connection line
  connArrow: "#888",        // Arrow marker fill
  connLabelBg: "#1E1E1E",  // Connection label background
  connLabelBorder: "#444",  // Connection label border
  connLabelText: "#CCC",   // Connection label text
  respLabel: "#999",        // Responsive section labels
  respFooterBg: "#141414", // Footer bar under responsive iframes
  // Group-specific colors (added per project)
  // edgeCaseBg, edgeCaseBorder, badge*, badgeBorder*, etc.
};
4.4 Viewport-Aware Lazy Loading
Loading all iframes simultaneously would crash the browser. The system uses viewport-aware lazy loading:

getVisibleKeys(cards, pan, zoom, viewW, viewH) — Pure function. Computes which card rectangles intersect the current viewport (with an 800px buffer zone). Returns a Set<string> of visible card keys.

useViewportLazy(cards, pan, zoom, containerRef) — Hook managing three pieces of state:

mounted: Set<string> — which iframes are currently in the DOM
loaded: Set<string> — which mounted iframes have fired their onLoad event
Grace timers — when a card leaves the viewport, it stays mounted for 30 seconds before being unmounted (prevents re-loading during back-and-forth panning)
LazyIframe component — Renders one of three states:

Not mounted: Hollow circle placeholder (dark surface background)
Mounted, not loaded: Spinning loader with "loading..." text
Loaded: Full iframe with 0.3s opacity fade-in transition
Performance characteristics:

Metric	Value
Iframes at default zoom (0.15)	2–4 mounted
Max concurrent iframes during heavy panning	~6–8
Buffer zone	800px around viewport
Debounce on visibility recalculation	150ms
Grace period before unmounting	30 seconds
Fade-in transition	0.3s ease
4.5 Pan & Zoom
Pan:

Mouse drag on canvas background
Scroll wheel (trackpad two-finger scroll)
didDrag flag prevents click-to-navigate after dragging
Zoom:

Ctrl/Cmd + scroll wheel (pinch on trackpad)
+/− buttons in header bar
Range: 0.05x to 2.0x, default 0.15x
Focal-point zoom toward cursor position
Transform: Single CSS transform on the canvas container:

transform: translate(${pan.x}px, ${pan.y}px) scale(${zoom})
transform-origin: 0 0
4.6 Click-to-Navigate
Screen cards and responsive cells are clickable. On click:

Check didDrag — if user was panning, ignore
Call onClose() to hide the canvas
Navigate to the screen's route via router (setLocation) or window.location.href for query-param routes
5. Data Model
5.1 Screen Nodes
interface ScreenNode {
  id: string;           // Unique identifier (e.g., "step-one", "dashboard")
  label: string;        // Display name shown on the card
  path: string;         // Route path (e.g., "/settings", "/?modal=edit")
  x: number;            // Canvas X position (pixels)
  y: number;            // Canvas Y position (pixels)
  group: string;        // Color group (e.g., "auth", "onboarding", "settings")
  edgeCases?: string[]; // Optional annotations for variant cards
}
5.2 Connections
interface Connection {
  from: string;   // Source screen ID
  to: string;     // Target screen ID
  label?: string; // Arrow label (e.g., "Next", "Submit")
}
5.3 Sections
interface Section {
  label: string;
  x: number;
  y: number;
  w: number;
  h: number;
}
5.4 Responsive Rows
interface ResponsiveRow {
  label: string;  // Row label (e.g., "Login page")
  path: string;   // Route to render at each breakpoint
  y: number;      // Row index (0-based)
}
5.5 Card Rects (for viewport calculations)
interface CardRect {
  key: string;   // Unique key (e.g., "screen-step-one", "resp-0-sm")
  x: number;     // Canvas X position
  y: number;     // Canvas Y position
  w: number;     // Card width
  h: number;     // Card height
}
6. Layout System
6.1 Constants
All layout dimensions are defined as constants at the top of the file:

const SCREEN_W = 1920;      // Iframe viewport width
const SCREEN_H = 1080;      // Iframe viewport height
const CARD_W = SCREEN_W;    // Card width = iframe width (1:1 at this zoom)
const CARD_H = SCREEN_H;    // Card height = iframe height
const LABEL_H = 60;         // Label bar height below each card
const TOTAL_H = CARD_H + LABEL_H;  // Total card + label height
const COL_GAP = 120;        // Horizontal gap between columns
const ROW_GAP = 200;        // Vertical gap between rows
6.2 Grid Positioning
Screen cards use a manual grid system with named column and row constants:

const COL_1 = 100;
const COL_2 = COL_1 + CARD_W + COL_GAP;
const COL_3 = COL_2 + CARD_W + COL_GAP;
// ... add more columns as needed
const ROW_1 = 80;
const ROW_2 = ROW_1 + TOTAL_H + ROW_GAP;
const ROW_3 = ROW_2 + TOTAL_H + ROW_GAP;
// ... add more rows as needed
6.3 Responsive Grid Layout
The responsive grid auto-calculates column positions from breakpoint widths:

const breakpoints = [
  { label: "sm", width: 320 },
  { label: "md", width: 480 },
  { label: "lg", width: 768 },
  { label: "xl", width: 1024 },
  { label: "xxl", width: 1280 },
];
function getResponsiveColumnX(colIndex: number): number {
  let x = RESP_SECTION_X + 30;
  for (let i = 0; i < colIndex; i++) {
    x += breakpoints[i].width + RESP_GAP;
  }
  return x;
}
7. Scaling Guide
Small App (3–5 screens)
1 row of screen cards
0–2 supporting variants
1 section boundary ("Screen flow")
Responsive grid optional (3–5 rows)
Default zoom 0.15 shows everything at once
Medium App (10–20 screens)
2–3 rows of screen cards, organized by user flow
3–5 supporting variants (error states, empty states, modals)
2–3 section boundaries
Responsive grid with 5–10 rows
Default zoom 0.10–0.15
Large App (50+ screens)
Multiple flow sections (auth, dashboard, settings, etc.)
Each section has its own row group
10+ supporting variants
Responsive grid with 15+ rows
Default zoom 0.05–0.10
Viewport lazy loading is critical at this scale — only 6–8 iframes are ever active
Key Scaling Properties
Property	Behavior
Performance	O(n) visibility check per pan/zoom, but only ~6–8 iframes are ever mounted
Memory	Bounded by visible viewport, not total screen count
Layout	Manual positioning; add rows/columns as needed
Section boundaries	Auto-calculate from content positions
Canvas size	Auto-calculated from max screen positions
8. Customization
8.1 Adding a New Screen
Add entry to screens array with unique id, label, path, x, y, and group
Add connection entries if this screen links to/from others
Adjust section bounding boxes if needed
Add to ALL_CARD_RECTS array (automatic via the spread pattern)
8.2 Adding a New Screen Group
Add color entries in DK (e.g., badgeNewGroup, badgeBorderNewGroup)
Add the group to groupColors map
Update the ScreenNode.group type union
8.3 Adding Edge Case Variants
Add a new screen entry with the same path but different query params (e.g., "/account?edge=no-data")
Add an edgeCases array to the screen entry
Position it in a "Supporting screens" section
The app must handle the query params and render the appropriate variant
8.4 Adding a New Responsive Row
Add entry to responsiveRows with label, path, and next y index
Section height auto-calculates from responsiveRows.length
8.5 Adding a New Breakpoint Column
Add entry to breakpoints array with label and width
Column positions auto-calculate via getResponsiveColumnX()
8.6 Changing the Color Theme
Edit the DK constant. All colors are centralized there.

9. Header Bar
The header bar displays:

Element	Description
Title	"DEV MODE" in accent blue, bold monospace
Status	"X mounted · Y loaded / Z total" — shows iframe lifecycle
Zoom controls	− / percentage / + buttons
Close button	✕ button to hide the canvas
10. Browser Compatibility
Chromium-based browsers (Chrome, Edge, Brave)
Standard CSS transforms, no vendor prefixes
CSS @keyframes for spinner animation
No Web APIs beyond standard DOM events
11. Future Enhancements
Enhancement	Description
Search/filter	Type to find a screen by name or path
Minimap	Small overview showing current viewport position on the canvas
Diff mode	Highlight screens that changed since last deploy
Annotation mode	Add sticky notes to screens
Export	Screenshot the entire canvas as a single image
Keyboard shortcuts	Ctrl+D to toggle, arrow keys to pan, +/- to zoom
Group toggle	Show/hide entire groups (onboarding, settings, etc.)
Fit-to-view	Button to zoom/pan so all screens fit in the viewport
Dark/light toggle	Switch the canvas between dark and light themes