--Dragoscendent Progenitor Incendium
function c77777911.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x40d),1,1,aux.NonTuner(Card.IsSetCard,0x40d),1,99)
	c:EnableReviveLimit()
  --spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetDescription(aux.Stringid(77777911,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,77777911)
  e3:SetCondition(c77777911.spcon)
	e3:SetTarget(c77777911.sptg2)
	e3:SetOperation(c77777911.spop2)
	c:RegisterEffect(e3)
  --damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777911,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c77777911.setcon)
	e2:SetTarget(c77777911.damtg)
	e2:SetOperation(c77777911.damop)
	c:RegisterEffect(e2)
end
function c77777911.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c77777911.spfilter2(c,e,tp)
	return c:IsSetCard(0x40d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777911.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c77777911.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c77777911.spop2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tc=Duel.SelectMatchingCard(tp,c77777911.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if tc:GetCount()>0 then
      Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
  end
end

function c77777911.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x40d) and c:GetPreviousControler()==tp
end
function c77777911.cfilter2(c,e)
	return c==e:GetHandler()
end
function c77777911.setcon(e,tp,eg,ep,ev,re,r,rp)
  if eg:IsExists(c77777911.cfilter2,1,nil,e) then return false end
	return eg:IsExists(c77777911.cfilter,1,nil,tp)
end

function c77777911.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end
function c77777911.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end