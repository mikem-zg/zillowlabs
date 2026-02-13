# Google Maps API Key Setup

## Table of Contents

- [Step 1: Create a Google Cloud Project](#step-1-create-a-google-cloud-project)
- [Step 2: Enable the Maps JavaScript API](#step-2-enable-the-maps-javascript-api)
- [Step 3: Create an API Key](#step-3-create-an-api-key)
- [Step 4: Restrict the Key](#step-4-restrict-the-key)
- [Step 5: Add to Replit](#step-5-add-to-replit)
- [Step 6: Set Up a Map ID](#step-6-set-up-a-map-id-required-for-advancedmarkers)
- [Billing & Quotas](#billing--quotas)
- [Security Checklist](#security-checklist)

## Step 1: Create a Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable billing (required — includes $200/month free credit)

## Step 2: Enable the Maps JavaScript API

1. Go to **APIs & Services → Library**
2. Search for **Maps JavaScript API** and enable it
3. Enable additional APIs as needed:

| API | Enable if you need |
|-----|--------------------|
| Maps JavaScript API | Maps, markers, InfoWindows (always required) |
| Places API | Address autocomplete, place search, place details |
| Directions API | Route calculation between points |
| Geocoding API | Address ↔ coordinate conversion |
| Distance Matrix API | Travel time/distance between multiple points |

## Step 3: Create an API Key

1. Go to **APIs & Services → Credentials**
2. Click **Create Credentials → API key**
3. Copy the key immediately

## Step 4: Restrict the Key

### Application Restriction (HTTP Referrers for web apps)

1. Click on the key name to edit
2. Under **Application restrictions**, select **HTTP referrers**
3. Add your allowed domains:

| Environment | Referrer Pattern |
|------------|-----------------|
| Replit dev | `*.replit.dev/*` |
| Replit app (published) | `*.replit.app/*` |
| Custom domain | `yourdomain.com/*` |

### API Restriction

1. Under **API restrictions**, select **Restrict key**
2. Select only the APIs you enabled in Step 2

## Step 5: Add to Replit

### As a Secret (Recommended)

Use the Replit Secrets tab or request the secret via the agent:

| Secret Name | Value |
|------------|-------|
| `GOOGLE_MAPS_API_KEY` | Your API key from Step 3 |

### Expose to Client via Vite

The API key must reach the browser (it's a client-side API). Two approaches:

**Option A: Vite define (simple)**

In `vite.config.ts`:
```ts
export default defineConfig({
  define: {
    'import.meta.env.VITE_GOOGLE_MAPS_API_KEY': JSON.stringify(process.env.GOOGLE_MAPS_API_KEY),
  },
});
```

Then in React:
```tsx
<APIProvider apiKey={import.meta.env.VITE_GOOGLE_MAPS_API_KEY}>
```

**Option B: Server endpoint (more secure)**

Serve the key from your Express backend:
```ts
app.get('/api/config/maps-key', (req, res) => {
  res.json({ apiKey: process.env.GOOGLE_MAPS_API_KEY });
});
```

Then fetch it in React before rendering the map.

## Step 6: Set Up a Map ID (Required for AdvancedMarkers)

1. Go to **Google Maps Platform → Map Management** in Cloud Console
2. Click **Create Map ID**
3. Choose **JavaScript** as the map type
4. Choose **Vector** for the map renderer (required for AdvancedMarkers)
5. Copy the Map ID and use it in your `<Map mapId="...">` component

## Billing & Quotas

| API | Free Tier (monthly) | Cost After Free Tier |
|-----|---------------------|---------------------|
| Dynamic Maps | 28,000 loads | $7 per 1,000 |
| Static Maps | 100,000 loads | $2 per 1,000 |
| Places Autocomplete | Varies by fields | $2.83–$17 per 1,000 |
| Geocoding | 40,000 requests | $5 per 1,000 |
| Directions | 40,000 requests | $5–$10 per 1,000 |

### Set Billing Alerts

1. Go to **Billing → Budgets & alerts**
2. Create a budget with email alerts at 50%, 90%, 100%

### Set Quota Limits

1. Go to **APIs & Services → Maps JavaScript API → Quotas**
2. Set a daily request limit to prevent unexpected charges

## Security Checklist

- [ ] API key stored as Replit secret, never hardcoded
- [ ] HTTP referrer restriction set for your domains
- [ ] API restriction limits key to only needed APIs
- [ ] Billing alerts configured
- [ ] Daily quota limits set
- [ ] Separate keys for development and production
- [ ] Key not committed to version control
