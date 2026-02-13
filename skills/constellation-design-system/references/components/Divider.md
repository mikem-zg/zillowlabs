# Divider

```tsx
import { Divider } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.38.0

## Usage

```tsx
import { Divider } from '@zillow/constellation';
```

```tsx
export const DividerBasic = () => {
  return <Divider />;
};
```

## Examples

### Divider Orientation

```tsx
import { Divider } from '@zillow/constellation';
```

```tsx
export const DividerOrientation = () => {
  return (
    <div style={{ height: '250px' }}>
      <Divider tone="muted" orientation="vertical" />
    </div>
  );
};
```

### Divider Responsive

```tsx
import { Divider } from '@zillow/constellation';
```

```tsx
export const DividerResponsive = () => {
  return (
    <div style={{ height: '250px' }}>
      <Divider tone="muted" orientation={{ base: 'vertical', lg: 'horizontal' }} />
    </div>
  );
};
```

### Divider Tone

```tsx
import { Box, Divider } from '@zillow/constellation';
```

```tsx
export const DividerTone = () => {
  return (
    <Box css={{ display: 'flex', flexDirection: 'column', gap: 'default' }}>
      <Divider tone="muted" />
      <Divider tone="muted-alt" />
      <Divider tone="emphasized" />
    </Box>
  );
};
```

### Divider With Margin

```tsx
import { Divider } from '@zillow/constellation';
```

```tsx
export const DividerWithMargin = () => {
  return <Divider css={{ marginBlock: 'default' }} />;
};
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `tone` | `'muted' \| 'muted-alt' \| 'emphasized'` | `muted` | The tone of the divider |
| `css` | `SystemStyleObject` | — | Styles object |
| `length` | `never` | — |  |
| `orientation` | `ResponsiveVariant<'horizontal' \| 'vertical'>` | `horizontal` | The orientation of a divider. Supports inline media query objects. |
| `role` | `AriaRole` | `separator` | A [role](https://www.w3.org/TR/wai-aria-1.2/#roles) is required for assistive technologies to announce the divider properly. Divider uses the [separator](https://www.w3.org/TR/wai-aria-1.2/#separator) role. |

