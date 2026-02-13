# Common Pitfalls

Every known Constellation gotcha in one place. For each pitfall: the wrong code, the correct code, and why it matters.

---

### 1. Card: combining elevated and outlined

**Rule:** Never set both `elevated` and `outlined` on the same Card — pick one.

```tsx
// WRONG
<Card elevated outlined tone="neutral">
  <Text>Content</Text>
</Card>

// CORRECT — elevated + interactive (clickable)
<Card elevated interactive tone="neutral" onClick={handleClick}>
  <Text>Content</Text>
</Card>

// CORRECT — outlined, no elevation (static)
<Card outlined elevated={false} tone="neutral">
  <Text>Content</Text>
</Card>
```

**Why:** Elevated and outlined are two distinct visual treatments. Combining them creates an inconsistent look that violates the design system. Choose elevated for interactive cards and outlined for static display cards.

---

### 2. Card: forgetting tone="neutral"

**Rule:** Always set `tone="neutral"` on every Card.

```tsx
// WRONG
<Card elevated interactive>
  <Text>Content</Text>
</Card>

// CORRECT
<Card elevated interactive tone="neutral">
  <Text>Content</Text>
</Card>
```

**Why:** Without `tone="neutral"`, the Card may render with an unintended default tone that doesn't match the design system's expected appearance.

---

### 3. Card: elevated without interactive

**Rule:** Elevated cards must also be interactive. If a card has a shadow, it should be clickable.

```tsx
// WRONG — elevated but not interactive
<Card elevated tone="neutral">
  <Text>Static content</Text>
</Card>

// CORRECT — elevated + interactive (for clickable cards)
<Card elevated interactive tone="neutral" onClick={handleClick}>
  <Text>Clickable content</Text>
</Card>

// CORRECT — static card uses outlined, not elevated
<Card outlined elevated={false} tone="neutral">
  <Text>Static content</Text>
</Card>
```

**Why:** Elevation (shadow) signals interactivity to users. A card with a shadow that isn't clickable is misleading. Use `outlined` with `elevated={false}` for static display cards.

---

### 4. PropertyCard: missing saveButton prop

**Rule:** Always include `saveButton={<PropertyCard.SaveButton />}` on every PropertyCard.

```tsx
// WRONG
<PropertyCard
  data={{ dataArea1: '$500,000', dataArea3: '123 Main St' }}
  elevated
  interactive
/>

// CORRECT
<PropertyCard
  saveButton={<PropertyCard.SaveButton />}
  data={{ dataArea1: '$500,000', dataArea3: '123 Main St' }}
  elevated
  interactive
/>
```

**Why:** The save button (heart icon) is a core part of the PropertyCard experience. Users expect to be able to save listings. Never use a custom save button — always use `PropertyCard.SaveButton`.

---

### 5. Modal: passing content as children instead of body prop

**Rule:** Always use the `body` prop for Modal content — never pass content as children.

```tsx
// WRONG — content as children
<Modal open={isOpen} onOpenChange={setIsOpen}>
  <Text>This content won't be styled correctly</Text>
</Modal>

// CORRECT — content in body prop
<Modal
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Title</Heading>}
  body={<Text>This content gets proper spacing and scrolling</Text>}
  footer={
    <ButtonGroup aria-label="modal actions">
      <Modal.Close><TextButton>Cancel</TextButton></Modal.Close>
      <Button emphasis="filled" tone="brand">Save</Button>
    </ButtonGroup>
  }
/>
```

**Why:** The Modal component applies proper padding, scrolling, and layout only to content passed through the `body` prop. Children are not rendered in the expected content area.

---

### 6. Modal: missing dividers prop

**Rule:** Always include the `dividers` prop on Modal.

```tsx
// WRONG
<Modal
  open={isOpen}
  onOpenChange={setIsOpen}
  header={<Heading level={1}>Title</Heading>}
  body={<Text>Content</Text>}
/>

// CORRECT
<Modal
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Title</Heading>}
  body={<Text>Content</Text>}
/>
```

**Why:** The `dividers` prop adds visual separation between the header, body, and footer sections. Without it, the modal looks unfinished and sections blend together.

