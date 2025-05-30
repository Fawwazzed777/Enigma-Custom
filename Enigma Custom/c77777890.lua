--Amber Fairy of the Glade
function c77777890.initial_effect(c)
  --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),1,2,c77777890.ovfilter,aux.Stringid(77777890,0),5)
	c:EnableReviveLimit()
  --flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777890,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetTarget(c77777890.tg)
	e1:SetOperation(c77777890.op)
	c:RegisterEffect(e1)
  --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777890,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c77777890.spcost)
	e2:SetTarget(c77777890.sptg)
	e2:SetOperation(c77777890.spop)
	c:RegisterEffect(e2)
  --negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,77777890)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c77777890.discon)
	e3:SetCost(c77777890.discost)
	e3:SetTarget(c77777890.distg)
	e3:SetOperation(c77777890.disop)
	c:RegisterEffect(e3)
end

function c77777890.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x40c) and c:IsType(TYPE_XYZ) and not c:IsCode(77777890)
end

function c77777890.cfilter(c)
	return c:IsSetCard(0x9c) and c:IsType(TYPE_MONSTER)
end
function c77777890.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroup(c77777890.cfilter,tp,LOCATION_GRAVE,0,nil)
	return ct:GetClassCount(Card.GetCode)>=7
end
function c77777890.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST)end
	c:RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c77777890.spfilter(c,e,tp,mc)
	return c:IsSetCard(0x40c) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and not c:IsCode(77777890)
end
function c77777890.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c77777890.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c77777890.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>=0 and c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c77777890.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
			local sc=g:GetFirst()
			if sc then
				local mg=c:GetOverlayGroup()
				if mg:GetCount()~=0 then
					Duel.Overlay(sc,mg)
				end
				sc:SetMaterial(Group.FromCards(c))
				Duel.Overlay(sc,Group.FromCards(c))
				Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
				sc:CompleteProcedure()
			end
		end
	end
  
function c77777890.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and re:GetHandlerPlayer()~=tp
end
function c77777890.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77777890.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsFaceup() and re:GetHandler():IsCanTurnSet() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,1,0,0)
	end
end
function c77777890.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
    local rc=re:GetHandler()
    rc:CancelToGrave()
		if Duel.ChangePosition(rc,POS_FACEDOWN)~=0 then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_FIELD)
      e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
      e1:SetCode(EFFECT_CANNOT_ACTIVATE)
      e1:SetTargetRange(0,1)
      e1:SetReset(RESET_PHASE+PHASE_END)
      e1:SetValue(c77777890.aclimit)
      e1:SetLabel(re:GetHandler():GetCode())
      Duel.RegisterEffect(e1,tp)
    end
	end
end
function c77777890.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(e:GetLabel())
end

function c77777890.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function c77777890.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	local sg=g:Select(1-tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end