---
name: transition-to-constellation-from-scratch
description: Rebuild any React frontend from scratch using Zillow's Constellation Design System v10.11.0. Runs a comprehensive analysis, generates a principal product-level PRD, then rebuilds task-by-task using the Ralph Wiggum methodology (one micro-task at a time, verify before moving on). Complementary to the incremental migration skill.
license: Proprietary
compatibility: Requires a React 18+ project. Will install @zillow/constellation and @pandacss/dev.
metadata:
  author: Zillow Group
  version: "10.11.0"
---

# Transition to Constellation from Scratch (v10.11.0)

This skill handles **analyzing, specifying, and rebuilding** a React frontend natively in Zillow's Constellation Design System. Unlike the incremental migration skill (which converts component-by-component), this skill takes a clean-slate approach: deeply analyze what the app does, write a product-level PRD capturing every feature, then rebuild from scratch — one task at a time — using only Constellation.

**When to use this skill vs the incremental migration skill:**

| Scenario | Use This Skill | Use Incremental Migration |
|----------|---------------|--------------------------|
| App has heavy custom styling/design debt | Yes | No |
| App has fewer than 15 screens | Yes | Maybe |
| App uses a design system with no Constellation equivalent | Yes | No |
| App is already well-structured with clear component boundaries | Maybe | Yes |
| App has 30+ screens in production | No | Yes |
| Team needs to ship features during migration | No | Yes |

## Program Overview

```
Phase 1: ANALYZE        → Deep-dive into the running app, document every feature
Phase 2: PRD            → Write a principal product-level PRD with features, tasks, and acceptance criteria
Phase 3: API CONTRACT   → Capture every backend endpoint the frontend depends on
Phase 4: CLEAN SLATE    → Delete all existing frontend code, preserve backend and shared code
Phase 5: REBUILD        → Build the new UI from the PRD task-by-task using the Ralph Wiggum method
```

---

## Phase 1: Analyze the Existing App

Read [App Analysis Guide](references/app-audit.md) for the full methodology.

Run a comprehensive analysis of the existing app. The goal is to understand **what the app does** — not how it's currently built. The analysis feeds directly into the PRD.

**What to capture:**
- Every screen and route (what the user sees and can do)
- Every interaction pattern (modals, forms, search, filters, menus, downloads, clipboard actions)
- Every data model and API endpoint
- Cross-cutting concerns (authentication, dark mode switching, responsive behavior, accessibility)
- Implicit behaviors (keyboard shortcuts, URL deep linking, scroll behavior, page titles)

**Output:** A comprehensive analysis document. This is a working document — it does not need to be polished. Its only purpose is to ensure nothing is missed when writing the PRD.

---

## Phase 2: Write the PRD

Read [PRD Template](references/prd-template.md) for the full template and examples.

Using the analysis from Phase 1, write a **principal product-level PRD** that becomes the single source of truth for the rebuild. The PRD captures every feature as a requirement with explicit acceptance criteria and granular tasks.

