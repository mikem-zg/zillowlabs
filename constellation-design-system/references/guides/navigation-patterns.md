# Navigation Patterns Guide

This guide helps you choose the right Constellation navigation component for your UI. It covers when to use each pattern, how they combine, and how they differ for Consumer vs Professional apps.

---

## Decision Framework

Use this flowchart to select the right navigation pattern. Start at the top and follow the questions.

```
Q1: What level of the app are you navigating?
├── Entire application (moving between top-level sections)
│   ├── Q2: How many top-level sections?
│   │   ├── ≤5 sections → Page.Header with text links or buttons
│   │   ├── 6-15 sections → VerticalNav sidebar
│   │   └── 15+ sections → VerticalNav with grouped headings and dividers
│   └── Q3: Is the app primarily desktop/professional?
│       ├── YES → Consider VerticalNav (always visible, scalable)
│       └── NO → Consider Page.Header (minimal footprint, clean)
│
├── Within a page (switching between related content sections)
│   ├── Q4: Are sections peers of equal weight?
│   │   ├── YES, 2-7 sections → Tabs
│   │   ├── YES, but content is long/vertical → Accordion
│   │   └── NO, one section is a child of another → These are separate pages; use Page.Header or VerticalNav for page nav + Page.Breadcrumb for hierarchy trail
│   └── Q5: Is the user switching a view mode (not navigating content)?
│       └── YES → SegmentedControl or ToggleButtonGroup (not navigation)
│
├── Within content (inline links)
│   └── Anchor for inline text links, TextButton for standalone actions
│
├── Sequential content (paginated lists)
│   └── Pagination
│
└── Actions/overflow (not navigation, but often in nav areas)
    └── Menu for dropdown actions
```

---

## Pattern Catalog

### 1. Page.Header — Top-Level App Navigation

**What it is:** A horizontal header bar at the top of every page, containing the logo, primary navigation links, and user actions (sign in, settings, search).

**When to use:**
- The app has **5 or fewer** top-level sections
- You need a clean, minimal navigation that leaves maximum content space
- The app serves **consumers** (homebuyers, renters, sellers)
- The navigation items are stable and don't change often

**When NOT to use:**
- The app has 6+ top-level sections (items will overflow or feel cramped)
- The app is a complex professional tool with deep hierarchies
- You need nested/grouped navigation categories

**Constellation components:**
- `Page.Root` — top-level wrapper
- `Page.Header` — header content container (wrap in sticky `Box` for fixed positioning)
- `ZillowLogo` — brand logo (24px desktop, 16px mobile)
- `TextButton` or `Anchor` — navigation links in the header
- `Divider` — below the header (never CSS border)
- `Menu` — for overflow actions or user account dropdown

**Code pattern (sticky header):**

> **Sticky header gotcha:** `Page.Header` has built-in responsive `margin-block` via design tokens that creates a grey gap when sticky. Wrap it in a `Box` with `display: 'flow-root'` to contain the margins.

```tsx
import { Page, Button, TextButton, ZillowLogo, Divider } from '@zillow/constellation';
import { Box, Flex } from '@/styled-system/jsx';

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
    <Page.Header asChild>
      <header>
        <Flex align="center" justify="space-between" css={{ width: '100%' }}>
          <Flex align="center" gap="400">
            <ZillowLogo role="img" css={{ height: '24px', width: 'auto' }} />
            <TextButton tone="brand">Buy</TextButton>
            <TextButton tone="brand">Rent</TextButton>
            <TextButton tone="brand">Sell</TextButton>
          </Flex>
          <Flex align="center" gap="300">
            {/* Search, sign in, user menu */}
          </Flex>
        </Flex>
      </header>
    </Page.Header>
    <Divider />
  </Box>
  <Page.Content>
    {/* Page content */}
  </Page.Content>
</Page.Root>
```

