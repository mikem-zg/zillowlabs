# DropdownSelect

```tsx
import { DropdownSelect } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.28.0

## Usage

```tsx
import { DropdownSelect } from '@zillow/constellation';
```

```tsx
export const DropdownSelectBasic = () => (
  <DropdownSelect
    options={[...statesAsStrings]}
    defaultValue="Michigan"
    placeholder="Select state"
  />
);
```

## Examples

### States As Strings

```tsx
import { DropdownSelect } from '@zillow/constellation';
```

```tsx
export const statesAsStrings = [
  'Alabama',
  'Alaska',
  'Arizona',
  'Arkansas',
  'California',
  'Colorado',
  'Connecticut',
  'Delaware',
  'Florida',
  'Georgia',
  'Hawaii',
  'Idaho',
  'Illinois',
  'Indiana',
  'Iowa',
  'Kansas',
  'Kentucky',
  'Louisiana',
  'Maine',
  'Maryland',
  'Massachusetts',
  'Michigan',
  'Minnesota',
  'Mississippi',
  'Missouri',
  'Montana',
  'Nebraska',
  'Nevada',
  'New Hampshire',
  'New Jersey',
  'New Mexico',
  'New York',
  'North Carolina',
  'North Dakota',
  'Ohio',
  'Oklahoma',
  'Oregon',
  'Pennsylvania',
  'Rhode Island',
  'South Carolina',
  'South Dakota',
  'Tennessee',
  'Texas',
  'Utah',
  'Vermont',
  'Virginia',
  'Washington',
  'West Virginia',
  'Wisconsin',
  'Wyoming',
] as const;

export const statesAsObjects = [
  { label: 'Alabama', value: 'AL' },
  { label: 'Alaska', value: 'AK' },
  { label: 'Arizona', value: 'AZ' },
  { label: 'Arkansas', value: 'AR' },
  { label: 'California', value: 'CA' },
  { label: 'Colorado', value: 'CO' },
  { label: 'Connecticut', value: 'CT' },
  { label: 'Delaware', value: 'DE' },
  { label: 'Florida', value: 'FL' },
  { label: 'Georgia', value: 'GA' },
  { label: 'Hawaii', value: 'HI' },
  { label: 'Idaho', value: 'ID' },
  { label: 'Illinois', value: 'IL' },
  { label: 'Indiana', value: 'IN' },
  { label: 'Iowa', value: 'IA' },
  { label: 'Kansas', value: 'KS' },
  { label: 'Kentucky', value: 'KY' },
  { label: 'Louisiana', value: 'LA' },
  { label: 'Maine', value: 'ME' },
  { label: 'Maryland', value: 'MD' },
  { label: 'Massachusetts', value: 'MA' },
  { label: 'Michigan', value: 'MI' },
  { label: 'Minnesota', value: 'MN' },
  { label: 'Mississippi', value: 'MS' },
  { label: 'Missouri', value: 'MO' },
  { label: 'Montana', value: 'MT' },
  { label: 'Nebraska', value: 'NE' },
  { label: 'Nevada', value: 'NV' },
  { label: 'New Hampshire', value: 'NH' },
  { label: 'New Jersey', value: 'NJ' },
  { label: 'New Mexico', value: 'NM' },
  { label: 'New York', value: 'NY' },
  { label: 'North Carolina', value: 'NC' },
  { label: 'North Dakota', value: 'ND' },
  { label: 'Ohio', value: 'OH' },
  { label: 'Oklahoma', value: 'OK' },
  { label: 'Oregon', value: 'OR' },
  { label: 'Pennsylvania', value: 'PA' },
  { label: 'Rhode Island', value: 'RI' },
  { label: 'South Carolina', value: 'SC' },
  { label: 'South Dakota', value: 'SD' },
  { label: 'Tennessee', value: 'TN' },
  { label: 'Texas', value: 'TX' },
  { label: 'Utah', value: 'UT' },
  { label: 'Vermont', value: 'VT' },
  { label: 'Virginia', value: 'VA' },
  { label: 'Washington', value: 'WA' },
  { label: 'West Virginia', value: 'WV' },
  { label: 'Wisconsin', value: 'WI' },
  { label: 'Wyoming', value: 'WY' },
] as const;

