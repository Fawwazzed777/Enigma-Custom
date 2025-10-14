--Ultimaya King Geiza
local s,id=GetID()
function s.initial_effect(c)
	--Synchro
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x309),1,1,Synchro.NonTunerEx(Card.IsSetCard,0x309),1,99)
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
	eq:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
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
end
function s.pfilter(c,e,tp)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function s.tgfilter(c,e,tp)
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