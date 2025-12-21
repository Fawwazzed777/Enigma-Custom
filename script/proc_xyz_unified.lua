--proc_xyz_unified.lua
aux.XyzUnified = aux.XyzUnified or {}
local XyzUnified = aux.XyzUnified

function XyzUnified.AltXyzSummon(c,filter,banishcount,desc)
	local e=Effect.CreateEffect(c)
	e:SetDescription(desc)
	e:SetType(EFFECT_TYPE_IGNITION)
	e:SetRange(LOCATION_EXTRA)
	e:SetCondition(function(e,tp)
		return Duel.IsExistingMatchingCard(filter,tp,LOCATION_MZONE,0,1,nil,tp)
			and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)>=banishcount
	end)
	e:SetOperation(function(e,tp)
		local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tc=Duel.SelectMatchingCard(tp,filter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
		if not tc then return end

		local mg=tc:GetOverlayGroup()
		if #mg>0 then
			Duel.Overlay(c,mg)
		end
		c:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(c,Group.FromCards(tc))

		if Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
			c:CompleteProcedure()
		end
	end)
	c:RegisterEffect(e)
end
