--Pyrorixis Ignition
local s,id=GetID()
function s.initial_effect(c)
	--Destroy 1 card
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={0x7f3}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and Duel.Destroy(tc,REASON_EFFECT)>0 then
		--If this effect was used by a "Pyrorixis" monster
		if re and re:GetHandler():IsSetCard(0x7f3) and re:GetHandler():IsType(TYPE_MONSTER) then
			Duel.Damage(1-tp,500,REASON_EFFECT)
		end
	end
end