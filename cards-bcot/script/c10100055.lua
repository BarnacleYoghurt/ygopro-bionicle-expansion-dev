--Suva
local s,id=GetID()
function s.initial_effect(c)
	--Multi-attribute
  local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_SINGLE)
	e1a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1a:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1a:SetRange(LOCATION_HAND)
	e1a:SetValue(ATTRIBUTE_WIND+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_EARTH)
	c:RegisterEffect(e1a)
  local e1b=e1a:Clone()
  e1b:SetRange(LOCATION_MZONE)
  e1b:SetCondition(s.condition1)
  c:RegisterEffect(e1b)
end
function s.filter1(c)
  return c:IsFaceup() and c:IsSetCard(0xb05)
end
function s.condition1(e)
  local tp=e:GetHandlerPlayer()
  return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_FZONE,0,1,nil)
end