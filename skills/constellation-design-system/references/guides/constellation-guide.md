# Constellation Design System Guide

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
[ ] APP_NAME and APP_DESCRIPTION env vars set (REQUIRED — see App Name & Description)
[ ] Replit project Name and Description updated (REQUIRED — see App Name & Description)
```

Do NOT skip this checklist. Loading the design system skill alone is not enough — brand rules vary significantly between consumer and professional audiences, and between marketing and product contexts.

---

## Step 1: Understand the Request

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

### Package Architecture

| Package | Purpose |
|---------|---------|
| `@zillow/constellation` | All 99 React components |
| `@zillow/constellation-config` | Panda CSS preset & config helper |
| `@zillow/constellation-tokens` | Design tokens (colors, spacing, typography) |
| `@zillow/constellation-icons` | 621 SVG icons as React components |
| `@zillow/constellation-fonts` | Inter + Object Sans font CSS (from zillowstatic.com CDN) |
| `@zillow/constellation-mcp` | MCP tooling (not needed at runtime) |

### Tech Stack Overview

| Layer | Technology |
|-------|-----------|
| Frontend | React 18, Vite, PandaCSS, Zillow Constellation v10.15.0 |
| Backend | Express.js, TypeScript |
| Routing | wouter (client-side) |
| State | @tanstack/react-query |
| Styling | PandaCSS with Constellation presets and tokens |

Constellation packages are installed from local `.tgz` files in `attached_assets/10.15.0/`.

Three config files must be wired up correctly:

1. **`panda.config.ts`** — Must include `constellationPandaPreset()` in presets and `constellationPandaPlugins()` in plugins (from `@zillow/constellation-config`)
2. **`vite.config.ts`** — Must have path aliases: `@/` → `client/src`, `@/styled-system` → `client/src/styled-system`, `@shared` → `shared/`
3. **`client/src/main.tsx`** — Must import Constellation tokens/fonts and call `getTheme("zillow")` + `injectTheme(document.documentElement, theme)` before rendering

For full installation and configuration details, load the `constellation-design-system` skill and read `references/guides/installation-and-setup.md`.

### pnpm-workspace.yaml Overrides

These packages are private (not on npm). The workspace needs overrides:

```yaml
overrides:
  "@zillow/yield-callback": "file:.agents/skills/constellation-design-system/packages/yield-callback-shim"
  "@zillow/constellation-icons": "file:.agents/skills/constellation-design-system/packages/constellation-icons-10.15.0.tgz"
  "@zillow/constellation-tokens": "file:.agents/skills/constellation-design-system/packages/constellation-tokens-10.15.0.tgz"
  "@zillow/constellation-config": "file:.agents/skills/constellation-design-system/packages/constellation-config-10.15.0.tgz"
  "@zillow/constellation-fonts": "file:.agents/skills/constellation-design-system/packages/constellation-fonts-10.15.0.tgz"
  "@zillow/constellation": "file:.agents/skills/constellation-design-system/packages/constellation-10.15.0.tgz"

onlyBuiltDependencies:
  - "@zillow/constellation"

minimumReleaseAgeExclude:
  - "@zillow/*"
```

### `@zillow/yield-callback` Shim

Constellation internally imports `interactionResponse` from `@zillow/yield-callback` (a private scheduler package). We provide a shim at `.agents/skills/constellation-design-system/packages/yield-callback-shim/` that implements it using `requestAnimationFrame`.

### Panda CSS Configuration

Every artifact needs `panda.config.ts`:

```ts
import { constellationPandaConfig } from '@zillow/constellation-config';

