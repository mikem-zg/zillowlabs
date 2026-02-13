# Text

```tsx
import { Text } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 6.0.0

## Usage

```tsx
import { Text } from '@zillow/constellation';
```

```tsx
export const TextBasic = () => (
  <Text color="text.neutral" textStyle="body">
    Lorem ipsum dolor sit amet, consectetur adipiscing elit.
  </Text>
);
```

## Examples

### Text As Semantic Elements

```tsx
import { Text } from '@zillow/constellation';
```

```tsx
export const TextAsSemanticElements = () => (
  <>
    <Text color="text.neutral" textStyle="body" asChild>
      <strong>strong</strong>
    </Text>
    <br />
    <Text color="text.neutral" textStyle="body" asChild>
      <b>b</b>
    </Text>
    <br />
    <Text color="text.neutral" textStyle="body" asChild>
      <em>em</em>
    </Text>
    <br />
    <Text color="text.neutral" textStyle="body" asChild>
      <i>i</i>
    </Text>
    <br />
    <Text color="text.neutral" textStyle="heading-sm" asChild>
      <strong>strong</strong>
    </Text>
    <br />
    <Text color="text.neutral" textStyle="heading-sm" asChild>
      <b>b</b>
    </Text>
    <br />
    <Text color="text.neutral" textStyle="heading-sm" asChild>
      <em>em</em>
    </Text>
    <br />
    <Text color="text.neutral" textStyle="heading-sm" asChild>
      <i>i</i>
    </Text>
  </>
);
```

### Text Responsive Built In

```tsx
import { Text } from '@zillow/constellation';
```

```tsx
export const TextResponsiveBuiltIn = () => (
  <Text color="text.neutral" textStyle="responsive.heading-lg">
    Constellation Design System
  </Text>
);
```

### Text With Icon

```tsx
import { Icon, Text } from '@zillow/constellation';
```

```tsx
export const TextWithIcon = () => (
  <Text color="text.neutral" textStyle="body">
    <Icon>
      <IconBedroomFilled />
    </Icon>{' '}
    3 Bedrooms
  </Text>
);
```

### Text With Semantic Elements

```tsx
import { Text } from '@zillow/constellation';
```

```tsx
export const TextWithSemanticElements = () => (
  <Text color="text.neutral" textStyle="body">
    Lorem <strong>ipsum</strong> dolor <em>sit</em> amet, <b>consectetur</b> adipiscing <i>elit</i>.
  </Text>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content **(required)** |
| `color` | `\| 'text.invisible'     \| 'text.neutral'     \| 'text.neutral-fixed'     \| 'text.subtle'     \| 'transparent'     \| 'brand'     \| 'brandSecondary'     \| 'textWhite'     \| 'textLight'     \| 'textMedium'     \| 'textDark'` | `body` | The text color |
| `css` | `SystemStyleObject` | — | Styles object |
| `fontColor` | `never` | — |  |
| `fontType` | `never` | — |  |
| `textStyle` | `\| 'heading-xl'     \| 'heading-lg'     \| 'heading-md'     \| 'heading-sm'     \| 'heading-xs'     \| 'body-lg'     \| 'body-lg-bold'     \| 'body'     \| 'body-bold'     \| 'body-sm'     \| 'body-sm-bold'     \| 'body-xs'     \| 'body-xs-bold'     \| 'fineprint'     \| 'fineprint-bold'     \| 'fineprint-sm'     \| 'fineprint-sm-bold'     \| 'responsive.heading-xl'     \| 'responsive.heading-lg'     \| 'responsive.heading-md'     \| 'responsive.heading-sm'     \| 'responsive.heading-xs'     \| 'responsive.body-lg'     \| 'responsive.body-lg-bold'` | `body` | The text style, it determines the size, weight, and line-height. Text styles prefixed with `responsive`, will include responsive typography already provided. |

