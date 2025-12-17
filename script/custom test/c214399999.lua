--Eternity Ace - Chrono Zereya 
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x994),7,2,nil,nil,Xyz.InfiniteMats)
	--Special summoned by its own method
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.sprcon)
	e0:SetTarget(s.sprtg)
	e0:SetOperation(s.sprop)
	c:RegisterEffect(e0)
end
s.listed_series={0x994}
function s.sprfilter(c,e)
	return c:IsFaceup() and c:GetLevel()
end
function s.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_MZONE,0,nil)
	return (c:IsFaceup() and not c:IsType(TYPE_TOKEN)) and c:IsType(TYPE_XYZ) and g:IsExists(s.sprfilter2,1,c,tp,c,sc,lv)
end
function s.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return (c:GetLevel()+mc:GetRank())==7 and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(s.sprfilter1,1,nil,tp,g,c)
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=eg:Filter(s.sprfilter1,nil,nil,tp,e:GetHandler())
	if chk==0 then
		local c=e:GetHandler()
		local pg=aux.GetMustBeMaterialGroup(tp,g,tp,nil,nil,REASON_XYZ)
		return #pg<=0 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
	end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) then return end
	local g=eg:Filter(s.sprfilter1,nil,e,tp,c)
	local pg=aux.GetMustBeMaterialGroup(tp,g,tp,nil,nil,REASON_XYZ)
	if #g>0 and #pg<=0 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 then
		c:SetMaterial(g)
		Duel.Overlay(c,g)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end
