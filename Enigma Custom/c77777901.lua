--Dragoscendent Glacies
function c77777901.initial_effect(c)
  --synchro limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c77777901.synlimit)
	c:RegisterEffect(e2)
  --xyz limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetValue(c77777901.synlimit)
	c:RegisterEffect(e5)
  --Revealed by monster, special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetDescription(aux.Stringid(77777901,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(77777900)
  e3:SetRange(LOCATION_HAND)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e3:SetTarget(c77777901.rtg)
  e3:SetOperation(c77777901.rop)
	c:RegisterEffect(e3)
	--Revealed by S/T, special summon
	local e4=e3:Clone()
	e4:SetCode(77777901)
	c:RegisterEffect(e4)
end

function c77777901.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x40d)
end


function c77777901.rtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
    	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77777901.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end