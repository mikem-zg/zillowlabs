---
name: header-navigation
description: Build Constellation header and navigation patterns for Zillow apps. Covers 11 header variations (basic, sticky, search, mobile-responsive, professional, tabs, sidebar, breadcrumb, centered logo, no-divider, contained) with correct component defaults, responsive logo swap, menu collapse, maxWidth alignment, and no-wrap rules. All patterns include maxWidth + mx auto on the inner Flex so header and page content widths always match. Use when building headers, navigation bars, app shells, or top-level page layouts.
---

# Header Navigation

Provides tested header patterns using Constellation components. Each pattern handles responsive behavior, accessibility, and graceful collapse of navigation links behind a menu icon.

## Prerequisites

- `@zillow/constellation` installed (provides `ZillowLogo`, `ZillowHomeLogo`, `Button`, `TextButton`, `IconButton`, `Divider`, `Avatar`)
- `@zillow/constellation-icons` installed (provides `IconMenuFilled`, `IconSearchFilled`, `IconNotificationFilled`, etc.)
- PandaCSS configured with Constellation preset (for `Flex`, `Box`, responsive breakpoints)

## When to Use

- Building a top-level header or navigation bar for a Zillow app
- Implementing sticky headers, responsive logo swaps, or menu collapse behavior
- Adding search bars, tab navigation, or sidebar toggles to a header
- Choosing between header variations (basic, professional, centered logo, breadcrumb, etc.)

## When NOT to Use

- **Building non-header UI** (cards, forms, modals, property listings) — use `constellation-design-system`
- **Looking up a specific icon for the header** — use `constellation-icons` to find the right icon name first
- **Implementing sidebar or vertical navigation** — this skill covers header-level navigation only; see `constellation-design-system` for `VerticalNav` patterns

## Component Defaults (Headers)

| Component | Default Props |
|-----------|--------------|
| **TextButton** | `textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}` |
| **Button** | `size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}` |
| **IconButton** | `tone="neutral" emphasis="bare" size="sm" shape="circle"` |
| **Icon** | `size="md"` (always — controls icon graphic, not button size) |
| **Avatar** | `Avatar.Root size="sm"` + `Avatar.Image src="..." alt="..."` |
| **Divider** | `tone="muted-alt"` (or omit for seamless variant) |
| **Input** | `size="sm"` |
| **Logo** | `ZillowLogo` at 24px on `md+`, `ZillowHomeLogo` at 24px on `base` |

## Critical Rules

1. **Never wrap text** — all TextButton, Button, and nav links MUST use `css={{ whiteSpace: "nowrap" }}`
2. **Never use `!important`** — use plain `Flex` with spacing tokens instead of `Page.Header` + className overrides
3. **Collapse gracefully** — hide nav links at breakpoints, show `IconMenuFilled` menu icon instead
4. **Responsive logo** — swap `ZillowLogo` (desktop) for `ZillowHomeLogo` (mobile) at `md` breakpoint
5. **Divider not border** — always use `<Divider tone="muted-alt" />`, never CSS border
6. **Match maxWidth** — the header's inner Flex MUST use the same `maxWidth` + `mx: "auto"` as the page content. Use a Constellation breakpoint size token (e.g., `"breakpoint-xxl"` = 80em) — NEVER hardcode pixel values. The sticky `Box` wrapper stays full-bleed for the background color.

## Layout Pattern

```tsx
<Flex align="center" justify="space-between" css={{ maxWidth: "breakpoint-xxl", mx: "auto", width: "100%", px: "400", py: "400" }}>
  {/* left: logo + nav links */}
  {/* right: actions + menu icon fallback */}
</Flex>
<Divider tone="muted-alt" />
```

**Header vertical padding:**

| Context | Token | Value | When to use |
|---------|-------|-------|-------------|
| Compact header | `py: "300"` | 12px | Dense professional dashboards, minimal headers |
| Standard header | `py: "400"` | 16px | Consumer apps, default recommendation |

Default to `py: "400"` for consumer-facing apps. Use `py: "300"` only when a more compact header is needed in professional or data-dense layouts.

**Sticky wrapper:**
```tsx
<Box css={{ position: "sticky", display: "flow-root", top: 0, zIndex: 10, background: "bg.screen.neutral" }}>
  {/* header content + divider inside */}
</Box>
```

