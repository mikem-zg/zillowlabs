# LabeledControl

```tsx
import { LabeledControl } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 6.0.0

## Usage

```tsx
import { Checkbox, Label, LabeledControl } from '@zillow/constellation';
```

```tsx
export const LabeledControlBasic = () => (
  <LabeledControl control={<Checkbox />} label={<Label>Label</Label>} />
);
```

## Examples

### Labeled Control Disabled

```tsx
import { Checkbox, Label, LabeledControl } from '@zillow/constellation';
```

```tsx
export const LabeledControlDisabled = () => (
  <LabeledControl control={<Checkbox />} label={<Label>Label</Label>} disabled />
);
```

### Labeled Control Fluid

```tsx
import { Checkbox, Label, LabeledControl } from '@zillow/constellation';
```

```tsx
export const LabeledControlFluid = () => (
  <LabeledControl control={<Checkbox />} label={<Label>Label</Label>} fluid />
);
```

### Labeled Control Label Position

```tsx
import { Box, Checkbox, Label, LabeledControl } from '@zillow/constellation';
```

```tsx
export const LabeledControlLabelPosition = () => (
  <Box css={{ display: 'flex', flexDirection: 'column', gap: 'loose' }}>
    <LabeledControl control={<Checkbox />} label={<Label>Label</Label>} labelPosition="left" />
    <LabeledControl control={<Checkbox />} label={<Label>Label</Label>} labelPosition="right" />
  </Box>
);
```

### Labeled Control Label That Wraps

```tsx
import { Box, Checkbox, Label, LabeledControl } from '@zillow/constellation';
```

```tsx
export const LabeledControlLabelThatWraps = () => (
  <Box css={{ width: '300px' }}>
    <LabeledControl
      control={<Checkbox />}
      label={
        <Label>
          Long label text in a narrow container that wraps into multiple lines to test that the
          label and control stay properly top-aligned
        </Label>
      }
    />
  </Box>
);
```

### Labeled Control Optional

```tsx
import { Checkbox, Label, LabeledControl } from '@zillow/constellation';
```

```tsx
export const LabeledControlOptional = () => (
  <LabeledControl control={<Checkbox />} label={<Label>Label</Label>} optional />
);
```

### Labeled Control Required

```tsx
import { Label, LabeledControl, Radio } from '@zillow/constellation';
```

```tsx
export const LabeledControlRequired = () => (
  <LabeledControl control={<Radio />} label={<Label>Label</Label>} required />
);
```

### Labeled Control Sizes

```tsx
import { Box, Label, LabeledControl, Switch } from '@zillow/constellation';
```

```tsx
export const LabeledControlSizes = () => (
  <Box css={{ display: 'flex', flexDirection: 'column', gap: 'loose' }}>
    <LabeledControl control={<Switch />} label={<Label>Label</Label>} size="md" />
    <LabeledControl control={<Switch />} label={<Label>Label</Label>} size="lg" />
  </Box>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `control` | `ReactNode` | — | A single control node, e.g. Checkbox, Radio, Switch. **(required)** |
| `controlId` | `string` | `defaultId` | Identifier used for form controls and labels. This will be used as the `id` by form controls and the `htmlFor` by Label components. If no `controlId` is specified, one will automatically be generated. |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Sets disabled flag for nested components. Can be inherited from FormField and/or FieldSet context. |
| `error` | `boolean` | `false` | Sets error flag for nested components. Can be inherited from FormField and/or FieldSet context. |
| `fluid` | `boolean` | `false` | If `true`, this will span the entire width. Be careful: while appealing at mobile sizes, this may result in too much space between the label and input at larger widths. |
| `labelPosition` | `'left' \| 'right'` | `right` | Where to align the label with respect to the selection control. |
| `label` | `ReactNode` | — | A node that labels the form controls, typically a Label component. **(required)** |
| `optional` | `boolean` | `false` | Sets optional flag for nested components. Can be inherited from FormField and/or FieldSet context. |
| `required` | `boolean` | `false` | Sets required flag for nested components. Can be inherited from FormField and/or FieldSet context. |
| `size` | `'md' \| 'lg'` | `md` | Sets size flag for nested components. Currently only works with Switches. Can be inherited from FieldSet context. |

