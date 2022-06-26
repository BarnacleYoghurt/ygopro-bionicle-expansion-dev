--Matoran Astrologer Nixie
local s,id=GetID()
function s.initial_effect(c)
  --Draw + SS
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_LVCHANGE)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
  e1:SetRange(LOCATION_HAND)
  e1:SetCode(EVENT_CHAINING)
  e1:SetCondition(s.condition1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --Send S/T
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_TOGRAVE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,{id,1})
  c:RegisterEffect(e2)
end
function s.filter1(c)
  return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  return re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then 
    return Duel.IsPlayerCanDraw(tp,1) 
      and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
      and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
  end
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.Draw(tp,1,REASON_EFFECT)>0 then
    local c=e:GetHandler()
    local tc=Duel.GetOperatedGroup():GetFirst()
    Duel.ConfirmCards(1-tp,tc)
    if c:IsRelateToEffect(e) then
      if tc:IsType(TYPE_MONSTER) then
        if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
          local e1=Effect.CreateEffect(c)
          e1:SetType(EFFECT_TYPE_SINGLE)
          e1:SetRange(LOCATION_MZONE)
          e1:SetCode(EFFECT_CHANGE_LEVEL)
          e1:SetValue(tc:GetLevel())
          e1:SetReset(RESET_EVENT+RESETS_STANDARD)
          c:RegisterEffect(e1)
        end
        Duel.SpecialSummonComplete()
      else
        Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD)
      end
    end
  end
end
function s.filter2(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil)
      and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_SPELL+TYPE_TRAP) --has to be checked in target because condition runs mid-chain 
  end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoGrave(g,REASON_EFFECT)
  end
end

