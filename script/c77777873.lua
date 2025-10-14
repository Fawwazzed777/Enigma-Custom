--Psyber-Evacuation
function c77777873.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777873,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,77777873)
	e1:SetTarget(c77777873.ptg)
	e1:SetOperation(c77777873.pop)
	c:RegisterEffect(e1)
end

function c77777873.pfilter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x40b) and c:IsAbleToRemove() 
    and Duel.IsExistingMatchingCard(c77777868.pfilter2,tp,LOCATION_DECK,0,1,c,e,tp,c:GetCode())
end
function c77777873.pfilter2(c,e,tp,code)
	return c:IsSetCard(0x40b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code)
end
function c77777873.pfilter3(c,code)
	return c:IsSetCard(0x40b) and c:IsAbleToHand() and c:IsCode(code)
end
function c77777873.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777873.pfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp)end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE)
end
function c77777873.pop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c77777873.pfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
  if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c77777873.pfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,g:GetFirst():GetCode()) then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      local g2=Duel.SelectMatchingCard(tp,c77777873.pfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,g:GetFirst():GetCode())
      if Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)~=0 then
        g2:GetFirst():RegisterFlagEffect(77777873,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetCountLimit(1)
        e1:SetLabel(fid)
        e1:SetLabelObject(g2:GetFirst())
        e1:SetCondition(c77777873.rmcon)
        e1:SetOperation(c77777873.rmop)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
        if Duel.IsExistingMatchingCard(c77777873.pfilter3,tp,LOCATION_DECK,0,1,nil,g:GetFirst():GetCode()) then
        local g3=Duel.SelectMatchingCard(tp,c77777873.pfilter3,tp,LOCATION_DECK,0,1,1,nil,g:GetFirst():GetCode())
        if g3:GetCount()>0 then
          Duel.SendtoHand(g3,nil,REASON_EFFECT)
        end
      end
      end
  end
end


function c77777873.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(77777873)==e:GetLabel()
end
function c77777873.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end