-- Artisan's Codex - DataLoader.lua
-- Responsible for loading profession guide data

local _, private = ...
private.DataLoader = {}
local DataLoader = private.DataLoader

-- This table will hold all guide data
private.Data = private.Data or {
    professions = {},
    leveling = {},
    specializations = {},
    treasures = {},
}

function DataLoader:Load()
    private:Print("Loading profession data...")

    -- List of professions we will support
    private.Data.professions = {
        "Alchemy",
        "Blacksmithing",
        "Enchanting",
        "Engineering",
        "Herbalism",
        "Inscription",
        "Jewelcrafting",
        "Leatherworking",
        "Mining",
        "Skinning",
        "Tailoring",
        "Cooking",
        "Fishing",
    }

    local loaded = 0
    if private.Data.Alchemy then
        loaded = loaded + 1
        private:Print("Alchemy data loaded")
    end
    if private.Data.Tailoring then
        loaded = loaded + 1
        private:Print("Tailoring data loaded")
    end


    private:Print("DataLoader ready - " .. loaded .. " guide(s) loaded, " ..
                  #private.Data.professions .. " professions registered")
end

function DataLoader:GetProfessionList()
    return private.Data.professions
end

function DataLoader:GetProfessionData(professionName)
    return private.Data[professionName]
end


function DataLoader:GetAvailableProfessions()
    local list = {}
    for name, _ in pairs(private.Data) do
        if type(private.Data[name]) == "table" and private.Data[name].name then
            table.insert(list, name)
        end
    end
    table.sort(list)
    return list
end