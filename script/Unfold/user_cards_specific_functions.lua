--Special Summon limit for "Darklight Fusion"-related Fusion monsters
function Auxiliary.DarkLightFLimit(e,se,sp,st)
	if not e:GetHandler():IsLocation(LOCATION_EXTRA) then return true end
	if not se then return false end
	local sc=se:GetHandler()
	return sc:IsCode(17106529) or sc:IsCode(899982111)--Phantasm Dragon Erva
end
--NOTE: Use this 'Duel.LoadScript("user_cards_specific_functions.lua")' in every script to connect all function on this script

if not GenerateEffect then
	GenerateEffect={}

	end
	--Additional ATTRIBUTE
	ATTRIBUTE_RADIANT= 0x100
	--Additional Types
	RACE_VIRTUOUS    = 0x100000000