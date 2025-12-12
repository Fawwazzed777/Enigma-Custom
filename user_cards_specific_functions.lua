--Special Summon limit for "Darklight Fusion"-related Fusion monsters
function Auxiliary.DarkLightFLimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or se:GetHandler():IsCode(17106529)
end
--NOTE: Use this 'Duel.LoadScript("user_cards_specific_functions.lua")' in every script to connect all function on this script

ATTRIBUTE_RADIANT= 0x100
RACE_VIRTUOUS    = 0x4000000
function Card.IsRadiant(c)
    return c:IsAttribute(ATTRIBUTE_RADIANT)
end
function Card.IsVirtuous(c)
    return c:IsRace(RACE_VIRTUOUS)
end