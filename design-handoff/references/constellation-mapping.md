# Constellation Component Mapping

Map detected UI patterns to the correct Constellation component. Use this when analyzing an existing codebase or translating Figma designs into Constellation implementations.

**Full component catalog:** For complete props, usage examples, and import paths for all 99 Constellation components, load the **constellation-design-system** skill and read its [components-catalog.md](../../../.agents/skills/constellation-design-system/references/components-catalog.md) (or load via `custom_instruction/components-catalog.md`). This file covers the **decision tree** — given a UI pattern, which component to use.

## Pattern-to-Component Map

### Containers & Layout

| UI Pattern | Constellation Component | Required Props | Anti-Pattern |
|-----------|------------------------|----------------|--------------|
| Property listing card | `PropertyCard` | `saveButton={<PropertyCard.SaveButton />}` | Using `Card` for property listings |
| Generic content container | `Card` | `tone="neutral"` + ONE of `elevated`/`outlined` | Using `Box` with shadow |
| Clickable card | `Card` | `elevated interactive tone="neutral"` | `Card` with only `elevated` (no `interactive`) |
| Static display card | `Card` | `outlined elevated={false} tone="neutral"` | Both `elevated` and `outlined` |
| Page header / navigation bar | `Page.Header` inside `Page.Root` (wrap in sticky `Box` if fixed) | Sticky: `Box` wrapper with `display: 'flow-root'` | `Box`/`Flex` as header; `position: sticky` directly on `Page.Header` |
| Horizontal rule / separator | `Divider` | — | CSS `border` or `borderBottom` |
| Modal / dialog | `Modal` | `body={...}` `header={...}` `footer={...}` `dividers` `size="md"` | Content as children (not in `body` prop) |
| Stack of elements | `Flex direction="column"` | `gap` token | `Box` with margins |
| Grid of cards | `Grid` | responsive `columns` | Manual `Flex` with `flexWrap` |

### Navigation & Selection

| UI Pattern | Constellation Component | Required Props | Anti-Pattern |
|-----------|------------------------|----------------|--------------|
| Tab interface | `Tabs.Root` + `Tabs.List` + `Tabs.Tab` + `Tabs.Panel` | `defaultSelected` | Missing `defaultSelected` |
| Single-select options (price, beds) | `ToggleButtonGroup` + `ToggleButton` | — | `Button` for selection |
| Segmented choices | `SegmentedControl` | — | `Button` group |
| Multi-select | `ComboBox` or `CheckboxGroup` | — | Custom checkboxes |
| Filter pills | `FilterChip` | — | Custom `Box` with styles |

### Text & Typography

| UI Pattern | Constellation Component | Required Props | Anti-Pattern |
|-----------|------------------------|----------------|--------------|
| Page headline (1-2 per screen) | `Heading` | `textStyle="heading-lg"` | Using `Heading` for every title |
| Section title | `Text` | `textStyle="body-lg-bold"` | `Heading` for section titles |
| Card title | `Text` | `textStyle="body-bold"` | `Heading` in every card |
| Body text | `Text` | `textStyle="body"` | Raw `<p>` or `<span>` |
| Description / secondary text | `Text` | `textStyle="body" css={{ color: "text.subtle" }}` | Hardcoded gray color |
| Small metadata | `Text` | `textStyle="body-sm"` | Custom font-size |

### Actions & Controls

| UI Pattern | Constellation Component | Required Props | Anti-Pattern |
|-----------|------------------------|----------------|--------------|
| Primary action button | `Button` | `tone="brand" emphasis="filled" size="md"` | Missing `size="md"` |
| Secondary action button | `Button` | `tone="neutral" emphasis="outlined" size="md"` | Filled button for secondary |
| Text-only action | `TextButton` | — | Unstyled `<a>` or `<button>` |
| Button with icon | `Button` | `icon={<IconXFilled />} iconPosition="start"` | Flex wrapping icon + text |
| Form text input | `Input` | — | Styled `<input>` |
| Dropdown select | `Select` | — | Custom dropdown |
| Checkbox | `Checkbox` | — | Custom checkbox |
| Radio selection | `Radio` | — | Custom radio |
| Search with autocomplete | `ComboBox` | — | Custom search input |

### Badges & Labels

| UI Pattern | Constellation Component | Required Props | Anti-Pattern |
|-----------|------------------------|----------------|--------------|
| Category label / badge | `Tag` | `size="sm" tone="blue" css={{ whiteSpace: "nowrap" }}` | Custom `Box` with bg/radius/padding |
| Property status badge | `PropertyCard.Badge` | `tone="accent"` | Custom badge component |
| Filter selection indicator | `FilterChip` | `selected` | Custom pill |

### Icons

| UI Pattern | Constellation Component | Required Props | Anti-Pattern |
|-----------|------------------------|----------------|--------------|
| Standard UI icon | `Icon` + `IconXxxFilled` | `size="md"` | Outline icon as default |
| Icon with semantic color | `Icon` + `IconXxxFilled` | `size="md" css={{ color: "token.path" }}` | `color` prop with token path |
| Empty state icon (Professional) | `Icon` + `IconXxxDuotone` | `size="xl"` | Filled icon for empty states |

