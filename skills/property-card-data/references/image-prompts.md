# Property Photo Generation Prompts

**Every PropertyCard requires an auto-generated photorealistic home exterior photo.** Use these prompts with the image generation tool before rendering any PropertyCard.

## Auto-Generation Rules (MANDATORY)

1. **Generate before render** — always call the image generation tool BEFORE writing the PropertyCard component code
2. **One image per card** — every PropertyCard gets its own unique generated image
3. **Hyper-realistic only** — photos must be indistinguishable from real MLS listing photography
4. **Batch when possible** — when creating multiple PropertyCards, generate all images in one tool call (up to 10)
5. **Match region** — use the region-specific prompt that matches the card's city/state
6. **Include imperfections** — real homes have subtle wear, natural asymmetry, and lived-in details

## Hyper-Realism Techniques (CRITICAL)

These techniques are what separate "obviously AI" images from photos that look genuinely real. Apply ALL of them to every prompt.

### 1. Camera Equipment & Technical Specs

Always include a specific camera body, lens, and settings. This forces the model toward photographic output rather than rendered/illustrated output.

| Element | What to include | Example |
|---------|----------------|---------|
| **Camera body** | Real professional camera model | Canon EOS R5, Sony A7R IV, Nikon Z6 |
| **Lens** | 24-35mm for exteriors (natural perspective) | 24mm wide-angle lens, 35mm lens |
| **Aperture** | f/8 to f/11 for architecture (deep focus) | f/8 aperture |
| **ISO** | Low ISO for clean detail | ISO 100 |
| **Film stock** (optional) | Adds natural grain and color | shot on Kodak Portra 400 |

### 2. Realism Keywords (ALWAYS include these)

Append to every prompt:
```
Professional real estate photography, shot on Canon EOS R5, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic material surfaces, subtle weathering details, 8K resolution.
```

### 3. Lived-In Imperfections (CRITICAL — what makes it look real)

AI defaults to "too perfect" which is the #1 giveaway. Real homes have:

| Detail | Prompt language |
|--------|----------------|
| **Siding wear** | "slight weathering on siding, natural patina" |
| **Lawn imperfections** | "natural lawn with minor bare patches near the walkway" |
| **Material texture** | "visible mortar lines between bricks, natural wood grain variation" |
| **Driveway** | "hairline cracks in concrete driveway, minor oil stain near garage" |
| **Roof** | "slight moss at roof edges" or "minor shingle color variation from sun exposure" |
| **Mailbox/details** | "slightly tilted mailbox, house numbers with minor tarnish" |

Pick 2-3 of these per prompt. Do not use all at once or the home looks run-down.

### 4. Perspective & Composition

| Rule | Why |
|------|-----|
| **Eye-level from the street** | Drone/aerial angles look artificial and rendered |
| **Slight three-quarter angle** | Straight-on shots look like 3D model renders. A subtle angle (10-15 degrees off center) is more natural |
| **Include street edge** | A sliver of street/curb in the foreground grounds the image in reality |
| **Neighbor context** | "neighboring roofline barely visible at frame edge" adds realism |

### 5. Lighting Specificity

Vague lighting produces flat, artificial results. Be specific:

| Instead of... | Say this... |
|---------------|-------------|
| "golden hour lighting" | "warm late afternoon sun casting long natural shadows across the lawn, light filtering through tree canopy" |
| "bright midday lighting" | "direct overhead sun with hard shadows under eaves, bright even exposure" |
| "natural daylight" | "soft diffused daylight from thin cloud cover, even illumination without harsh shadows" |

### 6. What NOT to Say (Anti-Patterns)

These words trigger stylization and make images look AI-generated:

| NEVER use | Why |
|-----------|-----|
| "cinematic" | Triggers dramatic color grading and unrealistic contrast |
| "dramatic" | Exaggerated shadows and highlights |
| "epic", "stunning", "breathtaking" | Pushes toward fantasy/conceptual art |
| "perfect", "flawless", "pristine" | Triggers uncanny valley overperfection |
| "hyper-detailed" | Oversharpens textures, creates plastic look |
| "4K wallpaper", "desktop wallpaper" | Triggers oversaturated stock photo look |
| "octane render", "unreal engine" | Explicitly 3D render styles |

## Image Generation Settings

| Setting | Value | Notes |
|---------|-------|-------|
| **Aspect ratio** | `4:3` (standard), `16:9` (large/horizontal) | Match the card layout |
| **Output path** | `client/src/assets/images/property-{n}.png` | Import into component |
| **Negative prompt** | See expanded negative prompt below | Always include |
| **one_line_summary** | `"{City} {style} home"` | e.g., "Raleigh colonial home" |

**Always use this negative prompt:**
```
text, watermark, logo, people, cars with license plates, interior shots, aerial view, blurry, low quality, cartoon, illustration, 3D render, CGI, digital art, painting, sketch, oversharpened, plastic texture, glossy surfaces, oversaturated colors, harsh HDR, excessive bloom, unnatural symmetry, distorted perspective, warped walls, floating objects, impossible geometry, color banding, artificial lighting, flat lighting, overexposed highlights, perfect unblemished surfaces
```

## Prompt Template

```
Professional real estate exterior photograph of a [PROPERTY_TYPE] in [CITY, STATE]. [ARCHITECTURAL_STYLE] architecture with [MATERIALS], [SPECIFIC_FEATURES]. [LANDSCAPING_DETAILS], [IMPERFECTION_DETAILS]. Shot from the street at eye level with slight angle, [SPECIFIC_LIGHTING_DESCRIPTION]. Shot on Canon EOS R5, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic material surfaces, subtle wear details, 8K resolution.
```

---

## Batch Generation Pattern

When building a page with multiple cards, generate all images at once:

```
generate_image_tool({
  images: [
    {
      prompt: "[Use full regional prompt with camera specs, imperfections, and lighting details]",
      negative_prompt: "text, watermark, logo, people, cars with license plates, interior shots, aerial view, blurry, low quality, cartoon, illustration, 3D render, CGI, digital art, painting, sketch, oversharpened, plastic texture, glossy surfaces, oversaturated colors, harsh HDR, excessive bloom, unnatural symmetry, distorted perspective, warped walls, floating objects, impossible geometry, color banding, artificial lighting, flat lighting, overexposed highlights, perfect unblemished surfaces",
      output_path: "client/src/assets/images/property-1.png",
      aspect_ratio: "4:3",
      one_line_summary: "Raleigh colonial home"
    },
    {
      prompt: "[Second property prompt]",
      negative_prompt: "text, watermark, logo, people, cars with license plates, interior shots, aerial view, blurry, low quality, cartoon, illustration, 3D render, CGI, digital art, painting, sketch, oversharpened, plastic texture, glossy surfaces, oversaturated colors, harsh HDR, excessive bloom, unnatural symmetry, distorted perspective, warped walls, floating objects, impossible geometry, color banding, artificial lighting, flat lighting, overexposed highlights, perfect unblemished surfaces",
      output_path: "client/src/assets/images/property-2.png",
      aspect_ratio: "4:3",
      one_line_summary: "Durham craftsman home"
    }
  ]
})
```

---

## Regional Prompt Templates

### Raleigh-Durham, NC

**Single-family (colonial):**
```
Professional real estate exterior photograph of a single-family home in Raleigh, North Carolina. Colonial revival architecture with brick veneer facade showing natural mortar line variation, black shutters with minor sun fading, covered front porch with white columns, two-car garage with slightly weathered door. Green bermuda grass lawn with natural mowing lines, mature crepe myrtle trees, azalea bushes along the foundation with some spent blooms, concrete driveway with hairline expansion joints. Neighboring roofline barely visible at frame edge. Shot from the street at eye level with slight three-quarter angle, warm late afternoon sun casting long natural shadows across the lawn. Shot on Canon EOS R5, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic material surfaces, 8K resolution.
```

