-- Artisan's Codex - Midnight Skinning Data
-- Source: wow-professions.com/guides/wow-skinning-leveling-guide (accurate as of patch 12.1)
-- Skinning is a gathering profession tied to killing mobs, not crafting -- no standard leveling recipe list.

local _, private = ...

private.Data = private.Data or {}

private.Data.Skinning = {
    name = "Skinning",
    icon = "Interface\\Icons\\INV_Misc_Pelt_Wolf_01",
    isGathering = true,
    overview = "Midnight Skinning has no more refining -- what you skin is what you get. Skill comes from skinning beasts as you level your character; High Value Beasts (marked on the minimap) give bonus leather. Pairs best with Leatherworking.",

    trainer = {
        name = "Tyn",
        zone = "Silvermoon City",
        mapID = 2393,
        x = 47.0,          -- approximate, refine if needed
        y = 58.0,
        note = "Artisan Skinner's Moxie is the profession-specific currency for Skinning unlocks.",
    },

    -- =========================================================
    -- LEVELING NOTES (gathering profession -- tied to killing mobs)
    -- =========================================================
    leveling = {
        {
            range = "1-100",
            recipe = "Skin everything you kill",
            quantity = 0,
            materials = {},
            note = "There's no dedicated skinning grind route -- skill comes naturally from skinning mobs while questing/leveling your character. Watch for the skinning-knife icon on the minimap (High Value Beasts) for bonus leather, and throw a Diffuser at a mob before killing it to also collect Motes.",
            difficulty = "orange",
            isRecommended = true,
        },
    },

    -- =========================================================
    -- BASE MATERIALS
    -- =========================================================
    materials = {
        { name = "Void-Tempered Leather", source = "Leather mobs" },
        { name = "Void-Tempered Scales", source = "Scale mobs" },
        { name = "Void-Tempered Hide", source = "Rare mobs, Sharpen Your Knife, lure beasts" },
        { name = "Void-Tempered Plating", source = "Rare scale mobs, Sharpen Your Knife, lure beasts" },
        { name = "Fantastic Fur", source = "Furred creatures" },
        { name = "Peerless Plumage", source = "Feathered creatures" },
        { name = "Carving Canine", source = "Fanged creatures" },
        { name = "Majestic Claw / Hide / Fin", source = "Renowned Beasts (lure system)" },
    },

    -- =========================================================
    -- DIFFUSERS (Mote farming, replaces old lure-on-ground system)
    -- =========================================================
    diffusers = {
        { name = "Lightbloom Diffuser", cost = "2x Mote of Light", drops = "1-4 Mote of Light" },
        { name = "Wild Diffuser", cost = "2x Mote of Wild Magic", drops = "1-4 Mote of Wild Magic" },
        { name = "Primal Diffuser", cost = "2x Mote of Primal Energy", drops = "1-4 Mote of Primal Energy" },
        { name = "Void Diffuser", cost = "2x Mote of Pure Void", drops = "1-4 Mote of Pure Void" },
    },

    -- =========================================================
    -- PROFESSION EQUIPMENT
    -- =========================================================
    equipment = {
        { name = "Skinner's Cap", craftedBy = "Leatherworking" },
        { name = "Skinner's Backpack", craftedBy = "Leatherworking" },
        { name = "Thalassian Skinning Knife", craftedBy = "Blacksmithing" },
        { name = "Sun-Blessed Skinning Knife", craftedBy = "Blacksmithing" },
    },

    -- =========================================================
    -- KNOWLEDGE TREASURES
    -- =========================================================
    knowledgeOverview = "Skinning Knowledge comes from one-time treasures (usually 8×3 KP) and weekly sources such as Patron Orders, a trainer quest, zone drops, an Inscription treatise, and the monthly Darkmoon Faire. Check each row below for details.",

    knowledgeCatchUp = "If you start late or miss weeks, Patron Orders can grant catch-up knowledge until you are back on pace.",

    treasures = {
        { id = "sindorei_tanning_oil", name = "Sin'dorei Tanning Oil", zone = "Silvermoon City", mapID = 2393, x = 43.2, y = 55.7, questID = 89171, kp = 3 },
        { id = "thalassian_skinning_knife", name = "Thalassian Skinning Knife", zone = "Eversong Woods", mapID = 2395, x = 48.4, y = 76.3, questID = 89173, kp = 3 },
        { id = "cadre_skinning_knife", name = "Cadre Skinning Knife", zone = "Zul'Aman (Atal'Aman)", mapID = 2536, x = 44.9, y = 45.2, questID = 89167, description = "May be phased -- progress the campaign further if it doesn't show.", kp = 3 },
        { id = "amani_skinning_knife", name = "Amani Skinning Knife", zone = "Zul'Aman", mapID = 2437, x = 33.1, y = 79.1, questID = 89172, kp = 3 },
        { id = "amani_tanning_oil", name = "Amani Tanning Oil", zone = "Zul'Aman", mapID = 2437, x = 40.4, y = 36.0, questID = 89170, kp = 3 },
        { id = "primal_hide", name = "Primal Hide", zone = "Harandar", mapID = 2413, x = 69.5, y = 49.2, questID = 89168, kp = 3 },
        { id = "lightbloom_afflicted_hide", name = "Lightbloom Afflicted Hide", zone = "Harandar", mapID = 2413, x = 76.0, y = 51.0, questID = 89166, kp = 3 },
        { id = "voidstorm_leather_sample", name = "Voidstorm Leather Sample", zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 45.5, y = 42.3, questID = 89169, kp = 3 },
    },

    -- =========================================================
    -- WEEKLY KNOWLEDGE
    -- =========================================================
    weekly = {
        { name = "Trainer Quest", kp = 3, note = "Weekly quest from the Skinning trainer." },
        { name = "Gathering Drops", kp = "~8", note = "Knowledge items drop naturally while skinning." },
        { name = "Thalassian Treatise on Skinning", kp = 1, note = "Crafted by Inscription (BoP). Submit a public crafting order or use an Inscription alt." },
        { name = "Darkmoon Faire", kp = 3, note = "Monthly, not weekly." },
    },
}