# IA Research Methods

## Card Sorting

A research technique where participants organize labeled content items into groups that make sense to them. Reveals natural mental models and categorization patterns.

### Types

| Type | Participants Create Groups? | Pre-defined Categories? | Best For |
|------|-----------------------------|------------------------|----------|
| **Open** | Yes — name their own groups | No | Generating new IA from scratch |
| **Closed** | No — sort into given groups | Yes | Validating proposed categories |
| **Hybrid** | Yes — can also create new groups | Yes — provided as starting point | Refining existing IA |

### Planning a Card Sort

**Step 1: Define scope**
- What content/features are you organizing?
- What level of the hierarchy are you testing? (top-level nav, sub-categories, or content within a category)

**Step 2: Create cards (30-50 recommended)**
- Each card = one content item, feature, or page
- Use neutral, descriptive labels (avoid leading terms)
- Include a brief description if the label is ambiguous
- Avoid duplicate concepts or overlapping items

**Step 3: Recruit participants (15-30)**
- Match your target audience
- 15 participants reveals ~90% of patterns
- Mix of experience levels with your product

**Step 4: Run the sort**
- In-person: physical index cards on a table
- Remote: OptimalSort, UXtweak, Maze, Miro
- Time: 15-30 minutes per participant
- Instruct: "Group these in a way that makes sense to you"

**Step 5: Analyze results**

| Analysis Method | What It Shows |
|-----------------|---------------|
| **Similarity matrix** | How often items were grouped together (0-100%) |
| **Dendrogram** | Hierarchical clustering — which items form natural groups |
| **Category frequency** | Most common group names participants created |
| **Outlier analysis** | Items that were sorted inconsistently — unclear or cross-cutting |

### Interpreting Results

- Items grouped together 70%+ of the time → strong candidates for same category
- Items grouped together 30-70% → may need cross-linking or multiple paths
- Items grouped together <30% → likely belong in different sections
- If participants create wildly different groups → your content may not have clear natural categories (consider faceted navigation)

### Common Pitfalls

- Too many cards (50+) causes fatigue and sloppy grouping
- Cards that are too vague get sorted randomly
- Cards that are too specific don't reveal higher-level patterns
- Running only one sort type — combine open (generate) and closed (validate)

## Tree Testing

The evaluative counterpart to card sorting. Validates whether users can find specific content within a proposed IA structure. Tests findability in isolation — no visual design, no search, just the hierarchy.

### Planning a Tree Test

**Step 1: Build the tree**
- Text-only hierarchy of your proposed IA
- Include 3-5 levels of depth
- Use the same labels you plan to use in production

**Step 2: Write tasks (8-12 per test)**
- Each task = "Where would you find [specific content]?"
- Cover different areas of the tree
- Mix easy (top-level) and hard (deep) tasks
- Use user language, not your labels

Example tasks:
- "Find out how much your home is worth"
- "Schedule a tour of a property you're interested in"
- "Change your email notification preferences"
- "See homes you've saved recently"

**Step 3: Recruit participants (50+ recommended)**
- Larger sample than card sorting because results are quantitative
- Match your target audience

**Step 4: Run the test**
- Tools: Treejack (Optimal Workshop), UXtweak
- Time: 10-15 minutes per participant
- Participants navigate the tree to complete each task

### Key Metrics

| Metric | What It Measures | Target |
|--------|-----------------|--------|
| **Success rate** | % who found the correct answer | 80%+ |
| **Directness** | % who found it without backtracking | 60%+ |
| **Time to complete** | Seconds to reach an answer | Varies by depth |
| **First click** | Where users start looking | Should match correct path |
| **Path analysis** | Common wrong paths taken | Identifies confusing branches |

### Interpreting Results

- Task success <60% → structural problem — content is in the wrong place or label is unclear
- High success but low directness → users eventually find it but the path isn't intuitive
- Wrong first clicks → the label is misleading or the category doesn't match the mental model
- Multiple tasks failing in the same branch → that section needs restructuring

## Content Audit

Inventory and evaluate all existing content to understand what you have before organizing it.

### Process

**Step 1: Inventory**
- Crawl or manually list every page/content item
- Record: URL, title, content type, last updated, owner, word count

**Step 2: Evaluate quality**

| Assessment | Question | Score |
|------------|----------|-------|
| **Accuracy** | Is the information correct and current? | 1-5 |
| **Completeness** | Does it cover the topic adequately? | 1-5 |
| **Usefulness** | Does it serve a user need? | 1-5 |
| **Findability** | Can users get to it? | 1-5 |
| **Consistency** | Does it follow style and format standards? | 1-5 |

**Step 3: Decide action**

| Action | When |
|--------|------|
| **Keep as-is** | High quality, still relevant |
| **Update** | Good topic, outdated content |
| **Merge** | Multiple pages covering the same topic |
| **Archive** | Once useful, no longer relevant |
| **Delete** | Redundant, incorrect, or zero-traffic |

**Step 4: Map gaps**
- What topics are users searching for that don't exist?
- What competitor content do you lack?
- What user tasks aren't supported by current content?

## Competitive Analysis (IA-Focused)

Evaluate how competitors organize similar content to identify patterns and opportunities.

### What to Analyze

| Element | What to Document |
|---------|-----------------|
| **Primary navigation** | Labels, number of items, grouping logic |
| **Search** | Filters, facets, auto-suggest, results layout |
| **Content hierarchy** | How deep is the structure? How many levels? |
| **Labeling** | What terms do they use? How consistent? |
| **Mobile adaptation** | How does nav change on mobile? |
| **Unique patterns** | What do they do differently? What works well? |

### Analysis Framework

For each competitor, score:
1. **Learnability** — How quickly can a new user orient themselves?
2. **Efficiency** — How many clicks/taps to complete key tasks?
3. **Findability** — Can users find specific content easily?
4. **Scalability** — Does the IA accommodate their content volume?
5. **Consistency** — Are patterns predictable across sections?

### Output

Create a comparison matrix showing:
- Common patterns across competitors (industry conventions)
- Differentiators (unique approaches worth considering)
- Weaknesses (opportunities for your product)
- User expectations (what patterns users are trained on)
