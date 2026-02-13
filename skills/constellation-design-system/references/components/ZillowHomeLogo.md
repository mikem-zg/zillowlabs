# ZillowHomeLogo

```tsx
import { ZillowHomeLogo } from '@zillow/constellation';
```

**Version:** 10.11.0

## Usage

```tsx
import { ZillowHomeLogo } from '@zillow/constellation';
```

```tsx
export const ZillowHomeLogoBasic = () => <ZillowHomeLogo role="img" />;
```

## Examples

### Zillow Home Logo Base On Impact

```tsx
import { ZillowHomeLogo } from '@zillow/constellation';
```

```tsx
export const ZillowHomeLogoBaseOnImpact = () => <ZillowHomeLogo onImpact role="img" />;
```

### Zillow Home Logo Legacy Logo On Impact

```tsx
import { ZillowHomeLogo } from '@zillow/constellation';
```

```tsx
export const ZillowHomeLogoLegacyLogoOnImpact = () => (
  <ZillowHomeLogo showLegacyLogo onImpact role="img" />
);
```

### Zillow Home Logo Legacy Logo Without Trademark

```tsx
import { ZillowHomeLogo } from '@zillow/constellation';
```

```tsx
export const ZillowHomeLogoLegacyLogoWithoutTrademark = () => (
  <ZillowHomeLogo showLegacyLogo removeTrademark role="img" />
);
```

### Zillow Home Logo Legacy Logo

```tsx
import { ZillowHomeLogo } from '@zillow/constellation';
```

```tsx
export const ZillowHomeLogoLegacyLogo = () => <ZillowHomeLogo showLegacyLogo role="img" />;
```

### Zillow Home Logo Logo Without Trademark

```tsx
import { ZillowHomeLogo } from '@zillow/constellation';
```

```tsx
export const ZillowHomeLogoLogoWithoutTrademark = () => (
  <ZillowHomeLogo removeTrademark role="img" />
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |
| `onImpact` | `boolean` | `false` | If value is true, the logo will be white. Otherwise, default coloring You can override the logo color(s) with the `css` prop |
| `removeTrademark` | `boolean` | `false` | Zillow logos should **always include the trademark** unless you verify with the brand team that it can be removed. |
| `role` | `AriaRole` | `img` | The role is set to "img" by default to exclude all child content from the accessibility tree. |
| `showLegacyLogo` | `boolean` | `false` | True: Render the legacy logo |

