# Artisan's Codex

Premium in-game profession guides for **World of Warcraft: Midnight**.

Leveling paths, specialization guidance, knowledge treasures, and (soon) a full recipe browser — without leaving the game.

| Command | Action |
|---------|--------|
| `/ac` | Open / close |
| `/codex` | Same |
| `/artisanscodex` | Same |
| `/ac debug` | Toggle debug chat |
| `/ac reset` | Wipe saved variables + reload |

---

## Status (v0.1.x-alpha)

| Tab | Status | Notes |
|-----|--------|--------|
| **Dashboard** | Placeholder | Smart recommendations planned later |
| **Leveling** | Usable | Trainer pin, paths, steps, materials — polish ongoing |
| **Specializations** | Partial | Data for some professions; interactive tree later |
| **Knowledge** | **Good enough for v0.1** | Treasures, one-time books, weekly sources, pins, tooltips |
| **Recipes** | Placeholder UI | Full browser planned (Tailoring first) |

Knowledge is considered **feature-complete enough** for early use. Remaining Knowledge work (live weekly progress, first-craft KP, Cooking/Fishing depth) is tracked in `TODO.md` and is **not** blocking Recipes.

---

## Knowledge tab (what works now)

- Profession sidebar
- Intro + trainer with **in-game map pin** (native waypoint, not TomTom)
- **One-time** renown books — item icons, quality color, tooltips
- **Treasures** by zone — collect status via quest flags, Pin / Pin Missing
- **Weekly** sources — patron knowledge items, trainer notebooks, zone drops, treatises, Darkmoon Faire
- Quality-colored names with client item-cache load (fixes white names on first open)
- Cross-links toward Specs / Leveling

**Explicitly later (see TODO):**

- Live “done this week” tracking for every weekly source
- First-craft knowledge tracking
- Full Cooking / Fishing knowledge depth
- Description/copy polish on a few treasure notes

---

## Recipes tab (planned)

Placeholder only in this release. Planned:

- Search + filters (All / Learned / Missing)
- Icons, quality colors, tooltips
- Reagent have/need
- Profession-by-profession data (Tailoring first)
- Links from Leveling steps

---

## Data

Profession guides live under `Data/Midnight/`. Sourced primarily from [wow-professions.com](https://www.wow-professions.com) and verified against Wowhead item IDs where possible.

---

## Install (dev)

1. Clone or copy into `World of Warcraft/_retail_/Interface/AddOns/ArtisansCodex`
2. Or symlink your dev folder there
3. `/reload` in-game

---

## Docs

- `TODO.md` — in progress, next, backlog  
- `CHANGELOG.md` — shipped changes  

---

## License / credits

Guide structure inspired by public Midnight profession guides; item IDs cross-checked with Wowhead. Not affiliated with Blizzard or wow-professions.com.
