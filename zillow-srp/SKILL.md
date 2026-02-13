---
name: zillow-srp
description: Build Zillow Search Results Pages (SRP) and any map-based property discovery UI with Constellation design system. Covers sticky header, filter bar with dropdown panels, Google Maps integration with custom price markers, responsive PropertyCard grid, and split-view map+listings layout. Use when building search results, property listing pages, map-based search, filter UI, location-based property discovery, property map views, commute search, triangulation tools, radius search, or any page that combines a Google Map with PropertyCards.
---

# Zillow Search Results Page (SRP) & Map+Listings Layout

Consumer-facing property search and map-based property discovery pages with sticky navigation, interactive filter dropdowns, Google Maps with custom price markers, and a responsive property listing grid. This skill provides reusable layout patterns for any page that combines a map view with PropertyCards. Built with Constellation v10.11.0 + PandaCSS.

## When to Use This Skill

**Search results pages:**
- Building a Zillow search page or search results page
- Creating a property search, home search, or listing search experience
- Building a "browse homes" or "find homes" page

**Any page combining Google Maps with PropertyCards:**
- Split-view layouts (map + listings side by side)
- Location-based property discovery (commute search, triangulation, radius search)
- Property map views with interactive markers
- Any consumer page showing properties on a map alongside a card list

**Reusable component patterns:**
- PriceMarker map pins (dark red pills with price labels)
- The `/api/maps-config` server route pattern for Google Maps API key
- Sticky header + content layout with `Page.Header` wrapped in `Box`
- Filter bars with dropdown panels (price, beds/baths, home type, etc.)
- Sort controls for property listings
- Mega-menu navigation (e.g., Buy dropdown with local links)

## Architecture

```
pages/search-results.tsx     ← Page shell (50 lines) — wires components + fetches map API key
components/
  SiteHeader.tsx             ← Sticky nav bar with ZillowLogo, nav links, Buy mega-menu
  BuyDropdownPanel.tsx       ← Hover-triggered mega menu with local links + resources
  FilterBar.tsx              ← Search input + 5 filter dropdowns (For Sale, Price, Beds/Baths, Home Type, More)
  MapView.tsx                ← Google Maps with dark-red pill price markers, error boundary, static fallback
  PropertyList.tsx           ← Sort controls + responsive PropertyCard grid
data/properties.ts           ← Property[] array (54 items) + types + map center coordinates
```

## Layout Structure

```
Page.Root (fluid, 100vh, flex column, overflow hidden)
├── Box (sticky, z-20, bg.screen.neutral, display: flow-root)
│   ├── SiteHeader (Page.Header + Divider + BuyDropdownPanel)
│   ├── FilterBar (search input + filter buttons)
│   └── Divider
└── Flex (flex 1, overflow hidden)
    ├── MapView (flex 1 1 50%, hidden below lg)
    └── PropertyList (flex 0 0 750px on lg, 100% on mobile)
```

## Responsive Breakpoints

| Viewport | Map | Listings | Grid columns |
|----------|-----|----------|--------------|
| < lg (1024px) | Hidden | Full width, single column | 1 |
| ≥ lg | Left 50% | Right 750px fixed | 2 |

## Critical Patterns

### 1. Sticky Header (Box wrapper required)

`Page.Header` has built-in responsive margins. Wrap in `Box` with `display: 'flow-root'` to prevent grey gap:

```tsx
<Box css={{ position: 'sticky', display: 'flow-root', top: 0, zIndex: 20, width: '100%', maxWidth: '100%', background: 'bg.screen.neutral' }}>
  <SiteHeader />
  <FilterBar />
  <Divider />
</Box>
```

### 2. PropertyCard (ALWAYS include saveButton)

```tsx
<PropertyCard
  photoBody={<PropertyCard.Photo src={p.image} alt={p.alt} />}
  badge={p.badge ? <PropertyCard.Badge tone={p.badgeTone}>{p.badge}</PropertyCard.Badge> : undefined}
  saveButton={<PropertyCard.SaveButton onClick={() => toggleSave(i)} selected={savedProperties.has(i)} />}
  data={{
    dataArea1: p.price,
    dataArea2: <PropertyCard.HomeDetails data={[{ value: p.beds, label: 'bd' }, { value: p.baths, label: 'ba' }, { value: p.sqft, label: 'sqft' }]} />,
    dataArea3: p.address,
    dataArea4: p.broker,
  }}
  elevated interactive
  onClick={() => setActiveMarker(i)}
/>
```

### 3. Map Price Markers (dark red pills)

Custom `AdvancedMarker` children with `#6B1818` background, white text, pill shape. Active state uses `#111116` + `scale(1.15)`.

### 4. Filter Dropdowns

Absolutely-positioned `Box` containers below filter buttons. Each dropdown has:
- `position: absolute`, `top: calc(100% + 4px)`, `background: bg.screen.neutral`
- `borderRadius: node.md`, `boxShadow`, `p: 400`, `zIndex: 50`
- Click-outside detection via `useRef` + `mousedown` listener
- Apply button: `<Button tone="brand" emphasis="filled" size="md">`

### 5. Sort Menu

Uses Constellation `Menu` component with `placement="bottom-end"`:

```tsx
<Menu
  placement="bottom-end"
  trigger={<Button tone="neutral" emphasis="outlined" size="sm" icon={<IconSortFilled />} iconPosition="start">Sort: {label}</Button>}
  content={<>{options.map(key => <Menu.Item key={key} onClick={() => setSortBy(key)}><Menu.ItemLabel>{label}</Menu.ItemLabel></Menu.Item>)}</>}
/>
```

## Required Dependencies

```
@vis.gl/react-google-maps    ← APIProvider, Map, AdvancedMarker
@zillow/constellation         ← All UI components
@zillow/constellation-icons   ← IconSearchFilled, IconSortFilled, IconChevronDownFilled, etc.
```

## Server Route

Expose Google Maps API key via `/api/maps-config`:

```ts
app.get('/api/maps-config', (_req, res) => {
  res.json({ apiKey: process.env.GOOGLE_MAPS_API_KEY || '' });
});
```

## Property Data Schema

```ts
interface Property {
  image: string; address: string; price: string; priceShort: string;
  beds: string; baths: string; sqft: string; type: string;
  badge: string | null; badgeTone: 'notify' | 'zillow';
  alt: string; broker: string; lat: number; lng: number;
}
```

## Consumer App Rules (applies to SRP)

- Full expressive color palette allowed (teals, oranges, purples for accents)
- `size="sm"` OK for filter buttons (size="md" rule is Professional apps only)
- Filled icons by default (`IconHeartFilled`, `IconSearchFilled`)
- White backgrounds (`bg.screen.neutral`)
- Only 1 `Heading` per screen — use `Text textStyle="body-bold"` for section labels
- `<Divider />` instead of CSS borders
- `TextButton` instead of `<a>` tags

## Reference Files

- **Page + Header + FilterBar**: See [references/page-composition.md](references/page-composition.md)
- **Map + Listings**: See [references/map-and-listings.md](references/map-and-listings.md)
- **Filter Dropdowns + Buy Menu**: See [references/filter-dropdowns.md](references/filter-dropdowns.md)
