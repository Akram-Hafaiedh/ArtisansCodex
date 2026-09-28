-- Midnight Skinning — Leveling (+ meta)
local _, private = ...
private.Data = private.Data or {}
private.Data.Skinning = private.Data.Skinning or {}
local P = private.Data.Skinning

P.name = "Skinning"

P.icon = "Interface\\Icons\\INV_Misc_Pelt_Wolf_01"

P.isGathering = true

P.overview = "Midnight Skinning has no more refining -- what you skin is what you get. Skill comes from skinning beasts as you level your character; High Value Beasts (marked on the minimap) give bonus leather. Pairs best with Leatherworking."

P.trainer = {

        name = "Tyn",

        zone = "Silvermoon City",

        mapID = 2393,

        x = 47.0,
        y = 58.0,

        note = "Artisan Skinner's Moxie is the profession-specific currency for Skinning unlocks.",

    }

P.leveling = {

        {

            range = "1-100",

            recipe = "Skin everything you kill",

            quantity = 0,

            reagents = {},

            note = "There's no dedicated skinning grind route -- skill comes naturally from skinning mobs while questing/leveling your character. Watch for the skinning-knife icon on the minimap (High Value Beasts) for bonus leather, and throw a Diffuser at a mob before killing it to also collect Motes.",

            difficulty = "orange",

            isRecommended = true,

        },

    }

P.materials = {

        { name = "Void-Tempered Leather", source = "Leather mobs" },

        { name = "Void-Tempered Scales", source = "Scale mobs" },

        { name = "Void-Tempered Hide", source = "Rare mobs, Sharpen Your Knife, lure beasts" },

        { name = "Void-Tempered Plating", source = "Rare scale mobs, Sharpen Your Knife, lure beasts" },

        { name = "Fantastic Fur", source = "Furred creatures" },

        { name = "Peerless Plumage", source = "Feathered creatures" },

        { name = "Carving Canine", source = "Fanged creatures" },

        { name = "Majestic Claw / Hide / Fin", source = "Renowned Beasts (lure system)" },

    }

P.diffusers = {

        { name = "Lightbloom Diffuser", cost = "2x Mote of Light", drops = "1-4 Mote of Light" },

        { name = "Wild Diffuser", cost = "2x Mote of Wild Magic", drops = "1-4 Mote of Wild Magic" },

        { name = "Primal Diffuser", cost = "2x Mote of Primal Energy", drops = "1-4 Mote of Primal Energy" },

        { name = "Void Diffuser", cost = "2x Mote of Pure Void", drops = "1-4 Mote of Pure Void" },

    }

P.equipment = {

        { name = "Skinner's Cap", craftedBy = "Leatherworking" },

        { name = "Skinner's Backpack", craftedBy = "Leatherworking" },

        { name = "Thalassian Skinning Knife", craftedBy = "Blacksmithing" },

        { name = "Sun-Blessed Skinning Knife", craftedBy = "Blacksmithing" },

    }

