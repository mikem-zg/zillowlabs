---
name: constellation-start
description: Bootstrap a new Claude Code project with Zillow's Constellation design system. Generates a .claude/ folder with CLAUDE.md rules, phase-gated task files, quality gates, and skill mappings. Run /constellation-start to start the interactive setup wizard. Activates when starting a new Zillow app, bootstrapping a project, or when the user mentions "constellation start", "new project", "start a build", or "set up constellation".
---

# Constellation Start

Bootstrap Claude Code projects with Zillow's Constellation design system, brand rules, and a phase-gated workflow.

When invoked, run an interactive setup wizard, then generate a complete `.claude/` folder so Claude behaves consistently with the Zillow stack from the first message.

## Parallel Execution Strategy

Use the Agent tool to run independent tasks simultaneously. This dramatically reduces wall-clock time.

**Rules for parallelism:**
- Launch agents for tasks that don't depend on each other's output
- Each agent gets the full project context (description, audience, app type, skills)
- The orchestrator (you) coordinates agents and merges their work
- Human confirmation gates still require user input — never skip them

**Phase-level parallelism:**

| Phase | Parallelization |
|-------|----------------|
| **Setup** | After `01_install-constellation` completes, run `02_configure-panda`, `03_configure-vite`, and `04_inject-theme` as 3 parallel agents. Then verify dev server. |
| **Design** | Can START while setup's `05_verify-dev-server` runs — design-draft only reads skills, doesn't need the running server. |
| **Build** | Split pages/views across agents. E.g. Agent 1 builds header + nav, Agent 2 builds the main dashboard/page, Agent 3 builds secondary pages. All agents follow the same CLAUDE.md rules and design brief. Merge results, then wire up routing. |
| **Review** | Run all 4 review tasks (`architect-review`, `accessibility-check`, `brand-compliance`, `description-check`) as parallel agents. Collect all findings, then fix in a single pass. |
| **Deliver** | Single task — no parallelism needed. |

**How to launch parallel agents:**

Send a single message with multiple Agent tool calls. Each agent should receive:
1. The project description from `.claude-state.json`
2. The full CLAUDE.md rules
3. The design brief (for build phase)
4. Its specific task assignment

Example for Build phase:
```
Agent 1: "Build the header and sidebar navigation for {projectName}. Follow all rules in CLAUDE.md. Use the header-navigation skill patterns. Here's the design brief: {brief}"
Agent 2: "Build the main dashboard page for {projectName}. Follow all rules in CLAUDE.md. Here's the design brief: {brief}. Components needed: {list from brief}"
Agent 3: "Build the {secondary page} for {projectName}. Follow all rules in CLAUDE.md. Here's the design brief: {brief}"
```

After all agents complete, merge their files and wire up routing in a single pass.

## Wizard

Ask these questions **one at a time**, waiting for each answer before proceeding.

### Step 1: Describe Your Idea

Ask: **"Tell me about what you want to build. What's the idea, who is it for, and what should it do?"**

This is a free-text response. Let the user describe their vision in their own words — a sentence, a paragraph, or a detailed brief. Capture the full response as `projectDescription`.

This is the most important step. Everything that follows builds on this description. Read it carefully — you'll use it to:
- Auto-suggest the project name, audience, and app type
- Guide design and build decisions in later phases
- Validate the final product matches the original vision

### Step 2: Project Name

Auto-suggest a name based on the description. Present it as a default the user can accept or override.

Ask: **"Project name? (suggested: {suggestion})"**

### Step 3: Audience

Infer from the description and present your best guess. Let the user confirm or override.

| Signal in description | Suggested audience |
|-----------------------|-------------------|
| "agents", "partners", "loan officers", "property managers", "CRM", "leads", "listings management" | **Professional** |
| "homebuyers", "renters", "sellers", "home search", "house hunting", "moving", "mortgage calculator" | **Consumer** |

