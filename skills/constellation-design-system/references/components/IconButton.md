# IconButton

```tsx
import { IconButton } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.42.0

## Usage

```tsx
import { Icon, IconButton } from '@zillow/constellation';
```

```tsx
export const IconButtonBasic = () => (
  <IconButton title="Right" tone="neutral" emphasis="outlined" size="md" shape="square">
    <Icon>
      <IconChevronRightFilled />
    </Icon>
  </IconButton>
);
```

## Examples

### Icon Button Brand Bare On Impact

```tsx
import { Icon, IconButton } from '@zillow/constellation';
```

```tsx
export const IconButtonBrandBareOnImpact = () => (
  <IconButton title="Right" tone="neutral" emphasis="outlined" size="md" shape="square" onImpact>
    <Icon>
      <IconChevronRightFilled />
    </Icon>
  </IconButton>
);
```

### Icon Button Brand Bare

```tsx
import { Icon, IconButton } from '@zillow/constellation';
```

```tsx
export const IconButtonBrandBare = () => (
  <IconButton title="Right" tone="brand" emphasis="bare" size="md" shape="square">
    <Icon>
      <IconChevronRightFilled />
    </Icon>
  </IconButton>
);
```

### Icon Button Brand Filled

```tsx
import { Icon, IconButton } from '@zillow/constellation';
```

```tsx
export const IconButtonBrandFilled = () => (
  <IconButton title="Right" tone="brand" emphasis="filled" size="md" shape="square">
    <Icon>
      <IconChevronRightFilled />
    </Icon>
  </IconButton>
);
```

### Icon Button Brand On Impact

```tsx
import { Icon, IconButton } from '@zillow/constellation';
```

```tsx
export const IconButtonBrandOnImpact = () => (
  <IconButton title="Right" tone="brand" emphasis="filled" size="md" shape="square" onImpact>
    <Icon>
      <IconChevronRightFilled />
    </Icon>
  </IconButton>
);
```

### Icon Button Brand Outlined

```tsx
import { Icon, IconButton } from '@zillow/constellation';
```

```tsx
export const IconButtonBrandOutlined = () => (
  <IconButton title="Right" tone="brand" emphasis="outlined" size="md" shape="square">
    <Icon>
      <IconChevronRightFilled />
    </Icon>
  </IconButton>
);
```

### Icon Button Critical Filled

```tsx
import { Icon, IconButton } from '@zillow/constellation';
```

```tsx
export const IconButtonCriticalFilled = () => (
  <IconButton title="Right" tone="critical" emphasis="filled" size="md" shape="square">
    <Icon>
      <IconChevronRightFilled />
    </Icon>
  </IconButton>
);
```

### Icon Button Icon Prop

```tsx
import { IconButton } from '@zillow/constellation';
```

```tsx
export const IconButtonIconProp = () => (
  <IconButton
    title="Right"
    icon={<IconAwardRibbonOutline />}
    tone="neutral"
    emphasis="outlined"
    size="md"
    shape="square"
  />
);
```

### Icon Button Neutral Bare On Impact

```tsx
import { Icon, IconButton } from '@zillow/constellation';
```

```tsx
export const IconButtonNeutralBareOnImpact = () => (
  <IconButton title="Right" tone="neutral" emphasis="bare" size="md" shape="square" onImpact>
    <Icon>
      <IconChevronRightFilled />
    </Icon>
  </IconButton>
);
```

### Icon Button Neutral Bare

```tsx
import { Icon, IconButton } from '@zillow/constellation';
```

```tsx
export const IconButtonNeutralBare = () => (
  <IconButton title="Right" tone="neutral" emphasis="bare" size="md" shape="square">
    <Icon>
      <IconChevronRightFilled />
    </Icon>
  </IconButton>
);
```

### Icon Button Neutral Outlined

```tsx
import { Icon, IconButton } from '@zillow/constellation';
```

```tsx
export const IconButtonNeutralOutlined = () => (
  <IconButton title="Right" tone="neutral" emphasis="outlined" size="md" shape="square">
    <Icon>
      <IconChevronRightFilled />
    </Icon>
  </IconButton>
);
```

### Icon Button Polymorphic

```tsx
import { Icon, IconButton } from '@zillow/constellation';
```

```tsx
export const IconButtonPolymorphic = () => (
  <IconButton asChild title="Right" disabled>
    <a href="https://www.zillow.com">
      <Icon>
        <IconChevronRightFilled />
      </Icon>
    </a>
  </IconButton>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `tone` | `'brand' \| 'neutral' \| 'neutral-fixed' \| 'critical'` | `brand` | Tone of the button Can be inherited from a parent ButtonGroup. |
| `emphasis` | `'filled' \| 'outlined' \| 'bare'` | `filled` | Button emphasis |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Set the button as disabled. |
| `icon` | `ReactNode` | — | Add an icon via a prop vs children. If both the `icon` prop and `children` are passed, `children` will take priority and `icon` prop will be ignored. |
| `onImpact` | `boolean` | `false` | Inverse colors for use on dark or colored backgrounds. |
| `shape` | `'circle' \| 'square'` | `square` | Dictates the shape of the button |
| `size` | `'xs' \| 'sm' \| 'md' \| 'lg'` | `md` | The size of the button, not the icon in the button. The size of the icon cannot be changed. Can be inherited from a parent ButtonGroup. |
| `tabIndex` | `number` | — | The tabIndex of the button. |
| `title` | `string` | — | Accessible text of the button **(required)** |
| `type` | `ComponentProps<'button'>['type']` | `button` | The type of the button. |

