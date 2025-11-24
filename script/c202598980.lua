--Imaginary Force - Gleamdragon
local s,id=GetID()
function s.initial_effect(c)
	--Sp itself
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,{id,0})
	e1:SetCondition(s.con)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.tt)
	e2:SetOperation(s.ot)
	c:RegisterEffect(e2)
end
s.listed_series={0x303}
function s.rvfilter(c)
	return c:IsSetCard(0x303)
end
function s.etfilter(c,e,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.etfilter,1,nil,e,tp) or eg:IsExists(s.etfilter,1,nil,e,1-tp) and c:IsReason(REASON_EFFECT)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
end
--
function s.spfilter(c,e,tp,code)
	return c:IsSetCard(0x303) and not c:IsCode(code)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.rtfilter(c,ft,tp)
	return c:IsFaceup() and c:IsSetCard(0x303) and c:IsAbleToDeck()
end
function s.tt(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local c=e:GetHandler()
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(s.rtfilter,tp,LOCATION_MZONE,0,1,c) and
	Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp):GetHandler():GetCode() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE)
end
function s.ot(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,s.rtfilter,tp,LOCATION_MZONE,0,1,1,c,e,tp):GetFirst()
	local tc1=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetHandler():GetCode()
	if tc and tc1 then
	Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
	Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
end
