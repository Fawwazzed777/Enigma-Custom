VORTEX_IMPORTED = true

if not SUMMON_TYPE_VORTEX then 
    SUMMON_TYPE_VORTEX=SUMMON_TYPE_SPECIAL|0x609
end
if not REASON_VORTEX then
    REASON_VORTEX  = 0x200000000
end
if not Vortex then Vortex = {} end
if not aux.VortexProcedure then aux.VortexProcedure = Vortex end
SUMMON_TYPE_VORTEX   = SUMMON_TYPE_SPECIAL|0x609
TYPE_VORTEX          = 0x210000000
VORTEX_ACTIVITY_FLAG = 109090901
REASON_VORTEX        = 0x200000000
if not SUMMON_TYPE_VORTEX then 
    SUMMON_TYPE_VORTEX = SUMMON_TYPE_SPECIAL|0x609
end
if not REASON_VORTEX then
    REASON_VORTEX = 0x400000000
end
function Vortex.GetValue(c)
    if c:IsType(TYPE_LINK) then return c:GetLink() end
    if c:IsType(TYPE_XYZ) then return c:GetRank() end
    return c:GetLevel()
end

--Global Check for Vortex Energy
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

function Vortex.AddProcedure(c,f1,f2)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
    e0:SetRange(LOCATION_ALL)
    e0:SetCode(EFFECT_REMOVE_TYPE)
    e0:SetValue(TYPE_FUSION|TYPE_XYZ)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetLabelObject({f1,f2})
    e1:SetCondition(Vortex.Condition)
    e1:SetTarget(Vortex.Target)
    e1:SetOperation(Vortex.Operation)
    e1:SetValue(SUMMON_TYPE_VORTEX)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_ADD_TYPE)
    e2:SetValue(TYPE_VORTEX)
    c:RegisterEffect(e2)
end
function Vortex.ResconFilter(sg,e,tp,mg)
    local info=e:GetLabelObject()
    local f1,f2=info[1],info[2]
    local sc=e:GetHandler()
    
    local g_core=sg:Filter(f1,nil,sc,tp)
    local g_fuel=sg:Filter(f2,nil,sc,tp)
    
    if #g_core<1 or #g_fuel<1 then return false end
    if #sg~=(#g_core+#g_fuel) then return false end
    
    return sg:GetSum(Vortex.GetValue)==sc:GetLevel()
end

function Vortex.GetFilters(e)
    local info=e:GetLabelObject()
    if type(info) == "table" then return info[1], info[2] end
    return nil, nil
end

function Vortex.Condition(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    if Duel.GetFlagEffect(tp,VORTEX_ACTIVITY_FLAG)==0 then return false end
    
    local rg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    return aux.SelectUnselectGroup(rg,e,tp,2,99,Vortex.ResconFilter,0,c)
end

function Vortex.Target(e,tp,eg,ep,ev,re,r,rp,chk,c)
    local rg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    local cancelable=Duel.IsSummonCancelable()
    local sg=aux.SelectUnselectGroup(rg,e,tp,2,99,Vortex.ResconFilter,1,tp,HINTMSG_REMOVE,Vortex.ResconFilter,nil,cancelable)
    if sg and #sg>0 then
        sg:KeepAlive()
        local info = e:GetLabelObject()
        e:SetLabelObject({info,sg})
        return true
    end
    return false
end

function Vortex.Operation(e,tp,eg,ep,ev,re,r,rp,c)
    local data=e:GetLabelObject()
    if not data or type(data)~= "table" then return end 
    local info = data[1] --{f1, f2}
    local sg   = data[2] --Group material
    local f1=info[1]
    local f2=info[2]
    c:SetMaterial(sg) 
    --Filter core and fuel
    local g_core=sg:Filter(f1,nil,c,tp)
    local g_fuel=sg:Filter(function(tc) return not f1(tc,c,tp) end,nil)   
    Duel.SendtoDeck(g_core,nil,2,REASON_MATERIAL+REASON_VORTEX)
    Duel.SendtoGrave(g_fuel,REASON_MATERIAL+REASON_VORTEX)    
    sg:DeleteGroup()
end