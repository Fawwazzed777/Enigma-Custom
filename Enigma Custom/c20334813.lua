--Ultimaya King of Demolition
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x309),1,1,Synchro.NonTunerEx(Card.IsSetCard,0x309),1,99)
	Pendulum.AddProcedure(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,{id,0})
	e1:SetTarget(s.target)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	-- Place in Pendulum Zone on Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.sppencon)
	e2:SetTarget(s.pentg2)
	e2:SetOperation(s.penop2)
	c:RegisterEffect(e2)
	--Destroy & Damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,{id,2})
	e3:SetTarget(s.target2)
	e3:SetOperation(s.opo)
	c:RegisterEffect(e3)
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER) 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,c) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,c) end
	local g1=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,c)
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local ct1=#g1
	local ct2=#g2
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,ct1+((ct1>ct2) and ct2 or ct1),0,0)
end

function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,e:GetHandler())
	local ct1=Duel.Destroy(g1,REASON_EFFECT)
	if ct1==0 then return end
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local ct2=#g2
	if ct2==0 then return end
	Duel.BreakEffect()
	if ct2<=ct1 then
		Duel.Destroy(g2,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g3=g2:Select(tp,ct1,ct1,nil)
		Duel.HintSelection(g3)
		Duel.Destroy(g3,REASON_EFFECT)
end
end
function s.penfilter(c)
	return c:IsSetCard(0x309) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(s.penfilter,tp,LOCATION_DECK,0,1,nil)  end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local pg=Duel.SelectMatchingCard(tp,s.penfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if pg then
		Duel.MoveToField(pg,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		
end
end
function s.pentg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function s.penop2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function s.sppenconfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x309) or c:IsCode(1686814)
end
function s.sppencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(s.sppenconfilter,1,nil,tp) and c:IsFaceup()
end

function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,1-tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,1-tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function s.opo(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			Duel.Damage(1-tp,tc:GetBaseAttack()/2,REASON_EFFECT)
		end
	end
end

