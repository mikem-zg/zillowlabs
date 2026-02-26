---
name: property-card-data
description: Generate realistic property data with auto-generated photorealistic images for Constellation PropertyCard components. Creates addresses using real U.S. cities, states, and ZIP codes with fictitious street names, calibrated to median-cost-of-living metros. Automatically generates photorealistic home exterior photos via image generation tool. Supports both rental and for-sale listings. Use when building PropertyCard UI, prototyping listing pages, or populating property search results.
---

# Property Card Data Generator

Generate realistic property data with **auto-generated photorealistic images** for Zillow Constellation `PropertyCard` components. Every card gets a unique, photorealistic home exterior photo generated at build time.

## Core Rules

1. **ALWAYS generate an image first** — before rendering any PropertyCard, call the image generation tool to create a photorealistic home exterior. This is mandatory, not optional.
2. **Use real cities, states, and ZIP codes** — every address must use a real U.S. city, state abbreviation, and valid ZIP code from [references/metro-data.md](references/metro-data.md)
3. **Use fictitious street names** — combine realistic street name patterns with random house numbers. Never use a real full address.
4. **Default to affordable metros** — Raleigh, Columbus, San Antonio, Indianapolis, Nashville, Charlotte, Tampa, Kansas City, Minneapolis, Phoenix
5. **Match price to region** — use metro-specific median prices from [references/metro-data.md](references/metro-data.md)
6. **Always include `saveButton`** — `PropertyCard` requires `saveButton={<PropertyCard.SaveButton />}`
7. **Vary the data** — never repeat the same address, price, or bed/bath combo across cards on a page
8. **Images MUST match the region** — every generated home photo must reflect the architecture, materials, landscaping, and climate of the specific metro area. A Raleigh card must show Raleigh-style homes (colonial brick, crepe myrtles, bermuda grass). A Phoenix card must show desert architecture (stucco, xeriscaping, saguaro). Never use a generic or mismatched regional style.

## Regional Image Accuracy (CRITICAL)

**The generated photo must look like it belongs in the region shown in the address.** This means:

| Region | Architecture | Materials | Landscaping | Climate cues |
|--------|-------------|-----------|-------------|-------------|
| Raleigh-Durham, NC | Colonial, craftsman, transitional | Brick, fiber cement | Crepe myrtles, azaleas, bermuda grass | Humid subtropical, green |
| Columbus, OH | Cape Cod, colonial, bungalow | Brick, vinyl siding | Maple trees, hostas, bluegrass | Midwest four-season |
| San Antonio, TX | Hill country, ranch | Limestone, stucco | Live oaks, xeriscaping, St. Augustine | Hot, dry, expansive sky |
| Indianapolis, IN | Colonial, craftsman | Red brick, vinyl | Oak trees, black-eyed Susans, bluegrass | Midwest four-season |
| Nashville, TN | Southern colonial, modern farmhouse | White brick, board-and-batten | Magnolias, boxwood, fescue | Southern, green |
| Charlotte, NC | Traditional Southern, contemporary | Brick and vinyl | Crepe myrtles, camellias, centipede grass | Humid subtropical |
| Tampa, FL | Florida ranch, Mediterranean | Stucco, barrel tile | Palm trees, hibiscus, St. Augustine | Tropical, vivid sky |
| Kansas City, MO | Bungalow, foursquare | Brick, vinyl | Elm trees, coneflowers, fescue | Midwest plains |
| Minneapolis, MN | Tudor, craftsman | Stucco, timber | Birch trees, hostas, cool-season grass | Northern, cold-weather |
| Phoenix, AZ | Southwestern, desert modern | Stucco, stone | Saguaro, palo verde, decomposed granite | Desert, arid |

**When generating multiple cards for a single page:**
- If the user specifies a region (e.g., "Raleigh area"), ALL cards must use that region's prompts from [references/image-prompts.md](references/image-prompts.md)
- Vary the property type (colonial, craftsman, townhouse, condo) but keep the regional style consistent
- Never mix regions unless explicitly requested (e.g., "show homes from different cities")

## Workflow: Generate a PropertyCard

**Every PropertyCard follows this exact sequence. Do not skip steps.**

### Step 1: Pick a real location

Choose a metro from [references/metro-data.md](references/metro-data.md). Use a specific real neighborhood, city, and ZIP code — not a range.

