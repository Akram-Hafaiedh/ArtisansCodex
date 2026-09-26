# Artisan's Codex — TODO

Track work in progress, next up, and backlog. Move completed items to
CHANGELOG.md when they ship.

---

## Status snapshot

| Area | State |
|------|--------|
| Knowledge tab | **Good enough for v0.1** — remaining items are polish / live tracking |
| Recipes tab | Placeholder UI only — full browser is next major feature |
| Leveling tab | Usable — shopping list + gathering layout still open |
| Specializations | Partial data + basic UI |
| Dashboard | Placeholder |

---

## 🚧 In Progress

- [ ] **Recipes tab — real browser** (next major feature)
  - [ ] Tailoring recipe data first
  - [ ] Search + filters (All / Learned / Missing)
  - [ ] Icons, quality-colored names, tooltips
  - [ ] Reagent lines + have/need counts
  - [ ] Expand to other professions

- [ ] **4.1 — Shopping list inside the Leveling tab**
  - [ ] Sub-tab bar: `[Steps] [Shopping List]`
  - [ ] Aggregate materials from current step onward
  - [ ] Owned counts via `C_Item.GetItemCount`
  - [ ] Dim fully-owned materials

- [ ] **4.2b — Verify profession data in a live client**
  - [ ] Spot-check itemIDs / trainer coords after each data pass
  - [ ] Fix remaining placeholder or wrong treasure descriptions

---

## Knowledge — deferred (not blocking Recipes)

Knowledge is **shipped for early use**. These are intentional later items:

- [ ] Live weekly progress (“done this week”) for patron / notebook / drops
- [ ] First-craft knowledge tracking
- [ ] Header KP from live profession API (not only static data totals)
- [ ] Cooking / Fishing knowledge depth (if the expansion supports meaningful KP sources)
- [ ] Optional `ArtisansCodexDB.completedTreasures` cache (quest flag remains source of truth)
- [ ] Treasure note copy-edit pass (a few wrong/copied descriptions)

---

## ⏭️ Next (after Recipes v1)

- [ ] **4.3 — Leveling: gathering-profession layout**
  - [ ] Mining / Herbalism / Skinning / Fishing use `isGathering` data shape
  - [ ] Different UX for routes vs kill-based skinning vs fishing

- [ ] **4.4 — Leveling polish**
  - [ ] Linear guides without forks
  - [ ] Spec tree / Pin Trainer verification across professions
  - [ ] Scroll performance on long guides

---

## 📋 Backlog

- [ ] **Dashboard** — live skill scan, goal-driven recommendations, KP / weekly summary
- [ ] **Specializations** — interactive tree, full builds per profession, “View Path”
- [ ] **Minimap button** — drag reposition, right-click settings
- [ ] **Settings panel** — goal, scale, minimap hide
- [ ] **Localization** — move strings to Locales; deDE / frFR / esES later
- [ ] **Import / export** — alt treasure progress, path strings
- [ ] **`/ac audit`** — flag missing itemIDs at runtime

---

## ✅ Done (high level)

### Skeleton
- [x] `.toc`, Init, Core, slash commands, minimap, SavedVariables
- [x] Main frame + tabs (Dashboard / Leveling / Specs / Knowledge / **Recipes**)

### Leveling
- [x] Profession sidebar, trainer pin, path forks, step list, materials, icons

### Knowledge (v0.1 “good enough”)
- [x] Treasures for primary professions + quest-flag collected state
- [x] Pin / Pin Missing (native map waypoint)
- [x] One-time renown books with itemIDs
- [x] Weekly sources with itemIDs (Glimmer, notebooks, zone drops, treatises)
- [x] Quality colors + tooltips (with item-cache load fix)
- [x] Cross-links to other tabs

### Recipes
- [x] Tab + module shell + empty-state UI (browser content not started)
