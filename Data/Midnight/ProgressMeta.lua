-- Artisan's Codex - Midnight progress meta (currencies, gathering quests)
-- Currency / skill-line IDs aligned with community trackers (WeeklyKnowledge et al.)
-- Used by Core progress scans for concentration, catch-up, gathering, first-craft scaffolding.

local _, private = ...

private.ProgressMeta = private.ProgressMeta or {}

-- skillLineID = base profession line (GetProfessionInfo)
-- variantID   = Midnight expansion skill line variant (C_TradeSkillUI)
-- catchUpCurrencyID = hidden weekly KP tracker currency
-- concentrationCurrencyID = concentration (0 = N/A for gathering)
-- catchUpItemID = Flicker / gathering catch-up item
-- moxieCurrencyID = Artisan <Profession>'s Moxie (spendable)
private.ProgressMeta.professions = {
    Alchemy = {
        skillLineID = 171,
        variantID = 2906,
        catchUpCurrencyID = 3189,
        concentrationCurrencyID = 3161,
        catchUpItemID = 246320,
        moxieCurrencyID = 3256,
    },
    Blacksmithing = {
        skillLineID = 164,
        variantID = 2907,
        catchUpCurrencyID = 3199,
        concentrationCurrencyID = 3162,
        catchUpItemID = 246322,
        moxieCurrencyID = 3257,
    },
    Enchanting = {
        skillLineID = 333,
        variantID = 2909,
        catchUpCurrencyID = 3198,
        concentrationCurrencyID = 3163,
        catchUpItemID = 267653,
        moxieCurrencyID = 3258,
        -- weekly disenchanting / gathering-style knowledge drops
        gatheringQuests = { 95048, 95049, 95050, 95051, 95052, 95053 },
    },
    Engineering = {
        skillLineID = 202,
        variantID = 2910,
        catchUpCurrencyID = 3197,
        concentrationCurrencyID = 3164,
        catchUpItemID = 246326,
        moxieCurrencyID = 3259,
    },
    Herbalism = {
        skillLineID = 182,
        variantID = 2912,
        catchUpCurrencyID = 3196,
        concentrationCurrencyID = 0,
        catchUpItemID = 238467,
        moxieCurrencyID = 3260,
        gatheringQuests = { 81425, 81426, 81427, 81428, 81429, 81430 },
    },
    Inscription = {
        skillLineID = 773,
        variantID = 2913,
        catchUpCurrencyID = 3195,
        concentrationCurrencyID = 3165,
        catchUpItemID = 246328,
        moxieCurrencyID = 3261,
    },
    Jewelcrafting = {
        skillLineID = 755,
        variantID = 2914,
        catchUpCurrencyID = 3194,
        concentrationCurrencyID = 3166,
        catchUpItemID = 246330,
        moxieCurrencyID = 3262,
    },
    Leatherworking = {
        skillLineID = 165,
        variantID = 2915,
        catchUpCurrencyID = 3193,
        concentrationCurrencyID = 3167,
        catchUpItemID = 246332,
        moxieCurrencyID = 3263,
    },
    Mining = {
        skillLineID = 186,
        variantID = 2916,
        catchUpCurrencyID = 3192,
        concentrationCurrencyID = 0,
        catchUpItemID = 237507,
        moxieCurrencyID = 3264,
        gatheringQuests = { 88673, 88674, 88675, 88676, 88677, 88678 },
    },
    Skinning = {
        skillLineID = 393,
        variantID = 2917,
        catchUpCurrencyID = 3191,
        concentrationCurrencyID = 0,
        catchUpItemID = 238627,
        moxieCurrencyID = 3265,
        gatheringQuests = { 88534, 88549, 88537, 88536, 88530, 88529 },
    },
    Tailoring = {
        skillLineID = 197,
        variantID = 2918,
        catchUpCurrencyID = 3190,
        concentrationCurrencyID = 3168,
        catchUpItemID = 246334,
        moxieCurrencyID = 3266,
    },
    -- Cooking / Fishing: no Midnight KP tracker currencies in the same system
    Cooking = {
        skillLineID = 185,
        variantID = nil,
        catchUpCurrencyID = 0,
        concentrationCurrencyID = 0,
        catchUpItemID = 0,
        moxieCurrencyID = 0,
    },
    Fishing = {
        skillLineID = 356,
        variantID = nil,
        catchUpCurrencyID = 0,
        concentrationCurrencyID = 0,
        catchUpItemID = 0,
        moxieCurrencyID = 0,
    },
}

-- Lookup by base skillLineID
private.ProgressMeta.bySkillLineID = {}
for name, meta in pairs(private.ProgressMeta.professions) do
    if meta.skillLineID then
        private.ProgressMeta.bySkillLineID[meta.skillLineID] = meta
        meta.name = name
    end
end

--- All catch-up + concentration currency IDs we care about
function private.ProgressMeta:GetTrackedCurrencyIDs()
    local ids = {}
    for _, meta in pairs(self.professions) do
        if meta.catchUpCurrencyID and meta.catchUpCurrencyID > 0 then
            ids[meta.catchUpCurrencyID] = meta
        end
        if meta.concentrationCurrencyID and meta.concentrationCurrencyID > 0 then
            ids[meta.concentrationCurrencyID] = meta
        end
    end
    return ids
end