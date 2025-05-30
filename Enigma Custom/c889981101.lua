--Mechwyrm Buster Hydrax
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,9,3)
	--Quick Xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_IMMEDIATELY_APPLY)
	e1:SetCountLimit(1,id)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(function() return Duel.IsBattlePhase() and Duel.GetFlagEffect(0,id)+Duel.GetFlagEffect(1,id)>=4 end)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--Send card(s) per attack declared
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.wcon)
	e2:SetCost(aux.dxmcostgen(1,1,op))
	e2:SetTarget(s.wtg)
	e2:SetOperation(s.wop)
	c:RegisterEffect(e2)
	--Count attacks declared
		aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(function(_,_,_,ep) Duel.RegisterFlagEffect(ep,id,RESET_PHASE+PHASE_END,0,1) end)
		Duel.RegisterEffect(ge1,0)
	end)
end
s.listed_names={889981100}
function s.filter(c,sc)
	return c:IsMonster() and c:IsCode(889981100) and c:IsFaceup()
end
function s.tg(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) end
	Duel.SetChainLimit(aux.FALSE)
	e:SetLabelObject(nil)
end
function s.op(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) then
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
		if #g>0 then
			c:SetMaterial(g)
			Duel.Overlay(c,g)
			Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			e:SetLabelObject(g:GetFirst())
			c:CompleteProcedure()
end
end
end

function s.wcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local ph=Duel.GetCurrentPhase()
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.GetFlagEffect(0,id)+Duel.GetFlagEffect(1,id)>=4
end
function s.wtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.wop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,Duel.GetFlagEffect(Duel.GetTurnPlayer(),id),nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
end	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