### Page Structure

| UI Pattern | Constellation Component | Required Props | Anti-Pattern |
|-----------|------------------------|----------------|--------------|
| App shell wrapper | `Page.Root` | — | No page wrapper |
| Top navigation bar | `Page.Header` inside sticky `Box` wrapper | `Box` with `position: 'sticky', display: 'flow-root', top: 0, zIndex: 10, background: 'bg.screen.neutral'` wrapping `Page.Header` | `position: sticky` directly on `Page.Header` (built-in margins cause grey gap) |
| Main content area | `Page.Content` | `css={{ px: "400", py: "600" }}` | No content wrapper |
| Zillow branding | `ZillowLogo` | `css={{ height: "24px" }}` (desktop) | Random logo sizes |

### Feedback & Status

| UI Pattern | Constellation Component | Required Props | Anti-Pattern |
|-----------|------------------------|----------------|--------------|
| Inline notification | `Banner` | `tone`, `emphasis` | Custom alert div |
| Loading spinner | `Spinner` | — | Custom CSS spinner |
| Progress indicator | `ProgressBar` | `value` | Custom progress element |
| Toast notification | `Toast` | — | Custom toast |
| Empty state | Illustration + `Text` (composite pattern) | Use spot illustration + descriptive text | Large icon as placeholder |
| Skeleton loading | `Skeleton` | — | Custom shimmer |

### Overlays & Popovers

| UI Pattern | Constellation Component | Required Props | Anti-Pattern |
|-----------|------------------------|----------------|--------------|
| Modal dialog | `Modal` | `body={...} header={...} footer={...} dividers size="md"` | Content as children |
| Dropdown menu | `Menu` | — | Custom dropdown |
| Tooltip | `Tooltip` | `content` | `title` attribute |
| Popover | `Popover` | — | Custom absolute-positioned div |
| Action confirmation | `Modal` (small) | `size="sm"` | `window.confirm()` |

### Data Display

| UI Pattern | Constellation Component | Required Props | Anti-Pattern |
|-----------|------------------------|----------------|--------------|
| Data table | `Table` | — | Custom `<table>` |
| Accordion / expandable | `Accordion` | — | Custom toggle div |
| Pagination | `Pagination` | — | Custom page links |
| Navigation breadcrumbs | `Text` links with `Divider` or `Icon` separators | — | Custom link chain (no Breadcrumb component in catalog) |
| Grouped action buttons | `ButtonGroup` | `aria-label` | Loose buttons in Flex |

### Forms

| UI Pattern | Constellation Component | Required Props | Anti-Pattern |
|-----------|------------------------|----------------|--------------|
| Text area | `Textarea` | — | Styled `<textarea>` |
| Date picker | `DatePicker` | — | Custom date input |
| Switch / toggle | `Switch` | — | Custom toggle |
| Slider | `Slider` | — | Custom range input |
| Form field wrapper | `FormField` | `label` | Custom label + input layout |

## High-Risk Rule Checks

When mapping components, always verify these critical rules:

| # | Rule | Check |
|---|------|-------|
| 1 | PropertyCard save button | Every `PropertyCard` has `saveButton={<PropertyCard.SaveButton />}` |
| 2 | Card style exclusivity | Card has EITHER `elevated` OR `outlined`, never both |
| 3 | Card elevation + interactivity | `elevated` cards also have `interactive` |
| 4 | Card tone | Every `Card` has `tone="neutral"` |
| 5 | Header component | Page header uses `Page.Header`, not `Box`/`Flex` |
| 6 | Divider component | Visual separators use `<Divider />`, not CSS borders |
| 7 | Icon variant | Icons use Filled variant by default |
| 8 | Icon size tokens | Icons use `sm`/`md`/`lg`/`xl` size tokens |
| 9 | Tabs default selection | `Tabs.Root` has `defaultSelected` prop |
| 10 | Heading limit | Max 1-2 `Heading` components per screen |
| 11 | Blue for interactive only | Blue color only on buttons, links, actions |
| 12 | Background colors | White (`bg.screen.neutral`) or gray, no light blue |
| 13 | Modal body prop | Modal content in `body` prop, not children |
| 14 | Button size | Professional apps use `size="md"` |
| 15 | Logo sizing | Desktop: 24px height, Mobile: 16px height |
| 16 | Sticky header wrapper | Sticky `Page.Header` is wrapped in `Box` with `display: 'flow-root'`, not positioned directly |

## Figma-to-Constellation Mapping

When working from Figma designs (via MCP tools):

| Figma Pattern | Constellation Equivalent |
|--------------|------------------------|
| Auto Layout (vertical) | `Flex direction="column"` |
| Auto Layout (horizontal) | `Flex direction="row"` |
| Grid layout | `Grid` with responsive `columns` |
| Fill container | `width="100%"` or `flex={1}` |
| Fixed width | Explicit `width` prop |
| Corner radius 12px | Default Card/Button radius (don't override) |
| Corner radius 20px | Hero container radius |
| Drop shadow | `elevated` prop on Card |
| Stroke / border | `outlined` prop on Card or `<Divider />` |
| Component instance | Look up in Constellation component catalog |
| Design token reference | Map to PandaCSS semantic token |
