--Mechanoclast Power Core
function c77777942.initial_effect(c)
  c:EnableCounterPermit(0x40e)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c77777942.activate)
	c:RegisterEffect(e1)
  --ss success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777942,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_FZONE)
  e2:SetCountLimit(1,77777942)
	e2:SetCondition(c77777942.sscon)
	e2:SetCost(c77777942.spcost)
	e2:SetTarget(c77777942.sptg)
	e2:SetOperation(c77777942.spop)
	c:RegisterEffect(e2)
  --atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x40e))
	e3:SetValue(c77777942.atkval)
	c:RegisterEffect(e3)
  --cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
  e4:SetCondition(c77777942.actcon)
	c:RegisterEffect(e4)
  --indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e5:SetCondition(c77777942.descon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(e6)
end

function c77777942.atkval(e,c)
	return e:GetHandler():GetCounter(0x40e)*50
end

function c77777942.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x40e) and c:IsAbleToHand()
end
function c77777942.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c77777942.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(77777942,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
      Duel.ConfirmCards(1-tp,sg)
      e:GetHandler():AddCounter(0x40e,1)
    end
	end
end

function c77777942.actcon(e)
  return e:GetHandler():GetCounter(0x40e)<=0
end

function c77777942.countfilter(c)
	return c:IsSetCard(0x40e) and c:IsFaceup() and (c:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT or c:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT+TYPE_LINK)
end
function c77777942.descon(e,tp)
  return e:GetHandler():GetCounter(0x40e)>0 and Duel.IsExistingMatchingCard(c77777942.countfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c77777942.sscon(e,tp)
  return Duel.IsExistingMatchingCard(c77777942.countfilter,tp,LOCATION_SZONE,0,5,nil)
end



function c77777942.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x40e,5,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x40e,5,REASON_COST)
end

function c77777942.spfilter(c,e,tp)
	return c:IsSetCard(0x40e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777942.filter(c)
	return c:IsSetCard(0x40e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c77777942.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  local free=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return free>0  and Duel.IsExistingMatchingCard(c77777942.spfilter,tp,LOCATION_SZONE,0,free,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,free,tp,LOCATION_SZONE)
end
function c77777942.spop(e,tp,eg,ep,ev,re,r,rp)
  local free=Duel.GetLocationCount(tp,LOCATION_MZONE)
  if free<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777942.spfilter,tp,LOCATION_SZONE,0,free,free,nil,e,tp)
	if g:GetCount()==free then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>=4 and Duel.IsExistingMatchingCard(c77777942.filter,tp,LOCATION_DECK,0,2,nil) then
      Duel.BreakEffect()
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
      local g=Duel.SelectMatchingCard(tp,c77777942.filter,tp,LOCATION_DECK,0,2,2,nil)
      if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
      end
    end
	end
end
