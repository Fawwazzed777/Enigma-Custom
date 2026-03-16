--Eternity Ace - Chrono Drive Dragon
--scripted by fawwazzed
if not ENIGMA_PATCH then Duel.LoadScript("enigma_utility.lua") end
if not VORTEX_IMPORTED then Duel.LoadScript("proc_vortex.lua") end
local s,id=GetID()
s.Vortex=true
--Material Logic
function s.initial_effect(c)
	--Vortex Procedure
    local f1=function(tc,sc,tp) return tc:IsType(TYPE_XYZ) and tc:IsRank(4) and c:IsSetCard(0x994) end
    local f2=function(tc,sc,tp) return not tc:IsType(TYPE_XYZ) and tc:GetLevel()>=0 and tc:IsAttribute(ATTRIBUTE_LIGHT|ATTRIBUTE_DARK) end
    Vortex.AddProcedure(c,f1,f2,nil)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	--Time Leap (Quick Effect)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,{id,0})
    e1:SetCost(s.leapcost)
    e1:SetTarget(s.leaptg)
    e1:SetOperation(s.leapop)
    c:RegisterEffect(e1)
	--Track effect: Special Summon Different Attribute of "Eternity Ace"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_REMOVE)
    e2:SetCountLimit(1,{id,1})
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
end
s.listed_series={0x993,0x994}
function s.leapcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(function(c) 
        return c:IsSetCard(0x994) and c:IsMonster() and c:IsAbleToRemoveAsCost() 
    end,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,function(c) 
        return c:IsSetCard(0x994) and c:IsMonster() and c:IsAbleToRemoveAsCost() 
    end,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.leaptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemove() end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
--Banish itself until End Phase (Time Leap)
function s.leapop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local attr=e:GetLabel() 
    if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
        c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,attr)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        e1:SetLabelObject(c)
        e1:SetOperation(s.retop)
        Duel.RegisterEffect(e1,tp)
    end
end

--Return & Recycle Tech
function s.retop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if Duel.ReturnToField(tc) then
        local g=Duel.GetMatchingGroup(function(c) 
            return c:IsSetCard(0x993) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() 
        end,tp,LOCATION_REMOVED,0,nil)
        if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
            local sg=g:Select(tp,1,1,nil)
            Duel.SSet(tp,sg)
        end
    end
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then 
        local attr=c:GetFlagEffectLabel(id) or 0
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,attr) 
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.spfilter(c,e,tp,attr)
    return c:IsSetCard(0x994) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and (attr==0 or not c:IsAttribute(attr))
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    local attr=c:GetFlagEffectLabel(id) or 0
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,attr)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end