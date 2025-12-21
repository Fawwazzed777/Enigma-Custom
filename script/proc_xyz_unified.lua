aux.XyzUnified = aux.XyzUnified or {}
local XU = aux.XyzUnified

function XU.AddProcedure(c,lvfilter,rank,minct,alt)
	Xyz.AddProcedure(
		c,
		lvfilter,
		rank,
		minct,
		function(tc,tp,lc)
			if not alt then return false end
			return tc:IsFaceup()
				and alt.filter(tc,tp,lc)
				and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)>=alt.banish
		end,
		function(e,tp,chk,lc)
			if chk==0 then return true end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local tc=Duel.SelectMatchingCard(
				tp,
				function(tc) return alt.filter(tc,tp,e:GetHandler()) end,
				tp,LOCATION_MZONE,0,1,1,nil
			):GetFirst()
			if not tc then return false end

			local c=e:GetHandler()
			local mg=tc:GetOverlayGroup()
			if #mg>0 then
				Duel.Overlay(c,mg)
			end
			c:SetMaterial(Group.FromCards(tc))
			Duel.Overlay(c,Group.FromCards(tc))
			Duel.XyzSummonComplete(c)
			return true
		end,
		alt.desc,
		Xyz.InfiniteMats
	)
end
