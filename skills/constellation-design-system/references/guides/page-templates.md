# Page Templates

Ready-to-use page templates built with Constellation components and design system best practices.

## 404 — Page Not Found

A centered empty-state layout with a spot illustration, heading, subtitle, and a call-to-action button to navigate home.

### Key design decisions
- **Spot illustration** at 160×160px (design system recommends illustrations for empty states, not oversized icons)
- **Centered layout** (centering is appropriate for empty states per design guidelines)
- **Friendly, helpful copy** following UX writing guidelines (sentence case, contractions, active voice)
- **Single primary action** ("Go home") to guide the user back
- **No Card wrapper** — full-page empty states should breathe, not be boxed in
- **Subtitle constrained to ~450px** so it wraps to two balanced lines on desktop

### Template

```tsx
import { Button, Heading, Text } from "@zillow/constellation";
import { Flex } from "@/styled-system/jsx";
import { useLocation } from "wouter";
import MagnifyingGlassIllustration from "@/assets/illustrations/Lightmode/magnifying-glass.svg";

export default function NotFound() {
  const [, navigate] = useLocation();

  return (
    <Flex
      direction="column"
      align="center"
      justify="center"
      gap="400"
      css={{
        minHeight: "60vh",
        width: "100%",
        px: "400",
        py: "800",
      }}
    >
      <img
        src={MagnifyingGlassIllustration}
        alt=""
        style={{ width: 160, height: 160 }}
      />
      <Flex direction="column" align="center" gap="100">
        <Heading level={1} textStyle="heading-lg">
          Page not found
        </Heading>
        <Text
          textStyle="body"
          css={{ color: "text.subtle", textAlign: "center" }}
          style={{ maxWidth: "450px" }}
        >
          We couldn't find the page you're looking for. It may have been moved
          or no longer exists.
        </Text>
      </Flex>
      <Button
        emphasis="filled"
        tone="brand"
        size="md"
        onClick={() => navigate("/")}
      >
        Go home
      </Button>
    </Flex>
  );
}
```

### Anatomy

| Element | Component | Details |
|---------|-----------|---------|
| Illustration | `<img>` with spot SVG | 160×160px, `magnifying-glass.svg` from Lightmode illustrations |
| Heading | `<Heading level={1} textStyle="heading-lg">` | Single page headline |
| Subtitle | `<Text textStyle="body">` | `color: text.subtle`, centered, max-width 450px for 2-line wrap |
| Action | `<Button emphasis="filled" tone="brand" size="md">` | Navigates to home |

### Customization notes
- Swap the illustration for any spot SVG from `@/assets/illustrations/Lightmode/` (see [constellation-illustrations](../../constellation-illustrations/SKILL.md) for the full catalog)
- For dark mode support, conditionally switch between `Lightmode/` and `Darkmode/` illustration paths
- Adjust `minHeight` if the page lives inside a layout that already provides vertical space
- The router hook (`useLocation` from wouter) can be replaced with your project's router (e.g., `useNavigate` from react-router)
