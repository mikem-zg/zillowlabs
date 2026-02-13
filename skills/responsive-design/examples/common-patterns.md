# Responsive Design Patterns

Production-ready React responsive patterns using PandaCSS breakpoints and Constellation components.

**Breakpoints:** sm (320px), md (480px), lg (768px), xl (1024px), xxl (1280px)
**Spacing tokens:** `100` (4px), `200` (8px), `300` (12px), `400` (16px), `600` (24px), `800` (32px)

---

## 1. Responsive Card Grid

### Auto-fit grid (no explicit breakpoints)

```tsx
import { css } from '@/styled-system/css';
import { Flex } from '@/styled-system/jsx';
import { Card, Text } from '@zillow/constellation';

interface Item {
  id: string;
  title: string;
  description: string;
}

function AutoFitCardGrid({ items }: { items: Item[] }) {
  return (
    <div className={css({
      display: 'grid',
      gridTemplateColumns: 'repeat(auto-fit, minmax(min(100%, 280px), 1fr))',
      gap: '400',
      px: '400',
      py: '600',
    })}>
      {items.map((item) => (
        <Card outlined elevated={false} tone="neutral" key={item.id}>
          <Flex direction="column" gap="200">
            <Text textStyle="body-bold">{item.title}</Text>
            <Text textStyle="body" color="text.subtle">{item.description}</Text>
          </Flex>
        </Card>
      ))}
    </div>
  );
}
```

### Breakpoint-based grid (1 → 2 → 3 columns)

```tsx
import { css } from '@/styled-system/css';
import { Grid, Flex } from '@/styled-system/jsx';
import { Card, Text } from '@zillow/constellation';

interface Item {
  id: string;
  title: string;
  description: string;
}

function BreakpointCardGrid({ items }: { items: Item[] }) {
  return (
    <Grid
      columns={{ base: 1, md: 2, xl: 3 }}
      gap="400"
      className={css({ px: '400', py: '600' })}
    >
      {items.map((item) => (
        <Card outlined elevated={false} tone="neutral" key={item.id}>
          <Flex direction="column" gap="200">
            <Text textStyle="body-bold">{item.title}</Text>
            <Text textStyle="body" color="text.subtle">{item.description}</Text>
          </Flex>
        </Card>
      ))}
    </Grid>
  );
}
```

### Interactive card grid

```tsx
import { Grid, Flex } from '@/styled-system/jsx';
import { css } from '@/styled-system/css';
import { Card, Text } from '@zillow/constellation';

interface ClickableItem {
  id: string;
  title: string;
  description: string;
  onClick: () => void;
}

function InteractiveCardGrid({ items }: { items: ClickableItem[] }) {
  return (
    <Grid
      columns={{ base: 1, md: 2, xl: 3 }}
      gap="400"
      className={css({ px: '400', py: '600' })}
    >
      {items.map((item) => (
        <Card elevated interactive tone="neutral" key={item.id} onClick={item.onClick}>
          <Flex direction="column" gap="200">
            <Text textStyle="body-bold">{item.title}</Text>
            <Text textStyle="body" color="text.subtle">{item.description}</Text>
          </Flex>
        </Card>
      ))}
    </Grid>
  );
}
```

---

## 2. Responsive Navigation (Page.Header)