export default constellationPandaConfig({
  config: {
    include: ['./src/**/*.{ts,tsx,js,jsx}'],
    outdir: 'styled-system',
    staticCss: {
      themes: ['zillow'],
    },
  },
});
```

### PostCSS Configuration

`postcss.config.cjs`:

```js
module.exports = {
  plugins: {
    '@pandacss/dev/postcss': {},
  },
};
```

### Panda Codegen

Run after install:

```bash
npx panda codegen --clean
touch styled-system/styles.css
```

This generates the `styled-system/` directory. You **must** also run `touch styled-system/styles.css` because the PostCSS plugin generates this file's content at build time, but Vite's CSS resolver needs the file to exist before that.

Add to `package.json` scripts:

```json
"prepare": "panda codegen --clean && panda cssgen"
```

The `panda cssgen` step is essential — `panda codegen` alone generates JS/TS artifacts but does NOT generate `styled-system/styles.css`. Without `panda cssgen`, every workflow restart will fail with `ENOENT: no such file or directory, open '../styled-system/styles.css'` because the `--clean` flag wipes the directory first.

### No Tailwind

Constellation replaces Tailwind entirely. Remove all Tailwind config, deps, and utility classes when converting.

### The Conversion Script Is the Source of Truth

Any fix to app configuration should also be applied to `.agents/skills/constellation-design-system/scripts/convert-to-constellation.sh` so future apps inherit it. When creating new apps, always use the conversion script rather than setting up manually.

### App Name and Description (REQUIRED)

You MUST set `APP_NAME` and `APP_DESCRIPTION` environment variables before the first build. The server injects these into `index.html` at runtime for browser tab title and link preview metadata. If not set, the browser tab will show "APP_NAME not set" and the server will log a warning on startup.

You must update the app name and description in **two places**:

**1. Environment variables** — Set `APP_NAME` and `APP_DESCRIPTION` in the **Secrets / Environment** tab with environment set to **shared** (so they apply in both development and production). These control the browser tab title and link preview metadata.

```
APP_NAME=Agent Hub | Your real estate command center
APP_DESCRIPTION=Manage your listings, track leads, and close deals — all in one place.
```

**2. Replit project settings** — Update the **Name** and **Description** fields in the Replit project settings (the deployment/publish dialog). The template defaults to "Zillow's Constellation design system built using agent skills" which must be replaced with the actual app name and a user-facing description. This is what appears in the Replit published app listing.

**Format:** `[App Name] | [Brief Tagline]`

| DO | DON'T |
|----|-------|
| Write from the user's perspective ("Find your next home") | Use developer jargon ("React SPA with Express backend") |
| Use sentence case for descriptions | Use ALL CAPS or Title Case Every Word |
| Set env vars in the "shared" environment | Edit `{{APP_NAME}}`/`{{APP_DESCRIPTION}}` placeholders in `index.html` directly |
| Set these BEFORE the first build | Leave them unset and rely on defaults |
| Update the Replit project Name and Description | Leave the template's default description |

### Configure the Workflow

Make sure a workflow is configured to run the dev server. This project uses `npm run dev` as the start command, which runs the Express server and PandaCSS concurrently. PandaCSS runs `codegen && cssgen` before entering watch mode — this happens in parallel with the server so the port opens immediately (the existing `styled-system` files are served while PandaCSS refreshes them). A custom Vite plugin (`pandaHmrCoalesce` in `vite.config.ts`) intercepts styled-system file changes and coalesces them into a single debounced page reload, preventing the HMR flood that would otherwise occur during PandaCSS's initial extraction.

---

## Step 3: Load the Right Skills

### Always Load
| Skill | What it gives you |
|-------|-------------------|
| `constellation-design-system` | 99 component APIs, design rules, spacing/color/breakpoint tokens, typography hierarchy, code patterns |
| `constellation-content` | UX writing and content guidelines — voice & tone, sentence case rules, microcopy patterns (error/success/warning/empty states), number formatting, button/form copy, inclusive language, AI behavioral guidance, audience-specific tone (consumer vs professional) |

### Load Based on Audience
| Audience | Load this skill | What it gives you |
|----------|----------------|-------------------|
| Consumer | `consumer-brand-guidelines` | Color rules, typography, logo usage, house motifs, illustration/photography guidance, co-branding — split by Marketing vs Product context |
| Professional | `professional-brand-guidelines` | Restricted palette, surface/elevation rules, icon rules, sub-brand logos, prohibited elements — split by Marketing vs Product context |

### Load When Building...

| What you're building | Load this skill | What it gives you |
|---------------------|----------------|-------------------|
| Any header or navigation | `header-navigation` | 11 tested header patterns, sticky positioning, responsive logo swap, maxWidth alignment, logo/Page.Header gotchas |
| Property listings or cards | `property-card-data` | Realistic property data generation, photorealistic image generation, PropertyCard anatomy and required props |
| Responsive layouts | `responsive-design` | PandaCSS breakpoint tokens, mobile-first patterns, container queries, fluid typography |
| Dark mode support | `constellation-dark-mode` | Theme injection, toggle patterns, `_dark`/`_light` CSS conditions |
| Pages with icons | `constellation-icons` | 621 icons searchable by name/alias, color token patterns, sizing, icon wrapper exceptions |
| Empty states, onboarding, upsells | `constellation-illustrations` | 99 spot illustrations, light/dark mode paths, sizing guidance |
| Maps or location features | `google-maps` | `@vis.gl/react-google-maps` setup, markers, geocoding, Places Autocomplete |
| Zillow login / auth | `zillow-auth` | Broker SDK, pauth integration, session events, test auth |
| Slack integration | `slack-integration` | Bolt SDK, slash commands, Block Kit, modals, webhooks |
| Google Slides generation | `google-slides-generator` | Zillow slide template, API setup, content population |
| Agent profiles / performance | `agent-data-api` | Agent Data API endpoints, auth, caching |
| Employee search | `zillow-employee-lookup` | Glean MCP, Slack API, Combobox/Avatar patterns |

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
| `security-audit` | When auditing auth, injection, data exposure |
| `scalability-audit` | When auditing performance, memory, queries, caching |

---

## Step 4: Apply Brand Rules

Load the brand guideline skill for your audience (identified in Step 1). **Before applying any visual rule, determine your context** — each skill separates **Marketing** from **Product**. Many rules differ.

| Audience | Skill to load | Promise | Vibe |
|----------|--------------|---------|------|
| Consumer | `consumer-brand-guidelines` | "Get home" | Joyful, vibrant, emotional |
| Professional | `professional-brand-guidelines` | "Unlock success" | Efficient, organized, trustworthy |

### Consumer Brand Rules (Quick Reference)

**Color & Surfaces:**
- Default to `bg.screen.neutral`. Use semantic tokens only — never raw hex.
- Full expressive palette allowed: **Blue** (interactive/actions), **Teal** (trust/productivity), **Purple** (news/inspiration), **Orange** (urgency/empowerment).
- **One color family per page** — pick one and commit. Don't mix teal + purple + orange on the same page.
- ≤ 25% bold color per viewport. Heroes may exceed. Dense content stays on white/neutral.
- NEVER stack colored sections back-to-back — separate with neutral sections. NEVER use light/pastel tinted backgrounds as main surfaces.

**Icons & Illustrations:**
- Filled icons by default. DuoColorIcon allowed for upsells, empty states, hero content.
- Scene illustrations for major storytelling (hero, education). Spot illustrations for supporting content (value props, upsells, empty states).
- House motifs (Frame, Window, Solid House) are allowed in consumer experiences.

**Tone & Layout:**
- Empathetic, hopeful, action-oriented — voice of an advocate.
- Can be more expressive: large color heroes and illustration-forward layouts OK, but white background + dark text for dense content.

### Professional Brand Rules (Quick Reference)

**Color & Surfaces:**
- White/neutral backgrounds only (`bg.screen.neutral`). Minimal, token-driven palette.
- For section differentiation, use `bg.screen.softest` (NOT `bg.screen.muted` — that token does not exist in PandaCSS and fails silently).
- **Blue** for interactive/actions only. **Waterfront** and **Pool** for depth/selection/feedback.
- **PROHIBITED** for general UI: Purple, Orange, Teal (reserved for data-viz, feedback, or event marketing).

**Icons, Illustrations & Shape:**
- Filled icons by default. Blue action tokens for primary; gray tokens (`icon.subtle`, `icon.muted`) for secondary.
- DuoColorIcon: MAX 1-2 per viewport. ONLY for summary/overview callout cards, empty states, upsell banners, one-off awareness moments. NEVER in metric cards, data cards, status cards, agent cards, list items, or any repeating card pattern — use plain `<Icon size="md" css={{ color: "icon.subtle" }}>` for those.
- **Spot illustrations only** — NO scene illustrations as heroes. Use photography for hero visuals.
- **NEVER** use house motifs in professional layouts.
- Shadows on interactive elements only. No nested shadows. Dark mode: no shadows.

**Component Sizing:**

Consumer defaults:

| Component | Default Size |
|-----------|-------------|
| Buttons, inputs, selects | `size="md"` always |
| Avatar | `size="md"` (40px) |
| Heading | `textStyle="heading-lg"` for page titles |

Professional defaults (matches COMP_P01 in professional brand skill):

| Component | Default Size | Notes |
|-----------|-------------|-------|
| Buttons, inputs, selects, tables | `size="sm"` | Use `size="md"` only for hero CTAs or primary page actions |
| Avatar | `size="sm"` (32px) in sidebars, cards, list items | `size="md"` (40px) only for standalone profile sections |
| Tag, IconButton | `size="sm"` in compact contexts | Sidebars, card footers |
| Heading | `textStyle="heading-md"` for page titles | NOT `heading-lg` — that's the consumer scale |
| Stat/metric values | `textStyle="heading-xs"` | NOT `heading-lg` or `heading-md` |

**Tone & Layout:**
- Confident, precise, calm. Speak to results, performance, reliability.
- Layouts: organized, focused, data-forward. Lots of neutral surface, clear hierarchy, restrained color.
- Tighter spacing than consumer — see Professional spacing table below.

### Brand ALWAYS vs NEVER

| Audience | ALWAYS | NEVER |
|----------|--------|-------|
| **Consumer** | Expressive families (blue, teal, purple, orange) via tokens for heroes and storytelling | Hard-code hex; dump expressive colors on dense content |
| | House motifs + scene/spot illustrations for emotional stories | House motifs in cramped placements or where they obscure legibility |
| | Dense content on white/neutral surfaces with dark text tokens | Long text on strong colored backgrounds |
| **Professional** | Minimal token-driven palette (white + neutrals, blue for actions, limited blues for depth) | Hex codes; color-coding lines of business (e.g., "purple = Rentals") |
| | Spot illustrations, duotone icons, photography of real partners | Consumer scene illustrations as hero; removing beige illustration anchor |
| | Functional, information-dense layouts with subtle elevation | House motifs; multiple bold background colors at once |

---

## Step 5: Build

### Critical Rules (NEVER Violate)

These are the rules that cause the most build errors. They're documented in detail in the skills, but they're listed here because violating them always requires rework:

```
1. PropertyCard → ALWAYS add saveButton={<PropertyCard.SaveButton />}
2. Card → Choose ONE of: elevated or outlined (NEVER both); elevated = interactive; ALWAYS tone="neutral"
   ⚠️ This applies to ALL pages including error/404 pages — don't relax Card rules on utility pages.
