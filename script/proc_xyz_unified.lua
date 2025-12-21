aux.XyzUnified = aux.XyzUnified or {}
local XU = aux.XyzUnified

-- altconds = {
--   {
--     filter = function(tc,tp,lc) ... end,
--     banish = 5,
--     label = 1,
--     desc = aux.Stringid(id,2)
--   },
--   {...}
-- }

function XU.AddProcedure(c,rank,lvfilter,minct,altconds)
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_FIELD)
	e:SetCode(EFFECT_SPSUMMON_PROC)
	e:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e:SetRange(LOCATION_EXTRA)
	e:SetValue(SUMMON_TYPE_XYZ)
	e:SetCondition(XU.con(rank,lvfilter,minct,altconds))
	e:SetOperation(XU.op(rank,lvfilter,minct,altconds))
	c:RegisterEffect(e)
end

-- ======================
-- CONDITION
-- ======================
function XU.con(rank,lvfilter,minct,altconds)
	return function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end

		-- NORMAL XYZ
		local g=Duel.GetMatchingGroup(lvfilter,tp,LOCATION_MZONE,0,nil)
		if #g>=minct then return true end

		-- ALT XYZ
		for _,alt in ipairs(altconds or {}) do
			if Duel.IsExistingMatchingCard(
				function(tc) return alt.filter(tc,tp,c) end,
				tp,LOCATION_MZONE,0,1,nil
			)
			and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)>=alt.banish then
				return true
			end
		end
		return false
	end
end

-- ======================
-- OPERATION
-- ======================
function XU.op(rank,lvfilter,minct,altconds)
	return function(e,tp,eg,ep,ev,re,r,rp,c)
		local use_alt=false
		local alt_used=nil

		-- cek alt tersedia
		local avail_alt={}
		for _,alt in ipairs(altconds or {}) do
			if Duel.IsExistingMatchingCard(
				function(tc) return alt.filter(tc,tp,c) end,
				tp,LOCATION_MZONE,0,1,nil
			)
			and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)>=alt.banish then
				table.insert(avail_alt,alt)
			end
		end

		-- pilihan ALT
		if #avail_alt>0 then
			for _,alt in ipairs(avail_alt) do
				if Duel.SelectYesNo(tp,alt.desc) then
					use_alt=true
					alt_used=alt
					break
				end
			end
		end

		-- ================= ALT XYZ =================
		if use_alt then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local tc=Duel.SelectMatchingCard(
				tp,
				function(tc) return alt_used.filter(tc,tp,c) end,
				tp,LOCATION_MZONE,0,1,1,nil
			):GetFirst()
			if not tc then return false end

			local mg=tc:GetOverlayGroup()
			if #mg>0 then
				Duel.Overlay(c,mg)
			end
			c:SetMaterial(Group.FromCards(tc))
			Duel.Overlay(c,Group.FromCards(tc))
			c:SetSummonType(SUMMON_TYPE_XYZ)
			e:SetLabel(alt_used.label or 1)
			return
		end

		-- ================= NORMAL XYZ =================
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mg=Duel.SelectMatchingCard(
			tp,
			lvfilter,
			tp,LOCATION_MZONE,0,minct,minct,nil
		)
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		c:SetSummonType(SUMMON_TYPE_XYZ)
		e:SetLabel(0)
	end
end
