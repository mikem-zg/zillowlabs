# Property Photo Generation Prompts

**Every PropertyCard requires an auto-generated photorealistic home exterior photo.** Use these prompts with the image generation tool before rendering any PropertyCard.

## Auto-Generation Rules (MANDATORY)

1. **Generate before render** — always call the image generation tool BEFORE writing the PropertyCard component code
2. **One image per card** — every PropertyCard gets its own unique generated image
3. **Photorealistic only** — photos must look like real estate listing photography, not illustrations or renders
4. **Batch when possible** — when creating multiple PropertyCards, generate all images in one tool call (up to 10)
5. **Match region** — use the region-specific prompt that matches the card's city/state

## Image Generation Settings

| Setting | Value | Notes |
|---------|-------|-------|
| **Aspect ratio** | `4:3` (standard), `16:9` (large/horizontal) | Match the card layout |
| **Output path** | `client/src/assets/images/property-{n}.png` | Import into component |
| **Negative prompt** | See below | Always include |
| **one_line_summary** | `"{City} {style} home"` | e.g., "Raleigh colonial home" |

**Always use this negative prompt:**
```
text, watermark, logo, people, cars with license plates, interior shots, aerial view, blurry, low quality, cartoon, illustration, 3D render, CGI, digital art, painting, sketch
```

## Prompt Template

```
Photorealistic real estate exterior photograph of a [PROPERTY_TYPE] in [CITY, STATE]. 
[ARCHITECTURAL_STYLE] architecture, [MATERIALS]. 
[LANDSCAPING_DETAILS]. 
Front view from the street, natural [LIGHTING] lighting, clear sky. 
Professional real estate photography, sharp focus, high detail, DSLR quality, f/8 aperture.
```

---

## Batch Generation Pattern

When building a page with multiple cards, generate all images at once:

```
generate_image_tool({
  images: [
    {
      prompt: "[Raleigh colonial prompt]",
      negative_prompt: "text, watermark, logo, people, cars with license plates, interior shots, aerial view, blurry, low quality, cartoon, illustration, 3D render, CGI, digital art, painting, sketch",
      output_path: "client/src/assets/images/property-1.png",
      aspect_ratio: "4:3",
      one_line_summary: "Raleigh colonial home"
    },
    {
      prompt: "[Durham craftsman prompt]",
      negative_prompt: "text, watermark, logo, people, cars with license plates, interior shots, aerial view, blurry, low quality, cartoon, illustration, 3D render, CGI, digital art, painting, sketch",
      output_path: "client/src/assets/images/property-2.png",
      aspect_ratio: "4:3",
      one_line_summary: "Durham craftsman home"
    },
    {
      prompt: "[Cary townhouse prompt]",
      negative_prompt: "text, watermark, logo, people, cars with license plates, interior shots, aerial view, blurry, low quality, cartoon, illustration, 3D render, CGI, digital art, painting, sketch",
      output_path: "client/src/assets/images/property-3.png",
      aspect_ratio: "4:3",
      one_line_summary: "Cary modern townhouse"
    }
  ]
})
```

---

## Regional Prompt Templates

### Raleigh-Durham, NC

**Single-family (colonial):**
```
Photorealistic real estate exterior photograph of a single-family home in Raleigh, North Carolina. Colonial revival architecture with brick veneer facade and black shutters, covered front porch with white columns, two-car garage. Green bermuda grass lawn, mature crepe myrtle trees, azalea bushes along the foundation, concrete driveway. Front view from the street, warm golden hour lighting, partly cloudy sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

**Single-family (craftsman):**
```
Photorealistic real estate exterior photograph of a craftsman bungalow in Durham, North Carolina. Arts and Crafts style with tapered porch columns on stone bases, exposed rafters, low-pitched gabled roof, mixed siding and shingle accents. Established front yard with mature pine trees, fescue lawn, perennial flower beds, brick walkway. Front view from the sidewalk, warm afternoon lighting, clear sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

