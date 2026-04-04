--Shadow Beast Mirror
local s,id=GetID()
function s.initial_effect(c)
    -- Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)   
    --SP
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,id)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
    --Protection
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_ONFIELD,0)
    e3:SetTarget(s.prottg)
    e3:SetValue(s.valcon)
	e3:SetCountLimit(1)
    c:RegisterEffect(e3)
end
s_listed_series={0xbc9}
function s.revfilter(c,e,tp)
    local code=c:GetCode()
    return c:IsSetCard(0xbc9) and c:IsMonster() and not c:IsPublic() and not c:IsForbidden()
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,code,e,tp)
end
function s.spfilter(c,code,e,tp)
    return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and Duel.IsExistingMatchingCard(s.revfilter,tp,LOCATION_HAND,0,1,nil,e,tp) 
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end   
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,s.revfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.ConfirmCards(1-tp,g)
        local code=g:GetFirst():GetCode()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local spg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,code,e,tp)
        if #spg>0 and Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)>0 then
            Duel.ShuffleHand(tp)
            Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        end
    end
end
function s.prottg(e,c)
    return c:IsSetCard(0xbc9) and c~=e:GetHandler()
end
function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE|REASON_EFFECT)~=0
end