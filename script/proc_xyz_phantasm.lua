aux.XyzPhantasm = aux.XyzPhantasm or {}
local XyzPhantasm = aux.XyzPhantasm

function XyzPhantasm.AddProcedure(c,filter,banishcount,desc)
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_FIELD)
	e:SetCode(EFFECT_SPSUMMON_PROC)
	e:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e:SetRange(LOCATION_EXTRA)
	e:SetValue(SUMMON_TYPE_XYZ)
	e:SetCondition(XyzPhantasm.con(filter,banishcount))
	e:SetOperation(XyzPhantasm.op(filter))
	if desc then
		e:SetDescription(desc)
	end
	c:RegisterEffect(e)
end

function XyzPhantasm.con(filter,banishcount)
	return function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(filter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)>=banishcount
	end
end

function XyzPhantasm.op(filter)
	return function(e,tp,eg,ep,ev,re,r,rp,c)
		if not Duel.SelectYesNo(tp,aux.Stringid(c:GetCode(),0)) then
			return false
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,filter,tp,LOCATION_MZONE,0,1,1,nil,true)
		if #g==0 then return false end
		local tc=g:GetFirst()
		local mg=tc:GetOverlayGroup()
		if #mg>0 then
			Duel.Overlay(c,mg)
		end
		c:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(c,Group.FromCards(tc))
		Duel.XyzSummonComplete(c)
		--return true --
	end
end
