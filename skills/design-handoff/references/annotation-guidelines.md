# Annotation Guidelines

Rules for annotating UI components during a design handoff.

## What to Annotate

Every component instance that renders visible UI. This includes:

1. **Constellation components** — Button, Card, Text, Heading, Input, Select, Modal, Tabs, PropertyCard, Tag, FilterChip, Divider, etc.
2. **Text and typography** — Every `Text` and `Heading` instance, capturing textStyle, color token, and content purpose. These are critical for developers to reproduce the visual hierarchy.
3. **Labels and badges** — Every `Tag`, `FilterChip`, and badge, capturing tone, size, and color tokens.
4. **Layout primitives** — Box, Flex, Grid (from `@/styled-system/jsx`)
5. **Icons** — every `<Icon>` wrapper and its child icon component
6. **Custom components** — project-specific components not from Constellation
7. **Images and illustrations** — SVGs, imgs, illustration assets

## What NOT to Annotate

- Internal React wrappers that produce no DOM output (providers, context wrappers)
- Utility hooks or logic-only components
- Individual `css()` calls that don't correspond to a visible element (unless they carry important tokens)

## Annotation Fields

For each component instance, capture these fields:

### Required Fields

| Field | Description | Example |
|-------|-------------|---------|
| **Component** | The Constellation or custom component name | `Card`, `Button`, `CustomHeader` |
| **Props** | All explicitly-set props with values | `tone="neutral" elevated interactive` |
| **Spacing** | PandaCSS spacing tokens used via props or `css()` | `p="400" gap="300" mt="200"` |
| **Colors** | Semantic color tokens | `bg="bg.screen.neutral" css={{ color: "text.subtle" }}` |

### Conditional Fields (include when present)

| Field | Description | Example |
|-------|-------------|---------|
| **Typography** | `textStyle` prop value | `textStyle="body-bold"` |
| **Icons** | Icon component name + size + color | `IconSearchFilled size="md" css={{ color: "icon.subtle" }}` |
| **Responsive** | Breakpoint-specific props or behavior | `columns={{ base: 1, md: 2, lg: 3 }}` |
| **Children** | Notable nested components | `Contains: Text, Icon, Badge` |
| **Notes** | Implementation-specific context | "Used as navigation trigger" |

## Brevity Rules

1. **One line per field** — don't write paragraphs for annotations
2. **Token values only** — write `p="400"` not `padding: 16px (using the 400 spacing token)`
3. **Skip defaults** — don't annotate props that match the component default
4. **Group repeated patterns** — if 10 cards share the same props, annotate once and note "×10"
5. **ASCII tree for hierarchy** — use `├─` and `└─` for the component tree, not nested bullet lists

## Hierarchy Notation

Use ASCII box drawing for component trees:

```
├─ ParentComponent
│  ├─ ChildA prop="value"
│  │  └─ GrandchildA
│  └─ ChildB
│     ├─ GrandchildB
│     └─ GrandchildC
```

Use box notation for individual annotations:

```
┌─ ComponentName ────────────────────────────────────────┐
│  Props: tone="neutral" elevated interactive            │
│  Spacing: p="400" gap="300"                            │
│  Colors: bg="bg.elevated"                              │
│  Contains:                                             │
│    ├─ Text textStyle="body-bold"                       │
│    └─ Icon size="sm" IconArrowRightFilled              │
└────────────────────────────────────────────────────────┘
```

## Token Recording

### Spacing Tokens

Record the token name (not the pixel value). Cross-reference:

| Token | Value |
|-------|-------|
| `100` | 4px |
| `200` | 8px |
| `300` | 12px |
| `400` | 16px |
| `500` | 20px |
| `600` | 24px |
| `800` | 32px |
| `1000` | 40px |

### Color Tokens

Record semantic token paths, not hex values:

| Token path | Purpose |
|------------|---------|
| `bg.screen.neutral` | Page background (white) |
| `bg.elevated` | Elevated surfaces |
| `bg.subtle` | Subtle backgrounds |
| `text.default` | Primary text |
| `text.subtle` | Secondary text |
| `text.action.hero.default` | Interactive blue text |
| `icon.subtle` | Secondary icons |
| `icon.action.hero.default` | Primary action icons |
| `border.default` | Default borders |

### Typography Tokens

Record the `textStyle` value:

| textStyle | Use for |
|-----------|---------|
| `heading-xl` | Hero headlines |
| `heading-lg` | Page headlines |
| `heading-md` | Section headlines |
| `body-lg-bold` | Section titles |
| `body-lg` | Large body text |
| `body-bold` | Card titles, labels |
| `body` | Body text |
| `body-sm` | Metadata, fine print |

## Handling Custom Components

When a component is NOT from Constellation:

1. Mark it as `[Custom]` in the Component column
2. Note which Constellation components it wraps internally
3. Document its public props
4. Flag if it should be replaced with a Constellation equivalent

Example:
```
| 5 | `[Custom] SkillCard` | `skill={...} onClick={...}` | — | — | — | — | — | Wraps Card + Flex + Text internally |
```

## Handling Dynamic Content

When props are driven by state or data:

1. Record the prop name with `{dynamic}` as value
2. Add a note explaining what drives it

Example:
```
| 3 | `Tag` | `tone={dynamic} size="sm"` | — | — | — | — | — | tone varies by category |
```
