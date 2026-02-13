# ToggleButton

```tsx
import { ToggleButton } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.0.0

## Usage

```tsx
import { ToggleButton } from '@zillow/constellation';
```

```tsx
export const ToggleButtonBasic = () => <ToggleButton>Swimming Pool</ToggleButton>;
```

## Examples

### Toggle Button As Child

```tsx
import { ToggleButton } from '@zillow/constellation';
```

```tsx
export const ToggleButtonAsChild = () => (
  <ToggleButton asChild>
    <div>Get pre-qualified</div>
  </ToggleButton>
);
```

### Toggle Button Composable

```tsx
import { ToggleButton } from '@zillow/constellation';
```

```tsx
export const ToggleButtonComposable = () => (
  <ToggleButton.Root>
    <ToggleButton.Icon>
      <IconTextAlignLeftFilled />
    </ToggleButton.Icon>
    <ToggleButton.Label>Left Aligned</ToggleButton.Label>
  </ToggleButton.Root>
);
```

### Toggle Button Controlled

```tsx
import { ToggleButton } from '@zillow/constellation';
```

```tsx
export const ToggleButtonControlled = () => {
  const [selected, setSelected] = useState(true);
  return (
    <ToggleButton.Root
      selected={selected}
      onClick={() => setSelected(!selected)}
      size="sm"
      // oxlint-disable-next-line no-console
      onSelectedChange={(changed) => console.log(changed)}
    >
      <ToggleButton.Icon>
        <IconBikeFilled />
      </ToggleButton.Icon>
      <ToggleButton.Label>Bike Storage</ToggleButton.Label>
    </ToggleButton.Root>
  );
};
```

### Toggle Button Default Selected

```tsx
import { ToggleButton } from '@zillow/constellation';
```

```tsx
export const ToggleButtonDefaultSelected = () => (
  <ToggleButton defaultSelected>Center Aligned</ToggleButton>
);
```

### Toggle Button Disabled

```tsx
import { ToggleButton } from '@zillow/constellation';
```

```tsx
export const ToggleButtonDisabled = () => <ToggleButton disabled>Disabled</ToggleButton>;
```

### Toggle Button Loading

```tsx
import { ToggleButton } from '@zillow/constellation';
```

```tsx
export const ToggleButtonLoading = () => <ToggleButton loading>Swimming Pool</ToggleButton>;
```

### Toggle Button Sizes

```tsx
import { Box, ToggleButton } from '@zillow/constellation';
```

```tsx
export const ToggleButtonSizes = () => (
  <Box css={{ display: 'flex', gap: 'loose', alignItems: 'flex-start' }}>
    <ToggleButton size="sm">Small</ToggleButton>
    <ToggleButton size="md">Medium</ToggleButton>
    <ToggleButton size="lg">Large</ToggleButton>
  </Box>
);
```

### Toggle Button With Icon

```tsx
import { ToggleButton } from '@zillow/constellation';
```

```tsx
export const ToggleButtonWithIcon = () => (
  <ToggleButton icon={<IconHouseFilled />} iconPosition="start">
    Home Type
  </ToggleButton>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content **(required)** |
| `value` | `string` | — | Value of the toggle button. |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Set the button as disabled. |
| `size` | `'sm' \| 'md' \| 'lg'` | `sm` | The size of the toggle button. Can be inherited from a parent ToggleButtonGroup. |
| `onSelectedChange` | `(value: boolean) => void` | — | Event handler called when the selected state of the ToggleButton changes. |
| `defaultSelected` | `boolean` | — | Sets the [aria-pressed](https://www.w3.org/TR/wai-aria-1.1/#aria-pressed) state and use as an [uncontrolled component](https://reactjs.org/docs/uncontrolled-components.html).  A toggle button can use `selected` or `defaultSelected`, but not both. |
| `selected` | `boolean` | — | Sets the [aria-pressed](https://www.w3.org/TR/wai-aria-1.1/#aria-pressed) state and use as a [controlled component](https://reactjs.org/docs/forms.html#controlled-components).  A toggle button can use `selected` or `defaultSelected`, but not both. |
| `loading` | `boolean` | `false` | Add a loading spinner to the button. |
| `icon` | `ReactNode` | — | Add an Icon component to the button. |
| `iconPosition` | `'start' \| 'end'` | `start` | Change the position of the `icon`. |

### ToggleButtonIcon

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

### ToggleButtonLabel

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `color` | `never` | — |  |
| `css` | `SystemStyleObject` | — | Styles object |

### ToggleButtonLoading

**Element:** `HTMLSpanElement`

### ToggleButtonRoot

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content **(required)** |
| `value` | `string` | — | Value of the toggle button. |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Set the button as disabled. |
| `size` | `'sm' \| 'md' \| 'lg'` | `sm` | The size of the toggle button. Can be inherited from a parent ToggleButtonGroup. |
| `onSelectedChange` | `(value: boolean) => void` | — | Event handler called when the selected state of the ToggleButton changes. |
| `defaultSelected` | `boolean` | `memoDefaultSelected` | Sets the [aria-pressed](https://www.w3.org/TR/wai-aria-1.1/#aria-pressed) state and use as an [uncontrolled component](https://reactjs.org/docs/uncontrolled-components.html). A toggle button can use `selected` or `defaultSelected`, but not both. |
| `selected` | `boolean` | `memoPressed` | Sets the [aria-pressed](https://www.w3.org/TR/wai-aria-1.1/#aria-pressed) state and use as a [controlled component](https://reactjs.org/docs/forms.html#controlled-components). A toggle button can use `selected` or `defaultSelected`, but not both. |
| `loading` | `boolean` | `false` | Add a loading spinner to the button. |

