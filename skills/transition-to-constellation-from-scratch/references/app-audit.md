# App Analysis Guide

This guide describes how to run a comprehensive analysis of an existing React application. The analysis captures *what the app does* — not how it's currently built. Its output feeds directly into the PRD (see [PRD Template](prd-template.md)).

**Goal:** Produce a complete feature inventory so that nothing is missed when writing the PRD. Every screen, interaction, data model, API endpoint, and implicit behavior must be documented.

**Relationship to PRD:** The analysis is a working document. It does not need to be polished. Its only job is to ensure the PRD captures every feature. Once the PRD is written, the analysis can be discarded.

## Analysis Methodology

### Phase 1: Map Every Screen

Walk through every route in the application and document what the user sees and can do on each screen.

**For each screen, capture:**

| Field | Description |
|-------|-------------|
| Route | URL path (e.g., `/`, `/skills/:id`, `/reports`) |
| Title | What the page is called |
| Purpose | What the user accomplishes here (one sentence) |
| Layout | Overall structure (sidebar + content, single column, grid, etc.) |
| Key content | What data is displayed |
| User actions | What the user can do (click, filter, search, submit, download) |
| Navigation | How the user gets here and where they can go next |

**Template:**

```markdown
### Screen: [Page Name]
- **Route:** `/path`
- **Purpose:** [One sentence: what does the user accomplish here?]
- **Layout:** [Single column / Two column / Grid / etc.]
- **Key content:**
  - [Data item 1]
  - [Data item 2]
- **User actions:**
  - [Action 1: e.g., "Filter skills by category tag"]
  - [Action 2: e.g., "Click card to open modal preview"]
- **Navigation:**
  - Reached from: [How the user gets here]
  - Links to: [Where the user can go from here]
```

### Phase 2: Inventory Interactions

Beyond page-level content, document every distinct interaction pattern:

| Interaction Type | What to Capture |
|-----------------|-----------------|
| **Modals/Dialogs** | Trigger, content, actions (primary + secondary), size, close behavior |
| **Forms** | Fields, validation rules, submit behavior, error handling |
| **Search** | Scope (global vs page), shortcut keys, result format, filtering logic |
| **Filters** | Filter dimensions, UI pattern (chips, dropdown, tabs), reset behavior |
| **Menus** | Trigger element, menu items, submenus |
| **Downloads** | What gets downloaded, format, tracking |
| **Clipboard** | What gets copied, feedback to user |
| **Authentication** | Sign-in flow, session management, protected actions |
| **Theme switching** | Dark mode toggle/menu, mode options (light/dark/system), persistence |

**Template:**

```markdown
### Interaction: [Name]
- **Type:** Modal / Form / Search / Filter / Menu / Download / Auth
- **Trigger:** [What causes this interaction to appear]
- **Behavior:**
  - [Step 1]
  - [Step 2]
- **Data required:** [What data this interaction needs]
- **Success outcome:** [What happens when it completes]
- **Error handling:** [What happens when it fails]
```

### Phase 3: Map Data Models

Document every data type the app works with:

```markdown
### Data Model: [Name]
- **Source:** API endpoint / local state / URL params
- **Fields:**
  | Field | Type | Purpose |
  |-------|------|---------|
  | id | string | Unique identifier |
  | name | string | Display name |
  | ... | ... | ... |
- **Used by:** [Which screens and interactions use this data]
- **CRUD operations:** [Create / Read / Update / Delete — which are supported]
```

### Phase 4: Map API Surface

List every API endpoint the frontend calls:

```markdown
| Method | Endpoint | Purpose | Auth Required |
|--------|----------|---------|---------------|
| GET | /api/skills | List all skills | No |
| GET | /api/skills/:id | Get skill detail | No |
| POST | /api/community-skills | Submit new skill | Yes |
| ... | ... | ... | ... |
```

### Phase 5: Document Cross-Cutting Concerns

These features affect multiple screens and must be rebuilt as shared infrastructure:

