VORTEX_IMPORTED=true

if not aux.VortexProcedure then
    aux.VortexProcedure={}
    Vortex=aux.VortexProcedure
end

SUMMON_TYPE_VORTEX = SUMMON_TYPE_SPECIAL+0x60
TYPE_VORTEX        = 0x200000000
VORTEX_ACTIVITY_FLAG = 511729901
REASON_VORTEX      = 0x20000000

function Vortex.GetValue(c)
    if c:IsType(TYPE_LINK) then return c:GetLink() end
    if c:IsType(TYPE_XYZ) then return c:GetRank() end
    return c:GetLevel()
end

--Global Check for Banishment (Vortex Energy)
if not Vortex.GlobalCheck then
    Vortex.GlobalCheck=true
    local ge1=Effect.GlobalEffect()
    ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge1:SetCode(EVENT_REMOVE)
    ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
        Duel.RegisterFlagEffect(0,VORTEX_ACTIVITY_FLAG,RESET_PHASE+PHASE_END,0,1)
        Duel.RegisterFlagEffect(1,VORTEX_ACTIVITY_FLAG,RESET_PHASE+PHASE_END,0,1)
    end)
    Duel.RegisterEffect(ge1,0)
end

function Vortex.Rescon(sg,e,tp,mg,c,f1,minc,f2,minf)
    local target_val=c:GetLevel()
    --
    local current_val=sg:GetSum(Vortex.GetValue)
    local g_core=sg:Filter(f1,nil,c,tp)
    local g_fuel=sg:Filter(f2,nil,c,tp)
    
    --
    if current_val>target_val then return false end
    
    local res=g_core:GetCount()>=minc and g_fuel:GetCount()>=minf and current_val==target_val
    return res,not(current_val<target_val)
end

function Vortex.AddProcedure(c,f1,minc,f2,minf,maxf)
    --f1: Core Filter (Default: Xyz)
    --f2: Fuel Filter (Default: Non-Xyz)
    if not f1 then f1=function(tc) return tc:IsType(TYPE_XYZ) end end
    if not f2 then f2=function(tc) return not tc:IsType(TYPE_XYZ) end end
	--
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
    e0:SetRange(LOCATION_ALL)
    e0:SetCode(EFFECT_REMOVE_TYPE)
    e0:SetValue(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
    c:RegisterEffect(e0)
	--Procedure
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD) 
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(Vortex.Condition(f1,minc,f2,minf,maxf))
    e1:SetTarget(Vortex.Target(f1,minc,f2,minf,maxf))
    e1:SetOperation(Vortex.Operation)
    e1:SetValue(SUMMON_TYPE_VORTEX)
    c:RegisterEffect(e1)
	
end

function Vortex.Condition(f1,minc,f2,minf,maxf)
    return function(e,c,tp)
        if c==nil then return true end
        if Duel.GetFlagEffect(tp,VORTEX_ACTIVITY_FLAG)==0 then return false end
        
        local rg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
        return aux.SelectUnselectGroup(rg,e,tp,minc+minf,maxf,Vortex.ResconCheck(c,f1,minc,f2,minf),0)
    end
end

function Vortex.ResconCheck(sc,f1,minc,f2,minf)
    return function(sg,e,tp,mg)
        local res, stop=Vortex.Rescon(sg,e,tp,mg,sc,f1,minc,f2,minf)
        return res
    end
end

function Vortex.Target(f1,minc,f2,minf,maxf)
    return function(e,tp,eg,ep,ev,re,r,rp,chk,c,must,og,min,max)
        local rg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
        local cancelable=Duel.IsSummonCancelable() 
        local sg=aux.SelectUnselectGroup(rg,e,tp,minc+minf,maxf,Vortex.ResconCheck(c,f1,minc,f2,minf),1,tp,HINTMSG_SPSUMMON,Vortex.ResconCheck(c,f1,minc,f2,minf),nil,cancelable)        
        if sg and sg:GetCount()>0 then
            sg:KeepAlive()
            e:SetLabelObject(sg)
            return true
        end
        return false
    end
end

function Vortex.Operation(e,tp,eg,ep,ev,re,r,rp,c,must,og,min,max)
    local g=e:GetLabelObject()
    if not g then return end
    c:SetMaterial(g)   
    --Dispersion
    local g_core=g:Filter(Card.IsType,nil,TYPE_XYZ)
    local g_fuel=g:Filter(function(tc) return not tc:IsType(TYPE_XYZ) end, nil)  
    --Core Return
    Duel.SendtoDeck(g_core,nil,2,REASON_MATERIAL+REASON_VORTEX)
    --Fuel to Graveyard
    Duel.SendtoGrave(g_fuel,REASON_MATERIAL+REASON_VORTEX)  
    g:DeleteGroup()
end