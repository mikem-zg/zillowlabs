# Feature Grouping Guide

This guide describes how to organize features from the app analysis into the PRD. Features are grouped by **domain** (what they relate to) and sequenced by **dependency** (what must be built first).

**Relationship to PRD:** This guide helps you structure the "Features" and "Feature Build Sequence" sections of the PRD (see [PRD Template](prd-template.md)).

---

## Grouping by Domain

Group features by what they relate to, not by screen or component. A domain group contains all features related to one area of the app.

| Domain Group | What Goes Here | Examples |
|-------------|----------------|----------|
| **App infrastructure** | Shell, routing, theme, auth — things every screen depends on | Header, navigation, dark mode switching, sign-in/sign-out |
| **Content browsing** | Viewing and navigating through items | Card grids, list views, pagination, filtering, sorting |
| **Content detail** | Viewing full details of a single item | Detail pages, tabbed content, code blocks, markdown rendering |
| **Search & discovery** | Finding items across the app | Global search, autocomplete, keyboard shortcuts |
| **User contributions** | Creating or submitting content | Forms, modals, validation, auth-gated actions |
| **Analytics & reporting** | Viewing usage data and stats | Dashboards, charts, leaderboards, export |
| **UX polish** | Behaviors that make the app feel complete | Loading states, empty states, clipboard feedback, scroll behavior, page titles |

### How to Assign Groups

For each feature from the analysis, ask: **"What domain does this belong to?"**

If a feature spans multiple domains (e.g., "search that opens a modal preview"), split it into two features in the PRD:
1. "Global search that navigates to items" (Search & discovery)
2. "Modal preview from search results" (Content detail)

---

## Sequencing by Dependency

After grouping, determine the build order. The sequence is driven by dependencies — what must exist before something else can be built.

### Build Phases

| Phase | What to Build | Why This Order |
|-------|---------------|----------------|
| **Phase 1: Foundation** | App shell, routing, theme (including dark mode switching), auth | Everything depends on this |
| **Phase 2: Core** | Content browsing + content detail | The primary reason users open the app |
| **Phase 3: Supporting** | Search & discovery + user contributions | Enhances core workflows |
| **Phase 4: Polish** | Analytics, UX polish, responsive refinements | Makes the app feel complete |

### Dependency Rules

```
Foundation → MUST be built first (everything depends on it)
Core → MUST come after foundation (needs routing, theme, shell)
Supporting → MUST come after core (search needs content to search; forms need data models)
Polish → Can be built anytime after core, but save for last to avoid yak-shaving
```

### Dark Mode in the Sequence

Dark mode switching belongs in **Phase 1 (Foundation)** because:
- It affects every component on every screen
- Building it later means retrofitting token compliance across all existing features
- Every subsequent task must be verified in both light and dark modes

| Aspect | Phase 1 Task |
|--------|-------------|
| Theme context | Create React context with light/dark/system state + localStorage persistence |
| DOM application | Set `data-panda-mode` attribute on `<html>` before first paint |
| Toggle UI | Add theme menu to app header |
| Verification | Confirm Constellation tokens resolve correctly in both modes |

---

## Ralph Wiggum Task Sizing

Within each phase, break features into Ralph Wiggum-sized tasks. Each task is one independently buildable and verifiable unit.

### Sizing Rules

| Too Big | Just Right |
|---------|------------|
| "Build the skills page" | "Create SkillCard component with name and description" |
| "Add search and filtering" | "Add search input that filters skill cards by name" |
| "Set up dark mode" | "Create theme context with light/dark/system state" |
| "Make it responsive" | "Update skill grid to show 1 column on mobile" |
| "Build the modal" | "Add modal that opens when clicking a skill card" |

### How Many Tasks Per Feature?

Most features break into **3-7 tasks**. If you have fewer than 3, the feature might be too small to be its own PRD feature (merge it into another). If you have more than 7, the feature might be too big (split it into two features).

---

## Example: Skills & MCP Library

### Phase 1: Foundation

| Feature | Tasks |
|---------|-------|
| App shell | 1. Page.Root + Page.Header with logo and navigation; 2. Sticky header with bg.screen.neutral; 3. Page.Content with max-width container |
| Routing | 1. Set up Wouter with routes for /, /skills/:id, /mcps/:id, /reports; 2. Add 404 fallback route |
| Dark mode switching | 1. Create theme context with light/dark/system state + localStorage; 2. Apply data-panda-mode before first paint; 3. Add theme toggle menu to header; 4. Verify tokens resolve in both modes |
| Authentication | 1. Create auth context with Google OAuth; 2. Add sign-in button to header; 3. Add user menu with avatar and sign-out; 4. Protect submission actions behind auth check |
| API client | 1. Create typed fetch wrapper for all endpoints |

### Phase 2: Core

| Feature | Tasks |
|---------|-------|
| Skills grid | 1. Create SkillCard component; 2. Add responsive grid layout; 3. Wire to GET /api/skills; 4. Add category filter chips |
| MCP grid | 1. Create MCPCard component; 2. Add responsive grid layout; 3. Wire to GET /api/mcps; 4. Add category filter chips |
| Skill detail page | 1. Create page layout with back button and title; 2. Add tabs for instructions/files/references; 3. Render markdown content; 4. Render code blocks with copy; 5. Add download button |
| MCP detail page | 1. Create page layout with back button and title; 2. Add tabs for setup/features/config; 3. Render markdown content; 4. Add copy config button |

### Phase 3: Supporting

| Feature | Tasks |
|---------|-------|
| Global search | 1. Add Combobox searching skills + MCPs; 2. Add Cmd+K keyboard shortcut; 3. Navigate to detail page on selection; 4. Mobile: icon-only trigger with overlay |
| Skill preview modal | 1. Open modal on card click from home; 2. Fetch and display skill details; 3. Add "View full page" navigation |
| MCP preview modal | 1. Open modal on card click from home; 2. Fetch and display MCP details; 3. Add "View full page" navigation |
| Submit skill form | 1. Authenticated modal with form fields; 2. Tag selection; 3. Submit to API with validation; 4. GitLab CI sync tab |
| Submit MCP form | 1. Authenticated modal with form fields; 2. Dynamic feature list; 3. Submit to API with validation |

### Phase 4: Polish

| Feature | Tasks |
|---------|-------|
| Reports dashboard | 1. Stats cards row; 2. Top downloads leaderboard; 3. Recent activity timeline with relative timestamps; 4. Category breakdown |
| Hero section | 1. Illustration with headline and description; 2. CTA buttons; 3. Smooth scroll to content sections |
| Empty states | 1. Add illustration + copy for no search results; 2. Add illustration + copy for no downloads; 3. Add illustration + copy for no activity |
| Loading states | 1. Add centered spinner for all async data fetching |
| Page titles | 1. Set document.title per route |
| Download tracking | 1. POST to /api/downloads on download/copy actions |
