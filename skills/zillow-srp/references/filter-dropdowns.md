# Filter Dropdowns + Buy Mega Menu

## FilterDropdown Container

Shared wrapper for all filter dropdown panels. Absolutely positioned below the trigger button.

```tsx
function FilterDropdown({ children, width = '340px' }: { children: ReactNode; width?: string }) {
  return (
    <Box
      css={{
        position: 'absolute',
        top: 'calc(100% + 4px)',
        left: 0,
        width,
        background: 'bg.screen.neutral',
        borderRadius: 'node.md',
        boxShadow: '0 4px 16px rgba(0,0,0,0.15)',
        zIndex: 50,
        p: '400',
      }}
    >
      {children}
    </Box>
  );
}
```

## ForSaleDropdown (280px)

Radio group: For sale / For rent / Sold.

```tsx
function ForSaleDropdown() {
  const [selected, setSelected] = useState('for-sale');
  const handler = useCallback(
    (event: React.ChangeEvent<HTMLInputElement>) => {
      setSelected(event.target.value);
    },
    [],
  );
  return (
    <FilterDropdown width="280px">
      <Flex direction="column" gap="300">
        <LabeledControl
          control={<Radio value="for-sale" checked={selected === 'for-sale'} onChange={handler} name="listing-type" />}
          label={<Label>For sale</Label>}
        />
        <LabeledControl
          control={<Radio value="for-rent" checked={selected === 'for-rent'} onChange={handler} name="listing-type" />}
          label={<Label>For rent</Label>}
        />
        <LabeledControl
          control={<Radio value="sold" checked={selected === 'sold'} onChange={handler} name="listing-type" />}
          label={<Label>Sold</Label>}
        />
      </Flex>
      <Button tone="brand" emphasis="filled" size="md" css={{ width: '100%', mt: '400' }}>
        Apply
      </Button>
    </FilterDropdown>
  );
}
```

## PriceDropdown (380px)

ToggleButtonGroup for price type (List price / Monthly payment) + min/max Select dropdowns.

```tsx
function PriceDropdown() {
  const [priceType, setPriceType] = useState<string | string[]>('list');
  return (
    <FilterDropdown width="380px">
      <Text textStyle="body-sm" css={{ fontWeight: 'bold', mb: '300' }}>Price range</Text>
      <ToggleButtonGroup
        aria-label="Price type"
        value={priceType}
        onValueChange={(v) => setPriceType(v)}
        conjoined
        size="sm"
        css={{ mb: '400' }}
      >
        <ToggleButton value="list">List price</ToggleButton>
        <ToggleButton value="monthly">Monthly payment</ToggleButton>
      </ToggleButtonGroup>
      <Flex align="center" gap="200">
        <Box css={{ flex: 1 }}>
          <Text textStyle="body-sm" css={{ fontWeight: 'bold', mb: '200' }}>Minimum</Text>
          <Select size="sm">
            <option>No min</option>
            <option>$100,000</option>
            <option>$200,000</option>
            <option>$300,000</option>
            <option>$400,000</option>
            <option>$500,000</option>
            <option>$600,000</option>
            <option>$700,000</option>
          </Select>
        </Box>
        <Text textStyle="body" css={{ color: 'text.subtle', mt: '400' }}>–</Text>
        <Box css={{ flex: 1 }}>
          <Text textStyle="body-sm" css={{ fontWeight: 'bold', mb: '200' }}>Maximum</Text>
          <Select size="sm">
            <option>No max</option>
            <option>$300,000</option>
            <option>$400,000</option>
            <option>$500,000</option>
            <option>$600,000</option>
            <option>$700,000</option>
            <option>$800,000</option>
            <option>$1,000,000</option>
          </Select>
        </Box>
      </Flex>
      <Button tone="brand" emphasis="filled" size="md" css={{ width: '100%', mt: '400' }}>Apply</Button>
    </FilterDropdown>
  );
}
```

## BedsAndBathsDropdown (420px)

Two ToggleButtonGroups (Bedrooms + Bathrooms) separated by Divider, with exact match checkbox.

