if not Vortex then 
	Vortex = {} 
end

if not SUMMON_TYPE_VORTEX then 
    SUMMON_TYPE_VORTEX=SUMMON_TYPE_SPECIAL|0x609
end
if not REASON_VORTEX then
    REASON_VORTEX  = 0x220000000
end
function Card.IsVortex(c)
    return c:IsType(TYPE_VORTEX)
end
if not aux.VortexProcedure then 
	aux.VortexProcedure = Vortex 
end

SUMMON_TYPE_VORTEX   = SUMMON_TYPE_SPECIAL|0x609
TYPE_VORTEX          = 0x210000000
VORTEX_ACTIVITY_FLAG = 109090901
REASON_VORTEX        = 0x220000000

if not SUMMON_TYPE_VORTEX then 
    SUMMON_TYPE_VORTEX = SUMMON_TYPE_SPECIAL|0x609
end
if not REASON_VORTEX then
    REASON_VORTEX = 0x400000000
end
function Vortex.GetValue(c)
    if c:IsType(TYPE_LINK) then return c:GetLink() end
    if c:IsType(TYPE_XYZ) or c:IsHasEffect(EFFECT_ADD_TYPE) then 
        local rk=c:GetRank()
        if rk>0 then return rk end
    end
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

function Vortex.AddProcedure(c,f1,f2,min_core,extra_con)
	if type(min_core)=="function" then
        extra_con=min_core
        min_core= 1
    end
    min_core=min_core or 1
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
	e1:SetLabel(min_core)
    e1:SetLabelObject({f1,f2,extra_con})
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
function Vortex.ResconFilter(g,e,tp,mg,c)
    local info=e:GetLabelObject()
    local f1=info[1]
    local f2=info[2]
    local min_core=e:GetLabel()
    local sc=e:GetHandler()              
    local core_filter=function(tc) return Vortex.CheckFilter(tc,f1,sc,tp,true) end
    local fuel_filter=function(tc) return Vortex.CheckFilter(tc,f2,sc,tp,false) end    
    local core_count=g:FilterCount(core_filter,nil)
    local fuel_count=g:FilterCount(fuel_filter,nil)

    if #g~=(core_count+fuel_count) then return false end
    local total_value=0
    for tc in aux.Next(g) do
        total_value=total_value+Vortex.GetValue(tc)
    end
    return core_count>=min_core and total_value==sc:GetLevel()
end

function Vortex.CheckFilter(tc,f,sc,tp,is_core)
    if not f then return true end   
    if type(f)=="number" then
        if is_core then
            if tc:IsType(TYPE_XYZ) and Vortex.GetValue(tc)==f then return true end            
            local eff=tc:IsHasEffect(EFFECT_ADD_TYPE)
            if eff then
                local e_list=type(eff)== "table" and eff or {eff}
                for _,e in ipairs(e_list) do
                    local val=e:GetValue()
                    if type(val)=="function" then val = val(e, tc) end
                    if (val & TYPE_XYZ)~=0 then
                        if Vortex.GetValue(tc)==f then return true end
                    end
                end
            end
            return false
        else
            return Vortex.GetValue(tc)==f
        end
    end
end
function Vortex.Condition(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local info=e:GetLabelObject()
    if not info then return false end
    local extra_con=info[3]
    
    if Duel.GetFlagEffect(tp,VORTEX_ACTIVITY_FLAG)==0 then return false end
    if extra_con and not extra_con(e,c) then return false end
    
    local rg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    return aux.SelectUnselectGroup(rg,e,tp,1,99,Vortex.ResconFilter,0,c)
end

function Vortex.Target(e,tp,eg,ep,ev,re,r,rp,chk,c)
    local rg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    local cancelable=Duel.IsSummonCancelable()
    local sg=aux.SelectUnselectGroup(rg,e,tp,1,99,Vortex.ResconFilter,1,tp,HINTMSG_REMOVE,Vortex.ResconFilter,nil,cancelable)
    if sg and #sg>0 then
        sg:KeepAlive()
        local info=e:GetLabelObject()
        e:SetLabelObject({info,sg})
        return true
    end
    return false
end

function Vortex.Operation(e,tp,eg,ep,ev,re,r,rp,c)
    local data=e:GetLabelObject()
    local info=data[1]
    local sg=data[2]
    local f1=info[1]
    
    c:SetMaterial(sg) 
    local g_core=sg:Filter(function(tc) return Vortex.CheckFilter(tc,f1,c,tp,true) end,nil)
    local g_fuel=sg:Filter(function(tc) return not g_core:IsContains(tc) end,nil)      
    Duel.SendtoDeck(g_core,nil,2,REASON_MATERIAL+REASON_VORTEX)
    Duel.SendtoGrave(g_fuel,REASON_MATERIAL+REASON_VORTEX)   
    e:SetLabelObject(info) 
    sg:DeleteGroup()
end

VORTEX_IMPORTED = true