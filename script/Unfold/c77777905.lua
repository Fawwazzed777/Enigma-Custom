--Dragoscendent Lux
function c77777905.initial_effect(c)
	--Reveal
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777905,0))
	e1:SetCategory(CATEGORY_ANNOUNCE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c77777905.tg)
	e1:SetOperation(c77777905.op)
	c:RegisterEffect(e1)
  --SS
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777905,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_TYPE_SINGLE+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c77777905.cncon)
	e2:SetTarget(c77777905.thtg)
	e2:SetOperation(c77777905.thop)
	c:RegisterEffect(e2)
  --synchro limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(c77777905.synlimit)
	c:RegisterEffect(e4)
  --xyz limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c77777905.synlimit)
	c:RegisterEffect(e3)
end

function c77777905.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x40d)
end

function c77777905.revfilter(c)
	return c:IsSetCard(0x40d) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
--Makes sure you have the proper cards in hand and this card can be SS
function c77777905.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777905.revfilter,tp,LOCATION_HAND,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,1,0,0)
end

function c77777905.op(e,tp,eg,ep,ev,re,r,rp,chk)
  --Checks to see that there is still another monster in your hand, and selects it.
	if not Duel.IsExistingMatchingCard(c77777905.revfilter,tp,LOCATION_HAND,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c77777905.revfilter,tp,LOCATION_HAND,0,1,1,nil)
  --Reveals it and raises event to tell other cards they have been revealed
	Duel.ConfirmCards(1-tp,g)
	Duel.RaiseSingleEvent(g:GetFirst(),77777900,e,REASON_EFFECT,tp,tp,0)
	Duel.ShuffleHand(tp)
end

function c77777905.cncon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:IsSetCard(0x40d) and ec:GetSummonType()==SUMMON_TYPE_SYNCHRO and ec:GetSummonPlayer()==tp
end
function c77777905.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
    and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
    and Duel.IsExistingMatchingCard(c77777905.thfilter,tp,LOCATION_GRAVE,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c77777905.thfilter(c)
	return c:IsSetCard(0x40d) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c77777905.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
  --SS this card
  if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
  if Duel.IsExistingMatchingCard(c77777905.thfilter,tp,LOCATION_GRAVE,0,1,nil) then
    Duel.BreakEffect()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77777905.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  end
end