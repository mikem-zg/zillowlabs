# Choropleth & Dynamic Coloring

Patterns for coloring map features dynamically using Mapbox GL JS `match` expressions, opacity strategies, and legend components.

## Table of Contents

- [Match Expression Basics](#match-expression-basics)
- [Choropleth Color Strategies](#choropleth-color-strategies)
- [Opacity Strategies](#opacity-strategies)
- [Applying Colors to Layers](#applying-colors-to-layers)
- [Feature Visibility Filtering](#feature-visibility-filtering)
- [Heatmap via Fill Layers](#heatmap-via-fill-layers)
- [Legend Component Pattern](#legend-component-pattern)

## Match Expression Basics

Mapbox `match` expressions map feature property values to visual properties (color, opacity). They act as a switch/case:

```ts
const colorExpression = [
  'match',
  ['get', 'propertyName'],
  'value1', '#1e3a8a',
  'value2', '#3b82f6',
  'value3', '#93c5fd',
  '#94a3b8'
];
```

The last value is the fallback (default) for unmatched features.

## Choropleth Color Strategies

### Percentile-based (quantile)

Divide data into equal-sized groups. Good when data is unevenly distributed.

```ts
function calculatePercentileColors(
  data: Array<{ id: string; value: number }>,
): Array<[string, string]> {
  const sorted = [...data].sort((a, b) => a.value - b.value);
  const p25 = sorted[Math.floor(sorted.length * 0.25)]?.value ?? 0;
  const p50 = sorted[Math.floor(sorted.length * 0.50)]?.value ?? 0;
  const p75 = sorted[Math.floor(sorted.length * 0.75)]?.value ?? 0;

  return data.map(({ id, value }) => {
    let color: string;
    if (value >= p75) color = '#1e3a8a';
    else if (value >= p50) color = '#3b82f6';
    else if (value >= p25) color = '#60a5fa';
    else color = '#93c5fd';
    return [id, color];
  });
}
```

### Threshold-based (fixed breakpoints)

Use specific cutoff values. Good when thresholds have domain meaning.

```ts
function calculateThresholdColors(
  data: Array<{ id: string; value: number }>,
  thresholds: number[],
  colors: string[],
): Array<[string, string]> {
  return data.map(({ id, value }) => {
    let color = colors[0];
    for (let i = thresholds.length - 1; i >= 0; i--) {
      if (value >= thresholds[i]) { color = colors[i + 1]; break; }
    }
    return [id, color];
  });
}

// Example: population density
const colors = calculateThresholdColors(zipData,
  [100, 500, 1000, 5000],
  ['#f0f9ff', '#bae6fd', '#38bdf8', '#0284c7', '#0c4a6e']
);
```

### Diverging (positive/negative values)

Two-color scale centered on zero. Good for change metrics.

```ts
function calculateDivergingColors(
  data: Array<{ id: string; change: number }>,
): { colorStops: Array<[string, string]>; opacityStops: Array<[string, number]> } {
  const colorStops: Array<[string, string]> = data.map(({ id, change }) => {
    let color: string;
    if (change > 5) color = '#1d4ed8';
    else if (change > 0) color = '#3b82f6';
    else if (change === 0) color = '#94a3b8';
    else if (change > -5) color = '#ef4444';
    else color = '#dc2626';
    return [id, color];
  });

  const opacityStops: Array<[string, number]> = data.map(({ id, change }) => {
    const abs = Math.abs(change);
    let opacity: number;
    if (abs > 10) opacity = 0.6;
    else if (abs > 5) opacity = 0.5;
    else if (abs > 2) opacity = 0.4;
    else if (abs > 0) opacity = 0.3;
    else opacity = 0.2;
    return [id, opacity];
  });

  return { colorStops, opacityStops };
}
```

## Opacity Strategies

Opacity adds a second visual dimension. Common approaches:

### Value-proportional

```ts
const opacityStops: Array<[string, number]> = data.map(({ id, value }) => {
  const opacity = Math.min(0.7, 0.15 + (value / maxValue) * 0.55);
  return [id, opacity];
});
```

### Tiered

```ts
const opacityStops: Array<[string, number]> = data.map(({ id, value }) => {
  let opacity: number;
  if (value >= p75) opacity = 0.5;
  else if (value >= p50) opacity = 0.4;
  else if (value >= p25) opacity = 0.3;
  else opacity = 0.2;
  return [id, opacity];
});
```

## Applying Colors to Layers

Build a `match` expression from color stops and apply it:

```ts
function applyVisualization(
  map: mapboxgl.Map,
  layerName: string,
  propertyName: string,
  colorStops: Array<[string, string]>,
  opacityStops: Array<[string, number]>,
  defaultColor = '#94a3b8',
  defaultOpacity = 0.05,
) {
  if (!map.getLayer(layerName)) return;

  const colorExpr: mapboxgl.ExpressionSpecification = ['match', ['get', propertyName],
    ...colorStops.flat(),
    defaultColor,
  ];

  const opacityExpr: mapboxgl.ExpressionSpecification = ['match', ['get', propertyName],
    ...opacityStops.flat(),
    defaultOpacity,
  ];

  map.setPaintProperty(layerName, 'fill-color', colorExpr);
  map.setPaintProperty(layerName, 'fill-opacity', opacityExpr);
}
```

### Usage

```ts
const { colorStops, opacityStops } = calculateDivergingColors(myData);
applyVisualization(map, 'my-fill-layer', 'name', colorStops, opacityStops);
```

## Feature Visibility Filtering

Show only features in your dataset:

```ts
function setVisibleFeatures(map: mapboxgl.Map, layerName: string, propertyName: string, ids: string[]) {
  if (!map.getLayer(layerName)) return;
  map.setFilter(layerName, [
    'in',
    ['get', propertyName],
    ['literal', ids],
  ]);
}
```

## Heatmap via Fill Layers

For polygon-based heatmaps (not point heatmaps), use the fill layer approach above with a continuous color scale:

```ts
function calculateHeatmapColors(
  data: Array<{ id: string; value: number }>,
  minColor = '#eff6ff',
  maxColor = '#1e3a8a',
): Array<[string, string]> {
  const values = data.map(d => d.value);
  const min = Math.min(...values);
  const max = Math.max(...values);
  const range = max - min || 1;

  return data.map(({ id, value }) => {
    const t = (value - min) / range;
    const color = interpolateColor(minColor, maxColor, t);
    return [id, color];
  });
}

function interpolateColor(c1: string, c2: string, t: number): string {
  const r1 = parseInt(c1.slice(1, 3), 16), g1 = parseInt(c1.slice(3, 5), 16), b1 = parseInt(c1.slice(5, 7), 16);
  const r2 = parseInt(c2.slice(1, 3), 16), g2 = parseInt(c2.slice(3, 5), 16), b2 = parseInt(c2.slice(5, 7), 16);
  const r = Math.round(r1 + (r2 - r1) * t), g = Math.round(g1 + (g2 - g1) * t), b = Math.round(b1 + (b2 - b1) * t);
  return `#${r.toString(16).padStart(2, '0')}${g.toString(16).padStart(2, '0')}${b.toString(16).padStart(2, '0')}`;
}
```

## Legend Component Pattern

A reusable React legend component for displaying color scales:

```tsx
interface LegendItem {
  color: string;
  opacity: number;
  label: string;
}

interface MapLegendProps {
  title: string;
  items: LegendItem[];
}

function MapLegend({ title, items }: MapLegendProps) {
  return (
    <div className="absolute bottom-4 left-4 bg-white rounded-lg shadow-lg p-3 z-10 border" data-testid="map-legend">
      <h3 className="text-xs font-semibold mb-2">{title}</h3>
      <div className="space-y-1.5">
        {items.map((item, i) => (
          <div key={i} className="flex items-center gap-2">
            <div
              className="w-6 h-4 rounded"
              style={{ backgroundColor: item.color, opacity: item.opacity }}
            />
            <span className="text-xs text-gray-700">{item.label}</span>
          </div>
        ))}
      </div>
    </div>
  );
}
```

### Usage

```tsx
<MapLegend
  title="Population Density"
  items={[
    { color: '#1e3a8a', opacity: 0.6, label: 'Very High (>5000/sq mi)' },
    { color: '#3b82f6', opacity: 0.5, label: 'High (1000-5000)' },
    { color: '#60a5fa', opacity: 0.4, label: 'Medium (500-1000)' },
    { color: '#93c5fd', opacity: 0.3, label: 'Low (<500)' },
  ]}
/>
```
