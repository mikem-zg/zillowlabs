# Header Patterns — Full Code Examples

> **Width alignment rule:** When the page content uses a max-width container (e.g., `maxWidth: "1200px"`), the header's inner `Flex` MUST use the same `maxWidth` + `mx: "auto"` so content aligns visually. The sticky `Box` wrapper stays full-bleed for the background color; only the inner layout container is constrained. All patterns below include `maxWidth: "1200px", mx: "auto"` on the inner Flex — adjust the value to match your page content width.

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
11. [Contained Header](#11-contained-header)

---

## 1. Basic Consumer Header

Standard header with logo, nav links, secondary links, sign-in button, and menu icon fallback.

```tsx
import {
  Page, Text, TextButton, Button, ZillowLogo, ZillowHomeLogo, Divider, Icon, IconButton,
} from "@zillow/constellation";
import { Box, Flex } from "@/styled-system/jsx";
import { IconMenuFilled } from "@zillow/constellation-icons";

export default function BasicConsumerHeader() {
  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
      <Flex align="center" justify="space-between" css={{ maxWidth: "1200px", mx: "auto", width: "100%", px: "400", py: "400" }}>
        <Flex align="center" gap="400">
          <Box css={{ display: { base: "none", md: "block" } }}>
            <ZillowLogo role="img" css={{ height: "24px", width: "auto" }} />
          </Box>
          <Box css={{ display: { base: "block", md: "none" } }}>
            <ZillowHomeLogo role="img" css={{ height: "24px", width: "auto" }} />
          </Box>
          <Box css={{ display: { base: "none", lg: "flex" }, gap: "400" }}>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Buy</TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Rent</TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Sell</TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Home loans</TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Agent finder</TextButton>
          </Box>
        </Flex>
        <Flex align="center" gap="300">
          <Box css={{ display: { base: "none", md: "flex" }, gap: "400" }}>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Manage rentals</TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Advertise</TextButton>
          </Box>
          <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>
            Sign in
          </Button>
          <Box css={{ display: { base: "block", lg: "none" } }}>
            <IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
              <Icon size="md"><IconMenuFilled /></Icon>
            </IconButton>
          </Box>
        </Flex>
      </Flex>
      <Divider tone="muted-alt" />
      <Page.Content>{/* content */}</Page.Content>
    </Page.Root>
  );
}
```

## 2. Sticky Consumer Header

Same as basic but wrapped in a sticky Box. Nav links collapse behind menu icon below `lg`.

```tsx
import {
  Page, Text, TextButton, Button, ZillowLogo, ZillowHomeLogo, Divider, Icon, IconButton,
} from "@zillow/constellation";
import { Box, Flex } from "@/styled-system/jsx";
import { IconMenuFilled } from "@zillow/constellation-icons";

export default function StickyConsumerHeader() {
  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
      <Box css={{ position: "sticky", display: "flow-root", top: 0, zIndex: 10, width: "100%", maxWidth: "100%", background: "bg.screen.neutral" }}>
        <Flex align="center" justify="space-between" css={{ maxWidth: "1200px", mx: "auto", width: "100%", px: "400", py: "400" }}>
          <Flex align="center" gap="400">
            <Box css={{ display: { base: "none", md: "block" } }}>
              <ZillowLogo role="img" css={{ height: "24px", width: "auto" }} />
            </Box>
            <Box css={{ display: { base: "block", md: "none" } }}>
              <ZillowHomeLogo role="img" css={{ height: "24px", width: "auto" }} />
            </Box>
            <Box css={{ display: { base: "none", lg: "flex" }, gap: "400" }}>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Buy</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Rent</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Sell</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Home loans</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Agent finder</TextButton>
            </Box>
          </Flex>
          <Flex align="center" gap="300">
            <Box css={{ display: { base: "none", md: "flex" }, gap: "400" }}>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Manage rentals</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Advertise</TextButton>
            </Box>
            <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>
              Sign in
            </Button>
            <Box css={{ display: { base: "block", lg: "none" } }}>
              <IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
                <Icon size="md"><IconMenuFilled /></Icon>
              </IconButton>
            </Box>
          </Flex>
        </Flex>
        <Divider tone="muted-alt" />
      </Box>
      <Page.Content>{/* scrollable content */}</Page.Content>
    </Page.Root>
  );
}
```

## 3. Search Bar Header

Sticky header with integrated search input. Nav links and search field share horizontal space.

```tsx
import {
  Page, Text, TextButton, Button, ZillowLogo, ZillowHomeLogo, Divider, Input, Icon, IconButton,
} from "@zillow/constellation";
import { Box, Flex } from "@/styled-system/jsx";
import { IconSearchFilled, IconMenuFilled } from "@zillow/constellation-icons";

export default function SearchHeader() {
  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
      <Box css={{ position: "sticky", display: "flow-root", top: 0, zIndex: 10, width: "100%", maxWidth: "100%", background: "bg.screen.neutral" }}>
        <Flex align="center" justify="space-between" gap="400" css={{ maxWidth: "1200px", mx: "auto", width: "100%", px: "400", py: "400" }}>
          <Box css={{ flexShrink: 0 }}>
            <Box css={{ display: { base: "none", md: "block" } }}>
              <ZillowLogo role="img" css={{ height: "24px", width: "auto" }} />
            </Box>
            <Box css={{ display: { base: "block", md: "none" } }}>
              <ZillowHomeLogo role="img" css={{ height: "24px", width: "auto" }} />
            </Box>
          </Box>
          <Box css={{ display: { base: "none", lg: "flex" }, gap: "400", flexShrink: 0 }}>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Buy</TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Rent</TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Sell</TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Home loans</TextButton>
          </Box>
          <Box css={{ flex: 1, maxWidth: "480px" }}>
            <Input size="sm" placeholder="Search by address, neighborhood, or ZIP" aria-label="Search properties" />
          </Box>
          <Flex align="center" gap="300" css={{ flexShrink: 0 }}>
            <IconButton title="Search" tone="neutral" emphasis="bare" size="sm" shape="circle">
              <Icon size="md"><IconSearchFilled /></Icon>
            </IconButton>
            <Box css={{ display: { base: "none", md: "block" } }}>
              <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>Sign in</Button>
            </Box>
            <Box css={{ display: { base: "block", lg: "none" } }}>
              <IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
                <Icon size="md"><IconMenuFilled /></Icon>
              </IconButton>
            </Box>
          </Flex>
        </Flex>
        <Divider tone="muted-alt" />
      </Box>
      <Page.Content>{/* content */}</Page.Content>
    </Page.Root>
  );
}
```

## 4. Mobile-Responsive Header

Full responsive header with hamburger toggle and slide-down menu panel. Uses `useState` for menu open/close.

```tsx
import { useState } from "react";
import {
  Page, Text, TextButton, Button, ZillowLogo, ZillowHomeLogo, Divider, Icon, IconButton,
} from "@zillow/constellation";
import { Box, Flex } from "@/styled-system/jsx";
import { IconMenuFilled, IconCloseFilled, IconSearchFilled, IconUserFilled } from "@zillow/constellation-icons";

export default function MobileResponsiveHeader() {
  const [menuOpen, setMenuOpen] = useState(false);

  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
      <Box css={{ position: "sticky", display: "flow-root", top: 0, zIndex: 10, width: "100%", maxWidth: "100%", background: "bg.screen.neutral" }}>
        <Flex align="center" justify="space-between" css={{ maxWidth: "1200px", mx: "auto", width: "100%", px: "400", py: "400" }}>
          <Flex align="center" gap="400">
            <Box css={{ display: { base: "none", md: "block" } }}>
              <ZillowLogo role="img" css={{ height: "24px", width: "auto" }} />
            </Box>
            <Box css={{ display: { base: "block", md: "none" } }}>
              <ZillowHomeLogo role="img" css={{ height: "24px", width: "auto" }} />
            </Box>
            <Box css={{ display: { base: "none", lg: "flex" }, gap: "400" }}>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Buy</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Rent</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Sell</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Home loans</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Agent finder</TextButton>
            </Box>
          </Flex>
          <Flex align="center" gap="200">
            <IconButton title="Search" tone="neutral" emphasis="bare" size="sm" shape="circle">
              <Icon size="md"><IconSearchFilled /></Icon>
            </IconButton>
            <Box css={{ display: { base: "none", md: "block" } }}>
              <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>Sign in</Button>
            </Box>
            <Box css={{ display: { base: "block", md: "none" } }}>
              <IconButton title="Account" tone="neutral" emphasis="bare" size="sm" shape="circle">
                <Icon size="md"><IconUserFilled /></Icon>
              </IconButton>
            </Box>
            <Box css={{ display: { base: "block", lg: "none" } }}>
              <IconButton
                title={menuOpen ? "Close menu" : "Open menu"}
                tone="neutral" emphasis="bare" size="sm" shape="circle"
                onClick={() => setMenuOpen(!menuOpen)}
              >
                <Icon size="md">{menuOpen ? <IconCloseFilled /> : <IconMenuFilled />}</Icon>
              </IconButton>
            </Box>
          </Flex>
        </Flex>
        <Divider tone="muted-alt" />
        {menuOpen && (
          <Box css={{ display: { base: "block", lg: "none" }, background: "bg.screen.neutral", py: "300", px: "400" }}>
            <Flex direction="column" gap="200">
              <TextButton textStyle="body" tone="neutral" css={{ justifyContent: "flex-start" }}>Buy</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ justifyContent: "flex-start" }}>Rent</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ justifyContent: "flex-start" }}>Sell</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ justifyContent: "flex-start" }}>Home loans</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ justifyContent: "flex-start" }}>Agent finder</TextButton>
              <Divider tone="muted-alt" />
              <TextButton textStyle="body" tone="neutral" css={{ justifyContent: "flex-start" }}>Manage rentals</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ justifyContent: "flex-start" }}>Advertise</TextButton>
            </Flex>
          </Box>
        )}
      </Box>
      <Page.Content>{/* content */}</Page.Content>
    </Page.Root>
  );
}
```

## 5. Professional Header

For agent/business apps. Uses notification/settings IconButtons and Avatar instead of text nav actions.

```tsx
import {
  Page, Text, TextButton, ZillowLogo, ZillowHomeLogo, Divider, Icon, IconButton, Avatar,
} from "@zillow/constellation";
import { Box, Flex } from "@/styled-system/jsx";
import { IconNotificationFilled, IconSettingsFilled, IconMenuFilled } from "@zillow/constellation-icons";

export default function ProfessionalHeader() {
  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
      <Box css={{ position: "sticky", display: "flow-root", top: 0, zIndex: 10, width: "100%", maxWidth: "100%", background: "bg.screen.neutral" }}>
        <Flex align="center" justify="space-between" css={{ maxWidth: "1200px", mx: "auto", width: "100%", px: "400", py: "300" }}>
          <Flex align="center" gap="400">
            <Box css={{ display: { base: "none", md: "block" } }}>
              <ZillowLogo role="img" css={{ height: "24px", width: "auto" }} />
            </Box>
            <Box css={{ display: { base: "block", md: "none" } }}>
              <ZillowHomeLogo role="img" css={{ height: "24px", width: "auto" }} />
            </Box>
          </Flex>
          <Box css={{ display: { base: "none", lg: "flex" }, gap: "400" }}>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Dashboard</TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Listings</TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Leads</TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Performance</TextButton>
          </Box>
          <Flex align="center" gap="200">
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
          </Flex>
        </Flex>
        <Divider tone="muted-alt" />
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
  Page, Text, Button, ZillowLogo, ZillowHomeLogo, Divider, Tabs, Icon, IconButton,
} from "@zillow/constellation";
import { Box, Flex } from "@/styled-system/jsx";
import { IconSearchFilled } from "@zillow/constellation-icons";

export default function HeaderWithTabs() {
  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
      <Box css={{ position: "sticky", display: "flow-root", top: 0, zIndex: 10, width: "100%", maxWidth: "100%", background: "bg.screen.neutral" }}>
        <Flex align="center" justify="space-between" css={{ maxWidth: "1200px", mx: "auto", width: "100%", px: "400", py: "400" }}>
          <Flex align="center" gap="400">
            <Box css={{ display: { base: "none", md: "block" } }}>
              <ZillowLogo role="img" css={{ height: "24px", width: "auto" }} />
            </Box>
            <Box css={{ display: { base: "block", md: "none" } }}>
              <ZillowHomeLogo role="img" css={{ height: "24px", width: "auto" }} />
            </Box>
          </Flex>
          <Flex align="center" gap="300">
            <IconButton title="Search" tone="neutral" emphasis="bare" size="sm" shape="circle">
              <Icon size="md"><IconSearchFilled /></Icon>
            </IconButton>
            <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>Sign in</Button>
          </Flex>
        </Flex>
        <Divider tone="muted-alt" />
        <Box css={{ maxWidth: "1200px", mx: "auto", width: "100%", px: "400" }}>
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

Minimal top header with VerticalNav sidebar. Sidebar collapses to icon-only below `lg`.

```tsx
import {
  Text, ZillowLogo, ZillowHomeLogo, Divider, Icon, IconButton, Avatar, Anchor, VerticalNav,
} from "@zillow/constellation";
import { Box, Flex } from "@/styled-system/jsx";
import {
  IconGridFilled, IconUserGroupFilled, IconFileTextFilled,
  IconTrendingFilled, IconSettingsFilled, IconNotificationFilled, IconQuestionMarkCircleFilled,
} from "@zillow/constellation-icons";

export default function HeaderWithSidebar() {
  return (
    <Box css={{ height: "100vh", display: "flex", flexDirection: "column" }}>
      <Box css={{ display: "flow-root", width: "100%", maxWidth: "100%", background: "bg.screen.neutral", flexShrink: 0 }}>
        <Flex align="center" justify="space-between" css={{ maxWidth: "1200px", mx: "auto", width: "100%", px: "400", py: "300" }}>
          <Flex align="center" gap="400">
            <Box css={{ display: { base: "none", md: "block" } }}>
              <ZillowLogo role="img" css={{ height: "24px", width: "auto" }} />
            </Box>
            <Box css={{ display: { base: "block", md: "none" } }}>
              <ZillowHomeLogo role="img" css={{ height: "24px", width: "auto" }} />
            </Box>
          </Flex>
          <Flex align="center" gap="200">
            <IconButton title="Notifications" tone="neutral" emphasis="bare" size="sm" shape="circle">
              <Icon size="md"><IconNotificationFilled /></Icon>
            </IconButton>
            <Avatar.Root size="sm">
              <Avatar.Image src="https://example.com/photo.jpg" alt="Jane Smith" />
            </Avatar.Root>
          </Flex>
        </Flex>
        <Divider tone="muted-alt" />
      </Box>
      <Flex css={{ flex: 1, overflow: "hidden" }}>
        <Box css={{ width: { base: "60px", lg: "240px" }, flexShrink: 0, background: "bg.screen.neutral", overflowY: "auto", py: "300" }}>
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
        <Divider tone="muted-alt" orientation="vertical" css={{ height: "100%" }} />
        <Box css={{ flex: 1, overflowY: "auto", p: "600" }}>
          {/* main content */}
        </Box>
      </Flex>
    </Box>
  );
}
```

## 8. Breadcrumb Header

Header with breadcrumb row and detail page heading + action buttons.

```tsx
import {
  Page, Text, Heading, TextButton, Button, ZillowLogo, ZillowHomeLogo,
  Divider, ButtonGroup, Icon, IconButton,
} from "@zillow/constellation";
import { Box, Flex } from "@/styled-system/jsx";
import { IconChevronLeftFilled, IconMenuFilled } from "@zillow/constellation-icons";

export default function HeaderWithBreadcrumb() {
  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
      <Box css={{ position: "sticky", display: "flow-root", top: 0, zIndex: 10, width: "100%", maxWidth: "100%", background: "bg.screen.neutral" }}>
        <Flex align="center" justify="space-between" css={{ maxWidth: "1200px", mx: "auto", width: "100%", px: "400", py: "400" }}>
          <Flex align="center" gap="400">
            <Box css={{ display: { base: "none", md: "block" } }}>
              <ZillowLogo role="img" css={{ height: "24px", width: "auto" }} />
            </Box>
            <Box css={{ display: { base: "block", md: "none" } }}>
              <ZillowHomeLogo role="img" css={{ height: "24px", width: "auto" }} />
            </Box>
          </Flex>
          <Flex align="center" gap="300">
            <Box css={{ display: { base: "none", md: "flex" }, gap: "400" }}>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Buy</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Rent</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Sell</TextButton>
            </Box>
            <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>Sign in</Button>
            <Box css={{ display: { base: "block", md: "none" } }}>
              <IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
                <Icon size="md"><IconMenuFilled /></Icon>
              </IconButton>
            </Box>
          </Flex>
        </Flex>
        <Divider tone="muted-alt" />
      </Box>
      <Page.Breadcrumb>
        <TextButton icon={<IconChevronLeftFilled />} textStyle="body" tone="neutral">
          Back to search results
        </TextButton>
      </Page.Breadcrumb>
      <Box css={{ px: "400", py: "400" }}>
        <Flex
          direction={{ base: "column", md: "row" }}
          align={{ base: "flex-start", md: "center" }}
          justify="space-between"
          gap="400"
        >
          <Heading level={1} textStyle="heading-md">123 Main Street, Seattle, WA 98101</Heading>
          <ButtonGroup aria-label="Property actions" css={{ flexShrink: 0, whiteSpace: "nowrap" }}>
            <Button size="sm" emphasis="filled" tone="brand" css={{ whiteSpace: "nowrap" }}>Contact agent</Button>
            <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>Save</Button>
          </ButtonGroup>
        </Flex>
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
  Page, Text, TextButton, Button, ZillowLogo, ZillowHomeLogo, Divider, Icon, IconButton,
} from "@zillow/constellation";
import { Box, Flex } from "@/styled-system/jsx";
import { IconMenuFilled } from "@zillow/constellation-icons";

export default function CenteredLogoHeader() {
  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
      <Flex align="center" justify="space-between" css={{ maxWidth: "1200px", mx: "auto", width: "100%", px: "400", py: "400" }}>
        <Box css={{ display: { base: "none", lg: "flex" }, gap: "400", flex: 1 }}>
          <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Buy</TextButton>
          <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Rent</TextButton>
          <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Sell</TextButton>
        </Box>
        <Box css={{ display: { base: "block", lg: "none" } }}>
          <IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
            <Icon size="md"><IconMenuFilled /></Icon>
          </IconButton>
        </Box>
        <Flex align="center" justify={{ base: "flex-start", lg: "center" }} css={{ flex: 1 }}>
          <Box css={{ display: { base: "none", md: "block" } }}>
            <ZillowLogo role="img" css={{ height: "24px", width: "auto" }} />
          </Box>
          <Box css={{ display: { base: "block", md: "none" } }}>
            <ZillowHomeLogo role="img" css={{ height: "24px", width: "auto" }} />
          </Box>
        </Flex>
        <Flex align="center" justify="flex-end" gap="400" css={{ flex: 1 }}>
          <Box css={{ display: { base: "none", lg: "flex" }, gap: "400" }}>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Home loans</TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Agent finder</TextButton>
          </Box>
          <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>Sign in</Button>
        </Flex>
      </Flex>
      <Divider tone="muted-alt" />
      <Page.Content>{/* content */}</Page.Content>
    </Page.Root>
  );
}
```

## 10. No-Divider Header

Same structure as basic consumer but without the bottom Divider for a seamless look.

```tsx
import {
  Page, Text, TextButton, Button, ZillowLogo, ZillowHomeLogo, Icon, IconButton,
} from "@zillow/constellation";
import { Box, Flex } from "@/styled-system/jsx";
import { IconMenuFilled } from "@zillow/constellation-icons";

