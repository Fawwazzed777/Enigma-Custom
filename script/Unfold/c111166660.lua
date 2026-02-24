--Enigmation Lord - Void Crisis
--scripted by fawwazzed
if not ENIGMA_PATCH then Duel.LoadScript("enigma_utility.lua") end
if not VORTEX_IMPORTED then Duel.LoadScript("proc_vortex.lua") end
local s,id=GetID()
--Material Logic
function s.vortex_recipe(sg,e,tp,mg)
    if not e then return true end
    local p = tp or e:GetHandlerPlayer()
    if not p then return false end
    local g=Duel.GetMatchingGroup(function(c) 
        return (c:IsSetCard(0x145) or c:IsSetCard(0x344)) and c:IsFaceup() 
    end,p,LOCATION_REMOVED,0,nil)   
    if #g<5 then return false end           
    --Rank 4
    local g_rank4=sg:Filter(Card.IsRank,nil,4)
    if #g_rank4~=1 then return false end     
    --Level 4 or lower
    local other_mats=sg-g_rank4
    local count_valid = other_mats:FilterCount(function(c) 
        return (c:GetLevel()>0 and c:IsLevelBelow(4))end,nil)  
    return count_valid == #other_mats
end
function s.initial_effect(c)
    c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	--Vortex Procedure
    Vortex.AddProcedure(c,12,s.vortex_recipe)
	--Level/Rank Cover
	local es=Effect.CreateEffect(c)
	es:SetType(EFFECT_TYPE_SINGLE)
	es:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	es:SetRange(LOCATION_ALL)
	es:SetCode(EFFECT_CHANGE_LEVEL)
	es:SetValue(8)
	c:RegisterEffect(es)
	local er=Effect.CreateEffect(c)
	er:SetType(EFFECT_TYPE_SINGLE)
	er:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	er:SetCode(EFFECT_XYZ_LEVEL)
	er:SetValue(function(e,c) return 4 end)
	c:RegisterEffect(er)
    --Anti-Climbing Lock
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(1,1)
    e1:SetTarget(s.splimit)
    c:RegisterEffect(e1)
	--Banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
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

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
    Duel.RegisterFlagEffect(1,id,RESET_PHASE+PHASE_END,0,1)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())    
    if #g>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local tg=g:Select(tp,1,2,nil)
        if #tg>0 then
            Duel.HintSelection(tg)
            Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
        end
    end
end