**UX guidance:**
- Keep labels short (1-2 words)
- Put the most important items first (left to right)
- Highlight the current section visually (bold text or underline)
- On mobile, collapse to a hamburger menu or bottom navigation

**References:** [Page component](../components/Page.md), [TextButton component](../components/TextButton.md), [Menu component](../components/Menu.md)

---

### 2. Tabs — Page-Level Section Switching

**What it is:** Horizontal tabs that switch between related content panels within a single page. The user stays on the same page; only the visible panel changes.

**When to use:**
- You have **2-7 related content sections** within one page
- Sections are **peers of equal weight** (no section is a child of another)
- Users will **frequently switch** between sections
- Content can be categorized into **clear, mutually exclusive groups**
- Examples: Property details (overview/photos/map), settings (profile/notifications/security), item detail (description/files/config)

**When NOT to use:**
- For **entire app navigation** (use Page.Header or VerticalNav instead)
- When you have **8+ sections** (too many tabs become hard to scan)
- When users need to see **multiple sections simultaneously** (use Accordion or just stack them)
- For **linear workflows** where order matters (use ProgressStepper instead)
- When sections are **not related** to each other (they belong as separate pages)
- For **view mode switching** (use SegmentedControl — see section 9)

**Constellation components:**
- `Tabs.Root` — container (ALWAYS set `defaultSelected`)
- `Tabs.List` — the tab bar
- `Tabs.Tab` — individual tab (supports `icon` prop, `asChild` for links, `disabled`)
- `Tabs.Panel` — content panel tied to a tab by matching `value`

**Appearances:**
- `appearance="default"` — standard underline tabs (most common)
- `appearance="file"` — file-tab style with contained background (for code editors, documents)

**Code pattern:**
```tsx
import { Tabs } from '@zillow/constellation';

<Tabs.Root appearance="default" defaultSelected="overview">
  <Tabs.List>
    <Tabs.Tab value="overview">Overview</Tabs.Tab>
    <Tabs.Tab value="photos">Photos</Tabs.Tab>
    <Tabs.Tab value="map">Map</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="overview">{/* Overview content */}</Tabs.Panel>
  <Tabs.Panel value="photos">{/* Photos content */}</Tabs.Panel>
  <Tabs.Panel value="map">{/* Map content */}</Tabs.Panel>
</Tabs.Root>
```

**Tabs as route links (navigation tabs):**
```tsx
<Tabs.Root defaultSelected="skills">
  <Tabs.List>
    <Tabs.Tab asChild value="skills">
      <a href="/skills">Skills</a>
    </Tabs.Tab>
    <Tabs.Tab asChild value="mcps">
      <a href="/mcps">MCPs</a>
    </Tabs.Tab>
  </Tabs.List>
</Tabs.Root>
```

**Critical rules:**
- ALWAYS set `defaultSelected` (or `selected` for controlled) — without it, no tab appears selected on mount
- The `defaultSelected` value must match a `Tabs.Tab` `value`
- Use `onSelectedChange` for controlled behavior (e.g., URL sync)
- Use `manualActivation` when tab panel content loads asynchronously

**UX guidance:**
- Order tabs by frequency of use (most used first)
- Use sentence case for tab labels
- Keep labels to 1-3 words
- If tabs overflow horizontally, the component scrolls — but consider reducing the number of tabs
- Tab content should fill the full width below the tab bar

**References:** [Tabs component](../components/Tabs.md)

---

### 3. VerticalNav — Sidebar Navigation

**What it is:** A vertical list of navigation items displayed in a sidebar, typically on the left side of the page. It can include headings, dividers, icons, and grouped sections.

**When to use:**
- The app has **6+ top-level sections** that don't fit in a horizontal header
- The app is a **professional/enterprise tool** (agent dashboards, admin panels, settings)
- Navigation items need **grouping with headings** (e.g., "Account", "Settings", "Reports")
- The navigation structure will **grow over time** (sidebar scales better than top nav)
- Users **switch between sections frequently** and need the nav always visible

