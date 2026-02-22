VORTEX_IMPORTED = true

if not aux.VortexProcedure then
    aux.VortexProcedure = {}
    Vortex = aux.VortexProcedure
end

VORTEX_GLOBAL_FLAG = 111166660 

function Vortex.GetValue(c)
    if c:IsType(TYPE_LINK) then return c:GetLink() end
    if c:IsType(TYPE_XYZ) then return c:GetRank() end
    return c:GetLevel()
end

function Vortex.MatFilter(c,filter,tp)
    return c:IsFaceup() and c:IsAbleToDeck() and (not filter or filter(c,tp))
end

function Vortex.Rescon(sg,e,tp,mg,total_val,recipe)
    local sum=sg:GetSum(Vortex.GetValue)
    if sum~=total_val then return false end
    if Duel.GetLocationCountFromEx(tp,tp,sg,e:GetHandler())<=0 then return false end
    if not recipe then return true end
    return recipe(sg,e,tp,mg)
end

function Vortex.AddProcedure(c,total_val,recipe)
    --Main Summon Procedure
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetLabel(total_val)   
    if recipe then
        e1:SetLabelObject(recipe)
    end    
    e1:SetCondition(Vortex.Condition)
    e1:SetTarget(Vortex.Target)
    e1:SetOperation(Vortex.Operation)
    e1:SetValue(SUMMON_TYPE_VORTEX)
    c:RegisterEffect(e1)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_REMOVE_TYPE)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetRange(LOCATION_ALL)
    e0:SetValue(TYPE_FUSION)
    c:RegisterEffect(e0)
end

function Vortex.Condition(e,c,tp,sg)
    if c==nil then return true end
    local tp=c:GetControler()
    if Duel.GetFlagEffect(tp,VORTEX_GLOBAL_FLAG)==0 then return false end   
    local total_val=e:GetLabel()
    local recipe=e:GetLabelObject()
    local rg=Duel.GetMatchingGroup(Vortex.MatFilter,tp,LOCATION_MZONE,0,nil)   
    return aux.SelectUnselectGroup(rg,e,tp,2,99,function(sg,e,tp,mg) return Vortex.Rescon(sg,e,tp,mg,total_val,recipe) end,0)
end

function Vortex.Target(e,tp,eg,ep,ev,re,r,rp,chk,c)
    local total_val=e:GetLabel()
    local recipe=e:GetLabelObject()
    local rg=Duel.GetMatchingGroup(Vortex.MatFilter,tp,LOCATION_MZONE,0,nil)
    local sg=aux.SelectUnselectGroup(rg,e,tp,2,99,function(sg,e,tp,mg) return Vortex.Rescon(sg,e,tp,mg,total_val,recipe) end,1,tp,HINTMSG_SPSUMMON,nil,nil,true)
    if sg then
        sg:KeepAlive()
        e:SetLabelObject(sg)
        return true
    end
    return false
end

function Vortex.Operation(e,tp,eg,ep,ev,re,r,rp,c,sg)
    local g=e:GetLabelObject()
    if not g then return end
    Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_MATERIAL+REASON_VORTEX)
    g:DeleteGroup()
end