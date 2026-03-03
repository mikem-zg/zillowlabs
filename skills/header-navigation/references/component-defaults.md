# Component Defaults for Headers

## TextButton

Default: `textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}`

### TextStyle Variations

| textStyle | Use case |
|-----------|----------|
| `body` | Standard nav links (default) |
| `body-bold` | Emphasized/active nav links |
| `body-sm` | Compact headers, secondary nav |
| `body-lg` | Large/prominent nav links |
| `body-lg-bold` | Large emphasized nav links |

### Tone Variations

| Tone | Use case |
|------|----------|
| `neutral` | Standard nav links (default) |
| `brand` | Branded/highlighted links |

### TextButton with Icon (Breadcrumb Back)

```tsx
<TextButton icon={<IconChevronLeftFilled />} textStyle="body" tone="neutral">
  Back to search results
</TextButton>
```

### Mobile Menu TextButtons (Left-Aligned)

```tsx
<TextButton textStyle="body" tone="neutral" css={{ justifyContent: "flex-start" }}>
  Buy
</TextButton>
```

## Button

Default in headers: `size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}`

| Variant | Props |
|---------|-------|
| Sign in (outlined) | `size="sm" emphasis="outlined" tone="neutral"` |
| Primary action (filled) | `size="sm" emphasis="filled" tone="brand"` |

## IconButton

Default: `tone="neutral" emphasis="bare" size="sm" shape="circle"`

Always wrap icon inside:
```tsx
<IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
  <Icon size="md"><IconMenuFilled /></Icon>
</IconButton>
```

Common header icons:
- `IconMenuFilled` — hamburger menu
- `IconCloseFilled` — close menu
- `IconSearchFilled` — search action
- `IconNotificationFilled` — notifications
- `IconSettingsFilled` — settings
- `IconUserFilled` — account (mobile)

## Icon

Always `size="md"` in headers. This controls the icon graphic size (24px), independent of the parent IconButton size.

## Avatar

Composed API with photo:
```tsx
<Avatar.Root size="sm">
  <Avatar.Image src="https://example.com/photo.jpg" alt="Jane Smith" />
</Avatar.Root>
```

## Divider

Default: `tone="muted-alt"`

| Context | Props |
|---------|-------|
| Below header | `tone="muted-alt"` |
| Sidebar separator | `tone="muted-alt" orientation="vertical" css={{ height: "100%" }}` |
| Inside mobile menu | `tone="muted-alt"` |
| No-divider variant | Omit entirely |

## Logo

Responsive swap pattern:
```tsx
<Box css={{ display: { base: "none", md: "block" } }}>
  <ZillowLogo role="img" css={{ height: "24px", width: "auto" }} />
</Box>
<Box css={{ display: { base: "block", md: "none" } }}>
  <ZillowHomeLogo role="img" css={{ height: "24px", width: "auto" }} />
</Box>
```

## Input

Default in headers: `size="sm"`

```tsx
<Input size="sm" placeholder="Search by address, neighborhood, or ZIP" aria-label="Search properties" />
```

## Tabs

Always include `defaultSelected`:
```tsx
<Tabs.Root appearance="default" defaultSelected="overview">
  <Tabs.List>
    <Tabs.Tab value="overview">Overview</Tabs.Tab>
  </Tabs.List>
</Tabs.Root>
```

## VerticalNav (Sidebar)

```tsx
<VerticalNav.Root background outlined={false} elevated={false} tone="neutral">
  <VerticalNav.List>
    <VerticalNav.Item current>
      <Anchor href="#">
        <Icon size="md"><IconGridFilled /></Icon>
        <Box css={{ display: { base: "none", lg: "inline" } }}>Dashboard</Box>
      </Anchor>
    </VerticalNav.Item>
  </VerticalNav.List>
</VerticalNav.Root>
```

Sidebar collapses to icon-only (60px) below `lg`, expands to full labels (240px) at `lg+`.
