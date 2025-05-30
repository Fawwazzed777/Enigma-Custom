--Ultimaya
local s,id=GetID()
function s.initial_effect(c)
	--Place 1 "Ultimaya" Pendulum from your Face-up Extra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Place 1 "Ultimaya" Pendulum from your Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.activate2)
	c:RegisterEffect(e2)
end
function s.pzfilter(c)
	return c:IsSetCard(0x309) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() 
end
function s.pzfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x309) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(s.pzfilter2,tp,LOCATION_EXTRA,0,1,nil) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.pzfilter2,tp,LOCATION_EXTRA,0,1,1,nil)
	if #g>0 then
		if Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)~=0 then
	if Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
	local st=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #st>0 then
	Duel.HintSelection(st)
	Duel.Destroy(st,REASON_EFFECT)
end
end
end
end
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(s.pzfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.pzfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		if Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)~=0 then
	if Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
	local st=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	if #st>0 then
	Duel.HintSelection(st)
	Duel.Destroy(st,REASON_EFFECT)
end
end
end
end
end

