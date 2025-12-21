aux.XyzUnified=aux.XyzUnified or {}
local XyzUnified=aux.XyzUnified
Debug.Message("proc_xyz_unified loaded")
-- normal_filter : filter normal material
-- normal_level  : level normal material
-- normal_count  : minimal jumlah
-- alt_filter    : filter Xyz alt material
-- banishcount   : minimal banish
-- desc          : stringid (for ALT)
function XyzUnified.AddProcedure(
	c,
	normal_filter,normal_level,normal_count,
	alt_filter,banishcount,
	desc)
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_FIELD)
	e:SetCode(EFFECT_SPSUMMON_PROC)
	e:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e:SetRange(LOCATION_EXTRA)
	e:SetValue(SUMMON_TYPE_XYZ)
	e:SetCondition(XyzUnified.con(
		normal_filter,normal_level,normal_count,
		alt_filter,banishcount
	))
	e:SetOperation(XyzUnified.op(
		normal_filter,normal_level,normal_count,
		alt_filter,banishcount
	))
	if desc then e:SetDescription(desc) end
	c:RegisterEffect(e)
end

function XyzUnified.con(nf,nlv,nct,af,bc)
	return function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		-- ALT possible?
		if Duel.IsExistingMatchingCard(af,tp,LOCATION_MZONE,0,1,nil,tp)
			and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)>=bc then
			return true
		end
		-- NORMAL possible?
		local g=Duel.GetMatchingGroup(
			function(tc)
				return nf(tc) and tc:IsLevel(nlv)
			end,
			tp,LOCATION_MZONE,0,nil
		)
		return #g>=nct
	end
end

function XyzUnified.op(nf,nlv,nct,af,bc)
	return function(e,tp,eg,ep,ev,re,r,rp,c)
		local can_alt=
			Duel.IsExistingMatchingCard(af,tp,LOCATION_MZONE,0,1,nil,tp)
			and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)>=bc

		local do_alt=false
		if can_alt then
			do_alt=Duel.SelectYesNo(tp,aux.Stringid(c:GetCode(),1))
		end
		-- ===== ALT XYZ =====
		if do_alt then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local tc=Duel.SelectMatchingCard(
				tp,
				function(tc) return af(tc,tp) end,
				tp,LOCATION_MZONE,0,1,1,nil
			):GetFirst()
			if not tc then return end

			local mg=tc:GetOverlayGroup()
			if #mg>0 then Duel.Overlay(c,mg) end
			c:SetMaterial(tc)
			Duel.Overlay(c,tc)
			c:CompleteProcedure()
			return
		end
		-- ===== NORMAL XYZ =====
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(
			tp,
			function(tc)
				return nf(tc) and tc:IsLevel(nlv)
			end,
			tp,LOCATION_MZONE,0,nct,99,nil
		)
		c:SetMaterial(g)
		Duel.Overlay(c,g)
		c:CompleteProcedure()
	end
end
