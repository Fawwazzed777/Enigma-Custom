--Ultimaya King Arcanum
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x309),2,2)
	c:EnableReviveLimit()
	-- 
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTarget(s.bpt)
	e0:SetValue(aux.tgoval)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
end
s.listed_series={0x309,0xa309}
function s.bpt(e,c)
	return c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function s.cfilter(c)
	return c:IsDestructable()
end
function s.ha(c)
	return c:IsSetCard(0x309) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.dfilter(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED) and c:IsDestructable()
end
function s.exist(c)
	return c:IsFaceup() and c:IsSetCard(0x309) and (c:IsType(TYPE_EXTRA) or c:GetOriginalType(ORIGINAL_TYPE_EXTRA))
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and s.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(s.ha,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler()) 
	local sr=Duel.IsExistingMatchingCard(s.ha,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	if rg and sr then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=rg:Select(tp,1,1,nil)
	Duel.HintSelection(tg)
	if Duel.Destroy(tg,REASON_EFFECT)~=0 then
	local st=Duel.SelectMatchingCard(tp,s.ha,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if st:IsRelateToEffect(e) and st:IsSSetable() then
	Duel.SSet(tp,st)
	--Quick Trap
	local et=Effect.CreateEffect(e:GetHandler())
	et:SetType(EFFECT_TYPE_SINGLE)
	et:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	et:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	et:SetReset(RESET_EVENT+RESETS_STANDARD)
	st:RegisterEffect(et)
		--Quick Spell
		local eq=Effect.CreateEffect(e:GetHandler())
		eq:SetType(EFFECT_TYPE_SINGLE)
		eq:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		eq:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		eq:SetReset(RESET_EVENT+RESETS_STANDARD)
		st:RegisterEffect(eq)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local rk=Duel.IsExistingMatchingCard(s.exist,tp,LOCATION_MZONE,0,1,e:GetHandler())
	local ek=Duel.IsExistingMatchingCard(s.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		if rk and ek and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local sg=Duel.SelectMatchingCard(tp,s.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #sg>0 then
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
end		
end
end
end
end
end