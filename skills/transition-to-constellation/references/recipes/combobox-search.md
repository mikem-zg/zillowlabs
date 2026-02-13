# Migrating Search/Select: shadcn Command/react-select/MUI Autocomplete → Constellation Combobox

## Constellation component

```tsx
import { Combobox } from '@zillow/constellation';
```

---

## Before (shadcn/ui — Command/CommandDialog)

```tsx
import {
  Command, CommandDialog, CommandEmpty, CommandGroup,
  CommandInput, CommandItem, CommandList
} from '@/components/ui/command';
import { Search } from 'lucide-react';

{/* Inline searchable list */}
<Command>
  <CommandInput placeholder="Search cities..." />
  <CommandList>
    <CommandEmpty>No results found.</CommandEmpty>
    <CommandGroup heading="Suggestions">
      <CommandItem onSelect={() => handleSelect('seattle')}>Seattle, WA</CommandItem>
      <CommandItem onSelect={() => handleSelect('portland')}>Portland, OR</CommandItem>
      <CommandItem onSelect={() => handleSelect('raleigh')}>Raleigh, NC</CommandItem>
    </CommandGroup>
  </CommandList>
</Command>

{/* Dialog/modal search */}
<CommandDialog open={open} onOpenChange={setOpen}>
  <CommandInput placeholder="Search anything..." />
  <CommandList>
    <CommandEmpty>No results.</CommandEmpty>
    <CommandGroup heading="Cities">
      <CommandItem>Seattle</CommandItem>
      <CommandItem>Portland</CommandItem>
    </CommandGroup>
  </CommandList>
</CommandDialog>
```

## Before (MUI — Autocomplete)

```tsx
import Autocomplete from '@mui/material/Autocomplete';
import TextField from '@mui/material/TextField';

const cities = [
  { label: 'Seattle, WA', value: 'seattle' },
  { label: 'Portland, OR', value: 'portland' },
  { label: 'Raleigh, NC', value: 'raleigh' },
];

<Autocomplete
  options={cities}
  getOptionLabel={(option) => option.label}
  onChange={(e, value) => handleSelect(value)}
  renderInput={(params) => (
    <TextField {...params} label="Search cities" variant="outlined" />
  )}
/>

{/* With freeSolo (allow custom input) */}
<Autocomplete
  freeSolo
  options={cities.map((c) => c.label)}
  renderInput={(params) => (
    <TextField {...params} label="Type a city" />
  )}
/>

{/* Multiple selection */}
<Autocomplete
  multiple
  options={cities}
  getOptionLabel={(option) => option.label}
  onChange={(e, values) => handleMultiSelect(values)}
  renderInput={(params) => (
    <TextField {...params} label="Select cities" />
  )}
/>
```

## Before (react-select)

```tsx
import Select from 'react-select';

const options = [
  { value: 'seattle', label: 'Seattle, WA' },
  { value: 'portland', label: 'Portland, OR' },
  { value: 'raleigh', label: 'Raleigh, NC' },
];

<Select
  options={options}
  onChange={handleSelect}
  placeholder="Search cities..."
  isClearable
  isSearchable
/>

{/* Multi-select */}
<Select
  isMulti
  options={options}
  onChange={handleMultiSelect}
  placeholder="Select cities..."
/>
```

## Before (Chakra UI)

```tsx
import { Select } from '@chakra-ui/react';
import { AutoComplete, AutoCompleteInput, AutoCompleteItem, AutoCompleteList } from '@choc-ui/chakra-autocomplete';

<AutoComplete onChange={handleSelect}>
  <AutoCompleteInput placeholder="Search cities..." />
  <AutoCompleteList>
    <AutoCompleteItem value="seattle">Seattle, WA</AutoCompleteItem>
    <AutoCompleteItem value="portland">Portland, OR</AutoCompleteItem>
    <AutoCompleteItem value="raleigh">Raleigh, NC</AutoCompleteItem>
  </AutoCompleteList>
</AutoComplete>
```

## Before (Tailwind + HTML — custom search input)

