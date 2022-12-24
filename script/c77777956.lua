--Mechanoclast Barrier Mech
function c77777956.initial_effect(c)
  --link summon
	aux.AddLinkProcedure(c,nil,3,3)
	c:EnableReviveLimit()
  --battle
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
  e0:SetCondition(c77777956.indcon)
	e0:SetValue(1)
	c:RegisterEffect(e0)
  --indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c77777956.indcon)
	e1:SetTarget(c77777956.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
  --indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c77777956.indcon2)
	e2:SetTarget(c77777956.indtg2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
  local e3=e2:Clone()
  e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e3:SetCondition(c77777956.indcon3)
  c:RegisterEffect(e3)
  local e4=e2:Clone()
  e4:SetCode(EFFECT_CANNOT_REMOVE)
  e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
  e4:SetCondition(c77777956.indcon4)
  e4:SetTarget(c77777956.indtg3)
  c:RegisterEffect(e4)
  --remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77777956,0))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c77777956.indcon4)
	e5:SetTarget(c77777956.rmtg)
	e5:SetOperation(c77777956.rmop)
	c:RegisterEffect(e5)
end

function c77777956.countfilter(c)
	return c:IsSetCard(0x40e) and c:IsFaceup() and (c:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT or c:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT+TYPE_LINK)
end
function c77777956.nobanfilter(c)
	return c:IsSetCard(0x40e) and c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77777956.indcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroup(c77777956.countfilter,e:GetHandler():GetControler(),LOCATION_SZONE,0,nil):GetCount()>=2
end
function c77777956.indtg(e,c)
	return e:GetHandler()==c or e:GetHandler():GetLinkedGroup():IsContains(c)
end

function c77777956.indcon2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroup(c77777956.countfilter,e:GetHandler():GetControler(),LOCATION_SZONE,0,nil):GetCount()>=3
end
function c77777956.indtg2(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end

function c77777956.indcon3(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroup(c77777956.countfilter,e:GetHandler():GetControler(),LOCATION_SZONE,0,nil):GetCount()>=4
end

function c77777956.indcon4(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroup(c77777956.countfilter,e:GetHandler():GetControler(),LOCATION_SZONE,0,nil):GetCount()==5
end

function c77777956.indtg3(e,c)
	return Duel.GetMatchingGroup(c77777956.nobanfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil):IsContains(c)
end


function c77777956.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c77777956.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end