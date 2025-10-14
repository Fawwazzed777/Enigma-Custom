--
local s,id=GetID()
function s.initial_effect(c)
	--Apply effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.descost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
function s.cfilter(c,tp)
	local atk=c:GetBaseAttack()
	if atk<0 then atk=0 end
	return c:IsMonster() and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(s.dfilter,tp,0,LOCATION_MZONE,1,nil,atk)
end
function s.dfilter(c,atk)
	return c:IsFaceup() and c:GetBaseAttack()<=atk
end
function s.dfilter2(c,atk)
	return c:IsFaceup() and c:GetBaseAttack()>=def
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,e:GetHandler(),tp)
	local atk=g:GetFirst():GetBaseAttack()
	if atk<0 then atk=0 end
	e:SetLabel(atk)
	local def=g:GetFirst():GetDefense()
	if def>0 then def=0 end
	e:SetLabel(def)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingMatchingCard(s.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.GetFlagEffect(tp,id)==0
	local b2=Duel.IsExistingMatchingCard(s.dfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.GetFlagEffect(tp,id+1)==0
	if chk==0 then return b1 or b2 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,nil,1,PLAYER_EITHER,LOCATION_MZONE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,nil,1,PLAYER_EITHER,LOCATION_MZONE)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
local b1=Duel.IsExistingMatchingCard(s.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.GetFlagEffect(tp,id)==0
local b2=Duel.IsExistingMatchingCard(s.dfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.GetFlagEffect(tp,id+1)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else return end
if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,s.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.dfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
	end
end
