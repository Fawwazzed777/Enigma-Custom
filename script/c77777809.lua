--Dinorider Incubation
function c77777809.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77777809.target)
	e1:SetOperation(c77777809.activate)
	c:RegisterEffect(e1)
	--activate grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777809,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
--	e2:SetCountLimit(1,77777809)
	e2:SetCost(c77777809.cost)
	e2:SetTarget(c77777809.target)
	e2:SetOperation(c77777809.activate)
	c:RegisterEffect(e2)
end
--0x600==Dinorider setcode --0xA00==Negative Ritual setcode
function c77777809.filter(c,e,tp,m)
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
function c77777809.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
		return Duel.IsExistingMatchingCard(c77777809.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c77777809.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c77777809.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1)
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


function c77777809.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end