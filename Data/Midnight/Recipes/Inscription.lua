-- Midnight Inscription recipes
-- Sources: wow-professions.com + wowhead.com (spellIDs from guide links)
-- spellID = craft recipe spell (C_TradeSkillUI.GetRecipeInfo / .learned)
-- itemID left 0 until cross-checked; learned scan uses spellID

local _, private = ...
private.RecipeData = private.RecipeData or {}
private.RecipeCategoryTips = private.RecipeCategoryTips or {}

private.RecipeCategoryTips.Inscription = {
  ["Reagents"]         = [[Inks, pigments, ciphers. Mill herbs -> ink -> higher crafts.]],
  ["Weapons"]          = [[Staves, bows, off-hands. Trainer rare set; epic via Spec: Blueprints.]],
  ["PvP"]              = [[Competitor's set from Mirvedon. Needs Competitor's Heraldry.]],
  ["Darkmoon"]         = [[Craft cards -> 8 into a deck -> Dominion trinket. Spec: Darkmoon Curiosity.]],
  ["Mysteries"]        = [[Inscribe random cards; Transcribe rerolls into a chosen suit. Spec: Darkmoon Curiosity.]],
  ["Sigils"]           = [[Embellishments from a full deck. Max 2 embellished items equipped.]],
  ["Contracts"]        = [[Weekly Warband rep boost from World Quests. Renown 5 vendors.]],
  ["Treatises"]        = [[Weekly KP for every profession. Inscription treatise from Spec: Calm Hands.]],
  ["Missives"]         = [[Optional reagents to lock secondary stats on gear / profession tools.]],
  ["Profession Gear"]  = [[Quills for Scribes + tools for Alchemy / Cooking. Epic from Lelorian (Moxie).]],
  ["Vantus"]           = [[Raid boss Vantus runes.]],
  ["House Decor"]      = [[Housing cosmetics. Vendors, renown, and drops.]],
}

