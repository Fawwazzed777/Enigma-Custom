--Dragoscendent Progenitor Glacies
function c77777909.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x40d),1,1,aux.NonTuner(Card.IsSetCard,0x40d),1,99)
	c:EnableReviveLimit()
  	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,77777909)
	e1:SetCondition(c77777909.thcon)
	e1:SetTarget(c77777909.thtg)
	e1:SetOperation(c77777909.thop)
	c:RegisterEffect(e1)
end

function c77777909.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c77777909.filter(c)
	return c:IsSetCard(0x40d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
end
function c77777909.rfilter(c,e,tp)
	return c:IsSetCard(0x40d) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c77777909.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777909.rfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c77777909.filter,tp,LOCATION_GRAVE,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777909.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
  local g=Duel.SelectMatchingCard(tp,c77777909.rfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  Duel.ConfirmCards(1-tp,g)
  Duel.RaiseSingleEvent(g:GetFirst(),77777900,e,REASON_EFFECT,tp,tp,0)
  Duel.ShuffleHand(tp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c77777909.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g2:GetCount()>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end