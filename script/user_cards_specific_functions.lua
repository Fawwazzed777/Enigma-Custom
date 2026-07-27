--Special Summon limit for "Darklight Fusion"-related Fusion monsters
function Auxiliary.DarkLightFLimit(e,se,sp,st)
	if not e:GetHandler():IsLocation(LOCATION_EXTRA) then return true end
	if not se then return true end
	local sc=se:GetHandler()
	return sc:IsCode(17106529) or sc:IsCode(899982111) or se:IsHasProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
end

if not GenerateEffect then
	GenerateEffect={}

	end

