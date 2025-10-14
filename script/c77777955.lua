--Mechanoclast Spider Tank
function c77777955.initial_effect(c)
  --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x40e),3,3)
	c:EnableReviveLimit()
  --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777955,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c77777955.thcon)
	e2:SetTarget(c77777955.thtg)
	e2:SetOperation(c77777955.thop)
	c:RegisterEffect(e2)
end

function c77777955.filter(c)
	return c:IsSetCard(0x40e) and c:IsFaceup()
end
function c77777955.filter2(c,hc)
	return c:GetColumnGroup():IsContains(hc)
end
function c77777955.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetLinkedGroup():FilterCount(Card.IsAbleToHand,nil)>0
end
function c77777955.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup():Filter(Card.IsAbleToHand,nil)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,lg,lg:GetCount(),0,0)
end
function c77777955.thop(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup():Filter(Card.IsAbleToHand,nil)
  if e:GetHandler():GetSequence()<5 and Duel.IsExistingMatchingCard(c77777955.filter2,tp,LOCATION_SZONE,0,1,nil,e:GetHandler())then
    local g=Duel.GetMatchingGroup(c77777955.filter2,tp,LOCATION_SZONE,0,nil,e:GetHandler())
    lg:Merge(g)
  end
	Duel.SendtoHand(lg,nil,REASON_EFFECT)
end