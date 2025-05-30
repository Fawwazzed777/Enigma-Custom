--Dragoscendent Pair
function c77777907.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77777907+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c77777907.target)
	e1:SetOperation(c77777907.activate)
	c:RegisterEffect(e1)
end
function c77777907.revfilter(c)
	return c:IsSetCard(0x40d) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c77777907.filter(c,code)
	return c:IsSetCard(0x40d) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and c:IsAbleToHand()
end
function c77777907.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777907.revfilter,tp,LOCATION_HAND,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,1,0,0)
end
function c77777907.activate(e,tp,eg,ep,ev,re,r,rp)
  --Checks to see that there is still another monster in your hand, and selects it.
	if not Duel.IsExistingMatchingCard(c77777907.revfilter,tp,LOCATION_HAND,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c77777907.revfilter,tp,LOCATION_HAND,0,1,1,nil)
  --Reveals it and raises event to tell other cards they have been revealed
	Duel.ConfirmCards(1-tp,g)
	Duel.RaiseSingleEvent(g:GetFirst(),77777900,e,REASON_EFFECT,tp,tp,0)
	Duel.ShuffleHand(tp)
  if Duel.IsExistingMatchingCard(c77777907.filter,tp,LOCATION_DECK,0,1,nil,code)then
    Duel.BreakEffect()
    --Adds cards to hand
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77777907.filter,tp,LOCATION_DECK,0,1,1,nil,code)
    if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  end
end