**Example:** Pick "Raleigh, NC 27601" — not "Raleigh, NC 276xx"

For multiple cards on one page, vary across 2-3 metros max to feel cohesive (like search results for a region).

### Step 2: Generate the address

Combine fictitious street components with the real city/state/ZIP into **one single line**:

| Component | Source | Example |
|-----------|--------|---------|
| House number | Random 3-5 digit number | 742, 1200, 3815 |
| Street name | See street name patterns below | Oakridge, Maple, Westfield |
| Street suffix | Dr, Ave, St, Ln, Blvd, Ct, Way, Pl | Dr |
| Unit (rentals) | Apt, Unit, #, Suite + number/letter | Unit 4B |
| City, State, ZIP | **Real** — from metro data | Raleigh, NC, 27601 |

**Full address format (all on one line in `dataArea3`):**
`742 Oakridge Dr, Raleigh, NC, 27601`

**Street name patterns** (mix and match):

| Category | Examples |
|----------|---------|
| Tree/nature | Oakridge, Maple, Cedar, Birchwood, Willow, Elm, Magnolia, Aspen, Laurel, Pinecrest |
| Directional | Westfield, Northgate, Southbrook, Eastview, Sunrise, Sunset |
| Landmark | Millstone, Stonegate, Bridgewater, Lakeview, Creekside, Meadowbrook, Hillcrest |
| Historic | Jefferson, Madison, Franklin, Liberty, Heritage, Colonial, Providence |
| Numbered | 2nd, 5th, 12th, 14th (common in grid cities like Columbus, Indianapolis, Phoenix) |

### Step 3: Generate price and home details

**For-sale:** Metro median ±20%, round to nearest $5,000. Format: `$285,000`
**Rental:** Metro median rent ±15%, round to nearest $25. Format: `$1,350/mo`

Select bed/bath/sqft from [references/property-types.md](references/property-types.md).

### Step 4: Generate the photo (MANDATORY)

**This step is not optional. Every PropertyCard must have a generated image.**

1. Select the appropriate regional prompt from [references/image-prompts.md](references/image-prompts.md)
2. Call the image generation tool with:
   - **Prompt:** Use the region-specific prompt, filling in property type and architectural style
   - **Aspect ratio:** `4:3` for standard cards, `16:9` for large/horizontal cards
   - **Output path:** `client/src/assets/images/property-{n}.png` (or appropriate project path)
   - **Negative prompt:** Always include: `text, watermark, logo, people, cars with license plates, interior shots, aerial view, blurry, low quality, cartoon, illustration, 3D render`
3. Import the generated image and pass it to `PropertyCard.Photo`

**Image generation call pattern:**
```
generate_image_tool({
  images: [{
    prompt: "Photorealistic real estate exterior photograph of a single-family home in Raleigh, North Carolina. Colonial revival architecture with brick veneer facade and black shutters, covered front porch with white columns. Green bermuda grass lawn, mature crepe myrtle trees, azalea bushes along the foundation, concrete driveway. Front view from the street, warm golden hour lighting, partly cloudy sky. Professional real estate photography, sharp focus, high detail.",
    negative_prompt: "text, watermark, logo, people, cars with license plates, interior shots, aerial view, blurry, low quality, cartoon, illustration, 3D render",
    output_path: "client/src/assets/images/property-1.png",
    aspect_ratio: "4:3",
    one_line_summary: "Raleigh NC colonial home"
  }]
})
```

### Step 5: Choose badge (optional)

| Badge | Tone | When to use |
|-------|------|------------|
| New listing | `notify` | For-sale, listed within 7 days |
| Price cut | `notify` | For-sale, price reduced |
| Open house | `accent` | For-sale, open house scheduled |
| Available now | `accent` | Rental, immediately available |
| Coming soon | `neutral` | Either, not yet on market |
| Hot home | `notify` | For-sale, high interest |

### Step 6: Render the PropertyCard

```tsx
import { PropertyCard } from '@zillow/constellation';
import propertyImage from '@/assets/images/property-1.png';

<PropertyCard
  photoBody={<PropertyCard.Photo src={propertyImage} alt="Home at 742 Oakridge Dr" />}
  badge={<PropertyCard.Badge tone="notify">New listing</PropertyCard.Badge>}
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
  onClick={handleClick}
  tabIndex={0}
/>
```

