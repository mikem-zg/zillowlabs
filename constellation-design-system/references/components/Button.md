# Button

```tsx
import { Button } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 1.0.5

## Usage

```tsx
import { Button } from '@zillow/constellation';
```

```tsx
export const ButtonBasic = () => <Button>Contact agent</Button>;
```

## Examples

### Button As Anchor

```tsx
import { Button } from '@zillow/constellation';
```

```tsx
export const ButtonAsAnchor = () => (
  <Button asChild>
    <a href="https://www.zillow.com">Get pre-qualified</a>
  </Button>
);
```

### Button As Disabled Anchor

```tsx
import { Button } from '@zillow/constellation';
```

```tsx
export const ButtonAsDisabledAnchor = () => (
  <Button asChild disabled>
    <a href="https://www.zillow.com">Read all reviews</a>
  </Button>
);
```

### Button Composable

```tsx
import { Button } from '@zillow/constellation';
```

```tsx
export const ButtonComposable = () => (
  <Button.Root>
    <Button.Icon>
      <IconCalculatorFilled />
    </Button.Icon>
    <Button.Label>Calculate now</Button.Label>
  </Button.Root>
);
```

### Button Disabled

```tsx
import { Button } from '@zillow/constellation';
```

```tsx
export const ButtonDisabled = () => <Button disabled>Submit</Button>;
```

### Button Loading As Anchor

```tsx
import { Button } from '@zillow/constellation';
```

```tsx
export const ButtonLoadingAsAnchor = () => (
  <Button asChild loading>
    <a href="https://www.zillow.com">Get pre-qualified</a>
  </Button>
);
```

### Button Loading Fluid

```tsx
import { Button } from '@zillow/constellation';
```

```tsx
export const ButtonLoadingFluid = () => (
  <Button loading fluid>
    Get pre-qualified
  </Button>
);
```

### Button Loading On Impact

```tsx
import { Box, Button } from '@zillow/constellation';
```

```tsx
export const ButtonLoadingOnImpact = () => (
  <Box css={{ display: 'flex', gap: 'loose' }}>
    <Button icon={<IconClockFilled />} loading onImpact tone="brand" emphasis="filled">
      Reserve a tour
    </Button>
    <Button icon={<IconClockFilled />} loading onImpact tone="neutral" emphasis="outlined">
      Reserve a tour
    </Button>
  </Box>
);
```

### Button Loading

```tsx
import { Box, Button } from '@zillow/constellation';
```

```tsx
export const ButtonLoading = () => (
  <Box css={{ display: 'flex', gap: 'loose', flexWrap: 'wrap' }}>
    <Button loading tone="brand" emphasis="filled">
      Calculate now
    </Button>
    <Button loading tone="brand" emphasis="outlined">
      Calculate now
    </Button>
    <Button loading tone="neutral" emphasis="outlined">
      Calculate now
    </Button>
    <Button loading tone="critical" emphasis="filled">
      Calculate now
    </Button>
  </Box>
);
```

### Button On Impact

```tsx
import { Box, Button } from '@zillow/constellation';
```

```tsx
export const ButtonOnImpact = () => (
  <Box css={{ display: 'flex', gap: 'loose', flexWrap: 'wrap' }}>
    <Button onImpact tone="brand" emphasis="outlined">
      Outlined brand onImpact
    </Button>
    <Button onImpact tone="critical" emphasis="filled">
      Filled critical onImpact
    </Button>
    <Button onImpact tone="critical" emphasis="outlined">
      Outlined critical onImpact
    </Button>
    <Button onImpact tone="neutral-fixed" emphasis="filled">
      Filled neutral fixed onImpact
    </Button>
    <Button onImpact tone="neutral-fixed" emphasis="outlined">
      Outlined neutral fixed onImpact
    </Button>
  </Box>
);
```

### Button Variants

```tsx
import { Box, Button } from '@zillow/constellation';
```

```tsx
export const ButtonVariants = () => (
  <Box css={{ display: 'flex', gap: 'loose', flexWrap: 'wrap' }}>
    <Button tone="brand" emphasis="outlined">
      Outlined brand
    </Button>
    <Button tone="brand" emphasis="filled">
      Filled brand
    </Button>
    <Button tone="critical" emphasis="filled">
      Filled critical
    </Button>
    <Button tone="critical" emphasis="outlined">
      Outlined critical
    </Button>
    <Button tone="neutral" emphasis="outlined">
      Outlined neutral
    </Button>
    <Button tone="neutral-fixed" emphasis="outlined">
      Outlined neutral fixed
    </Button>
  </Box>
);
```

### Button With Icon

```tsx
import { Button } from '@zillow/constellation';
```

```tsx
export const ButtonWithIcon = () => (
  <Button icon={<IconClockFilled />} iconPosition="start">
    Reserve a tour
  </Button>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `tone` | `'brand' \| 'neutral' \| 'neutral-fixed' \| 'critical'` | `brand` | Tone of the button |
| `emphasis` | `'filled' \| 'outlined'` | `outlined` | Button emphasis |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Set the button as disabled. |
| `fluid` | `ResponsiveVariant<boolean>` | `false` | A fluid button will take up all horizontal space. |
| `onImpact` | `boolean` | `false` | On Impact colors for use on dark or colored backgrounds. On Impact styling is only available for 'filled + brand' and 'outlined + neutral' button types |
| `size` | `'sm' \| 'md' \| 'lg'` | `md` | The size of the button. Can be inherited from a parent ButtonGroup. |
| `loading` | `boolean` | `false` | Add a loading spinner to the button. |
| `type` | `ComponentProps<'button'>['type']` | `button` | The type of the button. |
| `icon` | `ReactNode` | — | Add an Icon component to the button. |
| `iconPosition` | `'start' \| 'end'` | `start` | Change the position of the `icon`. |

### ButtonIcon

**Element:** `SVGSVGElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | The SVG icon to render. |
| `css` | `SystemStyleObject` | — | Styles object |
| `focusable` | `ComponentProps<'svg'>['focusable']` | `false` | The SVG [`focusable`](https://www.w3.org/TR/SVGTiny12/interact.html#focusable-attr) attribute. |
| `role` | `AriaRole` | `img` | The role is set to "img" by default to exclude all child content from the accessibility tree. |
| `size` | `ResponsiveVariant<'sm' \| 'md' \| 'lg' \| 'xl'>` | — | By default, icons are sized to `1em` to match the size of the text content. For fixed-width sizes, you can use the `size` prop. |
| `render` | `ReactNode` | — | Alternative to children. |
| `title` | `string` | — | Creates an accessible label for the icon for contextually meaninful icons, and sets the appropriate `aria` attributes. Icons are hidden from screen readers by default without this prop.  Note: specifying `aria-labelledby`, `aria-hidden`, or `children` manually while using this prop may produce accessibility errors. This prop is only available on prebuilt icons within Constellation. |

### ButtonLabel

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `color` | `never` | — |  |
| `css` | `SystemStyleObject` | — | Styles object |

### ButtonLoading

**Element:** `HTMLSpanElement`

### ButtonRoot

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `tone` | `'brand' \| 'neutral' \| 'neutral-fixed' \| 'critical'` | `brand` | Tone of the button |
| `emphasis` | `'filled' \| 'outlined'` | `outlined` | Button emphasis |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Set the button as disabled. |
| `fluid` | `ResponsiveVariant<boolean>` | `false` | A fluid button will take up all horizontal space. |
| `onImpact` | `boolean` | `false` | On Impact colors for use on dark or colored backgrounds. On Impact styling is only available for 'filled + brand' and 'outlined + neutral' button types |
| `size` | `'sm' \| 'md' \| 'lg'` | `md` | The size of the button. Can be inherited from a parent ButtonGroup. |
| `loading` | `boolean` | `false` | Add a loading spinner to the button. |
| `type` | `ComponentProps<'button'>['type']` | `button` | The type of the button. |

