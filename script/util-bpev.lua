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
function BPEV.toa_nuva_kaita_search(baseC)
  local function filter(c)
    return c:IsSetCard(0xb0c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
  end
  local function target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
  end
  local function operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
  end
  
  local e=Effect.CreateEffect(baseC)
  e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
  e:SetType(EFFECT_TYPE_IGNITION)
  e:SetProperty(EFFECT_FLAG_DELAY)
  e:SetRange(LOCATION_MZONE)
  e:SetCost(aux.dxmcostgen(1,1))
  e:SetTarget(target)
  e:SetOperation(operation)
  return e
end
--Kanohi Nuva
function BPEV.kanohi_nuva_search_spell(baseC,aoetg,aoeop,id)
  return bpev.kanohi_nuva_search(baseC,aoetg,aoeop,id,
    function (c,tp)
      return c:IsSetCard(0xb0c) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
    end,
    function (g,tp) Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true) end,
    HINTMSG_TOFIELD
  )
end
function BPEV.kanohi_nuva_search_trap(baseC,aoetg,aoeop,id)
  return bpev.kanohi_nuva_search(baseC,aoetg,aoeop,id,
    function (c,tp)
      return c:IsSetCard(0xb0c) and c:IsType(TYPE_TRAP) and c:IsSSetable()
    end,
    function (g,tp) Duel.SSet(tp,g) end,
    HINTMSG_SET
  )
