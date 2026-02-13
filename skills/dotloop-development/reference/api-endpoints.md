# Dotloop API v2 — Complete Endpoint Reference

## Base URL

```
https://api-gateway.dotloop.com/public/v2/
```

All requests require HTTPS. Every request must include an OAuth 2.0 Bearer token:

```
Authorization: Bearer ACCESS_TOKEN
Content-Type: application/json
```

**Rate Limits:** 100 requests per window. Check `X-RateLimit-Remaining` header.
**Pagination:** Batch-based — `batch_number` (starting at 1) + `batch_size` (max 50).

---

## Endpoint Summary

| # | Resource | Base Path | Methods |
|---|----------|-----------|---------|
| 1 | [Account](#1-account) | `/account` | GET |
| 2 | [Profiles](#2-profiles) | `/profile` | GET, POST, PATCH |
| 3 | [Loops](#3-loops-transactions) | `/profile/:profile_id/loop` | GET, POST, PATCH |
| 4 | [Loop-It](#4-loop-it-facade-api) | `/loop-it` | POST |
| 5 | [Loop Details](#5-loop-details) | `/profile/:profile_id/loop/:loop_id/detail` | GET, PATCH |
| 6 | [Participants](#6-participants) | `/profile/:profile_id/loop/:loop_id/participant` | GET, POST, PATCH, DELETE |
| 7 | [Folders](#7-folders) | `/profile/:profile_id/loop/:loop_id/folder` | GET, POST, PATCH |
| 8 | [Documents](#8-documents) | `/profile/:profile_id/loop/:loop_id/folder/:folder_id/document` | GET, POST |
| 9 | [Contacts](#9-contacts) | `/contact` | GET, POST, PATCH |
| 10 | [Templates](#10-templates) | `/profile/:profile_id/loop-template` | GET |
| 11 | [Activity](#11-activity) | `/profile/:profile_id/loop/:loop_id/activity` | GET |
| 12 | [Task Lists](#12-task-lists) | `/profile/:profile_id/loop/:loop_id/tasklist` | GET |
| 13 | [Webhook Subscriptions](#13-webhook-subscriptions) | `/subscription` | GET, POST, PATCH, DELETE |

---

## 1. Account

**Scope required:** `account:read`

### GET /account — Get Current User Account Info

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/account" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch('https://api-gateway.dotloop.com/public/v2/account', {
  headers: { 'Authorization': `Bearer ${accessToken}` },
});
const { data } = await response.json();
```

#### Response

```json
{
  "data": {
    "id": 12345,
    "firstName": "John",
    "lastName": "Smith",
    "email": "john.smith@example.com",
    "defaultProfileId": 4711
  }
}
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | User account ID |
| `firstName` | string | User's first name |
| `lastName` | string | User's last name |
| `email` | string | User's email address |
| `defaultProfileId` | integer | Default profile ID for this user |

---

## 2. Profiles

**Scope required:** `profile:read` (GET), `profile:write` (POST, PATCH)

**Profile types:** `INDIVIDUAL`, `OFFICE`, `BROKERAGE`

> ⚠️ **Loop access is restricted to INDIVIDUAL profiles only.** You cannot create or access loops on OFFICE or BROKERAGE profiles.

### GET /profile — List All Profiles

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch('https://api-gateway.dotloop.com/public/v2/profile', {
  headers: { 'Authorization': `Bearer ${accessToken}` },
});
const { data } = await response.json();
```

#### Response

```json
{
  "data": [
    {
      "id": 4711,
      "name": "John Smith",
      "type": "INDIVIDUAL",
      "company": "Acme Realty",
      "phone": "555-123-4567",
      "fax": "555-123-4568",
      "address": "123 Main St",
      "city": "San Francisco",
      "state": "CA",
      "zipCode": "94114",
      "default": true,
      "requiresTemplate": false
    }
  ]
}
```

### GET /profile/:profile_id — Get Individual Profile

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch(`https://api-gateway.dotloop.com/public/v2/profile/${profileId}`, {
  headers: { 'Authorization': `Bearer ${accessToken}` },
});
const { data } = await response.json();
```

### POST /profile — Create New Profile

```bash
curl -X POST "https://api-gateway.dotloop.com/public/v2/profile" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Jane Doe",
    "company": "Acme Realty",
    "phone": "555-987-6543",
    "address": "456 Oak Ave",
    "city": "Los Angeles",
    "zipCode": "90001",
    "state": "CA",
    "country": "US"
  }'
```

```typescript
const response = await fetch('https://api-gateway.dotloop.com/public/v2/profile', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${accessToken}`,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    name: 'Jane Doe',
    company: 'Acme Realty',
    phone: '555-987-6543',
    address: '456 Oak Ave',
    city: 'Los Angeles',
    zipCode: '90001',
    state: 'CA',
    country: 'US',
  }),
});
```

#### Create Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `name` | string | Yes | Profile name |
| `company` | string | No | Company name |
| `phone` | string | No | Phone number |
| `address` | string | No | Street address |
| `city` | string | No | City |
| `zipCode` | string | No | ZIP/postal code |
| `state` | string | No | State |
| `country` | string | No | Country code |

### PATCH /profile/:profile_id — Update Profile

```bash
curl -X PATCH "https://api-gateway.dotloop.com/public/v2/profile/4711" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "phone": "555-111-2222",
    "company": "New Realty Corp"
  }'
```

```typescript
const response = await fetch(`https://api-gateway.dotloop.com/public/v2/profile/${profileId}`, {
  method: 'PATCH',
  headers: {
    'Authorization': `Bearer ${accessToken}`,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    phone: '555-111-2222',
    company: 'New Realty Corp',
  }),
});
```

#### Profile Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Profile ID |
| `name` | string | Profile name |
| `type` | string | `INDIVIDUAL`, `OFFICE`, or `BROKERAGE` |
| `company` | string | Company name |
| `phone` | string | Phone number |
| `fax` | string | Fax number |
| `address` | string | Street address |
| `city` | string | City |
| `state` | string | State |
| `zipCode` | string | ZIP code |
| `default` | boolean | Whether this is the default profile |
| `requiresTemplate` | boolean | Whether loops require a template |

---

## 3. Loops (Transactions)

**Scope required:** `loop:read` (GET), `loop:write` (POST, PATCH)

> ⚠️ **CRITICAL: Always use `loop_view_id`, NOT `loop_id`.** Loop IDs can change when loops are merged. The API handles this via 301 redirects, but always store and use the view ID.

### GET /profile/:profile_id/loop — List All Loops

Returns max 50 loops per batch. Use `batch_number` and `batch_size` to paginate.

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop?batch_number=1&batch_size=50" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const params = new URLSearchParams({
  batch_number: '1',
  batch_size: '50',
});
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop?${params}`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

#### Query Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `batch_number` | integer | Page number (starts at 1) |
| `batch_size` | integer | Results per page (max 50) |
| `statusIds` | string | Filter by status IDs (comma-separated) |
| `complianceStatusIds` | string | Filter by compliance status IDs |
| `tagIds` | string | Filter by tag IDs |
| `tagNames` | string | Filter by tag names |
| `sortBy` | string | Sort field |
| `searchQuery` | string | Search query string |
| `createdByMe` | boolean | Filter to loops created by current user |

### GET /profile/:profile_id/loop/:loop_id — Get Loop Details

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

#### Response

```json
{
  "data": {
    "id": 34308,
    "profileId": 4711,
    "name": "Brian Erwin",
    "transactionType": "PURCHASE_OFFER",
    "status": "PRE_OFFER",
    "created": "2017-05-30T21:42:17Z",
    "updated": "2017-05-31T23:27:11Z",
    "loopUrl": "https://www.dotloop.com/m/loop?viewId=34308"
  }
}
```

### POST /profile/:profile_id/loop — Create New Loop

```bash
curl -X POST "https://api-gateway.dotloop.com/public/v2/profile/4711/loop" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Smith Purchase - 123 Main St",
    "transactionType": "PURCHASE_OFFER",
    "status": "PRE_OFFER",
    "templateId": 1424
  }'
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop`,
  {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      name: 'Smith Purchase - 123 Main St',
      transactionType: 'PURCHASE_OFFER',
      status: 'PRE_OFFER',
      templateId: 1424,
    }),
  }
);
const { data } = await response.json();
```

#### Create Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `name` | string | Yes | Loop name |
| `transactionType` | string | Yes | See [Transaction Types](#transaction-types) |
| `status` | string | Yes | See [Status Values](#status-values) |
| `templateId` | integer | No* | Loop template ID (*may be required by organization if `requiresTemplate` is true) |

### PATCH /profile/:profile_id/loop/:loop_id — Update Loop

```bash
curl -X PATCH "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "status": "UNDER_CONTRACT",
    "name": "Smith Purchase - Updated"
  }'
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}`,
  {
    method: 'PATCH',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      status: 'UNDER_CONTRACT',
      name: 'Smith Purchase - Updated',
    }),
  }
);
```

#### Loop Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Loop view ID |
| `profileId` | integer | Profile ID the loop belongs to |
| `name` | string | Loop name |
| `transactionType` | string | Transaction type |
| `status` | string | Current status |
| `created` | string | ISO 8601 creation timestamp |
| `updated` | string | ISO 8601 last update timestamp |
| `loopUrl` | string | URL to open the loop in dotloop.com |

---

## 4. Loop-It Facade API

> **THE MOST IMPORTANT ENDPOINT FOR QUICK START.** Creates a loop, adds participants, and sets property info all in ONE call.

**Scope required:** `loop:write`

> ⚠️ **Access restricted to INDIVIDUAL profiles only.** The `profile_id` query parameter is required if the account has more than one profile.

### POST /loop-it — Create Loop with Participants and Property

```bash
curl -X POST "https://api-gateway.dotloop.com/public/v2/loop-it?profile_id=4711" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Brian Erwin",
    "transactionType": "PURCHASE_OFFER",
    "status": "PRE_OFFER",
    "streetName": "Waterview Dr",
    "streetNumber": "2100",
    "unit": "4B",
    "city": "San Francisco",
    "zipCode": "94114",
    "state": "CA",
    "country": "US",
    "participants": [
      {
        "fullName": "Brian Erwin",
        "email": "brian@example.com",
        "role": "BUYER"
      },
      {
        "fullName": "Allen Agent",
        "email": "allen@example.com",
        "role": "LISTING_AGENT"
      }
    ],
    "templateId": 1424
  }'
```

```typescript
const params = new URLSearchParams({ profile_id: profileId.toString() });
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/loop-it?${params}`,
  {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      name: 'Brian Erwin',
      transactionType: 'PURCHASE_OFFER',
      status: 'PRE_OFFER',
      streetName: 'Waterview Dr',
      streetNumber: '2100',
      unit: '4B',
      city: 'San Francisco',
      zipCode: '94114',
      state: 'CA',
      country: 'US',
      participants: [
        { fullName: 'Brian Erwin', email: 'brian@example.com', role: 'BUYER' },
        { fullName: 'Allen Agent', email: 'allen@example.com', role: 'LISTING_AGENT' },
      ],
      templateId: 1424,
    }),
  }
);
const { data } = await response.json();
const loopUrl = data.loopUrl;
```

#### Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `name` | string | Yes | Loop name |
| `transactionType` | string | Yes | See [Transaction Types](#transaction-types) |
| `status` | string | Yes | See [Status Values](#status-values) |
| `streetName` | string | No | Property street name |
| `streetNumber` | string | No | Property street number |
| `unit` | string | No | Unit/suite number |
| `city` | string | No | Property city |
| `state` | string | No | Property state |
| `zipCode` | string | No | Property ZIP code |
| `county` | string | No | Property county |
| `country` | string | No | Property country |
| `participants` | array | No | Array of participant objects |
| `participants[].fullName` | string | Yes* | Participant full name |
| `participants[].email` | string | No | Participant email |
| `participants[].role` | string | Yes* | See [Participant Roles](#participant-roles) |
| `templateId` | integer | No | Loop template ID |
| `mlsPropertyId` | string | No | MLS property ID |
| `mlsId` | string | No | MLS system ID |
| `mlsAgentId` | string | No | MLS agent ID |
| `nrdsId` | string | No | NRDS ID |

#### Query Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `profile_id` | integer | Conditional | Required if account has more than one profile |

#### Response (201 Created)

```json
{
  "data": {
    "id": 34308,
    "profileId": 4711,
    "name": "Brian Erwin",
    "transactionType": "PURCHASE_OFFER",
    "status": "PRE_OFFER",
    "created": "2017-05-30T21:42:17Z",
    "updated": "2017-05-31T23:27:11Z",
    "loopUrl": "https://www.dotloop.com/m/loop?viewId=34308"
  }
}
```

> **Tip:** Use the returned `loopUrl` to redirect the user directly into dotloop.com to continue working on the transaction.

---

## 5. Loop Details

**Scope required:** `loop:read` (GET), `loop:write` (PATCH)

> ⚠️ **Sections are dynamic.** Empty fields are NOT included in the response. Do not assume any specific property will always exist.

### GET /profile/:profile_id/loop/:loop_id/detail — Get Loop Detail Sections

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/detail" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/detail`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

