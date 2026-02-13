# DataSelect

```tsx
import { DataSelect } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 5.0.0

## Usage

```tsx
import { DataSelect } from '@zillow/constellation';
```

```tsx
export const DataSelectBasic = () => {
  return <DataSelect data={[1, 2, 3]} />;
};
```

## Examples

### Data Select Options As An Array Of Objects

```tsx
import { DataSelect } from '@zillow/constellation';
```

```tsx
export const DataSelectOptionsAsAnArrayOfObjects = () => {
  return (
    <DataSelect
      data={[
        { children: 'One', value: 1 },
        { children: 'Two', value: 2 },
      ]}
    />
  );
};
```

### Data Select Options As An Object

```tsx
import { DataSelect } from '@zillow/constellation';
```

```tsx
export const DataSelectOptionsAsAnObject = () => {
  return <DataSelect data={{ One: 1, Two: 2, Three: 3 }} />;
};
```

### Data Select Transforming Custom Data Structure

```tsx
import { DataSelect } from '@zillow/constellation';
```

```tsx
export const DataSelectTransformingCustomDataStructure = () => {
  return (
    <DataSelect
      data={{
        Fixed30Year: '30 year fixed',
        Fixed20Year: '20 year fixed',
        Fixed15Year: '15 year fixed',
        Fixed10Year: '10 year fixed',
        ARM7: '7/1 ARM',
        ARM5: '5/1 ARM',
        ARM3: '3/1 ARM',
      }}
      mapValueToProps={({ key, value }) => ({
        value: key,
        children: value,
        key: key,
      })}
    />
  );
};
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `disabled` | `boolean` | `false` | Displays the select in a disabled state. Can also be inherited from a FormField parent. |
| `error` | `boolean` | `false` | Displays the select in an error state. Can also be inherited from a FormField parent. |
| `fluid` | `boolean` | `true` | Selects are fluid by default which means they stretch to fill the entire width of their container. When `fluid="false"`, the select's width is set to `auto`. |
| `size` | `'sm' \| 'md' \| 'lg'` | `'md'` | Determines the size of the select. |
| `required` | `boolean` | `false` | Indicates the select is required. Can also be inherited from a FormField parent. |
| `readOnly` | `boolean` | `false` | Read-only state. Inherited from parent context if undefined. |
| `css` | `SystemStyleObject` | — | Styles object |
| `data` | `Array<any> \| Record<any, any>` | `[]` | The source data from which options will be constructed. If `data` is not already an array, you will need to use `dataTransform` to turn it into one. |
| `dataTransform` | `(data: Array<any> \| Record<any, any>) => Array<any>` | `defaultDataTransform` | A transform function that will translate the source data into an array of values. Arrays will be passed through directly by default. Objects will be transformed into an array of objects with `key` and `value` properties. |
| `mapValueToProps` | `(     value: any,   ) => Pick<ComponentProps<'option'>, 'children' \| 'value'> & { key: Key }` | `defaultMapValueToProps` | At the minimum, all `<option>` elements should receive `value`, `key`, and `children` props. This function will translate the list value from `data` into an object including the three required `<option>` props. By default, primitive values (i.e. strings, numbers) will be used as the `<option>` `value` prop. For object values, `value`, `key`, and `children` will be pulled directly from the object. When `key` is missing, it will fallback to `value`. When `children` is missing, it will fallback first to `key`, and then to `value`. |
| `onValueChange` | `(value: any, index: number) => void` | — | Value change event handler. The first parameter is the selected value from your transformed `data` prop. The second parameter is the array index. |

