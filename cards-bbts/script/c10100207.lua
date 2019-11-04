if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Krana Xa, Swarm Commander
function c10100207.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAINING)
  e1:SetCost(c10100207.cost1)
  e1:SetCondition(c10100207.condition1)
  e1:SetTarget(c10100207.target1)
	e1:SetOperation(c10100207.operation1)
	e1:SetCountLimit(1,10100207)
	c:RegisterEffect(e1)
	--Summon
	local e2=bbts.krana_summon(c)
	c:RegisterEffect(e2)
end
function c10100207.filter1(c)
  return c:IsSetCard(0x15c) and c:IsType(TYPE_MONSTER)
end
function c10100207.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c10100207.condition1(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
  for i=1,ev-1 do
    local ce=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
    if c10100207.filter1(ce:GetHandler()) then
      return true
    end
  end
  return false
end
function c10100207.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Group.CreateGroup()
  for i=1,ev do
    local ce=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
    local tc=ce:GetHandler()
    if tc:IsRelateToEffect(ce) and tc:IsFaceup() and Duel.IsChainDisablable(i) then
      g:AddCard(ce:GetHandler())
    end
  end
  if chk==0 then return g:GetCount()>0 end
  Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c10100207.operation1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  for i=1,ev do
    local ce=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
    local tc=ce:GetHandler()
    if tc:IsRelateToEffect(ce) and tc:IsFaceup() and Duel.IsChainDisablable(i) then
      Duel.NegateRelatedChain(tc,RESET_TURN_SET)
      local e1=Effect.CreateEffect(c)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_DISABLE)
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e1)
      local e2=Effect.CreateEffect(c)
      e2:SetType(EFFECT_TYPE_SINGLE)
      e2:SetCode(EFFECT_DISABLE_EFFECT)
      e2:SetValue(RESET_TURN_SET)
      e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e2)
      end
  end
end