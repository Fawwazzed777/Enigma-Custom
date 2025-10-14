--Shadow Beast Charge
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0xabc9}
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xabc9)
end
function s.dfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xabc9)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xabc9) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.get_count(g)
	if #g==0 then return 0 end
	local ret=0
	repeat
		local tc=g:GetFirst()
		g:RemoveCard(tc)
		local ct1=#g
		g:Remove(Card.IsCode,nil,tc:GetCode())
		local ct2=#g
		local c=ct1-ct2+1
		if c>ret then ret=c end
	until #g==0 or #g<=ret
	return ret
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	local ct=s.get_count(g)
	e:SetLabel(ct) 
	return tp~=Duel.GetTurnPlayer() and (ph&PHASE_MAIN2+PHASE_END)==0 and ct==3 or ct==6 and ep~=tp
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,1)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.SelectMatchingCard(tp,s.dfilter,tp,LOCATION_MZONE,0,1,3,nil)
	if #g>0 then
		Duel.HintSelection(g)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
	local rc=#g
	Duel.BreakEffect()
	local ct=Duel.Draw(tp,1*rc,REASON_EFFECT)
	if Duel.SelectEffectYesNo(tp,e:GetOwner()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ct>=3 then
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	
end
	Duel.SpecialSummonComplete()
end
end
end
end
