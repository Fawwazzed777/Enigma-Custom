--Seafarer Lookout Barbarossa
function c66666692.initial_effect(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetDescription(aux.Stringid(66666692,0))
	e2:SetCountLimit(1,66666692)
--	e2:SetCost(c66666692.cost)
	e2:SetTarget(c66666692.sptg)
	e2:SetOperation(c66666692.spop)
	c:RegisterEffect(e2)
end

function c66666692.filter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function c66666692.filter2(c)
	return c:IsAbleToChangeControler()and c:GetSequence()<5
end

function c66666692.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c66666692.filter,tp,LOCATION_ONFIELD,0,1,nil)end
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
  Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end

function c66666692.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c66666692.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.BreakEffect()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 
    and Duel.IsExistingMatchingCard(c66666692.filter2,tp,0,LOCATION_SZONE,1,nil) and 
    Duel.SelectYesNo(tp,aux.Stringid(66666692,1))then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
      local g=Duel.SelectMatchingCard(tp,c66666692.filter2,tp,0,LOCATION_SZONE,1,1,e:GetHandler())
      Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
      local tc=g:GetFirst()
      Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
      Duel.ChangePosition(tc,POS_FACEDOWN)
      Duel.ConfirmCards(1-tp,tc)
    end
	end
end