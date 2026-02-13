# TextButton

```tsx
import { TextButton } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 5.0.0

## Usage

```tsx
import { TextButton } from '@zillow/constellation';
```

```tsx
export const TextButtonBasic = () => (
  <TextButton tone="brand" textStyle="body-bold" title="Fancy text button title">
    Lorem ipsum
  </TextButton>
);
```

## Examples

### Text Button As Anchor Element

```tsx
import { TextButton } from '@zillow/constellation';
```

```tsx
export const TextButtonAsAnchorElement = () => (
  <TextButton tone="brand" textStyle="body-bold" icon={<IconChevronLeftOutline />} asChild>
    <a href="http://www.zillow.com" target="_blank" rel="noreferrer">
      Zillow
    </a>
  </TextButton>
);
```

### Text Button Composable

```tsx
import { TextButton } from '@zillow/constellation';
```

```tsx
export const TextButtonComposable = () => (
  <TextButton.Root tone="brand" textStyle="body-bold">
    <TextButton.Label>Lorem ipsum</TextButton.Label>
    <TextButton.Icon>
      <IconChevronRightOutline />
    </TextButton.Icon>
  </TextButton.Root>
);
```

### Text Button Disabled

```tsx
import { TextButton } from '@zillow/constellation';
```

```tsx
export const TextButtonDisabled = () => (
  <TextButton tone="brand" textStyle="body-bold" disabled>
    Lorem ipsum
  </TextButton>
);
```

### Text Button On Impact

```tsx
import { Box, TextButton } from '@zillow/constellation';
```

```tsx
export const TextButtonOnImpact = () => (
  <Box css={{ display: 'flex', gap: 'loose', flexWrap: 'wrap' }}>
    <TextButton onImpact tone="neutral" textStyle="body-bold">
      Neutral onImpact
    </TextButton>
    <TextButton onImpact tone="brand" textStyle="body-bold">
      Brand onImpact
    </TextButton>
    <TextButton onImpact tone="critical" textStyle="body-bold">
      Critical onImpact
    </TextButton>
  </Box>
);
```

### Text Button Variants

```tsx
import { Box, TextButton } from '@zillow/constellation';
```

```tsx
export const TextButtonVariants = () => (
  <Box css={{ display: 'flex', gap: 'loose', flexWrap: 'wrap' }}>
    <TextButton tone="brand" textStyle="body-bold">
      Brand
    </TextButton>
    <TextButton tone="neutral" textStyle="body-bold">
      Neutral
    </TextButton>
    <TextButton tone="neutral-fixed" textStyle="body-bold">
      Neutral fixed
    </TextButton>
    <TextButton tone="critical" textStyle="body-bold">
      Critical
    </TextButton>
    <TextButton tone="subtle" textStyle="body-bold">
      Subtle
    </TextButton>
  </Box>
);
```

### Text Button With Icon

```tsx
import { TextButton } from '@zillow/constellation';
```

```tsx
export const TextButtonWithIcon = () => (
  <TextButton tone="brand" textStyle="body-bold" icon={<IconChevronLeftOutline />}>
    Lorem ipsum
  </TextButton>
);
```

### Text Button With Smaller Text

```tsx
import { TextButton } from '@zillow/constellation';
```

```tsx
export const TextButtonWithSmallerText = () => (
  <TextButton tone="brand" textStyle="body-sm-bold" icon={<IconChevronLeftOutline />}>
    Lorem ipsum
  </TextButton>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `tone` | `'brand' \| 'neutral' \| 'neutral-fixed' \| 'critical' \| 'subtle'` | `brand` | The type of button. |
| `children` | `ReactNode` | — | Content. **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Set the button as disabled. |
| `onImpact` | `boolean` | `false` | For use on dark or colored backgrounds. |
| `size` | `'sm' \| 'md' \| 'lg'` | — | Size of the button  This is not an exposed API property. It is inherited from a parent `ButtonGroup`. |
| `textStyle` | `'body' \| 'body-bold' \| 'body-sm' \| 'body-sm-bold'` | `body-bold` | Determines the font used for the label and affects icon size. Limited to `body`, `body-bold`, `body-sm`, and `body-sm-bold`. |
| `type` | `ComponentProps<'button'>['type']` | `button` | The type of the button. |
| `fontType` | `never` | — | Removed in v10. Please use `textStyle` prop |
| `icon` | `ReactNode` | — | Add an `Icon` to the button. |
| `iconPosition` | `'start' \| 'end'` | `start` | Change the position of the `icon`. |

### TextButtonIcon

**Element:** `SVGSVGElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `size` | `'sm' \| 'md'` | — | The size of the icon. If the shorthand `TextButton` component is used, the icon size is determined by `textStyle`. |

### TextButtonLabel

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Text button content. **(required)** |
| `color` | `never` | — |  |
| `css` | `SystemStyleObject` | — | Styles object |
| `textStyle` | `'body' \| 'body-bold' \| 'body-sm' \| 'body-sm-bold'` | — | Determines the font used for the label. Limited to `body`, `body-bold`, `body-sm`, and `body-sm-bold`. |

### TextButtonRoot

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `tone` | `'brand' \| 'neutral' \| 'neutral-fixed' \| 'critical' \| 'subtle'` | `brand` | The type of button. |
| `children` | `ReactNode` | — | Content. **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Set the button as disabled. |
| `onImpact` | `boolean` | `false` | For use on dark or colored backgrounds. |
| `size` | `'sm' \| 'md' \| 'lg'` | — | Size of the button This is not an exposed API property. It is inherited from a parent `ButtonGroup`. |
| `textStyle` | `'body' \| 'body-bold' \| 'body-sm' \| 'body-sm-bold'` | `body-bold` | Determines the font used for the label and affects icon size. Limited to `body`, `body-bold`, `body-sm`, and `body-sm-bold`. |
| `type` | `ComponentProps<'button'>['type']` | `button` | The type of the button. |

