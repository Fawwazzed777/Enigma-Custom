--Boulderous Elementalist
function c77777967.initial_effect(c)
  --link summon
	aux.AddLinkProcedure(c,c77777967.sumfilter,2,2)
	c:EnableReviveLimit()
  --indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c77777967.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
  --battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetValue(c77777967.atlimit)
	c:RegisterEffect(e3)
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e5)
  --replace
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77777967,0))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e6:SetCountLimit(1)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c77777967.tgcondition)
	e6:SetTarget(c77777967.tgtarget)
	e6:SetOperation(c77777967.tgoperation)
	c:RegisterEffect(e6,false,1)
end

function c77777967.sumfilter(c)
	return c:IsSetCard(0x40f) or c:IsRace(RACE_ROCK)
end
function c77777967.atlimit(e,c)
	return c:IsFaceup() and c~=e:GetHandler() and c:IsSetCard(0x42)
end
function c77777967.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end



function c77777967.tgfilter(c,e,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c) and c==e:GetHandler()
end
function c77777967.tgtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	if chkc then return chkc:IsOnField() and c77777967.tgfilter(chkc,e,re,rp,tf,ceg,cep,cev,cre,cr,crp) end
	if chk==0 then return Duel.IsExistingTarget(c77777967.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetLabelObject(),e,re,rp,tf,ceg,cep,cev,cre,cr,crp) end
end
function c77777967.tgoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		Duel.ChangeTargetCard(ev,Group.FromCards(tc))
	end
end
