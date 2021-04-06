if not bcot then
	dofile "expansions/util-bcot.lua"
end
--Great Kanohi Kakama
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
	--Attack All
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_ATTACK_ALL)
  e2:SetCondition(bcot.greatkanohi_con)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Search
  local e3=bcot.kanohi_search(c,10100004)
  e3:SetDescription(aux.Stringid(id,0))
  e3:SetCountLimit(1,id)
	c:RegisterEffect(e3)
end
