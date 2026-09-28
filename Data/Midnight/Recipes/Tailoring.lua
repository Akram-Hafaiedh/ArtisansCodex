-- Midnight Tailoring recipes
-- Sources: wow-professions.com + wowhead.com (spellIDs from wow-professions guide links)
-- spellID = craft recipe spell (C_TradeSkillUI.GetRecipeInfo / IsRecipeProfessionLearned)
-- trainCost = cost in copper (160g = 1600000)

local _, private = ...
private.RecipeData = private.RecipeData or {}
private.RecipeCategoryTips = private.RecipeCategoryTips or {}

-- One-line tips shown under category headers in the Recipes tab.
private.RecipeCategoryTips.Tailoring = {
  ["Reagents"]        = [[Bolts & intermediates. Arcanoweave / Sunfire Silk bolts are daily cooldowns.]],
  ["Armor"]           = [[Trainer rare set for leveling; epic set unlocked via specialization.]],
  ["Embellished"]     = [[Unique effects; max 2 equipped. High demand for endgame cloth.]],
  ["Embellishments"]  = [[Unique effects; max 2 equipped. High demand for endgame cloth.]],
  ["Spellthread"]     = [[Tailor-only leg enchants. Always in demand.]],
  ["Profession Gear"] = [[Green = trainer BoE · Blue = vendor BoE · Epic = Soulbound (Crafting Orders).]],
  ["PvP"]             = [[Competitor's cloth from Mirvedon. Needs Competitor's Heraldry.]],
  ["Bags"]            = [[Profession bags and reagent satchels.]],
  ["Bandages"]        = [[Cloth bandages for combat healing.]],
  ["House Decor"]     = [[Housing cosmetics. Some are renown-gated.]],
  ["Wardrobe"]        = [[Cosmetic cloaks and appearance unlocks.]],
}

