--Eternity Tech - Time Leap
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--banish "Eternity Ace" Monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,{id,0})
	e2:SetCost(s.ttcost)
	e2:SetOperation(s.top)
	c:RegisterEffect(e2)

end
s.listed_series={0x993,0x994}
function s.cfilter(c,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsMonster() and c:IsAbleToRemove() and c:IsSetCard(0x994)
		and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,c:GetAttribute(),e,tp)
end
function s.tgfilter(c,att)
	return c:IsSetCard(0x994) and not c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.ttcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(Duel.GetOperatedGroup():GetFirst():GetAttribute())
end
function s.top(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e:GetLabel(),e,tp):GetFirst()
	if tc and tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end