---

### 7. Modal: action buttons in body instead of footer

**Rule:** Action buttons must go in the `footer` prop, never inside `body`.

```tsx
// WRONG — buttons in body
<Modal
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Confirm</Heading>}
  body={
    <Flex direction="column" gap="400">
      <Text>Are you sure?</Text>
      <ButtonGroup>
        <Button>Cancel</Button>
        <Button emphasis="filled" tone="brand">Confirm</Button>
      </ButtonGroup>
    </Flex>
  }
/>

// CORRECT — buttons in footer
<Modal
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Confirm</Heading>}
  body={<Text>Are you sure?</Text>}
  footer={
    <ButtonGroup aria-label="modal actions">
      <Modal.Close><TextButton>Cancel</TextButton></Modal.Close>
      <Button emphasis="filled" tone="brand">Confirm</Button>
    </ButtonGroup>
  }
/>
```

**Why:** The footer is sticky and stays visible when body content scrolls. Placing buttons in the body means users may not see them if content is long. Use `Modal.Close` wrapper for the cancel action.

---

### 8. Tabs: using defaultValue instead of defaultSelected

**Rule:** Constellation Tabs use `defaultSelected`, not `defaultValue`.

```tsx
// WRONG
<Tabs.Root defaultValue="tab1">
  <Tabs.List>
    <Tabs.Tab value="tab1">Overview</Tabs.Tab>
    <Tabs.Tab value="tab2">Details</Tabs.Tab>
  </Tabs.List>
</Tabs.Root>

// CORRECT
<Tabs.Root defaultSelected="tab1">
  <Tabs.List>
    <Tabs.Tab value="tab1">Overview</Tabs.Tab>
    <Tabs.Tab value="tab2">Details</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="tab1">Overview content</Tabs.Panel>
  <Tabs.Panel value="tab2">Details content</Tabs.Panel>
</Tabs.Root>
```

**Why:** `defaultValue` is from other tab libraries (Radix, MUI). Constellation uses `defaultSelected`. Using the wrong prop name means no tab will be selected on mount.

---

### 9. Tabs: missing defaultSelected entirely

**Rule:** Always include `defaultSelected` on Tabs.Root.

```tsx
// WRONG — no default selection
<Tabs.Root>
  <Tabs.List>
    <Tabs.Tab value="tab1">Overview</Tabs.Tab>
    <Tabs.Tab value="tab2">Details</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="tab1">Overview content</Tabs.Panel>
  <Tabs.Panel value="tab2">Details content</Tabs.Panel>
</Tabs.Root>

// CORRECT
<Tabs.Root defaultSelected="tab1">
  <Tabs.List>
    <Tabs.Tab value="tab1">Overview</Tabs.Tab>
    <Tabs.Tab value="tab2">Details</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="tab1">Overview content</Tabs.Panel>
  <Tabs.Panel value="tab2">Details content</Tabs.Panel>
</Tabs.Root>
```

**Why:** Without `defaultSelected`, no tab panel is visible on initial render. Users see tab headers but no content, which looks broken.

---

### 10. Icon: using color prop instead of css prop for token colors

**Rule:** Use the `css` prop (not `color` prop) to apply semantic token colors to icons.

```tsx
// WRONG — color prop doesn't resolve token paths
<Icon size="md" color="icon.neutral"><IconHeartFilled /></Icon>
<Icon size="md" color="text.subtle"><IconInfoFilled /></Icon>

// CORRECT — use css prop for semantic tokens
<Icon size="md" css={{ color: 'icon.neutral' }}><IconHeartFilled /></Icon>
<Icon size="md" css={{ color: 'text.subtle' }}><IconInfoFilled /></Icon>

// FALLBACK — use style prop with CSS variables (when theme injection unavailable)
<Icon size="md" style={{ color: 'var(--color-icon-subtle)' }}><IconHeartFilled /></Icon>
```

**Why:** The Icon `color` prop does not accept semantic token paths. Passing a token path to `color` renders the literal string as a CSS color value, which the browser ignores. The `css` prop resolves tokens through PandaCSS.

---