export const statesAsGroups = [
  {
    heading: 'Northwest',
    options: [
      { label: 'Alaska', value: 'AK' },
      { label: 'Idaho', value: 'ID' },
      { label: 'Montana', value: 'MT' },
      { label: 'Oregon', value: 'OR' },
      { label: 'Washington', value: 'WA' },
      { label: 'Wyoming', value: 'WY' },
    ],
  },
  {
    heading: 'Southwest',
    options: [
      { label: 'Arizona', value: 'AZ' },
      { label: 'California', value: 'CA' },
      { label: 'Colorado', value: 'CO' },
      { label: 'Hawaii', value: 'HI' },
      { label: 'Nevada', value: 'NV' },
      { label: 'New Mexico', value: 'NM' },
      { label: 'Oklahoma', value: 'OK' },
      { label: 'Texas', value: 'TX' },
      { label: 'Utah', value: 'UT' },
    ],
  },
  {
    heading: 'Northeast',
    options: [
      { label: 'Connecticut', value: 'CT' },
      { label: 'Delaware', value: 'DE' },
      { label: 'Maine', value: 'ME' },
      { label: 'Maryland', value: 'MD' },
      { label: 'Massachusetts', value: 'MA' },
      { label: 'New Hampshire', value: 'NH' },
      { label: 'New Jersey', value: 'NJ' },
      { label: 'New York', value: 'NY' },
      { label: 'Pennsylvania', value: 'PA' },
      { label: 'Rhode Island', value: 'RI' },
      { label: 'Vermont', value: 'VT' },
    ],
  },
  {
    heading: 'Southeast',
    options: [
      { label: 'Alabama', value: 'AL' },
      { label: 'Arkansas', value: 'AR' },
      { label: 'Florida', value: 'FL' },
      { label: 'Georgia', value: 'GA' },
      { label: 'Kentucky', value: 'KY' },
      { label: 'Louisiana', value: 'LA' },
      { label: 'Mississippi', value: 'MS' },
      { label: 'Missouri', value: 'MO' },
      { label: 'North Carolina', value: 'NC' },
      { label: 'South Carolina', value: 'SC' },
      { label: 'Tennessee', value: 'TN' },
      { label: 'Virginia', value: 'VA' },
      { label: 'West Virginia', value: 'WV' },
    ],
  },
] as const;
```

### Dropdown Select Complex Options

```tsx
import { DropdownSelect, Icon } from '@zillow/constellation';
```

```tsx
export const DropdownSelectComplexOptions = () => (
  <DropdownSelect
    options={statesAsObjects.map((state) => ({
      ...state,
      meta: 'Optional meta',
      icon: <Icon render={<IconLocationFilled />} />,
    }))}
    showLabelForValue
    placeholder="Select state"
  />
);
```

### Dropdown Select Controlled Open State

```tsx
import { Box, DropdownSelect, Text } from '@zillow/constellation';
```

```tsx
export const DropdownSelectControlledOpenState = () => {
  const [open, setOpen] = useState<boolean>(false);
  const [callbackOpen, setCallbackOpen] = useState<boolean | undefined>(undefined);
  const [callbackReason, setCallbackReason] = useState<string | undefined>(undefined);

  // @ts-ignore
  const handler: UseFloatingOptions['onOpenChange'] = (open, event, reason) => {
    setOpen(open);
    setCallbackOpen(open);
    setCallbackReason(reason);
  };

  return (
    <Box css={{ display: 'flex', flexDirection: 'column', gap: 'tight' }}>
      <Text textStyle="body-sm">
        Current <code>open</code>: <code>{JSON.stringify(open)}</code>
      </Text>
      <Text textStyle="body-sm">
        Last <code>onChange</code> callback <code>value</code>:{' '}
        <code>{JSON.stringify(callbackOpen)}</code>
      </Text>
      <Text textStyle="body-sm">
        Last <code>onOpenChange</code> callback <code>reason</code>:{' '}
        <code>&#39;{callbackReason}&#39;</code>
      </Text>
      <DropdownSelect
        options={[...statesAsStrings]}
        open={open}
        onOpenChange={handler}
        placeholder="Select state"
      />
    </Box>
  );
};
```

### Dropdown Select Controlled

```tsx
import { Box, Button, ButtonGroup, DropdownSelect, Paragraph, Text } from '@zillow/constellation';
```

```tsx
export const DropdownSelectControlled = () => {
  const [value, setValue] = useState<string | undefined>(undefined);
  const [callbackValue, setCallbackValue] = useState<string | undefined>(undefined);
  const [callbackReason, setCallbackReason] = useState<string | undefined>(undefined);

  const onChangeCallback = useCallback<ComboboxOnChangeType<string>>(
    // @ts-ignore
    (newValue, event, reason) => {
      setValue(newValue);
      setCallbackValue(newValue);
      setCallbackReason(reason);
    },
    [],
  );

  return (
    <Box css={{ display: 'flex', flexDirection: 'column', gap: 'tight' }}>
      <Text textStyle="body-sm">
        Current <code>value</code>: <code>&#39;{value}&#39;</code>
      </Text>
      <Text textStyle="body-sm">
        Last <code>onChange</code> callback <code>value</code>:{' '}
        <code>&#39;{callbackValue}&#39;</code>
      </Text>
      <Text textStyle="body-sm">
        Last <code>onChange</code> callback <code>reason</code>:{' '}
        <code>&#39;{callbackReason}&#39;</code>
      </Text>
      <DropdownSelect
        value={value}
        onChange={onChangeCallback}
        options={[...statesAsStrings]}
        placeholder="Select state"
      />
      <Paragraph>
        Controlled value changes do not trigger callbacks, as these are reserved for user
        interactions only. This follows standard React controlled component patterns and prevents
        circular update loops between parent and child components.
      </Paragraph>
      <ButtonGroup aria-label="Dynamic values">
        <Button onClick={() => setValue('Texas')}>Set to Texas</Button>
        <Button onClick={() => setValue('')}>Clear Selection</Button>
      </ButtonGroup>
    </Box>
  );
};
```

### Dropdown Select Disabled Options

```tsx
import { DropdownSelect } from '@zillow/constellation';
```

```tsx
export const DropdownSelectDisabledOptions = () => (
  <DropdownSelect
    options={statesAsObjects.map((state) => ({
      ...state,
      disabled: Math.random() > 0.5,
    }))}
    showLabelForValue
    placeholder="Select state"
  />
);
```

### Dropdown Select Fluid Dropdown

```tsx
import { Box, DropdownSelect, Icon } from '@zillow/constellation';
```

```tsx
export const DropdownSelectFluidDropdown = () => (
  <Box css={{ maxWidth: '200px' }}>
    <DropdownSelect
      options={statesAsObjects.map((state) => ({
        ...state,
        meta: 'A very, very, very, long optional meta entry',
        icon: <Icon render={<IconLocationFilled />} />,
      }))}
      fluidDropdown={false}
      placeholder="Select state"
    />
  </Box>
);
```

### Dropdown Select Grouped Options

```tsx
import { DropdownSelect, Icon } from '@zillow/constellation';
```

```tsx
export const DropdownSelectGroupedOptions = () => (
  <DropdownSelect
    options={statesAsGroups.map((group) => ({
      heading: {
        icon: <Icon render={<IconLocationFilled />} />,
        label: group.heading,
      },
      options: group.options.map((option) => ({
        ...option,
        meta: 'Optional meta',
        icon: <Icon render={<IconLocationFilled />} />,
      })),
    }))}
    showLabelForValue
    placeholder="Select state"
  />
);
```

### Dropdown Select Multi Select Controlled

```tsx
import { Box, Button, ButtonGroup, DropdownSelect, Paragraph, Text } from '@zillow/constellation';
```

```tsx
export const DropdownSelectMultiSelectControlled = () => {
  const [value, setValue] = useState<Array<string>>([]);
  const [callbackValue, setCallbackValue] = useState<Array<string>>([]);
  const [callbackReason, setCallbackReason] = useState<string | undefined>(undefined);

  const onChangeCallback = useCallback<ComboboxOnChangeType<Array<string>>>(
    // @ts-ignore
    (newValue, event, reason) => {
      setValue(newValue);
      setCallbackValue(newValue);
      setCallbackReason(reason);
    },
    [],
  );

  return (
    <Box css={{ display: 'flex', flexDirection: 'column', gap: 'tight' }}>
      <Text textStyle="body-sm">
        Current <code>value</code>: <code>{JSON.stringify(value)}</code>
      </Text>
      <Text textStyle="body-sm">
        Last <code>onChange</code> callback <code>value</code>:{' '}
        <code>{JSON.stringify(callbackValue)}</code>
      </Text>
      <Text textStyle="body-sm">
        Last <code>onChange</code> callback <code>reason</code>:{' '}
        <code>{JSON.stringify(callbackReason)}</code>
      </Text>
      <DropdownSelect
        value={value}
        onChange={onChangeCallback}
        options={[...statesAsStrings]}
        placeholder="Select state"
      />
      <Paragraph>
        Controlled value changes do not trigger callbacks, as these are reserved for user
        interactions only. This follows standard React controlled component patterns and prevents
        circular update loops between parent and child components.
      </Paragraph>
      <ButtonGroup aria-label="Dynamic values">
        <Button onClick={() => setValue(['Texas'])}>Set to Texas</Button>
        <Button onClick={() => setValue([])}>Clear Selection</Button>
      </ButtonGroup>
    </Box>
  );
};
```

### Dropdown Select Multi Select

```tsx
import { DropdownSelect } from '@zillow/constellation';
```

```tsx
export const DropdownSelectMultiSelect = () => (
  <DropdownSelect options={[...statesAsStrings]} defaultValue={['Arizona', 'Michigan', 'Texas']} />
);
```

### Dropdown Select No Heading Groups With Dividers

```tsx
import { DropdownSelect } from '@zillow/constellation';
```

```tsx
export const DropdownSelectNoHeadingGroupsWithDividers = () => (
  <DropdownSelect
    dividers
    options={statesAsGroups.map((group) => ({
      heading: {
        label: group.heading,
        visuallyHidden: true,
      },
      options: group.options.map((option) => ({
        ...option,
      })),
    }))}
    showLabelForValue
    placeholder="Select state"
  />
);
```

### Dropdown Select Show Label As Value

```tsx
import { Box, DropdownSelect } from '@zillow/constellation';
```

```tsx
export const DropdownSelectShowLabelAsValue = () => (
  <Box css={{ display: 'flex', flexDirection: 'column', gap: 'tight' }}>
    <DropdownSelect options={[...statesAsObjects]} placeholder="Show value for value" />
    <DropdownSelect
      options={[...statesAsObjects]}
      placeholder="Show label for value"
      showLabelForValue
    />
  </Box>
);
```

### Dropdown Select Show Option Control

```tsx
import { Box, DropdownSelect } from '@zillow/constellation';
```

```tsx
export const DropdownSelectShowOptionControl = () => (
  <Box css={{ display: 'flex', flexDirection: 'column', gap: 'default' }}>
    <DropdownSelect options={[...statesAsStrings]} showOptionControl placeholder="Select state" />
    <DropdownSelect
      options={[...statesAsStrings]}
      defaultValue={['Michigan', 'Texas']}
      showOptionControl
    />
  </Box>
);
```

### Dropdown Select Various States

```tsx
import { Box, DropdownSelect } from '@zillow/constellation';
```

```tsx
export const DropdownSelectVariousStates = () => (
  <Box css={{ display: 'flex', flexDirection: 'column', gap: 'default' }}>
    <DropdownSelect options={[...statesAsStrings]} error placeholder="Error state" />
    <DropdownSelect options={[...statesAsStrings]} disabled placeholder="Disabled state" />
    <DropdownSelect options={[...statesAsStrings]} size="sm" placeholder="Small size" />
    <DropdownSelect options={[...statesAsStrings]} size="lg" placeholder="Large size" />
  </Box>
);
```

### Dropdown Select Within Form Field

```tsx
import { DropdownSelect, FormField, FormHelp, Label } from '@zillow/constellation';
```

```tsx
export const DropdownSelectWithinFormField = () => (
  <FormField
    control={<DropdownSelect options={[...statesAsStrings]} placeholder="Select state" />}
    label={<Label>State of residence</Label>}
    description={<FormHelp>Help text</FormHelp>}
  />
);
```

## API

`DropdownSelectPropsInterface<ValueType>` extends `ComboboxPropsInterface<ValueType>` with the following props omitted: `appearance`, `autoCompleteBehavior`, `focusFirstOption`, `freeForm`, `editable`, `getHighlightPattern`, `limitChipsShown`, `loading`, `onChipClose`, `optionFilter`, `selectCallbackFrequency`.

`ValueType` extends `ComboboxValueType` which is `string | Array<string>`.

| Prop | Type | Default | Description |
| --- | --- | --- | --- |
| allowSubmitWhileOpen | `boolean` | `false` | If enabled, pressing "enter" will both select an option and submit a form while the dropdown is open. Useful for search box experiences. |
| children | `ReactNode` | - | Content |
| css | `SystemStyleObject` | - | Styles object |
| defaultOpen | `boolean` | - | Uncontrolled default open state |
| defaultValue | `ValueType` | - | Uncontrolled default value state |
| disabled | `boolean` | `false` | Disabled state. Inherited from parent context if undefined. |
| dividers | `boolean` | `false` | Show divider between groups |
| error | `boolean` | `false` | Error state. Inherited from parent context if undefined. |
| fluidDropdown | `boolean` | `false` | When enabled, the dropdown will be fluid to match the width of the combobox. Disable this and the width of the dropdown will be based on the dropdown content. |
| offset | `OffsetOptions` | `22` | Dropdown content offset from trigger |
| onChange | `ComboboxOnChangeType<ValueType>` | - | Called whenever there is a change in value. Receives new value, event, and reason for change. |
| onClear | `(event: SyntheticEvent<HTMLButtonElement>) => void` | - | Called whenever clear button is clicked and value is cleared. |
| onOpenChange | `UseFloatingOptions['onOpenChange']` | - | Controlled event. Receives `open` state, `event` object, and `reason` for state change. |
| onOptionFocus | `(option: ComboboxOptionType) => void` | - | Called whenever the active descendant option changes. Passes option as string or object. |
| onOptionSelect | `(option: ComboboxOptionType) => void` | - | Called whenever an option is selected. Passes option as string or object. By default only called when the action results in a change of value. |
| open | `UseFloatingOptions['open']` | `false` | Controlled open state |
| options | `ComboboxOptionsType` | **required** | An array of options. Accepts multiple data structures: `Array<string \| ComboboxOptionObjectInterface \| ComboboxGroupType>`. |
| overflowPadding | `DetectOverflowOptions['padding']` | `8` | Virtual padding around the boundary to check for overflow. |
| placeholder | `string` | - | Combobox input placeholder |
| placement | `UseFloatingOptions['placement']` | `'bottom-start'` | Dropdown placement. If there is not enough space, Dropdown will pick the next best placement. |
| portalId | `FloatingPortalProps['id']` | - | Optionally selects the node with the id if it exists, or creates it and appends it to the specified root (by default document.body). Passed to Combobox.Portal. |
| portalRoot | `FloatingPortalProps['root']` | - | Specifies the root node the portal container will be appended to. Passed to Combobox.Portal. |
| portalPreserveTabOrder | `FloatingPortalProps['preserveTabOrder']` | `true` | When using non-modal focus management, preserves the tab order context based on the React tree instead of the DOM tree. Passed to Combobox.Portal. |
| renderAdornment | `(props: ComboboxAdornmentPropsInterface) => ReactNode` | - | Render custom Adornment sub-component |
| renderChip | `(props: InputChipPropsInterface & { isLast: boolean }) => ReactNode` | - | Render custom Chip sub-component |
| renderChipsOverflow | `(props: ComboboxChipsOverflowPropsInterface) => ReactNode` | - | Render custom ChipsOverflow sub-component |
| renderClear | `(props: ComboboxClearPropsInterface) => ReactNode` | - | Render custom Clear sub-component |
| renderEmptyState | `(props: ComboboxEmptyStatePropsInterface) => ReactNode` | - | Render custom EmptyState sub-component |
| renderGroup | `(props: ComboboxGroupRenderProps) => ReactNode` | - | Render custom Group sub-component |
| renderHeading | `(props: ComboboxHeadingRenderProps) => ReactNode` | - | Render custom Heading sub-component |
| renderInput | `(props: ComboboxInputPropsInterface) => ReactNode` | - | Render custom Input sub-component |
| renderInputGroup | `(props: ComboboxInputGroupPropsInterface) => ReactNode` | - | Render custom InputGroup sub-component |
| renderLoadingState | `(props: ComboboxLoadingStatePropsInterface) => ReactNode` | - | Render custom LoadingState sub-component |
| renderOption | `(props: ComboboxOptionRenderProps) => ReactNode` | - | Render custom Option sub-component |
| renderOptionLabel | `(props: ComboboxOptionLabelPropsInterface & { highlightPattern: string \| RegExp \| null }) => ReactNode` | - | Render custom OptionLabel sub-component |
| renderOptionMedia | `(props: ComboboxOptionMediaPropsInterface) => ReactNode` | - | Render custom OptionMedia sub-component |
| renderOptionMeta | `(props: ComboboxOptionMetaPropsInterface & { highlightPattern: string \| RegExp \| null }) => ReactNode` | - | Render custom OptionMeta sub-component |
| required | `boolean` | `false` | Required state. Inherited from parent context if undefined. |
| shouldAwaitInteractionResponse | `boolean` | `true` | Improve INP score by interrupting the main thread with interaction response. You might need to opt-out if you require reliable access to the `event` object. |
| shouldCloseOnViewportLeave | `boolean` | `false` | Close the trigger when the user scrolls away from the trigger node. |
| showLabelForValue | `boolean` | `false` | When options have value differing from label, if true, uses the selected option's label as the input field's value. If false, the selected option's value is used instead. |
| showOptionControl | `boolean` | `false` | Display pseudo radio or checkbox control in option based on single or multi select state. |
| size | `'sm' \| 'md' \| 'lg'` | `'md'` | The size of the input. |
| useDismissProps | `UseDismissProps` | - | Floating UI's `useDismiss` props. |
| useRoleProps | `UseRoleProps` | - | Floating UI's `useRole` props. |
| value | `ValueType` | - | Controlled value state |

