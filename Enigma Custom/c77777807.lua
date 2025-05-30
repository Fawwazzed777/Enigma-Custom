--Dinorider's Envoy
function c77777807.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c77777807.cost)
	e1:SetTarget(c77777807.target)
	e1:SetOperation(c77777807.activate)
	c:RegisterEffect(e1)
end

function c77777807.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0x600) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0x600)
	Duel.Release(g,REASON_COST)
end

function c77777807.filter(c,e,tp)
	return (c:IsSetCard(0x600)or c:IsCode(4638410)or c:IsCode(38318146)
		or c:IsCode(48357738)or c:IsCode(55271628)or c:IsCode(76721030)) and c:IsAbleToHand()
end
function c77777807.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777807.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777807.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777807.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end