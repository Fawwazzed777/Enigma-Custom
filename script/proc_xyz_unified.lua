aux.XyzUnified = aux.XyzUnified or {}

function aux.XyzUnified.AddProcedure(c,rank,lvfilter,altfilter,banishcount,desc)
	Xyz.AddProcedure(
		c,
		lvfilter,         -- normal material filter
		rank,3,           -- normal requirement
		function(tc,tp,lc)
			-- ALT condition
			return altfilter
				and altfilter(tc,tp,lc)
				and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)>=banishcount
		end,
		function(e,tp,chk)
			if chk==0 then return true end

			local c=e:GetHandler()

			-- pilih: normal atau alt
			if Duel.SelectYesNo(tp,desc) then
				-- ALT XYZ
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local tc=Duel.SelectMatchingCard(
					tp,
					function(c) return altfilter(c,tp,c) end,
					tp,LOCATION_MZONE,0,1,1,nil
				):GetFirst()
				if not tc then return false end

				local mg=tc:GetOverlayGroup()
				if #mg>0 then
					Duel.Overlay(c,mg)
				end
				c:SetMaterial(Group.FromCards(tc))
				Duel.Overlay(c,Group.FromCards(tc))
			end
			return true
		end,
		desc,
		nil,
		Xyz.InfiniteMats
	)
end
