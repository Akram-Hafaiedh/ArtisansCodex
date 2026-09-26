-- Midnight Enchanting — Knowledge
local _, private = ...
private.Data = private.Data or {}
private.Data.Enchanting = private.Data.Enchanting or {}
local P = private.Data.Enchanting

P.knowledgeOverview = "Enchanting Knowledge comes from one-time treasures (usually 8×3 KP) and weekly sources such as Patron Orders, a trainer quest, zone drops, an Inscription treatise, and the monthly Darkmoon Faire. Check each row below for details."

P.knowledgeCatchUp = "If you start late or miss weeks, Patron Orders can grant catch-up knowledge until you are back on pace."

P.oneTime = {

        {

            id = "renown_book",

            name = "Skill Issue: Enchanting",

            itemID = 257600,

            kp = 10,

            kind = "renown_book",

            note = "Sold by Caeris Fairdawn in Eversong Woods for 75 Artisan Enchanter's Moxie. Requires Renown 6 with Silvermoon Court.",

            vendor = "Caeris Fairdawn",

            zone = "Eversong Woods",

        },

    }

P.weekly = {

        {

            name = "Patron Crafting Orders",

            kp = "~12",

            itemID = 246325,

            note = "Main weekly source. Some orders award Glimmer of Midnight Enchanting Knowledge.",

        },

        {

            name = "Weekly Quest (Trainer)",

            kp = 3,

            itemID = 263464,

            note = "Trainer weekly quest rewards a Thalassian Enchanter's Folio (3 KP).",

        },

        {

            name = "Weekly Zone Drops",

            kp = 2,

            itemID = 259193,

            note = "Lost Thalassian Vellum from zone treasures (+2 KP).",

        },

        {

            name = "Thalassian Treatise on Enchanting",

            kp = 1,

            itemID = 245759,

            note = "BoP from Inscription. Public Crafting Order, or craft on an Inscription alt.",

        },

        {

            name = "Darkmoon Faire",

            kp = 3,

            note = "Monthly profession quest: +3 Knowledge and +2 Skill.",

        },

    }

P.treasures = {

        { id = "sindorei_enchanting_rod", name = "Sin'dorei Enchanting Rod",

            itemID = 238555, zone = "Eversong Woods", mapID = 2395, x = 63.5, y = 32.6, questID = 89107, description = "Eversong Woods.", kp = 3 },

        { id = "everblazing_sunmote", name = "Everblazing Sunmote",

            itemID = 238551, zone = "Eversong Woods", mapID = 2395, x = 60.8, y = 53.0, questID = 89103, description = "Eversong Woods.", kp = 3 },

        { id = "enchanted_sunfire_silk", name = "Enchanted Sunfire Silk",

            itemID = 238549, zone = "Eversong Woods", mapID = 2395, x = 40.2, y = 61.2, questID = 89101, description = "Eversong Woods.", kp = 3 },

        { id = "loa_blessed_dust", name = "Loa-Blessed Dust",

            itemID = 238554, zone = "Zul'Aman", mapID = 2437, x = 40.4, y = 51.1, questID = 89106, description = "Zul'Aman.", kp = 3 },

        { id = "enchanted_amani_mask", name = "Enchanted Amani Mask",

            itemID = 238548, zone = "Zul'Aman (Atal'Aman)", mapID = 2536, x = 48.4, y = 22.9, questID = 89100, description = "Atal'Aman - may be phased.", kp = 3 },

        { id = "primal_essence_orb", name = "Primal Essence Orb",

            itemID = 238553, zone = "Harandar", mapID = 2413, x = 65.8, y = 50.2, questID = 89105, description = "On giant mushroom trees.", kp = 3 },

        { id = "entropic_shard", name = "Entropic Shard",

            itemID = 238552, zone = "Harandar", mapID = 2413, x = 37.7, y = 65.3, questID = 89104, description = "Harandar.", kp = 3 },

        { id = "pure_void_crystal", name = "Pure Void Crystal",

            itemID = 238550, zone = "Voidstorm", mapID = 2405, x = 35.5, y = 58.8, questID = 89102, description = "Voidstorm.", kp = 3 },

    }

