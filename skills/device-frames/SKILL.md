---
name: device-frames
description: Render realistic device frame mockups around screenshots and live content using pure CSS or React components. Covers iPhone 17 Pro/Pro Max (latest), iPhone 16, iPad Pro, MacBook Pro, Samsung Galaxy S25 Ultra, Google Pixel 9 Pro, Android phones, browser windows, and Apple Watch. Use when building landing pages, app showcases, portfolio sites, product demos, onboarding screens, or any UI that wraps content in a device frame. Includes pure CSS implementations, React component patterns, device specifications, and responsive scaling.
---

# Device Frames

Wrap screenshots, live HTML, or iframe content in realistic device mockups using pure CSS or React components. No images required.

## When to Use

- Showcasing app screenshots on a landing page or portfolio
- Building product demo pages with device context
- Creating onboarding flows that show the app in a phone frame
- Embedding live web content inside a device mockup
- Presenting responsive designs across multiple device types

## Quick Start — iPhone 17 Pro (Latest)

```tsx
import { DeviceFrame } from '@/components/device-frame';

<DeviceFrame device="iphone-17-pro" color="deep-blue">
  <img src="/screenshot.png" alt="App screenshot" />
</DeviceFrame>
```

Pure CSS (no dependencies):

```html
<div class="device device-iphone-17-pro">
  <div class="device-frame">
    <img class="device-screen" src="screenshot.png" />
  </div>
  <div class="device-stripe"></div>
  <div class="device-header"></div>
  <div class="device-sensors"></div>
  <div class="device-btns"></div>
  <div class="device-power"></div>
</div>
```

## Available Devices

| Category | Devices |
|----------|---------|
| **iOS Phones** | iPhone 17 Pro, iPhone 17 Pro Max, iPhone 17, iPhone 17 Air, iPhone 16 Pro, iPhone 16 Pro Max, iPhone 16 |
| **Android Phones** | Samsung Galaxy S25 Ultra, Google Pixel 9 Pro |
| **Tablets** | iPad Pro 13" (M4), iPad Pro 11" (M4) |
| **Laptops** | MacBook Pro 16", MacBook Pro 14" |
| **Browsers** | Chrome, Safari, Firefox, Arc |
| **Watches** | Apple Watch Ultra |

## Implementation Options

Choose the approach that fits your stack:

| Approach | Best For | Reference |
|----------|----------|-----------|
| **Custom CSS (recommended)** | Full control, latest devices, no deps | [references/css-frames.md](references/css-frames.md) |
| **React component** | Reusable components in React projects | [references/react-component.md](references/react-component.md) |
| **devices.css library** | Quick setup, broad device support | [references/devices-css-library.md](references/devices-css-library.md) |
| **react-device-frameset** | npm package, device selector UI | [references/npm-packages.md](references/npm-packages.md) |

## Device Specifications

Full specs (viewport, resolution, DPR, dimensions) for all devices:

- **iOS devices**: See [references/device-specs-ios.md](references/device-specs-ios.md)
- **Android devices**: See [references/device-specs-android.md](references/device-specs-android.md)
- **Tablets & laptops**: See [references/device-specs-tablets-laptops.md](references/device-specs-tablets-laptops.md)

## Responsive Scaling

Scale device frames to fit any container:

```css
.device-container {
  --device-scale: 0.7;
}
.device-container .device {
  transform: scale(var(--device-scale));
  transform-origin: top center;
}

@media (max-width: 768px) {
  .device-container { --device-scale: 0.5; }
}
```

## Key Rules

1. **Screen content** goes inside `.device-screen` (CSS) or as `children` (React)
2. **Scale with transform** — never change the device's width/height directly
3. **Use overflow: hidden** on screen containers to clip content
4. **Provide alt text** for screenshot images inside frames
5. **Safe area insets** — use `env(safe-area-inset-*)` for content inside iOS frames
