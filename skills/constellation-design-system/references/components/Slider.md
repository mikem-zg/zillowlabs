# Slider

```tsx
import { Slider } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 6.12.0

## Usage

```tsx
import { Slider } from '@zillow/constellation';
```

```tsx
export const SliderBasic = () => <Slider ariaLabel="Value" defaultValue={50} />;
```

## Examples

### Slider Aria Valuetext

```tsx
import { Slider } from '@zillow/constellation';
```

```tsx
export const SliderAriaValuetext = () => (
  <Slider
    ariaLabel="Temperature"
    ariaValuetext={(state) => {
      return `${state.value} degrees`;
    }}
    defaultValue={60}
  />
);
```

### Slider Composition

```tsx
import { Box, Slider } from '@zillow/constellation';
```

```tsx
export const SliderComposition = () => (
  <Box css={{ display: 'flex', gap: 'tighter', flexDirection: 'column', width: '100%' }}>
    <Slider.Root ariaLabel="Price range" defaultValue={[15, 35]}>
      <Slider.Track>
        <Slider.ActiveTrack />
      </Slider.Track>
      <Slider.Handles />
    </Slider.Root>
    <Slider.Root ariaLabel="Quantity range" defaultValue={[50, 75]}>
      <Slider.Track>
        <Slider.ActiveTrack />
      </Slider.Track>
      <Slider.Handle ariaLabel="Minimum quantity" />
      <Slider.Handle ariaLabel="Maximum quantity" />
    </Slider.Root>
  </Box>
);
```

### Slider Controlled Value

```tsx
import { Box, FormField, Input, Label, Slider } from '@zillow/constellation';
```

```tsx
export const SliderControlledValue = () => {
  const [value, setValue] = useState([40, 60]);

  const handleInputChange = useCallback(
    (i: number): ChangeEventHandler<HTMLInputElement> => {
      return (e) => {
        const next = [...value];
        next[i] = Number(e.target.value);
        setValue(next);
      };
    },
    [value],
  );

  return (
    <Box css={{ display: 'flex', flexDirection: 'column', gap: 'default', width: '100%' }}>
      <Box css={{ display: 'flex', justifyContent: 'space-between', gap: 'default' }}>
        <FormField
          control={
            <Input fluid={false} value={value[0]} onChange={handleInputChange(0)} type="number" />
          }
          label={<Label>Value 1</Label>}
        />
        <FormField
          control={
            <Input fluid={false} value={value[1]} onChange={handleInputChange(1)} type="number" />
          }
          label={<Label>Value 2</Label>}
        />
      </Box>
      <Slider ariaLabel="Value range" value={value} onValueChange={setValue} />
    </Box>
  );
};
```

### Slider Disabled

```tsx
import { Slider } from '@zillow/constellation';
```

```tsx
export const SliderDisabled = () => <Slider ariaLabel="Value" disabled defaultValue={50} />;
```

### Slider Displacement Disabled

```tsx
import { Slider } from '@zillow/constellation';
```

```tsx
export const SliderDisplacementDisabled = () => (
  <Slider ariaLabel="Range" displacementDisabled defaultValue={[50, 65]} />
);
```

### Slider Minimum Distance

```tsx
import { Slider } from '@zillow/constellation';
```

```tsx
export const SliderMinimumDistance = () => (
  <Slider ariaLabel="Range" defaultValue={[25, 75]} step={1} minDistance={10} />
);
```

### Slider Multiple Values

```tsx
import { Slider } from '@zillow/constellation';
```

```tsx
export const SliderMultipleValues = () => <Slider ariaLabel="Range" defaultValue={[10, 30]} />;
```

### Slider Shift Step

```tsx
import { Slider } from '@zillow/constellation';
```

```tsx
export const SliderShiftStep = () => (
  <Slider
    ariaLabel="Range"
    defaultValue={[25, 75]}
    step={1}
    shiftStep={(step) => {
      return step * 10;
    }}
  />
);
```

### Slider Snap Drag Disabled

```tsx
import { Slider } from '@zillow/constellation';
```

```tsx
export const SliderSnapDragDisabled = () => (
  <Slider ariaLabel="Value" snapDragDisabled defaultValue={50} />
);
```

### Slider Steps

```tsx
import { Slider } from '@zillow/constellation';
```

```tsx
export const SliderSteps = () => <Slider ariaLabel="Range" defaultValue={[25, 75]} step={10} />;
```

### Slider Tooltip Placement

```tsx
import { Slider } from '@zillow/constellation';
```

```tsx
export const SliderTooltipPlacement = () => (
  <Slider ariaLabel="Value" defaultValue={50} tooltipPlacement="bottom" />
);
```

### Slider Tooltip Text

```tsx
import { Slider } from '@zillow/constellation';
```

```tsx
export const SliderTooltipText = () => (
  <Slider
    ariaLabel="Temperature"
    ariaValuetext={(state) => {
      return `${state.value} degrees`;
    }}
    tooltipText={(state) => {
      return `${state.valueNow}°`;
    }}
    defaultValue={60}
  />
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `min` | `number` | `0` | The Slider's minimum value. |
| `max` | `number` | `100` | The Slider's maximum value. |
| `value` | `number \| Array<number>` | — | Controlled Slider value |
| `defaultValue` | `number \| Array<number>` | `0` | Default uncontrolled Slider value |
| `reverse` | `boolean` | `false` | Reverses the Slider's direction |
| `onValueChange` | `\| ((value: number) => void)     \| ((value: Array<number>) => void)     \| ((value: number \| Array<number>) => void)` | — | Callback called when the Slider's value changes. |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Disables the slider when true |
| `step` | `number` | `1` | Value to be added or subtracted on each step the slider makes. Must be greater than zero. `max - min` should be evenly divisible by the step value. |
| `shiftStep` | `null \| number \| ((step: number) => number)` | `step => step * 10` | Handles step increments for 'PageUp', 'PageDown', or shift + arrow keys. |
| `snapDragDisabled` | `boolean` | `false` | Disables handle movement when clicking the slider track |
| `displacementDisabled` | `boolean` | `false` | By default, the active handle will push other handles when moved Setting this to true will turn off this behavior. |
| `minDistance` | `number` | `0` | Minimum distance in between handles |
| `tooltipPlacement` | `TooltipRootPropsInterface['placement']` | `'top'` | Placement of the tooltip |
| `ariaLabel` | `\| string     \| ((state: { value: number \| Array<number>; index: number; valueNow: number }) => string)` | — | Accessible label for the slider handle. Can be a static string, or a function that returns a string. The function will be passed a single argument, an object with the following properties: `args.value`: the Slider's current value `args.index`: the index of the current handle `args.valueNow`: the value of the current handle |
| `ariaValuetext` | `\| string     \| ((state: { value: number \| Array<number>; index: number; valueNow: number }) => string)` | — | `aria-valuetext` for screen-readers. Can be a static string, or a function that returns a string. The function will be passed a single argument, an object with the following properties: `args.value`: the Slider's current value `args.index`: the index of the current handle `args.valueNow`: the value of the current handle |
| `tooltipText` | `\| string     \| ((state: { value: number \| Array<number>; index: number; valueNow: number }) => string)` | — | `tooltipText` for the tooltip content. Can be a static string, or a function that returns a string. The function will be passed a single argument, an object with the following properties `args.value`: the Slider's current value `args.index`: the index of the current handle `args.valueNow`: the value of the current handle |

### SliderActiveTrack

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |

### SliderHandle

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |
| `ariaLabel` | `\| string     \| ((state: { value: number \| Array<number>; index: number; valueNow: number }) => string)` | `ariaLabelContext` | Accessible label for the slider handle. Can be a static string, or a function that returns a string. The function will be passed a single argument, an object with the following properties: `args.value`: the Slider's current value `args.index`: the index of the current handle `args.valueNow`: the value of the current handle |
| `ariaValuetext` | `\| string     \| ((state: { value: number \| Array<number>; index: number; valueNow: number }) => string)` | — | `aria-valuetext` for screen-readers. Can be a static string, or a function that returns a string. The function will be passed a single argument, an object with the following properties: `args.value`: the Slider's current value `args.index`: the index of the current handle `args.valueNow`: the value of the current handle |
| `tooltipText` | `\| string     \| ((state: { value: number \| Array<number>; index: number; valueNow: number }) => string)` | — | `tooltipText` for the tooltip content. Can be a static string, or a function that returns a string. The function will be passed a single argument, an object with the following properties `args.value`: the Slider's current value `args.index`: the index of the current handle `args.valueNow`: the value of the current handle |

### SliderHandles

### SliderRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `ariaLabel` | `\| string     \| ((state: { value: number \| Array<number>; index: number; valueNow: number }) => string)` | — | Accessible label for the slider handle. Can be a static string, or a function that returns a string. The function will be passed a single argument, an object with the following properties: `args.value`: the Slider's current value `args.index`: the index of the current handle `args.valueNow`: the value of the current handle |
| `ariaValuetext` | `\| string     \| ((state: { value: number \| Array<number>; index: number; valueNow: number }) => string)` | — | `aria-valuetext` for screen-readers. Can be a static string, or a function that returns a string. The function will be passed a single argument, an object with the following properties: `args.value`: the Slider's current value `args.index`: the index of the current handle `args.valueNow`: the value of the current handle |
| `tooltipText` | `\| string     \| ((state: { value: number \| Array<number>; index: number; valueNow: number }) => string)` | — | `tooltipText` for the tooltip content. Can be a static string, or a function that returns a string. The function will be passed a single argument, an object with the following properties `args.value`: the Slider's current value `args.index`: the index of the current handle `args.valueNow`: the value of the current handle |
| `min` | `number` | `0` | The Slider's minimum value. |
| `max` | `number` | `100` | The Slider's maximum value. |
| `value` | `number \| Array<number>` | — | Controlled Slider value |
| `defaultValue` | `number \| Array<number>` | `0` | Default uncontrolled Slider value |
| `reverse` | `boolean` | `false` | Reverses the Slider's direction |
| `onValueChange` | `\| ((value: number) => void)     \| ((value: Array<number>) => void)     \| ((value: number \| Array<number>) => void)` | — | Callback called when the Slider's value changes. |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Disables the slider when true |
| `step` | `number` | `1` | Value to be added or subtracted on each step the slider makes. Must be greater than zero. `max - min` should be evenly divisible by the step value. |
| `shiftStep` | `null \| number \| ((step: number) => number)` | `step => step * 10` | Handles step increments for 'PageUp', 'PageDown', or shift + arrow keys. |
| `snapDragDisabled` | `boolean` | `false` | Disables handle movement when clicking the slider track |
| `displacementDisabled` | `boolean` | `false` | By default, the active handle will push other handles when moved Setting this to true will turn off this behavior. |
| `minDistance` | `number` | `0` | Minimum distance in between handles |
| `tooltipPlacement` | `TooltipRootPropsInterface['placement']` | `'top'` | Placement of the tooltip |

### SliderTrack

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |

