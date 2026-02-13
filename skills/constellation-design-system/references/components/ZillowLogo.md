# ZillowLogo

```tsx
import { ZillowLogo } from '@zillow/constellation';
```

**Version:** 10.11.0

## Usage

```tsx
import { ZillowLogo } from '@zillow/constellation';
```

```tsx
export const ZillowLogoBasic = () => <ZillowLogo role="img" />;
```

## Examples

### Zillow Logo Base On Impact

```tsx
import { ZillowLogo } from '@zillow/constellation';
```

```tsx
export const ZillowLogoBaseOnImpact = () => <ZillowLogo onImpact role="img" />;
```

### Zillow Logo Legacy Logo On Impact

```tsx
import { ZillowLogo } from '@zillow/constellation';
```

```tsx
export const ZillowLogoLegacyLogoOnImpact = () => <ZillowLogo showLegacyLogo onImpact role="img" />;
```

### Zillow Logo Legacy Logo Without Trademark

```tsx
import { ZillowLogo } from '@zillow/constellation';
```

```tsx
export const ZillowLogoLegacyLogoWithoutTrademark = () => (
  <ZillowLogo showLegacyLogo removeTrademark role="img" />
);
```

### Zillow Logo Legacy Logo

```tsx
import { ZillowLogo } from '@zillow/constellation';
```

```tsx
export const ZillowLogoLegacyLogo = () => <ZillowLogo showLegacyLogo role="img" />;
```

### Zillow Logo Logo Without Trademark

```tsx
import { ZillowLogo } from '@zillow/constellation';
```

```tsx
export const ZillowLogoLogoWithoutTrademark = () => <ZillowLogo removeTrademark role="img" />;
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |
| `onImpact` | `boolean` | `false` | If value is true, the logo will be white. Otherwise, default coloring You can override the logo color(s) with the `css` prop |
| `removeTrademark` | `boolean` | `false` | Zillow logos should **always include the trademark** unless you verify with the brand team that it can be removed. |
| `role` | `AriaRole` | `img` | The role is set to "img" by default to exclude all child content from the accessibility tree. |
| `showLegacyLogo` | `boolean` | `false` | True: Render the legacy logo |

