---
name: accessibility
description: Build accessible web interfaces compliant with WCAG 2.2 Level AA. Use when implementing UI components, reviewing accessibility, annotating designs for handoff, writing ARIA attributes, managing focus in React SPAs, or testing with axe/Lighthouse. Covers Zillow's internal design and engineering checklists, WAI-ARIA patterns, React-specific a11y patterns, and automated/manual testing workflows.
---

# Accessibility

Build inclusive, WCAG 2.2 AA-compliant web interfaces. This skill covers standards, implementation patterns, testing, and Zillow's internal accessibility workflows.

## Reference Guides

- **[WCAG 2.2 Checklist](references/wcag-checklist.md)** — All success criteria organized by principle and level, with React implementation guidance
- **[ARIA Patterns](references/aria-patterns.md)** — WAI-ARIA authoring patterns for common components (keyboard interaction, roles, states, properties)
- **[React Patterns](references/react-patterns.md)** — Focus management, live regions, route changes, forms, and SPA-specific accessibility
- **[Testing Guide](references/testing-guide.md)** — Automated testing (jest-axe, axe-playwright, Lighthouse), manual testing (screen readers, keyboard), and CI/CD integration
- **[Design & Engineering Checklists](references/checklists.md)** — Zillow's internal design checklist, engineering handoff checklist, and Figma annotation guidance

## Critical Rules

1. **Semantic HTML first** — Use `<button>`, `<nav>`, `<main>`, `<header>`, `<h1>`–`<h6>` before reaching for ARIA
2. **Keyboard accessible** — Every interactive element must be operable via keyboard (Tab, Enter, Space, Escape, arrow keys)
3. **No keyboard traps** — Users must be able to navigate away from every component (exception: intentional focus traps in modals with Escape to close)
4. **Visible focus indicators** — 2px minimum outline with 3:1 contrast ratio against unfocused state
5. **Color is not the only indicator** — Use text, icons, or patterns alongside color to convey meaning
6. **Text alternatives** — All informative images need `alt` text; decorative images need `alt=""`
7. **Contrast ratios** — Normal text: 4.5:1 minimum; large text (18pt+ or 14pt+ bold): 3:1 minimum
8. **Target size** — Interactive elements: 24×24px minimum (WCAG 2.2); 44×44px recommended for touch
9. **Live regions for dynamic content** — Keep `aria-live` elements permanently in DOM; update text content only
10. **Focus management on route changes** — Move focus to `<h1>` or `<main>` after SPA navigation

## Quick Reference: ARIA Roles for Common Patterns

| Pattern | Role | Key Attributes |
|---------|------|----------------|
| Modal dialog | `role="dialog"` | `aria-modal="true"`, `aria-labelledby` |
| Tab interface | `role="tablist"`, `role="tab"`, `role="tabpanel"` | `aria-selected`, `aria-controls` |
| Combobox / autocomplete | `role="combobox"` | `aria-expanded`, `aria-activedescendant`, `aria-autocomplete` |
| Alert message | `role="alert"` | Implicit `aria-live="assertive"` |
| Status message | `role="status"` | Implicit `aria-live="polite"` |
| Navigation landmark | `<nav>` or `role="navigation"` | `aria-label` when multiple nav regions |
| Accordion | `<button>` triggers | `aria-expanded`, `aria-controls` |
| Toggle button | `<button>` | `aria-pressed="true/false"` |
| Progressbar | `role="progressbar"` | `aria-valuenow`, `aria-valuemin`, `aria-valuemax` |

## Constellation Components & Built-in Accessibility

Constellation components handle many ARIA patterns automatically. Key things to verify:

| Component | What Constellation handles | What you must provide |
|-----------|---------------------------|----------------------|
| `Modal` | Focus trap, `role="dialog"`, `aria-modal` | `header` prop for `aria-labelledby` |
| `Tabs` | `tablist`/`tab`/`tabpanel` roles, arrow key nav | `defaultSelected` prop |
| `Select` / `ComboBox` | `combobox` role, `aria-expanded`, keyboard nav | `label` or `aria-label` |
| `Accordion` | `aria-expanded`, keyboard Enter/Space | Meaningful trigger text |
| `Button` | Native `<button>` semantics | Visible text or `aria-label` for icon-only |
| `IconButton` | Native `<button>` semantics | `title` prop (required) |
| `Input` | Native `<input>` semantics | `<label>` via `htmlFor` or `aria-label` |
| `Checkbox` / `Radio` | Native semantics + group roles | Label text, `CheckboxGroup`/`RadioGroup` for grouping |
| `Alert` / `Banner` | `role="alert"` or `role="status"` | Meaningful message text |

## WCAG 2.2 New Criteria (Quick Summary)

| Criterion | Level | Key Requirement |
|-----------|-------|-----------------|
| 2.4.11 Focus Not Obscured | AA | Focused element must not be fully hidden by sticky headers/footers |
| 2.5.7 Dragging Movements | A | Provide single-pointer alternative to all drag operations |
| 3.2.6 Consistent Help | AA | Help mechanisms in same relative position across pages |
| 3.3.7 Redundant Entry | A | Don't ask for same information twice in a session |
| 3.3.8 Accessible Authentication | AA | Don't require cognitive function tests for login |

## When to Use This Skill

- Implementing any new UI component or page
- Reviewing existing code for accessibility compliance
- Preparing designs for engineering handoff
- Writing ARIA attributes for custom interactive widgets
- Managing focus in React SPAs (route changes, modals, dynamic content)
- Setting up automated accessibility testing
- Responding to accessibility audit findings
- Building forms with proper validation and error messaging