**When NOT to use:**
- Simple consumer apps with 5 or fewer sections (use Page.Header instead)
- Mobile-first apps where screen width is limited (sidebar takes 20-25% of screen)
- When navigation items are all peers without grouping needs

**Constellation components:**
- `VerticalNav.Root` — container with `tone`, `elevated`, `outlined`, `background` props
- `VerticalNav.List` — ordered list of nav items
- `VerticalNav.Item` — individual item with `current`, `selected`, `disabled` props
- `VerticalNav.Heading` — group heading within the nav
- `VerticalNav.Divider` — visual separator between groups
- `Anchor` — for link-based items
- `UnstyledButton` — for button-based items (client-side navigation)
- `Icon` — optional icon prefix on items

**Tone options:**
- `tone="brand"` — blue active indicator (default, use for primary navigation)
- `tone="neutral"` — gray active indicator (use for settings, secondary nav)

**Code pattern — simple sidebar:**
```tsx
import { Anchor, VerticalNav } from '@zillow/constellation';

<VerticalNav.Root background outlined elevated={false} tone="neutral">
  <VerticalNav.List>
    <VerticalNav.Item current="true">
      <Anchor href="/dashboard">Dashboard</Anchor>
    </VerticalNav.Item>
    <VerticalNav.Item>
      <Anchor href="/leads">Leads</Anchor>
    </VerticalNav.Item>
    <VerticalNav.Item>
      <Anchor href="/listings">Listings</Anchor>
    </VerticalNav.Item>
    <VerticalNav.Item>
      <Anchor href="/reports">Reports</Anchor>
    </VerticalNav.Item>
  </VerticalNav.List>
</VerticalNav.Root>
```

**Code pattern — grouped sidebar with icons:**
```tsx
import { Anchor, Icon, UnstyledButton, VerticalNav } from '@zillow/constellation';
import { IconHomeFilled, IconPeopleFilled, IconSettingsFilled } from '@zillow/constellation-icons';

<VerticalNav.Root background outlined elevated={false} tone="neutral">
  <VerticalNav.Heading level={5} id="main-heading">Main</VerticalNav.Heading>
  <VerticalNav.List aria-labelledby="main-heading">
    <VerticalNav.Item current>
      <Anchor href="/dashboard">
        <Icon size="md"><IconHomeFilled /></Icon> Dashboard
      </Anchor>
    </VerticalNav.Item>
    <VerticalNav.Item>
      <Anchor href="/leads">
        <Icon size="md"><IconPeopleFilled /></Icon> Leads
      </Anchor>
    </VerticalNav.Item>
  </VerticalNav.List>
  <VerticalNav.Divider />
  <VerticalNav.Heading level={5} id="settings-heading">Settings</VerticalNav.Heading>
  <VerticalNav.List aria-labelledby="settings-heading">
    <VerticalNav.Item>
      <Anchor href="/settings">
        <Icon size="md"><IconSettingsFilled /></Icon> Preferences
      </Anchor>
    </VerticalNav.Item>
  </VerticalNav.List>
</VerticalNav.Root>
```

**Layout pattern (sidebar + content):**
```tsx
import { Flex } from '@/styled-system/jsx';

<Flex>
  <Box css={{ width: '260px', flexShrink: 0 }}>
    <VerticalNav.Root>{/* ... */}</VerticalNav.Root>
  </Box>
  <Box css={{ flex: 1 }}>
    <Page.Root>
      <Page.Content>{/* Main content */}</Page.Content>
    </Page.Root>
  </Box>
</Flex>
```

**UX guidance:**
- Use `current` prop for link-based items (renders `aria-current`), `selected` for button-based items
- Group related items under `VerticalNav.Heading` with `VerticalNav.Divider` between groups
- On mobile, collapse the sidebar behind a hamburger menu or drawer
- Keep the sidebar at a fixed width (200-280px is typical)
- For Professional apps, use `elevated={false}` with `outlined` for a clean, flat appearance