Ask: **"Who is the audience? (suggested: {suggestion})"**
- **Consumer** — Homebuyers, renters, sellers. Expressive, emotional UI.
- **Professional** — Agents, loan officers, property managers. Functional, data-forward UI.

### Step 4: App Type

Infer from the description and present your best guess.

| Signal in description | Suggested type |
|-----------------------|---------------|
| "dashboard", "metrics", "analytics", "reports", "KPIs", "overview" | Data dashboard |
| "search", "browse", "listings", "filter", "map", "explore" | Search / browse |
| "landing page", "marketing", "campaign", "promo", "announcement" | Landing / marketing page |
| "form", "wizard", "onboarding", "survey", "intake", "steps" | Form / wizard flow |
| "tool", "utility", "calculator", "converter", "internal" | Tool / utility |

Ask: **"What type of app? (suggested: {suggestion})"**
- Data dashboard
- Search / browse experience
- Landing / marketing page
- Form / wizard flow
- Tool / utility

### Step 5: Project Type

Auto-suggest based on app type, but let the user override:

| App Type | Default |
|----------|---------|
| Dashboard, Search, Form | **standard** (setup > design > build > review > deliver) |
| Landing page | **research** (setup > design > review > deliver) |
| Tool / utility | **implementation** (setup > build > review > deliver) |

Ask: **"Project workflow type? (suggested: {default})"**
- **standard** — Full planning + design + build
- **implementation** — Skip design, requirements already exist
- **research** — Exploration-focused, skip build

### Step 6: Context

Ask: **"Marketing or Product context?"**
- **Product** — In-app experience, functional UI
- **Marketing** — Landing pages, campaigns, promotional content

### Step 7: Skills

Always include these (do not ask):
- `constellation-design-system`
- `constellation-content`
- `{audience}-brand-guidelines` (consumer or professional based on Step 3)

Ask: **"Which additional skills should I load?"** and offer:
- header-navigation — Header and nav patterns
- property-card-data — Property listings with generated images
- responsive-design — Mobile-first layouts
- constellation-dark-mode — Dark mode support
- constellation-icons — Icon library reference
- constellation-illustrations — Spot illustrations
- google-maps — Maps and location features
- zillow-auth — Zillow login / auth
- slack-integration — Slack bots and integrations
- accessibility — WCAG 2.2 AA compliance
- design-review — Structured UX review
- orangelogic-dam — Brand imagery from DAM
- device-frames — Device frame mockups
- google-slides-generator — Slide deck generation

### Step 8: Confirm

Show a summary of all choices including the description, and ask **"Ready to generate?"**

---

## Generation

After the wizard, generate the following files. Use the **project directory** (current working directory).

### File: `.claude/CLAUDE.md`

Generate with this structure, filling in values from the wizard:

```markdown
<!-- AUTO-GENERATED by constellation-init — DO NOT EDIT this file directly -->
<!-- To customize rules for this project, edit OVERRIDES.md instead -->

# {projectName} — Claude Project Rules

## What We're Building

{projectDescription}

---

**Constellation version:** {latest version from Artifactory or 10.14.1}
**Audience:** {audience}
**App type:** {appType}
**Workflow:** {projectType}
**Context:** {context}

Also read `OVERRIDES.md` for project-specific rules that override or extend these defaults.

## Project Workflow

This project uses a **{projectType}** workflow with phase-gated progression.
Task files live in `phases/` — each phase has numbered tasks and mandatory quality gates.

**Do not proceed to the next phase until a human confirms the current phase is complete.**

| Phase | Directory |
|-------|-----------|
{for each phase in the project type, list: | {name} | `phases/{NNN}_{name}/` |}
```

Then include ALL of the following sections in the generated CLAUDE.md:

#### Tech Stack Section

```markdown
## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React 18, Vite, PandaCSS, Zillow Constellation v{version} |
| Backend | Express.js, TypeScript |
| Routing | wouter (client-side) |
| State | @tanstack/react-query |
| Styling | PandaCSS with Constellation presets and tokens |
```

