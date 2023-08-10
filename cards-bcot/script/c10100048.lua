if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Great Kanohi Aki
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
	--Indestructible by battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e2:SetCondition(s.condition)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--ATK gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetCondition(s.condition)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
  --Piercing
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_EQUIP)
  e4:SetCode(EFFECT_PIERCE)
  e4:SetCondition(s.condition)
  c:RegisterEffect(e4)
  --Attack All
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_ATTACK_ALL)
  e5:SetCondition(s.condition)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--Xyz
	local e6=bcot.kanohi_xyz(c)
	e6:SetDescription(aux.Stringid(id,0))
  e6:SetCountLimit(1)
	c:RegisterEffect(e6)
end
s.listed_series={0xb04,0x1b02,0x2b02,0xb02}
function s.condition(e)
  return bcot.kanohi_con(e,{0x2b02})
end
