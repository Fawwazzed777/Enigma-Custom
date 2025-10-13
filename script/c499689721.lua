--Aerolizer Bolt Sphere
local s,id=GetID()
function s.initial_effect(c)
	--SP
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--Can be treated as a non-tuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(s.ntval)
	c:RegisterEffect(e2)
end
s.listed_series={0xbf45}
function s.rtfilter(c,e,tp)
	return c:IsLevelBelow(2) and not c:IsCode(id) and c:IsAttribute(ATTRIBUTE_WIND) 
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function s.scfilter(c)
	return c:IsMonster() and c:IsLevel(2) and c:IsAttribute(ATTRIBUTE_WIND)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() 
	and Duel.IsExistingMatchingCard(s.rtfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.rtfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.rtfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local rg=Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
	and Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	and rg and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
	Duel.BreakEffect()
		local sg=rg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
end	
end
end
function s.ntval(c,sc,tp)
	return sc and sc:IsAttribute(ATTRIBUTE_WIND)
end