```tsx
function BedsAndBathsDropdown() {
  const [beds, setBeds] = useState<string | string[]>('any');
  const [baths, setBaths] = useState<string | string[]>('any');
  const [exactMatch, setExactMatch] = useState(false);
  return (
    <FilterDropdown width="420px">
      <Text textStyle="body-sm" css={{ fontWeight: 'bold', mb: '300' }}>Number of bedrooms</Text>
      <Text textStyle="body-sm" css={{ fontWeight: 'bold', mb: '200' }}>Bedrooms</Text>
      <ToggleButtonGroup aria-label="Bedrooms" value={beds} onValueChange={(v) => setBeds(v)} conjoined size="sm">
        <ToggleButton value="any">Any</ToggleButton>
        <ToggleButton value="1">1+</ToggleButton>
        <ToggleButton value="2">2+</ToggleButton>
        <ToggleButton value="3">3+</ToggleButton>
        <ToggleButton value="4">4+</ToggleButton>
        <ToggleButton value="5">5+</ToggleButton>
      </ToggleButtonGroup>
      <Box css={{ mt: '300' }}>
        <LabeledControl
          control={<Checkbox checked={exactMatch} onChange={() => setExactMatch(!exactMatch)} />}
          label={<Label>Use exact match</Label>}
        />
      </Box>
      <Divider css={{ my: '400' }} />
      <Text textStyle="body-sm" css={{ fontWeight: 'bold', mb: '300' }}>Number of bathrooms</Text>
      <Text textStyle="body-sm" css={{ fontWeight: 'bold', mb: '200' }}>Bathrooms</Text>
      <ToggleButtonGroup aria-label="Bathrooms" value={baths} onValueChange={(v) => setBaths(v)} conjoined size="sm">
        <ToggleButton value="any">Any</ToggleButton>
        <ToggleButton value="1">1+</ToggleButton>
        <ToggleButton value="1.5">1.5+</ToggleButton>
        <ToggleButton value="2">2+</ToggleButton>
        <ToggleButton value="3">3+</ToggleButton>
        <ToggleButton value="4">4+</ToggleButton>
      </ToggleButtonGroup>
      <Button tone="brand" emphasis="filled" size="md" css={{ width: '100%', mt: '400' }}>Apply</Button>
    </FilterDropdown>
  );
}
```

## HomeTypeDropdown (300px)

Checkbox group with select/deselect all toggle using `indeterminate` state.

```tsx
function HomeTypeDropdown() {
  const allTypes = ['Houses', 'Townhomes', 'Multi-family', 'Condos/Co-ops', 'Lots/Land', 'Apartments', 'Manufactured'];
  const [checked, setChecked] = useState<Set<string>>(new Set(allTypes));
  const allSelected = checked.size === allTypes.length;
  const someSelected = checked.size > 0 && !allSelected;
  const toggleAll = () => {
    if (allSelected) { setChecked(new Set()); } else { setChecked(new Set(allTypes)); }
  };
  const toggleOne = (type: string) => {
    setChecked((prev) => {
      const next = new Set(prev);
      if (next.has(type)) { next.delete(type); } else { next.add(type); }
      return next;
    });
  };
  return (
    <FilterDropdown width="300px">
      <Text textStyle="body-sm" css={{ fontWeight: 'bold', mb: '300' }}>Home type</Text>
      <LabeledControl
        control={<Checkbox checked={allSelected} indeterminate={someSelected} onChange={toggleAll} />}
        label={<Label>{allSelected ? 'Deselect all' : 'Select all'}</Label>}
      />
      <Divider css={{ my: '300' }} />
      <Flex direction="column" gap="300">
        {allTypes.map((type) => (
          <LabeledControl
            key={type}
            control={<Checkbox checked={checked.has(type)} onChange={() => toggleOne(type)} />}
            label={<Label>{type}</Label>}
          />
        ))}
      </Flex>
      <Button tone="brand" emphasis="filled" size="md" css={{ width: '100%', mt: '400' }}>Apply</Button>
    </FilterDropdown>
  );
}
```

## MoreFiltersDropdown (520px)

