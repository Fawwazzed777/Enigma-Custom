--
local s,id=GetID()
function s.initial_effect(c)
	--Link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--Increase ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetTarget(s.ta)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
function s.atkval(e,c)
	return c:GetLinkedGroup():FilterCount(aux.FilterBoolFunction(Card.IsMonster),nil)*500
end
function s.filter(e,c,cc)
	return (not Duel.GetAttacker() or c~=Duel.GetAttacker()) and c~=Duel.GetAttackTarget()
end
function s.ta(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst() end
	if tc then
		Duel.HintSelection(tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_SELF_ATTACK)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		e1:SetTargetRange(1,1)
		Duel.RegisterEffect(e1,tp)
		Duel.ChangeAttackTarget(tc,true)
	end
end
