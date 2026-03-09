# Copy Patterns

Expanded copy examples and templates for common UI patterns. All examples follow Zillow voice & tone and sentence case rules.

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
- Something went wrong. Refresh the page or try again later.
- This email is already in use. Try signing in instead.

### Success
- Your listing was published. **View listing**
- Your profile was updated. **View profile**
- Changes saved.
- Your password was updated. You can now sign in with your new password.

### Empty States
- You haven't saved any homes yet. **Start a new search**
- Your renter profile isn't set up. **Create renter profile**
- No results match your filters. Try adjusting your search criteria.
- You don't have any notifications yet.

---

## Audience-Specific Examples

### Consumer (Buyers, Renters, Sellers)

Tone: Joyful, vibrant, emotional. Speak to the person's goal, not just the data.

| Context | Example |
|---------|---------|
| Save confirmation | "Home saved! You can find it in your saved homes." |
| Empty saved homes | "You haven't saved any homes yet. Start exploring to find the one." |
| Search prompt | "Where do you want to live?" |
| Onboarding welcome | "Welcome to Zillow. We'll help you find a place you'll love." |
| Error | "We couldn't load your saved homes. Try refreshing the page." |
| Tour scheduled | "Your tour is scheduled. We'll send you a reminder." |

### Professional (Agents, Loan Officers, Property Managers)

Tone: Efficient, organized, trustworthy. Lead with data and outcomes, not enthusiasm.

| Context | Example |
|---------|---------|
| Lead assigned | "3 new leads assigned to your pipeline." |
| Empty pipeline | "No leads in your pipeline. Leads will appear here as they're assigned." |
| Dashboard prompt | "Review your team's performance this week." |
| Onboarding welcome | "Welcome to your dashboard. Start by connecting your CRM." |
| Error | "We couldn't sync your leads. Check your integration settings." |
| Report ready | "Your monthly report is ready. Download or share it with your team." |

---

## Pattern Templates

### Modal Confirmation (Destructive Action)
```
Header:  Delete [item]?
Body:    This will permanently delete [item]. You cannot undo this action.
Cancel:  Cancel
Confirm: Delete
```

### Modal Confirmation (Non-Destructive)
```
Header:  Save changes?
Body:    You have unsaved changes. Would you like to save before leaving?
Cancel:  Discard
Confirm: Save changes
```

### Onboarding Step
```
Heading:     [Benefit-oriented headline]
Description: [One sentence explaining the value]
CTA:         [Action verb] — e.g., "Get started", "Connect your account"
Skip:        "Skip for now"
```

Consumer example:
```
Heading:     Find homes you'll love
Description: Tell us what you're looking for and we'll match you with listings.
CTA:         Get started
```

Professional example:
```
Heading:     Set up your pipeline
Description: Connect your CRM to automatically sync leads and contacts.
CTA:         Connect CRM
```

### Notification / Toast
```
[What happened] + [Optional next step]
```
- Keep to one line when possible
- Use sentence case
- No period if it's a fragment; period if it's a full sentence

Examples:
- "Changes saved"
- "Lead assigned to Sarah M."
- "Your listing was published. View listing"

### Tooltip / Helper Text
```
[Brief explanation of what this control does]
```
- Max ~80 characters
- No period unless a full sentence
- Don't repeat the label

Examples:
- "Only you can see your saved homes"
- "We'll use this to verify your identity"
- "Appears on your public profile"

### Loading States
```
[What's happening]...
```
- Use present participle ("Loading...", "Saving...", "Syncing leads...")
- Keep under 3 words when possible

### Pagination / List Counts
```
Showing [n] of [total] [items]
```
- Always use numerals
- Use the item's actual name, not a generic word

Examples:
- "Showing 10 of 248 homes"
- "3 of 12 leads"

---

## Punctuation Quick Reference

| Rule | Example |
|------|---------|
| No em dashes (—) or en dashes (–) | Use commas or separate sentences instead |
| No Oxford comma debates — just be consistent | "Beds, baths, and sqft" or "Beds, baths and sqft" — pick one per project |
| Periods on full sentences only | "Changes saved" (no period) vs "Your changes were saved." (period) |
| No exclamation marks in professional data UI | "Lead assigned" not "Lead assigned!" |
| Consumer celebrations can use one exclamation | "Home saved!" is OK in consumer contexts |
| Question marks in prompts | "Where do you want to live?" |
