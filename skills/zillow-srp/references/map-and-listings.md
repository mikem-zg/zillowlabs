# Map View + Property Listings

## MapView (`components/MapView.tsx`)

Interactive Google Maps with custom dark-red pill price markers. Includes error boundary with static map fallback.

### Full Implementation

```tsx
import { Component, type ReactNode } from 'react';
import { Text } from '@zillow/constellation';
import { css } from '@/styled-system/css';
import { Flex, Box } from '@/styled-system/jsx';
import { APIProvider, Map, AdvancedMarker } from '@vis.gl/react-google-maps';
import { properties, CHARLOTTE_CENTER } from '@/data/properties';

function PriceMarker({ price, isActive }: { price: string; isActive: boolean }) {
  return (
    <Box
      css={{
        borderRadius: '16px',
        px: '200',
        py: '50',
        fontSize: '12px',
        fontWeight: 'bold',
        whiteSpace: 'nowrap',
        cursor: 'pointer',
        transition: 'all 0.15s ease',
        lineHeight: '16px',
        color: 'white',
      }}
      style={{
        background: isActive ? '#111116' : '#6B1818',
        boxShadow: '0 2px 4px rgba(0,0,0,0.3)',
        transform: isActive ? 'scale(1.15)' : 'scale(1)',
      }}
    >
      {price}
    </Box>
  );
}

function MapMarkers({
  activeMarker,
  setActiveMarker,
}: {
  activeMarker: number | null;
  setActiveMarker: (v: number | null) => void;
}) {
  return (
    <>
      {properties.map((p, i) => (
        <AdvancedMarker
          key={i}
          position={{ lat: p.lat, lng: p.lng }}
          onClick={() => setActiveMarker(i === activeMarker ? null : i)}
        >
          <PriceMarker price={p.priceShort} isActive={i === activeMarker} />
        </AdvancedMarker>
      ))}
    </>
  );
}

class MapErrorBoundary extends Component<
  { children: ReactNode; fallback: ReactNode },
  { hasError: boolean }
> {
  constructor(props: { children: ReactNode; fallback: ReactNode }) {
    super(props);
    this.state = { hasError: false };
  }
  static getDerivedStateFromError() {
    return { hasError: true };
  }
  render() {
    if (this.state.hasError) return this.props.fallback;
    return this.props.children;
  }
}

function buildStaticMapUrl(apiKey: string) {
  const markers = properties
    .map((p) => `markers=color:0x0041D9%7Clabel:${encodeURIComponent(p.priceShort.replace('$', ''))}%7C${p.lat},${p.lng}`)
    .join('&');
  return `https://maps.googleapis.com/maps/api/staticmap?center=${CHARLOTTE_CENTER.lat},${CHARLOTTE_CENTER.lng}&zoom=10&size=800x600&scale=2&${markers}&key=${apiKey}`;
}

function StaticMapFallback({ apiKey }: { apiKey: string }) {
  return (
    <Box css={{ width: '100%', height: '100%', position: 'relative' }}>
      <img
        src={buildStaticMapUrl(apiKey)}
        alt="Map of properties in Charlotte, NC"
        style={{ width: '100%', height: '100%', objectFit: 'cover' }}
      />
    </Box>
  );
}

