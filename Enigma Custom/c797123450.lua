--Noble Caesar Dragon
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,1,id)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,49968950,49968945)
	--Leave rep
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetCountLimit(2)
	e1:SetCondition(s.repcon)
	e1:SetTarget(s.reptg)
	c:RegisterEffect(e1)
	--damage reduce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(s.damval)
	c:RegisterEffect(e2)
	--Nullify LP gains
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_REVERSE_RECOVER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,1)
	e3:SetValue(s.damval)
	c:RegisterEffect(e3)
	--Following effects
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(s.effcon)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetCondition(s.effcon1)
	e5:SetTarget(s.tgtg)
	e5:SetOperation(s.tgop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e6:SetCondition(s.rdcon)
	e6:SetValue(aux.ChangeBattleDamage(1,HALF_DAMAGE))
	c:RegisterEffect(e6)
end
s.miracle_synchro_fusion=true
function s.exfilter(c,e)
	return c:GetOriginalType(ORIGINAL_TYPE_EXTRA)
end
function s.repcon(e)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(s.exfilter),e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) 
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	return Duel.SelectEffectYesNo(tp,c)
end
function s.damval(e,re,val,r,rp,rc)
	if (r&REASON_EFFECT)~=0 then return 0 end
	return val
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.effcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)~=0 and Duel.GetAttacker()==e:GetHandler()
end
function s.rdcon(e)
	local tp=e:GetHandlerPlayer()
	return e:GetHandler():GetFlagEffect(id)~=0 and
	Duel.GetAttackTarget()==nil and e:GetHandler():GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function s.tgfilter(c,p)
	return Duel.IsPlayerCanSendtoGrave(p,c)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,0,LOCATION_MZONE,nil,1-tp)
	if chk==0 then return #g>0 end
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,0,0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,0,LOCATION_MZONE,nil,1-tp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if ct<=0 or #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_RULE,PLAYER_NONE,1-tp)
end
end