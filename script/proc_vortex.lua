VORTEX_IMPORTED=true

if not aux.VortexProcedure then
    aux.VortexProcedure= {}
    Vortex= aux.VortexProcedure
end

SUMMON_TYPE_VORTEX = SUMMON_TYPE_SPECIAL+0x60
TYPE_VORTEX      = 0x200000000
VORTEX_ACTIVITY_FLAG = 511729901

function Vortex.GetValue(c)
    if c:IsType(TYPE_LINK) then return c:GetLink() end
    if c:IsType(TYPE_XYZ) then return c:GetRank() end
    return c:GetLevel()
end

--Core(Rank/Xyz)
function Vortex.CoreFilter(c,f1,vortex_card,tp)
    if not c:IsType(TYPE_XYZ) or not c:IsFaceup() then return false end
    if not f1 then return true end
    if type(f1)=="function" then return f1(c,vortex_card,tp) end
    return c:GetRank()==f1
end

--Fuel
function Vortex.FuelFilter(c,f2,vortex_card,tp)
    if c:IsType(TYPE_XYZ) or not c:IsFaceup() then return false end
    if not f2 then return true end
    return f2(c,vortex_card,tp)
end

function Vortex.Rescon(sg,e,tp,mg,total_val,f1,minc,f2,minf,maxf)
    local cores=sg:Filter(Vortex.CoreFilter,nil,f1,e:GetHandler(),tp)
    local fuels=sg:Filter(Vortex.FuelFilter,nil,f2,e:GetHandler(),tp)
    if #cores<minc or #fuels<minf or #sg>(minc+maxf) then return false end
    --Rank + Level equal target Summon
    if sg:GetSum(Vortex.GetValue)~=total_val then return false end
    --Core/Fuel
    return sg:FilterCount(function(c) return cores:IsContains(c) or fuels:IsContains(c) end,nil)==#sg
end

function Vortex.AddProcedure(c,f1,minc,f2,minf,maxf)
    if not minc then minc=1 end
    if not minf then minf=1 end
    if not maxf then maxf=99 end
    --Type Stripping Hacks (EDOPro standard for custom ED cards)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
    e1:SetRange(LOCATION_ALL)
    e1:SetCode(EFFECT_REMOVE_TYPE)
    e1:SetValue(TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK)
    c:RegisterEffect(e1)       
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
    e2:SetCode(EFFECT_ADD_TYPE)
    e2:SetValue(TYPE_VORTEX)
    c:RegisterEffect(e2)
    --Summon Procedure
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_SPSUMMON_PROC)
    e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetRange(LOCATION_EXTRA)
    e3:SetLabel(c:GetLevel())
    e3:SetCondition(Vortex.Condition(f1,minc,f2,minf,maxf))
    e3:SetTarget(Vortex.Target(f1,minc,f2,minf,maxf))
    e3:SetOperation(Vortex.Operation(f1))
    e3:SetValue(SUMMON_TYPE_VORTEX)
    c:RegisterEffect(e3)
end

function Vortex.Condition(f1,minc,f2,minf,maxf)
    return function(e,c,tp)
        if c==nil then return true end
        if Duel.GetFlagEffect(tp,VORTEX_ACTIVITY_FLAG)==0 then return false end
        local rg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
        return aux.SelectUnselectGroup(rg,e,tp,minc+minf,99,function(sg,e,tp,mg)
            return Vortex.Rescon(sg,e,tp,mg,e:GetLabel(),f1,minc,f2,minf,maxf)
        end,0)
    end
end

function Vortex.Target(f1,minc,f2,minf,maxf)
    return function(e,tp,eg,ep,ev,re,r,rp,chk,c)
        local cancelable=Duel.IsSummonCancelable()
        local rg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
        local sg=aux.SelectUnselectGroup(rg,e,tp,minc+minf,99,function(sg,e,tp,mg)
            return Vortex.Rescon(sg,e,tp,mg,e:GetLabel(),f1,minc,f2,minf,maxf)
        end,1,tp,HINTMSG_SPSUMMON,nil,nil,cancelable)
        if sg and #sg>0 then
            sg:KeepAlive()
            e:SetLabelObject(sg)
            return true
        end
        return false
    end
end

function Vortex.Operation(f1)
    return function(e,tp,eg,ep,ev,re,r,rp,c)
        local g=e:GetLabelObject()
        if not g then return end
        c:SetMaterial(g)
        local cores=g:Filter(Vortex.CoreFilter,nil,f1,c,tp)
        local fuels=g:Clone()
        fuels:Sub(cores)       
        --Dispersion Rule
        Duel.SendtoDeck(cores,nil,SEQ_DECKSHUFFLE,REASON_MATERIAL+REASON_VORTEX)
        Duel.SendtoGrave(fuels,REASON_MATERIAL+REASON_VORTEX)       
        g:DeleteGroup()
    end
end