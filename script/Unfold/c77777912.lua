--Dragoscendent Progenitor Umbra
function c77777912.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x40d),1,1,aux.NonTuner(Card.IsSetCard,0x40d),1,99)
	c:EnableReviveLimit()
  --indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x40d))
	e1:SetValue(1)
	c:RegisterEffect(e1)
  --spsummon
	local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(77777912,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,77777912)
  e3:SetCondition(c77777912.spcon)
	e3:SetTarget(c77777912.thtg)
	e3:SetOperation(c77777912.thop)
	c:RegisterEffect(e3)
end
function c77777912.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_SYNCHRO
end

function c77777912.thfilter(c)
	return c:IsSetCard(0x40d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c77777912.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c77777912.thfilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c77777912.thfilter,tp,LOCATION_GRAVE,0,1,c) end
	local g=Duel.SelectTarget(tp,c77777912.thfilter,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c77777912.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end