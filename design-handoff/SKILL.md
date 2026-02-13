---
name: design-handoff
description: Prepare a Replit project for developer handoff by analyzing every UI component and producing an annotated specification. Use when someone asks to get a project ready for dev, create a handoff spec, annotate the UI for developers, or document components for implementation. Covers Constellation component mapping, props, spacing tokens, color tokens, responsive behavior, and design system compliance.
---

# Design Handoff

Analyze a running Replit project's frontend and produce a structured handoff specification that a developer can use to rebuild or maintain the UI. The output annotates every component with its Constellation design system name, props, spacing tokens, color tokens, responsive behavior, and any design rule violations.

## When to Use

- "Get this ready for dev handoff"
- "Annotate the UI for developers"
- "Create a handoff spec for this project"
- "Document the components and tokens used"
- "Prepare this for another team to pick up"
- "What Constellation components does this use?"

## Core Workflow

### Phase 1: Inventory

Read every frontend file and catalog each UI element:

1. **Scan all component files** — pages, components, app shell
2. **For each file**, identify:
   - Constellation components used (imports from `@zillow/constellation`)
   - Icons used (imports from `@zillow/constellation-icons`)
   - PandaCSS tokens used (spacing, color, typography via `css()` or JSX props)
   - Layout primitives (`Box`, `Flex`, `Grid` from `@/styled-system/jsx`)
3. **Record the component tree** — which components contain which, and how they compose

### Phase 2: Annotate

For each component instance found, document using the format in [references/annotation-guidelines.md](references/annotation-guidelines.md):

| Field | What to capture |
|-------|----------------|
| **Component** | Constellation component name |
| **Props** | All props with values |
| **Spacing** | PandaCSS spacing tokens (padding, margin, gap) |
| **Colors** | Semantic color tokens |
| **Typography** | Text styles used |
| **Icons** | Icon name, size token, color token |
| **Responsive** | Breakpoint-specific behavior |
| **Children** | Nested components or content |

### Phase 3: Validate

Check every annotation against design system rules. Flag violations. Load the full rule set from the **constellation-design-system** skill's design-system-rules.md. Key checks:

- PropertyCard missing `saveButton`
- Card with both `elevated` and `outlined`
- Headers built with `Box`/`Flex` instead of `Page.Header`
- CSS `border` instead of `<Divider />`
- Outline icons used as default
- Tabs without `defaultSelected`
- More than 2 `Heading` per screen
- Blue used for non-interactive elements
- Hardcoded hex colors instead of tokens
- `textTransform: "capitalize"` creating Title Case
- Missing `tone="neutral"` on Card
- Raw `Flex` in Modal footer instead of `ButtonGroup`

### Phase 4: Responsive Audit

Check responsive behavior using the **responsive-design** skill:

- PandaCSS responsive breakpoints used?
- Layouts using responsive `Grid` columns?
- Modals responsive at mobile widths?
- Navigation responsive (hamburger, collapsible)?
- Touch targets at least 44px on mobile?
- Appropriate show/hide with `display: { base: "none", md: "block" }`?

### Phase 5: Generate Handoff Document

Produce the final output using [references/output-template.md](references/output-template.md), organized **by page/route**:

1. Component tree showing hierarchy
2. Detailed annotation table for every component instance
3. Spacing and layout description
4. Design system violations with fixes
5. Responsive behavior notes
6. Developer implementation notes

### Phase 6: Inject Dev Mode Overlay (Optional)

Inject an interactive dev mode overlay into the project so developers can toggle annotations visually in the browser. This adds hover-based metadata panels to every annotated component.

Follow the step-by-step guide in [references/dev-mode-injection.md](references/dev-mode-injection.md):

1. Copy template files from `references/templates/` into the target project
2. Wrap the app root with `DevModeProvider`
3. Render `DevModeToggle` inside the provider (it floats fixed in the bottom-left corner)
4. Wrap each annotated component with `DevAnnotation` using the annotation data from Phase 2
5. Verify: toggle with Ctrl+Shift+D, hover to see metadata, outlines toggle independently

The overlay has zero visual impact when disabled. Gate behind `NODE_ENV === 'development'` for production safety.

**Template files:** [references/templates/](references/templates/)
- `DevModeProvider.tsx` — Context + keyboard shortcut + outline styles
- `DevAnnotation.tsx` — Invisible wrapper with hover tooltip panel
- `DevModeToggle.tsx` — Floating bottom-left toggle button (position: fixed)

## Annotation Format

```
┌─ ComponentName ────────────────────────────────────────┐
│  Props: tone="neutral" elevated interactive            │
│  Spacing: p="400" gap="300"                            │
│  Colors: bg="bg.screen.neutral" color="text.subtle"    │
│  Typography: textStyle="body-bold"                     │
│  Contains:                                             │
│    ├─ ChildComponent prop="value"                      │
│    └─ AnotherChild                                     │
└────────────────────────────────────────────────────────┘
```

## Figma-to-Handoff Path (Optional)

When a Figma URL is provided, use Figma MCP tools before annotation:

1. `get_design_context` — extract component structure and code
2. `get_variable_defs` — extract design tokens
3. `get_code_connect_map` — check existing code mappings
4. `get_metadata` — get layer hierarchy

Map Figma components to Constellation equivalents using [references/constellation-mapping.md](references/constellation-mapping.md).

## Cross-Skill References

| Skill | What it provides |
|-------|-----------------|
| **constellation-design-system** | Component docs, design rules, anti-patterns |
| **constellation-icons** | Icon catalog, color tokens, size tokens, wrapper exceptions |
| **responsive-design** | Breakpoint tokens, responsive patterns, modal responsiveness |
| **constellation-illustrations** | Illustration catalog for empty states |

## Reference Documents

- **Output template**: [references/output-template.md](references/output-template.md)
- **Annotation guidelines**: [references/annotation-guidelines.md](references/annotation-guidelines.md)
- **Constellation mapping**: [references/constellation-mapping.md](references/constellation-mapping.md)
- **Figma workflow**: [references/figma-workflow.md](references/figma-workflow.md)
- **Dev mode injection**: [references/dev-mode-injection.md](references/dev-mode-injection.md)
- **Dev mode templates**: [references/templates/](references/templates/) (DevModeProvider, DevAnnotation, DevModeToggle)
