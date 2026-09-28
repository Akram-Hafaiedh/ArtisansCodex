-- Midnight Skinning recipes
-- Sources: in-game TradeSkillUI export (debugger) + wow-professions.com Skinning guide
-- spellID = craft/gathering ability (learned scan); itemID = produced item when known
-- Gathering profession: "recipes" are lures, diffusers, and material outcomes — not craft queues

local _, private = ...
private.RecipeData = private.RecipeData or {}
private.RecipeCategoryTips = private.RecipeCategoryTips or {}

private.RecipeCategoryTips.Skinning = {
  ["Diffusers"]            = [[Throw on a mob before killing it to also collect Motes (Light / Wild / Primal / Void). Crafted from 2× matching Mote.]],
  ["Majestic Beast Lures"] = [[Lures for Renowned Beasts (Majestic Claw / Hide / Fin). Zone-specific fish reagents; Grand Beast Lure is the multi-zone option.]],
  ["Skinning Details"]     = [[Primary materials from skinning beasts. No refining — what you skin is what you get. High Value Beasts (minimap knife icon) give bonus yields.]],
}

private.RecipeData.Skinning = {
  -- ========== Diffusers ==========
  { name = [[Lightbloom Diffuser]], spellID = 1225939, itemID = 238657, skill = 0, source = [[Trainer]], category = [[Diffusers]],
    reagents = {{name="Mote of Light",itemID=236949,amount=2}},
    note = [[Use on mob before kill → 1–4 Mote of Light]] },
  { name = [[Wild Diffuser]], spellID = 1225941, itemID = 238658, skill = 0, source = [[Trainer]], category = [[Diffusers]],
    reagents = {{name="Mote of Wild Magic",itemID=236951,amount=2}},
    note = [[Use on mob before kill → 1–4 Mote of Wild Magic]] },
  { name = [[Primal Diffuser]], spellID = 1225940, itemID = 238659, skill = 0, source = [[Trainer]], category = [[Diffusers]],
    reagents = {{name="Mote of Primal Energy",itemID=236950,amount=2}},
    note = [[Use on mob before kill → 1–4 Mote of Primal Energy]] },
  { name = [[Void Diffuser]], spellID = 1225942, itemID = 238660, skill = 0, source = [[Trainer]], category = [[Diffusers]],
    reagents = {{name="Mote of Pure Void",itemID=236952,amount=2}},
    note = [[Use on mob before kill → 1–4 Mote of Pure Void]] },

  -- ========== Majestic Beast Lures ==========
  { name = [[Majestic Eversong Lure]], spellID = 1225943, itemID = 238652, skill = 0, source = [[Trainer]], category = [[Majestic Beast Lures]],
    reagents = {{name="Arcane Wyrmfish",itemID=238371,amount=8},{name="Lynxfish",itemID=238366,amount=8}},
    note = [[Eversong Woods Renowned Beasts]] },
  { name = [[Majestic Zul'Aman Lure]], spellID = 1225944, itemID = 238653, skill = 0, source = [[Trainer]], category = [[Majestic Beast Lures]],
    reagents = {{name="Gore Guppy",itemID=238382,amount=8}},
    note = [[Zul'Aman Renowned Beasts]] },
  { name = [[Majestic Harandar Lure]], spellID = 1225945, itemID = 238654, skill = 0, source = [[Trainer]], category = [[Majestic Beast Lures]],
    reagents = {{name="Fungalskin Pike",itemID=238375,amount=8},{name="Tender Lumifin",itemID=238374,amount=8}},
    note = [[Harandar Renowned Beasts]] },
  { name = [[Majestic Voidstorm Lure]], spellID = 1225946, itemID = 238655, skill = 0, source = [[Trainer]], category = [[Majestic Beast Lures]],
    reagents = {{name="Ominous Octopus",itemID=238373,amount=4}},
    note = [[Voidstorm Renowned Beasts]] },
  { name = [[Grand Beast Lure]], spellID = 1225948, itemID = 238656, skill = 0, source = [[Trainer]], category = [[Majestic Beast Lures]],
    reagents = {{name="Null Voidfish",itemID=238380,amount=4}},
    note = [[Premium / multi-zone lure option]] },

  -- ========== Skinning Details (material outcomes) ==========
  -- itemIDs cross-checked against Leatherworking / Alchemy reagent lists
  { name = [[Void-Tempered Leather]], spellID = 1225901, itemID = 238511, skill = 1, source = [[Gather: Skinning]], category = [[Skinning Details]],
    reagents = {},
    note = [[Common from leather-type beasts]] },
  { name = [[Void-Tempered Scales]], spellID = 1225897, itemID = 238513, skill = 1, source = [[Gather: Skinning]], category = [[Skinning Details]],
    reagents = {},
    note = [[Common from scale-type beasts]] },
  { name = [[Void-Tempered Hide]], spellID = 1225902, itemID = 238518, skill = 1, source = [[Gather: Skinning]], category = [[Skinning Details]],
    reagents = {},
    note = [[Rarer hide — High Value Beasts, Sharpen Your Knife, lures]] },
  { name = [[Void-Tempered Plating]], spellID = 1225903, itemID = 238520, skill = 1, source = [[Gather: Skinning]], category = [[Skinning Details]],
    reagents = {},
    note = [[Rarer plating — rare scale mobs, Sharpen Your Knife, lures]] },
}