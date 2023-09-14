--Aerolizer Ascension Brilliant
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_SYNCHRO),1,99,aux.FilterBoolFunction(Card.IsCode,499689704),1,1)
	--Must first be Synchro Summoned with the above materials
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	--atk change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(s.vala)
	c:RegisterEffect(e1)
	--def change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(s.vald)
	c:RegisterEffect(e2)
	--indes count
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.valcon)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.atkcon)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)
	--register effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) end)
	e5:SetOperation(s.regop)
	c:RegisterEffect(e5)
	--material count check
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(s.valcheck)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
end
s.listed_series={0xbf45}
s.synchro_tuner_required=2
s.synchro_nt_required=1
function s.vala(e,c)
	return c:GetBaseAttack()-1000
end
function s.vald(e,c)
	return c:GetBaseDefense()-1000
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or ((st&SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO and not se)
end
function s.valcon(e,re,r,rp)
	if (r&REASON_BATTLE+REASON_EFFECT)~=0 then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		return true
	else return false end
end
function s.synfilter(c)
	return c:IsType(TYPE_SYNCHRO)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(s.synfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if c:IsRelateToBattle() and c:IsFaceup() and ct>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL+RESET_EVENT+RESETS_STANDARD_DISABLE)
		e1:SetValue(ct*800)
		c:RegisterEffect(e1)
	end
end
--Check
function s.tunercheck(c)
	return c:IsType(TYPE_TUNER) 
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(s.tunercheck,nil)
	e:GetLabelObject():SetLabel(ct)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	--Negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ANNOUNCE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(ct)
	e1:SetTarget(s.atktg1)
	e1:SetOperation(s.atkop1)
	e1:SetReset(RESET_EVENT+(RESETS_STANDARD&~RESET_TURN_SET))
	c:RegisterEffect(e1)
end
function s.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.atkop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack() 
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2))then
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)	
end
end
end
