--Nuva Cube
local s,id=GetID()
function s.initial_effect(c)
  --Activate
  local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
  --Cannot target
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_SZONE)
  e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e1:SetCondition(s.condition1)
  e1:SetValue(aux.tgoval)
  c:RegisterEffect(e1)
  --Shuffle
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetRange(LOCATION_SZONE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1)
  c:RegisterEffect(e2)
end
function s.filter1(c)
  return c:IsSetCard(0xb0c) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(s.filter1,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
function s.filter2a(c,e)
  return c:IsSetCard(0xb0c) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
    and not c:IsFacedown() --Checking for face-up would exclude those in GY
end
function s.filter2b(c,tp)
  return c:IsSetCard(0xb0c) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.filter2c(c)
  return c:IsFaceup() and c:IsAbleToDeck()
end
function s.filter2d(c,e,tp)
  return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local g=Duel.GetMatchingGroup(s.filter2a,tp,LOCATION_SZONE+LOCATION_GRAVE,LOCATION_GRAVE,nil,e)
  if chkc then return false end
  if chk==0 then return #g>0 end
  local tg=aux.SelectUnselectGroup(g,e,tp,1,6,aux.dncheck,1,tp,HINTMSG_TODECK)
  Duel.SetTargetCard(tg)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,0,0)
  Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
  Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_REMOVED)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
    local tg=Duel.GetTargetCards(e)
    local ct=Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    if ct>0 and Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_DECK,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
      and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
      Duel.BreakEffect()
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
      local g1=Duel.SelectMatchingCard(tp,s.filter2b,tp,LOCATION_DECK,0,1,1,nil,tp)
      if #g1>0 then
        Duel.MoveToField(g1:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
      end
    end
    if ct>2 and Duel.IsExistingMatchingCard(Card.IsNegatableSpellTrap,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
      Duel.BreakEffect()
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
      local nc=Duel.SelectMatchingCard(tp,Card.IsNegatableSpellTrap,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c):GetFirst()
      Duel.NegateRelatedChain(nc,RESET_TURN_SET)
      local e1=Effect.CreateEffect(c)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_DISABLE)
      e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
      nc:RegisterEffect(e1)
      local e2=e1:Clone()
      e2:SetCode(EFFECT_DISABLE_EFFECT)
      e2:SetValue(RESET_TURN_SET)
      nc:RegisterEffect(e2)
      if nc:IsType(TYPE_TRAPMONSTER) then
        local e3=e1:Clone()
        e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
        nc:RegisterEffect(e3)
      end
    end
    if ct==6 and Duel.IsExistingMatchingCard(s.filter2d,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
      and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
      Duel.BreakEffect()
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      local g3=Duel.SelectMatchingCard(tp,s.filter2d,tp,LOCATION_REMOVED,0,1,math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),2),nil,e,tp)
      if #g3>0 then
        Duel.SpecialSummon(g3,0,tp,tp,false,false,POS_FACEUP)
      end
    end
  end
end