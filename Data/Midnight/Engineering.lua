-- Artisan's Codex - Midnight Engineering Data
-- Source: wow-professions.com + Wowhead (accurate as of patch 12.1)

local _, private = ...

private.Data = private.Data or {}

private.Data.Engineering = {
    name = "Engineering",
    icon = "Interface\\Icons\\Trade_Engineering",
    overview = "Midnight Engineering is built around Recycling. Most recipes are discovered by recycling crafted reagents from any profession. Early levels use trainer recipes + Recycling, then Quel'dorei gear, and finally Housing Decor or Profession Equipment / Crafting Orders to reach 100.",

    trainer = {
        name = "Danwe",
        zone = "Silvermoon City",
        mapID = 2393,
        x = 43.5,          -- approximate, refine if needed
        y = 54.1,
        note = "Engineering supply vendor is standing right next to the trainer (Malleable Wireframe, Pile of Junk, tools).",
    },

    -- =========================================================
    -- RECYCLING REAGENTS
    -- =========================================================
    -- Recycling (itemID 253849) accepts any crafted reagent from ANY profession.
    -- "cheapest" are the go-to picks for leveling; "byProfession" is the full
    -- list of everything else that can be recycled, grouped by source profession.
    recycling = {
        abilityItemID = 253849,
        cheapest = {
            { name = "Powder Pigment", itemID = 245807, profession = "Inscription", output = "Evercore" },
            { name = "Bright Linen Bolt", itemID = 239700, profession = "Tailoring", output = "Evercore" },
            { name = "Imbued Bright Linen Bolt", itemID = 239702, profession = "Tailoring", output = "Aetherlume" },
        },
        byProfession = {
            Blacksmithing = {
                { name = "Gloaming Alloy", itemID = 238202 },
                { name = "Sterling Alloy", itemID = 238204 },
                { name = "Refulgent Copper Ingot", itemID = 238197 },
            },
            Engineering = {
                { name = "Song Gear", itemID = 243574 },
                { name = "Soul Cipher", itemID = 245766 },
                { name = "Soul Sprocket", itemID = 243576 },
            },
            Inscription = {
                { name = "Argentleaf Pigment", itemID = 245803 },
                { name = "Codified Azeroot", itemID = 245764 },
                { name = "Darkmoon Sigil: Blood", itemID = 245871 },
                { name = "Darkmoon Sigil: Hunt", itemID = 245875 },
                { name = "Darkmoon Sigil: Rot", itemID = 245877 },
                { name = "Darkmoon Sigil: Void", itemID = 245873 },
                { name = "Munsell Ink", itemID = 245801 },
                { name = "Powder Pigment", itemID = 245807 },
                { name = "Sienna Ink", itemID = 245805 },
                { name = "Thalassian Missive of Crafting Speed", itemID = 245820 },
                { name = "Thalassian Missive of Deftness", itemID = 245826 },
                { name = "Thalassian Missive of Finesse", itemID = 245822 },
                { name = "Thalassian Missive of Ingenuity", itemID = 245814 },
                { name = "Thalassian Missive of Multicraft", itemID = 245818 },
                { name = "Thalassian Missive of Perception", itemID = 245824 },
                { name = "Thalassian Missive of Resourcefulness", itemID = 245816 },
                { name = "Thalassian Missive of the Aurora", itemID = 245781 },
                { name = "Thalassian Missive of the Feverflare", itemID = 245783 },
                { name = "Thalassian Missive of the Fireflash", itemID = 245785 },
                { name = "Thalassian Missive of the Harmonious", itemID = 245787 },
                { name = "Thalassian Missive of the Peerless", itemID = 245789 },
                { name = "Thalassian Missive of the Quickblade", itemID = 245791 },
            },
            Leatherworking = {
                { name = "Blessed Pango Charm", itemID = 244603 },
                { name = "Devouring Banding", itemID = 244674 },
                { name = "Infused Scalewoven Hide", itemID = 244633 },
                { name = "Primal Spore Binding", itemID = 244607 },
                { name = "Scalewoven Hide", itemID = 244631 },
                { name = "Silvermoon Weapon Wrap", itemID = 244637 },
                { name = "Sin'dorei Armor Banding", itemID = 244635 },
            },
            Tailoring = {
                { name = "Bright Linen Bolt", itemID = 239700 },
                { name = "Imbued Bright Linen Bolt", itemID = 239702 },
                { name = "Arcanoweave Bolt", itemID = 239198 },
                { name = "Arcanoweave Lining", itemID = 240166 },
                { name = "Sunfire Silk Bolt", itemID = 239201 },
                { name = "Sunfire Silk Lining", itemID = 240164 },
            },
        },
    },

    -- =========================================================
    -- LEVELING GUIDE
    -- =========================================================
    leveling = {
        -- 1-25 Shared
        {
            range = "1-16",
            recipe = "Song Gear + Recycling",
            quantity = 8,
            materials = {
                { name = "Malleable Wireframe", amount = 8, itemID = 253302 },
                { name = "Refulgent Copper Ore", amount = 80, itemID = 237359 },
                { name = "Umbral Tin Ore", amount = 40, itemID = 237362 },
            },
            note = "Craft 8x Song Gear, then recycle 7x of the cheapest reagent you can find (Powder Pigment, Bright Linen Bolt, or Refulgent Copper Ingot -- see the recycling.cheapest table).",
            difficulty = "orange",
        },
        {
            range = "16-25",
            recipe = "First Crafts (Evercore items)",
            quantity = 1,
            materials = {},
            note = "Craft every available First Craft: Evercore Shade, Evercore Vision Guard, Evercore Dome Dinger, Evercore Zoomshroud, Evercore Reconaissance.",
            difficulty = "orange",
            isSpecial = true,
        },
        {
            range = "25-39",
            recipe = "Soul Sprocket + Cogwheels",
            quantity = 10,
            materials = {
                { name = "Malleable Wireframe", amount = 10, itemID = 253302 },
                { name = "Refulgent Copper Ore", amount = 50, itemID = 237359 },
                { name = "Umbral Tin Ore", amount = 100, itemID = 237362 },
            },
            note = "At skill 25 unlock specializations. Put your first 10 Knowledge Points into Recycling (required for recipe discovery).",
            difficulty = "orange",
            specAction = "open_tree",
            specTargetIcon = "Interface\\Icons\\Inv_10_engineering_device_gadget1_color1",
            specTarget = "Recycling",
        },
        {
            range = "39-45",
            recipe = "More Recycling + First Crafts",
            quantity = 20,
            materials = {},
            note = "Keep recycling the cheapest reagent available (see recycling.cheapest) and craft every remaining First Craft recipe in your book.",
            difficulty = "yellow",
        },

        -- =========================================================
        -- FORK
        -- =========================================================
        {
            type = "fork",
            range = "45-100",
            paths = {
                {
                    key = "recycle",
                    label = "Recycling / Quel'dorei",
                    description = "Cheapest",
                    intro = "Keep recycling until you discover Quel'dorei recipes. These are the cheapest way to 80.",
                },
                {
                    key = "decor",
                    label = "Housing Decor",
                    description = "Reliable to 100",
                    intro = "Discover the 7 Housing Decor recipes via Recycling. They stay useful all the way to 100.",
                },
                {
                    key = "orders",
                    label = "Crafting Orders / Profession Gear",
                    description = "Passive / Gold",
                    intro = "Use Crafting Orders (especially epic tools) or craft rare/epic profession equipment if you went Market Mobility.",
                },
            },
        },

        -- Recycle / Quel'dorei path
        {
            range = "45-80",
            path = "recycle",
            recipe = "Quel'dorei Gear (discovered)",
            quantity = 60,
            materials = {
                { name = "Pile of Junk", amount = 300, itemID = 253303 },
                { name = "Malleable Wireframe", amount = 60, itemID = 253302 },
                { name = "Evercore", amount = 60, itemID = 243581 },
            },
            note = "Keep recycling until you discover any Quel'dorei recipe (Guards, Bracers, etc.). These carry you to 80 very cheaply.",
            difficulty = "green",
            isRecommended = true,
        },

        -- Housing Decor path
        {
            range = "80-100",
            path = "decor",
            recipe = "Housing Decor (discovered)",
            quantity = 1,
            materials = {
                { name = "Aetherlume", amount = 5, itemID = 243578 },
                { name = "Evercore", amount = 5, itemID = 243581 },
                { name = "Song Gear", amount = 10, itemID = 243574 },
                { name = "Soul Sprocket", amount = 10, itemID = 243576 },
                { name = "Thalassian Lumber", amount = 25, itemID = 256963 }, -- average
            },
            note = "7 different Housing Decor recipes. Stay yellow until ~92 and usable to 100. Best non-order path to 100.",
            difficulty = "yellow",
        },

        -- Orders / Profession Gear path
        {
            range = "80-100",
            path = "orders",
            recipe = "Epic Profession Tools / Crafting Orders",
            quantity = 1,
            materials = {},
            note = "Epic profession tools (sold by Lyrendal for Artisan Engineer's Moxie) always give skill. Crafting Orders for Aetherlume armor or tools are also excellent.",
            difficulty = "green",
        },
    },

    -- =========================================================
    -- KNOWLEDGE TREASURES
    -- =========================================================
    treasures = {
        { id = "one_engineers_junk", name = "One Engineer's Junk", zone = "Silvermoon City", mapID = 2393, x = 51.2, y = 74.6, questID = 89133, kp = 3 },
        { id = "what_to_do", name = "What To Do When Nothing Works", zone = "Silvermoon City", mapID = 2393, x = 51.3, y = 57.0, questID = 89139, kp = 3 },
        { id = "manual_mistakes", name = "Manual of Mistakes and Mishaps", zone = "Eversong Woods", mapID = 2395, x = 39.6, y = 45.8, questID = 89135, kp = 3 },
        { id = "offline_helper", name = "Offline Helper Bot", zone = "Zul'Aman (Atal'Aman)", mapID = 2536, x = 65.3, y = 35.0, questID = 89138, kp = 3 },
        { id = "handy_wrench", name = "Handy Wrench", zone = "Zul'Aman", mapID = 2437, x = 34.2, y = 87.8, questID = 89140, kp = 3 },
        { id = "expeditious_pylon", name = "Expeditious Pylon", zone = "Harandar", mapID = 2413, x = 68.0, y = 49.8, questID = 89136, kp = 3 },
        { id = "ethereal_stormwrench", name = "Ethereal Stormwrench", zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 54.1, y = 51.1, questID = 89137, kp = 3 },
        { id = "miniaturized_skiff", name = "Miniaturized Transport Skiff", zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 28.9, y = 39.1, questID = 89134, kp = 3 },
    },

    -- =========================================================
    -- WEEKLY KNOWLEDGE
    -- =========================================================
    weekly = {
        { name = "Patron Crafting Orders", kp = "~12", note = "Main source." },
        { name = "Weekly Quest (Trainer)", kp = 1, note = "Complete 3 Crafting Orders." },
        { name = "Weekly Drops", kp = 4, note = "Dance Gear + Dawn Capacitor." },
        { name = "Thalassian Treatise on Engineering", kp = 1, note = "Crafted by Inscription (BoP)." },
        { name = "Darkmoon Faire", kp = 3, note = "Once per month." },
    },

    -- =========================================================
    -- SPECIALIZATION BUILDS
    -- =========================================================
    specializations = {
        {
            name = "Recycling First (Recommended for leveling)",
            goal = "Cheapest leveling + discovery",
            description = "Required to unlock recipe discovery. Also gives strong crafting stats.",
            steps = {
                "10 points into Recycling root (unlocks discovery)",
                "Then Resourcefulness sub-spec",
                "Later fill the rest of Recycling for more materials per recycle",
            },
        },
        {
            name = "Market Mobility (Profession Tools)",
            goal = "Crafting Orders / Gold",
            description = "Best if you want to craft tools and accessories for other professions.",
            steps = {
                "Unlock Market Mobility",
                "Prioritize the tool/accessory nodes you want to sell",
                "Still put early points into Recycling",
            },
        },
        {
            name = "Combat Analytics",
            goal = "Goggles / Bracers / Guns",
            description = "For personal gear or high-end Crafting Orders.",
            steps = {
                "Unlock Combat Analytics at 50",
                "Focus on the armor type / gun you care about",
            },
        },
    },
}