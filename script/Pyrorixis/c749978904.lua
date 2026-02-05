--Pyrorixis Burst Summon
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x7f3}
function s.costfilter(c)
	return c:IsSetCard(0x7f3) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000)
		and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.PayLPCost(tp,1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,PLAYER_ALL,LOCATION_MZONE)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x7f3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.nfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0x7f3)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.nfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		if not tc:IsSetCard(0x7f3) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			if tc:RegisterEffect(e1)>0 then
	--[Recast]If this effect was applied by a "Pyrorixis" monster
	if re and re:GetHandler():IsSetCard(0x7f3) and re:GetHandler():IsType(TYPE_MONSTER) or not e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then			
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
			if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 then
				local lv=sc:GetLevel()
				if lv>0 then
					Duel.Recover(tp,lv*300,REASON_EFFECT)
							--FIRE Lock
							local e3=Effect.CreateEffect(c)
							e3:SetType(EFFECT_TYPE_FIELD)
							e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
							e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
							e3:SetDescription(aux.Stringid(id,1))
							e3:SetTargetRange(1,0)
							e3:SetTarget(s.splimit)
							e3:SetReset(RESET_PHASE+PHASE_END)
							Duel.RegisterEffect(e3,tp)
							end
						end
					end	
				end
			end
		end
	end
end
function s.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_FIRE)
end