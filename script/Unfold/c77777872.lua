--Psyber-Freefall
function c77777872.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777872,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,77777872)
	e1:SetCost(c77777872.cost)
	e1:SetTarget(c77777872.target)
	e1:SetOperation(c77777872.operation)
	c:RegisterEffect(e1)
end

function c77777872.pfilter3(c)
	return c:IsSetCard(0x40b) and c:IsAbleToDeck() and c:IsFaceup()
end
function c77777872.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c77777872.filter(c)
	return c:IsSetCard(0x40b) and not c:IsCode(77777872) and c:IsAbleToHand()
end
function c77777872.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777872.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777872.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777872.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c77777872.pfilter3,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(77777872,1)) then
      Duel.ConfirmCards(1-tp,g)
      local g2=Duel.SelectMatchingCard(tp,c77777872.pfilter3,tp,LOCATION_REMOVED,0,1,3,nil)
      Duel.SendtoDeck(g2,tp,2,REASON_EFFECT)
    end
	end
end