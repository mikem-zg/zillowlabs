# Figma-to-Handoff Workflow

When a Figma URL or file is provided alongside the handoff request, use this workflow to extract design context before running the standard handoff phases.

## Prerequisites

- Figma MCP server must be connected
- User must provide a Figma URL in the format: `https://figma.com/design/:fileKey/:fileName?node-id=:nodeId`

## Step 1: Extract Design Context

```
get_design_context(
  fileKey: extracted from URL,
  nodeId: extracted from URL,
  clientFrameworks: "react",
  clientLanguages: "typescript"
)
```

This returns:
- Component structure as code
- Component names and hierarchy
- Props and styling information
- Download URLs for any image assets referenced

**Use the returned code as the primary source for component mapping.**

## Step 2: Extract Design Tokens

```
get_variable_defs(
  fileKey: extracted from URL,
  nodeId: extracted from URL,
  clientFrameworks: "react",
  clientLanguages: "typescript"
)
```

This returns:
- Color variables (e.g., `icon/default/secondary → #949494`)
- Spacing variables
- Typography variables

**Map these to PandaCSS semantic tokens.**

## Step 3: Check Code Connect Mappings

```
get_code_connect_map(
  fileKey: extracted from URL,
  nodeId: extracted from URL
)
```

This returns:
- Mapping of Figma node IDs to code component locations
- Component names in the codebase
- Source file paths

**Use these to verify that Figma components match their code implementations.**

## Step 4: Get Layer Metadata (if needed)

```
get_metadata(
  fileKey: extracted from URL,
  nodeId: extracted from URL,
  clientFrameworks: "react",
  clientLanguages: "typescript"
)
```

This returns:
- XML structure of the Figma node tree
- Layer types, names, positions, sizes

**Use only when you need structural overview before deep-diving into specific nodes.**

## Step 5: Get Screenshot (for reference)

```
get_screenshot(
  fileKey: extracted from URL,
  nodeId: extracted from URL,
  clientFrameworks: "react",
  clientLanguages: "typescript"
)
```

**Use for visual reference only — not as the source for component mapping.**

## Mapping Figma Output to Handoff

After extraction, feed the results into the standard handoff workflow:

1. **Component names** from `get_design_context` → map to Constellation components using `constellation-mapping.md`
2. **Design tokens** from `get_variable_defs` → map to PandaCSS semantic tokens
3. **Layer structure** from `get_metadata` → use as the component tree in the handoff doc
4. **Code Connect** from `get_code_connect_map` → verify existing code implementations match the design

## Handling Tailwind v4 Utilities

If Figma MCP returns Tailwind CSS v4/v4.1 utilities that don't exist in v3.x, convert them to inline styles:

| V4 Utility | Inline Style Equivalent |
|-----------|------------------------|
| `mask-alpha`, `mask-luminance` | `style={{ maskMode: "alpha" \| "luminance" }}` |
| `mask-intersect`, `mask-add` | `style={{ maskComposite: "intersect" \| "add" }}` |
| `mask-[url(...)]` | `style={{ maskImage: "url(...)" }}` |
| `text-shadow-*` | `style={{ textShadow: "..." }}` |
| `wrap-balance`, `wrap-pretty` | `style={{ textWrap: "balance" \| "pretty" }}` |
| `drop-shadow-[color]` | `style={{ filter: "drop-shadow(... [color])" }}` |
| 3D transforms | `style={{ transform: "rotateX(...)" }}` |
| `@container` queries (`@sm:`, `@lg:`) | Replace with responsive breakpoints (`sm:`, `md:`, `lg:`) |

## Error Handling

| Error | Recovery |
|-------|----------|
| Figma MCP rate limit | Wait and retry, or skip Figma extraction and work from code only |
| Node not found | Ask user to verify the URL and node ID |
| No Code Connect mappings | Proceed with manual Constellation mapping |
| Security scanner blocks output | Inform user immediately, ask how to proceed |
