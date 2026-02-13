# Progress

```tsx
import { Progress } from '@zillow/constellation';
```

**Version:** 10.11.0

## Usage

```tsx
import { Progress } from '@zillow/constellation';
```

```tsx
export const ProgressBasic = () => (
  <Progress.Root aria-label="Progress Example" value={50}>
    <Progress.Bar>
      <Progress.Range />
      <Progress.Track />
    </Progress.Bar>
  </Progress.Root>
);
```

## Examples

### Progress Complete

```tsx
import { Progress } from '@zillow/constellation';
```

```tsx
export const ProgressComplete = () => (
  <Progress.Root aria-label="Progress Example" value={100}>
    <Progress.Bar>
      <Progress.Range />
      <Progress.Track />
    </Progress.Bar>
  </Progress.Root>
);
```

### Progress Medium Size

```tsx
import { Progress } from '@zillow/constellation';
```

```tsx
export const ProgressMediumSize = () => (
  <Progress.Root aria-label="Progress Example" size="md" value={50}>
    <Progress.Bar>
      <Progress.Range />
      <Progress.Track />
    </Progress.Bar>
  </Progress.Root>
);
```

## API

### ProgressRoot

| Prop | Type | Default | Description |
| --- | --- | --- | --- |
| aria-describedby | `string` | - | The `id` of an element that provides information about the progress bar beyond the `aria-label` or `aria-labelledby` label. When used in a `FormField`, this value will automatically be set to the `description` element's `id`. |
| aria-label | `string` | - | An accessible label for those using assistive technologies. Describes the purpose of the progress bar. An accessible label is required and can be provided using either `aria-label` or `aria-labelledby`. |
| aria-labelledby | `string` | - | The `id` of the element that acts as an accessible label. When used in a `FormField`, this value will automatically be set to the `label` element's `id`. An accessible label is required and can be provided using either `aria-label` or `aria-labelledby`. |
| children | `ReactNode` | - | Contents of the Progress Root component |
| maxValue | `number` | `100` | The value when progress has been completed |
| minValue | `number` | `0` | The value when no progress has been made |
| size | `'sm' \| 'md'` | `'sm'` | Determines the height of the bar |
| value | `number` | **required** | The current progress value. Do not use a percentage. Instead, use a number between the minValue and maxValue. |

### ProgressBar

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
| --- | --- | --- | --- |
| aria-describedby | `string` | - | The `id` of an element that provides information about the progress bar beyond the `aria-label` or `aria-labelledby` label. When used in a `FormField`, this value will automatically be set to the `description` element's `id`. |
| aria-label | `string` | - | An accessible label for those using assistive technologies. Describes the purpose of the progress bar. |
| aria-labelledby | `string` | - | The `id` of the element that acts as an accessible label. When used in a `FormField`, this value will automatically be set to the `label` element's `id`. |
| css | `SystemStyleObject` | - | Styles object |
| maxValue | `number` | `100` | The value when progress has been completed. Inherited from Progress.Root context. |
| minValue | `number` | `0` | The value when no progress has been made. Inherited from Progress.Root context. |
| size | `'sm' \| 'md'` | `'sm'` | Determines the height of the bar. Inherited from Progress.Root context. |
| value | `number` | - | The current progress value. Inherited from Progress.Root context. |

### ProgressRange

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
| --- | --- | --- | --- |
| css | `SystemStyleObject` | - | Styles object |
| size | `'sm' \| 'md'` | `'sm'` | Determines the height of the bar. Inherited from Progress.Root context. |
| percentComplete | `number` | - | Controls the width and background color of the active track. Inherited from Progress.Root context. |

### ProgressTrack

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
| --- | --- | --- | --- |
| css | `SystemStyleObject` | - | Styles object |
| size | `'sm' \| 'md'` | `'sm'` | Determines the height of the bar. Inherited from Progress.Root context. |

