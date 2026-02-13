# LabeledInput

```tsx
import { LabeledInput } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.23.0

## Usage

```tsx
import { Input, Label, LabeledInput } from '@zillow/constellation';
```

```tsx
export const LabeledInputBasic = () => (
  <LabeledInput input={<Input />} label={<Label>Field label</Label>} />
);
```

## Examples

### Labeled Input Custom Control Id

```tsx
import { Input, Label, LabeledInput } from '@zillow/constellation';
```

```tsx
export const LabeledInputCustomControlId = () => (
  <LabeledInput input={<Input />} label={<Label>Field label</Label>} controlId="my-custom-id" />
);
```

### Labeled Input Disabled Fluid Width

```tsx
import { Input, Label, LabeledInput } from '@zillow/constellation';
```

```tsx
export const LabeledInputDisabledFluidWidth = () => (
  <LabeledInput input={<Input />} label={<Label>Field label</Label>} fluid={false} />
);
```

### Labeled Input Disabled

```tsx
import { Input, Label, LabeledInput } from '@zillow/constellation';
```

```tsx
export const LabeledInputDisabled = () => (
  <LabeledInput input={<Input />} label={<Label>Field label</Label>} disabled />
);
```

### Labeled Input Error

```tsx
import { Input, Label, LabeledInput } from '@zillow/constellation';
```

```tsx
export const LabeledInputError = () => (
  <LabeledInput input={<Input />} label={<Label>Field label</Label>} error />
);
```

### Labeled Input Optional

```tsx
import { Input, Label, LabeledInput } from '@zillow/constellation';
```

```tsx
export const LabeledInputOptional = () => (
  <LabeledInput input={<Input />} label={<Label>Field label</Label>} optional />
);
```

### Labeled Input Read Only

```tsx
import { Input, Label, LabeledInput } from '@zillow/constellation';
```

```tsx
export const LabeledInputReadOnly = () => (
  <LabeledInput
    input={<Input defaultValue="Lorem ipsum" />}
    label={<Label>Field label</Label>}
    readOnly
  />
);
```

### Labeled Input Required

```tsx
import { Input, Label, LabeledInput } from '@zillow/constellation';
```

```tsx
export const LabeledInputRequired = () => (
  <LabeledInput input={<Input />} label={<Label>Field label</Label>} required />
);
```

### Labeled Input With Placeholder

```tsx
import { Input, Label, LabeledInput } from '@zillow/constellation';
```

```tsx
export const LabeledInputWithPlaceholder = () => (
  <LabeledInput
    input={<Input />}
    label={<Label>Field label</Label>}
    placeholder="Ex: placeholder text"
  />
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `controlId` | `string` | `defaultId` | Identifier used for input and labels. This will be used as the `id` by `Input` and the `htmlFor` by `Label`. If no `controlId` is specified, one will automatically be generated. |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Disabled state. Can be inherited from FormField context. |
| `error` | `boolean` | `false` | Error state. Can be inherited from FormField context. |
| `fluid` | `boolean` | `true` | Inputs are fluid by default which means they stretch to fill the entire width of their container. When `fluid="false"`, the inputs's width is set to `auto`. |
| `input` | `ReactNode` | — | An `Input` component. **(required)** |
| `label` | `ReactNode` | — | A `Label` component. **(required)** |
| `optional` | `boolean` | `false` | Indicates the input is optional. Can be inherited from FormField context. |
| `placeholder` | `string` | `' '` | Placeholder text appears when the input receives focus. Defaults to an empty space (' ') instead of an empty string for CSS targeting purposes. |
| `readOnly` | `boolean` | `false` | Read-only state. Can be inherited from FormField context. |
| `required` | `boolean` | `false` | Indicates the input is required. Can be inherited from FormField context. |

