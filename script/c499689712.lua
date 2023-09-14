--Aerolizer Razor Wind
local s,id=GetID()
function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--Can be treated as a non-tuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(s.ntval)
	c:RegisterEffect(e2)
end
s.listed_series={0xbf45}
function s.filter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0xbf45)
end
function s.thfilter(c,tp)
	return c:IsSetCard(0xbf45) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function s.wfilter(c)
	return c:IsFaceup() and c:IsMonster() and not c:IsAttribute(ATTRIBUTE_WIND)
end
function s.desfilter(c)
	return c:IsSetCard(0xbf45) and c:IsType(TYPE_SYNCHRO)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	local sg=Duel.SelectMatchingCard(tp,s.wfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
end	
end
end
function s.ntval(c,sc,tp)
	return sc and sc:IsAttribute(ATTRIBUTE_WIND)
end