### 11. Icon: using Outline variant instead of Filled

**Rule:** Always use Filled icon variants by default.

```tsx
// WRONG
import { IconHeartOutline, IconSearchOutline } from '@zillow/constellation-icons';
<Icon size="md"><IconHeartOutline /></Icon>

// CORRECT
import { IconHeartFilled, IconSearchFilled } from '@zillow/constellation-icons';
<Icon size="md"><IconHeartFilled /></Icon>
```

**Why:** Constellation's design language uses Filled icons as the default. Outline variants are not the standard and should only be used in specific exception cases.

---

### 12. Icon: missing Icon wrapper (using raw icon component)

**Rule:** Always wrap icon components in the `Icon` wrapper with a size token.

```tsx
// WRONG — raw icon without wrapper
import { IconSearchFilled } from '@zillow/constellation-icons';
<IconSearchFilled />

// CORRECT — wrapped in Icon with size token
import { Icon } from '@zillow/constellation';
import { IconSearchFilled } from '@zillow/constellation-icons';
<Icon size="md"><IconSearchFilled /></Icon>
```

**Why:** The `Icon` wrapper applies consistent sizing via design tokens. Without it, the icon renders at an unpredictable default size and doesn't follow the size scale (sm/md/lg/xl).

---

### 13. Icon: custom pixel sizes instead of size tokens

**Rule:** Use size tokens (sm, md, lg, xl) — never custom pixel sizes.

```tsx
// WRONG — custom pixel sizes
<Icon style={{ width: '18px', height: '18px' }}><IconHomeFilled /></Icon>
<Icon style={{ fontSize: '32px' }}><IconHomeFilled /></Icon>

// CORRECT — use size tokens
<Icon size="sm"><IconHomeFilled /></Icon>   {/* small */}
<Icon size="md"><IconHomeFilled /></Icon>   {/* 24px default */}
<Icon size="lg"><IconHomeFilled /></Icon>   {/* large */}
<Icon size="xl"><IconHomeFilled /></Icon>   {/* extra large */}
```

**Why:** Custom pixel sizes break visual consistency. The size tokens ensure icons match the spacing and typography scale throughout the app.

---

### 14. Divider: using CSS border/hr instead of Divider component

**Rule:** Always use `<Divider />` for visual separators — never CSS borders or `<hr>`.

```tsx
// WRONG — CSS border
<div style={{ borderBottom: '1px solid #e0e0e0' }} />

// WRONG — HTML hr
<hr className="border-gray-200 my-4" />

// WRONG — Box with border
<Box css={{ borderBottom: '1px solid', borderColor: 'border.default' }} />

// CORRECT
import { Divider } from '@zillow/constellation';
<Divider />
```

**Why:** The Divider component uses the correct design token colors, spacing, and thickness. CSS borders won't update with theme changes and may have incorrect colors.

---

### 15. Header: using Box/Flex instead of Page.Header

**Rule:** Always use `Page.Header` inside `Page.Root` for navigation headers.

```tsx
// WRONG — custom header with Flex
<Flex
  justify="space-between"
  align="center"
  css={{ p: '400', bg: 'bg.screen.neutral' }}
>
  <ZillowLogo />
  <Button>Sign in</Button>
</Flex>

// CORRECT
<Page.Root>
  <Page.Header>
    <ZillowLogo css={{ height: '24px', width: 'auto' }} />
    <Button>Sign in</Button>
  </Page.Header>
  <Divider />
  <Page.Content>
    {/* page content */}
  </Page.Content>
</Page.Root>
```

**Why:** `Page.Header` provides built-in responsive behavior, proper semantic structure, and consistent positioning that a custom Flex header cannot replicate.

---

### 16. Header: CSS border below header instead of Divider

**Rule:** Use `<Divider />` below headers — never CSS borderBottom.

```tsx
// WRONG
<Page.Header css={{ borderBottom: '1px solid #e0e0e0' }}>
  <ZillowLogo />
</Page.Header>

// CORRECT
<Page.Header>
  <ZillowLogo css={{ height: '24px', width: 'auto' }} />
</Page.Header>
<Divider />
```

