--Ultimaya General Randolf
local s,id=GetID()
function s.initial_effect(c)
	--Pendulum summon feature
	Pendulum.AddProcedure(c)
	--Destroy and SP
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,{id,0})
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	local ep=e1:Clone()
	ep:SetRange(LOCATION_EXTRA)
	ep:SetCondition(s.descon)
	c:RegisterEffect(ep)
	--When you Pendulum Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.acon)
	e2:SetOperation(s.aop)
	c:RegisterEffect(e2)
	--To PZ
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(s.pencon)
	e3:SetTarget(s.pentg)
	e3:SetOperation(s.penop)
	c:RegisterEffect(e3)
end
s.listed_series={0x309}
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function s.afilter(c)
	return c:IsSetCard(0x309) and c:IsAbleToHand()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_PZONE) end
	if chk==0 then return Duel.GetFieldGroup(tp,LOCATION_MZONE,0) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and
	Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_PZONE,0,1,nil)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 
		and Duel.IsExistingMatchingCard(s.afilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1))then
			local g=Duel.SelectMatchingCard(tp,s.afilter,tp,LOCATION_DECK,0,1,1,nil)
			if #g==0 then return end
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPendulumSummoned()
end
function s.pefilter(c)
	return c:IsSetCard(0x309) and c:IsAbleToHand() and c:IsPendulumMonster() and c:IsFaceup()
end
function s.acon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.aop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and
	Duel.IsExistingMatchingCard(s.pefilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
	local tc=Duel.SelectMatchingCard(tp,s.pefilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if #tc==0 then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
end
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckPendulumZones(tp) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end