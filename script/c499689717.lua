--Aerolizer Exterminator Wing
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xbf45),1,1,Synchro.NonTunerEx(Card.IsAttribute,ATTRIBUTE_WIND),1,99)
	c:EnableReviveLimit()
	--Send to GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.ctcon)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--Turn into Quick Effect
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(s.lpcon)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetCondition(s.lpcon1)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
s.listed_series={0xbf45}
function s.cfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack())
	return g 
end
function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local g=Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack())
	return g and Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function s.lpcon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tg,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	local c=e:GetHandler()
	if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
	  		local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(g:GetFirst():GetAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_ATTACK)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetTargetRange(LOCATION_MZONE,0)
			e2:SetTarget(s.atlimit)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
end
end
function s.atlimit(e,c)
	return c~=e:GetOwner()
end
