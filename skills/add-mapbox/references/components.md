# Map Components

Generic React components for Mapbox GL JS integration: MapContext provider, MapContainer, TerritoryMap (small embedded map), and MapSearchBar.

## Table of Contents

- [MapContext Provider](#mapcontext-provider)
- [MapContainer](#mapcontainer)
- [TerritoryMap](#territorymap)
- [MapSearchBar](#mapsearchbar)

## MapContext Provider

Wraps the `useMapbox` hook in a React context so any descendant can access map state.

```tsx
import { createContext, useContext, ReactNode } from "react";
import { useMapbox } from "@/hooks/use-mapbox";

interface MapContextType {
  map: mapboxgl.Map | null;
  styleLoaded: boolean;
  selectedFeatureId: string | null;
  isLoading: boolean;
  mapError: string | null;
  initializeMap: (container: HTMLDivElement) => void;
  disposeMap: () => void;
  selectFeature: (id: string | null, layer: string, prop?: string) => void;
  setupClickHandler: (layer: string, prop: string, cb: (id: string, props: Record<string, unknown>, lngLat: { lng: number; lat: number }) => void) => void;
  setupHoverPopup: (layer: string, prop: string, fmt: (props: Record<string, unknown>) => string) => void;
  fitToBounds: (bounds: { minLng: number; minLat: number; maxLng: number; maxLat: number }, padding?: number) => void;
  searchLocation: (query: string) => Promise<{ success: boolean; message?: string }>;
}

const MapContext = createContext<MapContextType | undefined>(undefined);

export function MapProvider({ children }: { children: ReactNode }) {
  const mapState = useMapbox();
  return (
    <MapContext.Provider value={mapState}>
      {children}
    </MapContext.Provider>
  );
}

export function useMapContext() {
  const context = useContext(MapContext);
  if (!context) {
    throw new Error("useMapContext must be used within MapProvider");
  }
  return context;
}
```

### Usage

```tsx
function App() {
  return (
    <MapProvider>
      <MapContainer />
      <Sidebar />
    </MapProvider>
  );
}
```

## MapContainer

Renders the map element and handles initialization/disposal lifecycle.

```tsx
import { useEffect, useRef } from "react";
import { useMapContext } from "@/contexts/MapContext";

interface MapContainerProps {
  isVisible?: boolean;
  className?: string;
}

export default function MapContainer({ isVisible = true, className }: MapContainerProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const { initializeMap, disposeMap, mapError, isLoading, map } = useMapContext();

  useEffect(() => {
    if (!containerRef.current || !isVisible) return;
    initializeMap(containerRef.current);
  }, [isVisible, initializeMap]);

  useEffect(() => {
    if (map && isVisible) {
      try { map.resize?.(); } catch { /* map disposed */ }
    }
  }, [map, isVisible]);

  useEffect(() => {
    return () => { disposeMap(); };
  }, [disposeMap]);

  return (
    <div className={`relative w-full h-full ${className || ''}`}>
      {mapError && (
        <div className="absolute inset-0 flex items-center justify-center bg-gray-50 z-10">
          <div className="max-w-md p-6 bg-white rounded-lg shadow-lg border">
            <h3 className="font-semibold mb-2">Map Not Available</h3>
            <p className="text-sm text-gray-600">{mapError}</p>
          </div>
        </div>
      )}
      {isLoading && (
        <div className="absolute inset-0 flex items-center justify-center bg-gray-50 z-10">
          <div className="animate-spin h-8 w-8 border-4 border-blue-500 border-t-transparent rounded-full" />
        </div>
      )}
      <div
        ref={containerRef}
        className="absolute inset-0"
        data-testid="map-container"
      />
    </div>
  );
}
```

## TerritoryMap

A small, self-contained map for embedding in cards or panels. Highlights a set of features within a bounding box.

```tsx
import { useEffect, useRef, useState } from "react";

declare global {
  interface Window { mapboxgl: typeof import('mapbox-gl'); }
}

interface TerritoryMapProps {
  featureIds: string[];
  boundingBox: {
    minLat: number;
    maxLat: number;
    minLng: number;
    maxLng: number;
  };
  sourceLayer: string;
  propertyName?: string;
  highlightColor?: string;
  height?: string;
}

export function TerritoryMap({
  featureIds,
  boundingBox,
  sourceLayer,
  propertyName = 'id',
  highlightColor = '#3b82f6',
  height = '12rem',
}: TerritoryMapProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const mapRef = useRef<mapboxgl.Map | null>(null);
  const styleLoadedRef = useRef(false);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!containerRef.current || mapRef.current) return;

    const token = import.meta.env.VITE_MAPBOX_ACCESS_TOKEN;
    if (!token) {
      setError("Map token not configured");
      setIsLoading(false);
      return;
    }

    const initMap = () => {
      try {
        window.mapboxgl.accessToken = token;
        const pad = 0.05;
        const bounds: [[number, number], [number, number]] = [
          [boundingBox.minLng - pad, boundingBox.minLat - pad],
          [boundingBox.maxLng + pad, boundingBox.maxLat + pad],
        ];

        const map = new window.mapboxgl.Map({
          container: containerRef.current!,
          style: 'mapbox://styles/mapbox/light-v11',
          bounds,
          fitBoundsOptions: { padding: 20 },
          interactive: true,
          attributionControl: false,
        });
        mapRef.current = map;

        map.on('style.load', () => {
          styleLoadedRef.current = true;

          if (map.getSource(sourceLayer)) {
            map.addLayer({
              id: 'highlight-fill',
              type: 'fill',
              source: sourceLayer,
              'source-layer': sourceLayer,
              filter: ['in', ['get', propertyName], ['literal', featureIds]],
              paint: {
                'fill-color': highlightColor,
                'fill-opacity': 0.4,
              },
            });
            map.addLayer({
              id: 'highlight-border',
              type: 'line',
              source: sourceLayer,
              'source-layer': sourceLayer,
              filter: ['in', ['get', propertyName], ['literal', featureIds]],
              paint: {
                'line-color': highlightColor,
                'line-width': 2,
              },
            });
          } else {
            map.addSource('territory-source', {
              type: 'vector',
              url: `mapbox://${sourceLayer}`,
            });
            map.addLayer({
              id: 'highlight-fill',
              type: 'fill',
              source: 'territory-source',
              'source-layer': sourceLayer,
              filter: ['in', ['get', propertyName], ['literal', featureIds]],
              paint: {
                'fill-color': highlightColor,
                'fill-opacity': 0.4,
              },
            });
            map.addLayer({
              id: 'highlight-border',
              type: 'line',
              source: 'territory-source',
              'source-layer': sourceLayer,
              filter: ['in', ['get', propertyName], ['literal', featureIds]],
              paint: {
                'line-color': highlightColor,
                'line-width': 2,
              },
            });
          }
          setIsLoading(false);
        });

        map.on('error', (e: mapboxgl.ErrorEvent) => {
          console.error('TerritoryMap error:', e.error);
          setError("Failed to load map");
          setIsLoading(false);
        });
      } catch (err) {
        console.error('TerritoryMap init failed:', err);
        setError("Failed to initialize map");
        setIsLoading(false);
      }
    };

    if (window.mapboxgl) {
      initMap();
    } else {
      const existing = document.querySelector('script[src*="mapbox-gl.js"]');
      if (existing) {
        const check = setInterval(() => {
          if (window.mapboxgl) { clearInterval(check); initMap(); }
        }, 100);
        return () => clearInterval(check);
      }
      const script = document.createElement('script');
      script.src = 'https://api.mapbox.com/mapbox-gl-js/v2.15.0/mapbox-gl.js';
      script.onload = initMap;
      script.onerror = () => { setError("Failed to load map library"); setIsLoading(false); };
      document.head.appendChild(script);
    }

    return () => {
      if (mapRef.current) {
        mapRef.current.remove();
        mapRef.current = null;
      }
    };
  }, []);

  useEffect(() => {
    const map = mapRef.current;
    if (!map || !styleLoadedRef.current) return;

    const filter: mapboxgl.FilterSpecification = [
      'in', ['get', propertyName], ['literal', featureIds],
    ];
    if (map.getLayer('highlight-fill')) map.setFilter('highlight-fill', filter);
    if (map.getLayer('highlight-border')) map.setFilter('highlight-border', filter);
  }, [featureIds, propertyName]);

  useEffect(() => {
    const map = mapRef.current;
    if (!map) return;

    const updateBounds = () => {
      const p = 0.05;
      map.fitBounds(
        [[boundingBox.minLng - p, boundingBox.minLat - p],
         [boundingBox.maxLng + p, boundingBox.maxLat + p]],
        { padding: 20, duration: 0 },
      );
    };

    if (map.isStyleLoaded()) updateBounds();
    else map.once('style.load', updateBounds);
  }, [boundingBox]);

  if (error) {
    return (
      <div style={{ height }} className="bg-gray-100 rounded-lg flex items-center justify-center">
        <p className="text-sm text-gray-500">{error}</p>
      </div>
    );
  }

  return (
    <div className="relative rounded-lg overflow-hidden border" style={{ height }} data-testid="territory-map">
      {isLoading && (
        <div className="absolute inset-0 bg-gray-100 flex items-center justify-center z-10">
          <div className="animate-spin h-6 w-6 border-2 border-blue-500 border-t-transparent rounded-full" />
        </div>
      )}
      <div ref={containerRef} className="h-full w-full" />
    </div>
  );
}
```

### Usage

```tsx
<TerritoryMap
  featureIds={['90210', '90211', '90212']}
  boundingBox={{ minLat: 34.05, maxLat: 34.10, minLng: -118.45, maxLng: -118.38 }}
  sourceLayer="zip_code_tabulation_areas"
  propertyName="name"
  highlightColor="#10b981"
  height="200px"
