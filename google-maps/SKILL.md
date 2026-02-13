---
name: google-maps
description: Provides Google Maps integration for React projects using @vis.gl/react-google-maps. Use when adding maps, markers, directions, geocoding, Places Autocomplete, or property maps. Covers setup, API key management, component patterns, and Constellation design system integration.
---

# Google Maps for React

Add interactive Google Maps to React applications using `@vis.gl/react-google-maps` (v1.0+), the official Google-endorsed React wrapper for the Maps JavaScript API.

**API Reference**: [references/api-reference.md](references/api-reference.md)
**Copy-Paste Patterns**: [references/patterns.md](references/patterns.md)
**API Key Setup**: [references/api-key-setup.md](references/api-key-setup.md)

## Prerequisites

1. **Google Maps API key** — stored as a Replit secret named `GOOGLE_MAPS_API_KEY`
2. **React 18+** with TypeScript
3. **Map ID** (required for AdvancedMarkers) — create at Google Cloud Console → Maps → Map Management

See [references/api-key-setup.md](references/api-key-setup.md) for step-by-step key creation and security setup.

## Installation

```bash
npm install @vis.gl/react-google-maps
```

For marker clustering, also install:
```bash
npm install @googlemaps/markerclusterer
```

## Quick Start

### 1. Wrap your app (or page) with APIProvider

```tsx
import { APIProvider } from '@vis.gl/react-google-maps';

function App() {
  return (
    <APIProvider apiKey={import.meta.env.VITE_GOOGLE_MAPS_API_KEY}>
      <MyMapPage />
    </APIProvider>
  );
}
```

**Replit setup:** Add `GOOGLE_MAPS_API_KEY` as a secret, then expose it to the client via Vite:

```ts
// vite.config.ts — define block
define: {
  'import.meta.env.VITE_GOOGLE_MAPS_API_KEY': JSON.stringify(process.env.GOOGLE_MAPS_API_KEY),
}
```

Or pass it from the server via an API endpoint (more secure for production).

### 2. Render a map with a marker

```tsx
import { Map, AdvancedMarker, Pin } from '@vis.gl/react-google-maps';

function MyMapPage() {
  const center = { lat: 47.6062, lng: -122.3321 }; // Seattle

  return (
    <Map
      mapId="YOUR_MAP_ID"
      defaultCenter={center}
      defaultZoom={12}
      style={{ width: '100%', height: '400px' }}
      gestureHandling="greedy"
    >
      <AdvancedMarker position={center}>
        <Pin background="#0041D9" glyphColor="#FFF" borderColor="#0041D9" />
      </AdvancedMarker>
    </Map>
  );
}
```

## Component & Hook Decision Table

| Need | Component/Hook | Notes |
|------|---------------|-------|
| Load the Maps API | `<APIProvider apiKey={...}>` | Wrap once at app/page level |
| Render a map | `<Map>` | Set `mapId` for AdvancedMarkers |
| Place a marker | `<AdvancedMarker>` + `<Pin>` | Legacy `Marker` is deprecated |
| Show a popup | `<InfoWindow>` | Attach to marker or position |
| Add UI controls on map | `<MapControl position={...}>` | Search bars, legends, filters |
| Access map instance | `useMap()` | For imperative operations (pan, zoom) |
| Load extra libraries | `useMapsLibrary('places')` | Places, Routes, Geocoding, etc. |
| Get marker ref | `useAdvancedMarkerRef()` | For anchoring InfoWindows to markers |

### Which library to load?

| Feature | Library Name | Key Classes |
|---------|-------------|-------------|
| Places search / autocomplete | `'places'` | `Autocomplete`, `PlacesService` |
| Directions / routes | `'routes'` | `DirectionsService`, `DirectionsRenderer` |
| Address ↔ coordinates | `'geocoding'` | `Geocoder` |
| Distance calculations | `'geometry'` | `spherical.computeDistanceBetween` |
| Heatmaps | `'visualization'` | `HeatmapLayer` |
| Drawing tools | `'drawing'` | `DrawingManager` |

```tsx
const placesLib = useMapsLibrary('places');
const geocodingLib = useMapsLibrary('geocoding');
```

## Constellation Integration

When using Google Maps in a Zillow/Constellation project:

### Map inside Page layout
```tsx
<Page.Root>
  <Page.Header>
    <ZillowLogo role="img" css={{ height: '24px', width: 'auto' }} />
  </Page.Header>
  <Divider />
  <Page.Content css={{ px: '0', py: '0' }}>
    <APIProvider apiKey={apiKey}>
      <Map
        mapId="YOUR_MAP_ID"
        defaultCenter={center}
        defaultZoom={12}
        style={{ width: '100%', height: 'calc(100vh - 64px)' }}
      />
    </APIProvider>
  </Page.Content>
</Page.Root>
```

