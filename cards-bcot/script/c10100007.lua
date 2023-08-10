if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Great Kanohi Hau
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
  e2:SetCondition(bcot.greatkanohi_con)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--No damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
  e3:SetCondition(bcot.greatkanohi_con)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Search
  local e4=bcot.kanohi_search(c,10100001)
  e4:SetDescription(aux.Stringid(id,0))
  e4:SetCountLimit(1,id)
	c:RegisterEffect(e4)
end
s.listed_names={10100001}
s.listed_series={0xb04,0xb02,0xb07}