**Why:** CSS borders don't use design token colors and won't adapt to theme changes. The Divider component is the standard visual separator.

---

### 17. Header: transparent sticky header background

**Rule:** Sticky headers must have a solid background color.

```tsx
// WRONG — transparent background
<Page.Header css={{ position: 'sticky', top: 0 }}>
  <ZillowLogo />
</Page.Header>

// CORRECT — solid background
<Page.Header css={{ position: 'sticky', top: 0, bg: 'bg.screen.neutral', zIndex: 10 }}>
  <ZillowLogo css={{ height: '24px', width: 'auto' }} />
</Page.Header>
```

**Why:** Transparent sticky headers cause content to show through as users scroll, making text unreadable. Always use `bg.screen.neutral` (white) for sticky headers.

---

### 18. Typography: overusing Heading

**Rule:** Use Heading for only 1-2 true headlines per screen. Use Text with textStyle variants for all other titles.

```tsx
// WRONG — Heading for every title
<Heading textStyle="heading-lg">Dashboard</Heading>
<Heading textStyle="heading-md">Recent activity</Heading>
<Heading textStyle="heading-sm">Saved homes</Heading>
<Heading textStyle="heading-sm">Notifications</Heading>
<Heading textStyle="heading-sm">Settings</Heading>

// CORRECT — one Heading, Text for the rest
<Heading textStyle="heading-lg">Dashboard</Heading>
<Text textStyle="body-lg-bold">Recent activity</Text>
<Text textStyle="body-lg-bold">Saved homes</Text>
<Text textStyle="body-lg-bold">Notifications</Text>
<Text textStyle="body-lg-bold">Settings</Text>
```

**Why:** Overusing Heading dilutes its visual impact and creates a flat hierarchy. Reserve Heading for the page's primary title; use Text variants for section and card titles.

---

### 19. Typography: using raw HTML p/span instead of Text

**Rule:** Always use the `Text` component — never raw `<p>` or `<span>` tags.

```tsx
// WRONG
<p>Browse listings near you.</p>
<span className="text-gray-500">Updated 2 hours ago</span>

// CORRECT
<Text textStyle="body">Browse listings near you.</Text>
<Text textStyle="body-sm" css={{ color: 'text.subtle' }}>Updated 2 hours ago</Text>
```

**Why:** Raw HTML elements don't use Constellation's typography tokens. The Text component applies the correct font family, size, line height, and weight from the design system.

---

### 20. Typography: Title Case instead of sentence case

**Rule:** Use sentence case for all UI text. Only capitalize proper nouns.

```tsx
// WRONG — Title Case
<Text textStyle="body-lg-bold">Recently Viewed Homes</Text>
<Button>Save And Continue</Button>
<Text>Filter By Price Range</Text>

// CORRECT — sentence case
<Text textStyle="body-lg-bold">Recently viewed homes</Text>
<Button>Save and continue</Button>
<Text>Filter by price range</Text>
```

**Why:** Zillow's UX writing standard is sentence case. Title Case looks formal and dated. Capitalize only proper nouns like "Zillow", "Seattle", and "Zestimate".

---

### 21. Alignment: centering long body text

**Rule:** Left-align by default. Center only short content (loading states, empty states, hero headlines of 1-3 lines).

```tsx
// WRONG — centered paragraph text
<Flex direction="column" align="center" css={{ textAlign: 'center' }}>
  <Heading textStyle="heading-lg">Find your dream home</Heading>
  <Text textStyle="body">
    Browse thousands of listings in your area. Filter by price, bedrooms,
    bathrooms, and more. Save your favorites and get notified when new
    properties match your criteria.
  </Text>
</Flex>

// CORRECT — left-aligned body text
<Flex direction="column" gap="100" alignItems="flex-start">
  <Heading textStyle="heading-lg">Find your dream home</Heading>
  <Text textStyle="body" css={{ color: 'text.subtle' }}>
    Browse thousands of listings in your area. Filter by price, bedrooms,
    bathrooms, and more. Save your favorites and get notified when new
    properties match your criteria.
  </Text>
</Flex>
```

**Why:** Centered body text is harder to read because the eye has to find a new starting position for each line. Left alignment creates a consistent left edge that guides reading.

