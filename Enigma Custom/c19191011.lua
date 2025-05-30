--Latent Shadow Beast
local s,id=GetID()
function s.initial_effect(c)
	--Copy Name
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCountLimit(1,id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.condition)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
s.listed_series={0xabc9}
function s.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.ccfilter(c,e,tp,code)
	return not c:IsCode(id) and c:IsRace(RACE_BEAST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc:IsRace(RACE_BEAST) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(aux.FaceupFilter(s.ccfilter),tp,LOCATION_MZONE,0,1,e:GetHandler(),c) end
	Duel.SelectTarget(tp,aux.FaceupFilter(s.ccfilter),tp,LOCATION_MZONE,0,1,1,e:GetHandler(),c)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e)) then return end
		--Change name
		local code=tc:GetCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp,tc:GetCode())
	local sc=g:GetFirst()
	if sc then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xabc9) and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,c,c:GetCode())
end
function s.cfilter2(c,code)
	return c:IsFaceup() and c:IsCode(code) 
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
end
end
