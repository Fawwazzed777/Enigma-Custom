--Ultimaya King Flame Gust
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	c:EnableReviveLimit()
	Pendulum.AddProcedure(c)
	Fusion.AddProcMix(c,true,true,49968956,s.ffilter)
	--Negate any effect activation that make a cards leave the field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(s.dcon)
	e1:SetTarget(s.dtg)
	e1:SetOperation(s.dop)
	c:RegisterEffect(e1)
	--Indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--To pendulum zone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.pentg)
	e3:SetOperation(s.penop)
	c:RegisterEffect(e3)
	--Slap the Unaffected
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(s.discon)
	e4:SetTarget(s.disable)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(-1000)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	e6:SetValue(-1000)
	c:RegisterEffect(e6)
end
s.listed_series={0x309}
function s.ffilter(c,fc,sumtype,tp)
	return c:IsSetCard(0x309,fc,sumtype,tp) and c:GetLevel()>=5 and (c:IsType(TYPE_PENDULUM,scard,sumtype,tp) and c:IsType(TYPE_FUSION,scard,sumtype,tp))
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x309) or c:IsCode(1686814)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3000)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(3110)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCode(EFFECT_IMMUNE_EFFECT)
		e5:SetValue(s.efilter)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e5)
	end
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--Field Protection
function s.dcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	if not Duel.IsChainDisablable(ev) then return false end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	if eb and tg and tg:IsExists(Card.IsOnField,1,nil) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if eb and tg and tg:IsExists(Card.IsOnField,1,nil) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TODECK)
	if eb and tg and tg:IsExists(Card.IsOnField,1,nil) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	if eb and tg and tg:IsExists(Card.IsOnField,1,nil) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	if eb and tg and tg:IsExists(Card.IsOnField,1,nil) then return true end
	return eb and tg and tg:IsExists(Card.IsOnField,1,nil)
end
function s.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
end
function s.dop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
end
end	
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
end
function s.discon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function s.disable(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
