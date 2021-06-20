--The Boxor, Weapon of the Matoran
local s,id=GetID()
function s.initial_effect(c)
	aux.AddUnionProcedure(c,aux.FilterBoolFunction(s.filter0))
  --set ATK
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_EQUIP)
  e1:SetCode(EFFECT_SET_BASE_ATTACK)
  e1:SetValue(2000)
  c:RegisterEffect(e1)
  --Block effects
  local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,1)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
  e2:SetCondition(s.condition2)
	e2:SetValue(s.value2)
	c:RegisterEffect(e2)
end
function s.filter0(c)
	return c:IsRace(RACE_WARRIOR) and c:IsLevel(2)
end
function s.condition2(e)
	return Duel.GetAttacker()==e:GetHandler():GetEquipTarget()
end
function s.value2(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end