# DateTimeBlock

```tsx
import { DateTimeBlock } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 10.4.0

## Usage

```tsx
import { DateTimeBlock } from '@zillow/constellation';
```

```tsx
const weekStart = startOfWeek(new Date(), { weekStartsOn: 1 });

const mockDates = [
  weekStart,
  addDays(weekStart, 1),
  addDays(weekStart, 2),
  addDays(weekStart, 3),
  addDays(weekStart, 4),
  addDays(weekStart, 5),
  addDays(weekStart, 6),
];

const mockTimes = [
  setMinutes(setHours(weekStart, 9), 0),
  setMinutes(setHours(weekStart, 9), 15),
  setMinutes(setHours(weekStart, 9), 30),
  setMinutes(setHours(weekStart, 9), 45),
  setMinutes(setHours(weekStart, 10), 0),
  setMinutes(setHours(weekStart, 10), 15),
  setMinutes(setHours(weekStart, 10), 30),
];

export const DateTimeBlockBasic = () => {
  return <DateTimeBlock dates={mockDates} times={mockTimes} />;
};
```

## Examples

### Date Time Block Composed

```tsx
import { DateTimeBlock } from '@zillow/constellation';
```

```tsx
const weekStart = startOfWeek(new Date(), { weekStartsOn: 1 });

const mockDates = [
  weekStart,
  addDays(weekStart, 1),
  addDays(weekStart, 2),
  addDays(weekStart, 3),
  addDays(weekStart, 4),
  addDays(weekStart, 5),
  addDays(weekStart, 6),
];

const mockTimes = [
  setMinutes(setHours(weekStart, 9), 0),
  setMinutes(setHours(weekStart, 9), 15),
  setMinutes(setHours(weekStart, 9), 30),
  setMinutes(setHours(weekStart, 9), 45),
  setMinutes(setHours(weekStart, 10), 0),
  setMinutes(setHours(weekStart, 10), 15),
  setMinutes(setHours(weekStart, 10), 30),
];

export const DateTimeBlockComposed = () => {
  return (
    <DateTimeBlock.Root dates={mockDates} times={mockTimes}>
      <DateTimeBlock.Wrap>
        <DateTimeBlock.Label />
      </DateTimeBlock.Wrap>
      <DateTimeBlock.Dates />
      <DateTimeBlock.Wrap>
        <DateTimeBlock.Times />
      </DateTimeBlock.Wrap>
    </DateTimeBlock.Root>
  );
};
```

### Date Time Block Controlled

```tsx
import { DateTimeBlock } from '@zillow/constellation';
```

```tsx
const weekStart = startOfWeek(new Date(), { weekStartsOn: 1 });

const mockDates = [
  weekStart,
  addDays(weekStart, 1),
  addDays(weekStart, 2),
  addDays(weekStart, 3),
  addDays(weekStart, 4),
  addDays(weekStart, 5),
  addDays(weekStart, 6),
];

const mockTimes = [
  setMinutes(setHours(weekStart, 9), 0),
  setMinutes(setHours(weekStart, 9), 15),
  setMinutes(setHours(weekStart, 9), 30),
  setMinutes(setHours(weekStart, 9), 45),
  setMinutes(setHours(weekStart, 10), 0),
  setMinutes(setHours(weekStart, 10), 15),
  setMinutes(setHours(weekStart, 10), 30),
];

export const DateTimeBlockControlled = () => {
  const [selectedDate, setSelectedDate] = useState<Date | string>();
  const [selectedTime, setSelectedTime] = useState<Date | string | Array<Date | string>>();

  return (
    <DateTimeBlock
      dates={mockDates}
      times={mockTimes}
      selectedDate={selectedDate}
      onDateChange={setSelectedDate}
      selectedTime={selectedTime}
      onTimeChange={setSelectedTime}
    />
  );
};
```

### Date Time Block Dates Only

```tsx
import { DateTimeBlock } from '@zillow/constellation';
```

```tsx
const weekStart = startOfWeek(new Date(), { weekStartsOn: 1 });

const mockDates = [
  weekStart,
  addDays(weekStart, 1),
  addDays(weekStart, 2),
  addDays(weekStart, 3),
  addDays(weekStart, 4),
  addDays(weekStart, 5),
  addDays(weekStart, 6),
];

export const DateTimeBlockDatesOnly = () => {
  return <DateTimeBlock dates={mockDates} times={[]} label="Select a date" />;
};
```

### Date Time Block Dates To Show

```tsx
import { Box, DateTimeBlock } from '@zillow/constellation';
```

```tsx
const weekStart = startOfWeek(new Date(), { weekStartsOn: 1 });

