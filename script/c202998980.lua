--Enigmation Force - Disaster Hawk
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(s.ffilter),4,2,nil,nil,Xyz.InfiniteMats)
end
s.listed_series={0x303,0x344}
function s.ffilter(c,fc,sumtype,tp)
	return c:IsSetCard(0x303) or c:IsSetCard(0x344)
end