--Zero Dragon Envil
--scripted by fawwazzed
if not ENIGMA_PATCH then Duel.LoadScript("enigma_utility.lua") end
if not VORTEX_IMPORTED then Duel.LoadScript("proc_vortex.lua") end
local s,id=GetID()
s.Vortex=true
--Material Logic
function s.vortex_recipe(g,e,tp,mg)
	if not e then return true end
    --1 Rank 4 or lower Monster
	if #g==0 then return false end
    local g_rank=g:Filter(function(c) return c:IsType(TYPE_XYZ) and c:GetRank()<=4 end,nil)
    if #g_rank~=1 then return false end 
    --1+ non Rank monsters (Level or Link, essentially non-Xyz)
    local other_mats=g:Clone()
	other_mats:Sub(g_rank)
    if #other_mats==0 then return false end	
    local count_valid=other_mats:FilterCount(function(c) return c:GetLevel()>0 and not c:IsType(TYPE_XYZ) end,nil)
	return count_valid==#other_mats
end
function s.initial_effect(c)
    --VORTEX SUMMON
    Vortex.AddProcedure(c,8,s.vortex_recipe)
    c:EnableReviveLimit()
    --Destroy S/T & Set from opponent GY
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,{id,0})
    e1:SetCondition(s.setcon)
    e1:SetTarget(s.settg)
    e1:SetOperation(s.setop)
    c:RegisterEffect(e1)
    --Destroy self/control & SS from GY
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,{id,1})
    e2:SetTarget(s.sstg)
    e2:SetOperation(s.ssop)
    c:RegisterEffect(e2)
end

function s.setcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_VORTEX
end

--Destroy all S/T then Set
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
    local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
    if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
        --Each player Set 1 from opponent's GY
        for p=0,1 do
            local opp_gy=Duel.GetMatchingGroup(Card.IsType,p,0,LOCATION_GRAVE,nil,TYPE_SPELL+TYPE_TRAP)
            if #opp_gy>0 and Duel.GetLocationCount(p,LOCATION_SZONE)>0 
                and Duel.SelectYesNo(p,aux.Stringid(id,2)) then -- Ask player to Set
                Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SET)
                local sg=opp_gy:Select(p,1,1,nil)
                if #sg>0 then
                    Duel.SSet(p,sg:GetFirst())
                end
            end
        end
    end
end

function s.spfilter(c,e,tp)
    return c:IsVortex() and not c:IsCode(id)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,nil)
            and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) 
    end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.ssop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,1,nil)
    if #dg>0 and Duel.Destroy(dg,REASON_EFFECT)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
        if #sg>0 then
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end