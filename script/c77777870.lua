--Psybernated Edge Demetra
function c77777870.initial_effect(c)
  --pendulum summon
	aux.EnablePendulumAttribute(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c77777870.fusfilter,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),true)
  --spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77777870.splimit)
	c:RegisterEffect(e1)
  --special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c77777870.sprcon)
	e2:SetOperation(c77777870.sprop)
	c:RegisterEffect(e2)
  --move to pen zone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77777870,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c77777870.pentarget)
	e3:SetOperation(c77777870.penoperation)
	c:RegisterEffect(e3)
  --spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e4:SetDescription(aux.Stringid(77777870,3))
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c77777870.spcon2)
	e4:SetTarget(c77777870.sptg2)
	e4:SetOperation(c77777870.spop2)
	c:RegisterEffect(e4)
  --can't be destroyed by card effects
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetValue(1)
	c:RegisterEffect(e6)
  --Remove
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(77777870,2))
	e7:SetCategory(CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,77777870+EFFECT_COUNT_CODE_OATH)
	e7:SetTarget(c77777870.destg)
	e7:SetOperation(c77777870.desop)
	c:RegisterEffect(e7)
  --spsummon
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e9:SetDescription(aux.Stringid(77777870,1))
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetHintTiming(0,TIMING_END_PHASE)
	e9:SetRange(LOCATION_MZONE)
  e9:SetCountLimit(1,77777870)
	e9:SetCost(c77777870.spcost)
	e9:SetTarget(c77777870.sptg)
	e9:SetOperation(c77777870.spop)
	c:RegisterEffect(e9)
  --Revive
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(77777870,5))
	e12:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e12:SetCode(EVENT_PHASE+PHASE_END)
	e12:SetRange(LOCATION_REMOVED)
	e12:SetCountLimit(1)
	e12:SetTarget(c77777870.sumtg)
	e12:SetOperation(c77777870.sumop)
	c:RegisterEffect(e12)
  --spsummon
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(77777870,4))
	e13:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e13:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e13:SetCode(EVENT_DESTROYED)
  e13:SetCountLimit(1,77777870+EFFECT_COUNT_CODE_SINGLE)
	e13:SetTarget(c77777870.sptg3)
	e13:SetOperation(c77777870.spop3)
	c:RegisterEffect(e13)
  local e14=e13:Clone()
  e14:SetCode(EVENT_REMOVE)
  c:RegisterEffect(e14)
end

function c77777870.fusfilter(c)
	return c:IsSetCard(0x40b)and c:IsType(TYPE_FUSION) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end


function c77777870.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)or e:GetHandler():IsFaceup()
end
function c77777870.spfilter1(c,tp)
	return c:IsSetCard(0x40b) and c:IsType(TYPE_FUSION) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
		and Duel.IsExistingMatchingCard(c77777870.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c77777870.spfilter2(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end
function c77777870.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c77777870.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c77777870.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c77777870.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c77777870.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end


function c77777870.slcon(e)
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  if tc1==e:GetHandler() then tc1=tc2 end
  return not tc1 or not tc1:IsSetCard(0x40b)
end


function c77777870.penfilter(c)
	return c:IsAbleToRemove()and c:IsSetCard(0x40b)
end
function c77777870.pentarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777870.penfilter,tp,LOCATION_PZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c77777870.penoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c77777870.penfilter,tp,LOCATION_PZONE,0,1,1,nil)
  if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
    Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
  end
end


function c77777870.dircon(e)
	return e:GetHandler():GetAttackAnnouncedCount()>0
end
function c77777870.atkcon2(e)
	return e:GetHandler():IsDirectAttacked()
end


function c77777870.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c77777870.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x40b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777870.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77777870.filter1,tp,LOCATION_REMOVED,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c77777870.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c77777870.filter1,tp,LOCATION_REMOVED,0,2,2,nil,e,tp)
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end


function c77777870.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c77777870.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c77777870.desfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToRemove() and Duel.IsExistingTarget(c77777870.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c77777870.desop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  if Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)~=0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,c77777870.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
      Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
    end
    e:GetHandler():RegisterFlagEffect(77777870,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
  end
end


function c77777870.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x40b) and c:IsType(TYPE_FUSION) and c:IsControler(tp)
end
function c77777870.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c77777870.cfilter,1,nil,tp)
end
function c77777870.spfilter3(c)
	return c:IsSetCard(0x40b) and c:IsAbleToHand()
end
function c77777870.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c77777870.spfilter3,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c77777870.spop2(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777870.spfilter3,tp,LOCATION_REMOVED,0,1,1,nil)
  Duel.SendtoHand(g,nil,REASON_EFFECT)
end

function c77777870.spfilter4(c,e,tp)
	return c:IsSetCard(0x40b) and c:IsFaceup() and not c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777870.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77777870.spfilter4,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c77777870.spop3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777870.spfilter4,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c77777870.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(77777870)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c77777870.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end