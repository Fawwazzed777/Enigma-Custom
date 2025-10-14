--Seafarer's Last Stand
function c66666702.initial_effect(c)
	--from grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66666702,0))
	e2:SetCountLimit(1,66666702)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c66666702.settg)
	e2:SetOperation(c66666702.setop)
	c:RegisterEffect(e2)
end

function c66666702.setfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSetCard(0x999)
end
function c66666702.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c66666702.setfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	local sfc=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,sfc,0,0)
end
function c66666702.setop(e,tp,eg,ep,ev,re,r,rp)
	local sfc=Duel.GetLocationCount(tp,LOCATION_SZONE)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
  local tc=Duel.SelectMatchingCard(tp,c66666702.setfilter,tp,LOCATION_GRAVE,0,sfc,sfc,nil,tp)
	Duel.SSet(tp,tc)
	Duel.ConfirmCards(1-tp,tc)
end