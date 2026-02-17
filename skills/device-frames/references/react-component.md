# React Device Frame Component

A reusable React component for rendering device frames. Drop this into any React project.

## DeviceFrame Component

```tsx
import React from 'react';

type DeviceType =
  | 'iphone-17-pro' | 'iphone-17-pro-max' | 'iphone-17' | 'iphone-17-air'
  | 'iphone-16-pro' | 'iphone-16-pro-max' | 'iphone-16'
  | 'galaxy-s25-ultra' | 'pixel-9-pro'
  | 'ipad-pro-13' | 'ipad-pro-11'
  | 'macbook-pro-16' | 'macbook-pro-14'
  | 'browser-chrome' | 'browser-safari';

interface DeviceFrameProps {
  device: DeviceType;
  children: React.ReactNode;
  scale?: number;
  color?: string;
  landscape?: boolean;
  className?: string;
  url?: string; // for browser frames
}

const DEVICE_CONFIGS: Record<string, {
  width: number; height: number; radius: number; bezel: number;
  type: 'phone' | 'tablet' | 'laptop' | 'browser';
  hasIsland?: boolean; hasPunchHole?: boolean; hasNotch?: boolean;
}> = {
  'iphone-17-pro':     { width: 402, height: 874, radius: 55, bezel: 6, type: 'phone', hasIsland: true },
  'iphone-17-pro-max': { width: 440, height: 956, radius: 55, bezel: 6, type: 'phone', hasIsland: true },
  'iphone-17':         { width: 402, height: 874, radius: 55, bezel: 6, type: 'phone', hasIsland: true },
  'iphone-17-air':     { width: 402, height: 874, radius: 55, bezel: 4, type: 'phone', hasIsland: true },
  'iphone-16-pro':     { width: 402, height: 874, radius: 55, bezel: 6, type: 'phone', hasIsland: true },
  'iphone-16-pro-max': { width: 440, height: 956, radius: 55, bezel: 6, type: 'phone', hasIsland: true },
  'iphone-16':         { width: 393, height: 852, radius: 50, bezel: 6, type: 'phone', hasIsland: true },
  'galaxy-s25-ultra':  { width: 480, height: 1040, radius: 38, bezel: 6, type: 'phone', hasPunchHole: true },
  'pixel-9-pro':       { width: 412, height: 915, radius: 40, bezel: 6, type: 'phone', hasPunchHole: true },
  'ipad-pro-13':       { width: 1024, height: 1366, radius: 18, bezel: 10, type: 'tablet' },
  'ipad-pro-11':       { width: 834, height: 1194, radius: 18, bezel: 10, type: 'tablet' },
  'macbook-pro-16':    { width: 1000, height: 650, radius: 16, bezel: 20, type: 'laptop', hasNotch: true },
  'macbook-pro-14':    { width: 880, height: 570, radius: 16, bezel: 20, type: 'laptop', hasNotch: true },
  'browser-chrome':    { width: 1280, height: 800, radius: 10, bezel: 0, type: 'browser' },
  'browser-safari':    { width: 1280, height: 800, radius: 10, bezel: 0, type: 'browser' },
};

export function DeviceFrame({ device, children, scale = 1, color, landscape, className, url }: DeviceFrameProps) {
  const config = DEVICE_CONFIGS[device];
  if (!config) return <>{children}</>;

  const w = landscape ? config.height : config.width;
  const h = landscape ? config.width : config.height;

  if (config.type === 'browser') {
    return (
      <div
        className={className}
        style={{
          width: w * scale,
          borderRadius: config.radius,
          boxShadow: '0 20px 60px rgba(0,0,0,0.2)',
          overflow: 'hidden',
          background: '#fff',
        }}
      >
        <BrowserToolbar url={url} browser={device === 'browser-safari' ? 'safari' : 'chrome'} />
        <div style={{ width: '100%', minHeight: (h - 76) * scale, overflow: 'hidden' }}>
          {children}
        </div>
      </div>
    );
  }

  if (config.type === 'laptop') {
    return (
      <div className={className} style={{ transform: `scale(${scale})`, transformOrigin: 'top center' }}>
        <div style={{
          position: 'relative',
          width: w,
          height: h,
          background: '#1d1d1f',
          borderRadius: '16px 16px 0 0',
          padding: `${config.bezel}px ${config.bezel}px ${config.bezel + 10}px`,
          boxShadow: '0 -2px 20px rgba(0,0,0,0.2)',
        }}>
          {config.hasNotch && (
            <div style={{
              position: 'absolute', top: config.bezel, left: '50%', transform: 'translateX(-50%)',
              width: 160, height: 18, background: '#1d1d1f', borderRadius: '0 0 10px 10px', zIndex: 10,
            }} />
          )}
          <div style={{ width: '100%', height: '100%', borderRadius: 10, overflow: 'hidden', background: '#000' }}>
            {children}
          </div>
        </div>
        <div style={{
          width: w + 100, height: 14, margin: '0 auto',
          background: 'linear-gradient(to bottom, #c0c0c0, #a0a0a0)', borderRadius: '0 0 10px 10px',
        }} />
      </div>
    );
  }

  // Phone / Tablet
  const frameColor = color || '#1d1d1f';
  return (
    <div
      className={className}
      style={{
        position: 'relative',
        width: w,
        height: h,
        background: frameColor,
        borderRadius: config.radius,
        boxShadow: `0 0 0 ${config.bezel}px ${frameColor}, 0 0 0 ${config.bezel + 2}px #3b444b, 0 30px 60px rgba(0,0,0,0.3)`,
        overflow: 'hidden',
        transform: `scale(${scale})`,
        transformOrigin: 'top center',
      }}
    >
      {config.hasIsland && (
        <div style={{
          position: 'absolute', top: 14, left: '50%', transform: 'translateX(-50%)',
          width: 100, height: 32, background: '#000', borderRadius: 20, zIndex: 10,
        }} />
      )}
      {config.hasPunchHole && (
        <div style={{
          position: 'absolute', top: 18, left: '50%', transform: 'translateX(-50%)',
          width: 14, height: 14, background: '#000', borderRadius: '50%', zIndex: 10,
        }} />
      )}
      <div style={{
        width: '100%', height: '100%',
        borderRadius: config.radius - config.bezel, overflow: 'hidden',
      }}>
        {children}
      </div>
      {/* Home indicator (iOS) */}
      {config.hasIsland && (
        <div style={{
          position: 'absolute', bottom: 8, left: '50%', transform: 'translateX(-50%)',
          width: 140, height: 5, background: 'rgba(255,255,255,0.3)', borderRadius: 3, zIndex: 10,
        }} />
      )}
    </div>
  );
}

