--Noxious Rebelious Lux
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,s.lcheck,2,nil,s.matcheck)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Deck Destruction
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.ddcon)
	e2:SetOperation(s.ddop)
	c:RegisterEffect(e2)
	--Gain LP equal to opponent's monster's ATK
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(s.rctg)
	e3:SetOperation(s.rcop)
	c:RegisterEffect(e3)
end
s.listed_series={0x222,0xb222}
function s.lcheck(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function s.matcheck(g,lc,sumtype,tp)
	return (g:IsExists(Card.IsSetCard,1,nil,0x222,lc,sumtype,tp) and g:IsExists(Card.IsType,1,nil,TYPE_LINK,lc,sumtype,tp))
end
function s.atkcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.atkval(e,c)
	local g=e:GetHandler():GetLinkedGroup():Filter(aux.FilterFaceupFunction(Card.IsAttribute,ATTRIBUTE_DARK),nil)
	return g:GetSum(Card.GetAttack)
end
function s.cfilter(c,g)
	return c:IsSetCard(0x222) and g:IsContains(c)
end
function s.ddcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg and eg:IsExists(s.cfilter,1,nil,lg)
end
function s.ddop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local ct=Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
	if ct>0 then
		Duel.Recover(tp,ct*800,REASON_EFFECT)
end
end
function s.rcfilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function s.rctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.rcfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.rcfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.rcfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function s.rcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
end

