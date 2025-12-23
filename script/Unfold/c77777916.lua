--Dragoscendent Pair
function c77777916.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77777916+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c77777916.target)
	e1:SetOperation(c77777916.activate)
	c:RegisterEffect(e1)
end
function c77777916.revfilter(c)
	return c:IsSetCard(0x40d) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c77777916.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777916.revfilter,tp,LOCATION_HAND,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,1,0,0)
end
function c77777916.filter(c)
	return c:IsSetCard(0x40d) and c:IsAbleToHand()
end
function c77777916.activate(e,tp,eg,ep,ev,re,r,rp)
  --Checks to see that there is still another monster in your hand, and selects it.
	if not Duel.IsExistingMatchingCard(c77777916.revfilter,tp,LOCATION_HAND,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c77777916.revfilter,tp,LOCATION_HAND,0,1,1,nil)
  --Reveals it and raises event to tell other cards they have been revealed
	Duel.ConfirmCards(1-tp,g)
	Duel.RaiseSingleEvent(g:GetFirst(),77777900,e,REASON_EFFECT,tp,tp,0)
	Duel.ShuffleHand(tp)
  if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
  local p=tp
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c77777916.filter,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		Duel.ShuffleDeck(p)
	end
end