```tsx
import { useState } from 'react';
import { css } from '@/styled-system/css';
import { Box, Flex } from '@/styled-system/jsx';
import { Button, Page, ZillowLogo, Text, Divider, Icon } from '@zillow/constellation';
import { IconMenuFilled, IconCloseFilled, IconSearchFilled, IconHomeFilled } from '@zillow/constellation-icons';

interface NavItem {
  label: string;
  href: string;
}

function ResponsiveNavigation({ navItems }: { navItems: NavItem[] }) {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  return (
    <Page.Root>
      <Page.Header>
        <Flex justifyContent="space-between" alignItems="center">
          <ZillowLogo css={{ height: { base: '16px', lg: '24px' }, width: 'auto' }} />

          <Box hideBelow="lg">
            <Flex gap="300" alignItems="center">
              {navItems.map((item) => (
                <Button
                  key={item.label}
                  emphasis="tertiary"
                  size="md"
                  onClick={() => window.location.href = item.href}
                >
                  {item.label}
                </Button>
              ))}
              <Button
                tone="brand"
                emphasis="filled"
                size="md"
                icon={<IconSearchFilled />}
                iconPosition="start"
              >
                Search
              </Button>
            </Flex>
          </Box>

          <Box hideFrom="lg">
            <Button
              size="md"
              emphasis="tertiary"
              icon={isMenuOpen ? <IconCloseFilled /> : <IconMenuFilled />}
              onClick={() => setIsMenuOpen(!isMenuOpen)}
              aria-expanded={isMenuOpen}
              aria-label="Toggle menu"
            />
          </Box>
        </Flex>
      </Page.Header>
      <Divider />

      {isMenuOpen && (
        <Box hideFrom="lg" className={css({ bg: 'bg.screen.neutral' })}>
          <Flex direction="column" gap="100" className={css({ px: '400', py: '300' })}>
            {navItems.map((item) => (
              <Button
                key={item.label}
                emphasis="tertiary"
                size="md"
                onClick={() => {
                  window.location.href = item.href;
                  setIsMenuOpen(false);
                }}
                className={css({ justifyContent: 'flex-start', width: '100%' })}
              >
                {item.label}
              </Button>
            ))}
            <Divider />
            <Button
              tone="brand"
              emphasis="filled"
              size="md"
              icon={<IconSearchFilled />}
              iconPosition="start"
              className={css({ width: '100%' })}
            >
              Search
            </Button>
          </Flex>
        </Box>
      )}
    </Page.Root>
  );
}
```

---

## 3. Responsive Data Table

```tsx
import { css } from '@/styled-system/css';
import { Box, Flex } from '@/styled-system/jsx';
import { Card, Text, Divider } from '@zillow/constellation';

interface TableRow {
  id: string;
  address: string;
  price: string;
  beds: number;
  baths: number;
  sqft: string;
  status: string;
}

function ResponsiveDataTable({ rows }: { rows: TableRow[] }) {
  return (
    <>
      <Box className={css({ display: { base: 'none', lg: 'block' }, overflowX: 'auto' })}>
        <table className={css({
          width: '100%',
          borderCollapse: 'collapse',
          '& th': {
            textAlign: 'left',
            p: '300',
            fontWeight: 'bold',
            fontSize: 'sm',
            color: 'text.subtle',
          },
          '& td': {
            p: '300',
            fontSize: 'sm',
          },
          '& tr:not(:last-child) td': {
            pb: '300',
          },
        })}>
          <thead>
            <tr>
              <th>Address</th>
              <th>Price</th>
              <th>Beds</th>
              <th>Baths</th>
              <th>Sqft</th>
              <th>Status</th>
            </tr>
            <tr><td colSpan={6}><Divider /></td></tr>
          </thead>
          <tbody>
            {rows.map((row) => (
              <tr key={row.id}>
                <td><Text textStyle="body-bold">{row.address}</Text></td>
                <td><Text textStyle="body">{row.price}</Text></td>
                <td><Text textStyle="body">{row.beds}</Text></td>
                <td><Text textStyle="body">{row.baths}</Text></td>
                <td><Text textStyle="body">{row.sqft}</Text></td>
                <td><Text textStyle="body">{row.status}</Text></td>
              </tr>
            ))}
          </tbody>
        </table>
      </Box>

      <Box className={css({ display: { base: 'block', lg: 'none' } })}>
        <Flex direction="column" gap="300" className={css({ px: '400' })}>
          {rows.map((row) => (
            <Card outlined elevated={false} tone="neutral" key={row.id}>
              <Flex direction="column" gap="200">
                <Text textStyle="body-bold">{row.address}</Text>
                <Flex justifyContent="space-between">
                  <Text textStyle="body" color="text.subtle">Price</Text>
                  <Text textStyle="body">{row.price}</Text>
                </Flex>
                <Divider />
                <Flex justifyContent="space-between">
                  <Text textStyle="body" color="text.subtle">Beds / Baths</Text>
                  <Text textStyle="body">{row.beds} bd / {row.baths} ba</Text>
                </Flex>
                <Flex justifyContent="space-between">
                  <Text textStyle="body" color="text.subtle">Sqft</Text>
                  <Text textStyle="body">{row.sqft}</Text>
                </Flex>
                <Flex justifyContent="space-between">
                  <Text textStyle="body" color="text.subtle">Status</Text>
                  <Text textStyle="body">{row.status}</Text>
                </Flex>
              </Flex>
            </Card>
          ))}
        </Flex>
      </Box>
    </>
  );
}
```

---

## 4. Responsive Hero Section