#### Required Skills Section

List all selected skills with their `/skill-name` invocations.

#### Critical Build Rules Section

Include these 21 rules verbatim:

```
1. PropertyCard -> ALWAYS add saveButton={<PropertyCard.SaveButton />}
2. Card -> Choose ONE of: elevated or outlined (NEVER both); elevated = interactive; ALWAYS tone="neutral"
3. Headers -> Use Flex inside sticky Box (not Page.Header)
4. Dividers -> borderBottom on header/nav containers; <Divider /> for content separators. Always pair borderBottom with borderColor.
5. Icons -> ALWAYS Filled variants, ALWAYS size tokens (sm/md/lg/xl)
6. Tabs -> ALWAYS include defaultSelected prop
7. Heading -> ONLY 1-2 per screen; use Text textStyle variants for section/card titles
8. Backgrounds -> ALWAYS bg.screen.neutral for page backgrounds. NEVER bg.canvas.
9. Text/Icon color -> Use css prop (NOT color prop) for semantic tokens: css={{ color: "text.subtle" }}
10. On-hero text -> Use style prop with CSS variables (NOT css prop)
11. Logo sizing -> Use style prop (NOT css prop) for pixel values on logos
12. Modal -> ALWAYS use body prop for content (NEVER children); default size="md"
13. PropertyCard images -> ALWAYS generate via property-card-data skill; NEVER external URLs
14. Page structure -> ALWAYS wrap pages in Page.Root > Page.Content
15. Heading level -> ALWAYS include level prop
16. PropertyCard.Badge tone -> ONLY "notify" | "neutral" | "buyAbility" | "zillow"
17. Native HTML elements -> NEVER use raw HTML form elements. ALWAYS use Constellation equivalents.
18. Custom form controls -> NEVER hand-build when Constellation provides RadioGroup, Checkbox, Switch, etc.
19. PandaCSS shorthand -> ALWAYS use Panda utility shorthands (p, px, py, m, mx, mb)
20. Minimum interactive gap -> NEVER use spacing tokens below "200" between clickable elements
21. Professional buttons -> Default to text-only. Icons only when essential for comprehension.
```

#### Brand Rules Section

**If Consumer:**
- Default to `bg.screen.neutral`. Semantic tokens only — never raw hex.
- Full expressive palette: Blue (interactive), Teal (trust), Purple (news), Orange (urgency).
- One color family per page. Max 25% bold color per viewport.
- NEVER stack colored sections back-to-back. NEVER use pastel tinted backgrounds as main surfaces.
- Filled icons by default. DuoColorIcon for upsells/empty states/hero.
- Scene illustrations for storytelling. Spot illustrations for supporting content. House motifs allowed.
- Typography: `heading-lg` for page titles, `body-lg-bold` for sections, `body-bold` for cards.
- Spacing: px=400, py=600, section gaps=800, card padding=400, grid gaps=400.
- Component sizing: `size="md"` for buttons/inputs/selects/avatar.

**If Professional:**
- White/neutral backgrounds only. `bg.screen.softest` for section differentiation (NOT `bg.screen.muted`).
- Blue for interactive only. Waterfront/Pool for depth. PROHIBITED: Purple, Orange, Teal in general UI.
- Filled icons. DuoColorIcon MAX 1-2 per viewport. Spot illustrations only — NO scene illustrations as heroes.
- NEVER use house motifs. Photography for hero visuals.
- Typography: `heading-md` for page titles, `heading-xs` for stat values, `body-sm` for metric labels.
- Spacing (dense): px=400, py=400, section gaps=400, card padding=300, grid gaps=200.
- Component sizing: `size="sm"` for buttons/inputs/selects/tables. `size="md"` only for hero CTAs.
- Buttons text-only by default. Icons only when essential for comprehension.

#### Standard Imports Section

