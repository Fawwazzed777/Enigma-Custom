--Seafarer Armsman Pierre
function c77777700.initial_effect(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetDescription(aux.Stringid(77777700,0))
	e2:SetCountLimit(1,77777700)
	e2:SetTarget(c77777700.sptg)
	e2:SetOperation(c77777700.spop)
	c:RegisterEffect(e2)
end


function c77777700.filter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end


function c77777700.spfilter(c,e,tp)
	return c:IsSetCard(0x999) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c77777700.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c77777700.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())end
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function c77777700.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not Duel.IsExistingMatchingCard(c77777700.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) then return end
	local g=Duel.SelectMatchingCard(tp,c77777700.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.BreakEffect()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c77777700.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(77777700,1))then
		local g2=Duel.SelectMatchingCard(tp,c77777700.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)    
		if g2:GetCount()>0 then
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	end
end