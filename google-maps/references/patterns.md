# Google Maps Copy-Paste Patterns

Ready-to-use patterns for `@vis.gl/react-google-maps`. Each section is self-contained.

## Table of Contents

- [Basic Map with Markers](#basic-map-with-markers)
- [Places Autocomplete (Address Search)](#places-autocomplete-address-search)
- [Geocoding (Address ↔ Coordinates)](#geocoding-address--coordinates)
- [Directions & Routes](#directions--routes)
- [Marker Clustering](#marker-clustering)
- [Zillow Price Marker (Custom Map Pin)](#zillow-price-marker-custom-map-pin)
- [Property Map (Zillow/Constellation)](#property-map-zillowconstellation)
- [Map with Search Overlay](#map-with-search-overlay)

---

## Basic Map with Markers

```tsx
import { useState } from 'react';
import { APIProvider, Map, AdvancedMarker, Pin, InfoWindow } from '@vis.gl/react-google-maps';

type Location = {
  id: string;
  name: string;
  position: { lat: number; lng: number };
  description: string;
};

const locations: Location[] = [
  { id: '1', name: 'Pike Place Market', position: { lat: 47.6097, lng: -122.3425 }, description: 'Historic farmers market' },
  { id: '2', name: 'Space Needle', position: { lat: 47.6205, lng: -122.3493 }, description: 'Iconic observation tower' },
  { id: '3', name: 'Pioneer Square', position: { lat: 47.6015, lng: -122.3343 }, description: 'Historic neighborhood' },
];

function MapWithMarkers() {
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const selectedLocation = locations.find((l) => l.id === selectedId);

  return (
    <APIProvider apiKey={import.meta.env.VITE_GOOGLE_MAPS_API_KEY}>
      <Map
        mapId="YOUR_MAP_ID"
        defaultCenter={{ lat: 47.6062, lng: -122.3321 }}
        defaultZoom={13}
        style={{ width: '100%', height: '500px' }}
        gestureHandling="greedy"
        onClick={() => setSelectedId(null)}
      >
        {locations.map((location) => (
          <AdvancedMarker
            key={location.id}
            position={location.position}
            onClick={() => setSelectedId(location.id)}
          >
            <Pin
              background={selectedId === location.id ? 'var(--color-gray-950)' : 'var(--color-blue-600)'}
              glyphColor="var(--color-white)"
              borderColor={selectedId === location.id ? 'var(--color-gray-950)' : 'var(--color-blue-600)'}
            />
          </AdvancedMarker>
        ))}

        {selectedLocation && (
          <InfoWindow
            position={selectedLocation.position}
            onCloseClick={() => setSelectedId(null)}
          >
            <div>
              <h3 style={{ margin: '0 0 4px 0', fontSize: '14px' }}>{selectedLocation.name}</h3>
              <p style={{ margin: 0, fontSize: '12px', color: '#666' }}>{selectedLocation.description}</p>
            </div>
          </InfoWindow>
        )}
      </Map>
    </APIProvider>
  );
}

export default MapWithMarkers;
```

---

## Places Autocomplete (Address Search)

### Pattern 1: PlaceAutocompleteElement (new API — recommended for new projects)

As of March 2025, `google.maps.places.Autocomplete` is not available to new Google Maps Platform customers. Use `PlaceAutocompleteElement` instead.

```tsx
import { useEffect, useRef } from 'react';
import { APIProvider, Map, useMap, useMapsLibrary, AdvancedMarker, Pin } from '@vis.gl/react-google-maps';

function PlaceAutocomplete() {
  const map = useMap();
  const placesLib = useMapsLibrary('places');
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!placesLib || !map || !containerRef.current) return;

    const autocomplete = new placesLib.PlaceAutocompleteElement({});

    autocomplete.addEventListener('gmp-placeselect', async (event: any) => {
      const place = event.place;
      await place.fetchFields({ fields: ['displayName', 'location', 'formattedAddress'] });

      if (place.location) {
        map.panTo(place.location);
        map.setZoom(15);
      }
    });

    containerRef.current.innerHTML = '';
    containerRef.current.appendChild(autocomplete);

    return () => {
      containerRef.current?.replaceChildren();
    };
  }, [placesLib, map]);

  return (
    <div
      ref={containerRef}
      style={{
        position: 'absolute',
        top: 10,
        left: '50%',
        transform: 'translateX(-50%)',
        zIndex: 10,
        width: '300px',
      }}
    />
  );
}

function PlaceAutocompleteMap() {
  return (
    <APIProvider apiKey={import.meta.env.VITE_GOOGLE_MAPS_API_KEY}>
      <div style={{ position: 'relative', width: '100%', height: '500px' }}>
        <Map
          mapId="YOUR_MAP_ID"
          defaultCenter={{ lat: 47.6062, lng: -122.3321 }}
          defaultZoom={12}
          style={{ width: '100%', height: '100%' }}
        >
          <PlaceAutocomplete />
        </Map>
      </div>
    </APIProvider>
  );
}

export default PlaceAutocompleteMap;
```

### Pattern 2: Autocomplete widget (legacy — existing projects only)

Only works for Google Maps Platform accounts created before March 2025.

```tsx
import { useEffect, useRef } from 'react';
import { APIProvider, Map, MapControl, ControlPosition, useMap, useMapsLibrary } from '@vis.gl/react-google-maps';

function LegacyAutocomplete() {
  const map = useMap();
  const placesLib = useMapsLibrary('places');
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (!placesLib || !map || !inputRef.current) return;

    const autocomplete = new placesLib.Autocomplete(inputRef.current, {
      fields: ['geometry', 'name', 'formatted_address'],
    });

    autocomplete.addListener('place_changed', () => {
      const place = autocomplete.getPlace();
      if (place.geometry?.location) {
        map.panTo(place.geometry.location);
        map.setZoom(15);
      }
    });
  }, [placesLib, map]);

  return (
    <MapControl position={ControlPosition.TOP}>
      <input
        ref={inputRef}
        type="text"
        placeholder="Search for a place..."
        style={{
          margin: '10px',
          padding: '10px 16px',
          width: '300px',
          fontSize: '14px',
          border: '1px solid #ccc',
          borderRadius: '8px',
          outline: 'none',
          boxShadow: '0 2px 6px rgba(0,0,0,0.1)',
        }}
      />
    </MapControl>
  );
}

function LegacyAutocompleteMap() {
  return (
    <APIProvider apiKey={import.meta.env.VITE_GOOGLE_MAPS_API_KEY}>
      <Map
        mapId="YOUR_MAP_ID"
        defaultCenter={{ lat: 47.6062, lng: -122.3321 }}
        defaultZoom={12}
        style={{ width: '100%', height: '500px' }}
      >
        <LegacyAutocomplete />
      </Map>
    </APIProvider>
  );
}

export default LegacyAutocompleteMap;
```

---

## Geocoding (Address ↔ Coordinates)

```tsx
import { useState, useMemo, useCallback } from 'react';
import { APIProvider, Map, AdvancedMarker, Pin, useMapsLibrary } from '@vis.gl/react-google-maps';

function useGeocode() {
  const geocodingLib = useMapsLibrary('geocoding');
  const geocoder = useMemo(() => {
    if (!geocodingLib) return null;
    return new geocodingLib.Geocoder();
  }, [geocodingLib]);

  const forward = useCallback(
    async (address: string) => {
      if (!geocoder) return null;
      const { results } = await geocoder.geocode({ address });
      if (results.length === 0) return null;
      const location = results[0].geometry.location;
      return { lat: location.lat(), lng: location.lng(), formattedAddress: results[0].formatted_address };
    },
    [geocoder]
  );

  const reverse = useCallback(
    async (lat: number, lng: number) => {
      if (!geocoder) return null;
      const { results } = await geocoder.geocode({ location: { lat, lng } });
      if (results.length === 0) return null;
      return results[0].formatted_address;
    },
    [geocoder]
  );

  return { forward, reverse, ready: !!geocoder };
}

function GeocodingDemo() {
  const { forward, reverse, ready } = useGeocode();
  const [address, setAddress] = useState('');
  const [result, setResult] = useState<string>('');
  const [marker, setMarker] = useState<{ lat: number; lng: number } | null>(null);

  const handleForwardGeocode = async () => {
    if (!ready || !address) return;
    const geo = await forward(address);
    if (geo) {
      setMarker({ lat: geo.lat, lng: geo.lng });
      setResult(`${geo.lat.toFixed(6)}, ${geo.lng.toFixed(6)}`);
    }
  };

  const handleMapClick = async (e: google.maps.MapMouseEvent) => {
    if (!ready || !e.latLng) return;
    const lat = e.latLng.lat();
    const lng = e.latLng.lng();
    setMarker({ lat, lng });
    const addr = await reverse(lat, lng);
    if (addr) {
      setResult(addr);
      setAddress(addr);
    }
  };

  return (
    <div>
      <div style={{ display: 'flex', gap: '8px', marginBottom: '8px' }}>
        <input
          value={address}
          onChange={(e) => setAddress(e.target.value)}
          placeholder="Enter an address..."
          style={{ flex: 1, padding: '8px 12px', fontSize: '14px', border: '1px solid #ccc', borderRadius: '8px' }}
          onKeyDown={(e) => e.key === 'Enter' && handleForwardGeocode()}
        />
        <button
          onClick={handleForwardGeocode}
          disabled={!ready}
          style={{ padding: '8px 16px', fontSize: '14px', borderRadius: '8px', border: 'none', background: '#0041D9', color: '#fff', cursor: 'pointer' }}
        >
          Geocode
        </button>
      </div>
      {result && <p style={{ margin: '0 0 8px', fontSize: '13px', color: '#666' }}>{result}</p>}
      <Map
        mapId="YOUR_MAP_ID"
        defaultCenter={{ lat: 47.6062, lng: -122.3321 }}
        defaultZoom={12}
        style={{ width: '100%', height: '400px' }}
        onClick={handleMapClick}
      >
        {marker && (
          <AdvancedMarker position={marker}>
            <Pin background="var(--color-blue-600)" glyphColor="var(--color-white)" borderColor="var(--color-blue-600)" />
          </AdvancedMarker>
        )}
      </Map>
    </div>
  );
}

function GeocodingPage() {
  return (
    <APIProvider apiKey={import.meta.env.VITE_GOOGLE_MAPS_API_KEY}>
      <GeocodingDemo />
    </APIProvider>
  );
}

export default GeocodingPage;
```

---

## Directions & Routes

```tsx
import { useState, useEffect, useMemo } from 'react';
import { APIProvider, Map, useMap, useMapsLibrary } from '@vis.gl/react-google-maps';

function DirectionsRenderer() {
  const map = useMap();
  const routesLib = useMapsLibrary('routes');

  const [directionsService, setDirectionsService] = useState<google.maps.DirectionsService | null>(null);
  const [directionsRenderer, setDirectionsRenderer] = useState<google.maps.DirectionsRenderer | null>(null);
  const [routes, setRoutes] = useState<google.maps.DirectionsRoute[]>([]);
  const [routeIndex, setRouteIndex] = useState(0);

  const selectedRoute = routes[routeIndex];
  const leg = selectedRoute?.legs[0];

  useEffect(() => {
    if (!routesLib || !map) return;
    const service = new routesLib.DirectionsService();
    const renderer = new routesLib.DirectionsRenderer({ map });
    setDirectionsService(service);
    setDirectionsRenderer(renderer);
    return () => renderer.setMap(null);
  }, [routesLib, map]);

  useEffect(() => {
    if (!directionsService || !directionsRenderer) return;

    directionsService
      .route({
        origin: 'Pike Place Market, Seattle, WA',
        destination: 'Space Needle, Seattle, WA',
        travelMode: google.maps.TravelMode.DRIVING,
        provideRouteAlternatives: true,
      })
      .then((response) => {
        directionsRenderer.setDirections(response);
        setRoutes(response.routes);
      });
  }, [directionsService, directionsRenderer]);

  useEffect(() => {
    if (!directionsRenderer) return;
    directionsRenderer.setRouteIndex(routeIndex);
  }, [routeIndex, directionsRenderer]);

  if (!leg) return null;

  return (
    <div
      style={{
        position: 'absolute',
        top: 10,
        right: 10,
        background: '#fff',
        padding: '16px',
        borderRadius: '12px',
        boxShadow: '0 2px 8px rgba(0,0,0,0.15)',
        zIndex: 10,
        maxWidth: '280px',
      }}
    >
      <h3 style={{ margin: '0 0 8px', fontSize: '14px' }}>{selectedRoute.summary}</h3>
      <p style={{ margin: '0 0 4px', fontSize: '13px' }}>
        {leg.start_address?.split(',')[0]} → {leg.end_address?.split(',')[0]}
      </p>
      <p style={{ margin: '0 0 8px', fontSize: '13px', color: '#666' }}>
        {leg.distance?.text} · {leg.duration?.text}
      </p>
      {routes.length > 1 && (
        <div style={{ display: 'flex', gap: '4px', flexWrap: 'wrap' }}>
          {routes.map((route, idx) => (
            <button
              key={route.summary}
              onClick={() => setRouteIndex(idx)}
              style={{
                padding: '4px 10px',
                fontSize: '12px',
                borderRadius: '6px',
                border: idx === routeIndex ? '2px solid #0041D9' : '1px solid #ccc',
                background: idx === routeIndex ? '#E8F0FE' : '#fff',
                cursor: 'pointer',
              }}
            >
              {route.summary}
            </button>
          ))}
        </div>
      )}
    </div>
  );
}

function DirectionsMap() {
  return (
    <APIProvider apiKey={import.meta.env.VITE_GOOGLE_MAPS_API_KEY}>
      <div style={{ position: 'relative', width: '100%', height: '500px' }}>
        <Map
          mapId="YOUR_MAP_ID"
          defaultCenter={{ lat: 47.6062, lng: -122.3321 }}
          defaultZoom={13}
          style={{ width: '100%', height: '100%' }}
        >
          <DirectionsRenderer />
        </Map>
      </div>
    </APIProvider>
  );
}

export default DirectionsMap;
```

---

## Marker Clustering

Requires separate install: `npm install @googlemaps/markerclusterer`

```tsx
import { useState, useEffect, useRef, useCallback } from 'react';
import { APIProvider, Map, useMap, AdvancedMarker, Pin } from '@vis.gl/react-google-maps';
import { MarkerClusterer } from '@googlemaps/markerclusterer';

type Point = {
  id: string;
  position: { lat: number; lng: number };
  label: string;
};

const points: Point[] = Array.from({ length: 100 }, (_, i) => ({
  id: String(i),
  label: `Location ${i + 1}`,
  position: {
    lat: 47.6062 + (Math.random() - 0.5) * 0.2,
    lng: -122.3321 + (Math.random() - 0.5) * 0.3,
  },
}));

function ClusteredMarkers({ data }: { data: Point[] }) {
  const map = useMap();
  const clustererRef = useRef<MarkerClusterer | null>(null);
  const [markers, setMarkers] = useState<Record<string, google.maps.marker.AdvancedMarkerElement>>({});

  useEffect(() => {
    if (!map) return;
    if (!clustererRef.current) {
      clustererRef.current = new MarkerClusterer({ map });
    }
  }, [map]);

  useEffect(() => {
    if (!clustererRef.current) return;
    clustererRef.current.clearMarkers();
    clustererRef.current.addMarkers(Object.values(markers));
  }, [markers]);

  const setMarkerRef = useCallback((marker: google.maps.marker.AdvancedMarkerElement | null, id: string) => {
    setMarkers((prev) => {
      if (marker && prev[id]) return prev;
      if (!marker && !prev[id]) return prev;
      const next = { ...prev };
      if (marker) {
        next[id] = marker;
      } else {
        delete next[id];
      }
      return next;
    });
  }, []);

  return (
    <>
      {data.map((point) => (
        <AdvancedMarker
          key={point.id}
          position={point.position}
          ref={(marker) => setMarkerRef(marker, point.id)}
        >
          <Pin background="var(--color-blue-600)" glyphColor="var(--color-white)" borderColor="var(--color-blue-600)" />
        </AdvancedMarker>
      ))}
    </>
  );
}

function ClusteredMap() {
  return (
    <APIProvider apiKey={import.meta.env.VITE_GOOGLE_MAPS_API_KEY}>
      <Map
        mapId="YOUR_MAP_ID"
        defaultCenter={{ lat: 47.6062, lng: -122.3321 }}
        defaultZoom={10}
        style={{ width: '100%', height: '500px' }}
      >
        <ClusteredMarkers data={points} />
      </Map>
    </APIProvider>
  );
}

export default ClusteredMap;
```

---

## Zillow Price Marker (Custom Map Pin)

Replaces Google's generic `Pin` component with Zillow-style price label markers. These use
Constellation CSS variable tokens for colors and spacing, matching the production Zillow map.

### Marker anatomy

```
  ┌──────────┐  ← optional badge ("NEW", "3D TOUR", "SHOWCASE")
  │  $749K   │  ← price pill (dark maroon bg, white text, rounded)
  └────▽─────┘  ← downward triangle pointer
```

### PriceMarker component

> **Why inline styles?** PriceMarker renders inside Google Maps' `AdvancedMarker` overlay,
> which sits outside PandaCSS's styled-system scope. Inline styles with CSS variable
> references are the correct approach here — they still resolve Constellation tokens at runtime.

```tsx
import { AdvancedMarker } from '@vis.gl/react-google-maps';
import { Icon, Tag } from '@zillow/constellation';
import { IconHomeFilled, IconSparksFilled } from '@zillow/constellation-icons';

type MarkerBadge = 'new' | '3d-tour' | 'showcase';

type PriceMarkerProps = {
  price: string;
  selected?: boolean;
  badge?: MarkerBadge;
  isMultiUnit?: boolean;
  unitCount?: number;
  isNewConstruction?: boolean;
  newHomesCount?: number;
  onClick?: () => void;
};

const badgeLabels: Record<MarkerBadge, string> = {
  'new': 'NEW',
  '3d-tour': '3D TOUR',
  'showcase': 'SHOWCASE',
};

function PriceMarker({
  price,
  selected = false,
  badge,
  isMultiUnit = false,
  unitCount,
  isNewConstruction = false,
  newHomesCount,
  onClick,
}: PriceMarkerProps) {
  return (
    <div
      onClick={onClick}
      style={{ cursor: 'pointer', display: 'flex', flexDirection: 'column', alignItems: 'center' }}
    >
      {badge && (
        <Tag
          size="sm"
          tone={badge === 'showcase' ? 'gray' : 'red'}
          css={{
            whiteSpace: 'nowrap',
            marginBottom: '-2px',
            zIndex: 1,
            ...(badge === 'showcase' && {
              border: '1px solid var(--color-red-600)',
              background: 'var(--color-white)',
              color: 'var(--color-red-800)',
            }),
          }}
        >
          {badgeLabels[badge]}
        </Tag>
      )}

      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '4px',
          backgroundColor: selected
            ? 'var(--color-gray-950)'
            : 'var(--color-bg-accent-red-impact)',
          color: 'var(--color-white)',
          padding: '4px 8px',
          borderRadius: '8px',
          fontFamily: 'var(--fonts-body)',
          fontSize: '12px',
          fontWeight: 700,
          lineHeight: 1,
          whiteSpace: 'nowrap',
          boxShadow: 'var(--shadow-sm)',
        }}
      >
        {isMultiUnit && (
          <Icon size="sm" style={{ color: 'var(--color-white)', flexShrink: 0 }}><IconHomeFilled /></Icon>
        )}
        {isNewConstruction && (
          <Icon size="sm" style={{ color: 'var(--color-white)', flexShrink: 0 }}><IconSparksFilled /></Icon>
        )}
        <span>
          {isMultiUnit && unitCount ? `${unitCount} units` : null}
          {isNewConstruction && newHomesCount ? `${newHomesCount} New Homes` : null}
          {!isMultiUnit && !isNewConstruction ? price : null}
        </span>
      </div>

      {/* Downward pointer triangle */}
      <div
        style={{
          width: 0,
          height: 0,
          borderLeft: '6px solid transparent',
          borderRight: '6px solid transparent',
          borderTop: selected
            ? '6px solid var(--color-gray-950)'
            : '6px solid var(--color-bg-accent-red-impact)',
        }}
      />
    </div>
  );
}
```

### Usage with AdvancedMarker

```tsx
{listings.map((listing) => (
  <AdvancedMarker
    key={listing.id}
    position={listing.position}
    onClick={() => setSelectedId(listing.id)}
  >
    <PriceMarker
      price={listing.price}
      selected={selectedId === listing.id}
      badge={listing.isNew ? 'new' : undefined}
    />
  </AdvancedMarker>
))}
```

### Token reference

| Element | Token / CSS Variable | Resolves to |
|---------|---------------------|-------------|
| Pill background (default) | `var(--color-bg-accent-red-impact)` | `red-800` (dark maroon) |
| Pill background (selected) | `var(--color-gray-950)` | Near-black |
| Pill text | `var(--color-white)` | `#FFFFFF` |
| Badge "NEW" / "3D TOUR" bg | `Tag tone="red"` | Constellation red tone |
| Badge "SHOWCASE" | `Tag tone="gray"` + red border | Outlined style |
| Font family | `var(--fonts-body)` | Constellation body font |
| Pill border-radius | `8px` | Matches `node.sm` |
| Pill shadow | `var(--shadow-sm)` | Constellation small shadow |
| Pill padding | `4px 8px` | Compact for map labels |
| Pointer triangle | Same color as pill bg | Visual continuity |

### When to use PriceMarker vs Pin

| Context | Use | Why |
|---------|-----|-----|
| Property listings on a map | `PriceMarker` | Shows price at a glance, matches Zillow UX |
| Generic location markers | `Pin` with Constellation token colors | Standard Google Maps affordance |
| Points of interest, search results | `Pin` | No price data to display |
| Marker clustering (zoomed out) | `Pin` inside clusterer | Price labels overlap at density |

---

## Property Map (Zillow/Constellation)

Uses the `PriceMarker` component from the [Zillow Price Marker](#zillow-price-marker-custom-map-pin) section above.

```tsx
import { useState } from 'react';
import { APIProvider, Map, AdvancedMarker, InfoWindow } from '@vis.gl/react-google-maps';
import { PropertyCard, Tag, Text } from '@zillow/constellation';
import { IconHomeFilled, IconSparksFilled } from '@zillow/constellation-icons';
import { Box, Flex } from '@/styled-system/jsx';

type Listing = {
  id: string;
  price: string;
  shortPrice: string;
  address: string;
  city: string;
  image: string;
  position: { lat: number; lng: number };
  details: Array<{ value: string | number; label: string }>;
  isNew?: boolean;
};

const listings: Listing[] = [
  {
    id: '1',
    price: '$1,250,000',
    shortPrice: '1.25M',
    address: '123 Waterfront Dr',
    city: 'Seattle, WA 98101',
    image: '/images/home1.jpg',
    position: { lat: 47.6097, lng: -122.3425 },
    details: [{ value: 4, label: 'bd' }, { value: 3, label: 'ba' }, { value: '2,400', label: 'sqft' }],
    isNew: true,
  },
  {
    id: '2',
    price: '$875,000',
    shortPrice: '875K',
    address: '456 Capitol Hill Ave',
    city: 'Seattle, WA 98102',
    image: '/images/home2.jpg',
    position: { lat: 47.6205, lng: -122.3210 },
    details: [{ value: 3, label: 'bd' }, { value: 2, label: 'ba' }, { value: '1,800', label: 'sqft' }],
  },
  {
    id: '3',
    price: '$650,000',
    shortPrice: '650K',
    address: '789 Ballard St',
    city: 'Seattle, WA 98107',
    image: '/images/home3.jpg',
    position: { lat: 47.6688, lng: -122.3840 },
    details: [{ value: 2, label: 'bd' }, { value: 1, label: 'ba' }, { value: '1,200', label: 'sqft' }],
  },
];

function PriceMarker({ price, selected, badge, onClick }: {
  price: string;
  selected: boolean;
  badge?: 'new' | '3d-tour' | 'showcase';
  onClick: () => void;
}) {
  const badgeLabels = { 'new': 'NEW', '3d-tour': '3D TOUR', 'showcase': 'SHOWCASE' };

  return (
    <div
      onClick={onClick}
      style={{ cursor: 'pointer', display: 'flex', flexDirection: 'column', alignItems: 'center' }}
    >
      {badge && (
        <Tag size="sm" tone="red" css={{ whiteSpace: 'nowrap', marginBottom: '-2px', zIndex: 1 }}>
          {badgeLabels[badge]}
        </Tag>
      )}
      <div
        style={{
          backgroundColor: selected
            ? 'var(--color-gray-950)'
            : 'var(--color-bg-accent-red-impact)',
          color: 'var(--color-white)',
          padding: '4px 8px',
          borderRadius: '8px',
          fontFamily: 'var(--fonts-body)',
          fontSize: '12px',
          fontWeight: 700,
          lineHeight: 1,
          whiteSpace: 'nowrap',
          boxShadow: 'var(--shadow-sm)',
        }}
      >
        {price}
      </div>
      <div
        style={{
          width: 0,
          height: 0,
          borderLeft: '6px solid transparent',
          borderRight: '6px solid transparent',
          borderTop: selected
            ? '6px solid var(--color-gray-950)'
            : '6px solid var(--color-bg-accent-red-impact)',
        }}
      />
    </div>
  );
}

function PropertyMap() {
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const selectedListing = listings.find((l) => l.id === selectedId);

  return (
    <APIProvider apiKey={import.meta.env.VITE_GOOGLE_MAPS_API_KEY}>
      <Flex css={{ height: '100vh' }}>
        <Box css={{ width: '420px', overflowY: 'auto', p: '400', bg: 'bg.screen.neutral' }}>
          <Flex direction="column" gap="400">
            <Text textStyle="body-lg-bold">
              {listings.length} results
            </Text>
            {listings.map((listing) => (
              <PropertyCard
                key={listing.id}
                saveButton={<PropertyCard.SaveButton />}
                photoBody={<PropertyCard.Photo src={listing.image} alt={`Home at ${listing.address}`} />}
                data={{
                  dataArea1: listing.price,
                  dataArea2: <PropertyCard.HomeDetails data={listing.details} />,
                  dataArea3: listing.address,
                  dataArea4: listing.city,
                }}
                elevated
                interactive
                onClick={() => setSelectedId(listing.id)}
              />
            ))}
          </Flex>
        </Box>

        <Box css={{ flex: 1 }}>
          <Map
            mapId="YOUR_MAP_ID"
            defaultCenter={{ lat: 47.6300, lng: -122.3500 }}
            defaultZoom={12}
            style={{ width: '100%', height: '100%' }}
            onClick={() => setSelectedId(null)}
          >
            {listings.map((listing) => (
              <AdvancedMarker
                key={listing.id}
                position={listing.position}
                onClick={() => setSelectedId(listing.id)}
              >
                <PriceMarker
                  price={listing.shortPrice}
                  selected={selectedId === listing.id}
                  badge={listing.isNew ? 'new' : undefined}
                  onClick={() => setSelectedId(listing.id)}
                />
              </AdvancedMarker>
            ))}

            {selectedListing && (
              <InfoWindow
                position={selectedListing.position}
                onCloseClick={() => setSelectedId(null)}
              >
                <Flex direction="column" gap="100">
                  <Text textStyle="body-lg-bold">{selectedListing.price}</Text>
                  <Text textStyle="body-bold">{selectedListing.address}</Text>
                  <Text textStyle="body" css={{ color: 'text.subtle' }}>{selectedListing.city}</Text>
                </Flex>
              </InfoWindow>
            )}
          </Map>
        </Box>
      </Flex>
    </APIProvider>
  );
}

export default PropertyMap;
```

---

## Map with Search Overlay

```tsx
import { useEffect, useRef } from 'react';
import { APIProvider, Map, MapControl, ControlPosition, useMap, useMapsLibrary } from '@vis.gl/react-google-maps';

function SearchOverlay() {
  const map = useMap();
  const placesLib = useMapsLibrary('places');
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!placesLib || !map || !containerRef.current) return;

    const autocomplete = new placesLib.PlaceAutocompleteElement({});

    autocomplete.addEventListener('gmp-placeselect', async (event: any) => {
      const place = event.place;
      await place.fetchFields({ fields: ['displayName', 'location', 'formattedAddress'] });

      if (place.location) {
        map.panTo(place.location);
        map.setZoom(15);
      }
    });

    containerRef.current.innerHTML = '';
    containerRef.current.appendChild(autocomplete);

    return () => {
      containerRef.current?.replaceChildren();
    };
  }, [placesLib, map]);

  return (
    <MapControl position={ControlPosition.TOP}>
      <div
        ref={containerRef}
        style={{
          margin: '10px',
          width: '320px',
          background: '#fff',
          borderRadius: '8px',
          boxShadow: '0 2px 6px rgba(0,0,0,0.15)',
          overflow: 'hidden',
        }}
      />
    </MapControl>
  );
}

function MapWithSearch() {
  return (
    <APIProvider apiKey={import.meta.env.VITE_GOOGLE_MAPS_API_KEY}>
      <Map
        mapId="YOUR_MAP_ID"
        defaultCenter={{ lat: 47.6062, lng: -122.3321 }}
        defaultZoom={12}
        style={{ width: '100%', height: '500px' }}
      >
        <SearchOverlay />
      </Map>
    </APIProvider>
  );
}

export default MapWithSearch;
```
