# Migrating Property Listings: Custom Cards → Constellation PropertyCard

## Constellation component

```tsx
import { PropertyCard } from '@zillow/constellation';
```

PropertyCard is Zillow-specific — there is no equivalent in shadcn, MUI, Chakra, or Tailwind. Any custom property listing card must be replaced with `PropertyCard`.

---

## Before (shadcn/ui — custom listing card)

```tsx
import { Card, CardContent, CardHeader } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Heart, Bed, Bath, Maximize } from 'lucide-react';

<Card className="overflow-hidden cursor-pointer hover:shadow-lg transition-shadow">
  <div className="relative">
    <img src={photo} alt={address} className="w-full h-48 object-cover" />
    <Badge className="absolute top-2 left-2 bg-orange-500">New</Badge>
    <Button
      variant="ghost"
      size="icon"
      className="absolute top-2 right-2"
      onClick={handleSave}
    >
      <Heart className="h-5 w-5" fill={isSaved ? 'red' : 'none'} />
    </Button>
  </div>
  <CardContent className="p-4">
    <p className="text-xl font-bold">$285,000</p>
    <div className="flex gap-4 text-sm text-gray-600">
      <span><Bed className="inline h-4 w-4" /> 3 bd</span>
      <span><Bath className="inline h-4 w-4" /> 2 ba</span>
      <span><Maximize className="inline h-4 w-4" /> 1,450 sqft</span>
    </div>
    <p className="text-sm text-gray-500 mt-1">742 Oakridge Dr</p>
    <p className="text-sm text-gray-500">Raleigh, NC 27601</p>
  </CardContent>
</Card>
```

## Before (MUI — custom listing card)

```tsx
import Card from '@mui/material/Card';
import CardMedia from '@mui/material/CardMedia';
import CardContent from '@mui/material/CardContent';
import Typography from '@mui/material/Typography';
import Chip from '@mui/material/Chip';
import IconButton from '@mui/material/IconButton';
import FavoriteIcon from '@mui/icons-material/Favorite';
import FavoriteBorderIcon from '@mui/icons-material/FavoriteBorder';

<Card sx={{ cursor: 'pointer', '&:hover': { boxShadow: 6 } }} onClick={handleClick}>
  <Box sx={{ position: 'relative' }}>
    <CardMedia component="img" height={200} image={photo} alt={address} />
    <Chip label="New" color="warning" size="small" sx={{ position: 'absolute', top: 8, left: 8 }} />
    <IconButton
      sx={{ position: 'absolute', top: 8, right: 8 }}
      onClick={handleSave}
    >
      {isSaved ? <FavoriteIcon color="error" /> : <FavoriteBorderIcon />}
    </IconButton>
  </Box>
  <CardContent>
    <Typography variant="h6" fontWeight="bold">$285,000</Typography>
    <Typography variant="body2" color="text.secondary">
      3 bd | 2 ba | 1,450 sqft
    </Typography>
    <Typography variant="body2" color="text.secondary">742 Oakridge Dr</Typography>
    <Typography variant="body2" color="text.secondary">Raleigh, NC 27601</Typography>
  </CardContent>
</Card>
```

## Before (Tailwind + HTML — custom listing card)

```tsx
<div
  className="rounded-xl overflow-hidden shadow-md hover:shadow-xl transition-shadow cursor-pointer bg-white"
  onClick={handleClick}
>
  <div className="relative">
    <img src={photo} alt={address} className="w-full h-48 object-cover" />
    <span className="absolute top-2 left-2 bg-orange-500 text-white text-xs px-2 py-1 rounded">
      New
    </span>
    <button
      className="absolute top-2 right-2 p-1 bg-white/80 rounded-full"
      onClick={handleSave}
    >
      <svg className="h-5 w-5 text-red-500">...</svg>
    </button>
  </div>
  <div className="p-4">
    <p className="text-xl font-bold">$285,000</p>
    <p className="text-sm text-gray-600">3 bd | 2 ba | 1,450 sqft</p>
    <p className="text-sm text-gray-500">742 Oakridge Dr</p>
    <p className="text-sm text-gray-500">Raleigh, NC 27601</p>
  </div>
</div>
```

---

## After (Constellation)

### Standard for-sale listing

```tsx
import { PropertyCard } from '@zillow/constellation';

<PropertyCard
  photoBody={<PropertyCard.Photo src={photo} alt="Home at 742 Oakridge Dr" />}
  badge={<PropertyCard.Badge tone="notify">New listing</PropertyCard.Badge>}
  saveButton={<PropertyCard.SaveButton onClick={handleSave} isSaved={isSaved} />}
  data={{
    dataArea1: '$285,000',
    dataArea2: <PropertyCard.HomeDetails data={[
      { value: '3', label: 'bd' },
      { value: '2', label: 'ba' },
      { value: '1,450', label: 'sqft' }
    ]} />,
    dataArea3: '742 Oakridge Dr, Raleigh, NC, 27601'
  }}
  elevated
  interactive
  onClick={handleClick}
/>
```

