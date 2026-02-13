# Component Decision Tree

When you need a specific UI pattern, use this guide to find the right Constellation component.

## "I need a..." → Use this

---

### Containers / Wrappers

| Pattern | Component | Key Props | Notes |
|---------|-----------|-----------|-------|
| Clickable card | `Card` | `elevated interactive tone="neutral"` | Use for navigation, links, actions — always pair elevated with interactive |
| Static info panel | `Card` | `outlined elevated={false} tone="neutral"` | Use for read-only content, form sections, info displays |
| Minimal container | `Card` | `elevated={false} tone="neutral"` | Subtle container with no visual emphasis |
| Property listing | `PropertyCard` | `saveButton={<PropertyCard.SaveButton />}` | Never use Card for property listings — always PropertyCard |
| Upsell / promo banner | `UpsellBanner` | | For promotional content and feature upsells |
| Toggleable card | `ToggleCard` | | Card with built-in toggle selection state |
| Page section wrapper | `Flex` | `direction="column" gap="800"` | Use for stacking page sections with consistent spacing |
| Generic layout box | `Box` | | Low-level layout primitive from `@/styled-system/jsx` |

---

### Navigation

| Pattern | Component | Key Props | Notes |
|---------|-----------|-----------|-------|
| Page header / nav bar | `Page.Header` | Inside `Page.Root` | Never use Box/Flex for headers |
| Page layout shell | `Page.Root` | | Wraps Header, Content, and footer |
| Page content area | `Page.Content` | `css={{ px: '400', py: '600' }}` | Main content container inside Page.Root |
| Tab navigation | `Tabs.Root` | `defaultSelected="..."` | Always include defaultSelected |
| Tab header | `Tabs.List` + `Tabs.Tab` | `value="..."` | Each tab needs a unique value |
| Tab content | `Tabs.Panel` | `value="..."` | Matches the corresponding Tab value |
| Sidebar navigation | `VerticalNav` | | For vertical navigation menus |
| Expandable sections | `Accordion` | | For collapsible content sections |
| Single collapsible | `Collapsible` | | For a single expand/collapse section |
| Page numbers | `Pagination` | | For navigating through paged data |

---

### Buttons / Actions

| Pattern | Component | Key Props | Notes |
|---------|-----------|-----------|-------|
| Primary action | `Button` | `tone="brand" emphasis="filled" size="md"` | Main CTA on the page |
| Secondary action | `Button` | `tone="brand" emphasis="outlined" size="md"` | Supporting action alongside primary |
| Subtle / tertiary action | `Button` | `tone="brand" emphasis="subtle" size="md"` | Low-emphasis action |
| Text-only action | `TextButton` | | For inline text actions (like "Cancel") |
| Icon-only action | `IconButton` | `size="md"` | For actions represented by a single icon |
| Button with icon | `Button` | `icon={<IconXFilled />} iconPosition="start"` | Never wrap icon+text in Flex inside Button |
| Button group | `ButtonGroup` | `aria-label="..."` | For grouping related buttons (e.g., modal footer) |
| Close / dismiss | `CloseButton` | | For closing modals, alerts, banners |
| Trigger for dropdown | `TriggerButton` | | Opens a dropdown or popover |
| Trigger text link | `TriggerText` | | Text-styled trigger for dropdowns |
| Unstyled button | `UnstyledButton` | | For fully custom button appearances |

---

### Forms / Input

| Pattern | Component | Key Props | Notes |
|---------|-----------|-----------|-------|
| Text input | `Input` | `size="md"` | Basic text input field |
| Labeled text input | `LabeledInput` | `label="..." size="md"` | Input with built-in label, error, and help text |
| Input with prefix/suffix | `AdornedInput` | | For inputs with icons, currency symbols, etc. |
| Multi-line text | `Textarea` | | For longer text content |
| Dropdown select | `Select` | `size="md"` | Native-style select dropdown |
| Searchable select | `Combobox` | | For filterable dropdown lists |
| Data-driven select | `DataSelect` | | Select powered by data arrays |
| Dropdown with menu | `DropdownSelect` | | Select with custom menu rendering |
| Checkbox | `Checkbox` | | Single checkbox |
| Checkbox group | `FieldSet` + `Checkbox` | | Multiple related checkboxes |
| Radio buttons | `Radio` | | Single radio inside a FieldSet |
| Toggle switch | `Switch` | | For on/off boolean settings |
| Range slider | `Range` | | For numeric range selection |
| Slider | `Slider` | | For single-value sliding selection |
| Date input | `DateInput` | | Text input for dates |
| Date picker | `DatePicker` | | Calendar-based date selection |
| Show/hide content | `ShowHide` | | For expandable form sections |
| Character counter | `ShowHideWordCount` | | Input with word/character count |
| Form wrapper | `Form` | | Wraps form elements |
| Form field wrapper | `FormField` | | Wraps individual form fields with label/error |
| Form actions area | `FormActions` | | Container for form submit/cancel buttons |
| Form help text | `FormHelp` | | Helper text below form fields |
| Fieldset wrapper | `FieldSet` | | Groups related form controls with a Legend |
| Field label | `Label` | | Label for form controls |
| Fieldset label | `Legend` | | Label for a FieldSet |
| Labeled control | `LabeledControl` | | Generic labeled wrapper for any control |

