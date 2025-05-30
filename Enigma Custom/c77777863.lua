--Psybernated Adventurer Alexa
function c77777863.initial_effect(c)
  --pendulum summon
	aux.EnablePendulumAttribute(c)
  --extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
  e2:SetCondition(c77777863.pcon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x40b))
	c:RegisterEffect(e2)
  --to hand on banish
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777863,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c77777863.ptg)
	e4:SetOperation(c77777863.pop)
	c:RegisterEffect(e4)
end

function c77777863.pcon(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  if tc1==e:GetHandler() then tc1=tc2 end
  return tc1 and tc1:IsSetCard(0x40b)
end


function c77777863.pfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x40b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(77777863)
end
function c77777863.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777863.pfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c77777863.pop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777863.pfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~= 0 then
      Duel.ConfirmCards(1-tp,g)
    end
	end
end