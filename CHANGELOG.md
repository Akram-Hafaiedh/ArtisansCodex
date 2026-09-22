# Changelog

All notable changes to Artisan's Codex will be documented here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning: [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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