-- Midnight Engineering recipes
-- Sources: wow-professions.com + wowhead.com (spellIDs from guide links)
-- spellID = craft recipe spell (C_TradeSkillUI.GetRecipeInfo / .learned)
-- itemID left 0 until cross-checked; learned scan uses spellID
-- Many mid-tier / decor recipes are learned via Recycling discovery

local _, private = ...
private.RecipeData = private.RecipeData or {}
private.RecipeCategoryTips = private.RecipeCategoryTips or {}

private.RecipeCategoryTips.Engineering = {
  ["Reagents"]        = [[Song Gear, Soul Sprocket. Recycling turns any Midnight reagent into Evercore / Aetherlume.]],
  ["Cogwheels"]       = [[Optional reagents for secondary stats on Engineering crafts.]],
  ["Combat Gear"]     = [[Goggles / bracers / boots for all armor types + guns. Epic via Spec: Combat Analytics.]],
  ["PvP"]             = [[Competitor's set from Mirvedon. Needs Competitor's Heraldry.]],
  ["Gadgets"]         = [[Scopes, ammo, bots, wormhole. Many discovered via Recycling.]],
  ["Embellishments"]  = [[Outdoor slot (1) + combat embellishments (max 2 equipped).]],
  ["Profession Gear"] = [[Tools for Eng / JC / Fishing / Mining / Tailoring. Epic from Lyrendal (Moxie).]],
  ["House Decor"]     = [[Tech-themed housing. Most discovered via Recycling.]],
}

