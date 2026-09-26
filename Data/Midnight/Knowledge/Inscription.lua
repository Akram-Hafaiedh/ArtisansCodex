-- Midnight Inscription — Knowledge
local _, private = ...
private.Data = private.Data or {}
private.Data.Inscription = private.Data.Inscription or {}
local P = private.Data.Inscription

P.knowledgeOverview = "Inscription Knowledge comes from one-time treasures (usually 8×3 KP) and weekly sources such as Patron Orders, a trainer quest, zone drops, an Inscription treatise, and the monthly Darkmoon Faire. Check each row below for details."

P.knowledgeCatchUp = "If you start late or miss weeks, Patron Orders can grant catch-up knowledge until you are back on pace."

P.oneTime = {

        {

            id = "renown_book",

            name = "Traditions of the Haranir: Inscription",

            itemID = 258411,

            kp = 10,

            kind = "renown_book",

            note = "Sold by Naynar in Harandar for 75 Artisan Scribe's Moxie. Requires Renown 6 with Hara'ti.",

            vendor = "Naynar",

            zone = "Harandar",

        },

    }

P.weekly = {

        {

            name = "Patron Crafting Orders",

            kp = "~12",

            itemID = 246329,

            note = "Main weekly source. Some orders award Glimmer of Midnight Inscription Knowledge.",

        },

        {

            name = "Weekly Quest (Trainer)",

            kp = 1,

            itemID = 263457,

            note = "Complete 3 Crafting Orders for a Thalassian Scribe's Journal.",

        },

        {

            name = "Weekly Zone Drops",

            kp = 4,

            itemIDs = { 259196, 259197 },

            note = "Brilliant Phoenix Ink + Loa-Blessed Rune from zone treasures.",

        },

        {

            name = "Thalassian Treatise on Inscription",

            kp = 1,

            itemID = 245757,

            note = "Crafted via Calm Hands specialization. Once per week.",

        },

        {

            name = "Darkmoon Faire",

            kp = 3,

            note = "Monthly profession quest: +3 Knowledge and +2 Skill.",

        },

    }

P.treasures = {

        { id = "songwriters_pen", name = "Songwriter's Pen",

            itemID = 238578, zone = "Silvermoon City", mapID = 2393, x = 47.7, y = 50.4, questID = 89073, description = "On top of the building behind the Alchemy trainer.", kp = 3 },

        { id = "songwriters_quill", name = "Songwriter's Quill",

            itemID = 238579, zone = "Eversong Woods", mapID = 2395, x = 40.3, y = 61.2, questID = 89074, description = "Inside the building.", kp = 3 },

        { id = "spare_ink", name = "Spare Ink",

            itemID = 238574, zone = "Eversong Woods", mapID = 2395, x = 48.3, y = 75.6, questID = 89069, description = "Eversong Woods.", kp = 3 },

        { id = "half_baked_techniques", name = "Half-Baked Techniques",

            itemID = 238577, zone = "Eversong Woods", mapID = 2395, x = 39.3, y = 45.4, questID = 89072, description = "Eversong Woods.", kp = 3 },

        { id = "leather_bound_techniques", name = "Leather-Bound Techniques",

            itemID = 238573, zone = "Zul'Aman", mapID = 2437, x = 40.5, y = 49.4, questID = 89068, description = "Inside the cave.", kp = 3 },

        { id = "leftover_sanguithorn_pigment", name = "Leftover Sanguithorn Pigment",

            itemID = 238576, zone = "Harandar", mapID = 2413, x = 52.7, y = 50.0, questID = 89071, description = "Harandar.", kp = 3 },

        { id = "intrepid_explorers_marker", name = "Intrepid Explorer's Marker",

            itemID = 238575, zone = "Harandar", mapID = 2413, x = 52.4, y = 52.6, questID = 89070, description = "Up on the roots.", kp = 3 },

        { id = "void_touched_quill", name = "Void-Touched Quill",

            itemID = 238572, zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 60.7, y = 84.3, questID = 89067, description = "Inside the building.", kp = 3 },

    }

