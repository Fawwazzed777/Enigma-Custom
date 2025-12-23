--Seafarer Renegade Jack
function c77777701.initial_effect(c)
	--ToHand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77777701,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
--	e3:SetCost(c77777701.cost)
	e3:SetCountLimit(1,77777701)
	e3:SetTarget(c77777701.sptg)
	e3:SetOperation(c77777701.spop)
	c:RegisterEffect(e3)
end
function c77777701.filter1(c)
	return c:IsAbleToChangeControler()and c:GetSequence()<5
end
function c77777701.dfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c77777701.filter2(c)
	return c:IsSetCard(0x999) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c77777701.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777701.filter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c77777701.dfilter,tp,LOCATION_ONFIELD,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_DECK)
  Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c77777701.spop(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.IsExistingMatchingCard(c77777701.dfilter,tp,LOCATION_ONFIELD,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,c77777701.dfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	if Duel.Destroy(g1,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c77777701.filter2,tp,LOCATION_DECK,0,1,nil)then
    Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c77777701.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 and Duel.SendtoHand(g2,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g2)
			if Duel.IsExistingMatchingCard(c77777701.filter1,tp,0,LOCATION_SZONE,1,c) and Duel.SelectYesNo(tp,aux.Stringid(77777701,1))then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
				local g3=Duel.SelectMatchingCard(tp,c77777701.filter1,tp,0,LOCATION_SZONE,1,1,e:GetHandler())	
        local tc=g3:GetFirst()
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        Duel.ChangePosition(tc,POS_FACEDOWN)
        Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end