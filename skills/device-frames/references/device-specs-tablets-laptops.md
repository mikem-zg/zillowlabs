# Tablet, Laptop & Browser Specifications

## iPad Pro 13" M4 (2024)

| Property | Value |
|----------|-------|
| Physical | 281.6mm × 215.5mm × 5.1mm, 579g |
| Screen | 13" Ultra Retina XDR OLED, 120Hz ProMotion |
| Resolution | 2752 × 2064 px |
| CSS Viewport (landscape) | 1366 × 1024 px |
| CSS Viewport (portrait) | 1024 × 1366 px |
| DPR | 2x |
| PPI | 264 |
| Corner Radius | ~18px |
| Colors | Silver, Space Black |

## iPad Pro 11" M4 (2024)

| Property | Value |
|----------|-------|
| Physical | 249.7mm × 177.5mm × 5.3mm, 444g |
| Screen | 11" Ultra Retina XDR OLED, 120Hz ProMotion |
| Resolution | 2420 × 1668 px |
| CSS Viewport (landscape) | 1194 × 834 px |
| CSS Viewport (portrait) | 834 × 1194 px |
| DPR | 2x |
| PPI | 264 |
| Corner Radius | ~18px |

## MacBook Pro 16" M4 (2024)

| Property | Value |
|----------|-------|
| Screen | 16.2" Liquid Retina XDR |
| Resolution | 3456 × 2234 px |
| CSS Viewport (default) | 1728 × 1117 px |
| DPR | 2x |
| PPI | 254 |
| Notch | Yes (camera housing) |

### Scale Options

| Setting | Viewport |
|---------|----------|
| Default | 1728 × 1117 px |
| More Space | 2056 × 1329 px |
| Larger Text | 1168 × 755 px |

## MacBook Pro 14" M4 (2024)

| Property | Value |
|----------|-------|
| Screen | 14.2" Liquid Retina XDR |
| Resolution | 3024 × 1964 px |
| CSS Viewport (default) | 1512 × 982 px |
| DPR | 2x |
| PPI | 254 |

## Apple Watch Ultra (2024)

| Property | Value |
|----------|-------|
| Screen | 1.93" OLED |
| Resolution | 502 × 410 px |
| Physical | 49mm × 44mm × 14.4mm |
| Colors | Natural Titanium, Black Titanium |

## Browser Frames

Browser windows don't have fixed viewport sizes — they adapt to the user's window. Use these defaults for mockups:

| Browser | Default Mockup Size | Tab Bar Height | Address Bar Height |
|---------|--------------------|----|-----|
| Chrome | 1280 × 800 px | 36px | 40px |
| Safari | 1280 × 800 px | 28px | 52px |
| Firefox | 1280 × 800 px | 36px | 40px |
| Arc | 1280 × 800 px | 0px (sidebar) | 40px |

## Mockup Dimensions

| Device | Frame W × H | Screen W × H | Border Radius |
|--------|-------------|---------------|---------------|
| iPad Pro 13" | 1024px × 1366px | 1004px × 1340px | 18px |
| iPad Pro 11" | 834px × 1194px | 814px × 1168px | 18px |
| MacBook Pro 16" | 1728px × 1117px | Full (within lid) | 10px (screen corners) |
| MacBook Pro 14" | 1512px × 982px | Full (within lid) | 10px |

## CSS Media Queries

```css
/* iPad Pro 11" */
@media (min-width: 834px) and (max-width: 1194px) and (-webkit-min-device-pixel-ratio: 2) { }

/* iPad Pro 13" */
@media (min-width: 1024px) and (max-width: 1366px) and (-webkit-min-device-pixel-ratio: 2) { }

/* MacBook Pro 16" default */
@media (min-width: 1728px) and (-webkit-min-device-pixel-ratio: 2) { }

/* MacBook Pro 14" default */
@media (min-width: 1512px) and (-webkit-min-device-pixel-ratio: 2) { }
```
