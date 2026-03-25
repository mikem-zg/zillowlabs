---
name: constellation-illustrations
description: Implement and manage Constellation spot illustrations. Activates when selecting illustrations, designing empty states, building onboarding flows, creating upsell banners, or adding visual storytelling to Zillow apps. Provides 99 illustrations with keywords, descriptions, categories, use-case guidance, and light/dark mode SVG paths.
license: Proprietary
compatibility: Requires a React project with illustration SVGs in client/src/assets/illustrations/
metadata:
  author: Zillow Group
  version: "10.14.0"
---

# Constellation Illustrations Library

99 spot illustrations in both light and dark mode for Zillow consumer and professional applications.

## Prerequisites

- Illustration SVG files present in `client/src/assets/illustrations/Lightmode/` and `client/src/assets/illustrations/Darkmode/`
- Vite (or equivalent bundler) configured to import `.svg` files as URL strings
- For dark mode switching: theme detection via `constellation-dark-mode` skill patterns

## When to Use

- Selecting an illustration for empty states, onboarding, error pages, or upsell banners
- Looking up illustrations by keyword (e.g., "what illustration shows a house with a checkmark?")
- Checking sizing rules (160×160px standard, 120×120px compact)
- Implementing light/dark mode illustration switching

## When NOT to Use

- **Small visual accents (under 120px)** — use an `Icon` from **[constellation-icons](../../constellation-icons/SKILL.md)** instead. Icons go down to 16px (`sm`) and up to 44px (`xl`). Load that skill for the full 621-icon catalog and lookup table.
- **Photography, hero images, or large visuals (over 160px)** — use the **[orangelogic-dam](../../orangelogic-dam/SKILL.md)** skill to search Zillow's Digital Asset Manager for photos, logos, and brand imagery. Load that skill for DAM search, asset URLs, and usage rights.
- **Adding icons to buttons or UI elements** — use **[constellation-icons](../../constellation-icons/SKILL.md)** (icons are not illustrations)
- **Building UI components or layouts** — use `constellation-design-system`
- **Implementing dark mode toggle logic** — use `constellation-dark-mode` (this skill only covers illustration variants)

## Reference Guides

- **`reference/illustration-catalog.md`** — Full catalog of all 99 illustrations with descriptions, keywords, categories, suggested use cases, and audience suitability
- **`reference/usage-guide.md`** — Implementation patterns, sizing rules, dark mode handling, design system rules, and anti-patterns

## Related Skills

- **[constellation-design-system](../../constellation-design-system/SKILL.md)**: Core design system rules, all 99 component docs, UX writing guidelines, and layout patterns. **Load this skill for component usage, spacing tokens, and design rules.**
- **[constellation-icons](../../constellation-icons/SKILL.md)**: Full catalog of 621 icons with color tokens, sizing, and implementation guides. **Load this skill when you need a small visual accent (under 120px) instead of an illustration.**
- **[constellation-dark-mode](../../constellation-dark-mode/SKILL.md)**: Theme injection, dark mode toggle patterns, and design token tiers. **Load this skill when implementing theming or dark mode** — illustrations have both light and dark variants.
- **[orangelogic-dam](../../orangelogic-dam/SKILL.md)**: Search Zillow's Digital Asset Manager for photography, logos, and brand imagery. **Load this skill when you need a large visual (over 160px) instead of an illustration** — hero images, property photos, feature showcases.
- **[consumer-brand-guidelines](../../consumer-brand-guidelines/SKILL.md)**: Consumer audience brand rules — both scene and spot illustrations allowed. **Load for consumer illustration usage rules.**
- **[professional-brand-guidelines](../../professional-brand-guidelines/SKILL.md)**: Professional audience brand rules — spot illustrations ONLY, no scene illustrations. **Load for professional illustration restrictions and duotone icon guidance.**

## Quick Start

```tsx
import SearchHomesLight from '@/assets/illustrations/Lightmode/search-homes.svg';
import SearchHomesDark from '@/assets/illustrations/Darkmode/search-homes.svg';
import { Image } from '@zillow/constellation';

<Image
  src={isDarkMode ? SearchHomesDark : SearchHomesLight}
  alt="Search homes"
  css={{ width: '160px', height: '160px' }}
/>
```

## Critical Rules

1. **ALWAYS** provide both light and dark mode variants
2. **ALWAYS** keep the beige background blob (grounds the visual)
3. **ALWAYS** use standard sizing: 160×160px (standard) or 120×120px (compact)
4. **ALWAYS** count illustrations toward the 25% bold color limit
5. **NEVER** use spot illustrations where an X-Large (44px) icon would suffice
6. **NEVER** place illustrations next to large solid-colored cards
7. **NEVER** scale illustrations smaller than 120px — use an `Icon` (size `xl` = 44px) instead; see **[constellation-icons](../../constellation-icons/SKILL.md)**
8. **NEVER** scale illustrations larger than 160px — use photography from the **[orangelogic-dam](../../orangelogic-dam/SKILL.md)** for hero-sized visuals
9. **Professional apps**: Spot illustrations ONLY — no complex scene illustrations
10. **Consumer apps**: Both spot and scene illustrations allowed

## When to Use Illustrations

| Context | Use | Example Illustrations |
|---------|-----|----------------------|
| Empty states | Show when no data exists | `envelope-empty`, `search-homes`, `saved-homes` |
| Onboarding | Welcome and guide new users | `guided-steps`, `key`, `buyer-education` |
| Upsell banners | Promote features or services | `star-rising`, `trophy`, `chart-trending-up` |
| Success screens | Celebrate completions | `celebrate`, `house-checkmark`, `verify` |
| Error/not found | Soften error messages | `magnifying-glass`, `user-question`, `support` |
| Feature intros | Explain new capabilities | `app-announcement`, `announcement`, `integration` |
| Educational | Teach concepts | `financial-education`, `avoid-mistakes`, `buyer-education` |

## Category Quick Finder

| Category | Count | Key Illustrations |
|----------|-------|-------------------|
| Homes & Properties | 21 | `search-homes`, `for-sale-home`, `house-checkmark` |
| Finance & Documents | 19 | `finance`, `calculator-paperwork`, `credit-score` |
| People & Communication | 15 | `agents`, `team`, `handshake` |
| Actions & States | 37 | `celebrate`, `checklist`, `magnifying-glass` |
| Lifestyle & Amenities | 7 | `pet`, `gym`, `car` |

## Keyword Search Tips

When searching the catalog, try these keyword patterns:

- **By concept**: "empty", "success", "error", "onboarding", "upsell"
- **By subject**: "home", "document", "agent", "phone", "laptop"
- **By action**: "search", "save", "celebrate", "verify", "compare"
- **By audience**: "consumer", "professional", "both"
