--Empty Bohrok Shell
function c10100248.initial_effect(c)
  --Search
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetCost(c10100248.cost1)
  e1:SetTarget(c10100248.target1)
  e1:SetOperation(c10100248.operation1)
  e1:SetCountLimit(1)
  c:RegisterEffect(e1)
  --Destroy
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e2:SetCode(EVENT_REMOVE)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetTarget(c10100248.target2)
  e2:SetOperation(c10100248.operation2)
  c:RegisterEffect(e2)
end
function c10100248.filter1(c)
  return c:IsSetCard(0x157) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToHand()
end
function c10100248.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return e:GetHandler():IsAbleToGraveAsCost()
  end
  Duel.SendtoGrave(e:GetHandler(), REASON_COST)
end
function c10100248.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.IsExistingMatchingCard(c10100248.filter1,tp,LOCATION_DECK,0,1,nil)
  end
  local g=Duel.GetMatchingGroup(c10100248.filter1,tp,LOCATION_DECK,0,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10100248.operation1(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.SelectMatchingCard(tp,c10100248.filter1,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
  end
end
function c10100248.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
  end
  local tc=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c10100248.operation2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
    Duel.Destroy(tc,REASON_EFFECT)
  end
end
