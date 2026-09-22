-- Artisan's Codex - Knowledge.lua
local _, private = ...
private.Knowledge = {}
local Knowledge = private.Knowledge

function Knowledge:Initialize()
    private:Print("Knowledge module loaded")
end

function Knowledge:Show(parentFrame, profession)
    -- Will show treasures + weekly knowledge sources
end

function Knowledge:PinAllMissing(profession)
    private:Print("Pinning missing treasures" .. (profession and (" for " .. profession) or ""))
    -- Future: create map pins
end