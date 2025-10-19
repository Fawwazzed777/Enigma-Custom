--Enigmation - Calamitous
local s,id=GetID()
function s.initial_effect(c)
	Pendulum.AddProcedure(c)
	--lp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.lpcost)
	e1:SetTarget(s.lptg)
	e1:SetOperation(s.lpop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,5))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,{id,2})
	e2:SetCondition(s.actcon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--Fusion , Synchro, Xyz
	local params = {aux.FilterBoolFunction(Card.IsSetCard,0x344)}
	local ef=Effect.CreateEffect(c)
	ef:SetDescription(aux.Stringid(id,2))
	ef:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	ef:SetType(EFFECT_TYPE_QUICK_O)
	ef:SetCode(EVENT_FREE_CHAIN)
	ef:SetRange(LOCATION_MZONE+LOCATION_HAND)
	ef:SetCondition(function(e,tp) return Duel.IsExistingMatchingCard(s.check,tp,LOCATION_MZONE+LOCATION_HAND,0,2,e:GetHandler()) end)
	ef:SetCost(s.scost)
	ef:SetCountLimit(1,{id,1})
	ef:SetTarget(Fusion.SummonEffTG(table.unpack(params)))
	ef:SetOperation(Fusion.SummonEffOP(table.unpack(params)))
	c:RegisterEffect(ef)
	local esy=ef:Clone()
	esy:SetDescription(aux.Stringid(id,3))
	esy:SetCategory(CATEGORY_SPECIAL_SUMMON)
	esy:SetTarget(s.sctg)
	esy:SetOperation(s.scop)
	c:RegisterEffect(esy)
	local exy=ef:Clone()
	exy:SetDescription(aux.Stringid(id,4))
	exy:SetCategory(CATEGORY_SPECIAL_SUMMON)
	exy:SetTarget(s.xyztg)
	exy:SetOperation(s.xyzop)
	c:RegisterEffect(exy)
end
s.listed_series={0x344}
--
function s.actfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function s.actcon(e)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(s.actfilter),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	local atk=tc:GetTextAttack()
	if tc then
		Duel.HintSelection(g)
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and aux.FilterBoolFunction(Card.IsOriginalType,TYPE_MONSTER) then
		Duel.BreakEffect()
		Duel.Damage(1-tp,atk/2,REASON_EFFECT)
		end
	end
end
--
function s.costfilter(c)
	return c:IsSetCard(0x344) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function s.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1600)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1600)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	--Draw
	if	Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
end
end
function s.check(c,e,tp)
	return c:IsMonster() and c:IsSetCard(0x344)
	and (c:IsCanBeFusionMaterial() or c:IsCanBeSynchroMaterial() or c:IsCanBeXyzMaterial()) and not c:IsHasEffect(EFFECT_IMMUNE_EFFECT)
end
function s.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
--Synchro
function s.synfilter(c,tp,hg)
	return c:IsSynchroSummonable(nil,hg)
end
function s.syns(c,e,tp)
	return c:IsSetCard(0x344) and c:IsMonster() and c:IsCanBeSynchroMaterial()
end
function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetMatchingGroup(s.syns,tp,LOCATION_MZONE+LOCATION_HAND,0,e:GetHandler())
	if chk==0 then return #hg>0 and Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,e:GetHandler(),nil,hg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetMatchingGroup(s.syns,tp,LOCATION_MZONE+LOCATION_HAND,0,e:GetHandler())
	Duel.ConfirmCards(1-tp,hg)
	local syng=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_EXTRA,0,e:GetHandler(),nil,hg)
	if #syng>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=syng:Select(tp,1,1,nil):GetFirst()
		Duel.SynchroSummon(tp,sc,nil,hg)
end
end
--Xyz
function s.xyzfilter(c,tp,mg)
	return c:IsXyzSummonable(nil,mg) 
end
function s.xyzs(c,e,tp)
	return c:IsSetCard(0x344) and c:IsMonster() and c:IsCanBeXyzMaterial()
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(s.xyzs,tp,LOCATION_MZONE+LOCATION_HAND,0,e:GetHandler())
	Duel.ConfirmCards(1-tp,mg)
	if chk==0 then return #mg>0 and Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,e:GetHandler(),nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(s.xyzs,tp,LOCATION_MZONE+LOCATION_HAND,0,e:GetHandler())
	local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,e:GetHandler(),nil,mg)
	if #xyzg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,nil,mg)
end
end
