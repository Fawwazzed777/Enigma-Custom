--Vandalization
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x1765)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--All face-up monsters become LIGHT Fiend while "Devas" exists
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(s.devas_exist)
	e1:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_FIEND)
	c:RegisterEffect(e2)
	--ATK/DEF gain for Devas Xyz with Vandal material (your turn only)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.devas_xyz)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetValue(s.atkval)
	c:RegisterEffect(e4)
	--Add Vandal Counter on each chain activation
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCondition(s.chaincon)
	e5:SetOperation(s.chainop)
	c:RegisterEffect(e5)
	--Opponent monsters lose 100 ATK based on Vandal Counters
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetValue(s.debuff)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
end
s.listed_series={0x765,0x963}
function s.devas_exist(e)
	return Duel.IsExistingMatchingCard(function(c) return 
	c:IsFaceup() and c:IsSetCard(0x765) end,
	e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function s.vandal_mat(c)
	return c:IsSetCard(0x963)
end
function s.devas_xyz(e,c)
	return c:IsFaceup()
		and c:IsSetCard(0x765)
		and c:IsType(TYPE_XYZ)
		and c:GetOverlayGroup():IsExists(s.vandal_mat,1,nil)
		and Duel.GetTurnPlayer()==c:GetControler()
end
function s.light_fiend_count()
	return Duel.GetMatchingGroupCount(
		function(c)
			return c:IsFaceup()
				and c:IsAttribute(ATTRIBUTE_LIGHT)
				and c:IsRace(RACE_FIEND)
		end,
		0,LOCATION_MZONE,LOCATION_MZONE,nil)
end
function s.atkval(e,c)
	return s.light_fiend_count()*300
end
function s.vandal_xyz_exist(tp)
	return Duel.IsExistingMatchingCard(
		function(c)
			return c:IsFaceup()
				and c:IsType(TYPE_XYZ)
				and c:IsSetCard(0x963)
		end,
		tp,LOCATION_MZONE,0,1,nil)
end
function s.chaincon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and s.vandal_xyz_exist(tp)
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1765,1)
end
function s.debuff(e,c)
	return -100*e:GetHandler():GetCounter(0x1765)
end