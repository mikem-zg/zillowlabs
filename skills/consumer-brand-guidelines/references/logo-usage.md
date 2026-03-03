# Logo Usage

Source: Zillow April 2024 Brand Guidelines, slides 42-78.

## Logo Components in Code

| Component | Import | Usage |
|-----------|--------|-------|
| `ZillowLogo` | `import { ZillowLogo } from '@zillow/constellation'` | Full logo with logotype |

### Sizing (use `style` prop, NOT `css`)

PandaCSS can misinterpret pixel values as tokens. Always use the `style` prop for logo sizing:

```tsx
<ZillowLogo style={{ height: '24px', width: 'auto' }} />
<ZillowLogo style={{ height: '16px', width: 'auto' }} />
```

## Three Logo Colorways

| # | Colorway | When to Use |
|---|----------|-------------|
| 01 | **Primary** (full color) | Default. On photos with clear space, or on white (`bg.screen.neutral`) background. |
| 02 | **All White** | Owned spaces: white logo on its own. Non-owned spaces: only with `Blue600` present in design. |
| 03 | **Tag Design** | Non-owned spaces where no `Blue600` is present. Logo housed in a designed "tag" with Zillow Blue. |

## Incorrect Usage (9 Rules — Both Marketing and Product)

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

### Owned vs Non-Owned Space Decision

| Context | `Blue600` Present? | Colorway |
|---------|-------------------|----------|
| Owned space (app, email, social) | — | Primary or white (both OK) |
| Non-owned space | Yes | White logo OK |
| Non-owned space | No | Tag design required |

### Marketing Email Logo
- Logo: 24px height
- Left-align in most instances

### Co-Branding (Marketing)

#### Product-Based Partnerships (Long-Term)
- Logos separated by vertical rule in `Gray950` (Granite)
- Zillow leads on owned channels
- Equal visual weight

#### Marketing-Based Partnerships (One-Off)
- "X" separator implies collaboration (Object Sans Bold, `Gray950`)
- Partner logo leads; Zillow follows

#### Co-Branding DON'Ts

| DON'T | Why |
|-------|-----|
| Position logos too close to dividing rule | Legibility |
| Make one logo bigger than the other | Must maintain equal visual weight |
| Use "X" for long-term product partnerships | "X" is for marketing/comms only |
| Abbreviate logos | Brand integrity |

### Brand Extensions

| Extension | Has a Logo? |
|-----------|------------|
| Zillow Home Loans | Yes |
| Zillow Rentals | Yes |
| Zillow Premier Agent | Yes |
| ShowingTime+ | Yes |
| Individual products/services | No |

---

## Product Logo Rules

### Key Difference from Marketing
The logo is used **more sparingly** in product. Customers already know they are within the Zillow ecosystem.

### Sizing Constraints

| Context | Height | Notes |
|---------|--------|-------|
| Desktop navigation | **24px** | `style={{ height: '24px', width: 'auto' }}` |
| Mobile navigation | **16px** | `style={{ height: '16px', width: 'auto' }}` |
| Email header | **24px** | More surrounding space than mobile web |
| Logomark minimum | **58px** | Never reduce below this for legibility |

### Sizing DON'Ts

| DON'T | Why |
|-------|-----|
| 24px on mobile | Too large; longer LOBs overcrowd mobile nav |
| 16px on desktop | Too small; feels too floaty |
| <12px anywhere | Illegible |

### Alignment in Product
- Left-align logo whenever possible
- This is the vision for global navigation going forward

### Avoid Overcrowding in Product
- The logo does not need to be visible at all times
- Customers already know they are on Zillow
- Never use the logomark without the logotype

### Logo in Headers (Product Code Pattern)

```tsx
<Box css={{ position: 'sticky', display: 'flow-root', top: 0, zIndex: 10, width: '100%', background: 'bg.screen.neutral' }}>
  <Flex align="center" justify="space-between" css={{ maxWidth: 'breakpoint-xxl', mx: 'auto', width: '100%', px: '400', py: '400' }}>
    <ZillowLogo style={{ height: '24px', width: 'auto' }} />
    <Button tone="brand" emphasis="filled" size="md">Browse homes</Button>
  </Flex>
  <Divider tone="muted-alt" />
</Box>
```

## Cross-References

- **Sticky header pattern** → `custom_instruction/instructions.md` lines 364-391
- **OrangeLogic DAM** → `.agents/skills/orangelogic-dam/SKILL.md` for sourcing logo assets. NEVER hardcode or inline SVG logos — always pull from the DAM.
