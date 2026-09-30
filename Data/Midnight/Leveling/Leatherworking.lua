-- Midnight Leatherworking — Leveling (+ meta)
local _, private = ...
private.Data = private.Data or {}
private.Data.Leatherworking = private.Data.Leatherworking or {}
local P = private.Data.Leatherworking

P.name = "Leatherworking"


P.overview = "Midnight Leatherworking pairs best with Skinning so you can farm your own leather and scales. First-craft sweeping trainer recipes gets you to ~61 skill; 60-100 is optional unless you want to craft armor at Rank 4-5."

P.trainer = {

        name = "Talmar",

        zone = "Silvermoon City",

        mapID = 2393,

        x = 46.0,
        y = 56.0,

        note = "Silverleaf Thread is sold by the supply vendor near the trainer.",

    }

P.shoppingList = {

        { name = "Void-Tempered Leather", amount = 690, itemID = 238511 },

        { name = "Void-Tempered Scales", amount = 610, itemID = 238513 },

        { name = "Void-Tempered Hide", amount = 3, itemID = 238518 },

        { name = "Void-Tempered Plating", amount = 2, itemID = 238520 },

        { name = "Peerless Plumage", amount = 4, itemID = 238522 },

        { name = "Carving Canine", amount = 3, itemID = 238523 },

        { name = "Fantastic Fur", amount = 4, itemID = 238525 },

        { name = "Tranquility Bloom", amount = 10, itemID = 236761 },

        { name = "Mote of Light", amount = 4, itemID = 236949 },

        { name = "Mote of Pure Void", amount = 1, itemID = 236952 },

        { name = "Silverleaf Thread", amount = 75, itemID = 251665 },

    }

P.leveling = {

        {

            range = "1-7",

            recipe = "Smuggler's Leather Wristbands / Scout's Scaled Bracers",

            quantity = 1,

            reagents = {},

            note = "You start with both recipes. Craft each once for the First Craft Bonus, then visit the trainer for more.",

            difficulty = "orange",

        },

        {

            range = "7-61",

            recipe = "First Craft Sweep (trainer recipes)",

            quantity = 1,

            reagents = {},

            note = "New recipes unlock every 5-10 skill. Filter by First Craft Bonus, craft each recipe once, check the trainer for the next batch, repeat through the skill 50 trainer batch. You'll land around skill 61. If Fantastic Fur, Peerless Plumage, or Carving Canine are too pricey on the AH, craft another orange multi-point recipe instead to keep first-crafting. Equip the Hideworker's Cover you craft along the way.",

            difficulty = "orange",

            isSpecial = true,

        },

        {

            range = "25",

            recipe = "Unlock Specializations",

            quantity = 0,

            reagents = {},

            note = "You unlock your first Leatherworking specialization at skill 25.",

            difficulty = "orange",

            isSpecial = true,

        },

        {

            range = "60-91",

            recipe = "Blessed Pango Charm / Primal Spore Binding / Blood Knight's Armor Kit / Forest Hunter's Armor Kit / Devouring Banding",

            quantity = 35,

            reagents = {

                { name = "Duskshrouded Stone / Scalewoven Hide / Infused Scalewoven Hide", amount = 35, itemID = 0 },

                { name = "Mote of Wild Magic / Primal Energy / Light", amount = 350, itemID = 0 },

                { name = "Sin'dorei Armor Banding / Petrified Root / Fantastic Fur / Carving Canine", amount = 70, itemID = 0 },

            },

            note = "Pick whichever pattern you can get (quest reward, drop, Auction House, or specialization). All go orange to 80, yellow to 90, grey at 100 -- about 35 crafts reaches 91.",

            difficulty = "yellow",

        },

        {

            range = "91-100",

            recipe = "Epic Leather/Mail Armor (Crafting Orders)",

            quantity = 3,

            reagents = {},

            note = "Epic armor recipes from the leather/mail specializations, vendors, drops, or quests give 3 skill points each and are orange to 100 -- 3 completions finishes leveling. Remember to hit Search on the Public Orders tab, it doesn't load automatically. If no orders are available, keep crafting the 60-91 recipe above; it also carries skill to 100, just slower.",

            difficulty = "green",

            isRecommended = true,

        },

    }

