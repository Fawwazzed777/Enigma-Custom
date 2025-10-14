--Mechanoclast Scout
function c77777950.initial_effect(c)
  --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777950,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetCountLimit(1,77777950)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c77777950.cost)
	e1:SetTarget(c77777950.target)
	e1:SetOperation(c77777950.operation)
	c:RegisterEffect(e1)
	--Place in S/T zone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777950,0))
  e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c77777950.distg)
	e2:SetOperation(c77777950.disop)
	c:RegisterEffect(e2)
  --Place counters
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77777950,1))
  e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
  e3:SetCountLimit(1)
	e3:SetTarget(c77777950.distg2)
	e3:SetOperation(c77777950.disop2)
	c:RegisterEffect(e3)
end

function c77777950.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c77777950.counterfilter,tp,LOCATION_SZONE,0,1,nil) end
end
function c77777950.countfilter(c)
	return c:IsSetCard(0x40e) and c:IsFaceup() and (c:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT or c:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT+TYPE_LINK)
end
function c77777950.counterfilter(c)
	return c:IsFaceup() and c:IsCode(77777942)
end
function c77777950.disop(e,tp,eg,ep,ev,re,r,rp)
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
  if not Duel.IsExistingMatchingCard(c77777950.counterfilter,tp,LOCATION_SZONE,0,1,nil) then return end
  local g=Duel.GetMatchingGroup(c77777950.countfilter,c:GetControler(),LOCATION_SZONE,0,nil)
  local g2=Duel.SelectMatchingCard(tp,c77777950.counterfilter,tp,LOCATION_SZONE,0,1,1,nil)
  local tc=g2:GetFirst()
  tc:AddCounter(0x40e,g:GetCount())
end

function c77777950.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777950.counterfilter,tp,LOCATION_SZONE,0,1,nil) and e:GetHandler():GetFlagEffect(77777942)==0 end
end
function c77777950.disop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
  if not Duel.IsExistingMatchingCard(c77777950.counterfilter,tp,LOCATION_SZONE,0,1,nil) then return end
  local g=Duel.GetMatchingGroup(c77777950.countfilter,c:GetControler(),LOCATION_SZONE,0,nil)
  local g2=Duel.SelectMatchingCard(tp,c77777950.counterfilter,tp,LOCATION_SZONE,0,1,1,nil)
  local tc=g2:GetFirst()
  tc:AddCounter(0x40e,g:GetCount())
end


function c77777950.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c77777950.filter(c)
	return c:IsSetCard(0x40e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c77777950.filter2(c)
	return c:IsSetCard(0x40e) and (c:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT or c:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT+TYPE_LINK) and c:IsAbleToGrave() 
end
function c77777950.target(e,tp,eg,ep,ev,re,r,rp,chk)
  local cnt = Duel.GetMatchingGroupCount(c77777950.filter2,tp,LOCATION_SZONE,0,nil)
	if chk==0 then return cnt>0 and Duel.IsExistingMatchingCard(c77777950.filter,tp,LOCATION_DECK,0,cnt,nil) and Duel.IsCanRemoveCounter(tp,1,0,0x40e,cnt,REASON_EFFECT)end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777950.operation(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.IsExistingMatchingCard(c77777950.filter2,tp,LOCATION_SZONE,0,1,nil) then return end
  local g1=Duel.GetMatchingGroup(c77777950.filter2,tp,LOCATION_SZONE,0,nil)
  local count=Duel.SendtoGrave(g1,REASON_EFFECT)
  if not Duel.IsCanRemoveCounter(tp,1,0,0x40e,count,REASON_EFFECT) then
    Duel.RemoveCounter(tp,1,0,0x40e,count,REASON_EFFECT)
    return 
  end
  Duel.RemoveCounter(tp,1,0,0x40e,count,REASON_EFFECT)
  if not Duel.IsExistingMatchingCard(c77777950.filter,tp,LOCATION_DECK,0,count,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777950.filter,tp,LOCATION_DECK,0,count,count,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
