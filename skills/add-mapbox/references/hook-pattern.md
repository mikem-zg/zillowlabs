# useMapbox Hook Pattern

A generic React hook for managing Mapbox GL JS map instances with dynamic script loading, layer management, click/hover interactions, and cleanup.

## Complete Hook

```tsx
import { useState, useCallback, useRef } from "react";

declare global {
  interface Window { mapboxgl: any; }
}

type MapMouseEvent = {
  point: { x: number; y: number };
  lngLat: { lng: number; lat: number };
  originalEvent: MouseEvent;
};

interface UseMapboxOptions {
  style?: string;
  center?: [number, number];
  zoom?: number;
  minZoom?: number;
}

const DEFAULT_OPTIONS: Required<UseMapboxOptions> = {
  style: 'mapbox://styles/mapbox/light-v11',
  center: [-98.58, 39.83],
  zoom: 4,
  minZoom: 2,
};

export function useMapbox(options: UseMapboxOptions = {}) {
  const config = { ...DEFAULT_OPTIONS, ...options };

  const [map, setMap] = useState<any>(null);
  const mapRef = useRef<any>(null);
  const isInitializedRef = useRef(false);
  const [selectedFeatureId, setSelectedFeatureId] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [isInitialized, setIsInitialized] = useState(false);
  const [mapError, setMapError] = useState<string | null>(null);
  const [styleLoaded, setStyleLoaded] = useState(false);
  const hoverPopupRef = useRef<any>(null);

  const disposeMap = useCallback(() => {
    const currentMap = mapRef.current;
    if (currentMap) {
      try { currentMap.remove(); } catch (e) { /* already removed */ }
      mapRef.current = null;
    }
    if (hoverPopupRef.current) {
      hoverPopupRef.current.remove();
      hoverPopupRef.current = null;
    }
    setMap(null);
    isInitializedRef.current = false;
    setIsInitialized(false);
    setStyleLoaded(false);
    setMapError(null);
    setSelectedFeatureId(null);
    setIsLoading(false);
  }, []);

  const initializeMap = useCallback((container: HTMLDivElement) => {
    if (isInitializedRef.current) return;
    isInitializedRef.current = true;
    setIsLoading(true);
    setIsInitialized(true);

    const createMap = () => {
      try {
        window.mapboxgl.accessToken = import.meta.env.VITE_MAPBOX_ACCESS_TOKEN || '';

        const mapInstance = new window.mapboxgl.Map({
          container,
          style: config.style,
          center: config.center,
          zoom: config.zoom,
          minZoom: config.minZoom,
          dragRotate: false,
          touchZoomRotate: true,
        });

        mapInstance.on('load', () => setIsLoading(false));
        mapInstance.on('style.load', () => setStyleLoaded(true));
        mapInstance.on('error', (e: Error) => {
          console.error('Mapbox error:', e);
          setMapError('Map failed to load. Ensure your browser supports WebGL.');
          setIsLoading(false);
        });

        mapRef.current = mapInstance;
        setMap(mapInstance);
      } catch (error) {
        console.error('Failed to initialize map:', error);
        setMapError('Failed to initialize map. Ensure your browser supports WebGL.');
        setIsLoading(false);
      }
    };

    if (window.mapboxgl) {
      createMap();
      return;
    }
    const existing = document.querySelector('script[src*="mapbox-gl.js"]');
    if (existing) {
      const check = setInterval(() => {
        if (window.mapboxgl) { clearInterval(check); createMap(); }
      }, 100);
      return;
    }
    const script = document.createElement('script');
    script.src = 'https://api.mapbox.com/mapbox-gl-js/v2.15.0/mapbox-gl.js';
    script.onload = createMap;
    document.head.appendChild(script);
  }, [config.style, config.center, config.zoom, config.minZoom]);

  const selectFeature = useCallback((featureId: string | null, layerName: string, propertyName = 'id') => {
    setSelectedFeatureId(featureId);
    if (!mapRef.current) return;
    const m = mapRef.current;

    if (m.getLayer(layerName)) {
      if (featureId) {
        m.setFilter(layerName, ['==', ['get', propertyName], featureId]);
      } else {
        m.setFilter(layerName, ['==', ['get', propertyName], '']);
      }
    }
  }, []);

  const setupClickHandler = useCallback((
    sourceLayer: string,
    propertyName: string,
    onFeatureClick: (featureId: string, properties: Record<string, any>, lngLat: { lng: number; lat: number }) => void,
  ) => {
    if (!mapRef.current) return;
    const m = mapRef.current;

    m.on('click', sourceLayer, (e: MapMouseEvent & { features?: any[] }) => {
      if (!e.features?.length) return;
      const feature = e.features[0];
      const id = feature.properties[propertyName];
      if (id) onFeatureClick(String(id), feature.properties, e.lngLat);
    });

    m.on('mouseenter', sourceLayer, () => { m.getCanvas().style.cursor = 'pointer'; });
    m.on('mouseleave', sourceLayer, () => { m.getCanvas().style.cursor = ''; });
  }, []);

  const setupHoverPopup = useCallback((
    sourceLayer: string,
    propertyName: string,
    formatContent: (properties: Record<string, any>) => string,
  ) => {
    if (!mapRef.current) return;
    const m = mapRef.current;

    m.on('mousemove', sourceLayer, (e: MapMouseEvent & { features?: any[] }) => {
      if (!e.features?.length) return;
      const props = e.features[0].properties;

      if (hoverPopupRef.current) hoverPopupRef.current.remove();

      hoverPopupRef.current = new window.mapboxgl.Popup({
        closeButton: false,
        closeOnClick: false,
        offset: 10,
      })
        .setLngLat(e.lngLat)
        .setHTML(formatContent(props))
        .addTo(m);
    });

    m.on('mouseleave', sourceLayer, () => {
      if (hoverPopupRef.current) {
        hoverPopupRef.current.remove();
        hoverPopupRef.current = null;
      }
    });
  }, []);

  const fitToBounds = useCallback((
    bounds: { minLng: number; minLat: number; maxLng: number; maxLat: number },
    padding = 50,
  ) => {
    if (!mapRef.current) return;
    mapRef.current.fitBounds(
      [[bounds.minLng, bounds.minLat], [bounds.maxLng, bounds.maxLat]],
      { padding, duration: 500 },
    );
  }, []);

  const searchLocation = useCallback(async (query: string): Promise<{ success: boolean; message?: string }> => {
    if (!mapRef.current) return { success: false, message: 'Map not ready' };
    const token = import.meta.env.VITE_MAPBOX_ACCESS_TOKEN;
    if (!token) return { success: false, message: 'Missing access token' };

    try {
      const res = await fetch(
        `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(query)}.json?access_token=${token}&country=us&limit=1`
      );
      const data = await res.json();
      if (!data.features?.length) return { success: false, message: 'Location not found' };

      const [lng, lat] = data.features[0].center;
      mapRef.current.flyTo({ center: [lng, lat], zoom: 12, duration: 1500 });
      return { success: true };
    } catch {
      return { success: false, message: 'Search failed' };
    }
  }, []);

  return {
    map,
    mapRef,
    styleLoaded,
    selectedFeatureId,
    isLoading,
    isInitialized,
    mapError,
    initializeMap,
    disposeMap,
    selectFeature,
    setupClickHandler,
    setupHoverPopup,
    fitToBounds,
    searchLocation,
  };
}
```

## Usage

```tsx
const {
  map,
  styleLoaded,
  isLoading,
  mapError,
  initializeMap,
  disposeMap,
  selectFeature,
  setupClickHandler,
  searchLocation,
} = useMapbox({
  style: 'mapbox://styles/mapbox/dark-v11',
  center: [-122.4, 37.8],
  zoom: 10,
});
```

## Key Design Decisions

- **Refs for stable callbacks**: `mapRef` and `isInitializedRef` prevent stale closure issues in `useCallback` with empty deps
- **Dynamic script loading**: No npm package — script tag loaded once, checked before re-appending
- **Dispose pattern**: `disposeMap()` cleans up the GL context, popups, and all React state for clean re-initialization
- **Generic property names**: `propertyName` parameter lets you work with any GeoJSON property, not just ZIP codes