```tsx
import { css } from '@/styled-system/css';
import { Box, Flex } from '@/styled-system/jsx';
import { Button, Heading, Text } from '@zillow/constellation';
import { IconSearchFilled } from '@zillow/constellation-icons';

function ResponsiveHero() {
  return (
    <div className={css({
      minHeight: '100dvh',
      display: 'flex',
      flexDirection: 'column',
      justifyContent: 'center',
      position: 'relative',
      overflow: 'hidden',
    })}>
      <picture>
        <source
          media="(min-width: 1024px)"
          srcSet="/hero-wide.webp"
          type="image/webp"
        />
        <source
          media="(min-width: 768px)"
          srcSet="/hero-medium.webp"
          type="image/webp"
        />
        <source srcSet="/hero-mobile.webp" type="image/webp" />
        <img
          src="/hero-mobile.jpg"
          alt="Beautiful homes in your area"
          loading="eager"
          fetchPriority="high"
          className={css({
            position: 'absolute',
            inset: 0,
            width: '100%',
            height: '100%',
            objectFit: 'cover',
            zIndex: 0,
          })}
        />
      </picture>

      <div className={css({
        position: 'absolute',
        inset: 0,
        bg: 'rgba(0, 0, 0, 0.4)',
        zIndex: 1,
      })} />

      <Flex
        direction="column"
        gap={{ base: '400', lg: '600' }}
        alignItems={{ base: 'center', lg: 'flex-start' }}
        className={css({
          position: 'relative',
          zIndex: 2,
          px: { base: '400', lg: '600' },
          py: '600',
          maxWidth: '800px',
          textAlign: { base: 'center', lg: 'left' },
        })}
      >
        <Heading
          level={1}
          className={css({
            fontSize: 'clamp(1.75rem, 4vw + 1rem, 3.5rem)',
            lineHeight: '1.1',
            color: 'white',
          })}
        >
          Find your perfect home
        </Heading>

        <Text
          textStyle="body"
          className={css({
            fontSize: 'clamp(1rem, 0.95rem + 0.25vw, 1.25rem)',
            color: 'rgba(255, 255, 255, 0.9)',
            maxWidth: '600px',
          })}
        >
          Search millions of homes and find the one that's right for you.
        </Text>

        <Button
          tone="brand"
          emphasis="filled"
          size="md"
          icon={<IconSearchFilled />}
          iconPosition="start"
        >
          Start searching
        </Button>
      </Flex>
    </div>
  );
}
```

---

## 5. useMediaQuery Hook

```tsx
import { useState, useEffect } from 'react';

function useMediaQuery(query: string, defaultValue = false): boolean {
  const [matches, setMatches] = useState<boolean>(() => {
    if (typeof window === 'undefined') return defaultValue;
    return window.matchMedia(query).matches;
  });

  useEffect(() => {
    if (typeof window === 'undefined') return;

    const mediaQuery = window.matchMedia(query);
    setMatches(mediaQuery.matches);

    const handler = (event: MediaQueryListEvent) => {
      setMatches(event.matches);
    };

    mediaQuery.addEventListener('change', handler);
    return () => mediaQuery.removeEventListener('change', handler);
  }, [query]);

  return matches;
}

export { useMediaQuery };
```

### Usage

```tsx
import { useMediaQuery } from '@/hooks/use-media-query';
import { Box } from '@/styled-system/jsx';
import { Text } from '@zillow/constellation';

function ResponsiveComponent() {
  const isDesktop = useMediaQuery('(min-width: 768px)');
  const prefersReducedMotion = useMediaQuery('(prefers-reduced-motion: reduce)');

  return (
    <Box>
      <Text textStyle="body">
        {isDesktop ? 'Desktop layout' : 'Mobile layout'}
      </Text>
    </Box>
  );
}
```

---

## 6. useBreakpoint Hook

```tsx
import { useState, useEffect } from 'react';

const BREAKPOINTS = {
  mobile: 0,
  tablet: 768,
  desktop: 1024,
  wide: 1280,
} as const;

type BreakpointName = keyof typeof BREAKPOINTS;

function useBreakpoint(defaultValue: BreakpointName = 'mobile'): BreakpointName {
  const [breakpoint, setBreakpoint] = useState<BreakpointName>(() => {
    if (typeof window === 'undefined') return defaultValue;
    return getBreakpoint(window.innerWidth);
  });

  useEffect(() => {
    if (typeof window === 'undefined') return;

    const queries = [
      { name: 'wide' as const, mq: window.matchMedia('(min-width: 1280px)') },
      { name: 'desktop' as const, mq: window.matchMedia('(min-width: 1024px)') },
      { name: 'tablet' as const, mq: window.matchMedia('(min-width: 768px)') },
    ];

    const update = () => {
      setBreakpoint(getBreakpoint(window.innerWidth));
    };

    queries.forEach(({ mq }) => mq.addEventListener('change', update));
    return () => {
      queries.forEach(({ mq }) => mq.removeEventListener('change', update));
    };
  }, []);

  return breakpoint;
}

function getBreakpoint(width: number): BreakpointName {
  if (width >= BREAKPOINTS.wide) return 'wide';
  if (width >= BREAKPOINTS.desktop) return 'desktop';
  if (width >= BREAKPOINTS.tablet) return 'tablet';
  return 'mobile';
}

export { useBreakpoint, BREAKPOINTS };
export type { BreakpointName };
```

