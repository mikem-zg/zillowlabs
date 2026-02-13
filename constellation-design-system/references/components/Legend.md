# Legend

```tsx
import { Legend } from '@zillow/constellation';
```

**Version:** 10.11.0

## Usage

```tsx
import { Legend } from '@zillow/constellation';
```

```tsx
export const LegendBasic = () => <Legend>First name</Legend>;
```

## Examples

### Legend Disabled

```tsx
import { Legend } from '@zillow/constellation';
```

```tsx
export const LegendDisabled = () => <Legend disabled>Disabled legend</Legend>;
```

### Legend Optional

```tsx
import { Legend } from '@zillow/constellation';
```

```tsx
export const LegendOptional = () => <Legend optional>Optional legend</Legend>;
```

### Legend Required

```tsx
import { Legend } from '@zillow/constellation';
```

```tsx
export const LegendRequired = () => <Legend required>Required legend</Legend>;
```

### Legend Sizes

```tsx
import { Box, Legend } from '@zillow/constellation';
```

```tsx
export const LegendSizes = () => (
  <Box css={{ display: 'flex', gap: 'default', flexDirection: 'column' }}>
    <Legend size="md">Medium size legend</Legend>
    <Legend size="lg">Large size legend</Legend>
  </Box>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Disabled state. Inherited from parent context if undefined. |
| `optional` | `boolean` | `false` | Optional state. Inherited from parent context if undefined. |
| `required` | `boolean` | `false` | Required state. Inherited from parent context if undefined. |
| `size` | `'md' \| 'lg'` | `md` | Legend size. Inherited from parent context if undefined. |