**References:** [VerticalNav component](../components/VerticalNav.md)

---

### 4. Page.Breadcrumb — Hierarchical Trail

**What it is:** A breadcrumb trail above the page header that shows where the user is within a content hierarchy and lets them navigate back up.

**When to use:**
- Content has a **parent-child hierarchy** (e.g., Home > Skills > Skill Detail)
- Users need a way to **navigate back** to parent pages
- The app has **3+ levels of depth**

**When NOT to use:**
- Flat navigation with no hierarchy (all pages are peers)
- Single-level apps where the header navigation is sufficient

**Constellation component:**
- `Page.Breadcrumb` — placed inside `Page.Root`, above `Page.Header`
- `TextButton` with `IconChevronLeftFilled` — for the back link

**Code pattern:**
```tsx
import { Page, TextButton, Heading } from '@zillow/constellation';
import { IconChevronLeftFilled } from '@zillow/constellation-icons';

<Page.Root>
  <Page.Breadcrumb>
    <TextButton icon={<IconChevronLeftFilled />} asChild>
      <a href="/skills">Back to skills</a>
    </TextButton>
  </Page.Breadcrumb>
  <Page.Header>
    <Heading level={1}>Skill name</Heading>
  </Page.Header>
  <Page.Content>{/* Detail content */}</Page.Content>
</Page.Root>
```

