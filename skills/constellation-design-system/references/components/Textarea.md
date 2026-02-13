# Textarea

```tsx
import { Textarea } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 3.0.0

## Usage

```tsx
import { Textarea } from '@zillow/constellation';
```

```tsx
export const TextareaBasic = () => <Textarea placeholder="Placeholder text" rows={3} />;
```

## Examples

### Textarea Disabled

```tsx
import { Textarea } from '@zillow/constellation';
```

```tsx
export const TextareaDisabled = () => <Textarea disabled placeholder="Placeholder text" rows={3} />;
```

### Textarea Error

```tsx
import { Textarea } from '@zillow/constellation';
```

```tsx
export const TextareaError = () => <Textarea error placeholder="Placeholder text" rows={3} />;
```

### Textarea In Form Field

```tsx
import { Box, FormField, FormHelp, Heading, Label, Textarea } from '@zillow/constellation';
```

```tsx
export const TextareaInFormField = () => (
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
        label={<Label>Description</Label>}
        control={
          <Textarea
            defaultValue="Lorem ipsum dolor sit amet, consectetur adipiscing elit."
            rows={3}
          />
        }
        description={<FormHelp>Help text</FormHelp>}
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
        label={<Label>Description</Label>}
        control={
          <Textarea
            defaultValue="Lorem ipsum dolor sit amet, consectetur adipiscing elit."
            rows={3}
          />
        }
        description={<FormHelp>Help text</FormHelp>}
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
        label={<Label>Description</Label>}
        control={
          <Textarea
            defaultValue="Lorem ipsum dolor sit amet, consectetur adipiscing elit."
            rows={3}
          />
        }
        description={<FormHelp>Help text</FormHelp>}
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
        label={<Label>Description</Label>}
        control={
          <Textarea
            defaultValue="Lorem ipsum dolor sit amet, consectetur adipiscing elit."
            rows={3}
          />
        }
        description={<FormHelp>Help text</FormHelp>}
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
        label={<Label>Description</Label>}
        control={
          <Textarea
            defaultValue="Lorem ipsum dolor sit amet, consectetur adipiscing elit."
            rows={3}
          />
        }
        description={<FormHelp>Help text</FormHelp>}
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
        label={<Label>Description</Label>}
        control={
          <Textarea
            defaultValue="Lorem ipsum dolor sit amet, consectetur adipiscing elit."
            rows={3}
          />
        }
        description={<FormHelp>Help text</FormHelp>}
      />
    </Box>
  </Box>
);
```

### Textarea Read Only

```tsx
import { Textarea } from '@zillow/constellation';
```

```tsx
export const TextareaReadOnly = () => <Textarea readOnly placeholder="Placeholder text" rows={3} />;
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Displays the textarea in a disabled state. Can also be inherited from a FormField parent. |
| `error` | `boolean` | `false` | Displays the textarea in an error state. Can also be inherited from a FormField parent. |
| `fluid` | `boolean` | `true` | Textareas are fluid by default which means they stretch to fill the entire width of their container. When `fluid="false"`, the textarea's width is set to `auto`. |
| `maxLength` | `number` | — | The [native textarea](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea) "maxlength" property. |
| `readOnly` | `boolean` | `false` | Displays the textarea in a read-only state. Can also be inherited from a FormField parent. |
| `resize` | `never` | — |  |
| `required` | `boolean` | `false` | Indicates the textarea is required. Can also be inherited from a FormField parent. |
| `rows` | `number` | `3` | The [native textarea](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea) "rows" property. |

