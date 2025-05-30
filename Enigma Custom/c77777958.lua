--Mechanoclast World Devastator
function c77777958.initial_effect(c)
  --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x40e),3,6)
	c:EnableReviveLimit()
  --tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777958,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c77777958.target)
	e1:SetOperation(c77777958.operation)
	c:RegisterEffect(e1)
  --to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777958,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c77777958.tdcost)
	e2:SetTarget(c77777958.tdtg)
	e2:SetOperation(c77777958.tdop)
	c:RegisterEffect(e2)
  --indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
  --indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c77777958.indtg)
	e5:SetValue(1)
	c:RegisterEffect(e5)
  local e6=e5:Clone()
  e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  c:RegisterEffect(e6)
end

function c77777958.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0x40e)
end
function c77777958.gyfilter(c)
	return c:IsSetCard(0x40e) and c:IsType(TYPE_LINK) and c:IsAbleToDeck()
end

function c77777958.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingMatchingCard(c77777958.gyfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
  local g2=Duel.GetMatchingGroup(c77777958.gyfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,g2:GetCount(),nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,g:GetCount(),0,0)
end
function c77777958.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
  local g2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  local count = g:GetCount()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g3=Duel.SelectMatchingCard(tp,c77777958.gyfilter,tp,LOCATION_GRAVE,0,count,count,nil)
	if Duel.SendtoDeck(g3,nil,0,REASON_EFFECT)==count and g:GetCount()>0 then
    Duel.BreakEffect()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end

function c77777958.countfilter(c)
	return c:IsSetCard(0x40e) and c:IsFaceup() and (c:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT or c:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT+TYPE_LINK)
end
function c77777958.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x40e,2,REASON_COST) or Duel.IsExistingMatchingCard(c77777958.countfilter,tp,LOCATION_SZONE,0,1,nil)end
  local choice=0
  if Duel.IsCanRemoveCounter(tp,1,0,0x40e,2,REASON_COST) then choice=choice+1 end
  if Duel.IsExistingMatchingCard(c77777958.countfilter,tp,LOCATION_SZONE,0,1,nil)then choice=choice+2 end
  if choice==3 then choice=Duel.SelectOption(tp,aux.Stringid(77777958,2),aux.Stringid(77777958,3))+1 end
	if choice==1 then Duel.RemoveCounter(tp,1,0,0x40e,2,REASON_COST)
elseif choice==2 then 
    local g=Duel.SelectMatchingCard(tp,c77777958.countfilter,tp,LOCATION_SZONE,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
  end
end
function c77777958.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c77777958.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,1,nil)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end