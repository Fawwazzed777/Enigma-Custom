--Phantasm Servant Radeus
--Scripted by fawwazzed
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon itself from hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Send Spell, Special Summon from GY, then Fusion Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.ftg)
	e2:SetOperation(s.fop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Recover LP
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,{id,2})
	e4:SetCondition(s.reccon)
	e4:SetOperation(s.recop)
	c:RegisterEffect(e4)
end
s.listed_names={8855578}
s.listed_series={0x46}
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,1000)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function s.spellfilter(c)
	return c:IsSpell() and (c:IsCode(8855578) or c:IsSetCard(0x46))
		and c:IsAbleToGrave()
end
function s.revfilter(c,e,tp)
	return c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.mfilter(c,e,tp)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
		and (c:IsControler(tp) or c:IsFaceup())
end
function s.ffilter(c,e,tp,mg,gc)
	return c:IsType(TYPE_FUSION) 
		and (c:IsAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_WYRM))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
		and c:CheckFusionMaterial(tp,mg,gc,tp)
end
function s.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spellfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(s.revfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.fop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Send 1 "Dimension of Destruction" or "Fusion" Spell
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,s.spellfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if #sg==0 or Duel.SendtoGrave(sg,REASON_EFFECT)==0 or not sg:GetFirst():IsLocation(LOCATION_GRAVE) then return end	
	--Special Summon from GY (Negated)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.revfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end	
	Duel.HintSelection(g)
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()	
	--Optional Fusion Summon 
	if c:IsRelateToEffect(e) and c:IsOnField() and not c:IsImmuneToEffect(e) and c:IsCanBeFusionMaterial() then
	local fusion_params={handler=c,
		fusfilter=function(c) return c:IsAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_WYRM) end,
		matfilter=function(c) return c:IsOnField() end,
		extrafil=function(e,tp,mg) return Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,0,LOCATION_MZONE,nil) end, gc=c}
		local chk_fusion=Fusion.SummonEffTG(fusion_params)(e,tp,eg,ep,ev,re,r,rp,0)
		if chk_fusion and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Fusion.SummonEffOP(fusion_params)(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1500,REASON_EFFECT)
end