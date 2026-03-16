VORTEX_IMPORTED=true

if not Vortex then Vortex={} end
if not aux.VortexProcedure then aux.VortexProcedure=Vortex end

if not Vortex.GlobalCheck then
    Vortex.GlobalCheck=true
    local ge1=Effect.GlobalEffect()
    ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge1:SetCode(EVENT_REMOVE)
    ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
        for tc in aux.Next(eg) do
            Duel.RegisterFlagEffect(0,VORTEX_ACTIVITY_FLAG,RESET_PHASE+PHASE_END,0,1)
            Duel.RegisterFlagEffect(1,VORTEX_ACTIVITY_FLAG,RESET_PHASE+PHASE_END,0,1)
        end
    end)
    Duel.RegisterEffect(ge1,0)
end

SUMMON_TYPE_VORTEX = SUMMON_TYPE_SPECIAL|0x609
TYPE_VORTEX        = 0x210000000
VORTEX_ACTIVITY_FLAG = 511729901
REASON_VORTEX      = 0x200000000

function Vortex.GetValue(c)
    local tpe=c:GetType()
    if (tpe&TYPE_XYZ)~=0 then return c:GetRank() end
    if (tpe&TYPE_LINK)~=0 then return c:GetlLink() end
    return math.max(c:GetLevel(),1)
end

function Vortex.AddProcedure(c,f1,minc,f2,minf,max,extra_con)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(Vortex.Condition(f1,minc,f2,minf,max,extra_con))
    e1:SetTarget(Vortex.Target(f1,minc,f2,minf,max))
    e1:SetOperation(Vortex.Operation(f1))
    e1:SetValue(SUMMON_TYPE_VORTEX)
    c:RegisterEffect(e1)	
    Vortex.AddCommonEffects(c)
end

function Vortex.Rescon(f1, minc, f2, minf)
    return function(sg, e, tp, mg, sc)
        local g_core = sg:Filter(f1, nil, sc, tp)
        local g_fuel = sg:Filter(f2, nil, sc, tp)

        if #sg~=(#g_core + #g_fuel) then return false end      
        local total_val=0
        for tc in aux.Next(sg) do
            total_val=total_val+Vortex.GetValue(tc)
        end
        local req_val=Vortex.GetValue(sc)

        if total_val==req_val then
            return #g_core>=minc and #g_fuel>=minf
        end
        if total_val<req_val then
            return true
        end
        return false
    end
end

function Vortex.Condition(f1,minc,f2,minf,max,extra_con)
    return function(e,c)
        if c==nil then return true end
        local tp=c:GetControler()     
        --Flag Check
        if Duel.GetFlagEffect(tp,VORTEX_ACTIVITY_FLAG)==0 then return false end        
        --Extra Condition Check (Nadleef 5 Banish, etc)
        if extra_con and not extra_con(e,c) then return false end        
        local rg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
        local rescon_func=Vortex.Rescon(f1,minc,f2,minf)
        return aux.SelectUnselectGroup(rg,e,tp,1,max,rescon_func,0,c)
    end
end

function Vortex.Target(f1,minc,f2,minf,max)
    return function(e,tp,eg,ep,ev,re,r,rp,chk,c)
        local rescon_func=Vortex.Rescon(f1,minc,f2,minf)
        local rg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
        local cancelable=Duel.IsSummonCancelable()      
        local sg=aux.SelectUnselectGroup(rg,e,tp,1,max,rescon_func,1,tp,HINTMSG_SPSUMMON,rescon_func,nil,cancelable)
        if sg and #sg>0 then
            sg:KeepAlive()
            c:SetMaterial(sg)
            return true
        end
        return false
    end
end

function Vortex.Operation(f1)
    return function(e,tp,eg,ep,ev,re,r,rp,c)
        local g=c:GetMaterial()
        if not g or #g==0 then return end
        local g_core=g:Filter(f1,nil,c,tp)
        local g_fuel=g:Filter(function(tc) return not f1(tc,c,tp) end,nil)       
        Duel.SendtoDeck(g_core,nil,2,REASON_MATERIAL+REASON_VORTEX)
        Duel.SendtoGrave(g_fuel,REASON_MATERIAL+REASON_VORTEX)
        g:DeleteGroup()
    end
end

function Vortex.AddCommonEffects(c)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
    e0:SetRange(LOCATION_ALL)
    e0:SetCode(EFFECT_REMOVE_TYPE)
    e0:SetValue(TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ)
    c:RegisterEffect(e0)   
end