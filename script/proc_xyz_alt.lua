aux.XyzAlt = aux.XyzAlt or {}
local XyzAlt = aux.XyzAlt
--filter: monster yang boleh dipakai sebagai ALT material
--banishcount: minimal kartu banish
--desc: stringid
function XyzAlt.AddProcedure(c,filter,banishcount,desc)
	Xyz.AddProcedure(
		c,
		nil,
		c:GetRank(),0,
		function(tc,tp,lc)
			return filter(tc,tp,lc)
				and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)>=banishcount
		end,
		function(e,tp,chk)
			if chk==0 then return true end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local tc=Duel.SelectMatchingCard(
				tp,
				function(c) return filter(c,tp,e:GetHandler()) end,
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
			return true
		end,
		desc
	)
end