private.RecipeData.Inscription = {
  -- ========== Reagents ==========
  { name = [[Sienna Ink]], spellID = 1230016, itemID = 245805, skill = 10, source = [[Trainer]], category = [[Reagents]] },
  { name = [[Munsell Ink]], spellID = 1230017, itemID = 245802, skill = 15, source = [[Trainer]], category = [[Reagents]] },
  { name = [[Codified Azeroot]], spellID = 1230018, itemID = 245764, skill = 25, source = [[Trainer]], category = [[Reagents]] },
  { name = [[Soul Cipher]], spellID = 1230019, itemID = 245766, skill = 20, source = [[Trainer]], category = [[Reagents]] },

  -- ========== Weapons ==========
  { name = [[Faunatender's Baton]], spellID = 1230055, itemID = 245773, skill = 20, source = [[Trainer]], category = [[Weapons]], note = [[Staff]] },
  { name = [[Floratender's Crutch]], spellID = 1230056, itemID = 245772, skill = 20, source = [[Trainer]], category = [[Weapons]], note = [[Staff]] },
  { name = [[Rootwarden's Lamp]], spellID = 1230057, itemID = 245768, skill = 20, source = [[Trainer]], category = [[Weapons]], note = [[Off-Hand]] },
  { name = [[Faunatender's Trust]], spellID = 1230058, itemID = 265336, skill = 35, source = [[Trainer]], category = [[Weapons]], note = [[Bow]] },
  { name = [[Aln'hara Pikestaff]], spellID = 1230059, itemID = 245771, skill = 0, source = [[Spec: Blueprints]], category = [[Weapons]], note = [[Epic staff]] },
  { name = [[Aln'hara Cane]], spellID = 1230060, itemID = 245770, skill = 0, source = [[Spec: Blueprints]], category = [[Weapons]], note = [[Epic staff]] },
  { name = [[Aln'hara Lantern]], spellID = 1230061, itemID = 245769, skill = 0, source = [[Spec: Blueprints]], category = [[Weapons]], note = [[Epic off-hand]] },
  { name = [[Aln'hara Sprigshot]], spellID = 1230062, itemID = 265337, skill = 0, source = [[Spec: Blueprints]], category = [[Weapons]], note = [[Epic bow]] },

  -- ========== PvP ==========
  { name = [[Thalassian Competitor's Lamp]], spellID = 1230064, itemID = 245870, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]], note = [[Off-Hand]] },
  { name = [[Thalassian Competitor's Staff]], spellID = 1230065, itemID = 268365, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]], note = [[Staff]] },
  { name = [[Thalassian Competitor's Pillar]], spellID = 1230066, itemID = 245868, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]], note = [[Polearm]] },
  { name = [[Thalassian Competitor's Emblem]], spellID = 1230067, itemID = 245753, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]], note = [[Trinket]] },
  { name = [[Thalassian Competitor's Insignia of Alacrity]], spellID = 1230068, itemID = 245752, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]], note = [[Trinket]] },
  { name = [[Thalassian Competitor's Medallion]], spellID = 1230069, itemID = 245751, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]], note = [[Trinket]] },
  { name = [[Thalassian Competitor's Bow]], spellID = 1260760, itemID = 245869, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]], note = [[Bow]] },

  -- ========== Mysteries (Inscribe / Transcribe) ==========
  { name = [[Inscribe: Blood]], spellID = 1230085, itemID = 245856, skill = 0, source = [[Spec: Darkmoon Curiosity]], category = [[Mysteries]], note = [[Random Blood card]] },
  { name = [[Transcribe: Blood]], spellID = 1230084, itemID = 245856, skill = 0, source = [[Spec: Darkmoon Curiosity]], category = [[Mysteries]], note = [[Reroll into Blood card]] },
  { name = [[Inscribe: Rot]], spellID = 1230081, itemID = 245847, skill = 0, source = [[Spec: Darkmoon Curiosity]], category = [[Mysteries]], note = [[Random Rot card]] },
  { name = [[Transcribe: Rot]], spellID = 1230080, itemID = 245847, skill = 0, source = [[Spec: Darkmoon Curiosity]], category = [[Mysteries]], note = [[Reroll into Rot card]] },
  { name = [[Inscribe: Hunt]], spellID = 1230083, itemID = 245830, skill = 0, source = [[Spec: Darkmoon Curiosity]], category = [[Mysteries]], note = [[Random Hunt card]] },
  { name = [[Transcribe: Hunt]], spellID = 1230082, itemID = 245830, skill = 0, source = [[Spec: Darkmoon Curiosity]], category = [[Mysteries]], note = [[Reroll into Hunt card]] },
  { name = [[Inscribe: Void]], spellID = 1230079, itemID = 245838, skill = 0, source = [[Spec: Darkmoon Curiosity]], category = [[Mysteries]], note = [[Random Void card]] },
  { name = [[Transcribe: Void]], spellID = 1230078, itemID = 245838, skill = 0, source = [[Spec: Darkmoon Curiosity]], category = [[Mysteries]], note = [[Reroll into Void card]] },

  -- ========== Darkmoon (Dominion trinkets) ==========
  { name = [[Darkmoon Dominion: Blood]], spellID = 1230070, itemID = 246305, skill = 0, source = [[Spec: Darkmoon Curiosity]], category = [[Darkmoon]], note = [[ilvl 220 trinket]] },
  { name = [[Darkmoon Dominion: Rot]], spellID = 1230071, itemID = 246306, skill = 0, source = [[Spec: Darkmoon Curiosity]], category = [[Darkmoon]], note = [[ilvl 220 trinket]] },
  { name = [[Darkmoon Dominion: Hunt]], spellID = 1230072, itemID = 246304, skill = 0, source = [[Spec: Darkmoon Curiosity]], category = [[Darkmoon]], note = [[ilvl 220 trinket]] },
  { name = [[Darkmoon Dominion: Void]], spellID = 1230073, itemID = 246307, skill = 0, source = [[Spec: Darkmoon Curiosity]], category = [[Darkmoon]], note = [[ilvl 220 trinket]] },

  -- ========== Sigils ==========
  { name = [[Darkmoon Sigil: Blood]], spellID = 1230074, itemID = 245872, skill = 0, source = [[Spec: Darkmoon Curiosity]], category = [[Sigils]] },
  { name = [[Darkmoon Sigil: Rot]], spellID = 1230075, itemID = 245877, skill = 0, source = [[Spec: Darkmoon Curiosity]], category = [[Sigils]] },
  { name = [[Darkmoon Sigil: Hunt]], spellID = 1230076, itemID = 245875, skill = 0, source = [[Spec: Darkmoon Curiosity]], category = [[Sigils]] },
  { name = [[Darkmoon Sigil: Void]], spellID = 1230077, itemID = 245874, skill = 0, source = [[Spec: Darkmoon Curiosity]], category = [[Sigils]] },

  -- ========== Contracts ==========
  { name = [[Contract: The Silvermoon Court]], spellID = 1230051, itemID = 245799, skill = 0, source = [[Vendor: Caeris Fairdawn (Renown 5)]], category = [[Contracts]] },
  { name = [[Contract: The Amani Tribe]], spellID = 1230052, itemID = 245797, skill = 0, source = [[Vendor: Magovu (Renown 5)]], category = [[Contracts]] },
  { name = [[Contract: The Hara'ti]], spellID = 1230053, itemID = 245796, skill = 0, source = [[Vendor: Naynar (Renown 5)]], category = [[Contracts]] },
  { name = [[Contract: The Singularity]], spellID = 1230054, itemID = 245794, skill = 0, source = [[Vendor: Void Researcher Anomander (Renown 5)]], category = [[Contracts]] },

  -- ========== Treatises ==========
  { name = [[Thalassian Treatise on Blacksmithing]], spellID = 1230026, itemID = 245763, skill = 0, source = [[Discovery: Crafting Treatises]], category = [[Treatises]] },
  { name = [[Thalassian Treatise on Mining]], spellID = 1230027, itemID = 245762, skill = 0, source = [[Discovery: Crafting Treatises]], category = [[Treatises]] },
  { name = [[Thalassian Treatise on Herbalism]], spellID = 1230028, itemID = 245761, skill = 0, source = [[Discovery: Crafting Treatises]], category = [[Treatises]] },
  { name = [[Thalassian Treatise on Jewelcrafting]], spellID = 1230029, itemID = 245760, skill = 0, source = [[Discovery: Crafting Treatises]], category = [[Treatises]] },
  { name = [[Thalassian Treatise on Enchanting]], spellID = 1230030, itemID = 245759, skill = 0, source = [[Discovery: Crafting Treatises]], category = [[Treatises]] },
  { name = [[Thalassian Treatise on Leatherworking]], spellID = 1230031, itemID = 245758, skill = 0, source = [[Discovery: Crafting Treatises]], category = [[Treatises]] },
  { name = [[Thalassian Treatise on Inscription]], spellID = 1230032, itemID = 245757, skill = 0, source = [[Spec: Calm Hands]], category = [[Treatises]], note = [[Weekly KP for self]] },
  { name = [[Thalassian Treatise on Tailoring]], spellID = 1230033, itemID = 245756, skill = 0, source = [[Discovery: Crafting Treatises]], category = [[Treatises]] },
  { name = [[Thalassian Treatise on Alchemy]], spellID = 1230034, itemID = 245755, skill = 0, source = [[Discovery: Crafting Treatises]], category = [[Treatises]] },
  { name = [[Thalassian Treatise on Skinning]], spellID = 1230035, itemID = 245828, skill = 0, source = [[Discovery: Crafting Treatises]], category = [[Treatises]] },
  { name = [[Thalassian Treatise on Engineering]], spellID = 1230036, itemID = 245809, skill = 0, source = [[Discovery: Crafting Treatises]], category = [[Treatises]] },

  -- ========== Missives ==========
  { name = [[Thalassian Missive of the Quickblade]], spellID = 1230037, itemID = 245792, skill = 45, source = [[Trainer]], category = [[Missives]], note = [[Haste + Vers]] },
  { name = [[Thalassian Missive of the Peerless]], spellID = 1230038, itemID = 245789, skill = 45, source = [[Trainer]], category = [[Missives]], note = [[Crit + Mastery]] },
  { name = [[Thalassian Missive of the Harmonious]], spellID = 1230039, itemID = 245788, skill = 35, source = [[Trainer]], category = [[Missives]], note = [[Mastery + Vers]] },
  { name = [[Thalassian Missive of the Fireflash]], spellID = 1230040, itemID = 245785, skill = 35, source = [[Trainer]], category = [[Missives]], note = [[Crit + Haste]] },
  { name = [[Thalassian Missive of the Feverflare]], spellID = 1230041, itemID = 245783, skill = 25, source = [[Trainer]], category = [[Missives]], note = [[Haste + Mastery]] },
  { name = [[Thalassian Missive of the Aurora]], spellID = 1230042, itemID = 245781, skill = 25, source = [[Trainer]], category = [[Missives]], note = [[Crit + Vers]] },
  { name = [[Thalassian Missive of Deftness]], spellID = 1230043, itemID = 245827, skill = 0, source = [[Vendor: Lelorian (Silvermoon)]], category = [[Missives]], note = [[Profession]] },
  { name = [[Thalassian Missive of Perception]], spellID = 1230044, itemID = 245824, skill = 0, source = [[Vendor: Lelorian (Silvermoon)]], category = [[Missives]], note = [[Profession]] },
  { name = [[Thalassian Missive of Finesse]], spellID = 1230045, itemID = 245822, skill = 0, source = [[Vendor: Lelorian (Silvermoon)]], category = [[Missives]], note = [[Profession]] },
  { name = [[Thalassian Missive of Crafting Speed]], spellID = 1230046, itemID = 245821, skill = 0, source = [[Vendor: Lelorian (Silvermoon)]], category = [[Missives]], note = [[Profession]] },
  { name = [[Thalassian Missive of Multicraft]], spellID = 1230047, itemID = 245819, skill = 0, source = [[Vendor: Lelorian (Silvermoon)]], category = [[Missives]], note = [[Profession]] },
  { name = [[Thalassian Missive of Resourcefulness]], spellID = 1230048, itemID = 245816, skill = 0, source = [[Vendor: Lelorian (Silvermoon)]], category = [[Missives]], note = [[Profession]] },
  { name = [[Thalassian Missive of Ingenuity]], spellID = 1230049, itemID = 245814, skill = 0, source = [[Vendor: Lelorian (Silvermoon)]], category = [[Missives]], note = [[Profession]] },

  -- ========== Vantus ==========
  { name = [[Vantus Rune: Radiant]], spellID = 1230050, itemID = 245879, skill = 50, source = [[Trainer]], category = [[Vantus]] },

  -- ========== Profession Gear ==========
  { name = [[Hobbyist Rolling Pin]], spellID = 1230020, itemID = 245779, skill = 0, source = [[Trainer]], category = [[Profession Gear]], note = [[Green · Cooking]] },
  { name = [[Hobbyist Alchemist's Mixing Rod]], spellID = 1230021, itemID = 245777, skill = 0, source = [[Trainer]], category = [[Profession Gear]], note = [[Green · Alchemy]] },
  { name = [[Hobbyist Scribe's Quill]], spellID = 1230022, itemID = 245775, skill = 0, source = [[Trainer]], category = [[Profession Gear]], note = [[Green · Inscription]] },
  { name = [[Sin'dorei Rolling Pin]], spellID = 1230023, itemID = 245780, skill = 0, source = [[Spec: Blueprints]], category = [[Profession Gear]], note = [[Blue · Cooking]] },
  { name = [[Sin'dorei Alchemist's Mixing Rod]], spellID = 1230024, itemID = 245778, skill = 0, source = [[Spec: Blueprints]], category = [[Profession Gear]], note = [[Blue · Alchemy]] },
  { name = [[Sin'dorei Quill]], spellID = 1230025, itemID = 245776, skill = 0, source = [[Spec: Blueprints]], category = [[Profession Gear]], note = [[Blue · Inscription]] },
  { name = [[Gilded Alchemist's Mixing Rod]], spellID = 1264550, itemID = 259205, skill = 0, source = [[Vendor: Lelorian (150 Moxie)]], category = [[Profession Gear]], note = [[Epic · Alchemy]] },
  { name = [[Gilded Sin'dorei Rolling Pin]], spellID = 1264551, itemID = 259207, skill = 0, source = [[Vendor: Lelorian (150 Moxie)]], category = [[Profession Gear]], note = [[Epic · Cooking]] },
  { name = [[Gilded Sin'dorei Quill]], spellID = 1264552, itemID = 259209, skill = 0, source = [[Vendor: Lelorian (150 Moxie)]], category = [[Profession Gear]], note = [[Epic · Inscription]] },

  -- ========== House Decor ==========
  { name = [[Sturdy Ren'dorei Cask]], spellID = 1248619, itemID = 262612, skill = 0, source = [[Vendor: Construct V'anore (Silvermoon)]], category = [[House Decor]] },
  { name = [[Restful Bronze Bench]], spellID = 1248620, itemID = 262790, skill = 0, source = [[Drop: Victorious Stormarion Pinnacle Cache]], category = [[House Decor]] },
  { name = [[Floating Void-Touched Tome]], spellID = 1248621, itemID = 262464, skill = 0, source = [[Vendor: Void Researcher Anomander (Renown 5)]], category = [[House Decor]] },
  { name = [[Homely Sin'dorei Shelf]], spellID = 1248622, itemID = 262594, skill = 0, source = [[Vendor: Lelorian (Silvermoon)]], category = [[House Decor]] },
  { name = [[Lively Songwriter's Quill]], spellID = 1248623, itemID = 262616, skill = 0, source = [[Vendor: Lelorian (Silvermoon)]], category = [[House Decor]] },
  { name = [[Opened Sin'dorei Scroll]], spellID = 1248624, itemID = 262598, skill = 0, source = [[Vendor: Lelorian (Silvermoon)]], category = [[House Decor]] },
  { name = [[Gilded Eversong Book]], spellID = 1248625, itemID = 262597, skill = 0, source = [[Vendor: Lelorian (Silvermoon)]], category = [[House Decor]] },
  { name = [[Sin'dorei Phoenix Quill]], spellID = 1248626, itemID = 262615, skill = 0, source = [[Vendor: Ranger Allorn (Eversong)]], category = [[House Decor]] },
  { name = [[Homely Wall Shelves]], spellID = 1248627, itemID = 262595, skill = 0, source = [[Fishing]], category = [[House Decor]] },
  { name = [[Wild Hanging Scroll]], spellID = 1248628, itemID = 262601, skill = 0, source = [[Vendor: Construct V'anore (Silvermoon)]], category = [[House Decor]] },
  { name = [[Harandar Signpost]], spellID = 1248630, itemID = 253508, skill = 0, source = [[Vendor: Naynar (Renown 5)]], category = [[House Decor]] },
  { name = [[Magnificent Towering Bookcase]], spellID = 1248631, itemID = 263034, skill = 0, source = [[Vendor: Naynar (Renown 5)]], category = [[House Decor]] },
}