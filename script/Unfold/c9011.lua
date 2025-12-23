local s,id=GetID()
function s.initial_effect(c)
--Link Procedure
c:EnableReviveLimit()
Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT),3,3)
	
end
