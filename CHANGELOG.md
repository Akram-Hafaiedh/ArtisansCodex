# Changelog

All notable changes to Artisan's Codex will be documented here.  
Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).  
Versioning: [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Recipes tab** (placeholder UI) — fifth tab with profession sidebar and clear empty state; full recipe browser planned for a later release (Tailoring first).
- **Knowledge — weekly itemIDs** for all primary professions (Glimmer of Midnight knowledge, trainer notebooks/notes, zone/gathering drops, Thalassian Treatises).
- **Knowledge — one-time renown books** with correct itemIDs across professions.
- **Knowledge — treasure itemIDs** so icons, quality colors, and tooltips work (not only Tailoring).
- `README.md` — status table, what Knowledge covers now, what is deferred.

### Changed
- Knowledge item names: request item data + recolor on load (fixes white/wrong quality until switching profession).
- Knowledge collected rows: muted **quality** color instead of flat grey.
- Knowledge / one-time / weekly tooltips: tight hit frame over icon + name (tooltip sits next to the item).
- Tab bar: five tabs; slightly narrower buttons to fit Recipes.
- Knowledge marked **good enough for v0.1** — remaining work (live weekly progress, first-craft KP, Cooking/Fishing depth) tracked in TODO, not required before Recipes.

### Notes (deferred — not bugs)
- Recipes browser content is intentionally empty until the Recipes feature pass.
- Live “done this week” for weekly sources, first-craft KP, and full Dashboard/Specs are planned later (see `TODO.md`).

### Previously in Unreleased
- Enchanting / Jewelcrafting / Leatherworking leveling data
- Mining / Herbalism / Skinning / Fishing gathering data
- Cooking leveling data
- Knowledge treasures data + Knowledge tab rewrite (collected flags, pins, weekly panel)

## [0.1.0-alpha] — 2026-09-22

### Added
- Addon skeleton (Init.lua, Core.lua, .toc)
- Slash commands: `/ac`, `/codex`, `/artisanscodex`
- Minimap button
- Main frame with tabs: Dashboard / Leveling / Specializations / Knowledge
- **Leveling tab** — profession selector, trainer pin, path forks, step list, materials, icons
- Spec tree navigation helpers
- `Tailoring.lua` — Midnight leveling data from wow-professions.com
- Module scaffolds: Dashboard, Leveling, Specializations, Knowledge, DataLoader
- Locale scaffold: `Locales/enUS.lua`
