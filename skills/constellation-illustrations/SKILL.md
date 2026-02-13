---
name: constellation-illustrations
description: Implement and manage Constellation spot illustrations. Use when selecting illustrations for empty states, onboarding, upsell banners, success screens, or any visual storytelling in Zillow apps. Provides 99 illustrations with keywords, descriptions, categories, use-case guidance, and light/dark mode paths.
license: Proprietary
compatibility: Requires a React project with illustration SVGs in client/src/assets/illustrations/
metadata:
  author: Zillow Group
  version: "10.11.0"
---

# Constellation Illustrations Library

99 spot illustrations in both light and dark mode for Zillow consumer and professional applications.

## Reference Guides

- **`reference/illustration-catalog.md`** — Full catalog of all 99 illustrations with descriptions, keywords, categories, suggested use cases, and audience suitability
- **`reference/usage-guide.md`** — Implementation patterns, sizing rules, dark mode handling, design system rules, and anti-patterns

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
7. **Professional apps**: Spot illustrations ONLY — no complex scene illustrations
8. **Consumer apps**: Both spot and scene illustrations allowed

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
