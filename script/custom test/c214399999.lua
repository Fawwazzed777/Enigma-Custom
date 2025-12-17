--Eternity Ace - Chrono Zereya 
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x994),7,2,nil,nil,Xyz.InfiniteMats,s.xyzop)
	--Special summoned by its own method

end
s.listed_series={0x994}
function s.sprfilter(c,e)
	return c:IsFaceup() and c:GetLevel()
end
function s.sprfilter1(c,tp,g,sc,lv)
	local lv=c:GetLevel()
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_MZONE,0,nil)
	return (c:IsFaceup() and not c:IsType(TYPE_TOKEN)) and c:IsType(TYPE_XYZ) and g:IsExists(s.sprfilter2,1,c,tp,c,sc,lv)
end
function s.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return (c:GetLevel()+mc:GetRank())==7 and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function s.xyzop(e,tp,chk,mc,sc,lv)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sprfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=eg:Filter(s.sprfilter1,nil,e,tp,c)
	local pg=aux.GetMustBeMaterialGroup(tp,g,tp,nil,nil,REASON_XYZ)
	local tc=Duel.GetMatchingGroup(s.sprfilter1,tp,LOCATION_MZONE,0,nil):SelectUnselect(Group.CreateGroup(),tp,false,Xyz.ProcCancellable)
	if tc and #g>0 and #pg<=0 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 then
		c:SetMaterial(g)
		Duel.Overlay(tc,g)
		return true
	else return false end
end
