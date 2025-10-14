--Witchcrafter Stacy
function c77777927.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),2,2)
	c:EnableReviveLimit()
  --indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c77777927.indtg)
	e3:SetValue(c77777927.indval)
	c:RegisterEffect(e3)
  local e5=e3:Clone()
  e5:SetCode(EFFECT_CANNOT_REMOVE)
  e5:SetValue(1)
  c:RegisterEffect(e5)
  --Attach
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetDescription(aux.Stringid(77777927,0))
	e4:SetRange(LOCATION_MZONE)
  e4:SetCode(EVENT_FREE_CHAIN)
  e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c77777927.xyztg)
	e4:SetOperation(c77777927.xyzop)
	c:RegisterEffect(e4)
end

function c77777927.xmfil2(c,xyzmat)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x407) and xyzmat:IsCanBeXyzMaterial(c)
end
function c77777927.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c77777927.xmfil2,tp,LOCATION_MZONE,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c77777927.xmfil2,tp,LOCATION_MZONE,0,1,1,nil,e:GetHandler())
end
function c77777927.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end

function c77777927.indtg(e,c)
	return c:IsSetCard(0x407) and e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c77777927.indval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end