## Complete Example: Multiple Cards with Auto-Generated Images

When building a page with multiple PropertyCards, generate ALL images first, then render:

```tsx
// Step 1: Generate all images (call image generation tool for each)
// property-1.png → Raleigh colonial, 4:3
// property-2.png → Raleigh townhouse, 4:3
// property-3.png → Durham craftsman, 4:3
// property-4.png → Cary condo building, 4:3

// Step 2: Import and render
import { PropertyCard } from '@zillow/constellation';
import property1 from '@/assets/images/property-1.png';
import property2 from '@/assets/images/property-2.png';
import property3 from '@/assets/images/property-3.png';
import property4 from '@/assets/images/property-4.png';

const properties = [
  {
    image: property1,
    address: '742 Oakridge Dr, Raleigh, NC, 27601',
    price: '$285,000',
    beds: 3, baths: 2, sqft: '1,450',
    type: 'House for sale',
    badge: 'New listing',
    alt: 'Colonial home in Raleigh'
  },
  {
    image: property2,
    address: '1518 Cedar Ln, Raleigh, NC, 27604',
    price: '$245,000',
    beds: 3, baths: 2, sqft: '1,280',
    type: 'Townhouse for sale',
    badge: null,
    alt: 'Townhouse in Raleigh'
  },
  {
    image: property3,
    address: '305 Elm St, Durham, NC, 27701',
    price: '$310,000',
    beds: 4, baths: 2.5, sqft: '1,820',
    type: 'House for sale',
    badge: 'Open house',
    alt: 'Craftsman home in Durham'
  },
  {
    image: property4,
    address: '2200 Magnolia Ave, Unit 12, Cary, NC, 27513',
    price: '$189,000',
    beds: 2, baths: 1, sqft: '920',
    type: 'Condo for sale',
    badge: null,
    alt: 'Condo in Cary'
  },
];

{properties.map((p, i) => (
  <PropertyCard
    key={i}
    photoBody={<PropertyCard.Photo src={p.image} alt={p.alt} />}
    badge={p.badge ? <PropertyCard.Badge tone="notify">{p.badge}</PropertyCard.Badge> : undefined}
    saveButton={<PropertyCard.SaveButton />}
    data={{
      dataArea1: p.price,
      dataArea2: <PropertyCard.HomeDetails data={[
        { value: String(p.beds), label: 'bd' },
        { value: String(p.baths), label: 'ba' },
        { value: p.sqft, label: 'sqft' }
      ]} />,
      dataArea3: p.address,
      dataArea4: p.type
    }}
    elevated
    interactive
    onClick={() => handleClick(i)}
    tabIndex={0}
  />
))}
```

## Rental Card Example

```tsx
import propertyRental from '@/assets/images/property-rental-1.png';

<PropertyCard
  photoBody={<PropertyCard.Photo src={propertyRental} alt="Apartment in Columbus" />}
  badge={<PropertyCard.Badge tone="accent">Available now</PropertyCard.Badge>}
  saveButton={<PropertyCard.SaveButton />}
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
  tabIndex={0}
/>
```

## Constellation PropertyCard Required Props Reminder

| Prop | Required? | Notes |
|------|-----------|-------|
| `saveButton` | **ALWAYS** | `{<PropertyCard.SaveButton />}` |
| `photoBody` | **ALWAYS** | Use `PropertyCard.Photo` with generated image |
| `elevated` | Yes for Professional apps | Adds shadow |
| `interactive` | Yes if clickable | Adds hover/cursor |
| `data` | Recommended | Object with dataArea1-5 |
| `badge` | Optional | Use `PropertyCard.Badge` |
| `tabIndex={0}` | Recommended | Keyboard accessibility |

## Reference Documents

- **Metro data**: [references/metro-data.md](references/metro-data.md) — 10 affordable metros with real cities, ZIP codes, architectural styles, and neighborhood patterns
- **Property types**: [references/property-types.md](references/property-types.md) — Detailed specs for every property type, listing statuses, and data formatting rules
- **Image prompts**: [references/image-prompts.md](references/image-prompts.md) — Ready-to-use photorealistic prompts for generating home photos by region and property type
