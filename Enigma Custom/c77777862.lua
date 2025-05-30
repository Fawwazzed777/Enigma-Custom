--Psybernated Girl Anna
function c77777862.initial_effect(c)
  --pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777862,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,77777862+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c77777862.pcon)
	e2:SetTarget(c77777862.ptg)
	e2:SetOperation(c77777862.pop)
	c:RegisterEffect(e2)
  --SS on banish
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777862,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
  e4:SetCountLimit(1,77777862)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c77777862.sumtg)
	e4:SetOperation(c77777862.sumop)
	c:RegisterEffect(e4)
  --spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_HAND)
  e5:SetCountLimit(1,77777861)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
  e5:SetDescription(aux.Stringid(77777862,0))
	e5:SetCondition(c77777862.spcon1)
	e5:SetTarget(c77777862.sptg1)
	e5:SetOperation(c77777862.spop1)
	c:RegisterEffect(e5)
end

function c77777862.pcon(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  if tc1==e:GetHandler() then tc1=tc2 end
  return tc1 and tc1:IsSetCard(0x40b)
end
function c77777862.pfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x40b) and c:IsAbleToHand()
end
function c77777862.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777862.pfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c77777862.pop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777862.pfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~= 0 then
      Duel.ConfirmCards(1-tp,g)
      Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
    end
	end
end


function c77777862.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x40b) and c:GetSummonPlayer()==tp
end
function c77777862.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77777862.cfilter,1,nil,tp)
end
function c77777862.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77777862.spop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
      local tc2=eg:GetFirst()
      while tc2 do
        if tc2:IsSetCard(0x40b) then
          local e1=Effect.CreateEffect(e:GetHandler())
          e1:SetType(EFFECT_TYPE_SINGLE)
          e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
          e1:SetCode(EFFECT_UPDATE_ATTACK)
          e1:SetValue(400)
          e1:SetReset(RESET_EVENT+0x1fe0000)
          tc2:RegisterEffect(e1)
        end
        tc2=eg:GetNext()
      end
    end
	end
end


function c77777862.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c77777862.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end