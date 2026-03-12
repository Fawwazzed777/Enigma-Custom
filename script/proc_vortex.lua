VORTEX_IMPORTED = true

if not aux.VortexProcedure then
    aux.VortexProcedure = {}
    Vortex = aux.VortexProcedure
end

SUMMON_TYPE_VORTEX = SUMMON_TYPE_SPECIAL+0x60
TYPE_VORTEX      = 0x200000000
VORTEX_ACTIVITY_FLAG = 511729901
function Vortex.GetValue(c)
    if c:IsType(TYPE_LINK) then return c:GetLink() end
    if c:IsType(TYPE_XYZ) then return c:GetRank() end
    return c:GetLevel()
end

function Vortex.MatFilter(c,filter,tp)
    local can_be_material=(c:IsType(TYPE_XYZ) and (c:IsAbleToDeck() or c:IsAbleToExtra())) or (not c:IsType(TYPE_XYZ) and c:IsAbleToGrave())
    return c:IsFaceup() and can_be_material and (not filter or filter(c,tp))
end

function Vortex.Rescon(sg,e,tp,mg,total_val,recipe)
    if #sg==0 then return false end
    local g=sg
    if type(sg)=="table" then
        g=Group.CreateGroup()
        for _,tc in ipairs(sg) do g:AddCard(tc) end
    end

    local sum=g:GetSum(Vortex.GetValue)
    if sum~=total_val then return false end
    if Duel.GetLocationCountFromEx(tp,tp,g,e:GetHandler())<=0 then return false end

    if not recipe then return true end
    return recipe(g,e,tp,mg)
end

function Vortex.AddProcedure(c,total_val,recipe)
	--Vortex Identity
	if not Vortex.global_check then
        Vortex.global_check= true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_REMOVE)
        ge1:SetOperation(function()
            Duel.RegisterFlagEffect(0,VORTEX_ACTIVITY_FLAG,RESET_PHASE+PHASE_END,0,1)
            Duel.RegisterFlagEffect(1,VORTEX_ACTIVITY_FLAG,RESET_PHASE+PHASE_END,0,1)
			end)
			Duel.RegisterEffect(ge1,0)
		end
	end
    --Must first be Vortex Summoned condition
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(function(e,se,sp,st) return (st&SUMMON_TYPE_VORTEX)==SUMMON_TYPE_VORTEX end)
    c:RegisterEffect(e0)
    --Vortex Summon Procedure
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
    e1:SetValue(SUMMON_TYPE_VORTEX)
    c:RegisterEffect(e1)
    --Type Stripping Hacks (EDOPro standard for custom ED cards)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
    e2:SetRange(LOCATION_ALL)
    e2:SetCode(EFFECT_REMOVE_TYPE)
    e2:SetValue(TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK)
    c:RegisterEffect(e2)    
    --if TYPE_VORTEX then
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
    e3:SetCode(EFFECT_ADD_TYPE)
    e3:SetValue(TYPE_VORTEX)
    c:RegisterEffect(e3)
end

function Vortex.Condition(e,c,tp,sg)
    if c==nil then return true end
    local tp=c:GetControler()  
	--Check if there is a card banished this turn
    if Duel.GetFlagEffect(tp,VORTEX_ACTIVITY_FLAG)==0 then 
        return false 
    end
    local total_val=e:GetLabel()
    local wrapper=e:GetLabelObject()
    local recipe=wrapper and wrapper[1] or nil    
    local rg=Duel.GetMatchingGroup(Vortex.MatFilter,tp,LOCATION_MZONE,0,nil)   
    return aux.SelectUnselectGroup(rg,e,tp,2,99,function(sg,e,tp,mg) return Vortex.Rescon(sg,e,tp,mg,total_val,recipe) end,0)
end

function Vortex.Target(e,tp,eg,ep,ev,re,r,rp,chk,c)
    local cancelable=Duel.IsSummonCancelable()
    local total_val=e:GetLabel()
    local wrapper=e:GetLabelObject()
    local recipe=wrapper and wrapper[1] or nil    
    local rg=Duel.GetMatchingGroup(Vortex.MatFilter,tp,LOCATION_MZONE,0,nil)
	local sg=aux.SelectUnselectGroup(rg,e,tp,2,99,function(sg,e,tp,mg) 
    return Vortex.Rescon(sg,e,tp,mg,total_val,recipe) 
    end,1,tp,HINTMSG_SPSUMMON,nil,nil,cancelable)
	if sg and #sg>0 then
        sg:KeepAlive()
        e:SetLabelObject(sg)
        return true
    else
        return false
    end
end

function Vortex.Operation(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetLabelObject()
    if not g then return end   
    c:SetMaterial(g)   
    local core=g:Filter(Card.IsType,nil,TYPE_XYZ)
    local fuel=g-core   
    --Core
    if #core>0 then
        Duel.SendtoDeck(core,nil,SEQ_DECKSHUFFLE,REASON_MATERIAL+REASON_VORTEX)
    end  
	--Fuel Material
    if #fuel>0 then
        Duel.SendtoGrave(fuel,REASON_MATERIAL+REASON_VORTEX)
    end   
    g:DeleteGroup()
end