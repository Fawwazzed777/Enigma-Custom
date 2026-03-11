--Nadir Dragon Vitra
--scripted by fawwazzed
if not ENIGMA_PATCH then Duel.LoadScript("enigma_utility.lua") end
if not VORTEX_IMPORTED then Duel.LoadScript("proc_vortex.lua") end
local s,id=GetID()
--Material Logic
function s.vortex_recipe(sg,e,tp,mg)
    --Rank 4
    local g_rank4=sg:Filter(function(c) return c:IsType(TYPE_XYZ) and c:IsRank(4) end, nil)
    if #g_rank4~=1 then return false end    
    --Level 4 or lower    
    local other_mats=sg:Clone()
    other_mats:Sub(g_rank4)
    if #other_mats==0 then return false end   
    local count_valid=other_mats:FilterCount(function(c) return c:GetLevel()>0 and c:IsLevelBelow(4)end,nil)    
    return count_valid==#other_mats
end
function s.initial_effect(c)
    --VORTEX SUMMON
    Vortex.AddProcedure(c,8,s.vortex_recipe)           
    --Gain ATK(Non-Xyz)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,{id,0})
    e1:SetCondition(s.atkcon)
    e1:SetTarget(s.atktg)
    e1:SetOperation(s.atkop)
    c:RegisterEffect(e1)
	--Send to GY
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.gcon)
	e2:SetTarget(s.gtg)
	e2:SetOperation(s.gop)
	c:RegisterEffect(e2)
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetSummonType()==SUMMON_TYPE_VORTEX
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    local filter=function(tc)
        return tc:IsLocation(LOCATION_GRAVE) 
            and (tc:GetTextAttack()>0 or tc:GetTextDefense()>0) 
            and not tc:IsType(TYPE_XYZ)
    end
    if chkc then return filter(chkc) end
    if chk==0 then return tc and tc :IsExists(filter,1,nil) end         
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=tc:FilterSelect(tp,filter,1,1,nil)
    Duel.SetTargetCard(g)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsRelateToEffect(e) then
        local val=math.max(tc:GetTextAttack(),tc:GetTextDefense())
        if val<=0 then return end        
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(val)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        c:RegisterEffect(e1)
    end
end

function s.gcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end

function s.gtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
end

function s.gop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end