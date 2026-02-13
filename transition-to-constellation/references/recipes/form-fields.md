# Migrating Form Fields: shadcn/MUI/HTML → Constellation

## Constellation components

```tsx
import {
  Input, LabeledInput, Select, Checkbox, Radio,
  Switch, Textarea, FormField, FieldSet, FormHelp, Label
} from '@zillow/constellation';
import { Flex } from '@/styled-system/jsx';
```

---

## Before (shadcn/ui)

```tsx
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Checkbox } from '@/components/ui/checkbox';
import { RadioGroup, RadioGroupItem } from '@/components/ui/radio-group';
import { Switch } from '@/components/ui/switch';
import { Textarea } from '@/components/ui/textarea';

{/* Text input */}
<div className="space-y-2">
  <Label htmlFor="email">Email</Label>
  <Input id="email" type="email" placeholder="Enter your email" />
  <p className="text-sm text-red-500">Please enter a valid email</p>
</div>

{/* Select */}
<Select>
  <SelectTrigger>
    <SelectValue placeholder="Select a state" />
  </SelectTrigger>
  <SelectContent>
    <SelectItem value="wa">Washington</SelectItem>
    <SelectItem value="ca">California</SelectItem>
    <SelectItem value="ny">New York</SelectItem>
  </SelectContent>
</Select>

{/* Checkbox */}
<div className="flex items-center space-x-2">
  <Checkbox id="terms" />
  <Label htmlFor="terms">I agree to the terms</Label>
</div>

{/* Radio group */}
<RadioGroup defaultValue="buy">
  <div className="flex items-center space-x-2">
    <RadioGroupItem value="buy" id="buy" />
    <Label htmlFor="buy">Buy</Label>
  </div>
  <div className="flex items-center space-x-2">
    <RadioGroupItem value="rent" id="rent" />
    <Label htmlFor="rent">Rent</Label>
  </div>
</RadioGroup>

{/* Switch */}
<div className="flex items-center space-x-2">
  <Switch id="notifications" />
  <Label htmlFor="notifications">Enable notifications</Label>
</div>

{/* Textarea */}
<div className="space-y-2">
  <Label htmlFor="message">Message</Label>
  <Textarea id="message" placeholder="Type your message" />
</div>
```

## Before (MUI)

```tsx
import TextField from '@mui/material/TextField';
import Select from '@mui/material/Select';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import InputLabel from '@mui/material/InputLabel';
import FormHelperText from '@mui/material/FormHelperText';
import Checkbox from '@mui/material/Checkbox';
import FormControlLabel from '@mui/material/FormControlLabel';
import RadioGroup from '@mui/material/RadioGroup';
import Radio from '@mui/material/Radio';
import Switch from '@mui/material/Switch';

{/* Text field with error */}
<TextField
  label="Email"
  type="email"
  error
  helperText="Please enter a valid email"
  fullWidth
/>

{/* Select */}
<FormControl fullWidth>
  <InputLabel>State</InputLabel>
  <Select value={state} onChange={(e) => setState(e.target.value)} label="State">
    <MenuItem value="wa">Washington</MenuItem>
    <MenuItem value="ca">California</MenuItem>
    <MenuItem value="ny">New York</MenuItem>
  </Select>
</FormControl>

{/* Checkbox */}
<FormControlLabel control={<Checkbox />} label="I agree to the terms" />

{/* Radio group */}
<RadioGroup value={type} onChange={(e) => setType(e.target.value)}>
  <FormControlLabel value="buy" control={<Radio />} label="Buy" />
  <FormControlLabel value="rent" control={<Radio />} label="Rent" />
</RadioGroup>

{/* Switch */}
<FormControlLabel control={<Switch />} label="Enable notifications" />

{/* Multiline text */}
<TextField label="Message" multiline rows={4} fullWidth />
```

## Before (Tailwind + HTML)

