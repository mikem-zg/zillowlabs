---
name: header-navigation
description: Build Constellation header and navigation patterns for Zillow apps. Covers 10 header variations (basic, sticky, search, mobile-responsive, professional, tabs, sidebar, breadcrumb, centered logo, no-divider) with correct component defaults, responsive logo swap, menu collapse, and no-wrap rules. Use when building headers, navigation bars, app shells, or top-level page layouts.
---

# Header Navigation

Provides tested header patterns using Constellation components. Each pattern handles responsive behavior, accessibility, and graceful collapse of navigation links behind a menu icon.

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

## Layout Pattern

```tsx
<Flex align="center" justify="space-between" css={{ width: "100%", px: "400", py: "300" }}>
  {/* left: logo + nav links */}
  {/* right: actions + menu icon fallback */}
</Flex>
<Divider tone="muted-alt" />
```

**Sticky wrapper:**
```tsx
<Box css={{ position: "sticky", display: "flow-root", top: 0, zIndex: 10, background: "bg.screen.neutral" }}>
  {/* header content + divider inside */}
</Box>
```

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

10 header variations with full code examples:

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

## Resources

- **Full code examples**: See [references/header-patterns.md](references/header-patterns.md) for all 10 patterns
- **Component defaults detail**: See [references/component-defaults.md](references/component-defaults.md) for prop tables and avatar/logo patterns
