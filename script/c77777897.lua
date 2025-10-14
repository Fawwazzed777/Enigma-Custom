--Night of the Witchcrafters
function c77777897.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77777897)
	e1:SetTarget(c77777897.target)
	e1:SetOperation(c77777897.activate)
	c:RegisterEffect(e1)
end
function c77777897.desfilter(c)
	return c:IsDestructable() and c:IsSetCard(0x407) and c:IsType(TYPE_PENDULUM)
end
function c77777897.filter(c)
	return c:IsSetCard(0x407) and c:IsType(TYPE_PENDULUM)
end
function c77777897.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777897.desfilter,tp,LOCATION_PZONE,0,1,nil) and Duel.IsExistingMatchingCard(c77777897.filter,tp,LOCATION_DECK,0,2,nil)end
end
function c77777897.activate(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.SelectMatchingCard(tp,c77777897.desfilter,tp,LOCATION_PZONE,0,1,1,nil)
  if Duel.Destroy(tc,REASON_EFFECT)~=0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))then
    Duel.BreakEffect()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local topend=Duel.SelectMatchingCard(tp,c77777897.filter,tp,LOCATION_DECK,0,1,1,nil)
    local g=topend:GetFirst()
    Duel.MoveToField(g,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77777897,0))
    local toextra=Duel.SelectMatchingCard(tp,c77777897.filter,tp,LOCATION_DECK,0,1,1,nil)
    local g2=toextra:GetFirst()
    Duel.SendtoExtraP(g2,nil,REASON_EFFECT)
  end
end
