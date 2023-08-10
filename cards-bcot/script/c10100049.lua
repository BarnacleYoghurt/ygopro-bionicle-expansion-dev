if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Great Kanohi Rua
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
	--Immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
  e2:SetCondition(s.condition)
  e2:SetValue(s.value2)
	c:RegisterEffect(e2)
	--Hand Reveal
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_HAND)
	e3:SetCode(EFFECT_PUBLIC)
  e3:SetCondition(s.condition)
	c:RegisterEffect(e3)
	--Xyz
	local e4=bcot.kanohi_xyz(c)
	e4:SetDescription(aux.Stringid(id,0))
  e4:SetCountLimit(1)
	c:RegisterEffect(e4)
end
s.listed_series={0xb04,0x1b02,0x2b02,0xb02}
function s.condition(e)
  return bcot.kanohi_con(e,{0x2b02})
end
function s.value2(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end