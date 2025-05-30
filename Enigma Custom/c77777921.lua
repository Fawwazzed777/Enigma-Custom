--Requipped Warrior Amadeus
function c77777921.initial_effect(c)
  --special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,77777921)
	e1:SetCondition(c77777921.spcon)
	c:RegisterEffect(e1)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777921,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetTarget(c77777921.eqtg)
	e4:SetOperation(c77777921.eqop)
	c:RegisterEffect(e4)
end


function c77777921.eqfilter(c,ec)
	return c:IsSetCard(0x408) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c77777921.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--flag effect is set to allow the cards to be activated directly from the deck,
	--even though the monster is potentially already equipped with a Requipped card.
	e:GetHandler():RegisterFlagEffect(77777812,RESET_EVENT+0x1fe0000,0,1)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777921.eqfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) 
		and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or e:GetHandler():GetEquipGroup():Filter(Card.IsControler,nil,tp):GetCount()>0) end
	e:GetHandler():ResetFlagEffect(77777812)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c77777921.eqop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetEquipGroup():GetCount()>0 then
		local g2=e:GetHandler():GetEquipGroup()
		Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
	end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x408)then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c77777921.eqfilter,tp,LOCATION_DECK,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c,true)
	end
end

function c77777921.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x408)
end
function c77777921.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77777921.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
