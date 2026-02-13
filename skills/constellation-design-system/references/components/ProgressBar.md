# ProgressBar

```tsx
import { ProgressBar } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 10.0.0

## Usage

```tsx
import { ProgressBar } from '@zillow/constellation';
```

```tsx
export const ProgressBarBasic = () => <ProgressBar aria-label="Progress Example" value={50} />;
```

## Examples

### Progress Bar Complete

```tsx
import { ProgressBar } from '@zillow/constellation';
```

```tsx
export const ProgressBarComplete = () => <ProgressBar aria-label="Progress Example" value={100} />;
```

### Progress Bar Medium Size

```tsx
import { ProgressBar } from '@zillow/constellation';
```

```tsx
export const ProgressBarMediumSize = () => (
  <ProgressBar aria-label="Progress Example" size="md" value={50} />
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'aria-describedby'` | `AriaAttributes['aria-describedby']` | — | Optional. The `id` of an element that provides information about the progress bar beyond the `aria-label` or `aria-labelledby` label. When `ProgressBar` is used in a `FormField`, this value will automatically be set to the `description` element's `id`. |
| `'aria-label'` | `AriaAttributes['aria-label']` | — | An accessible label for those using assistive technologies. Describes the purpose of the progress bar. An accessible label is required and can be provided using either `aria-label` or `aria-labelledby`. |
| `'aria-labelledby'` | `AriaAttributes['aria-labelledby']` | — | The `id` of the element that acts as an accessible label for those using assistive technologies. The label should describe the purpose of the progress bar. When `ProgressBar` is used in a `FormField`, this value will automatically be set to the `label` element's `id`. An accessible label is required and can be provided using either `aria-label` or `aria-labelledby`. |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'maxValue'` | `number` | `100` | The value when progress has been completed. |
| `'minValue'` | `number` | `0` | The value when no progress has been made. |
| `'size'` | `'sm' \| 'md'` | `sm` | Determines the height of the bar. |
| `'value'` | `number` | — | The current progress value. Do not use a percentage. Instead, use a number between the minValue and maxValue. **(required)** |
| `'stepperOffset'` | `boolean` | — | Used only by ProgressStepper to adjust the width of its progress bar. Since a ProgressStepper starts at 1 (not 0), the width % needs to be calculated based on number of steps - 1. |

