# FieldSet

```tsx
import { FieldSet } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.0.0

## Usage

```tsx
import { Checkbox, FieldSet, FormHelp, Label, LabeledControl, Legend } from '@zillow/constellation';
```

```tsx
export const FieldSetBasic = () => (
  <FieldSet legend={<Legend>Legend</Legend>} description={<FormHelp>Helper text</FormHelp>}>
    <LabeledControl label={<Label>Checkbox label</Label>} control={<Checkbox defaultChecked />} />
    <LabeledControl label={<Label>Checkbox label</Label>} control={<Checkbox />} />
  </FieldSet>
);
```

## Examples

### Field Set Disabled

```tsx
import { Checkbox, FieldSet, FormHelp, Label, LabeledControl, Legend } from '@zillow/constellation';
```

```tsx
export const FieldSetDisabled = () => (
  <FieldSet
    legend={<Legend>Legend</Legend>}
    description={<FormHelp>Helper text</FormHelp>}
    disabled
  >
    <LabeledControl label={<Label>Checkbox label</Label>} control={<Checkbox defaultChecked />} />
    <LabeledControl label={<Label>Checkbox label</Label>} control={<Checkbox />} />
  </FieldSet>
);
```

### Field Set Error

```tsx
import { Checkbox, FieldSet, FormHelp, Label, LabeledControl, Legend } from '@zillow/constellation';
```

```tsx
export const FieldSetError = () => (
  <FieldSet legend={<Legend>Legend</Legend>} description={<FormHelp>Helper text</FormHelp>} error>
    <LabeledControl label={<Label>Checkbox label</Label>} control={<Checkbox defaultChecked />} />
    <LabeledControl label={<Label>Checkbox label</Label>} control={<Checkbox />} />
  </FieldSet>
);
```

### Field Set Large Size Switches

```tsx
import { FieldSet, FormHelp, Label, LabeledControl, Legend, Switch } from '@zillow/constellation';
```

```tsx
export const FieldSetLargeSizeSwitches = () => (
  <FieldSet
    legend={<Legend>Legend</Legend>}
    description={<FormHelp>Helper text</FormHelp>}
    size="lg"
  >
    <LabeledControl label={<Label>Switch label</Label>} control={<Switch defaultChecked />} />
    <LabeledControl label={<Label>Switch label</Label>} control={<Switch />} />
  </FieldSet>
);
```

### Field Set Optional

```tsx
import { Checkbox, FieldSet, FormHelp, Label, LabeledControl, Legend } from '@zillow/constellation';
```

```tsx
export const FieldSetOptional = () => (
  <FieldSet
    legend={<Legend>Legend</Legend>}
    description={<FormHelp>Helper text</FormHelp>}
    optional
  >
    <LabeledControl label={<Label>Checkbox label</Label>} control={<Checkbox defaultChecked />} />
    <LabeledControl label={<Label>Checkbox label</Label>} control={<Checkbox />} />
  </FieldSet>
);
```

### Field Set Render As Div If No Legend

```tsx
import { Checkbox, FieldSet, Label, LabeledControl } from '@zillow/constellation';
```

```tsx
export const FieldSetRenderAsDivIfNoLegend = () => (
  <FieldSet>
    <LabeledControl label={<Label>Checkbox label</Label>} control={<Checkbox defaultChecked />} />
    <LabeledControl label={<Label>Checkbox label</Label>} control={<Checkbox />} />
  </FieldSet>
);
```

### Field Set Required

```tsx
import { FieldSet, FormHelp, Label, LabeledControl, Legend, Radio } from '@zillow/constellation';
```

```tsx
export const FieldSetRequired = () => (
  <FieldSet
    legend={<Legend>Legend</Legend>}
    description={<FormHelp>Helper text</FormHelp>}
    required
  >
    <LabeledControl label={<Label>Radio label</Label>} control={<Radio defaultChecked />} />
    <LabeledControl label={<Label>Radio label</Label>} control={<Radio />} />
  </FieldSet>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `ref` | `RefObject<HTMLFieldSetElement \| HTMLDivElement>` | — | Needed to set a custom ref type to support multiple elements since `FieldSet` can be rendered as either a `<fieldset>` or a `<div>`. |
| `children` | `ReactNode` | — | A group of thematically related controls, usually `LabeledControl`. **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `description` | `ReactNode` | — | A node that describes the form controls, typically a FormHelp component. It will automatically associate the FormHelp with each field control using [`aria-describedby`](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/ARIA_Techniques/Using_the_aria-describedby_attribute). |
| `disabled` | `boolean` | `false` | Displays the fieldset in a disabled state. Can also be inherited by nested components. |
| `error` | `boolean` | `false` | Sets error flag for nested components. |
| `legend` | `ReactNode` | — | A node that labels the form controls, typically a `Legend` component. While a legend is optional, it is strongly recommended that some form of label be provided, whether through a legend or through an external label associated using `aria-labelledby`. The W3C spec requires that a `<fieldset>` include a `<legend>` child. So, when a legend is not provided, `FieldSet` will render a `div` instead. |
| `optional` | `boolean` | `false` | Sets optional flag for nested components. |
| `required` | `boolean` | `false` | Sets required flag for nested components. |
| `size` | `'md' \| 'lg'` | — | Sets size flag for nested components. Currently only works with Switches. |