**Townhouse:**
```
Photorealistic real estate exterior photograph of a modern townhouse in Cary, North Carolina. Transitional style with fiber cement siding in gray-blue, stone accent base, attached single-car garage, small covered entry. Small front yard with ornamental grasses, young dogwood tree, mulched beds. Front view from the sidewalk, bright midday lighting, clear blue sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

**Condo / apartment:**
```
Photorealistic real estate exterior photograph of a mid-rise apartment building in Durham, North Carolina. Contemporary design with mixed materials — red brick lower level, fiber cement panels in warm gray upper floors, large windows with dark frames. Landscaped entrance with crepe myrtles, boxwood hedges, modern concrete walkway, glass lobby entrance. Front view from the street, natural daylight, clear sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

---

### Columbus, OH

**Single-family (Cape Cod):**
```
Photorealistic real estate exterior photograph of a single-family home in Columbus, Ohio. Cape Cod style with white vinyl siding, dark gray roof, red brick chimney, front gable dormers, covered front entry with black lantern lights. Green bluegrass lawn, mature maple tree providing shade, hosta plantings along the walkway, attached two-car garage. Front view from the street, bright midday lighting, clear sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

**Single-family (colonial):**
```
Photorealistic real estate exterior photograph of a two-story colonial home in Upper Arlington, Ohio. Traditional red brick facade, white trim, symmetrical windows with black shutters, columned front entrance, attached side-entry garage. Established landscaping with buckeye tree, boxwood hedges, manicured bluegrass lawn, concrete driveway. Front view from the street, warm afternoon lighting, partly cloudy sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

**Townhouse:**
```
Photorealistic real estate exterior photograph of a brick townhouse in the Short North area of Columbus, Ohio. Traditional design with red brick facade, black iron railings, small covered entryway, second-floor bay window. Compact front landscaping with low boxwood hedge, potted plants by the door, brick sidewalk. Front view from the sidewalk, warm afternoon lighting, partly cloudy sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

---

### San Antonio, TX

**Single-family (hill country):**
```
Photorealistic real estate exterior photograph of a single-family home in San Antonio, Texas. Texas hill country style with limestone and stucco exterior, clay tile roof, arched entryway, two-car garage with decorative iron hardware. Xeriscaped front yard with native grasses, a mature live oak tree, gravel border, St. Augustine grass patches, stone-lined flower beds. Front view from the street, warm golden hour lighting, clear blue Texas sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

**Single-family (ranch):**
```
Photorealistic real estate exterior photograph of a ranch-style home in San Antonio, Texas. Single-story stucco home painted in warm beige, brown composition roof, covered front porch with wrought iron supports, attached two-car garage. Flat front yard with St. Augustine grass, two palm trees, desert sage plantings, concrete driveway with decorative edging. Front view from the street, bright midday lighting, expansive sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

**Condo / apartment:**
```
Photorealistic real estate exterior photograph of a garden-style apartment complex in San Antonio, Texas. Three-story stucco building in warm terracotta and cream tones, barrel tile accent roof, covered breezeway entries, parking lot visible. Landscaping with live oak trees, agave plants, crepe myrtles, well-maintained walkways. Front view from the parking area, natural daylight, clear sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

---

### Indianapolis, IN

**Single-family (colonial):**
```
Photorealistic real estate exterior photograph of a single-family home in Indianapolis, Indiana. Midwest colonial style with red brick facade, white trim, black shutters, covered front porch with square columns, attached two-car garage. Green bluegrass lawn, mature oak tree in the front yard, black-eyed Susans along the walkway, mulched foundation beds. Front view from the street, warm afternoon lighting, partly cloudy sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

**Single-family (craftsman):**
```
Photorealistic real estate exterior photograph of a craftsman bungalow in the Broad Ripple neighborhood of Indianapolis, Indiana. Arts and Crafts style with tapered columns on stone bases, exposed rafters, mixed siding and stone foundation, wide front porch. Established landscaping with dogwood tree, perennial flower beds, concrete walkway, mature shade trees. Front view from the sidewalk, golden hour lighting, autumn foliage. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

---

### Nashville, TN

