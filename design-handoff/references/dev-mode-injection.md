# Dev Mode Overlay Injection Guide

Step-by-step instructions for injecting the interactive dev mode overlay into a target Replit project. The agent follows these steps during Phase 6 of the design handoff workflow.

## Overview

The dev mode overlay adds three components to the target project:

1. **DevModeProvider** — React context managing on/off state + keyboard shortcut (Ctrl+Shift+D)
2. **DevAnnotation** — Invisible wrapper that shows hover tooltips with component metadata when dev mode is active
3. **DevModeToggle** — A small toggle button placed in the header

When dev mode is off, `DevAnnotation` renders only its children with zero DOM impact. When on, annotated elements show dashed outlines and hovering reveals a metadata panel. The wrapper uses `display: contents` to avoid introducing extra block-level elements that could break layout.

## Step 1: Copy Template Files

Copy the three template files into the target project's components directory:

```
Source: .agents/skills/design-handoff/references/templates/
Target: client/src/components/dev-mode/

Files to copy:
  DevModeProvider.tsx  → client/src/components/dev-mode/DevModeProvider.tsx
  DevAnnotation.tsx    → client/src/components/dev-mode/DevAnnotation.tsx
  DevModeToggle.tsx    → client/src/components/dev-mode/DevModeToggle.tsx
```

Adjust import paths in each file to match the target project's directory structure. The templates use relative imports between the three files.

## Step 2: Wrap the App with DevModeProvider

Find the app's root component (typically `App.tsx` or equivalent) and wrap the entire tree:

```tsx
import { DevModeProvider } from "@/components/dev-mode/DevModeProvider";

function App() {
  return (
    <DevModeProvider>
      {/* existing app tree */}
    </DevModeProvider>
  );
}
```

Place `DevModeProvider` inside any existing providers (QueryClient, Auth, Theme) so it has access to app context.

## Step 3: Add the Toggle Button

Render `DevModeToggle` inside `DevModeProvider`. It is position-fixed to the bottom-left corner of the screen, so it does not need to go inside the header — just place it alongside the app tree:

```tsx
import { DevModeProvider } from "@/components/dev-mode/DevModeProvider";
import { DevModeToggle } from "@/components/dev-mode/DevModeToggle";

function App() {
  return (
    <DevModeProvider>
      {/* existing app tree */}
      <DevModeToggle />
    </DevModeProvider>
  );
}
```

The toggle floats in the bottom-left corner at `z-index: 10002`, always visible regardless of scroll position. It does not interfere with the header or page layout.

## Step 4: Apply Annotations

This is the main work. For each component instance identified during the Inventory and Annotate phases, wrap it with `DevAnnotation`:

```tsx
import { DevAnnotation } from "@/components/dev-mode/DevAnnotation";

// Before:
<Card elevated interactive tone="neutral" css={{ p: "400" }}>
  <Text textStyle="body-bold">Skill name</Text>
</Card>

// After:
<DevAnnotation annotation={{
  component: "Card",
  props: { tone: "neutral", elevated: "true", interactive: "true" },
  spacing: "p='400'",
  colors: "bg=default (Card elevated)",
  typography: "children: body-bold",
  status: "pass",
}}>
  <Card elevated interactive tone="neutral" css={{ p: "400" }}>
    <Text textStyle="body-bold">Skill name</Text>
  </Card>
</DevAnnotation>
```

### Annotation Priorities

Apply annotations in this order (most impactful first):

1. **Page-level containers** — Page.Root, Page.Header, Page.Content
2. **Major sections** — Hero areas, card grids, sidebars
3. **Interactive components** — Buttons, Tabs, Modals, Menus
4. **Cards and list items** — Card instances, PropertyCard
5. **Text and typography** — Every `Heading` and `Text` instance showing textStyle, color token, and content purpose (see Text Annotation below)
6. **Labels and badges** — Every `Tag`, `FilterChip`, and badge showing tone, size, and color tokens
7. **Icons** — Icon wrappers with their child icons
8. **Form elements** — Input, Select, Checkbox, etc.
9. **Utility components** — Divider

### Text & Label Annotation Guide

Annotate **every** visible text element and label — not just containers. These carry the typography and color tokens developers need most.

**Text elements (`Text`, `Heading`):**

```tsx
<DevAnnotation annotation={{
  component: "Heading",
  props: { level: "2" },
  typography: "textStyle='heading-lg'",
  colors: "color=default (text.default)",
  notes: "Page headline (1 of max 2 per screen)",
  status: "pass",
}}>
  <Heading level={2} textStyle="heading-lg">Find your home</Heading>
</DevAnnotation>

<DevAnnotation annotation={{
  component: "Text",
  typography: "textStyle='body-bold'",
  colors: "color=default",
  notes: "Card title",
  status: "pass",
}} as="span">
  <Text textStyle="body-bold">Card name</Text>
</DevAnnotation>

<DevAnnotation annotation={{
  component: "Text",
  typography: "textStyle='body'",
  colors: "css={{ color: 'text.subtle' }}",
  notes: "Description text",
  status: "pass",
}} as="span">
  <Text textStyle="body" css={{ color: "text.subtle" }}>Description here</Text>
</DevAnnotation>

<DevAnnotation annotation={{
  component: "Text",
  typography: "textStyle='body-sm'",
  colors: "css={{ color: 'text.subtle' }}",
  notes: "Metadata / fine print",
  status: "pass",
}} as="span">
  <Text textStyle="body-sm" css={{ color: "text.subtle" }}>12 items</Text>
</DevAnnotation>
```