3. Headers → Use Flex inside sticky Box (not Page.Header) — see header-navigation skill
4. Dividers → Use borderBottom on header/nav containers (borderBottom: "default", borderColor: "border.muted"); use <Divider /> for content separators (between sections, lists, cards)
   ⚠️ Always pair borderBottom with borderColor — omitting borderColor causes a black border fallback.
5. Icons → ALWAYS Filled variants (e.g., IconWarningFilled, NOT IconWarningOutline), ALWAYS size tokens (sm/md/lg/xl). There are no exceptions — error/warning icons included.
6. Tabs → ALWAYS include defaultSelected prop
7. Heading → ONLY 1-2 per screen; use Text textStyle variants for section/card titles
8. Backgrounds → ALWAYS bg.screen.neutral for page backgrounds. NEVER use bg.canvas — it is not a standard page surface token.
9. Text/Icon color → Use css prop (NOT color prop) for semantic tokens on BOTH Icon and Text: css={{ color: "text.subtle" }}. The color prop may not resolve semantic token paths.
10. On-hero text → Use style prop with CSS variables (NOT css prop): style={{ color: "var(--color-text-on-hero-neutral)" }}
11. Logo sizing → Use style prop (NOT css prop) for pixel values on logos
12. Modal → ALWAYS use body prop for content (NEVER children); default size="md"
13. PropertyCard images → ALWAYS generate via property-card-data skill; NEVER external URLs
14. Page structure → ALWAYS wrap pages in Page.Root > Page.Content; NEVER use manual Box wrappers with maxWidth/mx as a substitute. In sidebar layouts, Page.Root goes inside the content pane (not around the sidebar).
15. Heading level → ALWAYS include level prop (level={1} for page headline, level={2} for section/modal headers)
16. PropertyCard.Badge tone → ONLY "notify" | "neutral" | "buyAbility" | "zillow"; other tone values fail silently
17. Native HTML elements → NEVER use raw HTML form elements (<input>, <select>, <textarea>). ALWAYS use Constellation equivalents (Input, Select, Textarea, RadioGroup, Radio, etc.). If no Constellation component exists for a specific input type (e.g., range slider), wrap it in a styled Box and note the gap explicitly.
18. Custom form controls → NEVER hand-build radio buttons, checkboxes, toggles, or selectors using Flex/Box when Constellation provides RadioGroup, Radio, CheckboxGroup, Checkbox, Switch, SegmentedControl, ToggleButtonGroup. The Constellation components include keyboard navigation, ARIA roles, and focus management that custom builds lack.
19. PandaCSS shorthand → ALWAYS use Panda utility shorthands (p, px, py, m, mx, mb, etc.) instead of raw CSS property names (padding, marginInline, marginBottom). Raw property names may not resolve spacing tokens correctly.
20. Minimum interactive gap → NEVER use spacing tokens below "200" (8px) for gaps between clickable/tappable elements (nav items, buttons, list rows). Tokens "50" and "100" are for text-internal spacing only — not between interactive targets.
21. Professional buttons → Default to text-only. Do NOT add icons to text buttons unless the icon is essential for comprehension (search, download, external link). NEVER conditionally inject an icon (causes layout shift). For icon-only actions, use IconButton.
22. Bold text → NEVER use css={{ fontWeight: 'bold' }} or fontWeight in the css/style prop. ALWAYS use textStyle bold variants: textStyle="body-bold", textStyle="body-lg-bold", textStyle="body-sm-bold". The fontWeight property bypasses the design system's type scale and produces inconsistent weight rendering across platforms.
23. Range/slider inputs → For range or slider inputs, use <Slider> or <Range> from Constellation. These provide accessible keyboard navigation and ARIA roles that raw <input type="range"> lacks. If Slider/Range does not support your use case, wrap the raw input in a styled Box and document the gap explicitly.
```

### New Page Checklist

Before writing any new page or route, verify these are in place:

```
[ ] Page wrapped in <Page.Root> <Page.Content> ... </Page.Content> </Page.Root>
[ ] Page background is bg.screen.neutral (via Page.Root default, not manual)
[ ] Only 1 Heading component on the page (level={1}, textStyle per audience)
[ ] All form inputs use Constellation components (Input, Select, Radio, Textarea, etc.)
[ ] No raw HTML elements (<input>, <select>, <div> as button, etc.)
[ ] All Icons use Filled variants and css={{ color: "..." }} for color
[ ] All Cards use tone="neutral" and EITHER elevated OR outlined (not both)
[ ] All Text/Icon color uses css prop, not color prop
[ ] Logo uses style prop for pixel dimensions, not css prop
[ ] Buttons are text-only by default (professional) — icon only when essential
[ ] No spacing tokens below "200" between clickable elements
[ ] No fontWeight: 'bold' — use textStyle bold variants (body-bold, body-lg-bold, body-sm-bold)
[ ] No raw <input type="range"> — use <Slider> or <Range>
```

---

## CSS & Theming

### CSS Import Order (Critical)

In `src/index.css`:

```css
@layer reset, base, tokens, recipes, utilities;

