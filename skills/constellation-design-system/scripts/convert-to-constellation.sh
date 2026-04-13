#!/usr/bin/env bash
set -euo pipefail

ARTIFACT_DIR="${1:?Usage: $0 <artifact-dir>}"
SKILL_DIR=".agents/skills/constellation-design-system"
TEMPLATE_DIR="$SKILL_DIR/templates"
PACKAGES_DIR="$SKILL_DIR/packages"
WORKSPACE_ROOT="$(pwd)"

if [ ! -d "$ARTIFACT_DIR" ]; then
  echo "ERROR: $ARTIFACT_DIR does not exist"
  exit 1
fi

echo "==> Converting $ARTIFACT_DIR to Constellation design system"

echo "--- Removing default scaffold files ---"
rm -rf "$ARTIFACT_DIR/src/components/ui" \
       "$ARTIFACT_DIR/src/lib/utils.ts" \
       "$ARTIFACT_DIR/src/pages/not-found.tsx" \
       "$ARTIFACT_DIR/src/hooks" \
       "$ARTIFACT_DIR/tailwind.config.ts" \
       "$ARTIFACT_DIR/tailwind.config.js" \
       "$ARTIFACT_DIR/src/App.css" \
       2>/dev/null || true

rmdir "$ARTIFACT_DIR/src/components" "$ARTIFACT_DIR/src/lib" "$ARTIFACT_DIR/src/pages" "$ARTIFACT_DIR/src/hooks" 2>/dev/null || true

echo "--- Copying template files ---"
cp "$TEMPLATE_DIR/src/App.tsx" "$ARTIFACT_DIR/src/App.tsx"
cp "$TEMPLATE_DIR/src/main.tsx" "$ARTIFACT_DIR/src/main.tsx"
cp "$TEMPLATE_DIR/src/index.css" "$ARTIFACT_DIR/src/index.css"
cp "$TEMPLATE_DIR/panda.config.ts" "$ARTIFACT_DIR/panda.config.ts"
cp "$TEMPLATE_DIR/postcss.config.cjs" "$ARTIFACT_DIR/postcss.config.cjs"
cp "$TEMPLATE_DIR/index.html" "$ARTIFACT_DIR/index.html"

echo "--- Copying Replit logo ---"
mkdir -p "$ARTIFACT_DIR/public"
cp "$PACKAGES_DIR/Replit-Logo-Primary.svg" "$ARTIFACT_DIR/public/Replit-Logo-Primary.svg"

echo "--- Rewriting package.json ---"
ARTIFACT_NAME=$(node -e "const p = require('./$ARTIFACT_DIR/package.json'); console.log(p.name)")

cat > "$ARTIFACT_DIR/package.json" << PKGJSON
{
  "name": "$ARTIFACT_NAME",
  "version": "0.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "prepare": "panda codegen --clean && panda cssgen",
    "dev": "vite --config vite.config.ts --host 0.0.0.0",
    "build": "vite build --config vite.config.ts",
    "serve": "vite preview --config vite.config.ts --host 0.0.0.0",
    "typecheck": "tsc -p tsconfig.json --noEmit"
  },
  "devDependencies": {
    "@replit/vite-plugin-cartographer": "catalog:",
    "@replit/vite-plugin-dev-banner": "catalog:",
    "@replit/vite-plugin-runtime-error-modal": "catalog:",
    "@types/node": "catalog:",
    "@types/react": "catalog:",
    "@types/react-dom": "catalog:",
    "@vitejs/plugin-react": "catalog:",
    "react": "catalog:",
    "react-dom": "catalog:",
    "vite": "catalog:",
    "wouter": "^3.3.5"
  },
  "dependencies": {
    "@pandacss/dev": "^1.9.1",
    "@zillow/constellation": "file:$WORKSPACE_ROOT/$PACKAGES_DIR/constellation-10.15.0.tgz",
    "@zillow/constellation-config": "file:$WORKSPACE_ROOT/$PACKAGES_DIR/constellation-config-10.15.0.tgz",
    "@zillow/constellation-fonts": "file:$WORKSPACE_ROOT/$PACKAGES_DIR/constellation-fonts-10.15.0.tgz",
    "@zillow/constellation-icons": "file:$WORKSPACE_ROOT/$PACKAGES_DIR/constellation-icons-10.15.0.tgz",
    "@zillow/constellation-tokens": "file:$WORKSPACE_ROOT/$PACKAGES_DIR/constellation-tokens-10.15.0.tgz",
    "postcss": "^8.5.8"
  }
}
PKGJSON

echo "--- Rewriting vite.config.ts ---"
cat > "$ARTIFACT_DIR/vite.config.ts" << 'VITECONFIG'
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import path from "path";
import runtimeErrorOverlay from "@replit/vite-plugin-runtime-error-modal";

const port = Number(process.env.PORT) || 5173;
const basePath = process.env.BASE_PATH || "/";

export default defineConfig({
  base: basePath,
  plugins: [
    react(),
    runtimeErrorOverlay(),
    ...(process.env.NODE_ENV !== "production" &&
    process.env.REPL_ID !== undefined
      ? [
          await import("@replit/vite-plugin-cartographer").then((m) =>
            m.cartographer({
              root: path.resolve(import.meta.dirname, ".."),
            }),
          ),
          await import("@replit/vite-plugin-dev-banner").then((m) =>
            m.devBanner(),
          ),
        ]
      : []),
  ],
  resolve: {
    alias: {
      "@/styled-system": path.resolve(import.meta.dirname, "styled-system"),
      "@": path.resolve(import.meta.dirname, "src"),
      "@assets": path.resolve(import.meta.dirname, "..", "..", "attached_assets"),
    },
    dedupe: ["react", "react-dom"],
  },
  root: path.resolve(import.meta.dirname),
  build: {
    outDir: path.resolve(import.meta.dirname, "dist/public"),
    emptyOutDir: true,
  },
  server: {
    port,
    host: "0.0.0.0",
    allowedHosts: true,
    fs: {
      strict: false,
    },
  },
  preview: {
    port,
    host: "0.0.0.0",
    allowedHosts: true,
  },
});
VITECONFIG

echo "--- Installing packages ---"
pnpm install 2>&1 | tail -5

echo "--- Running Panda CSS codegen ---"
cd "$WORKSPACE_ROOT/$ARTIFACT_DIR"
npx panda codegen --clean 2>&1
touch styled-system/styles.css
cd "$WORKSPACE_ROOT"

echo "==> Conversion complete! Restart the workflow to see the app."
