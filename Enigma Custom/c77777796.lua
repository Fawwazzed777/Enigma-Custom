--Dinorider Genesis
function c77777796.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77777796.target)
	e1:SetOperation(c77777796.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777796,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,77777796)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c77777796.thcost)
	e2:SetTarget(c77777796.thtg)
	e2:SetOperation(c77777796.thop)
	c:RegisterEffect(e2)
end
--0x600==Dinorider setcode --0xA00==Negative Ritual setcode
function c77777796.filter(c,e,tp,m)
	if not (c:IsSetCard(0x600)and c:IsSetCard(0xA00))or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)then return false end
	local mg=nil
	if c.mat_filter then
		mg=m:Filter(c.mat_filter,c)
	else
		mg=m:Clone()
		mg:RemoveCard(c)
	end
	return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function c77777796.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
		return Duel.IsExistingMatchingCard(c77777796.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c77777796.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c77777796.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc.mat_filter then
			mg1=mg1:Filter(tc.mat_filter,nil)
		end
		local mat=mg1:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
		local sg=Group.CreateGroup()
		local tc2=mat:GetFirst()
		while tc2 do
			local sg1=tc2:GetOverlayGroup()
			sg:Merge(sg1)
			tc2=mat:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		Duel.Overlay(tc,mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end


function c77777796.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c77777796.thfilter2(c)
	return c:IsSetCard(0x600) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
		and c:IsSetCard(0xa00)and c:IsAbleToHand()
end
function c77777796.thfilter1(c)
	return c:IsSetCard(0x600) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_TRAP)and c:IsAbleToHand()
end
function c77777796.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777796.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777796.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777796.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			local g2=Duel.SelectMatchingCard(tp,c77777796.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
			if g2:GetCount()>0 then
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
			end
		end
	end
end
