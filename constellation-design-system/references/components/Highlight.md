# Highlight

```tsx
import { Highlight } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.28.0

## Usage

```tsx
import { Highlight, Text } from '@zillow/constellation';
```

```tsx
export const HighlightBasic = () => (
  <Text>
    <Highlight
      css={{
        backgroundColor: 'bg.accent.yellow.soft-fixed',
        color: 'text.neutral-fixed',
      }}
    >
      Content
    </Highlight>
  </Text>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

