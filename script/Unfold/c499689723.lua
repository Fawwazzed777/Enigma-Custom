--Aerolizer Valor Wing - Karti
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterSummonCode(499689705),1,1,Synchro.NonTuner(Card.IsAttribute,ATTRIBUTE_WIND),1,99)
	c:EnableReviveLimit()
	--Pay LP to Special Summon Synchro from GY or Banished
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.lpcost)
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
function s.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local lp=Duel.AnnounceNumber(tp,800,1600,2400)
	Duel.PayLPCost(tp,lp)
	e:SetLabel(lp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local lp=e:GetLabel()
	if lp<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	if not sc then return end
	if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP_ATTACK)>0 then
		--ATK gain
		local atk=lp/800*600
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_UPDATE_ATTACK)
		e0:SetValue(atk)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e0)
			--Place it on the bottom of the Deck if it leaves the field
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(3301)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT|RESETS_REDIRECT)
			e1:SetValue(LOCATION_DECKBOT)
			sc:RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete()
end
