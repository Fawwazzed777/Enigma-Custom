--Dragoscendent Petram
function c77777904.initial_effect(c)
  --Revealed by monster, special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetDescription(aux.Stringid(77777904,0))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(77777900)
  e3:SetRange(LOCATION_HAND)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e3:SetTarget(c77777904.rtg)
  e3:SetOperation(c77777904.rop)
	c:RegisterEffect(e3)
  --synchro limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c77777904.synlimit)
	c:RegisterEffect(e2)
  --xyz limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(c77777904.synlimit)
	c:RegisterEffect(e4)
end

function c77777904.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x40d)
end

function c77777904.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c77777904.rtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if not re then return false end
  local rc=re:GetHandler()
  if not rc:IsType(TYPE_MONSTER) then return false end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
      and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c77777904.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
  local rc=re:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  if Duel.IsExistingMatchingCard(c77777904.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,rc:GetCode())then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77777904.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,rc:GetCode())
    if g:GetCount()>0 then
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
 else
	if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
  end
end