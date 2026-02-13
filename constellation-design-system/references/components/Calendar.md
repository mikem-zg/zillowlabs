# Calendar

```tsx
import { Calendar } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 10.0.0

## Usage

```tsx
import { Calendar } from '@zillow/constellation';
```

```tsx
export const CalendarBasic = () => {
  return <Calendar />;
};
```

## Examples

### Calendar Composed

```tsx
import { Calendar, Icon } from '@zillow/constellation';
```

```tsx
export const CalendarComposed = () => (
  <Calendar.Root>
    <Calendar.Controls
      renderPrevMonth={(props) => (
        <Calendar.ControlButton {...props}>
          <Icon render={<IconArrowLeftOutline />} />
        </Calendar.ControlButton>
      )}
      renderNextMonth={(props) => (
        <Calendar.ControlButton {...props}>
          <Icon render={<IconArrowRightOutline />} />
        </Calendar.ControlButton>
      )}
    />
    <Calendar.Body
      renderDay={({ day, ...rest }) => <Calendar.Day {...rest}>{day}</Calendar.Day>}
      renderDayOfWeek={({ day, ...rest }) => (
        <Calendar.DayOfWeek {...rest}>{day}</Calendar.DayOfWeek>
      )}
    />
  </Calendar.Root>
);
```

### Calendar Disabled Dates

```tsx
import { Calendar } from '@zillow/constellation';
```

```tsx
export const CalendarDisabledDates = () => (
  <Calendar
    disabledDates={[
      addDays(startOfToday(), 1),
      addDays(startOfToday(), 2),
      addDays(startOfToday(), 3),
    ]}
  />
);
```

### Calendar Max Date

```tsx
import { Calendar } from '@zillow/constellation';
```

```tsx
export const CalendarMaxDate = () => <Calendar maxDate={new Date()} />;
```

### Calendar Min Date

```tsx
import { Calendar } from '@zillow/constellation';
```

```tsx
export const CalendarMinDate = () => <Calendar minDate={new Date()} />;
```

### Calendar Today Selected

```tsx
import { Calendar } from '@zillow/constellation';
```

```tsx
export const CalendarTodaySelected = () => <Calendar defaultSelected={new Date()} />;
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `dateFormat` | `string` | `MM/dd/yyyy` | The format of the date when parsing date strings. This format will also be used for formatting dates returned to the `onChange` callback.  Formatting options can be seen in [date-fns](https://date-fns.org/v2.13.0/docs/format). |
| `disabledDates` | `Array<Date \| string> \| ((date: Date) => boolean)` | `[]` | An array of dates that are unavailable to be selected. |
| `minDate` | `Date \| string` | — | The oldest date allowed by the date picker. Defaults to 5 years before the selected date. |
| `maxDate` | `Date \| string` | — | The newest date allowed by the date picker. Defaults to 5 years after the selected date. |
| `onSelectedChange` | `(value: Record<string, Date \| string>, meta: { reason: string }) => void` | — | Callback function when a day is selected from the calendar using a mouse or keyboard. The callback will receive two parameters. One with the date object `date`, and one with the formatted date string `formatted`. |
| `selected` | `Date \| string` | — | The value when using this as a [controlled component](https://reactjs.org/docs/forms.html#controlled-components). |
| `defaultSelected` | `Date \| string` | — | The default value when using this as an [uncontrolled component](https://reactjs.org/docs/uncontrolled-components.html). |
| `headerId` | `string` | — | The `id` of the header element rendered by `Calendar.Month`. Used to associate the header with an accessible label on `Calendar.Body`. |

### CalendarBody

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'renderDay'` | `(props: Omit<CalendarDayPropsInterface, 'children'> & { day: number }) => ReactNode` | — | Render day |
| `'renderDayOfWeek'` | `(     props: Omit<CalendarDayOfWeekPropsInterface, 'children'> & { day: string },   ) => ReactNode` | — | Render day of week |
| `'aria-labelledby'` | `AriaAttributes['aria-labelledby']` | `calendar?.headerId` | The `id` of the element that acts as an accessible label for those using assistive technologies. The label should describe the purpose of the progress bar. When used in a `DatePicker`, this value will automatically be set to the rendered month's `id`. |

### CalendarControlButton

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `tone` | `'brand' \| 'neutral' \| 'neutral-fixed' \| 'critical'` | `brand` | Tone of the button Can be inherited from a parent ButtonGroup. |
| `emphasis` | `'filled' \| 'outlined' \| 'bare'` | `filled` | Button emphasis |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | — | Set the button as disabled. |
| `icon` | `ReactNode` | — | Add an icon via a prop vs children.  If both the `icon` prop and `children` are passed, `children` will take priority and `icon` prop will be ignored. |
| `onImpact` | `boolean` | — | Inverse colors for use on dark or colored backgrounds. |
| `shape` | `'circle' \| 'square'` | — | Dictates the shape of the button |
| `size` | `'xs' \| 'sm' \| 'md' \| 'lg'` | — | The size of the button, not the icon in the button. The size of the icon cannot be changed. Can be inherited from a parent ButtonGroup. |
| `tabIndex` | `number` | — | The tabIndex of the button. |
| `title` | `string` | — | Accessible text of the button **(required)** |
| `type` | `ComponentProps<'button'>['type']` | `button` | The type of the button. |

### CalendarControls

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `renderNextMonth` | `(props: CalendarControlButtonPropsInterface) => ReactNode` | — | Render next month button |
| `renderPrevMonth` | `(props: CalendarControlButtonPropsInterface) => ReactNode` | — | Render previous month button |
| `renderYearSelect` | `(props: CalendarYearSelectPropsInterface) => ReactNode` | — | Render year select |
| `renderMonth` | `(props: CalendarMonthPropsInterface) => ReactNode` | — | Render month |

### CalendarDay

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `selected` | `boolean` | `false` | Selected |
| `today` | `boolean` | `false` | Today |
| `disabled` | `boolean` | `false` | Disabled |

### CalendarDayOfWeek

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### CalendarMonth

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### CalendarRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `dateFormat` | `string` | `MM/dd/yyyy` | The format of the date when parsing date strings. This format will also be used for formatting dates returned to the `onChange` callback. Formatting options can be seen in [date-fns](https://date-fns.org/v2.13.0/docs/format). |
| `disabledDates` | `Array<Date \| string> \| ((date: Date) => boolean)` | `[]` | An array of dates that are unavailable to be selected. |
| `minDate` | `Date \| string` | `datePickerContext.minDate` | The oldest date allowed by the date picker. Defaults to 5 years before the selected date. |
| `maxDate` | `Date \| string` | `datePickerContext.maxDate` | The newest date allowed by the date picker. Defaults to 5 years after the selected date. |
| `onSelectedChange` | `(value: Record<string, Date \| string>, meta: { reason: string }) => void` | — | Callback function when a day is selected from the calendar using a mouse or keyboard. The callback will receive two parameters. One with the date object `date`, and one with the formatted date string `formatted`. |
| `selected` | `Date \| string` | `datePicker?.pendingValue ?? datePicker?.value` | The value when using this as a [controlled component](https://reactjs.org/docs/forms.html#controlled-components). |
| `defaultSelected` | `Date \| string` | `datePicker?.pendingValue ?? datePicker?.value` | The default value when using this as an [uncontrolled component](https://reactjs.org/docs/uncontrolled-components.html). |
| `headerId` | `string` | — | The `id` of the header element rendered by `Calendar.Month`. Used to associate the header with an accessible label on `Calendar.Body`. |

### CalendarYearSelect

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

