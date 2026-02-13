# ButtonGroup

```tsx
import { ButtonGroup } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 5.0.0

## Usage

```tsx
import { Button, ButtonGroup, TextButton } from '@zillow/constellation';
```

```tsx
export const ButtonGroupBasic = () => (
  <ButtonGroup aria-label="Storybook Example">
    <Button tone="brand" emphasis="filled">
      Primary
    </Button>
    <Button tone="brand" emphasis="outlined">
      Secondary
    </Button>
    <Button tone="neutral" emphasis="outlined">
      Tertiary
    </Button>
    <Button tone="critical" emphasis="filled">
      Critical
    </Button>
    <TextButton>Text</TextButton>
  </ButtonGroup>
);
```

## Examples

### Button Group Conjoined Horizontal

```tsx
import { Button, ButtonGroup } from '@zillow/constellation';
```

```tsx
export const ButtonGroupConjoinedHorizontal = () => (
  <ButtonGroup aria-label="Storybook Example" conjoined>
    <Button>First</Button>
    <Button>Middle</Button>
    <Button>Middle</Button>
    <Button>Last</Button>
  </ButtonGroup>
);
```

### Button Group Conjoined Vertical

```tsx
import { Button, ButtonGroup } from '@zillow/constellation';
```

```tsx
export const ButtonGroupConjoinedVertical = () => (
  <ButtonGroup aria-label="Storybook Example" conjoined orientation="vertical">
    <Button>First</Button>
    <Button>Middle</Button>
    <Button>Middle</Button>
    <Button>Last</Button>
  </ButtonGroup>
);
```

### Button Group Fluid

```tsx
import { Button, ButtonGroup } from '@zillow/constellation';
```

```tsx
export const ButtonGroupFluid = () => (
  <ButtonGroup aria-label="Storybook Example" fluid>
    <Button tone="brand" emphasis="filled">
      Brand Filled
    </Button>
    <Button tone="brand" emphasis="outlined">
      Brand Outlined
    </Button>
  </ButtonGroup>
);
```

### Button Group On Impact

```tsx
import { Button, ButtonGroup } from '@zillow/constellation';
```

```tsx
export const ButtonGroupOnImpact = () => (
  <ButtonGroup aria-label="Storybook Example" fluid>
    <Button tone="brand" emphasis="filled" onImpact>
      Brand Filled On Impact
    </Button>
    <Button tone="neutral" emphasis="outlined" onImpact>
      Neutral Outlined On Impact
    </Button>
  </ButtonGroup>
);
```

### Button Group Responsive

```tsx
import { Button, ButtonGroup } from '@zillow/constellation';
```

```tsx
export const ButtonGroupResponsive = () => (
  <ButtonGroup
    aria-label="Storybook Example"
    orientation={{ base: 'vertical', lg: 'horizontal' }}
    reverse={{ base: false, lg: true }}
  >
    <Button>First</Button>
    <Button>Middle</Button>
    <Button>Middle</Button>
    <Button>Last</Button>
  </ButtonGroup>
);
```

### Button Group Vertical

```tsx
import { Button, ButtonGroup, TextButton } from '@zillow/constellation';
```

```tsx
export const ButtonGroupVertical = () => (
  <ButtonGroup aria-label="Storybook Example" orientation="vertical">
    <Button tone="brand" emphasis="filled">
      Brand Filled
    </Button>
    <Button tone="brand" emphasis="outlined">
      Brand Outlined
    </Button>
    <Button tone="neutral" emphasis="outlined">
      Neutral Outlined
    </Button>
    <Button tone="critical" emphasis="filled">
      Critical Filled
    </Button>
    <TextButton>Text</TextButton>
  </ButtonGroup>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'aria-label'` | `AriaAttributes['aria-label']` | — | An [aria-label](https://www.w3.org/TR/wai-aria-1.2/#aria-label) is required for assistive technologies to announce the button group properly. **(required)** |
| `'asChild'` | `boolean` | — | Use child as the root element |
| `'tone'` | `'brand' \| 'neutral' \| 'critical'` | `brand` | Tone of the button |
| `'emphasis'` | `'filled' \| 'outlined'` | `filled` | Button emphasis |
| `'children'` | `ReactNode` | — | Content **(required)** |
| `'conjoined'` | `boolean` | `false` | Connect the buttons by removing the space between buttons in the group. In general, you will only want to do this with buttons of the same type. You can use `tone + emphasis` to set the type to be the same for all buttons. |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'fluid'` | `ResponsiveVariant<boolean>` | `false` | Fluid buttons will take up all horizontal space. |
| `'direction'` | `never` | — |  |
| `'orientation'` | `ResponsiveVariant<'horizontal' \| 'vertical'>` | `horizontal` | The direction in which the buttons should be aligned. Buttons will be fluid when the direction is set to `vertical`. |
| `'reverse'` | `ResponsiveVariant<boolean>` | `false` | Reverse the button order. |
| `'role'` | `AriaRole` | `group` | Sets the `role` of the button group. By default, this is set to ["group"](https://www.w3.org/TR/wai-aria-1.2/#group), but "toolbar" might be more appropriate if the button group is used in a toolbar. |
| `'size'` | `'sm' \| 'md' \| 'lg'` | `md` | Set the same button size on all children. |

