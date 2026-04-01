# Build Kickoff Guide

This is the step-by-step workflow for starting any new app or feature with Zillow's Constellation Design System. Follow these steps in order. Each step references the specific skills that carry the detailed knowledge — load them when you need them.

**Conflict resolution:** When brand guideline skills contradict this document, the brand guideline skill is authoritative. This document is a working cheat sheet — skills are the source of truth.

---

## Pre-Build Checklist (MANDATORY — complete before writing any code)

```
[ ] Review tasks/lessons.md for relevant patterns before starting
[ ] Audience identified (Consumer or Professional)
[ ] Brand guidelines skill loaded for that audience (consumer-brand-guidelines or professional-brand-guidelines)
[ ] Marketing or Product context determined
[ ] Color family chosen and documented (one family per page)
[ ] Illustration needs identified (which sections need warmth/storytelling?)
[ ] App type identified (dashboard, search, landing page, form, tool)
[ ] constellation-design-system skill loaded
[ ] APP_NAME and APP_DESCRIPTION env vars set (REQUIRED — see Step 2B)
[ ] Replit project Name and Description updated (REQUIRED — see Step 2B)
```

Do NOT skip this checklist. Loading the design system skill alone is not enough — brand rules vary significantly between consumer and professional audiences, and between marketing and product contexts.

---

## Step 1: Understand the Request

Before writing any code, answer these questions:

### 1A. Who is the audience?

| Audience | Description | Examples |
|----------|-------------|----------|
| **Consumer** | People buying, selling, or renting a home | Homebuyer, Renter, Seller, "My Home" dashboard, search/browse flows |
| **Professional** | People conducting real-estate business | Agents, loan officers, property managers, "Agent Hub", ZRM tools |

The audience determines brand rules, color palette, component sizing, illustration style, and tone. Consumer apps are expressive and emotional; Professional apps are functional and data-forward.

### 1B. What type of app is this?

Identify the core pattern so you know which skills to load:
- **Data dashboard** → focus on tables, cards, filters, charts
- **Search/browse experience** → PropertyCard grids, maps, filters
- **Landing/marketing page** → hero sections, illustrations, CTAs
- **Form/wizard flow** → inputs, validation, step indicators
- **Tool/utility** → functional layout, minimal color

---

## Step 2: Set Up the Project

### 2A. Tech stack and installation

Read `references/guides/installation-and-setup.md` in this skill for full setup details. Key requirements:

- `panda.config.ts` must include `constellationPandaPreset()` and `constellationPandaPlugins()`
- `vite.config.ts` must have path aliases: `@/` → `client/src`, `@/styled-system`, `@shared`
- `client/src/main.tsx` must call `getTheme("zillow")` + `injectTheme(document.documentElement, theme)` before rendering

### 2B. App name and description (REQUIRED)

Set `APP_NAME` and `APP_DESCRIPTION` environment variables in the **shared** environment before the first build. The server injects these into `index.html` for browser tab title and link preview metadata.

Also update the **Name** and **Description** fields in Replit project settings (deployment/publish dialog).

**Format:** `[App Name] | [Brief Tagline]`

| DO | DON'T |
|----|-------|
| Write from the user's perspective ("Find your next home") | Use developer jargon ("React SPA with Express backend") |
| Use sentence case for descriptions | Use ALL CAPS or Title Case Every Word |
| Set env vars in the "shared" environment | Edit `{{APP_NAME}}`/`{{APP_DESCRIPTION}}` placeholders in `index.html` directly |
| Set these BEFORE the first build | Leave them unset and rely on defaults |
| Update the Replit project Name and Description | Leave the template's default description |

### 2C. Configure the workflow

Ensure a workflow runs `npm run dev` as the start command (Express server + PandaCSS concurrently).

---

## Step 3: Load the Right Skills

### Always Load
| Skill | What it gives you |
|-------|-------------------|
| `constellation-design-system` | 99 component APIs, 21 critical rules, new page checklist, token resolution rules, spacing/color/breakpoint tokens, typography hierarchy, code patterns |
| `constellation-content` | UX writing and content guidelines — voice & tone, sentence case rules, microcopy patterns, number formatting, audience-specific tone |

