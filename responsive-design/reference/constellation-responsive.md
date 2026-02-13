# Constellation/PandaCSS Responsive Design Reference

## Imports

```tsx
import { css } from '@/styled-system/css';
import { Box, Flex, Grid } from '@/styled-system/jsx';
import { Button, Card, Text, Heading, Page, ZillowLogo, Tabs, PropertyCard, Icon, Divider } from '@zillow/constellation';
```

---

## 1. Breakpoint Tokens

Mobile-first `min-width` breakpoints using `em` units:

| Token | Value | Pixels | Target |
|-------|-------|--------|--------|
| `sm` | 20em | 320px | Small phones |
| `md` | 30em | 480px | Large phones / landscape |
| `lg` | 48em | 768px | Tablets |
| `xl` | 64em | 1024px | Laptops / small desktops |
| `xxl` | 80em | 1280px | Large desktops |

---

## 2. Responsive Prop Syntax

### Object Syntax

```tsx
<Box p={{ base: '400', lg: '600' }} display={{ base: 'block', lg: 'flex' }}>
  Content
</Box>
```

### Nested Syntax

```tsx
<Box className={css({
  padding: '400',
  lg: {
    padding: '600',
    display: 'flex',
    gap: '400',
  },
})}>
  Content
</Box>
```

### Array Syntax

PandaCSS supports array syntax where values map to breakpoints in order (`[base, sm, md, lg, xl, xxl]`). Use `null` to skip a breakpoint:

```tsx
<Box p={['400', null, null, '600']}>
  Content
</Box>
```

---

## 3. Responsive Conditions

### Standard (min-width)

| Condition | Media Query |
|-----------|-------------|
| `sm` | `@media (min-width: 20em)` |
| `md` | `@media (min-width: 30em)` |
| `lg` | `@media (min-width: 48em)` |
| `xl` | `@media (min-width: 64em)` |
| `xxl` | `@media (min-width: 80em)` |

### Only (exact range)

| Condition | Range |
|-----------|-------|
| `smOnly` | 20em – 29.9975em |
| `mdOnly` | 30em – 47.9975em |
| `lgOnly` | 48em – 63.9975em |
| `xlOnly` | 64em – 79.9975em |
| `xxlOnly` | ≥ 80em |

### Down (max-width)

| Condition | Media Query |
|-----------|-------------|
| `smDown` | `@media (max-width: 19.9975em)` |
| `mdDown` | `@media (max-width: 29.9975em)` |
| `lgDown` | `@media (max-width: 47.9975em)` |
| `xlDown` | `@media (max-width: 63.9975em)` |
| `xxlDown` | `@media (max-width: 79.9975em)` |

### Range (between two breakpoints)

| Condition | Range |
|-----------|-------|
| `smToMd` | 20em – 29.9975em |
| `smToLg` | 20em – 47.9975em |
| `smToXl` | 20em – 63.9975em |
| `smToXxl` | 20em – 79.9975em |
| `mdToLg` | 30em – 47.9975em |
| `mdToXl` | 30em – 63.9975em |
| `mdToXxl` | 30em – 79.9975em |
| `lgToXl` | 48em – 63.9975em |
| `lgToXxl` | 48em – 79.9975em |
| `xlToXxl` | 64em – 79.9975em |

### Usage

```tsx
<Box className={css({
  flexDirection: 'column',
  lg: { flexDirection: 'row', gap: '600' },
  lgDown: { padding: '300' },
  mdToLg: { fontSize: 'md' },
  xlOnly: { maxWidth: '1200px', margin: '0 auto' },
})}>
  Content
</Box>
```

---

## 4. hideFrom / hideBelow Utilities

Available on `Box`, `Flex`, `Grid`, and other JSX layout primitives from `@/styled-system/jsx`.

```tsx
<Box hideBelow="lg">
  Visible on lg (768px) and above only
</Box>

<Box hideFrom="lg">
  Visible below lg (768px) only
</Box>

<Flex hideBelow="md" gap="400" alignItems="center">
  Desktop navigation links
</Flex>

<Grid hideFrom="md" columns={1} gap="300">
  Mobile-only stacked layout
</Grid>
```

### CSS Alternative

```tsx
<Box className={css({ display: { base: 'none', lg: 'block' } })}>
  Desktop only (equivalent to hideBelow="lg")
</Box>

<Box className={css({ display: { base: 'block', lg: 'none' } })}>
  Mobile only (equivalent to hideFrom="lg")
</Box>
```

---

## 5. Spacing Tokens

Constellation uses numeric string tokens:

