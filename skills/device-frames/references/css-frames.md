# Pure CSS Device Frames

Complete CSS implementations for device mockups. No images, no dependencies.

## iPhone 17 Pro / Pro Max

```css
.device-iphone-17-pro {
  position: relative;
  width: 402px;
  height: 874px;
  background: #1d1d1f;
  border-radius: 55px;
  box-shadow:
    0 0 0 6px #1d1d1f,
    0 0 0 8px #3b444b,
    0 30px 60px rgba(0, 0, 0, 0.3);
  overflow: hidden;
}

.device-iphone-17-pro .device-screen {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 49px;
}

.device-iphone-17-pro .dynamic-island {
  position: absolute;
  top: 14px;
  left: 50%;
  transform: translateX(-50%);
  width: 100px;
  height: 32px;
  background: #000;
  border-radius: 20px;
  z-index: 10;
}

.device-iphone-17-pro .home-indicator {
  position: absolute;
  bottom: 8px;
  left: 50%;
  transform: translateX(-50%);
  width: 140px;
  height: 5px;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 3px;
  z-index: 10;
}

/* Side buttons */
.device-iphone-17-pro .btn-power {
  position: absolute;
  right: -8px;
  top: 200px;
  width: 4px;
  height: 80px;
  background: #3b444b;
  border-radius: 0 2px 2px 0;
}

.device-iphone-17-pro .btn-volume-up {
  position: absolute;
  left: -8px;
  top: 180px;
  width: 4px;
  height: 40px;
  background: #3b444b;
  border-radius: 2px 0 0 2px;
}

.device-iphone-17-pro .btn-volume-down {
  position: absolute;
  left: -8px;
  top: 240px;
  width: 4px;
  height: 40px;
  background: #3b444b;
  border-radius: 2px 0 0 2px;
}

.device-iphone-17-pro .btn-action {
  position: absolute;
  left: -8px;
  top: 120px;
  width: 4px;
  height: 24px;
  background: #3b444b;
  border-radius: 2px 0 0 2px;
}
```

### Color Variants

```css
/* Deep Blue */
.device-iphone-17-pro.color-deep-blue {
  box-shadow: 0 0 0 6px #1a2744, 0 0 0 8px #2a3b5c, 0 30px 60px rgba(0,0,0,0.3);
}
.device-iphone-17-pro.color-deep-blue .btn-power,
.device-iphone-17-pro.color-deep-blue .btn-volume-up,
.device-iphone-17-pro.color-deep-blue .btn-volume-down,
.device-iphone-17-pro.color-deep-blue .btn-action { background: #2a3b5c; }

/* Silver */
.device-iphone-17-pro.color-silver {
  box-shadow: 0 0 0 6px #c7c7c7, 0 0 0 8px #d4d4d4, 0 30px 60px rgba(0,0,0,0.2);
}

/* Cosmic Orange */
.device-iphone-17-pro.color-cosmic-orange {
  box-shadow: 0 0 0 6px #c46a3a, 0 0 0 8px #d07a4a, 0 30px 60px rgba(0,0,0,0.3);
}
```

### Pro Max (just change dimensions)

```css
.device-iphone-17-pro-max {
  width: 440px;
  height: 956px;
  /* All other styles same as .device-iphone-17-pro */
}
```

### HTML Structure

```html
<div class="device-iphone-17-pro color-deep-blue">
  <div class="dynamic-island"></div>
  <img class="device-screen" src="screenshot.png" alt="App" />
  <div class="home-indicator"></div>
  <div class="btn-power"></div>
  <div class="btn-volume-up"></div>
  <div class="btn-volume-down"></div>
  <div class="btn-action"></div>
</div>
```

### Live Content (instead of image)

```html
<div class="device-iphone-17-pro">
  <div class="dynamic-island"></div>
  <div class="device-screen" style="overflow-y: auto; background: #fff;">
    <!-- Any HTML content here -->
    <h1>My App</h1>
    <p>Live content inside the frame</p>
  </div>
  <div class="home-indicator"></div>
</div>
```

### Iframe Embed

```html
<div class="device-iphone-17-pro">
  <div class="dynamic-island"></div>
  <iframe
    class="device-screen"
    src="https://example.com"
    style="border: none; width: 100%; height: 100%; border-radius: 49px;"
  ></iframe>
  <div class="home-indicator"></div>
</div>
```

---

## Samsung Galaxy S25 Ultra

```css
.device-galaxy-s25-ultra {
  position: relative;
  width: 480px;
  height: 1040px;
  background: #1a1a1a;
  border-radius: 38px;
  box-shadow:
    0 0 0 6px #2a2a2a,
    0 0 0 8px #4a4a4a,
    0 30px 60px rgba(0, 0, 0, 0.3);
  overflow: hidden;
}

.device-galaxy-s25-ultra .device-screen {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 32px;
}

.device-galaxy-s25-ultra .camera-punch-hole {
  position: absolute;
  top: 18px;
  left: 50%;
  transform: translateX(-50%);
  width: 14px;
  height: 14px;
  background: #000;
  border-radius: 50%;
  z-index: 10;
}
```

---

## Google Pixel 9 Pro