**UX guidance:**
- Use sentence case: "Back to skills" not "Back to Skills"
- Show only one level back (not a full breadcrumb trail) unless the hierarchy is 4+ levels deep
- On mobile, the breadcrumb should still be visible (it's compact enough)

**References:** [Page component](../components/Page.md)

---

### 5. Anchor & TextButton — Inline Text Navigation

**What it is:** Text-based links for navigating within content or performing lightweight navigation actions.

**When to use:**
- **Anchor:** Inline links within body text (e.g., "Learn more about [home loans]")
- **TextButton:** Standalone navigation actions outside of body text (e.g., "View all", "See details", breadcrumb back links)

**When NOT to use:**
- For primary navigation — use Page.Header, Tabs, or VerticalNav
- For primary actions — use Button with `emphasis="filled"`

**Key differences:**

| | Anchor | TextButton |
|---|---|---|
| **HTML element** | `<a>` by default | `<button>` by default |
| **Purpose** | Navigate to a URL | Trigger an action or navigate |
| **Usage** | Inline within text | Standalone, outside body text |
| **Icon support** | No | Yes (`icon` prop) |
| **Underline** | Yes (default link styling) | No (styled as actionable text) |

**Code patterns:**
```tsx
import { Anchor, Text, TextButton } from '@zillow/constellation';
import { IconChevronRightOutline } from '@zillow/constellation-icons';

// Inline link within body text
<Text textStyle="body">
  Explore <Anchor href="/homes">available homes</Anchor> in your area.
</Text>

// Standalone navigation action
<TextButton tone="brand" icon={<IconChevronRightOutline />} iconPosition="end">
  View all listings
</TextButton>
```

**References:** [Anchor component](../components/Anchor.md), [TextButton component](../components/TextButton.md)

---

### 6. Menu — Dropdown Actions

**What it is:** A dropdown menu triggered by a button, containing a list of actions. Not navigation in the traditional sense, but frequently placed in navigation areas (user account menu, overflow actions, settings).

**When to use:**
- **User account actions** (sign out, settings, profile) in the header
- **Overflow actions** on cards or list items (edit, delete, share)
- **Theme switching** (light/dark/system mode selector)
- **Sort/filter options** that are too numerous for inline buttons

**When NOT to use:**
- For primary navigation between app sections (use Page.Header, Tabs, or VerticalNav)
- When there are only 2-3 actions (use inline buttons instead)

**Code pattern — user account menu in header:**
```tsx
import { Menu, Avatar, Icon } from '@zillow/constellation';
import { IconSettingsFilled, IconLogoutFilled } from '@zillow/constellation-icons';

<Menu
  trigger={<Menu.Button><Avatar src={user.photo} size="sm" /></Menu.Button>}
  content={
    <>
      <Menu.Group aria-label="Account">
        <Menu.Item>
          <Icon size="sm"><IconSettingsFilled /></Icon>
          <Menu.ItemLabel>Settings</Menu.ItemLabel>
        </Menu.Item>
      </Menu.Group>
      <Menu.Group aria-label="Session">
        <Menu.Item>
          <Icon size="sm"><IconLogoutFilled /></Icon>
          <Menu.ItemLabel>Sign out</Menu.ItemLabel>
        </Menu.Item>
      </Menu.Group>
    </>
  }
/>
```

**References:** [Menu component](../components/Menu.md)

---

### 7. Pagination — Sequential Page Navigation

**What it is:** Previous/next buttons with optional page number buttons for navigating through paginated lists of content.

**When to use:**
- Lists of items that are too long to display on one page (search results, listings, logs)
- The user needs to navigate to a specific page in a set

**When NOT to use:**
- Infinite scroll or "load more" patterns (use a Button instead)
- Short lists that fit on one page
- Tabs or section navigation (Pagination is for sequential data, not content sections)

**Code pattern:**
```tsx
import { Pagination } from '@zillow/constellation';

<Pagination
  totalPages={15}
  showNumberButtons
  onPageSelected={(index) => setCurrentPage(index)}
/>
```

**UX guidance:**
- On mobile, `showNumberButtons` defaults to `false` (previous/next only) — this is a responsive behavior built into the component
- Place pagination at the bottom of the list, optionally also at the top for long lists
- Use the `divider` prop to visually separate pagination from content above

**References:** [Pagination component](../components/Pagination.md)

---

### 8. Accordion — Progressive Disclosure

**What it is:** Expandable/collapsible sections that reveal content when opened. Use when content is organized into sections that users want to browse selectively.

**When to use:**
- **FAQ pages** — users scan headings and expand only what interests them
- **Settings/preferences** — grouped settings that would be overwhelming if all visible
- **Long-form content** — breaking dense information into scannable sections
- **Mobile-first** — when vertical space is at a premium and not all sections are equally relevant

**When NOT to use:**
- When users need to **compare content across sections** (they can't see two panels at once unless you use `multiple`)
- When all content is equally important and should be visible (just stack it)
- For **primary navigation** (use VerticalNav or Tabs)
- When there are only **2 sections** (just show both)

**Code pattern:**
```tsx
import { Accordion, Heading, Paragraph } from '@zillow/constellation';

<Accordion.Root title="Frequently asked questions">
  <Accordion.Item value="q1">
    <Accordion.Header>
      <Heading level={5}>How do I install a skill?</Heading>
    </Accordion.Header>
    <Accordion.Panel>
      <Paragraph>Copy the skill directory into your .agents/skills/ folder.</Paragraph>
    </Accordion.Panel>
  </Accordion.Item>
  <Accordion.Item value="q2">
    <Accordion.Header>
      <Heading level={5}>Can I submit my own skills?</Heading>
    </Accordion.Header>
    <Accordion.Panel>
      <Paragraph>Yes, sign in and use the submit form.</Paragraph>
    </Accordion.Panel>
  </Accordion.Item>
</Accordion.Root>
```

**References:** [Accordion component](../components/Accordion.md)

---

### 9. SegmentedControl & ToggleButtonGroup — View Mode Switching

**What it is:** A set of mutually exclusive options that change the **presentation or mode** of content, not the content itself. These are NOT navigation components, but they are frequently confused with Tabs.

**When to use SegmentedControl:**
- Switching between **view modes** of the same data (e.g., list view vs grid view, map vs satellite)
- Choosing a **data format** (e.g., monthly vs yearly pricing)
- The options are **2-4 choices** that change how content is displayed

**When to use ToggleButtonGroup:**
- **Single-select filters** (e.g., price range: $100k / $200k / $300k+)
- **Category selection** where the choice is binary/exclusive
- More than 4 options (SegmentedControl is limited)

**Key distinction from Tabs:**

| | Tabs | SegmentedControl / ToggleButtonGroup |
|---|---|---|
| **Purpose** | Navigate between different content sections | Change how the same content is displayed |
| **Content change** | Entirely different content per tab | Same content, different presentation |
| **URL impact** | Often changes URL or adds query params | Rarely affects URL |
| **Example** | Property detail: Overview / Photos / Map | Search results: List view / Grid view |

**NEVER use:**
- Regular `Button` components for selection or toggle UI — always use `ToggleButtonGroup`, `SegmentedControl`, or `CheckboxGroup`

**Note on SegmentedControl:** `SegmentedControl` is referenced in Constellation design rules as the preferred component for segmented choices, but it does not have a separate component documentation file in this skill. If `SegmentedControl` is not available in your version of `@zillow/constellation`, use `ToggleButtonGroup` as a functionally equivalent alternative.

**References:** See `custom_instruction/instructions.md` for component selection rules. [ToggleButtonGroup component](../components/ToggleButtonGroup.md)

---

## Hybrid Patterns

Real-world apps often combine multiple navigation patterns. Here are the most common and effective combinations.

### Header + Tabs (Simple content apps)

Use Page.Header for top-level app navigation and Tabs for page-level section switching. This is the most common pattern for **consumer apps** with moderate complexity.

```
┌──────────────────────────────────────────┐
│ Logo    Buy  Rent  Sell    [Search] [👤] │  ← Page.Header
├──────────────────────────────────────────┤
│ Overview | Photos | Map | Schools        │  ← Tabs
├──────────────────────────────────────────┤
│                                          │
│  Tab content area                        │  ← Tabs.Panel
│                                          │
└──────────────────────────────────────────┘
```

**Best for:** Zillow consumer pages (property details, user profiles, search results with filters).

### Header + Sidebar (Complex professional apps)

Use a minimal Page.Header for branding and global actions, with VerticalNav for primary section navigation. This is the standard pattern for **professional apps**.

```
┌──────────────────────────────────────────┐
│ Logo                      [Search] [👤]  │  ← Page.Header (minimal)
├────────────┬─────────────────────────────┤
│ Dashboard  │                             │
│ Leads      │  Page content               │  ← Page.Root > Page.Content
│ Listings   │                             │
│ ─────────  │                             │
│ Settings   │                             │
│ Reports    │                             │
├────────────┤                             │  ← VerticalNav
└────────────┴─────────────────────────────┘
```

**Best for:** Agent dashboards, admin panels, CRM tools.

### Sidebar + Tabs (Complex professional apps with deep content)

Use VerticalNav for section navigation and Tabs within each section for sub-navigation.

```
┌──────────────────────────────────────────┐
│ Logo                      [Search] [👤]  │
├────────────┬─────────────────────────────┤
│ Dashboard  │ Overview | Activity | Stats │  ← Tabs within section
│ Leads ←    ├─────────────────────────────┤
│ Listings   │                             │
│ ─────────  │  Tab content area           │
│ Settings   │                             │
│ Reports    │                             │
└────────────┴─────────────────────────────┘
```

**Best for:** Complex tools where each section has multiple sub-views.

### Header + Breadcrumb (Hierarchical content)

Use Page.Header for top-level navigation and Page.Breadcrumb for showing depth within a content hierarchy.

```
┌──────────────────────────────────────────┐
│ Logo    Skills  MCPs  Reports   [👤]     │  ← Page.Header
├──────────────────────────────────────────┤
│ ← Back to skills                         │  ← Page.Breadcrumb
├──────────────────────────────────────────┤
│ Skill Name                               │  ← Page.Header (page title)
├──────────────────────────────────────────┤
│                                          │
│  Detail content                          │
│                                          │
└──────────────────────────────────────────┘
```

**Best for:** Content libraries, documentation, detail pages.

---

## Mobile & Responsive Considerations

Each navigation pattern has different responsive behavior:

| Pattern | Desktop | Tablet | Mobile |
|---------|---------|--------|--------|
| **Page.Header** | Full horizontal links | May collapse some items | Hamburger menu or bottom nav |
| **Tabs** | Full tab bar | Full tab bar (may scroll) | Scrollable tab bar or stacked |
| **VerticalNav** | Always-visible sidebar | Collapsible sidebar | Hidden behind hamburger/drawer |
| **Breadcrumb** | Full trail | Full trail | Full trail (compact enough) |
| **Pagination** | Number buttons + prev/next | Number buttons + prev/next | Prev/next only (built-in) |
| **Accordion** | Works at all sizes | Works at all sizes | Works at all sizes (good mobile pattern) |

**Mobile-specific guidance:**
- **Never** show a sidebar and header nav simultaneously on mobile — pick one or collapse the sidebar
- **Tabs** work well on mobile if you have ≤5 tabs; for more, the tab bar scrolls horizontally
- **Accordion** is often the best mobile pattern for content that uses Tabs on desktop — consider switching patterns based on screen size
- **Bottom navigation bars** are a common mobile pattern but are not a Constellation component — build them with `Flex` and `IconButton` if needed

---

## Consumer vs Professional App Guidance

### Consumer Apps

| Navigation Need | Recommended Pattern |
|----------------|---------------------|
| Top-level sections (Buy, Rent, Sell) | Page.Header with TextButton links |
| Property detail sections | Tabs (Overview, Photos, Map, Schools) |
| Back to search results | Page.Breadcrumb |
| User account actions | Menu dropdown |
| Search results pages | Pagination |
| FAQ / help content | Accordion |

**Consumer navigation characteristics:**
- Simple, clean, minimal — don't overwhelm with options
- Focused on the primary task (finding a home)
- Heavy use of Tabs for in-page navigation
- Full expressive palette allowed for active/selected states

### Professional Apps

| Navigation Need | Recommended Pattern |
|----------------|---------------------|
| Primary app sections (Dashboard, Leads, Listings) | VerticalNav sidebar |
| Sub-sections within a page | Tabs |
| Settings categories | VerticalNav with grouped headings |
| Back to parent page | Page.Breadcrumb |
| User/account actions | Menu dropdown |
| Data table navigation | Pagination |
| Dense settings/preferences | Accordion |

**Professional navigation characteristics:**
- Structured, organized, efficient — built for daily use
- VerticalNav is the default primary nav pattern
- Blue (#0041D9) for active/selected states only — no Purple, Orange, or Teal
- `size="md"` for all interactive elements in navigation
- Shadows only on interactive elements
- For static (non-interactive) VerticalNav, use `outlined` with `elevated={false}` to show a border without shadow — matching the Card rule that outlined containers should not have elevation

---

## Anti-Patterns (NEVER Do)

| NEVER | ALWAYS Instead |
|-------|----------------|
| Use `Box`/`Flex` for page headers | `Page.Header` inside `Page.Root` |
| CSS borders below headers | `<Divider />` component |
| Regular `Button` for toggle/selection | `ToggleButtonGroup` or `SegmentedControl` |
| Tabs for entire app navigation (replacing header) | `Page.Header` or `VerticalNav` |
| Tabs for view mode switching (list/grid) | `SegmentedControl` |
| VerticalNav for 3-4 items in a simple consumer app | `Page.Header` with text links |
| Custom sidebar with `Box` and styled links | `VerticalNav` component |
| Transparent backgrounds on sticky headers | `bg.screen.neutral` (solid) |
| Outline icons in navigation | Filled icons (e.g., `IconHomeFilled`) |
