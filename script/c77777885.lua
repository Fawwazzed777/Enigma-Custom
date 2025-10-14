--Tranquil Trail Through the Glade
function c77777885.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
  --SS
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777885,0))
  e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c77777885.condition)
	e2:SetTarget(c77777885.target)
	e2:SetOperation(c77777885.operation)
	c:RegisterEffect(e2)
end

function c77777885.cfilter(c,tp)
	return c:IsSetCard(0x40c) and c:GetPreviousControler()==tp and c:GetPreviousLocation()==LOCATION_MZONE
end
function c77777885.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77777885.cfilter,1,nil,tp)
end
function c77777885.filter(c,e,tp)
	return c:IsSetCard(0x40c) and c:IsType(TYPE_MONSTER)and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777885.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c77777885.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77777885.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777885.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
    Duel.ConfirmCards(1-tp,g)
	end
end