export default function NoDividerHeader() {
  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
      <Flex align="center" justify="space-between" css={{ maxWidth: "1200px", mx: "auto", width: "100%", px: "400", py: "400" }}>
        <Flex align="center" gap="400">
          <Box css={{ display: { base: "none", md: "block" } }}>
            <ZillowLogo role="img" css={{ height: "24px", width: "auto" }} />
          </Box>
          <Box css={{ display: { base: "block", md: "none" } }}>
            <ZillowHomeLogo role="img" css={{ height: "24px", width: "auto" }} />
          </Box>
          <Box css={{ display: { base: "none", lg: "flex" }, gap: "400" }}>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Buy</TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Rent</TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Sell</TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Home loans</TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Agent finder</TextButton>
          </Box>
        </Flex>
        <Flex align="center" gap="300">
          <Box css={{ display: { base: "none", md: "flex" }, gap: "400" }}>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Manage rentals</TextButton>
            <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Advertise</TextButton>
          </Box>
          <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>Sign in</Button>
          <Box css={{ display: { base: "block", lg: "none" } }}>
            <IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
              <Icon size="md"><IconMenuFilled /></Icon>
            </IconButton>
          </Box>
        </Flex>
      </Flex>
      <Page.Content>{/* content */}</Page.Content>
    </Page.Root>
  );
}
```

---

## 11. Contained Header

Full-bleed sticky background with maxWidth-constrained inner content. Use when the page content has a max-width container so the header content aligns with it visually.

**Key rules:**
- Always match the header's inner `maxWidth` to the page content's `maxWidth`. The sticky `Box` wrapper remains full-bleed for the background color, but the inner `Flex` is constrained and centered with `mx: "auto"`.
- Default to `py: "400"` (16px) for consumer apps. Use `py: "300"` (12px) only for compact professional headers.

```tsx
import {
  Page, Text, TextButton, Button, ZillowLogo, ZillowHomeLogo, Divider, Icon, IconButton,
} from "@zillow/constellation";
import { Box, Flex } from "@/styled-system/jsx";
import { IconMenuFilled } from "@zillow/constellation-icons";

