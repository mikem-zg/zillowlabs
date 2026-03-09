# Content Validation Checklist

Machine-readable rules for automated and manual content review. Each rule has an ID, category, description, severity, and audience scope.

Source: Rules derived from [Zillow Style Guide](https://zillow.styleguide.com/) and Constellation content standards.

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
| CONT_002 | Case | Only proper nouns are capitalized (Zillow, Seattle, Zestimate, etc.) | ERROR |
| CONT_003 | Voice | Active voice used; outcome front-loaded | WARN |
| CONT_004 | Voice | User addressed as "you"; Zillow as "we/us/our" | ERROR |
| CONT_005 | Contractions | Contractions used consistently (we'll, you're, that's, it's) | WARN |
| CONT_006 | Contractions | No mixing of contracted and spelled-out forms in the same flow | WARN |
| CONT_007 | Numbers | Numerals for 10+; numerals OK for 1-9 when space is tight | WARN |
| CONT_008 | Numbers | Currency uses comma separators ($2,500 not $2500) | WARN |
| CONT_009 | Numbers | Percentages use numeral + % (3.5% not three point five percent) | WARN |
| CONT_010 | Punctuation | Em dashes (—) used sparingly with spaces on both sides; en dashes (–) for ranges with no spaces | WARN |
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
| CONT_022 | Inclusion | People-first, neutral language; no ableist terms | WARN |
| CONT_023 | Tense | Simple tenses used (past, present, future) — no -ing verb chains | WARN |
| CONT_024 | Labels | UI labels referenced exactly as shown ("Select **Saved Homes**") | WARN |
| CONT_025 | Length | Tooltip/helper text max ~80 characters | INFO |
| CONT_026 | Consistency | Terminology consistent across the same flow | WARN |
| CONT_027 | Punctuation | Oxford (serial) comma used in lists | WARN |
| CONT_028 | Punctuation | No periods on headings, helper text, toasts, alerts, or button/label text (unless multi-sentence) | WARN |
| CONT_029 | Punctuation | No exclamation points on buttons | ERROR |
| CONT_030 | Interaction | "Select" used instead of "Click", "Click here", or "Tap" | ERROR |
| CONT_031 | Terminology | "home" preferred over "house" (unless specifically a single-family dwelling) | WARN |
| CONT_032 | Terminology | "primary bedroom" used instead of "master bedroom" | ERROR |
| CONT_033 | Terminology | "sign in" (verb) / "sign-in" (noun/adj) — never "login" as verb | WARN |
| CONT_034 | Terminology | "OK" used instead of "okay" | WARN |
| CONT_035 | Terminology | "listing price" used instead of "list price" | WARN |
| CONT_036 | Inclusion | No banned terms (blacklist, whitelist, master, walkthrough, etc.) | ERROR |
| CONT_037 | Punctuation | Semicolons avoided — prefer two sentences or em dash | INFO |

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

## AI-Specific Rules

| ID | Category | Rule | Severity |
|----|----------|------|----------|
| CONT_AI01 | Character | No anthropomorphizing ("I feel...", "I think...") | ERROR |
| CONT_AI02 | Character | No false urgency without real time constraints | ERROR |
| CONT_AI03 | Character | No repeated recommendations after user refusal | ERROR |
| CONT_AI04 | Character | Confidence scales with data certainty — no overconfident assertions from partial data | WARN |
| CONT_AI05 | Character | Uses "recommend" / "suggest" instead of "must" / "should" | WARN |
| CONT_AI06 | Character | Progressive disclosure: short answer first, depth available | WARN |
| CONT_AI07 | Character | Names the situation, not the feeling (no scripted empathy) | WARN |
| CONT_AI08 | Character | Surfaces tradeoffs and constraints before commitment, not after | WARN |
| CONT_AI09 | Character | Plain failure acknowledgment with impact + next steps — no apology inflation | WARN |
| CONT_AI10 | Character | Never uses "Most users choose this" as persuasion | ERROR |

---

## Review Process

1. Run through all **ERROR** rules first — these block shipping
2. Address **WARN** rules — these should be fixed in most cases
3. Consider **INFO** suggestions — nice-to-have polish
4. Cross-check audience scope — consumer rules don't apply to professional UI and vice versa
5. AI rules apply to all AI-generated or agentic content regardless of audience
6. Verify consistency across the entire flow, not just individual screens
7. Check [terminology](terminology.md) for any Zillow-specific terms