**Single-family (craftsman):**
```
Professional real estate exterior photograph of a craftsman bungalow in Durham, North Carolina. Arts and Crafts style with tapered porch columns on stone bases showing natural stone color variation, exposed rafters, low-pitched gabled roof with minor shingle granule variation, mixed siding and shingle accents. Established front yard with mature pine trees, fescue lawn with natural shade patterns, perennial flower beds, brick walkway with moss in joints. Curb and street edge visible in foreground. Shot from the sidewalk at eye level, soft diffused daylight from thin cloud cover, even illumination. Shot on Sony A7R IV, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic wood grain detail, 8K resolution.
```

**Townhouse:**
```
Professional real estate exterior photograph of a modern townhouse in Cary, North Carolina. Transitional style with fiber cement siding in gray-blue, stone accent base with natural texture variation, attached single-car garage, small covered entry with sconce light. Small front yard with ornamental grasses, young dogwood tree, mulched beds with natural mulch decomposition at edges. Adjacent townhouse unit partially visible. Shot from the sidewalk at eye level with slight angle, bright midday sun with hard shadows under eaves. Shot on Canon EOS R5, 24mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic proportions, 8K resolution.
```

**Condo / apartment:**
```
Professional real estate exterior photograph of a mid-rise apartment building in Durham, North Carolina. Contemporary design with mixed materials — red brick lower level with visible mortar joints, fiber cement panels in warm gray upper floors, large windows with dark frames reflecting sky and trees. Landscaped entrance with crepe myrtles, boxwood hedges with natural growth variation, concrete walkway with minor staining, glass lobby entrance. Street curb and parking area edge visible. Shot from across the street at eye level, natural daylight with soft cloud-diffused lighting. Shot on Canon EOS R5, 24mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic glass reflections, 8K resolution.
```

---

### Columbus, OH

**Single-family (Cape Cod):**
```
Professional real estate exterior photograph of a single-family home in Columbus, Ohio. Cape Cod style with white vinyl siding, dark gray roof with minor granule variation, red brick chimney with slight efflorescence, front gable dormers, covered front entry with black lantern lights. Green bluegrass lawn with natural mowing lines, mature maple tree providing dappled shade, hosta plantings along the walkway, attached two-car garage with slightly faded door. Shot from the street at eye level with slight angle, bright midday sun with crisp shadows. Shot on Canon EOS R5, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic material surfaces, 8K resolution.
```

**Single-family (colonial):**
```
Professional real estate exterior photograph of a two-story colonial home in Upper Arlington, Ohio. Traditional red brick facade with natural color variation between bricks, white trim, symmetrical windows with black shutters, columned front entrance, attached side-entry garage. Established landscaping with buckeye tree casting dappled shadows, boxwood hedges with natural growth irregularity, manicured bluegrass lawn, concrete driveway with minor expansion joint cracks. Neighboring fence line barely visible at edge. Shot from the street at eye level, warm late afternoon sun with long shadows across the yard. Shot on Sony A7R IV, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic brick detail, 8K resolution.
```

**Townhouse:**
```
Professional real estate exterior photograph of a brick townhouse in the Short North area of Columbus, Ohio. Traditional design with red brick facade showing natural mortar aging, black iron railings with minor patina, small covered entryway, second-floor bay window. Compact front landscaping with low boxwood hedge, potted plants by the door, brick sidewalk with slight settling variation. Adjacent townhouse partially visible. Shot from the sidewalk at eye level, warm afternoon sun filtering through street trees. Shot on Canon EOS R5, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic urban context, 8K resolution.
```

---

### San Antonio, TX

