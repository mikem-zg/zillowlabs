# FormField

```tsx
import { FormField } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 4.0.0

## Usage

```tsx
import { FormField, FormHelp, Input, Label } from '@zillow/constellation';
```

```tsx
export const FormFieldBasic = () => (
  <FormField
    control={<Input />}
    description={<FormHelp>Help text</FormHelp>}
    label={<Label>Label text</Label>}
  />
);
```

## Examples

### Form Field Disabled

```tsx
import { FormField, FormHelp, Input, Label } from '@zillow/constellation';
```

```tsx
export const FormFieldDisabled = () => (
  <FormField
    control={<Input />}
    description={<FormHelp>Help text</FormHelp>}
    label={<Label>Label text</Label>}
    disabled
  />
);
```

### Form Field Error

```tsx
import { FormField, FormHelp, Input, Label } from '@zillow/constellation';
```

```tsx
export const FormFieldError = () => (
  <FormField
    control={<Input />}
    description={<FormHelp>Help text</FormHelp>}
    label={<Label>Label text</Label>}
    error
  />
);
```

### Form Field Optional Children

```tsx
import { FormField, FormHelp, Input, Label } from '@zillow/constellation';
```

```tsx
export const FormFieldOptionalChildren = () => (
  <FormField
    control={<Input />}
    description={<FormHelp>Help text</FormHelp>}
    label={<Label>Label text</Label>}
  >
    <span>Optional children</span>
  </FormField>
);
```

### Form Field Optional

```tsx
import { FormField, FormHelp, Input, Label } from '@zillow/constellation';
```

```tsx
export const FormFieldOptional = () => (
  <FormField
    control={<Input />}
    description={<FormHelp>Help text</FormHelp>}
    label={<Label>Label text</Label>}
    optional
  />
);
```

### Form Field Read Only

```tsx
import { FormField, FormHelp, Input, Label } from '@zillow/constellation';
```

```tsx
export const FormFieldReadOnly = () => (
  <FormField
    control={<Input />}
    description={<FormHelp>Help text</FormHelp>}
    label={<Label>Label text</Label>}
    readOnly
  />
);
```

### Form Field Required

```tsx
import { FormField, FormHelp, Input, Label } from '@zillow/constellation';
```

```tsx
export const FormFieldRequired = () => (
  <FormField
    control={<Input />}
    description={<FormHelp>Help text</FormHelp>}
    label={<Label>Label text</Label>}
    required
  />
);
```

### Form Field With Labeled Input

```tsx
import { FormField, FormHelp, Input, Label, LabeledInput } from '@zillow/constellation';
```

```tsx
export const FormFieldWithLabeledInput = () => (
  <FormField
    control={
      <LabeledInput input={<Input />} label={<Label>Field label</Label>}>
        Lorem ipsum dolor sit amet
      </LabeledInput>
    }
    description={<FormHelp>Help text</FormHelp>}
  />
);
```

### Form Field With Progress Bar

```tsx
import { FormField, FormHelp, Label, ProgressBar } from '@zillow/constellation';
```

```tsx
export const FormFieldWithProgressBar = () => (
  <FormField
    control={<ProgressBar maxValue={100} value={20} size="md" />}
    description={<FormHelp>Help text</FormHelp>}
    label={<Label>Label text</Label>}
  />
);
```

### Form Field With Select

```tsx
import { FormField, FormHelp, Label, Select } from '@zillow/constellation';
```

```tsx
export const FormFieldWithSelect = () => (
  <FormField
    control={
      <Select>
        <option value="1">Option 1</option>
        <option value="2">Option 2</option>
        <option value="3">Option 3</option>
      </Select>
    }
    description={<FormHelp>Help text</FormHelp>}
    label={<Label>Label text</Label>}
  />
);
```

### Form Field With Textarea

```tsx
import { FormField, FormHelp, Label, Textarea } from '@zillow/constellation';
```

```tsx
export const FormFieldWithTextarea = () => (
  <FormField
    control={<Textarea>Lorem ipsum dolor sit amet</Textarea>}
    description={<FormHelp>Help text</FormHelp>}
    label={<Label>Label text</Label>}
  />
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | You will want to use the `control`, `description`, and `label` props instead of `children`, but you can use `children` if you need a specialized layout. When using `children`, however, not all ARIA properties can automatically be associated, so you must verify that your specialized layout follow accessibility best practices. |
| `control` | `ReactNode` | — | A single control node, e.g. Input, Select, Textarea. When composing several different controls in one field, use a FieldSet. |
| `controlId` | `string` | — | Identifier used for form controls and labels. This will be used as the `id` by form controls and the `htmlFor` by Label components. If no `controlId` is specified, one will automatically be generated. |
| `css` | `SystemStyleObject` | — | Styles object |
| `description` | `ReactNode` | — | A node that describes the form field, typically a FormHelp. This will automatically associate the FormHelp with the field control using [`aria-describedby`](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/ARIA_Techniques/Using_the_aria-describedby_attribute). |
| `disabled` | `boolean` | `false` | Sets disabled flag for nested components. Inherited from parent context if undefined. |
| `error` | `boolean` | `false` | Sets error flag for nested components. Inherited from parent context if undefined. |
| `label` | `ReactNode` | — | A node that labels the form control, typically a `Label` component. |
| `optional` | `boolean` | `false` | Sets optional flag for nested components. Inherited from parent context if undefined. |
| `readOnly` | `boolean` | `false` | Sets readOnly flag for nested components. Inherited from parent context if undefined. |
| `required` | `boolean` | `false` | Sets required flag for nested components. Inherited from parent context if undefined. |

