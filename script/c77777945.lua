--Mechanoclast Dreadnought Mk I
function c77777945.initial_effect(c)
  --SS
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777945,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
  e1:SetCost(c77777945.ssscost)
	e1:SetTarget(c77777945.ssstg)
	e1:SetOperation(c77777945.sssop)
	c:RegisterEffect(e1)
	--Place in S/T zone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777945,0))
  e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c77777945.distg)
	e2:SetOperation(c77777945.disop)
	c:RegisterEffect(e2)
  --Place counters
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77777945,1))
  e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
  e3:SetCountLimit(1)
	e3:SetTarget(c77777945.distg2)
	e3:SetOperation(c77777945.disop2)
	c:RegisterEffect(e3)
  --ss success
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777945,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c77777945.spcon)
	e4:SetCost(c77777945.spcost)
	e4:SetTarget(c77777945.sptg)
	e4:SetOperation(c77777945.spop)
	c:RegisterEffect(e4)
end

function c77777945.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c77777945.counterfilter,tp,LOCATION_SZONE,0,1,nil) end
end
function c77777945.countfilter(c)
	return c:IsSetCard(0x40e) and c:IsFaceup() and (c:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT or c:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT+TYPE_LINK)
end
function c77777945.counterfilter(c)
	return c:IsFaceup() and c:IsCode(77777942)
end
function c77777945.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(77777942,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
  if not Duel.IsExistingMatchingCard(c77777945.counterfilter,tp,LOCATION_SZONE,0,1,nil) then return end
  local g=Duel.GetMatchingGroup(c77777945.countfilter,c:GetControler(),LOCATION_SZONE,0,nil)
  local g2=Duel.SelectMatchingCard(tp,c77777945.counterfilter,tp,LOCATION_SZONE,0,1,1,nil)
  local tc=g2:GetFirst()
  tc:AddCounter(0x40e,g:GetCount())
end


function c77777945.ssscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x40e,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x40e,1,REASON_COST)
end
--Makes sure you have the proper cards in hand and this card can be SS
function c77777945.ssstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
    and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c77777945.sssop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
  if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end



function c77777945.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777945.counterfilter,tp,LOCATION_SZONE,0,1,nil) and e:GetHandler():GetFlagEffect(77777942)==0 end
end
function c77777945.disop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
  if not Duel.IsExistingMatchingCard(c77777945.counterfilter,tp,LOCATION_SZONE,0,1,nil) then return end
  local g=Duel.GetMatchingGroup(c77777945.countfilter,c:GetControler(),LOCATION_SZONE,0,nil)
  local g2=Duel.SelectMatchingCard(tp,c77777945.counterfilter,tp,LOCATION_SZONE,0,1,1,nil)
  local tc=g2:GetFirst()
  tc:AddCounter(0x40e,g:GetCount())
end


function c77777945.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rc:IsSetCard(0x40e)
end
function c77777945.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x40e,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x40e,1,REASON_COST)
end

function c77777945.spfilter(c,e,tp)
	return c:IsSetCard(0x40e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(77777945)
end
function c77777945.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  and Duel.IsExistingMatchingCard(c77777945.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c77777945.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g
  if Duel.GetLocationCount(tp,LOCATION_MZONE)==1 then
    g=Duel.SelectMatchingCard(tp,c77777945.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  else
    g=Duel.SelectMatchingCard(tp,c77777945.spfilter,tp,LOCATION_HAND,0,1,2,nil,e,tp)
  end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
  local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c77777945.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c77777945.splimit(e,c)
	return not (c:IsRace(RACE_MACHINE) and c:IsType(TYPE_LINK)) and c:IsLocation(LOCATION_EXTRA)
end