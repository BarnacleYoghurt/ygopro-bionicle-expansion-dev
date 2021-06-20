--Matoran of The Swarm
local s,id=GetID()
function s.initial_effect(c)
  --Attach from GY
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_FLIP)
	e1:SetCondition(s.condition1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
  --Attach from hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()==0 then return false end
  local fc=eg:GetFirst()
  return fc:IsType(TYPE_XYZ) and fc:IsControler(tp)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  if eg:GetCount()>0 then
    local c=e:GetHandler()
    local tc=eg:GetFirst()
    if c:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
      Duel.Overlay(tc,Group.FromCards(c))
    end
  end
end
function s.filter2a(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb09) and c:IsAbleToGraveAsCost()
end
function s.filter2b(c)
  return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter2a,tp,LOCATION_DECK,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.IsExistingTarget(s.filter2b,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter2b,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
    Duel.Overlay(tc,Group.FromCards(c))
    local e1=Effect.CreateEffect(tc)
    e1:SetDescription(aux.Stringid(id,2))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_SET_ATTACK_FINAL)
    e1:SetCondition(s.condition2_1)
    e1:SetValue(0)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    tc:RegisterEffect(e1,true)
    local e1b=e1:Clone()
    e1b:SetCode(EFFECT_SET_DEFENSE_FINAL)
    tc:RegisterEffect(e1b,true)
    if not tc:IsType(TYPE_EFFECT) then
      local e2=Effect.CreateEffect(c)
      e2:SetType(EFFECT_TYPE_SINGLE)
      e2:SetCode(EFFECT_CHANGE_TYPE)
      e2:SetValue(tc:GetType()+TYPE_EFFECT)
      e2:SetReset(RESET_EVENT+RESETS_STANDARD)
      tc:RegisterEffect(e2)
    end
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_TRIGGER)
    e3:SetReset(RESET_EVENT+RESETS_STANDARD)
    tc:RegisterEffect(e3)
  end
end
function s.condition2_1(e)
	local ph=Duel.GetCurrentPhase()
	local bc=e:GetHandler():GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and bc and bc:IsSetCard(0xb08)
end