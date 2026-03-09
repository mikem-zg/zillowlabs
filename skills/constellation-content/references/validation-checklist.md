# Content Validation Checklist

Machine-readable rules for automated and manual content review. Each rule has an ID, category, description, severity, and audience scope.

## Severity Levels

| Level | Meaning |
|-------|---------|
| **ERROR** | Must fix before shipping — violates core brand/UX standards |
| **WARN** | Should fix — degrades quality or consistency |
| **INFO** | Suggestion — consider for polish |

---

## Universal Rules (All Audiences)

| ID | Category | Rule | Severity |
|----|----------|------|----------|
| CONT_001 | Case | All UI text uses sentence case (not Title Case or ALL CAPS) | ERROR |
| CONT_002 | Case | Only proper nouns are capitalized (Zillow, Seattle, etc.) | ERROR |
| CONT_003 | Voice | Active voice used; outcome front-loaded | WARN |
| CONT_004 | Voice | User addressed as "you"; Zillow as "we/us/our" | ERROR |
| CONT_005 | Contractions | Contractions used consistently (we'll, you're, that's, it's) | WARN |
| CONT_006 | Contractions | No mixing of contracted and spelled-out forms in the same flow | WARN |
| CONT_007 | Numbers | All numbers use numerals (never spelled out) | ERROR |
| CONT_008 | Numbers | Currency uses comma separators ($2,500 not $2500) | WARN |
| CONT_009 | Numbers | Percentages use numeral + % (3.5% not three point five percent) | WARN |
| CONT_010 | Punctuation | No em dashes (—) or en dashes (–) | ERROR |
| CONT_011 | Punctuation | No (s) or (es) plurals — use natural pluralization | ERROR |
| CONT_012 | Emoji | No emojis in UI text, labels, headings, or descriptions | ERROR |
| CONT_013 | Errors | Error messages include what failed + how to fix | WARN |
| CONT_014 | Success | Success messages include what happened + next step | WARN |
| CONT_015 | Empty states | Empty states include heading + guidance + one primary CTA | WARN |
| CONT_016 | Buttons | Button text uses short action verbs (Save, Continue, Delete) | WARN |
| CONT_017 | Buttons | No vague button text (Click here, Submit, Learn more without context) | ERROR |
| CONT_018 | Forms | Every form field has a visible label (not placeholder-only) | ERROR |
| CONT_019 | Forms | Placeholders show example format, not label text | WARN |
| CONT_020 | Inclusion | They/them used for singular when gender unknown | INFO |
| CONT_021 | Inclusion | No idioms or culture-bound references | WARN |
| CONT_022 | Inclusion | People-first, neutral language | WARN |
| CONT_023 | Tense | Simple tenses used (past, present, future) — no -ing verb chains | WARN |
| CONT_024 | Labels | UI labels referenced exactly as shown ("Select **Saved Homes**") | WARN |
| CONT_025 | Length | Tooltip/helper text max ~80 characters | INFO |
| CONT_026 | Consistency | Terminology consistent across the same flow | WARN |

---

## Consumer-Specific Rules

| ID | Category | Rule | Severity |
|----|----------|------|----------|
| CONT_C01 | Tone | Copy speaks to the person's goal, not just data labels | WARN |
| CONT_C02 | Tone | Benefit-oriented headlines ("Find your home" not "Property search") | WARN |
| CONT_C03 | Tone | Playful/warm tone OK in celebrations and milestones | INFO |
| CONT_C04 | Punctuation | One exclamation mark OK in celebration contexts ("Home saved!") | INFO |
| CONT_C05 | Empty states | Empty states use aspirational language ("Start exploring to find the one") | INFO |

---

## Professional-Specific Rules

| ID | Category | Rule | Severity |
|----|----------|------|----------|
| CONT_P01 | Tone | Data-forward, concise copy — no unnecessary enthusiasm | WARN |
| CONT_P02 | Tone | Lead with outcomes and metrics, not emotional language | WARN |
| CONT_P03 | Punctuation | No exclamation marks in data UI, dashboards, or tables | ERROR |
| CONT_P04 | Punctuation | Exclamation marks OK only in onboarding welcome or milestone celebrations | INFO |
| CONT_P05 | Labels | Use industry-standard terminology (leads, pipeline, CRM, listings) | WARN |
| CONT_P06 | Empty states | Empty states explain what will appear and when ("Leads will appear here as they're assigned") | WARN |

---

## Review Process

1. Run through all **ERROR** rules first — these block shipping
2. Address **WARN** rules — these should be fixed in most cases
3. Consider **INFO** suggestions — nice-to-have polish
4. Cross-check audience scope — consumer rules don't apply to professional UI and vice versa
5. Verify consistency across the entire flow, not just individual screens
