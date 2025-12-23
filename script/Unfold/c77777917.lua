--Requipped General Yennefer
function c77777917.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x408),2)
	c:EnableReviveLimit()
  --equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777917,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c77777917.condition)
	e1:SetTarget(c77777917.target)
	e1:SetOperation(c77777917.operation)
	c:RegisterEffect(e1)
  --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777917,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c77777917.sptg)
	e2:SetOperation(c77777917.spop)
	c:RegisterEffect(e2)
  --equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77777917,2))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetCost(c77777917.eqcost)
	e3:SetTarget(c77777917.eqtg)
	e3:SetOperation(c77777917.eqop)
	c:RegisterEffect(e3)
end

function c77777917.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK
end
function c77777917.filter(c,e,tp,ec)
	return c:IsSetCard(0x408) and c:IsCanBeEffectTarget(e)and c:CheckEquipTarget(ec)
end
function c77777917.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK) and c77777917.filter(chkc,e,tp,e:GetHandler()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingMatchingCard(c77777917.filter,tp,LOCATION_DECK,0,2,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,2,0,0)
end
function c77777917.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(c77777917.filter,tp,LOCATION_DECK,0,nil,e,tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=g:Select(tp,2,2,nil)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local tc=g1:GetFirst()
	while tc do
		Duel.Equip(tp,tc,c,true,true)
		tc=g1:GetNext()
	end
	Duel.EquipComplete()
end

function c77777917.spfilter0(c,e,tp)
	return c:IsSetCard(0x408) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777917.spfilter1(c,e,tp,zone)
	return c:IsSetCard(0x408) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c77777917.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		if zone~=0 then
			return Duel.IsExistingMatchingCard(c77777917.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone)
		else
			return false
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77777917.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777917.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end


function c77777917.eqfilter(c,ec)
	return c:IsSetCard(0x408) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c77777917.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipGroup():IsExists(Card.IsType,1,e:GetHandler(),TYPE_SPELL)end
	local g2=e:GetHandler():GetEquipGroup()
	g2=g2:Filter(Card.IsType,nil,TYPE_SPELL)
--	local g1=g2:FilterSelect(Card.IsType,tp,1,1,e:GetHandler(),TYPE_SPELL)
	local g1=g2:Select(tp,1,1,nil)
	Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
end
function c77777917.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--flag effect is set to allow the cards to be activated directly from the deck,
	--even though the monster is potentially already equipped with a Requipped card.
	e:GetHandler():RegisterFlagEffect(77777812,RESET_EVENT+0x1fe0000,0,1)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777917.eqfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	e:GetHandler():ResetFlagEffect(77777812)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c77777917.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e)then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c77777917.eqfilter,tp,LOCATION_DECK,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c,true)
	end
end