#### Response

```json
{
  "data": {
    "Property Address": {
      "streetNumber": "2100",
      "streetName": "Waterview Dr",
      "city": "San Francisco",
      "stateOrProvince": "CA",
      "postalCode": "94114",
      "country": "US",
      "mlsNumber": "MLS12345"
    },
    "Financials": {
      "purchasePrice": "450000",
      "earnestMoneyHeldBy": "Acme Title"
    },
    "Contract Dates": {
      "ContractDate": "2025-01-15",
      "ClosingDate": "2025-03-01"
    }
  }
}
```

### PATCH /profile/:profile_id/loop/:loop_id/detail — Update Loop Detail Sections

```bash
curl -X PATCH "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/detail" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "Property Address": {
      "streetNumber": "2100",
      "streetName": "Waterview Dr",
      "city": "San Francisco",
      "stateOrProvince": "CA",
      "postalCode": "94114"
    },
    "Financials": {
      "purchasePrice": "475000",
      "commissionRate": "3.0"
    },
    "Contract Dates": {
      "ContractDate": "2025-01-20",
      "ClosingDate": "2025-03-15",
      "InspectionDate": "2025-02-01"
    }
  }'
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/detail`,
  {
    method: 'PATCH',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      'Property Address': {
        streetNumber: '2100',
        streetName: 'Waterview Dr',
        city: 'San Francisco',
        stateOrProvince: 'CA',
        postalCode: '94114',
      },
      'Financials': {
        purchasePrice: '475000',
        commissionRate: '3.0',
      },
      'Contract Dates': {
        ContractDate: '2025-01-20',
        ClosingDate: '2025-03-15',
        InspectionDate: '2025-02-01',
      },
    }),
  }
);
```

#### Detail Sections and Fields

| Section | Fields |
|---------|--------|
| **Property Address** | `streetNumber`, `streetName`, `city`, `stateOrProvince`, `postalCode`, `country`, `mlsNumber` |
| **Financials** | `purchasePrice`, `originalListingPrice`, `currentPrice`, `commissionRate`, `earnestMoneyHeldBy` |
| **Contract Dates** | `ContractDate`, `ClosingDate`, `OfferDate`, `ExpirationDate`, `InspectionDate`, `AppraisalDate` |
| **Closing Information** | `ClosingDate`, `ActualClosingDate`, `ClosingLocation`, `TitleCompany`, `ClosingAttorney` |
| **Listing Information** | `ListPrice`, `ListingDate`, `ExpirationDate` |
| **Listing Brokerage** | `name`, `address`, `city`, `state`, `zipCode`, `officePhone` |
| **Buying Brokerage** | `name`, `address`, `city`, `state`, `zipCode` |

---

## 6. Participants

**Scope required:** `loop:read` (GET), `loop:write` (POST, PATCH, DELETE)

### GET /profile/:profile_id/loop/:loop_id/participant — List Participants

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/participant" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/participant`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

