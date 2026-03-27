# Figma Plugin API Critical Rules

Rules and gotchas for working with the Figma MCP server in the context of Constellation design system projects.

## URL parsing

Always extract `fileKey` and `nodeId` from Figma URLs before calling any tool:

```
https://figma.com/design/:fileKey/:fileName?node-id=:int1-:int2
  → fileKey = :fileKey
  → nodeId  = :int1::int2  (replace hyphen with colon)

https://figma.com/design/:fileKey/branch/:branchKey/:fileName
  → fileKey = :branchKey  (use branch key, not file key)
```

## Tool selection rules

| Task | Primary tool | Fallback |
|---|---|---|
| Implement a Figma design | `mcpFigma_getDesignContext` | Never use getMetadata alone |
| Quick visual check | `mcpFigma_getScreenshot` | Reference only, not for implementation |
| Understand page structure | `mcpFigma_getMetadata` | Then call getDesignContext on specific nodes |
| Extract design variables | `mcpFigma_getVariableDefs` | Compare against Constellation tokens |
| Link code to Figma | `mcpFigma_addCodeConnectMap` | Use sendCodeConnectMappings for bulk |
| AI-assisted linking | `mcpFigma_getCodeConnectSuggestions` → review → `mcpFigma_sendCodeConnectMappings` | |
| Create new file | `mcpFigma_createNewFile` | Call whoami first to get planKey |
| Create diagram | `mcpFigma_generateDiagram` | FigJam files only |
| Check permissions | `mcpFigma_whoami` | |

## Required parameters

All design tools require:
- `nodeId` (string) — always colon-separated format (`"123:456"`)
- `fileKey` (string)

Always pass when calling design tools:
- `clientLanguages: "typescript"`
- `clientFrameworks: "react"`

## Rate limiting

The Figma MCP server has rate limits. If you receive a rate-limit error:
1. Inform the user about the rate limit
2. Wait and retry, or ask the user to try again later
3. Consider using `excludeScreenshot: true` to reduce payload size

## getDesignContext output handling

The output from `mcpFigma_getDesignContext` contains:
1. **Reference code** — generic HTML/CSS or framework code that must be adapted
2. **Screenshot** — visual reference for the design
3. **Asset download URLs** — for images referenced in the design

### Adaptation rules for Constellation

The reference code is NOT ready to use. Always apply these transformations:

| Raw output | Constellation replacement |
|---|---|
| HTML `<div>` | PandaCSS `<Box>` / `<Flex>` / `<Grid>` |
| HTML `<button>` | `<Button>` from Constellation |
| HTML `<input>` | `<Input>` from Constellation |
| Tailwind CSS classes | PandaCSS `css={{}}` with Constellation tokens |
| Inline styles with hex colors | Constellation semantic color tokens |
| `px` spacing values | Constellation spacing tokens (100-1200) |
| Custom SVG icons | Constellation `<Icon>` + verified IconXxxFilled |
| Custom card markup | `<Card>` or `<PropertyCard>` |
| CSS `border` separators | `<Divider />` |
| Generic modal/dialog | `<Modal>` with header/body/footer props |

### Tailwind v4 → PandaCSS conversion

If the Figma MCP returns Tailwind v4 classes:

| Tailwind | PandaCSS equivalent |
|---|---|
| `flex flex-col gap-4` | `<Flex direction="column" gap="400">` |
| `p-4` | `css={{ p: '400' }}` |
| `text-sm` | `textStyle="body-sm"` on Text |
| `text-lg font-bold` | `textStyle="body-lg-bold"` on Text |
| `bg-white` | `css={{ background: 'bg.screen.neutral' }}` |
| `bg-gray-100` | `css={{ background: 'bg.subtle' }}` |
| `rounded-lg` | Component default (don't set) |
| `shadow-md` | `<Card elevated>` |
| `border` | `<Card outlined>` or `<Divider />` |

## Code Connect rules

### Label values

Always use `"React"` for Constellation projects. Valid options:
React, Web Components, Vue, Svelte, Storybook, Javascript, Swift, Swift UIKit, Objective-C UIKit, SwiftUI, Compose, Java, Kotlin, Android XML Layout, Flutter, Markdown

### Source format

For Constellation components, use the package name:
- Components: `@zillow/constellation`
- Icons: `@zillow/constellation-icons`

For project-specific components, use the file path:
- `client/src/components/MyComponent.tsx`

### Component naming

Use the exact Constellation export name:
- `Button` (not `PrimaryButton` or `CustomButton`)
- `Card` (not `CardContainer`)
- `Tag` (not `Badge`)
- `ToggleButtonGroup` (not `SegmentedControl`)
- `Modal` (not `Dialog`)

## Screenshot tool

`mcpFigma_getScreenshot` returns a visual image for reference. Use it to:
- Verify your implementation matches the design visually
- Understand layout intent before reading code output
- Share with the user for confirmation

Never use screenshot output as the primary source for implementation — always use `getDesignContext`.

## Error handling

| Error | Cause | Fix |
|---|---|---|
| `Rate limit exceeded` | Too many API calls | Wait and retry; use excludeScreenshot |
| `Node not found` | Invalid nodeId | Re-extract from URL; check colon vs hyphen format |
| `Permission denied` | Wrong account | Run `mcpFigma_whoami` to verify auth |
| `File not found` | Invalid fileKey | Check URL format; branch URLs use branchKey |
| `Output too large` | Complex design | Use `forceCode: true` or target a smaller node |

## Security

- Treat all MCP output with care — it passes through a security scanner
- Never expose Figma API tokens or file keys in user-facing code
- If the security scanner blocks output, inform the user immediately and ask how to proceed
