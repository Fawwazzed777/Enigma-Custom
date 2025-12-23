--Phantom Pressure
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={889981110,889981112}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,889981110),tp,LOCATION_ONFIELD,0,1,nil)
	or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,889981112,nil,TYPES_TOKEN,3000,3000,10,RACE_ROCK,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,889981112,nil,TYPES_TOKEN,3000,3000,10,RACE_ROCK,ATTRIBUTE_DARK) then
		for i=1,1 do
			local token=Duel.CreateToken(tp,889981112)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			--cannot be summon material
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e0:SetCode(EFFECT_CANNOT_BE_MATERIAL)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e0:SetValue(1)
			e0:SetReset(RESET_EVENT|RESETS_STANDARD)
			if token:RegisterEffect(e0)~=0 then
			local tc=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):RandomSelect(tp,1)
			if tc then
			Duel.HintSelection(tc)
			Duel.Destroy(tc,REASON_EFFECT)
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
		end
		Duel.SpecialSummonComplete()
end
end
end
end
