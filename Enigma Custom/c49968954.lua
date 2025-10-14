--Accel Winds Dragon
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(s.sfilter1),1,1,aux.FilterSummonCode(49968945),1,1)
	c:EnableReviveLimit()
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,id+2)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
s.material={49968945}
s.listed_names={49968945}
s.synchro_nt_required=1
function s.sfilter1(c,val,scard,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_WIND,scard,sumtype,tp) and c:IsType(TYPE_SYNCHRO,scard,sumtype,tp)
end
function s.rtfilter(c)
	return c:IsType(TYPE_SYNCHRO) and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
end
function s.cfilter(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeckAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rtfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local cg=Duel.SelectMatchingCard(tp,s.rtfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(cg,nil,2,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.BreakEffect()
end
function s.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
	local sg=Duel.IsExistingMatchingCard(s.disfilter,tp,0,LOCATION_ONFIELD,1,nil)
	for tc:IsFaceup() in aux.Next(sg) do
		e:SetProperty(e:GetProperty()|EFFECT_FLAG_IGNORE_IMMUNE)
		Duel.HintSelection(sg)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetRange(LOCATION_ONFIELD)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetValue(function(e,te) return te:GetOwner()~=e:GetOwner() end)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		tc:RegisterEffect(e3,true)
		Duel.AdjustInstantly(tc)
		e:SetProperty(e:GetProperty()&~EFFECT_FLAG_IGNORE_IMMUNE)
end
end
function s.filter2(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP)
		Duel.BreakEffect()
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
	end
function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE+REASON_EFFECT)~=0
end
