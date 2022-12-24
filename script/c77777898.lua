--Witchcrafter's Creation
function c77777898.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,77777898)
	e1:SetTarget(c77777898.target)
	e1:SetOperation(c77777898.operation)
	c:RegisterEffect(e1)
  	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c77777898.reptg)
  e2:SetValue(c77777898.repval)
	e2:SetOperation(c77777898.repop)
	c:RegisterEffect(e2)
end

function c77777898.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand() and (c:IsSetCard(0x95) or c:IsSetCard(0x5d2))
end
function c77777898.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp and c77777898.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77777898.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c77777898.filter,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c77777898.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end

function c77777898.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x407) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsControler(tp) and c:GetDestination()==LOCATION_REMOVED and not c:IsReason(REASON_REPLACE+REASON_COST)
end
function c77777898.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and aux.exccon(e) and eg:IsExists(c77777898.repfilter,1,nil,tp) end
  return Duel.SelectYesNo(tp,aux.Stringid(77777898,0))
--	if Duel.SelectYesNo(tp,aux.Stringid(77777898,0))then
--[[    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
    return true
  else
    return false end]]
end
function c77777898.repval(e,c)
	return c77777898.repfilter(c,e:GetHandlerPlayer())
end
function c77777898.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
