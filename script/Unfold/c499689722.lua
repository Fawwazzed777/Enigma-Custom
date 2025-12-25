--Aerolizer Chip Away
local s,id=GetID()
function s.initial_effect(c)
	--Pay 2000 LP
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(Cost.PayLP(2300))
	e1:SetCondition(s.con)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
s.listed_series={0xbf45}
s.listed_names={749968945}
function s.cfilter(c)
	return c:IsCode(749968945) or (c:IsType(TYPE_SYNCHRO) and c:ListsCode(749968945))
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil) and 
	Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>=2
end
function s.tgfilter(c,p)
	return c:IsFaceup() and Duel.IsPlayerCanSendtoGrave(p,c)
end
function s.spfilter(c,e,tp)
	return c:IsCode(499689704) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,0,LOCATION_MZONE,nil,1-tp)
	if chk==0 then return #g>0 end
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,math.min(ct-1,#g),0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,0,LOCATION_MZONE,nil,1-tp):GetMaxGroup(Card.GetAttack)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if ct<=1 or #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local tg=g:Select(1-tp,ct-1,ct-1,nil)
	if #tg>0 then
		Duel.HintSelection(tg,true)
		if Duel.SendtoGrave(tg,REASON_RULE,PLAYER_NONE,1-tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1))then
		local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		if tc then
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
end
end
end
end
