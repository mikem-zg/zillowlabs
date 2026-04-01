# Lead Schema & Data Model

Defined in `shared/schema.ts`. The `Lead` type is the unified model used across all data sources.

## Core Lead Fields

| Field | Type | Source | Notes |
|-------|------|--------|-------|
| `id` | string | All | Internal record ID |
| `leadId` | string | All | Primary lead identifier (UUID) |
| `name` | string | Derived | `deriveDisplayName(sender_name, sender_email)` |
| `email` | string | `sender.email` | |
| `phone` | string | `sender.phone` | |
| `zuid` | string | `sender.zuid` | Zillow User ID |
| `polarisId` | string | `sender.polaris_id` | |

## Classification Fields

| Field | Type | Values | Notes |
|-------|------|--------|-------|
| `brand` | string | Zillow, Trulia, StreetEasy, HotPads | |
| `intent` | string | Buy, Sell, Rent, NewCon, Finance | Derived from `contact_form_type`, `listing_type`, `pa_type` |
| `lob` | string | ZHL, PA, Marketing | Line of Business |
| `classification` | string | Selected, Unselected | Lead classification status |
| `subCategory` | string | flex, premier_agent, agent_profile, etc. | |
| `leadQuality` | string | Passed, Spam, Threshold, Deny List | Derived from spam/block flags |
| `medium` | string | Desktop, App, Mobile Web | |

## Engagement Fields

| Field | Type | Notes |
|-------|------|-------|
| `bars` | string | BARS Yes / BARS No / No BARS Response |
| `mar` | string | MAR status (YES/NO) |
| `consumerResolution` | string | Consumer-side outcome |
| `ruleSegment` | string | Routing rule applied |
| `eventTrigger` | string | What triggered the lead |
| `leadProgram` | string | Program the lead belongs to |
| `recipientType` | string | Type of recipient (agent, team) |
| `recipientSelection` | string | How recipient was selected |

## Pearl (Concierge) Fields

| Field | Type | Notes |
|-------|------|-------|
| `pearlDisposition` | string | Connected, Not Interested, No Answer, etc. |
| `pearlOutcome` | string | Pearl conversation outcome |
| `pearlConnection` | string | Connection result |
| `pearlId` | string | Pearl case identifier |
| `pearlCaseId` | string | Concierge case ID |
| `pearlDelivery` | string | Delivery status |
| `pearlConversation` | string[] | SMS messages (legacy, replaced by unified) |

## findPRO / Agent Fields

| Field | Type | Notes |
|-------|------|-------|
| `findProId` | string | findPRO identifier |
| `agentName` | string | Assigned agent name |
| `agentId` | string | Agent account ID |
| `agentAttempts` | number | Number of connection attempts |
| `agentOutcome` | string | Agent connection outcome |
| `recordingUrl` | string | Call recording URL |
| `result` | string | Connected, No Answer, Rejected, etc. |

## Transaction Fields

| Field | Type | Notes |
|-------|------|-------|
| `transactionId` | string | Matched transaction ID |
| `transactionSide` | string | Buy or Sell |
| `closeDate` | string | Transaction close date |
| `transactionZpid` | string | Zillow Property ID |

## Property Fields

| Field | Type | Notes |
|-------|------|-------|
| `propertyAddress` | string | Street address |
| `propertyCity` | string | City |
| `propertyState` | string | State |
| `propertyZip` | string | ZIP code |

## Timestamp Fields

| Field | Type | Notes |
|-------|------|-------|
| `createdAt` | string | Lead creation timestamp |
| `updatedAt` | string | Last update timestamp |
| `enriched` | boolean | Whether enrichment has been applied |

## Related Types

### VoiceCall
```
callId, externalNumber, direction (inbound/outbound), startTime, endTime,
duration, callType, language, leadId
```

### VoiceTranscriptSegment
```
channel (internal/external), speaker, content, startTime, endTime, confidence
```

### UnifiedConversation
```
conversationId, channel (sms/voice/chat), participantRole, participantName,
messages[], metadata (leadId, caseId), startTime
```

### UnifiedMessage
```
id, sender, content, timestamp, direction (inbound/outbound)
```

## Derivation Logic

### `deriveIntent(row)`
Priority: `contact_form_type` → `listing_type` → `pa_type`
- "sell" in form type → "Sell"
- "rent" in listing type → "Rent"
- "newcon" → "NewCon"
- Default: "Buy"

### `deriveLob(row)`
- ZHL-related fields present → "ZHL"
- Default: determined by table source

### `deriveLeadQuality(row)`
- `is_spam=true` → "Spam"
- `quality_blocked=true` → checks `block_reason` for "threshold" or "deny"
- Default: "Passed"

### `deriveBarsValue(row)`
- `bars_yes > 0` → "BARS Yes"
- `bars_no > 0` → "BARS No"
- Default: "No BARS Response"
