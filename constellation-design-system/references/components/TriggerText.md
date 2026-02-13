# TriggerText

```tsx
import { TriggerText } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 7.0.0

## Usage

```tsx
import { Paragraph, TriggerText } from '@zillow/constellation';
```

```tsx
export const TriggerTextBasic = () => (
  <Paragraph>
    Lorem ipsum dolor sit amet <TriggerText>trigger text</TriggerText> consectetur adipiscing elit,
    sed do eius mod tempor incididunt ut labore.
  </Paragraph>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

