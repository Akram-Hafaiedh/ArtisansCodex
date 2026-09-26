-- Midnight Leatherworking — Knowledge
local _, private = ...
private.Data = private.Data or {}
private.Data.Leatherworking = private.Data.Leatherworking or {}
local P = private.Data.Leatherworking

P.knowledgeOverview = "Leatherworking Knowledge comes from one-time treasures (usually 8×3 KP) and weekly sources such as Patron Orders, a trainer quest, zone drops, an Inscription treatise, and the monthly Darkmoon Faire. Check each row below for details."

P.knowledgeCatchUp = "If you start late or miss weeks, Patron Orders can grant catch-up knowledge until you are back on pace."

P.oneTime = {

        {

            id = "renown_book",

            name = "Whisper of the Loa: Leatherworking",

            itemID = 250922,

            kp = 10,

            kind = "renown_book",

            note = "Sold by Magovu in Zul'Aman for 75 Artisan Leatherworker's Moxie. Requires Renown 6 with Amani Tribe.",

            vendor = "Magovu",

            zone = "Zul'Aman",

        },

    }

P.weekly = {

        {

            name = "Patron Crafting Orders",

            kp = "~12",

            itemID = 246333,

            note = "Main weekly source. Some orders award Glimmer of Midnight Leatherworking Knowledge.",

        },

        {

            name = "Weekly Quest (Trainer)",

            kp = 1,

            itemID = 263459,

            note = "Complete 3 Crafting Orders for a Thalassian Leatherworker's Journal.",

        },

        {

            name = "Weekly Zone Drops",

            kp = 4,

            itemIDs = { 259200, 259201 },

            note = "Amani Tanning Oil + Thalassian Mana Oil from zone treasures.",

        },

        {

            name = "Thalassian Treatise on Leatherworking",

            kp = 1,

            itemID = 245758,

            note = "BoP from Inscription. Public Crafting Order, or craft on an Inscription alt.",

        },

        {

            name = "Darkmoon Faire",

            kp = 3,

            note = "Monthly profession quest: +3 Knowledge and +2 Skill.",

        },

    }

P.treasures = {

        { id = "artisans_considered_order", name = "Artisan's Considered Order",

            itemID = 238595, zone = "Silvermoon City", mapID = 2393, x = 44.8, y = 56.2, questID = 89096, description = "Silvermoon City.", kp = 3 },

        { id = "bundle_of_tanners_trinkets", name = "Bundle of Tanner's Trinkets",

            itemID = 238591, zone = "Zul'Aman (Atal'Aman)", mapID = 2536, x = 45.4, y = 45.5, questID = 89092, description = "Atal'Aman - may be phased.", kp = 3 },

        { id = "amani_leatherworkers_tool", name = "Amani Leatherworker's Tool",

            itemID = 238588, zone = "Zul'Aman", mapID = 2437, x = 33.1, y = 78.9, questID = 89089, description = "Zul'Aman.", kp = 3 },

        { id = "prestigiously_racked_hide", name = "Prestigiously Racked Hide",

            itemID = 238590, zone = "Zul'Aman", mapID = 2437, x = 30.8, y = 84.0, questID = 89091, description = "Zul'Aman.", kp = 3 },

        { id = "ethereal_leatherworking_knife", name = "Ethereal Leatherworking Knife",

            itemID = 238589, zone = "Voidstorm", mapID = 2405, x = 34.7, y = 57.0, questID = 89090, description = "Voidstorm.", kp = 3 },

        { id = "haranir_leatherworking_mallet", name = "Haranir Leatherworking Mallet",

            itemID = 238593, zone = "Harandar", mapID = 2413, x = 51.7, y = 51.3, questID = 89094, description = "Harandar.", kp = 3 },

        { id = "haranir_leatherworking_knife", name = "Haranir Leatherworking Knife",

            itemID = 238594, zone = "Harandar", mapID = 2413, x = 36.1, y = 25.2, questID = 89095, description = "Harandar.", kp = 3 },

        { id = "patterns_beyond_the_void", name = "Patterns: Beyond the Void",

            itemID = 238592, zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 53.7, y = 51.7, questID = 89093, description = "Voidstorm, Slaver's Rise.", kp = 3 },

    }

