# Illustrations

99 spot illustrations available in both light and dark mode variants.

## Installation

Illustrations are bundled in the skill at `packages/illustrations-v10.11.0.tar.gz`. Extract into your project's assets directory:

```bash
mkdir -p client/src/assets/illustrations
tar xzf .agents/skills/constellation/packages/illustrations-v10.11.0.tar.gz -C client/src/assets/illustrations/
```

This creates `client/src/assets/illustrations/Lightmode/` and `client/src/assets/illustrations/Darkmode/` with 99 SVGs each.

## Usage

Import the SVG directly (Vite resolves these as URLs):

```tsx
import { Image } from '@zillow/constellation';
import forSaleHomeSvg from '@/assets/illustrations/Lightmode/for-sale-home.svg';

<Image src={forSaleHomeSvg} alt="Home for sale" />
```

For dark mode, import from the `Darkmode/` directory:

```tsx
import forSaleHomeDark from '@/assets/illustrations/Darkmode/for-sale-home.svg';

<Image src={forSaleHomeDark} alt="Home for sale" />
```

> The `@/` alias maps to `client/src/`. Vite handles SVG imports and provides the resolved URL at build time.

## When to Use

- Empty states (no results, no data)
- Upsell and promotional sections
- Onboarding and feature introductions
- Educational and informational content
- Success and confirmation screens

## Catalog

### Homes & Properties (21)

`apartment-interior-couch`, `apartment-interior-desk`, `apartment-rooftop-grill`, `bedroom`, `city-skyline`, `claim-properties`, `compare-homes`, `for-sale`, `for-sale-home`, `home-midwest-style`, `home-rental`, `house-checkmark`, `house-info`, `house-savings`, `multi-family-apartment-building`, `notification-homes`, `rental-listing`, `rental-search`, `rental-tour`, `saved-homes`, `search-homes`

### Finance & Documents (19)

`calculator-paperwork`, `credit-score`, `document-medical`, `document-notarized`, `document-option1`, `document-option2`, `document-signature`, `document-verified`, `documents-option1`, `documents-option2`, `finance`, `finance-option2`, `finance-option3`, `financial-education`, `online-payment`, `price-range`, `roi`, `roi-data`, `temporary-living-costs`

### People & Communication (15)

`agents`, `call`, `client-insights`, `communication-finance`, `communication-virtual`, `contact`, `handshake`, `magnifying-glass-users`, `network`, `professional-paperwork`, `professional-talking`, `support`, `team`, `user-info`, `user-question`

### Actions & States (37)

`3d-tours`, `announcement`, `app-announcement`, `application`, `avoid-mistakes`, `buyer-education`, `calendar-schedule`, `celebrate`, `chart-trending-up`, `checklist`, `clipboard`, `collections`, `envelope-empty`, `guided-steps`, `integration`, `key`, `listing-media`, `magnifying-glass`, `mailbox`, `map`, `phone-notification`, `photographer`, `photography`, `rental-data-laptop`, `rental-notifications`, `save-time-and-money`, `social-media`, `star-rising`, `tasks`, `touring`, `trophy`, `verify`, `webpage`, `zillow-ad`, `zillow-ads`, `zillow-phone`, `zipcode`

### Lifestyle & Amenities (7)

`car`, `community-outdoors`, `gym`, `laptop-browsing`, `laptop-chart`, `laptop-phone`, `pet`

## File Format

All illustrations are SVGs with both Lightmode and Darkmode variants. File naming convention: `{name}.svg`

## DuoColorIcon (Two-Tone Icon Styling)

For simpler two-tone decorative icons (not spot illustrations), use the [DuoColorIcon](DuoColorIcon.md) component which wraps any standard icon with a colored circular background.

```tsx
import { DuoColorIcon, Icon } from '@zillow/constellation';
import { IconKeyFilled } from '@zillow/constellation-icons';

<DuoColorIcon tone="trust" onBackground="default">
  <Icon><IconKeyFilled /></Icon>
</DuoColorIcon>
```

Available tones: `trust`, `insight`, `inspire`, `empower`, `info`, `success`, `critical`, `warning`, `notify`

Available backgrounds: `default`, `hero`, `impact`
