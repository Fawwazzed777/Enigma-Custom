--Psyberspace
function c77777874.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--[[indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
  e3:SetCountLimit(1)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x40b))
	e3:SetValue(1)
	c:RegisterEffect(e3)]]--
  --indes adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c77777874.adjustop)
	c:RegisterEffect(e2)
  --shuffle cards into deck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77777874,1))
	e5:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetTarget(c77777874.destg)
	e5:SetOperation(c77777874.desop)
	c:RegisterEffect(e5)
  --SS
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(77777874,0))
	e11:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e11:SetType(EFFECT_TYPE_IGNITION)
  e11:SetCountLimit(1)
	e11:SetRange(LOCATION_FZONE)
	e11:SetTarget(c77777874.ptg)
	e11:SetOperation(c77777874.pop)
	c:RegisterEffect(e11)
end

function c77777874.pfilter3(c)
	return c:IsSetCard(0x40b) and c:IsAbleToDeck() and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c77777874.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c77777874.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c77777874.pfilter3,tp,LOCATION_REMOVED,0,2,nil)then
    local g2=Duel.SelectMatchingCard(tp,c77777874.pfilter3,tp,LOCATION_REMOVED,0,2,2,nil)
    if Duel.SendtoDeck(g2,tp,2,REASON_EFFECT)==2 then
      Duel.ShuffleDeck(tp)
      Duel.Draw(tp,2,REASON_EFFECT)
    end
  end
end





function c77777874.pfilter1(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND))and c:IsSetCard(0x40b) and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c77777874.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777874.pfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE)
  Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c77777874.pop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown()then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c77777874.pfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
  if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
  end
end

function c77777874.filter(c)
  return c:IsSetCard(0x40b) and c:IsFaceup()
end
function c77777874.adjfilter(c)
  return c:IsCode(77777874) and c:IsFaceup()
end
function c77777874.adjcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c77777874.adjfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c77777874.adjustop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(c77777874.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
  local tc=g:GetFirst()
  while tc do
    if tc:GetFlagEffect(77777874)==0 then
    --indes
    local e4=Effect.CreateEffect(e:GetHandler())
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e4:SetCountLimit(1)
    e4:SetValue(1)
    e4:SetCondition(c77777874.adjcon)
    tc:RegisterEffect(e4)
    tc:RegisterFlagEffect(77777874,RESET_EVENT+0x1fe0000,0,1)
    end
    tc=g:GetNext()
  end
end