export function MapView({
  mapsApiKey,
  activeMarker,
  setActiveMarker,
}: {
  mapsApiKey: string | null;
  activeMarker: number | null;
  setActiveMarker: (v: number | null) => void;
}) {
  return (
    <Box
      css={{
        position: 'relative',
        height: '100%',
        display: { base: 'none', lg: 'block' },
      }}
      className={css({ flex: '1 1 50%' })}
    >
      {mapsApiKey ? (
        <MapErrorBoundary fallback={<StaticMapFallback apiKey={mapsApiKey} />}>
          <APIProvider apiKey={mapsApiKey}>
            <Map
              defaultCenter={CHARLOTTE_CENTER}
              defaultZoom={11}
              gestureHandling="greedy"
              disableDefaultUI={false}
              mapId="zillow-srp-map"
              style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}
            >
              <MapMarkers activeMarker={activeMarker} setActiveMarker={setActiveMarker} />
            </Map>
          </APIProvider>
        </MapErrorBoundary>
      ) : (
        <Flex align="center" justify="center" css={{ height: '100%', width: '100%', background: 'bg.canvas' }}>
          <Text textStyle="body" css={{ color: 'text.subtle' }}>Loading map...</Text>
        </Flex>
      )}
    </Box>
  );
}
```

### Map Design Notes

- **Marker colors**: `#6B1818` (dark red) for default, `#111116` (granite) for active — these match Zillow's actual SRP brand
- **Pill shape**: `borderRadius: 16px` with tight padding (`px: 200, py: 50`)
- **Active state**: scales 1.15x with darker background
- **Map ID**: `"zillow-srp-map"` required for AdvancedMarker support
- **Responsive**: Hidden below `lg` breakpoint (`display: { base: 'none', lg: 'block' }`)
- **Error handling**: Class-based ErrorBoundary catches Maps API errors, falls back to Static Maps API

---

## PropertyList (`components/PropertyList.tsx`)

Sort controls + responsive PropertyCard grid with save functionality.

### Full Implementation

```tsx
import { useState } from 'react';
import {
  Button, Text, Heading, PropertyCard, Divider, Menu,
} from '@zillow/constellation';
import { IconSortFilled } from '@zillow/constellation-icons';
import { css } from '@/styled-system/css';
import { Flex, Box, Grid } from '@/styled-system/jsx';
import { properties, type Property } from '@/data/properties';

type SortOption = 'homes' | 'price-high' | 'price-low' | 'newest' | 'bedrooms' | 'bathrooms' | 'sqft' | 'lot-size';

const sortLabels: Record<SortOption, string> = {
  homes: 'Homes for you',
  'price-high': 'Price (High to Low)',
  'price-low': 'Price (Low to High)',
  newest: 'Newest',
  bedrooms: 'Bedrooms',
  bathrooms: 'Bathrooms',
  sqft: 'Square Feet',
  'lot-size': 'Lot Size',
};

function parsePrice(price: string): number {
  return parseInt(price.replace(/[$,]/g, ''), 10) || 0;
}

function parseNum(val: string): number {
  return parseFloat(val.replace(/,/g, '')) || 0;
}

function sortProperties(props: Property[], sort: SortOption) {
  const sorted = [...props];
  switch (sort) {
    case 'price-high':
      sorted.sort((a, b) => parsePrice(b.price) - parsePrice(a.price));
      break;
    case 'price-low':
      sorted.sort((a, b) => parsePrice(a.price) - parsePrice(b.price));
      break;
    case 'bedrooms':
      sorted.sort((a, b) => parseNum(b.beds) - parseNum(a.beds));
      break;
    case 'bathrooms':
      sorted.sort((a, b) => parseNum(b.baths) - parseNum(a.baths));
      break;
    case 'sqft':
      sorted.sort((a, b) => parseNum(b.sqft) - parseNum(a.sqft));
      break;
    case 'lot-size':
      sorted.sort((a, b) => parseNum(b.sqft) - parseNum(a.sqft));
      break;
    case 'newest':
    case 'homes':
    default:
      break;
  }
  return sorted;
}

export function PropertyList({
  activeMarker,
  setActiveMarker,
}: {
  activeMarker: number | null;
  setActiveMarker: (v: number | null) => void;
}) {
  const [savedProperties, setSavedProperties] = useState<Set<number>>(new Set());
  const [sortBy, setSortBy] = useState<SortOption>('homes');

  const sortedProperties = sortProperties(properties, sortBy);

  const toggleSave = (index: number) => {
    setSavedProperties((prev) => {
      const next = new Set(prev);
      if (next.has(index)) {
        next.delete(index);
      } else {
        next.add(index);
      }
      return next;
    });
  };

  return (
    <Box
      css={{
        overflowY: 'auto',
        height: '100%',
        flex: { base: '1 1 100%', lg: '0 0 750px' },
        width: { base: '100%', lg: '750px' },
        maxWidth: { base: '100%', lg: '750px' },
      }}
    >
      <Flex align="center" justify="space-between" css={{ px: '400', py: '300' }}>
        <Flex direction="column" gap="50">
          <Heading level={1} textStyle="heading-sm">
            Real estate & homes for sale
          </Heading>
          <Text textStyle="body-sm" css={{ color: 'text.subtle' }}>
            {properties.length} results
          </Text>
        </Flex>
        <Menu
          placement="bottom-end"
          trigger={
            <Button tone="neutral" emphasis="outlined" size="sm"
              icon={<IconSortFilled />} iconPosition="start">
              Sort: {sortLabels[sortBy]}
            </Button>
          }
          content={
            <>
              {(Object.keys(sortLabels) as SortOption[]).map((key) => (
                <Menu.Item key={key} onClick={() => setSortBy(key)}>
                  <Menu.ItemLabel>{sortLabels[key]}</Menu.ItemLabel>
                </Menu.Item>
              ))}
            </>
          }
        />
      </Flex>

      <Divider />

      <Grid columns={{ base: 1, lg: 2 }} gap="400" css={{ px: '400', py: '400' }}>
        {sortedProperties.map((p) => {
          const origIndex = properties.indexOf(p);
          return (
            <PropertyCard
              key={origIndex}
              photoBody={<PropertyCard.Photo src={p.image} alt={p.alt} />}
              badge={
                p.badge ? (
                  <PropertyCard.Badge tone={p.badgeTone}>{p.badge}</PropertyCard.Badge>
                ) : undefined
              }
              saveButton={
                <PropertyCard.SaveButton
                  onClick={() => toggleSave(origIndex)}
                  selected={savedProperties.has(origIndex)}
                />
              }
              data={{
                dataArea1: p.price,
                dataArea2: (
                  <PropertyCard.HomeDetails
                    data={[
                      { value: p.beds, label: 'bd' },
                      { value: p.baths, label: 'ba' },
                      { value: p.sqft, label: 'sqft' },
                    ]}
                  />
                ),
                dataArea3: p.address,
                dataArea4: p.broker,
              }}
              elevated
              interactive
              onClick={() => setActiveMarker(origIndex)}
              tabIndex={0}
            />
          );
        })}
      </Grid>
    </Box>
  );
}
```

