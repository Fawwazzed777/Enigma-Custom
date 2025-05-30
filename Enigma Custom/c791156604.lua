--Revandal Emperor Devas
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(s.ffilter),7,2,nil,nil,99)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(aux.dxmcostgen(1,1))
	e1:SetCondition(s.co)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--Check for activation on field
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetCondition(s.regcon)
		ge1:SetOperation(s.regop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetCondition(s.regcon)
		ge2:SetOperation(s.regop2)
		Duel.RegisterEffect(ge2,0)
	end)
end		
function s.ffilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
--
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField()
end
function s.regop1(e,tp,eg,ep,ev,re,r,rp)
	re:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.regop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=re:GetHandler():GetFlagEffect(id)
	re:GetHandler():ResetFlagEffect(id)
	for i=1,ct-1 do
		re:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
--
function s.rfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(id)>0
end
function s.co(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(s.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	local ct=Duel.GetMatchingGroupCount(s.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())	
	if ct>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500*ct)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if c:IsAttackAbove(3700) and Duel.IsExistingMatchingCard(s.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())			
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(s.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())	
		if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local sc=g:Select(tp,1,1,nil,e,tp):GetFirst()
		Duel.HintSelection(sc)
		if Duel.SendtoGrave(sc,REASON_EFFECT)~=0 then	
		Duel.Draw(tp,2,REASON_EFFECT)
		--
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(s.atlimit)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
end
end
end
end
end
function s.atlimit(e,c)
	return c~=e:GetOwner()
end
