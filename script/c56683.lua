--Noxious Dominance
local s,id=GetID()
function s.initial_effect(c)
	c:EnableUnsummonable()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.con)
	e2:SetCost(s.scost)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	e2:SetHintTiming(TIMING_STANDBY_PHASE+TIMING_END_PHASE+TIMING_SPSUMMON+TIMING_DAMAGE_STEP+TIMING_DAMAGE_CAL)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,{id,1})
	e3:SetCondition(s.ddcon)
	e3:SetTarget(s.ddtg)
	e3:SetOperation(s.ddop)
	e3:SetHintTiming(TIMING_SUMMON+TIMING_SPSUMMON+TIMING_FLIPSUMMON+TIMING_DAMAGE_STEP+TIMING_DAMAGE_CAL)
	c:RegisterEffect(e3)
end
function s.splimit(e,se,sp,st,re,c)
	return se:IsHasType(EFFECT_TYPE_ACTIONS) and se:GetHandler():IsSetCard(0x222)
end
function s.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) and Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	Duel.PayLPCost(tp,800)
	Duel.DiscardDeck(tp,1,REASON_COST)
end
function s.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x222) and c:IsType(TYPE_MONSTER)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
return not eg:IsContains(e:GetHandler()) and eg:IsExists(aux.NOT(Card.IsSummonPlayer),1,nil,tp)
	 and Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_EXTRA,1,nil,tp,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND+LOCATION_EXTRA)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA):RandomSelect(tp,1)
	g1:Merge(g2)
	if #g1>0 then
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
end
end
function s.csfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and (c:IsPreviousControler(tp) or c:IsPreviousControler(1-tp))
end
function s.noxfilter(c)
	return c:IsLocation(LOCATION_DECK) and c:IsSetCard(0x222)
end
function s.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function s.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.csfilter,1,nil,tp)
end
function s.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,3)
end
function s.ddop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
	if #g>0 then
		local rs=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if rs>=2 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
	local sg=Duel.SelectMatchingCard(tp,s.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
end
end
end
end
