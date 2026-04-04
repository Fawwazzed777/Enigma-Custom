--Outer Shadow Beast - Zafier
local s,id=GetID()
function s.initial_effect(c)
	--Xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_EARTH),4,2)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s_listed_series={0xbc9}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1
            and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.spfilter(c,e,tp)
    return c:IsSetCard(0xbc9) and c:IsMonster() 
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.stfilter(c)
    return c:IsSetCard(0xbc9) and c:IsSpellTrap()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local deck_ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    if deck_ct==0 then return end  
    local max_num=math.min(deck_ct,4)
    local t={}
    for i=1,max_num do t[i]=i end
    Duel.Hint(HINT_SELECTMSG,tp,HINT_NUMBER)
    local ac=Duel.AnnounceNumber(tp,table.unpack(t))   
    --Excavate (Confirm)
    Duel.ConfirmDecktop(tp,ac)
    local g=Duel.GetDecktopGroup(tp,ac)
    if #g==0 then return end   
    --Send "Shadow Beast" Spell/Trap to GY
    local stg=g:Filter(s.stfilter,nil)
    local ct=0
    if #stg>0 then
        ct=Duel.SendtoGrave(stg,REASON_EFFECT+REASON_REVEAL)
    end
    Duel.ShuffleDeck(tp)
    if ct>0 then
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
        local spg_pool=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)       
        if ft>0 and #spg_pool>0 then
            Duel.BreakEffect()
            local count=math.min(ft,ct)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local spg=spg_pool:Select(tp,1,count,nil)
            if #spg>0 then
                Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
            end
        end
    end
end