--Super Frightfur Fusion
local s,id=GetID()
function s.initial_effect(c)
	--Fusion
	local e1=Fusion.CreateSummonEff{handler=c,fusfilter=aux.FilterBoolFunction(Card.IsSetCard,0xad),matfilter=Fusion.OnFieldMat,extrafil=s.fextra,extratg=s.extratg}
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
	--add setcode
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetValue(0xad)
	c:RegisterEffect(e2)

end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup),tp,0,LOCATION_ONFIELD,nil)
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
