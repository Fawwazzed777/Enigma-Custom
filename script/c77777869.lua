--Psybernated Synth Katrina
function c77777869.initial_effect(c)
  --pendulum summon
	aux.EnablePendulumAttribute(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x40b),2,true)
  --spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77777869.splimit)
	c:RegisterEffect(e1)
  --special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c77777869.sprcon)
	e2:SetOperation(c77777869.sprop)
	c:RegisterEffect(e2)
  --banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77777869,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c77777869.pentarget)
	e3:SetOperation(c77777869.penoperation)
	c:RegisterEffect(e3)
  --scale
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_LSCALE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c77777869.slcon)
	e4:SetValue(6)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e5)
  --spsummon
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e9:SetDescription(aux.Stringid(77777869,1))
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetHintTiming(0,TIMING_END_PHASE)
	e9:SetRange(LOCATION_MZONE)
  e9:SetCountLimit(1,77777869)
	e9:SetCost(c77777869.spcost)
	e9:SetTarget(c77777869.sptg)
	e9:SetOperation(c77777869.spop)
	c:RegisterEffect(e9)
  --SS
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(77777869,3))
	e10:SetCategory(CATEGORY_REMOVE)
	e10:SetType(EFFECT_TYPE_IGNITION)
  e10:SetCountLimit(1,77777869+EFFECT_COUNT_CODE_OATH)
	e10:SetRange(LOCATION_PZONE)
	e10:SetTarget(c77777869.bantg)
	e10:SetOperation(c77777869.banop)
	c:RegisterEffect(e10)
  --SS
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(77777869,2))
	e11:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e11:SetType(EFFECT_TYPE_IGNITION)
  e11:SetCountLimit(1)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTarget(c77777869.ptg)
	e11:SetOperation(c77777869.pop)
	c:RegisterEffect(e11)
    --battle indestructable
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e12:SetValue(1)
	c:RegisterEffect(e12)
  --spsummon
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(77777869,4))
	e13:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e13:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e13:SetCode(EVENT_DESTROYED)
  e13:SetCountLimit(1,77777872+EFFECT_COUNT_CODE_OATH)
	e13:SetTarget(c77777869.sptg2)
	e13:SetOperation(c77777869.spop2)
	c:RegisterEffect(e13)
  local e14=e13:Clone()
  e14:SetCode(EVENT_REMOVE)
  c:RegisterEffect(e14)
end

function c77777869.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)or e:GetHandler():IsFaceup()
end
function c77777869.spfilter1(c,tp)
	return c:IsSetCard(0x40b) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end
function c77777869.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c77777869.spfilter1,tp,LOCATION_MZONE,0,2,nil,tp)
end
function c77777869.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c77777869.spfilter1,tp,LOCATION_MZONE,0,2,2,nil,tp)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end


function c77777869.slcon(e)
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  if tc1==e:GetHandler() then tc1=tc2 end
  return not tc1 or not tc1:IsSetCard(0x40b)
end


function c77777869.penfilter(c)
	return c:IsAbleToRemove()and c:IsSetCard(0x40b)
end
function c77777869.pentarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777869.penfilter,tp,LOCATION_PZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c77777869.penoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c77777869.penfilter,tp,LOCATION_PZONE,0,1,1,nil)
  if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
    Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
  end
end


function c77777869.dircon(e)
	return e:GetHandler():GetAttackAnnouncedCount()>0
end
function c77777869.atkcon2(e)
	return e:GetHandler():IsDirectAttacked()
end


function c77777869.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c77777869.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x40b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777869.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77777869.filter1,tp,LOCATION_REMOVED,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c77777869.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c77777869.filter1,tp,LOCATION_REMOVED,0,2,2,nil,e,tp)
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end


function c77777869.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c77777869.pfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x40b) and c:IsAbleToRemove()
end
function c77777869.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777869.pfilter1,tp,LOCATION_MZONE,0,1,nil)and Duel.IsExistingTarget(c77777869.thfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE)
end
function c77777869.pop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c77777869.pfilter1,tp,LOCATION_MZONE,0,1,1,nil)
  if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
    local g=Duel.SelectTarget(tp,c77777869.thfilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
      Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
  end
end

function c77777869.banfilter1(c)
	return c:IsSetCard(0x40b) and c:IsAbleToRemove()
end
function c77777869.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777869.banfilter1,tp,LOCATION_DECK,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE)
end
function c77777869.banop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c77777869.banfilter1,tp,LOCATION_DECK,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end

function c77777869.spfilter4(c,e,tp)
	return c:IsSetCard(0x40b) and c:IsFaceup() and not c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777869.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77777869.spfilter4,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c77777869.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777869.spfilter4,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end