end
function BPEV.kanohi_nuva_search(baseC,aoetg,aoeop,id,searchfilter,searchop,hintmsg)
  local function filterA(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
  end
  local function filterB(c)
    return c:IsFaceup() and c:IsSetCard(0x3b02)
  end
  local function cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
      return Duel.IsExistingMatchingCard(filterA,tp,LOCATION_GRAVE,0,1,nil) and
        Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0 --need to check in cost so it updates after every trigger
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,filterA,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
  end
  local function target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
      return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(searchfilter,tp,LOCATION_DECK,0,1,nil,tp)
        and (not aoetg or aoetg(e,tp,eg,ep,ev,re,r,rp,chk))
    end
    if aoetg then aoetg(e,tp,eg,ep,ev,re,r,rp,chk) end
  end
  local function operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
      Duel.Hint(HINT_SELECTMSG,tp,hintmsg)
      local g=Duel.SelectMatchingCard(tp,searchfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
      if #g>0 then
        searchop(g,tp)
      end
    end
    
    if aoeop and Duel.IsExistingMatchingCard(filterB,tp,LOCATION_MZONE,0,1,1,nil) then
      aoeop(e,tp,eg,ep,ev,re,r,rp)
    end
  end
  local function chainfilter(re,tp,cid)
    local loc=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)
    return not (re:IsActiveType(TYPE_SPELL) and re:IsActiveType(TYPE_EQUIP) and loc==LOCATION_GRAVE)
  end
  
  local e=Effect.CreateEffect(baseC)
  e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e:SetProperty(EFFECT_FLAG_DELAY)
  e:SetCode(EVENT_TO_GRAVE)
  e:SetCost(cost)
  e:SetTarget(target)
  e:SetOperation(operation)
  return e,chainfilter
end
--Nuva Symbols
function BPEV.nuva_symbol_search(baseC,targetCode,qStr)
  local function filterA(c)
    return c:IsCode(targetCode) and c:IsAbleToHand()
  end
  local function filterB(c,tp)
    return c:IsCode(targetCode) and not c:IsPublic() and Duel.IsExistingMatchingCard(filterC,tp,LOCATION_DECK,0,1,nil)
  end
  local function filterC(c)
    return c:IsSetCard(0xb0b) and c:IsAbleToHand()
  end
  local function cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToDeckAsCost() end
    Duel.SendtoDeck(c,nil,LOCATION_DECKSHF,REASON_COST)
  end
  local function target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
      return Duel.IsExistingMatchingCard(filterA,tp,LOCATION_DECK,0,1,nil)
        or Duel.IsExistingMatchingCard(filterB,tp,LOCATION_HAND,0,1,nil,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
  end
  local function operation(e,tp,eg,ep,ev,re,r,rp)
    local addFilter=filterA
    if Duel.IsExistingMatchingCard(filterB,tp,LOCATION_HAND,0,1,nil,tp)
    and Duel.IsExistingMatchingCard(filterC,tp,LOCATION_DECK,0,1,nil) then
      if (not Duel.IsExistingMatchingCard(filterA,tp,LOCATION_DECK,0,1,nil)) or Duel.SelectYesNo(tp,qStr) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local rg=Duel.SelectMatchingCard(tp,filterB,tp,LOCATION_HAND,0,1,1,nil,tp)
        Duel.ConfirmCards(1-tp,rg)
        addFilter=filterC
      end
    end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,addFilter,tp,LOCATION_DECK,0,1,1,nil)
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
function BPEV.nuva_symbol_punish(baseC,punish,punishtg)
  local function filter(c)
    return c:IsFaceup() and c:IsSetCard(0x3b02)
  end
  local function condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsFaceup() and not e:GetHandler():IsLocation(LOCATION_DECK)
  end
  local function target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return filter(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
    if chk==0 then return not punishtg or punishtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,filter,tp,LOCATION_MZONE,0,1,1,nil)
    if #g>0 then
      Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
    end
    if punishtg then
      punishtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
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
      if (not tc:IsImmuneToEffect(e1)) and (not tc:IsImmuneToEffect(e2)) and punish then
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
--Bohrok-Kal
function BPEV.bohrok_kal_xmat(baseC)
  local function target(e,c)
    return c:IsLocation(LOCATION_OVERLAY) and e:GetHandler():GetOverlayGroup():IsContains(c)
  end
  
  local e=Effect.CreateEffect(baseC)
	e:SetType(EFFECT_TYPE_FIELD)
  e:SetProperty(EFFECT_FLAG_IGNORE_RANGE) --somehow required to affect Xyz Materials
	e:SetRange(LOCATION_MZONE)
	e:SetTargetRange(0xff,0)
	e:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e:SetTarget(target)
	e:SetValue(LOCATION_DECKBOT)
	return e
end
function BPEV.bohrok_kal_attach(baseC)
  local function filter(c)
    return c:IsSetCard(0xb09) and c:IsType(TYPE_MONSTER)
  end
  local function target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(filter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
  end
  local function operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
      local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(filter),tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
      if #g>0 then
        Duel.Overlay(c,g,true)
      end
    end
  end
  
  local e=Effect.CreateEffect(baseC)
  e:SetType(EFFECT_TYPE_IGNITION)
  e:SetRange(LOCATION_MZONE)
  e:SetTarget(target)
  e:SetOperation(operation)
  return e
end
--Krana-Kal
function BPEV.krana_kal_debuff(baseC,desc)
  local function condition(e)
    local ph=Duel.GetCurrentPhase()
    return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and Duel.GetAttackTarget()
  end
  local function target(e,c)
    local tp=e:GetHandlerPlayer()
    local bc=c:GetBattleTarget()
    return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsControler(1-tp) and bc and bc:IsSetCard(0xb08)
  end
  
  local e1=Effect.CreateEffect(baseC)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetRange(LOCATION_MZONE)
  e1:SetTargetRange(0,LOCATION_MZONE)
  e1:SetCode(EFFECT_SET_ATTACK_FINAL)
  e1:SetCondition(condition)
  e1:SetTarget(target)
  e1:SetValue(0)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
  local e3
  if desc then --Extremly convoluted way of applying the client hint to the affected card
    e3=e1:Clone()
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e3:SetCode(0)
    local e3_inner=Effect.CreateEffect(baseC)
    e3_inner:SetDescription(desc)
    e3_inner:SetType(EFFECT_TYPE_SINGLE)
    e3_inner:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e3:SetLabelObject(e3_inner)
  end
  return e1,e2,e3
end
function BPEV.krana_kal_ssummon(baseC)
  local function filter(c,e,tp)
    return c:IsLevel(4) and c:IsSetCard(0xb08) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_DEFENSE)
  end
  local function cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReleasable() end
    Duel.Release(c,REASON_COST)
  end
  local function target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
      return Duel.GetMZoneCount(tp,e:GetHandler())>0 and Duel.IsExistingMatchingCard(filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp);
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
  end
  local function operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_DEFENSE)>0 then
      --Return it to deck if it leaves the field
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetDescription(3301)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
      e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
      e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
      e1:SetValue(LOCATION_DECKSHF)
      g:GetFirst():RegisterEffect(e1,true)
    end
  end

  local e=Effect.CreateEffect(baseC)
  e:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e:SetType(EFFECT_TYPE_IGNITION)
  e:SetRange(LOCATION_MZONE)
  e:SetCost(cost)
  e:SetTarget(target)
  e:SetOperation(operation)
  return e
end
function BPEV.krana_kal_xsummon(baseC)
  local function filterB(c,e,tp,mc,pg)
    return c:IsSetCard(0xb08) and c:IsType(TYPE_XYZ)
      and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and mc:IsCanBeXyzMaterial(c,tp)
      and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
  end
  local function filterA(c,e,tp)
    local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
    return #(pg-c)==0 and c:IsFaceup() and c:IsSetCard(0xb08) and c:IsLevel(4) and e:GetHandler():GetLinkedGroup():IsContains(c)
      and Duel.IsExistingMatchingCard(filterB,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,pg)
  end
  local function target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and filterA(chkc,e) end
    if chk==0 then return Duel.IsExistingTarget(filterA,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,filterA,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
  end
  local function operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and filterA(tc,e,tp) then
      local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(tc),tp,nil,nil,REASON_XYZ)
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      local g=Duel.SelectMatchingCard(tp,filterB,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,pg)
      local sc=g:GetFirst()
      if sc then
        sc:SetMaterial(tc)
        Duel.Overlay(sc,tc)
        Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
        sc:CompleteProcedure()
      end
    end
  end

  local e=Effect.CreateEffect(baseC)
  e:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e:SetType(EFFECT_TYPE_IGNITION)
  e:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e:SetRange(LOCATION_MZONE)
  e:SetTarget(target)
  e:SetOperation(operation)
  return e
end