#### Response

```json
{
  "data": [
    {
      "participantId": 9001,
      "fullName": "Brian Erwin",
      "email": "brian@example.com",
      "role": "BUYER",
      "memberOfMyTeam": false
    },
    {
      "participantId": 9002,
      "fullName": "Allen Agent",
      "email": "allen@example.com",
      "role": "LISTING_AGENT",
      "memberOfMyTeam": true
    }
  ]
}
```

### GET /profile/:profile_id/loop/:loop_id/participant/:participant_id — Get Participant

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/participant/9001" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/participant/${participantId}`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

### POST /profile/:profile_id/loop/:loop_id/participant — Add Participant

```bash
curl -X POST "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/participant" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "Sarah Escrow",
    "email": "sarah@titleco.com",
    "role": "ESCROW_OFFICER"
  }'
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/participant`,
  {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      fullName: 'Sarah Escrow',
      email: 'sarah@titleco.com',
      role: 'ESCROW_OFFICER',
    }),
  }
);
```

### PATCH /profile/:profile_id/loop/:loop_id/participant/:participant_id — Update Participant

```bash
curl -X PATCH "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/participant/9001" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "brian.new@example.com"
  }'
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/participant/${participantId}`,
  {
    method: 'PATCH',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ email: 'brian.new@example.com' }),
  }
);
```

