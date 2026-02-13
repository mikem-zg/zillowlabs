# FormHelp

```tsx
import { FormHelp } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 4.0.0

## Usage

```tsx
import { FormHelp } from '@zillow/constellation';
```

```tsx
export const FormHelpBasic = () => <FormHelp>This is helper text</FormHelp>;
```

## Examples

### Form Help Disabled

```tsx
import { FormHelp } from '@zillow/constellation';
```

```tsx
export const FormHelpDisabled = () => <FormHelp disabled>This is disabled helper text</FormHelp>;
```

### Form Help Error

```tsx
import { FormHelp } from '@zillow/constellation';
```

```tsx
export const FormHelpError = () => <FormHelp error>This is error helper text</FormHelp>;
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Disabled state. Inherited from parent context if undefined. |
| `error` | `boolean` | `false` | Displays the form help in an error state. Usually inherited from a `FormField` or `FieldSet` parent. |

