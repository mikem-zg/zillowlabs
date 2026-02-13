# Migrating Page Headers: Custom Nav/AppBar → Constellation

## Constellation components

```tsx
import { Page, ZillowLogo, Divider, Text, Button } from '@zillow/constellation';
import { IconSearchFilled, IconNotificationFilled, IconPersonFilled, IconMenuFilled } from '@zillow/constellation-icons';
import { Flex } from '@/styled-system/jsx';
```

---

## Before (shadcn/ui)

```tsx
import { Button } from '@/components/ui/button';
import { NavigationMenu, NavigationMenuItem, NavigationMenuList } from '@/components/ui/navigation-menu';
import { Search, Bell, User, Menu } from 'lucide-react';

<header className="sticky top-0 z-50 w-full border-b bg-white">
  <div className="container flex h-16 items-center justify-between px-4">
    <div className="flex items-center gap-6">
      <img src="/logo.svg" alt="Logo" className="h-6" />
      <NavigationMenu>
        <NavigationMenuList>
          <NavigationMenuItem>Buy</NavigationMenuItem>
          <NavigationMenuItem>Rent</NavigationMenuItem>
          <NavigationMenuItem>Sell</NavigationMenuItem>
        </NavigationMenuList>
      </NavigationMenu>
    </div>
    <div className="flex items-center gap-4">
      <Button variant="ghost" size="icon"><Search className="h-5 w-5" /></Button>
      <Button variant="ghost" size="icon"><Bell className="h-5 w-5" /></Button>
      <Button variant="ghost" size="icon"><User className="h-5 w-5" /></Button>
    </div>
  </div>
</header>
```

## Before (MUI)

```tsx
import AppBar from '@mui/material/AppBar';
import Toolbar from '@mui/material/Toolbar';
import IconButton from '@mui/material/IconButton';
import Typography from '@mui/material/Typography';
import MenuIcon from '@mui/icons-material/Menu';
import SearchIcon from '@mui/icons-material/Search';
import NotificationsIcon from '@mui/icons-material/Notifications';
import AccountCircle from '@mui/icons-material/AccountCircle';

<AppBar position="sticky" color="default" elevation={1}>
  <Toolbar>
    <IconButton edge="start"><MenuIcon /></IconButton>
    <Typography variant="h6" sx={{ flexGrow: 1 }}>
      <img src="/logo.svg" alt="Logo" height={24} />
    </Typography>
    <nav>
      <Button>Buy</Button>
      <Button>Rent</Button>
      <Button>Sell</Button>
    </nav>
    <IconButton><SearchIcon /></IconButton>
    <IconButton><NotificationsIcon /></IconButton>
    <IconButton><AccountCircle /></IconButton>
  </Toolbar>
</AppBar>
```

## Before (Chakra UI)

```tsx
import { Box, Flex, HStack, Image, Link, IconButton } from '@chakra-ui/react';
import { HamburgerIcon, SearchIcon, BellIcon } from '@chakra-ui/icons';

<Box as="header" position="sticky" top={0} zIndex={50} bg="white" borderBottom="1px solid" borderColor="gray.200">
  <Flex maxW="container.xl" mx="auto" h={16} alignItems="center" justifyContent="space-between" px={4}>
    <HStack spacing={8}>
      <Image src="/logo.svg" h="24px" alt="Logo" />
      <HStack spacing={4}>
        <Link>Buy</Link>
        <Link>Rent</Link>
        <Link>Sell</Link>
      </HStack>
    </HStack>
    <HStack spacing={2}>
      <IconButton aria-label="Search" icon={<SearchIcon />} variant="ghost" />
      <IconButton aria-label="Notifications" icon={<BellIcon />} variant="ghost" />
    </HStack>
  </Flex>
</Box>
```

## Before (Tailwind + HTML)

```tsx
<header className="sticky top-0 z-50 bg-white border-b border-gray-200">
  <div className="max-w-7xl mx-auto px-4 h-16 flex items-center justify-between">
    <div className="flex items-center gap-8">
      <img src="/logo.svg" alt="Logo" className="h-6" />
      <nav className="hidden md:flex gap-6">
        <a href="/buy" className="text-sm font-medium hover:text-blue-600">Buy</a>
        <a href="/rent" className="text-sm font-medium hover:text-blue-600">Rent</a>
        <a href="/sell" className="text-sm font-medium hover:text-blue-600">Sell</a>
      </nav>
    </div>
    <div className="flex items-center gap-3">
      <button className="p-2 hover:bg-gray-100 rounded-full">
        <svg className="h-5 w-5">...</svg>
      </button>
      <button className="p-2 hover:bg-gray-100 rounded-full">
        <svg className="h-5 w-5">...</svg>
      </button>
    </div>
  </div>
</header>
```

---

## After (Constellation)

### Desktop header