**Single-family (hill country):**
```
Professional real estate exterior photograph of a single-family home in San Antonio, Texas. Texas hill country style with limestone and stucco exterior showing natural stone texture variation, clay tile roof with sun-faded tones, arched entryway, two-car garage with decorative iron hardware. Xeriscaped front yard with native grasses, a mature live oak tree casting heavy shade, gravel border with natural scatter, St. Augustine grass patches, stone-lined flower beds. Curb and street visible in foreground. Shot from the street at eye level with slight angle, warm late afternoon Texas sun casting long shadows, expansive clear blue sky. Shot on Canon EOS R5, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic limestone detail, 8K resolution.
```

**Single-family (ranch):**
```
Professional real estate exterior photograph of a ranch-style home in San Antonio, Texas. Single-story stucco home painted in warm beige with minor hairline stucco texture variation, brown composition roof, covered front porch with wrought iron supports showing slight patina, attached two-car garage. Flat front yard with St. Augustine grass showing natural summer stress patches, two palm trees, desert sage plantings, concrete driveway with minor surface wear. Shot from the street at eye level, bright midday Texas sunshine with hard shadows under eaves, expansive sky. Shot on Sony A7R IV, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic stucco surface, 8K resolution.
```

**Condo / apartment:**
```
Professional real estate exterior photograph of a garden-style apartment complex in San Antonio, Texas. Three-story stucco building in warm terracotta and cream tones with natural sun fading on south-facing wall, barrel tile accent roof, covered breezeway entries, parking lot visible with a few parked cars. Landscaping with live oak trees, agave plants, crepe myrtles, walkways with minor wear. Shot from the parking area at eye level, natural daylight with soft shadows. Shot on Canon EOS R5, 24mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic stucco aging, 8K resolution.
```

---

### Indianapolis, IN

**Single-family (colonial):**
```
Professional real estate exterior photograph of a single-family home in Indianapolis, Indiana. Midwest colonial style with red brick facade showing natural brick color variation, white trim, black shutters, covered front porch with square columns, attached two-car garage. Green bluegrass lawn with visible mowing lines, mature oak tree in the front yard casting dappled shade, black-eyed Susans along the walkway, mulched foundation beds with natural mulch decomposition. Shot from the street at eye level with slight angle, warm late afternoon sun with long shadows. Shot on Canon EOS R5, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic brick mortar detail, 8K resolution.
```

**Single-family (craftsman):**
```
Professional real estate exterior photograph of a craftsman bungalow in the Broad Ripple neighborhood of Indianapolis, Indiana. Arts and Crafts style with tapered columns on stone bases, exposed rafters with natural wood weathering, mixed siding and stone foundation, wide front porch with vintage pendant light. Established landscaping with dogwood tree, perennial flower beds with mixed bloom stages, concrete walkway with minor moss in joints, mature shade trees. Shot from the sidewalk at eye level, soft golden hour light filtering through tree canopy, autumn-tinged foliage. Shot on Sony A7R IV, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic wood grain, 8K resolution.
```

---

### Nashville, TN

**Single-family (Southern colonial):**
```
Professional real estate exterior photograph of a single-family home in Nashville, Tennessee. Southern colonial style with white painted brick showing subtle texture through paint, black shutters, grand front porch with tall white columns, symmetrical facade, side-entry garage. Lush green fescue lawn with natural mowing patterns, mature magnolia tree with waxy leaves catching light, boxwood hedges with natural growth variation, brick walkway with slight settling, wrought iron mailbox with minor patina. Shot from the street at eye level with slight angle, warm late afternoon sun casting long shadows across the porch. Shot on Canon EOS R5, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic painted brick detail, 8K resolution.
```

**Modern farmhouse (new construction):**
```
Professional real estate exterior photograph of a new construction modern farmhouse in Nashville, Tennessee. Board-and-batten siding in white with crisp lines, black metal roof accents, large front windows reflecting trees and sky, covered porch with black metal posts, two-car garage. New landscaping with ornamental grasses, young red maple with support stake still visible, fresh mulched beds, stone walkway, modern black exterior lights. Construction grade sod lawn with visible seams between rolls. Shot from the street at eye level, bright midday sun with crisp shadows from eaves. Shot on Canon EOS R5, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic new construction details, 8K resolution.
```

