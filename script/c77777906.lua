--Dragon's Valley
function c77777906.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77777906+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c77777906.activate)
	c:RegisterEffect(e1)
  --atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(300)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DRAGON))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
  --search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetDescription(aux.Stringid(77777906,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c77777906.target2)
	e4:SetOperation(c77777906.operation2)
	c:RegisterEffect(e4)
end

function c77777906.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x40d) and c:IsAbleToHand()
end
function c77777906.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c77777906.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(77777906,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end


function c77777906.revfilter(c)
	return c:IsSetCard(0x40d) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c77777906.filter2(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToGrave()
end
function c77777906.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777906.revfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c77777906.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c77777906.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
  if not Duel.IsExistingMatchingCard(c77777906.revfilter,tp,LOCATION_HAND,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
  
	local g=Duel.SelectMatchingCard(tp,c77777906.revfilter,tp,LOCATION_HAND,0,1,1,nil)
  --Reveals it and raises event to tell other cards they have been revealed
	Duel.ConfirmCards(1-tp,g)
	Duel.RaiseSingleEvent(g:GetFirst(),77777900,e,REASON_EFFECT,tp,tp,0)
	Duel.ShuffleHand(tp)
  
  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c77777906.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g2,REASON_EFFECT)
	end
end