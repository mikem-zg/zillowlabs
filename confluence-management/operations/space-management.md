## Personal Space Handling

### Analysis from Claude Code History

Based on analysis of previous Claude Code sessions, personal space creation requires special handling due to format differences and potential space creation requirements.

**Key Findings:**
- Personal spaces use encoded account ID format: `~{account_id_no_special_chars}`
- Regular spaces use numeric string IDs (e.g., "543948825")
- Personal spaces may need manual creation before page creation
- Error "Expected type is Long" indicates space ID format mismatch

**Successful Patterns Found:**
```javascript
// Account ID: 712020:4c313651-7716-4c70-a312-13cb148f959c
// Becomes: ~7120204c31365177164c70a31213cb148f959c
function encodePersonalSpaceKey(accountId) {
    return '~' + accountId.replace(/[:-]/g, '');
}
```

**Enhanced Error Handling for Personal Spaces:**
```javascript
if (error.message.includes("Expected type is Long") || error.message.includes("space not found")) {
    console.log(`Personal space issue detected:

1. Personal space may not exist yet - create manually first:
   - Go to https://zillowgroup.atlassian.net/wiki
   - Click 'Create Space' → 'Personal Space'
   - Once created, retry page creation

2. Alternative: Use fallback space (FUB, ENG) temporarily

3. Space ID format: Personal spaces use encoded account keys (~accountid)
   Regular spaces use numeric strings ("12345")`);
}
```

**Recommended Workflow for Personal Space Operations:**
1. **Detection**: Check if operation targets personal space
2. **Validation**: Verify personal space exists via space list
3. **Fallback**: Offer alternative spaces (FUB, ENG) if personal unavailable
4. **Guidance**: Provide manual creation steps for personal spaces

**Space Type Detection:**
```bash
# Detect personal space request
if [[ "$space_key" == "personal" || "$space_key" =~ ^~.* ]]; then
    echo "Personal space operation detected - may require manual creation"
fi
```

