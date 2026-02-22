-- Enigmation Lord - Void Crisis
Duel.LoadScript("utility_enigma.lua")
local s,id=GetID()
function s.vortex_recipe(sg,e,tp,mg)
    local g=Duel.GetMatchingGroup(function(c) 
        return (c:IsSetCard(0x145) or c:IsSetCard(0x344)) and c:IsFaceup() 
    end,tp,LOCATION_REMOVED,0,nil)
    if #g<5 then return false end    
    local g_rank4=sg:Filter(Card.IsRank,nil,4)
    if #g_rank4~=1 then return false end   
    local other_mats=sg-g_rank4
    return other_mats:All(function(c) return c:IsLevelBelow(4) and c:GetLevel()>0 end)
end

function s.initial_effect(c)
    c:EnableReviveLimit()       
    Vortex.AddProcedure(c,12,s.vortex_recipe)  
    -- Global Check Banishment
    if not s.global_check then
        s.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_REMOVE)
        ge1:SetOperation(s.checkop)
        Duel.RegisterEffect(ge1,0)
    end
end
s.listed_series={0x145,0x344}
function s.splimit(e,c)
    return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_XYZ)
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(0,111166660,RESET_PHASE+PHASE_END,0,1)
    Duel.RegisterFlagEffect(1,111166660,RESET_PHASE+PHASE_END,0,1)
end