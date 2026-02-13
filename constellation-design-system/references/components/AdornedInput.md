# AdornedInput

```tsx
import { AdornedInput } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 5.0.0

## Usage

```tsx
import { AdornedInput } from '@zillow/constellation';
```

```tsx
export const AdornedInputBasic = () => {
  return (
    <AdornedInput
      input={<AdornedInput.Input aria-label="Amount" placeholder="Placeholder text" />}
      startAdornment={<AdornedInput.Adornment>$</AdornedInput.Adornment>}
      endAdornment={<AdornedInput.Adornment>/ month</AdornedInput.Adornment>}
    />
  );
};
```

## Examples

### Adorned Input Composed

```tsx
import { AdornedInput } from '@zillow/constellation';
```

```tsx
export const AdornedInputComposed = () => {
  return (
    <AdornedInput.Root>
      <AdornedInput.Adornment>$</AdornedInput.Adornment>
      <AdornedInput.Input aria-label="Monthly rental price" placeholder="Placeholder text" />
      <AdornedInput.Adornment>/ month</AdornedInput.Adornment>
    </AdornedInput.Root>
  );
};
```

### Adorned Input Custom Adornment Ids

```tsx
import { AdornedInput } from '@zillow/constellation';
```

```tsx
export const AdornedInputCustomAdornmentIds = () => {
  return (
    <AdornedInput
      input={<AdornedInput.Input aria-label="Amount" placeholder="Placeholder text" />}
      startAdornment={<AdornedInput.Adornment id="start-adornment">$</AdornedInput.Adornment>}
      endAdornment={<AdornedInput.Adornment id="end-adornment">/ month</AdornedInput.Adornment>}
    />
  );
};
```

### Adorned Input Custom Control Id

```tsx
import { AdornedInput } from '@zillow/constellation';
```

```tsx
export const AdornedInputCustomControlId = () => {
  return (
    <AdornedInput
      controlId="custom-control-id"
      input={<AdornedInput.Input aria-label="Amount" placeholder="Placeholder text" />}
      startAdornment={<AdornedInput.Adornment>$</AdornedInput.Adornment>}
      endAdornment={<AdornedInput.Adornment>/ month</AdornedInput.Adornment>}
    />
  );
};
```

### Adorned Input Disabled Fluid Width

```tsx
import { AdornedInput } from '@zillow/constellation';
```

```tsx
export const AdornedInputDisabledFluidWidth = () => {
  return (
    <AdornedInput
      fluid={false}
      input={<AdornedInput.Input aria-label="Amount" placeholder="Placeholder text" />}
      startAdornment={<AdornedInput.Adornment>$</AdornedInput.Adornment>}
      endAdornment={<AdornedInput.Adornment>/ month</AdornedInput.Adornment>}
    />
  );
};
```

### Adorned Input Disabled

```tsx
import { AdornedInput } from '@zillow/constellation';
```

```tsx
export const AdornedInputDisabled = () => {
  return (
    <AdornedInput
      disabled
      input={
        <AdornedInput.Input aria-label="Amount" placeholder="Placeholder text" defaultValue={800} />
      }
      startAdornment={<AdornedInput.Adornment>$</AdornedInput.Adornment>}
      endAdornment={<AdornedInput.Adornment>/ month</AdornedInput.Adornment>}
    />
  );
};
```

### Adorned Input Error

```tsx
import { AdornedInput } from '@zillow/constellation';
```

```tsx
export const AdornedInputError = () => {
  return (
    <AdornedInput
      error
      input={
        <AdornedInput.Input
          aria-label="Amount"
          placeholder="Placeholder text"
          defaultValue="abcd"
        />
      }
      startAdornment={<AdornedInput.Adornment>$</AdornedInput.Adornment>}
      endAdornment={<AdornedInput.Adornment>/ month</AdornedInput.Adornment>}
    />
  );
};
```

### Adorned Input In Form Field

```tsx
import { AdornedInput, Box, FormField, FormHelp, Heading, Label } from '@zillow/constellation';
```

```tsx
export const AdornedInputInFormField = () => {
  return (
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
          label={<Label>Monthly payment</Label>}
          control={
            <AdornedInput
              input={<AdornedInput.Input aria-label="Amount" defaultValue={800} />}
              startAdornment={<AdornedInput.Adornment>$</AdornedInput.Adornment>}
              endAdornment={<AdornedInput.Adornment>/ month</AdornedInput.Adornment>}
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
          label={<Label>Monthly payment</Label>}
          control={
            <AdornedInput
              input={<AdornedInput.Input aria-label="Amount" defaultValue={800} />}
              startAdornment={<AdornedInput.Adornment>$</AdornedInput.Adornment>}
              endAdornment={<AdornedInput.Adornment>/ month</AdornedInput.Adornment>}
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
          label={<Label>Monthly payment</Label>}
          control={
            <AdornedInput
              input={<AdornedInput.Input aria-label="Amount" defaultValue={800} />}
              startAdornment={<AdornedInput.Adornment>$</AdornedInput.Adornment>}
              endAdornment={<AdornedInput.Adornment>/ month</AdornedInput.Adornment>}
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
          label={<Label>Monthly payment</Label>}
          control={
            <AdornedInput
              input={<AdornedInput.Input aria-label="Amount" defaultValue={800} />}
              startAdornment={<AdornedInput.Adornment>$</AdornedInput.Adornment>}
              endAdornment={<AdornedInput.Adornment>/ month</AdornedInput.Adornment>}
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
          label={<Label>Monthly payment</Label>}
          control={
            <AdornedInput
              input={<AdornedInput.Input aria-label="Amount" defaultValue={800} />}
              startAdornment={<AdornedInput.Adornment>$</AdornedInput.Adornment>}
              endAdornment={<AdornedInput.Adornment>/ month</AdornedInput.Adornment>}
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
          label={<Label>Monthly payment</Label>}
          control={
            <AdornedInput
              input={<AdornedInput.Input aria-label="Amount" defaultValue={800} />}
              startAdornment={<AdornedInput.Adornment>$</AdornedInput.Adornment>}
              endAdornment={<AdornedInput.Adornment>/ month</AdornedInput.Adornment>}
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
          With Icon
        </Heading>
        <FormField
          label={<Label>Search</Label>}
          control={
            <AdornedInput
              input={<AdornedInput.Input aria-label="Search" />}
              endAdornment={
                <AdornedInput.Adornment>
                  <AdornedInput.Icon>
                    <IconSearchFilled />
                  </AdornedInput.Icon>
                </AdornedInput.Adornment>
              }
            />
          }
          description={<FormHelp>Help text</FormHelp>}
        />
      </Box>
    </Box>
  );
};
```

### Adorned Input Interactive As Child

```tsx
import { AdornedInput, Icon, IconButton } from '@zillow/constellation';
```

```tsx
export const AdornedInputInteractiveAsChild = () => {
  return (
    <AdornedInput
      input={<AdornedInput.Input aria-label="Search" placeholder="Placeholder text" />}
      endAdornment={
        <AdornedInput.Adornment asChild>
          <IconButton
            emphasis="bare"
            // oxlint-disable-next-line no-console
            onClick={() => console.log('Clicked button in AdornedInput.Adornment')}
            shape="square"
            size="md"
            title="Right"
            tone="neutral"
          >
            <Icon>
              <IconCloseCircleFilled />
            </Icon>
          </IconButton>
        </AdornedInput.Adornment>
      }
    />
  );
};
```

### Adorned Input Read Only

```tsx
import { AdornedInput } from '@zillow/constellation';
```

```tsx
export const AdornedInputReadOnly = () => {
  return (
    <AdornedInput
      readOnly
      input={
        <AdornedInput.Input aria-label="Amount" placeholder="Placeholder text" defaultValue={800} />
      }
      startAdornment={<AdornedInput.Adornment>$</AdornedInput.Adornment>}
      endAdornment={<AdornedInput.Adornment>/ month</AdornedInput.Adornment>}
    />
  );
};
```

### Adorned Input With Icon

```tsx
import { AdornedInput } from '@zillow/constellation';
```

```tsx
export const AdornedInputWithIcon = () => {
  return (
    <AdornedInput
      input={<AdornedInput.Input aria-label="Search" />}
      endAdornment={
        <AdornedInput.Adornment>
          <AdornedInput.Icon>
            <IconSearchFilled />
          </AdornedInput.Icon>
        </AdornedInput.Adornment>
      }
    />
  );
};
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `startAdornment` | `ReactNode` | — | Takes an Adornment component. |
| `endAdornment` | `ReactNode` | — | Takes an Adornment component. |
| `input` | `ReactNode` | — | Takes an Input component. **(required)** |

### AdornedInputAdornment

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'asChild'` | `boolean` | `false` | Use child as the root element |
| `'children'` | `ReactNode` | — | Content **(required)** |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'aria-hidden'` | `AriaAttributes['aria-hidden']` | `true` | Set to `true` in most situations. An adornment is associated with an input using other attributes and will be announced by screen readers when the input gains focus. Setting `aria-hidden="true"` ensures the adornment isn't repeated again when the user steps through the content. |

### AdornedInputIcon

**Element:** `SVGSVGElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | The SVG icon to render. |
| `css` | `SystemStyleObject` | — | Styles object |
| `focusable` | `ComponentProps<'svg'>['focusable']` | `false` | The SVG [`focusable`](https://www.w3.org/TR/SVGTiny12/interact.html#focusable-attr) attribute. |
| `role` | `AriaRole` | `img` | The role is set to "img" by default to exclude all child content from the accessibility tree. |
| `size` | `ResponsiveVariant<'sm' \| 'md' \| 'lg' \| 'xl'>` | — | By default, icons are sized to `1em` to match the size of the text content. For fixed-width sizes, you can use the `size` prop. |
| `render` | `ReactNode` | — | Alternative to children. |
| `title` | `string` | — | Creates an accessible label for the icon for contextually meaninful icons, and sets the appropriate `aria` attributes. Icons are hidden from screen readers by default without this prop.  Note: specifying `aria-labelledby`, `aria-hidden`, or `children` manually while using this prop may produce accessibility errors. This prop is only available on prebuilt icons within Constellation. |

### AdornedInputInput

**Element:** `HTMLInputElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `autoComplete` | `string` | — | Used for [autofill](https://developers.google.com/web/updates/2015/06/checkout-faster-with-autofill). |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Disabled state. Inherited from parent context if undefined. |
| `error` | `boolean` | `false` | Error state. Inherited from parent context if undefined. |
| `readOnly` | `boolean` | `false` | Read-only state. Inherited from parent context if undefined. |
| `required` | `boolean` | `false` | Required state. Inherited from parent context if undefined. |
| `type` | `HTMLInputTypeAttribute` | `text` | The HTML input type. |

### AdornedInputRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `controlId` | `string` | `formFieldContext.controlId \|\| defaultId` | Identifier used for input and labels. This will be used as the `id` by `AdornedInput` and the `htmlFor` by `Label`. If no `controlId` is specified, one will automatically be generated. |
| `error` | `boolean` | `false` | Displays the Input and Adornments in an error state. Can also be inherited from a FormField parent. |
| `size` | `'sm' \| 'md' \| 'lg'` | `md` | This will set the `size` prop for the nested Input. |
| `disabled` | `boolean` | `false` | Displays the Input and Adornments in a disabled state. Can also be inherited from a FormField parent. |
| `fluid` | `boolean` | `true` | This will set the `fluid` prop on the nested Input. Inputs are fluid by default which means they stretch to fill the entire width of their container. When `fluid="false"`, the Input's width is set to `auto`. |
| `required` | `boolean` | `false` | Indicates the input is required. Can be inherited from FormField context. |
| `readOnly` | `boolean` | `false` | Displays the Input in a read-only state. Can also be inherited from a FormField parent. |

