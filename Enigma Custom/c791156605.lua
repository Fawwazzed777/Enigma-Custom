--Vandalism Diavasma
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Treat it with pleasure
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.ta)
	e1:SetOperation(s.ac)
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
s.listed_series={0x963}
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
function s.nefilter(c)
	return c:GetFlagEffect(id)>0 and c:HasLevel() and not c:IsLevel(7)
end
function s.ta(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.nefilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_GRAVE)
end
function s.aafilter(c,e,tp)
	return c:IsSetCard(0x963) and c:IsLevel(7) and c:IsAbleToHand()
end
function s.ac(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_APPLYTO)
	local tc=Duel.SelectMatchingCard(tp,s.nefilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(tc,true)
	--"Vandal"
	local extraproperty=tc:IsPosition(POS_FACEDOWN) and EFFECT_FLAG_SET_AVAILABLE or 0	
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(7)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	if not tc:IsSetCard(0x963) then
	--
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetValue(0x963)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
	if Duel.IsExistingMatchingCard(s.aafilter,tp,LOCATION_GRAVE,0,1,nil)			
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,s.aafilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
				Duel.Draw(tp,1,REASON_EFFECT)
end
end
end
end
