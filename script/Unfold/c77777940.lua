--Reserved Fairy of the Glade
function c77777940.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x40c),2)
	c:EnableReviveLimit()
  --send link
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777940,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
  e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
  e2:SetCountLimit(1)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetCondition(c77777940.spcon)
	e2:SetTarget(c77777940.tgtg)
	e2:SetOperation(c77777940.tgop)
	c:RegisterEffect(e2)
  --spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetDescription(aux.Stringid(77777940,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c77777940.sptg)
	e3:SetOperation(c77777940.spop)
	c:RegisterEffect(e3)
  --Activate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_POSITION)
  e5:SetDescription(aux.Stringid(77777940,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetCountLimit(2)
  e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c77777940.fliptg)
	e5:SetOperation(c77777940.flipop)
	c:RegisterEffect(e5)
  --recover
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77777940,0))
	e6:SetCategory(CATEGORY_RECOVER)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_FLIP)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c77777940.damcon)
	e6:SetTarget(c77777940.damtg)
	e6:SetOperation(c77777940.damop)
	c:RegisterEffect(e6)
end

function c77777940.cfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsFacedown()
end
function c77777940.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77777940.cfilter,1,nil,tp)
end
function c77777940.sendfilter(c)
	return c:IsType(TYPE_LINK)
end
function c77777940.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777940.sendfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c77777940.tgop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c77777940.sendfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
function c77777940.spfilter(c,e,tp)
	return c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777940.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then local zone=e:GetHandler():GetLinkedZone(tp)
    if zone>0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c77777940.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
    else return false end 
    end
end
function c77777940.spop(e,tp,eg,ep,ev,re,r,rp)
  local zone=e:GetHandler():GetLinkedZone(tp)
	if zone<=0 then return end
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777940.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE+POS_FACEDOWN_DEFENSE,zone)
    Duel.ConfirmCards(1-tp,tc)
	end
end


function c77777940.filter2(c,e)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsFacedown() and c:IsType(TYPE_MONSTER)
end
function c77777940.fliptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777940.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c77777940.flipop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectMatchingCard(tp,c77777940.filter2,tp,LOCATION_MZONE,0,1,1,nil,e)
  local tc=g:GetFirst()
  Duel.ChangePosition(tc,0,0,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
end


function c77777940.cfilter2(c,tp)
	return c:IsType(TYPE_MONSTER)
end
function c77777940.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77777940.cfilter2,1,nil,tp)
end
function c77777940.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x40c)
end
function c77777940.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777940.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c77777940.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77777940.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(100*eg:GetCount())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end