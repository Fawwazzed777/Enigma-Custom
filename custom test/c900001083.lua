--The Amethyst Imitator Beating Heart
local s,id=GetID()
function s.initial_effect(c)
	--Add or special summon 1 "Amethyst Imitator" monster from GY
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Change Code + negate
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
s.listed_series={0x7988}
function s.ssfilter(c,ft,e,tp)
	return c:IsSetCard(0x7988) and c:IsType(TYPE_MONSTER) and ((ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)) or c:IsAbleToHand())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.ssfilter(chkc,e,tp,ft) end
	if chk==0 then return Duel.IsExistingTarget(s.ssfilter,tp,LOCATION_GRAVE,0,1,nil,ft,e,tp) end
	local g=Duel.GetMatchingGroup(s.ssfilter,tp,LOCATION_GRAVE,0,nil,ft,e,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local sg=g:Select(tp,1,1,nil)
		Duel.SetTargetCard(sg)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sc=Duel.GetFirstTarget()
	if sc and sc:IsRelateToEffect(e) then
		aux.ToHandOrElse(sc,tp,function(c)
			return sc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and ft>0 end,
		function(c)
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) end,
		2)
	end
	Duel.SpecialSummonComplete()
end
	
function s.filter1(c,tp)
	return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,c,c:GetCode()) 
end
function s.filter(c)
	return c:IsFaceup() and c:IsMonster() and c:IsOriginalSetCard(0x7988) 
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,nil,tp) 
	and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local g1=Duel.SelectTarget(tp,s.filter1,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),g1:GetFirst():GetCode())
	e:SetLabelObject(g1:GetFirst())
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c1=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if c1==tc then c1=g:GetNext() end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or not tc:IsControler(tp) then return end
	if c1:IsFaceup() and c1:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(c1:GetOriginalCode())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		--continous negation
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(s.discon)
		e2:SetOperation(s.disop)
		e2:SetLabel(c1:GetOriginalCodeRule())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.AdjustInstantly(tc)
end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return re:IsActiveType(TYPE_SPELL) and loc&LOCATION_ONFIELD~=0 and (code1==code or code2==code)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.NegateEffect(ev)
end
