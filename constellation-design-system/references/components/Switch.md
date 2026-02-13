# Switch

```tsx
import { Switch } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 6.7.0

## Usage

```tsx
import { Switch } from '@zillow/constellation';
```

```tsx
export const SwitchBasic = () => <Switch size="md" />;
```

## Examples

### Switch Composable

```tsx
import { Switch } from '@zillow/constellation';
```

```tsx
export const SwitchComposable = () => (
  <Switch.Root size="md" defaultChecked>
    <Switch.Input
      // oxlint-disable-next-line no-console
      onBlur={() => console.log('onBlur in composable story')}
      // oxlint-disable-next-line no-console
      onChange={(e) => console.log('onChange in composable story', e.currentTarget.checked)}
      // oxlint-disable-next-line no-console
      onFocus={() => console.log('onFocus in composable story')}
    />
    <Switch.Track>
      <Switch.Handle />
    </Switch.Track>
  </Switch.Root>
);
```

### Switch Controlled

```tsx
import { Switch } from '@zillow/constellation';
```

```tsx
export const SwitchControlled = () => {
  const [checked, setChecked] = useState<boolean>(true);
  const handleChange = (e: ChangeEvent<HTMLInputElement>) => {
    setChecked(e.currentTarget.checked);
  };
  return <Switch size="md" checked={checked} onChange={handleChange} />;
};
```

### Switch Disabled

```tsx
import { Box, Switch } from '@zillow/constellation';
```

```tsx
export const SwitchDisabled = () => (
  <Box css={{ display: 'flex', gap: 'layout.default', flexDirection: 'column' }}>
    <Switch disabled />
    <Switch disabled checked />
  </Box>
);
```

### Switch Sizes

```tsx
import { Box, Switch } from '@zillow/constellation';
```

```tsx
export const SwitchSizes = () => (
  <Box css={{ display: 'flex', gap: 'layout.default', flexDirection: 'column' }}>
    <Switch size="md" defaultChecked />
    <Switch size="lg" defaultChecked />
  </Box>
);
```

### Switch Uncontrolled

```tsx
import { Switch } from '@zillow/constellation';
```

```tsx
export const SwitchUncontrolled = () => <Switch size="md" defaultChecked />;
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `checked` | `boolean` | — | Sets the on/off state of the switch and uses it as a controlled component. |
| `controlId` | `string` | `formFieldContext?.controlId ?? defaultId` | Identifier used to associate form controls and labels. If this is not defined directly or via context, an identifier will be automatically generated. |
| `css` | `SystemStyleObject` | — | Styles object |
| `defaultChecked` | `boolean` | `false` | Sets the on/off state of the switch and uses it as a uncontrolled component. |
| `disabled` | `boolean` | `false` | Displays the switch in a disabled state. Can also be inherited from a `LabeledControl` or `FieldSet` parent. |
| `id` | `string` | — | Identifier used to associate form controls and labels. Usually passed down via context. |
| `onChange` | `ChangeEventHandler<HTMLInputElement>` | — | Event handler called when switch is toggled. |
| `required` | `boolean` | — | When true, indicates that the user must set the switch to "on" before the owning form can be submitted. |
| `size` | `SwitchRootPropsInterface['size']` | — |  |

### SwitchHandle

**Element:** `HTMLLabelElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |
| `checkedState` | `boolean` | `switchRootContext.checkedState` | The on/off state of the switch. |
| `size` | `'md' \| 'lg'` | `switchRootContext.size` | The size of the switch, defaults to `md`. Can also be inherited from a `FieldSet` parent. |

### SwitchInput

**Element:** `HTMLInputElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `checked` | `boolean` | `switchRootContext.checkedState` | Sets the on/off state of the switch. Use for both controlled and uncontrolled components. Uncontrolled behavior is handled by `Switch.Root`. |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Displays the switch in a disabled state. Usually passed down via context. |
| `id` | `string` | `switchRootContext.controlId` | Identifier used to associate form controls and labels. Usually passed down via context. |
| `onChange` | `ChangeEventHandler<HTMLInputElement>` | — | Event handler called when switch is toggled. |
| `required` | `boolean` | `false` | When true, indicates that the user must set the switch to "on" before the owning form can be submitted. |

### SwitchRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `checked` | `boolean` | — | Sets the on/off state of the switch and uses it as a controlled component. |
| `children` | `ReactNode` | — | Content **(required)** |
| `controlId` | `string` | `formFieldContext?.controlId ?? defaultId` | Identifier used to associate form controls and labels. If this is not defined directly or via context, an identifier will be automatically generated. |
| `css` | `SystemStyleObject` | — | Styles object |
| `defaultChecked` | `boolean` | `false` | Sets the on/off state of the switch and uses it as a uncontrolled component. |
| `disabled` | `boolean` | `false` | Displays the switch in a disabled state. Can also be inherited from a `LabeledControl` or `FieldSet` parent. |
| `size` | `'md' \| 'lg'` | `fieldSetContext?.size ?? 'md'` | The size of the switch, defaults to `md`. Can also be inherited from a `FieldSet` parent. |

### SwitchTrack

**Element:** `HTMLLabelElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `controlId` | `string` | `switchRootContext.controlId` | Identifier used to associate a switch control with a switch input. Usually passed down via context. |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `switchRootContext.disabled` | Displays the switch in a disabled state. Can also be inherited from a `LabeledControl` or `FieldSet` parent. |
| `checkedState` | `boolean` | `switchRootContext.checkedState` | The on/off state of the switch. |
| `size` | `'md' \| 'lg'` | `switchRootContext.size` | The size of the switch, defaults to `md`. Can also be inherited from a `FieldSet` parent. |

