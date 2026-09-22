# Artisan's Codex — TODO

Track work in progress, next up, and backlog. Move completed items to
CHANGELOG.md when they ship.

---

## 🚧 In Progress

- [ ] **4.1 — Shopping list inside the Leveling tab**
  - [ ] Sub-tab bar between header and scroll: `[Steps] [Shopping List]`
  - [ ] Aggregate materials from current step onward (respects `selectedPath`)
  - [ ] Subtract owned items via `C_Item.GetItemCount(itemID, true, false, true, true)`
  - [ ] Row layout: icon · name · `×remaining` (· `×total` if partially owned)
  - [ ] Checkmark + dimmed text for fully-owned materials
  - [ ] Empty state: "You already own everything required."
  - [ ] Preserve scroll offset per sub-tab (so toggling doesn't jump)

---

## ⏭️ Next

- [ ] **4.2 — Real data for all remaining professions**
  - [ ] Alchemy (currently stubbed — replace)
  - [ ] Blacksmithing
  - [ ] Enchanting
  - [ ] Engineering
  - [ ] Inscription
  - [ ] Jewelcrafting
  - [ ] Leatherworking
  - [ ] Herbalism
  - [ ] Mining
  - [ ] Skinning
  - [ ] Cooking
  - [ ] Fishing
  - [ ] Add each to `Artisan'sCodex.toc` under `# Data`
  - [ ] Verify every `itemID` against live client

- [ ] **4.3 — Leveling tab polish**
  - [ ] Handle professions without forks (linear guide only)
  - [ ] Handle professions without a trainer block (Cooking, Fishing)
  - [ ] Verify "Open Spec Tree" across all professions with specs
  - [ ] Verify "Pin Trainer" across all professions with map coords
  - [ ] Scroll-wheel performance on long guides (e.g., Blacksmithing)

---

## 📋 Backlog

- [ ] **Dashboard tab — real content**
  - [ ] Replace hardcoded profession list with live skill scan
  - [ ] Recommendation card driven by `addon.db.goal`
  - [ ] Quick stats: total KP, missing treasures, weekly KP progress
  - [ ] Recommended actions computed from open KP + nearby treasures

- [ ] **Knowledge tab — real content**
  - [ ] Treasure checklist driven by `profData.treasures`
  - [ ] Completion persisted in `ArtisansCodexDB.completedTreasures`
  - [ ] "Pin All Missing" sets waypoints for every uncollected treasure
  - [ ] Weekly sources panel reads `profData.weekly`
  - [ ] Profession filter bar (currently 5 hardcoded names)

- [ ] **Specializations tab — real content**
  - [ ] Interactive tree visualization
  - [ ] Recommended builds driven by `profData.specializations`
  - [ ] Per-build point-allocation walkthrough with checkpoints
  - [ ] "View Path" opens the in-game spec tree on the right node

- [ ] **Minimap button — drag to reposition**
  - [ ] Angle as saved var (currently hardcoded 220°)
  - [ ] Right-click → settings
  - [ ] Tooltip shows active profession + skill

- [ ] **Settings / Options panel**
  - [ ] Goal selector: personal / gold / orders / balanced
  - [ ] Scale slider
  - [ ] Hide minimap button toggle
  - [ ] Debug mode toggle (exists via `/ac debug`)

- [ ] **Localization**
  - [ ] Move all user-facing strings to `Locales/enUS.lua`
  - [ ] Scaffold deDE, frFR, esES

- [ ] **Import / export**
  - [ ] Share completed treasures between alts
  - [ ] Share custom paths via string

- [ ] **Item ID audit command**
  - [ ] `/ac audit` — flags missing or zero itemIDs at runtime

---

## ✅ Done

### Addon Skeleton
- [x] `.toc` with correct load order
- [x] `Init.lua` — private namespace + debug printer
- [x] `Core.lua` — database, events, lifecycle
- [x] Slash commands: `/ac`, `/codex`, `/artisanscodex`
- [x] Minimap button with tooltip
- [x] Saved variables: `ArtisansCodexDB`

### Main Frame
- [x] Movable, closable, clamped, 1000×680
- [x] Gold-trimmed dark theme
- [x] Four tabs: Dashboard / Leveling / Specializations / Knowledge
- [x] Tab state and per-tab content frames

### Leveling Tab
- [x] Left panel: profession selector
- [x] Header: icon + name + overview
- [x] Trainer block with "Pin Trainer" button
- [x] Fork/path system (Slow / Rush) with tabs + intros
- [x] Scrollable step list with stable layout
- [x] Step rows: range, quantity, recipe, item icons
- [x] Materials row with per-material icons
- [x] Difficulty badges + recommended flag
- [x] Crafted-items sub-list (multi-craft steps)
- [x] Spec-action footer + "Open Spec Tree" button
- [x] Scroll position preserved across path switches
- [x] Custom mouse-wheel scroll speed

### Spec Tree Navigation
- [x] Resolve skillLineID from profession name
- [x] `C_TradeSkillUI.OpenTradeSkill(skillLineID)`
- [x] Three strategies: by-id, by-tab-system, by-text
- [x] Retry loop
- [x] Cache selection
- [x] Transient spec reminder overlay

### Data
- [x] `Tailoring.lua` — real Midnight data
- [x] `Alchemy.lua` — stub (data TBD)
- [x] `DataLoader` module

### Modules (scaffolded)
- [x] `Modules/Leveling.lua` (UI lives in Core for now)
- [x] `Modules/Dashboard.lua`
- [x] `Modules/Specializations.lua`
- [x] `Modules/Knowledge.lua`
- [x] `Locales/enUS.lua`

---

## 🗓️ Milestones

- **v0.1.0-alpha** — Leveling tab + Tailoring guide *(current, first commit)*
- **v0.2.0-alpha** — Shopping list in Leveling tab + all 12 professions
- **v0.3.0-alpha** — Dashboard real content
- **v0.4.0-alpha** — Knowledge tab real content
- **v0.5.0-alpha** — Specializations tab real content
- **v0.6.0-beta**  — Settings, localization scaffold
- **v1.0.0**       — Shipping quality, all features