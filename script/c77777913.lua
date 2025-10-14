--Dragoscendent Progenitor Lux
function c77777913.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x40d),1,1,aux.NonTuner(Card.IsSetCard,0x40d),1,99)
	c:EnableReviveLimit()
  --spsummon
	local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(77777913,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,77777913)
  e3:SetCondition(c77777913.spcon)
	e3:SetTarget(c77777913.destg)
	e3:SetOperation(c77777913.desop)
	c:RegisterEffect(e3)
  --cannot disable summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x40d))
	c:RegisterEffect(e6)
  local e11=e6:Clone()
  e11:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
  c:RegisterEffect(e11)
end

function c77777913.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_SYNCHRO
end

function c77777913.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
  local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77777913.desop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if dg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=dg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
