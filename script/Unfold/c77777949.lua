--Mechanoclast Power Cell
function c77777949.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,77777949)
	e1:SetTarget(c77777949.target)
	e1:SetOperation(c77777949.activate)
	c:RegisterEffect(e1)
end
function c77777949.filter(c,tp)
	return c:IsCode(77777942) and c:GetActivateEffect():IsActivatable(tp)
end
function c77777949.filter2(c)
	return c:IsSetCard(0x40e) and c:IsType(TYPE_MONSTER)
end
function c77777949.counterfilter(c)
	return c:IsFaceup() and c:IsCode(77777942)
end
function c77777949.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777949.filter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.IsExistingMatchingCard(c77777949.filter2,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 end
end
function c77777949.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c77777949.filter,tp,LOCATION_DECK,0,nil,tp)
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
    --activate field
    local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local g=Duel.SelectMatchingCard(tp,c77777949.filter2,tp,LOCATION_DECK,0,1,1,nil)
    local c=g:GetFirst()
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    local e1=Effect.CreateEffect(c)
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fc0000)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    c:RegisterEffect(e1)
    c:RegisterFlagEffect(77777942,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
    if not Duel.IsExistingMatchingCard(c77777949.counterfilter,tp,LOCATION_SZONE,0,1,nil) then return end
  local g2=Duel.SelectMatchingCard(tp,c77777949.counterfilter,tp,LOCATION_SZONE,0,1,1,nil)
  local tc2=g2:GetFirst()
  tc2:AddCounter(0x40e,3)
  end
end
