--Shadow Beast Possesion
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0xabc9}
function s.filter(c)
	return c:IsSetCard(0xabc9) and c:IsAbleToDeckAsCost()
end
function s.cfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function s.get_count(g)
	if #g==0 then return 0 end
	local ret=0
	repeat
		local tc=g:GetFirst()
		g:RemoveCard(tc)
		local ct1=#g
		g:Remove(Card.IsCode,nil,tc:GetCode())
		local ct2=#g
		local c=ct1-ct2+1
		if c>ret then ret=c end
	until #g==0 or #g<=ret
	return ret
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	local ct=s.get_count(g)
	e:SetLabel(ct) 
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) and ct==2 or ct==3 and ep~=tp 
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsOnField() and rc:IsRelateToEffect(re) and rc:IsAbleToChangeControler() then
		Duel.BreakEffect()
		Duel.GetControl(rc,tp)
		-- Treated as a "Shadow Beast" monster
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_SETCODE)
		e1:SetValue(0xabc9)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1)
		-- Cannot declare an attack
		local e2=e1:Clone()
		e2:SetDescription(3206)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		rc:RegisterEffect(e2)
end
end
		