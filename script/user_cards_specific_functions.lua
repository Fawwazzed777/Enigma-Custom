--Special Summon limit for "Darklight Fusion"-related Fusion monsters
function Auxiliary.DarkLightFLimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or se:GetHandler():IsCode(17106529)
end

if not GenerateEffect then
	GenerateEffect={}

	end

