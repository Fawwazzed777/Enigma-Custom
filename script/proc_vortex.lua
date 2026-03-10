VORTEX_IMPORTED = true

if not aux.VortexProcedure then
    aux.VortexProcedure = {}
    Vortex = aux.VortexProcedure
end

if not Vortex then
    Vortex = aux.VortexProcedure
end

VORTEX_GLOBAL_FLAG=111166660 --Enigmation Lord - Void Crisis Nadleef
SUMMON_TYPE_VORTEX=SUMMON_TYPE_SPECIAL+0x60

--Helper cards, allow other cards to perform Vortex Summon without having to wait for a specific card to be banished first.
function Vortex.Enable(tp)
    if Duel.GetFlagEffect(tp,VORTEX_GLOBAL_FLAG)==0 then
        Duel.RegisterFlagEffect(tp,VORTEX_GLOBAL_FLAG,RESET_PHASE+PHASE_END,0,1)
    end
end

function Vortex.GetValue(c)
    if c:IsType(TYPE_LINK) then return c:GetLink() end
    if c:IsType(TYPE_XYZ) then return c:GetRank() end
    return c:GetLevel()
end

function Vortex.MatFilter(c,filter,tp)
    return c:IsFaceup() and (c:IsAbleToDeck() or c:IsAbleToExtra()) and (not filter or filter(c,tp))
end

function Vortex.Rescon(sg,e,tp,mg,total_val,recipe)
    if #sg==0 then return false end
    local g=sg
    if type(sg== "table" then
        g=Group.CreateGroup()
        for _,tc in ipairs(sg) do g:AddCard(tc) end
    end
    local sum= g:GetSum(Vortex.GetValue)
    if sum~= total_val then return false end
    if Duel.GetLocationCountFromEx(tp,tp,g,e:GetHandler(),0x60)<=0 then return false end    
    if not recipe then return true end
    return recipe(g,e,tp,mg)
end

function Vortex.AddProcedure(c,total_val,recipe)
    --Main Summon Procedure
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(1199)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetLabel(total_val)
    if recipe then e1:SetLabelObject({recipe}) end
    e1:SetCondition(Vortex.Condition)
    e1:SetTarget(Vortex.Target)
    e1:SetOperation(Vortex.Operation)
    e1:SetValue(SUMMON_TYPE_VORTEX+0x60) 
    c:RegisterEffect(e1)
    --NOT FUSION/SYNCHRO/XYZ
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
    e2:SetRange(LOCATION_ALL)
    e2:SetCode(EFFECT_REMOVE_TYPE)
    e2:SetValue(TYPE_FUSION)
    c:RegisterEffect(e2)
	local es=e2:Clone()
    es:SetValue(TYPE_SYNCHRO)
    c:RegisterEffect(es)
	local ex=e2:Clone()
    ex:SetValue(TYPE_XYZ)
    c:RegisterEffect(ex)
	local eli=e2:Clone()
    eli:SetValue(TYPE_LINK)
    c:RegisterEffect(eli)	
    if TYPE_VORTEX then
        local e3=e2:Clone()
        e3:SetCode(EFFECT_ADD_TYPE)
        e3:SetValue(TYPE_VORTEX)
        c:RegisterEffect(e3)
    end
end

function Vortex.Condition(e,c,tp,sg)
    if c==nil then return true end
    local tp=c:GetControler()
    if Duel.GetFlagEffect(tp,VORTEX_GLOBAL_FLAG)==0 then return false end       
    local total_val=e:GetLabel()
    local wrapper=e:GetLabelObject()
    local recipe=wrapper and wrapper[1] or nil    
    local rg=Duel.GetMatchingGroup(Vortex.MatFilter,tp,LOCATION_MZONE,0,nil)   
    return aux.SelectUnselectGroup(rg,e,tp,2,99,function(sg,e,tp,mg) return Vortex.Rescon(sg,e,tp,mg,total_val,recipe) end,0)
end

function Vortex.Target(e,tp,eg,ep,ev,re,r,rp,chk,c)
    local total_val=e:GetLabel()
    local wrapper=e:GetLabelObject()
    local recipe=wrapper and wrapper[1] or nil    
    local rg=Duel.GetMatchingGroup(Vortex.MatFilter,tp,LOCATION_MZONE,0,nil)
    local sg=aux.SelectUnselectGroup(rg,e,tp,2,99,function(sg,e,tp,mg) return Vortex.Rescon(sg,e,tp,mg,total_val,recipe) end,1,tp,HINTMSG_SPSUMMON,nil,nil,true)
    if sg then
        sg:KeepAlive()
        e:SetLabelObject(sg)
        return true
    end
    return false
end

function Vortex.Operation(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetLabelObject()
    if not g then return end   
    c:SetMaterial(g)   
    --Xyz(Core)
    local core=g:Filter(Card.IsType,nil,TYPE_XYZ)
    --Fuel (Non-Xyz) to Grave
    local fuel=g-core   
    if #core>0 then
        Duel.SendtoDeck(core,nil,SEQ_DECKSHUFFLE,REASON_MATERIAL+REASON_VORTEX)
    end   
    if #fuel>0 then
        Duel.SendtoGrave(fuel,REASON_MATERIAL+REASON_VORTEX)
    end   
    g:DeleteGroup()
end