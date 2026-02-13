# Radio

```tsx
import { Radio } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 1.8.0

## Usage

```tsx
import { Radio } from '@zillow/constellation';
```

```tsx
export const RadioBasic = () => <Radio />;
```

## Examples

### Radio Controlled

```tsx
import { Box, Radio } from '@zillow/constellation';
```

```tsx
export const RadioControlled = () => {
  const [value, setValue] = useState<string>('first');
  const handler: ChangeEventHandler<HTMLInputElement> = useCallback(
    (event) => {
      if (value !== event?.target.value) {
        setValue(event.target.value);
      }
    },
    [value],
  );
  return (
    <Box css={{ display: 'flex', gap: 'default' }}>
      <Radio
        value="first"
        checked={value === 'first'}
        onChange={handler}
        name="controlled-radio-inputs"
      />
      <Radio
        value="second"
        checked={value === 'second'}
        onChange={handler}
        name="controlled-radio-inputs"
      />
    </Box>
  );
};
```

### Radio Disabled

```tsx
import { Box, Radio } from '@zillow/constellation';
```

```tsx
export const RadioDisabled = () => (
  <Box css={{ display: 'flex', gap: 'default' }}>
    <Radio disabled />
    <Radio disabled checked />
  </Box>
);
```

### Radio Uncontrolled

```tsx
import { Box, Radio } from '@zillow/constellation';
```

```tsx
export const RadioUncontrolled = () => (
  <Box css={{ display: 'flex', gap: 'default' }}>
    <Radio defaultChecked name="uncontrolled-radio-inputs" />
    <Radio name="uncontrolled-radio-inputs" />
  </Box>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `checked` | `boolean` | — | Sets the checked state of the input and uses it as a controlled component. |
| `defaultChecked` | `boolean` | — | Sets the initial checked state of the input and uses it as a uncontrolled component. |
| `disabled` | `boolean` | `false` | Disabled state. When true, prevents the user from interacting with the radio. Inherited from parent context if undefined. |
| `required` | `boolean` | `false` | Required state. When true, indicates that the user must check the radio before the owning form can be submitted. Inherited from parent context if undefined. |
| `readOnly` | `boolean` | `false` | Read-only state. Inherited from parent context if undefined. |
| `css` | `SystemStyleObject` | — | Styles object |

