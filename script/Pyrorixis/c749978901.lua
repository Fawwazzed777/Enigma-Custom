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
	e1:SetCost(Cost.PayLP(800))
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={0x7f3}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then exc=e:GetHandler() end
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() and chkc~=exc end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,exc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,exc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local is_apply = not e:IsHasType(EFFECT_TYPE_ACTIVATE)
	if is_apply then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		if #g>0 then
			tc=g:Select(tp,1,1,nil):GetFirst()
		end
	end
	if tc and (is_apply or tc:IsRelateToEffect(e)) then
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			--RECAST
			local rc = re and re:GetHandler()
			if is_apply and rc and rc:IsSetCard(0x7f3) and rc:IsType(TYPE_MONSTER) then
				Duel.BreakEffect()
				Duel.Damage(1-tp,800,REASON_EFFECT)
			end
		end
	end
end