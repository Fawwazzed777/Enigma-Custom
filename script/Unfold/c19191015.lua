--Shadow Beast Calling
local s,id=GetID()
function s.initial_effect(c)
    --Search or Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)  
    --GY Recycle 
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(aux.exccon)
	e2:SetCountLimit(1,id)
    e2:SetCost(aux.bfgcost)
    e2:SetOperation(s.gyop)
    c:RegisterEffect(e2)
end
s.listed_series={0xbc9,0xabc9}
function s.filter(c,e,tp,ft)
    return c:IsSetCard(0xbc9) and c:IsMonster() and (c:IsAbleToHand() 
        or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function s.dfilter(c,e,tp,ft)
    return c:IsSetCard(0xbc9) and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp,ft) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft)
    if #g>0 then
        local tc=g:GetFirst()
        --If you control a "Shadow Beast Tamer" Monster, Special Summon it instead
        if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) 
            and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0xabc9),tp,LOCATION_MZONE,0,1,nil)
            and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        else
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        end
    end
end

function s.gyop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,s.dfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end