if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Great Kanohi Pakari
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
	--ATK gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetCondition(bcot.greatkanohi_con)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
  --Piercing
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_EQUIP)
  e3:SetCode(EFFECT_PIERCE)
  e3:SetCondition(bcot.greatkanohi_con)
  c:RegisterEffect(e3)
	--Search
  local e4=bcot.kanohi_search(c,10100003)
  e4:SetDescription(aux.Stringid(id,0))
  e4:SetCountLimit(1,id)
	c:RegisterEffect(e4)
end
s.listed_names={10100003}
s.listed_series={0xb04,0xb02,0xb07}