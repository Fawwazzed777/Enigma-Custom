--Enigmation - Draconic Phantasm
Duel.LoadScript("proc_xyz_unified.lua")
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Xyz Summon
	aux.XyzUnified.AddProcedure(
	c,
	12,
	aux.FilterBoolFunctionEx(s.xp), -- normal material
	function(tc,tp,lc)             -- ALT material
		return tc:IsFaceup()
			and tc:IsSetCard(0x145)
			and tc:IsType(TYPE_XYZ)
	end,
	5,
	aux.Stringid(id,2)
)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.con)
	e3:SetOperation(s.sumsuc)
	c:RegisterEffect(e3)
	--cannot disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.cnvalue)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e5)
	--Material Check
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(s.valcheck)
	e6:SetLabelObject(e3)
	c:RegisterEffect(e6)	
end
s.listed_names={640146361}
s.listed_series={0x344,0x145}
function s.xp(c,fc,sumtype,tp)
	return c:IsSetCard(0x344) or c:IsSetCard(0x145)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (loc&LOCATION_ONFIELD)~=0
		and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and c:IsType(TYPE_XYZ) then
		rc:CancelToGrave()
		Duel.Overlay(c,Group.FromCards(rc))
	end
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local g=e:GetHandler():GetOverlayGroup()
	Duel.SendtoGrave(g,REASON_COST)
end
function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
	Duel.SetChainLimit(s.chlimit)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	Duel.RemoveCards(c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local token=Duel.CreateToken(tp,640146361)
		Duel.MoveToField(token,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		Duel.BreakEffect()
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()==1
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0x145) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function s.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_XYZ) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(1-tp,LOCATION_ONFIELD)
	e1:SetTarget(s.disable)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.disable(e,c)
	return c~=e:GetHandler() and (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or (c:GetOriginalType()&TYPE_EFFECT)==TYPE_EFFECT))
end
function s.cnvalue(e,ct)
	return Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT):GetHandler()==e:GetHandler()
end