@import '@zillow/constellation-fonts/zillow-fonts.css';
@import '../styled-system/styles.css';

html, body {
  margin: 0;
  padding: 0;
}
```

The `@layer` directive **must** come first. This establishes CSS cascade ordering so that Constellation's token, recipe, and utility layers resolve in the correct priority.

The `html, body` reset removes default browser margins that cause a visible white gap around the viewport edges.

### Theme Activation

Set `data-panda-theme="zillow"` on `<html>`:

```html
<html lang="en" data-panda-theme="zillow">
```

### Design Tokens

Tokens are accessed via Panda CSS token paths in the `css` prop. The category prefix matching the CSS property type is always implicit — never add it manually.

- **Colors**: `text.primary.default`, `text.subtle`, `text.accent.green.hero`, `text.accent.orange.hero`, `text.action.critical.hero.default`, `background.primary.default`, `bg.softest`, `bg.soft`, `bg.primary.default`
- **Border colors**: `border.muted`
- **Icon colors**: `icon.brand.hero.default`, `icon.neutral.subtle`
- **Spacing**: `tight`, `default`, `loose` (shorthand); also `layout.tight`, `layout.default`, `layout.loose`, `layout.looser` (do NOT prefix with `spacing.` — the category is implicit from the CSS property. Valid layout tokens: `layout.tightest`, `layout.tighter`, `layout.tight`, `layout.default`, `layout.loose`, `layout.looser`, `layout.loosest`)
- **Border radius**: `obj.default`, `obj.soft`
- **Typography**: handled by component `level` and `textStyle` props

### Token Usage in the `css` Prop

#### Spacing tokens: NEVER prefix with `spacing.`

In Panda CSS, the `css` prop automatically infers the token category from the CSS property. For spacing properties (`padding`, `margin`, `gap`, etc.), the `spacing` category is implicit.

```tsx
// WRONG — literal string "spacing.layout.default" in CSS output
<Box css={{ padding: 'spacing.layout.default', gap: 'spacing.tight' }} />

// CORRECT — resolves to var(--spacing-layout-default), var(--spacing-tight)
<Box css={{ padding: 'layout.default', gap: 'tight' }} />
```

#### Layout spacing scale: use semantic names, NOT size abbreviations

| Token name | CSS variable | Value |
|---|---|---|
| `layout.tightest` | `var(--spacing-layout-tightest)` | `var(--spacing-200)` ≈ 8px |
| `layout.tighter` | `var(--spacing-layout-tighter)` | `var(--spacing-300)` ≈ 12px |
| `layout.tight` | `var(--spacing-layout-tight)` | `var(--spacing-400)` ≈ 16px |
| `layout.default` | `var(--spacing-layout-default)` | `var(--spacing-600)` ≈ 24px |
| `layout.loose` | `var(--spacing-layout-loose)` | `var(--spacing-800)` ≈ 32px |
| `layout.looser` | `var(--spacing-layout-looser)` | `var(--spacing-1200)` ≈ 48px |
| `layout.loosest` | `var(--spacing-layout-loosest)` | `var(--spacing-1400)` ≈ 56px |

```tsx
// WRONG — layout.lg and layout.xl do NOT exist
<Box css={{ padding: 'layout.lg', gap: 'layout.xl' }} />

