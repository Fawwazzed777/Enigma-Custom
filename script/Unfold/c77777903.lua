--Dragoscendent Umbra
function c77777903.initial_effect(c)
  --tohand, SS
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777903,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c77777903.thcon)
	e1:SetTarget(c77777903.rtg)
	e1:SetOperation(c77777903.rop)
	c:RegisterEffect(e1)
  --Revealed by monster, search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetDescription(aux.Stringid(77777903,1))
  e3:SetCategory(CATEGORY_TOHAND)
  e3:SetCountLimit(1,77777903)
	e3:SetCode(77777900)
  e3:SetRange(LOCATION_HAND)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e3:SetTarget(c77777903.thtg)
  e3:SetOperation(c77777903.thop)
	c:RegisterEffect(e3)
  --synchro limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c77777903.synlimit)
	c:RegisterEffect(e2)
  --xyz limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(c77777903.synlimit)
	c:RegisterEffect(e4)
end

function c77777903.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x40d)
end

function c77777903.filter(c)
	return c:IsSetCard(0x40d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
    and not c:IsCode(77777903)
end
function c77777903.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777903.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777903.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777903.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c77777903.revfilter(c)
	return c:IsSetCard(0x40d) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c77777903.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c77777903.rtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777903.revfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
    	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77777903.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
  local g=Duel.SelectMatchingCard(tp,c77777903.revfilter,tp,LOCATION_HAND,0,1,1,c)
  --Reveals it and raises event to tell other cards they have been revealed
	Duel.ConfirmCards(1-tp,g)
	Duel.RaiseSingleEvent(g:GetFirst(),77777900,e,REASON_EFFECT,tp,tp,0)
	Duel.ShuffleHand(tp)
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end