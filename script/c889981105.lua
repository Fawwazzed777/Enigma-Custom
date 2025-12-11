--Enigmatic Lord - Alpha
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--special summon
	local es=Effect.CreateEffect(c)
	es:SetDescription(aux.Stringid(id,0))
	es:SetCategory(CATEGORY_SPECIAL_SUMMON)
	es:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	es:SetCode(EVENT_PHASE|PHASE_BATTLE_START)
	es:SetRange(LOCATION_HAND|LOCATION_REMOVED)
	es:SetCountLimit(1,{id,0})
	es:SetTarget(s.sptg)
	es:SetOperation(s.spop)
	c:RegisterEffect(es)
	local er=es:Clone()
	er:SetCode(EVENT_PHASE|PHASE_STANDBY)
	c:RegisterEffect(er)
	local et=es:Clone()
	et:SetCode(EVENT_PHASE|PHASE_END)
	c:RegisterEffect(et)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,{id,1})
	e1:SetTarget(s.dtg)
	e1:SetOperation(s.dop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,{id,2})
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP|EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.dtcon)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.drop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCondition(s.cond)
	e5:SetOperation(s.cto)
	c:RegisterEffect(e5)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function s.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
end
function s.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.dtcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and not chkc:IsControler(tp) end
	local rc=re:GetHandler()
	if chk==0 then return rc:IsOnField() and rc:IsControler(1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,LOCATION_ONFIELD)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	Duel.Destroy(rc,REASON_EFFECT) 
end
function s.cond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(1-tp)
end
function s.cto(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=Duel.GetAttacker()
	if not tc or not tc:IsRelateToBattle() then return end
	if tc then
	Duel.Destroy(tc,REASON_EFFECT)
end
end
