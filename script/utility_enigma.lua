aux.Enigma = aux.Enigma or {}

function aux.Enigma.CheckBanish(tp,count)
    return Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)>=count
end