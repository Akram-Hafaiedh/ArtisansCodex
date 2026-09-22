-- Artisan's Codex
-- Premium Profession Guides for World of Warcraft: Midnight
-- Init.lua - Bootstrap file

local addonName, private = ...

-- Create the main private table
private.addon = {}
private.addonName = addonName
private.version = "0.1.0-alpha"

-- Debug mode (set to true while developing)
private.debug = true

-- Simple print function that only shows when debug is on
function private:Print(...)
    if private.debug then
        print("|cff00ccff[Artisan's Codex]|r", ...)
    end
end

private:Print("Init.lua loaded - Version " .. private.version)