--Enigmatic Lord – Seismic Warden
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--special summon
	local es=Effect.CreateEffect(c)
	es:SetDescription(aux.Stringid(id,0))
	es:SetCategory(CATEGORY_SPECIAL_SUMMON)
	es:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	es:SetCode(EVENT_PHASE|PHASE_END)
	es:SetRange(LOCATION_HAND|LOCATION_REMOVED)
	es:SetCountLimit(1,{id,0})
	es:SetTarget(s.sptg)
	es:SetOperation(s.spop)
	c:RegisterEffect(es)
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
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,{id,2})
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP|EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.dtcon)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.drop)
	c:RegisterEffect(e4)
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
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,1-tp,1)
end
function s.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetFieldGroup(1-tp,0,LOCATION_GRAVE):RandomSelect(tp,1)
	local g2=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):RandomSelect(tp,1)
	g1:Merge(g2)
	Duel.SendtoHand(g1,c:GetControler()~=c:GetOwner(),REASON_EFFECT)
end
function s.dtcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:GetHandler():IsLocation(LOCATION_ONFIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsMonsterEffect()
end
function s.posfilter(c)
	return c:IsCanChangePosition()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local rc=re:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,tp,0)
	if rc:IsAbleToDeck() and rc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,tp,0)
	end
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoDeck(eg,1,REASON_EFFECT)
	end
end