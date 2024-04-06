if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Great Kanohi Pakari Nuva
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
  e2:SetCondition(function(e) return bcot.kanohi_con(e,{0x3b02}) end)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
  --Piercing
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_EQUIP)
  e3:SetCode(EFFECT_PIERCE)
  e3:SetCondition(function(e) return bcot.kanohi_con(e,{0x3b02}) end)
  c:RegisterEffect(e3)
  --Place Nuva Symbol & boost field
  local e4,chainfilter=bpev.kanohi_nuva_search_spell(c,s.operation4,id)
  Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,chainfilter)
  e4:SetDescription(aux.Stringid(id,0))
  c:RegisterEffect(e4)
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
  for tc in aux.Next(g) do
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(600)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
    tc:RegisterEffect(e1)
  end
end