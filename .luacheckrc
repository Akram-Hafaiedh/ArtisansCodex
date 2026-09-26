-- Artisan's Codex — luacheck configuration
-- Docs: https://luacheck.readthedocs.io/en/stable/config.html

std = "lua51"
max_line_length = 500

-- WoW addon files start with:
--   local addonName, private = ...
-- Luacheck treats these as locals and warns if unused. We control the
-- convention per-file with `local _, private = ...` when addonName isn't
-- needed, so no global ignore is applied here.

globals = {
    -- Public addon global (set via `_G[addonName] = addon`)
    "ArtisansCodex",

    -- Slash command registration
    "SLASH_ARTISANSCODEX1",
    "SLASH_ARTISANSCODEX2",
    "SLASH_ARTISANSCODEX3",
    "SlashCmdList",

    -- Blizzard state tables we read and write
    "g_professionsSpecsSelectedTabs",
}

read_globals = {
    -- Saved variables
    "ArtisansCodexDB",

    -- Frame / UI creation
    "CreateFrame",
    "CreateVector2D",
    "UIParent",
    "Minimap",
    "GameTooltip",
    "WorldFrame",

    -- WoW API namespaces
    "C_AddOns",
    "C_CraftingOrders",
    "C_Item",
    "C_Map",
    "C_Professions",
    "C_ProfSpecs",
    "C_SuperTrack",
    "C_Timer",
    "C_TradeSkillUI",

    -- Free functions
    "GetProfessions",
    "GetProfessionInfo",
    "GetItemInfo",
    "GetLocale",
    "ReloadUI",

    -- String / table helpers
    "strtrim",
    "strlower",
    "strupper",
    "strsplit",
    "tinsert",
    "tremove",
    "wipe",

    -- Debug
    "print",
    "DEFAULT_CHAT_FRAME",
}

ignore = {
    "212", -- unused argument (frame callbacks often ignore the frame arg)
}