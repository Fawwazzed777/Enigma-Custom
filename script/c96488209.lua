--Enigmation - Phantasm Kaiser
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK),8,5)
	c:EnableReviveLimit()
	--Check materials used for its Xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.regcon)
	e1:SetOperation(s.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--ATK Up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.effcon)
	e3:SetCost(Cost.Detach(1,1))
	e3:SetTarget(s.rtg)
	e3:SetOperation(s.rop)
	c:RegisterEffect(e3)
	--Would Leave the Field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.effcon)
	e4:SetTarget(s.reptg)
	c:RegisterEffect(e4)
	--indes
	local en=Effect.CreateEffect(c)
	en:SetType(EFFECT_TYPE_SINGLE)
	en:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	en:SetRange(LOCATION_MZONE)
	en:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	en:SetValue(1)
	c:RegisterEffect(en)
	--spsummon condition
	local et=Effect.CreateEffect(c)
	et:SetType(EFFECT_TYPE_SINGLE)
	et:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	et:SetCode(EFFECT_SPSUMMON_CONDITION)
	et:SetValue(s.splimit)
	c:RegisterEffect(et)
end
s.listed_names={96488201}

function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.xyzlimit(e,se,sp,st)
end
--Check
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():GetSummonType()&SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and e:GetLabel()==1
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
end
function s.matfilter(c,sc)
	return c:IsCode(96488201)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(s.matfilter,1,nil,c) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function s.effcon(e)
	return e:GetHandler():GetFlagEffect(id)>0
end
--
function s.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,0,0)
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
		if #g>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(#g*1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
end
end
end
--
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE)
	 and c:GetOverlayGroup():IsExists(Card.IsAbleToRemoveAsCost,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
	local ovg=c:GetOverlayGroup()
	local rg=Duel.Remove(ovg,POS_FACEUP,REASON_COST)
	local g=Duel.SelectMatchingCard(tp,Card.IsRemovable,tp,0,LOCATION_ONFIELD,rg,rg,nil)
		if #g>0 then
		Duel.HintSelection(g)
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==0 then return end
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		if #og>0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
			local sg=og:Select(tp,1,2,nil)
			Duel.BreakEffect()
			Duel.Overlay(c,sg)
	end
		return true
	else return false end
end
end

