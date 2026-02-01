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
	e0:SetTarget(s.selfsptg)
	e0:SetOperation(s.spop)
	e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetTargetRange(POS_FACEUP,0)	
	c:RegisterEffect(e0)
	--Apply up to 2 "Pyrorixis" Spell/trap from GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.cptg)
	e1:SetOperation(s.cpop)
	c:RegisterEffect(e1)
end
s.listed_series={0x7f3}
function s.fusfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(7) and c:IsSetCard(0x7f3) and c:IsAbleToGraveAsCost()
end
function s.spellfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x7f3) and c:IsAbleToRemoveAsCost()
end
function s.rescon(sg,e,tp,mg)
	return Duel.GetLocationCountFromEx(tp,tp,sg,e:GetHandler())>0
	and sg:FilterCount(Card.IsControler,nil,tp)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and Duel.IsExistingMatchingCard(s.fusfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.spellfilter,tp,LOCATION_GRAVE,0,1,nil)
end

function s.selfsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local mg=Duel.SelectMatchingCard(tp,s.fusfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if #mg==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,s.spellfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #sg==0 then return false end
	mg:KeepAlive()
	sg:KeepAlive()
	e:SetLabelObject(mg)
	e:SetLabel(sg:GetFirst():GetFieldID())
	return true
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=e:GetLabelObject()
	local fid=e:GetLabel()
	local sg=Duel.GetMatchingGroup(Card.GetFieldID,tp,LOCATION_GRAVE,0,nil,fid)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_MATERIAL+REASON_FUSION)
	Duel.Remove(sg,POS_FACEUP,REASON_MATERIAL+REASON_FUSION)
	mg:DeleteGroup()
end

function s.cpfilter(c)
	return c:IsSetCard(0x7f3) and c:IsSpellTrap()
		and c:IsAbleToDeck()
		and c:CheckActivateEffect(false,true,false)~=nil
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local g=Duel.SelectMatchingCard(tp,s.cpfilter,tp,LOCATION_GRAVE,0,1,2,nil)
	if #g==0 then return end
	local ct=0
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
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			ct=ct+1
			Duel.BreakEffect()
		end
	end
	--Self Burn 
	if ct>0 then
		Duel.Damage(tp,ct*1000,REASON_EFFECT)
	end
end
