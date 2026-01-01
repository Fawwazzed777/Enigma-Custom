--Enigmation Wonder Fountain
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Recycle + grant re-activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={0x344}
function s.recfilter(c)
	return c:IsSetCard(0x344) and c:IsMonster() 
	and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeck()
end
function s.monfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x344) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
	and s.effect_map[c:GetCode()]~=nil
end
--Really make you wonder...
s.effect_map={
	[96488199]=function(e,tp,tc) 
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetValue(RESET_TURN_SET)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_DISABLE_EFFECT)
		e5:SetValue(RESET_TURN_SET)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e5)
		Duel.Damage(1-tp,800,REASON_EFFECT)	
	end
end,

	[87654321]=function(e,tp,tc)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
}

--Ah shit......
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.recfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	and Duel.IsExistingMatchingCard(s.monfilter,tp,LOCATION_MZONE,0,1,nil)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	--Recycle
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local rg=Duel.SelectMatchingCard(tp,s.recfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local rc=rg:GetFirst()
	if not rc then return end
	local seq=rc:IsType(TYPE_EXTRA) and SEQ_DECKBOTTOM or SEQ_DECKBOTTOM
	if Duel.SendtoDeck(rc,nil,seq,REASON_EFFECT)==0 then return end
	--Select monster
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tg=Duel.SelectMatchingCard(tp,s.monfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=tg:GetFirst()
	if not tc then return end
	--Run its effect AS THIS CARD
	local func=s.effect_map[tc:GetCode()]
	if func then
		func(e,tp,tc)
	end
end
