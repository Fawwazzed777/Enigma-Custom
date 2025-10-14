--Seafarer Undead Unagi
function c66666696.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x999),1,1,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
  local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66666696,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
--	e2:SetCost(c66666696.cost)
	e2:SetTarget(c66666696.settg)
	e2:SetOperation(c66666696.setop)
	c:RegisterEffect(e2)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c66666696.atkval)
	c:RegisterEffect(e5)
end

function c66666696.atkfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetSequence()<5
end

function c66666696.atkval(e,c)
	return Duel.GetMatchingGroupCount(c66666696.atkfilter,e:GetHandler(),LOCATION_SZONE,0,nil)*100
end


function c66666696.cstfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function c66666696.setfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)and(c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)<100)
end
function c66666696.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c66666696.setfilter,tp,0,LOCATION_GRAVE,1,nil,tp)and
	Duel.IsExistingMatchingCard(c66666696.cstfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
  Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
end
function c66666696.setop(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.IsExistingMatchingCard(c66666696.cstfilter,tp,LOCATION_ONFIELD,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local cst=Duel.SelectMatchingCard(tp,c66666696.cstfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	if Duel.Destroy(cst,REASON_EFFECT)~=0 then
    Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c66666696.setfilter,tp,0,LOCATION_GRAVE,1,1,nil,tp) 
    if g:GetCount()<1 then return end
    local tc=g:GetFirst()
		if (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
