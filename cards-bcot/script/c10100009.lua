if not bcot then
	dofile "expansions/util-bcot.lua"
end
--Great Kanohi Pakari
local s,id=GetID()
function s.initial_effect(c)
	--Activate, Equip Limit
	local e1,e2=bcot.kanohi_equip_great(c)
	c:RegisterEffect(e1)
	c:RegisterEffect(e2)
  --Destroy if replaced
  local e3=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e3)
	--ATK gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(1000)
	c:RegisterEffect(e4)
  --Piercing
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_EQUIP)
  e5:SetCode(EFFECT_PIERCE)
  c:RegisterEffect(e5)
	--Search
  local e6=bcot.kanohi_search(c,10100003)
  e6:SetDescription(id,0)
  e6:SetCountLimit(1,id)
	c:RegisterEffect(e6)
end