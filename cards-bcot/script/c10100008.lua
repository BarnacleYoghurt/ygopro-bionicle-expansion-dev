if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Great Kanohi Kaukau
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
  --Immune to non-targeting effects
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
s.listed_names={10100002}
s.listed_series={0xb04,0xb02,0xb07}
function s.value2(e,re)
  if e:GetOwnerPlayer()==re:GetOwnerPlayer() then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler():GetEquipTarget())
end