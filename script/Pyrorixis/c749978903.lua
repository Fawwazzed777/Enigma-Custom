--Pyrorixis High Sorcerer Marchel
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Inherent Fusion
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.spcon)
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetTargetRange(POS_FACEUP,0)	
	c:RegisterEffect(e0)
	--Apply up to 2 "Pyrorixis" Spell/trap from GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.cptg)
	e1:SetOperation(s.cpop)
	c:RegisterEffect(e1)
end
s.listed_series={0x7f3}
function s.spmatfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x7f3) and c:IsLevelAbove(7) and c:IsAbleToGraveAsCost()
end
function s.spmatfilter2(c)
	return c:IsSetCard(0x7f3) and c:IsSpell() and c:IsAbleToRemoveAsCost()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and Duel.IsExistingMatchingCard(s.spmatfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.spmatfilter2,tp,LOCATION_GRAVE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g1=Duel.GetMatchingGroup(s.spmatfilter1,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(s.spmatfilter2,tp,LOCATION_GRAVE,0,nil)	
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=g1:Select(tp,1,1,nil)
		if sg1:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg2=g2:Select(tp,1,1,nil)
			if sg2:GetCount()>0 then
				sg1:Merge(sg2)
				sg1:KeepAlive()
				e:SetLabelObject(sg1)
				return true
			end
		end
	end
	return false
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	local tc_mon=g:Filter(Card.IsLocation,nil,LOCATION_MZONE):GetFirst()
	local tc_spl=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetFirst()	
	if tc_mon and tc_spl then
		Duel.SendtoGrave(tc_mon,REASON_COST)
		Duel.Remove(tc_spl,POS_FACEUP,REASON_COST)
	end
	g:DeleteGroup()
end
function s.cpfilter(c)
	return c:IsSetCard(0x7f3) and c:IsSpellTrap()
		and c:IsAbleToDeck()
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cpfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local g=Duel.SelectMatchingCard(tp,s.cpfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do
		local te=tc:CheckActivateEffect(false,true,true)
		if te then
			local tg=te:GetTarget()
			local op=te:GetOperation()
			if tg then tg(te,tp,Group.CreateGroup(),PLAYER_NONE,0,e,REASON_EFFECT,PLAYER_NONE,1) end
			Duel.BreakEffect()
			tc:CreateEffectRelation(te)
			local tg_cards=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if tg_cards then
				for etc in aux.Next(tg_cards) do
					etc:CreateEffectRelation(te)
				end
			end
			if op then op(te,tp,Group.CreateGroup(),PLAYER_NONE,0,e,REASON_EFFECT,PLAYER_NONE,1) end
			tc:ReleaseEffectRelation(te)
			if tg_cards then
				for etc in aux.Next(tg_cards) do
					etc:ReleaseEffectRelation(te)
				end
			end
			local ct=Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			--Self Burn 
			if ct>0 then
			Duel.BreakEffect()
			Duel.Damage(tp,ct*1000,REASON_EFFECT)
			end
		end
	end
end