// CORRECT
<Box css={{ padding: 'layout.loose', gap: 'layout.looser' }} />
```

### Token Resolution Rules

| Token category | Works in css prop? | Use instead |
|---|---|---|
| `bg.screen.*` | YES | `css={{ bg: "bg.screen.neutral" }}` |
| `bg.softest`, `bg.softer` | YES | `css={{ bg: "bg.softest" }}` |
| `text.subtle`, `text.muted` | YES | `css={{ color: "text.subtle" }}` |
| `border.muted` | YES | `css={{ borderColor: "border.muted" }}` |
| Spacing (`200`, `400`, etc.) | YES | `css={{ p: "400" }}` |
| `bg.surface.brand.*` | NO | `style={{ backgroundColor: "var(--color-bg-accent-teal-hero)" }}` |
| `icon.brand.*` | NO | `style={{ color: "var(--color-icon-accent-teal-strong)" }}` |
| `text.on-hero.*` | NO | `style={{ color: "var(--color-text-on-hero-neutral)" }}` |
| Any accent/expressive color | NO | Use `--color-*` CSS variables in `style` prop |

**Token syntax:**
```tsx
// In css() or JSX props: use token value only (NO prefix)
<Box bg="bg.default" p="400" borderRadius="node.md" />

// In token() function: use full path WITH prefix
token('spacing.400')
```

### Background Color Usage

- Use `bg.primary.default` for the main page background (white).
- Reserve `bg.softest` for interior sections that need subtle contrast against the page.
- Use `bg.soft` sparingly for small accent elements (icon containers, badges, stat rows).
- Avoid stacking grey backgrounds (e.g., `bg.softest` page with `bg.soft` headers) — this makes the entire UI feel overly grey.

---

## Provider Configuration

### Vite Config: `@/styled-system` Alias (Critical)

Constellation components internally import from `@/styled-system/css`. Your Vite config **must** alias this:

```ts
resolve: {
  alias: {
    "@/styled-system": path.resolve(import.meta.dirname, "styled-system"),
    "@": path.resolve(import.meta.dirname, "src"),
  },
  dedupe: ["react", "react-dom"],
},
```

Order matters — `@/styled-system` must come before `@`.

### `fs.strict: false` in Vite

Required because Constellation resolves files outside the `src/` directory (the `styled-system/` directory is at the artifact root).

```ts
server: {
  fs: { strict: false },
},
```

### PORT and BASE_PATH Environment Variables

The Vite config uses `PORT` and `BASE_PATH` environment variables. Always use fallback defaults instead of throwing on missing values:

```ts
const port = Number(process.env.PORT) || 5173;
const basePath = process.env.BASE_PATH || "/";
```

This prevents build failures in CI or local dev environments where these may not be set.

### ToastProvider

When using `Toast` and `useToast()`, wrap the app (or the section that uses toasts) with `<ToastProvider>`:

```tsx
import { ToastProvider, Toast, useToast } from '@zillow/constellation';

function App() {
  return (
    <ToastProvider placement="bottom-end">
      <MyPage />
    </ToastProvider>
  );
}
```

Inside a child component:

```tsx
const { enqueueToast } = useToast();
enqueueToast(<Toast tone="success">Saved successfully.</Toast>);
```

### No `<StrictMode>` in main.tsx

The template's `main.tsx` renders without React StrictMode. This is intentional — some Constellation components may double-fire effects in StrictMode during development.

---

## Typography Hierarchy

Reserve `Heading` for 1-2 true headlines per screen. Use `Text` with textStyle variants for all other hierarchy.

**Consumer typography:**

| Content Type | Component + textStyle | Color |
|--------------|----------------------|-------|
| Page headline | `<Heading level={1} textStyle="heading-lg">` | default |
| Section title | `<Text textStyle="body-lg-bold">` | default |
| Card title | `<Text textStyle="body-bold">` | default |
| Description | `<Text textStyle="body">` | `text.subtle` |
| Fine print/hints | `<Text textStyle="body-sm">` | `text.subtle` |

**Professional typography** (compact, data-forward):

| Content Type | Component + textStyle | Color |
|--------------|----------------------|-------|
| Page headline | `<Heading level={1} textStyle="heading-md">` | default |
| Stat/metric value | `<Text textStyle="heading-xs">` | default |
| Metric card label | `<Text textStyle="body-sm">` | `text.subtle` |
| Section title | `<Text textStyle="body-lg-bold">` | default |
| Card title | `<Text textStyle="body-bold">` | default |
| Description | `<Text textStyle="body">` | `text.subtle` |
| Fine print/hints | `<Text textStyle="body-sm">` | `text.subtle` |

**Professional typography in compact contexts** (tables, metric cards, compact nav):

| Context | Primary text | Secondary text |
|---------|-------------|---------------|
| Standard layout | `body` | `body-sm` with `text.subtle` |
| Compact / table / card | `body-sm` (bold via `fontWeight: 600` for emphasis) | `body-sm` with `text.subtle` |
| Metric card value | `heading-xs` | — |
| Metric card label | `body-sm` with `text.subtle` | — |

---

## Token Quick Reference

### Consumer Spacing Tokens

| Context | Token | Value |
|---------|-------|-------|
| Page padding (sides) | `400` | 16px |
| Page padding (top/bottom) | `600` | 24px |
| Section gaps | `800` | 32px |
| Card internal padding | `400` | 16px |
| Grid gaps between items | `400` | 16px |
| Tight list spacing | `200` | 8px |
| Comfortable list spacing | `300` | 12px |

### Professional Spacing — Standard (settings pages, onboarding, landing pages)

| Context | Token | Value |
|---------|-------|-------|
| Page padding (sides) | `400` | 16px |
| Page padding (top/bottom) | `600` | 24px |
| Section gaps | `600` | 24px |
| Card internal padding | `400` | 16px |
| Grid gaps between items | `300` | 12px |

### Professional Spacing — Dense (dashboards, data tables, admin tools, CRM)

| Context | Token | Value |
|---------|-------|-------|
| Page padding (sides) | `400` | 16px |
| Page padding (top/bottom) | `400` | 16px |
| Section gaps | `400` | 16px |
| Card internal padding | `300` | 12px |
| Grid gaps between items | `200` | 8px |
| Tab panel top padding | `300` | 12px |
| Sidebar logo area padding | `py="300"` | 12px |
| Sidebar footer padding | `py="200"` | 8px |

**When to use dense vs standard spacing:**
- **Dense** (default for professional product UI): Dashboards, data tables, admin tools, CRM-style interfaces, or any layout where the primary content is tabular or metric-driven.
- **Standard**: Landing pages, onboarding flows, settings pages, or any layout where readability and visual breathing room matter more than density.

### Breakpoint Tokens

| Token (for `maxWidth`) | Breakpoint condition | Value |
|------------------------|---------------------|-------|
| `"breakpoint-sm"` | `sm` / `smDown` | 320px |
| `"breakpoint-md"` | `md` / `mdDown` | 480px |
| `"breakpoint-lg"` | `lg` / `lgDown` | 768px |
| `"breakpoint-xl"` | `xl` / `xlDown` | 1024px |
| `"breakpoint-xxl"` | `xxl` / `xxlDown` | 1280px |

`Page.Root` defaults to `maxWidth: "breakpoint-xxl"` (1280px). Use `<Page.Root fluid>` for full-bleed.

### Color Family Roles

| Family | Role | Usage |
|--------|------|-------|
| **Blue** | Interactive only | Buttons, links, primary actions. NEVER headlines or decorative backgrounds. |
| **Teal** | Trust / finance | Agent connections, home loans, financial features. |
| **Orange** | Urgency / alerts | "New" badges, "Open House" pins, time-sensitive callouts. |
| **Purple** | Inspiration / news | "New Features" highlights, educational content accents. |

---

## Code Pattern Gotchas

### Text/Icon color — use css prop, NOT color prop (applies to both Text and Icon)

```tsx
// WRONG — color prop doesn't resolve token paths
<Icon size="md" color="icon.neutral"><IconHeartFilled /></Icon>
<Text color="text.subtle">Label</Text>