**Labels and badges (`Tag`, `FilterChip`):**

```tsx
<DevAnnotation annotation={{
  component: "Tag",
  props: { size: "sm", tone: "blue" },
  spacing: "css={{ whiteSpace: 'nowrap' }}",
  notes: "Category badge",
  status: "pass",
}} as="span">
  <Tag size="sm" tone="blue" css={{ whiteSpace: "nowrap" }}>Design system</Tag>
</DevAnnotation>

<DevAnnotation annotation={{
  component: "FilterChip",
  props: { selected: "{dynamic}" },
  notes: "Category filter — tone varies by selection state",
  status: "pass",
}}>
  <FilterChip selected={isSelected}>All skills</FilterChip>
</DevAnnotation>
```

**Typography token quick reference (include in tooltip):**

| textStyle | Purpose | Typical color |
|-----------|---------|---------------|
| `heading-lg` | Page headline (max 2 per screen) | `text.default` |
| `body-lg-bold` | Section titles | `text.default` |
| `body-lg` | Large body text | `text.default` or `text.subtle` |
| `body-bold` | Card titles, labels | `text.default` |
| `body` | Body text, descriptions | `text.default` or `text.subtle` |
| `body-sm` | Metadata, counts, fine print | `text.subtle` |

### Annotation Data Guide

For each `DevAnnotation`, populate the `annotation` object:

| Field | Source | Example |
|-------|--------|---------|
| `component` | Constellation component name from the import | `"Card"`, `"Button"`, `"Page.Header"` |
| `props` | Object of explicitly-set props | `{ tone: "neutral", elevated: "true" }` |
| `spacing` | PandaCSS spacing tokens from css prop or direct props | `"p='400' gap='300'"` |
| `colors` | Semantic color tokens from css prop | `"bg='bg.screen.neutral' color='text.subtle'"` |
| `typography` | textStyle values | `"textStyle='body-bold'"` |
| `icons` | Icon component name + size | `"IconSearchFilled size='md'"` |
| `responsive` | Breakpoint-specific behavior | `"columns={{ base: 1, md: 2, lg: 3 }}"` |
| `contains` | Array of notable child component names | `["Text", "Icon", "Badge"]` |
| `notes` | Implementation context | `"Sticky header, z-index: 100"` |
| `status` | Design rule compliance | `"pass"`, `"warning"`, or `"violation"` |
| `statusNote` | Explanation for warning/violation | `"Missing saveButton prop"` |

**`as` prop:** Use `as="span"` when annotating inline elements to avoid block-level wrapping. Defaults to `"div"`. The wrapper uses `display: contents` either way, but the element type matters for HTML validity.

### Status Values

| Status | When to use |
|--------|-------------|
| `"pass"` | Component follows all design system rules |
| `"warning"` | Minor concern (e.g., approaching Heading limit) |
| `"violation"` | Breaks a design system rule (see High-Risk Rule Checks in constellation-mapping.md) |

## Step 5: Annotate Repeated Patterns

For components rendered in a loop (e.g., a grid of cards), annotate the wrapper and one representative card:

```tsx
<DevAnnotation annotation={{
  component: "Grid",
  spacing: "gap='400'",
  responsive: "columns={{ base: 1, md: 2, lg: 3 }}",
  notes: `Renders ${items.length} skill cards`,
  status: "pass",
}}>
  <Grid columns={{ base: 1, md: 2, lg: 3 }} gap="400">
    {items.map((item, i) => (
      <DevAnnotation
        key={item.id}
        annotation={{
          component: "Card",
          props: { tone: "neutral", elevated: "true", interactive: "true" },
          spacing: "p='400'",
          notes: i === 0 ? "Representative card (pattern repeats)" : undefined,
          status: "pass",
        }}
      >
        <SkillCard skill={item} />
      </DevAnnotation>
    ))}
  </Grid>
</DevAnnotation>
```

## Step 6: Verify

After injection:

1. Toggle dev mode with Ctrl+Shift+D — outlines should appear on annotated elements
2. Hover over each annotated region — metadata panel should display correctly
3. Toggle outlines button — outlines should show/hide independently
4. Turn off dev mode — UI should return to normal with no visual artifacts
5. Check that no annotations overlap or create layout shifts

## Cleanup Notes

The dev mode overlay is intended for development and handoff review. Before shipping to production:

- Either remove the `DevModeProvider`, `DevAnnotation` wrappers, and `DevModeToggle`
- Or gate them behind an environment variable: `if (process.env.NODE_ENV === 'development')`

The templates are designed so that when `enabled` is `false`, `DevAnnotation` renders only `{children}` with zero overhead.
