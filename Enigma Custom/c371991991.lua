--Tidal Knight Dragna
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.ta)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
s.listed_names={371991989,id}
function s.exfilter(c,e,tp)
	return c.material and c:IsType(TYPE_FUSION) and Card.ListsCodeAsMaterial(c,371991989)
	and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c) and not c:IsCode(371991989)
end
function s.spfilter(c,e,tp,fc)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(table.unpack(fc.material)) and not c:IsCode(371991989)
end
function s.sgfilter(c,e,tp,fc)
	return c:IsCode(371991989) and c:IsAbleToGrave()
end
function s.ta(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.sgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)	
	and Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #cg==0 then return end
	Duel.ConfirmCards(1-tp,cg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(371991989)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
	local gg=Duel.SelectMatchingCard(tp,s.sgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if #gg>0 then
	if Duel.SendtoGrave(gg,REASON_EFFECT)~=0 then
-->
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,cg:GetFirst())
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
end
end
end