---

### 22. Colors: light blue backgrounds

**Rule:** Use white (`bg.screen.neutral`) or gray for backgrounds — never light blue.

```tsx
// WRONG — light blue background
<Box css={{ bg: '#e3f2fd' }}>
  <Text>Welcome to your dashboard</Text>
</Box>

// WRONG — blue-tinted background
<Flex css={{ backgroundColor: 'rgb(219, 234, 254)' }}>
  <Text>Section content</Text>
</Flex>

// CORRECT — white background
<Box css={{ bg: 'bg.screen.neutral' }}>
  <Text>Welcome to your dashboard</Text>
</Box>

// CORRECT — gray background for section differentiation
<Box css={{ bg: '#F7F7F7' }}>
  <Text>Section content</Text>
</Box>
```

**Why:** Constellation uses white and gray backgrounds exclusively. Light blue backgrounds are an anti-pattern that creates visual noise and conflicts with blue interactive elements.

---

### 23. Colors: blue headlines

**Rule:** Blue is reserved for interactive elements only (buttons, links, actions). Never use blue for headlines or static text.

```tsx
// WRONG — blue headline
<Heading textStyle="heading-lg" css={{ color: 'Blue600' }}>
  Welcome to your dashboard
</Heading>

// WRONG — blue section title
<Text textStyle="body-lg-bold" css={{ color: '#0041D9' }}>
  Recent activity
</Text>

// CORRECT — default color for headlines
<Heading textStyle="heading-lg">Welcome to your dashboard</Heading>
<Text textStyle="body-lg-bold">Recent activity</Text>
```

**Why:** Users associate blue with clickable elements. A blue headline looks like a link, confusing users who try to click it. Use default text color for headlines and titles.

---

### 24. Button: wrapping icon+text in Flex inside Button

**Rule:** Use Button's `icon` and `iconPosition` props — never wrap icon and text in Flex.

```tsx
// WRONG — Flex wrapper inside Button
<Button>
  <Flex align="center" gap="200">
    <Icon size="md"><IconSearchFilled /></Icon>
    <Text>Search</Text>
  </Flex>
</Button>

// CORRECT — use icon and iconPosition props
<Button icon={<IconSearchFilled />} iconPosition="start">
  Search
</Button>
```

**Why:** The Button component handles icon spacing, alignment, and sizing internally. Wrapping in Flex creates double spacing, inconsistent alignment, and breaks the button's internal layout logic.

---

### 25. Button: using Button for toggle/selection UI

**Rule:** Use ToggleButtonGroup, SegmentedControl, or CheckboxGroup for selection UI — never regular Buttons.

```tsx
// WRONG — Buttons for selection
<Flex gap="200">
  <Button emphasis={selected === 'buy' ? 'filled' : 'outlined'} onClick={() => setSelected('buy')}>
    Buy
  </Button>
  <Button emphasis={selected === 'rent' ? 'filled' : 'outlined'} onClick={() => setSelected('rent')}>
    Rent
  </Button>
</Flex>

// CORRECT — ToggleButtonGroup for single selection
<ToggleButtonGroup value={selected} onChange={setSelected}>
  <ToggleButton value="buy">Buy</ToggleButton>
  <ToggleButton value="rent">Rent</ToggleButton>
</ToggleButtonGroup>

// CORRECT — SegmentedControl for segmented choices
<SegmentedControl value={selected} onChange={setSelected}>
  <SegmentedControl.Option value="buy">Buy</SegmentedControl.Option>
  <SegmentedControl.Option value="rent">Rent</SegmentedControl.Option>
</SegmentedControl>
```

**Why:** Buttons are for actions (submit, navigate). Selection UI needs proper ARIA roles, keyboard navigation, and visual state management that ToggleButtonGroup and SegmentedControl provide out of the box.

---

### 26. Tag: using custom Box with bg/borderRadius for labels

**Rule:** Use the `Tag` component for labels and badges — never custom styled Box elements.

