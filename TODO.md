# Artisan's Codex — TODO

Track work in progress, next up, and backlog. Move completed items to
CHANGELOG.md when they ship.

---

## 🚧 In Progress

- [ ] **Verify Leveling tab end-to-end with real client**
  - Fork/path switching (Slow vs Rush) preserves scroll position
  - "Open Spec Tree" button navigates to correct sub-tree
  - "Pin Trainer" sets a native waypoint on the map
  - Materials + crafted-item icons render for every step
  - Difficulty badges (orange/yellow/green) match live skill

- [ ] **Alchemy.lua** — populate `Data/Midnight/Alchemy.lua` with real
  leveling data (same schema as Tailoring)

---

## ⏭️ Next

- [ ] **Dashboard tab — real content**
  - Replace hardcoded profession list with live skill scan
    (`C_TradeSkillUI.GetAllProfessionTradeSkillLines`)
  - Recommendation card driven by `addon.db.goal`
  - Quick stats: total KP, missing treasures, weekly KP progress
  - Recommended actions computed from open KP + nearby treasures

- [ ] **Knowledge tab — real content**
  - Treasure checklist driven by `profData.treasures`
  - Completion state persisted in `Artisan'sCodexDB.completedTreasures`
  - "Pin All Missing" actually sets waypoints for every uncollected treasure
  - Weekly sources panel reads `profData.weekly`
  - Profession filter bar (currently 5 hardcoded names)

- [ ] **Specializations tab — real content**
  - Tree visualization placeholder → interactive tree map
  - Recommended builds driven by `profData.specializations`
  - Per-build point-allocation walkthrough with checkpoints
  - "View Path" opens the actual in-game spec tree on the right node

- [ ] **Minimap button — drag to reposition**
  - Angle hardcoded at 220° — make it a saved var
  - Left-click opens window, right-click opens settings
  - Tooltip shows active profession + skill

---

## 📋 Backlog

- [ ] **Settings / Options panel**
  - Goal selector: personal / gold / orders / balanced
  - Scale slider
  - Hide minimap button toggle
  - Debug mode toggle (already exists via `/ac debug`)

- [ ] **Data: remaining 10 professions**
  - Blacksmithing, Enchanting, Engineering, Inscription,
    Jewelcrafting, Leatherworking, Herbalism, Mining, Skinning,
    Cooking, Fishing
  - Same schema: name, icon, overview, trainer, leveling (with forks),
    treasures, weekly, specializations

- [ ] **Item ID audit**
  - Every `itemID` in `Tailoring.lua` verified against live client
  - Any `0` or missing IDs filled from Wowhead
  - Add a `/ac audit` command that flags missing IDs at runtime

- [ ] **Shopping list**
  - Aggregate remaining materials across current + future steps
  - Subtract owned (bags, bank, reagent bank, warband bank)
  - Show ×remaining / ×required per line

- [ ] **Localization**
  - Move all user-facing strings to `Locales/enUS.lua`
  - Scaffold deDE, frFR, esES as fallback files
  - Slash command aliases per-locale

- [ ] **Custom waypoint arrow (optional)**
  - Currently using Blizzard's native SuperTrack — works great
  - If we want route-style multi-waypoint navigation (e.g., treasure
    sweep), we'd need a custom arrow like TomTom's
  - Decision deferred until treasure-batch feature ships

- [ ] **Search / filter in Leveling tab**
  - Text input to jump to a step by recipe or material name
  - "Skill X" input to jump to a range

- [ ] **Import / export**
  - Share completed treasures between alts (per profession)
  - Share custom paths via string

---

## ✅ Done

### Addon Skeleton
- [x] `.toc` with correct load order (Init → Core → Locales → Data → Modules)
- [x] `Init.lua` — private namespace + debug printer
- [x] `Core.lua` — database, event handling, lifecycle
- [x] Slash commands: `/ac`, `/codex`, `/artisanscodex` (open / debug / reset)
- [x] Minimap button with tooltip
- [x] Saved variables: `ArtisansCodexDB` with `CopyDefaults` merge

### Main Frame
- [x] Movable, closable, clamped, 1000×680
- [x] Gold-trimmed dark theme
- [x] Four tabs: Dashboard / Leveling / Specializations / Knowledge
- [x] Tab state (active tab highlighting)
- [x] Per-tab content frames with visibility swapping

### Leveling Tab (fully implemented)
- [x] Left panel: profession selector (available guides only)
- [x] Header: profession icon + name + overview text
- [x] Trainer block: name, zone, note, "Pin Trainer" button
      (calls `C_Map.SetUserWaypoint` + `C_SuperTrack`)
- [x] Fork/path system — Slow (Daily CD) vs Rush, with tabs and
      intro paragraphs
- [x] Scrollable step list with stable layout
- [x] Step rows: skill range, quantity ×N, recipe name, item icons
- [x] Materials row with per-material icons and counts
- [x] Difficulty badges (orange / yellow / green)
- [x] "Recommended" flag on highlighted steps
- [x] Crafted-items sub-list for multi-craft steps (Courtly set, etc.)
- [x] Spec-action footer with "Open Spec Tree" button
- [x] Scroll position preserved across path switches
- [x] Custom mouse-wheel scroll speed

### Spec Tree Navigation
- [x] Resolve `skillLineID` from profession name
- [x] `C_TradeSkillUI.OpenTradeSkill(skillLineID)` to open the book
- [x] Three strategies: by-id (`C_ProfSpecs`), by-tab-system, by-text
- [x] Retry loop (up to 12 × 0.1s) while the frame builds itself
- [x] Cache selected tab to `g_professionsSpecsSelectedTabs`
- [x] Transient reminder overlay ("Spend 5 KP on X")

### Data
- [x] Tailoring.lua — real Midnight data from wow-professions.com
      (leveling with fork, treasures, weekly, specializations)
- [x] DataLoader module — profession registry + getters
- [x] Items resolved via `C_Item.GetItemCount` / `GetItemIconByID`

### Modules (scaffolded, awaiting content)
- [x] `Modules/DataLoader.lua`
- [x] `Modules/Dashboard.lua`
- [x] `Modules/Leveling.lua`
- [x] `Modules/Specializations.lua`
- [x] `Modules/Knowledge.lua`
- [x] `Locales/enUS.lua`

---

## 🗓️ Milestones

- **v0.1.0-alpha** — Leveling tab complete for Tailoring *(current)*
- **v0.2.0-alpha** — Dashboard + Knowledge real content
- **v0.3.0-alpha** — Specializations tab, all crafting professions
- **v0.5.0-beta**  — Settings panel, localization scaffold
- **v1.0.0**       — All 13 professions, shipping quality