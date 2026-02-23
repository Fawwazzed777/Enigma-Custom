VORTEX_IMPORTED = true

if not aux.VortexProcedure then
    aux.VortexProcedure = {}
    Vortex = aux.VortexProcedure
end

VORTEX_GLOBAL_FLAG = 111166660 
SUMMON_TYPE_VORTEX = SUMMON_TYPE_SPECIAL+0x50
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
    if recipe then e1:SetLabelObject({recipe}) end
    e1:SetCondition(Vortex.Condition)
    e1:SetTarget(Vortex.Target)
    e1:SetOperation(Vortex.Operation)
    e1:SetValue(SUMMON_TYPE_VORTEX) 
    c:RegisterEffect(e1)
    --NOT FUSION and cannot be used as Fusion material
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
    e0:SetRange(LOCATION_ALL)
    e0:SetCode(EFFECT_REMOVE_TYPE)
    e0:SetValue(TYPE_FUSION)
    c:RegisterEffect(e0)
    --ADD TYPE VORTEX
    if TYPE_VORTEX then
        local e2=e0:Clone()
        e2:SetCode(EFFECT_ADD_TYPE)
        e2:SetValue(TYPE_VORTEX)
        c:RegisterEffect(e2)
    end
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
    e3:SetRange(LOCATION_EXTRA)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetValue(function(e,re,rp)
        return re:IsHasCategory(CATEGORY_FUSION_SUMMON) or (re:GetActiveType() and re:GetActiveType()&TYPE_FUSION~=0)
    end)
    c:RegisterEffect(e3)    
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

function Vortex.Operation(e,tp,eg,ep,ev,re,r,rp,c,sg)
    local g=e:GetLabelObject()
    if not g then return end
    Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_MATERIAL+REASON_COST)
    g:DeleteGroup()
end