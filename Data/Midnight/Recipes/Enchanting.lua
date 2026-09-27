-- Midnight Enchanting recipes
-- Sources: wow-professions.com + wowhead.com (spellIDs from wow-professions guide links)
-- spellID = craft recipe spell (C_TradeSkillUI.GetRecipeInfo / .learned)
-- Enchants often have no output itemID (applied directly); rods/oils/decor do.

local _, private = ...
private.RecipeData = private.RecipeData or {}

private.RecipeData.Enchanting = {
  -- ========== Weapon Enchants ==========
  { name = [[Enchant Weapon - Berserker's Rage]], spellID = 1236067, itemID = 0, skill = 20, source = [[Trainer]], category = [[Weapon]], note = [[Proc: Haste buff · Amani]] },
  { name = [[Enchant Weapon - Jan'alai's Precision]], spellID = 1236066, itemID = 0, skill = 55, source = [[Trainer]], category = [[Weapon]], note = [[Proc: Crit buff · Amani]] },
  { name = [[Enchant Weapon - Arcane Mastery]], spellID = 1236097, itemID = 0, skill = 40, source = [[Trainer]], category = [[Weapon]], note = [[Proc: Mastery buff · Thalassian]] },
  { name = [[Enchant Weapon - Acuity of the Ren'dorei]], spellID = 1236095, itemID = 0, skill = 0, source = [[Vendor: Void Researcher Anomander (Renown)]], category = [[Weapon]], note = [[Proc: Primary Stat · Thalassian]] },
  { name = [[Enchant Weapon - Strength of Halazzi]], spellID = 1236065, itemID = 0, skill = 0, source = [[Vendor: Magovu (Renown)]], category = [[Weapon]], note = [[Proc: Bleed damage · Amani]] },
  { name = [[Enchant Weapon - Flames of the Sin'dorei]], spellID = 1236094, itemID = 0, skill = 0, source = [[Drop: Degentrius (Magisters' Terrace)]], category = [[Weapon]], note = [[Ignite + AoE on kill · Thalassian]] },
  { name = [[Enchant Weapon - Worldsoul Aegis]], spellID = 1236080, itemID = 0, skill = 55, source = [[Trainer]], category = [[Weapon]], note = [[Shield on damage taken · Haranir]] },
  { name = [[Enchant Weapon - Worldsoul Tenacity]], spellID = 1236081, itemID = 0, skill = 0, source = [[Vendor: Naynar (Renown)]], category = [[Weapon]], note = [[Vers + absorb · Haranir]] },
  { name = [[Enchant Weapon - Worldsoul Cradle]], spellID = 1236079, itemID = 0, skill = 0, source = [[Drop: Chimaerus (The Dreamrift)]], category = [[Weapon]], note = [[Heal absorb shield · Haranir]] },

  -- ========== Boot Enchants ==========
  { name = [[Enchant Boots - Lynx's Dexterity]], spellID = 1236057, itemID = 0, skill = 0, source = [[Spec: Amani Augments]], category = [[Boots]], note = [[+Avoidance, +Stamina · Amani]] },
  { name = [[Enchant Boots - Shaladrassil's Roots]], spellID = 1236072, itemID = 0, skill = 0, source = [[Drop: Heavy Trunk (Delves)]], category = [[Boots]], note = [[+Leech, +Stamina · Haranir]] },
  { name = [[Enchant Boots - Farstrider's Hunt]], spellID = 1236085, itemID = 0, skill = 0, source = [[Vendor: Construct V'anore (Silvermoon)]], category = [[Boots]], note = [[+Speed, +Stamina · Thalassian]] },

  -- ========== Chest Enchants ==========
  { name = [[Enchant Chest - Mark of the Rootwarden]], spellID = 1236068, itemID = 0, skill = 0, source = [[Vendor: Naynar (Renown)]], category = [[Chest]], note = [[+Agility, +Speed · Haranir]] },
  { name = [[Enchant Chest - Mark of the Magister]], spellID = 1236082, itemID = 0, skill = 0, source = [[Drop: Degentrius (Magisters' Terrace)]], category = [[Chest]], note = [[+Intellect, +Mana% · Thalassian]] },
  { name = [[Enchant Chest - Mark of Nalorakk]], spellID = 1236054, itemID = 0, skill = 0, source = [[Drop: Chest of Proven Valor (Den of Nalorakk)]], category = [[Chest]], note = [[+Strength, +Stamina · Amani]] },
  { name = [[Enchant Chest - Mark of the Worldsoul]], spellID = 1236069, itemID = 0, skill = 0, source = [[Spec: Haranir Heightening]], category = [[Chest]], note = [[+Primary Stat · Haranir]] },

  -- ========== Helm Enchants ==========
  { name = [[Enchant Helm - Rune of Avoidance]], spellID = 1236083, itemID = 0, skill = 15, source = [[Trainer]], category = [[Helm]], note = [[+Avoidance · Thalassian]] },
  { name = [[Enchant Helm - Empowered Rune of Avoidance]], spellID = 1236084, itemID = 0, skill = 0, source = [[Drop: Heavy Trunk (Delves)]], category = [[Helm]], note = [[+Avoidance, +Speed burst on kill · Thalassian]] },
  { name = [[Enchant Helm - Hex of Leeching]], spellID = 1236055, itemID = 0, skill = 35, source = [[Trainer]], category = [[Helm]], note = [[+Leech · Amani]] },
  { name = [[Enchant Helm - Empowered Hex of Leeching]], spellID = 1236056, itemID = 0, skill = 0, source = [[Drop: Heavy Trunk (Delves)]], category = [[Helm]], note = [[+Leech, +Heal on kill · Amani]] },
  { name = [[Enchant Helm - Blessing of Speed]], spellID = 1236070, itemID = 0, skill = 50, source = [[Trainer]], category = [[Helm]], note = [[+Speed · Haranir]] },
  { name = [[Enchant Helm - Empowered Blessing of Speed]], spellID = 1236071, itemID = 0, skill = 0, source = [[Spec: Haranir Heightening]], category = [[Helm]], note = [[+Speed, +Vigor on kill · Haranir]] },

  -- ========== Shoulder Enchants ==========
  { name = [[Enchant Shoulders - Nature's Grace]], spellID = 1236075, itemID = 0, skill = 10, source = [[Trainer]], category = [[Shoulders]], note = [[+Avoidance · Haranir]] },
  { name = [[Enchant Shoulders - Amirdrassil's Grace]], spellID = 1236076, itemID = 0, skill = 0, source = [[Drop: Heavy Trunk (Delves)]], category = [[Shoulders]], note = [[+Avoidance (higher) · Haranir]] },
  { name = [[Enchant Shoulders - Thalassian Recovery]], spellID = 1236090, itemID = 0, skill = 50, source = [[Trainer]], category = [[Shoulders]], note = [[+Leech · Thalassian]] },
  { name = [[Enchant Shoulders - Silvermoon's Mending]], spellID = 1236091, itemID = 0, skill = 0, source = [[Spec: Thalassian Talents]], category = [[Shoulders]], note = [[+Leech (higher) · Thalassian]] },
  { name = [[Enchant Shoulders - Flight of the Eagle]], spellID = 1236061, itemID = 0, skill = 30, source = [[Trainer]], category = [[Shoulders]], note = [[+Speed · Amani]] },
  { name = [[Enchant Shoulders - Akil'zon's Swiftness]], spellID = 1236062, itemID = 0, skill = 0, source = [[Drop: Heavy Trunk (Delves)]], category = [[Shoulders]], note = [[+Speed (higher) · Amani]] },

  -- ========== Ring Enchants ==========
  { name = [[Enchant Ring - Nature's Wrath]], spellID = 1236073, itemID = 0, skill = 25, source = [[Trainer]], category = [[Rings]], note = [[+Crit · Haranir]] },
  { name = [[Enchant Ring - Nature's Fury]], spellID = 1236074, itemID = 0, skill = 0, source = [[Drop: Heavy Trunk (Delves)]], category = [[Rings]], note = [[+Crit (higher) · Haranir]] },
  { name = [[Enchant Ring - Eyes of the Eagle]], spellID = 1236059, itemID = 0, skill = 0, source = [[Drop: Zul'Aman Treasures]], category = [[Rings]], note = [[+Crit Effectiveness% · Amani]] },
  { name = [[Enchant Ring - Thalassian Haste]], spellID = 1236086, itemID = 0, skill = 1, source = [[Trainer]], category = [[Rings]], note = [[+Haste · Thalassian]] },
  { name = [[Enchant Ring - Silvermoon's Alacrity]], spellID = 1236088, itemID = 0, skill = 0, source = [[Spec: Thalassian Talents]], category = [[Rings]], note = [[+Haste (higher) · Thalassian]] },
  { name = [[Enchant Ring - Amani Mastery]], spellID = 1236058, itemID = 0, skill = 45, source = [[Trainer]], category = [[Rings]], note = [[+Mastery · Amani]] },
  { name = [[Enchant Ring - Zul'jin's Mastery]], spellID = 1236060, itemID = 0, skill = 0, source = [[Spec: Amani Augments]], category = [[Rings]], note = [[+Mastery (higher) · Amani]] },
  { name = [[Enchant Ring - Thalassian Versatility]], spellID = 1236087, itemID = 0, skill = 5, source = [[Trainer]], category = [[Rings]], note = [[+Vers · Thalassian]] },
  { name = [[Enchant Ring - Silvermoon's Tenacity]], spellID = 1236089, itemID = 0, skill = 0, source = [[Vendor: Caeris Fairdawn (Renown)]], category = [[Rings]], note = [[+Vers (higher) · Thalassian]] },

  -- ========== Tool Enchants ==========
  { name = [[Enchant Tool - Amani Perception]], spellID = 1236063, itemID = 0, skill = 0, source = [[Vendor: Magovu (Renown)]], category = [[Tools]], note = [[+Perception · Amani]] },
  { name = [[Enchant Tool - Amani Resourcefulness]], spellID = 1236064, itemID = 0, skill = 0, source = [[Spec: Amani Augments]], category = [[Tools]], note = [[+Resourcefulness · Amani]] },
  { name = [[Enchant Tool - Haranir Finesse]], spellID = 1236077, itemID = 0, skill = 0, source = [[Spec: Haranir Heightening]], category = [[Tools]], note = [[+Finesse · Haranir]] },
  { name = [[Enchant Tool - Haranir Multicrafting]], spellID = 1236078, itemID = 0, skill = 0, source = [[Vendor: Naynar (Renown)]], category = [[Tools]], note = [[+Multicrafting · Haranir]] },
  { name = [[Enchant Tool - Ren'dorei Ingenuity]], spellID = 1236093, itemID = 0, skill = 0, source = [[Vendor: Void Researcher Anomander (Renown)]], category = [[Tools]], note = [[+Ingenuity · Thalassian]] },
  { name = [[Enchant Tool - Sin'dorei Deftness]], spellID = 1236092, itemID = 0, skill = 0, source = [[Spec: Thalassian Talents]], category = [[Tools]], note = [[+Deftness · Thalassian]] },

  -- ========== Oils / Consumables ==========
  { name = [[Oil of Dawn]], spellID = 1236492, itemID = 243736, skill = 0, source = [[Spec: Transitories, Tonics, and Tools]], category = [[Oils]], note = [[Healer oil: chance to shield target]] },
  { name = [[Smuggler's Enchanted Edge]], spellID = 1236493, itemID = 243738, skill = 0, source = [[Drop: Lithiel Cinderfury (Murder Row)]], category = [[Oils]], note = [[DPS oil: Arcane damage]] },
  { name = [[Thalassian Phoenix Oil]], spellID = 1236491, itemID = 243734, skill = 20, source = [[Trainer]], category = [[Oils]], note = [[+Crit and +Haste]] },

  -- ========== Rods (Profession Tool) ==========
  { name = [[Runed Refulgent Copper Rod]], spellID = 1236486, itemID = 244174, skill = 1, source = [[Trainer]], category = [[Rods]], note = [[Common starter rod]] },
  { name = [[Runed Brilliant Silver Rod]], spellID = 1236487, itemID = 244176, skill = 0, source = [[Spec: Transitories, Tonics, and Tools]], category = [[Rods]], note = [[Rare mid-tier]] },
  { name = [[Runed Dazzling Thorium Rod]], spellID = 1236488, itemID = 244177, skill = 0, source = [[Vendor: Lyna (Silvermoon)]], category = [[Rods]], note = [[Epic best stats]] },

  -- ========== Wands ==========
  { name = [[Thalassian Spellweaver's Wand]], spellID = 1236489, itemID = 244178, skill = 40, source = [[Trainer]], category = [[Wands]], note = [[Combat wand · train cost 150]], trainCost = 1500000 },
  { name = [[Magister's Grand Focus]], spellID = 1236490, itemID = 244179, skill = 100, source = [[Spec: Transitories, Tonics, and Tools]], category = [[Wands]], note = [[High-end combat wand · Worthy Wands]] },


  -- ========== Shattering ==========
  { name = [[Dawn Shatter]], spellID = 1280401, itemID = 0, skill = 25, source = [[Trainer]], category = [[Shattering]], note = [[Dawn Crystal → 3 Radiant Shards]] },
  { name = [[Radiant Shatter]], spellID = 1280394, itemID = 0, skill = 50, source = [[Trainer]], category = [[Shattering]], note = [[Radiant Shard → 3 Eversinging Dust]] },
  { name = [[Shatter Essence]], spellID = 1235731, itemID = 0, skill = 0, source = [[Spec: Spellbound Shatterer]], category = [[Shattering]], note = [[Buff: +Resourcefulness, +Ingenuity, +Multicraft]] },

  -- ========== Illusions ==========
  { name = [[Illusory Adornment - Blooming Light]], spellID = 1236098, itemID = 244032, skill = 25, source = [[Trainer]], category = [[Illusions]], note = [[Golden/holy glow]] },
  { name = [[Illusory Adornment - Nature's Embrace]], spellID = 1236099, itemID = 244034, skill = 0, source = [[Vendor: Construct V'anore (Silvermoon)]], category = [[Illusions]], note = [[Green nature effect]] },
  { name = [[Illusory Adornment - Voidtouched]], spellID = 1236100, itemID = 244036, skill = 0, source = [[Drop: Victorious Stormarion Pinnacle Cache]], category = [[Illusions]], note = [[Purple void effect]] },

  -- ========== Gleeful Glamours (Cosmetic Toys) ==========
  { name = [[Gleeful Glamour - Blood Elf]], spellID = 1236461, itemID = 243773, skill = 5, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Dark Iron Dwarf]], spellID = 1236463, itemID = 243774, skill = 45, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Haranir]], spellID = 1236464, itemID = 244056, skill = 0, source = [[Vendor: Naynar (Renown)]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Draenei]], spellID = 1236465, itemID = 243775, skill = 20, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Dwarf]], spellID = 1236466, itemID = 243776, skill = 10, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Gnome]], spellID = 1236467, itemID = 243778, skill = 50, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Goblin]], spellID = 1236468, itemID = 243779, skill = 50, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Highmountain Tauren]], spellID = 1236469, itemID = 243780, skill = 40, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Human]], spellID = 1236470, itemID = 243781, skill = 15, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Kul Tiran]], spellID = 1236471, itemID = 243782, skill = 35, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Lightforged Draenei]], spellID = 1236472, itemID = 243783, skill = 40, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Mag'har Orc]], spellID = 1236473, itemID = 243784, skill = 55, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Mechagnome]], spellID = 1236474, itemID = 243785, skill = 55, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Night Elf]], spellID = 1236475, itemID = 243786, skill = 5, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Nightborne]], spellID = 1236476, itemID = 243787, skill = 25, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Orc]], spellID = 1236477, itemID = 243788, skill = 15, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Pandaren]], spellID = 1236478, itemID = 243789, skill = 45, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Tauren]], spellID = 1236479, itemID = 243790, skill = 20, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Troll]], spellID = 1236480, itemID = 243791, skill = 45, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Undead]], spellID = 1236481, itemID = 243792, skill = 10, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Void Elf]], spellID = 1236482, itemID = 243793, skill = 25, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Vulpera]], spellID = 1236483, itemID = 243794, skill = 30, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Worgen]], spellID = 1236484, itemID = 243795, skill = 30, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Zandalari Troll]], spellID = 1236485, itemID = 243796, skill = 35, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },
  { name = [[Gleeful Glamour - Earthen]], spellID = 1236594, itemID = 243777, skill = 10, source = [[Trainer: Jennara Sunglow]], category = [[Glamours]] },

  -- ========== House Decor ==========
  { name = [[Animated Sin'dorei Hammer]], spellID = 1246906, itemID = 262459, skill = 0, source = [[Vendor: World Vendors (Eversong)]], category = [[House Decor]] },
  { name = [[Animated Sin'dorei Pick]], spellID = 1246902, itemID = 262458, skill = 0, source = [[Vendor: World Vendors (Eversong)]], category = [[House Decor]] },
  { name = [[Endless Codex of Blooming Light]], spellID = 1281342, itemID = 268038, skill = 0, source = [[Vendor: Caeris Fairdawn (Renown)]], category = [[House Decor]] },
  { name = [[Endless Codex of Nature's Grace]], spellID = 1281348, itemID = 268039, skill = 0, source = [[Vendor: Magovu (Renown)]], category = [[House Decor]] },
  { name = [[Endless Codex of the Voidtouched]], spellID = 1281349, itemID = 268041, skill = 0, source = [[Vendor: Void Researcher Anomander (Renown)]], category = [[House Decor]] },
  { name = [[Ensorcelled Broom]], spellID = 1246904, itemID = 262450, skill = 80, source = [[Trainer]], category = [[House Decor]] },
  { name = [[Font of Gleaming Water]], spellID = 1246905, itemID = 262455, skill = 80, source = [[Trainer]], category = [[House Decor]] },
  { name = [[Ren'dorei Postal Repository]], spellID = 1246903, itemID = 262468, skill = 0, source = [[Drop: Voidstorm Treasures]], category = [[House Decor]] },
  { name = [[Rootflame Campfire]], spellID = 1246908, itemID = 262590, skill = 0, source = [[Drop: Heavy Trunk (Delves)]], category = [[House Decor]] },
  { name = [[Self-Pouring Thalassian Sunwine]], spellID = 1246909, itemID = 246693, skill = 0, source = [[Vendor: Neriv (Eversong)]], category = [[House Decor]] },
  { name = [[Spellbound Tome of Thalassian Magics]], spellID = 1246907, itemID = 262470, skill = 0, source = [[Vendor: Caeris Fairdawn (Renown)]], category = [[House Decor]] },
}