-- Midnight Inscription specialization guide

local _, private = ...
private.SpecGuideData = private.SpecGuideData or {}

private.SpecGuideData.Inscription = {
    trees = {
        { key = "blueprints", name = "Blueprints", unlockSkill = 25,
          summary = "Weapons (staves, bows, off-hands) and profession tools." },
        { key = "calm_hands", name = "Calm Hands", unlockSkill = 25,
          summary = "Crafting stats for all Inscription + Treatise recipe / bonus KP." },
        { key = "perfected_products", name = "Perfected Products", unlockSkill = 50,
          summary = "Processing (milling/inks) and Parchment (missives, contracts, vantus)." },
        { key = "darkmoon", name = "Darkmoon Curiosity", unlockSkill = 75,
          summary = "Darkmoon cards, trinkets, sigil embellishments." },
    },
    builds = {
        {
            key = "reagents",
            name = "Reagents",
            goal = "Inks, milling, parchment quality",
            summary = "Strong AH demand. Calm Hands first for Treatise, then Perfected Products.",
            steps = {
                { tree = "Calm Hands", node = "Calm Hands (root)", points = 20, note = "Treatise unlock + baseline stats" },
                { tree = "Perfected Products", node = "Processing", points = 20, note = "Milling / inks / ciphers quality" },
                { tree = "Perfected Products", node = "Parchment", points = 20, note = "Missives, contracts, vantus" },
                { tree = "Calm Hands", node = "Calm Hands (root)", points = 20, note = "Finish root for treatise bonus KP" },
            },
        },
        {
            key = "weapons_tools",
            name = "Weapons & Tools",
            goal = "Crafting orders for weapons and profession gear",
            summary = "Blueprints for staves/bows/tools; still take Calm Hands early.",
            steps = {
                { tree = "Calm Hands", node = "Calm Hands (root)", points = 15, note = "Treatise + stats" },
                { tree = "Blueprints", node = "Blueprints (root)", points = 20, note = "Open Field Research / tool paths" },
                { tree = "Blueprints", node = "Staves / Bows / Tools", points = 30, note = "Specialize in the slots you craft" },
            },
        },
        {
            key = "darkmoon",
            name = "Darkmoon Cards",
            goal = "Cards & trinkets",
            summary = "Later-game; unlock Darkmoon Curiosity after core stats.",
            steps = {
                { tree = "Calm Hands", node = "Calm Hands (root)", points = 20, note = "Baseline" },
                { tree = "Darkmoon Curiosity", node = "Darkmoon Curiosity", points = 30, note = "Open suits (Rot / Blood / Hunt / Void)" },
                { tree = "Darkmoon Curiosity", node = "Inscribe / Transcribe", points = 20, note = "Per-suit sub-specs" },
            },
        },
    },
}
