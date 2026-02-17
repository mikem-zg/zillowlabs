# devices.css Library

[devices.css](https://devicescss.xyz/) by picturepan2 — modern device mockups in pure CSS. MIT licensed.

## Install

```bash
npm install devices.css
```

Or CDN:

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/picturepan2/devices.css/dist/devices.min.css">
```

## Supported Devices

| Device Class | Model |
|-------------|-------|
| `device-iphone-14-pro` | iPhone 14 Pro (Dynamic Island) |
| `device-iphone-14` | iPhone 14 |
| `device-iphone-x` | iPhone X |
| `device-iphone-8` | iPhone 8 |
| `device-ipad-pro` | iPad Pro |
| `device-macbook-pro` | MacBook Pro |
| `device-imac` | iMac |
| `device-apple-watch-ultra` | Apple Watch Ultra |
| `device-homepod` | HomePod |
| `device-surface-pro-2017` | Surface Pro |
| `device-surface-book` | Surface Book |

## HTML Structure

All devices follow the same markup pattern:

```html
<div class="device device-iphone-14-pro">
  <div class="device-frame">
    <img class="device-screen" src="screenshot.png" alt="App screenshot">
  </div>
  <div class="device-stripe"></div>
  <div class="device-header"></div>
  <div class="device-sensors"></div>
  <div class="device-btns"></div>
  <div class="device-power"></div>
</div>
```

## Color Variants

Add a color class after the device class:

```html
<div class="device device-iphone-14-pro device-spacegray">
```

Options: `device-gold`, `device-silver`, `device-spacegray`, `device-black`

## Live Content (not just images)

Replace `<img>` with any HTML:

```html
<div class="device device-iphone-14-pro">
  <div class="device-frame">
    <div class="device-screen" style="overflow-y: auto; background: white;">
      <h1>Live content</h1>
      <p>Scrollable HTML inside the device</p>
    </div>
  </div>
  <div class="device-stripe"></div>
  <div class="device-header"></div>
  <div class="device-sensors"></div>
  <div class="device-btns"></div>
  <div class="device-power"></div>
</div>
```

## Responsive Scaling

```css
.device { transform: scale(0.7); transform-origin: top center; }

@media (max-width: 768px) {
  .device { transform: scale(0.5); }
}
```

## Limitations

- Latest model is iPhone 14 Pro (no iPhone 15/16/17 yet)
- No Samsung Galaxy or Pixel models
- No browser window frames
- For latest devices, use the custom CSS approach in [css-frames.md](css-frames.md)

## When to Use

- Quick prototyping where iPhone 14 Pro is recent enough
- Projects that need iPad Pro, MacBook Pro, iMac, or Apple Watch mockups
- When you want a battle-tested CSS library with minimal setup
