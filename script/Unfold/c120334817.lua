--Ultimaya King Arcanum
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x309),2,2)
	c:EnableReviveLimit()
	-- 
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTarget(s.bpt)
	e0:SetValue(aux.tgoval)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
end
s.listed_series={0x309,0xa309}
function s.bpt(e,c)
	return c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function s.cfilter(c,g)
	return g:IsContains(c) and c:IsDestructable()
end
function s.hand(c)
	return c:IsSetCard(0x309) and c:IsAbleToHand()
end
function s.exist(c)
	return c:IsFaceup() and c:IsSetCard(0x309) and (c:IsType(TYPE_EXTRA) or c:GetOriginalType(ORIGINAL_TYPE_EXTRA))
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	local rg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,lg) 
	local sr=Duel.IsExistingMatchingCard(s.hand,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return #rg>0 and sr end
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	local rg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,lg) 
	local sr=Duel.IsExistingMatchingCard(s.hand,tp,LOCATION_DECK,0,1,nil)
	if #rg>0 and sr then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=rg:Select(tp,1,1,nil)
	Duel.HintSelection(tg)
	if Duel.Destroy(tg,REASON_EFFECT)~=0 then
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local rk=Duel.IsExistingMatchingCard(s.exist,tp,LOCATION_MZONE,0,1,e:GetHandler())
	local g=Duel.SelectMatchingCard(tp,s.hand,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		if rk and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local sg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #sg>0 then
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
end		
end
end
end
end
end