---

### Selection (single, multi, segmented)

| Pattern | Component | Key Props | Notes |
|---------|-----------|-----------|-------|
| Single select (e.g., price, beds) | `ToggleButtonGroup` + `ToggleButton` | `value onChange` | For mutually exclusive button-style choices |
| Segmented control | `SegmentedControl` | `value onChange` | For 2-5 segmented options (Buy/Rent/Sold) |
| Multi-select filterable | `Combobox` | | Preferred for multi-select with search |
| Multi-select checkboxes | `CheckboxGroup` | | For visible multi-select options |
| Filter chips | `ChipGroup` + `FilterChip` | | For toggleable filter tags |
| Filter with dropdown | `FilterChipWithMenu` | | Filter chip that opens a dropdown |
| Removable selection tag | `InputChip` | | For displaying selected items that can be removed |
| Action chip | `AssistChip` | | For suggested actions |
| Dropdown menu | `Menu` | | For action menus triggered by a button |

---

### Feedback (alerts, toasts, loading)

| Pattern | Component | Key Props | Notes |
|---------|-----------|-----------|-------|
| Inline alert | `Alert` | `tone="positive" / "caution" / "critical"` | For page-level or section-level messages |
| Banner notification | `Banner` | | For persistent top-of-page messages |
| Toast notification | `Toast` | Inside `ToastProvider` | For temporary success/error messages |
| Inline field feedback | `InlineFeedback` | | For form field validation messages |
| Tooltip | `Tooltip` | | For hover information on icons/elements |
| Popover | `Popover` | | For rich content on click/hover |
| Loading spinner | `Spinner` | | For inline loading indicators |
| Loading overlay | `LoadingMask` | | For full-section loading overlays |
| Progress bar | `ProgressBar` | | For determinate progress indication |
| Progress indicator | `Progress` | | For general progress display |
| Step progress | `ProgressStepper` | | For multi-step process tracking |
| Skeleton placeholder | `Gleam` | | For content loading placeholders |

---

### Overlays (modal, popover, tooltip, menu)

| Pattern | Component | Key Props | Notes |
|---------|-----------|-----------|-------|
| Dialog / modal | `Modal` | `body={...} dividers header footer size="md"` | Content must go in body prop, never children |
| Modal close button | `Modal.Close` | | Wrap cancel buttons in this |
| Info tooltip | `Tooltip` | | For brief hover text |
| Rich popover | `Popover` | | For interactive content on click |
| Action menu | `Menu` | | For dropdown action lists |
| Dropdown list | `Dropdown` | | For dropdown content panels |

---

### Data Display (table, list, tags)

| Pattern | Component | Key Props | Notes |
|---------|-----------|-----------|-------|
| Data table | `Table.Root` | | Wrapper for table structure |
| Table header row | `Table.Header` | | Contains header cells |
| Table body | `Table.Body` | | Contains data rows |
| Table row | `Table.Row` | | Individual table row |
| Table cell | `Table.Cell` | | Individual data cell |
| Table header cell | `Table.HeaderCell` | | Column header cell |
| Ordered/unordered list | `List` | | Semantic list component |
| Icon + text layout | `MediaObject` | | For avatar/icon alongside text content |
| Label / badge | `Tag` | `size="sm" tone="blue"` | Never use custom Box styling for labels |
| Star rating | `RatingStars` | | For displaying star ratings |
| Labeled star rating | `LabeledRatingStars` | | Star rating with label text |
| Numeric rating | `NumberRating` | | For numeric score display |
| Date/time display | `DateTimeBlock` | | For formatted date/time |
| Calendar view | `Calendar` | | For calendar display |

---

### Typography

