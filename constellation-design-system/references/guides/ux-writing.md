# Zillow UX Writing Guide

**For AI agents writing UI copy in Zillow products.**

---

## TL;DR - Critical Rules

```
1. Sentence case → ALL UI text (headings, buttons, labels, alerts, links)
2. Contractions → ALWAYS use: we'll, you're, that's, it's
3. Active voice → ALWAYS front-load the task or outcome
4. User = "you" → Zillow = "we/us/our"
5. Numbers → Numerals always: $1,500, 5%, 2 of 6
6. No dashes → NEVER use em dashes (—) or en dashes (–)
7. Plurals → NEVER write (s) or (es), use natural pluralization
8. Emoji → Sparingly, NEVER as punctuation
```

---

## Voice & Tone

| Attribute | Meaning |
|-----------|---------|
| **Thoughtful** | Human, compassionate, inclusive |
| **Direct** | Genuine, transparent, straightforward |
| **Empowering** | Confident, optimistic, motivational |

**Default:** Thoughtful + Direct. Add Empowering when driving action. Use Playful sparingly.

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

## Common Copy Snippets

### Actions
- Verify your email to sign in. **Verify email**
- Log in to comment.
- Contact us if you have questions.
- You cannot undo this action.

### Errors
- Enter a 5-digit ZIP code.
- Enter a phone number in this format: 555-123-4567.
- We couldn't verify your SSN. Try again.

### Success
- Your listing was published. **View listing**
- Your profile was updated. **View profile**

### Empty States
- You haven't saved any homes yet. **Start a new search**
- Your renter profile isn't set up. **Create renter profile**

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