const mockDates = [
  weekStart,
  addDays(weekStart, 1),
  addDays(weekStart, 2),
  addDays(weekStart, 3),
  addDays(weekStart, 4),
  addDays(weekStart, 5),
  addDays(weekStart, 6),
];

const mockTimes = [
  setMinutes(setHours(weekStart, 9), 0),
  setMinutes(setHours(weekStart, 9), 15),
  setMinutes(setHours(weekStart, 9), 30),
  setMinutes(setHours(weekStart, 9), 45),
  setMinutes(setHours(weekStart, 10), 0),
  setMinutes(setHours(weekStart, 10), 15),
  setMinutes(setHours(weekStart, 10), 30),
];

export const DateTimeBlockDatesToShow = () => {
  return (
    <Box css={{ display: 'flex', flexDirection: 'column', gap: '32px' }}>
      <Box css={{ maxWidth: '305px' }}>
        <DateTimeBlock dates={mockDates} times={mockTimes} datesToShow={2} />
      </Box>
      <Box css={{ maxWidth: '394px' }}>
        <DateTimeBlock dates={mockDates} times={mockTimes} />
      </Box>
      <Box css={{ maxWidth: '504px' }}>
        <DateTimeBlock dates={mockDates} times={mockTimes} datesToShow={4} />
      </Box>
      <Box css={{ maxWidth: '608px' }}>
        <DateTimeBlock dates={mockDates} times={mockTimes} datesToShow={5} />
      </Box>
    </Box>
  );
};
```

### Date Time Block Disabled Dates Times

```tsx
import { DateTimeBlock } from '@zillow/constellation';
```

```tsx
const weekStart = startOfWeek(new Date(), { weekStartsOn: 1 });

const mockDates = [
  weekStart,
  addDays(weekStart, 1),
  addDays(weekStart, 2),
  addDays(weekStart, 3),
  addDays(weekStart, 4),
  addDays(weekStart, 5),
  addDays(weekStart, 6),
];

const mockTimes = [
  setMinutes(setHours(weekStart, 9), 0),
  setMinutes(setHours(weekStart, 9), 15),
  setMinutes(setHours(weekStart, 9), 30),
  setMinutes(setHours(weekStart, 9), 45),
  setMinutes(setHours(weekStart, 10), 0),
  setMinutes(setHours(weekStart, 10), 15),
  setMinutes(setHours(weekStart, 10), 30),
];

export const DateTimeBlockDisabledDatesTimes = () => {
  return (
    <DateTimeBlock
      dates={mockDates}
      times={mockTimes}
      disabledDates={[mockDates[3]]}
      disabledTimes={[mockTimes[4], mockTimes[5]]}
    />
  );
};
```

### Date Time Block Display Type Chips Multiple

```tsx
import { DateTimeBlock } from '@zillow/constellation';
```

```tsx
const weekStart = startOfWeek(new Date(), { weekStartsOn: 1 });

const mockDates = [
  weekStart,
  addDays(weekStart, 1),
  addDays(weekStart, 2),
  addDays(weekStart, 3),
  addDays(weekStart, 4),
  addDays(weekStart, 5),
  addDays(weekStart, 6),
];

const mockTimes = [
  setMinutes(setHours(weekStart, 9), 0),
  setMinutes(setHours(weekStart, 9), 15),
  setMinutes(setHours(weekStart, 9), 30),
  setMinutes(setHours(weekStart, 9), 45),
  setMinutes(setHours(weekStart, 10), 0),
  setMinutes(setHours(weekStart, 10), 15),
  setMinutes(setHours(weekStart, 10), 30),
];

export const DateTimeBlockDisplayTypeChipsMultiple = () => {
  return <DateTimeBlock dates={mockDates} times={mockTimes} timeDisplay="chips" multiple />;
};
```

### Date Time Block Display Type Chips

```tsx
import { DateTimeBlock } from '@zillow/constellation';
```

```tsx
const weekStart = startOfWeek(new Date(), { weekStartsOn: 1 });

const mockDates = [
  weekStart,
  addDays(weekStart, 1),
  addDays(weekStart, 2),
  addDays(weekStart, 3),
  addDays(weekStart, 4),
  addDays(weekStart, 5),
  addDays(weekStart, 6),
];

const mockTimes = [
  setMinutes(setHours(weekStart, 9), 0),
  setMinutes(setHours(weekStart, 9), 15),
  setMinutes(setHours(weekStart, 9), 30),
  setMinutes(setHours(weekStart, 9), 45),
  setMinutes(setHours(weekStart, 10), 0),
  setMinutes(setHours(weekStart, 10), 15),
  setMinutes(setHours(weekStart, 10), 30),
];