**Single-family (Southern colonial):**
```
Photorealistic real estate exterior photograph of a single-family home in Nashville, Tennessee. Southern colonial style with white painted brick, black shutters, grand front porch with tall white columns, symmetrical facade, side-entry garage. Lush green fescue lawn, mature magnolia tree, boxwood hedges, brick walkway, wrought iron mailbox. Front view from the street, warm golden hour lighting, blue sky with wispy clouds. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

**Modern farmhouse (new construction):**
```
Photorealistic real estate exterior photograph of a new construction modern farmhouse in Nashville, Tennessee. Board-and-batten siding in white, black metal roof accents, large front windows, covered porch with black metal posts, two-car garage. New landscaping with ornamental grasses, young red maple, mulched beds, stone walkway, modern black exterior lights. Front view from the street, bright midday lighting, clear sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

**Tall-and-skinny (urban infill):**
```
Photorealistic real estate exterior photograph of a tall-and-skinny urban infill home in East Nashville, Tennessee. Three-story contemporary design with fiber cement siding in charcoal gray, large windows, rooftop deck visible, narrow lot with small front yard. Minimal modern landscaping with ornamental grasses, concrete walkway, street trees. Front view from the sidewalk, warm afternoon lighting, urban neighborhood context. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

---

### Charlotte, NC

**Single-family (traditional):**
```
Photorealistic real estate exterior photograph of a single-family home in Charlotte, North Carolina. Traditional Southern style with brick and vinyl siding, covered front porch with turned columns, two-car garage, gabled roof with dormers. Green centipede grass lawn, crepe myrtle trees, camellia bushes, mulched flower beds, concrete driveway. Front view from the street, warm afternoon lighting, partly cloudy sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

**Townhouse:**
```
Photorealistic real estate exterior photograph of a modern townhouse in the South End neighborhood of Charlotte, North Carolina. Contemporary design with brick and fiber cement siding in warm gray, black window frames, attached single-car garage, rooftop terrace visible. Small front yard with ornamental grasses, young dogwood tree, paver walkway. Front view from the sidewalk, bright midday lighting, clear sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

---

### Tampa, FL

**Single-family (Florida ranch):**
```
Photorealistic real estate exterior photograph of a single-family home in Tampa, Florida. Florida ranch style with peach stucco exterior, barrel tile roof in terracotta, screened front entry, attached two-car garage, impact-resistant windows. Tropical landscaping with palm trees, hibiscus bushes, St. Augustine grass, crushed shell walkway, tropical flower beds. Front view from the street, bright Florida sunshine, vivid blue sky with white cumulus clouds. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

**Single-family (Mediterranean):**
```
Photorealistic real estate exterior photograph of a Mediterranean-style home in South Tampa, Florida. Two-story stucco home in cream with terracotta barrel tile roof, arched windows and entry, decorative iron balcony, paver driveway. Lush tropical landscaping with queen palm trees, bird of paradise, bougainvillea, manicured lawn, decorative fountain visible. Front view from the street, golden hour lighting, clear tropical sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

**Condo building:**
```
Photorealistic real estate exterior photograph of a mid-rise condominium building in Tampa, Florida. Coastal contemporary design with white and sand-colored stucco, blue glass balcony railings, flat roof with parapet, ground-floor lobby with glass entrance. Tropical landscaping with queen palm trees, bird of paradise, manicured lawn, covered car port visible. Front view from the street, bright midday lighting, tropical blue sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

---

### Kansas City, MO

**Single-family (bungalow):**
```
Photorealistic real estate exterior photograph of a single-family home in Kansas City, Missouri. Midwest bungalow style with brick facade, wide front porch with tapered columns, exposed stone foundation, low-pitched roof with wide eaves. Green fescue lawn, elm trees, ornamental grasses, brick-lined flower beds, concrete driveway. Front view from the street, warm golden hour lighting, open Midwest sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

**Single-family (foursquare):**
```
Photorealistic real estate exterior photograph of an American foursquare home in the Brookside neighborhood of Kansas City, Missouri. Two-story frame with vinyl siding in sage green, wide covered front porch, dormer window, symmetrical facade, detached garage. Established landscaping with elm trees, coneflowers, ornamental grasses, brick walkway. Front view from the street, warm afternoon lighting, partly cloudy sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

---

### Minneapolis, MN

