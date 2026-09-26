# Changelog

All notable changes to Artisan's Codex will be documented here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning: [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `Enchanting.lua`, `Jewelcrafting.lua`, `Leatherworking.lua` — new leveling data, sourced from wow-professions.com
- `Mining.lua`, `Herbalism.lua`, `Skinning.lua`, `Fishing.lua` — new gathering-profession data (`isGathering = true`, skill-range steps instead of recipes, plus `zones`/`equipment`/`consumables`/`infusedTypes` tables)
- `Cooking.lua` — new leveling data
- All 8 new profession files registered in `ArtisansCodex.toc` under `# Data`

### Changed
- `Alchemy.lua` — rewritten. The previous file had incorrect item IDs (Tranquility Bloom, Sanguithorn, Mana Lily, Azeroot, Argentleaf, and Oil of Heartwood were mismatched) and an incomplete First Crafts list. Now matches the current wow-professions.com leveling guide, with a Potions/Flasks fork for 50-100.
- `DataLoader.lua` — `Load()` now iterates `private.Data.professions` generically instead of a hardcoded if-chain per profession, so newly added data files register automatically.

### Verified
- `Blacksmithing.lua` — checked against wow-professions.com's current leveling guide, already accurate, no changes made.

## [0.1.0-alpha] — 2026-09-22

### Added
- Addon skeleton (Init.lua, Core.lua, .toc)
- Slash commands: `/ac`, `/codex`, `/artisanscodex`
- Minimap button
- Main frame with four tabs: Dashboard / Leveling / Specializations / Knowledge
- **Leveling tab** — full implementation:
  - Profession selector, trainer block with map-pin button
  - Fork/path system (Slow vs Rush)
  - Scrollable step list with item icons, materials, difficulty badges
  - Crafted-items sub-list for multi-craft steps
  - Spec-action footer with "Open Spec Tree" button
  - Scroll position preservation across path switches
- **Spec tree navigation** — three fallback strategies + retry loop
- **Transient spec reminder** overlay after opening the tree
- `Tailoring.lua` — real Midnight leveling data from wow-professions.com
- Module scaffolds: Dashboard, Leveling, Specializations, Knowledge, DataLoader
- Locale scaffold: `Locales/enUS.lua`