/>
```

## MapSearchBar

A search input that geocodes a query and flies the map to the result.

```tsx
import { useState, FormEvent } from "react";
import { useMapContext } from "@/contexts/MapContext";

export default function MapSearchBar() {
  const [query, setQuery] = useState("");
  const [isSearching, setIsSearching] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const { searchLocation, styleLoaded } = useMapContext();

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    if (!query.trim() || !styleLoaded) return;

    setIsSearching(true);
    setError(null);
    const result = await searchLocation(query);
    setIsSearching(false);

    if (!result.success) {
      setError(result.message || "Location not found");
    }
  };

  return (
    <div className="absolute top-4 left-4 z-10 w-full max-w-sm">
      <form onSubmit={handleSubmit} className="flex gap-2">
        <input
          type="text"
          placeholder="Search location..."
          value={query}
          onChange={(e) => { setQuery(e.target.value); setError(null); }}
          disabled={isSearching}
          className="flex-1 px-3 py-2 text-sm border rounded-md shadow-sm bg-white"
          data-testid="input-map-search"
        />
        <button
          type="submit"
          disabled={isSearching || !query.trim()}
          className="px-4 py-2 text-sm bg-blue-600 text-white rounded-md shadow-sm disabled:opacity-50"
          data-testid="button-map-search"
        >
          {isSearching ? "..." : "Go"}
        </button>
      </form>
      {error && <p className="mt-1 text-xs text-red-500">{error}</p>}
    </div>
  );
}
```

### Usage

```tsx
<MapProvider>
  <div className="relative h-screen">
    <MapSearchBar />
    <MapContainer />
  </div>
</MapProvider>
```
