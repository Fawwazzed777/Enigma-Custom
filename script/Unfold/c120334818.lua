--Ultimaya King Surging Storm
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	c:EnableReviveLimit()
	Pendulum.AddProcedure(c)
	Xyz.AddProcedure(c,s.matfilter,10,2)
	--Xyz with "Ultimaya Draco Lord"
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_XYZ_LEVEL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e0:SetTarget(function(e,c) return c:IsCode(49968956) end)
	e0:SetValue(function(e,_,rc) return rc==e:GetHandler() and 10 or 0 end)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.sscon)
	e1:SetCost(Cost.DetachFromSelf(1,1,nil))
	e1:SetTarget(s.sstg)
	e1:SetOperation(s.ssop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,{id,1})
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.t)
	e2:SetOperation(s.o)
	c:RegisterEffect(e2)
	--You want some Vanilla ?
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_CHANGE_TYPE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(s.vanilla)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(TYPE_NORMAL+TYPE_MONSTER)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTarget(s.vanilla)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(-700)
	c:RegisterEffect(e4)
	--def change
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetValue(-700)
	c:RegisterEffect(e5)

end
s.pendulum_level=10
s.listed_names={49968956}
s.listed_series={0x309,0xa309}
function s.matfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_PENDULUM,xyz,sumtype,tp) and c:IsSetCard(0x309,xyz,sumtype,tp)
end
function s.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsType,TYPE_PENDULUM),tp,LOCATION_EXTRA,0,nil)>0
end
function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsType,TYPE_PENDULUM),tp,LOCATION_EXTRA,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0,nil)
end
function s.ssop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsType,TYPE_PENDULUM),tp,LOCATION_EXTRA,0,nil)
	local ct=Duel.SendtoGrave(g,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) then
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	if #sg>0 then
	Duel.HintSelection(sg)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
end
end
function s.mfilter(c)
	local p=c:GetOwner()
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:CheckUniqueOnField(p,LOCATION_PZONE)
		and (c:IsLocation(LOCATION_MZONE) or not c:IsForbidden())
end
function s.t(e,tp,eg,ep,ev,re,r,rp,chk,chkc)	
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.mfilter(chkc) end
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	and Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function s.o(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,s.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
	Duel.HintSelection(tc)
	Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_PZONE,POS_FACEUP,true)
end
end
function s.vanilla(e,c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
