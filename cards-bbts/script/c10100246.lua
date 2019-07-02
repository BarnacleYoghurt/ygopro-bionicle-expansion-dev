--Matoran Tender Kotu
function c10100246.initial_effect(c)
  --ATK down
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetRange(LOCATION_MZONE)
  e1:SetTargetRange(0,LOCATION_MZONE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetCondition(c10100246.condition1)
  e1:SetValue(-800)
  c:RegisterEffect(e1)
  --To hand
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_SUMMON_SUCCESS)
  e2:SetTarget(c10100246.target2)
  e2:SetOperation(c10100246.operation2)
  e2:SetCountLimit(1,10100246)
  c:RegisterEffect(e2)
end
function c10100246.condition1(e)
  local ph=Duel.GetCurrentPhase()
  return ph >= PHASE_BATTLE_START and ph <= PHASE_BATTLE
end
function c10100246.filter2(c)
  return Duel.IsPlayerCanDraw(c:GetOwner(),1)
end
function c10100246.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.IsExistingTarget(c10100246.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
  end
  local tc=Duel.SelectTarget(tp,c10100246.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tc:GetFirst():GetOwner(),1)
  if tc:IsExists(Card.IsAbleToHand,1,nil) then
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,nil)
  end
end
function c10100246.operation2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
    if Duel.Draw(tc:GetOwner(),1,REASON_EFFECT) then
      Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
  end
end