```tsx
{/* Text input */}
<div className="space-y-1">
  <label htmlFor="email" className="text-sm font-medium">Email</label>
  <input
    id="email"
    type="email"
    className="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
    placeholder="Enter your email"
  />
  <p className="text-sm text-red-500">Please enter a valid email</p>
</div>

{/* Select */}
<div className="space-y-1">
  <label htmlFor="state" className="text-sm font-medium">State</label>
  <select id="state" className="w-full border rounded-lg px-3 py-2">
    <option value="">Select a state</option>
    <option value="wa">Washington</option>
    <option value="ca">California</option>
  </select>
</div>

{/* Checkbox */}
<div className="flex items-center gap-2">
  <input type="checkbox" id="terms" className="rounded" />
  <label htmlFor="terms" className="text-sm">I agree to the terms</label>
</div>

{/* Radio buttons */}
<fieldset>
  <legend className="text-sm font-medium mb-2">Property type</legend>
  <div className="space-y-2">
    <label className="flex items-center gap-2">
      <input type="radio" name="type" value="buy" />
      <span className="text-sm">Buy</span>
    </label>
    <label className="flex items-center gap-2">
      <input type="radio" name="type" value="rent" />
      <span className="text-sm">Rent</span>
    </label>
  </div>
</fieldset>

{/* Textarea */}
<div className="space-y-1">
  <label htmlFor="message" className="text-sm font-medium">Message</label>
  <textarea
    id="message"
    rows={4}
    className="w-full border rounded-lg px-3 py-2"
    placeholder="Type your message"
  ></textarea>
</div>
```

---

## After (Constellation)

### Text input with LabeledInput (simplest)

```tsx
<LabeledInput
  label="Email"
  type="email"
  placeholder="Enter your email"
  size="md"
/>
```

### Text input with validation error

```tsx
<LabeledInput
  label="Email"
  type="email"
  placeholder="Enter your email"
  size="md"
  error="Please enter a valid email"
/>
```

### Text input with FormField (more control)

```tsx
<FormField>
  <Label>Email</Label>
  <Input type="email" placeholder="Enter your email" size="md" />
  <FormHelp>We'll never share your email.</FormHelp>
</FormField>
```

### FormField with error state

```tsx
<FormField error>
  <Label>Email</Label>
  <Input type="email" placeholder="Enter your email" size="md" />
  <FormHelp>Please enter a valid email address.</FormHelp>
</FormField>
```

### Select

```tsx
<LabeledInput label="State">
  <Select size="md" value={state} onChange={(e) => setState(e.target.value)}>
    <option value="">Select a state</option>
    <option value="wa">Washington</option>
    <option value="ca">California</option>
    <option value="ny">New York</option>
  </Select>
</LabeledInput>
```

### Checkbox

```tsx
<Checkbox
  label="I agree to the terms and conditions"
  checked={agreed}
  onChange={(e) => setAgreed(e.target.checked)}
/>
```

### Radio group with FieldSet

```tsx
<FieldSet legend="Property type">
  <Flex direction="column" gap="200">
    <Radio
      name="propertyType"
      value="buy"
      label="Buy"
      checked={type === 'buy'}
      onChange={() => setType('buy')}
    />
    <Radio
      name="propertyType"
      value="rent"
      label="Rent"
      checked={type === 'rent'}
      onChange={() => setType('rent')}
    />
  </Flex>
</FieldSet>
```

### Switch

```tsx
<Switch
  label="Enable notifications"
  checked={notificationsEnabled}
  onChange={(e) => setNotificationsEnabled(e.target.checked)}
/>
```

### Textarea

```tsx
<LabeledInput label="Message">
  <Textarea
    placeholder="Type your message"
    rows={4}
    size="md"
  />
</LabeledInput>
```

### Complete form example

```tsx
<Flex direction="column" gap="400">
  <LabeledInput
    label="Full name"
    placeholder="Enter your full name"
    size="md"
    value={name}
    onChange={(e) => setName(e.target.value)}
  />

  <LabeledInput
    label="Email"
    type="email"
    placeholder="Enter your email"
    size="md"
    value={email}
    onChange={(e) => setEmail(e.target.value)}
    error={emailError}
  />

  <LabeledInput label="State">
    <Select size="md" value={state} onChange={(e) => setState(e.target.value)}>
      <option value="">Select a state</option>
      <option value="wa">Washington</option>
      <option value="ca">California</option>
    </Select>
  </LabeledInput>

  <FieldSet legend="I'm interested in">
    <Flex direction="column" gap="200">
      <Radio name="interest" value="buying" label="Buying" />
      <Radio name="interest" value="selling" label="Selling" />
      <Radio name="interest" value="renting" label="Renting" />
    </Flex>
  </FieldSet>

  <Checkbox label="I agree to the terms and conditions" />

  <LabeledInput label="Additional notes">
    <Textarea placeholder="Anything else we should know?" rows={3} size="md" />
  </LabeledInput>

  <Button tone="brand" emphasis="filled" size="md">
    Submit
  </Button>
</Flex>
```