private.RecipeData.Tailoring = {
  -- ========== Reagents / Bolts ==========
  { name = [[Bright Linen Bolt]], spellID = 1228939, itemID = 239700, skill = 1, source = [[Trainer]], category = [[Reagents]], reagents = {{name="Bright Linen",itemID=236965,amount=1},{name="Silverleaf Thread",itemID=251665,amount=4},}, note = [[Primary leveling bolt]] },
  { name = [[Imbued Bright Linen Bolt]], spellID = 1228940, itemID = 239702, skill = 25, trainCost = 1600000, source = [[Trainer]], category = [[Reagents]], reagents = {{name="Bright Linen Bolt",itemID=239700,amount=2},{name="Silverleaf Thread",itemID=251665,amount=4},}, note = [[Unlocks with specializations at 25]] },
  { name = [[Arcanoweave Bolt]], spellID = 1227926, itemID = 239198, skill = 50, source = [[Spec: Nimble Needlework]], category = [[Reagents]], reagents = {{name="Mote of Wild Magic",itemID=236951,amount=4},{name="Arcanoweave",itemID=237017,amount=5},{name="Imbued Bright Linen Bolt",itemID=239702,amount=6},}, note = [[Daily cooldown; creates 2]] },
  { name = [[Sunfire Silk Bolt]], spellID = 1228060, itemID = 239201, skill = 50, source = [[Spec: Nimble Needlework]], category = [[Reagents]], reagents = {{name="Mote of Light",itemID=236949,amount=4},{name="Sunfire Silk",itemID=237016,amount=5},{name="Imbued Bright Linen Bolt",itemID=239702,amount=5},}, note = [[Daily cooldown; creates 2]] },

  -- ========== Rare Armor (Courtly set - Trainer) ==========
  { name = [[Courtly Helm]], spellID = 1228951, itemID = 239668, skill = 25, trainCost = 1600000, source = [[Trainer]], category = [[Armor]], reagents = {{name="Bright Linen Bolt",itemID=239700,amount=3},{name="Silverleaf Thread",itemID=251665,amount=4},{name="Embroidery Floss",itemID=251691,amount=3},} },
  { name = [[Courtly Gloves]], spellID = 1228952, itemID = 239669, skill = 15, trainCost = 1600000, source = [[Trainer]], category = [[Armor]], reagents = {{name="Bright Linen Bolt",itemID=239700,amount=3},{name="Silverleaf Thread",itemID=251665,amount=3},} },
  { name = [[Courtly Belt]], spellID = 1228953, itemID = 239670, skill = 10, trainCost = 1600000, source = [[Trainer]], category = [[Armor]], reagents = {{name="Bright Linen Bolt",itemID=239700,amount=2},{name="Silverleaf Thread",itemID=251665,amount=3},{name="Embroidery Floss",itemID=251691,amount=2},} },
  { name = [[Courtly Wrists]], spellID = 1228954, itemID = 239671, skill = 5, trainCost = 1600000, source = [[Trainer]], category = [[Armor]], reagents = {{name="Bright Linen Bolt",itemID=239700,amount=2},{name="Silverleaf Thread",itemID=251665,amount=2},} },
  { name = [[Courtly Robes]], spellID = 1228955, itemID = 239672, skill = 30, trainCost = 1600000, source = [[Trainer]], category = [[Armor]], reagents = {{name="Bright Linen Bolt",itemID=239700,amount=2},{name="Silverleaf Thread",itemID=251665,amount=3},} },
  { name = [[Courtly Pants]], spellID = 1228956, itemID = 239676, skill = 20, trainCost = 1600000, source = [[Trainer]], category = [[Armor]], reagents = {{name="Bright Linen Bolt",itemID=239700,amount=3},{name="Silverleaf Thread",itemID=251665,amount=4},{name="Embroidery Floss",itemID=251691,amount=3},} },
  { name = [[Courtly Slippers]], spellID = 1228957, itemID = 239673, skill = 15, trainCost = 1600000, source = [[Trainer]], category = [[Armor]], reagents = {{name="Bright Linen Bolt",itemID=239700,amount=2},{name="Silverleaf Thread",itemID=251665,amount=3},} },
  { name = [[Courtly Cloak]], spellID = 1228958, itemID = 239674, skill = 15, trainCost = 1600000, source = [[Trainer]], category = [[Armor]], reagents = {{name="Bright Linen Bolt",itemID=239700,amount=2},{name="Silverleaf Thread",itemID=251665,amount=3},} },
  { name = [[Courtly Shoulders]], spellID = 1228959, itemID = 239675, skill = 30, trainCost = 1600000, source = [[Trainer]], category = [[Armor]], reagents = {{name="Bright Linen Bolt",itemID=239700,amount=3},{name="Silverleaf Thread",itemID=251665,amount=3},{name="Embroidery Floss",itemID=251691,amount=1},} },

  -- ========== Epic Armor (Martyr's set - Spec: Sin'dorei Finery) ==========
  { name = [[Martyr's Crown]], spellID = 1228942, itemID = 239652, skill = 100, source = [[Spec: Sin'dorei Finery]], category = [[Armor]], reagents = {}, note = [[Epic]] },
  { name = [[Martyr's Gloves]], spellID = 1228943, itemID = 239653, skill = 100, source = [[Spec: Sin'dorei Finery]], category = [[Armor]], reagents = {}, note = [[Epic]] },
  { name = [[Martyr's Waistwrap]], spellID = 1228944, itemID = 239649, skill = 100, source = [[Spec: Sin'dorei Finery]], category = [[Armor]], reagents = {}, note = [[Epic]] },
  { name = [[Martyr's Bindings]], spellID = 1228945, itemID = 239648, skill = 100, source = [[Spec: Sin'dorei Finery]], category = [[Armor]], reagents = {}, note = [[Epic]] },
  { name = [[Martyr's Vestments]], spellID = 1228946, itemID = 239655, skill = 100, source = [[Spec: Sin'dorei Finery]], category = [[Armor]], reagents = {}, note = [[Epic]] },
  { name = [[Martyr's Leggings]], spellID = 1228947, itemID = 239651, skill = 100, source = [[Spec: Sin'dorei Finery]], category = [[Armor]], reagents = {}, note = [[Epic]] },
  { name = [[Martyr's Slippers]], spellID = 1228948, itemID = 239654, skill = 100, source = [[Spec: Sin'dorei Finery]], category = [[Armor]], reagents = {}, note = [[Epic]] },
  { name = [[Martyr's Mantle]], spellID = 1228949, itemID = 239650, skill = 100, source = [[Spec: Sin'dorei Finery]], category = [[Armor]], reagents = {}, note = [[Epic]] },
  { name = [[Adherent's Silken Shroud]], spellID = 1228950, itemID = 239656, skill = 100, source = [[Spec: Sin'dorei Finery]], category = [[Armor]], reagents = {}, note = [[Epic back]] },

  -- ========== Embellished Armor (Spec: Nimble Needlework / Drops) ==========
  { name = [[Arcanoweave Bracers]], spellID = 1228984, itemID = 239660, skill = 80, source = [[Spec: Nimble Needlework]], category = [[Embellished]], reagents = {}, note = [[Arcanoweave Trappings set]] },
  { name = [[Arcanoweave Cloak]], spellID = 1228985, itemID = 239661, skill = 100, source = [[Spec: Nimble Needlework]], category = [[Embellished]], reagents = {}, note = [[Arcanoweave Trappings set]] },
  { name = [[Arcanoweave Treads]], spellID = 1228986, itemID = 239662, skill = 80, source = [[Spec: Nimble Needlework]], category = [[Embellished]], reagents = {}, note = [[Arcanoweave Trappings set]] },
  { name = [[Arcanoweave Cord]], spellID = 1228988, itemID = 239664, skill = 80, source = [[Drop: Heavy Trunk (Delves)]], category = [[Embellished]], reagents = {}, note = [[Proc: +Mastery]] },
  { name = [[Sunfire Bracers]], spellID = 1228981, itemID = 239657, skill = 80, source = [[Spec: Nimble Needlework]], category = [[Embellished]], reagents = {}, note = [[Sunfire Silk Trappings set]] },
  { name = [[Sunfire Cloak]], spellID = 1228982, itemID = 239658, skill = 80, source = [[Spec: Nimble Needlework]], category = [[Embellished]], reagents = {}, note = [[Sunfire Silk Trappings set]] },
  { name = [[Sunfire Treads]], spellID = 1228983, itemID = 239659, skill = 80, source = [[Spec: Nimble Needlework]], category = [[Embellished]], reagents = {}, note = [[Sunfire Silk Trappings set]] },
  { name = [[Sunfire Sash]], spellID = 1228987, itemID = 239663, skill = 80, source = [[Drop: Restless Heart (Windrunner Spire)]], category = [[Embellished]], reagents = {}, note = [[Proc: Radiant damage]] },

  -- ========== PvP Gear (Thalassian Competitor's Cloth - Vendor: Mirvedon) ==========
  { name = [[Thalassian Competitor's Cloth Bands]], spellID = 1228989, itemID = 239677, skill = 60, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]], reagents = {}, note = [[Requires Competitor's Heraldry]] },
  { name = [[Thalassian Competitor's Cloth Cloak]], spellID = 1228990, itemID = 239678, skill = 60, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]], reagents = {{name="Silverleaf Thread",itemID=251665,amount=2},{name="Mote of Light",itemID=236949,amount=4},{name="Imbued Bright Linen Bolt",itemID=239702,amount=6},}, note = [[Requires Competitor's Heraldry]] },
  { name = [[Thalassian Competitor's Cloth Gloves]], spellID = 1228991, itemID = 239679, skill = 60, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]], reagents = {}, note = [[Requires Competitor's Heraldry]] },
  { name = [[Thalassian Competitor's Cloth Hood]], spellID = 1228992, itemID = 239680, skill = 60, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]], reagents = {{name="Silverleaf Thread",itemID=251665,amount=2},{name="Mote of Light",itemID=236949,amount=4},{name="Carving Canine",itemID=238523,amount=4},{name="Imbued Bright Linen Bolt",itemID=239702,amount=6},}, note = [[Requires Competitor's Heraldry]] },
  { name = [[Thalassian Competitor's Cloth Leggings]], spellID = 1228993, itemID = 239681, skill = 60, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]], reagents = {}, note = [[Requires Competitor's Heraldry]] },
  { name = [[Thalassian Competitor's Cloth Sash]], spellID = 1228994, itemID = 239682, skill = 60, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]], reagents = {}, note = [[Requires Competitor's Heraldry]] },
  { name = [[Thalassian Competitor's Cloth Shoulderpads]], spellID = 1228995, itemID = 239683, skill = 60, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]], reagents = {}, note = [[Requires Competitor's Heraldry]] },
  { name = [[Thalassian Competitor's Cloth Treads]], spellID = 1228996, itemID = 239684, skill = 60, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]], reagents = {{name="Silverleaf Thread",itemID=251665,amount=2},{name="Mote of Light",itemID=236949,amount=4},{name="Carving Canine",itemID=238523,amount=4},{name="Imbued Bright Linen Bolt",itemID=239702,amount=6},}, note = [[Requires Competitor's Heraldry]] },
  { name = [[Thalassian Competitor's Cloth Tunic]], spellID = 1228997, itemID = 239685, skill = 60, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]], reagents = {{name="Silverleaf Thread",itemID=251665,amount=2},{name="Mote of Pure Void",itemID=236952,amount=4},{name="Carving Canine",itemID=238523,amount=4},{name="Imbued Bright Linen Bolt",itemID=239702,amount=6},}, note = [[Requires Competitor's Heraldry]] },

  -- ========== Profession Gear ==========
  -- Green (Trainer) · Blue (Deynna 150 Moxie, BoE) · Epic (Deynna 150 Moxie, Soulbound)
  -- Green
  { name = [[Bright Linen Alchemy Apron]], spellID = 1228968, itemID = 239641, skill = 25, trainCost = 1600000, source = [[Trainer]], category = [[Profession Gear]], note = [[Green · Alchemy]] },
  { name = [[Chef's Bright Linen Cooking Chapeau]], spellID = 1228969, itemID = 239642, skill = 25, trainCost = 1600000, source = [[Trainer]], category = [[Profession Gear]], note = [[Green · Cooking]] },
  { name = [[Bright Linen Enchanting Hat]], spellID = 1228970, itemID = 239643, skill = 25, trainCost = 1600000, source = [[Trainer]], category = [[Profession Gear]], note = [[Green · Enchanting]] },
  { name = [[Bright Linen Fishing Hat]], spellID = 1228971, itemID = 239644, skill = 25, trainCost = 1600000, source = [[Trainer]], category = [[Profession Gear]], note = [[Green · Fishing]] },
  { name = [[Bright Linen Herbalism Hat]], spellID = 1228972, itemID = 239645, skill = 25, trainCost = 1600000, source = [[Trainer]], category = [[Profession Gear]], note = [[Green · Herbalism]] },
  { name = [[Bright Linen Tailoring Robe]], spellID = 1228973, itemID = 239646, skill = 30, trainCost = 1600000, source = [[Trainer]], category = [[Profession Gear]], reagents = {{name="Bright Linen Bolt",itemID=239700,amount=4},{name="Silverleaf Thread",itemID=251665,amount=5},{name="Embroidery Floss",itemID=251691,amount=2},}, note = [[Green · Tailoring]] },
  -- Blue
  { name = [[Elegant Artisan's Alchemy Coveralls]], spellID = 1228962, itemID = 239635, skill = 90, source = [[Vendor: Deynna (150 Moxie)]], category = [[Profession Gear]], reagents = {{name="Embroidery Floss",itemID=251691,amount=2},{name="Mote of Primal Energy",itemID=236950,amount=5},{name="Arcanoweave Bolt",itemID=239198,amount=8},{name="Radiant Shard",itemID=243602,amount=3},}, note = [[Blue · BoE]] },
  { name = [[Elegant Artisan's Cooking Hat]], spellID = 1228963, itemID = 239636, skill = 90, source = [[Vendor: Deynna (150 Moxie)]], category = [[Profession Gear]], note = [[Blue · BoE]] },
  { name = [[Elegant Artisan's Enchanting Hat]], spellID = 1228964, itemID = 239637, skill = 90, source = [[Vendor: Deynna (150 Moxie)]], category = [[Profession Gear]], note = [[Blue · BoE]] },
  { name = [[Elegant Artisan's Fishing Hat]], spellID = 1228965, itemID = 239638, skill = 90, source = [[Vendor: Deynna (150 Moxie)]], category = [[Profession Gear]], note = [[Blue · BoE]] },
  { name = [[Elegant Artisan's Herbalism Hat]], spellID = 1228966, itemID = 239639, skill = 90, source = [[Vendor: Deynna (150 Moxie)]], category = [[Profession Gear]], reagents = {{name="Embroidery Floss",itemID=251691,amount=2},{name="Mote of Wild Magic",itemID=236951,amount=5},{name="Arcanoweave Bolt",itemID=239198,amount=8},{name="Radiant Shard",itemID=243602,amount=3},}, note = [[Blue · BoE]] },
  { name = [[Elegant Artisan's Tailoring Robe]], spellID = 1228967, itemID = 239640, skill = 90, source = [[Vendor: Deynna (150 Moxie)]], category = [[Profession Gear]], reagents = {{name="Embroidery Floss",itemID=251691,amount=2},{name="Mote of Pure Void",itemID=236952,amount=5},{name="Sunfire Silk Bolt",itemID=239201,amount=8},{name="Radiant Shard",itemID=243602,amount=3},}, note = [[Blue · BoE]] },
  -- Epic (Soulbound · Crafting Orders) — IDs from Wowhead
  { name = [[Thalassian Alchemy Coveralls]], spellID = 1279123, itemID = 267052, skill = 90, source = [[Vendor: Deynna (150 Moxie)]], category = [[Profession Gear]], reagents = {{name="Embroidery Floss",itemID=251691,amount=2},{name="Mote of Primal Energy",itemID=236950,amount=5},{name="Fused Vitality",itemID=245345,amount=20},{name="Arcanoweave Bolt",itemID=239198,amount=8},{name="Radiant Shard",itemID=243602,amount=3},}, note = [[Epic · Soulbound]] },
  { name = [[Thalassian Chef's Chapeau]], spellID = 1279124, itemID = 267054, skill = 90, source = [[Vendor: Deynna (150 Moxie)]], category = [[Profession Gear]], reagents = {{name="Embroidery Floss",itemID=251691,amount=2},{name="Mote of Light",itemID=236949,amount=5},{name="Fused Vitality",itemID=245345,amount=20},{name="Sunfire Silk Bolt",itemID=239201,amount=8},{name="Radiant Shard",itemID=243602,amount=3},}, note = [[Epic · Soulbound]] },
  { name = [[Thalassian Enchanter's Bonnet]], spellID = 1279125, itemID = 267056, skill = 90, source = [[Vendor: Deynna (150 Moxie)]], category = [[Profession Gear]], reagents = {{name="Embroidery Floss",itemID=251691,amount=2},{name="Mote of Wild Magic",itemID=236951,amount=5},{name="Fused Vitality",itemID=245345,amount=20},{name="Arcanoweave Bolt",itemID=239198,amount=8},{name="Radiant Shard",itemID=243602,amount=3},}, note = [[Epic · Soulbound]] },
  { name = [[Thalassian Herbalist's Cowl]], spellID = 1279128, itemID = 267060, skill = 90, source = [[Vendor: Deynna (150 Moxie)]], category = [[Profession Gear]], reagents = {{name="Embroidery Floss",itemID=251691,amount=2},{name="Mote of Wild Magic",itemID=236951,amount=5},{name="Fused Vitality",itemID=245345,amount=20},{name="Arcanoweave Bolt",itemID=239198,amount=8},{name="Radiant Shard",itemID=243602,amount=3},}, note = [[Epic · Soulbound]] },
  { name = [[Thalassian Tailor's Threads]], spellID = 1279129, itemID = 267062, skill = 90, source = [[Vendor: Deynna (150 Moxie)]], category = [[Profession Gear]], reagents = {{name="Embroidery Floss",itemID=251691,amount=2},{name="Mote of Pure Void",itemID=236952,amount=5},{name="Fused Vitality",itemID=245345,amount=20},{name="Sunfire Silk Bolt",itemID=239201,amount=8},{name="Radiant Shard",itemID=243602,amount=3},}, note = [[Epic · Soulbound]] },

  -- ========== Spellthread ==========
  { name = [[Bright Linen Spellthread]], spellID = 1228976, itemID = 240156, skill = 35, trainCost = 1600000, source = [[Trainer]], category = [[Spellthread]], reagents = {{name="Imbued Bright Linen Bolt",itemID=239702,amount=2},{name="Eversinging Dust",itemID=243599,amount=2},{name="Embroidery Floss",itemID=251691,amount=3},}, note = [[+Intellect leg enchant]] },
  { name = [[Arcanoweave Spellthread]], spellID = 1228975, itemID = 240154, skill = 60, source = [[Vendor: Caeris Fairdawn (Renown)]], category = [[Spellthread]], reagents = {{name="Arcanoweave Bolt",itemID=239198,amount=2},{name="Mote of Pure Void",itemID=236952,amount=1},}, note = [[+Intellect, +max mana]] },
  { name = [[Sunfire Silk Spellthread]], spellID = 1228974, itemID = 240094, skill = 80, source = [[Drop: Fallen-King Salhadaar]], category = [[Spellthread]], reagents = {{name="Embroidery Floss",itemID=251691,amount=5},{name="Mote of Primal Energy",itemID=236950,amount=6},{name="Petrified Root",itemID=251285,amount=4},{name="Sunfire Silk Bolt",itemID=239201,amount=8},{name="Radiant Shard",itemID=243602,amount=6},{name="Sunfire Silk",itemID=237015,amount=12},}, note = [[+Intellect, +Stamina]] },

  -- ========== Bags ==========
  { name = [[Imbued Bright Linen Backpack]], spellID = 1228977, itemID = 240160, skill = 35, trainCost = 1600000, source = [[Trainer]], category = [[Bags]], reagents = {{name="Imbued Bright Linen Bolt",itemID=239702,amount=4},{name="Silverleaf Thread",itemID=251665,amount=6},} },
  { name = [[Bright Linen Reagent Satchel]], spellID = 1228978, itemID = 240159, skill = 35, trainCost = 1600000, source = [[Trainer]], category = [[Bags]], reagents = {{name="Imbued Bright Linen Bolt",itemID=239702,amount=3},{name="Silverleaf Thread",itemID=251665,amount=4},} },
  { name = [[Arcanoweave Reagent Rucksack]], spellID = 1228979, itemID = 240158, skill = 60, trainCost = 1600000, source = [[Trainer]], category = [[Bags]], reagents = {{name="Arcanoweave Bolt",itemID=239198,amount=4},} },
  { name = [[Sunfire Silk Backpack]], spellID = 1228980, itemID = 240161, skill = 50, trainCost = 1600000, source = [[Trainer]], category = [[Bags]], reagents = {{name="Sunfire Silk Bolt",itemID=239201,amount=4},} },

  -- ========== Bandages ==========
  { name = [[Bright Linen Bandage]], spellID = 1228941, itemID = 239711, skill = 1, trainCost = 1600000, source = [[Trainer]], category = [[Bandages]], reagents = {{name="Bright Linen Bolt",itemID=239700,amount=1},} },

  -- ========== Embellishments / Optional Reagents (Linings) ==========
  { name = [[Arcanoweave Lining]], spellID = 1228961, itemID = 240166, skill = 80, source = [[Drop: Degentrius (Magisters' Terrace)]], category = [[Embellishments]], reagents = {{name="Embroidery Floss",itemID=251691,amount=1},{name="Arcanoweave Bolt",itemID=239198,amount=2},{name="Arcanoweave",itemID=237018,amount=6},}, note = [[Optional reagent / embellishment]] },
  { name = [[Sunfire Silk Lining]], spellID = 1228960, itemID = 240164, skill = 80, source = [[Drop: Heavy Trunk (Delves)]], category = [[Embellishments]], reagents = {}, note = [[Optional reagent / embellishment]] },
  { name = [[Snakeskin Lining]], spellID = 1288335, itemID = 270898, skill = 80, source = [[Patch 12.1]], category = [[Embellishments]], reagents = {{name="Embroidery Floss",itemID=251691,amount=1},{name="Cursebound Globe",itemID=274781,amount=6},{name="Neutralized Venom Clot",itemID=274777,amount=4},{name="Arcanoweave Bolt",itemID=239198,amount=2},{name="Sunfire Silk Bolt",itemID=239201,amount=2},}, note = [[Optional reagent / embellishment]] },

  -- ========== House Decor ==========
  { name = [[Silvermoon Curtains]], spellID = 1229000, itemID = 262599, skill = 85, source = [[Quest: Clothes Make the Man]], category = [[House Decor]], reagents = {{name="Silverleaf Thread",itemID=251665,amount=3},{name="Thalassian Lumber",itemID=256963,amount=24},{name="Arcanoweave Bolt",itemID=239198,amount=8},{name="Sunfire Silk Bolt",itemID=239201,amount=8},} },
  { name = [[Lush Telogrus Carpet]], spellID = 1229001, itemID = 262352, skill = 70, source = [[Vendor: Void Researcher Anomander (Renown)]], category = [[House Decor]], reagents = {{name="Silverleaf Thread",itemID=251665,amount=3},{name="Thalassian Lumber",itemID=256963,amount=8},{name="Arcanoweave Bolt",itemID=239198,amount=4},{name="Sunfire Silk Bolt",itemID=239201,amount=4},} },
  { name = [[Luxurious Silvermoon Lounge Cushion]], spellID = 1229002, itemID = 262591, skill = 85, source = [[Drop: Eversong Treasures]], category = [[House Decor]], reagents = {{name="Silverleaf Thread",itemID=251665,amount=3},{name="Thalassian Lumber",itemID=256963,amount=6},{name="Sunfire Silk Bolt",itemID=239201,amount=4},} },
  { name = [[Plush Silvermoon Bed]], spellID = 1229003, itemID = 262592, skill = 85, source = [[Vendor: Deynna (Silvermoon)]], category = [[House Decor]], reagents = {{name="Silverleaf Thread",itemID=251665,amount=3},{name="Thalassian Lumber",itemID=256963,amount=22},{name="Arcanoweave Bolt",itemID=239198,amount=8},{name="Sunfire Silk Bolt",itemID=239201,amount=8},} },
  { name = [[Chic Silvermoon Pillow]], spellID = 1246919, itemID = 262593, skill = 85, source = [[Vendor: Deynna (Silvermoon)]], category = [[House Decor]], reagents = {{name="Silverleaf Thread",itemID=251665,amount=3},{name="Thalassian Lumber",itemID=256963,amount=4},{name="Arcanoweave Bolt",itemID=239198,amount=4},} },
  { name = [[Voidstrider Saddlebag]], spellID = 1246929, itemID = 262611, skill = 85, source = [[Drop: Victorious Stormarion Pinnacle Cache]], category = [[House Decor]], reagents = {{name="Silverleaf Thread",itemID=251665,amount=3},{name="Thalassian Lumber",itemID=256963,amount=8},{name="Imbued Bright Linen Bolt",itemID=239702,amount=4},} },
  { name = [[Twilight's Blade Bedroll]], spellID = 1296512, itemID = 279350, skill = 85, source = [[Drop: Thalassian Recipe in a Bottle]], category = [[House Decor]], reagents = {{name="Silverleaf Thread",itemID=251665,amount=3},{name="Thalassian Lumber",itemID=256963,amount=8},{name="Imbued Bright Linen Bolt",itemID=239702,amount=8},}, note = [[Patch 12.1]] },
  { name = [[Tortollan Slingsack]], spellID = 1296514, itemID = 279353, skill = 85, source = [[Vendor: Navigator Otoola (Coiled Isle)]], category = [[House Decor]], reagents = {{name="Silverleaf Thread",itemID=251665,amount=3},{name="Thalassian Lumber",itemID=256963,amount=8},{name="Imbued Bright Linen Bolt",itemID=239702,amount=4},}, note = [[Patch 12.1]] },

  -- ========== Wardrobe Enhancements (Cosmetic Capes) ==========
  { name = [[Smuggler's Cloak]], spellID = 1280541, itemID = 267444, skill = 50, trainCost = 1600000, source = [[Trainer]], category = [[Wardrobe]], reagents = {{name="Embroidery Floss",itemID=251691,amount=2},{name="Mote of Pure Void",itemID=236952,amount=6},{name="Arcanoweave",itemID=237017,amount=10},{name="Arcanoweave Bolt",itemID=239198,amount=32},} },
  { name = [[Silvermoon Agent's Drape]], spellID = 1280542, itemID = 267445, skill = 50, trainCost = 1600000, source = [[Trainer]], category = [[Wardrobe]], reagents = {{name="Embroidery Floss",itemID=251691,amount=2},{name="Mote of Pure Void",itemID=236952,amount=6},{name="Arcanoweave",itemID=237017,amount=10},{name="Arcanoweave Bolt",itemID=239198,amount=32},} },
  { name = [[Scout's Cape]], spellID = 1280543, itemID = 267446, skill = 50, trainCost = 1600000, source = [[Trainer]], category = [[Wardrobe]], reagents = {{name="Embroidery Floss",itemID=251691,amount=2},} },
  { name = [[Farstrider's Embroidered Cover]], spellID = 1280544, itemID = 267447, skill = 50, trainCost = 1600000, source = [[Trainer]], category = [[Wardrobe]], reagents = {{name="Embroidery Floss",itemID=251691,amount=2},{name="Mote of Primal Energy",itemID=236950,amount=6},{name="Sunfire Silk",itemID=237016,amount=10},{name="Sunfire Silk Bolt",itemID=239201,amount=32},} },
  { name = [[Blood-Tempered Cape]], spellID = 1280545, itemID = 267448, skill = 50, trainCost = 1600000, source = [[Trainer]], category = [[Wardrobe]], reagents = {{name="Embroidery Floss",itemID=251691,amount=2},{name="Mote of Wild Magic",itemID=236951,amount=6},{name="Arcanoweave",itemID=237017,amount=10},{name="Arcanoweave Bolt",itemID=239198,amount=32},} },
  { name = [[Spellbreaker's Shroud]], spellID = 1280546, itemID = 267449, skill = 50, trainCost = 1600000, source = [[Trainer]], category = [[Wardrobe]], reagents = {{name="Embroidery Floss",itemID=251691,amount=2},} },
}