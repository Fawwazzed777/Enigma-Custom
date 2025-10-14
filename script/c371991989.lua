--Armoraid Fusioner
local s,id=GetID()
function s.initial_effect(c)
	--Fusion summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.ta)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.tgfilter(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetCode(),e,tp,c)
end
function s.spfilter(c,code,e,tp,mc)
	if not c.material_count or Duel.GetLocationCountFromEx(tp,tp,mc,c)<=0 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) or not c:CheckFusionMaterial() then return false end
	for i=1,c.material_count do
		if code==c.material[i] then
			for j=1,c.material_count do
				if 371991989==c.material[j] and c.material[j]~=c.material[i] then return true end
			end
		end
	end
	return false
end
function s.ta(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		g:AddCard(e:GetHandler())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetCode(),e,tp,tc):GetFirst()
		if sc then
			sc:SetMaterial(g)
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end