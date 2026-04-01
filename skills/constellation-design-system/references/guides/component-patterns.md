# Component Patterns

Load this file when building UI components. For critical rules (must-read every session), see [design-system-rules.md](design-system-rules.md). For token/styling reference, see [token-reference.md](token-reference.md).

---

## Component Selection (ALWAYS Check First)

| Building This? | ALWAYS Use | NEVER Use |
|----------------|------------|-----------|
| Page structure | `Page.Root` > `Page.Header` > `Page.Content` | Custom `Box`/`Flex` page layouts |
| Page header/nav | `Flex` inside sticky `Box` (see header-navigation skill); `Page.Header` OK for non-sticky simple pages | Sticky directly on `Page.Header` (margin-block gap) |
| Breadcrumbs | `Page.Breadcrumb` inside `Page.Root` | Custom breadcrumb wrappers |
| Property listing | `PropertyCard` with `saveButton` | `Card` |
| Generic container | `Card tone="neutral"` (add `elevated` or `outlined` as needed) | custom `Box` without Card semantics |
| Modals/Dialogs | `Modal` with `header`/`footer` props | Custom overlays or `Dialog` |
| Single-select (price, beds) | `ToggleButtonGroup` + `ToggleButton` | `Button` |
| Segmented choices | `ToggleButtonGroup` + `ToggleButton` | `Button` group |
| Multi-select options | `ComboBox` (preferred) or `CheckboxGroup` | `Button` or custom checkboxes |
| Visual separator | `<Divider />` | CSS `border` |
| Form inputs | `Select`, `ComboBox`, `Checkbox`, `Radio`, `Input` | styled divs |
| Page headline (1-2 max) | `Heading textStyle="heading-lg"` | Multiple `Heading` per screen |
| Section/card titles | `Text textStyle="body-lg-bold"` or `body-bold` | `Heading` for every title |
| Body text | `Text textStyle="body"` | `p` or `span` |
| Layout stacking | `Flex direction="column"` or `VStack` or `Stack` (from `@/styled-system/jsx`) | Bare `<Flex>` without direction (defaults to row); `Box` with margin |
| Labels/badges/tags (display-only) | `<Tag size="sm" tone="blue" css={{ whiteSpace: 'nowrap' }}>` | custom Box with bg/borderRadius |
| Toggleable filter/selection | `FilterChip` | `Tag` with onClick (Tag is display-only) |
| Empty states / upsells | `<DuoColorIcon tone="trust" onBackground="default"><Icon><IconXxxFilled /></Icon></DuoColorIcon>` | `IconXxxDuotone` (doesn't exist) |
| Button with text + icon (sparingly) | `<Button icon={<IconX />} iconPosition="start">` — only when icon aids comprehension | Flex wrapping icon + text inside Button; icons on every text button |
| Icon-only button | `<IconButton title="Label" tone="neutral" emphasis="bare" size="md" shape="square">` | `<Button icon={<IconX />}>` without text |
| Data table | `<Table size="sm">` inside `Card outlined` — do NOT override child sizes | Vertical table; custom div grids |
| Secondary actions | Outlined or subtle button variants | Filled buttons for everything |

---

## Card Styling

**ALWAYS** set `tone="neutral"`. Choose ONE style — **NEVER combine `elevated` and `outlined`:**

| Style | Props | When to use |
|-------|-------|-------------|
| **Elevated** (shadow) | `elevated interactive tone="neutral"` | Clickable/interactive cards — links, navigation, actions |
| **Outlined** (border) | `outlined elevated={false} tone="neutral"` | Static display cards — info panels, read-only content, form sections |
| **Minimal** (neither) | `elevated={false} tone="neutral"` | Subtle containers with no visual emphasis |

```tsx
<Card elevated interactive tone="neutral" onClick={handleClick}>
  <Paragraph>Click to navigate</Paragraph>
</Card>

<Card outlined elevated={false} tone="neutral">
  <Paragraph>Read-only information</Paragraph>
</Card>

<Card elevated={false} tone="neutral">
  <Paragraph>Subtle container</Paragraph>
</Card>
```

---

## Page Structure

Every page MUST use `Page.Root` as the top-level wrapper.

```tsx
<Page.Root>
  <Page.Breadcrumb>
    <TextButton icon={<IconChevronLeftFilled />}>Back to listings</TextButton>
  </Page.Breadcrumb>
  <Page.Header>
    <Heading level={1}>Page title</Heading>
  </Page.Header>
  <Page.Content>
    <Paragraph>Page body content goes here.</Paragraph>
  </Page.Content>
</Page.Root>
```

| Sub-Component | Purpose | Required? |
|---------------|---------|-----------|
| `Page.Root` | Top-level page wrapper | YES - always |
| `Page.Header` | Page header with heading | YES - for pages with titles |
| `Page.Content` | Page body section (can use multiple) | YES - for page content |
| `Page.Breadcrumb` | Breadcrumb navigation above header | Optional |

### Page.Header with Actions

```tsx
<Page.Header>
  <Heading level={1}>Dashboard</Heading>
  <ButtonGroup aria-label="Page actions">
    <TextButton icon={<IconStarFilled />}>Save view</TextButton>
    <TextButton icon={<IconFilterFilled />}>Filters</TextButton>
  </ButtonGroup>
</Page.Header>
```

### Fluid (Full-Width) Pages

```tsx
<Page.Root fluid>
  <Page.Header><Heading level={1}>Full-width page</Heading></Page.Header>
  <Page.Content><Paragraph>Content spans the full width.</Paragraph></Page.Content>
</Page.Root>
```

### Sidebar Layouts

`Page.Root` wraps the **content pane only** — not the entire viewport.

```tsx
<Flex>
  <Sidebar />
  <Page.Root>
    <Page.Content>...</Page.Content>
  </Page.Root>
</Flex>
```

### Sticky Header

`Page.Header` has built-in responsive margins that create a grey gap when sticky. Wrap in a `Box` instead:

```tsx
<Page.Root>
  <Box css={{ position: 'sticky', display: 'flow-root', top: 0, zIndex: 10,
              width: '100%', maxWidth: '100%', background: 'bg.screen.neutral' }}>
    <Page.Header>
      <ZillowLogo role="img" css={{ height: 'obj.sm' }} />
      <Button icon={<IconSearchFilled />}>Browse Homes</Button>
    </Page.Header>
  </Box>
  <Page.Content><Paragraph>Page content here.</Paragraph></Page.Content>
</Page.Root>
```

### Polymorphic Sub-Components

```tsx
<Page.Header asChild><header><Heading level={1}>Semantic header</Heading></header></Page.Header>
<Page.Content asChild><main><Paragraph>Main content area.</Paragraph></main></Page.Content>
```

---

## PropertyCard

```tsx
<PropertyCard
  saveButton={<PropertyCard.SaveButton />}
  interactive={true}
  elevated={true}
/>
```

### PropertyCard Anatomy

| Area | Sub-area | Content |
|------|----------|---------|
| **1. Photo area** | 1A. Badges | Status badges (e.g., "New", "Open House") |
| | 1B. Save button | Heart icon via `saveButton={<PropertyCard.SaveButton />}` |
| | 1C. MLS logo | Listing source branding |
| | 1D. Photo carousel | Property images |
| **2. Data areas** | 2A. Data area 1 | Price (e.g., "$1,695,000") |
| | 2B. Data area 2 | Beds, baths, sqft, property type |
| | 2C. Data area 3 | Address |
| | 2D/2E. Data area 4-5 | Listing agent/broker info |

---

## Modal

**ALWAYS use `body` prop for content — NEVER children. Default to `size="md"`.**

```tsx
<Modal
  size="md"
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Modal title</Heading>}
  body={
    <Flex direction="column" gap="300">
      <Text>Modal body content goes in the body prop</Text>
    </Flex>
  }
  footer={
    <ButtonGroup aria-label="modal actions">
      <Modal.Close><TextButton>Cancel</TextButton></Modal.Close>
      <Button emphasis="filled" tone="brand">Save</Button>
    </ButtonGroup>
  }
/>
```

### Modal Heading Rules

| Rule | Guidance |
|------|----------|
| Heading in `header` | `<Heading level={1}>` with NO `textStyle` override |
| Heading-less modal | Omit `header` prop — OK for confirmation dialogs |
| Prominent body text | `<Text textStyle="heading-lg">` — NEVER add a second `Heading` in body |
| Heading count | Max 1 `Heading` per modal (in the `header` prop only) |

---

## Button Icons

**Use icons in buttons sparingly.** Only add when genuinely aids comprehension.

```tsx
<Button icon={<IconSearchFilled />} iconPosition="start">Search</Button>
```

**Icon-only button** — always use `IconButton`:

```tsx
<IconButton title="Close" tone="neutral" emphasis="bare" size="md" shape="square">
  <Icon><IconCloseFilled /></Icon>
</IconButton>
```

---

## Tag Component

**Icon support requires default size.** `size="sm"` with `icon` will not render the icon.

```tsx
<Tag icon={<IconUserFilled />} css={{ whiteSpace: "nowrap" }}>Mike Payne</Tag>
<Tag size="sm" tone="blue" css={{ whiteSpace: "nowrap" }}>Label</Tag>
```

Tags stretch in flex column layouts. Wrap in `Flex` with `alignSelf: "flex-start"` to hug content.

Tags must use sentence case. NEVER ALL CAPS or Title Case.

---

## Typography Hierarchy

Load the brand skill (`consumer-brand-guidelines` or `professional-brand-guidelines`) for audience-specific typography tables. General hierarchy:

| Content Type | Component + textStyle | Color |
|--------------|----------------------|-------|
| Page headline | `<Heading textStyle="heading-lg">` | default |
| Section title | `<Text textStyle="body-lg-bold">` | default |
| Card title | `<Text textStyle="body-bold">` | default |
| Description | `<Text textStyle="body">` | `text.subtle` |
| Fine print/hints | `<Text textStyle="body-sm">` | `text.subtle` |

---

## ALWAYS vs NEVER Quick Reference

| ALWAYS | NEVER |
|--------|-------|
| Left-align by default | Center long paragraphs or body text |
| Sentence case for all UI text | Title Case Or ALL CAPS |
| `Heading` for 1-2 true headlines per screen | Overuse `Heading` |
| `Flex direction="column"` for vertical stacking | Bare `<Flex>` without direction |
| `<Tag>` for labels/badges | Custom Box with bg/borderRadius/padding |
| `PropertyCard.SaveButton` | Custom save buttons |
| `<Divider />` for content separators | CSS `border` |
| Constellation form components | Raw HTML form elements |
| `<IconButton title="...">` for icon-only actions | `<Button icon={...}>` without text |
| Modal `body` prop for content | Modal children |

---

## Error / 404 Page Pattern

```tsx
import NotFoundIllustration from '@/assets/illustrations/Lightmode/search-homes.svg';

<Page.Root>
  <Page.Content>
    <Flex align="center" justify="center" direction="column" gap="300"
          css={{ minHeight: '60vh' }}>
      <img src={NotFoundIllustration} alt="Page not found"
           className={css({ width: '160px', height: '160px' })} />
      <Heading level={1}>Page not found</Heading>
      <Text textStyle="body" css={{ color: 'text.subtle' }}>
        The page you are looking for does not exist.
      </Text>
      <Button tone="brand" emphasis="filled" size="md">Go home</Button>
    </Flex>
  </Page.Content>
</Page.Root>
```
