--Enigmation - Phantasm Chimera
local s,id=GetID()
function s.initial_effect(c)
	-- Fusion Material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,s.matfilter1,s.matfilter2,s.matfilter3)
	--Banish on Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,{id,0})
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)	
	--Banish from GY to gain ATK & Effect (Quick Effect)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.copytg)
	e2:SetOperation(s.copyop)
	c:RegisterEffect(e2)	
	--Add to hand when banished
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,{id,2})
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
s.listed_series={0x145,0x344}
s.material_setcode={0x145,0x344}
function s.matfilter1(c,fc,sumtype,tp)
    return c:IsSetCard(0x145) or c:IsSetCard(0x344)
end
function s.matfilter2(c,fc,sumtype,tp,mg,sg)
	if not sg then return false end
	local mc=sg:GetFirst()
	return (c:IsSetCard(0x145) or c:IsSetCard(0x344)) 
		and not c:IsRace(mc:GetRace())
end
function s.matfilter3(c,fc,sumtype,tp,mg,sg)
	if not sg then return false end
	local mc=sg:GetFirst()
	return (c:IsSetCard(0x145) or c:IsSetCard(0x344)) 
		and not c:IsRace(mc:GetRace())
end
function s.fusfilter(c,mc,fc,sumtype,tp)
    return c:IsCode(mc:GetCode()) or c:IsRace(mc:GetRace())
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function s.copyfilter(c,e,tp)
	return c:IsSetCard(0x145) or c:IsSetCard(0x344) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.copyfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function s.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.copyfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
		--Gain ATK
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(tc:GetBaseAttack()/2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			end			
			--Banish 1 card if Synchro or Xyz was banished
			if tc:IsType(TYPE_SYNCHRO+TYPE_XYZ) then
				local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
				if #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
					local sg=g2:Select(tp,1,1,nil)
					Duel.HintSelection(sg)
					Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)

			end
		end
	end
end
function s.thfilter(c)
	return c:IsSetCard(SET_FUSION) and c:IsSpell() and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end