```tsx
// WRONG — custom Box styled as a tag
<Box css={{
  bg: '#e3f2fd',
  borderRadius: '12px',
  px: '200',
  py: '100',
  fontSize: '12px',
}}>
  New listing
</Box>

// CORRECT
import { Tag } from '@zillow/constellation';
<Tag size="sm" tone="blue" css={{ whiteSpace: 'nowrap' }}>New listing</Tag>
```

**Why:** The Tag component uses design-token colors, consistent sizing, and proper semantics. Custom Box styling drifts from the design system and won't update with theme changes.

---

### 27. PropertyCard: splitting address across dataArea3 and dataArea4

**Rule:** Put the full address in dataArea3. Use dataArea4 for listing agent/broker info, not the city/state/zip.

```tsx
// WRONG — address split across data areas
<PropertyCard
  saveButton={<PropertyCard.SaveButton />}
  data={{
    dataArea1: '$500,000',
    dataArea3: '123 Main Street',
    dataArea4: 'Seattle, WA 98101',
  }}
/>

// CORRECT — full address in dataArea3, agent info in dataArea4
<PropertyCard
  saveButton={<PropertyCard.SaveButton />}
  data={{
    dataArea1: '$500,000',
    dataArea3: '123 Main Street, Seattle, WA 98101',
    dataArea4: 'Listed by: ABC Realty',
  }}
/>
```

**Why:** The PropertyCard anatomy defines dataArea3 as the address field and dataArea4-5 as listing agent/broker info. Splitting the address across areas creates inconsistency with the standard PropertyCard layout used across Zillow.

---

### 28. Logo: random sizes

**Rule:** ZillowLogo must be exactly 24px on desktop and 16px on mobile.

```tsx
// WRONG — random sizes
<ZillowLogo css={{ height: '32px' }} />
<ZillowLogo css={{ height: '48px', width: '120px' }} />
<ZillowLogo style={{ width: '200px' }} />

// CORRECT — desktop
<ZillowLogo css={{ height: '24px', width: 'auto' }} />

// CORRECT — mobile
<ZillowLogo css={{ height: '16px', width: 'auto' }} />

// CORRECT — responsive
<ZillowLogo css={{ height: { base: '16px', md: '24px' }, width: 'auto' }} />
```

**Why:** The Zillow brand guidelines require specific logo sizes. Oversized or undersized logos look unprofessional and violate brand consistency.

---

### 29. Spacing: using pixel values instead of spacing tokens

**Rule:** Use spacing tokens (200, 300, 400, 600, 800) — never raw pixel values.

```tsx
// WRONG — pixel values
<Flex css={{ gap: '16px', padding: '24px', marginBottom: '32px' }}>
  <Card css={{ p: '12px' }}>Content</Card>
</Flex>

// CORRECT — spacing tokens
<Flex gap="400" css={{ p: '600', mb: '800' }}>
  <Card css={{ p: '300' }}>Content</Card>
</Flex>
```

**Why:** Spacing tokens ensure consistent rhythm across the app. Pixel values drift from the design system's spacing scale and create visual inconsistencies. Token reference: 200=8px, 300=12px, 400=16px, 600=24px, 800=32px.

---

### 30. Theme: forgetting injectTheme() setup

**Rule:** Call `injectTheme()` in your app entry point. Without it, semantic tokens (colors, spacing, typography) won't resolve.

```tsx
// WRONG — no theme injection, tokens render as raw strings
import './styled-system/styles.css';

function App() {
  return <Button tone="brand">Click me</Button>;
}

// CORRECT — inject theme on mount
import './styled-system/styles.css';
import { useEffect } from 'react';
import { getTheme, injectTheme } from './styled-system/themes';

function ThemeLoader({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    getTheme('zillow').then((theme) => {
      injectTheme(document.documentElement, theme);
    });
  }, []);
  return <>{children}</>;
}

function App() {
  return (
    <ThemeLoader>
      <Button tone="brand">Click me</Button>
    </ThemeLoader>
  );
}
```

**Why:** Constellation relies on CSS custom properties set by the theme. Without `injectTheme()`, semantic tokens like `bg.screen.neutral`, `text.subtle`, and component tone colors resolve to nothing, resulting in missing colors and broken styling.
