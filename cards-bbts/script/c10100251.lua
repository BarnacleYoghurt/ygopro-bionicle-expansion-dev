--Exo Armaments
function c10100251.initial_effect(c)
  --Search
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c10100251.target1)
  e1:SetOperation(c10100251.operation1)
  c:RegisterEffect(e1)
end
function c10100251.filter1(c)
  return c:IsCode(10100250) and c:IsAbleToHand()
end
function c10100251.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c10100251.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  local g=Duel.GetMatchingGroup(c10100251.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10100251.operation1(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.SelectMatchingCard(tp,c10100251.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