### Usage

```tsx
import { useBreakpoint } from '@/hooks/use-breakpoint';
import { Grid } from '@/styled-system/jsx';
import { Card, Text } from '@zillow/constellation';

function AdaptiveGrid({ items }: { items: { id: string; title: string }[] }) {
  const breakpoint = useBreakpoint();

  const columnsMap = {
    mobile: 1,
    tablet: 2,
    desktop: 3,
    wide: 4,
  };

  return (
    <Grid columns={columnsMap[breakpoint]} gap="400">
      {items.map((item) => (
        <Card outlined elevated={false} tone="neutral" key={item.id}>
          <Text textStyle="body-bold">{item.title}</Text>
        </Card>
      ))}
    </Grid>
  );
}
```

---

## 7. useResizeObserver Hook

### Basic implementation

```tsx
import { useState, useEffect, useRef, useCallback, type RefObject } from 'react';

interface Dimensions {
  width: number;
  height: number;
}

function useResizeObserver<T extends HTMLElement>(): [RefObject<T | null>, Dimensions] {
  const ref = useRef<T | null>(null);
  const [dimensions, setDimensions] = useState<Dimensions>({ width: 0, height: 0 });

  useEffect(() => {
    const element = ref.current;
    if (!element) return;

    const observer = new ResizeObserver((entries) => {
      const entry = entries[0];
      if (!entry) return;
      const { width, height } = entry.contentRect;
      setDimensions({ width, height });
    });

    observer.observe(element);
    return () => observer.disconnect();
  }, []);

  return [ref, dimensions];
}

export { useResizeObserver };
export type { Dimensions };
```

### Debounced version

```tsx
import { useState, useEffect, useRef, type RefObject } from 'react';

interface Dimensions {
  width: number;
  height: number;
}

function useDebouncedResizeObserver<T extends HTMLElement>(
  delay = 150
): [RefObject<T | null>, Dimensions] {
  const ref = useRef<T | null>(null);
  const [dimensions, setDimensions] = useState<Dimensions>({ width: 0, height: 0 });
  const timeoutRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    const element = ref.current;
    if (!element) return;

    const observer = new ResizeObserver((entries) => {
      const entry = entries[0];
      if (!entry) return;

      if (timeoutRef.current) clearTimeout(timeoutRef.current);
      timeoutRef.current = setTimeout(() => {
        const { width, height } = entry.contentRect;
        setDimensions({ width, height });
      }, delay);
    });

    observer.observe(element);
    return () => {
      observer.disconnect();
      if (timeoutRef.current) clearTimeout(timeoutRef.current);
    };
  }, [delay]);

  return [ref, dimensions];
}

export { useDebouncedResizeObserver };
```

### Usage with component-level responsiveness

```tsx
import { useResizeObserver } from '@/hooks/use-resize-observer';
import { css } from '@/styled-system/css';
import { Flex, Grid } from '@/styled-system/jsx';
import { Card, Text } from '@zillow/constellation';

function AdaptiveContainer() {
  const [ref, { width }] = useResizeObserver<HTMLDivElement>();

  const columns = width > 800 ? 3 : width > 500 ? 2 : 1;

  return (
    <div ref={ref} className={css({ width: '100%' })}>
      <Grid columns={columns} gap="400">
        <Card outlined elevated={false} tone="neutral">
          <Text textStyle="body-bold">Card 1</Text>
        </Card>
        <Card outlined elevated={false} tone="neutral">
          <Text textStyle="body-bold">Card 2</Text>
        </Card>
        <Card outlined elevated={false} tone="neutral">
          <Text textStyle="body-bold">Card 3</Text>
        </Card>
      </Grid>
    </div>
  );
}
```

---

## 8. Responsive Form Layout

