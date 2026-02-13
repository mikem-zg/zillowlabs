# ProgressStepper

```tsx
import { ProgressStepper } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.42.0

## Usage

```tsx
import { ProgressStepper } from '@zillow/constellation';
```

```tsx
export const ProgressStepperBasic = () => (
  <ProgressStepper
    activeStepIndex={3}
    steps={['Basic', 'Education', 'Work', 'Security and background', 'Review']}
  />
);
```

## Examples

### Progress Stepper Adding Meta Content To Steps

```tsx
import { ProgressStepper, Tag } from '@zillow/constellation';
```

```tsx
export const ProgressStepperAddingMetaContentToSteps = () => (
  <ProgressStepper
    activeStepIndex={2}
    alignLabels="left"
    steps={[
      {
        label: 'Basic',
        meta: <Tag tone="success">Status</Tag>,
        tone: 'complete',
      },
      {
        label: 'Education',
        meta: <Tag tone="info">Status</Tag>,
        tone: 'complete',
        interactive: true,
        href: 'https://www.zillow.com',
      },
      {
        label: 'Work',
        meta: 'Complete by 9/22',
      },
      {
        label: 'Security',
      },
      {
        label: 'Review',
      },
    ]}
  />
);
```

### Progress Stepper Building Steps Using Other Data Structures

```tsx
import { ProgressStepper } from '@zillow/constellation';
```

```tsx
export const ProgressStepperBuildingStepsUsingOtherDataStructures = () => (
  <ProgressStepper
    activeStepIndex={2}
    steps={[{ step: 'Personal' }, { step: 'Contact' }, { step: 'History' }, { step: 'Review' }]}
    mapStepsToProps={(item: Record<string, any>) => ({ label: item.step })}
  />
);
```

### Progress Stepper Composition

```tsx
import { Box, ProgressStepper, Tag } from '@zillow/constellation';
```

```tsx
export const ProgressStepperComposition = () => {
  return (
    <Box css={{ display: 'flex', flexDirection: 'column', gap: 'layout.loose' }}>
      <ProgressStepper.Root
        activeStepIndex={2}
        alignLabels="left"
        steps={[
          {
            label: 'Basic',
            meta: <Tag tone="success">Status</Tag>,
            tone: 'complete',
          },
          {
            label: 'Education',
            meta: <Tag tone="info">Status</Tag>,
            tone: 'complete',
          },
          {
            label: 'Work',
            interactive: true,
          },
          {
            label: 'Security',
            interactive: true,
          },
          {
            label: 'Review',
            interactive: true,
          },
        ]}
      >
        <ProgressStepper.Bar />
        <ProgressStepper.Steps />
      </ProgressStepper.Root>

      <ProgressStepper.Root activeStepIndex={2} alignLabels="left">
        <ProgressStepper.Bar minValue={0} maxValue={5} />
        <ProgressStepper.Steps>
          <ProgressStepper.Step
            index={0}
            label="Basic"
            tone="complete"
            meta={<Tag tone="success">Status</Tag>}
          />
          <ProgressStepper.Step
            index={1}
            label="Education"
            tone="complete"
            meta={<Tag tone="info">Status</Tag>}
          />
          <ProgressStepper.Step index={2} label="Work" />
          <ProgressStepper.Step index={3} label="Security" interactive />
          <ProgressStepper.Step index={4} label="Review" interactive />
        </ProgressStepper.Steps>
      </ProgressStepper.Root>
    </Box>
  );
};
```

### Progress Stepper Interactive

```tsx
import { ProgressStepper, type ProgressStepperPropsInterface } from '@zillow/constellation';
```

```tsx
export const ProgressStepperInteractive = () => {
  const [activeStepIndex, setActiveStepIndex] = useState(3);
  const steps = [
    { label: 'Basic', tone: 'complete', interactive: true },
    { label: 'Education', tone: 'complete', interactive: true },
    { label: 'Work', tone: 'incomplete', interactive: true },
    { label: 'Security and background', tone: 'incomplete', interactive: true },
    { label: 'Review', interactive: true },
  ] satisfies ProgressStepperPropsInterface['steps'];

  return (
    <ProgressStepper
      activeStepIndex={activeStepIndex}
      onStepClick={(_event, nextActiveStepIndex) => setActiveStepIndex(nextActiveStepIndex)}
      steps={steps}
    />
  );
};
```

### Progress Stepper Label Appearances

```tsx
import { Box, ProgressStepper, Text } from '@zillow/constellation';
```

```tsx
export const ProgressStepperLabelAppearances = () => {
  return (
    <Box
      css={{
        display: 'flex',
        gap: 'loose',
        flexDirection: 'column',
      }}
    >
      <Text css={{ textAlign: 'center' }} textStyle="body-sm">
        Current
      </Text>

      <ProgressStepper
        activeStepIndex={2}
        steps={['Basic', 'Education', 'Work', 'Review']}
        labelAppearance="current"
        css={{ marginBlockEnd: 'looser' }}
      />

      <Text css={{ textAlign: 'center' }} textStyle="body-sm">
        All
      </Text>

      <ProgressStepper
        activeStepIndex={2}
        steps={['Basic', 'Education', 'Work', 'Review']}
        labelAppearance="all"
        css={{ marginBlockEnd: 'looser' }}
      />

      <Text css={{ textAlign: 'center' }} textStyle="body-sm">
        None
      </Text>

      <ProgressStepper
        activeStepIndex={2}
        steps={['Basic', 'Education', 'Work', 'Review']}
        labelAppearance="none"
        css={{ marginBlockEnd: 'looser' }}
      />

      <Text css={{ textAlign: 'center' }} textStyle="body-sm">
        Responsive: current on small screens, all on larger screens
      </Text>

      <ProgressStepper
        activeStepIndex={2}
        steps={['Basic', 'Education', 'Work', 'Review']}
        labelAppearance={{ base: 'current', md: 'all' }}
        css={{ marginBlockEnd: 'looser' }}
      />
    </Box>
  );
};
```

### Progress Stepper No Active Steps

```tsx
import { ProgressStepper } from '@zillow/constellation';
```

```tsx
export const ProgressStepperNoActiveSteps = () => (
  <>
    <ProgressStepper
      activeStepIndex={-1}
      steps={['Basic', 'Education', 'Work', 'Security and background', 'Review']}
      css={{ marginBlockEnd: 'looser' }}
    />

    <ProgressStepper
      activeStepIndex={5}
      steps={[
        { label: 'Basic', tone: 'complete' },
        { label: 'Education', tone: 'complete' },
        { label: 'Work', tone: 'complete' },
        { label: 'Security and background', tone: 'complete' },
        { label: 'Review', tone: 'complete' },
      ]}
    />
  </>
);
```

### Progress Stepper Vertical Orientation

```tsx
import { ProgressStepper, Tag } from '@zillow/constellation';
```

```tsx
export const ProgressStepperVerticalOrientation = () => (
  <ProgressStepper
    activeStepIndex={2}
    orientation="vertical"
    steps={[
      {
        label: 'Basic',
        meta: <Tag tone="success">Status</Tag>,
        tone: 'complete',
      },
      {
        label: 'Education',
        meta: <Tag tone="info">Status</Tag>,
        tone: 'complete',
      },
      {
        label: 'Work',
      },
      {
        label: 'Security',
      },
      {
        label: 'Review',
      },
    ]}
  />
);
```

### Progress Stepper With Step Objects

```tsx
import { ProgressStepper } from '@zillow/constellation';
```

```tsx
export const ProgressStepperWithStepObjects = () => (
  <ProgressStepper
    activeStepIndex={4}
    steps={[
      { label: 'Basic', tone: 'complete' },
      { label: 'Education', tone: 'incomplete' },
      { label: 'Work', tone: 'warning' },
      { label: 'Security and background', tone: 'critical' },
      { label: 'Contact', tone: 'incomplete' },
      { label: 'Review' },
    ]}
  />
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'activeStepIndex'` | `number` | `0` | Zero-based index of the step the user is currently on. This step will display in the "active" state.  If you don't want any steps to display as "active", you can use a value either less than 0 or higher than the final step's index. Ex: If the user hasn't started any steps yet, set `activeStepIndex={-1}` and the bar color will indicate no progress. If the user has completed all of five steps, set `activeStepIndex={5}` or higher. |
| `'alignLabels'` | `'center' \| 'left'` | `center` | Sets the horizontal alignment for all step labels. All labels in a `ProgressStepper` must have the same alignment.  When steps contain meta content, use left alignment to ensure readability. |
| `'aria-label'` | `AriaAttributes['aria-label']` | `progress` | Defines a string value that labels the ProgressStepper root element |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'labelAppearance'` | `ResponsiveVariant<'all' \| 'current' \| 'none'>` | `{ base: 'current', md: 'all' }` | Option to show all step labels, only the current step label, or hide all step labels on different breakpoints. Supports inline media queries. |
| `'onStepClick'` | `(event: MouseEvent<HTMLAnchorElement>, nextIndex: number) => void` | — | Callback when a single step is clicked |
| `'mapStepsToProps'` | `ProgressStepperStepsPropsInterface['mapStepsToProps']` | — | A function that maps the the steps prop to an object of props that will be passed to ProgressStepper.Step. By default, `mapStepsToProps` will convert strings into an object where the string is a label. |
| `'orientation'` | `'horizontal' \| 'vertical'` | `horizontal` | Displays either the horizontal or vertical version of the ProgressStepper.  Supports inline media query objects. Ex: You can display the horizontal version on desktop and tablet and the vertical version on phone. |
| `'steps'` | `Array<ProgressStepperStepPropsInterface \| Record<string, any> \| string>` | — | An array of step information.  Providing an array of strings will create a simple Progress Stepper with no icons nor interactivity. For a more complex Progress Stepper, you can provide an array of objects that will be passed as props to ProgressStepperStep. Objects must contain at least a label property (or, if you're using a custom `mapStepsToProps` callback, something equivalent). You can also use the optional meta property to show additional content underneath a step label (ex: a Tag or Text) |

### ProgressStepperBar

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'aria-describedby'` | `AriaAttributes['aria-describedby']` | — | Optional. The `id` of an element that provides information about the progress bar beyond the `aria-label` or `aria-labelledby` label.  When `ProgressBar` is used in a `FormField`, this value will automatically be set to the `description` element's `id`. |
| `'aria-label'` | `AriaAttributes['aria-label']` | — | An accessible label for those using assistive technologies. Describes the purpose of the progress bar.  An accessible label is required and can be provided using either `aria-label` or `aria-labelledby`. |
| `'aria-labelledby'` | `AriaAttributes['aria-labelledby']` | — | The `id` of the element that acts as an accessible label for those using assistive technologies. The label should describe the purpose of the progress bar.  When `ProgressBar` is used in a `FormField`, this value will automatically be set to the `label` element's `id`.  An accessible label is required and can be provided using either `aria-label` or `aria-labelledby`. |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'maxValue'` | `number` | `100` | The value when progress has been completed. |
| `'minValue'` | `number` | `0` | The value when no progress has been made. |
| `'size'` | `'sm' \| 'md'` | `sm` | Determines the height of the bar. |
| `'value'` | `number` | — | The current progress value. Do not use a percentage. Instead, use a number between the minValue and maxValue. |
| `'stepperOffset'` | `boolean` | — | Used only by ProgressStepper to adjust the width of its progress bar. Since a ProgressStepper starts at 1 (not 0), the width % needs to be calculated based on number of steps - 1. |

### ProgressStepperRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'activeStepIndex'` | `number` | `0` | Zero-based index of the step the user is currently on. This step will display in the "active" state. If you don't want any steps to display as "active", you can use a value either less than 0 or higher than the final step's index. Ex: If the user hasn't started any steps yet, set `activeStepIndex={-1}` and the bar color will indicate no progress. If the user has completed all of five steps, set `activeStepIndex={5}` or higher. |
| `'alignLabels'` | `'center' \| 'left'` | `center` | Sets the horizontal alignment for all step labels. All labels in a `ProgressStepper` must have the same alignment. When steps contain meta content, use left alignment to ensure readability. |
| `'aria-label'` | `AriaAttributes['aria-label']` | `progress` | Defines a string value that labels the ProgressStepper root element |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'labelAppearance'` | `ResponsiveVariant<'all' \| 'current' \| 'none'>` | `{ base: 'current', md: 'all' }` | Option to show all step labels, only the current step label, or hide all step labels on different breakpoints. Supports inline media queries. |
| `'onStepClick'` | `(event: MouseEvent<HTMLAnchorElement>, nextIndex: number) => void` | — | Callback when a single step is clicked |
| `'mapStepsToProps'` | `ProgressStepperStepsPropsInterface['mapStepsToProps']` | — | A function that maps the the steps prop to an object of props that will be passed to ProgressStepper.Step. By default, `mapStepsToProps` will convert strings into an object where the string is a label. |
| `'orientation'` | `'horizontal' \| 'vertical'` | `horizontal` | Displays either the horizontal or vertical version of the ProgressStepper. Supports inline media query objects. Ex: You can display the horizontal version on desktop and tablet and the vertical version on phone. |
| `'steps'` | `Array<ProgressStepperStepPropsInterface \| Record<string, any> \| string>` | — | An array of step information. Providing an array of strings will create a simple Progress Stepper with no icons nor interactivity. For a more complex Progress Stepper, you can provide an array of objects that will be passed as props to ProgressStepperStep. Objects must contain at least a label property (or, if you're using a custom `mapStepsToProps` callback, something equivalent). You can also use the optional meta property to show additional content underneath a step label (ex: a Tag or Text) |

### ProgressStepperStep

**Element:** `HTMLLIElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `active` | `boolean` | `false` | Indicates this is the current, active step. |
| `asChild` | `boolean` | `false` | Use child as the root element |
| `css` | `SystemStyleObject` | — | Styles object |
| `href` | `string` | `#` | If `interactive` is true, this is the href the anchor will point to. |
| `interactive` | `boolean` | `false` | If true, user will be able to click on and navigate to the step |
| `index` | `number` | — | Internally used to track step position |
| `label` | `string` | — | Label text of the step. |
| `meta` | `string \| ReactElement<TagPropsInterface>` | — | * Additional content that will appear underneath the step label text. Currently, `Tag` and text are officially supported. For more customization options, you can use the `renderLabel` prop. It's best to avoid long `meta` values to help maintain understandability for screen reader users. |
| `renderLabel` | `(props: ProgressStepperStepPropsInterface) => ReactNode` | — | A function that takes a props object as an argument and returns a step label component, by default a `ProgressStepperStepLabel`. |
| `tone` | `Extract<StatusType, 'complete' \| 'incomplete' \| 'critical' \| 'warning'> \| 'none'` | — | Changes the appearance of a step to show its status. If no appearance is provided, the step will appear in the default, "not started" state. |

### ProgressStepperSteps

**Element:** `HTMLOListElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Used by composed `ProgressStepper` only. Contains a series of `ProgressStepper.Step` compoenents. |
| `css` | `SystemStyleObject` | — | Styles object |
| `mapStepsToProps` | `(step: any) => ProgressStepperStepPropsInterface` | — | A function that maps the the steps prop to an object of props that will be passed to ProgressStepper.Step. By default, `mapStepsToProps` will convert strings into an object where the string is a label. |
| `totalSteps` | `number` | `0` | The total number of steps in the ProgressStepper. This is automatically calculated based on the number of children. |