```tsx
import {
  Button, Card, Text, Heading, Input, Tabs, PropertyCard, ZillowLogo,
  Icon, IconButton, Divider, Select, Checkbox, Radio, Tag,
  ToggleButtonGroup, ToggleButton, Modal, Switch, Table
} from '@zillow/constellation';

import { IconHeartFilled, IconSearchFilled, IconHouseFilled } from '@zillow/constellation-icons';

import { css } from '@/styled-system/css';
import { Box, Flex, Grid } from '@/styled-system/jsx';
import { getTheme, injectTheme } from '@/styled-system/themes';
```

**Components that do NOT exist** — never reference these:
- ~~SegmentedControl~~ → use `ToggleButtonGroup` + `ToggleButton`
- ~~CheckboxGroup~~ → use multiple `Checkbox` or `ChipGroup`
- ~~Badge~~ → use `Tag`

**Wrong icon names** — always verify via constellation-mcp:
- ~~IconHomeFilled~~ → `IconHouseFilled`
- ~~IconPersonFilled~~ → does not exist
- ~~IconPaymentFilled~~ → `IconDollarSignCircleFilled`
- ~~IconDocumentFilled~~ → `IconFileFilled`
- ~~IconToolFilled~~ → `IconWrenchFilled`

#### Setup Reference Section (correct paths for v10.14.1+)

Include these corrected paths — the most common setup errors:

```
Token import:  @zillow/constellation-tokens/css/zillow        (NOT dist/css/zillow.css)
Font import:   @zillow/constellation-fonts/zillow-fonts.css    (NOT dist/fonts.css)
Theme API:     import { getTheme, injectTheme } from "@/styled-system/themes"  (NOT from @zillow/constellation)
               getTheme() is ASYNC — must await it
Panda plugins: constellationPandaPlugins({})                   (NOT constellationPandaPlugins())
CSS layers:    @layer reset, base, tokens, recipes, compositions, utilities;
Vite aliases:  @/styled-system MUST come before @/ in alias config
```

#### Code Patterns Section

Include these patterns:
- Text/Icon color: `css={{ color: 'icon.neutral' }}` (NOT color prop)
- Card styling: elevated+interactive for clickable, outlined+elevated={false} for static
- Sticky header: Box with position sticky + Flex inside
- Modal: ALWAYS use body prop

### File: `.claude/OVERRIDES.md`

```markdown
# {projectName} — Project Overrides

Add project-specific rules here. These override or extend the defaults in CLAUDE.md.
This file is yours to edit — it will not be regenerated.

## What We're Building

{projectDescription}

Use this section to refine the vision as the project evolves.

## Custom Rules

## Additional Skills

## Notes
```

### File: `.claude/.claude-state.json`

```json
{
  "constellationVersion": "{version}",
  "projectName": "{projectName}",
  "projectDescription": "{projectDescription}",
  "audience": "{audience}",
  "appType": "{appType}",
  "projectType": "{projectType}",
  "context": "{context}",
  "skills": ["{skill1}", "{skill2}"],
  "currentPhase": "{first phase}",
  "phases": [
    {
      "name": "{phase}",
      "dirName": "{NNN}_{phase}",
      "tasks": [
        { "id": "{taskId}", "title": "{taskTitle}", "status": "pending" }
      ],
      "qualityGate": { "review": "pending", "iterate": "pending" }
    }
  ],
  "createdAt": "{ISO timestamp}",
  "updatedAt": "{ISO timestamp}"
}
```

---

## Phase Directories

Generate `.claude/phases/` with numbered directories based on the project type.

### Phase numbering
- Directories: `001_setup`, `002_design`, `003_build`, `004_review`, `005_deliver`
- Tasks within: `01_task-id.md`, `02_task-id.md`, etc.
- Quality gates always last: `XX_quality_review.md`, `XX_quality_iterate.md`

### Setup Phase Tasks

**01_install-constellation.md** — Install Constellation v{version}, all required packages, and peer dependencies. This must complete first.
```
pnpm add @zillow/constellation@{version} @zillow/constellation-icons@{version} @zillow/constellation-tokens@{version} @zillow/constellation-fonts@{version} date-fns
pnpm add -D @zillow/constellation-config@{version}
```

