--Vandalization
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--All monsters become LIGHT Fiend while "Devas" monster exists
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(s.attrcon)
	e1:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e1)
	local e1b=e1:Clone()
	e1b:SetCode(EFFECT_CHANGE_RACE)
	e1b:SetValue(RACE_FIEND)
	c:RegisterEffect(e1b)
	--ATK/DEF gain for Devas Xyz with Vandal material (your turn only)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(s.atkcon)
	e2:SetTarget(s.atktg)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2b)
	--ATK loss on opponent monsters when chain is activated
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(s.chainop)
	c:RegisterEffect(e3)
end
s.listed_series={0x765,0x963}
function s.devasfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x765)
end
function s.attrcon(e)
	return Duel.IsExistingMatchingCard(s.devasfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.atkcon(e,tp)
	return Duel.GetTurnPlayer()==tp
end
function s.atktg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x765) and c:IsType(TYPE_XYZ)
		and c:GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x963)
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(function(tc) return tc:IsFaceup() and tc:IsAttribute(ATTRIBUTE_LIGHT) 
	and tc:IsRace(RACE_FIEND) end,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*300
end
function s.vandalxyzfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x963) and c:IsType(TYPE_XYZ) and c:IsControler(tp)
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.vandalxyzfilter,tp,LOCATION_MZONE,0,1,nil,tp) then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
			tc:RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-200)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
	end
end
