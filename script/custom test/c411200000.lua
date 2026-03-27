--Enigmation Domain
local s,id=GetID()
function s.initial_effect(c)
    --Activate: Attach up to 3 cards from GY/Banish
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_LEAVE_GRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    --ATK Boost: 100 for each card underneath
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x344))
    e2:SetValue(s.atkval)
    c:RegisterEffect(e2)
	--Attach 1 additional card
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(s.target)
    e3:SetOperation(s.attachop)
    c:RegisterEffect(e3)
    --Leave Field: Return Attached card to hand
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetOperation(s.regop)
    c:RegisterEffect(e4)
end
s.listed_series={0x344}
function s.atkval(e,c)
    return e:GetHandler():GetOverlayCount()*200
end

function s.filter(c)
    return c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil)
    if #g>0 then
        Duel.Overlay(c,g)
    end
end

function s.attachop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    if #g>0 then
        Duel.Overlay(c,g)
    end
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetOverlayGroup()
    if #g==0 then return end
    g:KeepAlive()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetLabelObject(g)
    e1:SetOperation(s.tohandop)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end

function s.tohandop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    if not g then return end
    local tg=g:Filter(function(tc) return tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_OVERLAY) end, nil) 
    if #tg>0 then
        Duel.Hint(HINT_CARD,0,id)
        Duel.SendtoHand(tg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tg)
    end
    g:DeleteGroup()
end