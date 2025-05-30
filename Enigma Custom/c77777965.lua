--aqueous elementalist
function c77777959.initial_effect(c)
  --Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777959,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c77777959.sptg)
	e1:SetOperation(c77777959.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777959,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CONTROL_CHANGED)
	e2:SetTarget(c77777959.thtg)
	e2:SetOperation(c77777959.thop)
	c:RegisterEffect(e2)
  --steal monster on SS
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77777959,1))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetCondition(c77777959.condition)
	e3:SetTarget(c77777959.target)
	e3:SetOperation(c77777959.activate)
	c:RegisterEffect(e3)
end

function c77777959.thfilter(c)
	return c:IsSetCard(0x40f) and c:IsAbleToHand() and not c:IsCode(77777959)
end
function c77777959.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777959.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777959.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777959.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end



function c77777959.spfilter(c,e,tp)
	return c:IsSetCard(0x40f) and not c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777959.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
		and Duel.IsExistingMatchingCard(c77777959.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77777959.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)<1 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
  if Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)==0 then return end
  Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777959.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end


function c77777959.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetControler()==e:GetHandler():GetOwner()
end
function c77777959.filter(c,e)
	return c:IsAttribute(e:GetHandler():GetAttribute()) and c:IsSetCard(0x40f) and c:IsControlerCanBeChanged() and c:IsFaceup()
end
function c77777959.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777959.filter,tp,0,LOCATION_MZONE,1,nil,e) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c77777959.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c77777959.filter,tp,0,LOCATION_MZONE,1,1,nil,e)
	local tc=g:GetFirst()
	if tc then
		Duel.GetControl(tc,tp)
	end
end