function BrowserToolbar({ url, browser }: { url?: string; browser: 'chrome' | 'safari' }) {
  const bg = browser === 'safari' ? '#f0f0f0' : '#dee1e6';
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '10px 16px', background: bg }}>
      <div style={{ display: 'flex', gap: 6 }}>
        <span style={{ width: 12, height: 12, borderRadius: '50%', background: '#ff5f57' }} />
        <span style={{ width: 12, height: 12, borderRadius: '50%', background: '#ffbd2e' }} />
        <span style={{ width: 12, height: 12, borderRadius: '50%', background: '#28c840' }} />
      </div>
      <div style={{
        flex: 1, height: 30, background: '#fff', borderRadius: 15,
        padding: '0 12px', fontSize: 13, lineHeight: '30px', color: '#5f6368',
      }}>
        {url || 'example.com'}
      </div>
    </div>
  );
}
```

## Usage Examples

### Basic Screenshot

```tsx
<DeviceFrame device="iphone-17-pro" color="#1a2744">
  <img src="/screenshot.png" alt="App" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
</DeviceFrame>
```

### Live HTML Content

```tsx
<DeviceFrame device="iphone-17-pro">
  <div style={{ padding: 20, background: '#fff', height: '100%', overflowY: 'auto' }}>
    <h1>My App</h1>
    <p>Renders live content inside the device frame</p>
  </div>
</DeviceFrame>
```

### Scaled for Responsive Layout

```tsx
<DeviceFrame device="iphone-17-pro-max" scale={0.6}>
  <img src="/screenshot.png" alt="App" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
</DeviceFrame>
```

### Browser Window

```tsx
<DeviceFrame device="browser-chrome" url="zillow.com">
  <img src="/desktop-screenshot.png" alt="Website" style={{ width: '100%' }} />
</DeviceFrame>
```

### Laptop Frame

```tsx
<DeviceFrame device="macbook-pro-16">
  <img src="/desktop-screenshot.png" alt="App" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
</DeviceFrame>
```

### Multi-Device Showcase

```tsx
<div style={{ display: 'flex', justifyContent: 'center', alignItems: 'flex-end', gap: 40, flexWrap: 'wrap' }}>
  <DeviceFrame device="iphone-17-pro" scale={0.6}>
    <img src="/mobile.png" alt="Mobile" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
  </DeviceFrame>
  <DeviceFrame device="ipad-pro-11" scale={0.4} landscape>
    <img src="/tablet.png" alt="Tablet" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
  </DeviceFrame>
  <DeviceFrame device="macbook-pro-16" scale={0.4}>
    <img src="/desktop.png" alt="Desktop" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
  </DeviceFrame>
</div>
```

### iPad in Portrait

```tsx
<DeviceFrame device="ipad-pro-13" scale={0.5}>
  <img src="/ipad-screenshot.png" alt="iPad app" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
</DeviceFrame>
```

### Android Devices

```tsx
<DeviceFrame device="galaxy-s25-ultra">
  <img src="/android-screenshot.png" alt="Android app" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
</DeviceFrame>

<DeviceFrame device="pixel-9-pro">
  <img src="/pixel-screenshot.png" alt="Pixel app" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
</DeviceFrame>
```
