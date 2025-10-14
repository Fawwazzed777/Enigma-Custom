--Seafarer Deckhand Alvida
function c66666689.initial_effect(c)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66666689,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
--	e3:SetCost(c66666689.cost)
	e3:SetCountLimit(1,66666689)
	e3:SetTarget(c66666689.sptg)
	e3:SetOperation(c66666689.spop)
	c:RegisterEffect(e3)
end


function c66666689.dfilter(c,s)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c66666689.spfilter(c,e,tp)
	return c:IsSetCard(0x999) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c66666689.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c66666689.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c66666689.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
		and Duel.IsExistingMatchingCard(c66666689.dfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c66666689.spop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.SelectMatchingCard(tp,c66666689.dfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),e:GetHandler())
	if Duel.Destroy(dg,REASON_EFFECT)~=0 then
    Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c66666689.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end