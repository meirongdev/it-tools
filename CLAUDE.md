# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
pnpm dev           # Start dev server (Vite, port 5173)
pnpm build         # Type-check + production build
pnpm preview       # Preview build on port 5050
pnpm test          # Run unit tests (vitest + jsdom)
pnpm test:unit     # Same as above
pnpm coverage      # Unit tests with coverage
pnpm lint          # ESLint on src/
pnpm typecheck     # vue-tsc type check only

# Run a single test file
pnpm vitest run src/composable/validation.test.ts

# E2E tests (requires built app)
pnpm test:e2e
# E2E against running dev server
pnpm test:e2e:dev

# Scaffold a new tool
node scripts/create-tool.mjs
```

Package manager: **pnpm** (v9). Do not use npm or yarn.

## Architecture

**Stack:** Vue 3 + TypeScript + Vite + Naive UI + UnoCSS + Pinia + vue-i18n + Vue Router

### Tool System

Each tool lives in `src/tools/<tool-name>/`:
- `index.ts` — calls `defineTool()` to register metadata (name, path, description, keywords, icon, component, createdAt)
- `<tool-name>.vue` — the tool UI component

All tools are imported and organized into `toolsByCategory` in `src/tools/index.ts`, then registered as routes automatically in `src/router.ts` using the `toolLayout` layout.

To add a new tool: run the scaffold script, implement the `.vue` file, export `tool` from `index.ts`, and add it to the appropriate category array in `src/tools/index.ts`.

### Layouts

- `src/layouts/base.layout.vue` — root layout with sidebar (collapsible tool menu + hero), top navbar (search/command palette, locale selector, nav buttons, support button), and footer
- `src/layouts/tool.layout.vue` — wraps `base.layout.vue`, adds tool title/description header and favorite button

### Key Components

- `src/components/NavbarButtons.vue` — GitHub, Twitter/X, About, and dark mode toggle buttons in the top-right navbar
- `src/components/CollapsibleToolMenu.vue` — sidebar navigation grouped by category
- `src/modules/command-palette/` — Ctrl+K command palette for searching tools

### State & Config

- `src/stores/style.store.ts` — dark/light theme, menu collapsed state, screen size detection
- `src/themes.ts` — Naive UI `GlobalThemeOverrides` for light and dark themes
- `src/config.ts` — app config via `figue`, reads env vars (`VITE_TRACKER_ENABLED`, `VITE_PLAUSIBLE_DOMAIN`, etc.)

### Styling

UnoCSS (utility classes used inline in templates) + Less (scoped `<style lang="less">` blocks). Naive UI theming is overridden in `src/themes.ts`.

### i18n

Translation files are in `locales/*.yml`. Tool-specific strings use the key pattern `tools.<tool-path>.title` and `tools.<tool-path>.description`.

### Analytics

Plausible tracker via `src/modules/tracker/tracker.services.ts`, disabled by default (requires `VITE_TRACKER_ENABLED=true`).
