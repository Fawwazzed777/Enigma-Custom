--Ultimaya Fusion
local s,id=GetID()
function s.initial_effect(c)
	--Fusion Summon 1 Fusion Monster, including 1+ "Ultimaya" monster as material
	local e1=Fusion.CreateSummonEff({handler=c,matfilter=s.mfilter,extrafil=s.fextra})
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)
	--Return to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.listed_series={0x309}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()&PHASE_MAIN1+PHASE_MAIN2>0
end
function s.mfilter(c)
	return (c:IsLocation(LOCATION_HAND+LOCATION_MZONE) and c:IsAbleToGrave())
	or (c:IsOriginalType(TYPE_MONSTER) and c:IsLocation(LOCATION_PZONE) and c:IsSetCard(0x309))
end
function s.checkmat(tp,sg,fc)
	return (sg:IsExists(Card.IsSetCard,1,nil,0x309) or sg:IsExists(Card.IsCode,1,nil,1686814))
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil),s.checkmat
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end

