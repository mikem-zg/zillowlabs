# Platform & Channel Guide (Professional)

Source: Zillow March 2025 Professional Brand Guidelines, slides 129-146.

## Functional-to-Expressive Spectrum

| More Functional ← | → More Expressive |
|---|---|
| Toolkits | Events |
| Product experience | — |
| Frontline presentations | — |
| One-pagers | — |
| Lifecycle emails | — |
| Landing pages | — |

Most professional work leans toward the functional side. Events are the key outlier, calling for a more expressive approach and full secondary palette.

---

## Offsite

### Print Collateral
- Use restricted professional palette
- No house motif
- Spot illustrations for visual support

### Events
- Full secondary palette allowed (the one exception)
- Event guidelines coming separately

---

## Frontline Materials

### Presentations
- Designed to clearly communicate key information about Zillow products and services
- Organized, visually appealing format for partner comprehension
- Use professional palette and Object Sans hierarchy

### One-Pagers
- Distill complex information into clear, digestible format
- Help partners understand key messages, support decisions, ensure team consistency

---

## Email Platform

### Email Types

| Type | Purpose | Design Approach |
|------|---------|----------------|
| **Lifecycle** | Nurture partner relationships, guide through journey stages | More expressive — personality and brand warmth |
| **Operational** | Deliver essential transaction/account information | More minimalist — focus on content |

### Logo in Email
- Left-aligned: stronger brand recall (research-backed)
- Center-aligned: OK when layout benefits from symmetry
- Height: 24px

### Email Color
- Apply professional palette
- Use contrasting colors for readability
- Highlight CTAs with `Blue600`
- Limit number of colors used
- Prioritize accessibility

---

## Web Platform

### Login Pages
First point of contact — sets tone for brand and user experience. Use sub-brand logo prominently. An engaging, user-friendly login page makes a solid first impression and is key to user retention.

### Product Marketing Landing Pages
Use flexible template allowing for varying color and supporting imagery. Maintain brand consistency across landing pages.

### Responsive Design
Fluid grid layout allowing content to resize and stack across devices. Ensure layout follows responsive patterns for desktop and mobile.

### Negative Space
Apply negative space to create separation and establish visual hierarchy.

| DO | DON'T |
|----|-------|
| Use negative space to divide content without visible dividers | Use excessive `<Divider />` lines (visual noise) |
| Effective visual hierarchy through spacing | Prevent users from focusing on content |

### Blog Design
1. Embrace empty space on the page
2. Focus on high readability with proper text sizing and alignment
3. Include imagery without excess
4. Use consistent design template

---

## Native Platform

### Onboarding / Welcome Screens
- Show 3-4 screens emphasizing core features
- Display clear progress indicators
- Maintain visual consistency (interface, text, brand elements)

### Empty States
- Well-designed empty state guides user and provides clear path forward
- Poorly designed empty state = confusing/frustrating
- Use spot illustrations (not scene illustrations)
- Ensure imagery and content consistent across web and native

### Loading States
- Clear visual indicators (progress bars, animated icons)
- Informative text explaining loading process
- Subtle animations to engage users
- Match brand aesthetic with playful microinteractions

---

## Design Patterns Across Platforms

| Pattern | Approach |
|---------|----------|
| Component sizing | Default `size="sm"` for buttons, inputs, selects. Tables: `appearance="horizontal"` and `size="sm"` on `Table.Root`; all internals inherit sm (`size="md"` for hero CTAs only) |
| Headers | Sticky `Box` with `Flex` inside; `borderBottom: "default"` + `borderColor: "border.muted"` on the `Box` |
| Navigation | Left-aligned logo, functional navigation |
| Cards | `Card elevated interactive tone="neutral"` for clickable; `Card outlined elevated={false} tone="neutral"` for static |
| Empty states | Spot illustration + heading + body text + CTA button |
| Data tables | Clean, high-contrast, functional layout |

## Cross-References

- **Component patterns** → `custom_instruction/instructions.md`
- **Responsive design** → `.agents/skills/responsive-design/SKILL.md`
- **Header navigation** → `.agents/skills/header-navigation/SKILL.md`
