--Lady of the Glade
function c77777881.initial_effect(c)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(511001225)
	e2:SetOperation(c77777881.tgval)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--To grave
	local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(77777881,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetTarget(c77777881.target)
	e3:SetOperation(c77777881.operation)
	c:RegisterEffect(e3)
  --attack limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_FLIP)
	e5:SetOperation(c77777881.flipop)
	c:RegisterEffect(e5)
end

function c77777881.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(77777876,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end

function c77777881.tgval(e,c)
	return c:IsRace(RACE_FAIRY)
end

function c77777881.tgfilter(c)
	return c:IsSetCard(0x40c) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c77777881.xyzfilter(c)
	return c:IsXyzSummonable() and c:IsRace(RACE_FAIRY)
end
function c77777881.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777881.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c77777881.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c77777881.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT) 
    and Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)
    and Duel.SelectYesNo(tp,aux.Stringid(77777881,1))  then
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    local g2=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil)
    if g2:GetCount()>0 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      local sg=g2:Select(tp,1,1,nil)
      Duel.XyzSummon(tp,sg:GetFirst(),nil)
    end
	end
end
function c77777881.xyzchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,419)
	Duel.CreateToken(1-tp,419)
end