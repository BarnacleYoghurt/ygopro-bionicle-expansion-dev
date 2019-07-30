--The End of the Swarm
function c10100255.initial_effect(c)
  --Banish
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetDescription(aux.Stringid(10100255,0))
  e1:SetCondition(c10100255.condition)
  e1:SetTarget(c10100255.target1)
  e1:SetOperation(c10100255.operation1)
  c:RegisterEffect(e1)
  --To Deck
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_ACTIVATE)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetDescription(aux.Stringid(10100255,1))
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
  if chk==0 then
    return Duel.IsExistingMatchingCard(c10100255.filter1,tp,LOCATION_MZONE,0,1,nil)
  end
  local tc=Duel.SelectTarget(tp,c10100255.filter1,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c10100255.operation1(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY) then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      e1:SetCode(EVENT_PHASE+PHASE_END)
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      e1:SetLabelObject(tc)
      e1:SetLabel(Duel.GetTurnCount())
      e1:SetCountLimit(1)
      e1:SetCondition(c10100255.condition1_1)
      e1:SetOperation(c10100255.operation1_1)
      Duel.RegisterEffect(e1,tp)
    end
  end
end
function c10100255.filter1_1(c)
  return bit.band(c:GetType(),TYPE_SPELL+TYPE_CONTINUOUS)==TYPE_SPELL+TYPE_CONTINUOUS and c:IsAbleToHand()
end
function c10100255.condition1_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()
end
function c10100255.operation1_1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.ReturnToField(e:GetLabelObject()) and Duel.SelectYesNo(tp,aux.Stringid(10100255,2)) then
    local g=Duel.SelectMatchingCard(tp,c10100255.filter1_1,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
  end
end
function c10100255.filter2a(c)
  return c:IsFaceup() and c:IsLevelAbove(8)
end
function c10100255.filter2b(c)
  return c:IsFacedown() and c:IsAbleToDeck()
end
function c10100255.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.IsExistingMatchingCard(c10100255.filter2a,tp,LOCATION_MZONE,0,1,nil)
      and Duel.IsExistingMatchingCard(c10100255.filter2b,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
  end
  local g=Duel.GetMatchingGroup(c10100255.filter2b,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,Duel.GetMatchingGroupCount(c10100255.filter2a,tp,LOCATION_MZONE,0,nil),0,0)
end
function c10100255.operation2(e,tp,eg,ep,ev,re,r,rp)
  local max=Duel.GetMatchingGroupCount(c10100255.filter2a,tp,LOCATION_MZONE,0,nil)
  local g=Duel.SelectMatchingCard(tp,c10100255.filter2b,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,max,nil)
  if g:GetCount()>0 then
    if Duel.SendtoDeck(g,nil,2,REASON_EFFECT) then
      local og=Duel.GetOperatedGroup()
      local mct=og:FilterCount(Card.IsPreviousLocation,nil,LOCATION_MZONE)
      if mct>0 then
        Duel.BreakEffect()
        Duel.Damage(1-tp,1000*mct,REASON_EFFECT)
      end
    end
  end
end