**02-04: Run in parallel** — After install completes, launch 3 agents simultaneously:

**Agent 1 — 02_configure-panda.md:** Configure `panda.config.ts`:
```ts
import { defineConfig } from "@pandacss/dev";
import { constellationPandaPreset, constellationPandaPlugins } from "@zillow/constellation-config";

export default defineConfig({
  preflight: true,
  include: [
    "./src/**/*.{js,jsx,ts,tsx}",
    "./node_modules/@zillow/constellation/dist/**/*.js",
  ],
  outdir: "src/styled-system",
  jsxFramework: "react",
  presets: [constellationPandaPreset()],
  plugins: constellationPandaPlugins({}),
});
```
Critical: `constellationPandaPlugins({})` needs empty object arg. `jsxFramework: "react"` is required for Box/Flex/Grid. Constellation dist MUST be in `include` for component style extraction.

**Agent 2 — 03_configure-vite.md:** Set up path aliases and PostCSS in `vite.config.ts`:
```ts
import pandacss from "@pandacss/dev/postcss";

export default defineConfig({
  css: {
    postcss: {
      plugins: [pandacss()],
    },
  },
  resolve: {
    alias: {
      "@/styled-system": path.resolve(__dirname, "src/styled-system"),  // FIRST — specific before general
      "@/": path.resolve(__dirname, "src/"),                             // SECOND
      "@shared": path.resolve(__dirname, "shared/"),
    },
  },
});
```
Critical: PostCSS plugin required (zero CSS without it). `@/styled-system` alias MUST come before `@/`.

**Agent 3 — 04_inject-theme.md:**
1. Add CSS layer directive as first line of main CSS file: `@layer reset, base, tokens, recipes, compositions, utilities;`
2. Update `src/main.tsx`:
```tsx
import "@zillow/constellation-tokens/css/zillow";
import "@zillow/constellation-fonts/zillow-fonts.css";
import "./index.css";
import { getTheme, injectTheme } from "@/styled-system/themes";

async function init() {
  const theme = await getTheme("zillow");
  injectTheme(document.documentElement, theme);
}
init();
```
Critical: Token path is `css/zillow` NOT `dist/css/zillow.css`. Font path is `zillow-fonts.css` NOT `dist/fonts.css`. Theme API is from `@/styled-system/themes` NOT `@zillow/constellation`. `getTheme()` is async — must await.

**05_verify-dev-server.md** — After all 3 agents complete, run `pnpm dev` and verify the server starts, PandaCSS codegen runs, and Constellation styles render.

**Overlap:** While verifying the dev server, start the Design phase — design-draft only reads skills, it doesn't need the running server.

### Design Phase Tasks

**IMPORTANT:** Do NOT ask the user to make design decisions. The brand skills and CLAUDE.md rules contain everything needed to make correct choices. Make all decisions autonomously based on the audience, app type, and project description, then present the complete design draft for review.

