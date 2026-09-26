-- Artisan's Codex - DataLoader.lua
-- Validates profession guide data after TOC loads Leveling/Knowledge/Recipes files

local _, private = ...
private.DataLoader = {}
local DataLoader = private.DataLoader

private.Data = private.Data or {}

function DataLoader:Load()
    private:Print("Loading profession data...")

    private.Data.professions = {
        "Alchemy", "Blacksmithing", "Enchanting", "Engineering",
        "Herbalism", "Inscription", "Jewelcrafting", "Leatherworking",
        "Mining", "Skinning", "Tailoring", "Cooking", "Fishing",
    }

    local loaded, withLeveling, withKnowledge = 0, 0, 0
    for _, name in ipairs(private.Data.professions) do
        local d = private.Data[name]
        if type(d) == "table" then
            loaded = loaded + 1
            local bits = {}
            if type(d.leveling) == "table" and #d.leveling > 0 then
                withLeveling = withLeveling + 1
                bits[#bits + 1] = string.format("leveling=%d", #d.leveling)
            else
                bits[#bits + 1] = "leveling=MISSING"
            end
            if type(d.treasures) == "table" and #d.treasures > 0 then
                withKnowledge = withKnowledge + 1
                bits[#bits + 1] = string.format("treasures=%d", #d.treasures)
            elseif type(d.treasures) == "table" then
                bits[#bits + 1] = "treasures=0"
            else
                bits[#bits + 1] = "treasures=MISSING"
            end
            if type(d.oneTime) == "table" then
                bits[#bits + 1] = string.format("oneTime=%d", #d.oneTime)
            end
            private:Print(name .. ": " .. table.concat(bits, ", "))
        else
            private:Print("|cffff4444" .. name .. " data NOT loaded|r")
        end
    end

    private:Print(string.format(
        "DataLoader ready — %d professions, %d with leveling, %d with treasures",
        loaded, withLeveling, withKnowledge
    ))
end

function DataLoader:GetProfessionList()
    return private.Data.professions
end

function DataLoader:GetProfessionData(professionName)
    return private.Data[professionName]
end

function DataLoader:GetAvailableProfessions()
    local list = {}
    for name, data in pairs(private.Data) do
        if type(data) == "table" and data.name then
            table.insert(list, name)
        end
    end
    table.sort(list)
    return list
end