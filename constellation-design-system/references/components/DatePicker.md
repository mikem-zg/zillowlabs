# DatePicker

```tsx
import { DatePicker } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 5.0.0

## Usage

```tsx
import { DatePicker } from '@zillow/constellation';
```

```tsx
export const DatePickerBasic = () => {
  return <DatePicker />;
};
```

## Examples

### Date Picker Close Modal On Date Select

```tsx
import { DatePicker } from '@zillow/constellation';
```

```tsx
export const DatePickerCloseModalOnDateSelect = () => {
  return <DatePicker closeModalOnDateSelect />;
};
```

### Date Picker Controlled

```tsx
import { DatePicker } from '@zillow/constellation';
```

```tsx
export const DatePickerControlled = () => {
  const [value, setValue] = useState(format(startOfToday(), 'MM/dd/yyyy'));

  const onValueChange = (newValue: string | Date) => {
    if (typeof newValue === 'string') {
      setValue(newValue);
    } else if (newValue instanceof Date) {
      setValue(format(newValue, 'MM/dd/yyyy'));
    }
  };

  return <DatePicker value={value} onValueChange={onValueChange} />;
};
```

### Date Picker Disabled Dates

```tsx
import { DatePicker } from '@zillow/constellation';
```

```tsx
export const DatePickerDisabledDates = () => {
  return (
    <DatePicker
      disabledDates={[
        addDays(startOfToday(), 1),
        addDays(startOfToday(), 2),
        addDays(startOfToday(), 3),
      ]}
    />
  );
};
```

### Date Picker Error

```tsx
import { DatePicker, FormField, FormHelp, Label } from '@zillow/constellation';
```

```tsx
export const DatePickerError = () => {
  return (
    <FormField
      error
      label={<Label>Date</Label>}
      control={<DatePicker error />}
      description={<FormHelp>Something went wrong</FormHelp>}
    />
  );
};
```

### Date Picker Read Only

```tsx
import { DatePicker } from '@zillow/constellation';
```

```tsx
export const DatePickerReadOnly = () => {
  return <DatePicker readOnly value={format(startOfToday(), 'MM/dd/yyyy')} />;
};
```

### Date Picker With Form Field

```tsx
import { Box, DatePicker, FormField, FormHelp, Heading, Label } from '@zillow/constellation';
```

```tsx
export const DatePickerWithFormField = () => {
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
          label={<Label>Date</Label>}
          control={<DatePicker value={format(startOfToday(), 'MM/dd/yyyy')} />}
          description={<FormHelp>Use format MM/DD/YYYY</FormHelp>}
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
          label={<Label>Date</Label>}
          control={<DatePicker value={format(startOfToday(), 'MM/dd/yyyy')} />}
          description={<FormHelp>Use format MM/DD/YYYY</FormHelp>}
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
          label={<Label>Date</Label>}
          control={<DatePicker value={format(startOfToday(), 'MM/dd/yyyy')} />}
          description={<FormHelp>Use format MM/DD/YYYY</FormHelp>}
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
          label={<Label>Date</Label>}
          control={<DatePicker value={format(startOfToday(), 'MM/dd/yyyy')} />}
          description={<FormHelp>Use format MM/DD/YYYY</FormHelp>}
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
          label={<Label>Date</Label>}
          control={<DatePicker value={format(startOfToday(), 'MM/dd/yyyy')} />}
          description={<FormHelp>Use format MM/DD/YYYY</FormHelp>}
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
          label={<Label>Date</Label>}
          control={<DatePicker value={format(startOfToday(), 'MM/dd/yyyy')} />}
          description={<FormHelp>Use format MM/DD/YYYY</FormHelp>}
        />
      </Box>
    </Box>
  );
};
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `dateFormat` | `string` | `MM/dd/yyyy` | The format of the date when parsing date strings. This format will also be used for formatting dates returned to the `onChange` callback.  Formatting options can be seen in [date-fns](https://date-fns.org/v2.13.0/docs/format). |
| `defaultOpen` | `boolean` | — | Uncontrolled default state |
| `disabled` | `boolean` | `false` | Disabled state. Inherited from parent context if undefined. |
| `error` | `boolean` | `false` | Error state. Inherited from parent context if undefined. |
| `disabledDates` | `Array<Date \| string> \| ((date: Date) => boolean)` | `[]` | An array of dates that are unavailable to be selected. |
| `minDate` | `Date \| string` | — | The oldest date allowed by the date picker. Defaults to 5 years before the selected date. |
| `maxDate` | `Date \| string` | — | The newest date allowed by the date picker. Defaults to 5 years after the selected date. |
| `onValueChange` | `(value: Date \| string, meta: { reason: string }) => void` | — | Callback function when a day is selected from the calendar using a mouse or keyboard. The callback will receive two objects. One with the date object `date`, and the formatted date string `formatted` as properties. Second, with the meta information. |
| `value` | `Date \| string` | — | The value when using this as a [controlled component](https://reactjs.org/docs/forms.html#controlled-components). |
| `defaultValue` | `Date \| string` | — | The default value when using this as an [uncontrolled component](https://reactjs.org/docs/uncontrolled-components.html). |
| `modal` | `boolean` | `true` | When true, the DatePicker will look like a modal until the medium breakpoint. |
| `closeModalOnDateSelect` | `boolean` | `false` | When true, the DatePicker will close when a value is selected. |
| `offset` | `OffsetOptions` | `22` | DatePicker content offset from trigger |
| `overflowPadding` | `DetectOverflowOptions['padding']` | `8` | This describes the virtual padding around the boundary to check for overflow. |
| `readOnly` | `boolean` | `false` | Read-only state. Inherited from parent context if undefined. |
| `required` | `boolean` | `false` | Required state. Inherited from parent context if undefined. |
| `size` | `'sm' \| 'md' \| 'lg'` | `md` | The size of the date picker. |
| `shouldAwaitInteractionResponse` | `boolean` | `true` | Improve INP score by interrupting the main thread with interaction response. You might need to opt-out if you require a reliable access to the `event` object. |
| `shouldCloseOnViewportLeave` | `boolean` | `false` | Close the trigger when the user scrolls away from the trigger node. |
| `useClickProps` | `UseClickProps` | — | Floating UI's `useClick` props. See https://floating-ui.com/docs/useClick |
| `useDismissProps` | `UseDismissProps` | — | Floating UI's `useDismiss` props. See https://floating-ui.com/docs/useDimiss |
| `useRoleProps` | `UseRoleProps` | — | Floating UI's `useRole` props. See https://floating-ui.com/docs/useRole |
| `pendingValue` | `Date \| string` | — | The temporary value when closeModalOnDateSelect is true |
| `resetPendingValue` | `() => void` | — | The function to reset the temporary value to original value. |
| `input` | `ReactNode` | `<DateInput />` | The date picker input |
| `calendar` | `ReactNode` | `<Calendar />` | The date picker calendar |
| `trigger` | `ReactNode` | — | Custom trigger to be used as DatePicker.Trigger |
| `footer` | `ReactNode` | `<DatePickerButtonGroup />` | Custom content to be used within DatePicker.Footer |
| `portalId` | `FloatingPortalProps['id']` | — | Optionally selects the node with the id if it exists, or create it and append it to the specified root (by default document.body). Passed to DatePicker.Portal. |
| `portalRoot` | `FloatingPortalProps['root']` | — | Specifies the root node the portal container will be appended to. Passed to DatePicker.Portal. |
| `portalPreserveTabOrder` | `FloatingPortalProps['preserveTabOrder']` | `true` | When using non-modal focus management, this will preserve the tab order context based on the React tree instead of the DOM tree. Passed to DatePicker.Portal. |

### DatePickerBackdrop

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `lockScroll` | `boolean` | `false` | Whether the overlay should lock scrolling on the document body. |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### DatePickerButtonGroup

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |
| `onClickCancel` | `(event: MouseEvent<HTMLButtonElement>) => void` | — | Additional callback for the cancel button onClick |
| `onClickOk` | `(event: MouseEvent<HTMLButtonElement>) => void` | — | Additional callback for the ok button onClick |
| `onKeyDownCancel` | `(event: KeyboardEvent<HTMLButtonElement>) => void` | — | Additional callback for the cancel button onKeyDown |
| `onKeyDownOk` | `(event: KeyboardEvent<HTMLButtonElement>) => void` | — | Additional callback for the ok button onKeyDown |

### DatePickerClose

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

### DatePickerContent

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `focusManagerProps` | `FloatingFocusManagerProps` | `{}` | Floating UI's `FloatingFocusManager` props. See https://floating-ui.com/docs/FloatingFocusManager |

### DatePickerFooter

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### DatePickerInputGroup

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### DatePickerPortal

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `id` | `string` | — | Optionally selects the node with the id if it exists, or create it and append it to the specified `root` (by default `document.body`). |
| `root` | `HTMLElement \| ShadowRoot \| null \| React.MutableRefObject<HTMLElement \| ShadowRoot \| null>` | — | Specifies the root node the portal container will be appended to. |
| `preserveTabOrder` | `boolean` | — | When using non-modal focus management using `FloatingFocusManager`, this will preserve the tab order context based on the React tree instead of the DOM tree. |
| `css` | `SystemStyleObject` | — | Styles object |

### DatePickerRoot

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `rootContext` | `FloatingRootContext<RT>` | — |  |
| `elements` | `{         /**          * Externally passed reference element. Store in state.          */         reference?: Element \| null;         /**          * Externally passed floating element. Store in state.          */         floating?: HTMLElement \| null;     }` | — | Object of external elements as an alternative to the `refs` object setters. |
| `nodeId` | `string` | — | Unique node id when using `FloatingTree`. |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `dateFormat` | `string` | `MM/dd/yyyy` | The format of the date when parsing date strings. This format will also be used for formatting dates returned to the `onChange` callback. Formatting options can be seen in [date-fns](https://date-fns.org/v2.13.0/docs/format). |
| `defaultOpen` | `boolean` | — | Uncontrolled default state |
| `disabled` | `boolean` | `false` | Disabled state. Inherited from parent context if undefined. |
| `error` | `boolean` | `false` | Error state. Inherited from parent context if undefined. |
| `disabledDates` | `Array<Date \| string> \| ((date: Date) => boolean)` | `[]` | An array of dates that are unavailable to be selected. |
| `minDate` | `Date \| string` | — | The oldest date allowed by the date picker. Defaults to 5 years before the selected date. |
| `maxDate` | `Date \| string` | — | The newest date allowed by the date picker. Defaults to 5 years after the selected date. |
| `onValueChange` | `(value: Date \| string, meta: { reason: string }) => void` | — | Callback function when a day is selected from the calendar using a mouse or keyboard. The callback will receive two objects. One with the date object `date`, and the formatted date string `formatted` as properties. Second, with the meta information. |
| `value` | `Date \| string` | — | The value when using this as a [controlled component](https://reactjs.org/docs/forms.html#controlled-components). |
| `defaultValue` | `Date \| string` | — | The default value when using this as an [uncontrolled component](https://reactjs.org/docs/uncontrolled-components.html). |
| `modal` | `boolean` | `true` | When true, the DatePicker will look like a modal until the medium breakpoint. |
| `closeModalOnDateSelect` | `boolean` | `false` | When true, the DatePicker will close when a value is selected. |
| `offset` | `OffsetOptions` | `22` | DatePicker content offset from trigger |
| `overflowPadding` | `DetectOverflowOptions['padding']` | `8` | This describes the virtual padding around the boundary to check for overflow. |
| `readOnly` | `boolean` | `false` | Read-only state. Inherited from parent context if undefined. |
| `required` | `boolean` | `false` | Required state. Inherited from parent context if undefined. |
| `size` | `'sm' \| 'md' \| 'lg'` | `md` | The size of the date picker. |
| `shouldAwaitInteractionResponse` | `boolean` | `true` | Improve INP score by interrupting the main thread with interaction response. You might need to opt-out if you require a reliable access to the `event` object. |
| `shouldCloseOnViewportLeave` | `boolean` | `false` | Close the trigger when the user scrolls away from the trigger node. |
| `useClickProps` | `UseClickProps` | — | Floating UI's `useClick` props. See https://floating-ui.com/docs/useClick |
| `useDismissProps` | `UseDismissProps` | — | Floating UI's `useDismiss` props. See https://floating-ui.com/docs/useDimiss |
| `useRoleProps` | `UseRoleProps` | — | Floating UI's `useRole` props. See https://floating-ui.com/docs/useRole |
| `pendingValue` | `Date \| string` | — | The temporary value when closeModalOnDateSelect is true |
| `resetPendingValue` | `() => void` | — | The function to reset the temporary value to original value. |

### DatePickerTrigger

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