**Tall-and-skinny (urban infill):**
```
Professional real estate exterior photograph of a tall-and-skinny urban infill home in East Nashville, Tennessee. Three-story contemporary design with fiber cement siding in charcoal gray, large windows reflecting neighboring trees, rooftop deck railing visible, narrow lot with small front yard. Minimal modern landscaping with ornamental grasses, concrete walkway, street trees, utility lines visible in sky. Adjacent older home partially visible showing neighborhood contrast. Shot from the sidewalk at eye level, warm afternoon light with shadows from neighboring structures. Shot on Sony A7R IV, 24mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic urban infill context, 8K resolution.
```

---

### Charlotte, NC

**Single-family (traditional):**
```
Professional real estate exterior photograph of a single-family home in Charlotte, North Carolina. Traditional Southern style with brick and vinyl siding, covered front porch with turned columns, two-car garage with slightly faded door, gabled roof with dormers. Green centipede grass lawn with natural growth patterns, crepe myrtle trees in bloom, camellia bushes, mulched flower beds with natural decomposition at edges, concrete driveway with minor surface staining. Shot from the street at eye level with slight angle, warm afternoon sun casting natural shadows through tree canopy. Shot on Canon EOS R5, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic material aging, 8K resolution.
```

**Townhouse:**
```
Professional real estate exterior photograph of a modern townhouse in the South End neighborhood of Charlotte, North Carolina. Contemporary design with brick and fiber cement siding in warm gray, black window frames reflecting sky, attached single-car garage, rooftop terrace railing visible. Small front yard with ornamental grasses, young dogwood tree, paver walkway with sand in joints. Adjacent unit partially visible. Shot from the sidewalk at eye level, bright midday sun with crisp shadows. Shot on Canon EOS R5, 24mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic urban proportions, 8K resolution.
```

---

### Tampa, FL

**Single-family (Florida ranch):**
```
Professional real estate exterior photograph of a single-family home in Tampa, Florida. Florida ranch style with peach stucco exterior showing natural stucco texture, barrel tile roof in terracotta with minor lichen at edges, screened front entry, attached two-car garage, impact-resistant windows reflecting palm trees. Tropical landscaping with palm trees casting sharp shadows, hibiscus bushes, St. Augustine grass with natural chinch bug patches near sidewalk, crushed shell walkway. Shot from the street at eye level with slight angle, bright Florida sunshine with vivid blue sky and white cumulus clouds. Shot on Canon EOS R5, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic tropical lighting, 8K resolution.
```

**Single-family (Mediterranean):**
```
Professional real estate exterior photograph of a Mediterranean-style home in South Tampa, Florida. Two-story stucco home in cream with natural stucco texture variation, terracotta barrel tile roof with sun-faded tones, arched windows and entry, decorative iron balcony with slight patina, paver driveway with sand in joints. Lush tropical landscaping with queen palm trees, bird of paradise, bougainvillea climbing wall, manicured lawn with irrigation head visible. Shot from the street at eye level with slight angle, warm golden hour light with long shadows across the driveway. Shot on Sony A7R IV, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic stucco and tile detail, 8K resolution.
```

**Condo building:**
```
Professional real estate exterior photograph of a mid-rise condominium building in Tampa, Florida. Coastal contemporary design with white and sand-colored stucco, blue glass balcony railings reflecting sky, flat roof with parapet, ground-floor lobby with glass entrance. Tropical landscaping with queen palm trees, bird of paradise, manicured lawn with sprinkler head visible, covered carport. Shot from across the street at eye level, bright midday tropical sun with vivid sky. Shot on Canon EOS R5, 24mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic glass reflections, 8K resolution.
```

---

### Kansas City, MO

