# NPM Packages for Device Frames

## react-device-frameset

The most popular React device frame library. Based on Marvel's devices.css.

### Install

```bash
npm install react-device-frameset
```

### Basic Usage

```tsx
import { DeviceFrameset } from 'react-device-frameset';
import 'react-device-frameset/styles/marvel-devices.min.css';

function App() {
  return (
    <DeviceFrameset device="iPhone X" color="black">
      <img src="/screenshot.png" alt="App" style={{ width: '100%' }} />
    </DeviceFrameset>
  );
}
```

### Available Devices

| Device | Colors |
|--------|--------|
| `"iPhone X"` | black |
| `"iPhone 8"` | black, silver, gold |
| `"iPhone 8 Plus"` | black, silver, gold |
| `"iPhone 5s"` | black, silver, gold |
| `"iPhone 5c"` | white, red, yellow, green, blue |
| `"iPhone 4s"` | black, silver |
| `"iPad Mini"` | black, silver |
| `"Galaxy Note 8"` | black |
| `"Nexus 5"` | black |
| `"Lumia 920"` | black, white, yellow, red, blue |
| `"Samsung Galaxy S5"` | white, black |
| `"HTC One"` | black |
| `"MacBook Pro"` | — |

### With Device Selector

```tsx
import { DeviceFrameset, DeviceSelector } from 'react-device-frameset';
import 'react-device-frameset/styles/marvel-devices.min.css';

function Demo() {
  return (
    <DeviceSelector>
      {({ device, color }) => (
        <DeviceFrameset device={device} color={color}>
          <iframe src="https://example.com" style={{ width: '100%', height: '100%', border: 'none' }} />
        </DeviceFrameset>
      )}
    </DeviceSelector>
  );
}
```

### Landscape Mode

```tsx
<DeviceFrameset device="iPhone X" landscape>
  <img src="/landscape-screenshot.png" alt="App landscape" />
</DeviceFrameset>
```

### Limitations

- No iPhone 14/15/16/17 models
- No Pixel or modern Samsung devices
- Last major update was 2021
- Good for quick prototypes, not latest-device accuracy

---

## react-device-frames

Minimal React components for device frames.

### Install

```bash
npm install react-device-frames
```

### Usage

```tsx
import { IPhoneX, Pixel3XL, Chrome } from 'react-device-frames';

<IPhoneX screenshot="/mobile.png" />
<Pixel3XL screenshot="/android.png" />
<Chrome screenshot="/desktop.png" />
```

### Limitations

- Only 3 devices: iPhone X, Pixel 3 XL, Chrome
- Screenshot-only (no live content)
- Minimal maintenance

---

## @nicepkg/react-device-mockup

Modern React library with newer devices.

### Install

```bash
npm install @nicepkg/react-device-mockup
```

### Supported Devices

- iPhone 15 Pro / Pro Max
- iPad Pro
- MacBook Pro
- Samsung Galaxy S24

---

## Recommendation

| Need | Use |
|------|-----|
| Latest devices (iPhone 17) | Custom CSS or React component from [react-component.md](react-component.md) |
| Quick prototype, older devices OK | `react-device-frameset` |
| Minimal, screenshot-only | `react-device-frames` |
| No dependencies | Pure CSS from [css-frames.md](css-frames.md) |