export const DateTimeBlockDisplayTypeChips = () => {
  return <DateTimeBlock dates={mockDates} times={mockTimes} timeDisplay="chips" />;
};
```

### Date Time Block Multiple Times Selection

```tsx
import { DateTimeBlock } from '@zillow/constellation';
```

```tsx
const weekStart = startOfWeek(new Date(), { weekStartsOn: 1 });

const mockDates = [
  weekStart,
  addDays(weekStart, 1),
  addDays(weekStart, 2),
  addDays(weekStart, 3),
  addDays(weekStart, 4),
  addDays(weekStart, 5),
  addDays(weekStart, 6),
];

const mockTimes = [
  setMinutes(setHours(weekStart, 9), 0),
  setMinutes(setHours(weekStart, 9), 15),
  setMinutes(setHours(weekStart, 9), 30),
  setMinutes(setHours(weekStart, 9), 45),
  setMinutes(setHours(weekStart, 10), 0),
  setMinutes(setHours(weekStart, 10), 15),
  setMinutes(setHours(weekStart, 10), 30),
];

export const DateTimeBlockMultipleTimesSelection = () => {
  return <DateTimeBlock dates={mockDates} times={mockTimes} multiple />;
};
```

### Date Time Block No Controls

```tsx
import { DateTimeBlock } from '@zillow/constellation';
```

```tsx
const weekStart = startOfWeek(new Date(), { weekStartsOn: 1 });

const mockDates = [weekStart, addDays(weekStart, 1), addDays(weekStart, 2)];

const mockTimes = [
  setMinutes(setHours(weekStart, 9), 0),
  setMinutes(setHours(weekStart, 9), 15),
  setMinutes(setHours(weekStart, 9), 30),
  setMinutes(setHours(weekStart, 9), 45),
  setMinutes(setHours(weekStart, 10), 0),
  setMinutes(setHours(weekStart, 10), 15),
  setMinutes(setHours(weekStart, 10), 30),
];

export const DateTimeBlockNoControls = () => {
  return <DateTimeBlock dates={mockDates} times={mockTimes} />;
};
```

### Date Time Block Touch Screen Offset

```tsx
import { Box, DateTimeBlock } from '@zillow/constellation';
```

```tsx
const weekStart = startOfWeek(new Date(), { weekStartsOn: 1 });

const mockDates = [
  weekStart,
  addDays(weekStart, 1),
  addDays(weekStart, 2),
  addDays(weekStart, 3),
  addDays(weekStart, 4),
  addDays(weekStart, 5),
  addDays(weekStart, 6),
];

const mockTimes = [
  setMinutes(setHours(weekStart, 9), 0),
  setMinutes(setHours(weekStart, 9), 15),
  setMinutes(setHours(weekStart, 9), 30),
  setMinutes(setHours(weekStart, 9), 45),
  setMinutes(setHours(weekStart, 10), 0),
  setMinutes(setHours(weekStart, 10), 15),
  setMinutes(setHours(weekStart, 10), 30),
];

export const DateTimeBlockTouchScreenOffset = () => {
  return (
    <Box
      css={{
        'maxWidth': '394px',

        '@media (hover: none) and (pointer: coarse)': {
          border: '1px solid',
          padding: 'default',
          overflow: 'hidden',
        },
      }}
    >
      <DateTimeBlock dates={mockDates} times={mockTimes} touchScreenOffset="default" />
    </Box>
  );
};
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |
| `timeDisplay` | `'chips' \| 'select'` | `select` | Display type |
| `label` | `string` | `'Select a date and time'` | Label for date-time block |
| `dates` | `Array<Date \| string>` | — | Array of dates to select from |
| `disabledDates` | `Array<Date \| string>` | — | Array of dates to disable |
| `selectedDate` | `Date \| string` | — | Selected date |
| `defaultSelectedDate` | `Date \| string` | — | Default selected date for uncontrolled usage |
| `datesToShow` | `DateSelectQuantityType` | `3` | Quantity of dates to display as a select  Note: quantity depends on available width where component will be placed, if using a narrow display, consider fewer cards |
| `onDateChange` | `(value: Date \| string) => void` | — | Callback function when a date is selected |
| `times` | `Array<Date \| string>` | — | Array of times to select from |
| `disabledTimes` | `Array<Date \| string>` | — | Array of times to disable |
| `onTimeChange` | `(value: Date \| string \| Array<Date \| string>) => void` | — | Callback function when a time is selected In single selection mode, receives a single time value In multiple selection mode, receives an array of time values |
| `selectedTime` | `Date \| string \| Array<Date \| string>` | — | Selected time(s) Single value for single selection mode, array for multiple selection mode |
| `defaultSelectedTime` | `Date \| string \| Array<Date \| string>` | — | Default selected time(s) for uncontrolled usage Single value for single selection mode, array for multiple selection mode |
| `multiple` | `boolean` | `false` | Enable multiple time selection mode When true, selectedTime/defaultSelectedTime should be arrays and onTimeChange receives arrays |
| `touchScreenOffset` | `'tightest' \| 'tighter' \| 'tight' \| 'default' \| 'loose' \| 'looser'` | — | Spacing value for touch screen horizontal offset. When provided, enables the container to "pop out" of its parent with negative margins and adds corresponding padding/pseudo-elements for proper spacing. Should match the parent container's padding value. (Only applied on touch screen devices). |

