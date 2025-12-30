--Eternity Ace - High Empress
local s,id=GetID()
function s.initial_effect(c)
c:SetUniqueOnField(1,0,id)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,s.ffilter1,s.ffilter2,s.ffilter3)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetRange(0x7)
	e0:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e0)
	--
end
function s.ffilter1(c,fc,sumtype,tp)
	return c:IsCode(16399999)
end
function s.ffilter2(c,fc,sumtype,tp)
	return c:IsSetCard(0x994) and c:IsAttribute(ATTRIBUTE_LIGHT) 
end
function s.ffilter3(c,fc,sumtype,tp)
	return c:IsSetCard(0x994) and c:IsAttribute(ATTRIBUTE_DARK) 
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(function(c) return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost() end,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST+REASON_MATERIAL)
end