--Aerolizer Valor Wing - Martia
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterSummonCode(499689705),1,1,Synchro.NonTuner(Card.IsAttribute,ATTRIBUTE_WIND),1,99)
	c:EnableReviveLimit()
	--Pay LP to Special Summon Synchro from GY or Banished
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1,id)
	e0:SetCost(s.lpcost)
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)
	--Send to GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_RECOVER)
	e1:SetCountLimit(1)
	e1:SetCondition(s.ctcon)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
end
s.material={499689705}
s.listed_names={499689705}
function s.spfilter(c,e,tp)
	return c:IsMonster() and c:IsType(TYPE_SYNCHRO) and c:IsFaceup() 
	and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local lp=Duel.AnnounceNumber(tp,1000,2000,3000)
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
		local atk=lp/1000*800
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_UPDATE_ATTACK)
		e0:SetValue(atk)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e0)
			--Place it on the Extra Deck if it leaves the field
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetDescription(aux.Stringid(id,4))
			e0:SetCategory(CATEGORY_TOEXTRA)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e0:SetReset(RESET_EVENT|RESETS_REDIRECT)
			e0:SetValue(LOCATION_DECKBOT)
			sc:RegisterEffect(e0,true)
	end
	Duel.SpecialSummonComplete()
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function s.ctfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk-1) and c:IsAbleToGrave()
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttack()) end
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if c:IsFaceup() then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_UPDATE_ATTACK)
		e0:SetValue(600)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	if	c:RegisterEffect(e0)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
	local g=Duel.SelectMatchingCard(tp,s.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c:GetAttack())
	if #g>0 then
	Duel.HintSelection(g)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
end
end
end