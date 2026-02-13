# Label

```tsx
import { Label } from '@zillow/constellation';
```

**Version:** 10.11.0

## Usage

```tsx
import { Label } from '@zillow/constellation';
```

```tsx
export const LabelBasic = () => <Label>First name</Label>;
```

## Examples

### Label Disabled

```tsx
import { Label } from '@zillow/constellation';
```

```tsx
export const LabelDisabled = () => <Label disabled>Disabled label</Label>;
```

### Label Optional

```tsx
import { Label } from '@zillow/constellation';
```

```tsx
export const LabelOptional = () => <Label optional>Optional label</Label>;
```

### Label Required

```tsx
import { Label } from '@zillow/constellation';
```

```tsx
export const LabelRequired = () => <Label required>Required label</Label>;
```

### Label Sizes

```tsx
import { Box, Label } from '@zillow/constellation';
```

```tsx
export const LabelSizes = () => (
  <Box css={{ display: 'flex', gap: 'default', flexDirection: 'column' }}>
    <Label size="md">Medium size label</Label>
    <Label size="lg">Large size label</Label>
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
| `size` | `'md' \| 'lg'` | `md` | Label size. Inherited from parent context if undefined. |