export default function ContainedHeader() {
  return (
    <Page.Root css={{ background: "bg.screen.neutral" }}>
      <Box css={{ position: "sticky", display: "flow-root", top: 0, zIndex: 10, background: "bg.screen.neutral" }}>
        <Flex
          align="center"
          justify="space-between"
          css={{ maxWidth: "1200px", mx: "auto", width: "100%", px: "400", py: "400" }}
        >
          <Flex align="center" gap="400">
            <Box css={{ display: { base: "none", md: "block" } }}>
              <ZillowLogo role="img" css={{ height: "24px", width: "auto" }} />
            </Box>
            <Box css={{ display: { base: "block", md: "none" } }}>
              <ZillowHomeLogo role="img" css={{ height: "24px", width: "auto" }} />
            </Box>
            <Box css={{ display: { base: "none", lg: "flex" }, gap: "400" }}>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Buy</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Rent</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Sell</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Home loans</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Agent finder</TextButton>
            </Box>
          </Flex>
          <Flex align="center" gap="300">
            <Box css={{ display: { base: "none", md: "flex" }, gap: "400" }}>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Manage rentals</TextButton>
              <TextButton textStyle="body" tone="neutral" css={{ whiteSpace: "nowrap" }}>Advertise</TextButton>
            </Box>
            <Button size="sm" emphasis="outlined" tone="neutral" css={{ whiteSpace: "nowrap" }}>Sign in</Button>
            <Box css={{ display: { base: "block", lg: "none" } }}>
              <IconButton title="Menu" tone="neutral" emphasis="bare" size="sm" shape="circle">
                <Icon size="md"><IconMenuFilled /></Icon>
              </IconButton>
            </Box>
          </Flex>
        </Flex>
        <Divider tone="muted-alt" />
      </Box>
      <Box css={{ maxWidth: "1200px", mx: "auto", width: "100%", px: "400", py: "600" }}>
        {/* Page content — same maxWidth as header inner content */}
      </Box>
    </Page.Root>
  );
}
```
