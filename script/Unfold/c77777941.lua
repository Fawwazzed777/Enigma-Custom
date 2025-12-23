--Mystic Fauna Beastgle
function c77777941.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x40a),2)
	c:EnableReviveLimit()
  --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777941,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,77777941)
	e1:SetCondition(c77777941.hspcon)
	e1:SetTarget(c77777941.hsptg)
	e1:SetOperation(c77777941.hspop)
	c:RegisterEffect(e1)
  --spsummon grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777941,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1,77777941+EFFECT_COUNT_CODE_OATH)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c77777941.condition)
	e2:SetTarget(c77777941.sptg)
	e2:SetOperation(c77777941.spop)
	c:RegisterEffect(e2)
  --move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77777941,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,77777941+EFFECT_COUNT_CODE_OATH+EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(c77777941.seqtg)
	e3:SetOperation(c77777941.seqop)
	c:RegisterEffect(e3)
end

function c77777941.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c77777941.hspfilter(c,e,tp)
	return c:IsRace(RACE_BEAST) and c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c77777941.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return zone>0 and Duel.IsExistingMatchingCard(c77777941.hspfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77777941.hspop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777941.hspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
  local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c77777941.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c77777941.splimit(e,c)
	return c:GetRace()~=RACE_BEAST
end

function c77777941.spfilter(c,e,tp)
	return c:IsSetCard(0x40a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c77777941.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	return eg:GetCount()==1 and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsSetCard(0x40a)
end
function c77777941.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c77777941.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c77777941.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77777941.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77777941.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end


function c77777941.seqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x40a)
end
function c77777941.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77777941.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77777941.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77777941,1))
	Duel.SelectTarget(tp,c77777941.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c77777941.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,571)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end