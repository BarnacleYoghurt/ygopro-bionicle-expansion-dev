if not bcot then
	dofile "expansions/util-bcot.lua"
end
--Great Kanohi Kaukau
local s,id=GetID()
function s.initial_effect(c)
	--Activate, Equip Limit
	local e1,e2=bcot.kanohi_equip_great(c)
	c:RegisterEffect(e1)
	c:RegisterEffect(e2)
  --Destroy if replaced
  local e3=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e3)
  --Spell/Trap immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(s.value4)
	c:RegisterEffect(e4)
	--Search
  local e5=bcot.kanohi_search(c,10100002)
  e5:SetDescription(id,0)
  e5:SetCountLimit(1,id)
	c:RegisterEffect(e5)
end
function s.value4(e,te)
  return (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_TRAP)) and te:GetHandler()~=e:GetHandler()
end