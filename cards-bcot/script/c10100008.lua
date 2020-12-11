if not bcot then
	dofile "expansions/util-bcot.lua"
end
--Great Kanohi Kaukau
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
  --Spell/Trap immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
  e2:SetCondition(bcot.greatkanohi_con)
	e2:SetValue(s.value2)
	c:RegisterEffect(e2)
	--Search
  local e3=bcot.kanohi_search(c,10100002)
  e3:SetDescription(aux.Stringid(id,0))
  e3:SetCountLimit(1,id)
	c:RegisterEffect(e3)
end
function s.value2(e,te)
  return (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_TRAP)) and te:GetHandler()~=e:GetHandler()
end