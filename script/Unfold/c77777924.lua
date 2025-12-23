--Descent from Witchcrafter's Manor
function c77777924.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,77777924)
  e1:SetTarget(c77777924.target)
	e1:SetOperation(c77777924.activate)
	c:RegisterEffect(e1)
  --draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777924,0))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1,77777924+EFFECT_COUNT_CODE_OATH)
	e4:SetRange(LOCATION_GRAVE)
  e4:SetCost(c77777924.cost)
	e4:SetTarget(c77777924.shtarget)
	e4:SetOperation(c77777924.shoperation)
	c:RegisterEffect(e4)
end
function c77777924.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x407) and not c:IsForbidden()
end

function c77777924.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and not ((not Duel.CheckLocation(tp,LOCATION_PZONE,0) or not Duel.CheckLocation(tp,LOCATION_PZONE,1)) and not Duel.CheckLocation(tp,LOCATION_SZONE,1) and not Duel.CheckLocation(tp,LOCATION_SZONE,2) and not Duel.CheckLocation(tp,LOCATION_SZONE,3)) end
end


function c77777924.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c77777924.filter,tp,LOCATION_DECK,0,nil)
	local ct=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct=ct+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct=ct+1 end
	if ct>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:Select(tp,1,ct,nil)
		local sc=sg:GetFirst()
		while sc do
			Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			sc=sg:GetNext()
		end
	end
end

function c77777924.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c77777924.shfilter(c)
	return (c:IsSetCard(0x95) or c:IsSetCard(0x5d2))and c:IsAbleToDeck() and c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function c77777924.shtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c77777924.shfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c77777924.shoperation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
  local g2=Duel.GetFieldGroup(p,LOCATION_HAND,0)
  local g=g2:Filter(c77777924.shfilter,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-p,g)
		local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		Duel.Draw(p,ct,REASON_EFFECT)
		Duel.ShuffleHand(p)
	end
end