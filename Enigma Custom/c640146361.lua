--The Enigmatic Overlord
local s,id=GetID()
function s.initial_effect(c)
	c:AddSetcodesRule(id,false,0x601)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(s.reptg)
	c:RegisterEffect(e2)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.RemoveCards(e:GetHandler())
		local token=Duel.CreateToken(tp,96488223)
		Duel.MoveToField(token,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		Duel.BreakEffect()
		token:CompleteProcedure()
	local rd=Duel.IsExistingMatchingCard(nil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,96488223)	
	if rd then
	local tc=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_MZONE,0,1,1,nil,96488223):GetFirst()
	local rd=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,2,nil)
	if tc and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
	if Duel.HintSelection(tc)~=0 then
	Duel.Overlay(tc,rd)
		return true
	else return false end
end
end
end
end

