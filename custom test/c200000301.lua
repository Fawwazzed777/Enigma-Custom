--Blue-Eyes Prophesied Dragon
local s,id=GetID()
function s.initial_effect(c)
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x140),1,1,aux.FilterSummonCode(CARD_BLUEEYES_W_DRAGON),1,1)
	c:EnableReviveLimit()
--PendulumSummon
	Pendulum.AddProcedure(c)
--Monster Effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
--Adding White Wing Magician to Hand
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
--Send Blue-Eyes Prophesied Dragon to Pendulum Zone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.pentg)
	e2:SetOperation(s.penop)
	c:RegisterEffect(e2)
--Pendulum Effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EVENT_MOVE)
	e3:SetCondition(s.penchk)
	e3:SetTarget(s.bewdadmchk)
	e3:SetOperation(s.spsmop)
	c:RegisterEffect(e3)
end
s.listed_names={11067666}

function s.penchk(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckEvent(e2) end
end

function s.bewdadmchk(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return (Duel.CheckLocation(tp,LOCATION_GRAVE,1) and c:IsCode(CARD_BLUEEYES_W_DRAGON)) or (Duel.CheckLocation(tp,LOCATION_GRAVE,1) and c.IsSetCard(0x140) and c.IsType(TYPE_TUNER)) or (Duel.CheckLocation(tp,LOCATION_DECK,1) and c.IsCode(CARD_BLUEEYES_W_DRAGON)) or (Duel.CheckLocation(tp,LOCATION_DECK,1) and c.IsSetCard(0x140) and c.IsType(TYPE_TUNER))
	end
end

function s.spsmop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_GRAVE,0) and c.IsCode(CARD_BLUEEYES_W_DRAGON)) and (Duel.CheckLocation(tp,LOCATION_GRAVE,0) and c.IsSetCard(0x140) and c.IsType(TYPE_TUNER)) and (Duel.CheckLocation(tp,LOCATION_DECK,0) and c.IsCode(CARD_BLUEEYES_W_DRAGON)) and (Duel.CheckLocation(tp,LOCATION_DECK,0) and c.IsSetCard(0x140) and c.IsType(TYPE_TUNER)) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		Duel.SynchroSummon()
	end
end
--Adamancipator Tuner
function s.spfilter1(c,e,tp)
	return c:IsSetCard(0x140) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_DECK,0,1,c,e,tp)
end
--Blue-Eyes non-Tuner
function s.spfilter2(c,e,tp)
	return c:IsSetCard(0xdd) and not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
--Check Blue-Eyes Synchro in Extra
function s.scfilter(c,mg)
	return c:IsSetCard(0xdd) and c:IsSynchroSummonable(nil,mg)
end

function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end

function s.penop(e,tp,eg,ep,ev,re,r,rp)
if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	--Special Summon
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,g1:GetFirst(),e,tp)
	g1:Merge(g2)
		for tc in aux.Next(g1) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	--Inherent Synchro
		local eg=Duel.GetMatchingGroup(s.scfilter,tp,LOCATION_EXTRA,0,nil,mg)
		if #eg>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=eg:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
		end
	end
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
	Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end

	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thfilter(c)
	return c:IsCode(11067666) and c:IsAbleToHand()
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
		end
end