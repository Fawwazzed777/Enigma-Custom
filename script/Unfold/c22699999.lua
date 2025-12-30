--Eternity Ace - High Empress
local s,id=GetID()
function s.initial_effect(c)
c:SetUniqueOnField(1,0,id)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,s.ffilter1,s.ffilter2,s.ffilter3)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetRange(0x7)
	e0:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.rcost)
	e1:SetTarget(s.rtg)
	e1:SetOperation(s.rop)
	c:RegisterEffect(e1)
end
function s.ffilter1(c,fc,sumtype,tp)
	return c:IsCode(16399999)
end
function s.ffilter2(c,fc,sumtype,tp)
	return c:IsSetCard(0x994) and c:IsAttribute(ATTRIBUTE_LIGHT) 
end
function s.ffilter3(c,fc,sumtype,tp)
	return c:IsSetCard(0x994) and c:IsAttribute(ATTRIBUTE_DARK) 
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(function(c) return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost() end,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST+REASON_MATERIAL)
end
function s.costfilter1(c)
	return c:IsSetCard(0x993) and c:IsAbleToRemoveAsCost()
end
function s.rcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	local maxtc=Duel.GetTargetCount(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter1,tp,LOCATION_GRAVE,0,1,maxtc,nil)
	local cg=Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(cg)
end
function s.rtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetTargetCards(e)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local rg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,ct,0,0)
	if #rg>0 then
		Duel.HintSelection(rg)
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
	end
end