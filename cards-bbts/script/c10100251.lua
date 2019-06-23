--Exo Armaments
function c10100251.initial_effect(c)
  --Search
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c10100251.target1)
  e1:SetOperation(c10100251.operation1)
  c:RegisterEffect(e1)
  --Armaments
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCondition(aux.exccon)
  e2:SetCost(c10100251.cost2)
  e2:SetTarget(c10100251.target2)
  e2:SetOperation(c10100251.operation2)
  e2:SetCountLimit(1,10100251)
  c:RegisterEffect(e2)
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
function c10100251.filter2a(c)
  return c:IsFaceup() and c:IsCode(10100250)
end
function c10100251.filter2b(c,seq)
  return c:IsDestructable() and c:GetSequence()==seq
end
function c10100251.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToRemoveAsCost() end
  Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c10100251.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingTarget(c10100251.filter2a,tp,LOCATION_ONFIELD,0,1,nil) end
  local g=Duel.SelectTarget(tp,c10100251.filter2a,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c10100251.operation2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    local op=0
    if tc:IsLocation(LOCATION_MZONE) and Duel.IsExistingMatchingCard(c10100251.filter2b,tp,0,LOCATION_ONFIELD,1,nil,4-tc:GetSequence()) then
      op = Duel.SelectOption(tp,aux.Stringid(10100251,2),aux.Stringid(10100251,3),aux.Stringid(10100251,4))
    elseif tc:IsLocation(LOCATION_MZONE) then
      op = Duel.SelectOption(tp,aux.Stringid(10100251,2),aux.Stringid(10100251,3))
    elseif Duel.IsExistingMatchingCard(c10100251.filter2b,tp,0,LOCATION_ONFIELD,1,nil,4-tc:GetSequence()) then
      op = Duel.SelectOption(tp,aux.Stringid(10100251,3),aux.Stringid(10100251,4)) + 1
    else
      op = Duel.SelectOption(tp,aux.Stringid(10100251,3)) + 1
    end
    if op==0 then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_FIELD)
      e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
      e1:SetCode(EFFECT_CANNOT_ACTIVATE)
      e1:SetRange(LOCATION_MZONE)
      e1:SetTargetRange(0,1)
      e1:SetCondition(c10100251.condition2_1)
      e1:SetValue(c10100251.value2_1)
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e1)
    elseif op==1 then
      local e2=Effect.CreateEffect(e:GetHandler())
      e2:SetType(EFFECT_TYPE_SINGLE)
      e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
      e2:SetValue(1)
      e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e2)
    else
      local g=Duel.SelectMatchingCard(tp,c10100251.filter2b,tp,0,LOCATION_ONFIELD,1,1,nil,4-tc:GetSequence())
      if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
      end
    end
  end
end
function c10100251.condition2_1(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c10100251.value2_1(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end