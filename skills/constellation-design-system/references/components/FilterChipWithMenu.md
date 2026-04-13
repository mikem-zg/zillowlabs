# FilterChipWithMenu

A filter chip that renders a native `<select>` dropdown menu. When the user picks a non-empty option the chip toggles into a "selected" visual state. It supports both controlled and uncontrolled usage, leading icons, option groups, elevated/disabled states, and a compound (composed) API for advanced layouts.

## Import

```tsx
import { FilterChipWithMenu } from '@zillow/constellation';
```

## Props

### FilterChipWithMenu (shorthand)

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | `<option>` and `<optgroup>` elements for the dropdown menu |
| `icon` | `ReactNode` | — | Leading icon. Accepts an `Icon` component; its `size` prop is ignored (size is fixed) |
| `defaultValue` | `string \| number` | — | Default selected option value (uncontrolled) |
| `value` | `string \| number` | — | Selected option value (controlled) |
| `onChange` | `(e: ChangeEvent<HTMLSelectElement>) => void` | — | Callback fired when the selected option changes |
| `disabled` | `boolean` | `false` | Renders the chip in a disabled state |
| `elevated` | `boolean` | `false` | Adds a drop shadow (useful over photos or maps) |
| `labelVoiceOver` | `string` | `"filter"` | Screen-reader label announced on focus/change. Rendered as visually hidden text |
| `css` | `SystemStyleObject` | — | Panda CSS style overrides |

### Sub-components (composed API)

| Component | Renders | Description |
|-----------|---------|-------------|
| `FilterChipWithMenu.Root` | `<label>` | Wrapper that provides context. Accepts all root-level props (`disabled`, `elevated`, `value`, `defaultValue`, `onChange`, `labelVoiceOver`, `css`) |
| `FilterChipWithMenu.Icon` | `<svg>` | Renders a leading icon inside the chip |
| `FilterChipWithMenu.Select` | `<select>` | The native select element. Accepts `<option>` / `<optgroup>` children and an optional `disabled` prop |

## Basic Usage

```tsx
<FilterChipWithMenu>
  <option value="">Foundation type</option>
  <option value="concrete">Concrete slab</option>
  <option value="pier">Pier and beam</option>
  <option value="wood">Wood</option>
</FilterChipWithMenu>
```

## Variants

### Default Value (Uncontrolled)

```tsx
<FilterChipWithMenu defaultValue="pier">
  <option value="">Foundation type</option>
  <option value="concrete">Concrete slab</option>
  <option value="pier">Pier and beam</option>
  <option value="wood">Wood</option>
</FilterChipWithMenu>
```

### Controlled

```tsx
const [val, setVal] = useState('');

<FilterChipWithMenu value={val} onChange={(e) => setVal(e.target.value)}>
  <option value="">Foundation type</option>
  <option value="concrete">Concrete slab</option>
  <option value="pier">Pier and beam</option>
  <option value="wood">Wood</option>
</FilterChipWithMenu>
```

### With Icon

```tsx
import { IconBlueprintFilled } from '@zillow/constellation-icons';

<FilterChipWithMenu icon={<IconBlueprintFilled />}>
  <option value="">Foundation type</option>
  <option value="concrete">Concrete slab</option>
  <option value="pier">Pier and beam</option>
  <option value="wood">Wood</option>
</FilterChipWithMenu>
```

### Elevated

```tsx
<FilterChipWithMenu elevated>
  <option value="">Foundation type</option>
  <option value="concrete">Concrete slab</option>
  <option value="pier">Pier and beam</option>
  <option value="wood">Wood</option>
</FilterChipWithMenu>
```

### Disabled

```tsx
<FilterChipWithMenu disabled>
  <option value="">Foundation type</option>
  <option value="concrete">Concrete slab</option>
  <option value="pier">Pier and beam</option>
  <option value="wood">Wood</option>
</FilterChipWithMenu>
```

### Option Groups

```tsx
<FilterChipWithMenu>
  <option value="">Choose one</option>
  <optgroup label="Letters">
    <option value="a">A</option>
    <option value="b">B</option>
  </optgroup>
  <optgroup label="Numbers">
    <option value="1">1</option>
    <option value="2">2</option>
  </optgroup>
</FilterChipWithMenu>
```

### Composed API

Use sub-components for fine-grained control over the chip layout:

```tsx
import { IconBlueprintFilled } from '@zillow/constellation-icons';

<FilterChipWithMenu.Root>
  <FilterChipWithMenu.Icon>
    <IconBlueprintFilled />
  </FilterChipWithMenu.Icon>
  <FilterChipWithMenu.Select>
    <option value="">Foundation type</option>
    <option value="concrete">Concrete slab</option>
    <option value="pier">Pier and beam</option>
    <option value="wood">Wood</option>
  </FilterChipWithMenu.Select>
</FilterChipWithMenu.Root>
```

### Composed + Controlled

```tsx
const [val, setVal] = useState('pier');

<FilterChipWithMenu.Root
  value={val}
  onChange={(e) => setVal(e.target.value)}
>
  <FilterChipWithMenu.Icon>
    <IconBlueprintFilled />
  </FilterChipWithMenu.Icon>
  <FilterChipWithMenu.Select>
    <option value="">Foundation type</option>
    <option value="concrete">Concrete slab</option>
    <option value="pier">Pier and beam</option>
    <option value="wood">Wood</option>
  </FilterChipWithMenu.Select>
</FilterChipWithMenu.Root>
```

## Related Components

- **FilterChip** — A simpler toggle chip without a dropdown menu; used for boolean filter selections
- **ChipGroup** — Groups multiple chips (FilterChip, FilterChipWithMenu, AssistChip, InputChip) with single or multiple selection management
- **AssistChip** — An action-oriented chip (not togglable)
- **InputChip** — A removable chip representing user input

## Gotchas

- The first `<option>` should have `value=""` to serve as the unselected/label state. The chip visually toggles "on" when a non-empty value is selected.
- `onChange` on both the shorthand and `FilterChipWithMenu.Root` is typed as `ComponentProps<'select'>['onChange']`, so `e.target` is already typed as an `HTMLSelectElement` in most cases. A cast is only needed if TypeScript widens the event type in your context.
- The `icon` prop (shorthand) and `FilterChipWithMenu.Icon` (composed) both ignore the icon's own `size` prop; the chip controls the icon size.
- `labelVoiceOver` should describe the filter's purpose (e.g. "Price range filter"), not the selected value — assistive technologies announce the value automatically.
