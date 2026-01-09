--Enigmation - Phantasm Hydra
local s,id=GetID()
function s.initial_effect(c)
	--Must be properly summoned before reviving
	c:EnableReviveLimit()
	--Xyz summon procedure
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x344),9,4,nil,nil,Xyz.InfiniteMats)
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
	--Extra busted
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.effcon)
	e3:SetCost(s.rcost)
	e3:SetTarget(s.rtg)
	e3:SetOperation(s.rop)
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--cannot be banished
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_REMOVE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,1)
	e5:SetTarget(s.rmlimit)
	c:RegisterEffect(e5)
	--Battle debuff + negate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e6:SetCondition(s.battlecon)
	e6:SetOperation(s.battleop)
	c:RegisterEffect(e6)
	--spsummon condition
	local er=Effect.CreateEffect(c)
	er:SetType(EFFECT_TYPE_SINGLE)
	er:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	er:SetCode(EFFECT_SPSUMMON_CONDITION)
	er:SetValue(aux.xyzlimit)
	c:RegisterEffect(er)
end
function s.rmlimit(e,c,tp,r)
	return c==e:GetHandler() and r==REASON_EFFECT
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():GetSummonType()&SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and e:GetLabel()==1
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
end
function s.matfilter(c,sc)
	return c:IsSetCard(0x344) and c:IsType(TYPE_XYZ,sc,SUMMON_TYPE_XYZ)
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
function s.stfilter(c)
	return c:IsSpellTrap() and c:IsAbleToRemove()
end
function s.rcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_SZONE)>0 end
	local g=Duel.GetMatchingGroup(s.stfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.stfilter,tp,0,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==0 then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)
	local extra=math.floor(ct/5)
	if extra>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(extra)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
--Battle debuff
function s.battlecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc~=nil
end
function s.battleop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not bc or not bc:IsRelateToBattle() then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)
	local val=ct*600
	--ATK/DEF reduction
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
	bc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	bc:RegisterEffect(e2)
	--Negate effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(s.distg)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
	bc:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_DISABLE_EFFECT)
	bc:RegisterEffect(e4)
end
function s.distg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end