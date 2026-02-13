# Select

```tsx
import { Select } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 2.1.0

## Usage

```tsx
import { Select } from '@zillow/constellation';
```

```tsx
export const SelectBasic = () => (
  <Select>
    <option value="1">Option 1</option>
    <option value="2">Option 2</option>
    <option value="3">Option 3</option>
  </Select>
);
```

## Examples

### Select Controlled

```tsx
import { Box, Select } from '@zillow/constellation';
```

```tsx
export const SelectControlled = () => {
  const [value, setValue] = useState('3');

  return (
    <Box css={{ display: 'flex', flexDirection: 'column', gap: '10' }}>
      <Select
        value={value}
        onChange={(event) => {
          setValue(event.target.value);
        }}
      >
        <option value="1">Option 1</option>
        <option value="2">Option 2</option>
        <option value="3">Option 3</option>
      </Select>
      <div>
        <button
          type="button"
          onClick={() => {
            setValue('1');
          }}
        >
          Set Value 1
        </button>
        <button
          type="button"
          onClick={() => {
            setValue('2');
          }}
        >
          Set Value 2
        </button>
        <button
          type="button"
          onClick={() => {
            setValue('3');
          }}
        >
          Set Value 3
        </button>
      </div>
    </Box>
  );
};
```

### Select Default Value

```tsx
import { Select } from '@zillow/constellation';
```

```tsx
export const SelectDefaultValue = () => (
  <Select defaultValue="2">
    <option value="1">Option 1</option>
    <option value="2">Option 2</option>
    <option value="3">Option 3</option>
  </Select>
);
```

### Select Disabled

```tsx
import { Select } from '@zillow/constellation';
```

```tsx
export const SelectDisabled = () => (
  <Select disabled>
    <option value="1">Option 1</option>
    <option value="2">Option 2</option>
    <option value="3">Option 3</option>
  </Select>
);
```

### Select In Form Field

```tsx
import { Box, FormField, FormHelp, Heading, Label, Select } from '@zillow/constellation';
```

```tsx
export const SelectInFormField = () => (
  <Box css={{ display: 'flex', gap: 'layout.loosest', flexDirection: 'column' }}>
    <Box>
      <Heading
        textStyle="body-lg-bold"
        level={2}
        css={{ color: 'text.subtle', marginBlockEnd: 'tight' }}
      >
        Base
      </Heading>
      <FormField
        label={<Label>Country</Label>}
        control={
          <Select defaultValue="2">
            <option value="1">United States</option>
            <option value="2">Canada</option>
            <option value="3">Mexico</option>
          </Select>
        }
        description={<FormHelp>Select your country</FormHelp>}
      />
    </Box>
    <Box>
      <Heading
        textStyle="body-lg-bold"
        level={2}
        css={{ color: 'text.subtle', marginBlockEnd: 'tight' }}
      >
        Disabled
      </Heading>
      <FormField
        disabled
        label={<Label>Country</Label>}
        control={
          <Select defaultValue="2">
            <option value="1">United States</option>
            <option value="2">Canada</option>
            <option value="3">Mexico</option>
          </Select>
        }
        description={<FormHelp>Select your country</FormHelp>}
      />
    </Box>
    <Box>
      <Heading
        textStyle="body-lg-bold"
        level={2}
        css={{ color: 'text.subtle', marginBlockEnd: 'tight' }}
      >
        Required
      </Heading>
      <FormField
        required
        label={<Label>Country</Label>}
        control={
          <Select defaultValue="2">
            <option value="1">United States</option>
            <option value="2">Canada</option>
            <option value="3">Mexico</option>
          </Select>
        }
        description={<FormHelp>Select your country</FormHelp>}
      />
    </Box>
    <Box>
      <Heading
        textStyle="body-lg-bold"
        level={2}
        css={{ color: 'text.subtle', marginBlockEnd: 'tight' }}
      >
        Optional
      </Heading>
      <FormField
        optional
        label={<Label>Country</Label>}
        control={
          <Select defaultValue="2">
            <option value="1">United States</option>
            <option value="2">Canada</option>
            <option value="3">Mexico</option>
          </Select>
        }
        description={<FormHelp>Select your country</FormHelp>}
      />
    </Box>
    <Box>
      <Heading
        textStyle="body-lg-bold"
        level={2}
        css={{ color: 'text.subtle', marginBlockEnd: 'tight' }}
      >
        Error
      </Heading>
      <FormField
        error
        label={<Label>Country</Label>}
        control={
          <Select defaultValue="2">
            <option value="1">United States</option>
            <option value="2">Canada</option>
            <option value="3">Mexico</option>
          </Select>
        }
        description={<FormHelp>Select your country</FormHelp>}
      />
    </Box>
    <Box>
      <Heading
        textStyle="body-lg-bold"
        level={2}
        css={{ color: 'text.subtle', marginBlockEnd: 'tight' }}
      >
        Readonly
      </Heading>
      <FormField
        readOnly
        label={<Label>Country</Label>}
        control={
          <Select defaultValue="2">
            <option value="1">United States</option>
            <option value="2">Canada</option>
            <option value="3">Mexico</option>
          </Select>
        }
        description={<FormHelp>Select your country</FormHelp>}
      />
    </Box>
  </Box>
);
```

### Select Not Fluid

```tsx
import { Select } from '@zillow/constellation';
```

```tsx
export const SelectNotFluid = () => (
  <Select fluid={false}>
    <option value="1">Option 1</option>
    <option value="2">Option 2</option>
    <option value="3">Option 3</option>
  </Select>
);
```

### Select Optgroup

```tsx
import { Select } from '@zillow/constellation';
```

```tsx
export const SelectOptgroup = () => (
  <Select>
    <optgroup label="Group 1">
      <option value="1">Option 1</option>
      <option value="2">Option 2</option>
    </optgroup>
    <optgroup label="Group 2">
      <option value="3">Option 3</option>
      <option value="4">Option 4</option>
    </optgroup>
  </Select>
);
```

### Select Read Only

```tsx
import { Select } from '@zillow/constellation';
```

```tsx
export const SelectReadOnly = () => (
  <Select readOnly defaultValue="3">
    <option value="1">Option 1</option>
    <option value="2">Option 2</option>
    <option value="3">Option 3</option>
  </Select>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | `<option>` and `<optgroup>` nodes **(required)** |
| `disabled` | `boolean` | `false` | Displays the select in a disabled state. Can also be inherited from a FormField parent. |
| `error` | `boolean` | `false` | Displays the select in an error state. Can also be inherited from a FormField parent. |
| `fluid` | `boolean` | `true` | Selects are fluid by default which means they stretch to fill the entire width of their container. When `fluid="false"`, the select's width is set to `auto`. |
| `size` | `'sm' \| 'md' \| 'lg'` | `'md'` | Determines the size of the select. |
| `required` | `boolean` | `false` | Indicates the select is required. Can also be inherited from a FormField parent. |
| `readOnly` | `boolean` | `false` | Read-only state. Inherited from parent context if undefined. |
| `css` | `SystemStyleObject` | — | Styles object |

