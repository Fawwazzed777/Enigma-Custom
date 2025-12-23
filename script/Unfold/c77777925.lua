--Witchcrafter Tea
function c77777925.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c77777925.sumfilter,1)
	c:EnableReviveLimit()
  --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777925,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c77777925.sptg)
	e2:SetOperation(c77777925.spop)
	c:RegisterEffect(e2)
end
function c77777925.sumfilter(c)
	return c:IsSetCard(0x407) and not c:IsType(TYPE_LINK)
end
function c77777925.spfilter1(c,e,tp,zone)
	return c:IsSetCard(0x407) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and c:IsFaceup()
end
function c77777925.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		if zone~=0 then
			return Duel.IsExistingMatchingCard(c77777925.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone)
		else
			return false
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function c77777925.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777925.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end