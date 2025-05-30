function c77777938.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCountLimit(1,77777938+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x999))
	e2:SetValue(300)
	c:RegisterEffect(e2)
  local e3=e2:Clone()
  e3:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e3)
  --sset from deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777938,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c77777938.target)
	e4:SetOperation(c77777938.operation)
	c:RegisterEffect(e4)
  local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77777938,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c77777938.target2)
	e5:SetOperation(c77777938.operation2)
	c:RegisterEffect(e5)
  local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77777938,2))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c77777938.target3)
	e6:SetOperation(c77777938.operation3)
	c:RegisterEffect(e6)
--[[  --to hand
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
  e7:SetCountLimit(1,77777938)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCondition(c77777938.thcon2)
	e7:SetTarget(c77777938.thtg2)
	e7:SetOperation(c77777938.thop2)
	c:RegisterEffect(e7)]]
  --splimit
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(1,0)
	e8:SetTarget(c77777938.splimit)
	c:RegisterEffect(e8)
end

function c77777938.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c77777938.filter(c)
	return c:IsSetCard(0x999) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(77777938) and c:IsSSetable()
end
function c77777938.filter2(c)
	return c:IsSetCard(0x999) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function c77777938.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c77777938.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c77777938.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c77777938.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SSet(tp,g:GetFirst())~=0 then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_CANNOT_TRIGGER)
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      g:GetFirst():RegisterEffect(e1)
    end
		Duel.ConfirmCards(1-tp,g)
	end
end

function c77777938.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c77777938.filter2,tp,LOCATION_GRAVE,0,1,nil) end
end
function c77777938.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c77777938.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SSet(tp,g:GetFirst())~=0 then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_CANNOT_TRIGGER)
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      g:GetFirst():RegisterEffect(e1)
    end
		Duel.ConfirmCards(1-tp,g)
	end
end


      

function c77777938.filter3(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsType(TYPE_FIELD)
end
function c77777938.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c77777938.filter3,tp,0,LOCATION_GRAVE,1,nil) end
end
function c77777938.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c77777938.filter3,tp,0,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SSet(tp,g:GetFirst())~=0 then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_CANNOT_TRIGGER)
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      g:GetFirst():RegisterEffect(e1)
    end
		Duel.ConfirmCards(1-tp,g)
	end
end


function c77777938.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT)
end
function c77777938.thfilter2(c)
	return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c77777938.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777938.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777938.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777938.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end