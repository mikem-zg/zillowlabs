# Page Composition: SearchResults + SiteHeader + FilterBar

## SearchResults Page (`pages/search-results.tsx`)

The page shell wires all components together. It manages two pieces of shared state:
- `activeMarker` — which property is highlighted on map + list
- `mapsApiKey` — fetched from server on mount

```tsx
import { useState, useEffect } from 'react';
import { Divider, Page } from '@zillow/constellation';
import { Flex, Box } from '@/styled-system/jsx';
import { SiteHeader } from '@/components/SiteHeader';
import { FilterBar } from '@/components/FilterBar';
import { MapView } from '@/components/MapView';
import { PropertyList } from '@/components/PropertyList';

export default function SearchResults() {
  const [activeMarker, setActiveMarker] = useState<number | null>(null);
  const [mapsApiKey, setMapsApiKey] = useState<string | null>(null);

  useEffect(() => {
    fetch('/api/maps-config')
      .then((res) => res.json())
      .then((data) => setMapsApiKey(data.apiKey))
      .catch(() => setMapsApiKey(''));
  }, []);

  return (
    <Page.Root fluid css={{ background: 'bg.screen.neutral', height: '100vh', display: 'flex', flexDirection: 'column', overflow: 'hidden', pb: '0', mb: '0' }}>
      <Box
        css={{
          position: 'sticky',
          display: 'flow-root',
          top: 0,
          zIndex: 20,
          width: '100%',
          maxWidth: '100%',
          background: 'bg.screen.neutral',
        }}
      >
        <SiteHeader />
        <FilterBar />
        <Divider />
      </Box>

      <Flex css={{ flex: 1, minHeight: 0, overflow: 'hidden' }}>
        <MapView
          mapsApiKey={mapsApiKey}
          activeMarker={activeMarker}
          setActiveMarker={setActiveMarker}
        />
        <PropertyList
          activeMarker={activeMarker}
          setActiveMarker={setActiveMarker}
        />
      </Flex>
    </Page.Root>
  );
}
```

## SiteHeader (`components/SiteHeader.tsx`)

Sticky navigation with ZillowLogo centered, nav links left, user actions right. Buy link triggers hover mega-menu.

**Key patterns:**
- `Page.Header` with fixed 32px height
- Nav links use `TextButton tone="neutral" textStyle="body-bold"`
- Buy mega-menu uses `useBuyMenuHover()` hook with 300ms close delay
- `IconButton` for inbox with `aria-label`
- `Avatar` with notification badge
- Buy dropdown positioned `fixed` below header at `top: 80px`

```tsx
import {
  Avatar, Icon, IconButton, TextButton, ZillowLogo, Divider, Page,
} from '@zillow/constellation';
import { IconInboxFilled, IconNotificationFilled } from '@zillow/constellation-icons';
import { Flex, Box } from '@/styled-system/jsx';
import { BuyDropdownPanel, useBuyMenuHover } from './BuyDropdownPanel';

const navLinks = ['Buy', 'Rent', 'Sell', 'Get a mortgage', 'Find an agent'];

export function SiteHeader() {
  const buyMenu = useBuyMenuHover();

  return (
    <>
      <Page.Header css={{ height: '32px', minHeight: '32px', maxHeight: '32px', py: '0', my: '0' }}>
        <Flex align="center" gap="600" css={{ display: { base: 'none', md: 'flex' } }}>
          {navLinks.map((link) => (
            link === 'Buy' ? (
              <Box
                key={link}
                onMouseEnter={buyMenu.handleEnter}
                onMouseLeave={buyMenu.handleLeave}
              >
                <TextButton tone="neutral" textStyle="body-bold">
                  {link}
                </TextButton>
              </Box>
            ) : (
              <TextButton key={link} tone="neutral" textStyle="body-bold">
                {link}
              </TextButton>
            )
          ))}
        </Flex>
        <ZillowLogo role="img" css={{ height: '24px', width: 'auto' }} />
        <Flex align="center" gap="600">
          <TextButton tone="neutral" textStyle="body-bold" css={{ display: { base: 'none', md: 'block' } }}>
            Manage rentals
          </TextButton>
          <TextButton tone="neutral" textStyle="body-bold" css={{ display: { base: 'none', md: 'block' } }}>
            Advertise
          </TextButton>
          <TextButton tone="neutral" textStyle="body-bold" css={{ display: { base: 'none', md: 'block' } }}>
            Get help
          </TextButton>
          <IconButton title="Inbox" aria-label="Inbox" tone="neutral" emphasis="bare" size="lg" shape="circle">
            <Icon><IconInboxFilled /></Icon>
          </IconButton>
          <Avatar
            size="sm"
            src="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg"
            alt="User profile"
            badge={<Avatar.Badge icon={<IconNotificationFilled />} tone="impact" />}
          />
        </Flex>
      </Page.Header>

      <Divider />

      {buyMenu.isOpen && (
        <Box
          onMouseEnter={buyMenu.handleEnter}
          onMouseLeave={buyMenu.handleLeave}
          css={{
            position: 'fixed',
            left: 0,
            right: 0,
            top: '80px',
            background: 'bg.screen.neutral',
            zIndex: 25,
          }}
          style={{
            boxShadow: '0 4px 12px rgba(0,0,0,0.12)',
          }}
        >
          <Divider />
          <BuyDropdownPanel />
        </Box>
      )}
    </>
  );
}
```

## FilterBar (`components/FilterBar.tsx`) — Main Export

The filter bar contains a search input and 5 filter button+dropdown pairs. Dropdowns are rendered inside the reference file [filter-dropdowns.md](filter-dropdowns.md).

**Key patterns:**
- Search input: fixed 560px / max 40vw with search icon overlay
- Filter buttons: `Button tone="neutral" emphasis="outlined" size="sm"` with chevron icon
- Click-outside: `useRef` on filter bar container + `mousedown` listener
- Each filter button wrapped in `Box css={{ position: 'relative' }}` for dropdown positioning

```tsx
export function FilterBar() {
  const [openFilter, setOpenFilter] = useState<string | null>(null);
  const filterBarRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (filterBarRef.current && !filterBarRef.current.contains(e.target as Node)) {
        setOpenFilter(null);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const toggleFilter = (name: string) => {
    setOpenFilter((prev) => (prev === name ? null : name));
  };

  return (
    <Flex align="center" gap="200" css={{ px: '400', py: '200' }}>
      <Box css={{ flex: '0 0 auto', width: '560px', maxWidth: '40vw', position: 'relative' }}>
        <Input defaultValue="Charlotte, NC" placeholder="Address, neighborhood, city, ZIP" size="sm" />
        <Box css={{ position: 'absolute', right: '12px', top: '50%', transform: 'translateY(-50%)', pointerEvents: 'none', color: 'icon.subtle' }}>
          <Icon size="sm"><IconSearchFilled /></Icon>
        </Box>
      </Box>

      <Flex ref={filterBarRef} align="center" gap="200">
        {/* Each filter: Box(relative) > Button + conditional Dropdown */}
        <Box css={{ position: 'relative' }}>
          <Button tone="neutral" emphasis="outlined" size="sm"
            icon={openFilter === 'for-sale' ? <IconChevronUpFilled /> : <IconChevronDownFilled />}
            iconPosition="end" onClick={() => toggleFilter('for-sale')}>
            For sale
          </Button>
          {openFilter === 'for-sale' && <ForSaleDropdown />}
        </Box>
        {/* ... Price, Beds & baths, Home type, More — same pattern */}
      </Flex>

      <Button tone="brand" emphasis="filled" size="sm">Save search</Button>
    </Flex>
  );
}
```
