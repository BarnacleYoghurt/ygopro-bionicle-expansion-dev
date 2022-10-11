if not bcot then
	Duel.LoadScript("../util-bcot.lua")
end
if not bpev then
	Duel.LoadScript("../util-bpev.lua")
end
--Great Kanohi Pakari Nuva
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
  --Place Nuva Symbol
  local e2=bpev.kanohi_nuva_search(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetCountLimit(1,id)
  c:RegisterEffect(e2)
  --ATK gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetCondition(function(e) return bcot.kanohi_con(e,{0xb0c}) end)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
  --Piercing
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_EQUIP)
  e4:SetCode(EFFECT_PIERCE)
  e4:SetCondition(function(e) return bcot.kanohi_con(e,{0xb0c}) end)
  c:RegisterEffect(e4)
  --AOE
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(id,2))
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetRange(LOCATION_SZONE)
  e5:SetCondition(function(e) return bcot.kanohi_con(e,{0xb0c}) end)
  e5:SetCost(s.cost5)
  e5:SetOperation(s.operation5)
  e5:SetCountLimit(1)
  c:RegisterEffect(e5)
end
function s.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.operation5(e,tp,eg,ep,ev,re,r,rp)
  if e:GetHandler():IsRelateToEffect(e) then
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    for tc in aux.Next(g) do
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetValue(500)
      e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
      tc:RegisterEffect(e1)
    end
  end
end