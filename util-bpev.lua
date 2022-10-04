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