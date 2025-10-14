--Witchcrafter Selena
function c77777929.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),9,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
  --todeck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
  e1:SetDescription(aux.Stringid(77777929,7))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c77777929.tdcost)
  e1:SetCondition(c77777929.tdcon)
	e1:SetTarget(c77777929.tdtg)
	e1:SetOperation(c77777929.tdop)
	c:RegisterEffect(e1)
  --splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c77777929.splimit)
	c:RegisterEffect(e2)
	--scale swap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(77777929,0))
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCondition(c77777929.sccon)
--	e3:SetTarget(c77777929.sctg)
	e3:SetOperation(c77777929.scop)
	c:RegisterEffect(e3)
  --spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777929,4))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
  e4:SetCondition(c77777929.spcon2)
  e4:SetCost(c77777929.spcost2)
	e4:SetTarget(c77777929.sptg2)
	e4:SetOperation(c77777929.spop2)
	c:RegisterEffect(e4)
  --cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
  e5:SetCondition(c77777929.tgcon)
	e5:SetValue(c77777929.tgval)
	c:RegisterEffect(e5)
  --remove
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77777929,2))
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_MZONE)
  e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCountLimit(1)
	e6:SetCondition(c77777929.rmcon)
	e6:SetTarget(c77777929.rmtg)
	e6:SetOperation(c77777929.rmop)
	c:RegisterEffect(e6)
  --banish replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EFFECT_SEND_REPLACE)
	e7:SetRange(LOCATION_MZONE)
  e7:SetCountLimit(1)
  e7:SetCondition(c77777929.banrepcon)
	e7:SetTarget(c77777929.banreptg)
  e7:SetValue(c77777929.banrepval)
	e7:SetOperation(c77777929.banrepop)
	c:RegisterEffect(e7)
  --destroy replace
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EFFECT_DESTROY_REPLACE)
	e8:SetRange(LOCATION_MZONE)
  e8:SetCountLimit(1)
  e8:SetCondition(c77777929.banrepcon)
	e8:SetTarget(c77777929.reptg)
	e8:SetValue(c77777929.repval)
	e8:SetOperation(c77777929.repop)
	c:RegisterEffect(e8)
  --Recover from Extra
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(77777929,1))
	e9:SetCategory(CATEGORY_TOHAND)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_PZONE)
	e9:SetCountLimit(1)
	e9:SetTarget(c77777929.hndtarget)
	e9:SetOperation(c77777929.hndoperation)
	c:RegisterEffect(e9)
  --pendulum place
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(77777929,3))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetCountLimit(1)
	e10:SetTarget(c77777929.pentarget)
	e10:SetOperation(c77777929.penoperation)
	c:RegisterEffect(e10)
end

c77777929.pendulum_level=9

function c77777929.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x407) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c77777929.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function c77777929.scop(e,tp,eg,ep,ev,re,r,rp)
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

function c77777929.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c77777929.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c77777929.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777929.rmfilter,0,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)
end
function c77777929.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c77777929.rmfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if tc:GetCount()>0 then
    Duel.HintSelection(tc)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

function c77777929.spcon2(e)
	return e:GetHandler():GetOverlayCount()>=2
end
function c77777929.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c77777929.spfilter(c,e,tp)
	return c:IsSetCard(0x407) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777929.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77777929.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c77777929.spop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777929.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c77777929.banrepcon(e)
	return e:GetHandler():GetOverlayCount()>=4
end
function c77777929.banrepfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x407) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsControler(tp) and c:GetDestination()==LOCATION_REMOVED and not c:IsReason(REASON_REPLACE+REASON_COST)
end
function c77777929.banreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT)and eg:IsExists(c77777929.banrepfilter,1,nil,tp) end
  return Duel.SelectYesNo(tp,aux.Stringid(77777929,6))
end
function c77777929.banrepval(e,c)
	return c77777929.banrepfilter(c,e:GetHandlerPlayer())
end
function c77777929.banrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end

function c77777929.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x407) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsControler(tp) and not c:IsReason(REASON_REPLACE)
end
function c77777929.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and eg:IsExists(c77777929.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(77777929,5))
end
function c77777929.repval(e,c)
	return c77777929.repfilter(c,e:GetHandlerPlayer())
end
function c77777929.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end

function c77777929.tgcon(e)
	return e:GetHandler():GetOverlayCount()>=3
end
function c77777929.tgval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end



function c77777929.filter2(c)
	return c:IsSetCard(0x407) and c:IsFaceup() and c:IsAbleToHand()
end
function c77777929.hndtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777929.filter2,tp,LOCATION_EXTRA,0,2,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c77777929.hndoperation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777929.filter2,tp,LOCATION_EXTRA,0,2,2,nil)
	if g:GetCount()==2 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c77777929.penfilter(c,e,tp)
	return c:IsSetCard(0x407) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777929.penfilter2(c,e,tp,mc,rk)
	return c:GetRank()==rk and c:IsSetCard(0x407) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c77777929.pentarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777929.penfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c77777929.penoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777929.penfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
  if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
    Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    Duel.BreakEffect()
    local tc=g:GetFirst()
    if not tc:IsType(TYPE_XYZ) then return end
    local rk=tc:GetRank()
    if not Duel.IsExistingMatchingCard(c77777929.penfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc,rk+1)then return end
    if Duel.SelectYesNo(tp,aux.Stringid(77777929,8)) then
      Duel.BreakEffect()
      local g=Duel.SelectMatchingCard(tp,c77777929.penfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
      local sc=g:GetFirst()
      if sc then
        local mg=tc:GetOverlayGroup()
        if mg:GetCount()~=0 then
          Duel.Overlay(sc,mg)
        end
        sc:SetMaterial(Group.FromCards(tc))
        Duel.Overlay(sc,Group.FromCards(tc))
        Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
        sc:CompleteProcedure()
      end
    end
  end
end


function c77777929.tdfilter(c)
	return not c:IsSetCard(0x407) and not c:IsSetCard(0x95) and not c:IsSetCard(0x5d2)
end
function c77777929.tdcon(e)
	return e:GetHandler():GetOverlayCount()>=12 and not e:GetHandler():GetOverlayGroup():IsExists(c77777929.tdfilter,1,nil)
end
function c77777929.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local matnum=e:GetHandler():GetOverlayCount()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,matnum,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,matnum,matnum,REASON_COST)
end
function c77777929.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c77777929.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end