# Form

```tsx
import { Form } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.0.0

## Usage

```tsx
import {
  AdornedInput,
  Button,
  Checkbox,
  Combobox,
  DatePicker,
  DropdownSelect,
  FieldSet,
  Form,
  FormActions,
  FormField,
  Icon,
  IconButton,
  Input,
  Label,
  LabeledControl,
  Legend,
  Radio,
  Select,
  Slider,
  Switch,
  Textarea,
  ToggleButton,
  ToggleButtonGroup,
} from '@zillow/constellation';
```

```tsx
export const FormBasic = () => (
  <Form onSubmit={(event) => event.preventDefault()}>
    <FormField required control={<Input />} label={<Label>Name</Label>} />
    <FormField required control={<Input type="email" />} label={<Label>Email</Label>} />
    <FormField
      required
      control={
        <AdornedInput
          endAdornment={
            <AdornedInput.Adornment asChild>
              <IconButton
                emphasis="bare"
                onClick={() =>
                  // oxlint-disable-next-line no-console
                  console.log('Clicked button in AdornedInput.Adornment')
                }
                shape="square"
                size="md"
                title="Show password"
                tone="neutral"
              >
                <Icon>
                  <IconConcealFilled />
                </Icon>
              </IconButton>
            </AdornedInput.Adornment>
          }
          input={<AdornedInput.Input type="password" />}
          startAdornment={null}
        />
      }
      label={<Label>Password</Label>}
    />
    <FieldSet required legend={<Legend>Marital status</Legend>}>
      <LabeledControl
        controlId="unmarried"
        label={<Label>Unmarried (includes single, divorced, or widowed)</Label>}
        control={<Radio name="marital-status" defaultChecked />}
      />
      <LabeledControl
        controlId="married"
        label={<Label>Married</Label>}
        control={<Radio name="marital-status" />}
      />
      <LabeledControl
        controlId="separated"
        label={<Label>Separated</Label>}
        control={<Radio name="marital-status" />}
      />
    </FieldSet>
    <FieldSet optional legend={<Legend>Communication preferences</Legend>}>
      <LabeledControl
        controlId="unmarried"
        label={<Label>Newsletter</Label>}
        control={<Switch name="newsletter" defaultChecked />}
      />
    </FieldSet>
    <FormField
      optional
      label={<Label>Are you or your spouse in the military or a veteran?</Label>}
      control={
        <ToggleButtonGroup aria-label="Military or veteran">
          <ToggleButton value="yes">Yes</ToggleButton>
          <ToggleButton value="no">No</ToggleButton>
        </ToggleButtonGroup>
      }
    />
    <FormField
      optional
      label={<Label>When did you move to your current address?</Label>}
      control={<DatePicker />}
    />
    <FormField
      optional
      label={<Label>Number of bedrooms</Label>}
      control={
        <Select>
          <option value="1">1 bedroom</option>
          <option value="2">2 bedrooms</option>
          <option value="3">3 bedrooms</option>
          <option value="4">4+ bedrooms</option>
        </Select>
      }
    />
    <FormField
      optional
      label={<Label>Preferred home features</Label>}
      control={
        <Combobox
          defaultValue={['garage', 'fireplace']}
          options={[
            { value: 'garage', label: 'Garage' },
            { value: 'pool', label: 'Pool' },
            { value: 'fireplace', label: 'Fireplace' },
            { value: 'garden', label: 'Garden' },
            { value: 'basement', label: 'Basement' },
          ]}
          placeholder="Select features..."
        />
      }
    />
    <FormField
      optional
      label={<Label>Property type</Label>}
      control={
        <DropdownSelect
          options={[
            {
              value: 'house',
              label: 'House',
              icon: <Icon render={<IconHouseFilled />} />,
            },
            {
              value: 'condo',
              label: 'Condo',
              icon: <Icon render={<IconBuildingFilled />} />,
            },
            {
              value: 'townhouse',
              label: 'Townhouse',
              icon: <Icon render={<IconTownhouseFilled />} />,
            },
            {
              value: 'multi-family',
              label: 'Multi-family',
              icon: <Icon render={<IconMultiFamilyFilled />} />,
            },
            {
              value: 'land',
              label: 'Land',
              icon: <Icon render={<IconLotSizeFilled />} />,
            },
          ]}
          showLabelForValue
        />
      }
    />
    <FormField
      optional
      label={<Label>Target price range</Label>}
      control={
        <Slider
          min={0}
          max={2_000_000}
          step={10_000}
          defaultValue={[500_000, 1_000_000]}
          ariaValuetext={(state) => `$${state.valueNow}`.replace(/000$/, ',000')}
        />
      }
    />
    <FormField
      optional
      label={<Label>Additional notes or requirements</Label>}
      control={<Textarea rows={3} />}
    />
    <FieldSet>
      <LabeledControl
        control={<Checkbox />}
        label={<Label>I agree to the terms and conditions</Label>}
      />
    </FieldSet>
    <FormActions>
      <Button tone="brand" emphasis="filled">
        Submit
      </Button>
    </FormActions>
  </Form>
);
```

## Examples

### Form Polymorphic

```tsx
import { Form } from '@zillow/constellation';
```

```tsx
export const FormPolymorphic = () => (
  <Form asChild>
    <section>Content</section>
  </Form>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

