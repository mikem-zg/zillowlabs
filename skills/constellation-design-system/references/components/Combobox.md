# Combobox

```tsx
import { Combobox } from '@zillow/constellation';
```

**Version:** 10.11.0

## Usage

```tsx
import { Combobox } from '@zillow/constellation';
```

```tsx
export const ComboboxBasic = () => (
  <Combobox options={[...statesAsStrings]} placeholder="Select state" />
);
```

## Examples

### Combobox Auto Complete Behavior

```tsx
import { Box, Combobox } from '@zillow/constellation';
```

```tsx
export const ComboboxAutoCompleteBehavior = () => (
  <Box css={{ display: 'flex', flexDirection: 'column', gap: 'default' }}>
    <Combobox
      options={[...statesAsStrings]}
      autoCompleteBehavior="none"
      placeholder="No autocomplete"
    />
    <Combobox
      options={[...statesAsStrings]}
      autoCompleteBehavior="manual"
      placeholder="Manual autocomplete"
    />
    <Combobox
      options={[...statesAsStrings]}
      autoCompleteBehavior="automatic"
      placeholder="Automatic autocomplete"
    />
  </Box>
);
```

### Combobox Complex Options

```tsx
import { Combobox, Icon } from '@zillow/constellation';
```

```tsx
export const ComboboxComplexOptions = () => (
  <Combobox
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

### Combobox Controlled Open State

```tsx
import { Box, Combobox, Text } from '@zillow/constellation';
```

```tsx
export const ComboboxControlledOpenState = () => {
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
      <Combobox
        options={[...statesAsStrings]}
        open={open}
        onOpenChange={handler}
        placeholder="Select state"
      />
    </Box>
  );
};
```

### Combobox Controlled

```tsx
import {
  Box,
  Button,
  ButtonGroup,
  Combobox,
  type ComboboxOnChangeType,
  Paragraph,
  Text,
} from '@zillow/constellation';
```

```tsx
export const ComboboxControlled = () => {
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
      <Combobox
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

### Combobox Custom Highlighter

```tsx
import { Combobox } from '@zillow/constellation';
```

```tsx
export const ComboboxCustomHighlighter = () => (
  <Combobox
    options={[...statesAsStrings]}
    getHighlightPattern={(value) => value}
    placeholder="Select state"
  />
);
```

### Combobox Custom Option Filter

```tsx
import { Combobox } from '@zillow/constellation';
```

```tsx
export const ComboboxCustomOptionFilter = () => (
  <Combobox
    options={[...statesAsStrings]}
    optionFilter={(value, text) => text.includes(value)}
    placeholder="Select state"
  />
);
```

### Combobox Disabled Options

```tsx
import { Combobox, Icon } from '@zillow/constellation';
```

```tsx
export const ComboboxDisabledOptions = () => (
  <Combobox
    options={statesAsObjects.map((state) => ({
      ...state,
      disabled: Math.random() > 0.5,
      meta: 'Optional meta',
      icon: <Icon render={<IconLocationFilled />} />,
    }))}
    showLabelForValue
    placeholder="Select state"
  />
);
```

### Combobox Empty State

```tsx
import { Combobox } from '@zillow/constellation';
```

```tsx
export const ComboboxEmptyState = () => (
  <Combobox
    options={[]}
    renderEmptyState={(emptyStateProps) => (
      <Combobox.EmptyState {...emptyStateProps}>Custom empty state</Combobox.EmptyState>
    )}
    placeholder="Select state"
  />
);
```

### Combobox First Option Focus

```tsx
import { Combobox } from '@zillow/constellation';
```

```tsx
export const ComboboxFirstOptionFocus = () => (
  <Combobox options={[...statesAsStrings]} focusFirstOption placeholder="Select state" />
);
```

### Combobox Fluid Dropdown

```tsx
import { Box, Combobox, Icon } from '@zillow/constellation';
```

```tsx
export const ComboboxFluidDropdown = () => (
  <Box css={{ maxWidth: '200px' }}>
    <Combobox
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

### Combobox Free Form

```tsx
import { Box, Combobox, type ComboboxOnChangeType, Text } from '@zillow/constellation';
```

```tsx
export const ComboboxFreeForm = () => {
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
      <Combobox
        value={value}
        onChange={onChangeCallback}
        options={[...statesAsStrings]}
        freeForm
        placeholder="Select state"
      />
    </Box>
  );
};
```

### Combobox Grouped Options

```tsx
import { Combobox, Icon } from '@zillow/constellation';
```

```tsx
export const ComboboxGroupedOptions = () => (
  <Combobox
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

### Combobox Input Appearance

```tsx
import { Combobox } from '@zillow/constellation';
```

```tsx
export const ComboboxInputAppearance = () => (
  <Combobox options={[...statesAsStrings]} appearance="input" placeholder="Select state" />
);
```

### Combobox Loading State

```tsx
import { Combobox } from '@zillow/constellation';
```

```tsx
export const ComboboxLoadingState = () => (
  <Combobox options={[...statesAsStrings]} loading placeholder="Select state" />
);
```

### Combobox Mixed Content

```tsx
import { Combobox, Icon } from '@zillow/constellation';
```

```tsx
export const ComboboxMixedContent = () => (
  <Combobox
    showLabelForValue
    options={[
      'Option as string #1',
      { label: 'Option as object with label #1', value: '1' },
      {
        label: 'Option as object with label and icon #1',
        value: '2',
        icon: <Icon render={<IconLocationFilled />} />,
      },
      {
        label: 'Option as object with label, icon, and meta #1',
        value: '3',
        icon: <Icon render={<IconLocationFilled />} />,
        meta: 'Hello!',
      },
      {
        heading: 'Heading as string',
        options: [
          'Option as string #2',
          { label: 'Option as object with label #2', value: '4' },
          {
            label: 'Option as object with label and icon #2',
            value: '5',
            icon: <Icon render={<IconLocationFilled />} />,
          },
          {
            label: 'Option as object with label, icon, and meta #2',
            value: '6',
            icon: <Icon render={<IconLocationFilled />} />,
            meta: 'Hello!',
          },
        ],
      },
      {
        heading: {
          label: 'Heading as object with label and icon',
          icon: <Icon render={<IconLocationFilled />} />,
        },
        options: [
          'Option as string #3',
          { label: 'Option as object with label #3', value: '7' },
          {
            label: 'Option as object with label and icon #3',
            value: '8',
            icon: <Icon render={<IconLocationFilled />} />,
          },
          {
            label: 'Option as object with label, icon, and meta #3',
            value: '9',
            icon: <Icon render={<IconLocationFilled />} />,
            meta: 'Hello!',
          },
        ],
      },
    ]}
    optionFilter={(value, text) => text.includes(value)}
    placeholder="Select option"
  />
);
```

### Combobox Multi Select Controlled

```tsx
import {
  Box,
  Button,
  ButtonGroup,
  Combobox,
  type ComboboxOnChangeType,
  Paragraph,
  Text,
} from '@zillow/constellation';
```

```tsx
export const ComboboxMultiSelectControlled = () => {
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
      <Combobox
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

### Combobox Multi Select Free Form

```tsx
import { Box, Combobox, type ComboboxOnChangeType, Text } from '@zillow/constellation';
```

```tsx
export const ComboboxMultiSelectFreeForm = () => {
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
      <Combobox
        value={value}
        onChange={onChangeCallback}
        options={[...statesAsStrings]}
        freeForm
        placeholder="Select state"
      />
    </Box>
  );
};
```

### Combobox Multi Select With Chips Limit

```tsx
import { Combobox } from '@zillow/constellation';
```

```tsx
export const ComboboxMultiSelectWithChipsLimit = () => (
  <Combobox
    options={[...statesAsStrings]}
    defaultValue={['Michigan', 'North Carolina', 'Texas']}
    limitChipsShown={2}
    placeholder="Select state"
  />
);
```

### Combobox Multi Select

```tsx
import { Combobox } from '@zillow/constellation';
```

```tsx
export const ComboboxMultiSelect = () => (
  <Combobox
    options={[...statesAsStrings]}
    defaultValue={['Michigan', 'Texas']}
    placeholder="Select state"
  />
);
```

### Combobox No Heading Groups With Dividers

```tsx
import { Combobox, Icon } from '@zillow/constellation';
```

```tsx
export const ComboboxNoHeadingGroupsWithDividers = () => (
  <Combobox
    dividers
    options={statesAsGroups.map((group) => ({
      heading: {
        label: group.heading,
        visuallyHidden: true,
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

### Combobox Option Focus And Select Callbacks

```tsx
import { Box, Combobox, type ComboboxOptionType, Text } from '@zillow/constellation';
```

```tsx
export const ComboboxOptionFocusAndSelectCallbacks = () => {
  const [focusedOption, setFocusedOption] = useState<ComboboxOptionType | undefined>(undefined);
  const [selectedOption, setSelectedOption] = useState<ComboboxOptionType | undefined>(undefined);

  const onOptionFocusCallback = useCallback<(option: ComboboxOptionType) => void>((option) => {
    setFocusedOption(option);
  }, []);

  const onOptionSelectCallback = useCallback<(option: ComboboxOptionType) => void>((option) => {
    setSelectedOption(option);
  }, []);

  return (
    <Box css={{ display: 'flex', flexDirection: 'column', gap: 'tight' }}>
      <Text textStyle="body-sm">
        Last <code>onOptionFocus</code> callback <code>option</code>:{' '}
        <code>{JSON.stringify(focusedOption)}</code>
      </Text>
      <Text textStyle="body-sm">
        Last <code>onOptionSelect</code> callback <code>option</code>:{' '}
        <code>{JSON.stringify(selectedOption)}</code>
      </Text>
      <Combobox
        onOptionFocus={onOptionFocusCallback}
        onOptionSelect={onOptionSelectCallback}
        options={[...statesAsObjects]}
        showLabelForValue
        placeholder="Select state"
      />
    </Box>
  );
};
```

### Combobox Render Adornment

```tsx
import { Combobox, Icon } from '@zillow/constellation';
```

```tsx
export const ComboboxRenderAdornment = () => (
  <Combobox
    options={[...statesAsStrings]}
    placeholder="Search state"
    renderAdornment={(adornmentProps) => (
      <Combobox.Adornment {...adornmentProps}>
        <Icon render={<IconSearchFilled />} />
      </Combobox.Adornment>
    )}
  />
);
```

### Combobox Show Label As Value

```tsx
import { Box, Combobox } from '@zillow/constellation';
```

```tsx
export const ComboboxShowLabelAsValue = () => (
  <Box css={{ display: 'flex', flexDirection: 'column', gap: 'tight' }}>
    <Combobox options={[...statesAsObjects]} placeholder="Show value for value" defaultValue="AK" />
    <Combobox
      options={[...statesAsObjects]}
      placeholder="Show label for value"
      defaultValue="AK"
      showLabelForValue
    />
  </Box>
);
```

### Combobox Show Option Control

```tsx
import { Box, Combobox } from '@zillow/constellation';
```

```tsx
export const ComboboxShowOptionControl = () => (
  <Box css={{ display: 'flex', flexDirection: 'column', gap: 'default' }}>
    <Combobox options={[...statesAsStrings]} showOptionControl placeholder="Select state" />
    <Combobox
      options={[...statesAsStrings]}
      showOptionControl
      defaultValue={['Michigan', 'Texas']}
      placeholder="Select state"
    />
  </Box>
);
```

### Combobox Submit While Open

```tsx
import { Combobox, Form } from '@zillow/constellation';
```

```tsx
export const ComboboxSubmitWhileOpen = () => (
  <Form
    onSubmit={(event) => {
      event.preventDefault();
      alert('Form submitted!');
    }}
  >
    <Combobox options={[...statesAsStrings]} allowSubmitWhileOpen placeholder="Select state" />
  </Form>
);
```

### Combobox Various States

```tsx
import { Box, Combobox } from '@zillow/constellation';
```

```tsx
export const ComboboxVariousStates = () => (
  <Box css={{ display: 'flex', flexDirection: 'column', gap: 'default' }}>
    <Combobox options={[...statesAsStrings]} error placeholder="Error state" />
    <Combobox options={[...statesAsStrings]} disabled placeholder="Disabled state" />
    <Combobox options={[...statesAsStrings]} size="sm" placeholder="Small size" />
    <Combobox options={[...statesAsStrings]} size="lg" placeholder="Large size" />
  </Box>
);
```

### Combobox Within Form Field

```tsx
import { Box, Combobox, FormField, FormHelp, Heading, Label } from '@zillow/constellation';
```

```tsx
export const ComboboxWithinFormField = () => (
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
        control={<Combobox options={[...statesAsStrings]} placeholder="Select state" />}
        label={<Label>State of residence</Label>}
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
        control={<Combobox options={[...statesAsStrings]} placeholder="Select state" />}
        label={<Label>State of residence</Label>}
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
        control={<Combobox options={[...statesAsStrings]} placeholder="Select state" />}
        label={<Label>State of residence</Label>}
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
        control={<Combobox options={[...statesAsStrings]} placeholder="Select state" />}
        label={<Label>State of residence</Label>}
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
        control={<Combobox options={[...statesAsStrings]} placeholder="Select state" />}
        label={<Label>State of residence</Label>}
        description={<FormHelp>Help text</FormHelp>}
      />
    </Box>
  </Box>
);
```

### States As Strings

```tsx
import { combobox } from '@zillow/constellation';
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

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |
| `portalId` | `FloatingPortalProps['id']` | — | Optionally selects the node with the id if it exists, or create it and append it to the specified root (by default document.body). Passed to Combobox.Portal. |
| `portalRoot` | `FloatingPortalProps['root']` | — | Specifies the root node the portal container will be appended to. Passed to Combobox.Portal. |
| `portalPreserveTabOrder` | `FloatingPortalProps['preserveTabOrder']` | `true` | When using non-modal focus management, this will preserve the tab order context based on the React tree instead of the DOM tree. Passed to Combobox.Portal. |

### ComboboxAdornment

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

### ComboboxChipsOverflow

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### ComboboxClear

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

### ComboboxContent

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |
| `focusManagerProps` | `FloatingFocusManagerProps` | `{}` | Floating UI's `FloatingFocusManager` props. See https://floating-ui.com/docs/FloatingFocusManager |
| `renderEmptyState` | `(props: ComboboxEmptyStatePropsInterface) => ReactNode` | — | Render custom `EmptyState` sub-component |
| `renderGroup` | `(     props: Omit<ComboboxGroupPropsInterface, 'children'> & {       group: ComboboxGroupType;       highlightPattern: HighlightPatternType;       renderHeading: NonNullable<ComboboxContentPropsInterface['renderHeading']>;       renderOption: NonNullable<ComboboxContentPropsInterface['renderOption']>;       renderOptionLabel: NonNullable<ComboboxContentPropsInterface['renderOptionLabel']>;       renderOptionMedia: NonNullable<ComboboxContentPropsInterface['renderOptionMedia']>;       renderOptionMeta: NonNullable<ComboboxContentPropsInterface['renderOptionMeta']>;     },   ) => ReactNode` | — | Render custom `Group` sub-component |
| `renderHeading` | `(     props: Omit<ComboboxHeadingPropsInterface, 'children'> & {       heading: ComboboxHeadingType;     },   ) => ReactNode` | — | Render custom `Heading` sub-component |
| `renderLoadingState` | `(props: ComboboxLoadingStatePropsInterface) => ReactNode` | — | Render custom `LoadingState` sub-component |
| `renderOption` | `(     props: Omit<ComboboxOptionPropsInterface, 'children' \| 'value'> & {       option: ComboboxOptionType;       highlightPattern: HighlightPatternType;       renderOptionLabel: NonNullable<ComboboxContentPropsInterface['renderOptionLabel']>;       renderOptionMedia: NonNullable<ComboboxContentPropsInterface['renderOptionMedia']>;       renderOptionMeta: NonNullable<ComboboxContentPropsInterface['renderOptionMeta']>;     },   ) => ReactNode` | — | Render custom `Option` sub-component |
| `renderOptionLabel` | `(     props: ComboboxOptionLabelPropsInterface & { highlightPattern: HighlightPatternType },   ) => ReactNode` | — | Render custom `OptionLabel` sub-component |
| `renderOptionMedia` | `(props: ComboboxOptionMediaPropsInterface) => ReactNode` | — | Render custom `OptionMedia` sub-component |
| `renderOptionMeta` | `(     props: ComboboxOptionMetaPropsInterface & { highlightPattern: HighlightPatternType },   ) => ReactNode` | — | Render custom `OptionMeta` sub-component |

### ComboboxEmptyState

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### ComboboxGroup

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### ComboboxHeading

**Element:** `HTMLHeadingElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `level` | `1 \| 2 \| 3 \| 4 \| 5 \| 6` | — | Heading level **(required)** |
| `visuallyHidden` | `boolean` | — | Visually hide heading |

### ComboboxInput

**Element:** `HTMLInputElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |

### ComboboxInputGroup

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### ComboboxLoadingState

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | `<Spinner size="md" />` | Content |
| `css` | `SystemStyleObject` | — | Styles object |

### ComboboxOption

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `option` | `ComboboxOptionType` | — | Single option from the options array |

### ComboboxOptionLabel

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### ComboboxOptionMedia

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

### ComboboxOptionMeta

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### ComboboxPortal

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `id` | `string` | — | Optionally selects the node with the id if it exists, or create it and append it to the specified `root` (by default `document.body`). |
| `root` | `HTMLElement \| ShadowRoot \| null \| React.MutableRefObject<HTMLElement \| ShadowRoot \| null>` | — | Specifies the root node the portal container will be appended to. |
| `preserveTabOrder` | `boolean` | — | When using non-modal focus management using `FloatingFocusManager`, this will preserve the tab order context based on the React tree instead of the DOM tree. |
| `css` | `SystemStyleObject` | — | Styles object |

### ComboboxRoot

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `rootContext` | `FloatingRootContext<RT>` | — |  |
| `elements` | `{         /**          * Externally passed reference element. Store in state.          */         reference?: Element \| null;         /**          * Externally passed floating element. Store in state.          */         floating?: HTMLElement \| null;     }` | — | Object of external elements as an alternative to the `refs` object setters. |
| `nodeId` | `string` | — | Unique node id when using `FloatingTree`. |
| `allowSubmitWhileOpen` | `boolean` | `false` | For a typical `<input>` within a `<form>`, pressing "enter" will submit the form. For a combobox, "enter" is used both to select options and submit the form; by default, "enter" will select an option while the dropdown is open, and submit a form while the dropdown is closed. If you enable this prop, pressing "enter" will both select an option and submit a form while the dropdown is open. This can be useful for search box like experiences that act immediately on free form input. |
| `appearance` | `'input' \| 'select'` | `select` | By default, comboboxes have the appearance of a Select component (with an arrow indicator). You can change the appearance to "input" to match the Input component. |
| `autoCompleteBehavior` | `'none' \| 'manual' \| 'automatic'` | `automatic` | Autocomplete behavior is different from the native autoComplete attribute, which handles browser autofill (always disabled for this component), and the aria-autocomplete attribute, which will be set automatically to "list" or "both" depending on the behavior. "none": The combobox is editable, and when the popup is triggered, the suggested values it contains are the same regardless of the characters typed in the combobox. For example, the popup suggests a set of recently entered values, and the suggestions do not change as the user types. "manual": When the popup is triggered, it presents suggested values. If the combobox is editable, the suggested values complete or logically correspond to the characters typed in the combobox. The character string the user has typed will become the value of the combobox unless the user selects a value in the popup. "automatic": The combobox is editable, and when the popup is triggered, it presents suggested values that complete or logically correspond to the characters typed in the combobox, and the first suggestion is automatically highlighted as selected. The automatically selected suggestion becomes the value of the combobox when the combobox loses focus unless the user chooses a different suggestion or changes the character string in the combobox (single-select comboboxes only). |
| `children` | `ReactNode` | — | Content |
| `defaultOpen` | `boolean` | — | Uncontrolled default open state |
| `defaultValue` | `ValueType` | — | Uncontrolled default value state |
| `disabled` | `boolean` | `false` | Disabled state. Inherited from parent context if undefined. |
| `dividers` | `boolean` | `false` | Show divider between groups |
| `editable` | `boolean` | `true` | When set to false the Combobox input becomes read-only. This is useful when `autoCompleteBehavior` is set to `none` |
| `error` | `boolean` | `false` | Error state. Inherited from parent context if undefined. |
| `freeForm` | `boolean` | `false` | By default, values must match one of the given options. To allow free form values to be entered, enable this prop. For single-select comboboxes, enabling this will trigger a change event for every character typed. For multi-selectable comboboxes, this will only trigger a change when the value is selected with "enter". |
| `fluidDropdown` | `boolean` | `false` | When enabled, the dropdown will be fluid to match the width of the combobox. Disable this and the width of the dropdown will be based on the dropdown content. |
| `focusFirstOption` | `boolean` | `false` | When enabled, the first option will automatically receive focus when the dropdown is opened. |
| `getHighlightPattern` | `null \| ((value: string) => string \| RegExp)` | — | By default, options will be highlighted based in the typed input. You can override the default behavior by providing a pattern based on the one parameter inputValue. You can disable this by setting this to null. Note: if you are returning a regular expression, be careful to escape the user input. See Highlighter for more information regarding the returned pattern. |
| `limitChipsShown` | `number` | — | You can limit the number of tags that are visible for multi-selectable comoboboxes by passing a number limit. Note: All tags will be visible when the comobobox has focus. |
| `loading` | `boolean` | `false` | Display loading state. |
| `offset` | `OffsetOptions` | `22` | Dropdown content offset from trigger |
| `onChange` | `ComboboxOnChangeType<ValueType>` | — | Called whenever there is a change inn value. It receives new value, event, and reason for change. |
| `onClear` | `(event: SyntheticEvent<HTMLButtonElement>) => void` | — | Called whenever clear button is clicked and value is cleared. |
| `onChipClose` | `(value: string, event: SyntheticEvent<HTMLSpanElement>) => void` | — | Called when an input chip close button is clicked, or when an input chi is removed with backspace. |
| `onOpenChange` | `UseFloatingOptions['onOpenChange']` | — | Controlled event. Receives `open` state, `event` object, and `reason` for state change. |
| `onOptionFocus` | `(option: ComboboxOptionType) => void` | — | Called whenever the active descendant option changes. It will pass option as string or object. |
| `onOptionSelect` | `(option: ComboboxOptionType) => void` | — | Called whenever an option is selected. It will pass option as string or object. By default, this will only be called when the action results in a change of value. You can use `selectCallbackFrequency` to change this behavior to always trigger. Note: This will NEVER be called for `freeForm` selections. You can use `onChange` to monitor those values. |
| `optionFilter` | `(inputValue: string, text: string) => boolean` | — | By default, options will be filtered automatically when using the "manual" or "automatic" `autoCompleteBehavior`. You can override the default filter behavior by providing your own function. The function will be passed the current `inputValue` and `text` (option label or meta) as the only parameters, and should return `true` to keep, or `false` to discard the option. |
| `open` | `UseFloatingOptions['open']` | `false` | Controlled state |
| `options` | `ComboboxOptionsType` | — | An array of options. It accept multiple data structures. See type definition for exhaustive list. **(required)** |
| `overflowPadding` | `DetectOverflowOptions['padding']` | `8` | This describes the virtual padding around the boundary to check for overflow. |
| `placeholder` | `string` | — | Combobox input placeholder |
| `placement` | `UseFloatingOptions['placement']` | `bottom-start` | Dropdown placement. If there is not enough space, Dropdown will pick the next best placement. |
| `required` | `boolean` | `false` | Required state. Inherited from parent context if undefined. |
| `selectCallbackFrequency` | `'always' \| 'change'` | — | By default, `onOptionSelect` will only fire if the action results in a change of value Alternatively, you can set this to `always` and the callback will always fire regardless of the outcome on the value. |
| `shouldAwaitInteractionResponse` | `boolean` | `true` | Improve INP score by interrupting the main thread with interaction response. You might need to opt-out if you require a reliable access to the `event` object. |
| `shouldCloseOnViewportLeave` | `boolean` | `false` | Close the trigger when the user scrolls away from the trigger node. |
| `showOptionControl` | `boolean` | `false` | Display pseudo radio or checkbox control in option based on single or multi select state. |
| `showLabelForValue` | `boolean` | `false` | Can be used when you have options where value differs from label. If true, Combobox uses the selected option's label as the input field's value. If false (default), the selected option's value will be used instead. |
| `size` | `'sm' \| 'md' \| 'lg'` | `md` | The size of the input. |
| `useDismissProps` | `UseDismissProps` | — | Floating UI's `useDismiss` props. See https://floating-ui.com/docs/useDimiss |
| `useRoleProps` | `UseRoleProps` | — | Floating UI's `useRole` props. See https://floating-ui.com/docs/useRole |
| `value` | `ValueType` | — | Controlled value state |

### ComboboxTrigger

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |
| `renderAdornment` | `(props: ComboboxAdornmentPropsInterface) => ReactNode` | — | Render custom `Adornment` sub-component |
| `renderChip` | `(props: InputChipPropsInterface & { isLast: boolean }) => ReactNode` | — | Render custom `Chip` sub-component |
| `renderChipsOverflow` | `(props: ComboboxChipsOverflowPropsInterface) => ReactNode` | — | Render custom `ChipsOverflow` sub-component |
| `renderClear` | `(props: ComboboxClearPropsInterface) => ReactNode` | — | Render custom `Clear` sub-component |
| `renderInput` | `(props: ComboboxInputPropsInterface) => ReactNode` | — | Render custom `Input` sub-component |
| `renderInputGroup` | `(props: ComboboxInputGroupPropsInterface) => ReactNode` | — | Render custom `InputGroup` sub-component |

