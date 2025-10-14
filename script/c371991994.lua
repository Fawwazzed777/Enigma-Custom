--
Duel.LoadScript("c511001822.lua")
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(s.stfilter),1,1,Synchro.NonTunerEx(s.stfilter1),1,1,s.matfilter)
	--Synchro summon level
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCode(EFFECT_SYNCHRO_LEVEL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(function(e,c) return (c:IsMonster() and c:IsCode(371991989)) end)
	e0:SetValue(function(e,c) return 2<<16|c:GetLevel() end) 
	c:RegisterEffect(e0)
	--I Just Don't Care
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(511010508)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCountLimit(1,{id,1})
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(s.c)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
s.listed_names={371991989}
function s.stfilter(c,val,scard,sumtype,tp)
	return c:IsRace(RACE_MACHINE,scard,sumtype,tp) and c:IsType(TYPE_EFFECT,scard,sumtype,tp)
end

function s.stfilter1(c,val,scard,sumtype,tp)
	return c:IsType(TYPE_FUSION,scard,sumtype,tp) and Card.ListsCode(c,371991989,scard,sumtype,tp)
end
function s.matfilter(c,scard,sumtype,tp)
	return c:IsCode(371991989)
end
function s.val(e,re,c)
	return (re:GetCode()==EFFECT_INDESTRUCTABLE_BATTLE or re:GetCode()==EFFECT_INDESTRUCTABLE_COUNT or re:GetCode()==EFFECT_INDESTRUCTABLE_EFFECT)
		and (not re:IsHasType(EFFECT_TYPE_SINGLE) or re:GetOwner()==c)
		and (not re:IsHasType(EFFECT_TYPE_FIELD) or re:GetActivateLocation()>0)
		and not re:GetHandler():IsHasEffect(EFFECT_CANNOT_DISABLE)
end
function s.disfilter(c)
	return c:IsFaceup() and c:Type(TYPE_EFFECT) and not c:IsDisabled()
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	local g=Duel.SelectMatchingCard(tp,s.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetRange(LOCATION_ONFIELD)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetValue(function(e,te) return te:GetOwner()~=e:GetOwner() end)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		tc:RegisterEffect(e3,true)
		Duel.AdjustInstantly(tc)
		e:SetProperty(e:GetProperty()&~EFFECT_FLAG_IGNORE_IMMUNE)
end
end
function s.c(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function s.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_FUSION)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil)
			and Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)~=0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			local rg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil) 
			Duel.Destroy(rg,REASON_EFFECT)
end
end
end
end