-- Midnight Herbalism recipes (herb nodes + mulch crafts)
-- Sources: live client export (debug)
-- Node "recipes" usually have itemID 0; Mulch crafts have real itemIDs
-- source = Trainer for base nodes / mulch; Patch 12.1 for Cursed variants

local _, private = ...
private.RecipeData = private.RecipeData or {}
private.RecipeCategoryTips = private.RecipeCategoryTips or {}

private.RecipeCategoryTips.Herbalism = {
  ["Section I - Peacebloom"] = [[Tranquility Bloom nodes and variants (base Midnight herb).]],
  ["Section II - Sanguithorn"] = [[Sanguithorn nodes and variants.]],
  ["Section III - Azeroot"] = [[Azeroot nodes and variants.]],
  ["Section IV - Argentleaf"] = [[Argentleaf nodes and variants.]],
  ["Section V - Mana Lily"] = [[Mana Lily nodes and variants.]],
  ["Mulch"] = [[Craft mulch from Tranquility Bloom for planting / bonuses.]],
}

private.RecipeData.Herbalism = {
  -- ========== Section I - Peacebloom (Tranquility Bloom) ==========
  { name = [[Tranquility Bloom]], spellID = 1223099, itemID = 236761, skill = 0, source = [[Trainer]], category = [[Section I - Peacebloom]], reagents = {} },
  { name = [[Lush Tranquility Bloom]], spellID = 1223148, itemID = 236761, skill = 0, source = [[Trainer]], category = [[Section I - Peacebloom]], reagents = {} },
  { name = [[Lightfused Tranquility Bloom]], spellID = 1224883, itemID = 236761, skill = 0, source = [[Trainer]], category = [[Section I - Peacebloom]], reagents = {} },
  { name = [[Primal Tranquility Bloom]], spellID = 1224888, itemID = 236761, skill = 0, source = [[Trainer]], category = [[Section I - Peacebloom]], reagents = {} },
  { name = [[Voidbound Tranquility Bloom]], spellID = 1224898, itemID = 236761, skill = 0, source = [[Trainer]], category = [[Section I - Peacebloom]], reagents = {} },
  { name = [[Wild Tranquility Bloom]], spellID = 1224893, itemID = 236761, skill = 0, source = [[Trainer]], category = [[Section I - Peacebloom]], reagents = {} },
  { name = [[Cursed Tranquility Bloom]], spellID = 1301655, itemID = 236761, skill = 0, source = [[Patch 12.1]], category = [[Section I - Peacebloom]], reagents = {}, note = [[Cursed nodes (12.1)]] },

  -- ========== Section II - Sanguithorn ==========
  { name = [[Sanguithorn]], spellID = 1223135, itemID = 236770, skill = 0, source = [[Trainer]], category = [[Section II - Sanguithorn]], reagents = {} },
  { name = [[Lush Sanguithorn]], spellID = 1223151, itemID = 236770, skill = 0, source = [[Trainer]], category = [[Section II - Sanguithorn]], reagents = {} },
  { name = [[Lightfused Sanguithorn]], spellID = 1224886, itemID = 236770, skill = 0, source = [[Trainer]], category = [[Section II - Sanguithorn]], reagents = {} },
  { name = [[Primal Sanguithorn]], spellID = 1224891, itemID = 236770, skill = 0, source = [[Trainer]], category = [[Section II - Sanguithorn]], reagents = {} },
  { name = [[Voidbound Sanguithorn]], spellID = 1224901, itemID = 236770, skill = 0, source = [[Trainer]], category = [[Section II - Sanguithorn]], reagents = {} },
  { name = [[Wild Sanguithorn]], spellID = 1224896, itemID = 236770, skill = 0, source = [[Trainer]], category = [[Section II - Sanguithorn]], reagents = {} },
  { name = [[Cursed Sanguithorn]], spellID = 1301654, itemID = 236770, skill = 0, source = [[Patch 12.1]], category = [[Section II - Sanguithorn]], reagents = {}, note = [[Cursed nodes (12.1)]] },

  -- ========== Section III - Azeroot ==========
  { name = [[Azeroot]], spellID = 1223137, itemID = 236774, skill = 0, source = [[Trainer]], category = [[Section III - Azeroot]], reagents = {} },
  { name = [[Lush Azeroot]], spellID = 1223150, itemID = 236774, skill = 0, source = [[Trainer]], category = [[Section III - Azeroot]], reagents = {} },
  { name = [[Lightfused Azeroot]], spellID = 1224885, itemID = 236774, skill = 0, source = [[Trainer]], category = [[Section III - Azeroot]], reagents = {} },
  { name = [[Primal Azeroot]], spellID = 1224890, itemID = 236774, skill = 0, source = [[Trainer]], category = [[Section III - Azeroot]], reagents = {} },
  { name = [[Voidbound Azeroot]], spellID = 1224900, itemID = 236774, skill = 0, source = [[Trainer]], category = [[Section III - Azeroot]], reagents = {} },
  { name = [[Wild Azeroot]], spellID = 1224895, itemID = 236774, skill = 0, source = [[Trainer]], category = [[Section III - Azeroot]], reagents = {} },
  { name = [[Cursed Azeroot]], spellID = 1301649, itemID = 236774, skill = 0, source = [[Patch 12.1]], category = [[Section III - Azeroot]], reagents = {}, note = [[Cursed nodes (12.1)]] },

  -- ========== Section IV - Argentleaf ==========
  { name = [[Argentleaf]], spellID = 1223138, itemID = 236776, skill = 0, source = [[Trainer]], category = [[Section IV - Argentleaf]], reagents = {} },
  { name = [[Lush Argentleaf]], spellID = 1223146, itemID = 236776, skill = 0, source = [[Trainer]], category = [[Section IV - Argentleaf]], reagents = {} },
  { name = [[Lightfused Argentleaf]], spellID = 1224882, itemID = 236776, skill = 0, source = [[Trainer]], category = [[Section IV - Argentleaf]], reagents = {} },
  { name = [[Primal Argentleaf]], spellID = 1224887, itemID = 236776, skill = 0, source = [[Trainer]], category = [[Section IV - Argentleaf]], reagents = {} },
  { name = [[Voidbound Argentleaf]], spellID = 1224897, itemID = 236776, skill = 0, source = [[Trainer]], category = [[Section IV - Argentleaf]], reagents = {} },
  { name = [[Wild Argentleaf]], spellID = 1224892, itemID = 236776, skill = 0, source = [[Trainer]], category = [[Section IV - Argentleaf]], reagents = {} },
  { name = [[Cursed Argentleaf]], spellID = 1301647, itemID = 236776, skill = 0, source = [[Patch 12.1]], category = [[Section IV - Argentleaf]], reagents = {}, note = [[Cursed nodes (12.1)]] },

  -- ========== Section V - Mana Lily ==========
  { name = [[Mana Lily]], spellID = 1223139, itemID = 236778, skill = 0, source = [[Trainer]], category = [[Section V - Mana Lily]], reagents = {} },
  { name = [[Lush Mana Lily]], spellID = 1223149, itemID = 236778, skill = 0, source = [[Trainer]], category = [[Section V - Mana Lily]], reagents = {} },
  { name = [[Lightfused Mana Lily]], spellID = 1224884, itemID = 236778, skill = 0, source = [[Trainer]], category = [[Section V - Mana Lily]], reagents = {} },
  { name = [[Primal Mana Lily]], spellID = 1224889, itemID = 236778, skill = 0, source = [[Trainer]], category = [[Section V - Mana Lily]], reagents = {} },
  { name = [[Voidbound Mana Lily]], spellID = 1224899, itemID = 236778, skill = 0, source = [[Trainer]], category = [[Section V - Mana Lily]], reagents = {} },
  { name = [[Wild Mana Lily]], spellID = 1224894, itemID = 236778, skill = 0, source = [[Trainer]], category = [[Section V - Mana Lily]], reagents = {} },
  { name = [[Cursed Mana Lily]], spellID = 1301651, itemID = 236778, skill = 0, source = [[Patch 12.1]], category = [[Section V - Mana Lily]], reagents = {}, note = [[Cursed nodes (12.1)]] },

  -- ========== Mulch ==========
  { name = [[Magical Mulch]], spellID = 1221179, itemID = 238387, skill = 0, source = [[Trainer]], category = [[Mulch]], reagents = {{name="Tranquility Bloom",itemID=236761,amount=5}} },
  { name = [[Imbued Mulch]], spellID = 1221180, itemID = 238388, skill = 0, source = [[Trainer]], category = [[Mulch]], reagents = {{name="Tranquility Bloom",itemID=236761,amount=10}} },
  { name = [[Empowered Mulch]], spellID = 1221181, itemID = 238389, skill = 0, source = [[Trainer]], category = [[Mulch]], reagents = {{name="Tranquility Bloom",itemID=236761,amount=20}} },
}