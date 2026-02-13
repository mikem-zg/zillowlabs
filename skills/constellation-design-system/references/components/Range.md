# Range

```tsx
import { Range } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 6.11.0

## Usage

```tsx
import { Range } from '@zillow/constellation';
```

```tsx
export const RangeBasic = () => <Range />;
```

## Examples

### Range Disabled

```tsx
import { Range } from '@zillow/constellation';
```

```tsx
export const RangeDisabled = () => <Range disabled />;
```

## API

### Range

**Element:** `HTMLInputElement`

| Prop | Type | Default | Description |
| --- | --- | --- | --- |
| css | `SystemStyleObject` | - | Styles object |
| disabled | `boolean` | `false` | Disabled state. Inherited from parent context if undefined. |
| error | `boolean` | `false` | Error state. Inherited from parent context if undefined. |
| max | `string` | - | The greatest value in the range of permitted values |
| min | `string` | - | The lowest value in the range of permitted values |
| step | `string` | - | The step attribute is a number that specifies the granularity that the value must adhere to |

