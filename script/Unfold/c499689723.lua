--Aerolizer Valor Wing
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterSummonCode(499689705),1,1,Synchro.NonTuner(Card.IsAttribute,ATTRIBUTE_WIND),1,99)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
s.material={499689705}
s.listed_names={499689705}
function s.spfilter(c,e,tp)
	return c:IsMonster() and c:IsType(TYPE_SYNCHRO) and c:IsFaceup() 
	and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	local codes={}
	local uniq=0
	for tc in g:Iter() do
		local code=tc:GetCode()
		if not codes[code] then
			codes[code]=true
			uniq=uniq+1
		end
	end
	if chk==0 then
		return uniq>0 and Duel.CheckLPCost(tp,uniq*1000)
	end
	local ct=Duel.AnnounceNumber(tp,table.unpack(aux.GetNumberTable(1,uniq)))
	e:SetLabel(ct)
	Duel.PayLPCost(tp,ct*1000)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<ct then return end
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	local sg=aux.SelectUnselectGroup(g,e,tp,ct,ct,aux.dncheck,1,tp,HINTMSG_SPSUMMON)
	if #sg>0 then
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
			--
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(3301)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT|RESETS_REDIRECT)
			e1:SetValue(LOCATION_DECKBOT)
			sc:RegisterEffect(e1,true)
		end
	end
	Duel.SpecialSummonComplete()
end