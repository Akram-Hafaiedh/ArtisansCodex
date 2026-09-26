-- Artisan's Codex - Midnight Leatherworking Data
-- Source: wow-professions.com/guides/wow-leatherworking-leveling-guide (accurate as of patch 12.1)

local _, private = ...

private.Data = private.Data or {}

private.Data.Leatherworking = {
    name = "Leatherworking",
    icon = "Interface\\Icons\\Trade_LeatherWorking",
    overview = "Midnight Leatherworking pairs best with Skinning so you can farm your own leather and scales. First-craft sweeping trainer recipes gets you to ~61 skill; 60-100 is optional unless you want to craft armor at Rank 4-5.",

    trainer = {
        name = "Talmar",
        zone = "Silvermoon City",
        mapID = 2393,
        x = 46.0,          -- approximate, refine if needed
        y = 56.0,
        note = "Silverleaf Thread is sold by the supply vendor near the trainer.",
    },

    shoppingList = {
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
    },

    leveling = {
        {
            range = "1-7",
            recipe = "Smuggler's Leather Wristbands / Scout's Scaled Bracers",
            quantity = 1,
            materials = {},
            note = "You start with both recipes. Craft each once for the First Craft Bonus, then visit the trainer for more.",
            difficulty = "orange",
        },
        {
            range = "7-61",
            recipe = "First Craft Sweep (trainer recipes)",
            quantity = 1,
            materials = {},
            note = "New recipes unlock every 5-10 skill. Filter by First Craft Bonus, craft each recipe once, check the trainer for the next batch, repeat through the skill 50 trainer batch. You'll land around skill 61. If Fantastic Fur, Peerless Plumage, or Carving Canine are too pricey on the AH, craft another orange multi-point recipe instead to keep first-crafting. Equip the Hideworker's Cover you craft along the way.",
            difficulty = "orange",
            isSpecial = true,
        },
        {
            range = "25",
            recipe = "Unlock Specializations",
            quantity = 0,
            materials = {},
            note = "You unlock your first Leatherworking specialization at skill 25.",
            difficulty = "orange",
            isSpecial = true,
        },
        {
            range = "60-91",
            recipe = "Blessed Pango Charm / Primal Spore Binding / Blood Knight's Armor Kit / Forest Hunter's Armor Kit / Devouring Banding",
            quantity = 35,
            materials = {
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
            materials = {},
            note = "Epic armor recipes from the leather/mail specializations, vendors, drops, or quests give 3 skill points each and are orange to 100 -- 3 completions finishes leveling. Remember to hit Search on the Public Orders tab, it doesn't load automatically. If no orders are available, keep crafting the 60-91 recipe above; it also carries skill to 100, just slower.",
            difficulty = "green",
            isRecommended = true,
        },
    },

    knowledgeOverview = "Leatherworking Knowledge comes from one-time treasures (usually 8×3 KP) and weekly sources such as Patron Orders, a trainer quest, zone drops, an Inscription treatise, and the monthly Darkmoon Faire. Check each row below for details.",

    knowledgeCatchUp = "If you start late or miss weeks, Patron Orders can grant catch-up knowledge until you are back on pace.",

    treasures = {
        { id = "artisans_considered_order", name = "Artisan's Considered Order", zone = "Silvermoon City", mapID = 2393, x = 44.8, y = 56.2, questID = 89096, description = "Silvermoon City.", kp = 3 },
        { id = "bundle_of_tanners_trinkets", name = "Bundle of Tanner's Trinkets", zone = "Zul'Aman (Atal'Aman)", mapID = 2536, x = 45.4, y = 45.5, questID = 89092, description = "Atal'Aman - may be phased.", kp = 3 },
        { id = "amani_leatherworkers_tool", name = "Amani Leatherworker's Tool", zone = "Zul'Aman", mapID = 2437, x = 33.1, y = 78.9, questID = 89089, description = "Zul'Aman.", kp = 3 },
        { id = "prestigiously_racked_hide", name = "Prestigiously Racked Hide", zone = "Zul'Aman", mapID = 2437, x = 30.8, y = 84.0, questID = 89091, description = "Zul'Aman.", kp = 3 },
        { id = "ethereal_leatherworking_knife", name = "Ethereal Leatherworking Knife", zone = "Voidstorm", mapID = 2405, x = 34.7, y = 57.0, questID = 89090, description = "Voidstorm.", kp = 3 },
        { id = "haranir_leatherworking_mallet", name = "Haranir Leatherworking Mallet", zone = "Harandar", mapID = 2413, x = 51.7, y = 51.3, questID = 89094, description = "Harandar.", kp = 3 },
        { id = "haranir_leatherworking_knife", name = "Haranir Leatherworking Knife", zone = "Harandar", mapID = 2413, x = 36.1, y = 25.2, questID = 89095, description = "Harandar.", kp = 3 },
        { id = "patterns_beyond_the_void", name = "Patterns: Beyond the Void", zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 53.7, y = 51.7, questID = 89093, description = "Voidstorm, Slaver's Rise.", kp = 3 },
    },

}