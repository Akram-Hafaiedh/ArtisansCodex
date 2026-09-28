-- Midnight Fishing recipes
-- Sources: live client export (debug) + wow-professions.com / wowhead patch 12.1
-- spellID = craft recipe spell (C_TradeSkillUI.GetRecipeInfo / IsRecipeProfessionLearned)
-- source  = how the player learns the recipe (Drop / Vendor)

local _, private = ...
private.RecipeData = private.RecipeData or {}
private.RecipeCategoryTips = private.RecipeCategoryTips or {}

private.RecipeCategoryTips.Fishing = {
  ["Crafting"] = [[Lures and wards. Recipes drop from Careless Cargo / Lost Treasures pools, or Coiled Isle vendors in 12.1.]],
}

private.RecipeData.Fishing = {
  -- ========== Crafting (Lures & Wards) ==========
  { name = [[Amani Angler's Ward]], spellID = 1226159, itemID = 241148, skill = 0, source = [[Drop: Careless Cargo / Lost Treasures]], category = [[Crafting]], reagents = {{name="Blood Hunter",itemID=238377,amount=2}}, note = [[Prevents Blood Hunter Spirits for 30 min]] },
  { name = [[Blood Hunter Lure]], spellID = 1235486, itemID = 241147, skill = 0, source = [[Drop: Careless Cargo / Lost Treasures]], category = [[Crafting]], reagents = {{name="Gore Guppy",itemID=238382,amount=5}} },
  { name = [[Lucky Loa Lure]], spellID = 1226157, itemID = 241145, skill = 0, source = [[Drop: Careless Cargo / Lost Treasures]], category = [[Crafting]], reagents = {{name="Sin'dorei Swarmer",itemID=238365,amount=5}} },
  { name = [[Ominous Octopus Lure]], spellID = 1226161, itemID = 241149, skill = 0, source = [[Drop: Careless Cargo / Lost Treasures]], category = [[Crafting]], reagents = {{name="Null Voidfish",itemID=238380,amount=5}} },
  { name = [[Coiled Stargorger Lure]], spellID = 1231090, itemID = 241151, skill = 0, source = [[Vendor: Second Mate Sluggs (Coiled Isle)]], category = [[Crafting]], reagents = {}, note = [[Patch 12.1]] },
  { name = [[Ula'tek Snakehead Lure]], spellID = 1302819, itemID = 277821, skill = 0, source = [[Vendor: Second Mate Sluggs (Coiled Isle)]], category = [[Crafting]], reagents = {{name="Toxic Tlhapi",itemID=274588,amount=5}}, note = [[Patch 12.1]] },
  { name = [[Tokka's Multi-Ward]], spellID = 1295922, itemID = 275013, skill = 0, source = [[Vendor: Captain Tokka's Crew (Venom Trawler)]], category = [[Crafting]], reagents = {{name="Blood Hunter",itemID=238377,amount=3},{name="Dirty Darter",itemID=274592,amount=30},{name="Sulfurous Sludgefish",itemID=274590,amount=6},{name="Neutralized Venom Clot",itemID=274777,amount=2}}, note = [[Water walk + Blood Hunter ward · Patch 12.1]] },
}