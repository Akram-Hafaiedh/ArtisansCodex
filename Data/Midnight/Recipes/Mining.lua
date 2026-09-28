-- Midnight Mining recipes (node variants / deposits)
-- Sources: live client export (debug)
-- Gathering "recipes" are deposit types, not crafts — itemID is usually 0
-- source = Trainer for base skill line; node variants unlock with skill / specialization

local _, private = ...
private.RecipeData = private.RecipeData or {}
private.RecipeCategoryTips = private.RecipeCategoryTips or {}

private.RecipeCategoryTips.Mining = {
  ["Section I - Refulgent Copper"] = [[Base copper ore nodes and variants (Rich, Seam, Lightfused, Primal, Voidbound, Wild, Cursed).]],
  ["Section II - Umbral Tin"] = [[Mid-tier tin nodes and variants.]],
  ["Section III - Brilliant Silver"] = [[Higher-tier silver nodes and variants.]],
}

private.RecipeData.Mining = {
  -- ========== Section I - Refulgent Copper ==========
  { name = [[Refulgent Copper]], spellID = 1225343, itemID = 237359, skill = 0, source = [[Trainer]], category = [[Section I - Refulgent Copper]], reagents = {} },
  { name = [[Refulgent Copper Seam]], spellID = 1225350, itemID = 237359, skill = 0, source = [[Trainer]], category = [[Section I - Refulgent Copper]], reagents = {} },
  { name = [[Rich Refulgent Copper]], spellID = 1225349, itemID = 237359, skill = 0, source = [[Trainer]], category = [[Section I - Refulgent Copper]], reagents = {} },
  { name = [[Lightfused Refulgent Copper]], spellID = 1225351, itemID = 237359, skill = 0, source = [[Trainer]], category = [[Section I - Refulgent Copper]], reagents = {} },
  { name = [[Primal Refulgent Copper]], spellID = 1225354, itemID = 237359, skill = 0, source = [[Trainer]], category = [[Section I - Refulgent Copper]], reagents = {} },
  { name = [[Voidbound Refulgent Copper]], spellID = 1225352, itemID = 237359, skill = 0, source = [[Trainer]], category = [[Section I - Refulgent Copper]], reagents = {} },
  { name = [[Wild Refulgent Copper]], spellID = 1225353, itemID = 237359, skill = 0, source = [[Trainer]], category = [[Section I - Refulgent Copper]], reagents = {} },
  { name = [[Cursed Refulgent Copper]], spellID = 1301492, itemID = 237359, skill = 0, source = [[Patch 12.1]], category = [[Section I - Refulgent Copper]], reagents = {}, note = [[Cursed nodes (12.1)]] },

  -- ========== Section II - Umbral Tin ==========
  { name = [[Umbral Tin]], spellID = 1225347, itemID = 237362, skill = 0, source = [[Trainer]], category = [[Section II - Umbral Tin]], reagents = {} },
  { name = [[Umbral Tin Seam]], spellID = 1225366, itemID = 237362, skill = 0, source = [[Trainer]], category = [[Section II - Umbral Tin]], reagents = {} },
  { name = [[Rich Umbral Tin]], spellID = 1225365, itemID = 237362, skill = 0, source = [[Trainer]], category = [[Section II - Umbral Tin]], reagents = {} },
  { name = [[Lightfused Umbral Tin]], spellID = 1225367, itemID = 237362, skill = 0, source = [[Trainer]], category = [[Section II - Umbral Tin]], reagents = {} },
  { name = [[Primal Umbral Tin]], spellID = 1225369, itemID = 237362, skill = 0, source = [[Trainer]], category = [[Section II - Umbral Tin]], reagents = {} },
  { name = [[Voidbound Umbral Tin]], spellID = 1225370, itemID = 237362, skill = 0, source = [[Trainer]], category = [[Section II - Umbral Tin]], reagents = {} },
  { name = [[Wild Umbral Tin]], spellID = 1225368, itemID = 237362, skill = 0, source = [[Trainer]], category = [[Section II - Umbral Tin]], reagents = {} },
  { name = [[Cursed Umbral Tin]], spellID = 1301494, itemID = 237362, skill = 0, source = [[Patch 12.1]], category = [[Section II - Umbral Tin]], reagents = {}, note = [[Cursed nodes (12.1)]] },

  -- ========== Section III - Brilliant Silver ==========
  { name = [[Brilliant Silver]], spellID = 1225348, itemID = 237364, skill = 0, source = [[Trainer]], category = [[Section III - Brilliant Silver]], reagents = {} },
  { name = [[Brilliant Silver Seam]], spellID = 1225357, itemID = 237364, skill = 0, source = [[Trainer]], category = [[Section III - Brilliant Silver]], reagents = {} },
  { name = [[Rich Brilliant Silver]], spellID = 1225355, itemID = 237364, skill = 0, source = [[Trainer]], category = [[Section III - Brilliant Silver]], reagents = {} },
  { name = [[Lightfused Brilliant Silver]], spellID = 1225359, itemID = 237364, skill = 0, source = [[Trainer]], category = [[Section III - Brilliant Silver]], reagents = {} },
  { name = [[Primal Brilliant Silver]], spellID = 1225361, itemID = 237364, skill = 0, source = [[Trainer]], category = [[Section III - Brilliant Silver]], reagents = {} },
  { name = [[Voidbound Brilliant Silver]], spellID = 1225362, itemID = 237364, skill = 0, source = [[Trainer]], category = [[Section III - Brilliant Silver]], reagents = {} },
  { name = [[Wild Brilliant Silver]], spellID = 1225363, itemID = 237364, skill = 0, source = [[Trainer]], category = [[Section III - Brilliant Silver]], reagents = {} },
  { name = [[Cursed Brilliant Silver]], spellID = 1301486, itemID = 237364, skill = 0, source = [[Patch 12.1]], category = [[Section III - Brilliant Silver]], reagents = {}, note = [[Cursed nodes (12.1)]] },
}