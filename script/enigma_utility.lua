ENIGMA_PATCH = true

--[[
Add this at the start of all cards that use custom functions
if not ENIGMA_PATCH then Duel.LoadScript("enigma_utility.lua") end
]]

--------------------------------------------
-- Import constants
--------------------------------------------

if not ENIGMA_CONSTANTS_IMPORTED then Duel.LoadScript("enigma_constant.lua") end

if not VORTEX_IMPORTED then Duel.LoadScript("proc_vortex.lua") end

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
REASONS[REASON_DESTROY] = "DESTROY"
REASONS[REASON_RELEASE] = "RELEASE"
REASONS[REASON_TEMPORARY] = "TEMPORARY"
REASONS[REASON_MATERIAL] = "MATERIAL"
REASONS[REASON_SUMMON] = "SUMMON"
REASONS[REASON_BATTLE] = "BATTLE"
REASONS[REASON_EFFECT] = "EFFECT"
REASONS[REASON_COST] = "COST"
REASONS[REASON_ADJUST] = "ADJUST"
REASONS[REASON_LOST_TARGET] = "LOST_TARGET"
REASONS[REASON_RULE] = "RULE"
REASONS[REASON_SPSUMMON] = "SPSUMMON"
REASONS[REASON_DISSUMMON] = "DISSUMMON"
REASONS[REASON_FLIP] = "FLIP"
REASONS[REASON_DISCARD] = "DISCARD"
REASONS[REASON_RDAMAGE] = "RDAMAGE"
REASONS[REASON_RRECOVER] = "RRECOVER"
REASONS[REASON_RETURN] = "RETURN"
REASONS[REASON_FUSION] = "FUSION"
REASONS[REASON_SYNCHRO] = "SYNCHRO"
REASONS[REASON_RITUAL] = "RITUAL"
REASONS[REASON_XYZ] = "XYZ"
REASONS[REASON_REPLACE] = "REPLACE"
REASONS[REASON_DRAW] = "DRAW"
REASONS[REASON_REDIRECT] = "REDIRECT"
REASONS[REASON_EXCAVATE] = "EXCAVATE"
REASONS[REASON_LINK] = "LINK"
REASONS[REASON_REVEAL] = "REVEAL"
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
SUMMON_TYPES[SUMMON_TYPE_NORMAL] = "NORMAL"
SUMMON_TYPES[SUMMON_TYPE_TRIBUTE] = "TRIBUTE"
SUMMON_TYPES[SUMMON_TYPE_GEMINI] = "GEMINI"
SUMMON_TYPES[SUMMON_TYPE_FLIP] = "FLIP"
SUMMON_TYPES[SUMMON_TYPE_SPECIAL] = "SPECIAL"
SUMMON_TYPES[SUMMON_TYPE_FUSION] = "FUSION"
SUMMON_TYPES[SUMMON_TYPE_RITUAL] = "RITUAL"
SUMMON_TYPES[SUMMON_TYPE_SYNCHRO] = "SYNCHRO"
SUMMON_TYPES[SUMMON_TYPE_XYZ] = "XYZ"
SUMMON_TYPES[SUMMON_TYPE_PENDULUM] = "PENDULUM"
SUMMON_TYPES[SUMMON_TYPE_LINK] = "LINK"
SUMMON_TYPES[SUMMON_TYPE_MAXIMUM] = "MAXIMUM"
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


function Duel.RegisterFlagEffectCustom(player, code, reset_flag, property, reset_count, label)
    if not label then label = 0 end
    Debug.Message("Duel.RegisterFlagEffect("..code..")")
    Duel.RegisterFlagEffect(player, code, reset_flag, property, reset_count, label)
end

function Card.RegisterFlagEffectCustom(c, code, reset_flag, property, reset_count, label, desc)
    if not c or not code then return end 
    Duel.RegisterFlagEffect(c:GetControler(), code, reset_flag, property, reset_count, label)
end


--------------------------------------------
