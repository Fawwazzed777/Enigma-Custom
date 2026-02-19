-- Enigmation Lord - Void Sentinel
local s,id=GetID()
function s.initial_effect(c)
    --Banish opponent's monster and SS this card from GY
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCountLimit(1,{id,0})
    e1:SetCondition(s.spcon)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --If banished, grant protection to an Enigmation monster
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_REMOVE)
    e2:SetCountLimit(1,{id,1})
    e2:SetTarget(s.prottg)
    e2:SetOperation(s.protop)
    c:RegisterEffect(e2)
end
s.listed_series={0x344}
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(function(c)return c:IsControler(1-tp) and c:IsAbleToRemove()end,1,nil) 
	and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0x344),tp,LOCATION_ONFIELD,0,1,nil)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=eg:Filter(Card.IsControler,nil,1-tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
    local c=e:GetHandler()
    if chk==0 then 
        return #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
    end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=eg:Filter(Card.IsControler,nil,1-tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
    if #g>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg=g:Select(tp,1,1,nil)
        if #sg>0 then
            Duel.HintSelection(sg)
            if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 then
                if c:IsRelateToEffect(e) then
                    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
                end
            end
        end
    end
end
function s.prottg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) 
        and chkc:IsFaceup() and chkc:IsSetCard(0x344) end
    if chk==0 then return Duel.IsExistingTarget(aux.FaceupFilter(Card.IsSetCard,0x344),tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,aux.FaceupFilter(Card.IsSetCard,0x344),tp,LOCATION_MZONE,0,1,1,nil)
end
function s.protop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        --Unaffected by opponent's card effects
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetDescription(3110)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
        e1:SetValue(s.efilter)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        tc:RegisterEffect(e1)
    end
end
function s.efilter(e,re)
    return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end