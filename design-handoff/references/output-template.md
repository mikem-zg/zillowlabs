# Design Handoff Specification Template

Use this template to produce the final handoff document. Fill in each section for every page/route in the project.

---

## Project Overview

| Field | Value |
|-------|-------|
| **Project name** | [Name] |
| **Audience** | Consumer / Professional |
| **Design system** | Constellation v10.11.0 |
| **Styling** | PandaCSS with Constellation preset |
| **Routing** | [Wouter / React Router / etc.] |
| **Routes** | [List all routes] |

---

## Global Elements

### App Shell

```
Component tree:
├─ Page.Root
│  ├─ Page.Header (sticky)
│  │  ├─ ZillowLogo
│  │  ├─ Navigation links
│  │  └─ User actions
│  └─ Page.Content
│     └─ Router
```

#### Component Annotations

| # | Component | Props | Spacing | Colors | Typography | Notes |
|---|-----------|-------|---------|--------|------------|-------|
| 1 | `Page.Root` | — | — | — | — | Top-level wrapper |
| 2 | `Page.Header` | `css={{ position: "sticky", top: 0, zIndex: 100 }}` | `px="400" py="300"` | `bg="bg.screen.neutral"` | — | Sticky header |
| 3 | `ZillowLogo` | `css={{ height: "24px" }}` | — | — | — | 24px desktop, 16px mobile |

---

## Page: [Route Path]

### Purpose
[1-2 sentences describing what this page does]

### Component Tree

```
├─ [Top-level container]
│  ├─ [Section 1]
│  │  ├─ [Component]
│  │  └─ [Component]
│  └─ [Section 2]
│     └─ [Component]
```

### Component Annotations

| # | Component | Props | Spacing | Colors | Typography | Icons | Responsive | Notes |
|---|-----------|-------|---------|--------|------------|-------|------------|-------|
| 1 | `Heading` | `level={1}` | — | default | `textStyle="heading-lg"` | — | — | Page headline |
| 2 | `Text` | — | — | `color="text.subtle"` | `textStyle="body-lg"` | — | — | Subtitle |
| 3 | `Button` | `tone="brand" emphasis="filled" size="md"` | — | — | — | `IconNoteFilled` start | — | Primary CTA |
| 4 | `Card` | `elevated interactive tone="neutral"` | `p="400"` | — | — | — | — | Skill card |
| 5 | `FilterChip` | `selected={isSelected}` | — | — | — | — | — | Category filter |
| 6 | `Grid` | — | `gap="400"` | — | — | — | `columns={{ base: 1, md: 2, lg: 3 }}` | Card grid |
| 7 | `Tag` | `size="sm" tone={dynamic}` | — | — | — | — | — | Category badge |
| 8 | `Icon` | `size="sm"` | — | `css={{ color: "icon.subtle" }}` | — | `IconArrowRightFilled` | — | Card arrow |
| 9 | `Divider` | — | — | — | — | — | — | Section separator |

### Layout & Spacing

```
┌─────────────────────────────────────────────────────────┐
│ Page.Content  bg="bg.screen.neutral"  minHeight="100vh" │
│                                                         │
│  ┌─ Hero Section ─────────────────────────────────────┐ │
│  │ bg="bg.elevated"  borderRadius="20px"              │ │
│  │ px="400" py="600" mx="400" mt="600"                │ │
│  │                                                     │ │
│  │  [Heading]  gap="300"  [Illustration 200x200]       │ │
│  │  [Text]               (hidden on mobile)            │ │
│  │  [Button] [Button]    gap="300" mt="200"            │ │
│  └─────────────────────────────────────────────────────┘ │
│                                                         │
│  gap="800" between sections                             │
│                                                         │
│  ┌─ Skills Section ───────────────────────────────────┐ │
│  │ px="400" maxWidth="1200px"                         │ │
│  │                                                     │ │
│  │  [Section header]  gap="200"                        │ │
│  │  [FilterChips]     gap="200" flexWrap="wrap"        │ │
│  │  [Grid]            gap="400" 1→2→3 columns          │ │
│  └─────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

### Responsive Behavior

| Breakpoint | Behavior |
|------------|----------|
| `base` (mobile) | Single column grid, illustration hidden, full-width cards |
| `md` (768px) | 2-column grid, illustration visible |
| `lg` (1024px) | 3-column grid |

### Design System Compliance

| Status | Rule | Detail |
|--------|------|--------|
| ✅ Pass | Card tone | All cards use `tone="neutral"` |
| ✅ Pass | Filled icons | All icons use Filled variants |
| ✅ Pass | Page.Header | Header uses `Page.Header`, not Box/Flex |
| ✅ Pass | Dividers | Uses `<Divider />`, not CSS borders |
| ⚠️ Warning | Heading count | 1 Heading on page (within limit) |
| ❌ Violation | [Rule name] | [Description and fix] |

### Developer Notes

- [Any implementation-specific notes, gotchas, or context]
- [Third-party dependencies or custom hooks used]
- [Data fetching patterns (TanStack Query, etc.)]
- [State management approach]

---

## Token Reference

### Spacing Tokens Used

| Token | Value | Where Used |
|-------|-------|------------|
| `100` | 4px | Tight gaps between text |
| `200` | 8px | Filter chip gaps, icon-text gaps |
| `300` | 12px | Button gaps, card internal gaps |
| `400` | 16px | Page padding, card padding, grid gaps |
| `600` | 24px | Section vertical padding |
| `800` | 32px | Section-to-section gaps |

### Color Tokens Used

| Token | Purpose | Where Used |
|-------|---------|------------|
| `bg.screen.neutral` | Page background | Page.Content, Page.Header |
| `bg.elevated` | Elevated surface | Hero section |
| `text.subtle` | Secondary text | Descriptions, metadata |
| `icon.subtle` | Secondary icons | Card arrows, metadata icons |
| `icon.action.hero.default` | Primary action icons | Section header icons |

### Typography Tokens Used

| textStyle | Purpose | Where Used |
|-----------|---------|------------|
| `heading-lg` | Page headline | Hero heading |
| `body-lg` | Large body text | Hero subtitle |
| `body-lg-bold` | Section titles | Section headers |
| `body-bold` | Card titles | Card names |
| `body` | Body text | Descriptions |
| `body-sm` | Small text | Metadata, counts |

---

## Assets

| Asset | Type | Location | Notes |
|-------|------|----------|-------|
| [Illustration name] | SVG | `client/src/assets/illustrations/Lightmode/` | Has dark mode variant |
| [Icon] | Component | `@zillow/constellation-icons` | Used as `<IconNameFilled />` |

---

## Summary

| Metric | Count |
|--------|-------|
| Pages/routes | [N] |
| Constellation components used | [N] |
| Icons used | [N] |
| Design system violations | [N] |
| Responsive breakpoints | [N] |
| Custom components | [N] |
