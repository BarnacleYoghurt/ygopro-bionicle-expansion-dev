if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Great Kanohi Kaukau Nuva
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
  e2:SetCondition(function(e) return bcot.kanohi_con(e,{0x3b02}) end)
	e2:SetValue(s.value2)
	c:RegisterEffect(e2)
  --Place Nuva Symbol & protect field
  local e3,chainfilter=bpev.kanohi_nuva_search_spell(c,s.operation3,id)
  Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,chainfilter)
  e3:SetDescription(aux.Stringid(id,0))
  c:RegisterEffect(e3)
end
function s.value2(e,re)
  if e:GetOwnerPlayer()==re:GetOwnerPlayer() then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler():GetEquipTarget())
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
  for tc in aux.Next(g) do
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(3001)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetValue(1)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
  end
end