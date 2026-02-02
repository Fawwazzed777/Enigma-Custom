--Enigmation Wonder Fountain
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Recycle + Apply Effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--If this card is banished
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.bntg)
	e2:SetOperation(s.bnop)
	c:RegisterEffect(e2)
end
s.listed_series={0x344}
s.listed_names={96488218,96488216,96488199}
function s.recfilter(c)
	return c:IsSetCard(0x344) and c:IsMonster() 
	and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeck()
end
function s.monfilter(c)
	return c:IsFaceup() and (c:IsCode(96488218,96488216,96488199) or c:ListsCode(96488218,96488216,96488199)) and c:IsType(TYPE_EXTRA)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.recfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	and Duel.IsExistingTarget(s.monfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g1=Duel.SelectTarget(tp,s.recfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g2=Duel.SelectTarget(tp,s.monfilter,tp,LOCATION_MZONE,0,1,1,nil)
    e:SetLabelObject(g2:GetFirst())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetTargetCards(e)
    if #g<2 then return end
    local tc1=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED):GetFirst()
    local tc2=e:GetLabelObject()  
    if not tc1 or not tc2 or not tc2:IsRelateToEffect(e) then return end
    if Duel.SendtoDeck(tc1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and tc1:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
        local effs={tc2:GetMarkedEffects(344)}
        if #effs>0 then
            local te=effs[1]
            local tg=te:GetTarget()
            local op=te:GetOperation()
            e:SetProperty(te:GetProperty())
            if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then
                if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
                if op then op(e,tp,eg,ep,ev,re,r,rp) end
            end
        else
        end
    end
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_EXTRA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.bntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.bnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	if not sc then return end
	if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	sc:CompleteProcedure()
	if sc:IsType(TYPE_XYZ) then
		local mg=Group.FromCards(c)
		if Duel.IsExistingMatchingCard(Card.IsMonster,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tc=Duel.SelectMatchingCard(tp,Card.IsMonster,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,c):GetFirst()
		if tc then
			mg:AddCard(tc)
		end
	end
		Duel.Overlay(sc,mg)
	end
end