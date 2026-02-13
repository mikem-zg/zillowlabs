# Checkbox

```tsx
import { Checkbox } from '@zillow/constellation';
```

**Version:** 10.11.0

## Usage

```tsx
import { Checkbox } from '@zillow/constellation';
```

```tsx
export const CheckboxBasic = () => <Checkbox />;
```

## Examples

### Checkbox Controlled Indeterminate Group

```tsx
import { Box, Checkbox } from '@zillow/constellation';
```

```tsx
export const CheckboxControlledIndeterminateGroup = () => {
  const [checks, setChecks] = useState<Array<boolean>>([false, false]);
  const [indeterminate, setIndeterminate] = useState<boolean>(false);

  const handleParentChange: ChangeEventHandler<HTMLInputElement> = (e) => {
    setChecks(checks.map(() => e.currentTarget.checked));
    setIndeterminate(false);
  };

  const handleChildChange =
    (i: number): ChangeEventHandler<HTMLInputElement> =>
    (e) => {
      const newChecks = [...checks];
      newChecks[i] = e.currentTarget.checked;
      setChecks(newChecks);
      setIndeterminate(newChecks.some((check) => !!check) && !newChecks.every((check) => !!check));
    };

  return (
    <Box css={{ display: 'flex', flexDirection: 'column', gap: 'tight' }}>
      <Checkbox
        key={Math.random()}
        checked={checks.every((check) => check)}
        indeterminate={indeterminate}
        onChange={handleParentChange}
      />
      {checks.map((checked, i) => {
        return (
          <Checkbox
            key={Math.random()}
            checked={checked}
            onChange={handleChildChange(i)}
            css={{ marginLeft: 'default' }}
          />
        );
      })}
    </Box>
  );
};
```

### Checkbox Controlled

```tsx
import { Checkbox } from '@zillow/constellation';
```

```tsx
export const CheckboxControlled = () => {
  const [checked, setChecked] = useState<boolean>(false);
  return <Checkbox checked={checked} onChange={() => setChecked(!checked)} />;
};
```

### Checkbox Disabled

```tsx
import { Box, Checkbox } from '@zillow/constellation';
```

```tsx
export const CheckboxDisabled = () => (
  <Box css={{ display: 'flex', flexDirection: 'column', gap: 'tight' }}>
    <Checkbox disabled />
    <Checkbox disabled checked />
    <Checkbox disabled indeterminate />
  </Box>
);
```

### Checkbox Indeterminate

```tsx
import { Checkbox } from '@zillow/constellation';
```

```tsx
export const CheckboxIndeterminate = () => <Checkbox indeterminate />;
```

### Checkbox Uncontrolled Default Checked

```tsx
import { Checkbox } from '@zillow/constellation';
```

```tsx
export const CheckboxUncontrolledDefaultChecked = () => <Checkbox defaultChecked />;
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `checked` | `boolean` | — | Sets the checked state of the input and uses it as a controlled component. |
| `defaultChecked` | `boolean` | — | Sets the initial checked state of the input and uses it as a uncontrolled component. |
| `disabled` | `boolean` | `false` | Disabled state. When true, prevents the user from interacting with the checkbox. Inherited from parent context if undefined. |
| `error` | `boolean` | `false` | Error state. Inherited from parent context if undefined. |
| `indeterminate` | `boolean` | `false` | Sets indeterminate state |
| `required` | `boolean` | `false` | Required state. When true, indicates that the user must check the checkbox before the owning form can be submitted. Inherited from parent context if undefined. |
| `readOnly` | `boolean` | `false` | Read-only state. Inherited from parent context if undefined. |
| `css` | `SystemStyleObject` | — | Styles object |

