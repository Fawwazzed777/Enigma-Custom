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
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	--hitung nama unik
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
		--minimal 1 monster, LP cukup
		return uniq>0 and Duel.CheckLPCost(tp,uniq*1000)
	end
	--pilih berapa monster (1 s/d uniq)
	local ct=Duel.AnnounceNumber(tp,table.unpack(aux.GetNumberTable(1,uniq)))
	e:SetLabel(ct)
	Duel.PayLPCost(tp,ct*1000)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE|LOCATION_REMOVED,0,nil,e,tp)
	local sg=Group.CreateGroup()
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if not tc then break end
		sg:AddCard(tc)
		g:Remove(Card.IsCode,nil,tc:GetCode())
	end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,#sg,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<#g or (#g>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)) then return end
	local c=e:GetHandler()
	for sc in g:Iter() do
		if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
			--Place it to the Extra Deck if it leaves the field
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
