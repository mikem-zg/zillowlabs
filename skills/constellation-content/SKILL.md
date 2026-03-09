---
name: constellation-content
description: Zillow UX writing and content guidelines for AI agents. Activates when writing UI copy, labels, headings, error messages, empty states, button text, form labels, notifications, onboarding copy, or any user-facing text in Zillow products. Covers voice & tone, sentence case rules, microcopy patterns, number formatting, capitalization, and audience-specific tone (consumer vs professional).
---

# Constellation Content — UX Writing Guidelines

Source: [Zillow Style Guide](https://zillow.styleguide.com/) (ZG Style Guide 2.0) and Constellation design system content standards.

Content guidelines for AI agents writing UI copy in Zillow products. This skill is independent of the visual design system — load it whenever you need to write or review user-facing text.

## When to Load This Skill

- Writing any UI text (headings, labels, buttons, descriptions, tooltips)
- Writing error, success, warning, or empty state messages
- Writing form labels and placeholder text
- Writing onboarding, modal, or notification copy
- Reviewing existing copy for Zillow voice & tone compliance
- Choosing between consumer and professional tone
- Writing AI/agent-generated responses (see AI Behavioral Guidance)

## TL;DR — Critical Rules

```
1. Sentence case → ALL UI text (headings, buttons, labels, alerts, links)
2. Contractions → ALWAYS use: we'll, you're, that's, it's
3. Active voice → ALWAYS front-load the task or outcome
4. User = "you" → Zillow = "we/us/our"
5. Numbers → Numerals for 10+; 1-9 numerals when tight, spell out in sentences
6. Oxford comma → ALWAYS use the serial comma
7. Plurals → NEVER write (s) or (es), use natural pluralization
8. Emoji → NEVER in UI text, labels, headings, or descriptions unless user explicitly requests
9. "Select" → NEVER write "Click" or "Tap" — use "Select" and name the target
10. Periods → NONE on headings, helper text, toasts, alerts, or button/label text (unless multi-sentence)
```

---

## Voice & Tone

Zillow's verbal identity is a reflection of who we are and how we communicate. It defines what we say and how we sound and is an expression of our personality.

**Voice** is always in use — it's who we are, the personality that sets Zillow apart.
**Tone** is circumstantial — it's the way we express our voice, depending on the audience and situation.

### Brand Personality Traits

| Trait | Meaning |
|-------|---------|
| **Courageous** | Pushes boundaries, stands up for what's right, innovates with purpose |
| **Insightful** | Understands context, provides unique insight, creates clarity |
| **Unflappable** | Unwavering through adversity, provides emotional stability, consistently delivers |

### Voice Archetype: The Advocate

When writing on behalf of Zillow, invoke the voice of an **Advocate** — one who supports or promotes the interests of a cause or group. Ask: "Is this something an advocate would say?"

### Audience-Specific Tone

| Audience | Promise | Tone | Example |
|----------|---------|------|---------|
| **Consumer** (buyers, renters, sellers) | "Get home" | Joyful, vibrant, emotional | "You've saved 3 homes — let's find the one" |
| **Professional** (agents, loan officers, property managers) | "Unlock success" | Efficient, organized, trustworthy | "3 new leads assigned to your pipeline" |

**Consumer copy** can be warmer and more aspirational. **Professional copy** should be concise and data-forward — no unnecessary enthusiasm.

---

## Capitalization & Letter Case

Most words should be in **lowercase (sentence case)** unless there's a specific rule stating otherwise.

- Use sentence case for headings, lists, titles, and button copy
- Capitalize proper nouns (Zillow, Seattle, Zestimate)
- Capitalize common regional terms (the Pacific Northwest, the Midwest)
- Sentence case unless a Zillow product or feature is copyrighted, trademarked, or named by the Brand Team
- Avoid ALLCAPS unless referring to a known abbreviation (e.g., SSN, ZIP, HOA)
- After a colon: lowercase (unless proper noun or full sentence)
- Hyphenated terms: first word only (unless next word is proper noun)

---

## Punctuation

### Ampersands (&)
- Use **only** when space is tight (headings, CTAs, buttons, subject lines)
- Use lowercase after the ampersand
- Don't use in body copy in place of "and"

### Apostrophes & Contractions
- Follow AP for contractions and possession
- Contractions are encouraged for conversational tone (it's, don't, we'll)
- **its** = possessive; **it's** = it is

### Colons
- Use to introduce a single data point or a list/steps
- If the lead-in is a heading, no colon
- Avoid colon-plus-sentence structures; prefer two sentences

### Commas
- Use the **Oxford (serial) comma**
- If stacking commas, consider splitting into shorter sentences
- In bulleted/numbered lists, don't add commas at line ends

### Dashes
- **En dash (–):** use for ranges; no spaces (e.g., 9–12, $200,000–$235,000)
- **Em dash (—):** use for emphasis or asides; add spaces on both sides; use sparingly
- Don't fake dashes with hyphens (--)

### Ellipses (...)
- Use to indicate truncated text or in-progress operations (e.g., "Loading more results...")
- Don't use to trail off or add drama
- Avoid in buttons/labels

### Exclamation Points
- Use **sparingly**; appropriate in celebratory confirmations
- Never in buttons
- Never in professional data UI, dashboards, or tables

### Hyphens (-)
- Use in compound modifiers before a noun (first-time buyer)
- No spaces around the hyphen
- Lowercase the word after the hyphen (even in headings)

### Parentheses
- Generally **avoid** in UI — they add cognitive load
- Fragment inside → no period inside
- Full standalone sentence inside → period before closing parenthesis

### Periods
- Don't add periods to headings, helper text, toasts, alerts, or button/label text (unless multi-sentence)
- In links at the end of text, don't add a trailing period to the link text
- In lists, add periods only if an item is a full sentence

### Quotation Marks
- Use smart quotes (" " ' ') where supported
- Don't quote UI elements; **bold** them instead
- Place ending punctuation inside quotes

### Semicolons
- **Avoid.** Prefer two sentences, an em dash, or a comma + conjunction

### Slashes (/)
- No spaces around slashes
- Don't use a slash to replace "and/or" (ambiguous)
- Don't show full URLs in user-facing copy; use descriptive link text

---

## Dates, Times & Numbers

### Numbers & Currency
- Use **numerals** for all numbers 10 and above
- For 1–9, use numerals when space is tight (e.g., "5 homes"), or spell out in sentences ("five homes")
- Always use **commas** in numbers 1,000 or higher: 2,500 square feet
- Use **$** before amounts — not the word "dollars"
- Include two decimal places only when needed (e.g., $45.75, not $45.00)
- Use **K** for thousands and **M** for millions only when space is limited (e.g., $250K, $1.2M)
- In full sentences, write out "million" or "billion"

### Ranges
- Use an en dash (–) without spaces for ranges: 10–15 minutes, $300,000–$400,000
- Use "to" when clearer or when the range includes text or symbols: 12% to 15%

### Time
- Use lowercase am/pm, no periods, no spaces: 9am, 2:30pm
- For time ranges, use an en dash and list am/pm only once when both are the same: 8–10am
- Use time zone abbreviations (ET, CT, MT, PT) when readers may be in multiple zones

### Dates
- Use Month Day, Year (AP Style): June 5, 2025
- When adding the day of week, separate with commas: Wednesday, October 4, 2023
- When space is tight, abbreviate months to three letters (no period): Mon, Jul 8
- Use cardinal numbers (1, 2, 3), not ordinals (1st, 2nd, 3rd)
- Use slashes for numerical formats: MM/DD/YYYY

### Percentages & Decimals
- Use numerals + %, no space: 20%, 5.5%
- For ratios, use words or hyphens: 2-to-1, 1 in 4 renters
- Always include a leading zero before decimals under 1: 0.25 acres

### Phone Numbers
- US: (XXX) XXX-XXXX — e.g., (206) 555-1234
- International: +CountryCode (Area) XXX-XXXX

---

## ALWAYS vs NEVER

| ALWAYS | NEVER |
|--------|-------|
| Sentence case for all UI text | Title Case Or ALL CAPS |
| Use contractions (we'll, you're) | Mix contracted and spelled-out forms |
| Active voice, front-load outcome | Passive voice or buried actions |
| Simple tenses (past, present, future) | -ing verbs or long helper verb chains |
| Oxford (serial) comma | Inconsistent comma usage |
| Numerals for 10+; numerals or words for 1-9 | Spelled-out numbers for 10+ |
| They/them as singular when needed | Assume user identity/status/family |
| "Select" and name the target | "Click", "Click here", "Tap" |
| People-first, neutral language | Idioms or culture-bound references |
| Exact UI labels: "Select **Saved Homes**" | Generic: "Click the button" |
| Use "home" (encompasses all dwelling types) | "house" unless specifically a single-family dwelling |
| "primary bedroom" | "master bedroom" |
| "turn on/off", "allow", "show" | "enable/disable" |
| "sign in" (verb), "sign-in" (noun/adjective) | "login" (verb form), "log in" |

---

## Inclusive Language

- Avoid gendered, ableist, or exclusionary language
- Use person-first language: "people with disabilities" over "disabled people"
- Ensure content is culturally inclusive and avoids unnecessary assumptions
- Singular "they" is acceptable for referring to an individual whose pronouns are unknown
- Don't use: "blacklist/whitelist" (use "block/approve"), "master" (use "primary"), "walk-in closet" (use dimensions), "walking distance" (ableist), "his-and-her" (heteronormative), "Jack-and-Jill" (heteronormative), "mother-in-law suite" (ageist/sexist)

---

## Microcopy Patterns

### Success Messages
```
[What happened] + [Value/Next step]
Example: "Your listing was published. View listing"
```
- Be specific about what occurred
- Exclamation points are rare (OK in consumer celebrations: "Home saved!")
- One clear next step

### Error Messages
```
[What failed] + [How to fix]
Example: "Enter a 5-digit ZIP code."
```
- Place field errors next to the field
- Tell what's wrong AND how to fix

### Warning Messages
```
[Risk] + [Action they can take]
Example: "If you exit, you will not save your progress."
```

### Empty States
```
[Short heading] + [One-sentence guidance] + [One primary CTA]
Example: "You haven't saved any homes yet. Start a new search"
```

---

## Buttons & Links

| ALWAYS | NEVER |
|--------|-------|
| Short action verbs: Save, Continue, Delete | Vague: Click here, Submit |
| Descriptive link text: "Verify email" | Generic: "Learn more" without context |
| One primary action per context | Multiple competing CTAs |
| No periods on button text | Periods on buttons |
| No exclamation points on buttons | Exclamation points on buttons |

---

## Forms

| Rule | Example |
|------|---------|
| Label every field | "Email address" not placeholder only |
| Keep labels short and concrete | "Phone" not "Please enter your phone number" |
| Mark the exception (required vs optional) | Show "Optional" if most fields required |
| Placeholders are examples, not labels | placeholder="555-123-4567" |
| Error format: what's wrong + how to fix | "Enter a phone number: 555-123-4567" |

---

## Key Terms Quick Reference

These terms have specific Zillow rules (see [full terminology](references/terminology.md)):

| Term | Rule |
|------|------|
| OK | Never "okay". Variations: OKs, OK'd, OK'ing |
| FAQ | Never "FAQs" |
| ZIP code | All caps for ZIP (Zone Improvement Plan) |
| Zestimate | Trademarked; specific styling required |
| home | Preferred over "house" (encompasses all dwelling types) |
| listing price | Never "list price" |
| homeowner | One word; also "homeownership" |
| multifamily | One word, no hyphen |
| townhome | One word, no hyphens |
| pre-approval | Hyphenated (exception to AP) |
| U.S. | Always use periods |
| Zillow Home Loans | Never abbreviate to ZHL in consumer-facing copy |
| please | Use sparingly — can come across as condescending |
| sorry | Only when error is Zillow's fault and causes significant inconvenience |
| thank you | Save for when user acts in response to our serious error |

---

## AI Behavioral Guidance

When writing for AI-driven or agentic experiences (Voyager, conversational search, AI recommendations), additional rules apply beyond standard voice & tone.

### Character Attributes

1. **Confident, not coercive** — Take responsibility for guidance without forcing outcomes. Use "recommend" and "suggest", not "must" or "should". Avoid false urgency.
2. **Helpful without over-explaining** — Respect user competence. Short answer first, depth available via "Learn more". Stop once intent is satisfied.
3. **Empathic, not performative** — Name the situation, not the feeling. Avoid scripted empathy ("We know this can be stressful"). Use neutral reassurance grounded in facts.
4. **Direct about tradeoffs** — Surface constraints and downsides early. Don't hide tradeoffs behind optimistic framing.
5. **Data-informed, not data-obsessed** — Explain why a metric matters, not just what it is. Use ranges and comparisons over false precision.
6. **Calm under failure** — Plain acknowledgment: "We couldn't load this right now." Explain impact and next steps, not internal causes.

### Anti-Patterns (Non-Negotiable for AI)

- Never pressure users toward irreversible decisions
- Never repeat recommendations after refusal
- Never simulate human emotion or companionship ("I feel...", "I think...")
- Never use "Most users choose this" as persuasion
- Never reframe rejection as misunderstanding
- Never use artificial urgency without real constraints
- Never use long-form empathy before answering a direct question

### Decision Postures

| Posture | When to Use | When Harmful |
|---------|-------------|--------------|
| **Assertive guide** | High-confidence data, safety/compliance, time-sensitive | Early exploration, ambiguous data |
| **Collaborative advisor** | Trade-off decisions, mid-funnel, preference-driven | Clear best action exists, crisis moments |
| **Neutral informant** | Comparison/research, regulatory contexts | User is stuck or overwhelmed |
| **Cautious explainer** | Predictive models, AI insights, partial data | Simple tasks, moments needing momentum |
| **Silent confirmer** | High-confidence user-initiated actions, familiar workflows | First-time actions, high-risk commitments |
| **Empathic stabilizer** | Errors/failures/delays, emotional moments | When empathy replaces instruction |

---

## Review Checklist

Before finalizing any copy:
- [ ] Purpose is clear and user-centered
- [ ] Sentence case used throughout
- [ ] Contractions used consistently
- [ ] Active voice, goal front-loaded
- [ ] Oxford comma used
- [ ] Terminology consistent across flow (check [terminology](references/terminology.md))
- [ ] Errors/success include next steps
- [ ] No periods on headings, buttons, labels, toasts, alerts
- [ ] Inclusive pronouns (they/them OK)
- [ ] No emojis in UI text
- [ ] Tone matches audience (consumer vs professional)
- [ ] No "Click" or "Tap" — use "Select"
- [ ] AI copy follows character attributes and avoids anti-patterns

---

## Reference Files

- [Copy Patterns](references/copy-patterns.md): Expanded copy snippets, audience-specific examples, and templates for modals, confirmations, onboarding, notifications, and tooltips.
- [Terminology](references/terminology.md): Full Zillow terminology glossary — approved terms, don't-use terms, and use-carefully terms from the official ZG Style Guide.
- [Accessibility & Inclusion](references/accessibility-inclusion.md): Inclusive language rules, ableist terms to avoid, plain language guidelines, and multimedia accessibility standards.
- [AI Behavioral Guidance](references/ai-behavioral-guidance.md): Full character model, interaction philosophy, decision posture framework, and emotional/cognitive intent map for AI-native experiences.
- [Validation Checklist](references/validation-checklist.md): Machine-readable rule IDs, categories, and severity levels for automated content review.

## Related Skills

- **[consumer-brand-guidelines](../consumer-brand-guidelines/SKILL.md)**: Visual identity and verbal identity for consumer audiences. See `references/verbal-identity.md` for brand story, personality traits, and the Advocate archetype.
- **[professional-brand-guidelines](../professional-brand-guidelines/SKILL.md)**: Visual identity and tone rules for professional audiences.
- **[constellation-design-system](../constellation-design-system/SKILL.md)**: Component library, design tokens, and visual rules. Load alongside this skill when building UI.