private.RecipeData.Engineering = {
  -- ========== Reagents / Parts ==========
  { name = [[Song Gear]], spellID = 1229755, itemID = 243574, skill = 0, source = [[Trainer]], category = [[Reagents]], note = [[Basic part · recycles to Evercore]] },
  { name = [[Recycling]], spellID = 1229930, itemID = 253849, skill = 1, source = [[Trainer]], category = [[Reagents]], note = [[Salvage reagents → Evercore / Aetherlume; discovers recipes]] },

  -- ========== Cogwheels ==========
  { name = [[Perfected Cogwheel]], spellID = 1229856, itemID = 244701, skill = 1, source = [[Trainer]], category = [[Cogwheels]], note = [[+Mastery]] },
  { name = [[Flux Cogwheel]], spellID = 1229859, itemID = 244697, skill = 5, source = [[Trainer]], category = [[Cogwheels]], note = [[+Haste]] },
  { name = [[Greased Cogwheel]], spellID = 1229857, itemID = 244699, skill = 20, source = [[Trainer]], category = [[Cogwheels]], note = [[+Crit]] },
  { name = [[Consistent Cogwheel]], spellID = 1229858, itemID = 244703, skill = 25, source = [[Trainer]], category = [[Cogwheels]], note = [[+Vers]] },

  -- ========== Combat Gear — Cloth ==========
  { name = [[Evercore Zoomshroud]], spellID = 1229862, itemID = 244751, skill = 20, source = [[Trainer]], category = [[Combat Gear]], note = [[Cloth head]] },
  { name = [[Evercore Wrist Latch]], spellID = 1229866, itemID = 245341, skill = 35, source = [[Trainer]], category = [[Combat Gear]], note = [[Cloth wrist]] },
  { name = [[Evercore Swiftfeet]], spellID = 1229935, itemID = 245337, skill = 35, source = [[Trainer]], category = [[Combat Gear]], note = [[Cloth feet]] },
  { name = [[Aetherlume Eye Wrap]], spellID = 1229870, itemID = 244743, skill = 0, source = [[Spec: Combat Analytics]], category = [[Combat Gear]], note = [[Epic cloth head]] },
  { name = [[Aetherlume Silken Cuffs]], spellID = 1229874, itemID = 244747, skill = 0, source = [[Spec: Combat Analytics]], category = [[Combat Gear]], note = [[Epic cloth wrist]] },
  { name = [[Aetherlume Softsteppers]], spellID = 1229878, itemID = 244771, skill = 0, source = [[Spec: Combat Analytics]], category = [[Combat Gear]], note = [[Epic cloth feet]] },
  { name = [[Quel'dorei Cloth Goggles]], spellID = 1229882, itemID = 244759, skill = 0, source = [[Recycling]], category = [[Combat Gear]], note = [[Warbound cloth head]] },
  { name = [[Quel'dorei Silken Cuffs]], spellID = 1229886, itemID = 244755, skill = 0, source = [[Recycling]], category = [[Combat Gear]], note = [[Warbound cloth wrist]] },
  { name = [[Quel'dorei Softsteppers]], spellID = 1229890, itemID = 244767, skill = 0, source = [[Recycling]], category = [[Combat Gear]], note = [[Warbound cloth feet]] },

  -- ========== Combat Gear — Leather ==========
  { name = [[Evercore Shade]], spellID = 1229863, itemID = 244752, skill = 1, source = [[Trainer]], category = [[Combat Gear]], note = [[Leather head]] },
  { name = [[Evercore Binding]], spellID = 1229867, itemID = 245342, skill = 35, source = [[Trainer]], category = [[Combat Gear]], note = [[Leather wrist]] },
  { name = [[Evercore Stitchwraps]], spellID = 1229936, itemID = 245338, skill = 35, source = [[Trainer]], category = [[Combat Gear]], note = [[Leather feet]] },
  { name = [[Aetherlume Optics]], spellID = 1229871, itemID = 244744, skill = 0, source = [[Spec: Combat Analytics]], category = [[Combat Gear]], note = [[Epic leather head]] },
  { name = [[Aetherlume Bands]], spellID = 1229875, itemID = 244748, skill = 0, source = [[Spec: Combat Analytics]], category = [[Combat Gear]], note = [[Epic leather wrist]] },
  { name = [[Aetherlume Runners]], spellID = 1229879, itemID = 244772, skill = 0, source = [[Spec: Combat Analytics]], category = [[Combat Gear]], note = [[Epic leather feet]] },
  { name = [[Quel'dorei Leather Optics]], spellID = 1229883, itemID = 244760, skill = 0, source = [[Recycling]], category = [[Combat Gear]], note = [[Warbound leather head]] },
  { name = [[Quel'dorei Bands]], spellID = 1229887, itemID = 244756, skill = 0, source = [[Recycling]], category = [[Combat Gear]], note = [[Warbound leather wrist]] },
  { name = [[Quel'dorei Runners]], spellID = 1229891, itemID = 244768, skill = 0, source = [[Recycling]], category = [[Combat Gear]], note = [[Warbound leather feet]] },

  -- ========== Combat Gear — Mail ==========
  { name = [[Evercore Reconnaissance]], spellID = 1229864, itemID = 244753, skill = 20, source = [[Trainer]], category = [[Combat Gear]], note = [[Mail head]] },
  { name = [[Evercore Chainguards]], spellID = 1229868, itemID = 245343, skill = 35, source = [[Trainer]], category = [[Combat Gear]], note = [[Mail wrist]] },
  { name = [[Evercore Turbochains]], spellID = 1229937, itemID = 245339, skill = 35, source = [[Trainer]], category = [[Combat Gear]], note = [[Mail feet]] },
  { name = [[Aetherlume Vision Shroud]], spellID = 1229872, itemID = 244745, skill = 0, source = [[Spec: Combat Analytics]], category = [[Combat Gear]], note = [[Epic mail head]] },
  { name = [[Aetherlume Bracelets]], spellID = 1229876, itemID = 244749, skill = 0, source = [[Spec: Combat Analytics]], category = [[Combat Gear]], note = [[Epic mail wrist]] },
  { name = [[Aetherlume Clonkers]], spellID = 1229880, itemID = 244773, skill = 0, source = [[Spec: Combat Analytics]], category = [[Combat Gear]], note = [[Epic mail feet]] },
  { name = [[Quel'dorei Mail Shroud]], spellID = 1229884, itemID = 244761, skill = 0, source = [[Recycling]], category = [[Combat Gear]], note = [[Warbound mail head]] },
  { name = [[Quel'dorei Bracelets]], spellID = 1229888, itemID = 244757, skill = 0, source = [[Recycling]], category = [[Combat Gear]], note = [[Warbound mail wrist]] },
  { name = [[Quel'dorei Clonkers]], spellID = 1229892, itemID = 244769, skill = 0, source = [[Recycling]], category = [[Combat Gear]], note = [[Warbound mail feet]] },

  -- ========== Combat Gear — Plate ==========
  { name = [[Evercore Vision Guard]], spellID = 1229865, itemID = 244754, skill = 15, source = [[Trainer]], category = [[Combat Gear]], note = [[Plate head]] },
  { name = [[Evercore Gear Weight]], spellID = 1229869, itemID = 245344, skill = 35, source = [[Trainer]], category = [[Combat Gear]], note = [[Plate wrist]] },
  { name = [[Evercore Greaseplates]], spellID = 1229938, itemID = 245340, skill = 35, source = [[Trainer]], category = [[Combat Gear]], note = [[Plate feet]] },
  { name = [[Aetherlume Sun Guard]], spellID = 1229873, itemID = 244746, skill = 0, source = [[Spec: Combat Analytics]], category = [[Combat Gear]], note = [[Epic plate head]] },
  { name = [[Aetherlume Guards]], spellID = 1229877, itemID = 244750, skill = 0, source = [[Spec: Combat Analytics]], category = [[Combat Gear]], note = [[Epic plate wrist]] },
  { name = [[Aetherlume Stompers]], spellID = 1229881, itemID = 244774, skill = 0, source = [[Spec: Combat Analytics]], category = [[Combat Gear]], note = [[Epic plate feet]] },
  { name = [[Quel'dorei Visor]], spellID = 1229885, itemID = 244762, skill = 0, source = [[Recycling]], category = [[Combat Gear]], note = [[Warbound plate head]] },
  { name = [[Quel'dorei Guards]], spellID = 1229889, itemID = 244758, skill = 0, source = [[Recycling]], category = [[Combat Gear]], note = [[Warbound plate wrist]] },
  { name = [[Quel'dorei Stompers]], spellID = 1229893, itemID = 244770, skill = 0, source = [[Recycling]], category = [[Combat Gear]], note = [[Warbound plate feet]] },

  -- ========== Guns ==========
  { name = [[Evercore Dome Dinger]], spellID = 1282455, itemID = 268475, skill = 20, source = [[Trainer]], category = [[Combat Gear]], note = [[Rare gun]] },
  { name = [[P.O.W. x3]], spellID = 1282456, itemID = 268477, skill = 0, source = [[Spec: Combat Analytics]], category = [[Combat Gear]], note = [[Epic gun]] },

  -- ========== PvP ==========
  { name = [[Thalassian Competitor's Cloth Goggles]], spellID = 1229908, itemID = 244735, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]] },
  { name = [[Thalassian Competitor's Leather Optics]], spellID = 1229909, itemID = 244736, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]] },
  { name = [[Thalassian Competitor's Mail Visor]], spellID = 1229910, itemID = 244737, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]] },
  { name = [[Thalassian Competitor's Plate Guard]], spellID = 1229911, itemID = 244738, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]] },
  { name = [[Thalassian Competitor's Cloth Cuffs]], spellID = 1229912, itemID = 244739, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]] },
  { name = [[Thalassian Competitor's Leather Bands]], spellID = 1229913, itemID = 244740, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]] },
  { name = [[Thalassian Competitor's Mail Links]], spellID = 1229914, itemID = 244741, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]] },
  { name = [[Thalassian Competitor's Plate Bindings]], spellID = 1229915, itemID = 244742, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]] },
  { name = [[Thalassian Competitor's Cloth Tip-Toes]], spellID = 1261490, itemID = 244763, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]] },
  { name = [[Thalassian Competitor's Leather Sliders]], spellID = 1261491, itemID = 244764, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]] },
  { name = [[Thalassian Competitor's Mail Footlinks]], spellID = 1261492, itemID = 244765, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]] },
  { name = [[Thalassian Competitor's Plate Dunkers]], spellID = 1261493, itemID = 244766, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]] },
  { name = [[Thalassian Competitor's Rifle]], spellID = 1282457, itemID = 268479, skill = 0, source = [[Vendor: Mirvedon (Silvermoon)]], category = [[PvP]] },

  -- ========== Gadgets ==========
  { name = [[Farstrider's Hawkeye]], spellID = 1261866, itemID = 257745, skill = 0, source = [[Recycling]], category = [[Gadgets]], note = [[Scope · +Crit]] },
  { name = [[Smuggler's Lynxeye]], spellID = 1261893, itemID = 257747, skill = 0, source = [[Recycling]], category = [[Gadgets]], note = [[Scope · +Mastery]] },
  { name = [[Laced Zoomshots]], spellID = 1261895, itemID = 257749, skill = 0, source = [[Recycling]], category = [[Gadgets]], note = [[Ammo · poison bleed]] },
  { name = [[Weighted Boomshots]], spellID = 1261913, itemID = 257751, skill = 0, source = [[Recycling]], category = [[Gadgets]], note = [[Ammo · fire explosions]] },
  { name = [[Emergency Soul Link]], spellID = 1229923, itemID = 248486, skill = 0, source = [[Recycling]], category = [[Gadgets]], note = [[Combat rez (usable by non-engineers)]] },
  { name = [[M3DDY]], spellID = 1229924, itemID = 248137, skill = 0, source = [[Spec: Bits and Bots]], category = [[Gadgets]], note = [[Raid combat rez on death]] },
  { name = [[W-47CH D0G]], spellID = 1229926, itemID = 248409, skill = 0, source = [[Recycling]], category = [[Gadgets]], note = [[Pauses Flask / Phial / Well Fed timers]] },
  { name = [[Curious Red Button]], spellID = 1229927, itemID = 248138, skill = 0, source = [[Recycling]], category = [[Gadgets]], note = [[Press enough times → death]] },
  { name = [[Wormhole Generator: Quel'Thalas]], spellID = 1229928, itemID = 248485, skill = 0, source = [[Recycling]], category = [[Gadgets]], note = [[Teleport to random Midnight location]] },
  { name = [[Lucky Keychain]], spellID = 1229916, itemID = 248130, skill = 0, source = [[Recycling]], category = [[Gadgets]], note = [[+1 Sparkle]] },

  -- ========== Embellishments ==========
  { name = [[M3DDY, Travel-Sized]], spellID = 1229917, itemID = 248136, skill = 0, source = [[Spec: Bits and Bots]], category = [[Embellishments]], note = [[Outdoor · combat rez on death]] },
  { name = [[Kinetic Ankle Primers]], spellID = 1229919, itemID = 248132, skill = 0, source = [[Recycling]], category = [[Embellishments]], note = [[Outdoor · feet only · launch upward]] },
  { name = [[HU5H, Nonchalant Pup]], spellID = 1229921, itemID = 255843, skill = 0, source = [[Spec: Bits and Bots]], category = [[Embellishments]], note = [[Outdoor · invis 4–18 sec]] },
  { name = [[B1P, Scorcher of Souls]], spellID = 1229922, itemID = 248135, skill = 0, source = [[Recycling]], category = [[Embellishments]], note = [[Combat · fire cone 6 sec]] },
  { name = [[B0P, Curator of Booms]], spellID = 1261945, itemID = 257735, skill = 0, source = [[Recycling]], category = [[Embellishments]], note = [[Combat · chance for Big Booms]] },

  -- ========== Profession Gear ==========
  { name = [[Junker's Multitool]], spellID = 1229896, itemID = 244717, skill = 0, source = [[Trainer]], category = [[Profession Gear]], note = [[Green · Engineering tool]] },
  { name = [[Junker's Junk Visor]], spellID = 1229901, itemID = 244709, skill = 0, source = [[Trainer]], category = [[Profession Gear]], note = [[Green · Engineering accessory]] },
  { name = [[Farstrider Hobbyist Rod]], spellID = 1229895, itemID = 244711, skill = 0, source = [[Trainer]], category = [[Profession Gear]], note = [[Green · Fishing]] },
  { name = [[Farstrider Clampers]], spellID = 1229898, itemID = 244713, skill = 0, source = [[Trainer]], category = [[Profession Gear]], note = [[Green · Jewelcrafting]] },
  { name = [[Farstrider Rock Satchel]], spellID = 1229899, itemID = 244719, skill = 0, source = [[Trainer]], category = [[Profession Gear]], note = [[Green · Mining accessory]] },
  { name = [[Farstrider Fabric Cutters]], spellID = 1229900, itemID = 244707, skill = 0, source = [[Trainer]], category = [[Profession Gear]], note = [[Green · Tailoring]] },
  { name = [[Farstrider Hardhat]], spellID = 1229904, itemID = 244715, skill = 0, source = [[Trainer]], category = [[Profession Gear]], note = [[Green · Mining tool]] },
  { name = [[Sin'dorei Headlamp]], spellID = 1229894, itemID = 244710, skill = 0, source = [[Spec: Market Mobility]], category = [[Profession Gear]], note = [[Blue · Engineering accessory]] },
  { name = [[Sin'dorei Gilded Hardhat]], spellID = 1229897, itemID = 244716, skill = 0, source = [[Spec: Market Mobility]], category = [[Profession Gear]], note = [[Blue · Mining]] },
  { name = [[Sin'dorei Angler's Rod]], spellID = 1229902, itemID = 244712, skill = 0, source = [[Spec: Market Mobility]], category = [[Profession Gear]], note = [[Blue · Fishing]] },
  { name = [[Turbo-Junker's Multitool]], spellID = 1229903, itemID = 244718, skill = 0, source = [[Spec: Market Mobility]], category = [[Profession Gear]], note = [[Blue · Engineering tool]] },
  { name = [[Sin'dorei Clampers]], spellID = 1229905, itemID = 244714, skill = 0, source = [[Spec: Market Mobility]], category = [[Profession Gear]], note = [[Blue · Jewelcrafting]] },
  { name = [[Junker's Big Ol' Bag]], spellID = 1229906, itemID = 244720, skill = 0, source = [[Spec: Market Mobility]], category = [[Profession Gear]], note = [[Blue · Mining accessory]] },
  { name = [[Sin'dorei Snippers]], spellID = 1229907, itemID = 244708, skill = 0, source = [[Spec: Market Mobility]], category = [[Profession Gear]], note = [[Blue · Tailoring]] },
  { name = [[Head-Mounted Beam Bummer]], spellID = 1264523, itemID = 259171, skill = 0, source = [[Vendor: Lyrendal (150 Moxie)]], category = [[Profession Gear]], note = [[Epic · Engineering accessory]] },
  { name = [[Rock Bonkin' Hardhat]], spellID = 1264524, itemID = 259173, skill = 0, source = [[Vendor: Lyrendal (150 Moxie)]], category = [[Profession Gear]], note = [[Epic · Mining]] },
  { name = [[Heavy-Duty Rock Assister]], spellID = 1264525, itemID = 259175, skill = 0, source = [[Vendor: Lyrendal (150 Moxie)]], category = [[Profession Gear]], note = [[Epic · Mining accessory]] },
  { name = [[Self-Sharpening Sin'dorei Snippers]], spellID = 1264526, itemID = 259177, skill = 0, source = [[Vendor: Lyrendal (150 Moxie)]], category = [[Profession Gear]], note = [[Epic · Tailoring]] },
  { name = [[Sin'dorei Reeler's Rod]], spellID = 1264527, itemID = 259179, skill = 0, source = [[Vendor: Lyrendal (150 Moxie)]], category = [[Profession Gear]], note = [[Epic · Fishing]] },
  { name = [[Giga-Gem Grippers]], spellID = 1264528, itemID = 259181, skill = 0, source = [[Vendor: Lyrendal (150 Moxie)]], category = [[Profession Gear]], note = [[Epic · Jewelcrafting]] },
  { name = [[Turbo-Junker's Multitool v9]], spellID = 1264529, itemID = 259183, skill = 0, source = [[Vendor: Lyrendal (150 Moxie)]], category = [[Profession Gear]], note = [[Epic · Engineering tool]] },

  -- ========== House Decor ==========
  { name = [[Ren'dorei Void Projector]], spellID = 1248610, itemID = 262618, skill = 0, source = [[Recycling]], category = [[House Decor]] },
  { name = [[Ren'dorei Lightpost]], spellID = 1248611, itemID = 263049, skill = 0, source = [[Recycling]], category = [[House Decor]] },
  { name = [[Ambient Aethercharged Crystal]], spellID = 1248612, itemID = 246460, skill = 0, source = [[Recycling]], category = [[House Decor]] },
  { name = [[Ren'dorei Stargazer]], spellID = 1248613, itemID = 262465, skill = 0, source = [[Recycling]], category = [[House Decor]] },
  { name = [[Small Telogrus Lamp]], spellID = 1248614, itemID = 262789, skill = 0, source = [[Recycling]], category = [[House Decor]] },
  { name = [[Ren'dorei Crafting Framework]], spellID = 1248615, itemID = 262617, skill = 0, source = [[Recycling]], category = [[House Decor]] },
  { name = [[Ren'dorei Warp Orb]], spellID = 1248616, itemID = 262602, skill = 0, source = [[Recycling]], category = [[House Decor]] },

  -- ========== Parts ==========
  { name = [[Soul Sprocket]], spellID = 1229853, itemID = 243576, skill = 0, source = [[Trainer]], category = [[Reagents]], note = [[Advanced part]] },

  -- ========== Bots / Bits (from live scan) ==========
  { name = [[G-00]], spellID = 1297647, itemID = 275683, skill = 0, source = [[Imported]], category = [[Gadgets]], note = [[Bot]] },
  { name = [[R0CKY]], spellID = 1297585, itemID = 0, skill = 0, source = [[Imported]], category = [[Gadgets]], note = [[Bot]] },
  { name = [[R0CKY-To-Go]], spellID = 1305148, itemID = 275676, skill = 0, source = [[Imported]], category = [[Gadgets]], note = [[Bot]] },
  { name = [[Coiled Snake-Eye]], spellID = 1291687, itemID = 273062, skill = 0, source = [[Imported]], category = [[Gadgets]] },

  -- ========== House Decor (extra from live) ==========
  { name = [[Aetherlume Field Lamp]], spellID = 1296503, itemID = 279341, skill = 0, source = [[Imported]], category = [[House Decor]] },
  { name = [[Coiled Amani Hookshot]], spellID = 1296501, itemID = 279337, skill = 0, source = [[Imported]], category = [[House Decor]] },
  { name = [[Proudmoore Ship-in-a-Bottle]], spellID = 1296502, itemID = 279339, skill = 0, source = [[Imported]], category = [[House Decor]] },
}