Comprehensive filter panel with scrollable content: HOA, listing type, property status, tours, parking, sqft, lot size, year built, basement, stories, 55+ communities, amenities, view, commute, days on Zillow, keywords.

```tsx
function MoreFiltersDropdown() {
  const listingTypes = ['Owner posted', 'Agent listed', 'New construction', 'Foreclosures', 'Auctions'];
  const [listingChecked, setListingChecked] = useState<Set<string>>(new Set(listingTypes));
  const [statusChecked, setStatusChecked] = useState<Set<string>>(new Set(['Coming soon']));
  const [toursChecked, setToursChecked] = useState<Set<string>>(new Set());
  const [parkingChecked, setParkingChecked] = useState<Set<string>>(new Set());
  const [basementChecked, setBasementChecked] = useState<Set<string>>(new Set());
  const [storiesChecked, setStoriesChecked] = useState<Set<string>>(new Set());
  const [communities55, setCommunities55] = useState('include');
  const [amenitiesChecked, setAmenitiesChecked] = useState<Set<string>>(new Set());
  const [viewChecked, setViewChecked] = useState<Set<string>>(new Set());
  const toggleSet = (set: Set<string>, value: string, setter: (s: Set<string>) => void) => {
    const next = new Set(set);
    if (next.has(value)) { next.delete(value); } else { next.add(value); }
    setter(next);
  };
  return (
    <FilterDropdown width="520px">
      <Text textStyle="body-sm" css={{ fontWeight: 'bold', mb: '400' }}>More filters</Text>
      <Box css={{ maxHeight: '500px', overflowY: 'auto', pr: '100' }}>
        {/* Max HOA */}
        <Text textStyle="body-sm" css={{ fontWeight: 'bold', mb: '200' }}>Max HOA</Text>
        <Select size="sm">
          <option>Any</option>
          <option>$100/month</option>
          <option>$200/month</option>
          <option>$300/month</option>
          <option>$500/month</option>
          <option>None</option>
        </Select>
        <Divider css={{ my: '400' }} />

        {/* Listing type — checkbox group */}
        <Text textStyle="body-sm" css={{ fontWeight: 'bold', mb: '300' }}>Listing type</Text>
        <Flex direction="column" gap="200">
          {listingTypes.map((type) => (
            <LabeledControl key={type}
              control={<Checkbox checked={listingChecked.has(type)} onChange={() => toggleSet(listingChecked, type, setListingChecked)} />}
              label={<Label>{type}</Label>}
            />
          ))}
        </Flex>
        <Divider css={{ my: '400' }} />

        {/* Property status — checkbox group */}
        <Text textStyle="body-sm" css={{ fontWeight: 'bold', mb: '300' }}>Property status</Text>
        <Flex direction="column" gap="200">
          {['Coming soon', 'Accepting backup offers', 'Pending & under contract'].map((status) => (
            <LabeledControl key={status}
              control={<Checkbox checked={statusChecked.has(status)} onChange={() => toggleSet(statusChecked, status, setStatusChecked)} />}
              label={<Label>{status}</Label>}
            />
          ))}
        </Flex>
        <Divider css={{ my: '400' }} />

        {/* Tours — checkbox group */}
        <Text textStyle="body-sm" css={{ fontWeight: 'bold', mb: '300' }}>Tours</Text>
        <Flex direction="column" gap="200">
          {['Must have open house', 'Must have 3D Tour', 'Must have Showcase'].map((tour) => (
            <LabeledControl key={tour}
              control={<Checkbox checked={toursChecked.has(tour)} onChange={() => toggleSet(toursChecked, tour, setToursChecked)} />}
              label={<Label>{tour}</Label>}
            />
          ))}
        </Flex>
        <Divider css={{ my: '400' }} />

        {/* Parking, Sqft, Lot size, Year built — Select + Input pairs */}
        {/* Basement, Stories — single checkboxes */}
        {/* 55+ Communities — radio group (Include / Don't show / Only show) */}
        {/* Amenities — checkbox group (A/C, pool, waterfront) */}
        {/* View — checkbox group (City, Mountain, Park, Water) */}
        {/* Commute — Input + expandable filters */}
        {/* Days on Zillow — Select */}
        {/* Keywords — Input */}
      </Box>
      <Flex align="center" justify="space-between" css={{ mt: '400' }} gap="300">
        <TextButton tone="brand">Reset all filters</TextButton>
        <Button tone="brand" emphasis="filled" size="md">Apply</Button>
      </Flex>
    </FilterDropdown>
  );
}
```

