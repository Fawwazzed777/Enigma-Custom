--Mechanoclast Retriever
function c77777953.initial_effect(c)
  --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x40e),2,2)
	c:EnableReviveLimit()
  --Place counters
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77777953,0))
  e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
	e3:SetTarget(c77777953.distg2)
	e3:SetOperation(c77777953.disop2)
	c:RegisterEffect(e3)
  --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetDescription(aux.Stringid(77777953,1))
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,77777953)
	e2:SetTarget(c77777953.thtg)
	e2:SetOperation(c77777953.thop)
	c:RegisterEffect(e2)
end

function c77777953.counterfilter(c)
	return c:IsFaceup() and c:IsCode(77777942)
end

function c77777953.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777953.counterfilter,tp,LOCATION_SZONE,0,1,nil)end
end
function c77777953.disop2(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.IsExistingMatchingCard(c77777953.counterfilter,tp,LOCATION_SZONE,0,1,nil) then return end
  local g2=Duel.SelectMatchingCard(tp,c77777953.counterfilter,tp,LOCATION_SZONE,0,1,1,nil)
  local tc=g2:GetFirst()
  tc:AddCounter(0x40e,2)
end

function c77777953.thfilter(c)
	return c:IsSetCard(0x40e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c77777953.thfilter2(c)
	return c:IsCode(77777942)and c:IsAbleToHand()
end
function c77777953.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777953.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c77777953.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777953.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
      Duel.ConfirmCards(1-tp,g)
      if Duel.IsExistingMatchingCard(c77777953.thfilter2,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(77777953,2)) then
        local g2=Duel.SelectMatchingCard(tp,c77777953.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
        if g2:GetCount()>0 then
          Duel.SendtoHand(g2,nil,REASON_EFFECT)
          Duel.ConfirmCards(1-tp,g2)
        end
      end
    end
	end
end
