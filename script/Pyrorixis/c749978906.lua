--Pyrorixis Grimoire
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x7f3}
function s.thfilter(c)
	return c:IsSetCard(0x7f3) and c:IsMonster() and c:IsAbleToHand()
end
function s.negfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	local is_recast = re and re:GetHandler():IsSetCard(0x7f3) and re:GetHandler():IsMonster()
	if is_recast then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DISABLE)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
		end
	end
	--RECAST EFFECT
	if re and re:GetHandler():IsSetCard(0x7f3) and re:GetHandler():IsMonster() and
	Duel.SelectYesNo(tp,aux.Stringid(id,1))then
		local tc=Duel.SelectMatchingCard(tp,s.negfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		if tc then
			Duel.BreakEffect()
			Duel.HintSelection(tc)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
				--Negate Effect
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				--Disable Effect Activation
				local e2=e1:Clone()
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				tc:RegisterEffect(e2)
				--Cannot Trigger
				local e3=e1:Clone()
				e3:SetCode(EFFECT_CANNOT_TRIGGER)
				tc:RegisterEffect(e3)				
				Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
		end
	end
end