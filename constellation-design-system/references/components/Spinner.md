# Spinner

```tsx
import { Spinner } from '@zillow/constellation';
```

**Version:** 10.11.0

## Usage

```tsx
import { Spinner } from '@zillow/constellation';
```

```tsx
export const SpinnerBasic = () => <Spinner />;
```

## Examples

### Spinner Custom Color

```tsx
import { Spinner } from '@zillow/constellation';
```

```tsx
export const SpinnerCustomColor = () => <Spinner css={{ color: 'text.accent.green.hero' }} />;
```

### Spinner Inherits Size

```tsx
import { Heading, Paragraph, Spinner } from '@zillow/constellation';
```

```tsx
export const SpinnerInheritsSize = () => (
  <>
    <Heading level={3}>
      <Spinner /> Loading...
    </Heading>
    <Heading level={5}>
      <Spinner /> Loading...
    </Heading>
    <Paragraph textStyle="body-sm">
      <Spinner /> Loading...
    </Paragraph>
  </>
);
```

### Spinner On Impact

```tsx
import { Spinner } from '@zillow/constellation';
```

```tsx
export const SpinnerOnImpact = () => <Spinner onImpact />;
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `never` | — |  |
| `fontColor` | `never` | — |  |
| `title` | `string \| null` | `Loading` | Creates an accessible label for the icon for contextually meaningful icons, and sets the appropriate `aria` attributes. Icons are hidden from screen readers by default without this prop. Note: specifying `aria-labelledby`, `aria-hidden`, or `children` manually while using this prop may produce accessibility errors. This prop is only available on prebuilt icons within Constellation. |
| `onImpact` | `boolean` | `false` | Inverse colors for use on dark or colored backgrounds. |