**01_design-draft.md** — Load `/{audience}-brand-guidelines` skill. Then autonomously produce a design brief covering:
- Color family (professional = Blue + Waterfront/Pool; consumer = pick the best fit from Blue/Teal/Purple/Orange based on the project description's tone)
- Page layout and information architecture — map features from the project description to specific pages/views
- Typography hierarchy per audience rules
- Which sections need illustrations (professional: spot only; consumer: scene + spot)
- Component inventory — list the Constellation components needed for each view

Write the design brief to `phases/002_design/design-brief.md`. Do not ask for input — just make the calls.

**02_design-review.md** — Present the design brief to the user for a single pass of feedback. Ask: "Here's the design plan. Want me to adjust anything before I start building?" Apply any feedback, then proceed.

### Build Phase Tasks

**IMPORTANT:** Build the complete initial draft without stopping to ask questions. Use the project description, design brief, and skill knowledge to make all implementation decisions. Present the working app for feedback only after the full first pass is built.

**01_build-app.md** — Split the build across parallel agents based on the design brief:

First, create shared scaffolding (routing setup, shared types, data layer skeleton) in the main thread. Then launch parallel agents:

| Agent | Builds | Depends on |
|-------|--------|-----------|
| **Agent 1: Shell** | Header, sidebar/nav, app layout wrapper | Shared scaffolding |
| **Agent 2: Primary page** | Main page/dashboard (the core view) | Shared scaffolding |
| **Agent 3: Secondary pages** | All other pages from the design brief | Shared scaffolding |

Each agent receives: project description, CLAUDE.md rules, design brief, and the shared scaffolding files. Each agent wraps pages in `<Page.Root><Page.Content>` and follows all 21 critical rules.

After all agents complete: merge files, wire up routing in `App.tsx`, connect data flows, and verify the app runs.

**02_build-review.md** — Show the user the running app. Ask: "Here's the first draft. What would you like me to change?" Iterate based on feedback.

### Review Phase Tasks

**Run all 4 reviews in parallel** — launch as simultaneous agents, each scanning the full codebase:

| Agent | Task | Focus |
|-------|------|-------|
| **Agent 1** | `01_architect-review.md` | All 21 critical rules. List every violation with file:line. |
| **Agent 2** | `02_accessibility-check.md` | WCAG 2.2 AA: keyboard nav, focus, ARIA, contrast, touch targets. Load `/accessibility` skill. |
| **Agent 3** | `03_brand-compliance.md` | Brand rules for audience: colors, icons, illustrations, sizing, spacing, buttons. |
| **Agent 4** | `04_description-check.md` | Re-read project description from `.claude-state.json`. Verify every feature/goal was built. List gaps. |

Collect all findings into a single remediation list. Fix everything in one pass, then re-verify.

### Deliver Phase Tasks

**01_final-verification.md** — `pnpm build` succeeds. App runs in production. No placeholder data. APP_NAME set. Product matches the original description.

### Quality Gates (every phase)

Always append these two files as the last tasks in every phase:

**XX_quality_review.md:**
```markdown
# Quality Gate: Review

Review all work in this phase against project standards.
- [ ] All task deliverables verified
- [ ] No CLAUDE.md rule violations
- [ ] No brand guideline violations
- [ ] Work aligns with project description

This gate is mandatory. Do not skip.
```

**XX_quality_iterate.md:**
```markdown
# Quality Gate: Iterate

Address all findings from the review and re-verify.
- [ ] All review findings addressed
- [ ] Re-verification passed
- [ ] No regressions

GATE: Do not proceed to the next phase until a human confirms this phase is complete.
```

---

## After Generation

Once all files are generated, print a summary:

```
Done! Generated .claude/ folder for: {projectName}

  "{projectDescription}" (truncated to first 100 chars)

  CLAUDE.md           — Global rules (auto-generated, do not edit)
  OVERRIDES.md        — Your project-specific overrides
  .claude-state.json  — State tracker with task-level progress
  phases/             — {N} phase directories with task files + quality gates

Start working through phases/001_setup/ — read each task file in order.
Run /constellation-start again to see progress or advance phases.
```

Then immediately read the first task file (`phases/001_setup/01_install-constellation.md`) and start executing it.

---

## Resume Mode

If invoked in a directory that already has `.claude/.claude-state.json`, skip the wizard and instead:

1. Read the state file
2. Show the project description as a reminder of what we're building
3. Show progress for each phase (completed tasks / total tasks)
4. Show current phase tasks with status
5. Ask: "Continue with current phase, or mark it complete and advance?"

## Phase Advancement

When the user says a phase is done:
1. Mark all tasks in the current phase as "complete"
2. Mark quality gates as "complete"
3. Update `currentPhase` to the next phase
4. Write updated state to `.claude-state.json`
5. Read the first task of the new phase and start executing
