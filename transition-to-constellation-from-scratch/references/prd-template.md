# PRD Template

Use this template to write the product requirements document after completing the app analysis. The PRD becomes the single source of truth for the rebuild — every feature must satisfy what's written here.

---

## 1. Product Overview

```markdown
### Product name
[App name]

### Problem statement
[One paragraph: What problem does this app solve? Why does it exist?]

### Product summary
[One paragraph: What is this app and what does it do at a high level?]

### Target audience
[Consumer / Professional / Internal — and why]

### Core value proposition
[One sentence: The single most important thing this app delivers to users]
```

---

## 2. User Personas

Define each distinct user type. Most apps have 2-3 personas.

```markdown
### Persona: [Name]
- **Role:** [What they do — e.g., "Real estate agent looking for productivity tools"]
- **Goal:** [What they want to accomplish with this app]
- **Key actions:** [The 3-5 things they do most in the app]
- **Frustrations:** [What would make them leave — slow load, missing features, confusing UI]
```

---

## 3. Features

This is the core of the PRD. Every feature the app provides is documented here, grouped by domain.

### Feature Template

For each feature, capture:

```markdown
### Feature: [Feature Name]

**Group:** [Domain group — e.g., "Content browsing", "Search & discovery", "User submissions"]

**Description:**
[What this feature does from the user's perspective. No implementation details.]

**User story:**
As a [persona], I want to [action] so that [outcome].

**Acceptance criteria:**
- [ ] [Specific, testable statement — e.g., "Skill cards display name, description, category tag, and file count"]
- [ ] [Another criterion — e.g., "Clicking a card opens a modal preview with full details"]
- [ ] [Another criterion — e.g., "Cards are arranged in a responsive grid: 1 column mobile, 2 tablet, 3 desktop"]
- [ ] [Dark mode criterion if applicable — e.g., "Card renders correctly in dark mode with no contrast issues"]

**Tasks:**
Each task is one Ralph Wiggum unit — small enough to build and verify in a single pass.

1. [Task 1 — e.g., "Create SkillCard component displaying name, description, and category tag"]
2. [Task 2 — e.g., "Add skill grid layout with responsive columns"]
3. [Task 3 — e.g., "Wire skill cards to API data via fetch"]
4. [Task 4 — e.g., "Add category filter chips above the grid"]

**Data requirements:**
- Source: [API endpoint, local state, URL params]
- Fields: [List the data fields this feature needs]
- Mutations: [Any data the feature creates or modifies]
```

### Writing Good Acceptance Criteria

Acceptance criteria must be **specific and testable**. Each one answers: "How do I know this works?"

| Bad (vague) | Good (testable) |
|-------------|-----------------|
| "Search works" | "Typing in the search box filters results by name and description in real time" |
| "Cards look nice" | "Cards display name, description, category tag, and file count in a responsive grid" |
| "Dark mode supported" | "All components render with semantic token colors in dark mode; no hardcoded hex values" |
| "User can submit" | "Authenticated user can fill out name, description, content, and tags; submit button is disabled until required fields are filled; success shows confirmation and refreshes the list" |
| "Page is responsive" | "Grid shows 1 column at 375px, 2 columns at 768px, 3 columns at 1280px" |

### Writing Good Tasks (Ralph Wiggum Size)

Each task should be:
- **One thing** — not "build the card and add filtering and wire up the API"
- **Independently verifiable** — you can run the app and confirm it works after building just this task
- **Ordered by dependency** — task 2 can depend on task 1, but not the reverse

| Bad (too big) | Good (Ralph Wiggum size) |
|---------------|--------------------------|
| "Build the skills page" | "Create SkillCard component with name and description" |
| "Add search and filtering" | "Add search input that filters the skill list by name" |
| "Set up auth" | "Add Google sign-in button to the header" |
| "Make it responsive" | "Update skill grid to show 1 column on mobile" |

---

## 4. Cross-Cutting Requirements

These apply to every feature and every screen.

