if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Great Kanohi Miru Nuva
local s,id=GetID()
function s.initial_effect(c) aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
  --Negate targeting effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(s.condition2)
  e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
  --Place Nuva Symbol & protect field
  local e3,chainfilter=bpev.kanohi_nuva_search_trap(c,s.operation3,id)
  Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,chainfilter)
  e3:SetDescription(aux.Stringid(id,0))
  c:RegisterEffect(e3)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not (bcot.kanohi_con(e,{0xb0c}) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler():GetEquipTarget()) and ep~=tp
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
  for tc in aux.Next(g) do
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(3061)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e1:SetValue(aux.tgoval)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
  end
end