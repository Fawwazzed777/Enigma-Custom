--Dragoscendent Progenitor Caeli
function c77777908.initial_effect(c)
  c:SetUniqueOnField(1,0,77777908)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x40d),1,1,aux.NonTuner(Card.IsSetCard,0x40d),1,99)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777908,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c77777908.drcon)
	e1:SetTarget(c77777908.drtg)
	e1:SetOperation(c77777908.drop)
	c:RegisterEffect(e1)
end
function c77777908.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetCount()==1 and tg~=e:GetHandler() and tg:GetSummonType()==SUMMON_TYPE_SYNCHRO
        and tg:IsSetCard(0x40d)
end
function c77777908.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c77777908.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
  local tc=Duel.GetOperatedGroup():GetFirst()
  Duel.ConfirmCards(1-tp,tc)
  Duel.RaiseSingleEvent(tc,77777900,e,REASON_EFFECT,tp,tp,0)
	Duel.ShuffleHand(tp)
end
