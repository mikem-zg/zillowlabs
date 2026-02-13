# Design Tokens

Design tokens capture all the design decisions within your design system — colors, typography, dimensions, and animations — providing a shared design language across design, engineering, and product.

## Token Tiers

### Tier 0 — Raw Values
Rendered values on the platform: hex codes, pixel values, typography attributes.

### Tier 1 — Base Tokens
Human-readable names for raw values. Introduces organization and scale. Very broad specificity of usage.

### Tier 2 — Semantic Tokens
Introduces **meaning** and **usage**. Names carry contextual information about how and where they should be applied. Semantic tokens store the majority of theming decisions. Values reference base-level tokens (rarely raw values).

### Tier 3 — Component Tokens
Exhaustive representation of a design decision. Insulates components from tier 2 tokens. Should reference semantic-level tokens wherever possible.

## Token Name Structure

```
type-subtype-component-element-attribute-context-function-tone-emphasis-modifier-scale-degree-state
```

| Part | Purpose | Examples |
|---|---|---|
| **type** | Type of token | color, size, typography |
| **subtype** | Further describing type | opacity, effect, spacing, dimension, radius, border |
| **component** | What "thing" it applies to | link, sheet, obj, icon, action, layout |
| **element** | Specific part | bg, text, border, padding, gap, heading |
| **attribute** | Detail on element | horz, vert, leading, trailing, height, width |
| **context** | Surrounding situation | onHero, onImpact, elevated |
| **function** | Purpose of element | action, express, feedback, neutral, accent |
| **tone** | Meaning/voice | critical, success, info, warning, trust, insight, empower, inspire |
| **emphasis** | Visual weight | soft, muted, subtle, hero, bold, strong, impact |
| **modifier** | Unique attribute | alt, fixed |
| **scale** | Measurable size | xs, sm, lg, default, tight |
| **degree** | Relative significance | -er (2nd), -est (3rd) |
| **state** | Interactive state | default, disabled, focus, hover, pressed, selected |

## Color Taxonomy

### Elements
| Element | Applied To |
|---|---|
| `bg` | Fill color of a container or surface |
| `text` | Color of any text element |
| `icon` | Color of any icon element |
| `border` | Stroke color of a container or line |

### Function
| Function | Purpose |
|---|---|
| `accent` | Decorative, no semantic meaning (use sparingly) |
| `action` | Clickable/tappable elements with changing states |
| `express` | Brand messaging and values |
| `feedback` | Status updates or response to actions |
| `neutral` | Core elements with no specific meaning |

### Tone
| Tone | Meaning | Associated Color |
|---|---|---|
| `empower` | Sturdy, refined | Orange |
| `critical` | Negative/destructive outcome | Red |
| `info` | Neutral information | Gray |
| `insight` | Deep understanding, relevant data | Teal |
| `inspire` | Possibility, confidence, excitement | Purple |
| `success` | Positive outcome, completion | Green |
| `trust` | Security, reliability | Blue |
| `warning` | Cautionary message | Yellow |

### Emphasis
| Emphasis | Description |
|---|---|
| `neutral` | Baseline, AAA-accessible |
| `soft` | Slight visual emphasis, quiet distinction |
| `subtle` | Lower contrast, reduces emphasis (AA or higher) |
| `hero` | Bold, bright, vibrant — calls attention to key actions |
| `strong` | High-contrast, adds emphasis (AAA-level) |
| `impact` | Background elements that add visual weight |

### Dark Mode Context
| Term | Description |
|---|---|
| `elevated` | Background surface that is raised/floating — uses drop shadow in light mode, background color in dark mode |
| `onHero` | Foreground element on any hero background |
| `onImpact` | Foreground element on any impact background |

## Using Design Tokens with PandaCSS

### Reference Syntax (Recommended)

```tsx
// Shorthand reference (omit token category)
<Box css={{ padding: 'loose' }}>Hello World</Box>

// Full path reference (include category with curly braces)
<Box
  css={{
    padding: '{spacing.loose}',
    border: '{borderWidths.default} solid {colors.border.subtle}',
  }}
>
  Hello World
</Box>
```

### Using css() function

```tsx
import { css } from '@/styled-system/css';

<span
  className={css({
    backgroundColor: 'bg.accent.yellow.soft',
    color: 'text.neutral',
    textStyle: 'body-bold',
  })}
>
  Hello World
</span>
```

### Do NOT Use the token() Function

The `token()` function results in an increase of at least **640kb of JavaScript** in your final bundle. It bloats your JavaScript with an unnecessarily large token map. Instead, pre-generate styles at build time using:

- `css` prop for styling
- `cva` and `sva` for variant styles

### Tier 3 Component Tokens (Updated April 2025)

The `ct()` function is no longer available. Component tokens now use only semantic tokens. This results in less JavaScript shipped and follows official PandaCSS token implementation.

## Responsive Variants Plugin

A PandaCSS plugin for responsive `cva` variants:

```tsx
import { crv, cva } from '@/styled-system/css';

const styles = cva({
  variants: {
    ...crv('variant', {
      primary: { bg: 'blue.500' },
      secondary: { bg: 'gray.500' },
      destructive: { bg: 'red.500' },
    }),
  },
});
```

Usage:

```tsx
<Component variant="primary" />
<Component variant={{ base: 'secondary', lg: 'primary' }} />
```
