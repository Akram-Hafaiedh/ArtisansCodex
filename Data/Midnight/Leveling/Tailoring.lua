-- Midnight Tailoring — Leveling (+ meta)
local _, private = ...
private.Data = private.Data or {}
private.Data.Tailoring = private.Data.Tailoring or {}
local P = private.Data.Tailoring

P.name = "Tailoring"


P.overview = "Midnight Tailoring is one of the simpler professions to level. Most of the early skill comes from trainer recipes and Bright Linen Bolts. At skill 25 you unlock specializations. Best paired with a gathering profession or buying cheap cloth from the AH."

P.trainer = {

        name = "Galana",

        zone = "Silvermoon City",

        mapID = 2393,

        x = 48.2,

        y = 54.0,

        note = "Tailoring supply vendor is nearby (Silverleaf Thread, Embroidery Floss, etc.).",

    }

P.leveling = {

        {

            range = "1-25",

            recipe = "Bright Linen Bolt",
            spellID = 1228939,

            itemID = 239700,

            quantity = 66,

            reagents = {

                { name = "Bright Linen", amount = 66, itemID = 236965 },

            },

            note = "Craft all 66 even after they go grey around skill 20. You need them later for armor and Imbued Bolts. Silverleaf Thread and Embroidery Floss are sold by the vendor near the trainer.",

            difficulty = "orange",

        },

        {

            range = "25-40",

            recipe = "Imbued Bright Linen Bolt",
            spellID = 1228940,

            itemID = 239702,

            quantity = 14,

            reagents = {

                { name = "Bright Linen Bolt", amount = 28, itemID = 239700 },

            },

            note = "You unlock your first specialization at skill 25.",

            difficulty = "orange",

        },

        {

            range = "40-45",

            recipe = "First Crafts (Courtly set + Robe)",

            quantity = 1,

            reagents = {},

            note = "Craft every remaining First Craft recipe for Knowledge Points. Equip the Bright Linen Tailoring Robe when finished.",

            difficulty = "yellow",

            isSpecial = true,

            crafts = {

                {

                    name = "Courtly Helm",

                    spellID = 1228951,
                    itemID = 239668,

                    quantity = 1,

                    reagents = {

                        { name = "Bright Linen Bolt", amount = 3, itemID = 239700 },

                        { name = "Silverleaf Thread", amount = 4, itemID = 251665 },

                        { name = "Embroidery Floss", amount = 3, itemID = 251691 },

                    },

                },

                {

                    name = "Courtly Shoulders",

                    spellID = 1228959,
                    itemID = 239675,

                    quantity = 1,

                    reagents = {

                        { name = "Bright Linen Bolt", amount = 2, itemID = 239700 },

                        { name = "Silverleaf Thread", amount = 3, itemID = 251665 },

                        { name = "Embroidery Floss", amount = 1, itemID = 251691 },

                    },

                },

                {

                    name = "Courtly Cloak",

                    spellID = 1228958,
                    itemID = 239674,

                    quantity = 1,

                    reagents = {

                        { name = "Bright Linen Bolt", amount = 2, itemID = 239700 },

                        { name = "Silverleaf Thread", amount = 3, itemID = 251665 },

                    },

                },

                {

                    name = "Courtly Robes",

                    spellID = 1228955,
                    itemID = 239672,

                    quantity = 1,

                    reagents = {

                        { name = "Bright Linen Bolt", amount = 2, itemID = 239700 },

                        { name = "Silverleaf Thread", amount = 3, itemID = 251665 },

                    },

                },

                {

                    name = "Courtly Gloves",

                    spellID = 1228952,
                    itemID = 239669,

                    quantity = 1,

                    reagents = {

                        { name = "Bright Linen Bolt", amount = 2, itemID = 239700 },

                        { name = "Silverleaf Thread", amount = 3, itemID = 251665 },

                    },

                },

                {

                    name = "Courtly Pants",

                    spellID = 1228956,
                    itemID = 239676,

                    quantity = 1,

                    reagents = {

                        { name = "Bright Linen Bolt", amount = 3, itemID = 239700 },

                        { name = "Silverleaf Thread", amount = 4, itemID = 251665 },

                        { name = "Embroidery Floss", amount = 2, itemID = 251691 },

                    },

                },

                {

                    name = "Courtly Belt",

                    spellID = 1228953,
                    itemID = 239670,

                    quantity = 1,

                    reagents = {

                        { name = "Bright Linen Bolt", amount = 2, itemID = 239700 },

                        { name = "Silverleaf Thread", amount = 3, itemID = 251665 },

                    },

                },

                {

                    name = "Courtly Slippers",

                    spellID = 1228957,
                    itemID = 239673,

                    quantity = 1,

                    reagents = {

                        { name = "Bright Linen Bolt", amount = 2, itemID = 239700 },

                        { name = "Silverleaf Thread", amount = 3, itemID = 251665 },

                    },

                },

                {

                    name = "Courtly Wrists",

                    spellID = 1228954,
                    itemID = 239671,

                    quantity = 1,

                    reagents = {

                        { name = "Bright Linen Bolt", amount = 1, itemID = 239700 },

                        { name = "Silverleaf Thread", amount = 2, itemID = 251665 },

                    },

                },

                {

                    name = "Bright Linen Tailoring Robe",

                    spellID = 1228973,
                    itemID = 239646,

                    quantity = 1,

                    reagents = {

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
            spellID = 1228959,

            itemID = 239675,

            quantity = 6,

            reagents = {

                { name = "Bright Linen Bolt", amount = 12, itemID = 239700 },

            },

            note = "Make a few more if you didn't reach 50.",

            difficulty = "yellow",

        },

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

            reagents = {},

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
            spellID = 1228976,

            itemID = 240157,

            quantity = 30,

            reagents = {

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

                    reagents = {

                        { name = "Sunfire Silk",      amount = 168, itemID = 237016 },

                        { name = "Sunfire Silk Bolt", amount = 56,  itemID = 239201 },

                    },

                },

                {

                    key = "arcanoweave",

                    label = "Arcanoweave Lining",

                    itemID = 240166,

                    reagents = {

                        { name = "Arcanoweave",      amount = 168, itemID = 237017 },

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

            reagents = {

                { name = "Mote of Light",     amount = 67,  itemID = 236949 },

                { name = "Sunfire Silk Bolt", amount = 107, itemID = 239201 },

                { name = "Radiant Shard",     amount = 40,  itemID = 243602 },

            },

            note = "Craft any combination of these. Each recipe costs 150 Artisan Tailor's Moxie from the vendor near the trainer.",

            difficulty = "green",

            crafts = {

                {

                    name = "Elegant Artisan's Cooking Hat",

                    spellID = 1228963,
                    itemID = 239636,

                    quantity = 1,

                    reagents = {

                        { name = "Mote of Light", amount = 5, itemID = 236949 },

                        { name = "Sunfire Silk Bolt", amount = 8, itemID = 239201 },

                        { name = "Radiant Shard", amount = 3, itemID = 243602 },

                    },

                },

                {

                    name = "Elegant Artisan's Enchanting Hat",

                    spellID = 1228964,
                    itemID = 239637,

                    quantity = 1,

                    reagents = {

                        { name = "Mote of Light", amount = 5, itemID = 236949 },

                        { name = "Sunfire Silk Bolt", amount = 8, itemID = 239201 },

                        { name = "Radiant Shard", amount = 3, itemID = 243602 },

                    },

                },

                {

                    name = "Elegant Artisan's Fishing Hat",

                    spellID = 1228965,
                    itemID = 239638,

                    quantity = 1,

                    reagents = {

                        { name = "Mote of Light", amount = 5, itemID = 236949 },

                        { name = "Sunfire Silk Bolt", amount = 8, itemID = 239201 },

                        { name = "Radiant Shard", amount = 3, itemID = 243602 },

                    },

                },

                {

                    name = "Elegant Artisan's Herbalism Hat",

                    spellID = 1228966,
                    itemID = 239639,

                    quantity = 1,

                    reagents = {

                        { name = "Mote of Light", amount = 5, itemID = 236949 },

                        { name = "Sunfire Silk Bolt", amount = 8, itemID = 239201 },

                        { name = "Radiant Shard", amount = 3, itemID = 243602 },

                    },

                },

                {

                    name = "Elegant Artisan's Alchemy Coveralls",

                    spellID = 1228962,
                    itemID = 239635,

                    quantity = 1,

                    reagents = {

                        { name = "Mote of Light", amount = 5, itemID = 236949 },

                        { name = "Sunfire Silk Bolt", amount = 8, itemID = 239201 },

                        { name = "Radiant Shard", amount = 3, itemID = 243602 },

                    },

                },

                {

                    name = "Elegant Artisan's Tailoring Robe",

                    spellID = 1228967,
                    itemID = 239640,

                    quantity = 1,

                    reagents = {

                        { name = "Mote of Light", amount = 5, itemID = 236949 },

                        { name = "Sunfire Silk Bolt", amount = 8, itemID = 239201 },

                        { name = "Radiant Shard", amount = 3, itemID = 243602 },

                    },

                },

            },

        },

    }

P.specializations = {

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

    }