| Concern | What to Capture |
|---------|-----------------|
| **Authentication** | Provider, sign-in flow, session persistence, protected routes/actions |
| **Dark mode / theming** | See Dark Mode Audit below for full checklist |
| **Routing** | Router library, route structure, navigation patterns |
| **State management** | Server state (React Query), client state (useState/context), URL state |
| **Responsive design** | Breakpoints, mobile-specific behavior, layout changes |
| **Error handling** | Global error boundaries, per-request error handling, user feedback |
| **Loading states** | Spinners, skeletons, progressive loading |
| **Accessibility** | Keyboard navigation, screen reader support, focus management |

### Phase 5b: Dark Mode Audit

If the app supports dark mode (or should), document the following:

**Switching mechanism:**

| Field | What to Capture |
|-------|-----------------|
| **Toggle location** | Where does the user switch themes? (header menu, settings page, system only) |
| **Mode options** | Which modes are offered? (light / dark / system / auto) |
| **Default mode** | What mode loads on first visit? |
| **Persistence** | How is the choice stored? (localStorage, cookie, database, OS preference) |
| **Sync** | Does the preference sync across devices or sessions? |

**Implementation details:**

| Field | What to Capture |
|-------|-----------------|
| **Theme mechanism** | How is dark mode applied? (CSS class on root, data attribute like `data-panda-mode`, media query, context/provider) |
| **Token usage** | Are colors defined via semantic tokens or hardcoded hex values? |
| **Hardcoded colors** | List any inline styles or hardcoded colors that bypass the theme system |
| **Custom CSS variables** | Are there app-specific CSS variables that need dark variants? |

**Asset audit:**

| Asset Type | Light Variant | Dark Variant | Notes |
|-----------|--------------|-------------|-------|
| Illustrations | `/Lightmode/name.svg` | `/Darkmode/name.svg` | Both variants exist? |
| Logo | Standard | Inverted/white? | Does the logo adapt? |
| Images | N/A | N/A | Do any images need dark-mode treatment? |
| Shadows | Standard | Removed/lighter bg? | Constellation rule: NO shadows in dark mode |

**Template:**

```markdown
### Dark Mode Assessment
- **Currently supported:** Yes / No / Partial
- **Switching UI:** [Location and interaction pattern]
- **Modes offered:** Light / Dark / System
- **Persistence:** [localStorage key, cookie, etc.]
- **Theme mechanism:** [data attribute, CSS class, context, etc.]
- **Semantic tokens used:** Yes / Partially / No (hardcoded colors)
- **Illustration variants:** [Count] of [total] have dark mode versions
- **Known issues:**
  - [e.g., "Card borders disappear in dark mode"]
  - [e.g., "Custom code block uses hardcoded #f5f5f5 background"]
- **Constellation compliance:**
  - [ ] Uses `injectTheme()` or `ConstellationProvider`
  - [ ] All colors use semantic tokens (no hardcoded hex)
  - [ ] No shadows on elements in dark mode
  - [ ] Illustrations have light/dark variants
  - [ ] Logo adapts to dark background
```

### Phase 6: Capture Implicit Features

These are behaviors that users expect but that may not be obvious from reading code:

- **Page titles** — Does each route set `document.title`?
- **Scroll behavior** — Does the app scroll to top on route change? Smooth scroll to sections?
- **Keyboard shortcuts** — Are there global shortcuts (e.g., Cmd+K for search)?
- **URL deep linking** — Can every significant view be reached by URL?
- **Browser back/forward** — Does navigation work correctly with browser history?
- **Clipboard feedback** — Does copying show "Copied" confirmation?
- **Relative timestamps** — Are dates shown as "2h ago" or "January 5, 2025"?

## Analysis Output Format

The analysis document should follow this structure. It does not need to be polished — it is a working document that feeds into the PRD.

