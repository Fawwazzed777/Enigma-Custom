--Entrance to the Glade
function c77777889.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,77777889)
	e2:SetCost(c77777889.spcost)
	e2:SetTarget(c77777889.sptg)
	e2:SetOperation(c77777889.spop)
	c:RegisterEffect(e2)
end

function c77777889.rfilter(c)
	return c:IsSetCard(0x40c)
end
function c77777889.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c77777889.rfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c77777889.rfilter,1,1,nil)
	local tc=g:GetFirst()
	Duel.Release(g,REASON_COST)
end
function c77777889.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c77777889.filter,tp,LOCATION_GRAVE,0,1,nil)) or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c77777889.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)) or Duel.IsExistingMatchingCard(c77777889.filter2,tp,LOCATION_DECK,0,1,nil,e,tp)end
  
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,550)
  local question=0
  if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c77777889.filter,tp,LOCATION_GRAVE,0,1,nil)then question=question+1 end
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c77777889.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then question=question+2 end
  if Duel.IsExistingMatchingCard(c77777889.filter2,tp,LOCATION_DECK,0,1,nil) then question=question+4 end
  
	if question==1 then
		op=Duel.SelectOption(tp,aux.Stringid(77777889,0))
	elseif question==2 then
    op=Duel.SelectOption(tp,aux.Stringid(77777889,1))+1
  elseif question==4 then
    op=Duel.SelectOption(tp,aux.Stringid(77777889,2))+2
  elseif question==3 then
		op=Duel.SelectOption(tp,aux.Stringid(77777889,0),aux.Stringid(77777889,1))
  elseif question==5 then
    op=Duel.SelectOption(tp,aux.Stringid(77777889,0),aux.Stringid(77777889,2))
    if op==1 then op=op+1 end
  elseif question==6 then
    op=Duel.SelectOption(tp,aux.Stringid(77777889,1),aux.Stringid(77777889,2))+1
  elseif question==7 then
    op=Duel.SelectOption(tp,aux.Stringid(77777889,0),aux.Stringid(77777889,1),aux.Stringid(77777889,2))
	end
	e:SetLabel(op)
end
function c77777889.spfilter(c,e,tp)
	return c:IsSetCard(0x40c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE+POS_FACEUP_DEFENSE)
end
function c77777889.filter(c)
	return c:IsSetCard(0x40c) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77777889.filter2(c)
	return c:IsSetCard(0x40c) and c:IsType(TYPE_MONSTER)
end
function c77777889.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c:IsSetCard(0x40c)
end

function c77777889.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local mylabel=e:GetLabel()
  if mylabel==2 then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c77777889.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
  elseif mylabel==0 then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
  local g=Duel.SelectMatchingCard(tp,c77777889.filter,tp,LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SSet(tp,g:GetFirst())
    Duel.ConfirmCards(1-tp,g)
  end
  else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777889.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE+POS_FACEDOWN_DEFENSE)
    Duel.ConfirmCards(1-tp,tc)
	end
  end
end
  