**Single-family (bungalow):**
```
Professional real estate exterior photograph of a single-family home in Kansas City, Missouri. Midwest bungalow style with brick facade showing natural mortar aging, wide front porch with tapered columns, exposed stone foundation with natural color variation, low-pitched roof with wide eaves. Green fescue lawn with natural mowing lines, elm trees casting dappled shade, ornamental grasses, brick-lined flower beds with natural mulch, concrete driveway with minor surface wear. Shot from the street at eye level with slight angle, warm golden hour light with long shadows across the porch, open Midwest sky. Shot on Canon EOS R5, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic brick aging, 8K resolution.
```

**Single-family (foursquare):**
```
Professional real estate exterior photograph of an American foursquare home in the Brookside neighborhood of Kansas City, Missouri. Two-story frame with vinyl siding in sage green showing minor sun fading on south side, wide covered front porch, dormer window, symmetrical facade, detached garage visible behind. Established landscaping with elm trees, coneflowers, ornamental grasses, brick walkway with minor settling. Neighboring fence partially visible. Shot from the street at eye level, warm afternoon sun filtering through mature trees. Shot on Sony A7R IV, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic siding detail, 8K resolution.
```

---

### Minneapolis, MN

**Single-family (Tudor):**
```
Professional real estate exterior photograph of a single-family home in Minneapolis, Minnesota. Tudor revival style with stucco and dark timber half-timbering showing natural wood aging, steep gabled roof with minor moss at north-facing edges, arched front entry, brick chimney with slight efflorescence, attached single-car garage. Green cool-season lawn with natural shade patterns under trees, birch trees with peeling bark, hostas and daylilies, stone walkway with natural settling. Shot from the street at eye level with slight angle, crisp midday light with defined shadows from steep roofline. Shot on Canon EOS R5, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic Tudor timber detail, 8K resolution.
```

**Single-family (craftsman):**
```
Professional real estate exterior photograph of a craftsman home in the Linden Hills neighborhood of Minneapolis, Minnesota. Updated craftsman with stucco exterior showing natural texture variation, tapered columns on stone bases, wide covered front porch with vintage pendant light, low-pitched roof with exposed rafters. Front yard with birch trees, spruce trees, daylilies in mixed bloom stages, cool-season bluegrass lawn with natural shade patterns, concrete walkway with minor surface crazing. Shot from the street at eye level, warm afternoon sun with shadows from mature tree canopy. Shot on Sony A7R IV, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic stucco and stone, 8K resolution.
```

---

### Phoenix, AZ

**Single-family (Southwestern):**
```
Professional real estate exterior photograph of a single-family home in Phoenix, Arizona. Southwestern style with tan stucco exterior showing natural desert sun patina, flat roof with parapet, desert-toned accents, covered front entry with timber beams showing natural wood grain, two-car garage. Xeriscaped front yard with decomposed granite showing natural raking patterns, saguaro cactus, palo verde tree casting lacy shadows, desert marigold, flagstone walkway with sand in joints, decorative boulders. Shot from the street at eye level with slight angle, bright desert sunshine with hard shadows under entry overhang, clear blue sky with distant mountain silhouette. Shot on Canon EOS R5, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic desert stucco, 8K resolution.
```

**Single-family (contemporary):**
```
Professional real estate exterior photograph of a contemporary home in Scottsdale, Arizona. Desert modern architecture with clean lines, floor-to-ceiling windows reflecting desert landscape, mixed stucco and stone veneer with natural texture, flat roof with deep overhangs, three-car garage. Minimalist xeriscaped front with decomposed granite, accent boulders with natural desert varnish, agave plants, palo verde trees, paver driveway with sand in joints. Shot from the street at eye level with slight angle, late afternoon desert golden hour with warm sky gradient and long shadows. Shot on Sony A7R IV, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic desert materials, 8K resolution.
```

