-- Midnight Blacksmithing — Knowledge
local _, private = ...
private.Data = private.Data or {}
private.Data.Blacksmithing = private.Data.Blacksmithing or {}
local P = private.Data.Blacksmithing

P.knowledgeOverview = "Blacksmithing Knowledge comes from one-time sources (8 treasures × 3 KP and a renown book for 10 KP) plus weekly sources. Patron Orders are the bulk of weekly KP (~12). Expect about 19 KP/week if you complete everything."

P.knowledgeCatchUp = "If you fall behind, Patron Orders grant Flicker of Midnight Blacksmithing Knowledge until you catch up."

P.oneTime = {

        {

            id = "renown_book",

            name = "Beyond the Event Horizon: Blacksmithing",

            itemID = 262644,

            kp = 10,

            kind = "renown_book",

            note = "Sold by Void Researcher Anomander in Voidstorm for 75 Artisan Blacksmith's Moxie. Requires Renown 9 with The Singularity.",

            vendor = "Void Researcher Anomander",

            zone = "Voidstorm",

        },

    }

P.weekly = {

        {

            name = "Patron Crafting Orders",

            kp = "~12",

            itemID = 246323,

            note = "Main weekly source. Some orders award Glimmer of Midnight Blacksmithing Knowledge.",

        },

        {

            name = "Weekly Quest (Trainer)",

            kp = 1,

            itemID = 263455,

            note = "Complete 3 Crafting Orders for a Thalassian Blacksmith's Journal.",

        },

        {

            name = "Weekly Zone Drops",

            kp = 4,

            itemIDs = { 259190, 259191 },

            note = "Thalassian Whetstone + Infused Quenching Oil from zone treasures.",

        },

        {

            name = "Thalassian Treatise on Blacksmithing",

            kp = 1,

            itemID = 245763,

            note = "BoP from Inscription. Public Crafting Order, or craft on an Inscription alt.",

        },

        {

            name = "Darkmoon Faire",

            kp = 3,

            note = "Monthly profession quest: +3 Knowledge and +2 Skill.",

        },

    }

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

P.treasures = {

        { id = "sindorei_masters_forgemace", name = "Sin'dorei Master's Forgemace",

            itemID = 238546, zone = "Silvermoon City", mapID = 2393, x = 49.2, y = 61.3, questID = 89183, description = "Silvermoon City.", kp = 3 },

        { id = "silvermoon_blacksmiths_hammer", name = "Silvermoon Blacksmith's Hammer",

            itemID = 238547, zone = "Silvermoon City", mapID = 2393, x = 48.5, y = 74.7, questID = 89184, description = "Silvermoon City.", kp = 3 },

        { id = "deconstructed_forge_techniques", name = "Deconstructed Forge Techniques",

            itemID = 238540, zone = "Silvermoon City", mapID = 2393, x = 26.9, y = 60.3, questID = 89177, description = "Silvermoon City.", kp = 3 },

        { id = "metalworking_cheat_sheet", name = "Metalworking Cheat Sheet",

            itemID = 238543, zone = "Eversong Woods", mapID = 2395, x = 56.8, y = 40.8, questID = 89180, description = "Eversong Woods.", kp = 3 },

        { id = "silvermoon_smithing_kit", name = "Silvermoon Smithing Kit",

            itemID = 238541, zone = "Eversong Woods", mapID = 2395, x = 48.3, y = 75.8, questID = 89178, description = "Eversong Woods.", kp = 3 },

        { id = "carefully_racked_spear", name = "Carefully Racked Spear",

            itemID = 238542, zone = "Zul'Aman (Atal'Aman)", mapID = 2536, x = 33.2, y = 65.9, questID = 89179, description = "This treasure is in Atal'Aman and may be phased.", kp = 3 },

        { id = "rutaani_floratenders_sword", name = "Rutaani Floratender's Sword",

            itemID = 238545, zone = "Harandar", mapID = 2413, x = 66.3, y = 50.9, questID = 89182, description = "On top of the mushroom.", kp = 3 },

        { id = "voidstorm_defense_spear", name = "Voidstorm Defense Spear",

            itemID = 238544, zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 30.6, y = 69.0, questID = 89181, description = "Voidstorm, Slaver's Rise.", kp = 3 },

    }

