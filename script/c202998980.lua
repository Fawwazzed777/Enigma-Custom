--Enigmation Force - Disaster Hawk
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(s.ffilter),4,2,nil,nil,Xyz.InfiniteMats)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(Cost.DetachFromSelf(1,1,nil))
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={0x303,0x344}
function s.ffilter(c,fc,sumtype,tp)
	return c:IsSetCard(0x303) or c:IsSetCard(0x344)
end
function s.banish(c,tp)
	return c:IsFaceup() and (c:IsSetCard(0x303) or c:IsSetCard(0x344))
end
function s.rfilter(c)
	return c:IsLocation(LOCATION_REMOVED)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.banish,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(s.banish,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.banish,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and tc:IsSetCard(0x303) then
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
		if sg then
		if Duel.SendtoDeck(sg,1,nil,REASON_EFFECT)>0 then
		Duel.Draw(1,tp,REASON_EFFECT)
	else if tc:IsSetCard(0x344) then
	local rg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,e:GetHandler())
	local val=Duel.GetMatchingGroupCount(s.dfilter,c:GetControler(),LOCATION_REMOVED,0,nil)*500
	for tc in aux.Next(rg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rg:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		rg:RegisterEffect(e2)
end
end
end
end
end
end
end
