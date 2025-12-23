--Dragoscendent Hatching
function c77777936.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetDescription(aux.Stringid(77777936,0))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77777936+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c77777936.target)
	e1:SetOperation(c77777936.activate)
	c:RegisterEffect(e1)
  --draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777936,2))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1,77777936)
	e4:SetRange(LOCATION_GRAVE)
  e4:SetCost(c77777936.cost)
	e4:SetTarget(c77777936.shtarget)
	e4:SetOperation(c77777936.shoperation)
	c:RegisterEffect(e4)
end
function c77777936.revfilter(c)
	return c:IsSetCard(0x40d) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c77777936.target(e,tp,eg,ep,ev,re,r,rp,chk)
  local g=Duel.GetMatchingGroup(c77777936.filter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777936.revfilter,tp,LOCATION_HAND,0,1,nil)and g:GetClassCount(Card.GetCode)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,1,0,0)
end
function c77777936.filter(c)
	return c:IsSetCard(0x40d)
end
function c77777936.activate(e,tp,eg,ep,ev,re,r,rp)
  --Checks to see that there is still another monster in your hand, and selects it.
	if not Duel.IsExistingMatchingCard(c77777936.revfilter,tp,LOCATION_HAND,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c77777936.revfilter,tp,LOCATION_HAND,0,1,1,nil)
  --Reveals it and raises event to tell other cards they have been revealed
	Duel.ConfirmCards(1-tp,g)
	Duel.RaiseSingleEvent(g:GetFirst(),77777900,e,REASON_EFFECT,tp,tp,0)
	Duel.ShuffleHand(tp)
  --Stacks deck
  g=Duel.GetMatchingGroup(c77777936.filter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		local rg=Group.CreateGroup()
		for i=1,3 do
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77777936,1))
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			rg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
		end
		Duel.ConfirmCards(1-tp,rg)
		Duel.ShuffleDeck(tp)
		local tg=rg:GetFirst()
		while tg do
			Duel.MoveSequence(tg,0)
			tg=rg:GetNext()
		end
		Duel.SortDecktop(tp,tp,3)
	end
end

function c77777936.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c77777936.shfilter(c)
	return not (c:IsSetCard(0x40d) and c:IsType(TYPE_MONSTER))and c:IsAbleToDeck()
end
function c77777936.shtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c77777936.shfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c77777936.shoperation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
  local g2=Duel.GetFieldGroup(p,LOCATION_HAND,0)
  local g=g2:Filter(c77777936.shfilter,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-p,g)
    local count=g:GetCount()
		local ct=Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
    Duel.SortDecktop(p,p,count)
		for i=1,count do
			local mg=Duel.GetDecktopGroup(p,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
		Duel.BreakEffect()
		Duel.Draw(p,ct,REASON_EFFECT)
		Duel.ShuffleHand(p)
	end
end