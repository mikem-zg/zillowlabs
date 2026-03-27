# Figma → Constellation Mapping Table

Complete element-by-element mapping from Figma design output to Constellation React components.

## Layout

| Figma element | Constellation code | Notes |
|---|---|---|
| Frame (horizontal, gap) | `<Flex direction="row" gap="TOKEN">` | Import from `@/styled-system/jsx` |
| Frame (vertical, gap) | `<Flex direction="column" gap="TOKEN">` | Use for text stacking (Text is inline) |
| Frame (grid layout) | `<Grid columns={N} gap="TOKEN">` | Import from `@/styled-system/jsx` |
| Frame (generic container) | `<Box css={{...}}>` | Import from `@/styled-system/jsx` |
| Page wrapper | `<Page.Root>` + `<Page.Content>` | Add `fluid` for dashboards/full-width |
| Page header (non-sticky) | `<Page.Header>` inside `<Page.Root>` | Simple pages only |
| Page header (sticky) | `<Box css={{ position: 'sticky', display: 'flow-root', top: 0, zIndex: 10 }}>` with `<Flex>` inside | NEVER put sticky on Page.Header directly |
| Divider / separator / line | `<Divider />` or `<Divider tone="muted-alt" />` | NEVER use CSS border |
| Spacer | `<Spacer />` or gap tokens on Flex | Prefer gap over Spacer |

## Typography

| Figma text style | Constellation code | When to use |
|---|---|---|
| Heading / title (large) | `<Heading textStyle="heading-lg">` | 1-2 per screen max |
| Heading (medium) | `<Heading textStyle="heading-md">` | Max for professional apps |
| Section title | `<Text textStyle="body-lg-bold">` | NOT Heading — use Text |
| Card title | `<Text textStyle="body-bold">` | Inside cards |
| Body text | `<Text textStyle="body">` | Default readable text |
| Description / subtitle | `<Text textStyle="body" css={{ color: 'text.subtle' }}>` | Secondary info |
| Small / fine print | `<Text textStyle="body-sm" css={{ color: 'text.subtle' }}>` | Hints, disclaimers |
| Paragraph block | `<Paragraph>` | Multi-line body text |
| Link text | `<Anchor href="...">` | Inline links |

## Buttons

| Figma element | Constellation code | Notes |
|---|---|---|
| Primary button (filled) | `<Button emphasis="filled" tone="brand">` | Professional: add `size="sm"` |
| Secondary button (outlined) | `<Button emphasis="outlined" tone="neutral">` | For secondary actions |
| Text-only button | `<TextButton>` | Tertiary / inline actions |
| Icon + text button | `<Button icon={<IconXxxFilled />} iconPosition="start">Label</Button>` | Use sparingly |
| Icon-only button | `<IconButton title="Label" tone="neutral" emphasis="bare" size="md" shape="square"><Icon><IconXxxFilled /></Icon></IconButton>` | Always use IconButton, not Button |
| Close button | `<CloseButton />` | Built-in close behavior |
| Button group | `<ButtonGroup aria-label="...">` | Groups related buttons |

## Forms

| Figma element | Constellation code | Notes |
|---|---|---|
| Text input | `<Input>` | Professional: `size="sm"` |
| Search input | `<AdornedInput>` with icon adornment | |
| Dropdown / select | `<Select>` | Professional: `size="sm"` |
| Multi-select / autocomplete | `<Combobox>` | Preferred for multi-select |
| Checkbox | `<Checkbox>` | Inside `<LabeledControl>` for labels |
| Radio button | `<Radio>` | Inside `<LabeledControl>` for labels |
| Toggle switch | `<Switch>` | |
| Textarea | `<Textarea>` | |
| Slider / range | `<Slider>` or `<Range>` | |
| Date picker | `<DatePicker>` or `<DateInput>` | |
| Form group | `<FormField>` wrapping label + input | |
| Form wrapper | `<Form>` | Handles submission |

## Cards

| Figma element | Constellation code | Notes |
|---|---|---|
| Property listing card | `<PropertyCard saveButton={<PropertyCard.SaveButton />}>` | REQUIRED: saveButton prop |
| Clickable card | `<Card elevated interactive tone="neutral">` | elevated + interactive together |
| Static info card | `<Card outlined elevated={false} tone="neutral">` | outlined, no elevation |
| Minimal card | `<Card elevated={false} tone="neutral">` | No visual emphasis |
| Upsell banner | `<UpsellBanner>` or `<Upsell>` | Marketing callouts |

## Navigation & Tabs

| Figma element | Constellation code | Notes |
|---|---|---|
| Tab bar | `<Tabs.Root defaultSelected="tab1"><Tabs.List>...</Tabs.List></Tabs.Root>` | REQUIRED: defaultSelected |
| Tab item | `<Tabs.Tab value="id">Label</Tabs.Tab>` | |
| Tab panel | `<Tabs.Panel value="id">Content</Tabs.Panel>` | |
| Accordion / collapsible | `<Accordion>` or `<Collapsible>` | |
| Side navigation | `<VerticalNav>` | |
| Pagination | `<Pagination>` | |
| Breadcrumbs | Manual with `<Anchor>` + `<Divider>` | No dedicated breadcrumb component |

## Icons

