---
name: constellation-content
description: Zillow UX writing and content guidelines for AI agents. Activates when writing UI copy, labels, headings, error messages, empty states, button text, form labels, notifications, onboarding copy, or any user-facing text in Zillow products. Covers voice & tone, sentence case rules, microcopy patterns, number formatting, capitalization, and audience-specific tone (consumer vs professional).
---

# Constellation Content — UX Writing Guidelines

Content guidelines for AI agents writing UI copy in Zillow products. This skill is independent of the visual design system — load it whenever you need to write or review user-facing text.

## When to Load This Skill

- Writing any UI text (headings, labels, buttons, descriptions, tooltips)
- Writing error, success, warning, or empty state messages
- Writing form labels and placeholder text
- Writing onboarding, modal, or notification copy
- Reviewing existing copy for Zillow voice & tone compliance
- Choosing between consumer and professional tone

## TL;DR — Critical Rules

```
1. Sentence case → ALL UI text (headings, buttons, labels, alerts, links)
2. Contractions → ALWAYS use: we'll, you're, that's, it's
3. Active voice → ALWAYS front-load the task or outcome
4. User = "you" → Zillow = "we/us/our"
5. Numbers → Numerals always: $1,500, 5%, 2 of 6
6. No dashes → NEVER use em dashes (—) or en dashes (–)
7. Plurals → NEVER write (s) or (es), use natural pluralization
8. Emoji → NEVER in UI text, labels, headings, or descriptions unless user explicitly requests
```

---

## Voice & Tone

| Attribute | Meaning |
|-----------|---------|
| **Thoughtful** | Human, compassionate, inclusive |
| **Direct** | Genuine, transparent, straightforward |
| **Empowering** | Confident, optimistic, motivational |

**Default:** Thoughtful + Direct. Add Empowering when driving action. Use Playful sparingly.

### Audience-Specific Tone

| Audience | Promise | Tone | Example |
|----------|---------|------|---------|
| **Consumer** (buyers, renters, sellers) | "Get home" | Joyful, vibrant, emotional | "You've saved 3 homes — let's find the one" |
| **Professional** (agents, loan officers, property managers) | "Unlock success" | Efficient, organized, trustworthy | "3 new leads assigned to your pipeline" |

**Consumer copy** can be warmer and more aspirational. **Professional copy** should be concise and data-forward — no unnecessary enthusiasm.

---

## ALWAYS vs NEVER

| ALWAYS | NEVER |
|--------|-------|
| Sentence case for all UI text | Title Case Or ALL CAPS |
| Use contractions (we'll, you're) | Mix contracted and spelled-out forms |
| Active voice, front-load outcome | Passive voice or buried actions |
| Simple tenses (past, present, future) | -ing verbs or long helper verb chains |
| Numerals for all numbers | Spelled-out numbers |
| They/them as singular when needed | Assume user identity/status/family |
| Exact UI labels: "Select **Saved Homes**" | Generic: "Click the button" |
| People-first, neutral language | Idioms or culture-bound references |

---

## Number Formatting

| Type | Format | Example |
|------|--------|---------|
| Currency | Comma separators | $2,500 |
| Percentage | Numeral + % | 3.5% |
| Time | Short form | 2 min, 3 hr, 3:30 PM |
| Large values (tight spaces) | K/M suffix | 12.5K |
| Counts | Numeral | 2 of 6 |

---

## Capitalization Rules

| Context | Rule |
|---------|------|
| UI text | Sentence case |
| Proper nouns | Capitalize (Zillow, Seattle) |
| After colon | Lowercase (unless proper noun or full sentence) |
| Hyphenated terms | First word only (unless next is proper noun) |

---

## Microcopy Patterns

### Success Messages
```
[What happened] + [Value/Next step]
Example: "Your listing was published. View listing"
```
- Be specific about what occurred
- Exclamation points are rare
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

## Review Checklist

Before finalizing any copy:
- [ ] Purpose is clear and user-centered
- [ ] Sentence case used throughout
- [ ] Contractions used consistently
- [ ] Active voice, goal front-loaded
- [ ] Terminology consistent across flow
- [ ] Errors/success include next steps
- [ ] No em dashes or en dashes
- [ ] Inclusive pronouns (they/them OK)
- [ ] No emojis in UI text
- [ ] Tone matches audience (consumer vs professional)

---

## Reference Files

- [Copy Patterns](references/copy-patterns.md): Expanded copy snippets, audience-specific examples, and templates for modals, confirmations, onboarding, notifications, and tooltips.
- [Validation Checklist](references/validation-checklist.md): Machine-readable rule IDs, categories, and severity levels for automated content review.

## Related Skills

- **[consumer-brand-guidelines](../consumer-brand-guidelines/SKILL.md)**: Visual identity and verbal identity for consumer audiences. See `references/verbal-identity.md` for brand story, personality traits, and the Advocate archetype.
- **[professional-brand-guidelines](../professional-brand-guidelines/SKILL.md)**: Visual identity and tone rules for professional audiences.
- **[constellation-design-system](../constellation-design-system/SKILL.md)**: Component library, design tokens, and visual rules. Load alongside this skill when building UI.
