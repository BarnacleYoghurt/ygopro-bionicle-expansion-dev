--Premature Bohrok Beacon
function c10100257.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c10100257.target1)
  e1:SetOperation(c10100257.operation1)
  c:RegisterEffect(e1)
end
function c10100257.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.IsExistingTarget(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEDOWN_DEFENSE)
  end
  local g=Duel.SelectTarget(tp,Card.IsPosition,tp,LOCATION_MZONE,0,1,1,nil,POS_FACEDOWN_DEFENSE)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c10100257.operation1(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
  end
end
