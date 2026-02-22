ENIGMA_PATCH = true

--[[
Add this at the start of all cards that use custom functions
if not ENIGMA_PATCH then Duel.LoadScript("enigma_utility.lua") end
]]

--------------------------------------------
-- Import constants
--------------------------------------------

if not ENIGMA_CONSTANTS_IMPORTED then Duel.LoadScript("enigma_constants.lua") end

--------------------------------------------
local ATTRIBUTES = {}
ATTRIBUTES[ATTRIBUTE_EARTH] = "EARTH"
ATTRIBUTES[ATTRIBUTE_WATER] = "WATER"
ATTRIBUTES[ATTRIBUTE_FIRE] = "FIRE"
ATTRIBUTES[ATTRIBUTE_WIND] = "WIND"
ATTRIBUTES[ATTRIBUTE_LIGHT] = "LIGHT"
ATTRIBUTES[ATTRIBUTE_DARK] = "DARK"
ATTRIBUTES[ATTRIBUTE_DIVINE] = "DIVINE"
function Auxiliary.DecodeAttribute(attr)
    local out
    for k,v in pairs(ATTRIBUTES) do
        if k&attr==k then
            if out then out = out.."|"..v
            else out = v end
        end
    end
    return out or "NONE"
end

local RACES = {}
RACES[RACE_WARRIOR] = "WARRIOR"
RACES[RACE_SPELLCASTER] = "SPELLCASTER"
RACES[RACE_FAIRY] = "FAIRY"
RACES[RACE_FIEND] = "FIEND"
RACES[RACE_ZOMBIE] = "ZOMBIE"
RACES[RACE_MACHINE] = "MACHINE"
RACES[RACE_AQUA] = "AQUA"
RACES[RACE_PYRO] = "PYRO"
RACES[RACE_ROCK] = "ROCK"
RACES[RACE_WINGEDBEAST] = "WINGEDBEAST"
RACES[RACE_PLANT] = "PLANT"
RACES[RACE_INSECT] = "INSECT"
RACES[RACE_THUNDER] = "THUNDER"
RACES[RACE_DRAGON] = "DRAGON"
RACES[RACE_BEAST] = "BEAST"
RACES[RACE_BEASTWARRIOR] = "BEASTWARRIOR"
RACES[RACE_DINOSAUR] = "DINOSAUR"
RACES[RACE_FISH] = "FISH"
RACES[RACE_SEASERPENT] = "SEASERPENT"
RACES[RACE_REPTILE] = "REPTILE"
RACES[RACE_PSYCHIC] = "PSYCHIC"
RACES[RACE_DIVINE] = "DIVINE"
RACES[RACE_CREATORGOD] = "CREATORGOD"
RACES[RACE_WYRM] = "WYRM"
RACES[RACE_CYBERSE] = "CYBERSE"
RACES[RACE_ILLUSION] = "ILLUSION"
RACES[RACE_CYBORG] = "CYBORG"
RACES[RACE_MAGICALKNIGHT] = "MAGICALKNIGHT"
RACES[RACE_HIGHDRAGON] = "HIGHDRAGON"
RACES[RACE_OMEGAPSYCHIC] = "OMEGAPSYCHIC"
RACES[RACE_CELESTIALWARRIOR] = "CELESTIALWARRIOR"
RACES[RACE_GALAXY] = "GALAXY"
RACES[RACE_YOKAI] = "YOKAI"
function Auxiliary.DecodeRace(race)
    local out
    for k,v in pairs(RACES) do
        if k&race==k then
            if out then out = out.."|"..v
            else out = v end
        end
    end
    return out or "NONE"
end

local REASONS = {}
REASONS[REASON_VORTEX] = "VORTEX"
function Auxiliary.DecodeReason(reason)
    local out
    for k,v in pairs(REASONS) do
        if k&reason==k then
            if out then out = out.."|"..v
            else out = v end
        end
    end
    return out or "NONE"
end

local SUMMON_TYPES = {}
SUMMON_TYPES[SUMMON_TYPE_VORTEX] = "VORTEX"
function Auxiliary.DecodeSummonType(summon)
    local out
    for k,v in pairs(SUMMON_TYPES) do
        if k&summon==k then
            if out then out = out.."|"..v
            else out = v end
        end
    end
    return out or "NONE"
end
--------------------------------------------
-- Import modules
--------------------------------------------

if not VORTEX_IMPORTED then Duel.LoadScript("proc_vortex.lua") end

--------------------------------------------
