--Eternity Ace - High Emperor
local s,id=GetID()
function s.initial_effect(c)
c:SetUniqueOnField(1,0,id)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,s.ffilter1,s.ffilter2,s.ffilter3,s.ffilter4)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetRange(0x7)
	e0:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(s.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_RELEASE)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(s.atkval)
    c:RegisterEffect(e3)
    local ec=e3:Clone()
    ec:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(ec)
    --
    local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetTarget(s.indtg1)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--End their ego and meaningless whim
	local emperor_rules=Effect.CreateEffect(c)
	emperor_rules:SetDescription(aux.Stringid(id,0))
	emperor_rules:SetType(EFFECT_TYPE_QUICK_O)
	emperor_rules:SetCode(EVENT_FREE_CHAIN)
	emperor_rules:SetCountLimit(1)
	emperor_rules:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	emperor_rules:SetRange(LOCATION_MZONE)
	emperor_rules:SetCost(s.cost)
	emperor_rules:SetTarget(s.t)
	emperor_rules:SetOperation(s.o)
	c:RegisterEffect(emperor_rules)
end
s.listed_names={16299999}
s.material_setcode={0x994}
function s.ffilter1(c,fc,sumtype,tp)
	return c:IsCode(16299999)
end
function s.ffilter2(c,fc,sumtype,tp)
	return c:IsSetCard(0x994) and c:IsAttribute(ATTRIBUTE_LIGHT) 
end
function s.ffilter3(c,fc,sumtype,tp)
	return c:IsSetCard(0x994) and c:IsAttribute(ATTRIBUTE_DARK) 
end
function s.ffilter4(c,fc,sumtype,tp)
	return c:IsCode(14899999) and c:IsLocation(LOCATION_FZONE)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(function(c) return (c:IsType(TYPE_MONSTER) or c:IsCode(14899999)) and c:IsAbleToDeckOrExtraAsCost() end,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST+REASON_MATERIAL)
end
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function s.att(c,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK)
end
function s.indtg(e,c)
	return c:IsSetCard(0x994) and c:IsAttribute(ATTRIBUTE_DARK)
end
function s.indtg1(e,c)
	return c:IsSetCard(0x994) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.atkval(e,c)
    return Duel.GetMatchingGroupCount(aux.FaceupFilter(s.att),c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c)*500 
 end
 function s.rtfilter(c)
	return c:IsMonster() and c:IsSetCard(0x994) and c:IsAbleToDeckAsCost()
end
 function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rtfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local cg=Duel.SelectMatchingCard(tp,s.rtfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.HintSelection(cg)
	Duel.SendtoDeck(cg,nil,2,REASON_COST)
end
function s.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
 --Ignore
function s.t(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function s.o(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,s.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	for tc in aux.Next(sg) do
		e:SetProperty(e:GetProperty()|EFFECT_FLAG_IGNORE_IMMUNE)
		Duel.HintSelection(sg)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(e:GetHandler())
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
