aux.XyzAlt=aux.XyzAlt or {}
local XyzAlt=aux.XyzAlt
-- filter: monster Xyz yang boleh dipakai
-- banishcount: minimal kartu face-up banished
-- desc: StringID
function XyzAlt.AddProcedure(c,filter,banishcount,desc)
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_FIELD)
	e:SetCode(EFFECT_SPSUMMON_PROC)
	e:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e:SetRange(LOCATION_EXTRA)
	e:SetValue(SUMMON_TYPE_XYZ)
	e:SetCondition(XyzAlt.con(filter,banishcount))
	e:SetOperation(XyzAlt.op(filter))
	if desc then
		e:SetDescription(desc)
	end
	c:RegisterEffect(e)
end

function XyzAlt.con(filter,banishcount)
	return function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(filter,tp,LOCATION_MZONE,0,1,nil,tp)
			and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)>=banishcount
	end
end

function XyzAlt.op(filter)
	return function(e,tp,eg,ep,ev,re,r,rp,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tc=Duel.SelectMatchingCard(
			tp,
			function(tc) return filter(tc,tp) end,
			tp,LOCATION_MZONE,0,1,1,nil
		):GetFirst()
		if not tc then return end
		local mg=tc:GetOverlayGroup()
		if #mg>0 then
			Duel.Overlay(c,mg)
		end
		c:SetMaterial(tc)
		Duel.Overlay(c,tc)
		c:CompleteProcedure()
	end
end