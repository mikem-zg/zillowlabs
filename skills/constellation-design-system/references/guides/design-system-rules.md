# Zillow Constellation Design System Rules

## TL;DR - Critical Rules (NEVER Violate)

```
1. PropertyCard → ALWAYS add saveButton={<PropertyCard.SaveButton />}
2. Card → Choose ONE of: elevated, outlined, or neither (NEVER both); ALWAYS set tone="neutral"
3. Headers → ALWAYS use Page.Header inside Page.Root (sticky headers: wrap Page.Header in a Box with display: flow-root)
4. Dividers → NEVER use CSS borders, ALWAYS use <Divider />
5. Icons → ALWAYS use Filled variants, ALWAYS use size tokens (sm/md/lg/xl)
6. Tabs → ALWAYS include defaultSelected prop
7. Heading → ONLY 1-2 per screen; use Text textStyle variants for hierarchy
8. Backgrounds → ALWAYS use bg.screen.neutral (white), NEVER light blue
9. Alignment → Left-align by default; center OK for short content (loading, empty states, heroes)
10. Professional apps → ALWAYS use size="md" for buttons/inputs
```

---

## AI Workflow (REQUIRED)

AFTER EVERY UI BUILD:
1. Request architect review against this file
2. Fix all violations
3. Re-verify before delivery

---

## Step 1: Identify the Audience

**Before building any UI, determine the target audience:**

| Audience | Description | Examples |
|----------|-------------|----------|
| **Consumer** | Users looking to buy, sell, or rent a home for themselves | Homebuyer, Renter, Seller, "My Home" dashboard |
| **Professional** | Users conducting business or providing services | Real Estate Agents, Loan Officers, Property Managers, "Agent Hub" |

---

## Consumer App Rules

**Goal:** "Get Home" | **Vibe:** Joyful, Vibrant, Emotional

| Category | Rule |
|----------|------|
| **Colors** | Full expressive palette - Teals, Oranges, Purples allowed for accents |
| **Backgrounds** | White or Gray only (no light blue or colored backgrounds) |
| **Icons** | Filled icons as default |
| **Illustrations** | Scene illustrations for storytelling + Spot illustrations for support |
| **Hero sections** | Can exceed 25% bold color limit for impact |

---

## Professional App Rules

**Goal:** "Unlock Success" | **Vibe:** Unflappable, Efficient, Organized, Trustworthy

