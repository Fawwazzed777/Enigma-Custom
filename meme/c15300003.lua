--
local s,id=GetID()
function s.initial_effect(c)
rollypolly=LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED
	--meh
	local wtf=Effect.CreateEffect(c)
	wtf:SetDescription(aux.Stringid(id,0))
	wtf:SetType(EFFECT_TYPE_ACTIVATE)
	wtf:SetCode(EVENT_FREE_CHAIN)
	wtf:SetHintTiming(0,TIMING_DRAW_PHASE)
	wtf:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	wtf:SetTarget(s.wtfm)
	wtf:SetOperation(s.iallowit)
	c:RegisterEffect(wtf)
end
function s.whatthedogdoing(c)
	return c:IsSpell() and c:IsSSetable()
end
function s.wtfm(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.whatthedogdoing),tp,rollypolly,0,1,1,nil) end
end
function s.iallowit(e,tp,eg,ep,ev,re,r,rp)
	local nevermind=e:GetHandler()
	local would=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.whatthedogdoing),tp,rollypolly,0,1,1,nil)
	local smash=would:GetFirst()
	if smash then
		Duel.SSet(tp,smash)
		local do_di_do=Effect.CreateEffect(nevermind)
		do_di_do:SetType(EFFECT_TYPE_SINGLE)
		do_di_do:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		do_di_do:SetCode(EFFECT_BECOME_QUICK)
		do_di_do:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		smash:RegisterEffect(do_di_do)
		local what_did_you_expect=Effect.CreateEffect(nevermind)
		what_did_you_expect:SetType(EFFECT_TYPE_SINGLE)
		what_did_you_expect:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		what_did_you_expect:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		what_did_you_expect:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		smash:RegisterEffect(what_did_you_expect)
end
end
