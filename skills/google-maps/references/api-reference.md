# @vis.gl/react-google-maps API Reference

## Table of Contents

- [Components](#components): APIProvider, Map, AdvancedMarker, Pin, InfoWindow, MapControl
- [Hooks](#hooks): useMap, useMapsLibrary, useAdvancedMarkerRef, useApiIsLoaded, useApiLoadingStatus
- [TypeScript Types](#typescript-types)

## Components

### APIProvider

Wraps the app or page to load the Google Maps JavaScript API. All map components and hooks must be descendants.

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `apiKey` | `string` | **required** | Google Maps API key |
| `version` | `string` | `"weekly"` | Maps JS API version |
| `onLoad` | `() => void` | — | Fires when the API is fully loaded |
| `libraries` | `string[]` | `[]` | Additional libraries to preload (e.g. `['places', 'geocoding']`) |
| `solutionChannel` | `string` | — | Analytics tracking channel |

> Wrap once at app or page level. All child components and hooks require this.

### Map

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `mapId` | `string` | — | **Required for AdvancedMarkers.** Get from Cloud Console → Maps → Map Management |
| `defaultCenter` | `{ lat: number; lng: number }` | — | Initial center (uncontrolled) |
| `center` | `{ lat: number; lng: number }` | — | Center (controlled) |
| `defaultZoom` | `number` (0–22) | — | Initial zoom (uncontrolled) |
| `zoom` | `number` (0–22) | — | Zoom (controlled) |
| `style` | `CSSProperties` | — | **Required.** Must set `width` and `height` |
| `gestureHandling` | `"greedy" \| "cooperative" \| "none" \| "auto"` | `"auto"` | How the map responds to touch/scroll |
| `disableDefaultUI` | `boolean` | `false` | Hides all default controls |
| `mapTypeId` | `"roadmap" \| "satellite" \| "hybrid" \| "terrain"` | `"roadmap"` | Base map type |
| `onClick` | `(e: MapMouseEvent) => void` | — | Map click handler |
| `onDblClick` | `(e: MapMouseEvent) => void` | — | Double-click handler |
| `onDragEnd` | `() => void` | — | Fires after map drag ends |
| `onZoomChanged` | `(zoom: number) => void` | — | Fires when zoom changes |
| `onCenterChanged` | `(center: LatLngLiteral) => void` | — | Fires when center changes |
| `onBoundsChanged` | `(bounds: LatLngBoundsLiteral) => void` | — | Fires when bounds change |
| `fullscreenControl` | `boolean` | `true` | Show fullscreen button |
| `zoomControl` | `boolean` | `true` | Show zoom buttons |
| `streetViewControl` | `boolean` | `true` | Show street view pegman |
| `mapTypeControl` | `boolean` | `true` | Show map/satellite toggle |
| `restriction` | `{ latLngBounds: LatLngBoundsLiteral; strictBounds?: boolean }` | — | Restricts the visible area |
| `minZoom` | `number` | — | Minimum zoom level |
| `maxZoom` | `number` | — | Maximum zoom level |

> Use **uncontrolled** (`defaultCenter`/`defaultZoom`) unless you need programmatic control. Controlled (`center`/`zoom`) requires you to update state on every camera change.

### AdvancedMarker

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `position` | `{ lat: number; lng: number }` | **required** | Marker position |
| `title` | `string` | — | Hover tooltip |
| `onClick` | `(e: MapMouseEvent) => void` | — | Click handler |
| `onDragEnd` | `(e: MapMouseEvent) => void` | — | Fires after drag ends |
| `draggable` | `boolean` | `false` | Allows dragging |
| `zIndex` | `number` | — | Stacking order |
| `collisionBehavior` | `string` | — | How marker handles overlap |

Children: optional custom JSX for marker content, or use `<Pin>`.

> **Requires** `mapId` on the parent `<Map>`. Legacy `Marker` is deprecated.

### Pin

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `background` | `string` | — | Fill color |
| `glyphColor` | `string` | — | Glyph/icon color |
| `borderColor` | `string` | — | Border color |
| `glyph` | `string \| Element` | — | Custom glyph content |
| `scale` | `number` | `1` | Size multiplier |

> Use inside `<AdvancedMarker>` for styled default markers.

### InfoWindow

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `position` | `{ lat: number; lng: number }` | — | Standalone placement position |
| `anchor` | `AdvancedMarker instance` | — | Marker to attach to |
| `onCloseClick` | `() => void` | — | Close button handler |
| `headerContent` | `string` | — | Header text |
| `headerDisabled` | `boolean` | `false` | Hides the header |
| `shouldFocus` | `boolean` | `true` | Auto-focus on open |
| `maxWidth` | `number` | — | Max width in pixels |
| `minWidth` | `number` | — | Min width in pixels |
| `pixelOffset` | `[number, number]` | — | Pixel offset `[x, y]` |

Children: JSX content for the popup.

> Use `anchor` with a marker ref to attach to a marker. Use `position` for standalone placement.

### MapControl

| Prop | Type | Description |
|------|------|-------------|
| `position` | `ControlPosition` | Where to place the control on the map |

**ControlPosition values:** `TOP`, `TOP_LEFT`, `TOP_RIGHT`, `TOP_CENTER`, `BOTTOM`, `BOTTOM_LEFT`, `BOTTOM_RIGHT`, `BOTTOM_CENTER`, `LEFT_TOP`, `LEFT_CENTER`, `LEFT_BOTTOM`, `RIGHT_TOP`, `RIGHT_CENTER`, `RIGHT_BOTTOM`

Children: any JSX to overlay on the map (search bars, legends, filters).

```tsx
import { ControlPosition, MapControl } from '@vis.gl/react-google-maps';

<MapControl position={ControlPosition.TOP_LEFT}>
  <input type="text" placeholder="Search..." />
</MapControl>
```

---

## Hooks

### useMap(id?)

Returns: `google.maps.Map | null`

Returns `null` until the map is loaded. Use for imperative operations (pan, zoom, fitBounds).

```tsx
const map = useMap();

function handleFitBounds(bounds: google.maps.LatLngBoundsLiteral) {
  if (!map) return;
  map.fitBounds(bounds);
}
```

### useMapsLibrary(name)

| Parameter | Type |
|-----------|------|
| `name` | `"places" \| "routes" \| "geocoding" \| "geometry" \| "drawing" \| "visualization" \| "maps3d"` |

Returns: the loaded library namespace or `null`.

Always null-check. Create service instances with `useMemo`.

```tsx
const geocodingLib = useMapsLibrary('geocoding');
const geocoder = useMemo(
  () => geocodingLib && new geocodingLib.Geocoder(),
  [geocodingLib]
);
```

### useAdvancedMarkerRef()

Returns: `[refCallback, markerInstance]`

Pass `refCallback` to AdvancedMarker's `ref` prop. Use `markerInstance` as `anchor` for InfoWindow.

```tsx
const [markerRef, marker] = useAdvancedMarkerRef();

<AdvancedMarker ref={markerRef} position={pos} onClick={() => setOpen(true)} />
{open && <InfoWindow anchor={marker} onCloseClick={() => setOpen(false)}>Content</InfoWindow>}
```

### useApiIsLoaded()

Returns: `boolean`

`true` when the Maps JavaScript API is fully loaded.

### useApiLoadingStatus()

Returns: `ApiLoadingStatus` — one of `"NOT_LOADED"` | `"LOADING"` | `"LOADED"` | `"FAILED"` | `"AUTH_FAILURE"`

---

## TypeScript Types

```tsx
type LatLngLiteral = { lat: number; lng: number };

google.maps.MapMouseEvent
google.maps.LatLngBoundsLiteral

google.maps.places.PlaceResult
google.maps.places.AutocompleteOptions

google.maps.DirectionsResult
google.maps.DirectionsRoute
google.maps.TravelMode
```

Import the library type via `useMapsLibrary` — types are available after the library loads:

```tsx
const placesLib = useMapsLibrary('places');
const routesLib = useMapsLibrary('routes');
```