### Load Based on Audience
| Audience | Load this skill | What it gives you |
|----------|----------------|-------------------|
| Consumer | `consumer-brand-guidelines` | Color rules, typography hierarchy, spacing tokens, component sizing, illustration/photography guidance, warmth checklist |
| Professional | `professional-brand-guidelines` | Restricted palette, typography hierarchy (standard + compact), spacing tokens (standard + dense), component sizing (sm default), table patterns, button icon rules |

### Load When Building...

| What you're building | Load this skill |
|---------------------|----------------|
| Any header or navigation | `header-navigation` |
| Property listings or cards | `property-card-data` |
| Responsive layouts | `responsive-design` |
| Dark mode support | `constellation-dark-mode` |
| Pages with icons | `constellation-icons` |
| Empty states, onboarding, upsells | `constellation-illustrations` |
| Maps or location features | `google-maps` |
| Zillow login / auth | `zillow-auth` |
| Slack integration | `slack-integration` |
| Google Slides generation | `google-slides-generator` |
| Agent profiles / performance | `agent-data-api` |
| Employee search | `zillow-employee-lookup` |

### Always Use for Images and Logos
| Skill | Rule |
|-------|------|
| `orangelogic-dam` | **Mandatory** for brand imagery, logos, photography, marketing assets, and headshots. Search the DAM first. NEVER use stock photos (Unsplash/Pexels), placeholder images, or hardcoded SVG logos. **Exception:** PropertyCard listing images are generated via the `property-card-data` skill using AI image generation — that is the only permitted use of AI-generated images. |

### Quality & Review (Load When Finishing)
| Skill | When to load |
|-------|-------------|
| `accessibility` | Before delivery — WCAG 2.2 AA compliance, ARIA patterns, focus management |
| `design-review` | For structured UX review with design legend personas |
| `design-handoff` | When preparing annotated specs for developer handoff |

---

## Step 4: Apply Brand Rules

Load the brand guideline skill for your audience. **Before applying any visual rule, determine your context** — each skill separates **Marketing** from **Product**. Many rules differ.

| Audience | Skill to load | Promise | Vibe |
|----------|--------------|---------|------|
| Consumer | `consumer-brand-guidelines` | "Get home" | Joyful, vibrant, emotional |
| Professional | `professional-brand-guidelines` | "Unlock success" | Efficient, organized, trustworthy |

The brand skills contain complete typography hierarchies, spacing tokens, component sizing defaults, and decision trees. Load the relevant skill for the full rules.

---

## Step 5: Build

Read the following guides in this skill:

- **`references/guides/design-system-rules.md`** — 21 critical rules, new page checklist, token resolution rules (PandaCSS gotchas), expressive color CSS variables, component selection quick reference, code pattern examples
- **`references/guides/quick-reference.md`** — condensed cheat sheet for fast lookups

---

## Step 6: Review and Deliver

### 6A. Run validation scripts
```bash
bash .agents/skills/constellation-design-system/scripts/validate-constellation.sh client/src
bash .agents/skills/constellation-icons/scripts/validate-icon-imports.sh client/src
```

### 6B. Architect review (required)

After every UI build, request an architect review against the design system rules and loaded brand skill. Fix all violations before delivery.

### 6C. Accessibility check

Load the `accessibility` skill and verify WCAG 2.2 Level AA compliance. Key checks:
- Keyboard navigation works
- Focus management is correct
- ARIA labels are present
- Color contrast meets requirements
- Touch targets are at least 44x44px

### 6D. Verify before delivering

```
[ ] App runs without errors
[ ] All critical rules from Step 5 are satisfied
[ ] Brand rules from Step 4 match the audience
[ ] APP_NAME and APP_DESCRIPTION env vars are set (shared environment)
[ ] Replit project Name and Description updated (not the template defaults)
[ ] No placeholder data or mocked content remains
```

---

## Reference Catalogs

Detailed catalogs live inside the skills — load the relevant skill when you need to search:

| What you need | Load this skill |
|---------------|----------------|
| 99 Constellation components | `constellation-design-system` |
| 621 icons by category | `constellation-icons` |
| 99 spot illustrations | `constellation-illustrations` |
| UX writing, voice & tone, microcopy | `constellation-content` |