| Token | Value | Common Use |
|-------|-------|------------|
| `'100'` | 4px | Tight gaps, icon spacing |
| `'200'` | 8px | Tight list spacing |
| `'300'` | 12px | Comfortable list spacing |
| `'400'` | 16px | Page padding (sides), card padding, grid gaps |
| `'500'` | 20px | Medium spacing |
| `'600'` | 24px | Page padding (top/bottom) |
| `'700'` | 28px | Large spacing |
| `'800'` | 32px | Section gaps |

### Responsive Spacing

```tsx
<Flex
  direction="column"
  gap={{ base: '400', lg: '800' }}
  p={{ base: '400', lg: '600' }}
>
  <Card outlined elevated={false} tone="neutral" css={{ p: '400' }}>
    Content
  </Card>
</Flex>
```

---

## 6. Constellation Component Responsive Patterns

### ZillowLogo

```tsx
<ZillowLogo css={{ height: { base: '16px', lg: '24px' }, width: 'auto' }} />
```

### Button / Input Sizing

Professional apps always use `size="md"`:

```tsx
<Button tone="brand" emphasis="filled" size="md">Search</Button>
<Input size="md" placeholder="Enter address" />
```

Consumer hero CTAs may use `size="lg"`:

```tsx
<Button tone="brand" emphasis="filled" size={{ base: 'md', lg: 'lg' }}>
  Get started
</Button>
```

### Responsive Card Layout

```tsx
<Grid columns={{ base: 1, md: 2, xl: 3 }} gap="400">
  {items.map(item => (
    <Card outlined elevated={false} tone="neutral" key={item.id}>
      <Flex direction="column" gap="200">
        <Text textStyle="body-bold">{item.title}</Text>
        <Text textStyle="body" color="text.subtle">{item.description}</Text>
      </Flex>
    </Card>
  ))}
</Grid>
```

### PropertyCard Responsive Grid

```tsx
<Grid columns={{ base: 1, md: 2, xl: 3 }} gap="400">
  {listings.map(listing => (
    <PropertyCard
      key={listing.id}
      appearance={{ base: 'small', lg: 'large' }}
      photoBody={<PropertyCard.Photo src={listing.imageUrl} alt={listing.address} />}
      saveButton={<PropertyCard.SaveButton />}
      data={{
        dataArea1: listing.price,
        dataArea2: <PropertyCard.HomeDetails data={listing.details} />,
        dataArea3: listing.address,
      }}
      elevated
      interactive
      onClick={() => navigate(`/listing/${listing.id}`)}
    />
  ))}
</Grid>
```

### Tabs Responsive

```tsx
<Tabs.Root defaultSelected="overview">
  <Box css={{ overflowX: { base: 'auto', lg: 'visible' }, whiteSpace: { base: 'nowrap', lg: 'normal' } }}>
    <Tabs.List>
      <Tabs.Tab value="overview">Overview</Tabs.Tab>
      <Tabs.Tab value="details">Details</Tabs.Tab>
      <Tabs.Tab value="history">History</Tabs.Tab>
    </Tabs.List>
  </Box>
  <Tabs.Panel value="overview">
    <Flex direction="column" gap="400" p={{ base: '300', lg: '400' }}>
      <Text textStyle="body">Overview content</Text>
    </Flex>
  </Tabs.Panel>
  <Tabs.Panel value="details">Details content</Tabs.Panel>
  <Tabs.Panel value="history">History content</Tabs.Panel>
</Tabs.Root>
```

### Page.Header with Responsive Content

```tsx
<Page.Root>
  <Page.Header>
    <Flex justifyContent="space-between" alignItems="center" p={{ base: '300', lg: '400' }}>
      <ZillowLogo css={{ height: { base: '16px', lg: '24px' }, width: 'auto' }} />

      <Flex hideBelow="lg" gap="300" alignItems="center">
        <Button tone="brand" emphasis="tertiary" size="md">Buy</Button>
        <Button tone="brand" emphasis="tertiary" size="md">Rent</Button>
        <Button tone="brand" emphasis="tertiary" size="md">Sell</Button>
        <Button tone="brand" emphasis="filled" size="md">Sign in</Button>
      </Flex>

      <Box hideFrom="lg">
        <Button size="md" emphasis="tertiary" icon={<IconMenuFilled />} aria-label="Menu" />
      </Box>
    </Flex>
  </Page.Header>
  <Divider />
  <Page.Content css={{ px: '400', py: '600' }}>
    Page body
  </Page.Content>
</Page.Root>
```

---

## 7. Responsive Grid and Flex Patterns

### Basic Responsive Grid

```tsx
<Grid columns={{ base: 1, md: 2, xl: 4 }} gap="400">
  <Box>Item 1</Box>
  <Box>Item 2</Box>
  <Box>Item 3</Box>
  <Box>Item 4</Box>
</Grid>
```

### Sidebar Layout

