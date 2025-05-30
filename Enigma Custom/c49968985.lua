--Ann, Connector of Ultimaya
local s,id=GetID()
function s.initial_effect(c)
	--Pendulum summon feature
	Pendulum.AddProcedure(c)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.actcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.con)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
	--synchrolimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(s.synchrolimit)
	c:RegisterEffect(e3)

end
s.listed_series={0x309}
function s.synchrolimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x309)
end

function s.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
	and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0x309),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
	or Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,1686814),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler()) 
end
--
function s.ccfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE) 
		and c:IsPreviousControler(tp) and c:IsSetCard(0x309)
		and c:IsReason(REASON_DESTROY) and ((c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp) or c:IsReason(REASON_BATTLE))
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.ccfilter,1,nil,tp)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function s.scfilter(c,tp)
	return s.ccfilter(c,tp) and (c:IsSetCard(0x309) or c:IsCode(1686814))
		and c:IsControler(tp) 
end
function s.synfilter(c,mg,lv)
	return c:GetLevel(lv) and c:IsSynchroSummonable(nil,mg) and c:IsSetCard(0x309)
end

function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=eg:Filter(s.scfilter,nil,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
			local tc=g:Select(tp,1,1,nil,e,tp):GetFirst()
			local mg=Group.FromCards(c,tc)
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0	and not tc:IsType(TYPE_TUNER) and tc:IsCanBeSynchroMaterial()
			and Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			--Synchro
			local sg=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_EXTRA,0,nil,mg)
			if #sg>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local syng=sg:Select(tp,1,1,nil)
				Duel.SynchroSummon(tp,syng:GetFirst(),nil,mg)
end
end
end
end
end
