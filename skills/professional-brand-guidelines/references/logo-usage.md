# Logo Usage (Professional)

Source: Zillow March 2025 Professional Brand Guidelines, slides 13-21.

## Logo Components in Code

| Component | Import | Usage |
|-----------|--------|-------|
| `ZillowLogo` | `import { ZillowLogo } from '@zillow/constellation'` | Full logo with logotype |

### Sizing (use `style` prop, NOT `css`)

```tsx
<ZillowLogo style={{ height: '24px', width: 'auto' }} />
<ZillowLogo style={{ height: '16px', width: 'auto' }} />
```

## Parent Brand Logo

The highest expression of the company. Embodies full brand equity and sets the tone for all sub-brands.

## Sub-Brand Logos

| Sub-Brand | Audience | Has Primary + Secondary + White Lockups |
|-----------|----------|----------------------------------------|
| **Zillow Premier Agent** | Agent partners | Yes |
| **Zillow Rentals** | Rental partners | Yes |
| **Zillow New Construction** | Builder partners | Yes |

Each sub-brand has three lockup orientations:
- **Primary** (preferred): Use whenever possible
- **Secondary**: When spacing constraints prevent primary
- **All White**: When `Blue600` is present in layout; or use tag design if no blue

## Clearspace + Minimum Sizes

### Zillow Premier Agent (applies similarly to all sub-brands)

| Measurement | Value |
|-------------|-------|
| Clearspace metric | House motif on all sides |
| Horizontal min size (screen) | 120px at 72dpi |
| Stacked min size (screen) | 120px at 72dpi |
| Horizontal min size (print) | 1.5" height |

### Tag Design
Position the tag design two house motifs to the left of the asset. Scale appropriately within layout.

## Incorrect Usage (9 Rules)

1. Do not scale disproportionately
2. Do not make all `Blue600`
3. Do not use colors outside the palette
4. Do not use logomark alone without logotype
5. Do not type out the logo manually
6. Do not place the logo within the house motif
7. Do not add drop shadows
8. Do not stack logomark above logotype
9. Do not add gradients

---

## Marketing Logo Rules

### Email Logo Alignment
- Left-aligned logo: stronger brand recall (research-backed)
- Center-aligned logo: OK in symmetric layouts

### Sub-Brand Usage in Marketing
Use sub-brand logos in frontline materials (presentations, one-pagers) and lifecycle emails. Always use the primary lockup when space allows.

---

## Product Logo Rules

### Sizing Constraints

| Context | Height | Code |
|---------|--------|------|
| Desktop navigation | **24px** | `style={{ height: '24px', width: 'auto' }}` |
| Mobile navigation | **16px** | `style={{ height: '16px', width: 'auto' }}` |

### Alignment
- Left-align logo whenever possible
- Consistent height across LOB transitions (Premier Agent → Rentals → New Construction)

### Login Screens
Login screens are the first point of contact — they set the tone for the brand. Use sub-brand logo prominently on login pages (e.g., "Zillow Rentals Manager login page", "Zillow Premier Agent login page").

### Sticky Header Pattern

```tsx
<Box css={{ position: 'sticky', display: 'flow-root', top: 0, zIndex: 10, width: '100%', background: 'bg.screen.neutral' }}>
  <Flex align="center" justify="space-between" css={{ maxWidth: 'breakpoint-xxl', mx: 'auto', width: '100%', px: '400', py: '400' }}>
    <ZillowLogo style={{ height: '24px', width: 'auto' }} />
    <Button tone="brand" emphasis="filled" size="sm">Get started</Button>
  </Flex>
  <Divider tone="muted-alt" />
</Box>
```

## Cross-References

- **OrangeLogic DAM** → `.agents/skills/orangelogic-dam/SKILL.md` for sourcing logo assets. NEVER hardcode or inline SVG logos.
- **Sticky header pattern** → `custom_instruction/instructions.md` lines 364-391
