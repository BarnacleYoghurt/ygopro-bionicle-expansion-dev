BPEV={}
bpev=BPEV
--Toa Nuva
function BPEV.toa_nuva_search(baseC)
  local function filter(c)
    return c:IsSetCard(0xb0c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
  end
  local function condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
  end
  local function target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
  end
  local function operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
      local og=Duel.GetOperatedGroup()
      if og:FilterCount(Card.IsLocation,nil,LOCATION_HAND)>0 then
        Duel.ConfirmCards(1-tp,g)
        Duel.BreakEffect()
        Duel.ShuffleHand(tp)
        Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
      end
    end
  end
  
  local e=Effect.CreateEffect(baseC)
  e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
  e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e:SetProperty(EFFECT_FLAG_DELAY)
  e:SetCode(EVENT_SPSUMMON_SUCCESS)
  e:SetCondition(condition)
  e:SetTarget(target)
  e:SetOperation(operation)
  return e
end
--Kanohi Nuva
function BPEV.kanohi_nuva_search(baseC)
  local function filterA(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
  end
  local function filterB(c,tp)
    return c:IsSetCard(0xb0c) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
  end
  local function cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(filterA,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,filterA,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
  end
  local function target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
      return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(filterB,tp,LOCATION_DECK,0,1,nil,tp)
    end
  end
  local function operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
      local g=Duel.SelectMatchingCard(tp,filterB,tp,LOCATION_DECK,0,1,1,nil,tp)
      if #g>0 then
        Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
      end
    end
  end
  
  local e=Effect.CreateEffect(baseC)
  e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e:SetProperty(EFFECT_FLAG_DELAY)
  e:SetCode(EVENT_TO_GRAVE)
  e:SetCost(cost)
  e:SetTarget(target)
  e:SetOperation(operation)
  return e
end
--Nuva Symbols
function BPEV.nuva_symbol_search(baseC,targetCode)
  local function filter(c)
    return (c:IsSetCard(0xb0b) or c:IsCode(targetCode)) and c:IsAbleToHand()
  end
  local function cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToDeckAsCost() end
    Duel.SendtoDeck(c,nil,LOCATION_DECKBOT,REASON_COST)
  end
  local function target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
  end
  local function operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,filter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  end
  
  local e=Effect.CreateEffect(baseC)
  e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
  e:SetType(EFFECT_TYPE_IGNITION)
  e:SetRange(LOCATION_SZONE)
  e:SetCost(cost)
  e:SetTarget(target)
  e:SetOperation(operation)
  return e
end
function BPEV.nuva_symbol_punish(baseC,targetCode,punish)
  local function condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsFaceup() and not e:GetHandler():IsLocation(LOCATION_DECK)
  end
  local function target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsFaceup() and chkc:IsCode(targetCode) end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,aux.FaceupFilter(Card.IsCode,targetCode),tp,LOCATION_ONFIELD,0,1,1,nil)
    if #g>0 then
      Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
    end
  end
  local function operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel:GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
      Duel.NegateRelatedChain(tc,RESET_TURN_SET)
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_DISABLE)
      e1:SetReset(RESET_EVENT+RESETS_STANDARD)
      tc:RegisterEffect(e1)
      local e2=Effect.CreateEffect(e:GetHandler())
      e2:SetType(EFFECT_TYPE_SINGLE)
      e2:SetCode(EFFECT_DISABLE_EFFECT)
      e2:SetValue(RESET_TURN_SET)
      e2:SetReset(RESET_EVENT+RESETS_STANDARD)
      tc:RegisterEffect(e2)
      if (not tc:IsImmuneToEffect(e1)) and (not tc:IsImmuneToEffect(e2)) then
        punish(e,tp,eg,ep,ev,re,r,rp)
      end
    end
  end
  
  local e=Effect.CreateEffect(baseC)
  e:SetCategory(CATEGORY_REMOVE)
  e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e:SetCode(EVENT_LEAVE_FIELD)
  e:SetCondition(condition)
  e:SetTarget(target)
  e:SetOperation(operation)
  return e
end