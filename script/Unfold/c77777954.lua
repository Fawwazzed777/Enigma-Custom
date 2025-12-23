--Mechanoclast Power Walker
function c77777954.initial_effect(c)
  --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x40e),2,3)
	c:EnableReviveLimit()
  --atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c77777954.atkval)
	c:RegisterEffect(e1)
  --Place from deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777954,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCountLimit(1,77777954)
  e4:SetCost(c77777954.thcost)
	e4:SetTarget(c77777954.tg)
	e4:SetOperation(c77777954.op)
	c:RegisterEffect(e4)
  --tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77777954,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
  e5:SetCountLimit(1,77777954+EFFECT_COUNT_CODE_OATH)
  e5:SetCondition(c77777954.con)
  e5:SetCost(c77777954.thcost)
	e5:SetTarget(c77777954.thtg)
	e5:SetOperation(c77777954.thop)
	c:RegisterEffect(e5)
end

function c77777954.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77777954.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x40e,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x40e,1,REASON_COST)
end
function c77777954.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c77777954.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c77777954.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c77777954.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c77777954.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c77777954.atkval(e,c)
	return c:GetLinkedGroupCount()*300
end

function c77777954.filter(c)
	return c:IsSetCard(0x40e) and c:IsType(TYPE_MONSTER)
end
function c77777954.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0  and Duel.IsExistingMatchingCard(c77777954.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
end
function c77777954.op(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
  local g=Duel.SelectMatchingCard(tp,c77777954.filter,tp,LOCATION_DECK,0,1,1,nil)
  local c=g:GetFirst()
  Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
  local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(77777942,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
end