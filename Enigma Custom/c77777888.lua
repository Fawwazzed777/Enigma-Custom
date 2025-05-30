--Resplendent Clearing in the Glade
function c77777888.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCategory(CATEGORY_POSITION)
  e1:SetCountLimit(1,77777888)
	e1:SetTarget(c77777888.fliptg)
	e1:SetOperation(c77777888.flipop)
	c:RegisterEffect(e1)
  --destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c77777888.reptg)
	e2:SetValue(c77777888.repval)
	e2:SetOperation(c77777888.repop)
	c:RegisterEffect(e2)
end

function c77777888.fliptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil) 
    and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.IsExistingMatchingCard(c77777888.filter,tp,LOCATION_DECK,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c77777888.filter(c)
	return c:IsSetCard(0x40c) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77777888.flipop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		if Duel.ChangePosition(tc,0,0,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
      local g=Duel.SelectMatchingCard(tp,c77777888.filter,tp,LOCATION_DECK,0,1,1,nil)
      if g:GetCount()>0 then
        Duel.SSet(tp,g:GetFirst())
        Duel.ConfirmCards(1-tp,g)
      end
    end
	end
end


function c77777888.repfilter(c,tp)
	return ((c:IsFaceup() and c:IsSetCard(0x40c)) or (c:IsFacedown() and c:IsType(TYPE_MONSTER))) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c77777888.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and aux.exccon(e) and eg:IsExists(c77777888.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(77777888,0))
end
function c77777888.repval(e,c)
	return c77777888.repfilter(c,e:GetHandlerPlayer())
end
function c77777888.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