**Contained sticky wrapper** (when page content has a max-width):
```tsx
<Box css={{ position: "sticky", display: "flow-root", top: 0, zIndex: 10, background: "bg.screen.neutral" }}>
  <Flex
    align="center"
    justify="space-between"
    css={{ maxWidth: "breakpoint-xxl", mx: "auto", width: "100%", px: "400", py: "400" }}
  >
    {/* left: logo + nav links */}
    {/* right: actions + menu icon fallback */}
  </Flex>
  <Divider tone="muted-alt" />
</Box>
```

**Key rules:**
- Always match the header content's `maxWidth` to the page content's `maxWidth` using a breakpoint size token
- The sticky `Box` wrapper remains full-bleed for the background color; only the inner layout container is constrained
- Default to `py: "400"` for consumer apps, `py: "300"` for compact professional headers

**Nav link container:** `gap="400"` (16px), hidden below `lg`, menu icon shown instead.

**Menu icon fallback:**
```tsx
<Box css={{ display: { base: "block", lg: "none" } }}>
  <IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
    <Icon size="md"><IconMenuFilled /></Icon>
  </IconButton>
</Box>
```

## TextButton Variations

Default is `textStyle="body" tone="neutral"`. Other options:

| textStyle | tone="neutral" | tone="brand" |
|-----------|---------------|--------------|
| `body` | Default nav links | Emphasized links |
| `body-bold` | Bold nav links | Bold emphasized |
| `body-sm` | Compact nav | Compact emphasized |
| `body-lg` | Large nav | Large emphasized |
| `body-lg-bold` | Large bold nav | Large bold emphasized |

## Available Patterns

11 header variations with full code examples:

| Pattern | Key Features | Audience |
|---------|-------------|----------|
| Basic consumer | Logo + nav + sign-in + menu fallback | Consumer |
| Sticky consumer | Box wrapper sticky positioning | Consumer |
| Search bar | Integrated Input in header | Consumer |
| Mobile-responsive | Hamburger menu + dropdown panel | Consumer |
| Professional | IconButtons + Avatar + menu fallback | Professional |
| Tabs navigation | Header + Tabs.Root below | Both |
| Sidebar | Minimal header + VerticalNav sidebar | Professional |
| Breadcrumb | Header + Page.Breadcrumb + detail heading | Both |
| Centered logo | Three-column layout, logo centered | Consumer |
| No divider | Clean seamless header | Consumer |
| Contained | Explicit page-content alignment example with matching maxWidth | Both |

> **Note:** All 11 patterns include `maxWidth: "breakpoint-xxl", mx: "auto"` on the inner Flex by default. Adjust the breakpoint size token to match your page content width. NEVER hardcode pixel values — use Constellation breakpoint tokens (`breakpoint-sm`, `breakpoint-md`, `breakpoint-lg`, `breakpoint-xl`, `breakpoint-xxl`). The sticky `Box` wrapper stays full-bleed; only the inner layout container is constrained.

## Related Constellation Skills

- **[constellation-design-system](../constellation-design-system/SKILL.md)**: Core design system rules, all 99 component docs, UX writing guidelines, and layout patterns. **Load this skill for component usage, spacing tokens, and design rules.**
- **[constellation-icons](../constellation-icons/SKILL.md)**: Full catalog of 621 icons with color tokens, sizing, and implementation guides. **Load this skill when choosing header icons** (menu, search, notifications, settings).
- **[constellation-dark-mode](../constellation-dark-mode/SKILL.md)**: Theme injection, dark mode toggle patterns, and design token tiers. **Load this skill when implementing dark mode** — headers use `bg.screen.neutral` which adapts automatically.
- **[responsive-design](../responsive-design/SKILL.md)**: Mobile-first responsive layouts, PandaCSS breakpoint tokens, and touch targets. **Load this skill for responsive header behavior** beyond the patterns included here.

## Resources

- **Full code examples**: See [references/header-patterns.md](references/header-patterns.md) for all 11 patterns
- **Component defaults detail**: See [references/component-defaults.md](references/component-defaults.md) for prop tables and avatar/logo patterns