### InfoWindow with Constellation components
```tsx
<InfoWindow position={position} onCloseClick={() => setOpen(false)}>
  <Flex direction="column" gap="100">
    <Text textStyle="body-bold">123 Main Street</Text>
    <Text textStyle="body" css={{ color: 'text.subtle' }}>Seattle, WA 98101</Text>
    <Text textStyle="body-lg-bold">$1,250,000</Text>
  </Flex>
</InfoWindow>
```

### Property listings + map (split view)

Uses `PriceMarker` from [references/patterns.md](references/patterns.md#zillow-price-marker-custom-map-pin).

```tsx
<Flex css={{ height: '100vh' }}>
  <Box css={{ width: '400px', overflowY: 'auto', p: '400' }}>
    <Flex direction="column" gap="400">
      {listings.map(listing => (
        <PropertyCard
          key={listing.id}
          saveButton={<PropertyCard.SaveButton />}
          photoBody={<PropertyCard.Photo src={listing.image} alt={listing.address} />}
          data={{
            dataArea1: listing.price,
            dataArea2: <PropertyCard.HomeDetails data={listing.details} />,
            dataArea3: listing.address,
          }}
          elevated
          interactive
          onClick={() => handleListingClick(listing)}
        />
      ))}
    </Flex>
  </Box>
  <Box css={{ flex: 1 }}>
    <APIProvider apiKey={apiKey}>
      <Map mapId="YOUR_MAP_ID" defaultCenter={center} defaultZoom={12}
        style={{ width: '100%', height: '100%' }}>
        {listings.map(listing => (
          <AdvancedMarker
            key={listing.id}
            position={listing.position}
            onClick={() => handleMarkerClick(listing)}
          >
            <PriceMarker
              price={listing.shortPrice}
              selected={selectedId === listing.id}
              badge={listing.isNew ? 'new' : undefined}
              onClick={() => handleMarkerClick(listing)}
            />
          </AdvancedMarker>
        ))}
      </Map>
    </APIProvider>
  </Box>
</Flex>
```

### Property price markers (recommended for listings)

For property maps, use custom `PriceMarker` components instead of Google's `Pin`. These render
Zillow-style dark maroon pills with abbreviated prices ("749K", "1.25M"), optional badges
("NEW", "3D TOUR", "SHOWCASE"), and a downward pointer triangle.

```tsx
<AdvancedMarker position={listing.position} onClick={() => select(listing.id)}>
  <PriceMarker
    price="875K"
    selected={selectedId === listing.id}
    badge={listing.isNew ? 'new' : undefined}
    onClick={() => select(listing.id)}
  />
</AdvancedMarker>
```

Key tokens used:
- Background: `var(--color-bg-accent-red-impact)` → `red-800` (dark maroon)
- Selected: `var(--color-gray-950)` (near-black)
- Text: `var(--color-white)`
- Badges: `Tag` component with `tone="red"`

See [references/patterns.md](references/patterns.md#zillow-price-marker-custom-map-pin) for the full `PriceMarker` component.

### Pin colors for generic markers

For non-property markers, use Google's `Pin` component with Constellation CSS variable tokens:

| Context | Pin `background` | Pin `glyphColor` |
|---------|-----------------|-----------------|
| Default marker | `var(--color-blue-600)` | `var(--color-white)` |
| Selected/active | `var(--color-gray-950)` | `var(--color-white)` |
| Saved/favorited | `var(--color-red-600)` | `var(--color-white)` |
| New listing | `var(--color-orange-600)` | `var(--color-white)` |

Always reference CSS variables instead of hardcoded hex values so colors adapt to theme changes.

## Common Gotchas

| Problem | Cause | Fix |
|---------|-------|-----|
| Markers don't appear | Missing `mapId` on `<Map>` | Add `mapId` — required for AdvancedMarkers |
| Map shows grey box | API key invalid or billing not enabled | Check Cloud Console for errors |
| "Autocomplete is not available" | New customers after March 2025 | Use `PlaceAutocompleteElement` or `AutocompleteService` instead |
| Map not responsive | Missing `style` on `<Map>` | Set explicit `width` and `height` (% or px) |
| `useMap()` returns null | Component not inside `<APIProvider>` | Wrap with `<APIProvider>` |
| Multiple API loads warning | Multiple `<APIProvider>` instances | Use one `<APIProvider>` at the app level |
| InfoWindow renders at wrong spot | Using `position` instead of `anchor` | Use `anchor` prop with marker ref |
| Hooks return null initially | Libraries load asynchronously | Always null-check before using |

## API Key Security Checklist

1. Store as Replit secret (`GOOGLE_MAPS_API_KEY`), never hardcode
2. Set HTTP referrer restriction in Cloud Console
3. Restrict to Maps JavaScript API only
4. Set billing alerts and quotas
5. Use separate keys for dev vs production

See [references/api-key-setup.md](references/api-key-setup.md) for detailed instructions.
