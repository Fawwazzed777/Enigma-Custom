--Psybernated Buster Cynthia
function c77777864.initial_effect(c)
  --pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777864,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetCountLimit(1,77777864)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c77777864.sptg)
	e1:SetOperation(c77777864.spop)
	c:RegisterEffect(e1)
  --spsummon banished
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777864,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCountLimit(1,77777864)
	e2:SetTarget(c77777864.sptg2)
	e2:SetOperation(c77777864.spop2)
	c:RegisterEffect(e2)
  --To hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e3:SetDescription(aux.Stringid(77777864,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
  e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,77777864+EFFECT_COUNT_CODE_OATH)
  e3:SetCondition(c77777864.pencon)
	e3:SetTarget(c77777864.pentg)
	e3:SetOperation(c77777864.penop)
	c:RegisterEffect(e3)
end

function c77777864.filter2(c,e,tp)
	return c:IsSetCard(0x40b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)and c:IsFaceup()
end
function c77777864.filter(c,e,tp)
	return c:IsSetCard(0x40b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777864.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77777864.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c77777864.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777864.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end


function c77777864.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77777864.filter2,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c77777864.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777864.filter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end


function c77777864.penfilter(c)
	return c:IsSetCard(0x40b) and c:IsType(TYPE_MONSTER)and c:IsAbleToHand() 
    and not c:IsCode(77777864)
end
function c77777864.cfilter(c)
	return c:IsSetCard(0x40b) and c:IsType(TYPE_MONSTER)
end
function c77777864.pencon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77777864.cfilter,1,nil)
end
function c77777864.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(c77777864.penfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c77777864.penop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
		local g=Duel.SelectMatchingCard(tp,c77777864.penfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
	end
end