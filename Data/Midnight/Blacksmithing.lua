-- Artisan's Codex - Midnight Blacksmithing Data
-- Source: wow-professions.com (accurate as of patch 12.1)

local _, private = ...

private.Data = private.Data or {}

private.Data.Blacksmithing = {
    name = "Blacksmithing",
    icon = "Interface\\Icons\\Trade_BlackSmithing",
    overview = "Midnight Blacksmithing is a straightforward First Craft + Sterling Alloy grind to 70, then Rare Profession Equipment, Epic Profession Equipment, or Crafting Orders to finish. Pairs best with Mining, since ore costs add up fast if you're buying everything from the AH.",

    trainer = {
        name = "Bemarrin",
        zone = "Silvermoon City",
        mapID = 2393,
        x = 48.5,          -- approximate, refine if needed (west side of the Bazaar, south of the bridge to Isle of Quel'danas)
        y = 61.9,
        note = "Blacksmithing supply vendor (Luminant Flux, Blacksmith Hammer, Artisan Blacksmith's Moxie recipes) is near the trainer.",
    },

    -- =========================================================
    -- LEVELING GUIDE
    -- =========================================================
    leveling = {
        {
            range = "1-15",
            recipe = "Refulgent Copper Ingot",
            quantity = 25,
            materials = {
                { name = "Refulgent Copper Ore", amount = 125, itemID = 237359 },
            },
            note = "Smelt 25x Refulgent Copper Ingot. Buy Luminant Flux and a Blacksmith Hammer from the supply vendor near the trainer if you don't have tools yet.",
            difficulty = "orange",
        },
        {
            range = "15-50",
            recipe = "First Craft Sweep (28 trainer recipes)",
            quantity = 28,
            materials = {
                { name = "Refulgent Copper Ingot", amount = 100, itemID = 238197 }, -- or ~500 extra Refulgent Copper Ore if smelting yourself
                { name = "Brilliant Silver Ore", amount = 6, itemID = 237364 },
                { name = "Umbral Tin Ore", amount = 6, itemID = 237362 },
                { name = "Duskshrouded Stone", amount = 1, itemID = 242788 },
            },
            note = "Filter your Profession window by 'First Craft Bonus' and craft everything that lights up, learning new recipes from the trainer as you go, until nothing is left. You'll land around 47-50 skill depending on craft order. Equip the Thalassian Blacksmith's Toolbox and Thalassian Blacksmith's Hammer you craft along the way.",
            difficulty = "orange",
            isSpecial = true,
        },
        {
            range = "25",
            recipe = "Unlock Specializations",
            quantity = 0,
            materials = {},
            note = "At skill 25 you unlock your first Blacksmithing specialization tree. It matters more later for the 70-100 stretch than right now, so check the Specialization guide/build before committing points.",
            difficulty = "orange",
            isSpecial = true,
        },
        {
            range = "50-70",
            recipe = "Sterling Alloy",
            quantity = 50,
            materials = {
                { name = "Luminant Flux", amount = 200, itemID = 243060 },
                { name = "Brilliant Silver Ore", amount = 300, itemID = 237364 },
                { name = "Refulgent Copper Ingot", amount = 150, itemID = 238197 },
            },
            note = "Clear your First Craft Bonus filter (little red X) so all recipes show again, then craft Sterling Alloy repeatedly. It turns green for the last ~10 points so you may need a few extra crafts -- Sterling Alloy is used in a lot of other recipes, so keep or sell the extras.",
            difficulty = "yellow",
        },

        -- =========================================================
        -- FORK
        -- =========================================================
        {
            type = "fork",
            range = "70-100",
            paths = {
                {
                    key = "rare",
                    label = "Rare Profession Equipment",
                    description = "No time-gate, mass craftable",
                    intro = "Unlock a Craftsmithing recipe and spam craft it. No time-gated materials needed.",
                },
                {
                    key = "epic",
                    label = "Epic Profession Equipment",
                    description = "3 skill/craft, time-gated",
                    intro = "Best skill-per-craft, but needs Fused Vitality which is time-gated (BoP).",
                },
                {
                    key = "orders",
                    label = "Crafting Orders (Epic Weapons/Armor)",
                    description = "3 skill/craft, needs Armorsmithing/Weaponsmithing",
                    intro = "Complete Crafting Orders for epic gear from the Armorsmithing/Weaponsmithing trees, or vendor/world-drop recipes.",
                },
            },
        },

        -- Rare Profession Equipment path
        {
            range = "70-100",
            path = "rare",
            recipe = "Sun-Blessed Profession Tools (Craftsmithing)",
            quantity = 8,
            materials = {
                { name = "Sterling Alloy", amount = 40, itemID = 238204 }, -- 5x per recipe, 8 recipes
                { name = "Majestic Claw", amount = 6, itemID = 238528 },
                { name = "Majestic Fin", amount = 1, itemID = 238530 },
                { name = "Majestic Hide", amount = 1, itemID = 238529 },
                { name = "Dazzling Thorium", amount = 16, itemID = 237366 }, -- 2x per recipe, 8 recipes
            },
            note = "8 different Sun-Blessed tools/toolkits, each unlocked via a different Craftsmithing node (costs range from 5 to 20 points). Pick whichever you can unlock first and mass craft just that one -- 1 skill point per craft, yellow at 90, green at 95. Blue-quality results are now BoE and sellable.",
            difficulty = "yellow",
            isRecommended = true,
        },

        -- Epic Profession Equipment path
        {
            range = "70-100",
            path = "epic",
            recipe = "Epic Profession Equipment",
            quantity = 1,
            materials = {
                { name = "Fused Vitality", amount = 20, itemID = 245345 },
            },
            note = "Recipes cost 150 Artisan Blacksmith's Moxie from the vendor near the trainer. Orange all the way to 100, 3 skill points per craft -- most efficient per-craft option, but each craft needs 20x Fused Vitality, which is BoP and time-gated. Every craft still counts, so pick these up whenever you have the mats.",
            difficulty = "orange",
        },

        -- Crafting Orders path
        {
            range = "70-100",
            path = "orders",
            recipe = "Crafting Orders (Epic Weapons/Armor)",
            quantity = 10,
            materials = {},
            note = "Recipes come from the Armorsmithing/Weaponsmithing specializations, or from vendors and world drops. All give 3 skill points and are orange to 100, so 10 completions finishes the profession. Patron Orders are personal NPC requests (not guaranteed to match what you can craft); Public Orders are realm-only and get claimed fast -- remember to hit 'Search' on the Public Orders tab, they don't load automatically.",
            difficulty = "orange",
        },
    },

    -- =========================================================
    -- KNOWLEDGE TREASURES
    -- =========================================================
    knowledgeOverview = "Blacksmithing Knowledge comes from one-time sources (8 treasures × 3 KP and a renown book for 10 KP) plus weekly sources. Patron Orders are the bulk of weekly KP (~12). Expect about 19 KP/week if you complete everything.",

    knowledgeCatchUp = "If you fall behind, Patron Orders grant Flicker of Midnight Blacksmithing Knowledge until you catch up.",

    oneTime = {
        {
            id = "renown_book",
            name = "Beyond the Event Horizon: Blacksmithing",
            kp = 10,
            kind = "renown_book",
            note = "Sold by Void Researcher Anomander in Voidstorm for 75 Artisan Blacksmith's Moxie. Requires Renown 9 with The Singularity.",
            vendor = "Void Researcher Anomander",
            zone = "Voidstorm",
        },
    },

    knowledgeTips = {
        "You only need Skill 1 in the Midnight profession tier to loot knowledge treasures.",
        "Treasures are character-specific — each alt can collect their own set.",
        "If you are on the coords but see nothing: check inside buildings/caves, fly up/down for vertical position, or finish campaign phasing (Atal'Aman).",
        "Trainer weekly quest unlocks after the Crafters Needed questline from Captain Flaresworn.",
    },

    knowledgeUnlock = {
        questID = 93723,
        questName = "Crafters Needed",
        npcName = "Captain Flaresworn",
        note = "Required to unlock the trainer weekly Knowledge quest.",
    },

    treasures = {
        { id = "sindorei_masters_forgemace", name = "Sin'dorei Master's Forgemace", zone = "Silvermoon City", mapID = 2393, x = 49.2, y = 61.3, questID = 89183, description = "Silvermoon City.", kp = 3 },
        { id = "silvermoon_blacksmiths_hammer", name = "Silvermoon Blacksmith's Hammer", zone = "Silvermoon City", mapID = 2393, x = 48.5, y = 74.7, questID = 89184, description = "Silvermoon City.", kp = 3 },
        { id = "deconstructed_forge_techniques", name = "Deconstructed Forge Techniques", zone = "Silvermoon City", mapID = 2393, x = 26.9, y = 60.3, questID = 89177, description = "Silvermoon City.", kp = 3 },
        { id = "metalworking_cheat_sheet", name = "Metalworking Cheat Sheet", zone = "Eversong Woods", mapID = 2395, x = 56.8, y = 40.8, questID = 89180, description = "Eversong Woods.", kp = 3 },
        { id = "silvermoon_smithing_kit", name = "Silvermoon Smithing Kit", zone = "Eversong Woods", mapID = 2395, x = 48.3, y = 75.8, questID = 89178, description = "Eversong Woods.", kp = 3 },
        { id = "carefully_racked_spear", name = "Carefully Racked Spear", zone = "Zul'Aman (Atal'Aman)", mapID = 2536, x = 33.2, y = 65.9, questID = 89179, description = "This treasure is in Atal'Aman and may be phased.", kp = 3 },
        { id = "rutaani_floratenders_sword", name = "Rutaani Floratender's Sword", zone = "Harandar", mapID = 2413, x = 66.3, y = 50.9, questID = 89182, description = "On top of the mushroom.", kp = 3 },
        { id = "voidstorm_defense_spear", name = "Voidstorm Defense Spear", zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 30.6, y = 69.0, questID = 89181, description = "Voidstorm, Slaver's Rise.", kp = 3 },
    },

}