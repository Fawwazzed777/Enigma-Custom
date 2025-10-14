--Witchcrafter Olivia
function c77777892.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),6,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c77777892.splimit)
	c:RegisterEffect(e2)
	--scale swap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(77777892,3))
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCondition(c77777892.sccon)
	e3:SetOperation(c77777892.scop)
	c:RegisterEffect(e3)
	--Pendulum Place
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77777892,4))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c77777892.pcon)
	e5:SetOperation(c77777892.pop)
	c:RegisterEffect(e5)
  --indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(c77777892.indtg)
	e1:SetValue(c77777892.indval)
	c:RegisterEffect(e1)
  --all monsters gain atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCategory(CATEGORY_DEFCHANGE)
	e4:SetCondition(c77777892.sccon)
	e4:SetDescription(aux.Stringid(77777892,1))
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetOperation(c77777892.defoperation)
	c:RegisterEffect(e4)
  --cannot disable summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x407))
	c:RegisterEffect(e6)
  local e11=e6:Clone()
  e11:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
  c:RegisterEffect(e11)
  --atk gain per xyz material
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	e7:SetValue(c77777892.adval)
	c:RegisterEffect(e7)
  local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_CHAINING)
	e8:SetRange(LOCATION_MZONE)
	e8:SetOperation(c77777892.chainop)
	c:RegisterEffect(e8)
  --atk up
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetRange(LOCATION_MZONE)
  e3:SetDescription(aux.Stringid(77777892,0))
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetCountLimit(1)
  e10:SetCost(c77777892.atkcost)
	e10:SetTarget(c77777892.atktg1)
	e10:SetOperation(c77777892.atkop1)
	c:RegisterEffect(e10)
end
c77777892.pendulum_level=6

function c77777892.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c77777892.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c77777892.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x407) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c77777892.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function c77777892.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local scl=c:GetLeftScale()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(c:GetRightScale())
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	e2:SetValue(scl)
	c:RegisterEffect(e2)
end


function c77777892.pcon(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  return not tc1 or not tc2
end
function c77777892.pop(e,tp,eg,ep,ev,re,r,rp)
  local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  if(tc1 and tc2) then return end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end

function c77777892.adval(e,c)
	return e:GetHandler():GetOverlayCount()*100
end

function c77777892.defoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77777892.filter2,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c77777892.indtg(e,c)
	return c:IsSetCard(0x407) and c~=e:GetHandler()
end

function c77777892.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x407)
end
function c77777892.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77777892.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77777892.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c77777892.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c77777892.atkop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

function c77777892.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
  local eg=te:GetHandler()
	return eg:GetHandler(0x5d2) or eg:GetHandler(0x95)
end
function c77777892.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c77777892.chainop(e,tp,eg,ep,ev,re,r,rp)
	if (re:GetHandler():IsSetCard(0x5d2) or re:GetHandler():IsSetCard(0x95) or re:GetHandler():IsCode(71345905) or re:GetHandler():IsCode(511000225)) and re:GetHandler():IsType(TYPE_SPELL) then
		Duel.SetChainLimit(c77777892.chainlm)
	end
end
function c77777892.chainlm(e,rp,tp)
	return tp==rp
end

function c77777892.indval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end