```tsx
import { css } from '@/styled-system/css';
import { Flex, Grid, Box } from '@/styled-system/jsx';
import { Button, Card, Text, Heading, Input, Select, Divider } from '@zillow/constellation';

interface FormData {
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  propertyType: string;
  priceRange: string;
  message: string;
}

function ResponsiveForm() {
  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
  };

  return (
    <Card outlined elevated={false} tone="neutral" className={css({ maxWidth: '800px', mx: 'auto' })}>
      <form onSubmit={handleSubmit}>
        <Flex direction="column" gap="600">
          <Flex direction="column" gap="100">
            <Heading level={2} textStyle="heading-lg">Contact an agent</Heading>
            <Text textStyle="body" color="text.subtle">
              Fill out the form and we'll connect you with a local expert.
            </Text>
          </Flex>

          <Flex direction="column" gap="400">
            <Flex
              direction={{ base: 'column', lg: 'row' }}
              gap="400"
            >
              <Box flex="1">
                <Input label="First name" size="md" required />
              </Box>
              <Box flex="1">
                <Input label="Last name" size="md" required />
              </Box>
            </Flex>

            <Flex
              direction={{ base: 'column', lg: 'row' }}
              gap="400"
            >
              <Box flex="1">
                <Input label="Email" type="email" size="md" required />
              </Box>
              <Box flex="1">
                <Input label="Phone" type="tel" size="md" />
              </Box>
            </Flex>

            <Divider />

            <Flex
              direction={{ base: 'column', lg: 'row' }}
              gap="400"
            >
              <Box flex="1">
                <Select label="Property type" size="md">
                  <option value="">Select type</option>
                  <option value="house">House</option>
                  <option value="condo">Condo</option>
                  <option value="townhouse">Townhouse</option>
                  <option value="multi-family">Multi-family</option>
                </Select>
              </Box>
              <Box flex="1">
                <Select label="Price range" size="md">
                  <option value="">Select range</option>
                  <option value="0-250k">$0 – $250,000</option>
                  <option value="250k-500k">$250,000 – $500,000</option>
                  <option value="500k-1m">$500,000 – $1,000,000</option>
                  <option value="1m+">$1,000,000+</option>
                </Select>
              </Box>
            </Flex>

            <Input label="Message" size="md" />
          </Flex>

          <Flex justifyContent={{ base: 'stretch', lg: 'flex-end' }}>
            <Button
              tone="brand"
              emphasis="filled"
              size="md"
              type="submit"
              className={css({ width: { base: '100%', lg: 'auto' } })}
            >
              Submit
            </Button>
          </Flex>
        </Flex>
      </form>
    </Card>
  );
}
```

---

## 9. Responsive Sidebar Layout

```tsx
import { useState } from 'react';
import { css } from '@/styled-system/css';
import { Box, Flex } from '@/styled-system/jsx';
import { Button, Text, Divider, Icon } from '@zillow/constellation';
import { IconMenuFilled, IconCloseFilled, IconHomeFilled, IconHeartFilled, IconSearchFilled } from '@zillow/constellation-icons';

interface SidebarItem {
  label: string;
  icon: React.ReactNode;
  onClick: () => void;
}

function ResponsiveSidebarLayout({ children }: { children: React.ReactNode }) {
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);

  const sidebarItems: SidebarItem[] = [
    { label: 'Home', icon: <IconHomeFilled />, onClick: () => {} },
    { label: 'Saved', icon: <IconHeartFilled />, onClick: () => {} },
    { label: 'Search', icon: <IconSearchFilled />, onClick: () => {} },
  ];

  const sidebarContent = (
    <Flex direction="column" gap="100" className={css({ p: '400' })}>
      <Flex direction="column" gap="100">
        {sidebarItems.map((item) => (
          <Button
            key={item.label}
            emphasis="tertiary"
            size="md"
            icon={item.icon}
            iconPosition="start"
            onClick={item.onClick}
            className={css({ justifyContent: 'flex-start', width: '100%' })}
          >
            {item.label}
          </Button>
        ))}
      </Flex>
    </Flex>
  );

  return (
    <Flex direction={{ base: 'column', lg: 'row' }} className={css({ minHeight: '100dvh' })}>
      <Box hideBelow="lg" className={css({
        width: '260px',
        flexShrink: 0,
        bg: 'bg.screen.neutral',
        borderRight: '1px solid',
        borderColor: 'border.default',
      })}>
        {sidebarContent}
      </Box>

      {isSidebarOpen && (
        <Box hideFrom="lg" className={css({
          position: 'fixed',
          inset: 0,
          zIndex: 50,
          bg: 'rgba(0, 0, 0, 0.5)',
        })} onClick={() => setIsSidebarOpen(false)}>
          <Box
            className={css({
              width: '280px',
              height: '100%',
              bg: 'bg.screen.neutral',
            })}
            onClick={(e: React.MouseEvent) => e.stopPropagation()}
          >
            <Flex justifyContent="flex-end" className={css({ p: '200' })}>
              <Button
                size="md"
                emphasis="tertiary"
                icon={<IconCloseFilled />}
                onClick={() => setIsSidebarOpen(false)}
                aria-label="Close sidebar"
              />
            </Flex>
            <Divider />
            {sidebarContent}
          </Box>
        </Box>
      )}

      <Flex direction="column" flex="1" className={css({ minWidth: 0 })}>
        <Box hideFrom="lg" className={css({ p: '200' })}>
          <Button
            size="md"
            emphasis="tertiary"
            icon={<IconMenuFilled />}
            onClick={() => setIsSidebarOpen(true)}
            aria-label="Open sidebar"
          />
        </Box>

        <Box className={css({ flex: 1, p: { base: '400', lg: '600' } })}>
          {children}
        </Box>
      </Flex>
    </Flex>
  );
}
```