```tsx
import { Page, ZillowLogo, Divider, Text, Button, Icon, IconButton } from '@zillow/constellation';
import { IconSearchFilled, IconNotificationFilled, IconPersonFilled } from '@zillow/constellation-icons';
import { Flex } from '@/styled-system/jsx';

<Page.Root>
  <Page.Header>
    <Flex justify="space-between" align="center" css={{ px: '400', py: '300' }}>
      <Flex align="center" gap="800">
        <ZillowLogo css={{ height: '24px', width: 'auto' }} />
        <Flex align="center" gap="600">
          <Text textStyle="body-bold" css={{ cursor: 'pointer' }}>Buy</Text>
          <Text textStyle="body-bold" css={{ cursor: 'pointer' }}>Rent</Text>
          <Text textStyle="body-bold" css={{ cursor: 'pointer' }}>Sell</Text>
        </Flex>
      </Flex>
      <Flex align="center" gap="200">
        <IconButton tone="neutral" emphasis="secondary" size="md" aria-label="Search">
          <IconSearchFilled />
        </IconButton>
        <IconButton tone="neutral" emphasis="secondary" size="md" aria-label="Notifications">
          <IconNotificationFilled />
        </IconButton>
        <IconButton tone="neutral" emphasis="secondary" size="md" aria-label="Account">
          <IconPersonFilled />
        </IconButton>
      </Flex>
    </Flex>
  </Page.Header>
  <Divider />
  <Page.Content css={{ px: '400', py: '600' }}>
    {/* Page content goes here */}
  </Page.Content>
</Page.Root>
```

### Mobile header

```tsx
<Page.Root>
  <Page.Header>
    <Flex justify="space-between" align="center" css={{ px: '400', py: '300' }}>
      <ZillowLogo css={{ height: '16px', width: 'auto' }} />
      <Flex align="center" gap="200">
        <IconButton tone="neutral" emphasis="secondary" size="md" aria-label="Search">
          <IconSearchFilled />
        </IconButton>
        <IconButton tone="neutral" emphasis="secondary" size="md" aria-label="Menu">
          <IconMenuFilled />
        </IconButton>
      </Flex>
    </Flex>
  </Page.Header>
  <Divider />
  <Page.Content css={{ px: '400', py: '600' }}>
    {/* Page content */}
  </Page.Content>
</Page.Root>
```

### Responsive header (desktop + mobile)

```tsx
<Page.Root>
  <Page.Header>
    <Flex justify="space-between" align="center" css={{ px: '400', py: '300' }}>
      <Flex align="center" gap="800">
        <ZillowLogo css={{
          height: { base: '16px', md: '24px' },
          width: 'auto'
        }} />
        <Flex
          align="center"
          gap="600"
          css={{ display: { base: 'none', md: 'flex' } }}
        >
          <Text textStyle="body-bold" css={{ cursor: 'pointer' }}>Buy</Text>
          <Text textStyle="body-bold" css={{ cursor: 'pointer' }}>Rent</Text>
          <Text textStyle="body-bold" css={{ cursor: 'pointer' }}>Sell</Text>
        </Flex>
      </Flex>
      <Flex align="center" gap="200">
        <IconButton tone="neutral" emphasis="secondary" size="md" aria-label="Search">
          <IconSearchFilled />
        </IconButton>
        <IconButton
          tone="neutral"
          emphasis="secondary"
          size="md"
          aria-label="Notifications"
          css={{ display: { base: 'none', md: 'inline-flex' } }}
        >
          <IconNotificationFilled />
        </IconButton>
        <IconButton
          tone="neutral"
          emphasis="secondary"
          size="md"
          aria-label="Account"
          css={{ display: { base: 'none', md: 'inline-flex' } }}
        >
          <IconPersonFilled />
        </IconButton>
        <IconButton
          tone="neutral"
          emphasis="secondary"
          size="md"
          aria-label="Menu"
          css={{ display: { base: 'inline-flex', md: 'none' } }}
        >
          <IconMenuFilled />
        </IconButton>
      </Flex>
    </Flex>
  </Page.Header>
  <Divider />
  <Page.Content css={{ px: '400', py: '600' }}>
    {/* Page content */}
  </Page.Content>
</Page.Root>
```

---

## Required rules

- ALWAYS use `Page.Header` inside `Page.Root` for navigation — NEVER use `Box`, `Flex`, or `<header>` as a standalone header
- ALWAYS add `<Divider />` below `Page.Header` — NEVER use CSS `border-bottom`
- ALWAYS use solid background on sticky headers (`bg.screen.neutral`) — NEVER transparent
- ALWAYS use `ZillowLogo` component — Desktop: 24px height, Mobile: 16px height
- Page structure MUST be: `Page.Root` > `Page.Header` + `Divider` + `Page.Content`
- Use `IconButton` for header action icons, not bare icons or custom buttons

---

## Anti-patterns