```tsx
<div className="relative">
  <input
    type="text"
    className="w-full border rounded-lg px-4 py-2 pl-10"
    placeholder="Search cities..."
    value={query}
    onChange={(e) => setQuery(e.target.value)}
  />
  <svg className="absolute left-3 top-2.5 h-5 w-5 text-gray-400">...</svg>
  {results.length > 0 && (
    <ul className="absolute z-10 w-full mt-1 bg-white border rounded-lg shadow-lg max-h-60 overflow-auto">
      {results.map((item) => (
        <li
          key={item.value}
          className="px-4 py-2 hover:bg-gray-100 cursor-pointer"
          onClick={() => handleSelect(item)}
        >
          {item.label}
        </li>
      ))}
    </ul>
  )}
</div>
```

---

## After (Constellation)

### Basic searchable select

```tsx
import { Combobox } from '@zillow/constellation';

const cities = [
  { value: 'seattle', label: 'Seattle, WA' },
  { value: 'portland', label: 'Portland, OR' },
  { value: 'raleigh', label: 'Raleigh, NC' },
  { value: 'durham', label: 'Durham, NC' },
  { value: 'columbus', label: 'Columbus, OH' },
];

<Combobox
  label="Search cities"
  items={cities}
  onSelectedItemChange={(item) => handleSelect(item)}
  placeholder="Search cities..."
/>
```

### With filtering

```tsx
import { useState } from 'react';
import { Combobox } from '@zillow/constellation';

const allCities = [
  { value: 'seattle', label: 'Seattle, WA' },
  { value: 'portland', label: 'Portland, OR' },
  { value: 'raleigh', label: 'Raleigh, NC' },
  { value: 'durham', label: 'Durham, NC' },
  { value: 'columbus', label: 'Columbus, OH' },
  { value: 'san-antonio', label: 'San Antonio, TX' },
  { value: 'indianapolis', label: 'Indianapolis, IN' },
  { value: 'nashville', label: 'Nashville, TN' },
  { value: 'charlotte', label: 'Charlotte, NC' },
  { value: 'phoenix', label: 'Phoenix, AZ' },
];

function CitySearch() {
  const [filteredItems, setFilteredItems] = useState(allCities);

  const handleInputChange = (inputValue: string) => {
    const filtered = allCities.filter((city) =>
      city.label.toLowerCase().includes(inputValue.toLowerCase())
    );
    setFilteredItems(filtered);
  };

  return (
    <Combobox
      label="City"
      items={filteredItems}
      onInputValueChange={handleInputChange}
      onSelectedItemChange={(item) => handleSelect(item)}
      placeholder="Type to search..."
    />
  );
}
```

### Inside a form

```tsx
import { Combobox, LabeledInput, Button } from '@zillow/constellation';
import { Flex } from '@/styled-system/jsx';

<Flex direction="column" gap="400">
  <LabeledInput label="Name" placeholder="Enter your name" />
  <Combobox
    label="State"
    items={states}
    onSelectedItemChange={(item) => setSelectedState(item)}
    placeholder="Select a state..."
  />
  <Combobox
    label="City"
    items={citiesForState}
    onSelectedItemChange={(item) => setSelectedCity(item)}
    placeholder="Select a city..."
  />
  <Button tone="brand" emphasis="filled" size="md">Submit</Button>
</Flex>
```

---

## Required rules

- Use `Combobox` for searchable select/search inputs — NEVER custom `<input>` + dropdown `<ul>`
- Use `Combobox` when the user needs to search/filter through options (prefer over `Select` for 10+ options)
- Use `Select` for simple dropdowns with fewer than 10 static options
- Use `DataSelect` for data-driven selects with complex option rendering
- ALWAYS provide a `label` prop for accessibility
- Implement `onInputValueChange` for client-side filtering

---

## Anti-patterns

```tsx
// WRONG — custom search input with manual dropdown
<div className="relative">
  <Input value={query} onChange={(e) => setQuery(e.target.value)} />
  {showDropdown && (
    <Box css={{ position: 'absolute', zIndex: 10, bg: 'white', border: '1px solid' }}>
      {results.map((r) => (
        <Box key={r.value} onClick={() => select(r)} css={{ cursor: 'pointer', p: '200' }}>
          {r.label}
        </Box>
      ))}
    </Box>
  )}
</div>

// CORRECT — use Combobox
<Combobox
  label="Search"
  items={results}
  onInputValueChange={handleSearch}
  onSelectedItemChange={handleSelect}
  placeholder="Search..."
/>
```

