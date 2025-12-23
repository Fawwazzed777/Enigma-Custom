--Gift to the Witchcrafter
function c77777930.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetDescription(aux.Stringid(77777930,0))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77777930)
	e1:SetTarget(c77777930.target)
	e1:SetOperation(c77777930.activate)
	c:RegisterEffect(e1)
  --draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777930,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_GRAVE)
  e4:SetCost(c77777930.cost)
	e4:SetTarget(c77777930.shtarget)
	e4:SetOperation(c77777930.shoperation)
	c:RegisterEffect(e4)
end
function c77777930.desfilter(c)
	return c:IsDestructable() and c:IsSetCard(0x407) and c:IsType(TYPE_PENDULUM)
end
function c77777930.filter(c)
	return (c:IsSetCard(0x5d2) or c:IsSetCard(0x95)) and c:IsAbleToHand()
end
function c77777930.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777930.desfilter,tp,LOCATION_PZONE,0,1,nil)and Duel.IsExistingMatchingCard(c77777930.filter,tp,LOCATION_DECK,0,1,nil)end
end
function c77777930.activate(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.SelectMatchingCard(tp,c77777930.desfilter,tp,LOCATION_PZONE,0,1,1,nil)
  if Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c77777930.filter,tp,LOCATION_DECK,0,1,nil)then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77777930.filter,tp,LOCATION_DECK,0,1,2,nil)
    if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  end
end


function c77777930.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c77777930.shfilter(c)
	return c:IsSetCard(0x407) and c:IsType(TYPE_XYZ) and c:IsAbleToDeck()
end
function c77777930.shtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and aux.exccon(e)
		and Duel.IsExistingMatchingCard(c77777930.shfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c77777930.filter,tp,LOCATION_GRAVE,0,1,nil)end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c77777930.shoperation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
  local g2=Duel.GetFieldGroup(p,LOCATION_GRAVE,0)
  local g=g2:Filter(c77777930.shfilter,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-p,g)
		if Duel.SendtoDeck(g,nil,0,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c77777930.filter,tp,LOCATION_GRAVE,0,1,nil)then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
      local g=Duel.SelectMatchingCard(tp,c77777930.filter,tp,LOCATION_GRAVE,0,1,1,nil)
      if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
      end
    end
	end
end