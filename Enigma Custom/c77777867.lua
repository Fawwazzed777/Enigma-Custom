--Psybernated Mecha Slyvia
function c77777867.initial_effect(c)
  --pendulum summon
	aux.EnablePendulumAttribute(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
  --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777867,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,77777867)
	e2:SetTarget(c77777867.ptg)
	e2:SetOperation(c77777867.pop)
	c:RegisterEffect(e2)
  --SS this card
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetDescription(aux.Stringid(77777867,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_HAND)
  e3:SetCondition(c77777867.pencon)
	e3:SetTarget(c77777867.pentg)
	e3:SetOperation(c77777867.penop)
	c:RegisterEffect(e3)
  --scale
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_LSCALE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c77777867.slcon)
	e4:SetValue(6)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e5)
  --negate on banish
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77777867,2))
	e6:SetCategory(CATEGORY_NEGATE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_REMOVE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e6:SetTarget(c77777867.distg)
	e6:SetOperation(c77777867.disop)
	c:RegisterEffect(e6)
end

function c77777867.slcon(e)
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  if tc1==e:GetHandler() then tc1=tc2 end
  return not tc1 or not tc1:IsSetCard(0x40b)
end
function c77777867.cfilter(c,tp)
	return c:IsSetCard(0x40b) and c:IsType(TYPE_MONSTER)and c:GetOwner()==tp
end
function c77777867.pencon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77777867.cfilter,1,nil,tp)
end
function c77777867.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c77777867.penop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end

function c77777867.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c77777867.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c77777867.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77777867.disfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c77777867.disfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c77777867.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		if Duel.GetCurrentPhase()==PHASE_END then
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		end
		tc:RegisterEffect(e1)
	end
end


function c77777867.pfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x40b) and c:IsAbleToRemove()
end
function c77777867.pfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c77777867.pfilter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c77777867.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777867.pfilter1,tp,LOCATION_MZONE,0,2,nil)and Duel.IsExistingMatchingCard(c77777867.pfilter3,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c77777867.pfilter2,tp,0,LOCATION_ONFIELD,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_MZONE)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,1-tp,LOCATION_ONFIELD)
end
function c77777867.pop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c77777867.pfilter1,tp,LOCATION_MZONE,0,2,2,nil)
  if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g2=Duel.SelectMatchingCard(tp,c77777867.pfilter3,tp,0,LOCATION_MZONE,1,1,nil)
    local g3=Duel.SelectMatchingCard(tp,c77777867.pfilter2,tp,0,LOCATION_ONFIELD,1,1,nil)
    g2:Merge(g3)
    Duel.Destroy(g2,REASON_EFFECT)
  end
end