### DELETE /profile/:profile_id/loop/:loop_id/participant/:participant_id — Remove Participant

```bash
curl -X DELETE "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/participant/9001" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/participant/${participantId}`,
  {
    method: 'DELETE',
    headers: { 'Authorization': `Bearer ${accessToken}` },
  }
);
```

#### Participant Fields

| Field | Type | Description |
|-------|------|-------------|
| `participantId` | integer | Participant ID |
| `fullName` | string | Full name |
| `email` | string | Email address |
| `role` | string | Participant role (see below) |
| `memberOfMyTeam` | boolean | Whether participant is on the user's team |

#### Participant Roles

| Role | Description |
|------|-------------|
| `BUYER` | Buyer |
| `SELLER` | Seller |
| `LISTING_AGENT` | Listing agent |
| `SELLING_AGENT` | Selling/buyer's agent |
| `MANAGING_BROKER` | Managing broker |
| `ESCROW_OFFICER` | Escrow officer |
| `TITLE_COMPANY` | Title company representative |
| `LENDER` | Lender |
| `APPRAISER` | Appraiser |
| `INSPECTOR` | Inspector |

---

## 7. Folders

**Scope required:** `loop:read` (GET), `loop:write` (POST, PATCH)

### GET /profile/:profile_id/loop/:loop_id/folder — List Folders

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/folder" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/folder`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