See `FilterBar.tsx` in the project for the complete MoreFiltersDropdown with all sections fully implemented.

## Required Imports for FilterBar

```tsx
import { useState, useEffect, useRef, useCallback, type ReactNode } from 'react';
import {
  Button, Icon, Text, TextButton, Input, Divider,
  Radio, Checkbox, Label, LabeledControl, Select,
  ToggleButtonGroup, ToggleButton,
} from '@zillow/constellation';
import {
  IconChevronDownFilled, IconChevronUpFilled, IconSearchFilled,
} from '@zillow/constellation-icons';
import { Flex, Box } from '@/styled-system/jsx';
```

---

## BuyDropdownPanel (`components/BuyDropdownPanel.tsx`)

Hover-triggered mega menu below the "Buy" nav link.

```tsx
import { useState, useEffect, useRef, useCallback } from 'react';
import { Text, TextButton, Divider } from '@zillow/constellation';
import { Flex, Box, Grid } from '@/styled-system/jsx';

const buyMenuData = {
  localLinks: {
    title: 'Charlotte homes for sale',
    items: [
      ['Homes for sale', 'New construction'],
      ['Foreclosures', 'Coming soon'],
      ['For sale by owner', 'Recent home sales'],
      ['Open houses', 'All homes'],
    ],
  },
  resources: {
    title: 'Resources',
    items: [
      'Home Buying Guide', 'Foreclosure center', 'Real estate app',
      'Down payment assistance', "Find a buyer's agent",
    ],
  },
};

export function BuyDropdownPanel() {
  return (
    <Flex gap="800" css={{ px: '600', py: '400' }}>
      <Box>
        <Text textStyle="body-sm" css={{ fontWeight: 'bold', mb: '200' }}>
          {buyMenuData.localLinks.title}
        </Text>
        <Grid columns={2} gap="100" css={{ columnGap: '600' }}>
          {buyMenuData.localLinks.items.flat().map((item) => (
            <TextButton key={item} tone="brand" css={{ justifyContent: 'flex-start' }}>
              {item}
            </TextButton>
          ))}
        </Grid>
      </Box>
      <Box>
        <Text textStyle="body-sm" css={{ fontWeight: 'bold', mb: '200' }}>
          {buyMenuData.resources.title}
        </Text>
        <Flex direction="column" gap="100">
          {buyMenuData.resources.items.map((item) => (
            <TextButton key={item} tone="brand" css={{ justifyContent: 'flex-start' }}>
              {item}
            </TextButton>
          ))}
        </Flex>
      </Box>
    </Flex>
  );
}

export function useBuyMenuHover() {
  const [isOpen, setIsOpen] = useState(false);
  const closeTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  const handleEnter = useCallback(() => {
    if (closeTimer.current) {
      clearTimeout(closeTimer.current);
      closeTimer.current = null;
    }
    setIsOpen(true);
  }, []);

  const handleLeave = useCallback(() => {
    closeTimer.current = setTimeout(() => {
      setIsOpen(false);
    }, 300);
  }, []);

  useEffect(() => {
    return () => {
      if (closeTimer.current) clearTimeout(closeTimer.current);
    };
  }, []);

  return { isOpen, handleEnter, handleLeave };
}
```

### Buy Menu Design Notes

- **Hover interaction**: 300ms close delay via `useBuyMenuHover` hook prevents flicker
- **Both trigger and panel** get `onMouseEnter/onMouseLeave` handlers
- **Links**: `TextButton tone="brand"` with `justifyContent: flex-start`
- **Layout**: Two-column Grid for local links, single-column Flex for resources
- **Section labels**: `Text textStyle="body-sm"` with bold weight
