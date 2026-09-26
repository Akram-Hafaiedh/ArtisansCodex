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

- [ ] **4.2b — Verify new profession data against a live client**
  - [ ] Alchemy — rewritten this pass, re-verify item IDs in-game
  - [ ] Enchanting / Jewelcrafting / Leatherworking — new, condensed from wow-professions.com, needs an in-game pass
  - [ ] Mining / Herbalism / Skinning / Fishing / Cooking — new, gathering-profession schema, needs an in-game pass
  - [ ] Fill in real trainer coordinates (currently approximate placeholders) for all professions added this pass
  - [ ] Some itemIDs are placeholders (`itemID = 0`) where wow-professions.com didn't link a Wowhead ID (e.g. Alchemy's Stabilized Derivate refs, some Leatherworking/Enchanting mixed-mote rows) — look these up in-game or via Wowhead search

---

## ⏭️ Next

- [ ] **4.3 — Leveling tab: gathering-profession support**
  - [ ] Mining, Herbalism, Skinning, and Fishing use a different data shape (`isGathering = true`, skill-range `leveling` entries with no real recipe/materials, plus `zones`/`equipment`/`consumables`/`infusedTypes` tables) — the Leveling tab UI currently assumes a crafting profession and needs a gathering-mode layout
  - [ ] Decide how Skinning (tied to killing mobs, not a grind route) should render differently from Mining/Herbalism (zone routes) and Fishing (skill-range zones, cap 300 not 100)
  - [ ] Add each new profession to `Artisan'sCodex.toc` under `# Data` — done for this pass, re-check on future additions

- [ ] **4.4 — Leveling tab polish**
  - [ ] Handle professions without forks (linear guide only) — Enchanting, Jewelcrafting, Leatherworking, Cooking now need this
  - [ ] Handle professions without a trainer block (Cooking, Fishing) — trainer blocks now exist for both, revisit whether this is still needed
  - [ ] Verify "Open Spec Tree" across all professions with specs
  - [ ] Verify "Pin Trainer" across all professions with map coords
  - [ ] Scroll-wheel performance on long guides (e.g., Blacksmithing, Enchanting)

---

## 📋 Backlog

- [ ] **Dashboard tab — real content**
  - [ ] Replace hardcoded profession list with live skill scan
  - [ ] Recommendation card driven by `addon.db.goal`
  - [ ] Quick stats: total KP, missing treasures, weekly KP progress
  - [ ] Recommended actions computed from open KP + nearby treasures

- [x] **Knowledge tab — real content**
  - [x] Treasure data for all 11 professions (scraped + added to data files)
  - [x] Treasure checklist driven by `profData.treasures`
  - [x] Live status via `C_QuestLog.IsQuestFlaggedCompleted(questID)`
  - [x] "Pin" + "Pin All Missing" using `C_Map.SetUserWaypoint`
  - [x] Weekly sources panel reads `profData.weekly`
  - [x] Profession filter bar (dynamic, all professions with treasures)
  - [ ] Optional cache in `ArtisansCodexDB.completedTreasures` (quest flag is primary source of truth)
- [ ] **Specializations tab — real content**
  - [ ] Interactive tree visualization
  - [ ] Recommended builds driven by `profData.specializations` (only Alchemy has this filled in; Engineering/Inscription have partial builds; rest are missing)
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
  - [ ] `/ac audit` — flags missing or zero itemIDs at runtime (there are a handful of known `itemID = 0` placeholders from this data pass, see 4.2b above)

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
- [x] `Alchemy.lua` — rewritten with corrected item IDs and full leveling path (was stubbed/stale)
- [x] `Tailoring.lua` — real Midnight data
- [x] `Blacksmithing.lua` — verified against wow-professions.com, no changes needed
- [x] `Engineering.lua` — existing data
- [x] `Inscription.lua` — existing data
- [x] `Enchanting.lua` — new
- [x] `Jewelcrafting.lua` — new
- [x] `Leatherworking.lua` — new
- [x] `Mining.lua` — new (gathering profession)
- [x] `Herbalism.lua` — new (gathering profession)
- [x] `Skinning.lua` — new (gathering profession)
- [x] `Cooking.lua` — new
- [x] `Fishing.lua` — new (gathering profession, 300 skill cap)
- [x] `DataLoader` module — now loads all 13 professions generically instead of a hardcoded if-chain

### Modules (scaffolded)
- [x] `Modules/Leveling.lua` (UI lives in Core for now)
- [x] `Modules/Dashboard.lua`
- [x] `Modules/Specializations.lua`
- [x] `Modules/Knowledge.lua`
- [x] `Locales/enUS.lua`

---

## 🗓️ Milestones

- **v0.1.0-alpha** — Leveling tab + Tailoring guide *(shipped)*
- **v0.2.0-alpha** — Shopping list in Leveling tab + all 13 professions have leveling data *(data now done, shopping list still pending)*
- **v0.3.0-alpha** — Dashboard real content
- **v0.4.0-alpha** — Knowledge tab real content
- **v0.5.0-alpha** — Specializations tab real content
- **v0.6.0-beta**  — Settings, localization scaffold
- **v1.0.0**       — Shipping quality, all features