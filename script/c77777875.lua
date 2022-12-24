--Psybernetic Regeneracy
function c77777875.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777875,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77777875.ptg)
	e1:SetOperation(c77777875.pop)
	c:RegisterEffect(e1)
end

function c77777875.pfilter2(c,e,tp)
	return c:IsSetCard(0x40b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)and c:IsFaceup() and c:IsLevelAbove(8)
end
function c77777875.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777875.pfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c77777875.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO)
end
function c77777875.pop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g2=Duel.SelectMatchingCard(tp,c77777875.pfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  if Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)~=0 then
    local rec=Duel.GetMatchingGroupCount(c77777875.filter,tp,LOCATION_MZONE,0,nil)*500
    local rec2=Duel.GetMatchingGroupCount(c77777875.filter,tp,LOCATION_REMOVED,0,nil)*300
    rec=rec+rec2
    Duel.Recover(tp,rec,REASON_EFFECT)
  end
end