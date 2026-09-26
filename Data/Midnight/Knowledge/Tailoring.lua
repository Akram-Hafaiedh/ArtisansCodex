-- Midnight Tailoring — Knowledge
local _, private = ...
private.Data = private.Data or {}
private.Data.Tailoring = private.Data.Tailoring or {}
local P = private.Data.Tailoring

P.knowledgeOverview = "Tailoring Knowledge comes from one-time sources (treasures and a renown book) and weekly sources (mostly Patron Orders). Treasures are 8×3 KP. The renown book is 10 KP. Weekly you can earn around 19 KP if you complete everything, though Patron Orders vary."

P.knowledgeCatchUp = "If you fall behind or start late, Patron Orders can reward Flicker of Midnight Tailoring Knowledge until you catch up. Missing a week is not permanent."

P.knowledgeTips = {

        "You only need Skill 1 in the Midnight profession tier to loot knowledge treasures.",

        "Treasures are character-specific — each alt can collect their own set.",

        "If you are on the coords but see nothing: check inside buildings/caves, fly up/down for vertical position, or finish campaign phasing (Atal'Aman).",

        "Trainer weekly quest unlocks after the Crafters Needed questline from Captain Flaresworn.",

    }

P.knowledgeUnlock = {

        questID = 93723,

        questName = "Crafters Needed",

        npcName = "Captain Flaresworn",

        note = "Required to unlock the trainer weekly Knowledge quest.",

    }

P.knowledgeChanges = {

        "Artisan Tailor's Moxie — profession-specific currency (replaces shared Artisan's Acuity for Tailoring spends).",

        "No bronze-quality reagents — reagents/consumables are Silver or Gold only. Concentration can push to Gold immediately.",

        "Epic profession gear — same Skill as Rare, higher secondary stats.",

        "No more unraveling — cloth no longer needs to be turned into spools before crafting.",

    }

P.oneTime = {

        {

            id = "renown_book",

            name = "Skill Issue: Tailoring",

            itemID = 257601,

            kp = 10,

            kind = "renown_book",

            note = "Sold by Caeris Fairdawn in Eversong Woods for 75 Artisan Tailor's Moxie. Requires Renown 6 with Silvermoon Court.",

            vendor = "Caeris Fairdawn",

            zone = "Eversong Woods",

        },

    }

P.treasures = {

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

    }

P.weekly = {

        {

            name = "Patron Crafting Orders",

            kp = "~12",

            itemID = 246335,

            note = "Main weekly source. Some orders award Glimmer of Midnight Tailoring Knowledge. Not every order gives KP.",

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

            note = "Embroidered Memento + Finely Woven Lynx Collar from zone treasures (2 KP each).",

        },

        {

            name = "Thalassian Treatise on Tailoring",

            kp = 1,

            itemID = 245756,

            note = "BoP from Inscription. Public Crafting Order, or craft on an Inscription alt.",

        },

        {

            name = "Darkmoon Faire",

            kp = 3,

            note = "Monthly profession quest: +3 Knowledge and +2 Skill.",

        },

    }

