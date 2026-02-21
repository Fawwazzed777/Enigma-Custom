--Enigmation Lord - Void Crisis
Duel.LoadScript("utility_enigma.lua")
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()       
    --Summon Logic
    --Requirement: Total Value 12, Recipe: 1 Rank 4 + 1+ Level 4 or lower
    Vortex.AddProcedure(c,12,s.vortex_recipe)    
    --Anti-Climbing Lock (Floodgate)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(1,1)
    e2:SetTarget(s.splimit)
    c:RegisterEffect(e2)
    --Global Check
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
--Recipe for Void Crisis
function s.vortex_recipe(sg,e,tp,mg)
    --Minimal 5 Enigmation/Phantasm di Banishment
    local g=Duel.GetMatchingGroup(function(c) 
        return (c:IsSetCard(0x145) or c:IsSetCard(0x344)) and c:IsFaceup() 
    end,tp,LOCATION_REMOVED,0,nil)
    if #g<5 then return false end
    local g_rank4= sg:Filter(Card.IsRank,nil,4)
    if #g_rank4~= 1 then return false end   
    local other_mats= sg-g_rank4
    return other_mats:All(function(c) return c:IsLevelBelow(4) and c:GetLevel() > 0 end)
end

--Global Check
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(0,111166660,RESET_PHASE+PHASE_END,0,1)
    Duel.RegisterFlagEffect(1,111166660,RESET_PHASE+PHASE_END,0,1)
end

--Lock (Anti-Climbing)
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    if not (c:IsLocation(LOCATION_EXTRA) or c:IsType(TYPE_EXTRA)) then return false end    
    local tpe=c:GetType()
    local filter_tpe= tpe&(TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK)
    if filter_tpe==0 then return false end 
    return Duel.IsExistingMatchingCard(s.material_filter,sump,LOCATION_MZONE,0,1,nil,filter_tpe)
end

function s.material_filter(c,filter_tpe)
    return c:IsType(TYPE_EXTRA) and c:IsType(filter_tpe)
end