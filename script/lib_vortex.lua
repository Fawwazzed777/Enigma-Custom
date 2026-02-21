--Vortex Procedure Library
if not Vortex then
    Vortex = {}
end

--ID Reference for Global Flag
VORTEX_GLOBAL_FLAG = 111166660

--Helper(Level, Rank, or Link)
function Vortex.GetValue(c)
    if c:IsType(TYPE_LINK) then return c:GetLink() end
    if c:IsType(TYPE_XYZ) then return c:GetRank() end
    return c:GetLevel()
end

--Procedure
function Vortex.AddProcedure(c, total_val, recipe)
    --total_val: Total Level/Rank/Link needed (example: 12)
    --recipe: Function for the material (ex: 1 Rank 4 + 1 Lvl 4)   
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(Vortex.Condition(total_val, recipe))
    e1:SetTarget(Vortex.Target(total_val, recipe))
    e1:SetOperation(Vortex.Operation)
    e1:SetValue(99) -- Custom Summon Type ID
    c:RegisterEffect(e1)
end

function Vortex.MatFilter(c)
    return c:IsFaceup() and c:IsAbleToDeck()
end

function Vortex.Rescon(total_val, recipe)
    return function(sg,e,tp,mg)
        if sg:GetSum(Vortex.GetValue) ~= total_val then return false end
        return not recipe or recipe(sg,e,tp,mg)
    end
end

function Vortex.Condition(total_val, recipe)
    return function(e,c,tp,sg)
        if c==nil then return true end
        local tp=c:GetControler()       
        if Duel.GetLocationCountFromEx(tp,tp,nil,c)<=0 then return false end               
        -- GLOBAL CHECK
        if Duel.GetFlagEffect(tp,111166660)== 0 then return false end                
        local rg=Duel.GetMatchingGroup(Vortex.MatFilter,tp,LOCATION_MZONE,0,nil)
        return aux.SelectUnselectGroup(rg,e,tp,2,99,Vortex.Rescon(total_val, recipe),0)
    end
end

function Vortex.Target(total_val, recipe)
    return function(e,tp,eg,ep,ev,re,r,rp,chk,c)
        local rg=Duel.GetMatchingGroup(Vortex.MatFilter,tp,LOCATION_MZONE,0,nil)
        local sg=aux.SelectUnselectGroup(rg,e,tp,2,99,Vortex.Rescon(total_val, recipe),1,tp,aux.Stringid(c:GetID(),0))
        if sg then
            sg:KeepAlive()
            e:SetLabelObject(sg)
            return true
        end
        return false
    end
end

function Vortex.Operation(e,tp,eg,ep,ev,re,r,rp,c,sg)
    local g=e:GetLabelObject()
    if not g then return end
    Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_MATERIAL+REASON_COST)
    g:DeleteGroup()
end