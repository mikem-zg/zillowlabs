---
name: design-review
description: Perform a structured, multi-agent UX review of a feature or interface using simulated design legend personas. Use when reviewing a new feature before merge, after major UX refactors, before public launch, when usability friction is suspected, or during design critiques. Covers mental models, simplicity, usability heuristics, spatial harmony, taste, strategic leverage, and cognitive amplification.
---

# Design Review

Perform a rigorous, structured UX review using seven simulated design legend personas, each with a distinct and non-overlapping lens. This is not a vibes-only critique — it is a structured design audit that produces actionable, scored feedback.

## When to Use

- "Review the UX of this feature"
- "Do a UX review"
- "Is this interface good enough to ship?"
- "Run a design critique on this page"
- "What would design experts think of this?"
- "Does this feel right?"
- "Can you critique this UI?"
- "Is this ready for users?"
- "What's wrong with this design?"
- "Run the design legends on this"
- "How would Jobs/Norman/Rams rate this?"
- "This doesn't feel polished"
- "Compare this to best-in-class"
- Before merging a major UI change
- After a UX refactor
- Before public launch
- When usability friction is suspected
- When something feels off but the issue is hard to articulate

## Input Required

Before starting, gather or request:

| Input | Description |
|-------|-------------|
| **Feature description** | What the feature does and where it lives in the app |
| **Primary persona** | Who is the target user (e.g., infra operator, homebuyer, agent) |
| **Screens / flows** | Read the actual component code; textual description also acceptable |
| **Key user goal** | What the user is trying to accomplish |
| **Known constraints** | Technical, legal, timeline, or design system constraints |

If any are missing, request them before proceeding. If reviewing a running app, take a screenshot and read the component source code to understand the full picture.

## Cross-Skill Dependencies

Before running the review, load context from these skills if the project uses them:

- **constellation-design-system** — Load design system rules to check component compliance
- **accessibility** — Reference WCAG 2.2 AA checklist for accessibility gaps
- **responsive-design** — Check responsive behavior and mobile patterns
- **ux-writing-guide** — Reference `custom_instruction/ux-writing-guide.md` for copy standards

## Core Workflow

### Phase 1: Context Gathering

1. Read the feature's component source code
2. Take a screenshot of the running feature if possible
3. Identify the component tree, props, tokens, and layout patterns
4. Note the target audience (Consumer vs Professional) per `custom_instruction/instructions.md`
5. Identify the primary user goal and flow

### Phase 2: Persona Reviews

Run each persona review independently. Each persona has a strictly scoped lens — do not allow overlap between personas. Each review must reference specific elements from the actual UI, not generic advice.

---

### 1. Don Norman — Mental Model Integrity

**Focus:** Affordances, visibility of system state, mapping between controls and outcomes, error prevention and recovery, mental model coherence.

**Questions to answer:**
- What mental model does this interface create?
- Where will users misunderstand system state?
- Are affordances clear — does each element look like what it does?
- Can users recover from errors easily?
- Is the mapping between controls and outcomes obvious?

**Avoid:** Aesthetic commentary. Norman cares about cognition, not beauty.

---

### 2. Dieter Rams — Reduction and Necessity

**Focus:** Feature necessity, elimination opportunities, signal-to-noise ratio, structural simplicity, long-term maintainability.

**Questions to answer:**
- Is this feature necessary?
- What can we remove and lose nothing?
- What is the signal-to-noise ratio on this screen?
- Does every element serve the core purpose?
- Will this age well or become clutter?

**Avoid:** Micro-UX nitpicks. Rams thinks in systems, not pixels.

---

### 3. Jakob Nielsen — Heuristic Risk Audit

**Focus:** Consistency, feedback clarity, error prevention, undo mechanisms, naming clarity, edge-case friction.

**Evaluate against Nielsen's 10 usability heuristics:**

1. Visibility of system status
2. Match between system and real world
3. User control and freedom
4. Consistency and standards
5. Error prevention
6. Recognition rather than recall
7. Flexibility and efficiency of use
8. Aesthetic and minimalist design
9. Help users recognize, diagnose, and recover from errors
10. Help and documentation

**This is the risk radar.** Nielsen catches what causes churn and support tickets.

---

### 4. Jony Ive — Spatial and Interaction Harmony

**Focus:** Hierarchy, information density, motion meaning, visual rhythm, layout coherence, craftsmanship.

**Questions to answer:**
- Does the spatial hierarchy guide the eye correctly?
- Is information density appropriate — not too sparse, not too dense?
- Do transitions and motion express meaning?
- Does the typography create clear rhythm?
- Does this feel like a serious, crafted instrument?

**Avoid:** Business or leverage commentary. Ive cares about form.

---

### 5. Steve Jobs — Taste and Ambition

**Focus:** Demo-worthiness, emotional impact, product conviction, coherence, whether it feels inevitable.

**Questions to answer:**
- If we demo this live on stage, does it land?
- Does this feel inevitable and magical, or cobbled together?
- Is this insanely great, or merely adequate?
- Does it require explanation, or is it self-evident?
- Would you be proud to put your name on this?

**Reject mediocrity.** Jobs does not accept "good enough."

---

### 6. Sam Altman — Leverage and Autonomy

**Focus:** Scalability, system compounding, operational leverage, whether UX increases autonomy, long-term strategic unlock.

