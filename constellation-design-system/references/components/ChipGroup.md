# ChipGroup

```tsx
import { ChipGroup } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 10.2.0

## Usage

```tsx
import { ChipGroup, FilterChip } from '@zillow/constellation';
```

```tsx
const chipArray = Array.from({ length: 16 }, (_, index) => (index + 1).toString());

export const ChipGroupBasic = () => (
  <ChipGroup aria-label="Chip group">
    {chipArray.map((chip) => (
      <FilterChip key={chip} value={chip}>
        {`Chip ${chip}`}
      </FilterChip>
    ))}
  </ChipGroup>
);
```

## Examples

### Chip Group As Child

```tsx
import { ChipGroup, FilterChip } from '@zillow/constellation';
```

```tsx
const chipArray = Array.from({ length: 16 }, (_, index) => (index + 1).toString());

export const ChipGroupAsChild = () => (
  <ChipGroup aria-label="Chip group" asChild>
    <article>
      {chipArray.map((chip) => (
        <FilterChip key={chip} value={chip}>
          {`Chip ${chip}`}
        </FilterChip>
      ))}
    </article>
  </ChipGroup>
);
```

### Chip Group Assist Chips

```tsx
import { AssistChip, ChipGroup } from '@zillow/constellation';
```

```tsx
export const ChipGroupAssistChips = () => (
  <ChipGroup aria-label="Chip group">
    <AssistChip onClick={() => alert('Search clicked')}>Search</AssistChip>
    <AssistChip onClick={() => alert('Filter clicked')}>Filter</AssistChip>
    <AssistChip onClick={() => alert('Sort clicked')}>Sort</AssistChip>
    <AssistChip onClick={() => alert('Share clicked')}>Share</AssistChip>
  </ChipGroup>
);
```

### Chip Group Controlled

```tsx
import { ChipGroup, FilterChip } from '@zillow/constellation';
```

```tsx
const chipArray = Array.from({ length: 8 }, (_, index) => (index + 1).toString());

export const ChipGroupControlled = () => {
  const [selected, setSelected] = useState<string>('1');

  const handleSelectionChange = (value: string | Array<string>) => {
    if (typeof value === 'string') {
      setSelected(value);
    }
  };

  return (
    <ChipGroup
      aria-label="Chip group"
      selected={selected}
      onSelectionChange={handleSelectionChange}
    >
      {chipArray.map((chip) => (
        <FilterChip key={chip} value={chip}>
          {`Chip ${chip}`}
        </FilterChip>
      ))}
    </ChipGroup>
  );
};
```

### Chip Group Disabled

```tsx
import { ChipGroup, FilterChip } from '@zillow/constellation';
```

```tsx
const chipArray = Array.from({ length: 8 }, (_, index) => (index + 1).toString());

export const ChipGroupDisabled = () => (
  <ChipGroup aria-label="Chip group" disabled>
    {chipArray.map((chip) => (
      <FilterChip key={chip} value={chip}>
        {`Chip ${chip}`}
      </FilterChip>
    ))}
  </ChipGroup>
);
```

### Chip Group Elevated

```tsx
import { ChipGroup, FilterChip } from '@zillow/constellation';
```

```tsx
const chipArray = Array.from({ length: 8 }, (_, index) => (index + 1).toString());

export const ChipGroupElevated = () => (
  <ChipGroup aria-label="Chip group" elevated>
    {chipArray.map((chip) => (
      <FilterChip key={chip} value={chip}>
        {`Chip ${chip}`}
      </FilterChip>
    ))}
  </ChipGroup>
);
```

### Chip Group Filter Chips Multiple

```tsx
import { ChipGroup, FilterChip } from '@zillow/constellation';
```

```tsx
const chipArray = Array.from({ length: 8 }, (_, index) => (index + 1).toString());

export const ChipGroupFilterChipsMultiple = () => (
  <ChipGroup aria-label="Chip group" multiple>
    {chipArray.map((chip) => (
      <FilterChip key={chip} value={chip}>
        {`Chip ${chip}`}
      </FilterChip>
    ))}
  </ChipGroup>
);
```

### Chip Group Filter Chips With Menus

```tsx
import { ChipGroup, FilterChipWithMenu } from '@zillow/constellation';
```

```tsx
export const ChipGroupFilterChipsWithMenus = () => (
  <ChipGroup aria-label="Chip group">
    <FilterChipWithMenu labelVoiceOver="Foundation filter" defaultValue="">
      <option value="">Foundation type</option>
      <option value="concrete">Concrete slab</option>
      <option value="pier">Pier and beam</option>
      <option value="wood">Wood</option>
    </FilterChipWithMenu>
    <FilterChipWithMenu labelVoiceOver="Bedrooms filter" defaultValue="">
      <option value="">Bedrooms</option>
      <option value="1">1 Bedroom</option>
      <option value="2">2 Bedrooms</option>
      <option value="3">3 Bedrooms</option>
      <option value="4">4+ Bedrooms</option>
    </FilterChipWithMenu>
  </ChipGroup>
);
```

### Chip Group Input Chips

```tsx
import { ChipGroup, InputChip } from '@zillow/constellation';
```

```tsx
export const ChipGroupInputChips = () => (
  <ChipGroup aria-label="Chip group">
    <InputChip onClose={() => alert('Removed JavaScript')}>JavaScript</InputChip>
    <InputChip onClose={() => alert('Removed React')}>React</InputChip>
    <InputChip onClose={() => alert('Removed TypeScript')}>TypeScript</InputChip>
    <InputChip onClose={() => alert('Removed Node.js')}>Node.js</InputChip>
  </ChipGroup>
);
```

### Chip Group Vertical Spacing Tighter

```tsx
import { ChipGroup, FilterChip } from '@zillow/constellation';
```

```tsx
const chipArray = Array.from({ length: 16 }, (_, index) => (index + 1).toString());

export const ChipGroupVerticalSpacingTighter = () => (
  <ChipGroup aria-label="Chip group" verticalSpacing="tighter">
    {chipArray.map((chip) => (
      <FilterChip key={chip} value={chip}>
        {`Chip ${chip}`}
      </FilterChip>
    ))}
  </ChipGroup>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'aria-label'` | `AriaAttributes['aria-label']` | — | An [aria-label](https://www.w3.org/TR/wai-aria-1.2/#aria-label) is required for assistive technologies to announce the chip group properly. **(required)** |
| `'asChild'` | `boolean` | `false` | Use child as the root element |
| `'elevated'` | `boolean` | — | Adds shadow to children chips |
| `'children'` | `ReactNode` | — | Content |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'role'` | `AriaRole` | `group` | Sets the `role` of the chip group. By default, this is set to ["group"](https://www.w3.org/TR/wai-aria-1.2/#group). |
| `'selected'` | `string \| Array<string>` | — | The selected value(s) for controlled usage. Use with `onSelectionChange` for controlled components. For single selection, provide a single value. For multiple selection, provide an array of values. |
| `'defaultSelected'` | `string \| Array<string>` | — | The default selected value(s) for uncontrolled usage. For single selection, provide a single value. For multiple selection, provide an array of values. |
| `'onSelectionChange'` | `(value: string \| Array<string>) => void` | — | Callback fired when the selection changes. |
| `'multiple'` | `boolean` | `false` | Enable multiple selection mode. When true, `selected` and `defaultSelected` should be arrays. |
| `'disabled'` | `boolean` | `false` | Disable all chips in the group. Individual chips can still override this with their own disabled prop. |
| `'verticalSpacing'` | `'default' \| 'tighter'` | `'default'` | The vertical spacing between chips. |

