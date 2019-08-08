--Queens' Illusion
function c10100252.initial_effect(c)
  --Summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCondition(c10100252.condition1)
  e1:SetTarget(c10100252.target1)
  e1:SetOperation(c10100252.operation1)
  c:RegisterEffect(e1)
  --Replace
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_PHASE+PHASE_END)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCondition(c10100252.condition2)
  e2:SetTarget(c10100252.target2)
  e2:SetOperation(c10100252.operation2)
  e2:SetCountLimit(1)
  --c:RegisterEffect(e2)
end
function c10100252.filter1a(c)
  return c:IsFaceup() and c:IsSetCard(0x15e)
end
function c10100252.filter1b(c,e,tp)
  return c:IsSetCard(0x15e) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false)
end
function c10100252.condition1(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c10100252.filter1a,tp,LOCATION_ONFIELD,0,1,nil)
end
function c10100252.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10100252.filter1b,tp,LOCATION_EXTRA,0,1,nil,e,tp)
  end
  local g=Duel.GetMatchingGroup(c10100252.filter1b,tp,LOCATION_EXTRA,0,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10100252.operation1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=Duel.SelectMatchingCard(tp,c10100252.filter1b,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    if Duel.SpecialSummon(g,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP) then
      local sc=g:GetFirst()
      local e1=Effect.CreateEffect(c)
      e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_SET_ATTACK)
      e1:SetValue(0)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      sc:RegisterEffect(e1)
      local e2=Effect.CreateEffect(c)
      e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
      e2:SetType(EFFECT_TYPE_SINGLE)
      e2:SetCode(EFFECT_DISABLE)
      e2:SetReset(RESET_EVENT+0x1fe0000)
      sc:RegisterEffect(e2)
      local e3=Effect.CreateEffect(c)
      e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
      e3:SetRange(LOCATION_MZONE)
      e3:SetCode(EVENT_PHASE+PHASE_END)
      e3:SetOperation(c10100252.operation1_3)
      e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      e3:SetCountLimit(1)
      sc:RegisterEffect(e3)
    end
  end
end
function c10100252.operation1_3(e,tp,eg,ep,ev,re,r,rp)
  Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function c10100252.filter2(c)
  return c:IsCode(10100252) and c:IsAbleToHand()
end
function c10100252.condition2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:GetTurnID()==Duel.GetTurnCount() and c:IsPreviousLocation(LOCATION_ONFIELD) and Duel.IsExistingMatchingCard(c10100252.filter1a,tp,LOCATION_ONFIELD,0,1,nil)
end
function c10100252.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.IsExistingMatchingCard(c10100252.filter2,tp,LOCATION_DECK,0,1,nil)
  end
  local g=Duel.GetMatchingGroup(c10100252.filter2,tp,LOCATION_DECK,0,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10100252.operation2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstMatchingCard(c10100252.filter2,tp,LOCATION_DECK,0,nil)
  Duel.SendtoHand(tc,nil,REASON_EFFECT)
end