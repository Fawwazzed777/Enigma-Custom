--Special Summon limit for "Darklight Fusion"-related Fusion monsters
function Auxiliary.DarkLightFLimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or se:GetHandler():IsCode(17106529)
end
--NOTE: Use this 'Duel.LoadScript("user_cards_specific_functions.lua")' in every script to connect all function on this script

if not GenerateEffect then
	GenerateEffect={}
	--Additional ATTRIBUTE
	ATTRIBUTE_RADIANT= 0x100

	--Additional Types
	RACE_VIRTUOUS    = 0x4000000
	end
--Counter
COUNTER_VANDAL =0x1765