### GET /profile/:profile_id/loop/:loop_id/folder/:folder_id — Get Folder

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/folder/5001" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/folder/${folderId}`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

### POST /profile/:profile_id/loop/:loop_id/folder — Create Folder

```bash
curl -X POST "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/folder" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Inspection Reports"
  }'
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/folder`,
  {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ name: 'Inspection Reports' }),
  }
);
```

### PATCH /profile/:profile_id/loop/:loop_id/folder/:folder_id — Update Folder

```bash
curl -X PATCH "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/folder/5001" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Inspection & Appraisal Reports"
  }'
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/folder/${folderId}`,
  {
    method: 'PATCH',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ name: 'Inspection & Appraisal Reports' }),
  }
);
```

---

## 8. Documents

**Scope required:** `loop:read` (GET), `loop:write` (POST)

### GET /profile/:profile_id/loop/:loop_id/folder/:folder_id/document — List Documents in Folder

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/folder/5001/document" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/folder/${folderId}/document`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

### GET /profile/:profile_id/loop/:loop_id/document/:document_id — Get Document Info

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/document/7001" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/document/${documentId}`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

### POST /profile/:profile_id/loop/:loop_id/folder/:folder_id/document — Upload Document

Upload uses `multipart/form-data`:

```bash
curl -X POST "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/folder/5001/document" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -F "file=@/path/to/contract.pdf" \
  -F "name=Purchase Agreement"
```