### PropertyList Design Notes

- **Only 1 Heading** on entire page: `<Heading level={1} textStyle="heading-sm">`
- **Sort menu**: Uses `Menu` component, NOT custom dropdown
- **Grid**: `columns={{ base: 1, lg: 2 }}` — single column mobile, two columns desktop
- **PropertyCard required props**: `saveButton`, `elevated`, `interactive`, `data` with all areas
- **Badge tones**: `'notify'` (orange) for "New listing", `'zillow'` for Zillow-branded badges
- **Fixed width on desktop**: `flex: 0 0 750px` prevents list from stretching

---

## Property Data Schema (`data/properties.ts`)

```ts
export interface Property {
  image: string;
  address: string;
  price: string;         // "$385,000"
  priceShort: string;    // "$385K" — used for map markers
  beds: string;
  baths: string;
  sqft: string;
  type: string;          // "House for sale"
  badge: string | null;  // "New listing", "Zillow showcase", etc.
  badgeTone: 'notify' | 'zillow';
  alt: string;           // Image alt text
  broker: string;        // "Keller Williams Realty"
  lat: number;           // Latitude for map marker
  lng: number;           // Longitude for map marker
}

export const CHARLOTTE_CENTER = { lat: 35.2271, lng: -80.8431 };

export const properties: Property[] = [
  // 54 property objects with Charlotte, NC addresses
  // Images imported from @/assets/images/property-{1-6}.png (cycled)
];
```

Each property needs:
- 6 property images imported and cycled across 54 listings
- Realistic Charlotte-area addresses with correct ZIP codes
- Lat/lng coordinates spread across the Charlotte metro area
- Mix of badge types: ~30% "New listing" (notify), ~10% "Zillow showcase" (zillow), rest null