**Questions to answer:**
- Does this feature unlock scale or add operational drag?
- Does it 10x capability or 1.1x aesthetics?
- Does this increase user autonomy or create dependency?
- Will this compound over time or require constant maintenance?
- Is this a strategic unlock or a tactical patch?

**Avoid:** Nitpicking layout or spacing. Altman thinks in leverage.

---

### 7. Bret Victor — Cognitive Amplification

**Focus:** Immediate feedback loops, cause-effect visibility, manipulability, learnability via interaction, whether the interface helps users think.

**Questions to answer:**
- Does the user get immediate feedback when they act?
- Can users see cause and effect directly?
- Is the interface manipulable — can users explore by doing?
- Does interacting with this teach the user something?
- Does this UI help users think, or just display information?

**Avoid:** Business commentary. Victor cares about cognition and tools.

---

### Phase 3: Scoring

For EACH persona, produce:

| Field | Requirement |
|-------|-------------|
| **3 Strengths** | Specific to this feature, not generic praise |
| **3 Weaknesses** | Specific, non-repetitive across personas |
| **UX Score (1–10)** | Based strictly on this persona's lens |
| **1 Highest-Leverage Improvement** | The single change with the most impact from this lens |

**Scoring Calibration (enforce strictly):**

| Score | Meaning |
|-------|---------|
| 1–3 | Fundamentally broken from this lens |
| 4–5 | Below acceptable — significant issues |
| 5–6 | Acceptable but clearly flawed |
| 7–8 | Strong — minor issues only |
| 9 | Excellent — approaching best-in-class |
| 10 | World-class — reserved for exceptional work |

**Do not inflate scores.** If the UX is mediocre, do not score above 6. Reserve 9–10 for genuinely world-class design. Be critical — assume the feature is flawed unless proven otherwise.

### Phase 4: Synthesis

After all persona reviews, produce:

#### 1. Disagreement Map
Where personas conflict. Example: "Jobs wants more boldness; Rams wants reduction. Resolution: [recommendation]."

#### 2. Highest-Confidence Structural Flaw
The single systemic weakness that multiple personas flagged or that represents the deepest risk.

#### 3. 20% Simplification
One concrete change that would improve clarity or power by approximately 20%. This should be specific and actionable, not vague.

#### 4. Design System Compliance
Flag any violations of the Constellation design system rules (reference `custom_instruction/instructions.md`):
- Missing `saveButton` on PropertyCard
- Card with both `elevated` and `outlined`
- CSS borders instead of `<Divider />`
- Outline icons used as default
- More than 2 `Heading` per screen
- Blue used for non-interactive elements
- Tabs without `defaultSelected`
- Wrong component choices (see Component Selection table)

#### 5. Strategic Recommendation
Choose exactly ONE:

| Recommendation | When to use |
|----------------|-------------|
| **Ship as-is** | Average score 8+ with no structural flaws |
| **Iterate** | Average score 6–8 with addressable issues |
| **Simplify** | Feature is overbuilt — reduce before shipping |
| **Re-architect** | Structural issues require fundamental rethinking |
| **Kill feature** | Feature does not serve the user goal or creates net negative value |

## Output Format

```markdown
# UX Review: [Feature Name]

**Reviewer:** UX Review Panel (7 personas)
**Date:** [date]
**Primary Persona:** [target user]
**User Goal:** [what they're trying to accomplish]

---

## Persona Reviews

### Don Norman — Mental Model Integrity
**Score: X/10**
| Strengths | Weaknesses |
|-----------|------------|
| 1. ... | 1. ... |
| 2. ... | 2. ... |
| 3. ... | 3. ... |
**Highest-leverage improvement:** ...

### Dieter Rams — Reduction and Necessity
**Score: X/10**
[same format]

### Jakob Nielsen — Heuristic Risk Audit
**Score: X/10**
[same format]

### Jony Ive — Spatial and Interaction Harmony
**Score: X/10**
[same format]

### Steve Jobs — Taste and Ambition
**Score: X/10**
[same format]

### Sam Altman — Leverage and Autonomy
**Score: X/10**
[same format]

### Bret Victor — Cognitive Amplification
**Score: X/10**
[same format]

---

## Synthesis

### Disagreement Map
...

### Highest-Confidence Structural Flaw
...

### 20% Simplification
...

### Design System Compliance
- [ ] Violation 1
- [ ] Violation 2
(or: No violations found.)

### Strategic Recommendation
**[Ship / Iterate / Simplify / Re-architect / Kill]**
Rationale: ...

---

**Average Score: X.X/10**
```

## Behavioral Rules

1. Be critical — optimize for long-term product excellence, not politeness
2. Do not repeat the same critique across personas — each weakness must be unique
3. No fluff — every sentence must carry information
4. No generic UX advice — tie critiques directly to the feature's actual behavior
5. No hedging — state opinions as direct assessments
6. No excessive praise — strengths should be specific, not flattering
7. Reference actual UI elements, component names, and token values when possible
8. If the project uses Constellation, validate against design system rules

## Example Invocation

"Run a UX review on the feature request board. Primary persona: internal product team member. Goal: submit and track feature requests for the Skills & MCPs library. Constraints: must use Constellation design system, professional app rules apply."
