-- Midnight Engineering — Knowledge
local _, private = ...
private.Data = private.Data or {}
private.Data.Engineering = private.Data.Engineering or {}
local P = private.Data.Engineering

P.knowledgeOverview = "Engineering Knowledge comes from one-time treasures (usually 8×3 KP) and weekly sources such as Patron Orders, a trainer quest, zone drops, an Inscription treatise, and the monthly Darkmoon Faire. Check each row below for details."

P.knowledgeCatchUp = "If you start late or miss weeks, Patron Orders can grant catch-up knowledge until you are back on pace."

P.oneTime = {

        {

            id = "renown_book",

            name = "Beyond the Event Horizon: Engineering",

            itemID = 262646,

            kp = 10,

            kind = "renown_book",

            note = "Sold by Void Researcher Anomander in Voidstorm for 75 Artisan Engineer's Moxie. Requires Renown 9 with The Singularity.",

            vendor = "Void Researcher Anomander",

            zone = "Voidstorm",

        },

    }

P.treasures = {

        { id = "one_engineers_junk", name = "One Engineer's Junk",

            itemID = 238556, zone = "Silvermoon City", mapID = 2393, x = 51.2, y = 74.6, questID = 89133, kp = 3 },

        { id = "what_to_do", name = "What To Do When Nothing Works",

            itemID = 238562, zone = "Silvermoon City", mapID = 2393, x = 51.3, y = 57.0, questID = 89139, kp = 3 },

        { id = "manual_mistakes", name = "Manual of Mistakes and Mishaps",

            itemID = 238558, zone = "Eversong Woods", mapID = 2395, x = 39.6, y = 45.8, questID = 89135, kp = 3 },

        { id = "offline_helper", name = "Offline Helper Bot",

            itemID = 238561, zone = "Zul'Aman (Atal'Aman)", mapID = 2536, x = 65.3, y = 35.0, questID = 89138, kp = 3 },

        { id = "handy_wrench", name = "Handy Wrench",

            itemID = 238563, zone = "Zul'Aman", mapID = 2437, x = 34.2, y = 87.8, questID = 89140, kp = 3 },

        { id = "expeditious_pylon", name = "Expeditious Pylon",

            itemID = 238559, zone = "Harandar", mapID = 2413, x = 68.0, y = 49.8, questID = 89136, kp = 3 },

        { id = "ethereal_stormwrench", name = "Ethereal Stormwrench",

            itemID = 238560, zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 54.1, y = 51.1, questID = 89137, kp = 3 },

        { id = "miniaturized_skiff", name = "Miniaturized Transport Skiff",

            itemID = 238557, zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 28.9, y = 39.1, questID = 89134, kp = 3 },

    }

P.weekly = {

        {

            name = "Patron Crafting Orders",

            kp = "~12",

            itemID = 246327,

            note = "Main weekly source. Some orders award Glimmer of Midnight Engineering Knowledge.",

        },

        {

            name = "Weekly Quest (Trainer)",

            kp = 1,

            itemID = 263456,

            note = "Complete 3 Crafting Orders for a Thalassian Engineer's Notepad.",

        },

        {

            name = "Weekly Zone Drops",

            kp = 4,

            itemIDs = { 259194, 259195 },

            note = "Dance Gear + Dawn Capacitor from zone treasures.",

        },

        {

            name = "Thalassian Treatise on Engineering",

            kp = 1,

            itemID = 245809,

            note = "BoP from Inscription. Public Crafting Order, or craft on an Inscription alt.",

        },

        {

            name = "Darkmoon Faire",

            kp = 3,

            note = "Monthly profession quest: +3 Knowledge and +2 Skill.",

        },

    }