```tsx
// WRONG — using Select for a long list of searchable options
<Select label="City">
  {allCities.map((city) => (
    <option key={city.value} value={city.value}>{city.label}</option>
  ))}
</Select>

// CORRECT — use Combobox for 10+ searchable options
<Combobox
  label="City"
  items={allCities}
  onInputValueChange={handleFilter}
  onSelectedItemChange={handleSelect}
  placeholder="Search cities..."
/>
```

```tsx
// WRONG — third-party react-select alongside Constellation
import Select from 'react-select';
<Select options={options} />

// CORRECT — use Constellation Combobox
import { Combobox } from '@zillow/constellation';
<Combobox label="Options" items={options} onSelectedItemChange={handleSelect} />
```

---

## Variants

### Combobox vs Select vs DataSelect

```tsx
{/* Combobox — searchable, filterable, 10+ options */}
<Combobox
  label="City"
  items={cities}
  onInputValueChange={handleFilter}
  onSelectedItemChange={handleSelect}
  placeholder="Search..."
/>

{/* Select — simple dropdown, <10 static options */}
<Select label="Property type" onChange={handleChange}>
  <option value="house">House</option>
  <option value="condo">Condo</option>
  <option value="townhouse">Townhouse</option>
</Select>

{/* DataSelect — data-driven with custom option rendering */}
<DataSelect
  label="Agent"
  items={agents}
  onSelectedItemChange={handleSelect}
/>
```

### Combobox sizes

```tsx
<Combobox label="City" items={cities} size="sm" />
<Combobox label="City" items={cities} size="md" />  {/* Default for professional apps */}
```

---

## Edge cases

### Replacing shadcn CommandDialog (search modal)

```tsx
import { Modal, Heading } from '@zillow/constellation';

<Modal
  size="md"
  open={isSearchOpen}
  onOpenChange={setIsSearchOpen}
  dividers
  header={<Heading level={1}>Search</Heading>}
  body={
    <Combobox
      label="Search"
      items={searchResults}
      onInputValueChange={handleSearch}
      onSelectedItemChange={(item) => {
        handleSelect(item);
        setIsSearchOpen(false);
      }}
      placeholder="Search addresses, cities, or ZIP codes..."
    />
  }
/>
```

### Combobox with no results

```tsx
<Combobox
  label="City"
  items={filteredCities.length > 0 ? filteredCities : []}
  onInputValueChange={handleFilter}
  onSelectedItemChange={handleSelect}
  placeholder="Search cities..."
/>
```

### Address search pattern (common for Zillow)

```tsx
function AddressSearch() {
  const [suggestions, setSuggestions] = useState([]);

  const handleSearch = async (inputValue: string) => {
    if (inputValue.length < 3) {
      setSuggestions([]);
      return;
    }
    const results = await fetchAddressSuggestions(inputValue);
    setSuggestions(results.map((r) => ({
      value: r.id,
      label: r.fullAddress,
    })));
  };

  return (
    <Combobox
      label="Address"
      items={suggestions}
      onInputValueChange={handleSearch}
      onSelectedItemChange={(item) => navigateToProperty(item.value)}
      placeholder="Enter an address, city, or ZIP code"
    />
  );
}
```

### Dependent comboboxes (state → city)

```tsx
function LocationSelector() {
  const [selectedState, setSelectedState] = useState(null);
  const [cities, setCities] = useState([]);

  const handleStateSelect = (state) => {
    setSelectedState(state);
    setCities(getCitiesForState(state.value));
  };

  return (
    <Flex direction="column" gap="400">
      <Combobox
        label="State"
        items={states}
        onSelectedItemChange={handleStateSelect}
        placeholder="Select state..."
      />
      <Combobox
        label="City"
        items={cities}
        onSelectedItemChange={(city) => handleCitySelect(city)}
        placeholder="Select city..."
        disabled={!selectedState}
      />
    </Flex>
  );
}
```
