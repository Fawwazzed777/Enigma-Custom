--Dragoscendent Incendium
function c77777902.initial_effect(c)
  --synchro limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c77777902.synlimit)
	c:RegisterEffect(e2)
  --xyz limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c77777902.synlimit)
	c:RegisterEffect(e3)
  --spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_HAND)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
  e5:SetCountLimit(1,77777902)
  e5:SetDescription(aux.Stringid(77777902,0))
	e5:SetCondition(c77777902.spcon1)
	e5:SetTarget(c77777902.sptg1)
	e5:SetOperation(c77777902.spop1)
	c:RegisterEffect(e5)
end

function c77777902.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x40d)
end


function c77777902.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x40d) and c:GetSummonPlayer()==tp
end
function c77777902.rfilter(c,e,tp)
	return c:IsSetCard(0x40d) and c:IsType(TYPE_MONSTER) and not c:IsCode(e:GetHandler():GetCode()) and Duel.IsExistingMatchingCard(c77777902.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetCode(),c:GetCode()) and not c:IsPublic()
end
function c77777902.filter(c,code1,code2)
	return c:IsSetCard(0x40d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
    and not (c:IsCode(code1) or c:IsCode(code2))
end
function c77777902.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77777902.rfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and eg:IsExists(c77777902.cfilter,1,nil,tp)
end

function c77777902.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777902.rfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777902.spop1(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
  local g=Duel.SelectMatchingCard(tp,c77777902.rfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  local group=Group.FromCards(g:GetFirst(),e:GetHandler())
  Duel.ConfirmCards(1-tp,group)
  Duel.RaiseSingleEvent(g:GetFirst(),77777900,e,REASON_EFFECT,tp,tp,0)
  Duel.RaiseSingleEvent(e:GetHandler(),77777900,e,REASON_EFFECT,tp,tp,0)
  Duel.ShuffleHand(tp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c77777902.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetHandler():GetCode(),g:GetFirst():GetCode())
	if g2:GetCount()>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end