### Rental listing

```tsx
<PropertyCard
  photoBody={<PropertyCard.Photo src={photo} alt="Apartment at 1200 Maple Ave" />}
  badge={<PropertyCard.Badge tone="accent">Available now</PropertyCard.Badge>}
  saveButton={<PropertyCard.SaveButton onClick={handleSave} isSaved={isSaved} />}
  data={{
    dataArea1: '$1,350/mo',
    dataArea2: <PropertyCard.HomeDetails data={[
      { value: '2', label: 'bd' },
      { value: '1', label: 'ba' },
      { value: '850', label: 'sqft' }
    ]} />,
    dataArea3: '1200 Maple Ave, Apt 4B, Columbus, OH, 43215'
  }}
  elevated
  interactive
  onClick={handleClick}
/>
```

### Large appearance with agent info

```tsx
<PropertyCard
  appearance="large"
  photoBody={<PropertyCard.Photo src={photo} alt="Home at 305 Elm St" />}
  badge={<PropertyCard.Badge tone="accent">Open house</PropertyCard.Badge>}
  saveButton={<PropertyCard.SaveButton onClick={handleSave} isSaved={isSaved} />}
  data={{
    dataArea1: '$310,000',
    dataArea2: <PropertyCard.HomeDetails data={[
      { value: '4', label: 'bd' },
      { value: '2.5', label: 'ba' },
      { value: '1,820', label: 'sqft' }
    ]} />,
    dataArea3: '305 Elm St, Durham, NC, 27701',
    dataArea4: 'Listing by Jane Smith',
    dataArea5: 'ABC Realty'
  }}
  elevated
  interactive
  onClick={handleClick}
/>
```

---

## PropertyCard anatomy

| Area | Prop | Content |
|------|------|---------|
| **Photo** | `photoBody` | `<PropertyCard.Photo src={url} alt="..." />` |
| **Badge** | `badge` | `<PropertyCard.Badge tone="notify">New listing</PropertyCard.Badge>` |
| **Save button** | `saveButton` | `<PropertyCard.SaveButton />` — **ALWAYS REQUIRED** |
| **Price** | `data.dataArea1` | Price string: `'$285,000'` or `'$1,350/mo'` |
| **Home details** | `data.dataArea2` | `<PropertyCard.HomeDetails data={[...]} />` |
| **Address** | `data.dataArea3` | Full address on ONE line: `'742 Oakridge Dr, Raleigh, NC, 27601'` |
| **Agent** | `data.dataArea4` | Listing agent info (optional) |
| **Broker** | `data.dataArea5` | Broker info (optional) |

### Badge tones

| Badge | Tone | When |
|-------|------|------|
| New listing | `notify` | Listed within 7 days |
| Price cut | `notify` | Price reduced |
| Open house | `accent` | Open house scheduled |
| Available now | `accent` | Rental, immediately available |
| Coming soon | `neutral` | Not yet on market |
| Hot home | `notify` | High interest |

---

## Required rules

- **ALWAYS** include `saveButton={<PropertyCard.SaveButton />}` — this is mandatory on every PropertyCard
- **ALWAYS** put the full address on ONE line in `dataArea3`: `'742 Oakridge Dr, Raleigh, NC, 27601'`
- **ALWAYS** use `PropertyCard.HomeDetails` for bed/bath/sqft in `dataArea2`
- **ALWAYS** add `elevated` and `interactive` for clickable cards
- **NEVER** use `Card` component for property listings — ALWAYS use `PropertyCard`
- **NEVER** build custom save buttons — ALWAYS use `PropertyCard.SaveButton`
- **NEVER** split the address across multiple data areas — keep it all in `dataArea3`
- For Professional apps, ALWAYS include `elevated={true}`

---

## Anti-patterns

```tsx
// WRONG — using Card instead of PropertyCard for listings
<Card elevated interactive tone="neutral">
  <img src={photo} />
  <Text textStyle="body-bold">$285,000</Text>
  <Text>3 bd | 2 ba</Text>
  <Text>742 Oakridge Dr</Text>
</Card>

// CORRECT — PropertyCard with all required props
<PropertyCard
  photoBody={<PropertyCard.Photo src={photo} alt="Home at 742 Oakridge Dr" />}
  saveButton={<PropertyCard.SaveButton />}
  data={{
    dataArea1: '$285,000',
    dataArea2: <PropertyCard.HomeDetails data={[
      { value: '3', label: 'bd' },
      { value: '2', label: 'ba' },
      { value: '1,450', label: 'sqft' }
    ]} />,
    dataArea3: '742 Oakridge Dr, Raleigh, NC, 27601'
  }}
  elevated
  interactive
/>
```