---

## Required rules

- Professional apps ALWAYS use `size="md"` for inputs and selects
- NEVER use styled divs or custom form controls — use Constellation form components
- Use `LabeledInput` for simple labeled inputs (includes label + input + error in one)
- Use `FormField` + `Label` + `Input` + `FormHelp` when you need more layout control
- Use `FieldSet` with `legend` to group related radio buttons or checkboxes
- Error messages appear automatically when `error` prop is set on `LabeledInput` or `FormField`

---

## Anti-patterns

```tsx
// WRONG — custom styled input
<div>
  <label className="text-sm font-medium">Email</label>
  <input className="border rounded px-3 py-2 w-full" type="email" />
  <span className="text-red-500 text-sm">Invalid email</span>
</div>

// CORRECT — use LabeledInput
<LabeledInput
  label="Email"
  type="email"
  size="md"
  error="Invalid email"
/>
```

```tsx
// WRONG — CSS border as separator between form sections
<div style={{ borderBottom: '1px solid #ccc', margin: '16px 0' }} />

// CORRECT — use Divider
<Divider />
```

```tsx
// WRONG — custom checkbox with styled div
<div className="flex items-center gap-2">
  <div className="w-4 h-4 border rounded bg-blue-500" />
  <span>Agree to terms</span>
</div>

// CORRECT — use Checkbox component
<Checkbox label="Agree to terms" />
```

---

## Variants

### Input sizes

```tsx
<Input size="sm" />   {/* Compact UI */}
<Input size="md" />   {/* Default for professional apps */}
<Input size="lg" />   {/* Hero search bars */}
```

### Input states

```tsx
<LabeledInput label="Normal" size="md" />
<LabeledInput label="With error" size="md" error="This field is required" />
<LabeledInput label="Disabled" size="md" disabled />
<LabeledInput label="Read-only" size="md" readOnly value="Cannot edit" />
```

### Select with placeholder

```tsx
<LabeledInput label="Property type">
  <Select size="md">
    <option value="" disabled>Choose a type</option>
    <option value="house">House</option>
    <option value="condo">Condo</option>
    <option value="townhouse">Townhouse</option>
  </Select>
</LabeledInput>
```

---

## Edge cases

### Password input with show/hide

```tsx
<LabeledInput
  label="Password"
  type={showPassword ? 'text' : 'password'}
  size="md"
/>
```

### Input with adornment (prefix/suffix)

```tsx
import { AdornedInput } from '@zillow/constellation';

<AdornedInput
  start="$"
  end="/mo"
  size="md"
>
  <Input type="number" placeholder="0" />
</AdornedInput>
```

### Form inside a Card

```tsx
<Card outlined elevated={false} tone="neutral" css={{ p: '400' }}>
  <Flex direction="column" gap="400">
    <Text textStyle="body-lg-bold">Contact agent</Text>
    <LabeledInput label="Your name" size="md" />
    <LabeledInput label="Phone" type="tel" size="md" />
    <LabeledInput label="Message">
      <Textarea placeholder="I'd like to schedule a tour..." rows={3} size="md" />
    </LabeledInput>
    <Button tone="brand" emphasis="filled" size="md">Send message</Button>
  </Flex>
</Card>
```

### Form inside a Modal

```tsx
<Modal
  size="md"
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Schedule a tour</Heading>}
  body={
    <Flex direction="column" gap="300">
      <LabeledInput label="Preferred date" type="date" size="md" />
      <LabeledInput label="Preferred time">
        <Select size="md">
          <option value="morning">Morning (9am - 12pm)</option>
          <option value="afternoon">Afternoon (12pm - 5pm)</option>
          <option value="evening">Evening (5pm - 8pm)</option>
        </Select>
      </LabeledInput>
      <LabeledInput label="Notes">
        <Textarea placeholder="Any special requests?" rows={2} size="md" />
      </LabeledInput>
    </Flex>
  }
  footer={
    <ButtonGroup aria-label="Tour actions">
      <Modal.Close>
        <TextButton>Cancel</TextButton>
      </Modal.Close>
      <Button tone="brand" emphasis="filled" size="md">Request tour</Button>
    </ButtonGroup>
  }
/>
```
