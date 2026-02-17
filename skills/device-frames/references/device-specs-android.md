# Android Device Specifications

## Samsung Galaxy S25 Ultra (2025)

| Property | Value |
|----------|-------|
| Physical | 162.8mm × 77.6mm × 8.2mm, 218g |
| Screen | 6.9" Dynamic AMOLED 2X, 120Hz |
| Resolution | 3120 × 1440 px (QHD+) |
| CSS Viewport | 480 × 1040 px |
| DPR | 3x |
| PPI | 505 |
| Corner Radius | ~38px |
| Frame Color CSS | Titanium Black: `#2a2a2a`, Titanium Gray: `#8a8a8a`, Titanium Silver: `#c0c0c0`, Titanium Blue: `#3d4f6f` |

## Google Pixel 9 Pro (2024)

| Property | Value |
|----------|-------|
| Physical | 152.8mm × 72mm × 8.5mm, 199g |
| Screen | 6.3" LTPO OLED, 120Hz |
| Resolution | 2856 × 1280 px |
| CSS Viewport | 412 × 915 px |
| DPR | ~3.1x |
| PPI | 495 |
| Corner Radius | ~40px |
| Frame Color CSS | Obsidian: `#1a1a1a`, Porcelain: `#e8e5e0`, Hazel: `#a8b5a0`, Rose Quartz: `#d4b5b5` |

## Google Pixel 9 Pro XL (2024)

| Property | Value |
|----------|-------|
| Physical | 162.8mm × 76.6mm × 8.5mm, 221g |
| Screen | 6.8" LTPO OLED, 120Hz |
| Resolution | 2992 × 1344 px |
| CSS Viewport | ~448 × 998 px |
| DPR | ~3x |
| PPI | 486 |

## Mockup Dimensions

| Device | Frame W × H | Screen W × H | Border Radius | Bezel |
|--------|-------------|---------------|---------------|-------|
| Galaxy S25 Ultra | 480px × 1040px | 468px × 1016px | 38px | 6px |
| Pixel 9 Pro | 412px × 915px | 400px × 891px | 40px | 6px |

## CSS Media Queries

```css
/* Galaxy S25 Ultra */
@media (width: 480px) and (-webkit-device-pixel-ratio: 3) { }

/* Pixel 9 Pro */
@media (width: 412px) and (-webkit-min-device-pixel-ratio: 3) { }

/* Common Android phone range */
@media (min-width: 360px) and (max-width: 480px) { }
```
