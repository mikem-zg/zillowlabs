---
name: header-navigation
description: Build Constellation header and navigation patterns for Zillow apps. Covers 10 header variations (basic, sticky, search, mobile-responsive, professional, tabs, sidebar, breadcrumb, centered logo, no-divider) with correct component defaults, responsive logo swap, Menu component for mobile nav, AdornedInput for search, and Box-based layouts with semantic spacing tokens. Use when building headers, navigation bars, app shells, or top-level page layouts.
---

# Header Navigation

Provides tested header patterns using Constellation components. Each pattern handles responsive behavior, accessibility, and graceful collapse of navigation links behind a Menu component.

## Prerequisites

- `@zillow/constellation` installed (provides `Box`, `ZillowLogo`, `ZillowHomeLogo`, `Button`, `TextButton`, `IconButton`, `Menu`, `AdornedInput`, `Avatar`)
- `@zillow/constellation-icons` installed (provides `IconMenuFilled`, `IconSearchFilled`, `IconNotificationFilled`, etc.)
- PandaCSS configured with Constellation preset (for responsive breakpoints, semantic tokens)

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
| **TextButton** | `textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild` + `<a href="#">` |
| **Button** | `size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}` |
| **IconButton** | `tone="neutral" emphasis="bare" size="sm" shape="circle"` |
| **Icon** | `size="md"` (always — controls icon graphic, not button size) |
| **Avatar** | `Avatar.Root size="sm"` + `Avatar.Image src="..." alt="..."` |
| **Logo** | `ZillowLogo` at 24px on `md+`, `ZillowHomeLogo` at 24px on `base` |

## Critical Rules

1. **Never use `@/styled-system/jsx`** — import `Box` from `@zillow/constellation`, never `Flex` or `Grid` from `@/styled-system/jsx`
2. **Never use shorthand CSS props** — use `paddingX` not `px`, `paddingY` not `py`, `marginTop` not `mt`
3. **Use semantic spacing tokens** — `"default"`, `"tight"`, `"tighter"`, `"loose"` instead of numeric tokens
4. **Never wrap text** — all TextButton, Button, and nav links MUST use `css={{ whiteSpace: "nowrap" }}`
5. **borderBottom not Divider** — use `borderBottom: "default"` + `borderColor: "border.muted"` on header container, never `<Divider />` for headers
6. **TextButton nav links use asChild** — wrap with `<a href="#">` for proper anchor semantics
7. **Wrap nav links in `<nav>`** — use `Box asChild` + `<nav>` for accessible navigation landmark
8. **Menu for mobile nav** — use `Menu` component with `Menu.Group` for grouped mobile navigation, not custom dropdown panels
9. **AdornedInput for search** — use `AdornedInput` with `IconButton` end adornment, not plain `Input`
10. **Collapse gracefully** — hide nav links at breakpoints, show menu icon instead
11. **Responsive logo** — both logos in one `Box`, toggled via responsive `display`

## Layout Pattern

```tsx
<Box
  css={{
    display: "flex",
    alignItems: "center",
    justifyContent: "space-between",
    width: "100%",
    paddingX: "default",
    paddingY: "tight",
    borderBottom: "default",
    borderColor: "border.muted",
  }}
>
  {/* left: logo + nav links */}
  {/* right: actions + menu icon fallback */}
</Box>
```

**Responsive logo swap (simplified):**
```tsx
<Box>
  <ZillowLogo role="img"
    css={{ display: { base: "none", md: "block" }, height: "24px", width: "auto" }} />
  <ZillowHomeLogo role="img"
    css={{ display: { base: "block", md: "none" }, height: "24px", width: "auto" }} />
</Box>
```

**Nav links with anchor semantics:**
```tsx
<Box css={{ display: { base: "none", lg: "flex" }, gap: "default" }} asChild>
  <nav>
    <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
      <a href="#">Buy</a>
    </TextButton>
    <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
      <a href="#">Rent</a>
    </TextButton>
  </nav>
</Box>
```

**Sticky wrapper:**
```tsx
<Box css={{ position: "sticky", display: "flow-root", top: 0, zIndex: 10,
  width: "100%", maxWidth: "100%", background: "bg.screen.neutral" }}>
  {/* header content inside */}
</Box>
```

**Mobile nav with Menu component:**
```tsx
<Menu
  content={
    <>
      <Menu.Group aria-label="Core navigation">
        <Menu.Item asChild><a href="#"><Menu.ItemLabel>Buy</Menu.ItemLabel></a></Menu.Item>
        <Menu.Item asChild><a href="#"><Menu.ItemLabel>Rent</Menu.ItemLabel></a></Menu.Item>
      </Menu.Group>
      <Menu.Group aria-label="User actions">
        <Menu.Item asChild><a href="#"><Menu.ItemLabel>Manage rentals</Menu.ItemLabel></a></Menu.Item>
      </Menu.Group>
    </>
  }
>
  <IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
    <Icon size="md"><IconMenuFilled /></Icon>
  </IconButton>
</Menu>
```

**Search bar with AdornedInput:**
```tsx
<AdornedInput
  input={<AdornedInput.Input aria-label="Search" placeholder="Search by address..." />}
  endAdornment={
    <AdornedInput.Adornment asChild>
      <IconButton emphasis="bare" shape="circle" size="md" title="Search" tone="neutral">
        <Icon><IconSearchFilled /></Icon>
      </IconButton>
    </AdornedInput.Adornment>
  }
/>
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
| Search bar | AdornedInput with IconButton adornment | Consumer |
| Mobile-responsive | Menu component with Menu.Group | Consumer |
| Professional | IconButtons + Avatar + nav asChild | Professional |
| Tabs navigation | Header + Tabs.Root below | Both |
| Sidebar | Minimal header + VerticalNav sidebar | Professional |
| Breadcrumb | Header + Page.Breadcrumb + detail heading | Both |
| Centered logo | Three-column layout, logo centered | Consumer |
| No divider | Clean seamless header (no borderBottom) | Consumer |

## Related Constellation Skills

- **[constellation-design-system](../constellation-design-system/SKILL.md)**: Core design system rules, all 99 component docs, UX writing guidelines, and layout patterns.
- **[constellation-icons](../constellation-icons/SKILL.md)**: Full catalog of 621 icons with color tokens, sizing, and implementation guides.
- **[constellation-dark-mode](../constellation-dark-mode/SKILL.md)**: Theme injection, dark mode toggle patterns, and design token tiers.
- **[responsive-design](../responsive-design/SKILL.md)**: Mobile-first responsive layouts, PandaCSS breakpoint tokens, and touch targets.

## Resources

- **Full code examples**: See [references/header-patterns.md](references/header-patterns.md) for all 10 patterns
- **Component defaults detail**: See [references/component-defaults.md](references/component-defaults.md) for prop tables and avatar/logo patterns
