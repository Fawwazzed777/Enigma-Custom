--Shadow Beast Tamer - Ouro
local s,id=GetID()
function s.initial_effect(c)
	--Quick Fusion/Xyz during Opponent's Turn
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E+TIMING_MAIN_END)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.quickcon)
    e1:SetTarget(s.quicktg)
    e1:SetOperation(s.quickop)
    c:RegisterEffect(e1)
	--Special Summon from GY/Banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
s.listed_series={0xbc9,0xabc9}
function s.quickcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp 
        and Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,e:GetHandler())
end

function s.tgfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:HasLevel()
end

function s.exfilter(c,e,tp,mg)
    return c:IsAttribute(ATTRIBUTE_EARTH) and (c:IsFusionSummonableCard(mg) or c:IsXyzSummonable(nil,mg))
end

function s.quicktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tgfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.quickop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
    local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_EARTH),tp,LOCATION_MZONE,0,nil)
    local lv=tc:GetLevel()  
    for sc in aux.Next(g) do
        --Ouro Mask
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_CODE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetValue(id)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        sc:RegisterEffect(e1)
        --Level Copy
        local e2=e1:Clone()
        e2:SetCode(EFFECT_CHANGE_LEVEL)
        e2:SetValue(lv)
        sc:RegisterEffect(e2)
    end
    Duel.AdjustInstantly()
    Duel.BreakEffect()
    local mg=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_EARTH),tp,LOCATION_MZONE,0,nil)
    local exg=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_EXTRA,0,nil,ATTRIBUTE_EARTH)
    local final_exg=exg:Filter(function(ec)
        if ec:IsType(TYPE_FUSION) then
            return ec:CheckFusionMaterial(mg,nil,tp)
        elseif ec:IsType(TYPE_XYZ) then
            return ec:IsXyzSummonable(nil,mg)
        end
        return false
    end,nil)  
    if #final_exg>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sumc=final_exg:Select(tp,1,1,nil):GetFirst()      
        if sumc:IsType(TYPE_FUSION) then
            local fmat=Duel.SelectFusionMaterial(tp,sumc,mg,nil,tp)
            sumc:SetMaterial(fmat)
            Duel.SendtoGrave(fmat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            Duel.SpecialSummon(sumc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
            sumc:CompleteProcedure()
        else
            Duel.XyzSummon(tp,sumc,nil,mg)
        end
    end
end

function s.spfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and (c:IsType(TYPE_FUSION) or c:IsType(TYPE_XYZ)) and c:IsSetCard(0xbc9)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spfilter,1,nil,tp)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end