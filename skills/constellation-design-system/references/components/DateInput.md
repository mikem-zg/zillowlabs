# DateInput

```tsx
import { DateInput } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.0.0

## Usage

```tsx
import { DateInput } from '@zillow/constellation';
```

```tsx
export const DateInputBasic = () => {
  return <DateInput />;
};
```

## Examples

### Date Input Controlled

```tsx
import { DateInput } from '@zillow/constellation';
```

```tsx
export const DateInputControlled = () => {
  const [value, setValue] = useState('04/15/2025');

  const onChange = (event: ChangeEvent<HTMLInputElement>) => {
    setValue(event.target.value);
  };

  return <DateInput value={value} onChange={onChange} />;
};
```

### Date Input Default Value

```tsx
import { DateInput } from '@zillow/constellation';
```

```tsx
export const DateInputDefaultValue = () => {
  return <DateInput defaultValue="04/15/2025" />;
};
```

### Date Input Disabled

```tsx
import { DateInput } from '@zillow/constellation';
```

```tsx
export const DateInputDisabled = () => {
  return <DateInput disabled />;
};
```

### Date Input Error

```tsx
import { DateInput } from '@zillow/constellation';
```

```tsx
export const DateInputError = () => {
  return <DateInput error />;
};
```

### Date Input Read Only

```tsx
import { DateInput } from '@zillow/constellation';
```

```tsx
export const DateInputReadOnly = () => {
  return <DateInput readOnly defaultValue="04/15/2025" />;
};
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `autoComplete` | `string` | — | Used for [autofill](https://developers.google.com/web/updates/2015/06/checkout-faster-with-autofill). |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Disabled state. Inherited from parent context if undefined. |
| `error` | `boolean` | `false` | Error state. Inherited from parent context if undefined. |
| `fluid` | `boolean` | `true` | Inputs are fluid by default which means they stretch to fill the entire width of their container. When `fluid="false"`, the inputs's width is set to `auto`. |
| `readOnly` | `boolean` | `false` | Read-only state. Inherited from parent context if undefined. |
| `required` | `boolean` | `false` | Required state. Inherited from parent context if undefined. |
| `size` | `'sm' \| 'md' \| 'lg'` | `md` | The size of the input. |
| `value` | `Date \| string` | — | The value of the input. |
| `defaultValue` | `Date \| string` | — | The default value of the input. |

