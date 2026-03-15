--Enigmation Lord - Void Crisis Nadleef
--scripted by fawwazzed
if not ENIGMA_PATCH then Duel.LoadScript("enigma_utility.lua") end
if not VORTEX_IMPORTED then Duel.LoadScript("proc_vortex.lua") end
local s,id=GetID()
s.Vortex=true
function s.initial_effect(c)
    c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	--Standard Vortex (1 Core Rank 4 + 1+ Fuel)
    --Parameter:(c,Core_Filter,Min_Core,Fuel_Filter,Min_Fuel)
    Vortex.AddProcedure(c,8,function(tc)return tc:GetRank()==4 end,s.nadleef_fuel)
	--Level/Rank Cover
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_RANK_LEVEL_S)
	c:RegisterEffect(e0)
    --Anti-Climbing Lock
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(1,1)
    e1:SetTarget(s.splimit)
    c:RegisterEffect(e1)
	--Banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--Immune to removal
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(s.imfilter)
	c:RegisterEffect(e3)
    --Global Check
    if not s.global_check then
        s.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_REMOVE)
        ge1:SetOperation(s.checkop)
        Duel.RegisterEffect(ge1,0)
    end
end
s.listed_series={0x145,0x344}

function s.nadleef_fuel(tc,vortex_card,tp)
    --Check Banishment is more than 5
    local g=Duel.GetMatchingGroup(function(bc) 
        return (bc:IsSetCard(0x145) or bc:IsSetCard(0x344)) and bc:IsFaceup() 
    end,tp,LOCATION_REMOVED,0,nil)
    return #g>=5 and tc:GetLevel()>0 and tc:IsLevelBelow(4)
end

--Lock (Anti-Climbing)
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    if not (c:IsLocation(LOCATION_EXTRA) or c:IsType(TYPE_EXTRA)) then return false end    
    local tpe=c:GetType()
    local filter_tpe= tpe&(TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK)
    if filter_tpe==0 then return false end 
    return Duel.IsExistingMatchingCard(s.material_filter,sump,LOCATION_MZONE,0,1,nil,filter_tpe)
end

function s.material_filter(c,filter_tpe)
    return c:IsType(TYPE_EXTRA) and c:IsType(filter_tpe)
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
    Duel.RegisterFlagEffect(1,id,RESET_PHASE+PHASE_END,0,1)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())  
    if #g>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local tg=g:Select(tp,1,2,nil)        
        if #tg>0 then
            Duel.HintSelection(tg)
            local ct=Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)        
            if ct>0 then
                local total_stats=0
                local og=Duel.GetOperatedGroup()
                for tc in aux.Next(og) do
                    if tc:IsOriginalType(TYPE_MONSTER) then
                        local atk= tc:GetTextAttack()
                        local def= tc:GetTextDefense()
                        if atk<0 then atk=0 end
                        if def<0 then def=0 end
                        local s_max= math.max(atk,def)
                        total_stats= total_stats+s_max
                    end
                end                
                if total_stats>0 then
                    Duel.BreakEffect()
                    Duel.Recover(tp,total_stats,REASON_EFFECT)
                end
            end
        end
    end
end

function s.leaveChk(c,category)
	local ex,tg=Duel.GetOperationInfo(0,category)
	return ex and tg~=nil and tg:IsContains(c)
end
function s.imfilter(e,te,c)
	local c=e:GetOwner()
	local tc=te:GetOwner()
	return (te:IsTrapEffect() and te:IsActivated())
		or (((te:IsSpellEffect())
		or (te:IsMonsterEffect() and tc~=c))
		and ((c:GetDestination()>0 and c:GetReasonEffect()==te)
		or (s.leaveChk(c,CATEGORY_TOHAND) or s.leaveChk(c,CATEGORY_DESTROY) or s.leaveChk(c,CATEGORY_REMOVE)
		or s.leaveChk(c,CATEGORY_TODECK) or s.leaveChk(c,CATEGORY_RELEASE) or s.leaveChk(c,CATEGORY_TOGRAVE))))
end