# FilterChip

```tsx
import { FilterChip } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.97.0

## Usage

```tsx
import { FilterChip } from '@zillow/constellation';
```

```tsx
export const FilterChipBasic = () => <FilterChip>Waterfront</FilterChip>;
```

## Examples

### Filter Chip Composed With Icon

```tsx
import { FilterChip } from '@zillow/constellation';
```

```tsx
export const FilterChipComposedWithIcon = () => (
  <FilterChip.Root>
    <FilterChip.Icon>
      <IconBeachFilled />
    </FilterChip.Icon>
    <FilterChip.Label>Air conditioning</FilterChip.Label>
  </FilterChip.Root>
);
```

### Filter Chip Controlled

```tsx
import { FilterChip } from '@zillow/constellation';
```

```tsx
export const FilterChipControlled = () => {
  const [selected, setSelected] = useState(true);
  return (
    <FilterChip.Root selected={selected} onClick={() => setSelected(!selected)}>
      <FilterChip.Icon>
        <IconBeachFilled />
      </FilterChip.Icon>
      <FilterChip.Label>Air conditioning</FilterChip.Label>
    </FilterChip.Root>
  );
};
```

### Filter Chip Default Selected

```tsx
import { FilterChip } from '@zillow/constellation';
```

```tsx
export const FilterChipDefaultSelected = () => (
  <FilterChip defaultSelected>Air conditioning</FilterChip>
);
```

### Filter Chip Disabled And Selected

```tsx
import { FilterChip } from '@zillow/constellation';
```

```tsx
export const FilterChipDisabledAndSelected = () => (
  <FilterChip disabled selected>
    Waterfront
  </FilterChip>
);
```

### Filter Chip Disabled

```tsx
import { FilterChip } from '@zillow/constellation';
```

```tsx
export const FilterChipDisabled = () => <FilterChip disabled>Waterfront</FilterChip>;
```

### Filter Chip Text Truncation Off

```tsx
import { Box, FilterChip } from '@zillow/constellation';
```

```tsx
export const FilterChipTextTruncationOff = () => (
  <Box
    css={{
      border: '1px dashed red',
      display: 'flex',
      flexDirection: 'column',
      gap: 'xs',
      maxWidth: '200px',
      padding: 'xs',
    }}
  >
    <FilterChip icon={<IconBeachFilled />}>Chip with truncation turned on</FilterChip>
    <FilterChip icon={<IconBeachFilled />} truncate={false}>
      Chip with truncation turned off
    </FilterChip>
    <FilterChip.Root>
      <FilterChip.Icon>
        <IconBeachFilled />
      </FilterChip.Icon>
      <FilterChip.Label truncate={false}>Composed Chip with truncation turned off</FilterChip.Label>
    </FilterChip.Root>
  </Box>
);
```

### Filter Chip With Elevation

```tsx
import { FilterChip } from '@zillow/constellation';
```

```tsx
export const FilterChipWithElevation = () => <FilterChip elevated>Waterfront</FilterChip>;
```

### Filter Chip With Icon

```tsx
import { FilterChip } from '@zillow/constellation';
```

```tsx
export const FilterChipWithIcon = () => (
  <FilterChip icon={<IconBeachFilled />}>Waterfront</FilterChip>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `elevated` | `boolean` | `false` | When true, adds a drop shadow. Useful for making the filter chip easier to see on certain backgrounds (ex: on top of a photo or map) |
| `value` | `string` | — | Value of the filter chip. |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Sets the filter chip as disabled. |
| `onSelectedChange` | `(value: boolean) => void` | — | Event handler called when the selected state of the FilterChip changes. |
| `defaultSelected` | `boolean` | — | Sets the [aria-pressed](https://www.w3.org/TR/wai-aria-1.1/#aria-pressed) state and use as an [uncontrolled component](https://reactjs.org/docs/uncontrolled-components.html).  A filter chip can use `selected` or `defaultSelected`, but not both. |
| `selected` | `boolean` | — | Sets the [aria-pressed](https://www.w3.org/TR/wai-aria-1.1/#aria-pressed) state and use as a [controlled component](https://reactjs.org/docs/forms.html#controlled-components).  A filter chip can use `selected` or `defaultSelected`, but not both. |
| `children` | `string` | — | The filter chip’s text label. **(required)** |
| `icon` | `ReactNode` | — | Adds a leading icon. Takes an `Icon` component but ignores its `size` prop (i.e. the icon size is fixed). |
| `truncate` | `boolean` | — | When true, label text truncates to one line with ellipsis. |

### FilterChipIcon

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

### FilterChipLabel

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `string` | — | The filter chip’s text label. Must be a string. **(required)** |
| `color` | `never` | — |  |
| `css` | `SystemStyleObject` | — | Styles object |
| `truncate` | `boolean` | `true` | When true, label text truncates to one line with ellipsis. |

### FilterChipRoot

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | The filter chip’s text label. To add decorators, use the `icon` and `avatar` props. **(required)** |
| `elevated` | `boolean` | `false` | When true, adds a drop shadow. Useful for making the filter chip easier to see on certain backgrounds (ex: on top of a photo or map) |
| `value` | `string` | — | Value of the filter chip. |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Sets the filter chip as disabled. |
| `onSelectedChange` | `(value: boolean) => void` | — | Event handler called when the selected state of the FilterChip changes. |
| `defaultSelected` | `boolean` | — | Sets the [aria-pressed](https://www.w3.org/TR/wai-aria-1.1/#aria-pressed) state and use as an [uncontrolled component](https://reactjs.org/docs/uncontrolled-components.html). A filter chip can use `selected` or `defaultSelected`, but not both. |
| `selected` | `boolean` | — | Sets the [aria-pressed](https://www.w3.org/TR/wai-aria-1.1/#aria-pressed) state and use as a [controlled component](https://reactjs.org/docs/forms.html#controlled-components). A filter chip can use `selected` or `defaultSelected`, but not both. |

