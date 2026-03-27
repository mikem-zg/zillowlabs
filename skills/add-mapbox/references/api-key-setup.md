# Mapbox API Key Setup

Step-by-step guide to obtaining a Mapbox access token and configuring it for use in a Replit + Vite project.

## 1. Request an API Key

To get a Mapbox access token, reach out to **Mike Messenger** and send him the **app edit URL** (your Replit project URL). He will add the API key directly to your app as a Replit secret.

## 2. Verify the Token Is Available

Once Mike has added the key, confirm it is set as a Replit secret named `MAPBOX_ACCESS_TOKEN`:

```ts
const token = import.meta.env.VITE_MAPBOX_ACCESS_TOKEN;
if (!token) {
  console.error('MAPBOX_ACCESS_TOKEN is not configured — reach out to Mike Messenger');
}
```

## 3. Expose to Vite Frontend

Vite requires environment variables to be prefixed with `VITE_` to be available on the client. Two approaches:

### Option A: Vite config define block

```ts
// vite.config.ts
export default defineConfig({
  define: {
    'import.meta.env.VITE_MAPBOX_ACCESS_TOKEN': JSON.stringify(process.env.MAPBOX_ACCESS_TOKEN),
  },
});
```

### Option B: .env file

Create a `.env` file (or add to existing):

```
VITE_MAPBOX_ACCESS_TOKEN=${MAPBOX_ACCESS_TOKEN}
```

### Usage in code

```ts
const token = import.meta.env.VITE_MAPBOX_ACCESS_TOKEN;
window.mapboxgl.accessToken = token;
```

## 4. Security Best Practices

| Practice | Details |
|----------|---------|
| Never hardcode tokens | Always use environment variables |
| Use URL restrictions | In Mapbox dashboard, restrict token to your domain |
| Separate dev/prod tokens | Create distinct tokens for each environment |
| Monitor usage | Set up usage alerts in Mapbox dashboard |
| Rotate tokens | Periodically rotate tokens, especially if exposed |

## 5. Verify Setup

A valid Mapbox token starts with `pk.` (public key) or `sk.` (secret key). For client-side use, always use a public key (`pk.`).
