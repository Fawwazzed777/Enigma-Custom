--Psybernated Support Joan
function c77777939.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),2)
	c:EnableReviveLimit()
  --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777939,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c77777939.rmcon)
	e1:SetTarget(c77777939.rmtg)
	e1:SetOperation(c77777939.rmop)
	c:RegisterEffect(e1)
  --destroy replace
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EFFECT_DESTROY_REPLACE)
	e8:SetRange(LOCATION_MZONE)
  e8:SetCountLimit(1)
	e8:SetTarget(c77777939.reptg)
	e8:SetValue(c77777939.repval)
	e8:SetOperation(c77777939.repop)
  c:RegisterEffect(e8)
  --spsummon
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e9:SetDescription(aux.Stringid(77777939,1))
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
  e9:SetCountLimit(1,77777939)
	e9:SetCost(c77777939.spcost)
	e9:SetTarget(c77777939.sptg)
	e9:SetOperation(c77777939.spop)
	c:RegisterEffect(e9)
end

function c77777939.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function c77777939.banfilter2(c)
	return not c:IsLocation(LOCATION_REMOVED)
end
function c77777939.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mat=e:GetHandler():GetMaterial()
	if chk==0 then return mat:IsExists(c77777939.banfilter2,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,mat,mat:GetCount(),0,0)
end
function c77777939.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial()
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end


function c77777939.banfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAbleToRemove()
end
function c77777939.repfilter(c,tp,hc)
	return hc:GetLinkedGroup():IsContains(c) and not c:IsReason(REASON_REPLACE) 
end
function c77777939.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777939.banfilter,0,LOCATION_DECK,0,1,nil) and eg:IsExists(c77777939.repfilter,1,nil,tp,e:GetHandler()) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c77777939.repval(e,c)
	return c77777939.repfilter(c,e:GetHandlerPlayer(),e:GetHandler())
end
function c77777939.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c77777939.banfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

function c77777939.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c77777939.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x40b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777939.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77777939.filter1,tp,LOCATION_REMOVED,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c77777939.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c77777939.filter1,tp,LOCATION_REMOVED,0,2,2,nil,e,tp)
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end