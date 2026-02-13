# Property Types and Listing Data

Detailed specifications for generating realistic property data across all listing types.

## For-Sale Property Types

### Single-Family Home

| Attribute | Range | Typical |
|-----------|-------|---------|
| Beds | 2-5 | 3-4 |
| Baths | 1-4 | 2-2.5 |
| Sqft | 1,000-3,500 | 1,400-2,200 |
| Lot size | 0.1-0.5 acres | 0.15-0.25 acres |
| Year built | 1950-2024 | 1985-2015 |
| Garage | 1-3 car | 2 car |

**dataArea4 label:** `House for sale`
**Typical badges:** New listing, Price cut, Open house, Hot home

### Townhouse

| Attribute | Range | Typical |
|-----------|-------|---------|
| Beds | 2-4 | 2-3 |
| Baths | 1.5-3 | 2-2.5 |
| Sqft | 900-2,200 | 1,100-1,600 |
| Year built | 1975-2024 | 2000-2020 |
| HOA | $150-$400/mo | $200-$300/mo |

**dataArea4 label:** `Townhouse for sale`
**Typical badges:** New listing, Price cut

### Condo / Co-op

| Attribute | Range | Typical |
|-----------|-------|---------|
| Beds | 1-3 | 1-2 |
| Baths | 1-2 | 1-1.5 |
| Sqft | 500-1,500 | 700-1,100 |
| Year built | 1970-2024 | 1995-2020 |
| HOA | $200-$600/mo | $250-$400/mo |

**dataArea4 label:** `Condo for sale`
**Typical badges:** New listing, Coming soon

### Multi-Family (Duplex/Triplex)

| Attribute | Range | Typical |
|-----------|-------|---------|
| Units | 2-4 | 2-3 |
| Total beds | 4-8 | 4-6 |
| Total baths | 2-6 | 3-4 |
| Sqft | 1,800-4,000 | 2,200-3,000 |
| Year built | 1940-2010 | 1970-2000 |

**dataArea4 label:** `Multi-family for sale`
**Typical badges:** New listing, Price cut

---

## Rental Property Types

### Apartment

| Attribute | Range | Typical |
|-----------|-------|---------|
| Beds | Studio-3 | 1-2 |
| Baths | 1-2 | 1 |
| Sqft | 400-1,200 | 650-900 |
| Floor | 1-20 | 2-6 |

**dataArea4 label:** `Apartment for rent`
**Address format:** Include unit number (e.g., "1200 Maple Ave, Apt 4B")
**Typical badges:** Available now, New listing

### House for Rent

| Attribute | Range | Typical |
|-----------|-------|---------|
| Beds | 2-5 | 3-4 |
| Baths | 1-3 | 2 |
| Sqft | 1,000-2,500 | 1,300-1,800 |
| Year built | 1960-2020 | 1990-2015 |

**dataArea4 label:** `House for rent`
**Typical badges:** Available now, New listing

### Townhouse for Rent

| Attribute | Range | Typical |
|-----------|-------|---------|
| Beds | 2-3 | 2-3 |
| Baths | 1.5-2.5 | 2 |
| Sqft | 900-1,800 | 1,100-1,400 |

**dataArea4 label:** `Townhouse for rent`
**Typical badges:** Available now

### Studio

| Attribute | Range | Typical |
|-----------|-------|---------|
| Beds | Studio | Studio |
| Baths | 1 | 1 |
| Sqft | 300-600 | 400-500 |

**dataArea4 label:** `Studio for rent`
**Address format:** Include unit number
**Typical badges:** Available now

---

## Badge Reference

### For-Sale Badges

| Badge Text | Tone | Description |
|-----------|------|-------------|
| New listing | `notify` | Listed within the past 7 days |
| Price cut | `notify` | Price has been reduced |
| Open house | `accent` | Has an upcoming open house event |
| Hot home | `notify` | Getting lots of views and saves |
| Coming soon | `neutral` | Pre-market, not yet active |
| Foreclosure | `neutral` | Bank-owned or pre-foreclosure |
| Pending | `neutral` | Under contract, not yet closed |

### Rental Badges

| Badge Text | Tone | Description |
|-----------|------|-------------|
| Available now | `accent` | Move-in ready immediately |
| New listing | `notify` | Listed within the past 3 days |
| Accepts applications | `accent` | Currently reviewing applications |
| Pet friendly | `accent` | Allows cats and/or dogs |
| Utilities included | `accent` | Rent covers some/all utilities |
| No deposit | `notify` | No security deposit required |

---

## Data Area Mapping

The PropertyCard `data` prop maps content to specific display areas:

| Data Area | For-Sale Content | Rental Content |
|-----------|-----------------|----------------|
| `dataArea1` | Price (e.g., `$285,000`) | Monthly rent (e.g., `$1,350/mo`) |
| `dataArea2` | `PropertyCard.HomeDetails` (bd/ba/sqft) | `PropertyCard.HomeDetails` (bd/ba/sqft) |
| `dataArea3` | Full address on one line: `742 Oakridge Dr, Raleigh, NC, 27601` | Full address with unit: `1200 Maple Ave, Apt 4B, Columbus, OH, 43215` |
| `dataArea4` | Property type (e.g., `House for sale`) | Property type (e.g., `Apartment for rent`) |

### HomeDetails Formatting

**Label conventions:**
| Detail | Label | Value format |
|--------|-------|-------------|
| Bedrooms | `bd` | Whole number: `3` |
| Bathrooms | `ba` | Whole or half: `2`, `2.5` |
| Square footage | `sqft` | Comma-separated: `1,450` |

**Half-bath handling:** When a property has half baths, combine with full baths using comma delimiter:
```tsx
<PropertyCard.HomeDetails data={[
  { value: '3', label: 'bd' },
  { value: '2', label: 'ba' },
  { value: '1', label: 'half ba', delimiter: 'comma' },
  { value: '1,450', label: 'sqft' }
]} />
```

**Studio handling:** For studios, omit the beds entry or use:
```tsx
<PropertyCard.HomeDetails data={[
  { value: 'Studio', label: '' },
  { value: '1', label: 'ba' },
  { value: '450', label: 'sqft' }
]} />
```

---

## Price Formatting Rules

| Type | Format | Example |
|------|--------|---------|
| For-sale | `$XXX,XXX` | `$285,000` |
| For-sale (millions) | `$X,XXX,XXX` | `$1,250,000` |
| Rental monthly | `$X,XXX/mo` | `$1,350/mo` |
| Price cut | Show current + original | `$265,000` with `Price cut` badge |

**Rounding rules:**
- For-sale: Round to nearest $5,000
- Rental: Round to nearest $25

---

## Listing Status Labels

| Status | dataArea5 for sale | dataArea5 for rent |
|--------|-------------------|-------------------|
| Active | `House for sale` | `Apartment for rent` |
| Pending | `Pending` | — |
| Coming soon | `Coming soon` | `Coming soon` |
| Contingent | `Contingent` | — |

---

## Variety Checklist

When generating multiple cards, ensure:

- [ ] At least 2 different property types
- [ ] Price range spans at least 30% (e.g., $220K - $310K)
- [ ] Mix of bed counts (don't make all 3bd/2ba)
- [ ] At most 2-3 cards with badges (not every card)
- [ ] Different street names (no duplicates)
- [ ] Different sqft values (vary by at least 100 sqft between cards)
- [ ] If showing 4+ cards, include at least one without a badge
