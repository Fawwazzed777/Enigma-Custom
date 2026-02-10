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
function s.check_recast(e)
	local re=e:GetOwnerEffect()
	if re and re:GetHandler():IsSetCard(0x7f3) and re:GetHandler():IsMonster() then return true end
	local ev=Duel.GetCurrentChain()
	if ev>0 then
		local te=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		return tc:IsSetCard(0x7f3) and tc:IsMonster()
	end
	return not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and s.negfilter(chkc) end	
	local is_recast = s.check_recast(e)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end	
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)	
	if is_recast then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g=Duel.SelectTarget(tp,s.negfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	else
		e:SetProperty(0)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--Search
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	--RECAST (Negate & Activation Lock)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.BreakEffect()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)	
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
		--Cannot Activate Effects
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_TRIGGER)
		tc:RegisterEffect(e3)		
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
	end
end