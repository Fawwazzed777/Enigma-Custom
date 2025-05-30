local s,id=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.cointg)
	e1:SetOperation(s.coinop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)	
end
s.listed_series={0x5}
s.toss_coin=true
function s.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	s.arcanareg(c,res)
end
function s.arcanareg(c,coin)
		--Heads
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCountLimit(2)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(s.discon)
		e1:SetTarget(s.distg)
		e1:SetOperation(s.disop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetDescription(aux.Stringid(id,3))
		e2:SetCode(EVENT_SUMMON)
		e2:SetCondition(s.damcon)
		e2:SetTarget(s.damtg)
		e2:SetOperation(s.damop)
		e2:SetLabelObject(e1)
		c:RegisterEffect(e2)
		local e4=e2:Clone()
		e4:SetCode(EVENT_SPSUMMON)
		c:RegisterEffect(e4)
		local e5=e2:Clone()
		e5:SetCode(EVENT_FLIP_SUMMON)
		c:RegisterEffect(e5)
		local e6=e2:Clone()
		e6:SetCode(EVENT_MSET)
		c:RegisterEffect(e6)
		--Tails
		local e7=Effect.CreateEffect(c)
		e7:SetDescription(aux.Stringid(id,1))
		e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e7:SetCode(EVENT_SUMMON)
		e7:SetRange(LOCATION_MZONE)
		e7:SetCountLimit(1)
		e7:SetCondition(s.dacon)
		e7:SetOperation(s.daop)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e7)
		local e8=e7:Clone()
		e8:SetCode(EVENT_SPSUMMON)
		c:RegisterEffect(e8)
		local e9=e7:Clone()
		e9:SetCode(EVENT_FLIP_SUMMON)
		c:RegisterEffect(e9)
		local e10=e7:Clone()
		e10:SetCode(EVENT_MSET)
		c:RegisterEffect(e10)
		c:RegisterFlagEffect(36690018,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)	
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(36690018)==1 and rp~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) 
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(36690018)==1 and rp~=tp
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,#eg,0,0)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
--Tails
function s.dacon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetFlagEffectLabel(36690018)==0 and rp~=tp
	and not (e:GetHandler():IsAttack(1300) or e:GetHandler():IsDefense(1300))
end
function s.daop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(1300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		c:RegisterEffect(e2)
end