```tsx
// WRONG — Box/Flex as header
<Box as="header" position="sticky" top={0} borderBottom="1px solid" borderColor="gray.200">
  <Flex justify="space-between" align="center" px={4} py={3}>
    <img src="/logo.svg" height={24} />
    <nav>...</nav>
  </Flex>
</Box>

// CORRECT — Page.Header with Divider
<Page.Root>
  <Page.Header>
    <Flex justify="space-between" align="center" css={{ px: '400', py: '300' }}>
      <ZillowLogo css={{ height: '24px', width: 'auto' }} />
      <nav>...</nav>
    </Flex>
  </Page.Header>
  <Divider />
  <Page.Content>...</Page.Content>
</Page.Root>
```

```tsx
// WRONG — CSS border below header
<Page.Header css={{ borderBottom: '1px solid #e5e7eb' }}>
  ...
</Page.Header>

// CORRECT — Divider component below header
<Page.Header>...</Page.Header>
<Divider />
```

```tsx
// WRONG — random logo size
<ZillowLogo css={{ height: '32px' }} />

// CORRECT — 24px desktop, 16px mobile
<ZillowLogo css={{ height: { base: '16px', md: '24px' }, width: 'auto' }} />
```

```tsx
// WRONG — transparent sticky header
<Page.Header css={{ position: 'sticky', top: 0, backdropFilter: 'blur(8px)' }}>

// CORRECT — solid background
<Page.Header css={{ position: 'sticky', top: 0, bg: 'bg.screen.neutral' }}>
```

---

## Variants

### Professional app header

```tsx
<Page.Root>
  <Page.Header>
    <Flex justify="space-between" align="center" css={{ px: '400', py: '300' }}>
      <Flex align="center" gap="600">
        <ZillowLogo css={{ height: '24px', width: 'auto' }} />
        <Text textStyle="body-bold">Agent Hub</Text>
      </Flex>
      <Flex align="center" gap="300">
        <Button tone="brand" emphasis="filled" size="md">New listing</Button>
        <IconButton tone="neutral" emphasis="secondary" size="md" aria-label="Account">
          <IconPersonFilled />
        </IconButton>
      </Flex>
    </Flex>
  </Page.Header>
  <Divider />
  <Page.Content css={{ px: '400', py: '600' }}>
    {/* Professional content */}
  </Page.Content>
</Page.Root>
```

### Header with tabs navigation

```tsx
<Page.Root>
  <Page.Header>
    <Flex direction="column">
      <Flex justify="space-between" align="center" css={{ px: '400', py: '300' }}>
        <ZillowLogo css={{ height: '24px', width: 'auto' }} />
        <Flex align="center" gap="200">
          <IconButton tone="neutral" emphasis="secondary" size="md" aria-label="Account">
            <IconPersonFilled />
          </IconButton>
        </Flex>
      </Flex>
      <Tabs.Root defaultSelected="buy">
        <Tabs.List>
          <Tabs.Tab value="buy">Buy</Tabs.Tab>
          <Tabs.Tab value="rent">Rent</Tabs.Tab>
          <Tabs.Tab value="sell">Sell</Tabs.Tab>
        </Tabs.List>
      </Tabs.Root>
    </Flex>
  </Page.Header>
  <Divider />
  <Page.Content css={{ px: '400', py: '600' }}>
    {/* Content */}
  </Page.Content>
</Page.Root>
```

---

## Edge cases

### Minimal header (logo only)

```tsx
<Page.Root>
  <Page.Header>
    <Flex align="center" css={{ px: '400', py: '300' }}>
      <ZillowLogo css={{ height: '24px', width: 'auto' }} />
    </Flex>
  </Page.Header>
  <Divider />
  <Page.Content css={{ px: '400', py: '600' }}>
    {/* Content */}
  </Page.Content>
</Page.Root>
```

### Header with search bar

```tsx
<Page.Root>
  <Page.Header>
    <Flex justify="space-between" align="center" gap="400" css={{ px: '400', py: '300' }}>
      <ZillowLogo css={{ height: '24px', width: 'auto' }} />
      <Flex css={{ flex: 1, maxWidth: '600px' }}>
        <Input placeholder="Search address, city, or ZIP" size="md" />
      </Flex>
      <IconButton tone="neutral" emphasis="secondary" size="md" aria-label="Account">
        <IconPersonFilled />
      </IconButton>
    </Flex>
  </Page.Header>
  <Divider />
  <Page.Content css={{ px: '400', py: '600' }}>
    {/* Content */}
  </Page.Content>
</Page.Root>
```

### Sticky header with solid background

```tsx
<Page.Root>
  <Page.Header css={{ position: 'sticky', top: 0, zIndex: 50, bg: 'bg.screen.neutral' }}>
    <Flex justify="space-between" align="center" css={{ px: '400', py: '300' }}>
      <ZillowLogo css={{ height: '24px', width: 'auto' }} />
      <nav>...</nav>
    </Flex>
  </Page.Header>
  <Divider />
  <Page.Content css={{ px: '400', py: '600' }}>
    {/* Scrollable content */}
  </Page.Content>
</Page.Root>
```