| Figma element | Constellation code | Notes |
|---|---|---|
| Any icon | `<Icon size="md"><IconXxxFilled /></Icon>` | ALWAYS Filled variant; ALWAYS verify name |
| Icon with semantic color | `<Icon size="md" css={{ color: 'icon.neutral' }}><IconXxxFilled /></Icon>` | Use css prop, not color prop |
| Icon (fallback color) | `<Icon size="md" style={{ color: 'var(--color-icon-subtle)' }}>` | When theme injection unavailable |
| Empty state icon (pro) | `<Icon size="xl"><IconXxxDuotone /></Icon>` | Professional apps only: Duotone for empty states |

### Icon size tokens

| Token | Pixels | Use |
|---|---|---|
| `sm` | 16px | Inside tables, tags, compact UI |
| `md` | 24px | Default for most contexts |
| `lg` | 32px | Feature callouts |
| `xl` | 44px | Large highlights (prefer over illustrations for simple concepts) |

## Selection & Toggles

| Figma element | Constellation code | Notes |
|---|---|---|
| Segmented control | `<ToggleButtonGroup><ToggleButton>A</ToggleButton><ToggleButton>B</ToggleButton></ToggleButtonGroup>` | SegmentedControl does NOT exist |
| Chip / filter chip | `<FilterChip>` or `<FilterChipWithMenu>` | |
| Chip group | `<ChipGroup>` | |
| Assist chip | `<AssistChip>` | |

## Tags & Badges

| Figma element | Constellation code | Notes |
|---|---|---|
| Status badge / label | `<Tag tone="green/warning/red/gray/blue/info/success/critical">` | No standalone Badge component |
| Tag with icon | `<Tag icon={<IconXxxFilled />}>Label</Tag>` | Default size ONLY (sm won't render icon) |
| Small tag (text only) | `<Tag size="sm" tone="blue">Label</Tag>` | No icon support at sm |
| Property badge | `<PropertyCard.Badge tone="accent">` | Inside PropertyCard only |

## Feedback & Overlays

| Figma element | Constellation code | Notes |
|---|---|---|
| Modal / dialog | `<Modal size="md" header={...} body={...} footer={...} dividers>` | Content in body prop, NEVER children |
| Alert / message bar | `<Alert>` or `<Banner>` | |
| Toast notification | `<Toast>` inside `<ToastProvider>` | |
| Tooltip | `<Tooltip>` | |
| Popover | `<Popover>` | |
| Inline validation | `<InlineFeedback>` | |

## Progress & Loading

| Figma element | Constellation code | Notes |
|---|---|---|
| Spinner | `<Spinner>` | |
| Skeleton / shimmer | `<Gleam>` | |
| Progress bar | `<ProgressBar>` | |
| Step indicator | `<ProgressStepper>` | |
| Loading overlay | `<LoadingMask>` | |

## Media

| Figma element | Constellation code | Notes |
|---|---|---|
| Avatar / user photo | `<Avatar>` | |
| Image | `<Image>` | |
| Photo carousel | `<PhotoCarousel>` | |
| Carousel | `<Carousel>` | |
| Rating stars | `<RatingStars>` or `<LabeledRatingStars>` | |

## Branding

| Figma element | Constellation code | Notes |
|---|---|---|
| Zillow logo | `<ZillowLogo style={{ height: '24px', width: 'auto' }} />` | Desktop: 24px, Mobile: 16px |
| Zillow home logo | `<ZillowHomeLogo>` | |

## Color token mapping

| Figma color / hex | Constellation token | CSS variable |
|---|---|---|
| `#FFFFFF` (white bg) | `bg.screen.neutral` | `--colors-bg-screen-neutral` |
| `#F7F7F7` (light gray bg) | `bg.subtle` | `--colors-bg-subtle` |
| `#111116` (text) | `text.primary` | `--colors-text-primary` |
| `#0041D9` (blue action) | `text.action.hero.default` | `--color-icon-action-hero-default` |
| `#6E6E73` (subtle text) | `text.subtle` | `--colors-text-subtle` |
| Icon default gray | `icon.neutral` | `--color-icon-neutral` |
| Icon subtle gray | `icon.subtle` | `--color-icon-subtle` |

## Spacing token mapping

| Figma spacing (px) | Constellation token |
|---|---|
| 4px | `100` |
| 8px | `200` |
| 12px | `300` |
| 16px | `400` |
| 20px | `500` |
| 24px | `600` |
| 32px | `800` |
| 40px | `1000` |
| 48px | `1200` |

## Common Figma → Constellation gotchas

| Figma output | Wrong | Correct |
|---|---|---|
| Shadow on card | Custom CSS box-shadow | `<Card elevated>` (built-in shadow) |
| Border on card | CSS `border: 1px solid` | `<Card outlined>` |
| Rounded corners | `borderRadius: 12px` | Component default (don't override) |
| Color on icon | `<Icon color="blue">` | `<Icon css={{ color: 'token.path' }}>` |
| Text stacking | Adjacent `<Text>` elements | Wrap in `<Flex direction="column">` |
| Logo size | Arbitrary px | 24px desktop / 16px mobile only |
| Badge component | `<Badge>` | `<Tag>` (Badge doesn't exist) |
| SegmentedControl | `<SegmentedControl>` | `<ToggleButtonGroup>` (doesn't exist) |
