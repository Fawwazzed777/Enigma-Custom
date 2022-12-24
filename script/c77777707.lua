--Witchcrafter Alexis
function c77777707.initial_effect(c)
--pendulum summon
Pendulum.AddProcedure(c)
--pen summon limit
local e2=Effect.CreateEffect(c)
e2:SetType(EFFECT_TYPE_FIELD)
e2:SetRange(LOCATION_PZONE)
e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
e2:SetTargetRange(1,0)
e2:SetTarget(c77777707.splimit)
c:RegisterEffect(e2)
--atk down
local e3=Effect.CreateEffect(c)
e3:SetType(EFFECT_TYPE_FIELD)
e3:SetRange(LOCATION_PZONE)
e3:SetCode(EFFECT_UPDATE_ATTACK)
e3:SetTargetRange(0,LOCATION_MZONE)
e3:SetValue(-200)
c:RegisterEffect(e3)
--atk up
local e4=Effect.CreateEffect(c)
e4:SetType(EFFECT_TYPE_FIELD)
e4:SetRange(LOCATION_PZONE)
e4:SetCode(EFFECT_UPDATE_ATTACK)
e4:SetTargetRange(LOCATION_MZONE,0)
e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x407))
e4:SetValue(200)
c:RegisterEffect(e4)
--Special Summon
local e5=Effect.CreateEffect(c)
e5:SetType(EFFECT_TYPE_FIELD)
e5:SetCode(EFFECT_SPSUMMON_PROC)
e5:SetRange(LOCATION_HAND)
e5:SetCountLimit(1,77777707)
e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
e5:SetCondition(c77777707.spcon2)
c:RegisterEffect(e5)
--spsummon grave
local e6=Effect.CreateEffect(c)
e6:SetDescription(aux.Stringid(77777707,2))
e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
e6:SetCode(EVENT_SPSUMMON_SUCCESS)
e6:SetCountLimit(1,77777807)
e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
e6:SetTarget(c77777707.sptg)
e6:SetOperation(c77777707.spop)
c:RegisterEffect(e6)
--scale swap
local e7=Effect.CreateEffect(c)
e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
e7:SetRange(LOCATION_PZONE)
e7:SetDescription(aux.Stringid(77777707,0))
e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
e7:SetCountLimit(1)
e7:SetCondition(c77777707.sccon)
e7:SetOperation(c77777707.scop)
c:RegisterEffect(e7)
end
function c77777707.splimit(e,c,tp,sump,sumtype,sumpos,targetp)
if c:IsSetCard(0x407) then return false end
return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c77777707.sccon(e,tp,eg,ep,ev,re,r,rp)
return Duel.GetTurnPlayer()==tp
end
function c77777707.scop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
if not c:IsRelateToEffect(e) then return end
local scl=c:GetLeftScale()
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_CHANGE_LSCALE)
e1:SetValue(c:GetRightScale())
e1:SetReset(RESET_EVENT+0x1ff0000)
c:RegisterEffect(e1)
local e2=e1:Clone()
e2:SetCode(EFFECT_CHANGE_RSCALE)
e2:SetValue(scl)
c:RegisterEffect(e2)
end
function c77777707.spcon2(e,c)
if c==nil then return true end
local tp=c:GetControler()
return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,2,nil,0x407)
end
function c77777707.spfilter(c,e,tp)
  return c:IsSetCard(0x407) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777707.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and Duel.IsExistingTarget(c77777707.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77777707.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c77777707.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end 