```css
.device-pixel-9-pro {
  position: relative;
  width: 412px;
  height: 915px;
  background: #1a1a1a;
  border-radius: 40px;
  box-shadow:
    0 0 0 6px #1a1a1a,
    0 0 0 8px #3a3a3a,
    0 30px 60px rgba(0, 0, 0, 0.3);
  overflow: hidden;
}

.device-pixel-9-pro .device-screen {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 34px;
}

.device-pixel-9-pro .camera-punch-hole {
  position: absolute;
  top: 18px;
  left: 50%;
  transform: translateX(-50%);
  width: 12px;
  height: 12px;
  background: #000;
  border-radius: 50%;
  z-index: 10;
}
```

---

## iPad Pro 13"

```css
.device-ipad-pro-13 {
  position: relative;
  width: 1024px;
  height: 1366px;
  background: #1d1d1f;
  border-radius: 18px;
  box-shadow:
    0 0 0 10px #1d1d1f,
    0 0 0 12px #3b444b,
    0 40px 80px rgba(0, 0, 0, 0.3);
  overflow: hidden;
}

.device-ipad-pro-13 .device-screen {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 8px;
}

.device-ipad-pro-13 .camera {
  position: absolute;
  top: 50%;
  right: -12px;
  transform: translateY(-50%);
  width: 8px;
  height: 8px;
  background: #2a2a2a;
  border-radius: 50%;
}

/* Landscape orientation */
.device-ipad-pro-13.landscape {
  width: 1366px;
  height: 1024px;
}
```

---

## MacBook Pro 16"

```css
.device-macbook-pro-16 {
  position: relative;
}

.device-macbook-pro-16 .lid {
  position: relative;
  width: 1000px;
  height: 650px;
  background: #1d1d1f;
  border-radius: 16px 16px 0 0;
  padding: 20px 20px 30px;
  box-shadow: 0 -2px 20px rgba(0, 0, 0, 0.2);
}

.device-macbook-pro-16 .device-screen {
  width: 100%;
  height: 100%;
  background: #000;
  border-radius: 10px;
  overflow: hidden;
}

.device-macbook-pro-16 .notch {
  position: absolute;
  top: 20px;
  left: 50%;
  transform: translateX(-50%);
  width: 160px;
  height: 18px;
  background: #1d1d1f;
  border-radius: 0 0 10px 10px;
  z-index: 10;
}

.device-macbook-pro-16 .base {
  width: 1100px;
  height: 14px;
  background: linear-gradient(to bottom, #c0c0c0, #a0a0a0);
  border-radius: 0 0 10px 10px;
  margin: 0 auto;
  position: relative;
}

.device-macbook-pro-16 .base::before {
  content: '';
  position: absolute;
  top: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 200px;
  height: 4px;
  background: #888;
  border-radius: 0 0 4px 4px;
}
```

### MacBook HTML Structure

```html
<div class="device-macbook-pro-16">
  <div class="lid">
    <div class="notch"></div>
    <div class="device-screen">
      <img src="screenshot.png" alt="App" style="width:100%; height:100%; object-fit:cover;" />
    </div>
  </div>
  <div class="base"></div>
</div>
```

---

## Browser Window (Chrome)

```css
.device-browser-chrome {
  position: relative;
  width: 1280px;
  max-width: 100%;
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
  overflow: hidden;
}

.device-browser-chrome .browser-toolbar {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 16px;
  background: #dee1e6;
}

.device-browser-chrome .browser-dots {
  display: flex;
  gap: 6px;
}

.device-browser-chrome .browser-dots span {
  width: 12px;
  height: 12px;
  border-radius: 50%;
}

.device-browser-chrome .browser-dots span:nth-child(1) { background: #ff5f57; }
.device-browser-chrome .browser-dots span:nth-child(2) { background: #ffbd2e; }
.device-browser-chrome .browser-dots span:nth-child(3) { background: #28c840; }

.device-browser-chrome .browser-address {
  flex: 1;
  height: 30px;
  background: #fff;
  border-radius: 15px;
  padding: 0 12px;
  font-size: 13px;
  line-height: 30px;
  color: #5f6368;
}

.device-browser-chrome .device-screen {
  width: 100%;
  min-height: 600px;
}
```

### Browser HTML Structure

```html
<div class="device-browser-chrome">
  <div class="browser-toolbar">
    <div class="browser-dots">
      <span></span><span></span><span></span>
    </div>
    <div class="browser-address">example.com</div>
  </div>
  <div class="device-screen">
    <img src="screenshot.png" alt="Website" style="width:100%;" />
  </div>
</div>
```

---

## Responsive Scaling

```css
.device-wrapper {
  --scale: 1;
  display: inline-block;
  transform: scale(var(--scale));
  transform-origin: top center;
}

@media (max-width: 1200px) { .device-wrapper { --scale: 0.8; } }
@media (max-width: 900px)  { .device-wrapper { --scale: 0.6; } }
@media (max-width: 600px)  { .device-wrapper { --scale: 0.45; } }
```

## Side-by-Side Layout

```css
.device-showcase {
  display: flex;
  justify-content: center;
  align-items: flex-end;
  gap: 40px;
  flex-wrap: wrap;
}
```

```html
<div class="device-showcase">
  <div class="device-wrapper" style="--scale: 0.6">
    <div class="device-iphone-17-pro">...</div>
  </div>
  <div class="device-wrapper" style="--scale: 0.5">
    <div class="device-ipad-pro-13 landscape">...</div>
  </div>
  <div class="device-wrapper" style="--scale: 0.45">
    <div class="device-macbook-pro-16">...</div>
  </div>
</div>
```
