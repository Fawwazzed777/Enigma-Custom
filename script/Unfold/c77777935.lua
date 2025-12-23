--Dragoscendent Outcast Malum
function c77777935.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x40d),3)
	c:EnableReviveLimit()
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(77777935,0))
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCountLimit(1,77777935+EFFECT_COUNT_CODE_OATH)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCondition(c77777935.thcon)
  e1:SetTarget(c77777935.thtg)
  e1:SetOperation(c77777935.thop)
  c:RegisterEffect(e1)
  --spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetDescription(aux.Stringid(77777935,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,77777935)
  e3:SetCondition(c77777935.spcon)
	e3:SetTarget(c77777935.sptg2)
	e3:SetOperation(c77777935.spop2)
	c:RegisterEffect(e3)
end

function c77777935.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_LINK
end
function c77777935.spfilter2(c,e,tp)
	return c:IsSetCard(0x40d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777935.thfilter(c)
	return c:IsSetCard(0x40d) and c:IsAbleToHand()
end
function c77777935.thfilter2(c)
	return c:IsSetCard(0x40d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c77777935.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c77777935.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
    and Duel.IsExistingTarget(c77777935.thfilter,tp,LOCATION_GRAVE,0,1,nil)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77777935.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  e:SetLabelObject(g:GetFirst())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g2=Duel.SelectTarget(tp,c77777935.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c77777935.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc1=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc2=g:GetFirst()
	if tc1:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)
	end
  if tc2:IsRelateToEffect(e) then
    Duel.SendtoHand(tc2,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,tc2)
  end
end

function c77777935.cfilter(c,g)
	return c:IsFaceup() and g:IsContains(c) and c:GetSummonType()==SUMMON_TYPE_XYZ and c:IsRace(RACE_DRAGON)
end
function c77777935.thcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg and eg:IsExists(c77777935.cfilter,1,nil,lg)
end
function c77777935.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777935.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_ATOHAND,nil,1,0,0)
end
function c77777935.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77777935.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,code)
    if g:GetCount()>0 then
      if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
        Duel.ConfirmCards(1-tp,g)
        Duel.BreakEffect()
        Duel.Damage(1-tp,300,REASON_EFFECT)
      end
    end
end