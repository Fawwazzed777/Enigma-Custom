--Ultimaya King Geiza
local s,id=GetID()
function s.initial_effect(c)
	--Synchro
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x309),1,1,Synchro.NonTunerEx(Card.IsSetCard,0x309),1,99)
	Pendulum.AddProcedure(c,false)
	c:EnableReviveLimit()
	--Banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.rtg)
	e1:SetOperation(s.rop)
	c:RegisterEffect(e1)
	local eq=e1:Clone()
	eq:SetType(EFFECT_TYPE_QUICK_O)
	eq:SetCode(EVENT_FREE_CHAIN)
	eq:SetCondition(s.spquickcon)
	c:RegisterEffect(eq)
	--atk 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x309))
	e2:SetValue(400)
	c:RegisterEffect(e2)
	--Place in Pendulum Zone on Activate Spell/Trap
	local ep=Effect.CreateEffect(c)
	ep:SetDescription(aux.Stringid(id,1))
	ep:SetType(EFFECT_TYPE_QUICK_O)
	ep:SetProperty(EFFECT_FLAG_DELAY)
	ep:SetCode(EVENT_CHAINING)
	ep:SetRange(LOCATION_EXTRA)
	ep:SetCountLimit(1,{id,1})
	ep:SetCondition(s.pencon)
	ep:SetTarget(s.pentg)
	ep:SetOperation(s.penop)
	c:RegisterEffect(ep)
	--PZ Effect
	local es=Effect.CreateEffect(c)
	es:SetDescription(aux.Stringid(id,0))
	es:SetCategory(CATEGORY_SPECIAL_SUMMON)
	es:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	es:SetCode(EVENT_PHASE|PHASE_END)
	es:SetRange(LOCATION_PZONE)
	es:SetCountLimit(1,{id,2})
	es:SetCondition(s.spcon)
	es:SetTarget(s.sptg)
	es:SetOperation(s.spop)
	c:RegisterEffect(es)
end
function s.pfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function s.tgfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function s.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.pfilter,tp,LOCATION_PZONE,0,nil)
	if chk==0 then return #g>0 and Duel.IsExistingMatchingCard(s.tgfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,0)
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local dg=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_PZONE,0,1,1,nil)
	if #dg==0 then return end
	Duel.HintSelection(dg)
	if Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tgc=Duel.SelectMatchingCard(tp,s.tgfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #tgc>0 then
	Duel.HintSelection(tgc)
	Duel.Remove(tgc,POS_FACEUP,REASON_EFFECT)
end
end
function s.spquickcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0xa309),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler()) 
end
function s.penconfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x309) or c:IsCode(1686814)
end
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(s.penconfilter,1,nil,tp) and c:IsFaceup()
	and ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsSpellTrapEffect()
	and Duel.IsChainNegatable(ev)
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp 
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end