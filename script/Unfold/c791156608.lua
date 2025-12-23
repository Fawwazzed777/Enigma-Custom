--Vandal Invitation
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCondition(s.c)
	e1:SetTarget(s.t)
	e1:SetOperation(s.o)
	c:RegisterEffect(e1)
end
s.listed_series={0x963}
function s.c(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0x963),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function s.filter(c,e)
	return c:IsCanBeEffectTarget(e) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FIEND)
end
function s.xyzfilter(c,mg,sc,set)
	local reset={}
	if not set then
		for tc in aux.Next(mg) do
			local e1=Effect.CreateEffect(sc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_XYZ_MATERIAL)
			tc:RegisterEffect(e1)
			table.insert(reset,e1)
		end
	end
	local res=c:IsXyzSummonable(nil,mg,#mg,#mg)
	for _,te in ipairs(reset) do
		te:Reset()
	end
	return res and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.rescon(set)
	return function(sg,e,tp,mg)
				return Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,sg,e:GetHandler(),set)
			end
end
function s.t(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(s.filter,1-tp,LOCATION_MZONE,1,nil,e)
	if chk==0 then return aux.SelectUnselectGroup(mg,e,tp,nil,2,s.rescon(false),0) end
	local reset={}
	for tc in aux.Next(mg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_XYZ_MATERIAL)
		tc:RegisterEffect(e1)
		table.insert(reset,e1)
	end
	local tg=aux.SelectUnselectGroup(mg,e,tp,nil,2,s.rescon(true),1,tp,HINTMSG_XMATERIAL,s.rescon(true))
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	for _,te in ipairs(reset) do
		te:Reset()
	end
end
function s.o(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetCards(e)
	local reset={}
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_XYZ_MATERIAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		table.insert(reset,e1)
		--yikes
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetValue(s.val1)
		e1:SetReset(RESET_PHASE+PHASE_END,1)
		Duel.RegisterEffect(e1,tp)
	end
	local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,g,c,true)
	if #xyzg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,nil,g)
	else
		for _,te in ipairs(reset) do
			te:Reset()
end
end
end
function s.val1(e,re,dam,r,rp,rc)
	if r&(REASON_BATTLE+REASON_EFFECT)~=0 then
		return dam/2
	else return dam end
end