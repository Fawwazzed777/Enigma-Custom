--Psybernated Agent Katherine
function c77777866.initial_effect(c)
  --pendulum summon
	aux.EnablePendulumAttribute(c)
  --banish on target
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(77777866,0))
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
  e1:SetCategory(CATEGORY_REMOVE)
  e1:SetCode(EVENT_CHAINING)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1)
  e1:SetCondition(c77777866.ngcon)
  e1:SetTarget(c77777866.ngtg)
  e1:SetOperation(c77777866.ngop)
  c:RegisterEffect(e1)
  --damage on banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777866,2))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetTarget(c77777866.damtg)
	e2:SetOperation(c77777866.damop)
	c:RegisterEffect(e2)
  --SS this card
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetDescription(aux.Stringid(77777866,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
  e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,77777866)
  e3:SetCondition(c77777866.pencon)
	e3:SetTarget(c77777866.pentg)
	e3:SetOperation(c77777866.penop)
	c:RegisterEffect(e3)
  --scale
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_LSCALE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c77777866.slcon)
	e4:SetValue(6)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e5)
end

function c77777866.slcon(e)
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  if tc1==e:GetHandler() then tc1=tc2 end
  return not tc1 or not tc1:IsSetCard(0x40b)
end
function c77777866.cfilter(c,tp)
	return c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_MONSTER) and c:GetOwner()==tp
end
function c77777866.pencon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77777866.cfilter,1,nil,tp)
end
function c77777866.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c77777866.penop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end



function c77777866.ngcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local loc,tg=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TARGET_CARDS)
	local tc=tg:GetFirst()
	if tg:GetCount()~=1 or not tc:IsLocation(LOCATION_MZONE) or not tc:IsSetCard(0x40b) then return false end
	return tc:IsAbleToRemove() and loc~=LOCATION_DECK
end
function c77777866.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
  local loc,tg=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TARGET_CARDS)
	local tc=tg:GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c77777866.ngop(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc,tg=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TARGET_CARDS)
	local tc=tg:GetFirst()
  if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		tc:RegisterFlagEffect(77777866,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c77777866.retcon)
		e1:SetOperation(c77777866.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c77777866.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(77777866)~=0
end
function c77777866.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end


function c77777866.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c77777866.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end