### 4a. Dark Mode Switching

```markdown
**Requirement:** The app must support light, dark, and system theme modes.

**Acceptance criteria:**
- [ ] Theme toggle is accessible from every screen (header menu)
- [ ] Light, dark, and system modes all function correctly
- [ ] System mode follows OS preference and updates in real time
- [ ] Selected mode persists across page reloads (localStorage)
- [ ] No flash of wrong theme on initial page load
- [ ] All colors use semantic tokens — no hardcoded hex values
- [ ] Illustrations have light/dark variants that switch with the theme
- [ ] No shadows on elements in dark mode
- [ ] Text is legible in both modes (check subtle/muted variants)

**Tasks:**
1. Create theme context with light/dark/system mode state and persistence
2. Apply theme via data-panda-mode attribute on HTML element before first paint
3. Add theme toggle menu to app header
4. Verify all existing components render correctly in dark mode
5. Add light/dark illustration switching based on resolved mode
```

### 4b. Authentication

```markdown
**Requirement:** [Describe auth requirement — e.g., "Google OAuth 2.0 sign-in for community submissions"]

**Acceptance criteria:**
- [ ] [e.g., "Sign-in button appears in header when not authenticated"]
- [ ] [e.g., "Clicking sign in initiates Google OAuth flow"]
- [ ] [e.g., "Session persists across page reloads"]
- [ ] [e.g., "Protected actions show sign-in prompt when not authenticated"]
- [ ] [e.g., "User avatar and name display in header when signed in"]
- [ ] [e.g., "Sign out clears session and returns to unauthenticated state"]

**Tasks:**
1. [Task 1]
2. [Task 2]
...
```

### 4c. Responsive Design

```markdown
**Requirement:** The app must be fully usable on mobile (375px), tablet (768px), and desktop (1280px+).

**Acceptance criteria:**
- [ ] Grids adapt column count by breakpoint
- [ ] Modals are fullscreen on mobile, sized on desktop
- [ ] Search collapses to icon on mobile (if applicable)
- [ ] Touch targets are at least 44x44px on mobile
- [ ] No horizontal scrolling on any breakpoint
- [ ] Navigation is accessible on all breakpoints

**Tasks:**
1. [Task 1]
2. [Task 2]
...
```

### 4d. Accessibility

```markdown
**Requirement:** The app must meet WCAG 2.1 AA standards.

**Acceptance criteria:**
- [ ] All interactive elements are keyboard-navigable (Tab, Enter, Escape)
- [ ] Modal focus is trapped and restored on close
- [ ] Images have meaningful alt text
- [ ] Form fields have visible labels
- [ ] Icon-only buttons have aria-labels or title attributes
- [ ] Color is not the only means of conveying information

**Tasks:**
1. [Task 1]
2. [Task 2]
...
```

### 4e. Error Handling

```markdown
**Requirement:** All error states are handled gracefully with user-friendly messaging.

**Acceptance criteria:**
- [ ] API failures show descriptive error messages (not raw errors)
- [ ] Empty data states show illustrations and helpful copy
- [ ] Form validation errors appear inline next to the relevant field
- [ ] 404 page renders for unknown routes
- [ ] Network errors do not crash the app

**Tasks:**
1. [Task 1]
2. [Task 2]
...
```

---

## 5. API Contract

Document every backend endpoint the frontend depends on. This section preserves the interface between the backend (which stays untouched) and the new frontend (which will be rebuilt from scratch). Capture this BEFORE deleting any frontend code.

See [API Contract Guide](api-contract-guide.md) for the full methodology.

### Endpoint Template

For each endpoint, capture:

```markdown
### `METHOD /api/path`

**Purpose:** [What this endpoint does — one sentence]

**Auth required:** Yes / No

**Request:**
- Path params: `id` (string) — resource identifier
- Query params: `category` (string, optional) — filter by category
- Body (JSON):
  ```json
  {
    "name": "string (required)",
    "description": "string (required)",
    "tags": "string[] (optional)"
  }
  ```

**Response (200):**
```json
{
  "id": "string",
  "name": "string",
  "description": "string",
  "tags": ["string"],
  "createdAt": "ISO 8601 timestamp"
}
```

**Error responses:**
- `401` — Not authenticated (auth required but no session)
- `404` — Resource not found
- `422` — Validation error (missing required fields)

**Side effects:** [e.g., "Increments download count", "Sends notification" — or "None"]
```

### Endpoint Table (Quick Reference)

After documenting each endpoint in detail, include a summary table:

```markdown
| Method | Path | Purpose | Auth |
|--------|------|---------|------|
| GET | /api/skills | List all skills with summary data | No |
| GET | /api/skills/:id | Get full skill detail | No |
| POST | /api/community-skills | Submit a new community skill | Yes |
| GET | /api/reports | Get analytics dashboard data | No |
| POST | /api/downloads/:type/:id | Track a download event | No |
| GET | /api/auth/me | Get current user session | No |
| POST | /api/auth/google | Exchange Google token for session | No |
| POST | /api/auth/logout | End user session | Yes |
```

### API Contract Checklist

Before proceeding to the clean slate phase, verify:

- [ ] Every `fetch` / API call in the existing frontend has a corresponding endpoint documented
- [ ] Every endpoint has its full request shape (params, query, body)
- [ ] Every endpoint has its full response shape (JSON fields and types)
- [ ] Authentication requirements are noted for each endpoint
- [ ] Error responses are documented
- [ ] Side effects are listed (downloads tracking, notifications, etc.)
- [ ] The endpoint table is complete and matches the detailed documentation

---

## 6. Out of Scope

List features that are explicitly NOT included in the rebuild. This prevents scope creep.

```markdown
| Feature | Reason |
|---------|--------|
| [e.g., "Admin panel"] | [e.g., "Not part of the user-facing app"] |
| [e.g., "Email notifications"] | [e.g., "Backend-only, no UI component"] |
```

---

## 7. Feature Build Sequence

After all features are documented, define the build order. This is derived from the PRD — not from the old codebase.

```markdown
### Phase 1: Foundation
1. [Feature/task — e.g., "App shell with header, routing, and sticky navigation"]
2. [Feature/task — e.g., "Theme context with light/dark/system switching"]
3. [Feature/task — e.g., "Auth provider with Google OAuth"]

### Phase 2: Core
4. [Feature — e.g., "Skills browsing grid with cards"]
5. [Feature — e.g., "Skill detail page with tabs"]
6. [Feature — e.g., "MCP browsing grid with cards"]
7. [Feature — e.g., "MCP detail page with features and setup"]

### Phase 3: Supporting
8. [Feature — e.g., "Global search with Combobox"]
9. [Feature — e.g., "Category filters"]
10. [Feature — e.g., "Modal previews"]
11. [Feature — e.g., "Community submission forms"]

### Phase 4: Polish
12. [Feature — e.g., "Reports dashboard"]
13. [Feature — e.g., "Keyboard shortcuts"]
14. [Feature — e.g., "Empty states with illustrations"]
15. [Feature — e.g., "Loading states and responsive refinements"]
```

---

## PRD Checklist

Before starting the rebuild, verify the PRD is complete:

- [ ] Every screen from the analysis has at least one feature in the PRD
- [ ] Every interaction from the analysis is captured in acceptance criteria
- [ ] Every API endpoint from the analysis has a corresponding data requirement
- [ ] Dark mode switching is documented with specific acceptance criteria and tasks
- [ ] Auth flow is documented end-to-end (if applicable)
- [ ] Responsive behavior is documented for each layout-sensitive feature
- [ ] Out of scope section is filled in (even if empty)
- [ ] Build sequence is defined
- [ ] Every task is Ralph Wiggum sized (one thing, independently verifiable)
- [ ] Every acceptance criterion is specific and testable (not vague)
