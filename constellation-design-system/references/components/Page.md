# Page

```tsx
import { Page } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.15.0

The `Page` component provides a structured page layout system with built-in responsive max-width, breadcrumbs, headers, and content sections. **ALWAYS use `Page.Root` as the top-level wrapper for pages instead of custom `Box`/`Flex` layouts.**

## Sub-Components

| Sub-Component | Purpose | Required? |
|---------------|---------|-----------|
| `Page.Root` | Top-level page wrapper (handles max-width, padding) | YES - always |
| `Page.Header` | Page header area for heading and action buttons | YES - for pages with titles |
| `Page.Content` | Page body section (can use multiple for separate sections) | YES - for page content |
| `Page.Breadcrumb` | Breadcrumb navigation placed above the header | Optional |

## Basic Usage

```tsx
import { Heading, Page, Paragraph, TextButton } from '@zillow/constellation';
import { IconChevronLeftFilled } from '@zillow/constellation-icons';

export const PageBasic = () => (
  <Page.Root>
    <Page.Breadcrumb>
      <TextButton icon={<IconChevronLeftFilled />}>Breadcrumb link</TextButton>
    </Page.Breadcrumb>
    <Page.Header>
      <Heading level={1}>Heading</Heading>
    </Page.Header>
    <Page.Content>
      <Paragraph>First content section.</Paragraph>
    </Page.Content>
    <Page.Content>
      <Paragraph>Second content section.</Paragraph>
    </Page.Content>
  </Page.Root>
);
```

## Examples

### Page Header with Actions

Place action buttons alongside the heading inside `Page.Header`:

```tsx
import { ButtonGroup, Heading, Page, Paragraph, TextButton } from '@zillow/constellation';
import { IconChevronLeftFilled, IconStar100Percent } from '@zillow/constellation-icons';

export const PagePageHeaderContent = () => (
  <Page.Root>
    <Page.Breadcrumb>
      <TextButton icon={<IconChevronLeftFilled />}>Breadcrumb link</TextButton>
    </Page.Breadcrumb>
    <Page.Header>
      <Heading level={1}>Heading</Heading>
      <ButtonGroup aria-label="Title example links">
        <TextButton icon={<IconStar100Percent />}>Title link</TextButton>
        <TextButton icon={<IconStar100Percent />}>Title link</TextButton>
      </ButtonGroup>
    </Page.Header>
    <Page.Content>
      <Paragraph>Page content here.</Paragraph>
    </Page.Content>
  </Page.Root>
);
```

### Fluid (Full-Width) Page

Use the `fluid` prop on `Page.Root` to remove the max-width constraint. This applies to all child sub-components:

```tsx
import { Heading, Page, Paragraph, TextButton } from '@zillow/constellation';
import { IconChevronLeftFilled } from '@zillow/constellation-icons';

export const PageFluid = () => (
  <Page.Root fluid>
    <Page.Breadcrumb>
      <TextButton icon={<IconChevronLeftFilled />}>Breadcrumb link</TextButton>
    </Page.Breadcrumb>
    <Page.Header>
      <Heading level={1}>Heading</Heading>
    </Page.Header>
    <Page.Content>
      <Paragraph>Full-width content.</Paragraph>
    </Page.Content>
  </Page.Root>
);
```

### Background Color

Apply background colors via the `css` prop on `Page.Root`:

```tsx
import { Heading, Page, Paragraph, TextButton } from '@zillow/constellation';
import { IconChevronLeftFilled } from '@zillow/constellation-icons';

export const PageBackgroundColor = () => (
  <Page.Root css={{ background: 'bg.accent.blue.soft' }}>
    <Page.Breadcrumb>
      <TextButton icon={<IconChevronLeftFilled />}>Breadcrumb link</TextButton>
    </Page.Breadcrumb>
    <Page.Header>
      <Heading level={1}>Heading</Heading>
    </Page.Header>
    <Page.Content>
      <Paragraph>Page with custom background.</Paragraph>
    </Page.Content>
  </Page.Root>
);
```

### Polymorphic Sub-Components (Semantic HTML)

Use `asChild` to render sub-components as semantic HTML elements:

```tsx
import { Heading, Page, Paragraph } from '@zillow/constellation';

export const PagePolymorphicSubcomponents = () => (
  <Page.Root>
    <Page.Header asChild>
      <header>
        <Heading level={1}>Heading</Heading>
      </header>
    </Page.Header>
    <Page.Content asChild>
      <main>
        <Paragraph>Main content area with semantic HTML.</Paragraph>
      </main>
    </Page.Content>
  </Page.Root>
);
```

## API

### PageRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `css` | `SystemStyleObject` | — | Styles object |
| `fluid` | `boolean` | `false` | Remove max-width constraint. Applies to all child sub-components. |

### PageHeader

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `css` | `SystemStyleObject` | — | Styles object |
| `fluid` | `boolean` | — | Remove max-width constraint. Inherits from `Page.Root` if set there. |

### PageContent

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `css` | `SystemStyleObject` | — | Styles object |
| `fluid` | `boolean` | — | Remove max-width constraint. Inherits from `Page.Root` if set there. |

### PageBreadcrumb

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `css` | `SystemStyleObject` | — | Styles object |
| `fluid` | `boolean` | — | Remove max-width constraint. Inherits from `Page.Root` if set there. |
