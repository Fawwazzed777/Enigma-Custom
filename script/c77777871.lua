--Psybernated Artillery Camilla
function c77777871.initial_effect(c)
  --pendulum summon
	aux.EnablePendulumAttribute(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c77777871.fusfilter,3,true)
  --spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77777871.splimit)
	c:RegisterEffect(e1)
  --special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c77777871.sprcon)
	e2:SetOperation(c77777871.sprop)
	c:RegisterEffect(e2)
  --put in pendulum zone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77777871,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c77777871.pentarget)
	e3:SetOperation(c77777871.penoperation)
	c:RegisterEffect(e3)
  --Pendulum Place
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777871,6))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c77777871.pcon2)
	e4:SetOperation(c77777871.pop2)
	c:RegisterEffect(e4)
  --cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
  --actlimit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,1)
	e7:SetValue(c77777871.aclimit)
	e7:SetCondition(c77777871.actcon)
	c:RegisterEffect(e7)
  --SS
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(77777871,2))
	e11:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e11:SetType(EFFECT_TYPE_QUICK_O)
  e11:SetCountLimit(1,77777871+EFFECT_COUNT_CODE_OATH)
	e11:SetRange(LOCATION_PZONE)
  e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetTarget(c77777871.ptg)
	e11:SetOperation(c77777871.pop)
	c:RegisterEffect(e11)
end

function c77777871.fusfilter(c)
  return c:IsType(TYPE_FUSION) and c:IsSetCard(0x40b) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end

function c77777871.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)or e:GetHandler():IsFaceup()
end
function c77777871.spfilter1(c,tp)
	return c:IsSetCard(0x40b) and c:IsType(TYPE_FUSION) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end
function c77777871.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c77777871.spfilter1,tp,LOCATION_MZONE,0,3,nil,tp)
end
function c77777871.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c77777871.spfilter1,tp,LOCATION_MZONE,0,3,3,nil,tp)
  c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end


function c77777871.slcon(e)
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  if tc1==e:GetHandler() then tc1=tc2 end
  return not tc1 or not tc1:IsSetCard(0x40b)
end


function c77777871.penfilter(c)
	return c:IsAbleToRemove()and c:IsSetCard(0x40b)
end
function c77777871.pentarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777871.penfilter,tp,LOCATION_PZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c77777871.penoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c77777871.penfilter,tp,LOCATION_PZONE,0,1,1,nil)
  if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
    Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
  end
end


function c77777871.dircon(e)
	return e:GetHandler():GetAttackAnnouncedCount()>0
end
function c77777871.atkcon2(e)
	return e:GetHandler():IsDirectAttacked()
end



function c77777871.pfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x40b) and c:IsAbleToRemove()
end
function c77777871.pfilter2(c,e,tp,code)
	return c:IsSetCard(0x40b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)and c:IsFaceup() and not c:IsCode(code)
end
function c77777871.pfilter3(c)
	return c:IsSetCard(0x40b) and c:IsAbleToDeck() and c:IsFaceup()
end
function c77777871.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777871.pfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE)
end
function c77777871.pop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
  local choice=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c77777871.pfilter1,tp,LOCATION_MZONE,0,1,1,nil)
  if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then choice=1
    elseif not Duel.IsExistingMatchingCard(c77777871.pfilter3,tp,LOCATION_REMOVED,0,2,nil)
      and not Duel.IsExistingMatchingCard(c77777871.pfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp,g:GetFirst():GetCode())then
        choice=2
    elseif not Duel.IsExistingMatchingCard(c77777871.pfilter3,tp,LOCATION_REMOVED,0,2,nil)then
      choice = Duel.SelectOption(tp,aux.Stringid(77777871,3),aux.Stringid(77777871,5))
      if choice==1 then choice=choice+1 end
    elseif not Duel.IsExistingMatchingCard(c77777871.pfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp,g:GetFirst():GetCode())then
      choice = Duel.SelectOption(tp,aux.Stringid(77777871,4),aux.Stringid(77777871,5))+1
    else
    choice = Duel.SelectOption(tp,aux.Stringid(77777871,3),aux.Stringid(77777871,4),aux.Stringid(77777871,5))
    end
    if choice==0 then
      local g2=Duel.SelectMatchingCard(tp,c77777871.pfilter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,g:GetFirst():GetCode())
      Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
    elseif choice==1 then
      local g2=Duel.SelectMatchingCard(tp,c77777871.pfilter3,tp,LOCATION_REMOVED,0,2,2,nil)
      Duel.SendtoDeck(g2,tp,2,REASON_EFFECT)
    elseif choice==2 then
      Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
    end
  end
end

function c77777871.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c77777871.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end

function c77777871.pcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  return not tc1 or not tc2
end
function c77777871.pop2(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  if(tc1 and tc2) then return end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