```markdown
# App Analysis — [App Name]

## Overview
- **App purpose:** [One paragraph describing what the app does]
- **Target audience:** [Who uses this app]
- **Screen count:** [Number of distinct screens]
- **API endpoint count:** [Number of API endpoints]
- **Dark mode:** [Yes / No / Partial]

## Screens
[Phase 1 output — one section per screen]

## Interactions
[Phase 2 output — one section per interaction]

## Data Models
[Phase 3 output — one section per data type]

## API Surface
[Phase 4 output — endpoint table]

## Cross-Cutting Concerns
[Phase 5 output — one section per concern]

## Dark Mode Assessment
[Phase 5b output — switching mechanism, implementation, assets]

## Implicit Features
[Phase 6 output — bullet list]
```

**Next step:** Use this analysis to write the PRD. See [PRD Template](prd-template.md).

## Example: Skills & MCP Library App

Below is a condensed example of an audit for a skills and MCP library application.

### Screens

| Route | Screen | Purpose |
|-------|--------|---------|
| `/` | Home | Browse skills and MCPs with filtering, open modal previews, submit contributions |
| `/skills/:id` | Skill detail | View full skill with instructions, files, and references in tabs |
| `/mcps/:id` | MCP detail | View full MCP with setup guide, features, and configuration |
| `/reports` | Reports dashboard | View usage analytics: stats, top downloads, recent activity, category breakdown |

### Interactions

| Interaction | Type | Trigger |
|-------------|------|---------|
| Skill preview modal | Modal | Click skill card on home page |
| MCP preview modal | Modal | Click MCP card on home page |
| Submit skill form | Modal + Form | Click "Submit skill" (requires auth) |
| Submit MCP form | Modal + Form | Click "Submit MCP" (requires auth) |
| Global search | Combobox | Click search or press Cmd+K |
| Category filter (skills) | Filter chips | Click tag chip on home page |
| Category filter (MCPs) | Filter chips | Click tag chip on home page |
| Theme switcher | Menu | Click settings gear icon |
| User menu | Menu | Click avatar/user icon |
| Download skill | Download | Click "Download" button on skill detail |
| Copy path | Clipboard | Click "Copy path" button |
| Copy code block | Clipboard | Click "Copy" on code block |

### Data Models

| Model | Key Fields | Source |
|-------|-----------|--------|
| SkillSummary | id, name, description, category, tags, fileCount, hasReferences, authorDisplayName | GET /api/skills |
| SkillDetail | + files[], mainContent, referenceFiles[] | GET /api/skills/:id |
| MCPSummary | id, name, description, category, features[], status, maintainer, repoUrl | GET /api/mcps |
| MCPDetail | + setupInstructions, configExample | GET /api/mcps/:id |
| ReportData | overview{}, topDownloads[], recentDownloads[], skillsByCategory{}, mcpsByCategory{}, contributors[] | GET /api/reports |
| User | uid, email, displayName, photoURL | GET /api/auth/me |

### Cross-Cutting Concerns

| Concern | Implementation |
|---------|---------------|
| Auth | Google OAuth 2.0 via GSI, server-side session, protected community submissions |
| Theme | Light/dark/system mode via PandaCSS data-panda-mode attribute, localStorage persistence |
| Routing | Wouter with 4 routes + 404 |
| State | React useState for UI state, useEffect for data fetching, no React Query mutations |
| Responsive | Mobile search collapses to icon, modals go fullScreen on mobile, grid columns adapt |
| Illustrations | Light/dark mode SVG variants from assets directory |

### Implicit Features

- Page titles set per route (document.title)
- Cmd+K keyboard shortcut for global search
- Smooth scroll to skills/MCPs sections from hero CTAs
- Deep-linkable skill and MCP detail pages
- Mobile: search icon expands to full-width overlay on tap
- "Copied" confirmation on clipboard actions
- Relative timestamps on recent activity ("2h ago")
- Download tracking via POST /api/downloads/:type/:id
- Author attribution with Google profile photo on community submissions
- GitLab CI sync tab in skill submission modal
