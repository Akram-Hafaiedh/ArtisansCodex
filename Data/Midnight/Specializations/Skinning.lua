-- Midnight Skinning specialization guide
-- Trees: live export 2026-10-01 (Debug -> Specs). Builds: guide-style defaults.
-- Profession: Skinning  variantID=2917  configID=54079696

local _, private = ...
private.SpecGuideData = private.SpecGuideData or {}

private.SpecGuideData.Skinning = {
    variantID = 2917,
    trees = {
        {
            key = "thorough_tanning",
            name = "Thorough Tanning",
            tabID = 1120,
            rootNodeID = 106089,
            maxKP = 120,
            unlockSkill = 25,
            summary = "General skinning skill, Sharpen Your Knife, leather vs scale focus.",
            paths = {
                { pathID = 106089, name = "Thorough Tanning", maxKP = 40 },
                { pathID = 106088, name = "Lasting Leather", maxKP = 40 },
                { pathID = 106087, name = "Superb Scales", maxKP = 40 },
            },
            notableRecipes = {
                { name = "Sharpen Your Knife", spellID = 1223388 },
            },
        },
        {
            key = "gainful_gathering",
            name = "Gainful Gathering",
            tabID = 1119,
            rootNodeID = 106059,
            maxKP = 160,
            unlockSkill = 25,
            summary = "Species reagents, meat (Carve Meat), trophies, and zone diffusers.",
            paths = {
                { pathID = 106059, name = "Gainful Gathering", maxKP = 40 },
                { pathID = 106058, name = "Careful Carving", maxKP = 40 },
                { pathID = 106057, name = "Trophy Taker", maxKP = 40 },
                { pathID = 106056, name = "Dedicated Diffuser", maxKP = 40 },
            },
            notableRecipes = {
                { name = "Carve Meat", spellID = 1226037 },
                { name = "Lightbloom Diffuser", spellID = 1225939 },
                { name = "Wild Diffuser", spellID = 1225941 },
                { name = "Primal Diffuser", spellID = 1225940 },
                { name = "Void Diffuser", spellID = 1225942 },
            },
        },
        {
            key = "talented_tracker",
            name = "Talented Tracker",
            tabID = 1121,
            rootNodeID = 106119,
            maxKP = 120,
            unlockSkill = 25,
            summary = "Renowned Beast lures and higher yields from elite skins.",
            paths = {
                { pathID = 106119, name = "Talented Tracker", maxKP = 40 },
                { pathID = 106118, name = "Majestic Materials", maxKP = 40 },
                { pathID = 106117, name = "Component Collector", maxKP = 40 },
            },
            notableRecipes = {
                { name = "Majestic Eversong Lure", spellID = 1225943 },
                { name = "Majestic Zul'Aman Lure", spellID = 1225944 },
                { name = "Majestic Harandar Lure", spellID = 1225945 },
                { name = "Majestic Voidstorm Lure", spellID = 1225946 },
                { name = "Grand Beast Lure", spellID = 1225948 },
            },
        },
    },
    builds = {
        {
            key = "baseline",
            name = "Baseline Skinner",
            goal = "General skill and guaranteed hides",
            summary = "Thorough Tanning root, Sharpen charges, then leather or scale.",
            steps = {
                { tree = "Thorough Tanning", node = "Thorough Tanning", pathID = 106089, points = 20,
                  note = "Skill + Sharpen Your Knife" },
                { tree = "Thorough Tanning", node = "Lasting Leather", pathID = 106088, points = 15,
                  note = "Leathery creatures (or Superb Scales for scales)" },
                { tree = "Gainful Gathering", node = "Gainful Gathering", pathID = 106059, points = 10,
                  note = "Species reagents + meat chance" },
            },
        },
        {
            key = "meat_trophies",
            name = "Meat & Trophies",
            goal = "Carve Meat, species reagents, Radiant Stomach",
            summary = "Gainful Gathering into Careful Carving and Trophy Taker.",
            steps = {
                { tree = "Gainful Gathering", node = "Gainful Gathering", pathID = 106059, points = 15,
                  note = "Open specialty gathering" },
                { tree = "Gainful Gathering", node = "Careful Carving", pathID = 106058, points = 15,
                  note = "Carve Meat ability" },
                { tree = "Gainful Gathering", node = "Trophy Taker", pathID = 106057, points = 15,
                  note = "Species-specific reagents" },
                { tree = "Thorough Tanning", node = "Thorough Tanning", pathID = 106089, points = 10,
                  note = "Baseline skinning skill" },
            },
        },
        {
            key = "renowned",
            name = "Renowned Beasts",
            goal = "Lures and elite skin yields",
            summary = "Talented Tracker for zone lures and Majestic Materials.",
            steps = {
                { tree = "Talented Tracker", node = "Talented Tracker", pathID = 106119, points = 20,
                  note = "Zone lures + Grand Beast Lure" },
                { tree = "Talented Tracker", node = "Majestic Materials", pathID = 106118, points = 15,
                  note = "Unique Renowned Beast mats" },
                { tree = "Talented Tracker", node = "Component Collector", pathID = 106117, points = 10,
                  note = "More basic leather/scale from elites" },
            },
        },
        {
            key = "diffusers",
            name = "Diffusers",
            goal = "Zone diffuser tools",
            summary = "Dedicated Diffuser for Lightbloom / Wild / Primal / Void tools.",
            steps = {
                { tree = "Gainful Gathering", node = "Gainful Gathering", pathID = 106059, points = 10,
                  note = "Open tree" },
                { tree = "Gainful Gathering", node = "Dedicated Diffuser", pathID = 106056, points = 20,
                  note = "All four diffuser types + yield" },
                { tree = "Thorough Tanning", node = "Thorough Tanning", pathID = 106089, points = 10,
                  note = "Baseline skill" },
            },
        },
    },
}