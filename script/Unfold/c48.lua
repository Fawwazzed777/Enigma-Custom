--Red-Eyes Empress
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMix(c,true,true,s.mfilter1,s.mfilter2)
	c:EnableReviveLimit()
end
s.listed_series={0x3b}
function s.mfilter1(c,fc,sumtype,tp)
	return c:IsSetCard(0x3b,fc,sumtype,tp)
end
function s.mfilter2(c,fc,sumtype,tp)
	return c:IsRace(RACE_DRAGON,fc,sumtype,tp) and c:IsLevelAbove(7)
end