--The End of the Swarm
function c10100255.initial_effect(c)
  --Banish
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_REMOVE)
  e1:SetDescription(aux.Stringid(10100255,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCondition(c10100255.condition)
  e1:SetTarget(c10100255.target1)
  e1:SetOperation(c10100255.operation1)
  c:RegisterEffect(e1)
  --Flip
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_POSITION)
  e2:SetDescription(aux.Stringid(10100255,1))
  e2:SetType(EFFECT_TYPE_ACTIVATE)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetCondition(c10100255.condition)
  e2:SetTarget(c10100255.target2)
  e2:SetOperation(c10100255.operation2)
  c:RegisterEffect(e2)
end
function c10100255.filter(c)
  return c:IsFaceup() and c:IsSetCard(0x155)
end
function c10100255.condition(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c10100255.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c10100255.filter1(c)
  return c:IsFaceup() and c:IsLevelAbove(8) and c:IsAbleToRemove()
end
function c10100255.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingTarget(c10100255.filter1,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectTarget(tp,c10100255.filter1,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c10100255.operation1(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and c10100255.filter1(tc) then
    if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      e1:SetCode(EVENT_PHASE+PHASE_END)
      e1:SetCondition(c10100255.condition1_1)
      e1:SetOperation(c10100255.operation1_1)
      e1:SetLabel(Duel.GetTurnCount())
      e1:SetLabelObject(tc)
      e1:SetCountLimit(1)
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      Duel.RegisterEffect(e1,tp)
    end
  end
end
function c10100255.filter1_1(c)
  return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand()
end
function c10100255.condition1_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()
end
function c10100255.operation1_1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.ReturnToField(e:GetLabelObject()) and Duel.SelectYesNo(tp,aux.Stringid(10100255,2)) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c10100255.filter1_1,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
  end
end
function c10100255.filter2(c)
  return c:IsFaceup() and c:IsLevelAbove(8)
end
function c10100255.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.IsExistingMatchingCard(c10100255.filter2,tp,LOCATION_MZONE,0,1,nil)
      and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
  end
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g,Duel.GetMatchingGroupCount(c10100255.filter2,tp,LOCATION_MZONE,0,nil),0,0)
end
function c10100255.operation2(e,tp,eg,ep,ev,re,r,rp)
  local max=Duel.GetMatchingGroupCount(c10100255.filter2,tp,LOCATION_MZONE,0,nil)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
  local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,max,nil)
  if g:GetCount()>0 then
    if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)>0 then
      local og=Duel.GetOperatedGroup()
      local tc=og:GetFirst()
      while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        tc:RegisterFlagEffect(10100255,RESET_EVENT+0x1fe0000,0,1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCode(EVENT_BATTLE_START)
        e2:SetCondition(c10100255.condition2_2)
        e2:SetOperation(c10100255.operation2_2)
        e2:SetLabelObject(tc)
        Duel.RegisterEffect(e2,tp)
        tc=og:GetNext()
      end
    end
  end
end
function c10100255.condition2_2(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  local at=Duel.GetAttackTarget()
  return at and at==tc and tc:GetFlagEffect(10100255)~=0
end
function c10100255.operation2_2(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  if Duel.SendtoGrave(tc,REASON_EFFECT)>0 then
    Duel.BreakEffect()
    Duel.Damage(1-tp,1000,REASON_EFFECT)
    e:Reset()
  end
end