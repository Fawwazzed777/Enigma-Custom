--Imaginary Force - Daylight Dragon
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
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.ta)
	e2:SetOperation(s.op)
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

function s.rtfilter(c,e,tp)
	return c:IsFaceup() and c:IsMonster() and c:IsSetCard(0x303) and c:IsAbleToDeck() and c:HasLevel()
		and Duel.IsExistingMatchingCard(s.tfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel())
end
function s.tfilter(c,e,tp,lv)
	return c:IsMonster() and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.ta(e,c,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rtfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end	
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	if #tc>0 then
	if Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)~=0 then
	local sg=Duel.SelectMatchingCard(tp,s.rtfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #sg>0 then
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
end
end
end
