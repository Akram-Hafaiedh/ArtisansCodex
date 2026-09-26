-- Artisan's Codex - Midnight Tailoring Data
-- Source: wow-professions.com (accurate as of patch 12.1)

local _, private = ...

private.Data = private.Data or {}

private.Data.Tailoring = {
    name = "Tailoring",
    icon = "Interface\\Icons\\Trade_Tailoring",
    overview = "Midnight Tailoring is one of the simpler professions to level. Most of the early skill comes from trainer recipes and Bright Linen Bolts. At skill 25 you unlock specializations. Best paired with a gathering profession or buying cheap cloth from the AH.",

    trainer = {
        name = "Galana",
        zone = "Silvermoon City",
        mapID = 2393,
        x = 48.2,
        y = 54.0,
        note = "Tailoring supply vendor is nearby (Silverleaf Thread, Embroidery Floss, etc.).",
    },

    -- =========================================================
    -- LEVELING GUIDE
    -- =========================================================
    leveling = {
        {
            range = "1-25",
            recipe = "Bright Linen Bolt",
            itemID = 239700,
            quantity = 66,
            materials = {
                { name = "Bright Linen", amount = 66, itemID = 236963 },
            },
            note = "Craft all 66 even after they go grey around skill 20. You need them later for armor and Imbued Bolts. Silverleaf Thread and Embroidery Floss are sold by the vendor near the trainer.",
            difficulty = "orange",
        },
        {
            range = "25-40",
            recipe = "Imbued Bright Linen Bolt",
            itemID = 239702,
            quantity = 14,
            materials = {
                { name = "Bright Linen Bolt", amount = 28, itemID = 239700 },
            },
            note = "You unlock your first specialization at skill 25.",
            difficulty = "orange",
        },
        {
            range = "40-45",
            recipe = "First Crafts (Courtly set + Robe)",
            quantity = 1,
            materials = {},
            note = "Craft every remaining First Craft recipe for Knowledge Points. Equip the Bright Linen Tailoring Robe when finished.",
            difficulty = "yellow",
            isSpecial = true,
            crafts = {
                {
                    name = "Courtly Helm",
                    itemID = 239670,
                    quantity = 1,
                    materials = {
                        { name = "Bright Linen Bolt", amount = 3, itemID = 239700 },
                        { name = "Silverleaf Thread", amount = 4, itemID = 251665 },
                        { name = "Embroidery Floss", amount = 3, itemID = 251691 },
                    },
                },
                {
                    name = "Courtly Shoulders",
                    itemID = 239675,
                    quantity = 1,
                    materials = {
                        { name = "Bright Linen Bolt", amount = 2, itemID = 239700 },
                        { name = "Silverleaf Thread", amount = 3, itemID = 251665 },
                        { name = "Embroidery Floss", amount = 1, itemID = 251691 },
                    },
                },
                {
                    name = "Courtly Cloak",
                    itemID = 239678,
                    quantity = 1,
                    materials = {
                        { name = "Bright Linen Bolt", amount = 2, itemID = 239700 },
                        { name = "Silverleaf Thread", amount = 3, itemID = 251665 },
                    },
                },
                {
                    name = "Courtly Robes",
                    itemID = 239680,
                    quantity = 1,
                    materials = {
                        { name = "Bright Linen Bolt", amount = 2, itemID = 239700 },
                        { name = "Silverleaf Thread", amount = 3, itemID = 251665 },
                    },
                },
                {
                    name = "Courtly Gloves",
                    itemID = 239682,
                    quantity = 1,
                    materials = {
                        { name = "Bright Linen Bolt", amount = 2, itemID = 239700 },
                        { name = "Silverleaf Thread", amount = 3, itemID = 251665 },
                    },
                },
                {
                    name = "Courtly Pants",
                    itemID = 239684,
                    quantity = 1,
                    materials = {
                        { name = "Bright Linen Bolt", amount = 3, itemID = 239700 },
                        { name = "Silverleaf Thread", amount = 4, itemID = 251665 },
                        { name = "Embroidery Floss", amount = 2, itemID = 251691 },
                    },
                },
                {
                    name = "Courtly Belt",
                    itemID = 239686,
                    quantity = 1,
                    materials = {
                        { name = "Bright Linen Bolt", amount = 2, itemID = 239700 },
                        { name = "Silverleaf Thread", amount = 3, itemID = 251665 },
                    },
                },
                {
                    name = "Courtly Slippers",
                    itemID = 239673,
                    quantity = 1,
                    materials = {
                        { name = "Bright Linen Bolt", amount = 2, itemID = 239700 },
                        { name = "Silverleaf Thread", amount = 3, itemID = 251665 },
                    },
                },
                {
                    name = "Courtly Wrists",
                    itemID = 239690,
                    quantity = 1,
                    materials = {
                        { name = "Bright Linen Bolt", amount = 1, itemID = 239700 },
                        { name = "Silverleaf Thread", amount = 2, itemID = 251665 },
                    },
                },
                {
                    name = "Bright Linen Tailoring Robe",
                    itemID = 239646,
                    quantity = 1,
                    materials = {
                        { name = "Imbued Bright Linen Bolt", amount = 2, itemID = 239702 },
                        { name = "Silverleaf Thread", amount = 3, itemID = 251665 },
                        { name = "Eversinging Dust", amount = 2, itemID = 243599 },
                    },
                },
            },
        },
        {
            range = "44-50",
            recipe = "Courtly Shoulders",
            itemID = 239675,
            quantity = 6,
            materials = {
                { name = "Bright Linen Bolt", amount = 12, itemID = 239700 },
            },
            note = "Make a few more if you didn't reach 50.",
            difficulty = "yellow",
        },
         -- =========================================================
        -- FORK — the guide splits from here.
        -- Steps above are shared; steps below declare a `path` field.
        -- =========================================================
        {
            type = "fork",
            range = "50-100",
            paths = {
                {
                    key = "slow",
                    label = "Daily CD Method",
                    description = "Slow & Profitable",
                    intro = "Best if you want to level quietly while also making gold. " ..
                            "Buy the Nimble Needlework specialization (5 KP), unlock a " ..
                            "bolt cooldown, and just craft one bolt per day. Slower overall, " ..
                            "but every craft is profitable and you'll hit 100 without " ..
                            "spending gold on the AH.",
                },
                {
                    key = "rush",
                    label = "Rushing to 100",
                    description = "Fast & Expensive",
                    intro = "Fastest route to 100 if gold isn't a concern. Buy the " ..
                            "Lining recipes off the AH and grind them out. You'll lose " ..
                            "money on raw materials but save hours of daily CD waiting.",
                },
            },
        },
        {
            range = "50-100",
            path = "slow",
            recipes = {
                { name = "Sunfire Silk Bolt (Daily CD)", itemID = 239201 },
                { name = "Arcanoweave Bolt (Daily CD)",  itemID = 239198 },
            },
            quantity = 1,
            materials = {},
            note = "Spend 5 Knowledge Points in the Nimble Needlework root node, " ..
                   "then pick one of the two sub-specs. This unlocks a daily bolt CD.\n\n" ..
                   "Each daily craft gives 2 skill points up to skill 80. Expect to " ..
                   "hit 80 in about two weeks with consistent daily crafting.\n\n" ..
                   "Bolt options and their materials:\n" ..
                   "• Sunfire Silk Bolt — 4x Mote of Light, 5x Sunfire Silk, 6x Imbued Bright Linen Bolt\n" ..
                   "• Arcanoweave Bolt — 4x Mote of Wild Magic, 5x Arcanoweave, 6x Imbued Bright Linen Bolt\n\n" ..
                   "|cffFFD700Alternatives for 90-100:|r Once you're in the 90s you'll " ..
                   "probably have epic recipes from vendors or your spec that still give " ..
                   "skill. Patron Crafting Orders also work here — they're random, but " ..
                   "frequent enough that only a few are needed to finish the range.",
            difficulty = "green",
            isRecommended = true,
            specAction = "open_tree",
            specTarget = "Nimble Needlework",
            specTargetIcon = "Interface\\Icons\\Inv_12_profession_tailoring_tailoringspecializations_fiberarts",
            hint = "The specialization tree is a passive bonus tree for your profession. " ..
                   "You spend Knowledge Points (KP) there to unlock bonuses like bolt cooldowns.",
        },
        {
            range = "50-65",
            path = "rush",
            header = "Warm up with Spellthreads",
            recipe = "Bright Linen Spellthread",
            itemID = 240157,
            quantity = 30,
            materials = {
                { name = "Imbued Bright Linen Bolt", amount = 60, itemID = 239702 },
                { name = "Eversinging Dust", amount = 60, itemID = 243599 },
            },
            note = "This will be green for the last few points. Alternative: unlock a Bolt CD early.",
            difficulty = "green",
        },
        {
            range = "65-90",
            path = "rush",
            header = "The expensive grind",
            quantity = 28,
            difficulty = "yellow",
            alternatives = {
                {
                    key = "sunfire",
                    label = "Sunfire Silk Lining",
                    itemID = 240164,
                    materials = {
                        { name = "Sunfire Silk",      amount = 168, itemID = 237015 },
                        { name = "Sunfire Silk Bolt", amount = 56,  itemID = 239201 },
                    },
                },
                {
                    key = "arcanoweave",
                    label = "Arcanoweave Lining",
                    itemID = 240166,
                    materials = {
                        { name = "Arcanoweave",      amount = 168, itemID = 237016 },
                        { name = "Arcanoweave Bolt", amount = 56,  itemID = 239198 },
                    },
                },
            },
            note = "Recipes are drops — buy from AH. Turns yellow at 80. " ..
                   "Pick whichever lining is cheaper on your server.",
        },
        {
            range = "90-100",
            path = "rush",
            header = "Finishing touches",
            recipe = "Elegant Artisan Profession Gear",
            quantity = 13,
            materials = {
                { name = "Mote of Light",     amount = 67,  itemID = 236949 },
                { name = "Sunfire Silk Bolt", amount = 107, itemID = 239201 },
                { name = "Radiant Shard",     amount = 40,  itemID = 243603 },
            },
            note = "Craft any combination of these. Each recipe costs 150 Artisan Tailor's Moxie from the vendor near the trainer.",
            difficulty = "green",
            crafts = {
                {
                    name = "Elegant Artisan's Cooking Hat",
                    itemID = 239636,
                    quantity = 1,
                    materials = {
                        { name = "Mote of Light", amount = 5, itemID = 236949 },
                        { name = "Sunfire Silk Bolt", amount = 8, itemID = 239201 },
                        { name = "Radiant Shard", amount = 3, itemID = 243603 },
                    },
                },
                {
                    name = "Elegant Artisan's Enchanting Hat",
                    -- spellID = 1228964,
                    itemID = 239637,
                    quantity = 1,
                    materials = {
                        { name = "Mote of Light", amount = 5, itemID = 236949 },
                        { name = "Sunfire Silk Bolt", amount = 8, itemID = 239201 },
                        { name = "Radiant Shard", amount = 3, itemID = 243603 },
                    },
                },
                {
                    name = "Elegant Artisan's Fishing Hat",
                    -- spellID = 1228965,
                    itemID = 239638,
                    quantity = 1,
                    materials = {
                        { name = "Mote of Light", amount = 5, itemID = 236949 },
                        { name = "Sunfire Silk Bolt", amount = 8, itemID = 239201 },
                        { name = "Radiant Shard", amount = 3, itemID = 243603 },
                    },
                },
                {
                    name = "Elegant Artisan's Herbalism Hat",
                    itemID = 239640,
                    quantity = 1,
                    materials = {
                        { name = "Mote of Light", amount = 5, itemID = 236949 },
                        { name = "Sunfire Silk Bolt", amount = 8, itemID = 239201 },
                        { name = "Radiant Shard", amount = 3, itemID = 243603 },
                    },
                },
                {
                    name = "Elegant Artisan's Alchemy Coveralls",
                    itemID = 239641,
                    quantity = 1,
                    materials = {
                        { name = "Mote of Light", amount = 5, itemID = 236949 },
                        { name = "Sunfire Silk Bolt", amount = 8, itemID = 239201 },
                        { name = "Radiant Shard", amount = 3, itemID = 243603 },
                    },
                },
                {
                    name = "Elegant Artisan's Tailoring Robe",
                    itemID = 239642,
                    quantity = 1,
                    materials = {
                        { name = "Mote of Light", amount = 5, itemID = 236949 },
                        { name = "Sunfire Silk Bolt", amount = 8, itemID = 239201 },
                        { name = "Radiant Shard", amount = 3, itemID = 243603 },
                    },
                },
            },
        },
    },

    -- =========================================================
    -- KNOWLEDGE TREASURES
    -- =========================================================
    -- =========================================================
    -- KNOWLEDGE (one-time + weekly + overview copy)
    -- =========================================================
    knowledgeOverview = "Tailoring Knowledge comes from one-time sources (treasures and a renown book) and weekly sources (mostly Patron Orders). Treasures are 8×3 KP. The renown book is 10 KP. Weekly you can earn around 19 KP if you complete everything, though Patron Orders vary.",

    knowledgeCatchUp = "If you fall behind or start late, Patron Orders can reward Flicker of Midnight Tailoring Knowledge until you catch up. Missing a week is not permanent.",

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
        -- Pin when coords known; optional
        -- mapID = nil, x = nil, y = nil,
    },

    knowledgeChanges = {
        "Artisan Tailor's Moxie — profession-specific currency (replaces shared Artisan's Acuity for Tailoring spends).",
        "No bronze-quality reagents — reagents/consumables are Silver or Gold only. Concentration can push to Gold immediately.",
        "Epic profession gear — same Skill as Rare, higher secondary stats.",
        "No more unraveling — cloth no longer needs to be turned into spools before crafting.",
    },

    oneTime = {
        {
            id = "renown_book",
            name = "Skill Issue: Tailoring",
            kp = 10,
            kind = "renown_book",
            itemID = 257601,
            note = "Sold by Caeris Fairdawn in Eversong Woods for 75 Artisan Tailor's Moxie. Requires Renown 6 with Silvermoon Court.",
            vendor = "Caeris Fairdawn",
            zone = "Eversong Woods",
            -- pin optional when we have coords; leave nil for now
        },
    },

    treasures = {
        {
            id = "really_nice_curtain",
            name = "A Really Nice Curtain",
            itemID = 238613,
            zone = "Silvermoon City",
            mapID = 2393,
            x = 35.9,
            y = 61.3,
            questID = 89079,
            description = "One of two Silvermoon City treasures. Easy early pickup while visiting the trainers.",
            kp = 3,
        },
        {
            id = "enchanting_tablecloth",
            name = "Particularly Enchanting Tablecloth",
            itemID = 238618,
            zone = "Silvermoon City",
            mapID = 2393,
            x = 31.8,
            y = 68.2,
            questID = 89084,
            description = "Second Silvermoon City treasure. Grab both while you are in the city.",
            kp = 3,
        },
        {
            id = "sindorei_ruler",
            name = "Sin'dorei Outfitter's Ruler",
            itemID = 238614,
            zone = "Eversong Woods",
            mapID = 2395,
            x = 46.3,
            y = 34.8,
            questID = 89080,
            description = "Out in Eversong Woods. Good to pin while traveling between hubs.",
            kp = 3,
        },
        {
            id = "artisans_cover_comb",
            name = "Artisan's Cover Comb",
            itemID = 238619,
            zone = "Zul'Aman",
            mapID = 2437,
            x = 40.5,
            y = 49.4,
            questID = 89085,
            description = "Inside the cave in Zul'Aman.",
            kp = 3,
        },
        {
            id = "wooden_weaving_sword",
            name = "Wooden Weaving Sword",
            itemID = 238615,
            zone = "Harandar",
            mapID = 2413,
            x = 69.8,
            y = 51.0,
            questID = 89081,
            description = "Harandar treasure. Pair with A Child's Stuffy nearby.",
            kp = 3,
        },
        {
            id = "childs_stuffy",
            name = "A Child's Stuffy",
            itemID = 238612,
            zone = "Harandar",
            mapID = 2413,
            x = 70.5,
            y = 50.9,
            questID = 89078,
            description = "Harandar, very close to Wooden Weaving Sword.",
            kp = 3,
        },
        {
            id = "book_sindorei_stitches",
            name = "Book of Sin'dorei Stitches",
            itemID = 238616,
            zone = "Voidstorm (Slayer's Rise)",
            mapID = 2444,
            x = 62.0,
            y = 83.6,
            questID = 89082,
            description = "Voidstorm, Slayer's Rise. Pair with Satin Throw Pillow.",
            kp = 3,
        },
        {
            id = "satin_throw_pillow",
            name = "Satin Throw Pillow",
            itemID = 238617,
            zone = "Voidstorm (Slayer's Rise)",
            mapID = 2444,
            x = 61.6,
            y = 85.0,
            questID = 89083,
            description = "Voidstorm, Slayer's Rise. Near Book of Sin'dorei Stitches.",
            kp = 3,
        },
    },

    weekly = {
        {
            name = "Patron Crafting Orders",
            kp = "~12",
            itemID = 246335,
            note = "Main weekly source. Some orders award Glimmer of Midnight Tailoring Knowledge. Not every order gives KP — recipe and quality matter.",
        },
        {
            name = "Weekly Quest (Trainer)",
            kp = 2,
            itemID = 263460,
            unlockQuestID = 93723,
            note = "Complete 3 Crafting Orders for a Thalassian Tailor's Notebook (2 KP). Locked until Crafters Needed is finished.",
        },
        {
            name = "Weekly Zone Drops",
            kp = 4,
            itemIDs = { 259202, 259203 },
            note = "Loot 1× Embroidered Memento and 1× Finely Woven Lynx Collar from zone treasures each week (2 KP each).",
        },
        {
            name = "Thalassian Treatise on Tailoring",
            kp = 1,
            itemID = 245756,
            note = "BoP from Inscription. Public Crafting Order, or craft on an Inscription alt (Warbound).",
        },
        {
            name = "Darkmoon Faire",
            kp = 3,
            note = "Monthly profession quest: +3 Knowledge and +2 Skill. Starts the Sunday before the first Monday of the month.",
        },
    },

    -- =========================================================
    -- SPECIALIZATION BUILDS
    -- =========================================================
    specializations = {
        {
            name = "Standard / All-rounder",
            goal = "Balanced start",
            description = "Good starting point for most players. Unlocks both bolt CDs early and some armor.",
            steps = {
                "20 points into Nimble Needlework root (unlocks both bolt CDs)",
                "Then start putting points into Sin'dorei Finery for armor recipes",
                "Later invest in Fiber Arts for Multicraft / Resourcefulness",
            },
        },
        {
            name = "Bolt Cooldowns + Embellishments",
            goal = "Daily gold + embellished gear",
            description = "Focus on the daily Arcanoweave / Sunfire Silk Bolts and embellished pieces.",
            steps = {
                "20 points into Nimble Needlework root",
                "Pick Arcanoweave or Sunfire path and go deep",
                "Add Fiber Arts for Multicraft",
            },
        },
        {
            name = "Cloth Armor (Sin'dorei Finery)",
            goal = "Personal gear / Crafting Orders",
            description = "Best if you want to craft your own epic cloth armor or fill orders.",
            steps = {
                "Unlock Sin'dorei Finery as soon as possible",
                "Prioritize the slots you need most",
                "Support with Fiber Arts for skill and stats",
            },
        },
        {
            name = "Cloth Farming",
            goal = "Maximum cloth drops",
            description = "Best for players who farm a lot of mobs.",
            steps = {
                "Max Fabric Specialist (choose Eastern Kingdoms or Otherworldly branch)",
                "Nimble Needlework to enable rare cloth drops",
                "Fiber Arts for extra value",
            },
        },
    },
}