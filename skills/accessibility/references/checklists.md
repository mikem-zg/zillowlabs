# Design & Engineering Checklists

Zillow's internal accessibility checklists for designers and engineers. Complete these during the design process and before engineering handoff.

## Design Process Checklist

Complete this checklist early to save time and avoid redesigning later.

### Color & Contrast
- [ ] Check color contrast: all text and essential UI elements (icons, input borders, informative graphics) meet WCAG AA contrast ratios. Use a contrast checking tool.
- [ ] Ensure meaning doesn't rely solely on color: use additional indicators (text, icons, patterns) to convey information, status, or required actions. Data visualizations (graphs, charts, diagrams) are the most common violators.

### Layout & Text
- [ ] Use real text, not images of text: avoid images of text unless essential (like logos) or customizable by the user. Otherwise, users can't enlarge, recolor, select, or read text aloud with assistive technology. This also ensures designs work when users adjust text spacing.
- [ ] Ensure clear link purpose: write link text that clearly describes the link's destination or function. Bonus: understandable even out of context.
- [ ] Design for text resizing: periodically ensure designs accommodate text resizing without loss of content or functionality.
- [ ] Design for responsive viewports: ensure layouts adapt to various screen sizes, including up to 400% zoom on desktop browsers. Be cautious of sticky elements (nav bars, headers/footers) — past a certain zoom level, they cover most screen content. A common solution: make sticky elements non-sticky past a certain zoom percentage.

### Navigation
- [ ] Ensure consistent navigation & help: maintain the same relative order for navigation links across multiple pages. Place repeated help mechanisms in the same relative location.
- [ ] Provide multiple page access methods (web): ensure pages can be found in more than one way (navigation, search, sitemap), except for steps within a process.
- [ ] Specify document language (web): ensure the primary language of the page is defined in code. In Figma, annotate the language and inform engineers.

### Multimedia (where applicable)
- [ ] Provide captions and transcripts for video/audio content
- [ ] Ensure auto-playing media can be paused or stopped

## Engineering Handoff Checklist

Final pass to catch remaining issues before engineering build.

### Page Structure
- [ ] Define page titles (web): for new pages, designate informative page titles (browser tab text). Follow existing guidelines from current pages per brand/content design.
- [ ] Define headings: use headings (H1, H2, H3, etc.) to structure page content logically. Document the heading level for all section titles and key components (tables, carousels, etc.). More than one H1 is not recommended but allowed if appropriate. Headings describe page sections — H3 should be a subsection of H2.

### Interaction (keyboard based)
- [ ] Include "skip links" where appropriate (web): for pages with repeating navigation/header blocks, include a "Skip to main content" link for keyboard users. A common Zillow pattern is a hidden link to skip navigation sections.
- [ ] Define keyboard focus order (only when applicable): only complete this if your design requires a focus order different than industry standards, or when documenting complex interactions. Specify the logical tab order, noting instances where focus order differs from visual layout. Non-standard focus orders can cause confusion and lengthen the build process.
- [ ] Specify custom keyboard interactions: if custom components (sliders, custom menus, etc.) have interactions not covered by common patterns, document expected keyboard behavior (arrow keys, Enter, Space, Esc). Reference existing ARIA patterns. Use Constellation and Accessibility Office Hours for feedback.

### Images
- [ ] Provide image alt text for informative images: keep to 1-2 succinct sentences. Describe based on purpose, not just facts ("5 out of 5 star rating" not "stars"). Don't include "image of" or "picture of" — screen readers identify graphics automatically. Reference the Constellation UX Writing Guide.
- [ ] Mark decorative images: clearly mark images that don't contribute information so developers omit alt text (alt="").
- [ ] Label icon buttons: provide clear, concise text labels for all icon-only buttons (can be visually hidden). Mark icon-only buttons as informative or decorative.
- [ ] Ensure consistent component identification: use consistent labels, icons, and alt text for components performing the same function across pages.

## Figma Annotation Guidance

Accessibility annotations communicate implementation requirements to engineers. Without explicit notes, accessibility efforts won't make it into the final product.

### What to Annotate
- Alt text for informative images
- Keyboard focus order (only when non-standard)
- Heading structure (H1, H2, H3 hierarchy)
- Custom keyboard interactions
- ARIA attributes needed
- Skip link placement
- Language attributes for mixed-language content

### How to Annotate
Duplicate screens into a dedicated accessibility section in your handoff file. Keep annotations organized so engineers can find them.

### Method 1: Accessibility Annotation Component
1. Create a designated accessibility section or page
2. Duplicate screens into the dedicated section
3. Insert an instance of the Accessibility Annotation component from the Shared Foundations library (search "AccessibilityAnnotation" in Figma Assets panel)
4. Use the properties panel to specify: who the annotation is for, which checklist category it covers, and alt text

### Method 2: Built-In Figma Annotations
1. Create a designated accessibility section or page
2. Duplicate screens
3. Click the dropdown arrow next to the "Comment" icon in the toolbar (keyboard shortcut: "Y")
4. Select the element/frame to annotate
5. Click "No category" dropdown and select "Accessibility"
6. Figma annotations show up automatically in Dev Mode — verify your engineers have Dev Mode access

### Method 3: Figma Comments, Stickies, or Text
1. Create a designated accessibility section
2. Duplicate screens
3. Add comments, stickies, or text annotations
4. Ensure engineers can see and access them

### Key Principle
The specific annotation method is flexible. What matters is that you annotate your designs and your engineers have access to them.
