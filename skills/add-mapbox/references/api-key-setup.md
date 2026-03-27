# Mapbox API Key Setup

Step-by-step guide to creating a Mapbox access token and configuring it for use in a Replit + Vite project.

## 1. Create a Mapbox Account

1. Go to [mapbox.com](https://www.mapbox.com/) and sign up for a free account
2. The free tier includes 50,000 map loads/month

## 2. Get Your Access Token

1. Log in to [account.mapbox.com](https://account.mapbox.com/)
2. Navigate to **Access tokens** in the left sidebar
3. Copy your **Default public token**, or click **Create a token** for a new one
4. For production, create a scoped token with only the permissions you need:
   - `styles:read` — load map styles
   - `fonts:read` — load map fonts
   - `datasets:read` — read datasets (if using Mapbox datasets)
   - `tilesets:read` — read tilesets (if using custom tilesets)

## 3. Add Token as Replit Secret

Use the environment-secrets skill to store the token:

1. Request the secret from the user:
   ```
   requestEnvVar('MAPBOX_ACCESS_TOKEN', 'Your Mapbox public access token from account.mapbox.com')
   ```
2. The token will be stored securely as a Replit secret

## 4. Expose to Vite Frontend

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

## 5. Security Best Practices

| Practice | Details |
|----------|---------|
| Never hardcode tokens | Always use environment variables |
| Use URL restrictions | In Mapbox dashboard, restrict token to your domain |
| Separate dev/prod tokens | Create distinct tokens for each environment |
| Monitor usage | Set up usage alerts in Mapbox dashboard |
| Rotate tokens | Periodically rotate tokens, especially if exposed |

## 6. Verify Setup

After configuring, verify the token works:

```ts
const token = import.meta.env.VITE_MAPBOX_ACCESS_TOKEN;
if (!token) {
  console.error('MAPBOX_ACCESS_TOKEN is not configured');
}
```

A valid Mapbox token starts with `pk.` (public key) or `sk.` (secret key). For client-side use, always use a public key (`pk.`).