```typescript
const formData = new FormData();
formData.append('file', fileBuffer, 'contract.pdf');
formData.append('name', 'Purchase Agreement');

const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/folder/${folderId}/document`,
  {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
    },
    body: formData,
  }
);
const { data } = await response.json();
```

### GET /profile/:profile_id/loop/:loop_id/document/:document_id/download — Download Document as PDF

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/document/7001/download" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -o document.pdf
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/document/${documentId}/download`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const pdfBuffer = await response.arrayBuffer();
```

---

## 9. Contacts

**Scope required:** `contact:read` (GET), `contact:write` (POST, PATCH)

> Contacts are **global** — they are NOT scoped to a profile.

### GET /contact — List Contacts

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/contact?batch_number=1&batch_size=50" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const params = new URLSearchParams({
  batch_number: '1',
  batch_size: '50',
});
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/contact?${params}`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

#### Query Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `batch_number` | integer | Page number (starts at 1) |
| `batch_size` | integer | Results per page (max 50) |

### GET /contact/:contact_id — Get Contact

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/contact/8001" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/contact/${contactId}`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

### POST /contact — Create Contact

```bash
curl -X POST "https://api-gateway.dotloop.com/public/v2/contact" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Maria",
    "lastName": "Garcia",
    "email": "maria@example.com",
    "home": "555-111-2222",
    "office": "555-333-4444",
    "fax": "555-555-6666",
    "cell": "555-777-8888",
    "address": "789 Pine St",
    "city": "Austin",
    "state": "TX",
    "zipCode": "78701",
    "country": "US"
  }'
```

```typescript
const response = await fetch('https://api-gateway.dotloop.com/public/v2/contact', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${accessToken}`,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    firstName: 'Maria',
    lastName: 'Garcia',
    email: 'maria@example.com',
    home: '555-111-2222',
    office: '555-333-4444',
    fax: '555-555-6666',
    cell: '555-777-8888',
    address: '789 Pine St',
    city: 'Austin',
    state: 'TX',
    zipCode: '78701',
    country: 'US',
  }),
});
```

### PATCH /contact/:contact_id — Update Contact

```bash
curl -X PATCH "https://api-gateway.dotloop.com/public/v2/contact/8001" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "cell": "555-999-0000",
    "address": "456 New Address Ave"
  }'
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/contact/${contactId}`,
  {
    method: 'PATCH',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      cell: '555-999-0000',
      address: '456 New Address Ave',
    }),
  }
);
```

#### Contact Fields

| Field | Type | Description |
|-------|------|-------------|
| `firstName` | string | First name |
| `lastName` | string | Last name |
| `email` | string | Email address |
| `home` | string | Home phone |
| `office` | string | Office phone |
| `fax` | string | Fax number |
| `cell` | string | Cell phone |
| `address` | string | Street address |
| `city` | string | City |
| `state` | string | State |
| `zipCode` | string | ZIP code |
| `country` | string | Country |

---

## 10. Templates

**Scope required:** `template:read`

### GET /profile/:profile_id/loop-template — List Loop Templates

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop-template" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop-template`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

