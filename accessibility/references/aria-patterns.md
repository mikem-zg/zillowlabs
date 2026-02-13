# WAI-ARIA Patterns

Reference for implementing accessible interactive components. Based on the [WAI-ARIA Authoring Practices Guide (APG)](https://www.w3.org/WAI/ARIA/apg/). Use semantic HTML first; add ARIA only when native semantics are insufficient.

## General Principles

1. **First rule of ARIA:** Don't use ARIA if native HTML can do it
2. **Second rule:** Don't change native semantics unless you must
3. **Third rule:** All interactive ARIA controls must be keyboard accessible
4. **Fourth rule:** Don't use `role="presentation"` or `aria-hidden="true"` on focusable elements
5. **Fifth rule:** All interactive elements must have an accessible name

## Dialog (Modal)

### Roles & Properties

- Container: `role="dialog"`, `aria-modal="true"`
- Title: referenced by `aria-labelledby` on the dialog
- Optional description via `aria-describedby`

### Keyboard Interaction

- **Tab / Shift+Tab:** cycle focus within dialog (focus trap)
- **Escape:** close dialog
- **On open:** focus first focusable element (or title with `tabindex="-1"` for long content)
- **On close:** return focus to the element that opened the dialog

### Implementation Notes

- Constellation `<Modal>` handles focus trap and ARIA automatically
- Always provide `header` prop for accessible labeling
- Use `aria-hidden="true"` on content behind modal (or use `aria-modal="true"`)

## Tabs

### Roles & Properties

- Container: `role="tablist"`
- Each tab: `role="tab"`, `aria-selected="true/false"`, `aria-controls="panel-id"`
- Each panel: `role="tabpanel"`, `aria-labelledby="tab-id"`

### Keyboard Interaction

- **Arrow Left/Right:** move between tabs (horizontal)
- **Arrow Up/Down:** move between tabs (vertical)
- **Home:** first tab, **End:** last tab
- **Tab:** move focus into the active panel
- **Space/Enter:** activate tab (manual activation mode)

### Implementation Notes

- Constellation `<Tabs>` handles all ARIA and keyboard nav
- Always provide `defaultSelected` prop
- Recommended: automatic activation (select on focus) for fast navigation

## Combobox

### Roles & Properties

- Input: `role="combobox"`, `aria-expanded="true/false"`, `aria-autocomplete="list|both|none"`
- Popup: `role="listbox"` (most common)
- Active option: `aria-activedescendant="option-id"` on the combobox
- Each option: `role="option"`, `aria-selected="true/false"`

### Keyboard Interaction

- **Down Arrow:** open popup / move to next option
- **Up Arrow:** move to previous option / last option
- **Enter:** accept selected option, close popup
- **Escape:** close popup, clear if editable
- **Printable characters:** filter options (editable) or jump to matching (non-editable)
- **Alt+Down Arrow:** open without moving focus

### Implementation Notes

- Constellation `<ComboBox>` and `<Select>` handle this pattern
- For custom implementations, use `aria-activedescendant` rather than moving DOM focus into the listbox

## Accordion

### Roles & Properties

- Trigger: `<button>` element (native semantics preferred)
- `aria-expanded="true/false"` on trigger
- `aria-controls="panel-id"` on trigger
- Panel: `role="region"` with `aria-labelledby="trigger-id"` (if few accordions)

### Keyboard Interaction

- **Enter/Space:** toggle expanded state
- **Tab:** move between triggers (panels with focusable content are in tab order when expanded)
- **Optional:** Arrow Up/Down between triggers, Home/End

### Implementation Notes

- Constellation `<Accordion>` handles all semantics
- Use `<h3>` (or appropriate level) as wrapping element for triggers to maintain heading hierarchy

## Button

### Roles & Properties

- Use native `<button>` element (inherits role automatically)
- Toggle buttons: add `aria-pressed="true/false"`
- Buttons that open menus: `aria-haspopup="true"`, `aria-expanded="true/false"`

### Keyboard Interaction

- **Enter or Space:** activate button
- **If opens a menu:** arrow keys navigate menu items

### Implementation Notes

- Never use `<div>` or `<span>` with click handlers as buttons
- For icon-only buttons: use `aria-label` or Constellation's `<IconButton title="...">`

## Radio Group

### Roles & Properties

- Container: `role="radiogroup"`, `aria-labelledby` or `aria-label`
- Each radio: `role="radio"`, `aria-checked="true/false"`
- Use native `<input type="radio">` when possible

### Keyboard Interaction

- **Arrow keys:** move selection between radio buttons
- **Tab:** move into/out of the radio group (focus lands on selected item)
- **Space:** select focused radio

## Checkbox

### Roles & Properties

- Single: `role="checkbox"`, `aria-checked="true/false/mixed"`
- Group: `role="group"`, `aria-labelledby`
- Tri-state (parent): `aria-checked="mixed"` when some children checked

### Keyboard Interaction

- **Space:** toggle checked state
- **Tab:** move between checkboxes

## Listbox

### Roles & Properties

- Container: `role="listbox"`, `aria-label` or `aria-labelledby`
- Options: `role="option"`, `aria-selected="true/false"`
- Multi-select: `aria-multiselectable="true"` on listbox

### Keyboard Interaction

- **Arrow Up/Down:** move focus between options
- **Home/End:** first/last option
- **Space:** toggle selection (multi-select)
- **Type-ahead:** jump to matching option

## Menu & Menu Button

### Roles & Properties

- Button: native `<button>`, `aria-haspopup="true"`, `aria-expanded`, `aria-controls`
- Menu: `role="menu"`
- Items: `role="menuitem"` (or `menuitemcheckbox`, `menuitemradio`)

### Keyboard Interaction

- **Enter/Space/Down Arrow on button:** open menu, focus first item
- **Arrow Up/Down:** navigate menu items
- **Escape:** close menu, return focus to button
- **Home/End:** first/last item
- **Type-ahead:** jump to matching item

## Tooltip

### Roles & Properties

- Trigger: interactive element with `aria-describedby` pointing to tooltip
- Tooltip: `role="tooltip"`

### Keyboard Interaction

- **Focus trigger:** show tooltip
- **Escape:** dismiss tooltip
- **Hover trigger:** show tooltip (must remain visible while hovering tooltip)

### WCAG 1.4.13 Requirements

- Dismissible (Escape key)
- Hoverable (mouse can move to tooltip without it disappearing)
- Persistent (stays visible until user dismisses or moves focus/hover)

## Carousel / Slider

### Roles & Properties

- Container: `role="region"`, `aria-roledescription="carousel"`, `aria-label`
- Slide: `role="group"`, `aria-roledescription="slide"`, `aria-label="N of M"`
- Controls: Previous/Next buttons with `aria-label`
- Auto-rotation: pause button required

### Keyboard Interaction

- **Tab:** move to slide content or controls
- **Previous/Next buttons:** standard button interaction
- **Optional:** Arrow Left/Right between slides

## Landmarks

### Standard Landmarks

| Element | ARIA Role | Usage |
|---------|-----------|-------|
| `<header>` | `banner` | Site-wide header (one per page) |
| `<nav>` | `navigation` | Navigation sections (label each with `aria-label`) |
| `<main>` | `main` | Primary content (one per page) |
| `<aside>` | `complementary` | Supporting content |
| `<footer>` | `contentinfo` | Site-wide footer (one per page) |
| `<section>` | `region` | Named section (requires `aria-label` or `aria-labelledby`) |
| `<form>` | `form` | Named form (requires accessible name) |
| N/A | `search` | Search functionality |

## Resources

- [WAI-ARIA Authoring Practices Guide](https://www.w3.org/WAI/ARIA/apg/)
- [WAI-ARIA 1.2 Specification](https://w3c.github.io/aria/)
- [ARIA in HTML](https://www.w3.org/TR/html-aria/)
