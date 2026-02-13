# Input

```tsx
import { Input } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 1.3.0

## Usage

```tsx
import { Input } from '@zillow/constellation';
```

```tsx
export const InputBasic = () => <Input placeholder="Placeholder text" />;
```

## Examples

### Input Disabled Fluid Width

```tsx
import { Input } from '@zillow/constellation';
```

```tsx
export const InputDisabledFluidWidth = () => <Input fluid={false} placeholder="Placeholder text" />;
```

### Input Disabled

```tsx
import { Input } from '@zillow/constellation';
```

```tsx
export const InputDisabled = () => <Input disabled placeholder="Placeholder text" />;
```

### Input Error State

```tsx
import { Input } from '@zillow/constellation';
```

```tsx
export const InputErrorState = () => <Input error placeholder="Placeholder text" />;
```

### Input Read Only

```tsx
import { Input } from '@zillow/constellation';
```

```tsx
export const InputReadOnly = () => <Input readOnly placeholder="Placeholder text" />;
```

### Input Sizes

```tsx
import { Box, Input } from '@zillow/constellation';
```

```tsx
export const InputSizes = () => (
  <Box css={{ display: 'flex', gap: 'default', flexDirection: 'column' }}>
    <Input size="sm" placeholder="Small Input" />
    <Input size="md" placeholder="Medium Input" />
    <Input size="lg" placeholder="Large Input" />
  </Box>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `autoComplete` | `string` | — | Used for [autofill](https://developers.google.com/web/updates/2015/06/checkout-faster-with-autofill). |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Disabled state. Inherited from parent context if undefined. |
| `error` | `boolean` | `false` | Error state. Inherited from parent context if undefined. |
| `fluid` | `boolean` | `true` | Inputs are fluid by default which means they stretch to fill the entire width of their container. When `fluid="false"`, the inputs's width is set to `auto`. |
| `readOnly` | `boolean` | `false` | Read-only state. Inherited from parent context if undefined. |
| `required` | `boolean` | `false` | Required state. Inherited from parent context if undefined. |
| `size` | `'sm' \| 'md' \| 'lg'` | `md` | The size of the input. |
| `type` | `HTMLInputTypeAttribute` | `text` | The HTML input type. |