**PRD structure:**
1. **Product overview** — What the app is, who it's for, what problem it solves
2. **User personas** — Who uses the app and what they need
3. **Features** — Every feature grouped by domain, each containing:
   - Description (what it does from the user's perspective)
   - Acceptance criteria (how to verify it works — specific, testable statements)
   - Tasks (granular implementation steps, each independently buildable and verifiable)
   - Data requirements (what data the feature needs, where it comes from)
4. **Cross-cutting requirements** — Dark mode, auth, responsive, accessibility, error handling
5. **Out of scope** — Features explicitly not included in the rebuild

**Critical rule:** The PRD describes *what* to build, not *how* to build it. Implementation details belong in the Constellation recipes, not the PRD. Features do not need to be built the same way as the original — they just need to satisfy the PRD requirements exactly.

**Output:** A complete PRD document that can stand alone as the specification for the new app.

---

## Phase 3: Capture the API Contract

Read [API Contract Guide](references/api-contract-guide.md) for the full methodology.

Before deleting any frontend code, **document every backend endpoint** the frontend depends on. This becomes the interface contract between the existing backend and the new frontend. The backend stays as-is — the new frontend must work with these exact endpoints.

**What to capture for each endpoint:**
- HTTP method and path
- Request parameters (query, path, body)
- Response shape (JSON structure with field types)
- Authentication requirements
- Error responses
- Any side effects (e.g., "increments download count")

**Why this phase exists:** Once you delete the frontend, you lose the implicit documentation of how the frontend called the backend. The API contract preserves that knowledge so the new frontend can wire up to the same endpoints without guessing.

**Output:** A complete API contract document listing every endpoint with request/response shapes. Include this as a section in the PRD or as a companion document.

---

## Phase 4: Clean Slate

After the PRD and API contract are complete, **delete all existing frontend code** and start fresh. The backend, shared schema, database, and configuration files stay untouched.

### What to DELETE

| Delete | Examples |
|--------|----------|
| All frontend components | `client/src/components/**`, `client/src/pages/**` |
| All frontend routes and entry points | `client/src/App.tsx`, `client/src/main.tsx` (will be recreated) |
| All frontend hooks | `client/src/hooks/**` |
| All frontend utilities | `client/src/lib/**` (frontend-specific utils) |
| All frontend styles | `client/src/index.css`, component-specific CSS |
| All frontend assets that will be replaced | Old images, icons (keep illustrations) |
| Static HTML (will be recreated) | `client/index.html` (recreate with minimal shell) |

### What to PRESERVE

| Preserve | Why |
|----------|-----|
| Backend server code | `server/**` — the API contract you just documented |
| Shared schema/types | `shared/**` — data models used by both frontend and backend |
| Database and migrations | `migrations/**`, database config |
| Build configuration | `vite.config.ts`, `tsconfig.json`, `package.json` |
| PandaCSS configuration | `panda.config.ts`, `client/src/styled-system/**` |
| Constellation packages | `node_modules/@zillow/**` (installed tarballs) |
| Theme setup | `client/src/styled-system/themes/**` |
| Illustration assets | `client/src/assets/illustrations/**` (light/dark mode SVGs) |
| Environment config | `.env`, secrets, `.replit` |
| Skill and instruction files | `.agents/**`, `custom_instruction/**` |

### Verification after deletion

Before starting the rebuild, confirm:

1. **Backend still runs** — Start the server and verify API endpoints respond correctly (use curl or similar)
2. **Database is intact** — Verify the database connection and data are unaffected
3. **Build tooling works** — Run `npx panda codegen` to verify PandaCSS still generates correctly
4. **Theme is intact** — The styled-system directory and theme injection files still exist
5. **Create a minimal `App.tsx`** — A blank page that renders with Constellation theme injection, confirming the foundation works

```tsx
// Minimal App.tsx to verify the foundation works after clean slate
import { injectTheme } from '@/styled-system/themes';
import { Page, Text } from '@zillow/constellation';

injectTheme(document.documentElement);

function App() {
  return (
    <Page.Root>
      <Page.Content>
        <Text textStyle="body">Clean slate ready. Rebuild starts here.</Text>
      </Page.Content>
    </Page.Root>
  );
}

export default App;
```

**Output:** A project where the backend works, the build tooling works, and a blank Constellation page renders. The old frontend is gone.

---

## Phase 5: Rebuild (Ralph Wiggum Method)

Read [Constellation Rebuild Recipes](references/constellation-rebuild-recipes.md) for implementation patterns.
Read [Rebuild Checklist](references/rebuild-checklist.md) for per-task verification.
Read [API Contract Guide](references/api-contract-guide.md) when wiring components to endpoints.

### What is the Ralph Wiggum Method?

The Ralph Wiggum method is a micro-incremental build approach. You build one tiny, self-contained piece at a time and verify it works completely before touching anything else. No building multiple things at once. No assuming something will "work later." Each task is independently shippable.

### The Rules

```
1. Pick ONE task from the PRD
2. Build ONLY that task — nothing else
3. Run the app and verify it works (visually + functionally)
4. Check it against the task's acceptance criteria
5. Only when it passes → move to the next task
6. If it breaks something that was working → fix it before moving on
7. NEVER skip verification. NEVER batch multiple tasks.
```

### Build Sequence

Work through the PRD features in this order:

1. **Foundation first** — App shell, routing, theme (including dark mode switching), auth provider
2. **Core features next** — The primary user workflows that define why the app exists
3. **Supporting features** — Search, filters, modals, forms, submissions
4. **Polish last** — Analytics, keyboard shortcuts, empty states, loading states, responsive refinements

Within each group, follow the task order defined in the PRD. Each task should be small enough to build and verify in a single pass.

### Per-Task Protocol

For every single task:

```
┌─────────────────────────────────────────────┐
│ 1. READ the task and its acceptance criteria │
│ 2. BUILD only what the task describes        │
│ 3. RUN the app                               │
│ 4. VERIFY against acceptance criteria        │
│ 5. CHECK: Did I break anything else?         │
│ 6. PASS → Move to next task                  │
│ 7. FAIL → Fix before moving on               │
└─────────────────────────────────────────────┘
```

### What "Verify" Means

- The app runs without errors
- The feature works as described in the acceptance criteria
- Previously completed features still work
- The UI uses Constellation components correctly (check against rebuild checklist)
- Dark mode renders correctly (if applicable)
- The page is responsive (if applicable)

---

## Reference Documents

| Document | Purpose |
|----------|---------|
| [App Analysis Guide](references/app-audit.md) | How to run a comprehensive analysis of the existing app |
| [PRD Template](references/prd-template.md) | Structured template for the product requirements document |
| [API Contract Guide](references/api-contract-guide.md) | How to capture and document backend endpoints before deletion |
| [Feature Categories](references/feature-categories.md) | How to group and sequence features in the PRD |
| [Constellation Rebuild Recipes](references/constellation-rebuild-recipes.md) | Constellation-native patterns for common feature types |
| [Rebuild Checklist](references/rebuild-checklist.md) | Per-task verification checklist (Ralph Wiggum protocol) |

## Key Principles

1. **The PRD is the contract.** Every feature in the rebuild must satisfy the PRD. Nothing more, nothing less.

2. **Capture the API contract before deleting anything.** The backend stays untouched. Document every endpoint so the new frontend can wire up correctly without guessing.

3. **Delete all frontend code, start fresh.** Do not incrementally convert. Delete the old frontend entirely, then rebuild from the PRD using Constellation and PandaCSS. The old code is gone — the PRD and API contract are your only references.

4. **Build Constellation-native, not conversion-equivalent.** Don't replicate the old UI. Build what the feature *should* look like in Constellation, as long as it meets the PRD.

5. **One task at a time (Ralph Wiggum).** Build one thing. Verify it works. Move on. Never batch, never skip verification, never assume.

6. **The PRD drives sequencing, not the old codebase.** Build in the order that makes sense for the new app, not the order the old app was built.

7. **Dark mode is not optional.** If the original app supports dark mode switching, the PRD must capture it and every task must be verified in both modes.
