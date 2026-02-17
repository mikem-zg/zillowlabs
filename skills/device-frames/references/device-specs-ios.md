# iOS Device Specifications

## iPhone 17 Pro (2025) — LATEST

| Property | Value |
|----------|-------|
| Physical | 150mm × 71.9mm × 8.75mm, 206g |
| Screen | 6.3" Super Retina XDR OLED, 120Hz ProMotion |
| Resolution | 2622 × 1206 px |
| CSS Viewport | 402 × 874 px |
| DPR | 3x |
| PPI | 460 |
| Corner Radius | ~55px (device), Dynamic Island |
| Safe Area (portrait) | Top: 59px, Bottom: 34px, L/R: 0px |
| Colors | Cosmic Orange, Deep Blue, Silver |
| Frame Material | Aluminum unibody |
| Frame Color CSS | Deep Blue: `#1a2744`, Silver: `#c7c7c7`, Cosmic Orange: `#c46a3a` |

## iPhone 17 Pro Max (2025)

| Property | Value |
|----------|-------|
| Physical | 163.4mm × 78mm × 8.75mm, 233g |
| Screen | 6.9" Super Retina XDR OLED, 120Hz ProMotion |
| Resolution | 2868 × 1320 px |
| CSS Viewport | 440 × 956 px |
| DPR | 3x |
| PPI | 460 |
| Corner Radius | ~55px (device), Dynamic Island |
| Safe Area (portrait) | Top: 59px, Bottom: 34px, L/R: 0px |
| Colors | Cosmic Orange, Deep Blue, Silver |

## iPhone 17 (2025)

| Property | Value |
|----------|-------|
| Physical | 149.6mm × 71.5mm × 7.95mm |
| Screen | 6.3" OLED, 120Hz ProMotion |
| Resolution | 2622 × 1206 px |
| CSS Viewport | 402 × 874 px |
| DPR | 3x |
| PPI | 460 |

## iPhone 17 Air (2025)

| Property | Value |
|----------|-------|
| Physical | ~5.6mm thickness (thinnest iPhone) |
| Screen | 6.5" OLED, 120Hz ProMotion |
| Resolution | ~2700 × 1245 px (est.) |
| CSS Viewport | ~402 × ~874 px (est.) |
| DPR | 3x |
| Colors | Space Black, Cloud White, Light Gold, Sky Blue |

## iPhone 16 Pro (2024)

| Property | Value |
|----------|-------|
| Physical | 149.6mm × 71.5mm × 8.25mm, 199g |
| Screen | 6.3" Super Retina XDR OLED, 120Hz ProMotion |
| Resolution | 2622 × 1206 px |
| CSS Viewport | 402 × 874 px |
| DPR | 3x |
| PPI | 460 |
| Colors | Desert Titanium, Natural Titanium, White Titanium, Black Titanium |
| Frame Color CSS | Natural: `#8a8a8a`, Blue: `#394a54`, White: `#c7c7c7`, Black: `#3b444b` |

## iPhone 16 Pro Max (2024)

| Property | Value |
|----------|-------|
| Physical | 163mm × 77.6mm × 8.25mm, 227g |
| Screen | 6.9" Super Retina XDR OLED, 120Hz ProMotion |
| Resolution | 2868 × 1320 px |
| CSS Viewport | 440 × 956 px |
| DPR | 3x |
| PPI | 460 |

## iPhone 16 (2024)

| Property | Value |
|----------|-------|
| Physical | 147.6mm × 71.6mm × 7.8mm, 170g |
| Screen | 6.1" Super Retina XDR OLED, 60Hz |
| Resolution | 2556 × 1179 px |
| CSS Viewport | 393 × 852 px |
| DPR | 3x |
| PPI | 460 |

## CSS Media Queries

```css
/* iPhone 17 Pro / 17 / 16 Pro (402px wide) */
@media (width: 402px) and (-webkit-device-pixel-ratio: 3) { }

/* iPhone 17 Pro Max / 16 Pro Max (440px wide) */
@media (width: 440px) and (-webkit-device-pixel-ratio: 3) { }

/* iPhone 16 (393px wide) */
@media (width: 393px) and (-webkit-device-pixel-ratio: 3) { }

/* All 3x Retina iPhones */
@media (-webkit-min-device-pixel-ratio: 3) { }
```

## Safe Area Insets

```css
/* Required viewport meta */
<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">

/* Apply safe areas */
.content {
  padding-top: env(safe-area-inset-top);
  padding-bottom: env(safe-area-inset-bottom);
  padding-left: env(safe-area-inset-left);
  padding-right: env(safe-area-inset-right);
}
```

## Mockup Dimensions (CSS pixels for frame rendering)

Use these when building CSS device frames. Scale with `transform: scale()`.

| Device | Frame W × H | Screen W × H | Border Radius | Bezel |
|--------|-------------|---------------|---------------|-------|
| iPhone 17 Pro | 402px × 874px | 390px × 844px | 55px | 6px |
| iPhone 17 Pro Max | 440px × 956px | 428px × 926px | 55px | 6px |
| iPhone 16 Pro | 402px × 874px | 390px × 844px | 55px | 6px |
| iPhone 16 | 393px × 852px | 381px × 822px | 50px | 6px |
