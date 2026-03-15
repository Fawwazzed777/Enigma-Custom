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

function Vortex.CoreFilter(c,f1,vortex_card,tp)
    if not c:IsType(TYPE_XYZ) or not c:IsFaceup() then return false end
    if type(f1)=="function" then
        return f1(c,vortex_card,tp)
    else
        return c:GetRank()==f1
    end
end

function Vortex.FuelFilter(c,f2,vortex_card,tp)
    if c:IsType(TYPE_XYZ) or not c:IsFaceup() then return false end
    if f2 then
        return f2(c,vortex_card,tp)
    else
        return true
    end
end

function Vortex.MatFilter(c,filter,tp)
    local can_be_material=(c:IsType(TYPE_XYZ) and (c:IsAbleToDeck() or c:IsAbleToExtra())) or (not c:IsType(TYPE_XYZ) and c:IsAbleToGrave())
    return c:IsFaceup() and can_be_material and (not filter or filter(c,tp))
end

function Vortex.Rescon(sg,e,tp,mg,c,f1,minc,f2,minf,maxf)
    --Atleast 1 Core and 1 Fuel
    local cores=sg:Filter(Vortex.CoreFilter,nil,f1,c,tp)
    local fuels=sg:Filter(Vortex.FuelFilter,nil,f2,c,tp)   
    --(Double/Triple tuning logic)
    if #cores~=minc then return false end    
    --Fuel Validation
    if #fuels<minf or #fuels>maxf then return false end  
    if #sg~=(#cores+#fuels) then return false end
    return true
end

--Vortex Summon by card effect
function Card.IsVortexSummonable(c,e,tp,must_use,mg)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false)
		and c:IsVortex() and c:VortexRule(e,tp,must_use,mg)
end

function Card.IsVortex(c)
    local mt=c:GetMetatable()
    return (mt and mt.Vortex) or c:IsHasEffect(511729900)
end

function Vortex.AddProcedure(c,f1,minc,f2,minf,maxf)
	--Vortex Identity
	if not minc then minc=1 end
    if not minf then minf=1 end
    if not maxf then maxf=99 end
	if not Vortex.global_check then
        Vortex.global_check= true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_REMOVE)
        ge1:SetOperation(function()
            if Duel.GetFlagEffect(0,VORTEX_ACTIVITY_FLAG)==0 then
                Duel.RegisterFlagEffect(0,VORTEX_ACTIVITY_FLAG,RESET_PHASE+PHASE_END,0,1)
            end
            if Duel.GetFlagEffect(1,VORTEX_ACTIVITY_FLAG)==0 then
                Duel.RegisterFlagEffect(1,VORTEX_ACTIVITY_FLAG,RESET_PHASE+PHASE_END,0,1)
            end
        end)
        Duel.RegisterEffect(ge1,0)
    end
    --Must first be Vortex Summoned condition
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(function(e,se,sp,st)
		if e:GetHandler():IsLocation(LOCATION_EXTRA) then
			return (st&SUMMON_TYPE_VORTEX)==SUMMON_TYPE_VORTEX
		end
		return true 
	end)
	c:RegisterEffect(e0)
    --Vortex Summon Procedure
    local e1=Effect.CreateEffect(c,f1,f2,min,max)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetDescription(1199)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetLabel(total_val)
    if recipe then e1:SetLabelObject({recipe}) end
    e1:SetCondition(Vortex.Condition(f1,minc,f2,minf,maxf))
    e1:SetTarget(Vortex.Target(f1,minc,f2,minf,maxf))
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
	local mt=c:GetMetatable()
    mt.vortex_parameters={f1,f2,min,max}
end


function Vortex.Condition(e,c,tp,sg)
    if c==nil then return true end
    local tp=c:GetControler()    
    --Flag 
    if Duel.GetFlagEffect(tp,VORTEX_ACTIVITY_FLAG)==0 then 
        return false 
    end 
    local total_val=e:GetLabel()
    local wrapper=e:GetLabelObject()
    local recipe=wrapper and wrapper[1] or nil    
    local rg=Duel.GetMatchingGroup(Vortex.MatFilter,tp,LOCATION_MZONE,0,nil)   
    return aux.SelectUnselectGroup(rg,e,tp,2,99,function(sg,e,tp,mg) 
        return Vortex.Rescon(sg,e,tp,mg,total_val,recipe) 
    end,0)
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
    local mt=c:GetMetatable()
    local params=mt.vortex_parameters
    local f1=params and params[1] or nil  
    --Core and Fuel 
    local cores=g:Filter(Vortex.CoreFilter,nil,f1,c,tp)
    local fuels=g:Clone()
    fuels:Sub(cores)
    Duel.SendtoDeck(cores,nil,SEQ_DECKSHUFFLE,REASON_MATERIAL+REASON_VORTEX)  
    --(Stacking special method)
    if c.vortex_stack_fuel then
        Duel.Overlay(c,fuels,REASON_MATERIAL+REASON_VORTEX)        
        --Optional flag
        for tc in aux.Next(fuels) do
            tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
        end
    else
        --Standar Procedure
        Duel.SendtoGrave(fuels,REASON_MATERIAL+REASON_VORTEX)
    end  
    g:DeleteGroup()
end