| Pattern | Component | Key Props | Notes |
|---------|-----------|-----------|-------|
| Page headline (1-2 per screen max) | `Heading` | `textStyle="heading-lg"` | Reserve for true page titles only |
| Section title | `Text` | `textStyle="body-lg-bold"` | Use Text, not Heading, for section titles |
| Card title | `Text` | `textStyle="body-bold"` | Use Text for card-level titles |
| Body text | `Text` | `textStyle="body"` | Default body copy |
| Subtle / description text | `Text` | `textStyle="body" css={{ color: 'text.subtle' }}` | For secondary descriptions |
| Fine print / hints | `Text` | `textStyle="body-sm" css={{ color: 'text.subtle' }}` | For helper text, timestamps |
| Paragraph | `Paragraph` | | For block-level paragraph text |
| Link text | `Anchor` | | For inline links |
| Search highlight | `Highlight` / `Highlighter` | | For highlighting search matches |
| Label | `Label` | | For form field labels |
| Visually hidden text | `VisuallyHidden` | | For screen-reader-only text |

---

### Layout

| Pattern | Component | Key Props | Notes |
|---------|-----------|-----------|-------|
| Flex container | `Flex` | `direction gap align justify` | From `@/styled-system/jsx` |
| Grid container | `Grid` | `columns gap` | From `@/styled-system/jsx` |
| Generic box | `Box` | | From `@/styled-system/jsx` |
| Visual separator | `Divider` | | Never use CSS borders — always Divider |
| Fixed-ratio container | `AspectRatio` | `ratio={16/9}` | For images/video at specific ratios |
| Spacer | `Spacer` | | Flexible space in flex layouts |
| Horizontal stack | `HStack` | `gap="..."` | Shorthand for horizontal Flex |
| Vertical stack | `VStack` | `gap="..."` | Shorthand for vertical Flex |
| Wrap layout | `Wrap` | `gap="..."` | For flowing/wrapping items |
| Full-width bleed | `Bleed` | | For content that breaks out of parent padding |
| Content slot | `Slot` | | For flexible content composition |
| Page structure | `Layout` | | For overall page layout structure |

---

### Media

| Pattern | Component | Key Props | Notes |
|---------|-----------|-----------|-------|
| Icon | `Icon` | `size="sm" / "md" / "lg" / "xl"` | Always wrap icon components in Icon |
| Duo-color icon | `DuoColorIcon` | | For two-tone decorative icons |
| Tone-colored icon | `ToneIcon` | | For icons with semantic tone colors |
| User avatar | `Avatar` | | For user profile images |
| Image | `Image` | | For responsive images |
| Image carousel | `PhotoCarousel` | | For property photo galleries |
| Generic carousel | `Carousel` | | For any content carousel |

---

### Zillow-Specific Patterns

| Pattern | Component | Key Props | Notes |
|---------|-----------|-----------|-------|
| Property listing card | `PropertyCard` | `saveButton={<PropertyCard.SaveButton />} elevated interactive` | Never use Card for listings |
| Property save button | `PropertyCard.SaveButton` | `onClick isSaved` | Always include on PropertyCard |
| Property photo | `PropertyCard.Photo` | `src alt` | For listing photos |
| Property badge | `PropertyCard.Badge` | `tone="accent"` | For "New", "Open House", etc. |
| Property details | `PropertyCard.HomeDetails` | `data={[{value, label}]}` | For beds/baths/sqft display |
| Zillow logo (desktop) | `ZillowLogo` | `css={{ height: '24px', width: 'auto' }}` | Must be exactly 24px on desktop |
| Zillow logo (mobile) | `ZillowLogo` | `css={{ height: '16px', width: 'auto' }}` | Must be exactly 16px on mobile |
| Zillow home logo | `ZillowHomeLogo` | | Alternative logo with house icon |
| Upsell card | `Upsell` | | For feature upsell content |
| Upsell banner | `UpsellBanner` | | For promotional banners |

---

## Quick Decision Shortcuts

**"Should I use Card or PropertyCard?"**
→ If it displays a property listing: **PropertyCard**. For everything else: **Card**.

**"Should I use Heading or Text?"**
→ Is it the main page title (only 1-2 per screen)? **Heading**. Everything else: **Text** with a textStyle variant.

**"Should I use Button or ToggleButtonGroup?"**
→ Does clicking it perform an action (submit, navigate, open)? **Button**. Does it select a value from options? **ToggleButtonGroup** or **SegmentedControl**.

**"Should I use Box or Flex?"**
→ Need to stack or align children? **Flex**. Just need a generic wrapper? **Box**. Need a grid? **Grid**.

**"Should I use CSS border or Divider?"**
→ Always **Divider**. Never CSS borders for visual separators.

**"Should I use Modal children or body prop?"**
→ Always the **body** prop. Never pass content as children.

**"Icon: color prop or css prop?"**
→ Always **css** prop for semantic token colors: `css={{ color: 'text.subtle' }}`. The `color` prop doesn't resolve token paths.