// CORRECT — use css prop for semantic tokens
<Icon size="md" css={{ color: 'icon.neutral' }}><IconHeartFilled /></Icon>
<Text css={{ color: 'text.subtle' }}>Label</Text>

// FALLBACK — use style prop with CSS variables
<Icon size="md" style={{ color: 'var(--color-icon-subtle)' }}><IconHeartFilled /></Icon>
```

### On-hero text — use style prop with CSS variables, NOT css prop

```tsx
// WRONG — PandaCSS outputs literal string
<Heading css={{ color: "text.on-hero.neutral" }}>...</Heading>

// CORRECT — use style prop with CSS variable
<Heading style={{ color: "var(--color-text-on-hero-neutral)" }}>...</Heading>
```

> **CSS variable prefix note:** Constellation CSS variables use `--color-` (singular), NOT `--colors-` (plural). For example: `var(--color-text-on-hero-neutral)`, `var(--color-icon-subtle)`. Using `--colors-` will silently fail with no value resolved.

### Expressive color backgrounds — PandaCSS does NOT resolve brand surface tokens

Tokens like `bg.surface.brand.teal` do NOT resolve through PandaCSS's `css` prop. They exist as CSS variables but are not mapped in the PandaCSS preset. You must use the `style` prop with the raw CSS variable.

```tsx
// WRONG — PandaCSS does not resolve this token
<Box css={{ bg: "bg.surface.brand.teal" }}>...</Box>

// CORRECT — use style prop with CSS variable
<Box style={{ backgroundColor: "var(--color-bg-surface-brand-teal-soft)" }}>...</Box>
```

### 9 Accent Background CSS Variables

| Family | Soft | Hero | Impact |
|--------|------|------|--------|
| **Teal** | `var(--color-bg-surface-brand-teal-soft)` | `var(--color-bg-surface-brand-teal-hero)` | `var(--color-bg-surface-brand-teal-impact)` |
| **Purple** | `var(--color-bg-surface-brand-purple-soft)` | `var(--color-bg-surface-brand-purple-hero)` | `var(--color-bg-surface-brand-purple-impact)` |
| **Orange** | `var(--color-bg-surface-brand-orange-soft)` | `var(--color-bg-surface-brand-orange-hero)` | `var(--color-bg-surface-brand-orange-impact)` |

### Matching Icon/Text CSS Variables for On-Hero Content

| Token type | CSS variable |
|------------|-------------|
| Text (neutral) | `var(--color-text-on-hero-neutral)` |
| Text (subtle) | `var(--color-text-on-hero-subtle)` |
| Icon (neutral) | `var(--color-icon-on-hero-neutral)` |
| Icon (subtle) | `var(--color-icon-on-hero-subtle)` |

Use these icon/text variables with the `style` prop on any content placed over hero or impact backgrounds.

### Icon Naming Exceptions

Some icon names don't follow the obvious pattern:

| You might expect | Actual name |
|-----------------|-------------|
| `IconStarFilled` | `IconStar100Percent` |
| `IconHomeFilled` | `IconHomesFilled` |
| `IconCheckFilled` | `IconCheckmarkFilled` |
| `IconChatFilled` | `IconMessageFilled` |
| `IconQuestionCircleFilled` | `IconQuestionMarkCircleFilled` |

When in doubt, check the filled icons directory at `node_modules/@zillow/constellation-icons/dist/filled/` to verify the exact name. Using a wrong name will cause a build error or silent import failure.

### Button Icons — Professional Apps Default to Text-Only

- **Professional:** Do NOT add icons to text buttons by default. Text-only buttons are cleaner and more functional. Only add an icon when it is essential for comprehension (e.g., search, download, external link).
- **Consumer:** Icons on text buttons are acceptable when they aid clarity, but still use sparingly.

```tsx
// PREFERRED (professional) — text-only button
<Button size="sm">Search</Button>

