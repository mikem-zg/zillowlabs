# Component Defaults for Headers

## TextButton

Default: `textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild` with `<a href="#">` child.

Nav links must always use `asChild` with an anchor tag for proper semantics. Wrap groups in `Box asChild` + `<nav>` for accessible navigation landmarks.

```tsx
<Box css={{ display: { base: "none", lg: "flex" }, gap: "default" }} asChild>
  <nav>
    <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
      <a href="#">Buy</a>
    </TextButton>
    <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
      <a href="#">Rent</a>
    </TextButton>
  </nav>
</Box>
```

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

## Header Borders

Use `borderBottom` and `borderColor` CSS props on the header container Box — never `<Divider />` for header borders.

| Context | CSS Props |
|---------|-----------|
| Below header | `borderBottom: "default"`, `borderColor: "border.muted"` |
| Sidebar separator | `borderRight: "default"`, `borderColor: "border.muted"` |
| No-border variant | Omit `borderBottom` entirely |

```tsx
<Box
  css={{
    display: "flex",
    alignItems: "center",
    justifyContent: "space-between",
    width: "100%",
    paddingX: "default",
    paddingY: "tight",
    borderBottom: "default",
    borderColor: "border.muted",
  }}
>
  {/* header content */}
</Box>
```

## Logo

Both logos in one wrapper Box, toggled via responsive `display` on each:
```tsx
<Box>
  <ZillowLogo role="img"
    css={{ display: { base: "none", md: "block" }, height: "24px", width: "auto" }} />
  <ZillowHomeLogo role="img"
    css={{ display: { base: "block", md: "none" }, height: "24px", width: "auto" }} />
</Box>
```

## AdornedInput (Search)

Use `AdornedInput` with `IconButton` end adornment for search bars — never plain `Input`:
```tsx
<AdornedInput
  input={
    <AdornedInput.Input
      aria-label="Search properties"
      placeholder="Search by address, neighborhood, or ZIP"
    />
  }
  endAdornment={
    <AdornedInput.Adornment asChild>
      <IconButton emphasis="bare" shape="circle" size="md" title="Search" tone="neutral">
        <Icon><IconSearchFilled /></Icon>
      </IconButton>
    </AdornedInput.Adornment>
  }
/>
```

## Menu (Mobile Nav)

Use the `Menu` component with `Menu.Group` for mobile navigation — never custom dropdown panels with `useState`:
```tsx
<Menu
  content={
    <>
      <Menu.Group aria-label="Core navigation">
        <Menu.Item asChild><a href="#"><Menu.ItemLabel>Buy</Menu.ItemLabel></a></Menu.Item>
        <Menu.Item asChild><a href="#"><Menu.ItemLabel>Rent</Menu.ItemLabel></a></Menu.Item>
      </Menu.Group>
      <Menu.Group aria-label="User actions">
        <Menu.Item asChild><a href="#"><Menu.ItemLabel>Manage rentals</Menu.ItemLabel></a></Menu.Item>
      </Menu.Group>
    </>
  }
>
  <IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
    <Icon size="md"><IconMenuFilled /></Icon>
  </IconButton>
</Menu>
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

Sidebar collapses to icon-only (60px) below `lg`, expands to full labels (240px) at `lg+`. Uses `borderRight: "default"` + `borderColor: "border.muted"` instead of `<Divider />`.

## Spacing Tokens (Headers)

| Token | Use for |
|-------|---------|
| `"default"` | Standard gaps between nav links, `paddingX` on header |
| `"tight"` | `paddingY` on header, gaps between action buttons |
| `"tighter"` | Gaps between icon buttons (notifications, settings, avatar) |
| `"loose"` | Main content area padding |
