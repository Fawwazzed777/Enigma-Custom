--Dragoscendent Caeli
function c77777900.initial_effect(c)
	--SS
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777900,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	--e1:SetCountLimit(1,77777900+EFFECT_COUNT_CODE_DUEL)
--	e1:SetCode(EVENT_FREE_CHAIN)
--	e1:SetCost(c77777900.cost)
	e1:SetTarget(c77777900.tg)
	e1:SetOperation(c77777900.op)
	c:RegisterEffect(e1)
  --synchro limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c77777900.synlimit)
	c:RegisterEffect(e2)
  --xyz limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c77777900.synlimit)
	c:RegisterEffect(e3)
end

--77777900 = revealed by monster
--77777901 = revealed by non-monster

function c77777900.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x40d)
end

function c77777900.revfilter(c)
	return c:IsSetCard(0x40d) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
--Makes sure you have the proper cards in hand and this card can be SS
function c77777900.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77777900.revfilter,tp,LOCATION_HAND,0,1,c)
    and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
    and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c77777900.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
  --Checks to see that there is still another monster in your hand, and selects it.
	if not Duel.IsExistingMatchingCard(c77777900.revfilter,tp,LOCATION_HAND,0,1,c) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c77777900.revfilter,tp,LOCATION_HAND,0,1,1,c)
  --Reveals it and raises event to tell other cards they have been revealed
	Duel.ConfirmCards(1-tp,g)
	Duel.RaiseSingleEvent(g:GetFirst(),77777900,e,REASON_EFFECT,tp,tp,0)
	Duel.ShuffleHand(tp)
  --SS this card
  if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end