// OK when icon is essential for comprehension (both audiences)
<Button icon={<IconSearchFilled />} iconPosition="start">Search</Button>

// Icon-only button — ALWAYS use IconButton
<IconButton title="Close" tone="neutral" emphasis="bare" size="md" shape="square">
  <Icon><IconCloseFilled /></Icon>
</IconButton>

// WRONG — don't wrap icons and text in Flex inside Button
<Button><Flex><Icon><IconSortFilled /></Icon><Text>Sort</Text></Flex></Button>
```

### Card Styling — Choose ONE, Never Combine elevated + outlined

```tsx
// Clickable card — elevated + interactive
<Card elevated interactive tone="neutral" onClick={handleClick}>
  <Paragraph>Click to navigate</Paragraph>
</Card>

// Static display card — outlined, no elevation
<Card outlined elevated={false} tone="neutral">
  <Paragraph>Read-only information</Paragraph>
</Card>

// Minimal card — no emphasis
<Card elevated={false} tone="neutral">
  <Paragraph>Subtle container</Paragraph>
</Card>
```

### Modal — ALWAYS Use body Prop, NEVER children

```tsx
<Modal
  size="md"
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Modal title</Heading>}
  body={
    <Flex direction="column" gap="300">
      <Text>Content goes in body prop for proper spacing</Text>
    </Flex>
  }
  footer={
    <ButtonGroup aria-label="modal actions">
      <Modal.Close><TextButton>Cancel</TextButton></Modal.Close>
      <Button emphasis="filled" tone="brand">Save</Button>
    </ButtonGroup>
  }
/>
```

### Sticky Header — Contained Pattern

```tsx
<Box css={{ position: "sticky", display: "flow-root", top: 0, zIndex: 10, bg: "bg.screen.neutral", borderBottom: "default", borderColor: "border.muted" }}>
  <Flex align="center" justify="space-between" css={{ maxWidth: "breakpoint-xxl", mx: "auto", width: "100%", px: "400", py: "400" }}>
    {/* logo + nav */}
  </Flex>
</Box>
```

### Tables — Horizontal Layout Inside a Card, Inherit sm Sizing

- Default to horizontal (row-based) tables. Use `<Table size="sm">` for professional apps.
- Wrap tables in a `Card outlined elevated={false} tone="neutral"` for visual grouping.
- Elements inside a `size="sm"` table inherit the sm scale — do NOT override child font sizes, Icon sizes, Tag sizes, or Button sizes. They should remain at the table's inherited size.
- Use `body-sm` for cell text. Bold via `fontWeight: 600` for emphasis columns, not a larger textStyle.

```tsx
<Card outlined elevated={false} tone="neutral">
  <Table size="sm">
    <Table.Header>
      <Table.Row>
        <Table.HeaderCell>Name</Table.HeaderCell>
        <Table.HeaderCell>Status</Table.HeaderCell>
        <Table.HeaderCell>Actions</Table.HeaderCell>
      </Table.Row>
    </Table.Header>
    <Table.Body>
      <Table.Row>
        <Table.Cell><Text textStyle="body-sm" css={{ fontWeight: 600 }}>Jane Doe</Text></Table.Cell>
        <Table.Cell><Tag size="sm" tone="notify">Active</Tag></Table.Cell>
        <Table.Cell><IconButton size="sm" title="Edit" tone="neutral" emphasis="bare"><Icon size="sm"><IconEditFilled /></Icon></IconButton></Table.Cell>
      </Table.Row>
    </Table.Body>
  </Table>
</Card>
```

---

## Component Selection Quick Reference

For full component API details, load the `constellation-design-system` skill.

| Building this? | Use this | Not this |
|----------------|----------|----------|
| Property listing | `PropertyCard` with `saveButton` + generated images | `Card`; external image URLs |
| Generic container | `Card tone="neutral"` (elevated or outlined) | custom `Box` |
| Header | Flex in sticky Box (see pattern above) | `Page.Header` directly |
| Modal/Dialog | `Modal` with `body` prop | Custom overlay |
| Single-select (price, beds) | `ToggleButtonGroup` + `ToggleButton` | `Button` |
| Segmented choices | `SegmentedControl` | `Button` group |
| Multi-select | `ComboBox` (preferred) or `CheckboxGroup` | `Button` or custom checkboxes |
| Form inputs | `Select`, `ComboBox`, `Checkbox`, `Radio`, `Input` | styled divs |
| Visual separator (content) | `<Divider />` | CSS `border` |
| Visual separator (header edge) | `borderBottom: "default"` + `borderColor: "border.muted"` on container Box | `<Divider />` child |
| Page headline (1-2 max) | `Heading textStyle="heading-lg"` (consumer) or `"heading-md"` (professional) | Multiple `Heading` |
| Section title | `Text textStyle="body-lg-bold"` | `Heading` for every title |
| Card title | `Text textStyle="body-bold"` | `Heading` |
| Body text | `Text textStyle="body"` | `<p>` or `<span>` |
| Layout stacking | `Flex direction="column"` | `Box` with margin |
| Labels/badges/tags (display-only) | `<Tag size="sm" tone="blue" css={{ whiteSpace: 'nowrap' }}>` | custom Box with bg/borderRadius |
| Toggleable filter/selection | `FilterChip` | `Tag` with onClick (Tag is display-only) |
| Empty states / upsells | `<DuoColorIcon tone="trust" onBackground="default"><Icon><IconXxxFilled /></Icon></DuoColorIcon>` | `IconXxxDuotone` (doesn't exist) |
| Button with text + icon | Text-only by default (professional); `<Button icon={<IconX />} iconPosition="start">` only when icon aids comprehension | Icons on every text button; Flex wrapping icon + text inside Button |
| Icon-only button | `<IconButton title="Label" tone="neutral" emphasis="bare" size="md" shape="square">` | `<Button icon={<IconX />}>` without text |
| Data table | `<Table size="sm">` inside `Card outlined` | Vertical table; custom `div` grids; overriding child sizes inside table |
| Secondary actions | Outlined or subtle button variants | Filled buttons for everything |

---

## Standard Imports

```tsx
import {
  Button, Card, Text, Heading, Input, Tabs, PropertyCard, ZillowLogo,
  Icon, Divider, Select, Checkbox, Radio, ToggleButtonGroup, ToggleButton,
  SegmentedControl, CheckboxGroup
} from '@zillow/constellation';