### GET /profile/:profile_id/loop-template/:template_id — Get Template Details

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop-template/1424" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop-template/${templateId}`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

---

## 11. Activity

**Scope required:** `loop:read`

### GET /profile/:profile_id/loop/:loop_id/activity — Get Loop Activity Log

Supports batch pagination (`batch_number`, `batch_size`).

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/activity?batch_number=1&batch_size=50" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const params = new URLSearchParams({
  batch_number: '1',
  batch_size: '50',
});
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/activity?${params}`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

#### Response

```json
{
  "data": [
    {
      "message": "Brian Erwin was added as Buyer",
      "activityDate": "2025-01-15T10:30:00Z"
    },
    {
      "message": "Purchase Agreement was uploaded",
      "activityDate": "2025-01-16T14:00:00Z"
    }
  ]
}
```

#### Activity Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `message` | string | Description of the activity |
| `activityDate` | string | ISO 8601 timestamp of the activity |

---

## 12. Task Lists

**Scope required:** `loop:read`

### GET /profile/:profile_id/loop/:loop_id/tasklist — List Task Lists

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/tasklist" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/tasklist`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

### GET /profile/:profile_id/loop/:loop_id/tasklist/:tasklist_id — Get Task List

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/tasklist/6001" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/tasklist/${tasklistId}`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

### GET /profile/:profile_id/loop/:loop_id/tasklist/:tasklist_id/task — List Tasks

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/tasklist/6001/task" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/tasklist/${tasklistId}/task`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

### GET /profile/:profile_id/loop/:loop_id/tasklist/:tasklist_id/task/:task_id — Get Task

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop/34308/tasklist/6001/task/7001" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop/${loopId}/tasklist/${tasklistId}/task/${taskId}`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

---

## 13. Webhook Subscriptions

> For detailed webhook event types, payloads, and signature verification, see [webhooks.md](webhooks.md).

### GET /subscription — List All Subscriptions

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/subscription" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch('https://api-gateway.dotloop.com/public/v2/subscription', {
  headers: { 'Authorization': `Bearer ${accessToken}` },
});
const { data } = await response.json();
```

### POST /subscription — Create Subscription

```bash
curl -X POST "https://api-gateway.dotloop.com/public/v2/subscription" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://yourapp.com/webhooks/dotloop",
    "eventTypes": ["LOOP_CREATED", "LOOP_UPDATED", "LOOP_PARTICIPANT_CREATED"],
    "signingKey": "your_webhook_secret",
    "externalId": "your-tracking-id"
  }'
```

```typescript
const response = await fetch('https://api-gateway.dotloop.com/public/v2/subscription', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${accessToken}`,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    url: 'https://yourapp.com/webhooks/dotloop',
    eventTypes: ['LOOP_CREATED', 'LOOP_UPDATED', 'LOOP_PARTICIPANT_CREATED'],
    signingKey: 'your_webhook_secret',
    externalId: 'your-tracking-id',
  }),
});
```

### GET /subscription/:subscription_id — Get Subscription

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/subscription/sub_123" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/subscription/${subscriptionId}`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const { data } = await response.json();
```

### PATCH /subscription/:subscription_id — Update Subscription

```bash
curl -X PATCH "https://api-gateway.dotloop.com/public/v2/subscription/sub_123" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://yourapp.com/webhooks/dotloop-v2",
    "eventTypes": ["LOOP_CREATED", "LOOP_UPDATED"]
  }'
