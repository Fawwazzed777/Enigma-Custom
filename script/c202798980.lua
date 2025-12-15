--Enigmation Force - Chaos Zaphire
local s,id=GetID()
function s.initial_effect(c)
	--Send S/T
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,{id,0})
	e1:SetTarget(s.tb)
	e1:SetOperation(s.tbo)
	c:RegisterEffect(e1)
	--Debuff
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.cost)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
s.listed_series={0x303,0x344}
function s.enigma(c)
	return (c:IsSetCard(0x303) or c:IsSetCard(0x344))
end
function s.tb(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.FaceupFilter(s.enigma),tp,LOCATION_REMOVED,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_LOCATION_SZONE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_LOCATION_SZONE)
end
function s.tbo(e,tp,eg,ep,ev,re,r,rp,chk)
	local max_ct=Duel.GetMatchingGroupCount(aux.FaceupFilter(s.enigma),tp,LOCATION_REMOVED,0,nil,e:GetHandler())
	if max_ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_SZONE,1,max_ct,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end