---

## 10. Responsive PropertyCard Grid

```tsx
import { css } from '@/styled-system/css';
import { Grid } from '@/styled-system/jsx';
import { PropertyCard } from '@zillow/constellation';

interface Property {
  id: string;
  imageUrl: string;
  price: string;
  beds: number;
  baths: number;
  sqft: string;
  address: string;
  city: string;
  isSaved: boolean;
  isNew: boolean;
}

function ResponsivePropertyGrid({
  properties,
  onSave,
  onClick,
}: {
  properties: Property[];
  onSave: (id: string) => void;
  onClick: (id: string) => void;
}) {
  return (
    <Grid
      columns={{ base: 1, md: 2, xl: 3 }}
      gap={{ base: '400', lg: '600' }}
      className={css({ px: '400', py: '600' })}
    >
      {properties.map((property) => (
        <PropertyCard
          key={property.id}
          appearance="large"
          photoBody={
            <PropertyCard.Photo
              src={property.imageUrl}
              alt={`Home at ${property.address}`}
            />
          }
          badge={
            property.isNew ? (
              <PropertyCard.Badge tone="accent">New listing</PropertyCard.Badge>
            ) : undefined
          }
          saveButton={
            <PropertyCard.SaveButton
              onClick={() => onSave(property.id)}
              isSaved={property.isSaved}
            />
          }
          data={{
            dataArea1: property.price,
            dataArea2: (
              <PropertyCard.HomeDetails
                data={[
                  { value: property.beds, label: 'bd' },
                  { value: property.baths, label: 'ba' },
                  { value: property.sqft, label: 'sqft' },
                ]}
              />
            ),
            dataArea3: property.address,
            dataArea4: property.city,
          }}
          elevated
          interactive
          onClick={() => onClick(property.id)}
        />
      ))}
    </Grid>
  );
}
```

---

## Quick Reference: Responsive Prop Patterns

### Common responsive values

```tsx
import { css } from '@/styled-system/css';
import { Flex, Box, Grid } from '@/styled-system/jsx';

<Flex direction={{ base: 'column', lg: 'row' }} />

<Grid columns={{ base: 1, md: 2, xl: 3 }} gap="400" />

<Box className={css({
  p: { base: '400', lg: '600' },
  fontSize: { base: 'sm', md: 'md', xl: 'lg' },
  display: { base: 'none', lg: 'block' },
})} />

<Box hideBelow="lg">Desktop only</Box>
<Box hideFrom="lg">Mobile only</Box>
```

### Responsive width patterns

```tsx
import { css } from '@/styled-system/css';
import { Box } from '@/styled-system/jsx';

<Box className={css({
  width: { base: '100%', lg: '50%', xl: '33.333%' },
  maxWidth: { base: '100%', lg: '800px' },
  mx: 'auto',
})} />
```

### Responsive spacing

```tsx
import { css } from '@/styled-system/css';
import { Flex } from '@/styled-system/jsx';

<Flex
  direction="column"
  gap={{ base: '400', lg: '800' }}
  className={css({
    px: { base: '400', lg: '600' },
    py: { base: '400', lg: '600' },
  })}
/>
```