```tsx
// WRONG — missing saveButton
<PropertyCard
  photoBody={<PropertyCard.Photo src={photo} alt="Home" />}
  data={{ dataArea1: '$285,000' }}
/>

// CORRECT — saveButton is ALWAYS required
<PropertyCard
  photoBody={<PropertyCard.Photo src={photo} alt="Home" />}
  saveButton={<PropertyCard.SaveButton />}
  data={{ dataArea1: '$285,000' }}
/>
```

```tsx
// WRONG — address split across multiple areas
data={{
  dataArea3: '742 Oakridge Dr',
  dataArea4: 'Raleigh, NC 27601'
}}

// CORRECT — full address on one line in dataArea3
data={{
  dataArea3: '742 Oakridge Dr, Raleigh, NC, 27601'
}}
```

```tsx
// WRONG — custom save button
<PropertyCard
  saveButton={
    <button onClick={handleSave}>
      <HeartIcon fill={isSaved ? 'red' : 'none'} />
    </button>
  }
/>

// CORRECT — use PropertyCard.SaveButton
<PropertyCard
  saveButton={<PropertyCard.SaveButton onClick={handleSave} isSaved={isSaved} />}
/>
```

```tsx
// WRONG — manually formatting home details as text
data={{
  dataArea2: '3 bd | 2 ba | 1,450 sqft'
}}

// CORRECT — use PropertyCard.HomeDetails component
data={{
  dataArea2: <PropertyCard.HomeDetails data={[
    { value: '3', label: 'bd' },
    { value: '2', label: 'ba' },
    { value: '1,450', label: 'sqft' }
  ]} />
}}
```

---

## Variants

### Appearances

```tsx
{/* Standard card */}
<PropertyCard appearance="default" ... />

{/* Large card (shows flex area for extra content) */}
<PropertyCard appearance="large" ... />
```

### With MLS logo

```tsx
<PropertyCard
  photoBody={<PropertyCard.Photo src={photo} alt="Home" />}
  saveButton={<PropertyCard.SaveButton />}
  mlsLogo={<img src={mlsLogoUrl} alt="MLS" height={16} />}
  data={{...}}
  elevated
  interactive
/>
```

### Without badge

```tsx
<PropertyCard
  photoBody={<PropertyCard.Photo src={photo} alt="Home" />}
  saveButton={<PropertyCard.SaveButton />}
  data={{
    dataArea1: '$245,000',
    dataArea2: <PropertyCard.HomeDetails data={[
      { value: '3', label: 'bd' },
      { value: '2', label: 'ba' },
      { value: '1,280', label: 'sqft' }
    ]} />,
    dataArea3: '1518 Cedar Ln, Raleigh, NC, 27604'
  }}
  elevated
  interactive
/>
```

---

## Edge cases

### Multiple cards in a grid

```tsx
import { Grid } from '@/styled-system/jsx';

<Grid columns={{ base: 1, sm: 2, lg: 3 }} gap="400">
  {properties.map((p, i) => (
    <PropertyCard
      key={i}
      photoBody={<PropertyCard.Photo src={p.image} alt={`Home at ${p.address}`} />}
      badge={p.badge ? <PropertyCard.Badge tone="notify">{p.badge}</PropertyCard.Badge> : undefined}
      saveButton={<PropertyCard.SaveButton />}
      data={{
        dataArea1: p.price,
        dataArea2: <PropertyCard.HomeDetails data={[
          { value: String(p.beds), label: 'bd' },
          { value: String(p.baths), label: 'ba' },
          { value: p.sqft, label: 'sqft' }
        ]} />,
        dataArea3: p.address
      }}
      elevated
      interactive
      onClick={() => handleClick(p.id)}
      tabIndex={0}
    />
  ))}
</Grid>
```

### Non-interactive PropertyCard (display only)

```tsx
<PropertyCard
  photoBody={<PropertyCard.Photo src={photo} alt="Home" />}
  saveButton={<PropertyCard.SaveButton />}
  data={{
    dataArea1: '$285,000',
    dataArea2: <PropertyCard.HomeDetails data={[
      { value: '3', label: 'bd' },
      { value: '2', label: 'ba' },
      { value: '1,450', label: 'sqft' }
    ]} />,
    dataArea3: '742 Oakridge Dr, Raleigh, NC, 27601'
  }}
  elevated={false}
/>
```

### Rental with unit number in address

```tsx
<PropertyCard
  saveButton={<PropertyCard.SaveButton />}
  photoBody={<PropertyCard.Photo src={photo} alt="Apartment" />}
  data={{
    dataArea1: '$1,800/mo',
    dataArea2: <PropertyCard.HomeDetails data={[
      { value: '1', label: 'bd' },
      { value: '1', label: 'ba' },
      { value: '680', label: 'sqft' }
    ]} />,
    dataArea3: '2200 Magnolia Ave, Unit 12, Cary, NC, 27513'
  }}
  elevated
  interactive
/>
```
