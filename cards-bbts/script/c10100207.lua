if not bbts then
	Duel.LoadScript("util-bbts.lua")
end
local s,id=GetID()
--Krana Xa, Swarm Commander
function s.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DISABLE)
  e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAINING)
  e1:SetCondition(s.condition1)
  e1:SetCost(s.cost1)
  e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--Summon
	local e2=bbts.krana_summon(c)
	c:RegisterEffect(e2)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  for i=1,ev-1 do
    local ce=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
    if ce:IsActiveType(TYPE_MONSTER) and ce:GetHandler():IsSetCard(0xb08) then
      return true
    end
  end
  return false
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Group.CreateGroup()
  for i=1,ev do
    local ce=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
    local tc=ce:GetHandler()
    if tc:IsRelateToEffect(ce) and tc:IsFaceup() and tc:IsLocation(LOCATION_ONFIELD) and not tc:IsSetCard(0xb08) and Duel.IsChainDisablable(i) then
      g:AddCard(ce:GetHandler())
    end
  end
  if chk==0 then return g:GetCount()>0 end
  Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  for i=1,ev do
    local ce=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
    local tc=ce:GetHandler()
    if tc:IsRelateToEffect(ce) and tc:IsFaceup() and tc:IsLocation(LOCATION_ONFIELD) and not tc:IsSetCard(0xb08) and Duel.IsChainDisablable(i) then
      Duel.NegateRelatedChain(tc,RESET_TURN_SET)
      local e1=Effect.CreateEffect(c)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_DISABLE)
      e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e1)
      local e2=Effect.CreateEffect(c)
      e2:SetType(EFFECT_TYPE_SINGLE)
      e2:SetCode(EFFECT_DISABLE_EFFECT)
      e2:SetValue(RESET_TURN_SET)
      e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e2)
    end
  end
end