### DateTimeBlockDates

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content for composable DateTimeBlock Dates subcomponent |
| `css` | `SystemStyleObject` | — | Styles object |
| `renderDatesPrevIconButton` | `(     props: UseDateTimeBlockRenderPaginationButtonPropsInterface,   ) => ReactNode` | `<IconButton><Icon><IconChevronLeftFilled/></Icon></IconButton>` | Icon to navigate to the previous set of dates Render function that receives navigation props |
| `renderDatesNextIconButton` | `(     props: UseDateTimeBlockRenderPaginationButtonPropsInterface,   ) => ReactNode` | `<IconButton><Icon><IconChevronRightFilled/></Icon></IconButton>` | Icon to navigate to the next set of dates Render function that receives navigation props |

### DateTimeBlockDay

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'aria-describedby'` | `AriaAttributes['aria-describedby']` | — | An [`aria-describedby`](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/ARIA_Techniques/Using_the_aria-describedby_attribute) to assist with associating helper text with the day. |
| `'children'` | `ReactNode` | — | Content for composable DateTimeBlock Dates subcomponent |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'date'` | `Date \| string` | — | Date to be displayed **(required)** |

### DateTimeBlockLabel

**Element:** `HTMLLabelElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content for composable DateTimeBlock Label subcomponent |
| `css` | `SystemStyleObject` | — | Styles object |

### DateTimeBlockRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |
| `timeDisplay` | `'chips' \| 'select'` | `select` | Display type |
| `label` | `string` | `'Select a date and time'` | Label for date-time block |
| `dates` | `Array<Date \| string>` | — | Array of dates to select from |
| `disabledDates` | `Array<Date \| string>` | — | Array of dates to disable |
| `selectedDate` | `Date \| string` | — | Selected date |
| `defaultSelectedDate` | `Date \| string` | — | Default selected date for uncontrolled usage |
| `datesToShow` | `DateSelectQuantityType` | `3` | Quantity of dates to display as a select Note: quantity depends on available width where component will be placed, if using a narrow display, consider fewer cards |
| `onDateChange` | `(value: Date \| string) => void` | — | Callback function when a date is selected |
| `times` | `Array<Date \| string>` | — | Array of times to select from |
| `disabledTimes` | `Array<Date \| string>` | — | Array of times to disable |
| `onTimeChange` | `(value: Date \| string \| Array<Date \| string>) => void` | — | Callback function when a time is selected In single selection mode, receives a single time value In multiple selection mode, receives an array of time values |
| `selectedTime` | `Date \| string \| Array<Date \| string>` | — | Selected time(s) Single value for single selection mode, array for multiple selection mode |
| `defaultSelectedTime` | `Date \| string \| Array<Date \| string>` | — | Default selected time(s) for uncontrolled usage Single value for single selection mode, array for multiple selection mode |
| `multiple` | `boolean` | `false` | Enable multiple time selection mode When true, selectedTime/defaultSelectedTime should be arrays and onTimeChange receives arrays |
| `touchScreenOffset` | `'tightest' \| 'tighter' \| 'tight' \| 'default' \| 'loose' \| 'looser'` | — | Spacing value for touch screen horizontal offset. When provided, enables the container to "pop out" of its parent with negative margins and adds corresponding padding/pseudo-elements for proper spacing. Should match the parent container's padding value. (Only applied on touch screen devices). |

### DateTimeBlockTimes

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content for composable DateTimeBlock Times subcomponent |
| `css` | `SystemStyleObject` | — | Styles object |
| `renderTimesChips` | `(props: UseDateTimeBlockRenderTimesChipsPropsInterface) => ReactNode` | `<ChipGroup><FilterChip/></ChipGroup>` | Custom chips render function Render function that receives chips props for customization |
| `renderTimesSelect` | `(props: UseDateTimeBlockRenderTimesSelectPropsInterface) => ReactNode` | `<DropdownSelect/>` | Custom select render function Render function that receives select props for customization |
| `renderTimesHelp` | `(props: UseDateTimeBlockRenderTimesHelpPropsInterface) => ReactNode` | `<Text/>` | Custom help render function for when no date is selected Render function that receives help props for customization |

### DateTimeBlockWrap

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content for composable DateTimeBlock Label subcomponent |
| `css` | `SystemStyleObject` | — | Styles object |

