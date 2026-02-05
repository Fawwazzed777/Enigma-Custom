--Pyrorixis Mage Falina
local s,id=GetID()
function s.initial_effect(c)
	--Activate 1 "Pyrorixis" Spell/trap from GY
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.cptg)
	e1:SetOperation(s.cpop)
	c:RegisterEffect(e1)
	--Special Summon from hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.hsptg)
	e2:SetOperation(s.hspop)
	c:RegisterEffect(e2)
end
s.listed_series={0x7f3}
function s.cpfilter(c)
	return c:IsSetCard(0x7f3) and c:IsSpellTrap()
		and c:IsAbleToDeck()
		and c:CheckActivateEffect(false,true,false)~=nil
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
    local g=Duel.SelectMatchingCard(tp,s.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    local tc=g:GetFirst()
    if not tc then return end
    local te=tc:CheckActivateEffect(false,true,true)
    if te then
        local op=te:GetOperation()
        if op then op(e,tp,eg,ep,ev,re,r,rp) end
        Duel.BreakEffect()
        Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
    end
end
--
function s.hspfilter(c,e,tp)
	return c:IsSetCard(0x7f3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.fire(c)
	return c:IsSetCard(0x7f3) and c:IsType(TYPE_SPELL)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.hspfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.hspfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 
		and Duel.IsExistingMatchingCard(s.fire,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.BreakEffect()
		Duel.Damage(1-tp,400,REASON_EFFECT)
	end
end