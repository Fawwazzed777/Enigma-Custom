--Seafarer Swindler Bonnie
function c77777702.initial_effect(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetDescription(aux.Stringid(77777702,0))
	e2:SetCountLimit(1,77777702)
--	e2:SetCost(c77777702.cost)
	e2:SetTarget(c77777702.sptg)
	e2:SetOperation(c77777702.spop)
	c:RegisterEffect(e2)
end

function c77777702.filter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function c77777702.filter2(c)
	return c:IsAbleToChangeControler()and c:GetSequence()<5
end

function c77777702.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c77777702.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())end
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c77777702.spop(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.IsExistingMatchingCard(c77777702.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) then return end
	local g=Duel.SelectMatchingCard(tp,c77777702.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
		if Duel.IsExistingMatchingCard(c77777702.filter2,tp,0,LOCATION_SZONE,1,nil) 
      and Duel.SelectYesNo(tp,aux.Stringid(77777702,1))then
      Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
			local g=Duel.SelectMatchingCard(tp,c77777702.filter2,tp,0,LOCATION_SZONE,1,1,e:GetHandler())
			local tc=g:GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
      Duel.ChangePosition(tc,POS_FACEDOWN)
      Duel.ConfirmCards(1-tp,tc)
		end
	end
	end
end