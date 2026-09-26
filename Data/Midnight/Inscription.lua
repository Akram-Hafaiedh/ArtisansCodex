-- Artisan's Codex - Midnight Inscription Data
-- Source: wow-professions.com (accurate as of patch 12.1)

local _, private = ...

private.Data = private.Data or {}

private.Data.Inscription = {
    name = "Inscription",
    icon = "Interface\\Icons\\Trade_Engraving",
    overview = "Midnight Inscription is arguably the easiest profession to level. Mill herbs into pigments, craft a handful of inks and first-craft items, then unlock the Thalassian Treatise on Inscription via Calm Hands and spam it (and the profession Treatises it discovers) all the way to 100. Pairs best with Herbalism.",

    trainer = {
        name = "Zantasia",
        zone = "Silvermoon City",
        mapID = 2393,
        x = 46.0,          -- approximate, refine if needed (Bazaar, near Sanctum of Light)
        y = 54.5,
        note = "Inscription supply vendor (Lexicologist's Vellum, Thalassian Songwater) is next to the trainer.",
    },

    -- =========================================================
    -- LEVELING GUIDE
    -- =========================================================
    leveling = {
        {
            range = "1-20",
            recipe = "Midnight Milling",
            quantity = 640,
            materials = {
                { name = "Tranquility Bloom", amount = 360, itemID = 236761 },
                { name = "Argentleaf", amount = 100, itemID = 236776 },
                { name = "Mana Lily", amount = 90, itemID = 236778 },
                { name = "Sanguithorn", amount = 90, itemID = 236770 },
            },
            note = "Mill all four herbs with Midnight Milling from your profession spell book. This alone carries you from 1 to 20. Farm the herbs yourself if you have Herbalism, otherwise buy from the AH.",
            difficulty = "orange",
        },
        {
            range = "20-30",
            recipe = "Munsell Ink + Sienna Ink",
            quantity = 23,
            materials = {
                { name = "Thalassian Songwater", amount = 69, itemID = 245882 },
                { name = "Powder Pigment", amount = 460, itemID = 245807 },
                { name = "Sanguithorn Pigment", amount = 110, itemID = 0 },
                { name = "Mana Lily Pigment", amount = 115, itemID = 0 },
                { name = "Argentleaf Pigment", amount = 120, itemID = 0 },
            },
            note = "Craft 11x Munsell Ink, then 12x Sienna Ink, in that order. Thalassian Songwater is sold by the supply vendor next to the trainer. Keep every ink you make, you'll need it later.",
            difficulty = "orange",
        },
        {
            range = "25",
            recipe = "Unlock Specializations",
            quantity = 0,
            materials = {},
            note = "At skill 25 you unlock Inscription specializations. Learn Calm Hands FIRST, it teaches the Thalassian Treatise on Inscription recipe you'll use to level from ~45 to 100. You'll eventually unlock all four trees (50/60/75), so the order after Calm Hands doesn't matter much.",
            difficulty = "orange",
            isSpecial = true,
            specAction = "open_tree",
            specTargetIcon = "Interface\\Icons\\Inv_10_specialization_inscription_sharedknowledge_color2",
            specTarget = "Calm Hands",
        },
        {
            range = "30-35",
            recipe = "First Crafts (Staves + Soul Cipher)",
            quantity = 4,
            materials = {
                { name = "Thalassian Songwater", amount = 3, itemID = 245882 },
                { name = "Azeroot", amount = 24, itemID = 236774 },
                { name = "Mote of Pure Void", amount = 1, itemID = 236952 },
                { name = "Mote of Light", amount = 1, itemID = 236949 },
                { name = "Duskshrouded Stone", amount = 1, itemID = 242788 },
                { name = "Munsell Ink", amount = 1, itemID = 245801 },
                { name = "Sienna Ink", amount = 1, itemID = 245805 },
            },
            note = "Craft Faunatender's Baton, Floratender's Crutch, Rootwarden's Lamp, and Soul Cipher once each for the First Craft bonuses.",
            difficulty = "orange",
            isSpecial = true,
        },
        {
            range = "35-42",
            recipe = "First Craft Sweep (Quill, Missives, Tools)",
            quantity = 9,
            materials = {
                { name = "Azeroot", amount = 31, itemID = 236774 },
                { name = "Munsell Ink", amount = 9, itemID = 245801 },
                { name = "Sienna Ink", amount = 13, itemID = 245805 },
                { name = "Mote of Primal Energy", amount = 4, itemID = 236950 },
                { name = "Mote of Pure Void", amount = 1, itemID = 236952 },
                { name = "Mote of Wild Magic", amount = 1, itemID = 236951 },
            },
            note = "Filter by 'First Craft Bonus' in your profession window and craft everything except the Thalassian Treatise on Inscription (save that for later). Includes Codified Azeroot, Faunatender's Trust, Hobbyist Alchemist's Mixing Rod, Hobbyist Rolling Pin, Hobbyist Scribe's Quill (equip it), and 4x Thalassian Missives. Clear your filter when done.",
            difficulty = "yellow",
            isSpecial = true,
        },
        {
            range = "42-45",
            recipe = "Thalassian Treatise on Inscription",
            quantity = 3,
            materials = {
                { name = "Lexicologist's Vellum", amount = 9, itemID = 245880 },
                { name = "Mote of Wild Magic", amount = 3, itemID = 236951 },
                { name = "Munsell Ink", amount = 3, itemID = 245801 },
                { name = "Sienna Ink", amount = 3, itemID = 245805 },
            },
            note = "Craft Treatises to fill in to 45 if you're not there already. Don't consume/use the Treatises yet, save one: putting 10 points into Calm Hands later doubles the knowledge you get from using one.",
            difficulty = "yellow",
        },
        {
            range = "45-50",
            recipe = "Missives + Treatise",
            quantity = 5,
            materials = {
                { name = "Munsell Ink", amount = 7, itemID = 245801 },
                { name = "Sienna Ink", amount = 7, itemID = 245805 },
                { name = "Mote of Pure Void", amount = 2, itemID = 236952 },
                { name = "Lexicologist's Vellum", amount = 9, itemID = 245880 },
                { name = "Mote of Wild Magic", amount = 3, itemID = 236951 },
            },
            note = "Learn new recipes from the trainer, craft Thalassian Missive of the Peerless, Thalassian Missive of the Quickblade, then 3x more Thalassian Treatise on Inscription.",
            difficulty = "yellow",
        },
        {
            range = "50-100",
            recipe = "Thalassian Treatise on Inscription (Treatise spam)",
            quantity = 70,
            materials = {
                { name = "Munsell Ink", amount = 70, itemID = 245801 },
                { name = "Sienna Ink", amount = 70, itemID = 245805 },
                { name = "Mote of Wild Magic", amount = 70, itemID = 236951 },
            },
            note = "Craft Treatises repeatedly; they grant skill all the way to 100. Crafting the Inscription Treatise has a chance to discover Treatises for other professions (10 total) which also grant skill and are Warbound (mailable to alts). ~70 Treatises total needed, exact number varies with skill-gain luck. Buying inks from the AH is usually cheaper than crafting them yourself.",
            difficulty = "yellow",
            isRecommended = true,
        },
        {
            range = "91-97",
            recipe = "Weapon Crafting Orders (optional, last few points)",
            quantity = 3,
            materials = {},
            note = "If Treatise skill gains slow down near the end, and you've unlocked a weapon recipe (Aln'hara Cane/Pikestaff/Lantern/Sprigshot) via the Blueprints specialization, complete 1-3 Crafting Orders for them instead — each gives 3 skill points. These need a Spark (BoP, one every 2 weeks), so you must use Crafting Orders rather than crafting them yourself. Good stopping/checkpoint levels are 91, 94, or 97.",
            difficulty = "green",
        },
    },

    knowledgeOverview = "Inscription Knowledge comes from one-time treasures (usually 8×3 KP) and weekly sources such as Patron Orders, a trainer quest, zone drops, an Inscription treatise, and the monthly Darkmoon Faire. Check each row below for details.",

    knowledgeCatchUp = "If you start late or miss weeks, Patron Orders can grant catch-up knowledge until you are back on pace.",

    treasures = {
        { id = "songwriters_pen", name = "Songwriter's Pen", zone = "Silvermoon City", mapID = 2393, x = 47.7, y = 50.4, questID = 89073, description = "On top of the building behind the Alchemy trainer.", kp = 3 },
        { id = "songwriters_quill", name = "Songwriter's Quill", zone = "Eversong Woods", mapID = 2395, x = 40.3, y = 61.2, questID = 89074, description = "Inside the building.", kp = 3 },
        { id = "spare_ink", name = "Spare Ink", zone = "Eversong Woods", mapID = 2395, x = 48.3, y = 75.6, questID = 89069, description = "Eversong Woods.", kp = 3 },
        { id = "half_baked_techniques", name = "Half-Baked Techniques", zone = "Eversong Woods", mapID = 2395, x = 39.3, y = 45.4, questID = 89072, description = "Eversong Woods.", kp = 3 },
        { id = "leather_bound_techniques", name = "Leather-Bound Techniques", zone = "Zul'Aman", mapID = 2437, x = 40.5, y = 49.4, questID = 89068, description = "Inside the cave.", kp = 3 },
        { id = "leftover_sanguithorn_pigment", name = "Leftover Sanguithorn Pigment", zone = "Harandar", mapID = 2413, x = 52.7, y = 50.0, questID = 89071, description = "Harandar.", kp = 3 },
        { id = "intrepid_explorers_marker", name = "Intrepid Explorer's Marker", zone = "Harandar", mapID = 2413, x = 52.4, y = 52.6, questID = 89070, description = "Up on the roots.", kp = 3 },
        { id = "void_touched_quill", name = "Void-Touched Quill", zone = "Voidstorm (Slayer's Rise)", mapID = 2444, x = 60.7, y = 84.3, questID = 89067, description = "Inside the building.", kp = 3 },
    },

}