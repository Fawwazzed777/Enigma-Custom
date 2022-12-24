--Seafarer Morale Boost
function c77777937.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77777937)
	e1:SetDescription(aux.Stringid(77777937,0))
	e1:SetTarget(c77777937.target)
	e1:SetOperation(c77777937.activate)
	c:RegisterEffect(e1)
	--Add2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCountLimit(1,77777937+EFFECT_COUNT_CODE_OATH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c77777937.spcon)
	e2:SetTarget(c77777937.target2)
	e2:SetOperation(c77777937.activate2)
	c:RegisterEffect(e2)
end

function c77777937.filter(c)
	return c:IsSetCard(0x999) and c:IsAbleToHand()
end
function c77777937.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777937.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777937.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777937.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c77777937.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and e:GetHandler():IsPreviousPosition(POS_FACEDOWN)
end
function c77777937.spfilter(c,e,tp)
	return c:IsSetCard(0x999) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777937.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777937.filter,tp,LOCATION_DECK,0,1,nil) or (Duel.IsExistingMatchingCard(c77777937.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777937.activate2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.IsExistingMatchingCard(c77777937.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c77777937.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
    local opt1=Duel.SelectOption(tp,aux.Stringid(77777937,0),aux.Stringid(77777937,1))
    if opt1==0 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
      local g=Duel.SelectMatchingCard(tp,c77777937.filter,tp,LOCATION_DECK,0,1,1,nil)
      if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
      end
    else
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      local g=Duel.SelectMatchingCard(tp,c77777937.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
      local tc=g:GetFirst()
      if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
      end
    end
  elseif Duel.IsExistingMatchingCard(c77777937.filter,tp,LOCATION_DECK,0,1,nil) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77777937.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  elseif Duel.IsExistingMatchingCard(c77777937.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)then
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77777937.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
      Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
  end
end