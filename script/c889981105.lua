--Enigmatic Lord - Alpha
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,id)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetTargetRange(POS_FACEUP_ATTACK,1)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
end
function s.spcon(e,c)
	if c==nil then return Duel.IsPhase(PHASE_STANDBY+PHASE_BATTLE_START+PHASE_END) end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end