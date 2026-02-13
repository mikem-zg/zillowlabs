# Highlighter

```tsx
import { Highlighter } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.28.0

## Usage

```tsx
import { Highlighter, Text } from '@zillow/constellation';
```

```tsx
export const HighlighterBasic = () => (
  <Text>
    <Highlighter
      text="Pinewood Condominium, New Brunswick, New Jersey"
      pattern="new"
      css={{
        '& [data-c11n-component="Highlight"]': {
          backgroundColor: 'bg.accent.yellow.soft-fixed',
          color: 'text.neutral-fixed',
        },
      }}
    />
  </Text>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |
| `pattern` | `string \| RegExp` | — | The pattern to find in `text`. When a string is passed, all matching strings will be highlighted (case insensitive). **(required)** |
| `renderHighlight` | `(props: HighlightPropsInterface) => ReactNode` | `({ key, ...highlightProps }) => <Highlight key={key} {...highlightProps} />` | A render function that will be called for all matching segments. By default it uses a `Highlight` component, [HTML Mark Text element (`<mark>`)](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/mark). |
| `text` | `string` | — | The text to render. **(required)** |