```

```typescript
const response = await fetch(
  `https://api-gateway.dotloop.com/public/v2/subscription/${subscriptionId}`,
  {
    method: 'PATCH',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      url: 'https://yourapp.com/webhooks/dotloop-v2',
      eventTypes: ['LOOP_CREATED', 'LOOP_UPDATED'],
    }),
  }
);
```

### DELETE /subscription/:subscription_id — Delete Subscription

```bash
curl -X DELETE "https://api-gateway.dotloop.com/public/v2/subscription/sub_123" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```typescript
await fetch(
  `https://api-gateway.dotloop.com/public/v2/subscription/${subscriptionId}`,
  {
    method: 'DELETE',
    headers: { 'Authorization': `Bearer ${accessToken}` },
  }
);
```

---

## Transaction Types

| Value | Description |
|-------|-------------|
| `PURCHASE_OFFER` | Buyer making an offer |
| `LISTING_FOR_SALE` | Listing agent creating a sale listing |
| `LISTING_FOR_LEASE` | Listing agent creating a rental listing |
| `LEASE` | Buyer/tenant making a lease offer |
| `REAL_ESTATE_OTHER` | Non-standard real estate transaction |
| `OTHER` | Non-real estate loop (limited fields/roles) |

## Status Values

| Value | Description |
|-------|-------------|
| `PRE_OFFER` | Before offer is made (purchase) |
| `PRE_LISTING` | Before listing goes active |
| `PRIVATE_LISTING` | Private/pocket listing |
| `ACTIVE_LISTING` | Active on market |
| `UNDER_CONTRACT` | Offer accepted |
| `SOLD` | Closed/sold |

---

## OAuth 2.0 Scopes Reference

| Scope | Access |
|-------|--------|
| `account:read` | Read account details |
| `profile:read` | Read profiles |
| `profile:write` | Create/update profiles |
| `loop:read` | Read loops, participants, documents, details, activity, tasks |
| `loop:write` | Create/update loops, participants, upload documents |
| `contact:read` | Read contacts |
| `contact:write` | Create/update contacts |
| `template:read` | Read loop templates |

---

## Batch Pagination Pattern

All list endpoints use batch-based pagination (NOT offset-based):

```typescript
async function fetchAllLoops(profileId: number, accessToken: string) {
  const allLoops: any[] = [];
  let batchNumber = 1;
  const batchSize = 50;

  while (true) {
    const params = new URLSearchParams({
      batch_number: batchNumber.toString(),
      batch_size: batchSize.toString(),
    });
    const response = await fetch(
      `https://api-gateway.dotloop.com/public/v2/profile/${profileId}/loop?${params}`,
      { headers: { 'Authorization': `Bearer ${accessToken}` } }
    );
    const { data } = await response.json();

    if (!data || data.length === 0) break;
    allLoops.push(...data);

    if (data.length < batchSize) break;
    batchNumber++;
  }

  return allLoops;
}
```

```bash
curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop?batch_number=1&batch_size=50" \
  -H "Authorization: Bearer $ACCESS_TOKEN"

curl -X GET "https://api-gateway.dotloop.com/public/v2/profile/4711/loop?batch_number=2&batch_size=50" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

---

## Error Responses

| HTTP Status | Meaning | Action |
|-------------|---------|--------|
| `400` | Bad request — invalid parameters | Check request body/params |
| `401` | Unauthorized — invalid or expired token | Refresh access token |
| `403` | Forbidden — insufficient scope or permissions | Check OAuth scopes |
| `404` | Resource not found | Verify IDs in path |
| `301` | Loop merged — redirected to new loop_view_id | Follow redirect, update stored ID |
| `429` | Rate limit exceeded | Back off, check `X-RateLimit-Remaining` |
| `500` | Server error | Retry with exponential backoff |

---

## Rate Limiting Headers

| Header | Description |
|--------|-------------|
| `X-RateLimit-Limit` | Max requests per window |
| `X-RateLimit-Remaining` | Requests remaining in current window |
| `X-RateLimit-Reset` | Timestamp when the window resets |

```typescript
const response = await fetch(url, { headers });
const remaining = parseInt(response.headers.get('X-RateLimit-Remaining') || '100');
if (remaining < 10) {
  const resetTime = parseInt(response.headers.get('X-RateLimit-Reset') || '0');
  const waitMs = Math.max(0, resetTime * 1000 - Date.now());
  await new Promise(resolve => setTimeout(resolve, waitMs));
}
```
