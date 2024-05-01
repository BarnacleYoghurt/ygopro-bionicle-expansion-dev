--Bohrok-Kal Strategy
local s,id=GetID()
function s.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetOperation(s.operation1)
  c:RegisterEffect(e1)
  --Search or destroy
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id)
  c:RegisterEffect(e2)
end
function s.filter1(c,e,tp)
  return c:IsSetCard(0xb08) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
    if Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
      if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
      end
    end
  end
end
function s.filter2a(c,tp)
  return c:IsFaceup() and c:IsSummonPlayer(tp) and c:IsSetCard(0xb08)
end
function s.filter2b(c)
  return c:IsSetCard(0xb08) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(id)
end
function s.filter2c(c)
  return c:IsFaceup() and c:IsSetCard(0xb08) and c:IsType(TYPE_XYZ)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(s.filter2a,1,nil,tp)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local c=e:GetHandler()
  if chkc then return e:GetLabel()~=2 and chkc:IsType(TYPE_SPELL+TYPE_TRAP) and chkc~=c end
  local b1=Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,TYPE_SPELL+TYPE_TRAP)
  local b2=Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_DECK,0,1,nil)
  local bkal=eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_XYZ)
  if chk==0 then return b1 or b2 end
  local op=Duel.SelectEffect(tp,
    {b1,aux.Stringid(id,2)},
    {b2,aux.Stringid(id,3)},
    {b1 and b2 and bkal,aux.Stringid(id,4)})
  e:SetLabel(op)
  
  if op~=2 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,TYPE_SPELL+TYPE_TRAP)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
  end
  if op~=1 then
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
  end
  e:SetCategory((op~=2 and CATEGORY_DESTROY or 0)+(op~=1 and CATEGORY_SEARCH+CATEGORY_TOHAND or 0))
  e:SetProperty(EFFECT_FLAG_DELAY+(op~=2 and EFFECT_FLAG_CARD_TARGET or 0))
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local op=e:GetLabel()
  if op~=2 then
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
      Duel.Destroy(tc,REASON_EFFECT)
    end
  end
  if op~=1 then
    if op==3 then Duel.BreakEffect() end --in sequence
    local g=Duel.SelectMatchingCard(tp,s.filter2b,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
      Duel.SendtoHand(g,tp,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  end
end