```tsx
<Flex direction={{ base: 'column', lg: 'row' }} gap={{ base: '400', lg: '600' }}>
  <Box flex={{ lg: '1' }}>
    Main content
  </Box>
  <Box width={{ base: '100%', lg: '300px' }} flexShrink={0}>
    Sidebar
  </Box>
</Flex>
```

### Auto-fit Grid (No Breakpoints)

```tsx
<div className={css({
  display: 'grid',
  gridTemplateColumns: 'repeat(auto-fit, minmax(min(100%, 280px), 1fr))',
  gap: '400',
})}>
  {items.map(item => <Card key={item.id} outlined elevated={false} tone="neutral">...</Card>)}
</div>
```

### Responsive Flex Wrap

```tsx
<Flex wrap="wrap" gap="300">
  {tags.map(tag => (
    <Tag key={tag} size="sm" tone="blue" css={{ whiteSpace: 'nowrap' }}>
      {tag}
    </Tag>
  ))}
</Flex>
```

### Stacking to Row

```tsx
<Flex
  direction={{ base: 'column', md: 'row' }}
  gap={{ base: '300', md: '400' }}
  alignItems={{ base: 'stretch', md: 'center' }}
>
  <Input size="md" placeholder="City, ZIP, or address" css={{ flex: { md: '1' } }} />
  <Button tone="brand" emphasis="filled" size="md" css={{ width: { base: '100%', md: 'auto' } }}>
    Search
  </Button>
</Flex>
```

---

## 8. PandaCSS `css()` Function Responsive Styles

### Object Syntax with Responsive Values

```tsx
const containerStyles = css({
  padding: { base: '400', lg: '600' },
  maxWidth: { base: '100%', xl: '1200px' },
  margin: '0 auto',
  display: { base: 'block', lg: 'grid' },
  gridTemplateColumns: { lg: '1fr 1fr' },
  gap: { lg: '600' },
});

<div className={containerStyles}>Content</div>
```

### Nested Condition Syntax

```tsx
const heroStyles = css({
  textAlign: 'center',
  padding: '600',
  lg: {
    textAlign: 'left',
    padding: '800',
    display: 'flex',
    alignItems: 'center',
    gap: '800',
  },
  xlDown: {
    paddingX: '400',
  },
});
```

### Combining with Component Props

```tsx
<Card outlined elevated={false} tone="neutral" className={css({
  p: { base: '300', lg: '400' },
  lg: {
    display: 'flex',
    gap: '400',
    alignItems: 'center',
  },
})}>
  <Box css={{ flex: { lg: '1' } }}>
    <Text textStyle="body-bold">Title</Text>
    <Text textStyle="body" color="text.subtle">Description</Text>
  </Box>
  <Button tone="brand" emphasis="filled" size="md" css={{ width: { base: '100%', lg: 'auto' }, mt: { base: '300', lg: '0' } }}>
    Action
  </Button>
</Card>
```

### Full Page Responsive Example

```tsx
function DashboardPage() {
  return (
    <Page.Root>
      <Page.Header>
        <Flex justifyContent="space-between" alignItems="center" p="400">
          <ZillowLogo css={{ height: { base: '16px', lg: '24px' }, width: 'auto' }} />
          <Box hideBelow="lg">
            <Flex gap="300" alignItems="center">
              <Button tone="brand" emphasis="tertiary" size="md">Dashboard</Button>
              <Button tone="brand" emphasis="tertiary" size="md">Listings</Button>
            </Flex>
          </Box>
        </Flex>
      </Page.Header>
      <Divider />
      <Page.Content css={{ px: '400', py: '600' }}>
        <Flex direction="column" gap="800">
          <Heading level={1} textStyle="heading-lg">Dashboard</Heading>

          <Grid columns={{ base: 1, md: 2, xl: 4 }} gap="400">
            {stats.map(stat => (
              <Card outlined elevated={false} tone="neutral" key={stat.label}>
                <Flex direction="column" gap="100">
                  <Text textStyle="body" color="text.subtle">{stat.label}</Text>
                  <Text textStyle="body-lg-bold">{stat.value}</Text>
                </Flex>
              </Card>
            ))}
          </Grid>

          <Flex direction={{ base: 'column', lg: 'row' }} gap="400">
            <Box flex={{ lg: '2' }}>
              <Card outlined elevated={false} tone="neutral">
                <Text textStyle="body-lg-bold">Recent activity</Text>
              </Card>
            </Box>
            <Box flex={{ lg: '1' }}>
              <Card outlined elevated={false} tone="neutral">
                <Text textStyle="body-lg-bold">Quick actions</Text>
              </Card>
            </Box>
          </Flex>
        </Flex>
      </Page.Content>
    </Page.Root>
  );
}
```
