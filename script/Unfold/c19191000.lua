--Outer Shadow Beast - Zafier
local s,id=GetID()
function s.initial_effect(c)
	--Xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_EARTH),4,2)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) 
end
end
function s.exfilter1(c,e,tp)
	return c:IsSetCard(0xabc9) and c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.exfilter2(c,e,tp)
	return c:IsSetCard(0xabc9)  
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	local max_num=math.min(ct,3,ft)	
	local t={}
	for i=1,max_num do t[i]=i end	
	Duel.Hint(HINTMSG_NUMBER,tp,HINT_NUMBER)
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))	
	Duel.ConfirmDecktop(tp,ac)
	local g=Duel.GetDecktopGroup(tp,ac)
	if #g>0 then
		Duel.DisableShuffleCheck()
		local sg=g:Filter(s.exfilter2,nil,e,tp)
		if #sg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local spg=sg:Select(tp,1,ft,nil) 
			if #spg>0 then
				Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		local rem=g:Filter(function(c) return not spg or not spg:IsContains(c) end,nil)
		if #rem>0 then
			Duel.SendtoGrave(rem,REASON_EFFECT+REASON_REVEAL)
		end
	end
end