| Category | Rule |
|----------|------|
| **Colors** | RESTRICTED - Blue (#0041D9) for actions, Granite (#111116) for text only |
| **Backgrounds** | Marble (#FFFFFF) + Light Gray (#F7F7F7) allowed for section differentiation |
| **Accents** | Waterfront (Navy) and Pool (Light Blue) sparingly |
| **PROHIBITED** | NO Purple, Orange, or vibrant Teals for UI elements |
| **Icons** | Filled icons (Gray950) for standard UI, Duotone icons for upsells/empty states |
| **Component sizing** | Default to `size="md"` for buttons, inputs, and other components |
| **Logo** | Use `ZillowLogo` component (same as Consumer: 24px desktop, 16px mobile) |
| **Illustrations** | Spot illustrations ONLY - no complex Scene illustrations |
| **Shadows** | Heavier, larger shadows on interactive elements only (not static elements) |
| **Text emphasis** | Use color sparingly - do not highlight random words |

### Professional App ALWAYS vs NEVER

| ALWAYS | NEVER |
|--------|-------|
| Blue for primary actions only | Purple, Orange, or Teal |
| Light Gray (#F7F7F7) for section backgrounds | Colored backgrounds |
| Duotone icons for upsells and empty states | Duotone icons everywhere |
| Shadows only on interactive/clickable elements | Shadows on static elements |
| Spot illustrations for metaphors | Scene illustrations (except onboarding) |
| `size="md"` for buttons, inputs, selects | Inconsistent component sizes |

---

## Component Selection (ALWAYS Check First)

| Building This? | ALWAYS Use | NEVER Use |
|----------------|------------|-----------|
| Page structure | `Page.Root` > `Page.Header` > `Page.Content` | Custom `Box`/`Flex` page layouts |
| Page header/nav | `Page.Header` inside `Page.Root` (sticky: wrap in `Box`) | `Box`/`Flex` as header; sticky directly on `Page.Header` |
| Breadcrumbs | `Page.Breadcrumb` inside `Page.Root` | Custom breadcrumb wrappers |
| Property listing | `PropertyCard` with `saveButton` | `Card` |
| Generic container | `Card tone="neutral"` (add `elevated` or `outlined` as needed) | custom `Box` without Card semantics |
| Modals/Dialogs | `Modal` with `header`/`footer` props | Custom overlays or `Dialog` |
| Single-select (price, beds) | `ToggleButtonGroup` + `ToggleButton` | `Button` |
| Segmented choices | `SegmentedControl` | `Button` group |
| Multi-select options | `ComboBox` (preferred) or `CheckboxGroup` | `Button` or custom checkboxes |
| Visual separator | `<Divider />` | CSS `border` |
| Form inputs | `Select`, `ComboBox`, `Checkbox`, `Radio`, `Input` | styled divs |
| Page headline (1-2 max) | `Heading textStyle="heading-lg"` | Multiple `Heading` per screen |
| Section/card titles | `Text textStyle="body-lg-bold"` or `body-bold` | `Heading` for every title |
| Body text | `Text textStyle="body"` | `p` or `span` |
| Layout stacking | `Flex direction="column"` | `Box` with margin |
| Empty states (Professional) | `IconXxxDuotone` | `IconXxxFilled` |
| Button with text + icon (sparingly) | `<Button icon={<IconX />} iconPosition="start">` | Flex wrapping icon + text inside Button |
| Icon-only button | `<IconButton title="Label" tone="neutral" emphasis="bare" size="md" shape="square">` | `<Button icon={<IconX />}>` without text |

### Card Styling Options

**ALWAYS** set `tone="neutral"`. Choose ONE style — **NEVER combine `elevated` and `outlined`:**

| Style | Props | When to use |
|-------|-------|-------------|
| **Elevated** (shadow) | `elevated interactive tone="neutral"` | Clickable/interactive cards — links, navigation, actions |
| **Outlined** (border) | `outlined elevated={false} tone="neutral"` | Static display cards — info panels, read-only content, form sections |
| **Minimal** (neither) | `elevated={false} tone="neutral"` | Subtle containers with no visual emphasis |

**Key rules:**
- Clickable cards → ALWAYS use `elevated` + `interactive` together (elevated cards should be interactive)
- Static/display cards → use `outlined` with `elevated={false}` (must explicitly disable elevation since `elevated` defaults to `true`)
- NEVER set both `elevated={true}` and `outlined={true}` on the same card — pick one

```tsx
// Clickable card — elevated + interactive
<Card elevated interactive tone="neutral" onClick={handleClick}>
  <Paragraph>Click to navigate</Paragraph>
</Card>

// Static display card — outlined, no elevation
<Card outlined elevated={false} tone="neutral">
  <Paragraph>Read-only information</Paragraph>
</Card>

// Minimal card — no emphasis
<Card elevated={false} tone="neutral">
  <Paragraph>Subtle container</Paragraph>
</Card>
```

---

## Required Component Props (MUST Include)

### Page (ALWAYS Use for Page Structure)

Every page MUST use `Page.Root` as the top-level wrapper. Use its sub-components for proper page structure:

```tsx
import { Heading, Page, Paragraph, TextButton, ButtonGroup } from '@zillow/constellation';
import { IconChevronLeftFilled } from '@zillow/constellation-icons';

// Basic page structure
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

#### Page Sub-Components

| Sub-Component | Purpose | Required? |
|---------------|---------|-----------|
| `Page.Root` | Top-level page wrapper | YES - always |
| `Page.Header` | Page header with heading | YES - for pages with titles |
| `Page.Content` | Page body section (can use multiple) | YES - for page content |
| `Page.Breadcrumb` | Breadcrumb navigation above header | Optional |

#### Page.Header with Actions

```tsx
<Page.Header>
  <Heading level={1}>Dashboard</Heading>
  <ButtonGroup aria-label="Page actions">
    <TextButton icon={<IconStarFilled />}>Save view</TextButton>
    <TextButton icon={<IconFilterFilled />}>Filters</TextButton>
  </ButtonGroup>
</Page.Header>
```

#### Fluid (Full-Width) Pages

```tsx
// Setting fluid on Page.Root applies to all child sub-components
<Page.Root fluid>
  <Page.Header>
    <Heading level={1}>Full-width page</Heading>
  </Page.Header>
  <Page.Content>
    <Paragraph>Content spans the full width.</Paragraph>
  </Page.Content>
</Page.Root>
```

#### Background Color

```tsx
// Default — white background (preferred)
<Page.Root css={{ background: 'bg.screen.neutral' }}>
  <Page.Header>
    <Heading level={1}>Standard page</Heading>
  </Page.Header>
  <Page.Content>
    <Paragraph>Page with default white background.</Paragraph>
  </Page.Content>
</Page.Root>

// Light gray for section differentiation (Professional apps only)
<Page.Root css={{ background: 'bg.soft' }}>
  <Page.Header>
    <Heading level={1}>Dashboard</Heading>
  </Page.Header>
  <Page.Content>
    <Paragraph>Page with subtle gray background.</Paragraph>
  </Page.Content>
</Page.Root>
```

**NEVER use `bg.accent.blue.soft` or any colored/blue background on `Page.Root`.** Only `bg.screen.neutral` (white) or `bg.soft` (light gray, Professional apps) are allowed. NEVER use custom hex colors — always use design tokens.

#### Sticky Header (CRITICAL)

`Page.Header` has built-in responsive `margin-block-start` and `margin-block-end` via Constellation design tokens. These margins create a visible grey gap between the viewport top and the header when scrolled. **Do NOT try to override them directly on `Page.Header`** — instead, wrap `Page.Header` in a `Box` that handles the sticky positioning:

```tsx
<Page.Root>
  <Box
    css={{
      position: 'sticky',
      display: 'flow-root',
      top: 0,
      zIndex: 10,
      width: '100%',
      maxWidth: '100%',
      background: 'bg.screen.neutral',
    }}
  >
    <Page.Header>
      <ZillowLogo role="img" css={{ height: 'obj.sm' }} />
      <Button icon={<IconSearchFilled />}>Browse Homes</Button>
    </Page.Header>
  </Box>
  <Page.Content>
    <Paragraph>Page content here.</Paragraph>
  </Page.Content>
</Page.Root>
```

| ALWAYS | NEVER |
|--------|-------|
| Wrap `Page.Header` in a sticky `Box` | Put `position: sticky` directly on `Page.Header` |
| Set `background: 'bg.screen.neutral'` on the sticky wrapper | Leave the wrapper background transparent |
| Use `display: 'flow-root'` on the wrapper | Skip `display: 'flow-root'` (needed to contain margins) |
| Use `zIndex: 10` on the wrapper | Skip z-index (header will scroll behind content) |

#### Polymorphic Sub-Components (Semantic HTML)

```tsx
<Page.Root>
  <Page.Header asChild>
    <header>
      <Heading level={1}>Semantic header</Heading>
    </header>
  </Page.Header>
  <Page.Content asChild>
    <main>
      <Paragraph>Main content area.</Paragraph>
    </main>
  </Page.Content>
</Page.Root>
```

### PropertyCard
```tsx
<PropertyCard
  saveButton={<PropertyCard.SaveButton />}  // REQUIRED - ALWAYS add
  interactive={true}                         // REQUIRED if clickable
  elevated={true}                            // REQUIRED for Professional apps
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
| **3. More menu** | | Additional actions popper |
| **4. Flex area** | | Large cards only - extra content |

---

## Imports (Copy This)

```tsx
// Components
import { 
  Button, Card, Text, Heading, Input, Tabs, PropertyCard, ZillowLogo,
  Icon, Divider, Select, Checkbox, Radio, ToggleButtonGroup, ToggleButton,
  SegmentedControl, CheckboxGroup, Page, Paragraph, TextButton, ButtonGroup
} from '@zillow/constellation';

// Icons - Always use Filled variants by default
import { IconHeartFilled, IconSearchFilled, IconHomeFilled } from '@zillow/constellation-icons';

// Styling
import { css } from '@/styled-system/css';
import { Box, Flex, Grid } from '@/styled-system/jsx';
```

---

## ALWAYS vs NEVER

### Colors & Backgrounds
| ALWAYS | NEVER |
|--------|-------|
| `bg.screen.neutral` (white) as default background | Light blue or colored backgrounds |
| `Blue600` ONLY for buttons/links/actions | Blue headlines (blue = interactive) |
| Bold colors under 25% of page | Large swaths of bold color |

### Icons
| ALWAYS | NEVER |
|--------|-------|
| **Filled** icons by default (`IconHeartFilled`) | Outline as default |
| `<Icon size="md">` (24px default) | Random icon sizes |
| Size tokens: `sm`, `md`, `lg`, `xl` | Custom pixel sizes or inline styles |
| `css={{ color: 'token.path' }}` for semantic colors | `color="token.path"` (color prop doesn't accept token paths) |

**Icon Color Note:** The Icon `color` prop does NOT accept semantic token paths. Use the `css` prop instead:

```tsx
// WRONG - color prop doesn't resolve token paths
<Icon size="md" color="icon.neutral"><IconHeartFilled /></Icon>

// CORRECT - use css prop for semantic tokens (requires theme injection)
<Icon size="md" css={{ color: 'icon.neutral' }}><IconHeartFilled /></Icon>
<Icon size="md" css={{ color: 'text.subtle' }}><IconHeartFilled /></Icon>

// FALLBACK - use style prop with CSS variables (when theme injection unavailable)
<Icon size="md" style={{ color: 'var(--color-icon-subtle)' }}><IconHeartFilled /></Icon>
```

### Button Icons

**Use icons in buttons sparingly.** Most buttons work fine with text alone. Only add an icon when it genuinely aids comprehension (e.g., search, filter, close). Do not add icons to buttons just for decoration.

**Text button with icon** (use sparingly):
```tsx
// Only when the icon adds real clarity
<Button icon={<IconSearchFilled />} iconPosition="start">
  Search
</Button>
```

**Icon-only button** (always use IconButton):
```tsx
// CORRECT — IconButton with bare neutral defaults
<IconButton title="Close" tone="neutral" emphasis="bare" size="md" shape="square">
  <Icon><IconCloseFilled /></Icon>
</IconButton>

// WRONG — Button with icon but no text
<Button icon={<IconCloseFilled />} />
```

**IconButton defaults:** Always start with `tone="neutral" emphasis="bare"` unless there is a specific reason for another style (e.g., a primary action that must be icon-only).

**WRONG — don't wrap icons and text in Flex:**
```tsx
<Button>
  <Flex>
    <Icon><IconSortFilled /></Icon>
    <Text>Sort</Text>
  </Flex>
</Button>
```

### Typography & Alignment
| ALWAYS | NEVER |
|--------|-------|
| Left-align by default | Center long paragraphs or body text |
| Center OK for: loading states, empty states, hero headlines (1-3 lines) | Center multi-paragraph content |
| **Sentence case** for all UI text | Title Case Or ALL CAPS |
| Capitalize only proper nouns (Zillow, Seattle) | Capitalize random words |
| Format text programmatically (capitalize first letter in logic) | `textTransform: "capitalize"` (creates Title Case on multi-word strings) |
| Use `Heading` only for 1-2 true headlines per screen | Overuse `Heading` (dilutes impact) |
| Use `Text` with appropriate textStyle for hierarchy | Raw HTML `<p>` or `<span>` |

### Modal Heading Rules

**Modal context:** Modals count as a separate screen context for the 1-2 Heading limit. A page with 1 Heading can open a modal that also has 1 Heading.

| Rule | Guidance |
|------|----------|
| Heading in `header` | `<Heading level={1}>` with NO `textStyle` override — renders at correct default size |
| Heading-less modal | Omit `header` prop — OK for confirmation dialogs and simple prompts |
| Prominent body text | `<Text textStyle="heading-lg">` — NEVER add a second `Heading` in modal body |
| Heading count | Max 1 `Heading` per modal (in the `header` prop only) |
| Heading size | NEVER override with custom `textStyle` — the default is intentional |

```tsx
// CORRECT — default heading size, no override
header={<Heading level={1}>Edit listing</Heading>}

// WRONG — custom textStyle overrides intended modal heading size
header={<Heading level={1} textStyle="heading-lg">Edit listing</Heading>}

// CORRECT — prominent value in modal body uses Text, not Heading
<Text textStyle="heading-lg">$365,000</Text>

// WRONG — second Heading component in modal body
<Heading level={2} textStyle="heading-lg">$365,000</Heading>
```

### Typography Hierarchy (Critical)

**`Heading` component:** Reserve for 1-2 true headlines per screen ONLY. Overusing dilutes impact.

| Content Type | Component + textStyle | Color |
|--------------|----------------------|-------|
| Page headline | `<Heading textStyle="heading-lg">` | default |
| Section title | `<Text textStyle="body-lg-bold">` | default |
| Card title | `<Text textStyle="body-bold">` | default |
| Description | `<Text textStyle="body">` | `text.subtle` |
| Fine print/hints | `<Text textStyle="body-sm">` | `text.subtle` |

### Page Structure & Headers
| ALWAYS | NEVER |
|--------|-------|
| `Page.Root` as the top-level page wrapper | Custom `Box`/`Flex` page layouts |
| `Page.Header` inside `Page.Root` (sticky: wrap in `Box` with `display: 'flow-root'`) | Sticky directly on `Page.Header`; custom headers with `Box` or `Flex` |
| `Page.Content` for page body sections | Unsemantic wrapper divs |
| `Page.Breadcrumb` for breadcrumb navigation | Custom breadcrumb containers |
| Solid backgrounds on sticky headers (`bg.screen.neutral`) | Transparent sticky header backgrounds |
| `<Divider />` below headers | CSS `border` or `borderBottom` |
| `fluid` prop on `Page.Root` for full-width layouts | Manual `maxWidth` overrides |

### Logo Sizing (REQUIRED)
| Context | Size |
|---------|------|
| Desktop | 24px height ONLY |
| Mobile | 16px height ONLY |

---

## Color Tokens (Semantic Usage)

| Token | Purpose | Use For |
|-------|---------|---------|
| `Blue600` | Interactive/Action | Buttons, links, primary actions ONLY |
| `Teal600` | Trust/Finance | Home loans, agent connections |
| `Orange600` | Urgency/Focus | "New", "Open House", alerts |
| `Purple500` | Creativity/News | "New Features", inspiration |
| `Gray`, `White` | Backgrounds | All background colors |

---

## Token Syntax

```tsx
// In css() or JSX props: use token value only (NO prefix)
<Box bg="bg.default" p="400" borderRadius="node.md" />

// In token() function: use full path WITH prefix
token('spacing.400')
```

---

## Shape & Elevation

**Do not override component default corner radii.**

| Element | Corner Radius |
|---------|---------------|
| Cards, Buttons | 12px (default) |
| Hero/Large containers | 20px |

| Context | Shadow |
|---------|--------|
| Property Cards (high interactivity) | Large shadow |
| Chips, small interactive elements | Small shadow |
| Dark Mode | NO shadows - use lighter backgrounds |

---

## Hero Sections

**Hero sections are the ONLY exception to the 25% bold color limit.**

| ALWAYS | NEVER |
|--------|-------|
| **20px** rounded corners for hero containers | 12px (standard) corners for heroes |
| Pick ONE color family (Teal/Orange/Purple) for hero | Mix multiple color families |
| Use SAME color family for elements below hero | Switch to different color family down page |
| ONE accent color for text emphasis | Multiple highlight colors in headline |
| Teal/Orange/Purple for text highlights | Blue for text highlights (Blue = interactive only) |

---

## Illustrations

### File Locations

| Theme | Path |
|-------|------|
| Light Mode | `client/src/assets/illustrations/Lightmode/{name}.svg` |
| Dark Mode | `client/src/assets/illustrations/Darkmode/{name}.svg` |

### Import Example

```tsx
import SearchHomesLight from '@/assets/illustrations/Lightmode/search-homes.svg';
import SearchHomesDark from '@/assets/illustrations/Darkmode/search-homes.svg';

<img src={isDarkMode ? SearchHomesDark : SearchHomesLight} alt="Search homes" />
```

### Sizing

| Type | Size | Use For |
|------|------|---------|
| Standard Spot | 160x160px | Empty states, value prop lists, product upsell banners |
| Compact Spot | 120x120px | Tighter layouts, inline with content |

---

## Common Page Patterns

### Error / 404 Page

Pick an appropriate illustration from the illustrations catalog (see `custom_instruction/illustrations-catalog.md`). If no exact match exists, use a general-purpose illustration like `search-homes` or `no-results`.

```tsx
import { Button, Heading, Page, Text } from '@zillow/constellation';
import { css } from '@/styled-system/css';
import { Flex } from '@/styled-system/jsx';
// Choose an illustration from the catalog — check illustrations-catalog.md for available assets
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

**Key rules this pattern enforces:**
- Uses `Page.Root` (not raw Flex/Box layout)
- Uses a Constellation illustration (not an oversized icon) — check the catalog for available assets
- Background is `bg.screen.neutral` (inherited from Page.Root default)
- Single `Heading` with no `textStyle` override (component renders at correct default size)
- Sentence case text
- Centered layout (OK for empty/error states)

---

## NEVER DO (Anti-Patterns)

| NEVER | ALWAYS Instead |
|-------|----------------|
| `Box`/`Flex` for page structure or headers | `Page.Root` > `Page.Header` > `Page.Content` |
| `Button` for selection/toggle UI | `ToggleButtonGroup`, `SegmentedControl`, or `CheckboxGroup` |
| CSS `border` for dividers or container outlines | `<Divider />` for separators; `<Card outlined elevated={false}>` for bordered containers |
| Custom save buttons on PropertyCard | `PropertyCard.SaveButton` |
| Light blue backgrounds or custom hex colors | `bg.screen.neutral` (white) or `bg.soft` (light gray) — always use design tokens |
| Center long paragraphs or body text | Left-align by default; center OK for short content |
| Blue headlines | Blue = interactive only |
| Outline icons as default | Filled icons |
| Custom form controls | `Select`, `Checkbox`, `Radio`, `Input`, `ComboBox` |
| `Box` for text stacking | `Flex direction="column"` |
| Random logo sizes | Desktop: 24px, Mobile: 16px ONLY |
| Remove beige background from spot illustrations | Keep the blob to ground the visual |
| Illustrations for simple highlights | X-Large (44px) icons |
| Tabs without defaultSelected | `<Tabs.Root defaultSelected="...">` |
| Heavy box-shadows on card hover | Subtle elevation or border emphasis |
| Custom `Box` with bg/borderRadius/padding for labels/badges | `<Tag size="sm" tone="blue">Label</Tag>` |
| `<Icon color="icon.neutral">` (color prop) | `<Icon css={{ color: 'icon.neutral' }}>` (css prop) |
| Wrapping icon+text in Flex inside `<Button>` | `<Button icon={<IconXFilled />} iconPosition="start">` |
| `<Icon>` wrapper inside Button `icon` prop | Pass raw icon: `icon={<IconXFilled />}` |
| `<IconButton>` without `title` prop | `<IconButton title="Search">` (required for accessibility) |
| Icons on every button for decoration | Icons in buttons only when they genuinely aid comprehension |
| `<Button icon={<IconX />}>` without text for icon-only actions | `<IconButton title="Label" tone="neutral" emphasis="bare">` |
| Modal content as children | `body={<content />}` prop (REQUIRED for proper spacing) |
| Action buttons inside Modal `body` | Use Modal `footer` with `ButtonGroup` |
| Raw `Flex` or `Box` in Modal `footer` | `<ButtonGroup aria-label="modal actions">` with `Modal.Close` wrapper for cancel |

---

## Common Mistakes with Examples

### Labels and Badges — Use Tag, Not Box

```tsx
// WRONG — custom Box styled as a badge
<Box css={{ bg: "bg.accent.blue.soft", borderRadius: "8px", px: "200", py: "100" }}>
  <Text textStyle="body-sm-bold" css={{ color: "text.action.trust.hero.default" }}>
    Custom skill
  </Text>
</Box>

// CORRECT — use Tag component
<Tag size="sm" tone="blue">Custom skill</Tag>
```

### Tags Must Never Wrap Text

Tag text must always render on a single line. When placing Tags in a flex container, always add `css={{ whiteSpace: 'nowrap' }}` to each Tag so the label never breaks across lines. If multiple Tags might overflow their container, set `flexWrap: 'wrap'` on the parent Flex so Tags flow to the next row instead of being squeezed and wrapping internally.

```tsx
// WRONG — Tags can wrap text when container is narrow
<Flex align="center" gap="200">
  <Tag size="sm" tone="green">Developer Tools</Tag>
  <Tag size="sm" tone="blue">In development</Tag>
</Flex>

// CORRECT — whiteSpace: 'nowrap' prevents internal text wrapping
<Flex align="center" gap="200" css={{ flexWrap: 'wrap' }}>
  <Tag size="sm" tone="green" css={{ whiteSpace: 'nowrap' }}>Developer Tools</Tag>
  <Tag size="sm" tone="blue" css={{ whiteSpace: 'nowrap' }}>In development</Tag>
</Flex>
```

### Icons in Buttons — Use Built-in Props

```tsx
// WRONG — Flex wrapping icon and text inside Button
<Button>
  <Flex align="center" gap="100">
    <Icon size="sm"><IconSortFilled /></Icon>
    <Text>Sort</Text>
  </Flex>
</Button>

// CORRECT — use icon and iconPosition props
<Button icon={<IconSortFilled />} iconPosition="start">Sort</Button>
```

### Icon Color — Use css Prop, Not color Prop

```tsx
// WRONG — color prop doesn't resolve semantic tokens
<Icon size="md" color="icon.neutral"><IconHeartFilled /></Icon>

// CORRECT — css prop resolves semantic tokens
<Icon size="md" css={{ color: 'icon.neutral' }}><IconHeartFilled /></Icon>
```

### Modal Content — Use body Prop, Not Children

```tsx
// WRONG — content as children
<Modal open={isOpen} onOpenChange={setIsOpen}>
  <Text>This content won't have proper spacing</Text>
</Modal>

// CORRECT — content in body prop
<Modal
  size="md"
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Title</Heading>}
  body={<Text>This content has proper spacing</Text>}
  footer={
    <ButtonGroup aria-label="actions">
      <Modal.Close><TextButton>Cancel</TextButton></Modal.Close>
      <Button emphasis="filled" tone="brand">Save</Button>
    </ButtonGroup>
  }
/>
```
