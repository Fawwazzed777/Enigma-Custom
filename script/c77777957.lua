--Mechanoclast Power Walker
function c77777957.initial_effect(c)
  --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x40e),3,4)
	c:EnableReviveLimit()
  --damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777957,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c77777957.damcost)
	e1:SetTarget(c77777957.damtg)
	e1:SetOperation(c77777957.damop)
	c:RegisterEffect(e1)
  --actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c77777957.aclimit)
	e2:SetCondition(c77777957.actcon)
	c:RegisterEffect(e2)
  --ss from grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777957,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c77777957.spcost)
	e4:SetTarget(c77777957.sptg)
	e4:SetOperation(c77777957.spop)
	c:RegisterEffect(e4)
end

function c77777957.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x40e,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x40e,3,REASON_COST)
end

function c77777957.spfilter(c,e,tp)
	return c:IsSetCard(0x40e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777957.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  and Duel.IsExistingMatchingCard(c77777957.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77777957.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777957.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end



function c77777957.countfilter(c)
	return c:IsSetCard(0x40e) and c:IsFaceup() and (c:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT or c:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT+TYPE_LINK)
end
function c77777957.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x40e,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x40e,1,REASON_COST)
end
function c77777957.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777957.countfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c77777957.damop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c77777957.countfilter,tp,LOCATION_SZONE,0,1,nil) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local val= Duel.GetMatchingGroup(c77777957.countfilter,e:GetHandler():GetControler(),LOCATION_SZONE,0,nil):GetCount()*400
	if val>0 then
		Duel.Damage(p,val,REASON_EFFECT)
	end
end

function c77777957.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c77777957.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
