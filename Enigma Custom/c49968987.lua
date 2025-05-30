--Ultimaya King Flare Draco
local s,id=GetID()
function s.initial_effect(c)
	--Must be properly summoned before reviving
	c:EnableReviveLimit()
	--Fusion summon procedure
	Fusion.AddProcMix(c,true,true,49968956,s.ffilter)
	--Searing Burst
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)	
	--Prominence Curse
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.deccon)
	e2:SetTarget(s.dectg)
	e2:SetOperation(s.decop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function s.ffilter(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.sfilter(c)
	return c:IsFaceup() and c:GetBaseAttack()~=c:GetAttack()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sfilter,1-tp,LOCATION_MZONE,1,1,nil) end
	local g=Duel.GetMatchingGroup(s.sfilter,1-tp,LOCATION_MZONE,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.sfilter,1-tp,LOCATION_MZONE,1,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function s.atkfilter(c)
	return c:IsFaceup() and (c:GetLevel()>0 or c:GetRank()>0 or c:GetLink()>0)
end
function s.deccon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function s.dectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,0,1-tp,200)
end
function s.decop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.atkfilter,1-tp,LOCATION_MZONE,1,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local val=0
		if tc:IsType(TYPE_XYZ)  then val=tc:GetRank()*-200
		else val=tc:GetLevel()*-200 end
		if tc:IsType(TYPE_LINK) then val=tc:GetLink()*-200 end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(val)
		tc:RegisterEffect(e1)
	end
end

