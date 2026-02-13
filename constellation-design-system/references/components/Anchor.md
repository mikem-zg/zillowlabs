# Anchor

```tsx
import { Anchor } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 6.0.0

## Usage

```tsx
import { Anchor, Paragraph } from '@zillow/constellation';
```

```tsx
export const AnchorBasic = () => (
  <Paragraph>
    Lorem ipsum <Anchor href="http://localhost:9999">sit amet</Anchor>.
  </Paragraph>
);
```

## Examples

### Anchor As Button

```tsx
import { Anchor, Paragraph } from '@zillow/constellation';
```

```tsx
export const AnchorAsButton = () => (
  <Paragraph>
    Lorem ipsum{' '}
    <Anchor href="#" asChild>
      <button type="button">sit amet</button>
    </Anchor>
    .
  </Paragraph>
);
```

### Anchor In Heading

```tsx
import { Anchor, Heading } from '@zillow/constellation';
```

```tsx
export const AnchorInHeading = () => (
  <Heading level={1}>
    Lorem ipsum <Anchor href="http://localhost:9999">sit amet</Anchor>.
  </Heading>
);
```

### Anchor In Text

```tsx
import { Anchor, Text } from '@zillow/constellation';
```

```tsx
export const AnchorInText = () => (
  <Text textStyle="body">
    Lorem ipsum <Anchor href="http://localhost:9999">sit amet</Anchor>.
  </Text>
);
```

### Anchor On Impact

```tsx
import { Anchor, Paragraph } from '@zillow/constellation';
```

```tsx
export const AnchorOnImpact = () => (
  <Paragraph css={{ color: 'text.onImpact.neutral' }}>
    Lorem ipsum{' '}
    <Anchor onImpact href="http://localhost:9999">
      sit amet
    </Anchor>
    .
  </Paragraph>
);
```

### Anchor Visited

```tsx
import { Anchor, Paragraph } from '@zillow/constellation';
```

```tsx
export const AnchorVisited = () => (
  <Paragraph>
    Lorem ipsum <Anchor href="https://www.zillow.com/">sit amet</Anchor>.
  </Paragraph>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | This prop mainly supports situations where `asChild` is used to turn another component into an anchor (ex: a `Button` component that is rendered as an anchor). Otherwise, anchor links should not be disabled. |
| `href` | `string` | — | The href attribute of the anchor |
| `onImpact` | `ResponsiveVariant<boolean>` | — | For use on dark or colored backgrounds. |

