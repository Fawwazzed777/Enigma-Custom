--March of the Dinoriders
function c77777806.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77777806)
	e1:SetTarget(c77777806.target)
	e1:SetOperation(c77777806.activate)
	c:RegisterEffect(e1)
	
end


function c77777806.filter(c)
	return c:IsRace(RACE_DINOSAUR) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeck()
		and c:IsType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c77777806.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c77777806.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,nil,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,nil)
end
function c77777806.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77777806.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	if g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,2,5,nil)
	local count=sg:GetCount()
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	if sg:IsExists(Card.IsLocation,count,nil,LOCATION_DECK+LOCATION_EXTRA) then
		Duel.BreakEffect()
		Duel.Draw(tp,count-1,REASON_EFFECT)
	end
end