import { IconHeartFilled, IconSearchFilled, IconHomesFilled } from '@zillow/constellation-icons';

import { css } from '@/styled-system/css';
import { Box, Flex, Grid } from '@/styled-system/jsx';
```

---

## Component Quick Reference (Gotchas Only)

For full component APIs, load the individual doc at `references/components/<Name>.md`. This section covers only the patterns that cause the most errors.

**CSS prop** — all components accept `css` for Panda CSS inline styles:
```tsx
<Box css={{ display: 'flex', gap: 'layout.default', p: 'layout.loose' }} />
```

**Responsive styles** — use object syntax for breakpoints:
```tsx
<Box css={{ gridTemplateColumns: { base: '1fr', md: 'repeat(2, 1fr)', lg: 'repeat(4, 1fr)' } }} />
```

**Button** — uses `tone` + `emphasis` (not `variant`):
```tsx
<Button tone="brand" emphasis="filled">Primary</Button>
<Button tone="neutral" emphasis="outlined">Secondary</Button>
```

**Flex is DEPRECATED** — does NOT apply `display: flex` automatically. Use `Box` with `css={{ display: 'flex' }}`.

**Switch** — use `e.currentTarget.checked`, not `e.target.checked`.

**Form components** — use `LabeledInput`, `LabeledControl`, `FormField` for label+control combos. Use `FieldSet` + `Legend` for grouped fields.

**Tag tones** — `success`, `warning`, `blue`, `critical`, `gray`, `notify`, `neutral`.

**Avatar tones** — `default`, `brand-hero`, `accent-1`, `accent-2`, `accent-3`, `accent-4`.

---

## Common Pitfalls

1. **`styled-system/styles.css` must exist before build**: Create an empty file with `touch styled-system/styles.css` after running `panda codegen`. The PostCSS plugin fills it at build time, but Vite's CSS resolver and import resolution need the file to exist on disk first.

2. **Prepare script must include `panda cssgen`**: Use `"prepare": "panda codegen --clean && panda cssgen"` — never just `panda codegen --clean` alone. The `--clean` flag wipes the directory, and without `cssgen`, `styles.css` will be missing on every workflow restart causing `ENOENT` errors.

3. **Always use fallback defaults for PORT and BASE_PATH**: Never throw on missing env vars that have reasonable defaults. Use `Number(process.env.PORT) || 5173` and `process.env.BASE_PATH || "/"`.

4. **Body margin reset is required**: Without `html, body { margin: 0; padding: 0; }` in `index.css`, a small white gap appears around the viewport edges from the browser's default body margin.

5. **CSS `@layer` must be first**: If the `@layer` directive is not the very first line in `index.css`, component styles may resolve in wrong order causing visual bugs.

6. **Panda codegen must run before build**: Without the `styled-system/` directory, imports will fail. The `"prepare"` script handles this on install, but if you see missing module errors for `@/styled-system/*`, re-run `npx panda codegen --clean`.

7. **Peer dep warning for `date-fns@^4.1.0`**: Unmet peer dep (workspace has 3.6.0). Non-blocking for most components; only affects DatePicker/Calendar.

8. **Storybook + Vite 7**: Storybook 8.x warns about Vite 7 peer dep compatibility. Works fine in practice.

9. **Flex is deprecated**: `Flex` does NOT apply `display: flex` automatically and does NOT accept layout props (`direction`, `alignItems`, `justifyContent`) as direct props. These props are silently ignored. Use `Box` with `css={{ display: 'flex' }}` instead.

10. **Verify icon names before using them**: The constellation-icons package has 621 icons but names are specific and cannot be guessed. Common mistakes: `IconChatFilled` (use `IconMessageFilled`), `IconQuestionCircleFilled` (use `IconQuestionMarkCircleFilled`). The naming convention is `Icon<ExactName>Filled` or `Icon<ExactName>Outline` — always check actual exports.

11. **Artifact limit is 7**: Plan accordingly when building sample apps. If you need more apps than slots available, some may need to share an artifact or remain build-only.

---

## Step 6: Review and Deliver

### 6A. Architect review (required)

After every UI build, request an architect review against these instructions and the loaded skills. Fix all violations before delivery.

### 6B. Accessibility check

Load the `accessibility` skill and verify WCAG 2.2 Level AA compliance. Key checks:
- Keyboard navigation works
- Focus management is correct
- ARIA labels are present
- Color contrast meets requirements
- Touch targets are at least 44x44px

### 6C. Verify before delivering

- App runs without errors
- All critical rules from Step 5 are satisfied
- Brand rules from Step 4 match the audience
- APP_NAME and APP_DESCRIPTION env vars are set (shared environment)
- Replit project Name and Description updated (not the template defaults)
- No placeholder data or mocked content remains

---

## Reference Catalogs

Detailed catalogs live inside the skills — load the relevant skill when you need to search:

| What you need | Load this skill | Reference file |
|---------------|----------------|----------------|
| 99 Constellation components | `constellation-design-system` | `references/components/` (individual component docs) |
| 621 icons by category | `constellation-icons` | `reference/icon-catalog.md` |
| 99 spot illustrations | `constellation-illustrations` | `reference/illustration-catalog.md` |
| UX writing, voice & tone, microcopy | `constellation-content` | `SKILL.md` + `references/copy-patterns.md`, `references/terminology.md`, `references/ai-behavioral-guidance.md` |
