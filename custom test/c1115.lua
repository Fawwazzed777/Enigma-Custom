--Detective HERO Cross Armor
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcFun2(c,s.matfilter,aux.FilterBoolFunctionEx(Card.IsSetCard,0x7970),true)
	--special summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.atkup)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--spsummon count limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCondition(s.fuslimit)
	e3:SetTargetRange(1,1)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
s.listed_series={0x8,0x7970}
s.material_setcode={0x8,0x7970}
function s.splimit(e,se,sp,st)
	if e:GetHandler():IsLocation(LOCATION_EXTRA) then
		return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
	end
	return true
end
function s.matfilter(c,fc,sumtype,tp)
	return c:IsSetCard(0x8,fc,sumtype,tp) and c:IsLevelAbove(6)
end
function s.gyfilter(c)
	return c:IsSetCard(0x8) and c:IsMonster()
end
function s.atkup(e,c)
	return Duel.GetMatchingGroupCount(s.gyfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*300
end
function s.fuslimit(e,c,sump,sumtype,sumpos,targetp)
	local c=e:GetHandler()
	if c:IsMonster() then
		return c:IsType(TYPE_FUSION)
	else
		return c:IsOriginalType(TYPE_FUSION)
	end
end