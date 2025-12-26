--Aerolizer Overdrive
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
s.listed_series={0xbf45}
function s.filter1(c,e,tp)
	local lv=c:GetLevel()
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp,c)
end
function s.rescon(tuner,scard)
	return	function(sg,e,tp,mg)
				sg:AddCard(tuner)
				local res=Duel.GetLocationCountFromEx(tp,tp,sg,scard)>0 
					and sg:CheckWithSumEqual(Card.GetLevel,scard:GetLevel(),#sg,#sg)
				sg:RemoveCard(tuner)
				return res
			end
end
function s.filter2(c,tp,sc)
	local rg=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,c)
	return c:IsSetCard(0xbf45) and c:IsType(TYPE_TUNER) and c:IsAbleToRemove() and aux.SpElimFilter(c,true) 
		and aux.SelectUnselectGroup(rg,e,tp,nil,1,s.rescon(c,sc),0)
end
function s.filter3(c)
	return c:IsSetCard(0xbf45) and c:HasLevel() and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove() and aux.SpElimFilter(c,true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_SYNCHRO)
		return #pg<=0 and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_SYNCHRO)
	if #pg>0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g1:GetFirst()
	if sc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp,sc)
		local tuner=g2:GetFirst()
		local rg=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,tuner)
		local sg=aux.SelectUnselectGroup(rg,e,tp,1,1,s.rescon(tuner,sc),1,tp,HINTMSG_REMOVE,s.rescon(tuner,sc))
		sg:AddCard(tuner)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummonStep(sc,SUMMON_TYPE_SYNCHRO,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.aclimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1,true)
		sc:CompleteProcedure()
	end
	Duel.SpecialSummonComplete()
end
function s.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsAttribute(ATTRIBUTE_WIND))
end
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsAttribute(ATTRIBUTE_WIND)
end