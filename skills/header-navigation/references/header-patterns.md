# Header Patterns — Full Code Examples

> **Layout rule:** All headers use `Box` from `@zillow/constellation` for layout — never `Flex` or `Grid` from `@/styled-system/jsx`. Use `borderBottom: "default"` + `borderColor: "border.muted"` on the header container instead of `<Divider />`. Use semantic spacing tokens (`"default"`, `"tight"`, `"tighter"`) instead of numeric tokens. All nav links use `TextButton asChild` with `<a>` tags inside a `<nav>` landmark via `Box asChild`. Mobile menus use the `Menu` component with `Menu.Group`. Search uses `AdornedInput` with `IconButton` adornment.

## Table of Contents

1. [Basic Consumer Header](#1-basic-consumer-header)
2. [Sticky Consumer Header](#2-sticky-consumer-header)
3. [Search Bar Header](#3-search-bar-header)
4. [Mobile-Responsive Header](#4-mobile-responsive-header)
5. [Professional Header](#5-professional-header)
6. [Tabs Navigation Header](#6-tabs-navigation-header)
7. [Sidebar Header](#7-sidebar-header)
8. [Breadcrumb Header](#8-breadcrumb-header)
9. [Centered Logo Header](#9-centered-logo-header)
10. [No Divider Header](#10-no-divider-header)

---

## 1. Basic Consumer Header

Standard header with logo, nav links, secondary links, sign-in button, and menu icon fallback.

```tsx
import {
  Page, Text, TextButton, Button, ZillowLogo, ZillowHomeLogo, Icon, IconButton, Box,
} from "@zillow/constellation";
import { IconMenuFilled } from "@zillow/constellation-icons";

export default function BasicConsumerHeader() {
  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
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
        <Box css={{ display: "flex", alignItems: "center", gap: "default" }}>
          <Box>
            <ZillowLogo role="img"
              css={{ display: { base: "none", md: "block" }, height: "24px", width: "auto" }} />
            <ZillowHomeLogo role="img"
              css={{ display: { base: "block", md: "none" }, height: "24px", width: "auto" }} />
          </Box>
          <Box css={{ display: { base: "none", lg: "flex" }, gap: "default" }} asChild>
            <nav>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Buy</a>
              </TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Rent</a>
              </TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Sell</a>
              </TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Home loans</a>
              </TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Agent finder</a>
              </TextButton>
            </nav>
          </Box>
        </Box>
        <Box css={{ display: "flex", alignItems: "center", gap: "tight" }}>
          <Box css={{ display: { base: "none", md: "flex" }, gap: "default" }}>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
              <a href="#">Manage rentals</a>
            </TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
              <a href="#">Advertise</a>
            </TextButton>
          </Box>
          <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>
            Sign in
          </Button>
          <Box css={{ display: { base: "block", lg: "none" } }}>
            <IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
              <Icon size="md"><IconMenuFilled /></Icon>
            </IconButton>
          </Box>
        </Box>
      </Box>
      <Page.Content>{/* content */}</Page.Content>
    </Page.Root>
  );
}
```

## 2. Sticky Consumer Header

Same as basic but wrapped in a sticky Box. Nav links collapse behind menu icon below `lg`.

```tsx
import {
  Page, Text, TextButton, Button, ZillowLogo, ZillowHomeLogo, Icon, IconButton, Box,
} from "@zillow/constellation";
import { IconMenuFilled } from "@zillow/constellation-icons";

export default function StickyConsumerHeader() {
  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
      <Box
        css={{
          position: "sticky",
          display: "flow-root",
          top: 0,
          zIndex: 10,
          width: "100%",
          maxWidth: "100%",
          background: "bg.screen.neutral",
        }}
      >
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
          <Box css={{ display: "flex", alignItems: "center", gap: "default" }}>
            <Box>
              <ZillowLogo role="img"
                css={{ display: { base: "none", md: "block" }, height: "24px", width: "auto" }} />
              <ZillowHomeLogo role="img"
                css={{ display: { base: "block", md: "none" }, height: "24px", width: "auto" }} />
            </Box>
            <Box css={{ display: { base: "none", lg: "flex" }, gap: "default" }} asChild>
              <nav>
                <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                  <a href="#">Buy</a>
                </TextButton>
                <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                  <a href="#">Rent</a>
                </TextButton>
                <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                  <a href="#">Sell</a>
                </TextButton>
                <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                  <a href="#">Home loans</a>
                </TextButton>
                <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                  <a href="#">Agent finder</a>
                </TextButton>
              </nav>
            </Box>
          </Box>
          <Box css={{ display: "flex", alignItems: "center", gap: "tight" }}>
            <Box css={{ display: { base: "none", md: "flex" }, gap: "default" }}>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Manage rentals</a>
              </TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Advertise</a>
              </TextButton>
            </Box>
            <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>
              Sign in
            </Button>
            <Box css={{ display: { base: "block", lg: "none" } }}>
              <IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
                <Icon size="md"><IconMenuFilled /></Icon>
              </IconButton>
            </Box>
          </Box>
        </Box>
      </Box>
      <Page.Content>{/* scrollable content */}</Page.Content>
    </Page.Root>
  );
}
```

## 3. Search Bar Header

Sticky header with `AdornedInput` search bar and `IconButton` adornment.

```tsx
import {
  Page, Text, TextButton, Button, ZillowLogo, ZillowHomeLogo,
  AdornedInput, Icon, IconButton, Box,
} from "@zillow/constellation";
import { IconSearchFilled, IconMenuFilled } from "@zillow/constellation-icons";

export default function SearchHeader() {
  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
      <Box
        css={{
          position: "sticky",
          display: "flow-root",
          top: 0,
          zIndex: 10,
          width: "100%",
          maxWidth: "100%",
          background: "bg.screen.neutral",
        }}
      >
        <Box
          css={{
            display: "flex",
            alignItems: "center",
            justifyContent: "space-between",
            gap: "default",
            width: "100%",
            paddingX: "default",
            paddingY: "tight",
            borderBottom: "default",
            borderColor: "border.muted",
          }}
        >
          <Box css={{ flexShrink: 0 }}>
            <ZillowLogo role="img"
              css={{ display: { base: "none", md: "block" }, height: "24px", width: "auto" }} />
            <ZillowHomeLogo role="img"
              css={{ display: { base: "block", md: "none" }, height: "24px", width: "auto" }} />
          </Box>
          <Box css={{ display: { base: "none", lg: "flex" }, gap: "default", flexShrink: 0 }} asChild>
            <nav>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Buy</a>
              </TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Rent</a>
              </TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Sell</a>
              </TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Home loans</a>
              </TextButton>
            </nav>
          </Box>
          <Box css={{ flex: 1, maxWidth: "480px" }}>
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
          </Box>
          <Box css={{ display: "flex", alignItems: "center", gap: "tight", flexShrink: 0 }}>
            <Box css={{ display: { base: "none", md: "block" } }}>
              <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>
                Sign in
              </Button>
            </Box>
            <Box css={{ display: { base: "block", lg: "none" } }}>
              <IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
                <Icon size="md"><IconMenuFilled /></Icon>
              </IconButton>
            </Box>
          </Box>
        </Box>
      </Box>
      <Page.Content>{/* content */}</Page.Content>
    </Page.Root>
  );
}
```

## 4. Mobile-Responsive Header

Full responsive header with `Menu` component for mobile navigation using `Menu.Group`.

```tsx
import {
  Page, Text, TextButton, Button, ZillowLogo, ZillowHomeLogo,
  Icon, IconButton, Menu, Box,
} from "@zillow/constellation";
import { IconMenuFilled, IconSearchFilled, IconUserFilled } from "@zillow/constellation-icons";

export default function MobileResponsiveHeader() {
  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
      <Box
        css={{
          position: "sticky",
          display: "flow-root",
          top: 0,
          zIndex: 10,
          width: "100%",
          maxWidth: "100%",
          background: "bg.screen.neutral",
        }}
      >
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
          <Box css={{ display: "flex", alignItems: "center", gap: "default" }}>
            <Box>
              <ZillowLogo role="img"
                css={{ display: { base: "none", md: "block" }, height: "24px", width: "auto" }} />
              <ZillowHomeLogo role="img"
                css={{ display: { base: "block", md: "none" }, height: "24px", width: "auto" }} />
            </Box>
            <Box css={{ display: { base: "none", lg: "flex" }, gap: "default" }} asChild>
              <nav>
                <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                  <a href="#">Buy</a>
                </TextButton>
                <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                  <a href="#">Rent</a>
                </TextButton>
                <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                  <a href="#">Sell</a>
                </TextButton>
                <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                  <a href="#">Home loans</a>
                </TextButton>
                <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                  <a href="#">Agent finder</a>
                </TextButton>
              </nav>
            </Box>
          </Box>
          <Box css={{ display: "flex", alignItems: "center", gap: "tighter" }}>
            <IconButton title="Search" tone="neutral" emphasis="bare" size="sm" shape="circle">
              <Icon size="md"><IconSearchFilled /></Icon>
            </IconButton>
            <Box css={{ display: { base: "none", md: "block" } }}>
              <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>
                Sign in
              </Button>
            </Box>
            <Box css={{ display: { base: "block", md: "none" } }}>
              <IconButton title="Account" tone="neutral" emphasis="bare" size="sm" shape="circle">
                <Icon size="md"><IconUserFilled /></Icon>
              </IconButton>
            </Box>
            <Box css={{ display: { base: "block", lg: "none" } }}>
              <Menu
                content={
                  <>
                    <Menu.Group aria-label="Core navigation">
                      <Menu.Item asChild><a href="#"><Menu.ItemLabel>Buy</Menu.ItemLabel></a></Menu.Item>
                      <Menu.Item asChild><a href="#"><Menu.ItemLabel>Rent</Menu.ItemLabel></a></Menu.Item>
                      <Menu.Item asChild><a href="#"><Menu.ItemLabel>Sell</Menu.ItemLabel></a></Menu.Item>
                      <Menu.Item asChild><a href="#"><Menu.ItemLabel>Home loans</Menu.ItemLabel></a></Menu.Item>
                      <Menu.Item asChild><a href="#"><Menu.ItemLabel>Agent finder</Menu.ItemLabel></a></Menu.Item>
                    </Menu.Group>
                    <Menu.Group aria-label="Current user actions">
                      <Menu.Item asChild><a href="#"><Menu.ItemLabel>Manage rentals</Menu.ItemLabel></a></Menu.Item>
                      <Menu.Item asChild><a href="#"><Menu.ItemLabel>Advertise</Menu.ItemLabel></a></Menu.Item>
                    </Menu.Group>
                  </>
                }
              >
                <IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
                  <Icon size="md"><IconMenuFilled /></Icon>
                </IconButton>
              </Menu>
            </Box>
          </Box>
        </Box>
      </Box>
      <Page.Content>{/* content */}</Page.Content>
    </Page.Root>
  );
}
```

## 5. Professional Header

For agent/business apps. Uses notification/settings IconButtons, Avatar, and nav links with `asChild`.

```tsx
import {
  Page, Text, TextButton, ZillowLogo, ZillowHomeLogo,
  Icon, IconButton, Avatar, Box,
} from "@zillow/constellation";
import { IconNotificationFilled, IconSettingsFilled, IconMenuFilled } from "@zillow/constellation-icons";

export default function ProfessionalHeader() {
  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
      <Box
        css={{
          position: "sticky",
          display: "flow-root",
          top: 0,
          zIndex: 10,
          width: "100%",
          maxWidth: "100%",
          background: "bg.screen.neutral",
        }}
      >
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
          <Box css={{ display: "flex", alignItems: "center", gap: "default" }}>
            <Box>
              <ZillowLogo role="img"
                css={{ display: { base: "none", md: "block" }, height: "24px", width: "auto" }} />
              <ZillowHomeLogo role="img"
                css={{ display: { base: "block", md: "none" }, height: "24px", width: "auto" }} />
            </Box>
          </Box>
          <Box css={{ display: { base: "none", lg: "flex" }, gap: "default" }} asChild>
            <nav>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Dashboard</a>
              </TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Listings</a>
              </TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Leads</a>
              </TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Performance</a>
              </TextButton>
            </nav>
          </Box>
          <Box css={{ display: "flex", alignItems: "center", gap: "tighter" }}>
            <IconButton title="Notifications" tone="neutral" emphasis="bare" size="sm" shape="circle">
              <Icon size="md"><IconNotificationFilled /></Icon>
            </IconButton>
            <IconButton title="Settings" tone="neutral" emphasis="bare" size="sm" shape="circle">
              <Icon size="md"><IconSettingsFilled /></Icon>
            </IconButton>
            <Avatar.Root size="sm">
              <Avatar.Image src="https://example.com/photo.jpg" alt="Jane Smith" />
            </Avatar.Root>
            <Box css={{ display: { base: "block", lg: "none" } }}>
              <IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
                <Icon size="md"><IconMenuFilled /></Icon>
              </IconButton>
            </Box>
          </Box>
        </Box>
      </Box>
      <Page.Content>{/* content */}</Page.Content>
    </Page.Root>
  );
}
```

## 6. Tabs Navigation Header

Minimal header with Tabs below for section switching. Tabs use `defaultSelected`.

```tsx
import {
  Page, Text, Button, ZillowLogo, ZillowHomeLogo, Tabs, Icon, IconButton, Box,
} from "@zillow/constellation";
import { IconSearchFilled } from "@zillow/constellation-icons";

export default function HeaderWithTabs() {
  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
      <Box
        css={{
          position: "sticky",
          display: "flow-root",
          top: 0,
          zIndex: 10,
          width: "100%",
          maxWidth: "100%",
          background: "bg.screen.neutral",
        }}
      >
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
          <Box css={{ display: "flex", alignItems: "center", gap: "default" }}>
            <Box>
              <ZillowLogo role="img"
                css={{ display: { base: "none", md: "block" }, height: "24px", width: "auto" }} />
              <ZillowHomeLogo role="img"
                css={{ display: { base: "block", md: "none" }, height: "24px", width: "auto" }} />
            </Box>
          </Box>
          <Box css={{ display: "flex", alignItems: "center", gap: "tight" }}>
            <IconButton title="Search" tone="neutral" emphasis="bare" size="sm" shape="circle">
              <Icon size="md"><IconSearchFilled /></Icon>
            </IconButton>
            <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>
              Sign in
            </Button>
          </Box>
        </Box>
        <Box css={{ paddingX: "default" }}>
          <Tabs.Root appearance="default" defaultSelected="overview">
            <Tabs.List>
              <Tabs.Tab value="overview">Overview</Tabs.Tab>
              <Tabs.Tab value="photos">Photos</Tabs.Tab>
              <Tabs.Tab value="map">Map</Tabs.Tab>
              <Tabs.Tab value="schools">Schools</Tabs.Tab>
              <Tabs.Tab value="neighborhood">Neighborhood</Tabs.Tab>
            </Tabs.List>
          </Tabs.Root>
        </Box>
      </Box>
      <Page.Content>{/* content */}</Page.Content>
    </Page.Root>
  );
}
```

## 7. Sidebar Navigation Header

Minimal top header with VerticalNav sidebar. Sidebar uses `borderRight` instead of Divider. Collapses to icon-only below `lg`.

```tsx
import {
  Text, ZillowLogo, ZillowHomeLogo, Icon, IconButton, Avatar, Anchor, VerticalNav, Box,
} from "@zillow/constellation";
import {
  IconGridFilled, IconUserGroupFilled, IconFileTextFilled,
  IconTrendingFilled, IconSettingsFilled, IconNotificationFilled, IconQuestionMarkCircleFilled,
} from "@zillow/constellation-icons";

export default function HeaderWithSidebar() {
  return (
    <Box css={{ height: "100vh", display: "flex", flexDirection: "column" }}>
      <Box
        css={{
          display: "flow-root",
          width: "100%",
          maxWidth: "100%",
          background: "bg.screen.neutral",
          flexShrink: 0,
        }}
      >
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
          <Box css={{ display: "flex", alignItems: "center", gap: "default" }}>
            <Box>
              <ZillowLogo role="img"
                css={{ display: { base: "none", md: "block" }, height: "24px", width: "auto" }} />
              <ZillowHomeLogo role="img"
                css={{ display: { base: "block", md: "none" }, height: "24px", width: "auto" }} />
            </Box>
          </Box>
          <Box css={{ display: "flex", alignItems: "center", gap: "tighter" }}>
            <IconButton title="Notifications" tone="neutral" emphasis="bare" size="sm" shape="circle">
              <Icon size="md"><IconNotificationFilled /></Icon>
            </IconButton>
            <Avatar.Root size="sm">
              <Avatar.Image src="https://example.com/photo.jpg" alt="Jane Smith" />
            </Avatar.Root>
          </Box>
        </Box>
      </Box>
      <Box css={{ display: "flex", flex: 1, overflow: "hidden" }}>
        <Box
          css={{
            width: { base: "60px", lg: "240px" },
            flexShrink: 0,
            background: "bg.screen.neutral",
            overflowY: "auto",
            paddingY: "tight",
            borderRight: "default",
            borderColor: "border.muted",
          }}
        >
          <VerticalNav.Root background outlined={false} elevated={false} tone="neutral">
            <VerticalNav.List>
              <VerticalNav.Item current>
                <Anchor href="#">
                  <Icon size="md"><IconGridFilled /></Icon>
                  <Box css={{ display: { base: "none", lg: "inline" } }}>Dashboard</Box>
                </Anchor>
              </VerticalNav.Item>
              <VerticalNav.Item>
                <Anchor href="#">
                  <Icon size="md"><IconUserGroupFilled /></Icon>
                  <Box css={{ display: { base: "none", lg: "inline" } }}>Leads</Box>
                </Anchor>
              </VerticalNav.Item>
              <VerticalNav.Item>
                <Anchor href="#">
                  <Icon size="md"><IconFileTextFilled /></Icon>
                  <Box css={{ display: { base: "none", lg: "inline" } }}>Listings</Box>
                </Anchor>
              </VerticalNav.Item>
              <VerticalNav.Item>
                <Anchor href="#">
                  <Icon size="md"><IconTrendingFilled /></Icon>
                  <Box css={{ display: { base: "none", lg: "inline" } }}>Performance</Box>
                </Anchor>
              </VerticalNav.Item>
            </VerticalNav.List>
            <VerticalNav.Divider />
            <VerticalNav.List>
              <VerticalNav.Item>
                <Anchor href="#">
                  <Icon size="md"><IconSettingsFilled /></Icon>
                  <Box css={{ display: { base: "none", lg: "inline" } }}>Settings</Box>
                </Anchor>
              </VerticalNav.Item>
              <VerticalNav.Item>
                <Anchor href="#">
                  <Icon size="md"><IconQuestionMarkCircleFilled /></Icon>
                  <Box css={{ display: { base: "none", lg: "inline" } }}>Help</Box>
                </Anchor>
              </VerticalNav.Item>
            </VerticalNav.List>
          </VerticalNav.Root>
        </Box>
        <Box css={{ flex: 1, overflowY: "auto", padding: "loose" }}>
          {/* main content */}
        </Box>
      </Box>
    </Box>
  );
}
```

## 8. Breadcrumb Header

Header with breadcrumb row and detail page heading + action buttons.

```tsx
import {
  Page, Text, Heading, TextButton, Button, ZillowLogo, ZillowHomeLogo,
  ButtonGroup, Icon, IconButton, Box,
} from "@zillow/constellation";
import { IconChevronLeftFilled, IconMenuFilled } from "@zillow/constellation-icons";

export default function HeaderWithBreadcrumb() {
  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
      <Box
        css={{
          position: "sticky",
          display: "flow-root",
          top: 0,
          zIndex: 10,
          width: "100%",
          maxWidth: "100%",
          background: "bg.screen.neutral",
        }}
      >
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
          <Box css={{ display: "flex", alignItems: "center", gap: "default" }}>
            <Box>
              <ZillowLogo role="img"
                css={{ display: { base: "none", md: "block" }, height: "24px", width: "auto" }} />
              <ZillowHomeLogo role="img"
                css={{ display: { base: "block", md: "none" }, height: "24px", width: "auto" }} />
            </Box>
          </Box>
          <Box css={{ display: "flex", alignItems: "center", gap: "tight" }}>
            <Box css={{ display: { base: "none", md: "flex" }, gap: "default" }} asChild>
              <nav>
                <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                  <a href="#">Buy</a>
                </TextButton>
                <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                  <a href="#">Rent</a>
                </TextButton>
                <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                  <a href="#">Sell</a>
                </TextButton>
              </nav>
            </Box>
            <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>
              Sign in
            </Button>
            <Box css={{ display: { base: "block", md: "none" } }}>
              <IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
                <Icon size="md"><IconMenuFilled /></Icon>
              </IconButton>
            </Box>
          </Box>
        </Box>
      </Box>
      <Page.Breadcrumb>
        <TextButton icon={<IconChevronLeftFilled />} textStyle="body" tone="neutral">
          Back to search results
        </TextButton>
      </Page.Breadcrumb>
      <Box css={{ paddingX: "default", paddingY: "default" }}>
        <Box
          css={{
            display: "flex",
            flexDirection: { base: "column", md: "row" },
            alignItems: { base: "flex-start", md: "center" },
            justifyContent: "space-between",
            gap: "default",
          }}
        >
          <Heading level={1} textStyle="heading-md">
            123 Main Street, Seattle, WA 98101
          </Heading>
          <ButtonGroup aria-label="Property actions" css={{ flexShrink: 0, whiteSpace: "nowrap" }}>
            <Button size="sm" emphasis="filled" tone="brand" css={{ whiteSpace: "nowrap" }}>
              Contact agent
            </Button>
            <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>
              Save
            </Button>
          </ButtonGroup>
        </Box>
      </Box>
      <Page.Content>{/* content */}</Page.Content>
    </Page.Root>
  );
}
```

## 9. Centered Logo Header

Three-column layout with nav links left, logo centered, and actions right.

```tsx
import {
  Page, Text, TextButton, Button, ZillowLogo, ZillowHomeLogo, Icon, IconButton, Box,
} from "@zillow/constellation";
import { IconMenuFilled } from "@zillow/constellation-icons";

export default function CenteredLogoHeader() {
  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
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
        <Box
          css={{ display: { base: "none", lg: "flex" }, gap: "default", flex: 1 }}
          asChild
        >
          <nav>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
              <a href="#">Buy</a>
            </TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
              <a href="#">Rent</a>
            </TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
              <a href="#">Sell</a>
            </TextButton>
          </nav>
        </Box>
        <Box css={{ display: { base: "block", lg: "none" } }}>
          <IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
            <Icon size="md"><IconMenuFilled /></Icon>
          </IconButton>
        </Box>
        <Box
          css={{
            display: "flex",
            alignItems: "center",
            justifyContent: { base: "flex-start", lg: "center" },
            flex: 1,
          }}
        >
          <ZillowLogo role="img"
            css={{ display: { base: "none", md: "block" }, height: "24px", width: "auto" }} />
          <ZillowHomeLogo role="img"
            css={{ display: { base: "block", md: "none" }, height: "24px", width: "auto" }} />
        </Box>
        <Box
          css={{
            display: "flex",
            alignItems: "center",
            justifyContent: "flex-end",
            gap: "default",
            flex: 1,
          }}
        >
          <Box css={{ display: { base: "none", lg: "flex" }, gap: "default" }}>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
              <a href="#">Home loans</a>
            </TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
              <a href="#">Agent finder</a>
            </TextButton>
          </Box>
          <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>
            Sign in
          </Button>
        </Box>
      </Box>
      <Page.Content>{/* content */}</Page.Content>
    </Page.Root>
  );
}
```

## 10. No Divider Header

Same structure as basic consumer but without `borderBottom` for a seamless look.

```tsx
import {
  Page, Text, TextButton, Button, ZillowLogo, ZillowHomeLogo, Icon, IconButton, Box,
} from "@zillow/constellation";
import { IconMenuFilled } from "@zillow/constellation-icons";

export default function NoDividerHeader() {
  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
      <Box
        css={{
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
          width: "100%",
          paddingX: "default",
          paddingY: "tight",
        }}
      >
        <Box css={{ display: "flex", alignItems: "center", gap: "default" }}>
          <Box>
            <ZillowLogo role="img"
              css={{ display: { base: "none", md: "block" }, height: "24px", width: "auto" }} />
            <ZillowHomeLogo role="img"
              css={{ display: { base: "block", md: "none" }, height: "24px", width: "auto" }} />
          </Box>
          <Box css={{ display: { base: "none", lg: "flex" }, gap: "default" }} asChild>
            <nav>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Buy</a>
              </TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Rent</a>
              </TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Sell</a>
              </TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Home loans</a>
              </TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
                <a href="#">Agent finder</a>
              </TextButton>
            </nav>
          </Box>
        </Box>
        <Box css={{ display: "flex", alignItems: "center", gap: "tight" }}>
          <Box css={{ display: { base: "none", md: "flex" }, gap: "default" }}>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
              <a href="#">Manage rentals</a>
            </TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }} asChild>
              <a href="#">Advertise</a>
            </TextButton>
          </Box>
          <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>
            Sign in
          </Button>
          <Box css={{ display: { base: "block", lg: "none" } }}>
            <IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
              <Icon size="md"><IconMenuFilled /></Icon>
            </IconButton>
          </Box>
        </Box>
      </Box>
      <Page.Content>{/* content */}</Page.Content>
    </Page.Root>
  );
}
```
