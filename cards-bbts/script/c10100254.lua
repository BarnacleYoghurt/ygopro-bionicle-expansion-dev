--Toa Seal
function c10100254.initial_effect(c)
  --Seal
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(10100254,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCondition(c10100254.condition1)
  e1:SetTarget(c10100254.target1)
  e1:SetOperation(c10100254.operation1)
  e1:SetCountLimit(1,10100254)
  c:RegisterEffect(e1)
end
function c10100254.filter1a(c)
  return c:IsFaceup() and c:IsSetCard(0x155)
end
function c10100254.filter1b(c,g)
  return c:IsSetCard(0x155) and c:IsAbleToRemove() and not g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function c10100254.condition1(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetMatchingGroup(c10100254.filter1a,tp,LOCATION_MZONE,0,nil):GetClassCount(Card.GetCode)>=4
end
function c10100254.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
  end
  local t=Duel.GetMatchingGroup(c10100254.filter1a,tp,LOCATION_MZONE,0,nil)
  local g0=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g0,g0:GetCount(),0,0)
  if Duel.IsExistingTarget(c10100254.filter1b,tp,LOCATION_GRAVE,0,1,nil,t) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(10100254,1)) then
    local t1=Duel.SelectTarget(tp,c10100254.filter1b,tp,LOCATION_GRAVE,0,1,1,nil,t)
    t:Merge(t1)
    local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,t1,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
  end
  if Duel.IsExistingTarget(c10100254.filter1b,tp,LOCATION_HAND,0,1,nil,t) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(10100254,2))  then
    local t1=Duel.SelectTarget(tp,c10100254.filter1b,tp,LOCATION_HAND,0,1,1,nil,t)
    local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,t1,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
  end
end
function c10100254.operation1(e,tp,eg,ep,ev,re,r,rp)
  local g0=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
  if Duel.Remove(g0,POS_FACEUP,REASON_EFFECT) then
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if tg then
      Duel.BreakEffect()
      if tg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
        local tc1=tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetFirst()
        if Duel.Remove(tc1,POS_FACEUP,REASON_EFFECT) then
          local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
          Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
        end
      end
      if tg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
        local tc2=tg:Filter(Card.IsLocation,nil,LOCATION_HAND):GetFirst()
        if Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT) then
          local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
          Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
        end
      end
    end
  end
end
      
      