**Single-family (Tudor):**
```
Photorealistic real estate exterior photograph of a single-family home in Minneapolis, Minnesota. Tudor revival style with stucco and dark timber half-timbering, steep gabled roof, arched front entry, brick chimney, attached single-car garage. Green cool-season lawn, birch trees, hostas and daylilies, stone walkway, established perennial gardens. Front view from the street, crisp midday lighting, clear sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

**Single-family (craftsman):**
```
Photorealistic real estate exterior photograph of a craftsman home in the Linden Hills neighborhood of Minneapolis, Minnesota. Updated craftsman with stucco exterior, tapered columns on stone bases, wide covered front porch, low-pitched roof with exposed rafters. Front yard with birch trees, spruce trees, daylilies, cool-season bluegrass lawn, concrete walkway. Front view from the street, warm afternoon lighting, clear blue sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

---

### Phoenix, AZ

**Single-family (Southwestern):**
```
Photorealistic real estate exterior photograph of a single-family home in Phoenix, Arizona. Southwestern style with tan stucco exterior, flat roof with parapet, desert-toned accents, covered front entry with timber beams, two-car garage. Xeriscaped front yard with decomposed granite, saguaro cactus, palo verde tree, desert marigold, flagstone walkway, decorative boulders. Front view from the street, bright desert sunshine, clear blue sky, distant mountain silhouette. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

**Single-family (contemporary):**
```
Photorealistic real estate exterior photograph of a contemporary home in Scottsdale, Arizona. Desert modern architecture with clean lines, floor-to-ceiling windows, mixed stucco and stone veneer, flat roof with deep overhangs, three-car garage. Minimalist xeriscaped front with decomposed granite, accent boulders, agave plants, palo verde trees, LED landscape lighting, paver driveway. Front view from the street, golden hour desert lighting, warm sky gradient. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

**Single-family (ranch):**
```
Photorealistic real estate exterior photograph of a ranch-style home in Mesa, Arizona. Single-story stucco home in warm desert tan, composition roof, covered front porch with wrought iron posts, two-car garage, block wall courtyard. Front yard with desert landscaping — gravel ground cover, ocotillo, prickly pear cactus, desert willow tree, concrete walkway. Front view from the street, bright midday Arizona sunshine, cloudless blue sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

---

## Rental-Specific Prompts

### Garden-Style Apartment

```
Photorealistic real estate exterior photograph of a garden-style apartment complex in [CITY, STATE]. Two-story residential building with [MATERIAL] exterior, covered breezeway entries, parking lot visible, building number sign. [REGIONAL_LANDSCAPING], well-maintained walkways, exterior staircase. Front view from the parking area, natural daylight, clear sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

### Urban Apartment / Mid-Rise

```
Photorealistic real estate exterior photograph of a modern apartment building in downtown [CITY, STATE]. Contemporary mixed-use design with [MATERIAL] and glass facade, retail at ground level, residential above, modern entrance canopy. Urban streetscape with street trees, bike rack, well-lit glass lobby visible. Front view from across the street, evening golden hour lighting, urban sky. Professional real estate photography, sharp focus, high detail, DSLR quality.
```

### Rental House

Use the same regional single-family prompts above — rental houses look the same as for-sale houses from the exterior.

---

## Prompt Customization Tips

**Adjust for price point:**
- **Budget ($150K-$220K):** Smaller homes, simpler landscaping, older construction. Add "modest, well-maintained, smaller" to prompt.
- **Median ($220K-$380K):** Standard suburban homes, established landscaping. Use prompts as written.
- **Upper ($380K-$550K):** Larger homes, upgraded materials, more polished landscaping. Add "upscale, manicured, premium finishes" to prompt.

**Adjust for season:**
- **Spring:** "Spring blooming azaleas and dogwoods, fresh green lawn"
- **Summer:** "Lush green landscaping, full canopy shade trees, bright sunshine"
- **Fall:** "Autumn foliage in warm oranges and reds, fallen leaves on the lawn"
- **Winter (South):** "Mild winter, evergreen landscaping, clear sky"
- **Winter (North):** "Light snow dusting on the roof and lawn, bare deciduous trees, overcast sky"

**Adjust for time of day:**
- **Golden hour (default):** "warm golden hour lighting" — best for most properties
- **Midday:** "bright midday lighting, clear sky" — good for new construction
- **Twilight:** "dusk twilight with warm interior lights glowing through windows" — premium listings
