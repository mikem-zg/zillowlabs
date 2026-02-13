# VisuallyHidden

```tsx
import { VisuallyHidden } from '@zillow/constellation';
```

**Version:** 10.11.0

## Usage

```tsx
import { VisuallyHidden } from '@zillow/constellation';
```

```tsx
export const VisuallyHiddenBasic = () => <VisuallyHidden>Hello</VisuallyHidden>;
```

## Examples

### Visually Hidden As Another Element

```tsx
import { VisuallyHidden } from '@zillow/constellation';
```

```tsx
export const VisuallyHiddenAsAnotherElement = () => (
  <VisuallyHidden asChild>
    <div>Hello</div>
  </VisuallyHidden>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element, root element defaults to <span> |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

