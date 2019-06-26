--Matoran of The Swarm
function c10100243.initial_effect(c)
  --Attach from GY
  local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_FLIP)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c10100243.condition1)
	e1:SetOperation(c10100243.operation1)
	c:RegisterEffect(e1)
  --Attach from hand
  local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c10100243.cost2)
	e2:SetTarget(c10100243.target2)
	e2:SetOperation(c10100243.operation2)
	c:RegisterEffect(e2)
end
function c10100243.condition1(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()==0 then return false end
  local fc=eg:GetFirst()
  return fc:IsType(TYPE_XYZ) and rp==tp
end
function c10100243.operation1(e,tp,eg,ep,ev,re,r,rp)
  if eg:GetCount()>0 then
    local c=e:GetHandler()
    local tc=eg:GetFirst()
    if c:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
      Duel.Overlay(tc,Group.FromCards(c))
    end
  end
end
function c10100243.filter2a(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x15d) and c:IsAbleToGraveAsCost()
end
function c10100243.filter2b(c)
  return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c10100243.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100243.filter2a,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c10100243.filter2a,tp,LOCATION_DECK,0,1,1,nil)
  Duel.SendtoGrave(g, REASON_COST)
end
function c10100243.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.IsExistingTarget(c10100243.filter2b,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10100243.filter2b,tp,0,LOCATION_MZONE,1,1,nil)
end
function c10100243.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
    Duel.Overlay(tc,Group.FromCards(c))
    local e1=Effect.CreateEffect(tc)
    e1:SetRange(RANGE_MZONE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK_FINAL)
    e1:SetValue(0)
    e1:SetCondition(c10100243.condition2_1)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e1,true)
    local e1b=e1:Clone()
    e1b:SetCode(EFFECT_SET_DEFENSE_FINAL)
    tc:RegisterEffect(e1b,true)
    if not tc:IsType(TYPE_EFFECT) then
      local e2=Effect.CreateEffect(c)
      e2:SetType(EFFECT_TYPE_SINGLE)
      e2:SetCode(EFFECT_CHANGE_TYPE)
      e2:SetValue(tc:GetType()+TYPE_EFFECT)
      e2:SetReset(RESET_EVENT+0x1fe0000)
      tc:RegisterEffect(e2)
    end
  end
end
function c10100243.condition2_1(e)
	local ph=Duel.GetCurrentPhase()
	local bc=e:GetHandler():GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and bc and bc:IsSetCard(0x15c)
end