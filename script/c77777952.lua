--Mechanoclast Behemoth
function c77777952.initial_effect(c)
  --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x40e),2,2)
	c:EnableReviveLimit()
  --ss success
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777952,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c77777952.con)
	e4:SetTarget(c77777952.tg)
	e4:SetOperation(c77777952.op)
	c:RegisterEffect(e4)
  --destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77777952,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
  e5:SetCountLimit(1)
	e5:SetCost(c77777952.descost)
	e5:SetTarget(c77777952.destg)
	e5:SetOperation(c77777952.desop)
	c:RegisterEffect(e5)
end

function c77777952.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c77777952.filter(c)
	return c:IsSetCard(0x40e) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_LINK)
end
function c77777952.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1  and Duel.IsExistingMatchingCard(c77777952.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp)
	end
end
function c77777952.op(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
  local g=Duel.SelectMatchingCard(tp,c77777952.filter,tp,LOCATION_GRAVE,0,2,2,nil)
  local c=g:GetFirst()
  Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
  local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(77777942,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
  c=g:GetNext()
  Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
  local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_CHANGE_TYPE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+0x1fc0000)
	e2:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(77777942,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
end


function c77777952.countfilter(c)
	return c:IsSetCard(0x40e) and c:IsFaceup() and (c:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT or c:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT+TYPE_LINK) and c:IsAbleToGraveAsCost()
end
function c77777952.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777952.countfilter,tp,LOCATION_SZONE,0,1,nil) end
  local g=Duel.SelectMatchingCard(tp,c77777952.countfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function c77777952.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77777952.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end