**Single-family (ranch):**
```
Professional real estate exterior photograph of a ranch-style home in Mesa, Arizona. Single-story stucco home in warm desert tan with natural stucco texture, composition roof, covered front porch with wrought iron posts showing desert patina, two-car garage, block wall courtyard. Front yard with desert landscaping — gravel ground cover with natural scatter, ocotillo, prickly pear cactus, desert willow tree casting lacy shade, concrete walkway with minor surface wear. Shot from the street at eye level, bright midday Arizona sunshine with hard shadows under porch, cloudless blue sky. Shot on Canon EOS R5, 35mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic desert home, 8K resolution.
```

---

## Rental-Specific Prompts

### Garden-Style Apartment

```
Professional real estate exterior photograph of a garden-style apartment complex in [CITY, STATE]. Two-story residential building with [MATERIAL] exterior showing natural weathering, covered breezeway entries, parking lot visible with a few parked cars, building number sign with minor fading. [REGIONAL_LANDSCAPING], walkways with minor wear, exterior staircase with metal railing. Shot from the parking area at eye level, natural daylight with soft shadows. Shot on Canon EOS R5, 24mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic apartment complex, 8K resolution.
```

### Urban Apartment / Mid-Rise

```
Professional real estate exterior photograph of a modern apartment building in downtown [CITY, STATE]. Contemporary mixed-use design with [MATERIAL] and glass facade reflecting surrounding buildings and sky, retail at ground level, residential above, modern entrance canopy. Urban streetscape with street trees, bike rack, glass lobby visible with interior lighting. Shot from across the street at eye level, late afternoon golden hour light with natural shadows from adjacent buildings. Shot on Canon EOS R5, 24mm lens, f/8, ISO 100. Photorealistic, natural textures, realistic glass reflections, 8K resolution.
```

### Rental House

Use the same regional single-family prompts above — rental houses look the same as for-sale houses from the exterior.

---

## Prompt Customization Tips

**Adjust for price point:**
- **Budget ($150K-$220K):** Smaller homes, simpler landscaping, older construction. Add "modest, well-maintained, smaller footprint, mature neighborhood with established trees" to prompt.
- **Median ($220K-$380K):** Standard suburban homes, established landscaping. Use prompts as written.
- **Upper ($380K-$550K):** Larger homes, upgraded materials, more polished landscaping. Add "upscale finishes, professionally landscaped, premium materials, wider lot" to prompt.

**Adjust for season:**
- **Spring:** "spring blooming azaleas and dogwoods, fresh bright green lawn, pollen dusting on cars and walkways"
- **Summer:** "lush green landscaping, full canopy shade trees, bright sunshine, heat shimmer on driveway"
- **Fall:** "autumn foliage in warm oranges and reds, scattered leaves on lawn and walkway, raked leaf pile near curb"
- **Winter (South):** "mild winter, evergreen landscaping, bare deciduous trees, clear cool sky"
- **Winter (North):** "light snow dusting on roof and lawn, bare deciduous trees, tire tracks in thin snow on driveway, overcast sky"

**Adjust for time of day:**
- **Golden hour (default):** "warm late afternoon sun casting long natural shadows across the lawn, light filtering through trees" — best for most properties
- **Midday:** "direct overhead sun with hard shadows under eaves, bright even exposure, deep blue sky" — good for new construction
- **Twilight:** "dusk twilight with warm interior lights glowing through windows, deep blue sky gradient, landscape lights on" — premium listings

## Realism Checklist (Verify Before Delivery)

After generating each image, verify these qualities:

- [ ] **Perspective** — Eye-level from street, not aerial or elevated
- [ ] **Shadows** — Natural shadow direction consistent with stated lighting
- [ ] **Materials** — Visible texture in brick/stucco/siding, not smooth or plastic
- [ ] **Landscaping** — Natural growth patterns, not perfectly symmetrical
- [ ] **Imperfections** — At least 1-2 subtle wear details present
- [ ] **Context** — Some environmental context visible (curb, neighboring element, sky)
- [ ] **No AI tells** — No warped lines, impossible geometry, or floating elements
- [ ] **Region match** — Architecture, materials, and landscaping match the stated city/state
